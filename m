Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464C31547CD
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbgBFPTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:19:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38052 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=NzwrChhdVdmkKNT+nRpc6rp14kLWb+Gda2MByckmEbM=; b=lzDJ0b1XLeVkt+CTIQfeYr4KdV
        JIWTXbXXIMc73L+Vq33hCcno0C8FPIZ9b1MdcWnL9BP+EOwByvirDz4hZxO96Xkb1TABSZAC8qRr3
        pApb6AD90ozq4jz5lcikrKn0ATm5z+92XZC8BWIPHHqSB3pLiSDI71rjP+4Hc8e7r1j5jRkH0TLf7
        ORaUr3UX4ITD1vZm1sCM/xmSzbgqUGZfFtDlJoH5f9eKZfiVXE71z59sCvwFpCGzZvZ2geR/R8ChR
        IfiBpAVdhjvkrfnXQMQ8j4WoKVBRgqkp9G8GyiY0p8jud3GKNuKvf5VtkeblJHVgmppRSi3nYAFj5
        nSBguW9Q==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005jE-32; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziue-002oWY-12; Thu, 06 Feb 2020 16:17:52 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 27/28] docs: networking: convert gen_stats.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:47 +0100
Message-Id: <02eb7aaa43c6649123e1dac054bc6aa94e8d2e13.1581002063.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581002062.git.mchehab+huawei@kernel.org>
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
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
 2 files changed, 55 insertions(+), 44 deletions(-)
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
index bc2ee843df03..548f8c281d01 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -59,6 +59,7 @@ Contents:
    framerelay
    generic-hdlc
    generic_netlink
+   gen_stats
 
 .. only::  subproject and html
 
-- 
2.24.1

