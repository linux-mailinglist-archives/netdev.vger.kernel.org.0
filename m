Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9DD174DCD
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgCAOpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:45:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbgCAOpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:45:50 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06A9124672;
        Sun,  1 Mar 2020 14:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073949;
        bh=+9GX7VkO5fDM/7wMfNiHz9/xCKTxapBnnwA9bJJjVWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Who2DHvFLTV5H4FF0upHhA/5uZb6exv33F9Edya/XDTV3HRsFTMfwrBtuobgz9w1H
         9ecQoAGFojnSa9syHmSFn48j1OXtVdKGm6V5YxfPT1qzAGWZnx45NFMy8R29VveunF
         h36uugM6YnjYnNZB04aQNlSmJUlLyENn2hzcItHg=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 14/23] net/dec: Delete driver versions
Date:   Sun,  1 Mar 2020 16:44:47 +0200
Message-Id: <20200301144457.119795-15-leon@kernel.org>
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

There is no need in assignments of driver version while linux kernel
is released as a monolith where the whole code base is aligned to one
general version.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/dec/tulip/de2104x.c     | 15 -----------
 drivers/net/ethernet/dec/tulip/dmfe.c        | 14 -----------
 drivers/net/ethernet/dec/tulip/tulip_core.c  | 26 ++------------------
 drivers/net/ethernet/dec/tulip/uli526x.c     | 13 ----------
 drivers/net/ethernet/dec/tulip/winbond-840.c | 12 ---------
 5 files changed, 2 insertions(+), 78 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index 42b798a3fad4..592454f444ce 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -30,7 +30,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #define DRV_NAME		"de2104x"
-#define DRV_VERSION		"0.7"
 #define DRV_RELDATE		"Mar 17, 2004"
 
 #include <linux/module.h>
@@ -52,14 +51,9 @@
 #include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
-/* These identify the driver base version and may not be removed. */
-static char version[] =
-"PCI Ethernet driver v" DRV_VERSION " (" DRV_RELDATE ")";
-
 MODULE_AUTHOR("Jeff Garzik <jgarzik@pobox.com>");
 MODULE_DESCRIPTION("Intel/Digital 21040/1 series PCI Ethernet driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 
 static int debug = -1;
 module_param (debug, int, 0);
@@ -1603,7 +1597,6 @@ static void de_get_drvinfo (struct net_device *dev,struct ethtool_drvinfo *info)
 	struct de_private *de = netdev_priv(dev);
 
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(de->pdev), sizeof(info->bus_info));
 }
 
@@ -1980,11 +1973,6 @@ static int de_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	board_idx++;
 
-#ifndef MODULE
-	if (board_idx == 0)
-		pr_info("%s\n", version);
-#endif
-
 	/* allocate a new ethernet device structure, and fill in defaults */
 	dev = alloc_etherdev(sizeof(struct de_private));
 	if (!dev)
@@ -2196,9 +2184,6 @@ static struct pci_driver de_driver = {
 
 static int __init de_init (void)
 {
-#ifdef MODULE
-	pr_info("%s\n", version);
-#endif
 	return pci_register_driver(&de_driver);
 }
 
diff --git a/drivers/net/ethernet/dec/tulip/dmfe.c b/drivers/net/ethernet/dec/tulip/dmfe.c
index 32d470d4122a..c1884fc9ad32 100644
--- a/drivers/net/ethernet/dec/tulip/dmfe.c
+++ b/drivers/net/ethernet/dec/tulip/dmfe.c
@@ -56,8 +56,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #define DRV_NAME	"dmfe"
-#define DRV_VERSION	"1.36.4"
-#define DRV_RELDATE	"2002-01-17"
 
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -280,10 +278,6 @@ enum dmfe_CR6_bits {
 };
 
 /* Global variable declaration ----------------------------- */
-static int printed_version;
-static const char version[] =
-	"Davicom DM9xxx net driver, version " DRV_VERSION " (" DRV_RELDATE ")";
-
 static int dmfe_debug;
 static unsigned char dmfe_media_mode = DMFE_AUTO;
 static u32 dmfe_cr6_user_set;
@@ -364,9 +358,6 @@ static int dmfe_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	DMFE_DBUG(0, "dmfe_init_one()", 0);
 
-	if (!printed_version++)
-		pr_info("%s\n", version);
-
 	/*
 	 *	SPARC on-board DM910x chips should be handled by the main
 	 *	tulip driver, except for early DM9100s.
@@ -1081,7 +1072,6 @@ static void dmfe_ethtool_get_drvinfo(struct net_device *dev,
 	struct dmfe_board_info *np = netdev_priv(dev);
 
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
 }
 
@@ -2177,7 +2167,6 @@ static struct pci_driver dmfe_driver = {
 MODULE_AUTHOR("Sten Wang, sten_wang@davicom.com.tw");
 MODULE_DESCRIPTION("Davicom DM910X fast ethernet driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 
 module_param(debug, int, 0);
 module_param(mode, byte, 0);
@@ -2204,9 +2193,6 @@ static int __init dmfe_init_module(void)
 {
 	int rc;
 
-	pr_info("%s\n", version);
-	printed_version = 1;
-
 	DMFE_DBUG(0, "init_module() ", debug);
 
 	if (debug)
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index 9e9d9eee29d9..48ea658aa1a6 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -12,13 +12,6 @@
 #define pr_fmt(fmt) "tulip: " fmt
 
 #define DRV_NAME	"tulip"
-#ifdef CONFIG_TULIP_NAPI
-#define DRV_VERSION    "1.1.15-NAPI" /* Keep at least for test */
-#else
-#define DRV_VERSION	"1.1.15"
-#endif
-#define DRV_RELDATE	"Feb 27, 2007"
-
 
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -37,9 +30,6 @@
 #include <asm/prom.h>
 #endif
 
-static char version[] =
-	"Linux Tulip driver version " DRV_VERSION " (" DRV_RELDATE ")\n";
-
 /* A few user-configurable values. */
 
 /* Maximum events (Rx packets, etc.) to handle at each interrupt. */
@@ -109,7 +99,6 @@ static int csr0;
 MODULE_AUTHOR("The Linux Kernel Team");
 MODULE_DESCRIPTION("Digital 21*4* Tulip ethernet driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 module_param(tulip_debug, int, 0);
 module_param(max_interrupt_work, int, 0);
 module_param(rx_copybreak, int, 0);
@@ -868,7 +857,6 @@ static void tulip_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *in
 {
 	struct tulip_private *np = netdev_priv(dev);
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
 }
 
@@ -1314,11 +1302,6 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	unsigned int eeprom_missing = 0;
 	unsigned int force_csr0 = 0;
 
-#ifndef MODULE
-	if (tulip_debug > 0)
-		printk_once(KERN_INFO "%s", version);
-#endif
-
 	board_idx++;
 
 	/*
@@ -1800,14 +1783,13 @@ static void tulip_set_wolopts (struct pci_dev *pdev, u32 wolopts)
 	void __iomem *ioaddr = tp->base_addr;
 
 	if (tp->flags & COMET_PM) {
-	  
 		unsigned int tmp;
-			
+
 		tmp = ioread32(ioaddr + CSR18);
 		tmp &= ~(comet_csr18_pmes_sticky | comet_csr18_apm_mode | comet_csr18_d3a);
 		tmp |= comet_csr18_pm_mode;
 		iowrite32(tmp, ioaddr + CSR18);
-			
+
 		/* Set the Wake-up Control/Status Register to the given WOL options*/
 		tmp = ioread32(ioaddr + CSR13);
 		tmp &= ~(comet_csr13_linkoffe | comet_csr13_linkone | comet_csr13_wfre | comet_csr13_lsce | comet_csr13_mpre);
@@ -1969,10 +1951,6 @@ static struct pci_driver tulip_driver = {
 
 static int __init tulip_init (void)
 {
-#ifdef MODULE
-	pr_info("%s", version);
-#endif
-
 	if (!csr0) {
 		pr_warn("tulip: unknown CPU architecture, using default csr0\n");
 		/* default to 8 longword cache line alignment */
diff --git a/drivers/net/ethernet/dec/tulip/uli526x.c b/drivers/net/ethernet/dec/tulip/uli526x.c
index 117ffe08800d..f726436b1985 100644
--- a/drivers/net/ethernet/dec/tulip/uli526x.c
+++ b/drivers/net/ethernet/dec/tulip/uli526x.c
@@ -7,8 +7,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #define DRV_NAME	"uli526x"
-#define DRV_VERSION	"0.9.3"
-#define DRV_RELDATE	"2005-7-29"
 
 #include <linux/module.h>
 
@@ -196,10 +194,6 @@ enum uli526x_CR6_bits {
 };
 
 /* Global variable declaration ----------------------------- */
-static int printed_version;
-static const char version[] =
-	"ULi M5261/M5263 net driver, version " DRV_VERSION " (" DRV_RELDATE ")";
-
 static int uli526x_debug;
 static unsigned char uli526x_media_mode = ULI526X_AUTO;
 static u32 uli526x_cr6_user_set;
@@ -282,9 +276,6 @@ static int uli526x_init_one(struct pci_dev *pdev,
 
 	ULI526X_DBUG(0, "uli526x_init_one()", 0);
 
-	if (!printed_version++)
-		pr_info("%s\n", version);
-
 	/* Init network device */
 	dev = alloc_etherdev(sizeof(*db));
 	if (dev == NULL)
@@ -972,7 +963,6 @@ static void netdev_get_drvinfo(struct net_device *dev,
 	struct uli526x_board_info *np = netdev_priv(dev);
 
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
 }
 
@@ -1799,9 +1789,6 @@ MODULE_PARM_DESC(mode, "ULi M5261/M5263: Bit 0: 10/100Mbps, bit 2: duplex, bit 8
 static int __init uli526x_init_module(void)
 {
 
-	pr_info("%s\n", version);
-	printed_version = 1;
-
 	ULI526X_DBUG(0, "init_module() ", debug);
 
 	if (debug)
diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 7f136488e67c..4d5e4fa53023 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -47,9 +47,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #define DRV_NAME	"winbond-840"
-#define DRV_VERSION	"1.01-e"
-#define DRV_RELDATE	"Sep-11-2006"
-
 
 /* Automatically extracted configuration info:
 probe-func: winbond840_probe
@@ -139,16 +136,9 @@ static int full_duplex[MAX_UNITS] = {-1, -1, -1, -1, -1, -1, -1, -1};
 #undef PKT_BUF_SZ			/* tulip.h also defines this */
 #define PKT_BUF_SZ		1536	/* Size of each temporary Rx buffer.*/
 
-/* These identify the driver base version and may not be removed. */
-static const char version[] __initconst =
-	"v" DRV_VERSION " (2.4 port) "
-	DRV_RELDATE "  Donald Becker <becker@scyld.com>\n"
-	"  http://www.scyld.com/network/drivers.html\n";
-
 MODULE_AUTHOR("Donald Becker <becker@scyld.com>");
 MODULE_DESCRIPTION("Winbond W89c840 Ethernet driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
 
 module_param(max_interrupt_work, int, 0);
 module_param(debug, int, 0);
@@ -1385,7 +1375,6 @@ static void netdev_get_drvinfo (struct net_device *dev, struct ethtool_drvinfo *
 	struct netdev_private *np = netdev_priv(dev);
 
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(np->pci_dev), sizeof(info->bus_info));
 }
 
@@ -1650,7 +1639,6 @@ static struct pci_driver w840_driver = {
 
 static int __init w840_init(void)
 {
-	printk(version);
 	return pci_register_driver(&w840_driver);
 }
 
-- 
2.24.1

