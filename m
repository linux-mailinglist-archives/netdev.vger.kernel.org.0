Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABABD1547CA
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgBFPTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:19:16 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38058 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727550AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=xn1+ZBCwahWIeQZAzJiRDVozcz9pfwHWgQZ0V1jYyS4=; b=lkh0y2pOexVJ8XFV0CeJAfyTk1
        KJf1OU924R9bSmyLyy12GHAEq3pOF68SOXbywLAngZfmFPjrgz/jTSRSQlmkx9Y52vySQTpts4JC8
        TTc5mIzNkujGbNIKvhwKTb3j8OeHFIbPcs7u5Hi7irg2gF0E61Ved+UGpUuiELpeU7yDzwSFfFtd1
        wDG/mpP/yIKheo7xzG7S95PZtCpRy3Xt54zaM1KN2wbf1BzYPk7FAAbav4Upjck5Fi+U5NNkspdp3
        kIOVaDCnmUof3X/zJMoDyZ6IkgvdOwn8JHtedr/iFhgSSBTWVoIufV+w08bqSvUc3hHUbiFLSP33F
        MZa8Xipg==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005jc-5D; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oVx-JY; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 19/28] docs: networking: convert driver.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:39 +0100
Message-Id: <2a20446abe6e81d2ba1fa2a7b7f27cdf16c6a310.1581002063.git.mchehab+huawei@kernel.org>
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
- add a document title;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.


Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{driver.txt => driver.rst}     | 22 +++++++++++--------
 Documentation/networking/index.rst            |  1 +
 2 files changed, 14 insertions(+), 9 deletions(-)
 rename Documentation/networking/{driver.txt => driver.rst} (85%)

diff --git a/Documentation/networking/driver.txt b/Documentation/networking/driver.rst
similarity index 85%
rename from Documentation/networking/driver.txt
rename to Documentation/networking/driver.rst
index da59e2884130..c8f59dbda46f 100644
--- a/Documentation/networking/driver.txt
+++ b/Documentation/networking/driver.rst
@@ -1,4 +1,8 @@
-Document about softnet driver issues
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================
+Softnet Driver Issues
+=====================
 
 Transmit path guidelines:
 
@@ -8,7 +12,7 @@ Transmit path guidelines:
    transmit function will become busy.
 
    Instead it must maintain the queue properly.  For example,
-   for a driver implementing scatter-gather this means:
+   for a driver implementing scatter-gather this means::
 
 	static netdev_tx_t drv_hard_start_xmit(struct sk_buff *skb,
 					       struct net_device *dev)
@@ -38,25 +42,25 @@ Transmit path guidelines:
 		return NETDEV_TX_OK;
 	}
 
-   And then at the end of your TX reclamation event handling:
+   And then at the end of your TX reclamation event handling::
 
 	if (netif_queue_stopped(dp->dev) &&
-            TX_BUFFS_AVAIL(dp) > (MAX_SKB_FRAGS + 1))
+	    TX_BUFFS_AVAIL(dp) > (MAX_SKB_FRAGS + 1))
 		netif_wake_queue(dp->dev);
 
-   For a non-scatter-gather supporting card, the three tests simply become:
+   For a non-scatter-gather supporting card, the three tests simply become::
 
 		/* This is a hard error log it. */
 		if (TX_BUFFS_AVAIL(dp) <= 0)
 
-   and:
+   and::
 
 		if (TX_BUFFS_AVAIL(dp) == 0)
 
-   and:
+   and::
 
 	if (netif_queue_stopped(dp->dev) &&
-            TX_BUFFS_AVAIL(dp) > 0)
+	    TX_BUFFS_AVAIL(dp) > 0)
 		netif_wake_queue(dp->dev);
 
 2) An ndo_start_xmit method must not modify the shared parts of a
@@ -86,7 +90,7 @@ Close/stop guidelines:
 
 1) After the ndo_stop routine has been called, the hardware must
    not receive or transmit any data.  All in flight packets must
-   be aborted. If necessary, poll or wait for completion of 
+   be aborted. If necessary, poll or wait for completion of
    any reset commands.
 
 2) The ndo_stop routine will be called by unregister_netdevice
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 68ddb023133c..b19188131d20 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -51,6 +51,7 @@ Contents:
    decnet
    defza
    dns_resolver
+   driver
 
 .. only::  subproject and html
 
-- 
2.24.1

