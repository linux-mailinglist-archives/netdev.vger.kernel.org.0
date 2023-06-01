Return-Path: <netdev+bounces-7102-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD13C719F76
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:15:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 413761C208D4
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 14:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA6E221CDD;
	Thu,  1 Jun 2023 14:15:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8D921063
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 14:15:16 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43701BF;
	Thu,  1 Jun 2023 07:15:11 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685628910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FbF9YiR1UaImGOv/TekzB+7e07IepTmsR1e+tk9jk7k=;
	b=PgLJCyf/9Ceg6ezO92AoOw3M45jJiJpxeHT6se9mGNWfy3rdZ/7POe5sNa709xNJgM9D3L
	Vu0riRXXSojli6ajUMXnXhsUKuc3cfhuYodGJy2x+p9aekpxL0cznTXQ9+AJ+xMLfNR8t0
	9hx1PEtVJ5yyFQeb2K/RchX4ub+yoepPHmF+k9wUsZBclbXskih6rX7b+fB+GWBihnepW4
	VlCaEH6sjw4rJKftp0TS97MFzkjnsSdvagHUkRIITlo0d0aU6NtDg+7gkdwKry3TBvc2q1
	zkL9VhNZNeL1fgJq9mcBeHMCp//pu4B/kwrqPmshuLHcYBOZN9XP50JL2IQOzg==
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
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 219A62000A;
	Thu,  1 Jun 2023 14:15:07 +0000 (UTC)
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
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v4 2/4] net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx
Date: Thu,  1 Jun 2023 16:14:52 +0200
Message-Id: <20230601141454.67858-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601141454.67858-1-maxime.chevallier@bootlin.com>
References: <20230601141454.67858-1-maxime.chevallier@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The newly introduced regmap-based MDIO driver allows for an easy mapping
of an mdiodevice onto the memory-mapped TSE PCS, which is actually a
Lynx PCS.

Convert Altera TSE to use this PCS instead of the pcs-altera-tse, which
is nothing more than a memory-mapped Lynx PCS.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V3->V4 :
 - Use pcs_lynxcreate()/destroy() introduced by Russell
 - Fix the error path
 - Add back misplaced KConfig dependencies
V2->V3 : No changes
V1->V2 : No changes

 drivers/net/ethernet/altera/Kconfig           |  2 +
 drivers/net/ethernet/altera/altera_tse_main.c | 57 ++++++++++++++++---
 2 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/altera/Kconfig b/drivers/net/ethernet/altera/Kconfig
index dd7fd41ccde5..93533ba03429 100644
--- a/drivers/net/ethernet/altera/Kconfig
+++ b/drivers/net/ethernet/altera/Kconfig
@@ -5,6 +5,8 @@ config ALTERA_TSE
 	select PHYLIB
 	select PHYLINK
 	select PCS_ALTERA_TSE
+	select MDIO_REGMAP
+	select REGMAP_MMIO
 	help
 	  This driver supports the Altera Triple-Speed (TSE) Ethernet MAC.
 
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 190ff1bcd94e..d866c0f1b503 100644
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
 
@@ -1132,13 +1134,16 @@ static int request_and_map(struct platform_device *pdev, const char *name,
 static int altera_tse_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id = NULL;
+	struct regmap_config pcs_regmap_cfg;
 	struct altera_tse_private *priv;
+	struct mdio_regmap_config mrc;
 	struct resource *control_port;
+	struct regmap *pcs_regmap;
 	struct resource *dma_res;
 	struct resource *pcs_res;
+	struct mii_bus *pcs_bus;
 	struct net_device *ndev;
 	void __iomem *descmap;
-	int pcs_reg_width = 2;
 	int ret = -ENODEV;
 
 	ndev = alloc_etherdev(sizeof(struct altera_tse_private));
@@ -1255,12 +1260,32 @@ static int altera_tse_probe(struct platform_device *pdev)
 	 * address space, but if it's not the case, we fallback to the mdiophy0
 	 * from the MAC's address space
 	 */
-	ret = request_and_map(pdev, "pcs", &pcs_res,
-			      &priv->pcs_base);
+	ret = request_and_map(pdev, "pcs", &pcs_res, &priv->pcs_base);
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
+	}
+
+	/* Create a regmap for the PCS so that it can be used by the PCS driver */
+	pcs_regmap = devm_regmap_init_mmio(&pdev->dev, priv->pcs_base,
+					   &pcs_regmap_cfg);
+	if (IS_ERR(pcs_regmap)) {
+		ret = PTR_ERR(pcs_regmap);
+		goto err_free_netdev;
 	}
+	mrc.regmap = pcs_regmap;
+	mrc.parent = &pdev->dev;
+	mrc.valid_addr = 0x0;
 
 	/* Rx IRQ */
 	priv->rx_irq = platform_get_irq_byname(pdev, "rx_irq");
@@ -1384,7 +1409,18 @@ static int altera_tse_probe(struct platform_device *pdev)
 			 (unsigned long) control_port->start, priv->rx_irq,
 			 priv->tx_irq);
 
-	priv->pcs = alt_tse_pcs_create(ndev, priv->pcs_base, pcs_reg_width);
+	snprintf(mrc.name, MII_BUS_ID_SIZE, "%s-pcs-mii", ndev->name);
+	pcs_bus = devm_mdio_regmap_register(&pdev->dev, &mrc);
+	if (IS_ERR(pcs_bus)) {
+		ret = PTR_ERR(pcs_bus);
+		goto err_init_pcs;
+	}
+
+	priv->pcs = lynx_pcs_create_mdiodev(pcs_bus, 0);
+	if (IS_ERR(priv->pcs)) {
+		ret = PTR_ERR(priv->pcs);
+		goto err_init_pcs;
+	}
 
 	priv->phylink_config.dev = &ndev->dev;
 	priv->phylink_config.type = PHYLINK_NETDEV;
@@ -1407,12 +1443,13 @@ static int altera_tse_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->phylink)) {
 		dev_err(&pdev->dev, "failed to create phylink\n");
 		ret = PTR_ERR(priv->phylink);
-		goto err_init_phy;
+		goto err_init_phylink;
 	}
 
 	return 0;
-
-err_init_phy:
+err_init_phylink:
+	lynx_pcs_destroy(priv->pcs);
+err_init_pcs:
 	unregister_netdev(ndev);
 err_register_netdev:
 	netif_napi_del(&priv->napi);
@@ -1433,6 +1470,8 @@ static int altera_tse_remove(struct platform_device *pdev)
 	altera_tse_mdio_destroy(ndev);
 	unregister_netdev(ndev);
 	phylink_destroy(priv->phylink);
+	lynx_pcs_destroy(priv->pcs);
+
 	free_netdev(ndev);
 
 	return 0;
-- 
2.40.1


