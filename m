Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88155364DDB
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhDSWwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhDSWwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 18:52:20 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63683C06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 15:51:49 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t14so1401604lfe.1
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 15:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LaouYuT2TsKPl+1l/wjwTOHcDQc/paE8PY91JJJXoB0=;
        b=ln97YXHqEeq71wTi82Dthmza6hs0baNtKFANjm4RfNYK3IgHLjQcXGeXoNBczzD4RN
         S0U0bl6W0krZXujQw0fC22HjQFAu3e0awKiPf+81/QZ6LEzSaHgPEf6Pfrs/F8o/d5DU
         VSUbeWMDm4mkZy7FCIeg3lQJgA+OCetW3BT7hO3Drtk53En0LC1g3W+NqEMMmfUPSfGE
         cNkMA9tABiIV842GmJmCXz3fNgLSgjI6FXcLnr39xatKS6Pa6470hEGCChCQx4TjxTrt
         7NmeG9BKRx397kSHrpKuzw68NW75EDF2z9IfiDxNSLSl0ruJ6tXJquTjb7AgJ8App8pj
         IL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LaouYuT2TsKPl+1l/wjwTOHcDQc/paE8PY91JJJXoB0=;
        b=njs6jhVd73dbtDDRRIZ3mLciPgXh4zSeveAKxA9NSgD2UOsEomL6fP+jlkN4Vl+XVI
         9ceZ8CDKJC5Oc+9smX3FDnZ54+r1L+UT94oiVnj2EubK9VUNFb55jvYDxrsrVoHXNhZ0
         2DtBfzz9gPnP2USxOfQiOuxkAsdU4fUePGqfzHRc6OAWZfyZovrFvkDQ4qWe3za5b1jR
         1R5MEBHb4X2zaUMksaY7QuLiTbkiL1Uvu9J7a009zOOoZJ/xRIukXgaY8QO/PqFPdU3r
         RXMYp8oxLfklerIqHck4vnR4j67PSev+nnsMriJYR+bwSqxXnshIV2XrdE2L96RffdCN
         /fvg==
X-Gm-Message-State: AOAM5326ADJlij/e+/hwDUlg8OamSkW/K3VMFKop5pMS7N9ZoygLU3MM
        MTUsvPmwR5BOX5uwcsdv1vlQD09ZA0qSxw==
X-Google-Smtp-Source: ABdhPJy1f5mELEWNA23VbbBEIhmobDSWkDnbitbx+GSGf3AL5ztp210aIpdI+V4hucxRFA3W9HgPuQ==
X-Received: by 2002:a19:3847:: with SMTP id d7mr6972086lfj.137.1618872707691;
        Mon, 19 Apr 2021 15:51:47 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id p5sm1950179lfg.183.2021.04.19.15.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 15:51:47 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>
Subject: [PATCH 2/3] net: ethernet: ixp4xx: Support device tree probing
Date:   Tue, 20 Apr 2021 00:51:32 +0200
Message-Id: <20210419225133.2005360-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210419225133.2005360-1-linus.walleij@linaro.org>
References: <20210419225133.2005360-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds device tree probing to the IXP4xx ethernet
driver.

Add a platform data bool to tell us whether to
register an MDIO bus for the device or not, as well
as the corresponding NPE.

We need to drop the memory region request as part of
this since the OF core will request the memory for the
device.

Cc: Zoltan HERPAI <wigyori@uid0.hu>
Cc: Raylynn Knight <rayknight@me.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Do not rely on earlier attempt for identifying which
  ports to use: we split the support clearly in a DT way
  and a playform data way.
- Isolate the DT code better.
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 202 ++++++++++++++++-------
 include/linux/platform_data/eth_ixp4xx.h |   2 +
 2 files changed, 148 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 9defaa21a1a9..758f820068b5 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -28,6 +28,7 @@
 #include <linux/kernel.h>
 #include <linux/net_tstamp.h>
 #include <linux/of.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_data/eth_ixp4xx.h>
 #include <linux/platform_device.h>
@@ -165,7 +166,6 @@ struct eth_regs {
 };
 
 struct port {
-	struct resource *mem_res;
 	struct eth_regs __iomem *regs;
 	struct npe *npe;
 	struct net_device *netdev;
@@ -1358,19 +1358,132 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 	.ndo_validate_addr = eth_validate_addr,
 };
 
+#ifdef CONFIG_OF
+static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct of_phandle_args queue_spec;
+	struct eth_plat_info *plat;
+	struct device_node *phy_np;
+	struct device_node *mdio_np;
+	u32 val;
+	int ret;
+
+	plat = devm_kzalloc(dev, sizeof(*plat), GFP_KERNEL);
+	if (!plat)
+		return NULL;
+
+	ret = of_property_read_u32(np, "intel,npe", &val);
+	if (ret) {
+		dev_err(dev, "no NPE engine specified\n");
+		return NULL;
+	}
+	/* NPE ID 0x00, 0x10, 0x20... */
+	plat->npe = (val << 4);
+
+	phy_np = of_parse_phandle(np, "phy-handle", 0);
+	if (phy_np) {
+		ret = of_property_read_u32(phy_np, "reg", &val);
+		if (ret) {
+			dev_err(dev, "cannot find phy reg\n");
+			return NULL;
+		}
+		of_node_put(phy_np);
+	} else {
+		dev_err(dev, "cannot find phy instance\n");
+		val = 0;
+	}
+	plat->phy = val;
+
+	/* Check if this device has an MDIO bus */
+	mdio_np = of_get_child_by_name(np, "mdio");
+	if (mdio_np) {
+		plat->has_mdio = true;
+		of_node_put(mdio_np);
+	}
+
+	/* Get the rx queue as a resource from queue manager */
+	ret = of_parse_phandle_with_fixed_args(np, "queue-rx", 1, 0,
+					       &queue_spec);
+	if (ret) {
+		dev_err(dev, "no rx queue phandle\n");
+		return NULL;
+	}
+	plat->rxq = queue_spec.args[0];
+
+	/* Get the txready queue as resource from queue manager */
+	ret = of_parse_phandle_with_fixed_args(np, "queue-txready", 1, 0,
+					       &queue_spec);
+	if (ret) {
+		dev_err(dev, "no txready queue phandle\n");
+		return NULL;
+	}
+	plat->txreadyq = queue_spec.args[0];
+
+	return plat;
+}
+#else
+static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
+{
+	return NULL;
+}
+#endif
+
 static int ixp4xx_eth_probe(struct platform_device *pdev)
 {
 	char phy_id[MII_BUS_ID_SIZE + 3];
 	struct phy_device *phydev = NULL;
 	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
 	struct eth_plat_info *plat;
-	resource_size_t regs_phys;
 	struct net_device *ndev;
 	struct resource *res;
 	struct port *port;
 	int err;
 
-	plat = dev_get_platdata(dev);
+	if (np) {
+		plat = ixp4xx_of_get_platdata(dev);
+		if (!plat)
+			return -ENODEV;
+	} else {
+		plat = dev_get_platdata(dev);
+		if (!plat)
+			return -ENODEV;
+		plat->npe = pdev->id;
+		switch (plat->npe) {
+		case IXP4XX_ETH_NPEA:
+			/* If the MDIO bus is not up yet, defer probe */
+			break;
+		case IXP4XX_ETH_NPEB:
+			/* On all except IXP43x, NPE-B is used for the MDIO bus.
+			 * If there is no NPE-B in the feature set, bail out,
+			 * else we have the MDIO bus here.
+			 */
+			if (!cpu_is_ixp43x()) {
+				if (!(ixp4xx_read_feature_bits() &
+				      IXP4XX_FEATURE_NPEB_ETH0))
+					return -ENODEV;
+				/* Else register the MDIO bus on NPE-B */
+				plat->has_mdio = true;
+			}
+			break;
+		case IXP4XX_ETH_NPEC:
+			/* IXP43x lacks NPE-B and uses NPE-C for the MDIO bus
+			 * access, if there is no NPE-C, no bus, nothing works,
+			 * so bail out.
+			 */
+			if (cpu_is_ixp43x()) {
+				if (!(ixp4xx_read_feature_bits() &
+				      IXP4XX_FEATURE_NPEC_ETH))
+					return -ENODEV;
+				/* Else register the MDIO bus on NPE-B */
+				plat->has_mdio = true;
+			}
+			break;
+		default:
+			return -ENODEV;
+		}
+	}
 
 	if (!(ndev = devm_alloc_etherdev(dev, sizeof(struct port))))
 		return -ENOMEM;
@@ -1378,59 +1491,29 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, dev);
 	port = netdev_priv(ndev);
 	port->netdev = ndev;
-	port->id = pdev->id;
+	port->id = plat->npe;
 
 	/* Get the port resource and remap */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
-	regs_phys = res->start;
 	port->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(port->regs))
 		return PTR_ERR(port->regs);
 
-	switch (port->id) {
-	case IXP4XX_ETH_NPEA:
-		/* If the MDIO bus is not up yet, defer probe */
-		if (!mdio_bus)
-			return -EPROBE_DEFER;
-		break;
-	case IXP4XX_ETH_NPEB:
-		/*
-		 * On all except IXP43x, NPE-B is used for the MDIO bus.
-		 * If there is no NPE-B in the feature set, bail out, else
-		 * register the MDIO bus.
-		 */
-		if (!cpu_is_ixp43x()) {
-			if (!(ixp4xx_read_feature_bits() &
-			      IXP4XX_FEATURE_NPEB_ETH0))
-				return -ENODEV;
-			/* Else register the MDIO bus on NPE-B */
-			if ((err = ixp4xx_mdio_register(port->regs)))
-				return err;
-		}
-		if (!mdio_bus)
-			return -EPROBE_DEFER;
-		break;
-	case IXP4XX_ETH_NPEC:
-		/*
-		 * IXP43x lacks NPE-B and uses NPE-C for the MDIO bus access,
-		 * of there is no NPE-C, no bus, nothing works, so bail out.
-		 */
-		if (cpu_is_ixp43x()) {
-			if (!(ixp4xx_read_feature_bits() &
-			      IXP4XX_FEATURE_NPEC_ETH))
-				return -ENODEV;
-			/* Else register the MDIO bus on NPE-C */
-			if ((err = ixp4xx_mdio_register(port->regs)))
-				return err;
+	/* Register the MDIO bus if we have it */
+	if (plat->has_mdio) {
+		err = ixp4xx_mdio_register(port->regs);
+		if (err) {
+			dev_err(dev, "failed to register MDIO bus\n");
+			return err;
 		}
-		if (!mdio_bus)
-			return -EPROBE_DEFER;
-		break;
-	default:
-		return -ENODEV;
 	}
+	/* If the instance with the MDIO bus has not yet appeared,
+	 * defer probing until it gets probed.
+	 */
+	if (!mdio_bus)
+		return -EPROBE_DEFER;
 
 	ndev->netdev_ops = &ixp4xx_netdev_ops;
 	ndev->ethtool_ops = &ixp4xx_ethtool_ops;
@@ -1444,12 +1527,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	if (!(port->npe = npe_request(NPE_ID(port->id))))
 		return -EIO;
 
-	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, ndev->name);
-	if (!port->mem_res) {
-		err = -EBUSY;
-		goto err_npe_rel;
-	}
-
 	port->plat = plat;
 	npe_port_tab[NPE_ID(port->id)] = port;
 	memcpy(ndev->dev_addr, plat->hwaddr, ETH_ALEN);
@@ -1463,11 +1540,17 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	udelay(50);
 
 	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
-		mdio_bus->id, plat->phy);
+		 mdio_bus->id, plat->phy);
 	phydev = phy_connect(ndev, phy_id, &ixp4xx_adjust_link,
 			     PHY_INTERFACE_MODE_MII);
+	if (!phydev) {
+		err = -ENODEV;
+		dev_err(dev, "no phydev\n");
+		goto err_free_mem;
+	}
 	if (IS_ERR(phydev)) {
 		err = PTR_ERR(phydev);
+		dev_err(dev, "could not connect phydev (%d)\n", err);
 		goto err_free_mem;
 	}
 
@@ -1485,8 +1568,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	phy_disconnect(phydev);
 err_free_mem:
 	npe_port_tab[NPE_ID(port->id)] = NULL;
-	release_resource(port->mem_res);
-err_npe_rel:
 	npe_release(port->npe);
 	return err;
 }
@@ -1502,12 +1583,21 @@ static int ixp4xx_eth_remove(struct platform_device *pdev)
 	ixp4xx_mdio_remove();
 	npe_port_tab[NPE_ID(port->id)] = NULL;
 	npe_release(port->npe);
-	release_resource(port->mem_res);
 	return 0;
 }
 
+static const struct of_device_id ixp4xx_eth_of_match[] = {
+	{
+		.compatible = "intel,ixp4xx-ethernet",
+	},
+	{ },
+};
+
 static struct platform_driver ixp4xx_eth_driver = {
-	.driver.name	= DRV_NAME,
+	.driver = {
+		.name = DRV_NAME,
+		.of_match_table = of_match_ptr(ixp4xx_eth_of_match),
+	},
 	.probe		= ixp4xx_eth_probe,
 	.remove		= ixp4xx_eth_remove,
 };
diff --git a/include/linux/platform_data/eth_ixp4xx.h b/include/linux/platform_data/eth_ixp4xx.h
index 6f652ea0c6ae..114b0940729f 100644
--- a/include/linux/platform_data/eth_ixp4xx.h
+++ b/include/linux/platform_data/eth_ixp4xx.h
@@ -14,6 +14,8 @@ struct eth_plat_info {
 	u8 rxq;		/* configurable, currently 0 - 31 only */
 	u8 txreadyq;
 	u8 hwaddr[6];
+	u8 npe;		/* NPE instance used by this interface */
+	bool has_mdio;	/* If this instance has an MDIO bus */
 };
 
 #endif
-- 
2.29.2

