Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED2942B225
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237751AbhJMBT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237294AbhJMBSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:51 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286A6C061775;
        Tue, 12 Oct 2021 18:16:44 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id p13so3403502edw.0;
        Tue, 12 Oct 2021 18:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MIykSxbCMBJ3msegm3mTK6tej05Y6/HxhKpXyf/s2XA=;
        b=GPHfzufvjk33HC1TH74atQK059kQpbkjrVlXl8lT2jpH/6NWeSfBR+z2dvHgRIA8/a
         oguwHaqAQBWww+J0VVXbSG0bB2liU+051P79SJbLrBco3kvhBPKEh57YJLc9L2t9syvN
         70QSxJRxsUMPVuuc1OAiWC8uOSAFeKxMd++Z8z/QKWT8h7Y4YVWT93DF75zuk1K9oPnl
         DA9z2LX/givq8t8wp1ko/V+whmNi+UMgCtqZM2Ksde3uSB0OQhZHlhDspIo7zJSLfeTt
         mc4ZSWa2NjddR+9FKySxD1y85P5SeCLSeGolZtWLai8qnm0s7ETRF130oCr6fNcjGqvO
         /Wvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MIykSxbCMBJ3msegm3mTK6tej05Y6/HxhKpXyf/s2XA=;
        b=mu3kStuKQxdt+dgAroEDLW4B6vMNP/omabckx1XSR2dpKc/FpYlcTQcGGrr+d9YdFO
         aInEchTe6vsQt5ZCk8ucaV7Rj1EUq3IbCJRIDPuLsXD6SPvEFmziHbcCLOLSUK+D/4mt
         J6cG/UhGsFcZv8TOzQJtrhshg6gimVF/55UeS7jp1km2jU3Xd7upscIGZLKE7C94MzyG
         33SLeEqAQYZoFp1CceAp+qUQwkMYLYNylp4eAPCxnwsJ35XGuYA2tRDSQqsl8weCgnLA
         izdVQW7lLMBUzJBCaOAW2K6mcqMhix6tecOEmG4CtoPz8NCOG7uFtbGtmOZ5xNNIx8GV
         7+/Q==
X-Gm-Message-State: AOAM531Uf9A3uFXNsOe+7kg0GgyzyUdGYynflu0JOphEWCaG5XNcoWZL
        re1KjFWtlSnv40NZkyOZPnQ=
X-Google-Smtp-Source: ABdhPJzP2PO3s4b/DyHfyQuOEwn++GdUekeUVfMW/7nrTH6NK7SFsSqhDj8WohsMTagVaKGaPdpKJw==
X-Received: by 2002:a17:907:1006:: with SMTP id ox6mr23000434ejb.146.1634087802636;
        Tue, 12 Oct 2021 18:16:42 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:42 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v6 14/16] net: dsa: qca8k: move port config to dedicated struct
Date:   Wed, 13 Oct 2021 03:16:20 +0200
Message-Id: <20211013011622.10537-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move ports related config to dedicated struct to keep things organized.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca8k.c | 26 +++++++++++++-------------
 drivers/net/dsa/qca8k.h | 10 +++++++---
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 2937c6b73e8e..2b7aee927b95 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1019,7 +1019,7 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 				delay = 3;
 			}
 
-			priv->rgmii_tx_delay[cpu_port_index] = delay;
+			priv->ports_config.rgmii_tx_delay[cpu_port_index] = delay;
 
 			delay = 0;
 
@@ -1035,7 +1035,7 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 				delay = 3;
 			}
 
-			priv->rgmii_rx_delay[cpu_port_index] = delay;
+			priv->ports_config.rgmii_rx_delay[cpu_port_index] = delay;
 
 			/* Skip sgmii parsing for rgmii* mode */
 			if (mode == PHY_INTERFACE_MODE_RGMII ||
@@ -1045,17 +1045,17 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 				break;
 
 			if (of_property_read_bool(port_dn, "qca,sgmii-txclk-falling-edge"))
-				priv->sgmii_tx_clk_falling_edge = true;
+				priv->ports_config.sgmii_tx_clk_falling_edge = true;
 
 			if (of_property_read_bool(port_dn, "qca,sgmii-rxclk-falling-edge"))
-				priv->sgmii_rx_clk_falling_edge = true;
+				priv->ports_config.sgmii_rx_clk_falling_edge = true;
 
 			if (of_property_read_bool(port_dn, "qca,sgmii-enable-pll")) {
-				priv->sgmii_enable_pll = true;
+				priv->ports_config.sgmii_enable_pll = true;
 
 				if (priv->switch_id == QCA8K_ID_QCA8327) {
 					dev_err(priv->dev, "SGMII PLL should NOT be enabled for qca8327. Aborting enabling");
-					priv->sgmii_enable_pll = false;
+					priv->ports_config.sgmii_enable_pll = false;
 				}
 
 				if (priv->switch_revision < 2)
@@ -1282,15 +1282,15 @@ qca8k_mac_config_setup_internal_delay(struct qca8k_priv *priv, int cpu_port_inde
 	 * not enabled. With ID or TX/RXID delay is enabled and set
 	 * to the default and recommended value.
 	 */
-	if (priv->rgmii_tx_delay[cpu_port_index]) {
-		delay = priv->rgmii_tx_delay[cpu_port_index];
+	if (priv->ports_config.rgmii_tx_delay[cpu_port_index]) {
+		delay = priv->ports_config.rgmii_tx_delay[cpu_port_index];
 
 		val |= QCA8K_PORT_PAD_RGMII_TX_DELAY(delay) |
 			QCA8K_PORT_PAD_RGMII_TX_DELAY_EN;
 	}
 
-	if (priv->rgmii_rx_delay[cpu_port_index]) {
-		delay = priv->rgmii_rx_delay[cpu_port_index];
+	if (priv->ports_config.rgmii_rx_delay[cpu_port_index]) {
+		delay = priv->ports_config.rgmii_rx_delay[cpu_port_index];
 
 		val |= QCA8K_PORT_PAD_RGMII_RX_DELAY(delay) |
 			QCA8K_PORT_PAD_RGMII_RX_DELAY_EN;
@@ -1398,7 +1398,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 
 		val |= QCA8K_SGMII_EN_SD;
 
-		if (priv->sgmii_enable_pll)
+		if (priv->ports_config.sgmii_enable_pll)
 			val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
 			       QCA8K_SGMII_EN_TX;
 
@@ -1426,10 +1426,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		val = 0;
 
 		/* SGMII Clock phase configuration */
-		if (priv->sgmii_rx_clk_falling_edge)
+		if (priv->ports_config.sgmii_rx_clk_falling_edge)
 			val |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
 
-		if (priv->sgmii_tx_clk_falling_edge)
+		if (priv->ports_config.sgmii_tx_clk_falling_edge)
 			val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
 
 		if (val)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index c5ca6277b45b..e10571a398c9 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -270,15 +270,19 @@ enum {
 	QCA8K_CPU_PORT6,
 };
 
-struct qca8k_priv {
-	u8 switch_id;
-	u8 switch_revision;
+struct qca8k_ports_config {
 	bool sgmii_rx_clk_falling_edge;
 	bool sgmii_tx_clk_falling_edge;
 	bool sgmii_enable_pll;
 	u8 rgmii_rx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
 	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
+};
+
+struct qca8k_priv {
+	u8 switch_id;
+	u8 switch_revision;
 	bool legacy_phy_port_mapping;
+	struct qca8k_ports_config ports_config;
 	struct regmap *regmap;
 	struct mii_bus *bus;
 	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
-- 
2.32.0

