Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D9F2113C8
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgGATpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:45:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22930 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725771AbgGATpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 15:45:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593632710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=8xvLwtlg/JLBnAz1PSrWE30usiWt7II2n8AjduQDYuM=;
        b=YbtttwLC4v4PgRO18Izzs5W1I8iQvqxmHkAQ/C/0PlPIxmMFBqlKxolky3mZloJYKBNXpG
        n/urTtvWFud+ZhHG61uYG0Ei0ly1IUidFoHExCq2fmIaocaHSFnp/bL5IW131eNedkpmbc
        je8wPBPeKvjMDwRA6hiHYXM3Ojp7uMg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-2uz4Et-yMaKG2r3186wWVw-1; Wed, 01 Jul 2020 15:45:08 -0400
X-MC-Unique: 2uz4Et-yMaKG2r3186wWVw-1
Received: by mail-wr1-f72.google.com with SMTP id s16so9047374wrv.1
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 12:45:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=8xvLwtlg/JLBnAz1PSrWE30usiWt7II2n8AjduQDYuM=;
        b=LqgjcrFXqp/D9M6cJb0zp6ifkE/PNm6khWyUIZjvtP4QE0NX4ixq8zeTM2Cmxlq7kB
         ObZ1z7sco5PJr/FudTQWDbKUmBpU/lpBqp6DTas13xhn/tjzrN128DQUd3aIZnENoC3Z
         yjusVCGDJ6Gq29E/GWTN6aZh3LbBjmfnxW4JP/LjS9C/dgjUNk8IBXV8eCizTlSsuVPK
         tQBSrdKG/FqUJzE6wbsMzKM27IFguxRXD5vuRS/ngFP9FbKg4kFm6dvPIPycD+cAJ4dx
         Qmi07qoMA7eoP99BSX/z2xA6u+ryAClb839nOgBS3UtPl5xofe4ZVAILrw1/lBHLLcZw
         60eg==
X-Gm-Message-State: AOAM532oJ12ZNxOLzp8dPX2ekcfCjGckBE+e2ZCiAFh7FEuJjR48EcVE
        ayzIKy+mmxpRlMvIMduzOVs47UERMvfrirRG5R/F1Qf7OPxfz5Y4l0bjAzyyH9qKJ5rsXsQG30t
        xgf4zE3/vDGjj9v1V
X-Received: by 2002:adf:ec4e:: with SMTP id w14mr29629477wrn.280.1593632707073;
        Wed, 01 Jul 2020 12:45:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwn0l00kytA3mrfFtT7CtBLqEvP0N0QugvnFFSrb+WL/Eid0BmKcLvIhO+8HZctaGYYg8JVXw==
X-Received: by 2002:adf:ec4e:: with SMTP id w14mr29629454wrn.280.1593632706752;
        Wed, 01 Jul 2020 12:45:06 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id 92sm9038938wrr.96.2020.07.01.12.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 12:45:06 -0700 (PDT)
Date:   Wed, 1 Jul 2020 21:45:04 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Martin Varghese <martinvarghesenokia@gmail.com>
Subject: [PATCH iproute2] ip link: initial support for bareudp devices
Message-ID: <f3401f1acfce2f472abe6f89fe059a5fade148a3.1593630794.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bareudp devices provide a generic L3 encapsulation for tunnelling
different protocols like MPLS, IP, NSH, etc. inside a UDP tunnel.

This patch is based on original work from Martin Varghese:
https://lore.kernel.org/netdev/1570532361-15163-1-git-send-email-martinvarghesenokia@gmail.com/

Examples:

  - ip link add dev bareudp0 type bareudp dstport 6635 ethertype mpls_uc

This creates a bareudp tunnel device which tunnels L3 traffic with
ethertype 0x8847 (unicast MPLS traffic). The destination port of the
UDP header will be set to 6635. The device will listen on UDP port 6635
to receive traffic.

  - ip link add dev bareudp0 type bareudp dstport 6635 ethertype ipv4 multiproto

Same as the MPLS example, but for IPv4. The "multiproto" keyword allows
the device to also tunnel IPv6 traffic.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 ip/Makefile           |   2 +-
 ip/iplink.c           |   2 +-
 ip/iplink_bareudp.c   | 150 ++++++++++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in |  44 +++++++++++++
 4 files changed, 196 insertions(+), 2 deletions(-)
 create mode 100644 ip/iplink_bareudp.c

diff --git a/ip/Makefile b/ip/Makefile
index 8735b8e4..4cad619c 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -11,7 +11,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
-    ipnexthop.o ipmptcp.o
+    ipnexthop.o ipmptcp.o iplink_bareudp.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/iplink.c b/ip/iplink.c
index 47f73988..7d4b244d 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -124,7 +124,7 @@ void iplink_usage(void)
 			"	   bridge | bond | team | ipoib | ip6tnl | ipip | sit | vxlan |\n"
 			"	   gre | gretap | erspan | ip6gre | ip6gretap | ip6erspan |\n"
 			"	   vti | nlmon | team_slave | bond_slave | bridge_slave |\n"
-			"	   ipvlan | ipvtap | geneve | vrf | macsec | netdevsim | rmnet |\n"
+			"	   ipvlan | ipvtap | geneve | bareudp | vrf | macsec | netdevsim | rmnet |\n"
 			"	   xfrm }\n");
 	}
 	exit(-1);
diff --git a/ip/iplink_bareudp.c b/ip/iplink_bareudp.c
new file mode 100644
index 00000000..885e1110
--- /dev/null
+++ b/ip/iplink_bareudp.c
@@ -0,0 +1,150 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <stdio.h>
+
+#include "libnetlink.h"
+#include "linux/if_ether.h"
+#include "linux/if_link.h"
+#include "linux/netlink.h"
+#include "linux/rtnetlink.h"
+#include "rt_names.h"
+#include "utils.h"
+#include "ip_common.h"
+#include "json_print.h"
+
+#define BAREUDP_ATTRSET(attrs, type) (((attrs) & (1L << (type))) != 0)
+
+static void print_explain(FILE *f)
+{
+	fprintf(f,
+		"Usage: ... bareudp dstport PORT\n"
+		"		ethertype PROTO\n"
+		"		[ srcportmin PORT ]\n"
+		"		[ [no]multiproto ]\n"
+		"\n"
+		"Where:	PORT       := 0-65535\n"
+		"	PROTO      := NUMBER | ip | mpls\n"
+		"	SRCPORTMIN := 0-65535\n"
+	);
+}
+
+static void explain(void)
+{
+	print_explain(stderr);
+}
+
+static void check_duparg(__u64 *attrs, int type, const char *key,
+			 const char *argv)
+{
+	if (!BAREUDP_ATTRSET(*attrs, type)) {
+		*attrs |= (1L << type);
+		return;
+	}
+	duparg2(key, argv);
+}
+
+static int bareudp_parse_opt(struct link_util *lu, int argc, char **argv,
+			     struct nlmsghdr *n)
+{
+	bool multiproto = false;
+	__u16 srcportmin = 0;
+	__be16 ethertype = 0;
+	__be16 dstport = 0;
+	__u64 attrs = 0;
+
+	while (argc > 0) {
+		if (matches(*argv, "dstport") == 0) {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_BAREUDP_PORT, "dstport",
+				     *argv);
+			if (get_be16(&dstport, *argv, 0))
+				invarg("dstport", *argv);
+		} else if (matches(*argv, "ethertype") == 0)  {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_BAREUDP_ETHERTYPE,
+				     "ethertype", *argv);
+			if (ll_proto_a2n(&ethertype, *argv))
+				invarg("ethertype", *argv);
+		} else if (matches(*argv, "srcportmin") == 0) {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_BAREUDP_SRCPORT_MIN,
+				     "srcportmin", *argv);
+			if (get_u16(&srcportmin, *argv, 0))
+				invarg("srcportmin", *argv);
+		} else if (matches(*argv, "multiproto") == 0) {
+			check_duparg(&attrs, IFLA_BAREUDP_MULTIPROTO_MODE,
+				     *argv, *argv);
+			multiproto = true;
+		} else if (matches(*argv, "nomultiproto") == 0) {
+			check_duparg(&attrs, IFLA_BAREUDP_MULTIPROTO_MODE,
+				     *argv, *argv);
+			multiproto = false;
+		} else if (matches(*argv, "help") == 0) {
+			explain();
+			return -1;
+		} else {
+			fprintf(stderr, "bareudp: unknown command \"%s\"?\n",
+				*argv);
+			explain();
+			return -1;
+		}
+		argc--, argv++;
+	}
+
+	if (!BAREUDP_ATTRSET(attrs, IFLA_BAREUDP_PORT))
+		missarg("dstport");
+	if (!BAREUDP_ATTRSET(attrs, IFLA_BAREUDP_ETHERTYPE))
+		missarg("ethertype");
+
+	addattr16(n, 1024, IFLA_BAREUDP_PORT, dstport);
+	addattr16(n, 1024, IFLA_BAREUDP_ETHERTYPE, ethertype);
+	if (BAREUDP_ATTRSET(attrs, IFLA_BAREUDP_SRCPORT_MIN))
+		addattr16(n, 1024, IFLA_BAREUDP_SRCPORT_MIN, srcportmin);
+	if (multiproto)
+		addattr(n, 1024, IFLA_BAREUDP_MULTIPROTO_MODE);
+
+	return 0;
+}
+
+static void bareudp_print_opt(struct link_util *lu, FILE *f,
+			      struct rtattr *tb[])
+{
+	if (!tb)
+		return;
+
+	if (tb[IFLA_BAREUDP_PORT])
+		print_uint(PRINT_ANY, "dstport", "dstport %u ",
+			   rta_getattr_be16(tb[IFLA_BAREUDP_PORT]));
+
+	if (tb[IFLA_BAREUDP_ETHERTYPE]) {
+		struct rtattr *attr = tb[IFLA_BAREUDP_ETHERTYPE];
+		SPRINT_BUF(ethertype);
+
+		print_string(PRINT_ANY, "ethertype", "ethertype %s ",
+			     ll_proto_n2a(rta_getattr_u16(attr),
+					  ethertype, sizeof(ethertype)));
+	}
+
+	if (tb[IFLA_BAREUDP_SRCPORT_MIN])
+		print_uint(PRINT_ANY, "srcportmin", "srcportmin %u ",
+			   rta_getattr_u16(tb[IFLA_BAREUDP_SRCPORT_MIN]));
+
+	if (tb[IFLA_BAREUDP_MULTIPROTO_MODE])
+		print_bool(PRINT_ANY, "multiproto", "multiproto ", true);
+	else
+		print_bool(PRINT_ANY, "multiproto", "nomultiproto ", false);
+}
+
+static void bareudp_print_help(struct link_util *lu, int argc, char **argv,
+			       FILE *f)
+{
+	print_explain(f);
+}
+
+struct link_util bareudp_link_util = {
+	.id		= "bareudp",
+	.maxattr	= IFLA_BAREUDP_MAX,
+	.parse_opt	= bareudp_parse_opt,
+	.print_opt	= bareudp_print_opt,
+	.print_help	= bareudp_print_help,
+};
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index e8a25451..c6bd2c53 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -223,6 +223,7 @@ ip-link \- network device configuration
 .BR ipvtap " |"
 .BR lowpan " |"
 .BR geneve " |"
+.BR bareudp " |"
 .BR vrf " |"
 .BR macsec " |"
 .BR netdevsim " |"
@@ -356,6 +357,9 @@ Link types:
 .BR geneve
 - GEneric NEtwork Virtualization Encapsulation
 .sp
+.BR bareudp
+- Bare UDP L3 encapsulation support
+.sp
 .BR macsec
 - Interface for IEEE 802.1AE MAC Security (MACsec)
 .sp
@@ -1293,6 +1297,46 @@ options.
 
 .in -8
 
+.TP
+Bareudp Type Support
+For a link of type
+.I Bareudp
+the following additional arguments are supported:
+
+.BI "ip link add " DEVICE
+.BI type " bareudp " dstport " PORT " ethertype " ETHERTYPE"
+[
+.BI srcportmin " SRCPORTMIN "
+] [
+.RB [ no ] multiproto
+]
+
+.in +8
+.sp
+.BI dstport " PORT"
+- specifies the destination port for the UDP tunnel.
+
+.sp
+.BI ethertype " ETHERTYPE"
+- specifies the ethertype of the L3 protocol being tunnelled.
+
+.sp
+.BI srcportmin " SRCPORTMIN"
+- selects the lowest value of the UDP tunnel source port range.
+
+.sp
+.RB [ no ] multiproto
+- activates support for protocols similar to the one
+.RB "specified by " ethertype .
+When
+.I ETHERTYPE
+is "mpls_uc" (that is, unicast MPLS), this allows the tunnel to also handle
+multicast MPLS.
+When
+.I ETHERTYPE
+is "ipv4", this allows the tunnel to also handle IPv6. This option is disabled
+by default.
+
 .TP
 MACVLAN and MACVTAP Type Support
 For a link of type
-- 
2.21.3

