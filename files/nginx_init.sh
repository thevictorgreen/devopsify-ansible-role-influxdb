#!/bin/bash

# LOG OUTPUT TO A FILE
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/root/.influx_automate/log.out 2>&1

if [[ ! -f "/root/.influx_automate/init.cfg" ]]
then
  # COPY req.conf into /etc/nginx/req.conf
  cp /root/.influx_automate/req.conf /etc/nginx/req.conf
  # COPY default into /etc/nginx/sites-available/default
  cp /root/.influx_automate/default /etc/nginx/sites-available/default
  # GENERATE SELF SIGNED CERTIFICATES FOR NGINX REVERSE PROXY
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/nginx.key -out /etc/nginx/nginx.crt -config /etc/nginx/req.conf
  # GENERATE STRONG DIFFIEHELMAN PARAMS
  openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
  # RESTART nginx
  systemctl restart nginx
  # CHECK NGINX STATUS
  systemctl status nginx
  touch /root/.influx_automate/init.cfg
fi
