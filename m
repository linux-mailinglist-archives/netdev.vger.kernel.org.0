Return-Path: <netdev+bounces-5287-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 551A1710991
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 108E72814EA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D16E570;
	Thu, 25 May 2023 10:11:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CCBE561
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:11:40 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B274C198;
	Thu, 25 May 2023 03:11:38 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685009497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x99islmyr57LN2jiggDr29/CR+Lb1DGSKfUWAveNjOs=;
	b=meM9w7WNxgWXOAIXPrwB4q5jdh1rNXyurhBMn8ZlBbu7mJXl/8CO+GM0scyp94N9H1UNZ0
	w5b9Ddt+cRudVwXtM5ztxixITvn+tZcwdKNPqKUOIsY/v4IpIcFdqriZk+S/aCkG4n/VcC
	1krlnJr/GUKUC9Th38A1HHP3LCUF70nAqJFWruZz04/3fVHNlT3/S+FoLGhn20f4J1Hurd
	w4sboYEmC5q6OHtXjwqgb3abtBZIVE5ZT1fqlAky35A7dtCkX7ZDrhmpvRktnnQeT9AzjZ
	gpGh3yaCD31Jg0dJX+j59tk9xFzjn3iU0fme0Bk3kWikHfEpYG6ZGKh98BSWQg==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id C235EC000E;
	Thu, 25 May 2023 10:11:34 +0000 (UTC)
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Mark Brown <broonie@kernel.org>,
	davem@davemloft.net
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com,
	thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH net-next v2 2/4] net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx
Date: Thu, 25 May 2023 12:11:24 +0200
Message-Id: <20230525101126.370108-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525101126.370108-1-maxime.chevallier@bootlin.com>
References: <20230525101126.370108-1-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The newly introduced regmap-based MDIO driver allows for an easy mapping
of an mdiodevice onto the memory-mapped TSE PCS, which is actually a
Lynx PCS.

Convert Altera TSE to use this PCS instead of the pcs-altera-tse, which
is nothing more than a memory-mapped Lynx PCS.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V1->V2 : No changes

 drivers/net/ethernet/altera/altera_tse.h      |  1 +
 drivers/net/ethernet/altera/altera_tse_main.c | 57 +++++++++++++++++--
 include/linux/mdio/mdio-regmap.h              |  2 +
 3 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
index db5eed06e92d..d50cf440d01b 100644
--- a/drivers/net/ethernet/altera/altera_tse.h
+++ b/drivers/net/ethernet/altera/altera_tse.h
@@ -477,6 +477,7 @@ struct altera_tse_private {
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
 	struct phylink_pcs *pcs;
+	struct mdio_device *pcs_mdiodev;
 };
 
 /* Function prototypes
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 190ff1bcd94e..66db6a7d0b22 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -27,14 +27,16 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mii.h>
+#include <linux/mdio/mdio-regmap.h>
 #include <linux/netdevice.h>
 #include <linux/of_device.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
-#include <linux/pcs-altera-tse.h>
+#include <linux/pcs-lynx.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/skbuff.h>
 #include <asm/cacheflush.h>
 
@@ -1134,13 +1136,21 @@ static int altera_tse_probe(struct platform_device *pdev)
 	const struct of_device_id *of_id = NULL;
 	struct altera_tse_private *priv;
 	struct resource *control_port;
+	struct regmap *pcs_regmap;
 	struct resource *dma_res;
 	struct resource *pcs_res;
+	struct mii_bus *pcs_bus;
 	struct net_device *ndev;
 	void __iomem *descmap;
-	int pcs_reg_width = 2;
 	int ret = -ENODEV;
 
+	struct regmap_config pcs_regmap_cfg;
+
+	struct mdio_regmap_config mrc = {
+		.parent = &pdev->dev,
+		.valid_addr = 0x0,
+	};
+
 	ndev = alloc_etherdev(sizeof(struct altera_tse_private));
 	if (!ndev) {
 		dev_err(&pdev->dev, "Could not allocate network device\n");
@@ -1258,10 +1268,29 @@ static int altera_tse_probe(struct platform_device *pdev)
 	ret = request_and_map(pdev, "pcs", &pcs_res,
 			      &priv->pcs_base);
 	if (ret) {
+		/* If we can't find a dedicated resource for the PCS, fallback
+		 * to the internal PCS, that has a different address stride
+		 */
 		priv->pcs_base = priv->mac_dev + tse_csroffs(mdio_phy0);
-		pcs_reg_width = 4;
+		pcs_regmap_cfg.reg_bits = 32;
+		/* Values are MDIO-like values, on 16 bits */
+		pcs_regmap_cfg.val_bits = 16;
+		pcs_regmap_cfg.reg_shift = REGMAP_UPSHIFT(2);
+	} else {
+		pcs_regmap_cfg.reg_bits = 16;
+		pcs_regmap_cfg.val_bits = 16;
+		pcs_regmap_cfg.reg_shift = REGMAP_UPSHIFT(1);
 	}
 
+	/* Create a regmap for the PCS so that it can be used by the PCS driver */
+	pcs_regmap = devm_regmap_init_mmio(&pdev->dev, priv->pcs_base,
+					   &pcs_regmap_cfg);
+	if (IS_ERR(pcs_regmap)) {
+		ret = PTR_ERR(pcs_regmap);
+		goto err_free_netdev;
+	}
+	mrc.regmap = pcs_regmap;
+
 	/* Rx IRQ */
 	priv->rx_irq = platform_get_irq_byname(pdev, "rx_irq");
 	if (priv->rx_irq == -ENXIO) {
@@ -1384,7 +1413,20 @@ static int altera_tse_probe(struct platform_device *pdev)
 			 (unsigned long) control_port->start, priv->rx_irq,
 			 priv->tx_irq);
 
-	priv->pcs = alt_tse_pcs_create(ndev, priv->pcs_base, pcs_reg_width);
+	snprintf(mrc.name, MII_BUS_ID_SIZE, "%s-pcs-mii", ndev->name);
+	pcs_bus = devm_mdio_regmap_register(&pdev->dev, &mrc);
+	if (IS_ERR(pcs_bus)) {
+		ret = PTR_ERR(pcs_bus);
+		goto err_init_phy;
+	}
+
+	priv->pcs_mdiodev = mdio_device_create(pcs_bus, 0);
+
+	priv->pcs = lynx_pcs_create(priv->pcs_mdiodev);
+	if (!priv->pcs) {
+		ret = -ENODEV;
+		goto err_init_phy;
+	}
 
 	priv->phylink_config.dev = &ndev->dev;
 	priv->phylink_config.type = PHYLINK_NETDEV;
@@ -1407,11 +1449,12 @@ static int altera_tse_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->phylink)) {
 		dev_err(&pdev->dev, "failed to create phylink\n");
 		ret = PTR_ERR(priv->phylink);
-		goto err_init_phy;
+		goto err_pcs;
 	}
 
 	return 0;
-
+err_pcs:
+	mdio_device_free(priv->pcs_mdiodev);
 err_init_phy:
 	unregister_netdev(ndev);
 err_register_netdev:
@@ -1433,6 +1476,8 @@ static int altera_tse_remove(struct platform_device *pdev)
 	altera_tse_mdio_destroy(ndev);
 	unregister_netdev(ndev);
 	phylink_destroy(priv->phylink);
+	mdio_device_free(priv->pcs_mdiodev);
+
 	free_netdev(ndev);
 
 	return 0;
diff --git a/include/linux/mdio/mdio-regmap.h b/include/linux/mdio/mdio-regmap.h
index b8508f152552..679d9069846b 100644
--- a/include/linux/mdio/mdio-regmap.h
+++ b/include/linux/mdio/mdio-regmap.h
@@ -7,6 +7,8 @@
 #ifndef MDIO_REGMAP_H
 #define MDIO_REGMAP_H
 
+#include <linux/phy.h>
+
 struct device;
 struct regmap;
 
-- 
2.40.1


