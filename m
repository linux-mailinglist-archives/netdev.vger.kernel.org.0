Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D2C1BB122
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgD0WEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbgD0WCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:00 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9592221EB;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=hcDugR9Ei2kcALB6m15r0N7fV4ifciWFKj04gGXvBuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GT+gPG34hk517db2YxFh+lLtciGEjV4Brm67oo557BBaUwujTGGRlz3qC7HSuPKc0
         zr8AArJQGboc0B9fbIvvTbjBN7oXaKYVnGUCvTqnQ1V/VLTZBrIiIHkG4kHpuxj8Kt
         Qh2ohmupTnfCLj3v9UQaFTTpQaZBDtUIJBoXXXFg=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000Ip4-Ve; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 18/38] docs: networking: convert driver.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:33 +0200
Message-Id: <830fa106e7fa2584038838973e71fe63ff73cac7.1588024424.git.mchehab+huawei@kernel.org>
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
index 55746038a7e9..313f66900bce 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -53,6 +53,7 @@ Contents:
    decnet
    defza
    dns_resolver
+   driver
 
 .. only::  subproject and html
 
-- 
2.25.4

