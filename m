Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B703B174DCB
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgCAOpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgCAOpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:47 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E930B222C4;
        Sun,  1 Mar 2020 14:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073946;
        bh=DBzShpyZt1PcZIxVPElKw/nZpiS8/EVdAFR8EFn3ndM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNenhdtzuP3w7QTeIyZVbIa4s9HqHNjpZ3tY0Ue/9NJ43AlSIOk0rUXgJ6e4YuDwK
         wX48ENp7paTGMk08ylZ6lpPlLw+/gTJaGDfq14h+vPsjo9aIcId8DgGcrZAeUnvFzh
         iK7pwuEb6NjaXdXwRGUxCXlqt2aEMieajMMJ0dNQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Denis Kirjanov <kda@linux-powerpc.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 15/23] net/dlink: Remove driver version and release date
Date:   Sun,  1 Mar 2020 16:44:48 +0200
Message-Id: <20200301144457.119795-16-leon@kernel.org>
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

Convert dlink drivers to use linux kernel version.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/dlink/dl2k.c     |  9 ---------
 drivers/net/ethernet/dlink/sundance.c | 20 --------------------
 2 files changed, 29 deletions(-)

diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index 26c5da032b1e..643090555cc7 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -8,8 +8,6 @@
 */
 
 #define DRV_NAME	"DL2000/TC902x-based linux driver"
-#define DRV_VERSION	"v1.19"
-#define DRV_RELDATE	"2007/08/12"
 #include "dl2k.h"
 #include <linux/dma-mapping.h>
 
@@ -20,8 +18,6 @@
 #define dr16(reg)	ioread16(ioaddr + (reg))
 #define dr8(reg)	ioread8(ioaddr + (reg))
 
-static char version[] =
-      KERN_INFO DRV_NAME " " DRV_VERSION " " DRV_RELDATE "\n";
 #define MAX_UNITS 8
 static int mtu[MAX_UNITS];
 static int vlan[MAX_UNITS];
@@ -113,13 +109,9 @@ rio_probe1 (struct pci_dev *pdev, const struct pci_device_id *ent)
 	int chip_idx = ent->driver_data;
 	int err, irq;
 	void __iomem *ioaddr;
-	static int version_printed;
 	void *ring_space;
 	dma_addr_t ring_dma;
 
-	if (!version_printed++)
-		printk ("%s", version);
-
 	err = pci_enable_device (pdev);
 	if (err)
 		return err;
@@ -1244,7 +1236,6 @@ static void rio_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 	struct netdev_private *np = netdev_priv(dev);
 
 	strlcpy(info->driver, "dl2k", sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
 }
 
diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index b91387c456ba..dc566fcc3ba9 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -23,9 +23,6 @@
 */
 
 #define DRV_NAME	"sundance"
-#define DRV_VERSION	"1.2"
-#define DRV_RELDATE	"11-Sep-2006"
-
 
 /* The user-configurable values.
    These may be modified when a driver module is loaded.*/
@@ -101,11 +98,6 @@ static char *media[MAX_UNITS];
 #include <linux/ethtool.h>
 #include <linux/mii.h>
 
-/* These identify the driver base version and may not be removed. */
-static const char version[] =
-	KERN_INFO DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE
-	" Written by Donald Becker\n";
-
 MODULE_AUTHOR("Donald Becker <becker@scyld.com>");
 MODULE_DESCRIPTION("Sundance Alta Ethernet driver");
 MODULE_LICENSE("GPL");
@@ -516,13 +508,6 @@ static int sundance_probe1(struct pci_dev *pdev,
 #endif
 	int phy, phy_end, phy_idx = 0;
 
-/* when built into the kernel, we only print version if device is found */
-#ifndef MODULE
-	static int printed_version;
-	if (!printed_version++)
-		printk(version);
-#endif
-
 	if (pci_enable_device(pdev))
 		return -EIO;
 	pci_set_master(pdev);
@@ -1657,7 +1642,6 @@ static void get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct netdev_private *np = netdev_priv(dev);
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
@@ -2010,10 +1994,6 @@ static struct pci_driver sundance_driver = {
 
 static int __init sundance_init(void)
 {
-/* when a module, this is printed whether or not devices are found in probe */
-#ifdef MODULE
-	printk(version);
-#endif
 	return pci_register_driver(&sundance_driver);
 }
 
-- 
2.24.1

