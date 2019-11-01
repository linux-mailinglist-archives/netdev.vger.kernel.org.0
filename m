Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86CAEC371
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfKANCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:02:50 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36253 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfKANCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 09:02:50 -0400
Received: by mail-lf1-f65.google.com with SMTP id a6so3776064lfo.3
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 06:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5qSCY0hy3sMC48rHBt8kAyy5w94n60kfo77Hgg2J0rk=;
        b=YqdYTCYFlmov3myb26ioiRB9KTJ39sNs84l1K5oejeFawLSxRqhdX/CR9zLhZqri+v
         /hfqMWDUs5n+JBuNCulgySlxCzGAPopfk3G2/1gJXhDGcqyRXf7NpRPhtgzRzJBgcGEJ
         4OHTI3FVedfJZLrYawGH39BcfVW1wm/vQoNTabHItq6M+y2+NWhjqvmYs1ceg1ymawUk
         trNDdSio6A+cEssXN3Ikwbs6aZ6qdFJ3imE//YFcBK8pgaiA4aVTGyFtlRp5K5z6osak
         RCEICM0gRmeExis28eQfoj7yuZFlx4hsEOFhPWTnpPi9KLbUxNRj4hozrs/ExWSvI9KY
         t0iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5qSCY0hy3sMC48rHBt8kAyy5w94n60kfo77Hgg2J0rk=;
        b=FzJU5DVWY86Z6RaaRK3sHBa2A/TWyelnUVr3r8uJwQ6ROxb9C13M3gWV7fjGTj+tAs
         gRE/sw3p7gQam6VEjUvA3kU06CEuotjtWN7GCHuIh/ZfvXmoZI/1pPO5H1wVGgmuJxEW
         /gJzULayRGkI7aGZlAEEYFMypgh3F9aD2FGtGpFvA311+Sw1LAZjsIfJK/MeQlFTvFDV
         JF2UYM7nWXGG/Xw8hufOl1/mMFcACC7966GAUD31Hc3L72UuSe6Gqh6zMX+7zvaiayYs
         LWlIO+I3PQ01O8YtWuyORNzrxWfJ3K07zH2PX4UN/XsMXUR6JYxNZr9MaICLRy33+4eo
         Siww==
X-Gm-Message-State: APjAAAV/t8ol7LEbzpF3J6yvaS4VfMsx6zzhvV844WWfrbFOiZ2kypjS
        wRThG47s/uj15pYcRXMAe3jgkidakjq+HQ==
X-Google-Smtp-Source: APXvYqwaxtKUNbiVKoe9UrW/Eu/bXCNQa2pdKadGKnPGzgBuEADTulTvKC/p5fsyEUjvY0YatVD1ew==
X-Received: by 2002:a19:c790:: with SMTP id x138mr7352814lff.61.1572613366471;
        Fri, 01 Nov 2019 06:02:46 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id c3sm2516749lfi.32.2019.11.01.06.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 06:02:45 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 08/10 v2] ARM/net: ixp4xx: Pass ethernet physical base as resource
Date:   Fri,  1 Nov 2019 14:02:22 +0100
Message-Id: <20191101130224.7964-9-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101130224.7964-1-linus.walleij@linaro.org>
References: <20191101130224.7964-1-linus.walleij@linaro.org>
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

