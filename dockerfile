FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y xfce4 xfce4-goodies tightvncserver wget supervisor python3 python3-websockify novnc firefox-esr && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up VNC password
RUN mkdir -p /root/.vnc && \
    x11vnc -storepasswd 1234 /root/.vnc/passwd

# Set up XFCE session for VNC
RUN echo "#!/bin/sh\nstartxfce4 &" > /root/.vnc/xstartup && chmod +x /root/.vnc/xstartup

# Supervisor config for VNC and noVNC
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 6080

CMD ["/usr/bin/supervisord", "-n"]
