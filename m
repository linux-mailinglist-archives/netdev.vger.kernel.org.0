Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467CB22D8D5
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 19:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgGYRCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 13:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgGYRCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 13:02:39 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D2CC08C5C0;
        Sat, 25 Jul 2020 10:02:39 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 66BD26F636;
        Sat, 25 Jul 2020 17:02:32 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, paul@paul-moore.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH v2] netfilter: Replace HTTP links with HTTPS ones
Date:   Sat, 25 Jul 2020 19:02:25 +0200
Message-Id: <20200725170225.4505-1-grandmaster@al2klimov.de>
In-Reply-To: <20200724112856.GA26061@salvia>
References: <20200724112856.GA26061@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
X-Spamd-Bar: /
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 v2: Included other netfilter patch.

 include/uapi/linux/netfilter/xt_connmark.h | 2 +-
 net/decnet/netfilter/dn_rtmsg.c            | 2 +-
 net/netfilter/Kconfig                      | 2 +-
 net/netfilter/nfnetlink_acct.c             | 2 +-
 net/netfilter/nft_set_pipapo.c             | 4 ++--
 net/netfilter/xt_CONNSECMARK.c             | 2 +-
 net/netfilter/xt_connmark.c                | 2 +-
 net/netfilter/xt_nfacct.c                  | 2 +-
 net/netfilter/xt_time.c                    | 2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_connmark.h b/include/uapi/linux/netfilter/xt_connmark.h
index 1aa5c955ee1e..f01c19b83a2b 100644
--- a/include/uapi/linux/netfilter/xt_connmark.h
+++ b/include/uapi/linux/netfilter/xt_connmark.h
@@ -4,7 +4,7 @@
 
 #include <linux/types.h>
 
-/* Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
+/* Copyright (C) 2002,2004 MARA Systems AB <https://www.marasystems.com>
  * by Henrik Nordstrom <hno@marasystems.com>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/net/decnet/netfilter/dn_rtmsg.c b/net/decnet/netfilter/dn_rtmsg.c
index dc705769acc9..26a9193df783 100644
--- a/net/decnet/netfilter/dn_rtmsg.c
+++ b/net/decnet/netfilter/dn_rtmsg.c
@@ -6,7 +6,7 @@
  *
  *              DECnet Routing Message Grabulator
  *
- *              (C) 2000 ChyGwyn Limited  -  http://www.chygwyn.com/
+ *              (C) 2000 ChyGwyn Limited  -  https://www.chygwyn.com/
  *
  * Author:      Steven Whitehouse <steve@chygwyn.com>
  */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 0ffe2b8723c4..25313c29d799 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -447,7 +447,7 @@ config NF_TABLES
 	  replace the existing {ip,ip6,arp,eb}_tables infrastructure. It
 	  provides a pseudo-state machine with an extensible instruction-set
 	  (also known as expressions) that the userspace 'nft' utility
-	  (http://www.netfilter.org/projects/nftables) uses to build the
+	  (https://www.netfilter.org/projects/nftables) uses to build the
 	  rule-set. It also comes with the generic set infrastructure that
 	  allows you to construct mappings between matchings and actions
 	  for performance lookups.
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 5827117f2635..5bfec829c12f 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * (C) 2011 Pablo Neira Ayuso <pablo@netfilter.org>
- * (C) 2011 Intra2net AG <http://www.intra2net.com>
+ * (C) 2011 Intra2net AG <https://www.intra2net.com>
  */
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 8c04388296b0..78070aa65f62 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -312,7 +312,7 @@
  *      Jay Ligatti, Josh Kuhn, and Chris Gage.
  *      Proceedings of the IEEE International Conference on Computer
  *      Communication Networks (ICCCN), August 2010.
- *      http://www.cse.usf.edu/~ligatti/papers/grouper-conf.pdf
+ *      https://www.cse.usf.edu/~ligatti/papers/grouper-conf.pdf
  *
  * [Rottenstreich 2010]
  *      Worst-Case TCAM Rule Expansion
@@ -325,7 +325,7 @@
  *      Kirill Kogan, Sergey Nikolenko, Ori Rottenstreich, William Culhane,
  *      and Patrick Eugster.
  *      Proceedings of the 2014 ACM conference on SIGCOMM, August 2014.
- *      http://www.sigcomm.org/sites/default/files/ccr/papers/2014/August/2619239-2626294.pdf
+ *      https://www.sigcomm.org/sites/default/files/ccr/papers/2014/August/2619239-2626294.pdf
  */
 
 #include <linux/kernel.h>
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index a5c8b653476a..76acecf3e757 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -6,7 +6,7 @@
  * with the SECMARK target and state match.
  *
  * Based somewhat on CONNMARK:
- *   Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
+ *   Copyright (C) 2002,2004 MARA Systems AB <https://www.marasystems.com>
  *    by Henrik Nordstrom <hno@marasystems.com>
  *
  * (C) 2006,2008 Red Hat, Inc., James Morris <jmorris@redhat.com>
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index eec2f3a88d73..e5ebc0810675 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -2,7 +2,7 @@
 /*
  *	xt_connmark - Netfilter module to operate on connection marks
  *
- *	Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
+ *	Copyright (C) 2002,2004 MARA Systems AB <https://www.marasystems.com>
  *	by Henrik Nordstrom <hno@marasystems.com>
  *	Copyright © CC Computer Consultants GmbH, 2007 - 2008
  *	Jan Engelhardt <jengelh@medozas.de>
diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index 5aab6df74e0f..a97c2259bbc8 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * (C) 2011 Pablo Neira Ayuso <pablo@netfilter.org>
- * (C) 2011 Intra2net AG <http://www.intra2net.com>
+ * (C) 2011 Intra2net AG <https://www.intra2net.com>
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 67cb98489415..6aa12d0f54e2 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -5,7 +5,7 @@
  *	based on ipt_time by Fabrice MARIE <fabrice@netfilter.org>
  *	This is a module which is used for time matching
  *	It is using some modified code from dietlibc (localtime() function)
- *	that you can find at http://www.fefe.de/dietlibc/
+ *	that you can find at https://www.fefe.de/dietlibc/
  *	This file is distributed under the terms of the GNU General Public
  *	License (GPL). Copies of the GPL can be obtained from gnu.org/gpl.
  */
-- 
2.27.0

