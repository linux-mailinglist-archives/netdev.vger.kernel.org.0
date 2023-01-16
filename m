Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0508666BE75
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 13:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbjAPM6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 07:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjAPM46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 07:56:58 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B781F91B;
        Mon, 16 Jan 2023 04:55:45 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id D9DE016F2;
        Mon, 16 Jan 2023 13:55:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673873739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N/4W4B+W4pbypXR0XLXo8vwK/KzTHK+Yr6B7LFX8zfE=;
        b=xmPF+pbQnuFJOIntAfRbp9TykBDBlvpixmjoiiWQ1ZmDbGhat5vqpLYOEh8b0FThavc0Hp
        XQmq5Zs+X+BSLhhO7tisGY1ZyxhoyWi+gz2tHrj28iKFKYNmFm8bCBasoF0aAV/ZyYZ79a
        4IYKgYHHAzbPN54vhPfSQbf7VQ0DeWm7Y/mPClv6SFdDFyQEDb2NnvAjpNzYFqn4ICwqgb
        A2EVliCxWfRccD+6tIO+yyyhMucYX+KVvjH8ElwfZH/YgPNnuNB8FIe+CwO0xP3EgD7VfK
        cUMALh+rWueQwiQjMXst9NEXnuW4FLyXKQpKRxSqLV+CB0Rrz7B3kkzBIN7buw==
From:   Michael Walle <michael@walle.cc>
Date:   Mon, 16 Jan 2023 13:55:18 +0100
Subject: [PATCH net-next 6/6] net: phy: Remove probe_capabilities
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230116-net-next-remove-probe-capabilities-v1-6-5aa29738a023@walle.cc>
References: <20230116-net-next-remove-probe-capabilities-v1-0-5aa29738a023@walle.cc>
In-Reply-To: <20230116-net-next-remove-probe-capabilities-v1-0-5aa29738a023@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-aspeed@lists.ozlabs.org, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

Deciding if to probe of PHYs using C45 is now determine by if the bus
provides the C45 read method. This makes probe_capabilities redundant
so remove it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/adi/adin1110.c               | 1 -
 drivers/net/ethernet/freescale/xgmac_mdio.c       | 1 -
 drivers/net/ethernet/mediatek/mtk_eth_soc.c       | 1 -
 drivers/net/ethernet/microchip/lan743x_main.c     | 2 --
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 3 ---
 drivers/net/mdio/mdio-aspeed.c                    | 1 -
 include/linux/phy.h                               | 8 --------
 7 files changed, 17 deletions(-)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 0805f249fff2..25f55756681d 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -523,7 +523,6 @@ static int adin1110_register_mdiobus(struct adin1110_priv *priv,
 	mii_bus->priv = priv;
 	mii_bus->parent = dev;
 	mii_bus->phy_mask = ~((u32)GENMASK(2, 0));
-	mii_bus->probe_capabilities = MDIOBUS_C22;
 	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
 
 	ret = devm_mdiobus_register(dev, mii_bus);
diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 8b5a4cd8ff08..a13b4ba4d6e1 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -397,7 +397,6 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	bus->read_c45 = xgmac_mdio_read_c45;
 	bus->write_c45 = xgmac_mdio_write_c45;
 	bus->parent = &pdev->dev;
-	bus->probe_capabilities = MDIOBUS_C22_C45;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%pa", &res->start);
 
 	priv = bus->priv;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index dc50e0b227a6..d67ec28b2ba3 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -808,7 +808,6 @@ static int mtk_mdio_init(struct mtk_eth *eth)
 	eth->mii_bus->write = mtk_mdio_write_c22;
 	eth->mii_bus->read_c45 = mtk_mdio_read_c45;
 	eth->mii_bus->write_c45 = mtk_mdio_write_c45;
-	eth->mii_bus->probe_capabilities = MDIOBUS_C22_C45;
 	eth->mii_bus->priv = eth;
 	eth->mii_bus->parent = eth->dev;
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index e205edf477de..86b81df374da 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3279,7 +3279,6 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
 			netif_dbg(adapter, drv, adapter->netdev,
 				  "SGMII operation\n");
-			adapter->mdiobus->probe_capabilities = MDIOBUS_C22_C45;
 			adapter->mdiobus->read = lan743x_mdiobus_read_c22;
 			adapter->mdiobus->write = lan743x_mdiobus_write_c22;
 			adapter->mdiobus->read_c45 = lan743x_mdiobus_read_c45;
@@ -3295,7 +3294,6 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 			netif_dbg(adapter, drv, adapter->netdev,
 				  "RGMII operation\n");
 			// Only C22 support when RGMII I/F
-			adapter->mdiobus->probe_capabilities = MDIOBUS_C22;
 			adapter->mdiobus->read = lan743x_mdiobus_read_c22;
 			adapter->mdiobus->write = lan743x_mdiobus_write_c22;
 			adapter->mdiobus->name = "lan743x-mdiobus";
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index d2cb22f49ce5..21aaa2730ac8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -553,9 +553,6 @@ int stmmac_mdio_register(struct net_device *ndev)
 
 	new_bus->name = "stmmac";
 
-	if (priv->plat->has_gmac4)
-		new_bus->probe_capabilities = MDIOBUS_C22_C45;
-
 	if (priv->plat->has_xgmac) {
 		new_bus->read = &stmmac_xgmac2_mdio_read_c22;
 		new_bus->write = &stmmac_xgmac2_mdio_write_c22;
diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index 2f4bbda5e56c..c727103c8b05 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -164,7 +164,6 @@ static int aspeed_mdio_probe(struct platform_device *pdev)
 	bus->write = aspeed_mdio_write_c22;
 	bus->read_c45 = aspeed_mdio_read_c45;
 	bus->write_c45 = aspeed_mdio_write_c45;
-	bus->probe_capabilities = MDIOBUS_C22_C45;
 
 	rc = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (rc) {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index fceaac0fb319..fbeba4fee8d4 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -419,14 +419,6 @@ struct mii_bus {
 	/** @reset_gpiod: Reset GPIO descriptor pointer */
 	struct gpio_desc *reset_gpiod;
 
-	/** @probe_capabilities: bus capabilities, used for probing */
-	enum {
-		MDIOBUS_NO_CAP = 0,
-		MDIOBUS_C22,
-		MDIOBUS_C45,
-		MDIOBUS_C22_C45,
-	} probe_capabilities;
-
 	/** @shared_lock: protect access to the shared element */
 	struct mutex shared_lock;
 

-- 
2.30.2
