Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4AA3577080
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 19:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbiGPRuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 13:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiGPRud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 13:50:33 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD961D0C7;
        Sat, 16 Jul 2022 10:50:31 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id f2so10939023wrr.6;
        Sat, 16 Jul 2022 10:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yFsn95Q1QkjD7u/Gn/6AXxf5eXuxr5kizQJ1Gj9EiVs=;
        b=IGnCyZfnWmSoZh/oLkNxMASW9EnlPzqo529N4ZSUVkNjUihKpufKXcsX0HIKGhqa5o
         CcjWgPx3x2ZmX3iBwbMerTnlwdM7tINBJeVsx50Qxms35mqPszkEJ++yFpF9915+B54X
         bHPzhOuRhoVvn1zHhxDwOoCfkF9pWd84FNIxZ8b0i32qgy48Tn2ST7LJyFyG2djHYPBT
         BZPttQ2Ai0Sit8Fb0J5DRqT0aS7ScLhfEJiwxs611KIvDIB3qwrjVo9H5yj5/AEqJYPl
         9vW/oUGraXuA5uRdQ7RORanN79y9gdSuLJKWRjkoCWivjD/pGXckUan2WuHaAdE6LN1Y
         yJug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yFsn95Q1QkjD7u/Gn/6AXxf5eXuxr5kizQJ1Gj9EiVs=;
        b=T4wroJH/HXLD9vu2kNd/7wnrCwDWdVN5a8IH/EvRaDjDCOJU4zYzrabOLW3XqOWDBg
         iMtdSMrMpf+tctfB9xDAs/qVAbHPLRjqd/tcTa3e87V+y6ozAf4RTjUKxN3A98ZyDpen
         q7R/HRxvsih0Pa2zqHJvoTmSpeCEmclP145kzSUGvvzQYZ8Nwwfi67RZCMUAut87zEVA
         ITQI2vN8LLzuBNf1QqbSBKdqTx64zLxDXMmDqOFbQqhsLeNZYte99D7o/3a3ZmQ7GJYz
         6Oxi8x4Lu5SrM4wY9TfLOjBVtLXF3Xh6tTWnAfBrHhKya3gpMpy6Pa72BchDet70qjnk
         l+HA==
X-Gm-Message-State: AJIora+0+c1NHsiZN3QnraVGOY9iy6O911IuROU2Obchl9bk8cW74VP+
        Uf9feAVAVZuTXrMmW7VDzxw=
X-Google-Smtp-Source: AGRyM1ssgw+6ldktfBS03azkyjhH8gnzlZc4HqxauKqCeZbup4l00IHOgOFY6AUBWHOTSDC2wm9c7A==
X-Received: by 2002:adf:b1d9:0:b0:21d:99c3:f5ca with SMTP id r25-20020adfb1d9000000b0021d99c3f5camr16828828wra.45.1657993829717;
        Sat, 16 Jul 2022 10:50:29 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id s6-20020adfecc6000000b0021d74906683sm6836108wro.28.2022.07.16.10.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 10:50:29 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next RFC PATCH 1/4] net: dsa: qca8k: drop qca8k_read/write/rmw for regmap variant
Date:   Sat, 16 Jul 2022 19:49:55 +0200
Message-Id: <20220716174958.22542-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220716174958.22542-1-ansuelsmth@gmail.com>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for code split, drop the remaining qca8k_read/write/rmw
and use regmap helper directly.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k.c | 206 +++++++++++++++++-------------------
 1 file changed, 95 insertions(+), 111 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
index 1cbb05b0323f..2d34e15c2e6f 100644
--- a/drivers/net/dsa/qca/qca8k.c
+++ b/drivers/net/dsa/qca/qca8k.c
@@ -184,24 +184,6 @@ qca8k_set_page(struct qca8k_priv *priv, u16 page)
 	return 0;
 }
 
-static int
-qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
-{
-	return regmap_read(priv->regmap, reg, val);
-}
-
-static int
-qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
-{
-	return regmap_write(priv->regmap, reg, val);
-}
-
-static int
-qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
-{
-	return regmap_update_bits(priv->regmap, reg, mask, write_val);
-}
-
 static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data;
@@ -647,7 +629,7 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 	}
 
 	/* Write the function register triggering the table access */
-	ret = qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
+	ret = regmap_write(priv->regmap, QCA8K_REG_ATU_FUNC, reg);
 	if (ret)
 		return ret;
 
@@ -658,7 +640,7 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_FDB_LOAD) {
-		ret = qca8k_read(priv, QCA8K_REG_ATU_FUNC, &reg);
+		ret = regmap_read(priv->regmap, QCA8K_REG_ATU_FUNC, &reg);
 		if (ret < 0)
 			return ret;
 		if (reg & QCA8K_ATU_FUNC_FULL)
@@ -803,7 +785,7 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 	reg |= FIELD_PREP(QCA8K_VTU_FUNC1_VID_MASK, vid);
 
 	/* Write the function register triggering the table access */
-	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
+	ret = regmap_write(priv->regmap, QCA8K_REG_VTU_FUNC1, reg);
 	if (ret)
 		return ret;
 
@@ -814,7 +796,7 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_VLAN_LOAD) {
-		ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC1, &reg);
+		ret = regmap_read(priv->regmap, QCA8K_REG_VTU_FUNC1, &reg);
 		if (ret < 0)
 			return ret;
 		if (reg & QCA8K_VTU_FUNC1_FULL)
@@ -842,7 +824,7 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 	if (ret < 0)
 		goto out;
 
-	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
+	ret = regmap_read(priv->regmap, QCA8K_REG_VTU_FUNC0, &reg);
 	if (ret < 0)
 		goto out;
 	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
@@ -852,7 +834,7 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 	else
 		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_TAG(port);
 
-	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+	ret = regmap_write(priv->regmap, QCA8K_REG_VTU_FUNC0, reg);
 	if (ret)
 		goto out;
 	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
@@ -875,7 +857,7 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	if (ret < 0)
 		goto out;
 
-	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
+	ret = regmap_read(priv->regmap, QCA8K_REG_VTU_FUNC0, &reg);
 	if (ret < 0)
 		goto out;
 	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
@@ -895,7 +877,7 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	if (del) {
 		ret = qca8k_vlan_access(priv, QCA8K_VLAN_PURGE, vid);
 	} else {
-		ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+		ret = regmap_write(priv->regmap, QCA8K_REG_VTU_FUNC0, reg);
 		if (ret)
 			goto out;
 		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
@@ -928,7 +910,7 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	if (ret)
 		goto exit;
 
-	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
+	ret = regmap_write(priv->regmap, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
 
 exit:
 	mutex_unlock(&priv->reg_mutex);
@@ -1434,10 +1416,10 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
 		mask |= QCA8K_MAC_PWR_RGMII1_1_8V;
 
 	if (mask) {
-		ret = qca8k_rmw(priv, QCA8K_REG_MAC_PWR_SEL,
-				QCA8K_MAC_PWR_RGMII0_1_8V |
-				QCA8K_MAC_PWR_RGMII1_1_8V,
-				mask);
+		ret = regmap_update_bits(priv->regmap, QCA8K_REG_MAC_PWR_SEL,
+					 QCA8K_MAC_PWR_RGMII0_1_8V |
+					 QCA8K_MAC_PWR_RGMII1_1_8V,
+					 mask);
 	}
 
 	return ret;
@@ -1478,8 +1460,8 @@ qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
 		if (data->reduced_package)
 			val |= QCA8327_PWS_PACKAGE148_EN;
 
-		ret = qca8k_rmw(priv, QCA8K_REG_PWS, QCA8327_PWS_PACKAGE148_EN,
-				val);
+		ret = regmap_update_bits(priv->regmap, QCA8K_REG_PWS,
+					 QCA8327_PWS_PACKAGE148_EN, val);
 		if (ret)
 			return ret;
 	}
@@ -1496,7 +1478,7 @@ qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
 		val |= QCA8K_PWS_LED_OPEN_EN_CSR;
 	}
 
-	return qca8k_rmw(priv, QCA8K_REG_PWS,
+	return regmap_update_bits(priv->regmap, QCA8K_REG_PWS,
 			QCA8K_PWS_LED_OPEN_EN_CSR | QCA8K_PWS_POWER_ON_SEL,
 			val);
 }
@@ -1629,12 +1611,12 @@ qca8k_mac_config_setup_internal_delay(struct qca8k_priv *priv, int cpu_port_inde
 	}
 
 	/* Set RGMII delay based on the selected values */
-	ret = qca8k_rmw(priv, reg,
-			QCA8K_PORT_PAD_RGMII_TX_DELAY_MASK |
-			QCA8K_PORT_PAD_RGMII_RX_DELAY_MASK |
-			QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
-			QCA8K_PORT_PAD_RGMII_RX_DELAY_EN,
-			val);
+	ret = regmap_update_bits(priv->regmap, reg,
+				 QCA8K_PORT_PAD_RGMII_TX_DELAY_MASK |
+				 QCA8K_PORT_PAD_RGMII_RX_DELAY_MASK |
+				 QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
+				 QCA8K_PORT_PAD_RGMII_RX_DELAY_EN,
+				 val);
 	if (ret)
 		dev_err(priv->dev, "Failed to set internal delay for CPU port%d",
 			cpu_port_index == QCA8K_CPU_PORT0 ? 0 : 6);
@@ -1723,7 +1705,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		qca8k_write(priv, reg, QCA8K_PORT_PAD_RGMII_EN);
+		regmap_write(priv->regmap, reg, QCA8K_PORT_PAD_RGMII_EN);
 
 		/* Configure rgmii delay */
 		qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
@@ -1733,13 +1715,13 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		 * rather than individual port registers.
 		 */
 		if (priv->switch_id == QCA8K_ID_QCA8337)
-			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
-				    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
+			regmap_write(priv->regmap, QCA8K_REG_PORT5_PAD_CTRL,
+				     QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
 		/* Enable SGMII on the port */
-		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
+		regmap_write(priv->regmap, reg, QCA8K_PORT_PAD_SGMII_EN);
 		break;
 	default:
 		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
@@ -1832,7 +1814,7 @@ qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
 
 	reg |= QCA8K_PORT_STATUS_TXMAC | QCA8K_PORT_STATUS_RXMAC;
 
-	qca8k_write(priv, QCA8K_REG_PORT_STATUS(port), reg);
+	regmap_write(priv->regmap, QCA8K_REG_PORT_STATUS(port), reg);
 }
 
 static struct qca8k_pcs *pcs_to_qca8k_pcs(struct phylink_pcs *pcs)
@@ -1848,7 +1830,7 @@ static void qca8k_pcs_get_state(struct phylink_pcs *pcs,
 	u32 reg;
 	int ret;
 
-	ret = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port), &reg);
+	ret = regmap_read(priv->regmap, QCA8K_REG_PORT_STATUS(port), &reg);
 	if (ret < 0) {
 		state->link = false;
 		return;
@@ -1908,17 +1890,17 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	}
 
 	/* Enable/disable SerDes auto-negotiation as necessary */
-	ret = qca8k_read(priv, QCA8K_REG_PWS, &val);
+	ret = regmap_read(priv->regmap, QCA8K_REG_PWS, &val);
 	if (ret)
 		return ret;
 	if (phylink_autoneg_inband(mode))
 		val &= ~QCA8K_PWS_SERDES_AEN_DIS;
 	else
 		val |= QCA8K_PWS_SERDES_AEN_DIS;
-	qca8k_write(priv, QCA8K_REG_PWS, val);
+	regmap_write(priv->regmap, QCA8K_REG_PWS, val);
 
 	/* Configure the SGMII parameters */
-	ret = qca8k_read(priv, QCA8K_REG_SGMII_CTRL, &val);
+	ret = regmap_read(priv->regmap, QCA8K_REG_SGMII_CTRL, &val);
 	if (ret)
 		return ret;
 
@@ -1940,7 +1922,7 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		val |= QCA8K_SGMII_MODE_CTRL_BASEX;
 	}
 
-	qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
+	regmap_write(priv->regmap, QCA8K_REG_SGMII_CTRL, val);
 
 	/* From original code is reported port instability as SGMII also
 	 * require delay set. Apply advised values here or take them from DT.
@@ -1964,10 +1946,10 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
 
 	if (val)
-		ret = qca8k_rmw(priv, reg,
-				QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
-				QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
-				val);
+		ret = regmap_update_bits(priv->regmap, reg,
+					 QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
+					 QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
+					 val);
 
 	return 0;
 }
@@ -2122,12 +2104,12 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 		mib = &ar8327_mib[i];
 		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
 
-		ret = qca8k_read(priv, reg, &val);
+		ret = regmap_read(priv->regmap, reg, &val);
 		if (ret < 0)
 			continue;
 
 		if (mib->size == 2) {
-			ret = qca8k_read(priv, reg + 4, &hi);
+			ret = regmap_read(priv->regmap, reg + 4, &hi);
 			if (ret < 0)
 				continue;
 		}
@@ -2161,7 +2143,7 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 	int ret;
 
 	mutex_lock(&priv->reg_mutex);
-	ret = qca8k_read(priv, QCA8K_REG_EEE_CTRL, &reg);
+	ret = regmap_read(priv->regmap, QCA8K_REG_EEE_CTRL, &reg);
 	if (ret < 0)
 		goto exit;
 
@@ -2169,7 +2151,7 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 		reg |= lpi_en;
 	else
 		reg &= ~lpi_en;
-	ret = qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
+	ret = regmap_write(priv->regmap, QCA8K_REG_EEE_CTRL, reg);
 
 exit:
 	mutex_unlock(&priv->reg_mutex);
@@ -2208,8 +2190,8 @@ qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 		break;
 	}
 
-	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_STATE_MASK, stp_state);
+	regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+			   QCA8K_PORT_LOOKUP_STATE_MASK, stp_state);
 }
 
 static int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
@@ -2242,8 +2224,8 @@ static int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
 	}
 
 	/* Add all other ports to this ports portvlan mask */
-	ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-			QCA8K_PORT_LOOKUP_MEMBER, port_mask);
+	ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+				 QCA8K_PORT_LOOKUP_MEMBER, port_mask);
 
 	return ret;
 }
@@ -2272,8 +2254,8 @@ static void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
 	/* Set the cpu port to be the only one in the portvlan mask of
 	 * this port
 	 */
-	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
+	regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+			   QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
 }
 
 static void
@@ -2357,7 +2339,7 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 		qca8k_port_set_status(priv, 6, 0);
 
 	/* Include L2 header / FCS length */
-	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
+	ret = regmap_write(priv->regmap, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
 
 	if (priv->port_enabled_map & BIT(0))
 		qca8k_port_set_status(priv, 0, 1);
@@ -2560,13 +2542,13 @@ qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 	int ret;
 
 	if (vlan_filtering) {
-		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
-				QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
+		ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+					 QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
+					 QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
 	} else {
-		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
-				QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
+		ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(port),
+					 QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
+					 QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
 	}
 
 	return ret;
@@ -2589,15 +2571,15 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	}
 
 	if (pvid) {
-		ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
-				QCA8K_EGREES_VLAN_PORT_MASK(port),
-				QCA8K_EGREES_VLAN_PORT(port, vlan->vid));
+		ret = regmap_update_bits(priv->regmap, QCA8K_EGRESS_VLAN(port),
+					 QCA8K_EGREES_VLAN_PORT_MASK(port),
+					 QCA8K_EGREES_VLAN_PORT(port, vlan->vid));
 		if (ret)
 			return ret;
 
-		ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
-				  QCA8K_PORT_VLAN_CVID(vlan->vid) |
-				  QCA8K_PORT_VLAN_SVID(vlan->vid));
+		ret = regmap_write(priv->regmap, QCA8K_REG_PORT_VLAN_CTRL0(port),
+				   QCA8K_PORT_VLAN_CVID(vlan->vid) |
+				   QCA8K_PORT_VLAN_SVID(vlan->vid));
 	}
 
 	return ret;
@@ -2905,16 +2887,18 @@ qca8k_setup(struct dsa_switch *ds)
 	/* Initial setup of all ports */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* Disable forwarding by default on all ports */
-		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-				QCA8K_PORT_LOOKUP_MEMBER, 0);
+		ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(i),
+					 QCA8K_PORT_LOOKUP_MEMBER, 0);
 		if (ret)
 			return ret;
 
 		/* Enable QCA header mode on all cpu ports */
 		if (dsa_is_cpu_port(ds, i)) {
-			ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(i),
-					  FIELD_PREP(QCA8K_PORT_HDR_CTRL_TX_MASK, QCA8K_PORT_HDR_CTRL_ALL) |
-					  FIELD_PREP(QCA8K_PORT_HDR_CTRL_RX_MASK, QCA8K_PORT_HDR_CTRL_ALL));
+			ret = regmap_write(priv->regmap, QCA8K_REG_PORT_HDR_CTRL(i),
+					   FIELD_PREP(QCA8K_PORT_HDR_CTRL_TX_MASK,
+						      QCA8K_PORT_HDR_CTRL_ALL) |
+					   FIELD_PREP(QCA8K_PORT_HDR_CTRL_RX_MASK,
+						      QCA8K_PORT_HDR_CTRL_ALL));
 			if (ret) {
 				dev_err(priv->dev, "failed enabling QCA header mode");
 				return ret;
@@ -2930,11 +2914,11 @@ qca8k_setup(struct dsa_switch *ds)
 	 * Notice that in multi-cpu config only one port should be set
 	 * for igmp, unknown, multicast and broadcast packet
 	 */
-	ret = qca8k_write(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
-			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_MASK, BIT(cpu_port)) |
-			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_BC_DP_MASK, BIT(cpu_port)) |
-			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_MC_DP_MASK, BIT(cpu_port)) |
-			  FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_UC_DP_MASK, BIT(cpu_port)));
+	ret = regmap_write(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL1,
+			   FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_MASK, BIT(cpu_port)) |
+			   FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_BC_DP_MASK, BIT(cpu_port)) |
+			   FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_MC_DP_MASK, BIT(cpu_port)) |
+			   FIELD_PREP(QCA8K_GLOBAL_FW_CTRL1_UC_DP_MASK, BIT(cpu_port)));
 	if (ret)
 		return ret;
 
@@ -2944,17 +2928,17 @@ qca8k_setup(struct dsa_switch *ds)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
-			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
+			ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(i),
+						 QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
 			if (ret)
 				return ret;
 		}
 
 		/* Individual user ports get connected to CPU port only */
 		if (dsa_is_user_port(ds, i)) {
-			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-					QCA8K_PORT_LOOKUP_MEMBER,
-					BIT(cpu_port));
+			ret = regmap_update_bits(priv->regmap, QCA8K_PORT_LOOKUP_CTRL(i),
+						 QCA8K_PORT_LOOKUP_MEMBER,
+						 BIT(cpu_port));
 			if (ret)
 				return ret;
 
@@ -2967,15 +2951,15 @@ qca8k_setup(struct dsa_switch *ds)
 			/* For port based vlans to work we need to set the
 			 * default egress vid
 			 */
-			ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
-					QCA8K_EGREES_VLAN_PORT_MASK(i),
-					QCA8K_EGREES_VLAN_PORT(i, QCA8K_PORT_VID_DEF));
+			ret = regmap_update_bits(priv->regmap, QCA8K_EGRESS_VLAN(i),
+						 QCA8K_EGREES_VLAN_PORT_MASK(i),
+						 QCA8K_EGREES_VLAN_PORT(i, QCA8K_PORT_VID_DEF));
 			if (ret)
 				return ret;
 
-			ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
-					  QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
-					  QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
+			ret = regmap_write(priv->regmap, QCA8K_REG_PORT_VLAN_CTRL0(i),
+					   QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
+					   QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
 			if (ret)
 				return ret;
 		}
@@ -3009,18 +2993,18 @@ qca8k_setup(struct dsa_switch *ds)
 					QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x8) |
 					QCA8K_PORT_HOL_CTRL0_EG_PORT(0x19);
 			}
-			qca8k_write(priv, QCA8K_REG_PORT_HOL_CTRL0(i), mask);
+			regmap_write(priv->regmap, QCA8K_REG_PORT_HOL_CTRL0(i), mask);
 
 			mask = QCA8K_PORT_HOL_CTRL1_ING(0x6) |
 			QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
 			QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
 			QCA8K_PORT_HOL_CTRL1_WRED_EN;
-			qca8k_rmw(priv, QCA8K_REG_PORT_HOL_CTRL1(i),
-				  QCA8K_PORT_HOL_CTRL1_ING_BUF_MASK |
-				  QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
-				  QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
-				  QCA8K_PORT_HOL_CTRL1_WRED_EN,
-				  mask);
+			regmap_update_bits(priv->regmap, QCA8K_REG_PORT_HOL_CTRL1(i),
+					   QCA8K_PORT_HOL_CTRL1_ING_BUF_MASK |
+					   QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
+					   QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
+					   QCA8K_PORT_HOL_CTRL1_WRED_EN,
+					   mask);
 		}
 	}
 
@@ -3028,14 +3012,14 @@ qca8k_setup(struct dsa_switch *ds)
 	if (priv->switch_id == QCA8K_ID_QCA8327) {
 		mask = QCA8K_GLOBAL_FC_GOL_XON_THRES(288) |
 		       QCA8K_GLOBAL_FC_GOL_XOFF_THRES(496);
-		qca8k_rmw(priv, QCA8K_REG_GLOBAL_FC_THRESH,
-			  QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK |
-			  QCA8K_GLOBAL_FC_GOL_XOFF_THRES_MASK,
-			  mask);
+		regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FC_THRESH,
+				   QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK |
+				   QCA8K_GLOBAL_FC_GOL_XOFF_THRES_MASK,
+				   mask);
 	}
 
 	/* Setup our port MTUs to match power on defaults */
-	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
+	ret = regmap_write(priv->regmap, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
 	if (ret)
 		dev_warn(priv->dev, "failed setting MTU settings");
 
@@ -3103,7 +3087,7 @@ static int qca8k_read_switch_id(struct qca8k_priv *priv)
 	if (!data)
 		return -ENODEV;
 
-	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
+	ret = regmap_read(priv->regmap, QCA8K_REG_MASK_CTRL, &val);
 	if (ret < 0)
 		return -ENODEV;
 
-- 
2.36.1

