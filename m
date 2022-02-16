Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCAD4B8C05
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiBPPGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:06:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235338AbiBPPGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:06:23 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67950295FFB
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NCcjnVB4WDH16Ar7GbvsJU5ZhYdQNJv0cU2nSVfsUGM=; b=lTNmnY8/3hSM2eYDQbYgaYE21k
        cbGV7czY9rSYXLQDvEZWZ5HoO7E+CYAR71yiKB2x+h58qf4M7yQ3EZyIFjrZorR6Ntu+dVYDmyX5R
        E8lAz1xOEA0wz1kLMfX5BMNPM/RQyk/QlwNB4hOxWcKF4duhx/cn1HtApVSFfosNyT5IV/7RivQJ6
        TpryoeOGPc7bpEC8pyxWpjyn6HnRmyaiqfnoDz3RdGY5BbEOcB32nI90qBB3Tofvx0SEewBSZpMUp
        FEQKjCHi+Mv/c+MhQc9Qq+pp6Dp8vBmMH6B2Teje+X3whEfy/ScHL7DHzzp9EDIzQDEb1wy6D4PTV
        gpt97FJA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46580 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nKLsc-0003ys-PW; Wed, 16 Feb 2022 15:06:06 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nKLsc-009NMd-6m; Wed, 16 Feb 2022 15:06:06 +0000
In-Reply-To: <Yg0SYHh1YNWsPB1D@shell.armlinux.org.uk>
References: <Yg0SYHh1YNWsPB1D@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/6] net: dsa: qca8k: move qca8k_setup()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nKLsc-009NMd-6m@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 16 Feb 2022 15:06:06 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move qca8k_setup() to be later in the file to avoid needing prototypes
for called functions.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/qca8k.c | 428 ++++++++++++++++++++--------------------
 1 file changed, 214 insertions(+), 214 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index bb2fbb6826ac..22938d7cd161 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1632,220 +1632,6 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 	return 0;
 }
 
-static int
-qca8k_setup(struct dsa_switch *ds)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int cpu_port, ret, i;
-	u32 mask;
-
-	cpu_port = qca8k_find_cpu_port(ds);
-	if (cpu_port < 0) {
-		dev_err(priv->dev, "No cpu port configured in both cpu port0 and port6");
-		return cpu_port;
-	}
-
-	/* Parse CPU port config to be later used in phy_link mac_config */
-	ret = qca8k_parse_port_config(priv);
-	if (ret)
-		return ret;
-
-	ret = qca8k_setup_mdio_bus(priv);
-	if (ret)
-		return ret;
-
-	ret = qca8k_setup_of_pws_reg(priv);
-	if (ret)
-		return ret;
-
-	ret = qca8k_setup_mac_pwr_sel(priv);
-	if (ret)
-		return ret;
-
-	/* Make sure MAC06 is disabled */
-	ret = regmap_clear_bits(priv->regmap, QCA8K_REG_PORT0_PAD_CTRL,
-				QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN);
-	if (ret) {
-		dev_err(priv->dev, "failed disabling MAC06 exchange");
-		return ret;
-	}
-
-	/* Enable CPU Port */
-	ret = regmap_set_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
-			      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
-	if (ret) {
-		dev_err(priv->dev, "failed enabling CPU port");
-		return ret;
-	}
-
-	/* Enable MIB counters */
-	ret = qca8k_mib_init(priv);
-	if (ret)
-		dev_warn(priv->dev, "mib init failed");
-
-	/* Initial setup of all ports */
-	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
-		/* Disable forwarding by default on all ports */
-		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-				QCA8K_PORT_LOOKUP_MEMBER, 0);
-		if (ret)
-			return ret;
-
-		/* Enable QCA header mode on all cpu ports */
-		if (dsa_is_cpu_port(ds, i)) {
-			ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(i),
-					  FIELD_PREP(QCA8K_PORT_HDR_CTRL_TX_MASK, QCA8K_PORT_HDR_CTRL_ALL) |
-					  FIELD_PREP(QCA8K_PORT_HDR_CTRL_RX_MASK, QCA8K_PORT_HDR_CTRL_ALL));
-			if (ret) {
-				dev_err(priv->dev, "failed enabling QCA header mode");
-				return ret;
-			}
-		}
-
-		/* Disable MAC by default on all user ports */
-		if (dsa_is_user_port(ds, i))
-			qca8k_port_set_status(priv, i, 0);
-	}
-
-	/* Forward all unknown frames to CPU port for Linux processing
-	 * Notice that in multi-cpu config only one port should be set
-	 * for igmp, unknown, multicast and broadcast packet
-	 */
-	ret = qca8k_write(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
-			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_MASK, BIT(cpu_port)) |
-			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_BC_DP_MASK, BIT(cpu_port)) |
-			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_MC_DP_MASK, BIT(cpu_port)) |
-			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_UC_DP_MASK, BIT(cpu_port)));
-	if (ret)
-		return ret;
-
-	/* Setup connection between CPU port & user ports
-	 * Configure specific switch configuration for ports
-	 */
-	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
-		/* CPU port gets connected to all user ports of the switch */
-		if (dsa_is_cpu_port(ds, i)) {
-			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
-			if (ret)
-				return ret;
-		}
-
-		/* Individual user ports get connected to CPU port only */
-		if (dsa_is_user_port(ds, i)) {
-			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-					QCA8K_PORT_LOOKUP_MEMBER,
-					BIT(cpu_port));
-			if (ret)
-				return ret;
-
-			/* Enable ARP Auto-learning by default */
-			ret = regmap_set_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(i),
-					      QCA8K_PORT_LOOKUP_LEARN);
-			if (ret)
-				return ret;
-
-			/* For port based vlans to work we need to set the
-			 * default egress vid
-			 */
-			ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
-					QCA8K_EGREES_VLAN_PORT_MASK(i),
-					QCA8K_EGREES_VLAN_PORT(i, QCA8K_PORT_VID_DEF));
-			if (ret)
-				return ret;
-
-			ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
-					  QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
-					  QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
-			if (ret)
-				return ret;
-		}
-
-		/* The port 5 of the qca8337 have some problem in flood condition. The
-		 * original legacy driver had some specific buffer and priority settings
-		 * for the different port suggested by the QCA switch team. Add this
-		 * missing settings to improve switch stability under load condition.
-		 * This problem is limited to qca8337 and other qca8k switch are not affected.
-		 */
-		if (priv->switch_id == QCA8K_ID_QCA8337) {
-			switch (i) {
-			/* The 2 CPU port and port 5 requires some different
-			 * priority than any other ports.
-			 */
-			case 0:
-			case 5:
-			case 6:
-				mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
-					QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
-					QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x4) |
-					QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x4) |
-					QCA8K_PORT_HOL_CTRL0_EG_PRI4(0x6) |
-					QCA8K_PORT_HOL_CTRL0_EG_PRI5(0x8) |
-					QCA8K_PORT_HOL_CTRL0_EG_PORT(0x1e);
-				break;
-			default:
-				mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
-					QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
-					QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x6) |
-					QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x8) |
-					QCA8K_PORT_HOL_CTRL0_EG_PORT(0x19);
-			}
-			qca8k_write(priv, QCA8K_REG_PORT_HOL_CTRL0(i), mask);
-
-			mask = QCA8K_PORT_HOL_CTRL1_ING(0x6) |
-			QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
-			QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
-			QCA8K_PORT_HOL_CTRL1_WRED_EN;
-			qca8k_rmw(priv, QCA8K_REG_PORT_HOL_CTRL1(i),
-				  QCA8K_PORT_HOL_CTRL1_ING_BUF_MASK |
-				  QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
-				  QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
-				  QCA8K_PORT_HOL_CTRL1_WRED_EN,
-				  mask);
-		}
-
-		/* Set initial MTU for every port.
-		 * We have only have a general MTU setting. So track
-		 * every port and set the max across all port.
-		 * Set per port MTU to 1500 as the MTU change function
-		 * will add the overhead and if its set to 1518 then it
-		 * will apply the overhead again and we will end up with
-		 * MTU of 1536 instead of 1518
-		 */
-		priv->port_mtu[i] = ETH_DATA_LEN;
-	}
-
-	/* Special GLOBAL_FC_THRESH value are needed for ar8327 switch */
-	if (priv->switch_id == QCA8K_ID_QCA8327) {
-		mask = QCA8K_GLOBAL_FC_GOL_XON_THRES(288) |
-		       QCA8K_GLOBAL_FC_GOL_XOFF_THRES(496);
-		qca8k_rmw(priv, QCA8K_REG_GLOBAL_FC_THRESH,
-			  QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK |
-			  QCA8K_GLOBAL_FC_GOL_XOFF_THRES_MASK,
-			  mask);
-	}
-
-	/* Setup our port MTUs to match power on defaults */
-	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
-	if (ret)
-		dev_warn(priv->dev, "failed setting MTU settings");
-
-	/* Flush the FDB table */
-	qca8k_fdb_flush(priv);
-
-	/* We don't have interrupts for link changes, so we need to poll */
-	ds->pcs_poll = true;
-
-	/* Set min a max ageing value supported */
-	ds->ageing_time_min = 7000;
-	ds->ageing_time_max = 458745000;
-
-	/* Set max number of LAGs supported */
-	ds->num_lag_ids = QCA8K_NUM_LAGS;
-
-	return 0;
-}
-
 static void
 qca8k_mac_config_setup_internal_delay(struct qca8k_priv *priv, int cpu_port_index,
 				      u32 reg)
@@ -2990,6 +2776,220 @@ static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
 	return 0;
 }
 
+static int
+qca8k_setup(struct dsa_switch *ds)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	int cpu_port, ret, i;
+	u32 mask;
+
+	cpu_port = qca8k_find_cpu_port(ds);
+	if (cpu_port < 0) {
+		dev_err(priv->dev, "No cpu port configured in both cpu port0 and port6");
+		return cpu_port;
+	}
+
+	/* Parse CPU port config to be later used in phy_link mac_config */
+	ret = qca8k_parse_port_config(priv);
+	if (ret)
+		return ret;
+
+	ret = qca8k_setup_mdio_bus(priv);
+	if (ret)
+		return ret;
+
+	ret = qca8k_setup_of_pws_reg(priv);
+	if (ret)
+		return ret;
+
+	ret = qca8k_setup_mac_pwr_sel(priv);
+	if (ret)
+		return ret;
+
+	/* Make sure MAC06 is disabled */
+	ret = regmap_clear_bits(priv->regmap, QCA8K_REG_PORT0_PAD_CTRL,
+				QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN);
+	if (ret) {
+		dev_err(priv->dev, "failed disabling MAC06 exchange");
+		return ret;
+	}
+
+	/* Enable CPU Port */
+	ret = regmap_set_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
+			      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
+	if (ret) {
+		dev_err(priv->dev, "failed enabling CPU port");
+		return ret;
+	}
+
+	/* Enable MIB counters */
+	ret = qca8k_mib_init(priv);
+	if (ret)
+		dev_warn(priv->dev, "mib init failed");
+
+	/* Initial setup of all ports */
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		/* Disable forwarding by default on all ports */
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+				QCA8K_PORT_LOOKUP_MEMBER, 0);
+		if (ret)
+			return ret;
+
+		/* Enable QCA header mode on all cpu ports */
+		if (dsa_is_cpu_port(ds, i)) {
+			ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(i),
+					  FIELD_PREP(QCA8K_PORT_HDR_CTRL_TX_MASK, QCA8K_PORT_HDR_CTRL_ALL) |
+					  FIELD_PREP(QCA8K_PORT_HDR_CTRL_RX_MASK, QCA8K_PORT_HDR_CTRL_ALL));
+			if (ret) {
+				dev_err(priv->dev, "failed enabling QCA header mode");
+				return ret;
+			}
+		}
+
+		/* Disable MAC by default on all user ports */
+		if (dsa_is_user_port(ds, i))
+			qca8k_port_set_status(priv, i, 0);
+	}
+
+	/* Forward all unknown frames to CPU port for Linux processing
+	 * Notice that in multi-cpu config only one port should be set
+	 * for igmp, unknown, multicast and broadcast packet
+	 */
+	ret = qca8k_write(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
+			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_MASK, BIT(cpu_port)) |
+			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_BC_DP_MASK, BIT(cpu_port)) |
+			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_MC_DP_MASK, BIT(cpu_port)) |
+			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_UC_DP_MASK, BIT(cpu_port)));
+	if (ret)
+		return ret;
+
+	/* Setup connection between CPU port & user ports
+	 * Configure specific switch configuration for ports
+	 */
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		/* CPU port gets connected to all user ports of the switch */
+		if (dsa_is_cpu_port(ds, i)) {
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
+			if (ret)
+				return ret;
+		}
+
+		/* Individual user ports get connected to CPU port only */
+		if (dsa_is_user_port(ds, i)) {
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+					QCA8K_PORT_LOOKUP_MEMBER,
+					BIT(cpu_port));
+			if (ret)
+				return ret;
+
+			/* Enable ARP Auto-learning by default */
+			ret = regmap_set_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(i),
+					      QCA8K_PORT_LOOKUP_LEARN);
+			if (ret)
+				return ret;
+
+			/* For port based vlans to work we need to set the
+			 * default egress vid
+			 */
+			ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
+					QCA8K_EGREES_VLAN_PORT_MASK(i),
+					QCA8K_EGREES_VLAN_PORT(i, QCA8K_PORT_VID_DEF));
+			if (ret)
+				return ret;
+
+			ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
+					  QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
+					  QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
+			if (ret)
+				return ret;
+		}
+
+		/* The port 5 of the qca8337 have some problem in flood condition. The
+		 * original legacy driver had some specific buffer and priority settings
+		 * for the different port suggested by the QCA switch team. Add this
+		 * missing settings to improve switch stability under load condition.
+		 * This problem is limited to qca8337 and other qca8k switch are not affected.
+		 */
+		if (priv->switch_id == QCA8K_ID_QCA8337) {
+			switch (i) {
+			/* The 2 CPU port and port 5 requires some different
+			 * priority than any other ports.
+			 */
+			case 0:
+			case 5:
+			case 6:
+				mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x4) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x4) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI4(0x6) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI5(0x8) |
+					QCA8K_PORT_HOL_CTRL0_EG_PORT(0x1e);
+				break;
+			default:
+				mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x6) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x8) |
+					QCA8K_PORT_HOL_CTRL0_EG_PORT(0x19);
+			}
+			qca8k_write(priv, QCA8K_REG_PORT_HOL_CTRL0(i), mask);
+
+			mask = QCA8K_PORT_HOL_CTRL1_ING(0x6) |
+			QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
+			QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
+			QCA8K_PORT_HOL_CTRL1_WRED_EN;
+			qca8k_rmw(priv, QCA8K_REG_PORT_HOL_CTRL1(i),
+				  QCA8K_PORT_HOL_CTRL1_ING_BUF_MASK |
+				  QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
+				  QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
+				  QCA8K_PORT_HOL_CTRL1_WRED_EN,
+				  mask);
+		}
+
+		/* Set initial MTU for every port.
+		 * We have only have a general MTU setting. So track
+		 * every port and set the max across all port.
+		 * Set per port MTU to 1500 as the MTU change function
+		 * will add the overhead and if its set to 1518 then it
+		 * will apply the overhead again and we will end up with
+		 * MTU of 1536 instead of 1518
+		 */
+		priv->port_mtu[i] = ETH_DATA_LEN;
+	}
+
+	/* Special GLOBAL_FC_THRESH value are needed for ar8327 switch */
+	if (priv->switch_id == QCA8K_ID_QCA8327) {
+		mask = QCA8K_GLOBAL_FC_GOL_XON_THRES(288) |
+		       QCA8K_GLOBAL_FC_GOL_XOFF_THRES(496);
+		qca8k_rmw(priv, QCA8K_REG_GLOBAL_FC_THRESH,
+			  QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK |
+			  QCA8K_GLOBAL_FC_GOL_XOFF_THRES_MASK,
+			  mask);
+	}
+
+	/* Setup our port MTUs to match power on defaults */
+	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
+	if (ret)
+		dev_warn(priv->dev, "failed setting MTU settings");
+
+	/* Flush the FDB table */
+	qca8k_fdb_flush(priv);
+
+	/* We don't have interrupts for link changes, so we need to poll */
+	ds->pcs_poll = true;
+
+	/* Set min a max ageing value supported */
+	ds->ageing_time_min = 7000;
+	ds->ageing_time_max = 458745000;
+
+	/* Set max number of LAGs supported */
+	ds->num_lag_ids = QCA8K_NUM_LAGS;
+
+	return 0;
+}
+
 static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_tag_protocol	= qca8k_get_tag_protocol,
 	.setup			= qca8k_setup,
-- 
2.30.2

