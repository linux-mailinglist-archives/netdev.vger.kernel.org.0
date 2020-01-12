Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B38138624
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 13:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732815AbgALMFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 07:05:14 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43425 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732774AbgALMFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 07:05:13 -0500
Received: by mail-lj1-f195.google.com with SMTP id a13so6912096ljm.10
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 04:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XJKp6ZeAq94OXUjfq5QU4GFx4A01NxhOkBWCYIlbSXY=;
        b=a0Vpd2ekUm1iC26IZQSuKglYbpbyVOdQPbor7PJ4D1wOnPthhAi99s1hKQoTbc3aT5
         fE8XJc7PaffSv8uzFzuJru70gls7G7VAO7p+pe7yJHa9UoA2XLCpCQNhyc89GNYqAx2k
         twY0rjzJZu1lrlAfTOrcFylUMHTZnA8znwI23umeXpYbcqu3LlfTCpRqhGWY0+VzQlUv
         IRd6di90qyGLV11DugrO/7KM1gkFhnSK8pYjPICyf+9+HNEm4tP4UKpr/Z761u0yCLpI
         ex1aZFVFwBNH+AtbouCwpe/TIHrWgaR9RX1avKqo/4LwTtOdt83cgdXFgxdmKXVysX3K
         hqyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XJKp6ZeAq94OXUjfq5QU4GFx4A01NxhOkBWCYIlbSXY=;
        b=o3UR1IHGtqOavP3d7sM24uHbgsCEdbDfUmPP2FxH6yG/1GX0koIPzrxf4fUOuGUjqf
         CsJ2nFLEabDAc5JmXY9fXRWNm807ZiWVLs1cLePvja0Lo4Qsi5txFe3IJZVjC5D8Pey8
         Zrx7EC/c+bGVxfI4oLtzfwo0VyZ+XOlWCoRinjUAVtIFFbcz1BAEJslZ1DT5xWp3lvaJ
         HP9/AFxlbk30x/yHRhUwKTSyq9ONizMgEPBO8RaJGN9gNbvgdsENZxoJKppxC/NVH2yr
         Hhi7yVVfPcctXn7tfSkkyKnHt+0IE4N23PDE7jDSMGuBFR7YFIQ/peMsJ3ncNhYR6Wz4
         q6SQ==
X-Gm-Message-State: APjAAAV4hV/wpqyy2I98VPLvH5L1IMnIGvnoksykBIWT2rwwJ20BE+yA
        p/e0KPMTY8gZiwJpYYaAPCMfzmztNUpSRg==
X-Google-Smtp-Source: APXvYqxINiAkr7z71El/iGWiJrjCDCGVyspe1hYvzRBu9UPsPK86AkWlwN1Xj76D49Rv/UcJu3jqbw==
X-Received: by 2002:a2e:b52b:: with SMTP id z11mr7947891ljm.155.1578830710637;
        Sun, 12 Jan 2020 04:05:10 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id z7sm4660347lfa.81.2020.01.12.04.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 04:05:10 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 8/9 v5] ARM/net: ixp4xx: Pass ethernet physical base as resource
Date:   Sun, 12 Jan 2020 13:04:49 +0100
Message-Id: <20200112120450.11874-9-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200112120450.11874-1-linus.walleij@linaro.org>
References: <20200112120450.11874-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to probe this ethernet interface from the device tree
all physical MMIO regions must be passed as resources. Begin
this rewrite by first passing the port base address as a
resource for all platforms using this driver, remap it in
the driver and avoid using any reference of the statically
mapped virtual address in the driver.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v4->v5:
- Renase onto the net-next tree
ChangeLog v3->v4:
- Drop a stable tag and rebubmit.
ChangeLog v2->v3:
- Rebased on v5.5-rc1
ChangeLog v1->v2:
- Rebased on the rest of the series.
---
 arch/arm/mach-ixp4xx/fsg-setup.c         | 20 ++++++++++++++++++++
 arch/arm/mach-ixp4xx/goramo_mlr.c        | 20 ++++++++++++++++++++
 arch/arm/mach-ixp4xx/ixdp425-setup.c     | 20 ++++++++++++++++++++
 arch/arm/mach-ixp4xx/nas100d-setup.c     | 10 ++++++++++
 arch/arm/mach-ixp4xx/nslu2-setup.c       | 10 ++++++++++
 arch/arm/mach-ixp4xx/omixp-setup.c       | 20 ++++++++++++++++++++
 arch/arm/mach-ixp4xx/vulcan-setup.c      | 20 ++++++++++++++++++++
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 20 +++++++++++---------
 8 files changed, 131 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/fsg-setup.c b/arch/arm/mach-ixp4xx/fsg-setup.c
index 648932d8d7a8..507ee3878769 100644
--- a/arch/arm/mach-ixp4xx/fsg-setup.c
+++ b/arch/arm/mach-ixp4xx/fsg-setup.c
@@ -132,6 +132,22 @@ static struct platform_device fsg_leds = {
 };
 
 /* Built-in 10/100 Ethernet MAC interfaces */
+static struct resource fsg_eth_npeb_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
+static struct resource fsg_eth_npec_resources[] = {
+	{
+		.start		= IXP4XX_EthC_BASE_PHYS,
+		.end		= IXP4XX_EthC_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info fsg_plat_eth[] = {
 	{
 		.phy		= 5,
@@ -151,12 +167,16 @@ static struct platform_device fsg_eth[] = {
 		.dev = {
 			.platform_data	= fsg_plat_eth,
 		},
+		.num_resources	= ARRAY_SIZE(fsg_eth_npeb_resources),
+		.resource	= fsg_eth_npeb_resources,
 	}, {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEC,
 		.dev = {
 			.platform_data	= fsg_plat_eth + 1,
 		},
+		.num_resources	= ARRAY_SIZE(fsg_eth_npec_resources),
+		.resource	= fsg_eth_npec_resources,
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/goramo_mlr.c b/arch/arm/mach-ixp4xx/goramo_mlr.c
index 93b7afeee142..07b50dfcc489 100644
--- a/arch/arm/mach-ixp4xx/goramo_mlr.c
+++ b/arch/arm/mach-ixp4xx/goramo_mlr.c
@@ -273,6 +273,22 @@ static struct platform_device device_uarts = {
 
 
 /* Built-in 10/100 Ethernet MAC interfaces */
+static struct resource eth_npeb_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
+static struct resource eth_npec_resources[] = {
+	{
+		.start		= IXP4XX_EthC_BASE_PHYS,
+		.end		= IXP4XX_EthC_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info eth_plat[] = {
 	{
 		.phy		= 0,
@@ -290,10 +306,14 @@ static struct platform_device device_eth_tab[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= eth_plat,
+		.num_resources		= ARRAY_SIZE(eth_npeb_resources),
+		.resource		= eth_npeb_resources,
 	}, {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEC,
 		.dev.platform_data	= eth_plat + 1,
+		.num_resources		= ARRAY_SIZE(eth_npec_resources),
+		.resource		= eth_npec_resources,
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/ixdp425-setup.c b/arch/arm/mach-ixp4xx/ixdp425-setup.c
index 6f0f7ed18ea8..45d5b720ded6 100644
--- a/arch/arm/mach-ixp4xx/ixdp425-setup.c
+++ b/arch/arm/mach-ixp4xx/ixdp425-setup.c
@@ -187,6 +187,22 @@ static struct platform_device ixdp425_uart = {
 };
 
 /* Built-in 10/100 Ethernet MAC interfaces */
+static struct resource ixp425_npeb_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
+static struct resource ixp425_npec_resources[] = {
+	{
+		.start		= IXP4XX_EthC_BASE_PHYS,
+		.end		= IXP4XX_EthC_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info ixdp425_plat_eth[] = {
 	{
 		.phy		= 0,
@@ -204,10 +220,14 @@ static struct platform_device ixdp425_eth[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= ixdp425_plat_eth,
+		.num_resources		= ARRAY_SIZE(ixp425_npeb_resources),
+		.resource		= ixp425_npeb_resources,
 	}, {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEC,
 		.dev.platform_data	= ixdp425_plat_eth + 1,
+		.num_resources		= ARRAY_SIZE(ixp425_npec_resources),
+		.resource		= ixp425_npec_resources,
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/nas100d-setup.c b/arch/arm/mach-ixp4xx/nas100d-setup.c
index c142cfa8c5d6..6959ad2e3aec 100644
--- a/arch/arm/mach-ixp4xx/nas100d-setup.c
+++ b/arch/arm/mach-ixp4xx/nas100d-setup.c
@@ -165,6 +165,14 @@ static struct platform_device nas100d_uart = {
 };
 
 /* Built-in 10/100 Ethernet MAC interfaces */
+static struct resource nas100d_eth_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info nas100d_plat_eth[] = {
 	{
 		.phy		= 0,
@@ -178,6 +186,8 @@ static struct platform_device nas100d_eth[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= nas100d_plat_eth,
+		.num_resources		= ARRAY_SIZE(nas100d_eth_resources),
+		.resource		= nas100d_eth_resources,
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/nslu2-setup.c b/arch/arm/mach-ixp4xx/nslu2-setup.c
index ee1877fcfafe..a428bb918703 100644
--- a/arch/arm/mach-ixp4xx/nslu2-setup.c
+++ b/arch/arm/mach-ixp4xx/nslu2-setup.c
@@ -185,6 +185,14 @@ static struct platform_device nslu2_uart = {
 };
 
 /* Built-in 10/100 Ethernet MAC interfaces */
+static struct resource nslu2_eth_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info nslu2_plat_eth[] = {
 	{
 		.phy		= 1,
@@ -198,6 +206,8 @@ static struct platform_device nslu2_eth[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= nslu2_plat_eth,
+		.num_resources		= ARRAY_SIZE(nslu2_eth_resources),
+		.resource		= nslu2_eth_resources,
 	}
 };
 
diff --git a/arch/arm/mach-ixp4xx/omixp-setup.c b/arch/arm/mach-ixp4xx/omixp-setup.c
index 6ed5a9aed600..8f2b8c473d7a 100644
--- a/arch/arm/mach-ixp4xx/omixp-setup.c
+++ b/arch/arm/mach-ixp4xx/omixp-setup.c
@@ -170,6 +170,22 @@ static struct platform_device mic256_leds = {
 };
 
 /* Built-in 10/100 Ethernet MAC interfaces */
+static struct resource ixp425_npeb_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
+static struct resource ixp425_npec_resources[] = {
+	{
+		.start		= IXP4XX_EthC_BASE_PHYS,
+		.end		= IXP4XX_EthC_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info ixdp425_plat_eth[] = {
 	{
 		.phy		= 0,
@@ -187,10 +203,14 @@ static struct platform_device ixdp425_eth[] = {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEB,
 		.dev.platform_data	= ixdp425_plat_eth,
+		.num_resources		= ARRAY_SIZE(ixp425_npeb_resources),
+		.resource		= ixp425_npeb_resources,
 	}, {
 		.name			= "ixp4xx_eth",
 		.id			= IXP4XX_ETH_NPEC,
 		.dev.platform_data	= ixdp425_plat_eth + 1,
+		.num_resources		= ARRAY_SIZE(ixp425_npec_resources),
+		.resource		= ixp425_npec_resources,
 	},
 };
 
diff --git a/arch/arm/mach-ixp4xx/vulcan-setup.c b/arch/arm/mach-ixp4xx/vulcan-setup.c
index d2ebb7c675a8..e506d2af98ad 100644
--- a/arch/arm/mach-ixp4xx/vulcan-setup.c
+++ b/arch/arm/mach-ixp4xx/vulcan-setup.c
@@ -124,6 +124,22 @@ static struct platform_device vulcan_uart = {
 	.num_resources		= ARRAY_SIZE(vulcan_uart_resources),
 };
 
+static struct resource vulcan_npeb_resources[] = {
+	{
+		.start		= IXP4XX_EthB_BASE_PHYS,
+		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
+static struct resource vulcan_npec_resources[] = {
+	{
+		.start		= IXP4XX_EthC_BASE_PHYS,
+		.end		= IXP4XX_EthC_BASE_PHYS + 0x0fff,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
 static struct eth_plat_info vulcan_plat_eth[] = {
 	[0] = {
 		.phy		= 0,
@@ -144,6 +160,8 @@ static struct platform_device vulcan_eth[] = {
 		.dev = {
 			.platform_data	= &vulcan_plat_eth[0],
 		},
+		.num_resources		= ARRAY_SIZE(vulcan_npeb_resources),
+		.resource		= vulcan_npeb_resources,
 	},
 	[1] = {
 		.name			= "ixp4xx_eth",
@@ -151,6 +169,8 @@ static struct platform_device vulcan_eth[] = {
 		.dev = {
 			.platform_data	= &vulcan_plat_eth[1],
 		},
+		.num_resources		= ARRAY_SIZE(vulcan_npec_resources),
+		.resource		= vulcan_npec_resources,
 	},
 };
 
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index f7edf8b38dea..ee45215c4ba4 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1365,9 +1365,10 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	struct phy_device *phydev = NULL;
 	struct device *dev = &pdev->dev;
 	struct eth_plat_info *plat;
+	resource_size_t regs_phys;
 	struct net_device *ndev;
+	struct resource *res;
 	struct port *port;
-	u32 regs_phys;
 	int err;
 
 	plat = dev_get_platdata(dev);
@@ -1380,13 +1381,18 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	port->netdev = ndev;
 	port->id = pdev->id;
 
+	/* Get the port resource and remap */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+	regs_phys = res->start;
+	port->regs = devm_ioremap_resource(dev, res);
+
 	switch (port->id) {
 	case IXP4XX_ETH_NPEA:
 		/* If the MDIO bus is not up yet, defer probe */
 		if (!mdio_bus)
 			return -EPROBE_DEFER;
-		port->regs = (struct eth_regs __iomem *)IXP4XX_EthA_BASE_VIRT;
-		regs_phys  = IXP4XX_EthA_BASE_PHYS;
 		break;
 	case IXP4XX_ETH_NPEB:
 		/*
@@ -1399,13 +1405,11 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 			      IXP4XX_FEATURE_NPEB_ETH0))
 				return -ENODEV;
 			/* Else register the MDIO bus on NPE-B */
-			if ((err = ixp4xx_mdio_register(IXP4XX_EthC_BASE_VIRT)))
+			if ((err = ixp4xx_mdio_register(port->regs)))
 				return err;
 		}
 		if (!mdio_bus)
 			return -EPROBE_DEFER;
-		port->regs = (struct eth_regs __iomem *)IXP4XX_EthB_BASE_VIRT;
-		regs_phys  = IXP4XX_EthB_BASE_PHYS;
 		break;
 	case IXP4XX_ETH_NPEC:
 		/*
@@ -1417,13 +1421,11 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 			      IXP4XX_FEATURE_NPEC_ETH))
 				return -ENODEV;
 			/* Else register the MDIO bus on NPE-C */
-			if ((err = ixp4xx_mdio_register(IXP4XX_EthC_BASE_VIRT)))
+			if ((err = ixp4xx_mdio_register(port->regs)))
 				return err;
 		}
 		if (!mdio_bus)
 			return -EPROBE_DEFER;
-		port->regs = (struct eth_regs __iomem *)IXP4XX_EthC_BASE_VIRT;
-		regs_phys  = IXP4XX_EthC_BASE_PHYS;
 		break;
 	default:
 		return -ENODEV;
-- 
2.21.0

