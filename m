Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03EFE13F053
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436581AbgAPSUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:20:47 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32942 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436577AbgAPSUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:20:46 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay11so8679526plb.0
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 10:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=stscByNiGsXnAo+DzaaEaCRJfO+2+1FyNAx7j/s4PNE=;
        b=WUpzP1rOTh7lP2/Usmu3ydUMGJCcpsuZvTLPaWrrsH4fN5GevCv1gqnDAe/7l2B5CA
         MkELxB5o6GxMR8rZ6vi2KWKsV/EHDfRa5Ifl8yok9A5FEMnaJ5vNBitOPrRv2/xgIWjE
         DLhBUWFlVZjGBVOe3WlRZ8StnErdOlbzr7XD5fo8Z88Wc9on2QPbUsMe/V2YkZSdylKa
         gDDg6UMNH9TJ19O1ihYbtJWdhtk9M+AMUase0qWbMdLhl7odPiVOpK2C7LYA7Djz0lvA
         y+bGAenH2kLw9h0yB8pDC+P3JlKKe1eUvMy9InmliyTF9cQJxc0ObVd+w1e/mL/EOnA/
         YK9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=stscByNiGsXnAo+DzaaEaCRJfO+2+1FyNAx7j/s4PNE=;
        b=hmwtb0zpT41MuECOzuVQJdYY1+Ynku/wjiVHP/tKf4DUf5/PpVyXmF6Xhub2q3bAmG
         gUBQno8xlCdYzxPv4hfA79HM6nkuzRS+Vpvgys7JFTYkz1IvuuBaAPqVi766HQ9tK1mq
         SJloltq0zMdNki19NwMTg3FDYKSZhbqmUxYvMId7aSveeXJh5p5yAvCzk8/2+ARmSRCx
         uJabLzk/bwvTPrSZ75uEHa0mSPr9Ug3GBCEWdmQ/dM7Cj8Okutbo9w2n8nbV1XuSRz1R
         iU2BUdP3mXk4E+ST2qgVvsg67QChtyrRPWIKRWPgEcLFidLe+vydMZQm39HXe4D/1B2P
         F60g==
X-Gm-Message-State: APjAAAUuvKtyy5rGYTxYujglIrpAZ24Jw+LVL2S2+f5xj0MkwgzxmsSZ
        QkzW1NgquURULSDbKCK9xkBdnTWk
X-Google-Smtp-Source: APXvYqxvYSbrLp04d9USTjpBOSBJwrH3JucOm+8QUkZ0ileMRzcGmImvihuXVAKlFyhDnWOGPxF/iQ==
X-Received: by 2002:a17:90b:3cc:: with SMTP id go12mr457130pjb.89.1579198845542;
        Thu, 16 Jan 2020 10:20:45 -0800 (PST)
Received: from ajayg.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id a17sm4405618pjv.6.2020.01.16.10.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 10:20:45 -0800 (PST)
From:   Ajay Gupta <ajaykuee@gmail.com>
X-Google-Original-From: Ajay Gupta <ajayg@nvidia.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, treding@nvidia.com,
        Ajay Gupta <ajayg@nvidia.com>
Subject: [PATCH] net: stmmac: platform: use generic device api
Date:   Wed, 15 Jan 2020 16:56:45 -0800
Message-Id: <20200116005645.14026-1-ajayg@nvidia.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Gupta <ajayg@nvidia.com>

Use generic device api to allow reading more configuration
parameter from both DT or ACPI based devices.

Signed-off-by: Ajay Gupta <ajayg@nvidia.com>
---
ACPI support related changes for dwc were reently queued [1]
This patch is required to read more configuration parameter
through ACPI table.

[1] https://marc.info/?l=linux-netdev&m=157661974305024&w=2

 .../ethernet/stmicro/stmmac/stmmac_platform.c | 49 +++++++++++--------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 4775f49d7f3b..0532e7258064 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -398,6 +398,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	struct device_node *np = pdev->dev.of_node;
 	struct plat_stmmacenet_data *plat;
 	struct stmmac_dma_cfg *dma_cfg;
+	struct device *dev = &pdev->dev;
 	int rc;
 
 	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
@@ -412,9 +413,9 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		*mac = NULL;
 	}
 
-	rc = of_get_phy_mode(np, &plat->phy_interface);
-	if (rc)
-		return ERR_PTR(rc);
+	plat->phy_interface = device_get_phy_mode(dev);
+	if (plat->phy_interface < 0)
+		return ERR_PTR(plat->phy_interface);
 
 	plat->interface = stmmac_of_get_mac_mode(np);
 	if (plat->interface < 0)
@@ -428,7 +429,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	plat->phylink_node = np;
 
 	/* Get max speed of operation from device tree */
-	if (of_property_read_u32(np, "max-speed", &plat->max_speed))
+	if (device_property_read_u32(dev, "max-speed", &plat->max_speed))
 		plat->max_speed = -1;
 
 	plat->bus_id = of_alias_get_id(np, "ethernet");
@@ -442,12 +443,13 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	 * or get clk_csr from device tree.
 	 */
 	plat->clk_csr = -1;
-	of_property_read_u32(np, "clk_csr", &plat->clk_csr);
+	device_property_read_u32(dev, "clk_csr", &plat->clk_csr);
 
 	/* "snps,phy-addr" is not a standard property. Mark it as deprecated
 	 * and warn of its use. Remove this when phy node support is added.
 	 */
-	if (of_property_read_u32(np, "snps,phy-addr", &plat->phy_addr) == 0)
+	if (device_property_read_u32(dev, "snps,phy-addr", &plat->phy_addr)
+			== 0)
 		dev_warn(&pdev->dev, "snps,phy-addr property is deprecated\n");
 
 	/* To Configure PHY by using all device-tree supported properties */
@@ -455,15 +457,15 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	if (rc)
 		return ERR_PTR(rc);
 
-	of_property_read_u32(np, "tx-fifo-depth", &plat->tx_fifo_size);
+	device_property_read_u32(dev, "tx-fifo-depth", &plat->tx_fifo_size);
 
-	of_property_read_u32(np, "rx-fifo-depth", &plat->rx_fifo_size);
+	device_property_read_u32(dev, "rx-fifo-depth", &plat->rx_fifo_size);
 
 	plat->force_sf_dma_mode =
-		of_property_read_bool(np, "snps,force_sf_dma_mode");
+		device_property_read_bool(dev, "snps,force_sf_dma_mode");
 
 	plat->en_tx_lpi_clockgating =
-		of_property_read_bool(np, "snps,en-tx-lpi-clockgating");
+		device_property_read_bool(dev, "snps,en-tx-lpi-clockgating");
 
 	/* Set the maxmtu to a default of JUMBO_LEN in case the
 	 * parameter is not present in the device tree.
@@ -535,25 +537,30 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	}
 	plat->dma_cfg = dma_cfg;
 
-	of_property_read_u32(np, "snps,pbl", &dma_cfg->pbl);
+	device_property_read_u32(dev, "snps,pbl", &dma_cfg->pbl);
 	if (!dma_cfg->pbl)
 		dma_cfg->pbl = DEFAULT_DMA_PBL;
-	of_property_read_u32(np, "snps,txpbl", &dma_cfg->txpbl);
-	of_property_read_u32(np, "snps,rxpbl", &dma_cfg->rxpbl);
-	dma_cfg->pblx8 = !of_property_read_bool(np, "snps,no-pbl-x8");
-
-	dma_cfg->aal = of_property_read_bool(np, "snps,aal");
-	dma_cfg->fixed_burst = of_property_read_bool(np, "snps,fixed-burst");
-	dma_cfg->mixed_burst = of_property_read_bool(np, "snps,mixed-burst");
-
-	plat->force_thresh_dma_mode = of_property_read_bool(np, "snps,force_thresh_dma_mode");
+	device_property_read_u32(dev, "snps,txpbl", &dma_cfg->txpbl);
+	device_property_read_u32(dev, "snps,rxpbl", &dma_cfg->rxpbl);
+	dma_cfg->pblx8 = !device_property_read_bool(dev, "snps,no-pbl-x8");
+
+	dma_cfg->aal = device_property_read_bool(dev, "snps,aal");
+	dma_cfg->fixed_burst = device_property_read_bool(dev,
+							 "snps,fixed-burst");
+	dma_cfg->mixed_burst = device_property_read_bool(dev,
+							 "snps,mixed-burst");
+
+	plat->force_thresh_dma_mode =
+			device_property_read_bool(dev,
+						  "snps,force_thresh_dma_mode");
 	if (plat->force_thresh_dma_mode) {
 		plat->force_sf_dma_mode = 0;
 		dev_warn(&pdev->dev,
 			 "force_sf_dma_mode is ignored if force_thresh_dma_mode is set.\n");
 	}
 
-	of_property_read_u32(np, "snps,ps-speed", &plat->mac_port_sel_speed);
+	device_property_read_u32(dev, "snps,ps-speed",
+				 &plat->mac_port_sel_speed);
 
 	plat->axi = stmmac_axi_setup(pdev);
 
-- 
2.17.1

