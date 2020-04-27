Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452C51BB116
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgD0WDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgD0WCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:01 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECCB822247;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=heeV+J4zgG1ilBcY9hCHShdtfgCZE3mtls31xZd0Bu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGNAoR4zE5irRDJf2dmGvUPKD7mP8S3ht879/yNtSTRezxsgAWpzdf28tvoNJ2N7u
         wF2bctADqnksRf+19Mad3EPzx4XiRr46xcTeu0h4eRaCb2HLfYASdVlZlymiSfW9Q0
         dHnnCjEfTpOqONNXA1YQUW1StN4J9d5Vp9A5PMqw=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000Ipi-5n; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 26/38] docs: networking: convert gen_stats.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:41 +0200
Message-Id: <1ac3aa71bea21f7a157cf8ca383afaeebe1012fd.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- mark code blocks and literals as such;
- mark tables as such;
- mark lists as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../{gen_stats.txt => gen_stats.rst}          | 98 ++++++++++---------
 Documentation/networking/index.rst            |  1 +
 net/core/gen_stats.c                          |  2 +-
 3 files changed, 56 insertions(+), 45 deletions(-)
 rename Documentation/networking/{gen_stats.txt => gen_stats.rst} (60%)

diff --git a/Documentation/networking/gen_stats.txt b/Documentation/networking/gen_stats.rst
similarity index 60%
rename from Documentation/networking/gen_stats.txt
rename to Documentation/networking/gen_stats.rst
index 179b18ce45ff..595a83b9a61b 100644
--- a/Documentation/networking/gen_stats.txt
+++ b/Documentation/networking/gen_stats.rst
@@ -1,67 +1,76 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============================================
 Generic networking statistics for netlink users
-======================================================================
+===============================================
 
 Statistic counters are grouped into structs:
 
+==================== ===================== =====================
 Struct               TLV type              Description
-----------------------------------------------------------------------
+==================== ===================== =====================
 gnet_stats_basic     TCA_STATS_BASIC       Basic statistics
 gnet_stats_rate_est  TCA_STATS_RATE_EST    Rate estimator
 gnet_stats_queue     TCA_STATS_QUEUE       Queue statistics
 none                 TCA_STATS_APP         Application specific
+==================== ===================== =====================
 
 
 Collecting:
 -----------
 
-Declare the statistic structs you need:
-struct mystruct {
-	struct gnet_stats_basic	bstats;
-	struct gnet_stats_queue	qstats;
-	...
-};
+Declare the statistic structs you need::
 
-Update statistics, in dequeue() methods only, (while owning qdisc->running)
-mystruct->tstats.packet++;
-mystruct->qstats.backlog += skb->pkt_len;
+	struct mystruct {
+		struct gnet_stats_basic	bstats;
+		struct gnet_stats_queue	qstats;
+		...
+	};
+
+Update statistics, in dequeue() methods only, (while owning qdisc->running)::
+
+	mystruct->tstats.packet++;
+	mystruct->qstats.backlog += skb->pkt_len;
 
 
 Export to userspace (Dump):
 ---------------------------
 
-my_dumping_routine(struct sk_buff *skb, ...)
-{
-	struct gnet_dump dump;
+::
 
-	if (gnet_stats_start_copy(skb, TCA_STATS2, &mystruct->lock, &dump,
-				  TCA_PAD) < 0)
-		goto rtattr_failure;
+    my_dumping_routine(struct sk_buff *skb, ...)
+    {
+	    struct gnet_dump dump;
 
-	if (gnet_stats_copy_basic(&dump, &mystruct->bstats) < 0 ||
-	    gnet_stats_copy_queue(&dump, &mystruct->qstats) < 0 ||
-		gnet_stats_copy_app(&dump, &xstats, sizeof(xstats)) < 0)
-		goto rtattr_failure;
+	    if (gnet_stats_start_copy(skb, TCA_STATS2, &mystruct->lock, &dump,
+				    TCA_PAD) < 0)
+		    goto rtattr_failure;
 
-	if (gnet_stats_finish_copy(&dump) < 0)
-		goto rtattr_failure;
-	...
-}
+	    if (gnet_stats_copy_basic(&dump, &mystruct->bstats) < 0 ||
+		gnet_stats_copy_queue(&dump, &mystruct->qstats) < 0 ||
+		    gnet_stats_copy_app(&dump, &xstats, sizeof(xstats)) < 0)
+		    goto rtattr_failure;
+
+	    if (gnet_stats_finish_copy(&dump) < 0)
+		    goto rtattr_failure;
+	    ...
+    }
 
 TCA_STATS/TCA_XSTATS backward compatibility:
 --------------------------------------------
 
 Prior users of struct tc_stats and xstats can maintain backward
 compatibility by calling the compat wrappers to keep providing the
-existing TLV types.
+existing TLV types::
 
-my_dumping_routine(struct sk_buff *skb, ...)
-{
-    if (gnet_stats_start_copy_compat(skb, TCA_STATS2, TCA_STATS,
-				     TCA_XSTATS, &mystruct->lock, &dump,
-				     TCA_PAD) < 0)
-		goto rtattr_failure;
-	...
-}
+    my_dumping_routine(struct sk_buff *skb, ...)
+    {
+	if (gnet_stats_start_copy_compat(skb, TCA_STATS2, TCA_STATS,
+					TCA_XSTATS, &mystruct->lock, &dump,
+					TCA_PAD) < 0)
+		    goto rtattr_failure;
+	    ...
+    }
 
 A struct tc_stats will be filled out during gnet_stats_copy_* calls
 and appended to the skb. TCA_XSTATS is provided if gnet_stats_copy_app
@@ -77,7 +86,7 @@ are responsible for making sure that the lock is initialized.
 
 
 Rate Estimator:
---------------
+---------------
 
 0) Prepare an estimator attribute. Most likely this would be in user
    space. The value of this TLV should contain a tc_estimator structure.
@@ -92,18 +101,19 @@ Rate Estimator:
    TCA_RATE to your code in the kernel.
 
 In the kernel when setting up:
+
 1) make sure you have basic stats and rate stats setup first.
 2) make sure you have initialized stats lock that is used to setup such
    stats.
-3) Now initialize a new estimator:
+3) Now initialize a new estimator::
 
-   int ret = gen_new_estimator(my_basicstats,my_rate_est_stats,
-       mystats_lock, attr_with_tcestimator_struct);
+    int ret = gen_new_estimator(my_basicstats,my_rate_est_stats,
+	mystats_lock, attr_with_tcestimator_struct);
 
-   if ret == 0
-       success
-   else
-       failed
+    if ret == 0
+	success
+    else
+	failed
 
 From now on, every time you dump my_rate_est_stats it will contain
 up-to-date info.
@@ -115,5 +125,5 @@ are still valid (i.e still exist) at the time of making this call.
 
 Authors:
 --------
-Thomas Graf <tgraf@suug.ch>
-Jamal Hadi Salim <hadi@cyberus.ca>
+- Thomas Graf <tgraf@suug.ch>
+- Jamal Hadi Salim <hadi@cyberus.ca>
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 42e556509e22..33afbb67f3fa 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -61,6 +61,7 @@ Contents:
    framerelay
    generic-hdlc
    generic_netlink
+   gen_stats
 
 .. only::  subproject and html
 
diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index 1d653fbfcf52..e491b083b348 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -6,7 +6,7 @@
  *           Jamal Hadi Salim
  *           Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
  *
- * See Documentation/networking/gen_stats.txt
+ * See Documentation/networking/gen_stats.rst
  */
 
 #include <linux/types.h>
-- 
2.25.4

