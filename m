Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E2B440969
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 16:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhJ3OLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhJ3OLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 10:11:42 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A267C061570
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 07:09:12 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q187so12751143pgq.2
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 07:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=tAfCyiK1YbF14uJH2Z5edlPGZhRV6Z11Yc6Km7BBUHo=;
        b=ncDKRLnGgUAq7ED7TeOXhiZtS2I8Bm2aROcD/1ct7GvYIQE5lOK+RcPTJxvVajhltW
         KL8O/tzj62Cu4TB7ha/UXI9QIqo2aSaZFpMV17DyRh55YeKROelYludCwRdGBygd6vfG
         UrSJZcPnT43vrx/hQVR5Udwgae3I7+rPs0SCzajmZ+VYE7Md5eCTXB9tgx4IhNxEyhV3
         13xPHgS9GHgysZAjL/GYMkjjyY+wrpnh5ZdtHjo4Od5ThHP/8UgRUARs/JHEK5IAC5rS
         b0NqZutHZa7o23LnBeVsom5YR3JLyMrn9NmPvCvqT2DQzUI4EXohcSmaqMwNhUQFAxjS
         f3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tAfCyiK1YbF14uJH2Z5edlPGZhRV6Z11Yc6Km7BBUHo=;
        b=Qo/vM4COPvcOAgJpV9fMzq9IQrgQ9oPt4TldcAY7YbgdlwCsQUwcVOGkgjbLvzP+h7
         fL+88VCk9FGlC6ajFHuzjKzEFHPR71WhKqFV7bxnPvhaduJVfyupaiwItHLRyJi1cZBd
         egLC8jFHzmxkA0zgYR3Q8LfTJu/EiHGqKw0VAaId3acZ4fL97ilB4HsEhonPF9iR/FCq
         En2gBNkO25FktNC3cm7FWhk0kbKQ6Zc7NvyJC7YzYfivYxMQ5yqqMxfEkY9/y67kirdt
         fSOARAcR7WxTCxhcIqGVznPkfIVplvtgwYxp+g0yTTj+oqNOqS3L2LIwymb+3Z037B9o
         jEfQ==
X-Gm-Message-State: AOAM532Cy+YnBCs46dc73qdaSaN59GUIsWyjCVXjSa+gcnKNi8qZzjpO
        YszIXEjDcpYbN0bcLCr+Zro=
X-Google-Smtp-Source: ABdhPJxLwGoC0MjP2LCNA8xyWn/l8A9aPkfjgDH0/GXIfFfvFNoz9NldqlO6v7k1P3B0qtn3yA9a5w==
X-Received: by 2002:a05:6a00:801:b0:47d:9dc8:5751 with SMTP id m1-20020a056a00080100b0047d9dc85751mr17438405pfk.32.1635602951523;
        Sat, 30 Oct 2021 07:09:11 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id nn2sm14159742pjb.34.2021.10.30.07.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 07:09:10 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     stephen@networkplumber.org, dsahern@gmail.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH iproute-next v3] ip: add AMT support
Date:   Sat, 30 Oct 2021 14:08:58 +0000
Message-Id: <20211030140858.16788-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic support for Automatic Multicast Tunneling (AMT) network devices.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - Remove unnecessary check
 - Use strcmp() instead of matches().
v2 -> v3:
 - Remove unnecessary check

 ip/Makefile           |   3 +-
 ip/ip.c               |   4 +-
 ip/iplink.c           |   2 +-
 ip/iplink_amt.c       | 200 ++++++++++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in |  46 ++++++++++
 5 files changed, 251 insertions(+), 4 deletions(-)
 create mode 100644 ip/iplink_amt.c

diff --git a/ip/Makefile b/ip/Makefile
index bcc5f816..2a7a51c3 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -11,7 +11,8 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
-    ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o ipioam6.o
+    ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o ipioam6.o \
+    iplink_amt.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/ip.c b/ip/ip.c
index b07a5c7d..c784f819 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -64,8 +64,8 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: ip [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"       ip [ -force ] -batch filename\n"
-		"where  OBJECT := { address | addrlabel | fou | help | ila | ioam | l2tp | link |\n"
-		"                   macsec | maddress | monitor | mptcp | mroute | mrule |\n"
+		"where  OBJECT := { address | addrlabel | amt | fou | help | ila | ioam | l2tp |\n"
+		"                   link | macsec | maddress | monitor | mptcp | mroute | mrule |\n"
 		"                   neighbor | neighbour | netconf | netns | nexthop | ntable |\n"
 		"                   ntbl | route | rule | sr | tap | tcpmetrics |\n"
 		"                   token | tunnel | tuntap | vrf | xfrm }\n"
diff --git a/ip/iplink.c b/ip/iplink.c
index 4e74512e..a3ea775d 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -50,7 +50,7 @@ void iplink_types_usage(void)
 {
 	/* Remember to add new entry here if new type is added. */
 	fprintf(stderr,
-		"TYPE := { bareudp | bond | bond_slave | bridge | bridge_slave |\n"
+		"TYPE := { amt | bareudp | bond | bond_slave | bridge | bridge_slave |\n"
 		"          dummy | erspan | geneve | gre | gretap | ifb |\n"
 		"          ip6erspan | ip6gre | ip6gretap | ip6tnl |\n"
 		"          ipip | ipoib | ipvlan | ipvtap |\n"
diff --git a/ip/iplink_amt.c b/ip/iplink_amt.c
new file mode 100644
index 00000000..48e079f8
--- /dev/null
+++ b/ip/iplink_amt.c
@@ -0,0 +1,200 @@
+/*
+ * iplink_amt.c	AMT device support
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ * Authors:	Taehee Yoo <ap420073@gmail.com>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <net/if.h>
+#include <linux/ip.h>
+#include <linux/if_link.h>
+#include <arpa/inet.h>
+#include <linux/amt.h>
+
+#include "rt_names.h"
+#include "utils.h"
+#include "ip_common.h"
+
+#define AMT_ATTRSET(attrs, type) (((attrs) & (1L << (type))) != 0)
+
+static void print_usage(FILE *f)
+{
+	fprintf(f,
+		"Usage: ... amt\n"
+		"               [ discovery IP_ADDRESS ]\n"
+		"               [ mode MODE ]\n"
+		"               [ local ADDR ]\n"
+		"               [ dev PHYS_DEV ]\n"
+		"               [ relay_port PORT ]\n"
+		"               [ gateway_port PORT ]\n"
+		"               [ max_tunnels NUMBER ]\n"
+		"\n"
+		"Where: ADDR	:= { IP_ADDRESS }\n"
+		"       MODE	:= { gateway | relay }\n"
+		);
+}
+
+static char *modename[] = {"gateway", "relay"};
+
+static void usage(void)
+{
+	print_usage(stderr);
+}
+
+static void check_duparg(__u64 *attrs, int type, const char *key,
+		const char *argv)
+{
+	if (!AMT_ATTRSET(*attrs, type)) {
+		*attrs |= (1L << type);
+		return;
+	}
+	duparg2(key, argv);
+}
+
+static int amt_parse_opt(struct link_util *lu, int argc, char **argv,
+			 struct nlmsghdr *n)
+{
+	unsigned int mode, max_tunnels;
+	inet_prefix saddr, daddr;
+	__u64 attrs = 0;
+	__u16 port;
+
+	saddr.family = daddr.family = AF_UNSPEC;
+
+	inet_prefix_reset(&saddr);
+	inet_prefix_reset(&daddr);
+
+	while (argc > 0) {
+		if (strcmp(*argv, "mode") == 0) {
+			NEXT_ARG();
+			if (strcmp(*argv, "gateway") == 0) {
+				mode = 0;
+			} else if (strcmp(*argv, "relay") == 0) {
+				mode = 1;
+			} else {
+				usage();
+				return -1;
+			}
+			addattr32(n, 1024, IFLA_AMT_MODE, mode);
+		} else if (strcmp(*argv, "relay_port") == 0) {
+			NEXT_ARG();
+			if (get_u16(&port, *argv, 0))
+				invarg("relay_port", *argv);
+			addattr16(n, 1024, IFLA_AMT_RELAY_PORT, htons(port));
+		} else if (strcmp(*argv, "gateway_port") == 0) {
+			NEXT_ARG();
+			if (get_u16(&port, *argv, 0))
+				invarg("gateway_port", *argv);
+			addattr16(n, 1024, IFLA_AMT_GATEWAY_PORT, htons(port));
+		} else if (strcmp(*argv, "max_tunnels") == 0) {
+			NEXT_ARG();
+			if (get_u32(&max_tunnels, *argv, 0))
+				invarg("max_tunnels", *argv);
+			addattr32(n, 1024, IFLA_AMT_MAX_TUNNELS, max_tunnels);
+		} else if (strcmp(*argv, "dev") == 0) {
+			unsigned int link;
+
+			NEXT_ARG();
+			link = ll_name_to_index(*argv);
+			if (!link)
+				exit(nodev(*argv));
+			addattr32(n, 1024, IFLA_AMT_LINK, link);
+		} else if (strcmp(*argv, "local") == 0) {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_AMT_LOCAL_IP, "local", *argv);
+			get_addr(&saddr, *argv, daddr.family);
+
+			if (is_addrtype_inet(&saddr))
+				addattr_l(n, 1024, IFLA_AMT_LOCAL_IP,
+					  saddr.data, saddr.bytelen);
+		} else if (strcmp(*argv, "discovery") == 0) {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_AMT_DISCOVERY_IP,
+				     "discovery", *argv);
+			get_addr(&daddr, *argv, daddr.family);
+			if (is_addrtype_inet(&daddr))
+				addattr_l(n, 1024, IFLA_AMT_DISCOVERY_IP,
+					  daddr.data, daddr.bytelen);
+		} else if (strcmp(*argv, "help") == 0) {
+			usage();
+			return -1;
+		} else {
+			fprintf(stderr, "amt: unknown command \"%s\"?\n", *argv);
+			usage();
+			return -1;
+		}
+		argc--, argv++;
+	}
+
+	return 0;
+}
+
+static void amt_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
+{
+	if (!tb)
+		return;
+
+	if (tb[IFLA_AMT_MODE])
+		print_string(PRINT_ANY, "mode", "%s ",
+			     modename[rta_getattr_u32(tb[IFLA_AMT_MODE])]);
+
+	if (tb[IFLA_AMT_GATEWAY_PORT])
+		print_uint(PRINT_ANY, "gateway_port", "gateway_port %u ",
+			   rta_getattr_be16(tb[IFLA_AMT_GATEWAY_PORT]));
+
+	if (tb[IFLA_AMT_RELAY_PORT])
+		print_uint(PRINT_ANY, "relay_port", "relay_port %u ",
+			   rta_getattr_be16(tb[IFLA_AMT_RELAY_PORT]));
+
+	if (tb[IFLA_AMT_LOCAL_IP]) {
+		__be32 addr = rta_getattr_u32(tb[IFLA_AMT_LOCAL_IP]);
+
+		print_string(PRINT_ANY, "local", "local %s ",
+			     format_host(AF_INET, 4, &addr));
+	}
+
+	if (tb[IFLA_AMT_REMOTE_IP]) {
+		__be32 addr = rta_getattr_u32(tb[IFLA_AMT_REMOTE_IP]);
+
+		print_string(PRINT_ANY, "remote", "remote %s ",
+			     format_host(AF_INET, 4, &addr));
+	}
+
+	if (tb[IFLA_AMT_DISCOVERY_IP]) {
+		__be32 addr = rta_getattr_u32(tb[IFLA_AMT_DISCOVERY_IP]);
+
+		print_string(PRINT_ANY, "discovery", "discovery %s ",
+			     format_host(AF_INET, 4, &addr));
+	}
+
+	if (tb[IFLA_AMT_LINK]) {
+		unsigned int link = rta_getattr_u32(tb[IFLA_AMT_LINK]);
+
+		print_string(PRINT_ANY, "link", "dev %s ",
+			     ll_index_to_name(link));
+	}
+
+	if (tb[IFLA_AMT_MAX_TUNNELS])
+		print_uint(PRINT_ANY, "max_tunnels", "max_tunnels %u ",
+			   rta_getattr_u32(tb[IFLA_AMT_MAX_TUNNELS]));
+}
+
+static void amt_print_help(struct link_util *lu, int argc, char **argv, FILE *f)
+{
+	print_usage(f);
+}
+
+struct link_util amt_link_util = {
+	.id		= "amt",
+	.maxattr	= IFLA_AMT_MAX,
+	.parse_opt	= amt_parse_opt,
+	.print_opt	= amt_print_opt,
+	.print_help	= amt_print_help,
+};
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index c0cbb5e8..1d67c9a4 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -198,6 +198,7 @@ ip-link \- network device configuration
 
 .ti -8
 .IR TYPE " := [ "
+.BR amt " | "
 .BR bridge " | "
 .BR bond " | "
 .BR can " | "
@@ -364,6 +365,9 @@ Link types:
 .BR bareudp
 - Bare UDP L3 encapsulation support
 .sp
+.BR amt
+- Automatic Multicast Tunneling (AMT)
+.sp
 .BR macsec
 - Interface for IEEE 802.1AE MAC Security (MACsec)
 .sp
@@ -1344,6 +1348,48 @@ When
 is "ipv4", this allows the tunnel to also handle IPv6. This option is disabled
 by default.
 
+.TP
+AMT Type Support
+For a link of type
+.I AMT
+the following additional arguments are supported:
+
+.BI "ip link add " DEVICE
+.BI type " AMT " discovery " IPADDR " mode " { " gateway " | " relay " } "
+.BI local " IPADDR " dev " PHYS_DEV " [
+.BI relay_port " PORT " ]
+[
+.BI gateway_port " PORT " ]
+[
+.BI max_tunnels " NUMBER "
+]
+
+.in +8
+.sp
+.BI discovery " IPADDR"
+- specifies the unicast discovery IP address to use to find remote IP address.
+
+.BR mode " { " gateway " | " relay " } "
+- specifies the role of AMT, Gateway or Relay
+
+.BI local " IPADDR "
+- specifies the source IP address to use in outgoing packets.
+
+.BI dev " PHYS_DEV "
+- specifies the underlying physical interface from which transform traffic
+is sent and received.
+
+.BI relay_port " PORT "
+- specifies the UDP Relay port to communicate to the Relay.
+
+.BI gateway_port " PORT "
+- specifies the UDP Gateway port to communicate to the Gateway.
+
+.BI max_tunnels " NUMBER "
+- specifies the maximum number of tunnels.
+
+.in -8
+
 .TP
 MACVLAN and MACVTAP Type Support
 For a link of type
-- 
2.17.1

