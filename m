Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F7242CEC4
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhJMWm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbhJMWl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:58 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCF9C06177C;
        Wed, 13 Oct 2021 15:39:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id p13so16703272edw.0;
        Wed, 13 Oct 2021 15:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MBkmCEkit/90hd+8bDO4/BkNiNCDmCigPRGdrFHyf24=;
        b=UuGulXkbPOE3R6sU+1mAumKk96Sd6ZlA2JX6UneH5RZEbkZXfQjoIq9I3CXe7L8gB+
         w3yB6EjuikROd0tBDaX4CbVXCUpFCOwK3EZBRZMmrH/OdXf94c24e2uAbc0b+8e7l4nv
         MI9k0f+kwNYgvh92yi+hzVa2flObRzkJlEOjUnx8NojG90QuYqO5EG3LbWsEfGX+CDBy
         /rJFxu7fKQqwuKP6awU6HapVERXsQ1qJYOOVR/wJcMtTgwpLUv+Y2AXXh++si2RtwdK+
         QJh4OH0Sam0AqcxeNB6g+Zi2uIfQg9GJp2pPEtbOSt+WnjY1V8CdQvEfwTPv18aSSyP4
         MNJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MBkmCEkit/90hd+8bDO4/BkNiNCDmCigPRGdrFHyf24=;
        b=OHknnrMjUFgiiSKcM9PdXjKAU4MwaHi7ZMoovEa45pbDMyBX/kUWQlIy3bC5HVIBRB
         0rU2uzMFepO3+7n/N3+S1ec9Q6MSoLqA5RI9U3F305Wyc8aP3gtWVM3fjgtfWHPgxPaJ
         2+k0+HCI0HEdMCkRVH6H243RKZtJz9gc58tJ8YwyLa3n30c8klriR/QeVnDa025XSED2
         zMTXS1o2xl9zuAHq07Lh/eP5QijkqSZ06vG+FuS/50YxSqVW9rVsE3WfHBP2qMQAg5ri
         /fI2HZOfeDsq+Cn1H8Uwzo1tIp7ONxyQ/Qv6hfUKDYheDNL00sSaNEWzzLz35I1pQOzq
         3LLA==
X-Gm-Message-State: AOAM531ISVHgmHSnJRsy2ThVjXiAJMaPIN8qzKBwx0NXBRYTQYnFCPg6
        JjBOx9EXISntZrxKiLOXWGo=
X-Google-Smtp-Source: ABdhPJx1URQIkUOFlM7jI3986dW164FNwMF9MXlpi9tyUI1iZv4HNDOi+kO7rOZ4k7uvG1fWjgSGyw==
X-Received: by 2002:a17:906:7848:: with SMTP id p8mr2365660ejm.212.1634164782564;
        Wed, 13 Oct 2021 15:39:42 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:42 -0700 (PDT)
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
Subject: [net-next PATCH v7 14/16] net: dsa: qca8k: move port config to dedicated struct
Date:   Thu, 14 Oct 2021 00:39:19 +0200
Message-Id: <20211013223921.4380-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
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
index 91f2ab3af251..2b0aadb0114c 100644
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
@@ -1281,15 +1281,15 @@ qca8k_mac_config_setup_internal_delay(struct qca8k_priv *priv, int cpu_port_inde
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
@@ -1397,7 +1397,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 
 		val |= QCA8K_SGMII_EN_SD;
 
-		if (priv->sgmii_enable_pll)
+		if (priv->ports_config.sgmii_enable_pll)
 			val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
 			       QCA8K_SGMII_EN_TX;
 
@@ -1425,10 +1425,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
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

