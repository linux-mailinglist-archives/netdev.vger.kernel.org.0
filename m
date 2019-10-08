Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71434CF7AB
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbfJHK7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:59:41 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38924 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729790AbfJHK7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 06:59:41 -0400
Received: by mail-pf1-f196.google.com with SMTP id v4so10563516pff.6
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 03:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=AqkueV0Lt9qDdfB1BJCxIGxiB546B16SW6VYPa83koI=;
        b=qbwhTQOrk0eFJdbQELs1gTqu+ZbLWGJ87Ev/0v9a+CnUTY/Opegf3+kTRUcFrcc1Vy
         H35t370LFU8bFEPnXPeoSQNJkS5gNN8A4CTHdSy43knzjKv4tWK0q48ZqrL3Tdk5KL/v
         EBgMxY9QIn/ObU39+XwLPuNf4u4QSTGQw0ZJ9ZJY+sXuXDvxHm34jDo9eiwFvuQiXHyQ
         OUF+w1mUfotm8yz8R29D07AQ6qx8581BLpvcaZrRjBVmf1c7AygTTH8AG9sE8RROmDXm
         M9I6jgsaFWPNVSpRvv+0ia6SbeszE5B6eHzhXtXHhXpJTUh8WThj56DKGqZLY8n7NoU2
         JZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=AqkueV0Lt9qDdfB1BJCxIGxiB546B16SW6VYPa83koI=;
        b=ObvT2zrV5bFc182p78Icoex90/6QgV1/8EpUV6pe2mBY3GRw/CMLNF2XhZHe4Q/VEN
         os6U5xmzQPSmWKMUu6OYlVH8zbZCsQH3slHELp6766uUkwvybmPgr+rf9xvCVZz2G0ZX
         gU2sHIPezwtlTCwCTJs3w4DsSwyF+zHt8AOC1k4Wg4s3Lhfx77YfQeK9K2Eq0QHfdYvU
         WXQDIzfsWAuQUh1/0u43EQO3JEzyLC5osKI7MWTFsIH9YKquV9+YeqJVlu48InenZWZ+
         bsWcXDY4YSLkiDhRNffHvXouKn5mwQPkijKEUXaroAO8I4myR5GPWnVZhzmE8qvdr8lg
         X7Eg==
X-Gm-Message-State: APjAAAXWB1FeFztzy0VtkyKEKWWVlHAWFVR2gzNViMtZAueDREdQYcOY
        L4tXQ1pPQA+dh/s7/keDY7Q=
X-Google-Smtp-Source: APXvYqyljGKVKKBtWc76GHrECWVQ8cggk4/+RfxIk7Xxb7Io0Yn+DHi8azjjEigClrhLJRr1bblwkQ==
X-Received: by 2002:a63:38c:: with SMTP id 134mr14517489pgd.360.1570532380574;
        Tue, 08 Oct 2019 03:59:40 -0700 (PDT)
Received: from localhost.localdomain ([122.178.241.240])
        by smtp.gmail.com with ESMTPSA id h4sm16686066pgg.81.2019.10.08.03.59.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Oct 2019 03:59:40 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     stephen@networkplumber.org, netdev@vger.kernel.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH iproute2] Bareudp device support
Date:   Tue,  8 Oct 2019 16:29:21 +0530
Message-Id: <1570532361-15163-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin <martin.varghese@nokia.com>

The Bareudp device provides a generic L3 encapsulation for tunnelling
different protocols like MPLS,IP,NSH, etc. inside a UDP tunnel.

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 include/uapi/linux/if_link.h |  12 ++++
 ip/Makefile                  |   2 +-
 ip/iplink_bareudp.c          | 154 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 167 insertions(+), 1 deletion(-)
 create mode 100644 ip/iplink_bareudp.c

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index d36919f..a3a876d 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -578,6 +578,18 @@ enum ifla_geneve_df {
 	GENEVE_DF_MAX = __GENEVE_DF_END - 1,
 };
 
+/* Bareudp section  */
+enum {
+	IFLA_BAREUDP_UNSPEC,
+	IFLA_BAREUDP_PORT,
+	IFLA_BAREUDP_ETHERTYPE,
+	IFLA_BAREUDP_SRCPORT_MIN,
+	IFLA_BAREUDP_EXTMODE,
+	__IFLA_BAREUDP_MAX
+};
+
+#define IFLA_BAREUDP_MAX (__IFLA_BAREUDP_MAX - 1)
+
 /* PPP section */
 enum {
 	IFLA_PPP_UNSPEC,
diff --git a/ip/Makefile b/ip/Makefile
index 5ab78d7..784d852 100644
--- a/ip/Makefile
+++ b/ip/Makefile
@@ -11,7 +11,7 @@ IPOBJ=ip.o ipaddress.o ipaddrlabel.o iproute.o iprule.o ipnetns.o \
     iplink_bridge.o iplink_bridge_slave.o ipfou.o iplink_ipvlan.o \
     iplink_geneve.o iplink_vrf.o iproute_lwtunnel.o ipmacsec.o ipila.o \
     ipvrf.o iplink_xstats.o ipseg6.o iplink_netdevsim.o iplink_rmnet.o \
-    ipnexthop.o
+    ipnexthop.o iplink_bareudp.o
 
 RTMONOBJ=rtmon.o
 
diff --git a/ip/iplink_bareudp.c b/ip/iplink_bareudp.c
new file mode 100644
index 0000000..479ad1c
--- /dev/null
+++ b/ip/iplink_bareudp.c
@@ -0,0 +1,154 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <stdio.h>
+
+#include "rt_names.h"
+#include "utils.h"
+#include "ip_common.h"
+
+#define BAREUDP_ATTRSET(attrs, type) (((attrs) & (1L << (type))) != 0)
+
+static void print_explain(FILE *f)
+{
+	fprintf(f,
+			"Usage: ........ bareudp dstport PORT\n"
+			"                ethertype ETHERTYPE|PROTOCOL\n"
+			"                [ext_mode]\n"
+			"                [srcportmin SRCPORTMIN]\n"
+			"\n"
+			"Where: PORT   := 0-65535\n"
+			"     : ETHERTYPE|PROTOCOL := ip|mpls|0-65535\n"
+			"     : SRCPORTMIN : = 0-65535\n"
+	       );
+}
+
+static void explain(void)
+{
+	print_explain(stderr);
+}
+
+static void check_duparg(__u64 *attrs, int type, const char *key,
+		const char *argv)
+{
+	if (!BAREUDP_ATTRSET(*attrs, type)) {
+		*attrs |= (1L << type);
+		return;
+	}
+	duparg2(key, argv);
+}
+
+static int bareudp_parse_opt(struct link_util *lu, int argc, char **argv,
+		struct nlmsghdr *n)
+{
+	__u16 dstport = 0;
+	__u16 ethertype = 0;
+	__u16 srcportmin = 0;
+	bool extmode = 0;
+	__u64 attrs = 0;
+
+	while (argc > 0) {
+		if (!matches(*argv, "dstport")) {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_BAREUDP_PORT, "dstport",
+					*argv);
+			if (get_u16(&dstport, *argv, 0))
+				invarg("dstport", *argv);
+		} else if (!matches(*argv, "extmode")) {
+			check_duparg(&attrs, IFLA_BAREUDP_EXTMODE,
+					*argv, *argv);
+			extmode = true;
+		} else if (!matches(*argv, "ethertype"))  {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_BAREUDP_ETHERTYPE,
+					*argv, *argv);
+			if (!matches(*argv, "mpls")) {
+				ethertype = 0x8847;
+				check_duparg(&attrs, IFLA_BAREUDP_EXTMODE,
+						*argv, *argv);
+				extmode = true;
+			} else if (!matches(*argv, "ip")) {
+				ethertype = 0x0800;
+				check_duparg(&attrs, IFLA_BAREUDP_EXTMODE,
+						*argv, *argv);
+				extmode = true;
+			} else {
+				if (get_u16(&ethertype, *argv, 0))
+					invarg("ethertype", *argv);
+			}
+		} else if (!matches(*argv, "srcportmin")) {
+			NEXT_ARG();
+			check_duparg(&attrs, IFLA_BAREUDP_SRCPORT_MIN,
+					*argv, *argv);
+			if (get_u16(&srcportmin, *argv, 0))
+				invarg("srcportmin", *argv);
+
+		} else if (matches(*argv, "help") == 0) {
+			explain();
+			return -1;
+		} else {
+			fprintf(stderr, "bareudp: unknown command \"%s\"?\n", *argv);
+			explain();
+			return -1;
+		}
+	argc--, argv++;
+	}
+
+	if (!dstport || !ethertype)  {
+		fprintf(stderr, "bareudp : Missing mandatory params\n");
+		return -1;
+	}
+
+	if (dstport)
+		addattr16(n, 1024, IFLA_BAREUDP_PORT, htons(dstport));
+	if (ethertype)
+		addattr16(n, 1024, IFLA_BAREUDP_ETHERTYPE, htons(ethertype));
+	if (extmode)
+		addattr(n, 1024, IFLA_BAREUDP_EXTMODE);
+	if (srcportmin)
+		addattr16(n, 1024, IFLA_BAREUDP_PORT, srcportmin);
+
+	return 0;
+}
+
+static void bareudp_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
+{
+
+	if (!tb)
+		return;
+
+	if (tb[IFLA_BAREUDP_PORT])
+		print_uint(PRINT_ANY,
+				"port",
+				"dstport %u ",
+				rta_getattr_be16(tb[IFLA_BAREUDP_PORT]));
+
+	if (tb[IFLA_BAREUDP_ETHERTYPE])
+		print_uint(PRINT_ANY,
+				"port",
+				"dstport %u ",
+				rta_getattr_be16(tb[IFLA_BAREUDP_ETHERTYPE]));
+	if (tb[IFLA_BAREUDP_SRCPORT_MIN])
+		print_uint(PRINT_ANY,
+				"port",
+				"dstport %u ",
+				rta_getattr_u16(tb[IFLA_BAREUDP_SRCPORT_MIN]));
+
+	if (tb[IFLA_BAREUDP_EXTMODE]) {
+		print_bool(PRINT_ANY, "extmode", "extmode ", true);
+		return;
+	}
+}
+
+static void bareudp_print_help(struct link_util *lu, int argc, char **argv,
+		FILE *f)
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
-- 
1.8.3.1

