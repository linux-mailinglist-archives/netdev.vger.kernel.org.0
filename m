Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE58B6B48CD
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 16:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbjCJPG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 10:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjCJPGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 10:06:33 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D6A26C0F;
        Fri, 10 Mar 2023 06:59:34 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id f19-20020a9d5f13000000b00693ce5a2f3eso3053323oti.8;
        Fri, 10 Mar 2023 06:59:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678460252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Siol0BKXbXdJTIj3lC8otnnA/7HJbspF3Iuig65XYfo=;
        b=n8tkLL+Wy5elZE41i+wNIN3VaWEiVcT7qo7/8bGI/gw6o3LgtEpmaMHtEA9zcXrSTy
         bTApAaajnU4b3OQMK2NQ9bTF8oAJHAAGNNXjoeY65kgEQN4icDc5I5ApMq/qt32CtNUl
         9VbU52k+VIQ+9IqSNXhLTsneaZHqaBBWojoirFA1oiyfOVENucb3DCGdvvYQjj1ccin4
         lxZgAmzNXG8fkSmqa2A3gb9J5YPe4Bui2HSf4feLhFS5CesjxXAajb1TTTLg9XC75PQo
         h4UyITtX9XK/6T26+LcW1/x34nYc09ZG2JxjPZklt19ayKeV2kMN6mA4PTM3cTJJcYuf
         7eEQ==
X-Gm-Message-State: AO0yUKWWHpMrmpwAGhNVL2f155JYdEqYXufJrI1wQfPn4GhvrXs2Kcr4
        lhgqezVstbSfO0BQU8OGCmCyGy0iTA==
X-Google-Smtp-Source: AK7set82bK+DCb6HkLyh9PPuqHg2n52w1M30t6Sf+VNlG0JPxQvhh/HoCxYFawXdJvHz/XmevzbyRw==
X-Received: by 2002:a05:6871:71e:b0:176:3c95:e94f with SMTP id f30-20020a056871071e00b001763c95e94fmr16647092oap.20.1678459727966;
        Fri, 10 Mar 2023 06:48:47 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id h4-20020a05687003c400b0017703cd8ff6sm122056oaf.7.2023.03.10.06.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 06:48:47 -0800 (PST)
Received: (nullmailer pid 1544240 invoked by uid 1000);
        Fri, 10 Mar 2023 14:47:18 -0000
From:   Rob Herring <robh@kernel.org>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Zhao Qiang <qiang.zhao@nxp.com>, Kalle Valo <kvalo@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>
Cc:     devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-wireless@vger.kernel.org
Subject: [PATCH] net: Use of_property_read_bool() for boolean properties
Date:   Fri, 10 Mar 2023 08:47:16 -0600
Message-Id: <20230310144718.1544169-1-robh@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is preferred to use typed property access functions (i.e.
of_property_read_<type> functions) rather than low-level
of_get_property/of_find_property functions for reading properties.
Convert reading boolean properties to to of_property_read_bool().

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/net/can/cc770/cc770_platform.c          | 12 ++++++------
 drivers/net/ethernet/cadence/macb_main.c        |  2 +-
 drivers/net/ethernet/davicom/dm9000.c           |  4 ++--
 drivers/net/ethernet/freescale/fec_main.c       |  2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c    |  2 +-
 drivers/net/ethernet/freescale/gianfar.c        |  4 ++--
 drivers/net/ethernet/ibm/emac/core.c            |  8 ++++----
 drivers/net/ethernet/ibm/emac/rgmii.c           |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c |  3 +--
 drivers/net/ethernet/sun/niu.c                  |  2 +-
 drivers/net/ethernet/ti/cpsw-phy-sel.c          |  3 +--
 drivers/net/ethernet/ti/netcp_ethss.c           |  8 +++-----
 drivers/net/ethernet/via/via-velocity.c         |  3 +--
 drivers/net/ethernet/xilinx/ll_temac_main.c     |  9 ++++-----
 drivers/net/wan/fsl_ucc_hdlc.c                  | 11 +++--------
 drivers/net/wireless/ti/wlcore/spi.c            |  3 +--
 net/ncsi/ncsi-manage.c                          |  4 ++--
 17 files changed, 35 insertions(+), 47 deletions(-)

diff --git a/drivers/net/can/cc770/cc770_platform.c b/drivers/net/can/cc770/cc770_platform.c
index 8d916e2ee6c2..8dcc32e4e30e 100644
--- a/drivers/net/can/cc770/cc770_platform.c
+++ b/drivers/net/can/cc770/cc770_platform.c
@@ -93,20 +93,20 @@ static int cc770_get_of_node_data(struct platform_device *pdev,
 	if (priv->can.clock.freq > 8000000)
 		priv->cpu_interface |= CPUIF_DMC;
 
-	if (of_get_property(np, "bosch,divide-memory-clock", NULL))
+	if (of_property_read_bool(np, "bosch,divide-memory-clock"))
 		priv->cpu_interface |= CPUIF_DMC;
-	if (of_get_property(np, "bosch,iso-low-speed-mux", NULL))
+	if (of_property_read_bool(np, "bosch,iso-low-speed-mux"))
 		priv->cpu_interface |= CPUIF_MUX;
 
 	if (!of_get_property(np, "bosch,no-comperator-bypass", NULL))
 		priv->bus_config |= BUSCFG_CBY;
-	if (of_get_property(np, "bosch,disconnect-rx0-input", NULL))
+	if (of_property_read_bool(np, "bosch,disconnect-rx0-input"))
 		priv->bus_config |= BUSCFG_DR0;
-	if (of_get_property(np, "bosch,disconnect-rx1-input", NULL))
+	if (of_property_read_bool(np, "bosch,disconnect-rx1-input"))
 		priv->bus_config |= BUSCFG_DR1;
-	if (of_get_property(np, "bosch,disconnect-tx1-output", NULL))
+	if (of_property_read_bool(np, "bosch,disconnect-tx1-output"))
 		priv->bus_config |= BUSCFG_DT1;
-	if (of_get_property(np, "bosch,polarity-dominant", NULL))
+	if (of_property_read_bool(np, "bosch,polarity-dominant"))
 		priv->bus_config |= BUSCFG_POL;
 
 	prop = of_get_property(np, "bosch,clock-out-frequency", &prop_size);
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 6e141a8bbf43..66e30561569e 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4990,7 +4990,7 @@ static int macb_probe(struct platform_device *pdev)
 		bp->jumbo_max_len = macb_config->jumbo_max_len;
 
 	bp->wol = 0;
-	if (of_get_property(np, "magic-packet", NULL))
+	if (of_property_read_bool(np, "magic-packet"))
 		bp->wol |= MACB_WOL_HAS_MAGIC_PACKET;
 	device_set_wakeup_capable(&pdev->dev, bp->wol & MACB_WOL_HAS_MAGIC_PACKET);
 
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index b21e56de6167..05a89ab6766c 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1393,9 +1393,9 @@ static struct dm9000_plat_data *dm9000_parse_dt(struct device *dev)
 	if (!pdata)
 		return ERR_PTR(-ENOMEM);
 
-	if (of_find_property(np, "davicom,ext-phy", NULL))
+	if (of_property_read_bool(np, "davicom,ext-phy"))
 		pdata->flags |= DM9000_PLATF_EXT_PHY;
-	if (of_find_property(np, "davicom,no-eeprom", NULL))
+	if (of_property_read_bool(np, "davicom,no-eeprom"))
 		pdata->flags |= DM9000_PLATF_NO_EEPROM;
 
 	ret = of_get_mac_address(np, pdata->dev_addr);
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c73e25f8995e..f3b16a6673e2 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4251,7 +4251,7 @@ fec_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_ipc_init;
 
-	if (of_get_property(np, "fsl,magic-packet", NULL))
+	if (of_property_read_bool(np, "fsl,magic-packet"))
 		fep->wol_flag |= FEC_WOL_HAS_MAGIC_PACKET;
 
 	ret = fec_enet_init_stop_mode(fep, np);
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
index a7f4c3c29f3e..b88816b71ddf 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -937,7 +937,7 @@ static int mpc52xx_fec_probe(struct platform_device *op)
 	priv->phy_node = of_parse_phandle(np, "phy-handle", 0);
 
 	/* the 7-wire property means don't use MII mode */
-	if (of_find_property(np, "fsl,7-wire-mode", NULL)) {
+	if (of_property_read_bool(np, "fsl,7-wire-mode")) {
 		priv->seven_wire_mode = 1;
 		dev_info(&ndev->dev, "using 7-wire PHY mode\n");
 	}
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index b2def295523a..38d5013c6fed 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -787,10 +787,10 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 	else
 		priv->interface = gfar_get_interface(dev);
 
-	if (of_find_property(np, "fsl,magic-packet", NULL))
+	if (of_property_read_bool(np, "fsl,magic-packet"))
 		priv->device_flags |= FSL_GIANFAR_DEV_HAS_MAGIC_PACKET;
 
-	if (of_get_property(np, "fsl,wake-on-filer", NULL))
+	if (of_property_read_bool(np, "fsl,wake-on-filer"))
 		priv->device_flags |= FSL_GIANFAR_DEV_HAS_WAKE_ON_FILER;
 
 	priv->phy_node = of_parse_phandle(np, "phy-handle", 0);
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 9b08e41ccc29..c97095abd26a 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -2939,9 +2939,9 @@ static int emac_init_config(struct emac_instance *dev)
 	}
 
 	/* Fixup some feature bits based on the device tree */
-	if (of_get_property(np, "has-inverted-stacr-oc", NULL))
+	if (of_property_read_bool(np, "has-inverted-stacr-oc"))
 		dev->features |= EMAC_FTR_STACR_OC_INVERT;
-	if (of_get_property(np, "has-new-stacr-staopc", NULL))
+	if (of_property_read_bool(np, "has-new-stacr-staopc"))
 		dev->features |= EMAC_FTR_HAS_NEW_STACR;
 
 	/* CAB lacks the appropriate properties */
@@ -3042,7 +3042,7 @@ static int emac_probe(struct platform_device *ofdev)
 	 * property here for now, but new flat device trees should set a
 	 * status property to "disabled" instead.
 	 */
-	if (of_get_property(np, "unused", NULL) || !of_device_is_available(np))
+	if (of_property_read_bool(np, "unused") || !of_device_is_available(np))
 		return -ENODEV;
 
 	/* Find ourselves in the bootlist if we are there */
@@ -3333,7 +3333,7 @@ static void __init emac_make_bootlist(void)
 
 		if (of_match_node(emac_match, np) == NULL)
 			continue;
-		if (of_get_property(np, "unused", NULL))
+		if (of_property_read_bool(np, "unused"))
 			continue;
 		idx = of_get_property(np, "cell-index", NULL);
 		if (idx == NULL)
diff --git a/drivers/net/ethernet/ibm/emac/rgmii.c b/drivers/net/ethernet/ibm/emac/rgmii.c
index 242ef976fd15..50358cf00130 100644
--- a/drivers/net/ethernet/ibm/emac/rgmii.c
+++ b/drivers/net/ethernet/ibm/emac/rgmii.c
@@ -242,7 +242,7 @@ static int rgmii_probe(struct platform_device *ofdev)
 	}
 
 	/* Check for RGMII flags */
-	if (of_get_property(ofdev->dev.of_node, "has-mdio", NULL))
+	if (of_property_read_bool(ofdev->dev.of_node, "has-mdio"))
 		dev->flags |= EMAC_RGMII_FLAG_HAS_MDIO;
 
 	/* CAB lacks the right properties, fix this up */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index ac8580f501e2..ac550d1ac015 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -213,8 +213,7 @@ imx_dwmac_parse_dt(struct imx_priv_data *dwmac, struct device *dev)
 	struct device_node *np = dev->of_node;
 	int err = 0;
 
-	if (of_get_property(np, "snps,rmii_refclk_ext", NULL))
-		dwmac->rmii_refclk_ext = true;
+	dwmac->rmii_refclk_ext = of_property_read_bool(np, "snps,rmii_refclk_ext");
 
 	dwmac->clk_tx = devm_clk_get(dev, "tx");
 	if (IS_ERR(dwmac->clk_tx)) {
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index e6144d963eaa..ab8b09a9ef61 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9271,7 +9271,7 @@ static int niu_get_of_props(struct niu *np)
 	if (model)
 		strcpy(np->vpd.model, model);
 
-	if (of_find_property(dp, "hot-swappable-phy", NULL)) {
+	if (of_property_read_bool(dp, "hot-swappable-phy")) {
 		np->flags |= (NIU_FLAGS_10G | NIU_FLAGS_FIBER |
 			NIU_FLAGS_HOTPLUG_PHY);
 	}
diff --git a/drivers/net/ethernet/ti/cpsw-phy-sel.c b/drivers/net/ethernet/ti/cpsw-phy-sel.c
index e8f38e3f7706..25e707d7b87c 100644
--- a/drivers/net/ethernet/ti/cpsw-phy-sel.c
+++ b/drivers/net/ethernet/ti/cpsw-phy-sel.c
@@ -226,8 +226,7 @@ static int cpsw_phy_sel_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->gmii_sel))
 		return PTR_ERR(priv->gmii_sel);
 
-	if (of_find_property(pdev->dev.of_node, "rmii-clock-ext", NULL))
-		priv->rmii_clock_external = true;
+	priv->rmii_clock_external = of_property_read_bool(pdev->dev.of_node, "rmii-clock-ext");
 
 	dev_set_drvdata(&pdev->dev, priv);
 
diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index 751fb0bc65c5..2adf82a32bf6 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -3583,13 +3583,11 @@ static int gbe_probe(struct netcp_device *netcp_device, struct device *dev,
 	/* init the hw stats lock */
 	spin_lock_init(&gbe_dev->hw_stats_lock);
 
-	if (of_find_property(node, "enable-ale", NULL)) {
-		gbe_dev->enable_ale = true;
+	gbe_dev->enable_ale = of_property_read_bool(node, "enable-ale");
+	if (gbe_dev->enable_ale)
 		dev_info(dev, "ALE enabled\n");
-	} else {
-		gbe_dev->enable_ale = false;
+	else
 		dev_dbg(dev, "ALE bypass enabled*\n");
-	}
 
 	ret = of_property_read_u32(node, "tx-queue",
 				   &gbe_dev->tx_queue_id);
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index a502812ac418..86f7843b4591 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2709,8 +2709,7 @@ static int velocity_get_platform_info(struct velocity_info *vptr)
 	struct resource res;
 	int ret;
 
-	if (of_get_property(vptr->dev->of_node, "no-eeprom", NULL))
-		vptr->no_eeprom = 1;
+	vptr->no_eeprom = of_property_read_bool(vptr->dev->of_node, "no-eeprom");
 
 	ret = of_address_to_resource(vptr->dev->of_node, 0, &res);
 	if (ret) {
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 1066420d6a83..e0ac1bcd9925 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1455,12 +1455,11 @@ static int temac_probe(struct platform_device *pdev)
 	 * endianness mode.  Default for OF devices is big-endian.
 	 */
 	little_endian = false;
-	if (temac_np) {
-		if (of_get_property(temac_np, "little-endian", NULL))
-			little_endian = true;
-	} else if (pdata) {
+	if (temac_np)
+		little_endian = of_property_read_bool(temac_np, "little-endian");
+	else if (pdata)
 		little_endian = pdata->reg_little_endian;
-	}
+
 	if (little_endian) {
 		lp->temac_ior = _temac_ior_le;
 		lp->temac_iow = _temac_iow_le;
diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index 1c53b5546927..47c2ad7a3e42 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -1177,14 +1177,9 @@ static int ucc_hdlc_probe(struct platform_device *pdev)
 	uhdlc_priv->dev = &pdev->dev;
 	uhdlc_priv->ut_info = ut_info;
 
-	if (of_get_property(np, "fsl,tdm-interface", NULL))
-		uhdlc_priv->tsa = 1;
-
-	if (of_get_property(np, "fsl,ucc-internal-loopback", NULL))
-		uhdlc_priv->loopback = 1;
-
-	if (of_get_property(np, "fsl,hdlc-bus", NULL))
-		uhdlc_priv->hdlc_bus = 1;
+	uhdlc_priv->tsa = of_property_read_bool(np, "fsl,tdm-interface");
+	uhdlc_priv->loopback = of_property_read_bool(np, "fsl,ucc-internal-loopback");
+	uhdlc_priv->hdlc_bus = of_property_read_bool(np, "fsl,hdlc-bus");
 
 	if (uhdlc_priv->tsa == 1) {
 		utdm = kzalloc(sizeof(*utdm), GFP_KERNEL);
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 2d2edddc77bd..3f88e6a0a510 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -447,8 +447,7 @@ static int wlcore_probe_of(struct spi_device *spi, struct wl12xx_spi_glue *glue,
 	dev_info(&spi->dev, "selected chip family is %s\n",
 		 pdev_data->family->name);
 
-	if (of_find_property(dt_node, "clock-xtal", NULL))
-		pdev_data->ref_clock_xtal = true;
+	pdev_data->ref_clock_xtal = of_property_read_bool(dt_node, "clock-xtal");
 
 	/* optional clock frequency params */
 	of_property_read_u32(dt_node, "ref-clock-frequency",
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index 80713febfac6..d9da942ad53d 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1803,8 +1803,8 @@ struct ncsi_dev *ncsi_register_dev(struct net_device *dev,
 	pdev = to_platform_device(dev->dev.parent);
 	if (pdev) {
 		np = pdev->dev.of_node;
-		if (np && (of_get_property(np, "mellanox,multi-host", NULL) ||
-			   of_get_property(np, "mlx,multi-host", NULL)))
+		if (np && (of_property_read_bool(np, "mellanox,multi-host") ||
+			   of_property_read_bool(np, "mlx,multi-host")))
 			ndp->mlx_multi_host = true;
 	}
 
-- 
2.39.2

