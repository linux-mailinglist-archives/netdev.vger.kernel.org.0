Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646933B10CE
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhFVXzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhFVXzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 19:55:46 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4217C06175F
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 16:53:29 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id f13so499526ljp.10
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 16:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XBTO/dsCoJ1/6e49JjZCIH26W7rNv+akPoD+ak28KpI=;
        b=fGOmkWMa3XDX0o7ASFv3QwRyU/WZruw5g6oZAaTz5XKzlEcaN0bRnL+QtZ7MskzGu7
         zlR17Fr+DqexxcHPoF3ZVoyOoKRbcBmnAfQ8fZmQTzgn0OU+6bxU1zzOURulFhSOZh6H
         wYZgeUiXcNoyh/AZuZbwTF0l4w6qV0rdwnCmZ8hRGgkL6uzWFMqecVweIJXJTr6KoqBv
         Htkmz1AX9xVO4NGq6bG/wPH2LYg1/mmbYRHo701HtcQdjbE6Os2iQUc7vSPQrFq3wZ3x
         Y09dFcpEYpKeRjvtw3lhGqm4XlpnbA0PX/zxzR/h5QJRv5nmTdXnMZBptBgdSfdVeUUt
         1jdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XBTO/dsCoJ1/6e49JjZCIH26W7rNv+akPoD+ak28KpI=;
        b=Eky2bMC/IXyKVsdVt0Uj/m6XH2AEXv8pVY7aKBy4/R3qEAW70MJYG98+2i945oHLSU
         hUR/m9vQMMG278lcokA87nMt2ZXqQ2Uy5d2j3o+roSqATzeziGBWY8gyC9L0e3TAILXZ
         BrUjv+vHw78ZFT/TlMI9vTSzmOJkDmEYKQAQR1pcckLG8rAhbQpRCKHmyCpIVS7mCjps
         rPnRVTHxr1SUP+zsTi/TDWIfdbaKALHYco8Vm7gfOHekFGeaLz4af4bcvMxZ46TmxpK4
         H48RhgwfG68b1qFsmyoYJqvjOpapCoG/37PLv43BebTLz//OwDirdyha5AHFRkpgGElJ
         Aukg==
X-Gm-Message-State: AOAM533/Iso4t4+kMaslY7wOWDGKXQR4Ox2npgbqrzHSh8KJL2KzWveF
        vXlAyqlNa6u6ZRj6ew5tDdRvqbBPDp8=
X-Google-Smtp-Source: ABdhPJwUO2KRubbRGOAOzqtzn10VQB+c8eAWTH6k3QINHGvutV5w7ilB2+sD+ZnMmSEbzq5vucRkmA==
X-Received: by 2002:a2e:a4b2:: with SMTP id g18mr5342691ljm.113.1624406008161;
        Tue, 22 Jun 2021 16:53:28 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id y23sm1680092lfg.173.2021.06.22.16.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 16:53:27 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH iproute2-next v2 2/2] iplink: support for WWAN devices
Date:   Wed, 23 Jun 2021 02:52:56 +0300
Message-Id: <20210622235256.25499-3-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210622235256.25499-1-ryazanov.s.a@gmail.com>
References: <20210622235256.25499-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WWAN subsystem has been extended to generalize the per data channel
network interfaces management. This change implements support for WWAN
links handling. And actively uses the earlier introduced ip-link
capability to specify the parent by its device name.

The WWAN interface for a new data channel should be created with a
command like this:

ip link add dev wwan0-2 parentdev wwan0 type wwan linkid 2

Where: wwan0 is the modem HW device name (should be taken from
/sys/class/wwan) and linkid is an identifier of the opened data
channel.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
To compile this, a new uapi/linux/wwan.h header file should be copied
from the kernel sources.

Changes since v1:
* no changes

Changes since RFC:
* no changes

 ip/Makefile      |  2 +-
 ip/iplink.c      |  3 +-
 ip/iplink_wwan.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 2 deletions(-)
 create mode 100644 ip/iplink_wwan.c

diff --git a/ip/Makefile b/ip/Makefile
index 4cad619c..b03af29b 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -11,7 +11,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
-    ipnexthop.o ipmptcp.o iplink_bareudp.o
+    ipnexthop.o ipmptcp.o iplink_bareudp.o iplink_wwan.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/iplink.c b/ip/iplink.c
index 33b7be30..18b2ea25 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -56,7 +56,8 @@ void iplink_types_usage(void)
 		"          ipip | ipoib | ipvlan | ipvtap |\n"
 		"          macsec | macvlan | macvtap |\n"
 		"          netdevsim | nlmon | rmnet | sit | team | team_slave |\n"
-		"          vcan | veth | vlan | vrf | vti | vxcan | vxlan | xfrm }\n");
+		"          vcan | veth | vlan | vrf | vti | vxcan | vxlan | wwan |\n"
+		"          xfrm }\n");
 }
 
 void iplink_usage(void)
diff --git a/ip/iplink_wwan.c b/ip/iplink_wwan.c
new file mode 100644
index 00000000..3510477a
--- /dev/null
+++ b/ip/iplink_wwan.c
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <stdio.h>
+#include <linux/netlink.h>
+#include <linux/wwan.h>
+
+#include "utils.h"
+#include "ip_common.h"
+
+static void print_explain(FILE *f)
+{
+	fprintf(f,
+		"Usage: ... wwan linkid LINKID\n"
+		"\n"
+		"Where: LINKID := 0-4294967295\n"
+	);
+}
+
+static void explain(void)
+{
+	print_explain(stderr);
+}
+
+static int wwan_parse_opt(struct link_util *lu, int argc, char **argv,
+			  struct nlmsghdr *n)
+{
+	while (argc > 0) {
+		if (matches(*argv, "linkid") == 0) {
+			__u32 linkid;
+
+			NEXT_ARG();
+			if (get_u32(&linkid, *argv, 0))
+				invarg("linkid", *argv);
+			addattr32(n, 1024, IFLA_WWAN_LINK_ID, linkid);
+		} else if (matches(*argv, "help") == 0) {
+			explain();
+			return -1;
+		} else {
+			fprintf(stderr, "wwan: unknown command \"%s\"?\n",
+				*argv);
+			explain();
+			return -1;
+		}
+		argc--, argv++;
+	}
+
+	return 0;
+}
+
+static void wwan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
+{
+	if (!tb)
+		return;
+
+	if (tb[IFLA_WWAN_LINK_ID])
+		print_uint(PRINT_ANY, "linkid", "linkid %u ",
+			   rta_getattr_u32(tb[IFLA_WWAN_LINK_ID]));
+}
+
+static void wwan_print_help(struct link_util *lu, int argc, char **argv,
+			    FILE *f)
+{
+	print_explain(f);
+}
+
+struct link_util wwan_link_util = {
+	.id		= "wwan",
+	.maxattr	= IFLA_WWAN_MAX,
+	.parse_opt	= wwan_parse_opt,
+	.print_opt	= wwan_print_opt,
+	.print_help	= wwan_print_help,
+};
-- 
2.26.3

