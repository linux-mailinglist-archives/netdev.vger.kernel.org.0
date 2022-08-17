Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F850596A67
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 09:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiHQH3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 03:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiHQH3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 03:29:50 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CBB6B161
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 00:29:47 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id jm11so9077081plb.13
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 00:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=bgttJYEOERx5qc8Fss9yIg6f5GDvQ+wYZ203XEFeUg0=;
        b=XC9XZxtdG6LJ6tSyJrFtyQ3H7ogFrNlILsILo2+EsIcuxU6Y01nCFe2EoEccCDe9kB
         h8N0VkUMCNVgVIKzN4iasFKBZbg67NW7uYxN4uhpYu/x8oJBV4vf5Ykd/km8f4CMxIL+
         MXL+G4Jg1uhe28eYs02p7qXbeaAwUHhfr1BsLmkyCjeurW4gIEnD+RXlhCcZ+dmBtmUF
         d9ICQ8jYXX3YIyHfLD66rScfQlvHCfHZFqGbt52scO8rSQx2+/vuTUm6D4Fw82WQk+yo
         7Jbiwk1AhZ+z/6WxevMSbQw2TB/bvlbyRz1VrUlWGynyOQ2UGGT0sm/OiJ9SgZmdkhMB
         ntWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=bgttJYEOERx5qc8Fss9yIg6f5GDvQ+wYZ203XEFeUg0=;
        b=G2e7NwwjjPzPobFyFVRW++Gc/OP9jxQ0at7Z4PqqidGjBxoexDoEZhelF8FnW+Y9lQ
         bgxhIlBNMLvtBkXuenDphK/acn0cIWr6rIibhxKNAmfPIWRsYHc1NOT3kNCbkD3b7GcQ
         jlpfqnpDOQLZ/vK4GmfdwfkOeYb+VlqxyF+sCYITV/Eechm7fZYmypLSQULlPNVKTKkt
         8aCwd94fcfaf5ExM5/WfIvokD4b+fgGK3fDO8rsCCSYPf9/AGqkHKNjgsyEptx/FTm5A
         78IF2NfQLZ0lsoPjmzehC/vVG5IfkMqKZhW18BJjoscWpO+wBrpvEPU0Eirkdn7Z8sTT
         j6VA==
X-Gm-Message-State: ACgBeo2GG/HRhCZqLuptnzae18EoIB3w7nziuO46kWD1byraVdwjb5Da
        2va7EdTRlgKAxeGAcb18nys=
X-Google-Smtp-Source: AA6agR7F4CqGTk6G08JMytb3ps+ebcmG0kGxR/SWJGxKZxC9+qGW3yi+/UF58XrqWTZ0iqRznnn8Zg==
X-Received: by 2002:a17:902:f711:b0:170:9e3c:1540 with SMTP id h17-20020a170902f71100b001709e3c1540mr24632396plo.22.1660721386582;
        Wed, 17 Aug 2022 00:29:46 -0700 (PDT)
Received: from localhost.localdomain ([112.20.110.237])
        by smtp.gmail.com with ESMTPSA id l2-20020a17090af8c200b001f3076970besm819327pjd.26.2022.08.17.00.29.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Aug 2022 00:29:46 -0700 (PDT)
From:   chris.chenfeiyang@gmail.com
X-Google-Original-From: chenfeiyang@loongson.cn
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com
Cc:     Feiyang Chen <chenfeiyang@loongson.cn>, zhangqing@loongson.cn,
        chenhuacai@loongson.cn, chris.chenfeiyang@gmail.com,
        netdev@vger.kernel.org, loongarch@lists.linux.dev
Subject: [PATCH v2 2/2] stmmac: pci: Add LS7A support for dwmac-loongson
Date:   Wed, 17 Aug 2022 15:29:19 +0800
Message-Id: <b530f9b0406b3e6411c193f6f1937416021465c5.1660720671.git.chenfeiyang@loongson.cn>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660720671.git.chenfeiyang@loongson.cn>
References: <cover.1660720671.git.chenfeiyang@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feiyang Chen <chenfeiyang@loongson.cn>

Current dwmac-loongson only support LS2K in the "probed with PCI and
configured with DT" manner. We add LS7A support on which the devices
are fully PCI (non-DT).

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
---
 .../ethernet/stmicro/stmmac/dwmac-loongson.c  | 177 ++++++++++++------
 1 file changed, 124 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index 017dbbda0c1c..3cf1ae49206b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -9,14 +9,22 @@
 #include <linux/of_irq.h>
 #include "stmmac.h"
 
-static int loongson_default_data(struct plat_stmmacenet_data *plat)
+struct stmmac_pci_info {
+	int (*setup)(struct pci_dev *pdev, struct plat_stmmacenet_data *plat);
+};
+
+static void common_default_data(struct pci_dev *pdev,
+				struct plat_stmmacenet_data *plat)
 {
+	plat->bus_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
+	plat->interface = PHY_INTERFACE_MODE_GMII;
+
 	plat->clk_csr = 2;	/* clk_csr_i = 20-35MHz & MDC = clk_csr_i/16 */
 	plat->has_gmac = 1;
 	plat->force_sf_dma_mode = 1;
 
 	/* Set default value for multicast hash bins */
-	plat->multicast_filter_bins = HASH_TABLE_SIZE;
+	plat->multicast_filter_bins = 256;
 
 	/* Set default value for unicast filter entries */
 	plat->unicast_filter_entries = 1;
@@ -35,32 +43,81 @@ static int loongson_default_data(struct plat_stmmacenet_data *plat)
 	/* Disable RX queues routing by default */
 	plat->rx_queues_cfg[0].pkt_route = 0x0;
 
-	/* Default to phy auto-detection */
-	plat->phy_addr = -1;
-
 	plat->dma_cfg->pbl = 32;
 	plat->dma_cfg->pblx8 = true;
 
-	plat->multicast_filter_bins = 256;
+	plat->clk_ref_rate = 125000000;
+	plat->clk_ptp_rate = 125000000;
+}
+
+static int loongson_gmac_data(struct pci_dev *pdev,
+			      struct plat_stmmacenet_data *plat)
+{
+	common_default_data(pdev, plat);
+
+	plat->mdio_bus_data->phy_mask = 0;
+
+	plat->phy_addr = -1;
+	plat->phy_interface = PHY_INTERFACE_MODE_RGMII_ID;
+
+	stmmac_flow_ctrl = FLOW_OFF;
+
 	return 0;
 }
 
-static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static struct stmmac_pci_info loongson_gmac_pci_info = {
+	.setup = loongson_gmac_data,
+};
+
+static void loongson_gnet_fix_speed(void *priv, unsigned int speed)
+{
+	struct net_device *ndev = (struct net_device *)(*(unsigned long *)priv);
+	struct stmmac_priv *ptr = netdev_priv(ndev);
+
+	if (speed == SPEED_1000) {
+		if (readl(ptr->ioaddr + MAC_CTRL_REG) & (1 << 15) /* PS */) {
+			/* reset phy */
+			phy_set_bits(ndev->phydev, 0 /*MII_BMCR*/,
+				     0x200 /*BMCR_ANRESTART*/);
+		}
+	}
+}
+
+static int loongson_gnet_data(struct pci_dev *pdev,
+			      struct plat_stmmacenet_data *plat)
+{
+	common_default_data(pdev, plat);
+
+	plat->mdio_bus_data->phy_mask = 0xfffffffb;
+
+	plat->phy_addr = 2;
+	plat->phy_interface = PHY_INTERFACE_MODE_GMII;
+
+	/* GNET 1000M speed need workaround */
+	plat->fix_mac_speed = loongson_gnet_fix_speed;
+
+	/* Get netdev pointer address */
+	plat->bsp_priv = &(pdev->dev.driver_data);
+
+	return 0;
+}
+
+static struct stmmac_pci_info loongson_gnet_pci_info = {
+	.setup = loongson_gnet_data,
+};
+
+static int loongson_dwmac_probe(struct pci_dev *pdev,
+				const struct pci_device_id *id)
 {
 	struct plat_stmmacenet_data *plat;
+	struct stmmac_pci_info *info;
 	struct stmmac_resources res;
 	struct device_node *np;
-	int ret, i, phy_mode;
+	int ret, i, bus_id, phy_mode;
 	bool mdio = false;
 
 	np = dev_of_node(&pdev->dev);
-
-	if (!np) {
-		pr_info("dwmac_loongson_pci: No OF node\n");
-		return -ENODEV;
-	}
-
-	if (!of_device_is_compatible(np, "loongson, pci-gmac")) {
+	if (np && !of_device_is_compatible(np, "loongson, pci-gmac")) {
 		pr_info("dwmac_loongson_pci: Incompatible OF node\n");
 		return -ENODEV;
 	}
@@ -74,14 +131,14 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 		mdio = true;
 	}
 
-	if (mdio) {
-		plat->mdio_bus_data = devm_kzalloc(&pdev->dev,
-						   sizeof(*plat->mdio_bus_data),
-						   GFP_KERNEL);
-		if (!plat->mdio_bus_data)
-			return -ENOMEM;
+	plat->mdio_bus_data = devm_kzalloc(&pdev->dev,
+					   sizeof(*plat->mdio_bus_data),
+					   GFP_KERNEL);
+	if (!plat->mdio_bus_data)
+		return -ENOMEM;
+
+	if (mdio)
 		plat->mdio_bus_data->needs_reset = true;
-	}
 
 	plat->dma_cfg = devm_kzalloc(&pdev->dev, sizeof(*plat->dma_cfg), GFP_KERNEL);
 	if (!plat->dma_cfg)
@@ -104,42 +161,52 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 		break;
 	}
 
-	plat->bus_id = of_alias_get_id(np, "ethernet");
-	if (plat->bus_id < 0)
-		plat->bus_id = pci_dev_id(pdev);
-
-	phy_mode = device_get_phy_mode(&pdev->dev);
-	if (phy_mode < 0) {
-		dev_err(&pdev->dev, "phy_mode not found\n");
-		return phy_mode;
-	}
-
-	plat->phy_interface = phy_mode;
-	plat->interface = PHY_INTERFACE_MODE_GMII;
-
 	pci_set_master(pdev);
 
-	loongson_default_data(plat);
-	pci_enable_msi(pdev);
-	memset(&res, 0, sizeof(res));
-	res.addr = pcim_iomap_table(pdev)[0];
+	info = (struct stmmac_pci_info *)id->driver_data;
+	ret = info->setup(pdev, plat);
+	if (ret)
+		return ret;
 
-	res.irq = of_irq_get_byname(np, "macirq");
-	if (res.irq < 0) {
-		dev_err(&pdev->dev, "IRQ macirq not found\n");
-		ret = -ENODEV;
+	if (np) {
+		bus_id = of_alias_get_id(np, "ethernet");
+		if (bus_id >= 0)
+			plat->bus_id = bus_id;
+
+		phy_mode = device_get_phy_mode(&pdev->dev);
+		if (phy_mode < 0) {
+			dev_err(&pdev->dev, "phy_mode not found\n");
+			return phy_mode;
+		}
+		plat->phy_interface = phy_mode;
 	}
 
-	res.wol_irq = of_irq_get_byname(np, "eth_wake_irq");
-	if (res.wol_irq < 0) {
-		dev_info(&pdev->dev, "IRQ eth_wake_irq not found, using macirq\n");
-		res.wol_irq = res.irq;
-	}
+	pci_enable_msi(pdev);
 
-	res.lpi_irq = of_irq_get_byname(np, "eth_lpi");
-	if (res.lpi_irq < 0) {
-		dev_err(&pdev->dev, "IRQ eth_lpi not found\n");
-		ret = -ENODEV;
+	memset(&res, 0, sizeof(res));
+	res.addr = pcim_iomap_table(pdev)[0];
+	if (np) {
+		res.irq = of_irq_get_byname(np, "macirq");
+		if (res.irq < 0) {
+			dev_err(&pdev->dev, "IRQ macirq not found\n");
+			ret = -ENODEV;
+		}
+
+		res.wol_irq = of_irq_get_byname(np, "eth_wake_irq");
+		if (res.wol_irq < 0) {
+			dev_info(&pdev->dev,
+				 "IRQ eth_wake_irq not found, using macirq\n");
+			res.wol_irq = res.irq;
+		}
+
+		res.lpi_irq = of_irq_get_byname(np, "eth_lpi");
+		if (res.lpi_irq < 0) {
+			dev_err(&pdev->dev, "IRQ eth_lpi not found\n");
+			ret = -ENODEV;
+		}
+	} else {
+		res.irq = pdev->irq;
+		res.wol_irq = pdev->irq;
 	}
 
 	return stmmac_dvr_probe(&pdev->dev, plat, &res);
@@ -199,8 +266,12 @@ static int __maybe_unused loongson_dwmac_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(loongson_dwmac_pm_ops, loongson_dwmac_suspend,
 			 loongson_dwmac_resume);
 
+#define PCI_DEVICE_ID_LOONGSON_GMAC	0x7a03
+#define PCI_DEVICE_ID_LOONGSON_GNET	0x7a13
+
 static const struct pci_device_id loongson_dwmac_id_table[] = {
-	{ PCI_VDEVICE(LOONGSON, 0x7a03) },
+	{ PCI_DEVICE_DATA(LOONGSON, GMAC, &loongson_gmac_pci_info) },
+	{ PCI_DEVICE_DATA(LOONGSON, GNET, &loongson_gnet_pci_info) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, loongson_dwmac_id_table);
-- 
2.31.1

