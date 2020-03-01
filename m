Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEAD1174DD7
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgCAOqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:46:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbgCAOqQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:46:16 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D199B222C4;
        Sun,  1 Mar 2020 14:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073975;
        bh=amtj4GRdAiNen6Wiz7deF0pzBdbki/BGzFr6UuqwUWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMPQ9lEy76QfvqdWuN1HbpPi6u/6o0Q7yr/8s7Kr5oCDfPxQatoQxWDpW44q4WCd+
         im4AOYcfpSGtvfP453uWksJHwTHqIhQGtDw0mCOH4Ks5CNQ/r4yEnwm+/CXWqK8Ko0
         87L4JP6bWBcToO/EAAJE+7iEBKGIy1NHj74Xhj0E=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 19/23] net/fealnx: Delete driver version
Date:   Sun,  1 Mar 2020 16:44:52 +0200
Message-Id: <20200301144457.119795-20-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200301144457.119795-1-leon@kernel.org>
References: <20200301144457.119795-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Use general linux kernel version instead of static driver version.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/fealnx.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
index 84f10970299a..73e896a7d8fd 100644
--- a/drivers/net/ethernet/fealnx.c
+++ b/drivers/net/ethernet/fealnx.c
@@ -25,8 +25,6 @@
 */
 
 #define DRV_NAME	"fealnx"
-#define DRV_VERSION	"2.52"
-#define DRV_RELDATE	"Sep-11-2006"
 
 static int debug;		/* 1-> print debug message */
 static int max_interrupt_work = 20;
@@ -91,11 +89,6 @@ static int full_duplex[MAX_UNITS] = { -1, -1, -1, -1, -1, -1, -1, -1 };
 #include <linux/uaccess.h>
 #include <asm/byteorder.h>
 
-/* These identify the driver base version and may not be removed. */
-static const char version[] =
-	KERN_INFO DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE "\n";
-
-
 /* This driver was written to use PCI memory space, however some x86 systems
    work only with I/O space accesses. */
 #ifndef __alpha__
@@ -495,13 +488,6 @@ static int fealnx_init_one(struct pci_dev *pdev,
 	int bar = 1;
 #endif
 
-/* when built into the kernel, we only print version if device is found */
-#ifndef MODULE
-	static int printed_version;
-	if (!printed_version++)
-		printk(version);
-#endif
-
 	card_idx++;
 	sprintf(boardname, "fealnx%d", card_idx);
 
@@ -1809,7 +1795,6 @@ static void netdev_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *i
 	struct netdev_private *np = netdev_priv(dev);
 
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
@@ -1950,11 +1935,6 @@ static struct pci_driver fealnx_driver = {
 
 static int __init fealnx_init(void)
 {
-/* when a module, this is printed whether or not devices are found in probe */
-#ifdef MODULE
-	printk(version);
-#endif
-
 	return pci_register_driver(&fealnx_driver);
 }
 
-- 
2.24.1

