Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8386E3AFA32
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 02:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhFVAeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 20:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhFVAed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 20:34:33 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D7CC061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 17:32:17 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id d16so25600626lfn.3
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 17:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UYXcSfjCQMkntp4BHtgmpyQaO5twG6KM2+bU91hpi3Q=;
        b=CBSeX0K7hL1y7JbnSIpDpA8q0FtrDb8r9ogWnDEpN2UiHC4uGGO0WqVtj/cr1AeVKn
         M6zxWRjCnxS4pQfSa2RL3CQDoyDlUnAYIwP3HkKWPPDp+OvF7GaOseWmB5GsGm22pE/L
         CW/rzS+4G/60bEOy+C8Yc3LcbznMQhg0N9PhfAYJaWJQyhgKR0xGpUr6YsWx1+32ZFBs
         9pg3FZIVoyUYDisaJp5zifpBLJ0SejWfmFhLDQKrkRJanctXbmtAAZNcudk5WRdvoMNx
         KZQRhvzA9khovSi2XjMQhGegEhY7QtnyGfhGsNyrg3wLXGjyp6nNaqPbrMYtT7W1l5rm
         sfoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UYXcSfjCQMkntp4BHtgmpyQaO5twG6KM2+bU91hpi3Q=;
        b=cllhg0MwSsGRJB9ZCOjNl4u7NOy21esMy2JlwKGUL/k82yV1oUqRHggaUAlb3ZNR/c
         CVXGIVgVu2lCnD2Bs6viQpPGIW71ahNc99uEJtBNmfkDWRPoVtca/M19VBh0tY2QWWhW
         DwKxwtLjkB+zyNJ07yvFkvY/w0vmQiQAFnHQmN7Y6Cy3Rci+uvOqKRXEX/cTSYrIF43G
         XWVI2MH4UBnAkf6aA85nK+CXZ+KBBS9vROXRBN3RX8s61Q+EAVfYziTXQuAp4mw9uV+d
         /1yRoVRX1M5k3kcqDTgLN4LEeJg5CbUZ9FhfgtF1XzZE1JBYQwfCkNalbusbrXjVquYU
         bH0w==
X-Gm-Message-State: AOAM530zMkqAegmIP73u9VEygtfGighPIpLpxs7hpNBLrXtwiVxoSzty
        kkY3WUKESUB0KNqghmjJ3XgPtoQL36M=
X-Google-Smtp-Source: ABdhPJxpZbvqLZY8qOv1zsRGtS6E4d2BwgtPIs0eEVqNOAfgiAodKkISm4Nn9q76b7GUNk+K1CPhhA==
X-Received: by 2002:ac2:4ed3:: with SMTP id p19mr716455lfr.256.1624321935865;
        Mon, 21 Jun 2021 17:32:15 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id br36sm404767lfb.296.2021.06.21.17.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 17:32:15 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH iproute2-next 2/2] iplink: support for WWAN devices
Date:   Tue, 22 Jun 2021 03:32:10 +0300
Message-Id: <20210622003210.22765-3-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210622003210.22765-1-ryazanov.s.a@gmail.com>
References: <20210622003210.22765-1-ryazanov.s.a@gmail.com>
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

