Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE0343ABAE
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 07:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhJZFan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 01:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbhJZFam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 01:30:42 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6481AC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 22:28:19 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id r28so8651513pga.0
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 22:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=4pazaoJEOSgBjw1OO+Jv/xXNdwetPywS7S69gBDBl1U=;
        b=EKCDC1fDrgQhxLmsdva7DLuoEfG4/9fjEO3hlml1j+HhVjgLhm5n9dwy7NYKZaHDJz
         xAqB1ZtgNmnC/Yy53BZTU1mufTwhZLVaAx/gfD9dDeDwsl6UpizXo0Kf19DcGqch0NU5
         +7uzysDz221dXbsBVX78FMuYtA+Z+ROavI08EGIE1a3VfVNE0ptPuBU45z+UEEWwytNv
         2bLMUaJtwinH77AI29b7MNQNmSwR9JoEto4rLFxY34v9ujndMS9xp0/OnN36VU3hyYqZ
         zQsJhzn+f9qCgQHhIpcolRxCsX/QXCelpK64mUMn/tcjcIXUsPwPQBzDRmtNeQR1Iffu
         uTFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4pazaoJEOSgBjw1OO+Jv/xXNdwetPywS7S69gBDBl1U=;
        b=k6w6aC/95+LQlcp7pDepivttkjKdbsKuKbq6RXpaD0JqKMj+URGiMBhUoJDREnVKt7
         DTVnszX7pdCXt2yhMDhiFoOpJ0KJ0kNhZp1zFYobeRZ1W5sbbXpMoDvtvxK2wXZWi+87
         0u6xmFWlujiq4u91fvycA5gE2jFqrGjjpYANJiTDutObtfTne5Xn/9KoKTx1XQOZGZQK
         Vx/VQ/a0Yczhkfjb9psxYzAn8tZc1Qtjf05iFc1jQ+oz3/7YZJR0kjtyz+el5nwdbZmQ
         2fkCIyHoqMV0uEyaVVwLQkH0xjKAb38FaCjPBboFoxXyjqBDrFsB7bgFrfIA+s3pXi7U
         K3fA==
X-Gm-Message-State: AOAM531xf1NlG0vdg1GqczdAHJFT1vo87YzYmkGXYFm21lJPP1PIgnHM
        ZpU9gE0vJLGnhFA9t1QGGT1p4cbzRVnC0Q==
X-Google-Smtp-Source: ABdhPJz3ZDS8Csz9svkLcgDGWNBXXlVl3qyEStEgspXC12bqtXYsZFna5xCz4DPAAQDyc7Oq7q1Brw==
X-Received: by 2002:a63:b50d:: with SMTP id y13mr17168446pge.286.1635226098762;
        Mon, 25 Oct 2021 22:28:18 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id m10sm16820402pfk.78.2021.10.25.22.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 22:28:18 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     stephen@networkplumber.org, dsahern@gmail.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH iproute2-next v2] ip: add AMT support
Date:   Tue, 26 Oct 2021 05:28:08 +0000
Message-Id: <20211026052808.1779-1-ap420073@gmail.com>
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

 ip/Makefile           |   3 +-
 ip/ip.c               |   4 +-
 ip/iplink.c           |   2 +-
 ip/iplink_amt.c       | 224 ++++++++++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in |  46 +++++++++
 5 files changed, 275 insertions(+), 4 deletions(-)
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
index 00000000..5761abac
--- /dev/null
+++ b/ip/iplink_amt.c
@@ -0,0 +1,224 @@
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
+	if (tb[IFLA_AMT_MODE]) {
+		print_string(PRINT_ANY,
+			     "mode",
+			     "%s ",
+			     modename[rta_getattr_u32(tb[IFLA_AMT_MODE])]);
+	}
+
+	if (tb[IFLA_AMT_GATEWAY_PORT]) {
+		print_uint(PRINT_ANY,
+			   "gateway_port",
+			   "gateway_port %u ",
+			   rta_getattr_be16(tb[IFLA_AMT_GATEWAY_PORT]));
+	}
+
+	if (tb[IFLA_AMT_RELAY_PORT]) {
+		print_uint(PRINT_ANY,
+			   "relay_port",
+			   "relay_port %u ",
+			   rta_getattr_be16(tb[IFLA_AMT_RELAY_PORT]));
+	}
+
+	if (tb[IFLA_AMT_LOCAL_IP]) {
+		__be32 addr = rta_getattr_u32(tb[IFLA_AMT_LOCAL_IP]);
+
+		if (addr)
+			print_string(PRINT_ANY,
+				     "local",
+				     "local %s ",
+				     format_host(AF_INET, 4, &addr));
+	}
+
+	if (tb[IFLA_AMT_REMOTE_IP]) {
+		__be32 addr = rta_getattr_u32(tb[IFLA_AMT_REMOTE_IP]);
+
+		if (addr)
+			print_string(PRINT_ANY,
+				     "remote",
+				     "remote %s ",
+				     format_host(AF_INET, 4, &addr));
+	}
+
+	if (tb[IFLA_AMT_DISCOVERY_IP]) {
+		__be32 addr = rta_getattr_u32(tb[IFLA_AMT_DISCOVERY_IP]);
+
+		if (addr) {
+			print_string(PRINT_ANY,
+				     "discovery",
+				     "discovery %s ",
+				     format_host(AF_INET, 4, &addr));
+		}
+	}
+
+	if (tb[IFLA_AMT_LINK]) {
+		unsigned int link = rta_getattr_u32(tb[IFLA_AMT_LINK]);
+
+		if (link)
+			print_string(PRINT_ANY, "link", "dev %s ",
+				     ll_index_to_name(link));
+	}
+
+	if (tb[IFLA_AMT_MAX_TUNNELS]) {
+		unsigned int tunnels = rta_getattr_u32(tb[IFLA_AMT_MAX_TUNNELS]);
+
+		if (tunnels)
+			print_uint(PRINT_ANY, "max_tunnels", "max_tunnels %u ",
+				   rta_getattr_u32(tb[IFLA_AMT_MAX_TUNNELS]));
+	}
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

