Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED59B1C34
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388154AbfIMLb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:26 -0400
Received: from correo.us.es ([193.147.175.20]:42594 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388065AbfIMLbY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D419D4FFE1E
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C59B4A7E22
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C473DA7E20; Fri, 13 Sep 2019 13:31:20 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 991FFA7EC6;
        Fri, 13 Sep 2019 13:31:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6D3EB4265A5A;
        Fri, 13 Sep 2019 13:31:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/27] netfilter: inline xt_hashlimit, ebt_802_3 and xt_physdev headers
Date:   Fri, 13 Sep 2019 13:30:48 +0200
Message-Id: <20190913113102.15776-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Three netfilter headers are only included once.  Inline their contents
at those sites and remove them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/xt_hashlimit.h     | 11 -----------
 include/linux/netfilter/xt_physdev.h       |  8 --------
 include/linux/netfilter_bridge/ebt_802_3.h | 12 ------------
 net/bridge/netfilter/ebt_802_3.c           |  8 +++++++-
 net/netfilter/xt_hashlimit.c               |  7 ++++++-
 net/netfilter/xt_physdev.c                 |  5 +++--
 6 files changed, 16 insertions(+), 35 deletions(-)
 delete mode 100644 include/linux/netfilter/xt_hashlimit.h
 delete mode 100644 include/linux/netfilter/xt_physdev.h
 delete mode 100644 include/linux/netfilter_bridge/ebt_802_3.h

diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfilter/xt_hashlimit.h
deleted file mode 100644
index 169d03983589..000000000000
--- a/include/linux/netfilter/xt_hashlimit.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _XT_HASHLIMIT_H
-#define _XT_HASHLIMIT_H
-
-#include <uapi/linux/netfilter/xt_hashlimit.h>
-
-#define XT_HASHLIMIT_ALL (XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT | \
-			  XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT | \
-			  XT_HASHLIMIT_INVERT | XT_HASHLIMIT_BYTES |\
-			  XT_HASHLIMIT_RATE_MATCH)
-#endif /*_XT_HASHLIMIT_H*/
diff --git a/include/linux/netfilter/xt_physdev.h b/include/linux/netfilter/xt_physdev.h
deleted file mode 100644
index 4ca0593949cd..000000000000
--- a/include/linux/netfilter/xt_physdev.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _XT_PHYSDEV_H
-#define _XT_PHYSDEV_H
-
-#include <linux/if.h>
-#include <uapi/linux/netfilter/xt_physdev.h>
-
-#endif /*_XT_PHYSDEV_H*/
diff --git a/include/linux/netfilter_bridge/ebt_802_3.h b/include/linux/netfilter_bridge/ebt_802_3.h
deleted file mode 100644
index c6147f9c0d80..000000000000
--- a/include/linux/netfilter_bridge/ebt_802_3.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __LINUX_BRIDGE_EBT_802_3_H
-#define __LINUX_BRIDGE_EBT_802_3_H
-
-#include <linux/skbuff.h>
-#include <uapi/linux/netfilter_bridge/ebt_802_3.h>
-
-static inline struct ebt_802_3_hdr *ebt_802_3_hdr(const struct sk_buff *skb)
-{
-	return (struct ebt_802_3_hdr *)skb_mac_header(skb);
-}
-#endif
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 2c8fe24400e5..68c2519bdc52 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -11,7 +11,13 @@
 #include <linux/module.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_802_3.h>
+#include <linux/skbuff.h>
+#include <uapi/linux/netfilter_bridge/ebt_802_3.h>
+
+static struct ebt_802_3_hdr *ebt_802_3_hdr(const struct sk_buff *skb)
+{
+	return (struct ebt_802_3_hdr *)skb_mac_header(skb);
+}
 
 static bool
 ebt_802_3_mt(const struct sk_buff *skb, struct xt_action_param *par)
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 2d2691dd51e0..ced3fc8fad7c 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -34,9 +34,14 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter/xt_hashlimit.h>
 #include <linux/mutex.h>
 #include <linux/kernel.h>
+#include <uapi/linux/netfilter/xt_hashlimit.h>
+
+#define XT_HASHLIMIT_ALL (XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT | \
+			  XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT | \
+			  XT_HASHLIMIT_INVERT | XT_HASHLIMIT_BYTES |\
+			  XT_HASHLIMIT_RATE_MATCH)
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index b92b22ce8abd..ec6ed6fda96c 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -5,12 +5,13 @@
 /* (C) 2001-2003 Bart De Schuymer <bdschuym@pandora.be>
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/if.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter_bridge.h>
-#include <linux/netfilter/xt_physdev.h>
 #include <linux/netfilter/x_tables.h>
-#include <net/netfilter/br_netfilter.h>
+#include <uapi/linux/netfilter/xt_physdev.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
-- 
2.11.0

