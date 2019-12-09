Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A3F1179A1
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfLIWpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:45:44 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38262 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfLIWpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:45:44 -0500
Received: by mail-pf1-f196.google.com with SMTP id x185so7981630pfc.5;
        Mon, 09 Dec 2019 14:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G+YCwOYu4hMdi/F+7FErfeWtNww/IVPjI+lxDi7fRJk=;
        b=g69ha8UZoZw9wz7rFUo2t43IQg1/+ANKfe3JwO4uoXTpMuFn9O+K/K4HPRuRk92u9I
         jKQN56QH7MRUslEdvcoelQl7LetVSGjrW1scPM3j6dDJA3oc/IJd4WC/W08LOWgAcyJh
         HoVRFJKy1PP/CbCg0z4oQsYdlhSljVyUMAmLaj9bd48vZB3WV4/absqvk9L6gk/41dnb
         nEdjRQs/v8akCyKuw4e/hOYkTZ+q261cIfjF9qY6oaE8rWUDhWKiyrNgBbrWb+ckUKUj
         uXSX0Y4QDxXfbXLza41m0z965Lr200KbXL+ZZaufZRJFvjCOm6FUXcMu9RKwXHw85kYh
         RQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G+YCwOYu4hMdi/F+7FErfeWtNww/IVPjI+lxDi7fRJk=;
        b=HFGua2zCoQ+lJBokEdBoR2GT44NZoR+w+clZYvfvxrvgXxvoBwD1OqrOI18Np4FTgA
         ReAYm+rZahQz6LFSDyH0kDG+6A5JTrPdZ6gXlDRd7xuY4n0fA6b8h2oeFl4ClNixHIXN
         awW0H7H/xXRS/DdVoRH5g8ItQIAiQXLl0sKMYh8EjO4vyRCwAmpOWM11TitvULtBqN3N
         ru5Buyd+eZIUhbhlLCRNkDLYEBIj7Cfjd4HhyIPmsKH5QV9b75PWvWLQIDCy6Rb8ZdBz
         AHBcX6y+kp2Op5bABr1IEXmnwVY26KN7Zl3o54CzDYJEVgwc5Nf16Uk9Mc00gsdYG/7j
         pcTQ==
X-Gm-Message-State: APjAAAVjOf5CXvzCHepWehYnBwWljg9w1caFP2F7GwlqGJnuGE11LuY5
        yKpAURbsEa+zuj6sObv9l6Q=
X-Google-Smtp-Source: APXvYqz7kvdy+KdoA7rtaZJAxy8KR/mrzYuX1ZGHwEPSvXvm6R2+oHU0gSnkkkAFyOSXYNe7y8xnBw==
X-Received: by 2002:a63:b005:: with SMTP id h5mr20644949pgf.67.1575931543079;
        Mon, 09 Dec 2019 14:45:43 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id d6sm375186pju.8.2019.12.09.14.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 14:45:42 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
Date:   Mon,  9 Dec 2019 14:45:30 -0800
Message-Id: <20191209224530.156283-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

and associated inet_is_local_unbindable_port() helper function:
use it to make explicitly binding to an unbindable port return
-EPERM 'Operation not permitted'.

Autobind doesn't honour this new sysctl since:
  (a) you can simply set both if that's the behaviour you desire
  (b) there could be a use for preventing explicit while allowing auto
  (c) it's faster in the relatively critical path of doing port selection
      during connect() to only check one bitmap instead of both

Various ports may have special use cases which are not suitable for
use by general userspace applications. Currently, ports specified in
ip_local_reserved_ports sysctl will not be returned only in case of
automatic port assignment, but nothing prevents you from explicitly
binding to them - even from an entirely unprivileged process.

In certain cases it is desirable to prevent the host from assigning the
ports even in case of explicit binds, even from superuser processes.

Example use cases might be:
 - a port being stolen by the nic for remote serial console, remote
   power management or some other sort of debugging functionality
   (crash collection, gdb, direct access to some other microcontroller
   on the nic or motherboard, remote management of the nic itself).
 - a transparent proxy where packets are being redirected: in case
   a socket matches this connection, packets from this application
   would be incorrectly sent to one of the endpoints.

Initially I wanted to solve this problem via the simple one line:

static inline bool inet_port_requires_bind_service(struct net *net, unsigned short port) {
-       return port < net->ipv4.sysctl_ip_prot_sock;
+       return port < net->ipv4.sysctl_ip_prot_sock || inet_is_local_reserved_port(net, port);
}

However, this doesn't work for two reasons:
  (a) it changes userspace visible behaviour of the existing local
      reserved ports sysctl, and there appears to be enough documentation
      on the internet talking about setting it to make this a bad idea
  (b) it doesn't prevent privileged apps from using these ports,
      CAP_BIND_SERVICE is relatively likely to be available to, for example,
      a recursive DNS server so it can listed on port 53, which also needs
      to do src port randomization for outgoing queries due to security
      reasons (and it thus does manual port binding).

If we *know* that certain ports are simply unusable, then it's better
nothing even gets the opportunity to try to use them.  This way we at
least get a quick failure, instead of some sort of timeout (or possibly
even corruption of the data stream of the non-kernel based use case).

Test:
  vm:~# cat /proc/sys/net/ipv4/ip_local_unbindable_ports

  vm:~# python -c 'import socket; s = socket.socket(socket.AF_INET6, socket.SOCK_STREAM, 0); s.bind(("::", 3967))'
  vm:~# python -c 'import socket; s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM, 0); s.bind(("::", 3967))'
  vm:~# echo 3967 > /proc/sys/net/ipv4/ip_local_unbindable_ports
  vm:~# cat /proc/sys/net/ipv4/ip_local_unbindable_ports
  3967
  vm:~# python -c 'import socket; s = socket.socket(socket.AF_INET6, socket.SOCK_STREAM, 0); s.bind(("::", 3967))'
  socket.error: (1, 'Operation not permitted')
  vm:~# python -c 'import socket; s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM, 0); s.bind(("::", 3967))'
  socket.error: (1, 'Operation not permitted')

Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Sean Tranchetti <stranche@codeaurora.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Linux SCTP <linux-sctp@vger.kernel.org>
Reviewed-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 Documentation/networking/ip-sysctl.txt | 13 +++++++++++++
 include/net/ip.h                       | 12 ++++++++++++
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/af_inet.c                     |  4 ++++
 net/ipv4/sysctl_net_ipv4.c             | 18 ++++++++++++++++--
 net/ipv6/af_inet6.c                    |  2 ++
 net/sctp/socket.c                      |  5 +++++
 7 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index fd26788e8c96..7129646a18bd 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -940,6 +940,19 @@ ip_local_reserved_ports - list of comma separated ranges
 
 	Default: Empty
 
+ip_local_unbindable_ports - list of comma separated ranges
+	Specify the ports which are not directly bind()able.
+
+	Usually you would use this to block the use of ports which
+	are invalid due to something outside of the control of the
+	kernel.  For example a port stolen by the nic for serial
+	console, remote power management or debugging.
+
+	There's a relatively high chance you will also want to list
+	these ports in 'ip_local_reserved_ports' to prevent autobinding.
+
+	Default: Empty
+
 ip_unprivileged_port_start - INTEGER
 	This is a per-namespace sysctl.  It defines the first
 	unprivileged port in the network namespace.  Privileged ports
diff --git a/include/net/ip.h b/include/net/ip.h
index 5b317c9f4470..045432e6d18e 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -346,6 +346,13 @@ static inline bool inet_is_local_reserved_port(struct net *net, unsigned short p
 	return test_bit(port, net->ipv4.sysctl_local_reserved_ports);
 }
 
+static inline bool inet_is_local_unbindable_port(struct net *net, unsigned short port)
+{
+	if (!net->ipv4.sysctl_local_unbindable_ports)
+		return false;
+	return test_bit(port, net->ipv4.sysctl_local_unbindable_ports);
+}
+
 static inline bool sysctl_dev_name_is_allowed(const char *name)
 {
 	return strcmp(name, "default") != 0  && strcmp(name, "all") != 0;
@@ -362,6 +369,11 @@ static inline bool inet_is_local_reserved_port(struct net *net, unsigned short p
 	return false;
 }
 
+static inline bool inet_is_local_unbindable_port(struct net *net, unsigned short port)
+{
+	return false;
+}
+
 static inline bool inet_port_requires_bind_service(struct net *net, unsigned short port)
 {
 	return port < PROT_SOCK;
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index c0c0791b1912..6a235651925d 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -197,6 +197,7 @@ struct netns_ipv4 {
 
 #ifdef CONFIG_SYSCTL
 	unsigned long *sysctl_local_reserved_ports;
+	unsigned long *sysctl_local_unbindable_ports;
 	int sysctl_ip_prot_sock;
 #endif
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 2fe295432c24..b26046431612 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -494,6 +494,10 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 		goto out;
 
 	snum = ntohs(addr->sin_port);
+	err = -EPERM;
+	if (snum && inet_is_local_unbindable_port(net, snum))
+		goto out;
+
 	err = -EACCES;
 	if (snum && inet_port_requires_bind_service(net, snum) &&
 	    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index fcb2cd167f64..fd363b57a653 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -745,6 +745,13 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_do_large_bitmap,
 	},
+	{
+		.procname	= "ip_local_unbindable_ports",
+		.data		= &init_net.ipv4.sysctl_local_unbindable_ports,
+		.maxlen		= 65536,
+		.mode		= 0644,
+		.proc_handler	= proc_do_large_bitmap,
+	},
 	{
 		.procname	= "ip_no_pmtu_disc",
 		.data		= &init_net.ipv4.sysctl_ip_no_pmtu_disc,
@@ -1353,11 +1360,17 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
 
 	net->ipv4.sysctl_local_reserved_ports = kzalloc(65536 / 8, GFP_KERNEL);
 	if (!net->ipv4.sysctl_local_reserved_ports)
-		goto err_ports;
+		goto err_reserved_ports;
+
+	net->ipv4.sysctl_local_unbindable_ports = kzalloc(65536 / 8, GFP_KERNEL);
+	if (!net->ipv4.sysctl_local_unbindable_ports)
+		goto err_unbindable_ports;
 
 	return 0;
 
-err_ports:
+err_unbindable_ports:
+	kfree(net->ipv4.sysctl_local_reserved_ports);
+err_reserved_ports:
 	unregister_net_sysctl_table(net->ipv4.ipv4_hdr);
 err_reg:
 	if (!net_eq(net, &init_net))
@@ -1370,6 +1383,7 @@ static __net_exit void ipv4_sysctl_exit_net(struct net *net)
 {
 	struct ctl_table *table;
 
+	kfree(net->ipv4.sysctl_local_unbindable_ports);
 	kfree(net->ipv4.sysctl_local_reserved_ports);
 	table = net->ipv4.ipv4_hdr->ctl_table_arg;
 	unregister_net_sysctl_table(net->ipv4.ipv4_hdr);
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index d727c3b41495..41f453906f2f 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -292,6 +292,8 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
 		return -EINVAL;
 
 	snum = ntohs(addr->sin6_port);
+	if (snum && inet_is_local_unbindable_port(net, snum))
+		return -EPERM;
 	if (snum && inet_port_requires_bind_service(net, snum) &&
 	    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
 		return -EACCES;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 0b485952a71c..d1c93542419d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -384,6 +384,9 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 		}
 	}
 
+	if (snum && inet_is_local_unbindable_port(net, snum))
+		return -EPERM;
+
 	if (snum && inet_port_requires_bind_service(net, snum) &&
 	    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
 		return -EACCES;
@@ -1061,6 +1064,8 @@ static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
 		if (sctp_autobind(sk))
 			return -EAGAIN;
 	} else {
+		if (inet_is_local_unbindable_port(net, ep->base.bind_addr.port))
+			return -EPERM;
 		if (inet_port_requires_bind_service(net, ep->base.bind_addr.port) &&
 		    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
 			return -EACCES;
-- 
2.24.0.393.g34dc348eaf-goog

