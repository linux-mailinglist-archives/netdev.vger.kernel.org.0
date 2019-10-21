Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7969DE167
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfJUAKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:10:40 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41904 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfJUAKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 20:10:39 -0400
Received: by mail-lj1-f195.google.com with SMTP id f5so11345796ljg.8
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 17:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NQA3AJm3F7kktm2Jt5b0JWKorpvHRxsQoUBzWLUiICs=;
        b=SpnDSw3G82h9koRO2lHsmsdwuXll7vzv5TWQ/nGDMiGr7Ou6wbbZuTDum6uUMlq01K
         Wd/8t06AH9Xwe4D8f3Hpok3qq0rUwKz64CxL8osfDGLsxR01ApV3rLoVRKtSBewpJ3JJ
         QcPSzUQDvFb8dWfCGkB+t2LTLb5HWLrinx1Oe1Wo/KvdJco3X0FYVK5rQ1SDs+4Zb/xO
         zkCu1nGXBHEqB6aBm9CJUjFMHruzouewcMurAefAlE27sns26cZH/rs3Cq2W9BCkzWql
         kjIOGt6TWOHiMBov+FyaIba21JLxilX+TrSEMnT0rp3EA/tBVrdM1pU0IRgrn1Eie+kp
         6ECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NQA3AJm3F7kktm2Jt5b0JWKorpvHRxsQoUBzWLUiICs=;
        b=U/musXY2uAMK1E1V6D+xH20/mQ1l2bLK0DB+yz2bxXY1mZJMe3FZh+GzXFIpwvY0Vx
         EWEiNJ+eUQx11BS/PYuJDkwA4aQL7s3YUmxKtKwmpHNiuLBq6HmTO88PC+AZgVp8YiVw
         LQy7BDWjKmHj9ynUL7oYEP3rc7w4UBWDkDOi2cJt+TF9uPtNzLMLJMtk97R70F5eVOLB
         16Vv9yGspc74xysKdOItLKHEckZ57u448YAMJlX7L1CMnHkk2dCyK2e7t9sL49lj62+D
         ywftDPHOswRB3jnnyaMEAoTpL5PeivGjvWq3NfmhP1ZZjatVqo32lGbaszjKOrZxbO+1
         3ymQ==
X-Gm-Message-State: APjAAAWYgXtXn/mKi4LXnormoA2IYwLExp3/hC0aU81L84HxU/7ImEb9
        v5zjXb7ydPhcn6RWHHqRkznyq2kWT7M=
X-Google-Smtp-Source: APXvYqwO6KLxhd+WZvSyM8N6bU3j+CeXT4QXsAq92k8q+YG4iKPyfwg0abmZyCCUF33+10aKzTxv+A==
X-Received: by 2002:a2e:b4a8:: with SMTP id q8mr12850183ljm.106.1571616636261;
        Sun, 20 Oct 2019 17:10:36 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id a18sm2723081lfi.15.2019.10.20.17.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 17:10:33 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 08/10] ARM/net: ixp4xx: Pass ethernet physical base as resource
Date:   Mon, 21 Oct 2019 02:08:22 +0200
Message-Id: <20191021000824.531-9-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021000824.531-1-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
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
index df18d8ebb170..60cff1bce113 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1371,9 +1371,10 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
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
@@ -1386,13 +1387,18 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
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
@@ -1405,13 +1411,11 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
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
@@ -1423,13 +1427,11 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
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

