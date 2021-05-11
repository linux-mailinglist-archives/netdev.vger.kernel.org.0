Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7464D379C99
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhEKCKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhEKCJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:09:10 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F63EC06175F;
        Mon, 10 May 2021 19:07:39 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id n2so18537427wrm.0;
        Mon, 10 May 2021 19:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EydPJz1eoQXmQhXNF/ShA7FJEooAzw2Ayy3j4YnoG0U=;
        b=dNHB7UV0pedz2hGC2d/DMP/M1GV6334Ym9yPFIQlF9mzCkNLt8KidsY8UKupjepv1k
         GQff4v3La4GmOKmqHYA6vFEvySsgoOsh+YyIpfPJNS+GdQGTKqGhV0ekTBvgMNJ9k+W/
         D4086VkS4/Mi4l9ixAtHqPOSE8ZdF4aJZZlTtXWh9F1Jz0HXtohsE39a9VGWgR0YhFFk
         libxznSn1itkD4Gl2/5F22PWqsK7BUPlndOQyWpaItJl/tAGa+zUcjE3EAwBhZzYSud1
         lVu4etla934cujHUlySorPyKMQThxtus3nR1MpkN07n0PAKeyKMXOlTsbsmZjlOGMKw7
         qj+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EydPJz1eoQXmQhXNF/ShA7FJEooAzw2Ayy3j4YnoG0U=;
        b=rLFTAIjqlxgRtWhJyb5G/BX9WwAgf51m2zNYuQkw/R68NgO+sU8tx6KGDAczrZ5jL6
         ioGTZkVrL/JfLuEVsOg7UIahQRZYohAt0zJ9p6LeVVxlq1pDKqel8I+vdSvGDKqsrRhv
         +tjAsPAFlnXnmh8+Uk0kKD+oRvChatPDVZO39o9HUd9jt4yR3snlSkr5dPT5QOMIcSWM
         SQvjusMJGzDrm1vGfunPcvHXA3X7/Bqo0gFufTXikrpGXLxfawh7p0IY9VE0RYElNhKP
         2s538C7bruAjacj+ToGTkMl8wd5tpSyuo/gvn89dp+rRMYaoGZv4o/TrVk7D3/078uLj
         jpmA==
X-Gm-Message-State: AOAM530hsZk6ta6SUb9DDnOdzc+USCh9DBoiWNhBeKvXQWfp0LuGYHf1
        giTMn1eY65KKnmuwfsZtcrU=
X-Google-Smtp-Source: ABdhPJxtF0IqWqasfkEWcJXp7U9wwPOPrQS4GJriTaJpJsoDKCsUulPXQ86UOnG/5A9zHAtGey+F6w==
X-Received: by 2002:adf:efc3:: with SMTP id i3mr34780264wrp.243.1620698858136;
        Mon, 10 May 2021 19:07:38 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:37 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next v5 16/25] net: dsa: qca8k: make rgmii delay configurable
Date:   Tue, 11 May 2021 04:04:51 +0200
Message-Id: <20210511020500.17269-17-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The legacy qsdk code used a different delay instead of the max value.
Qsdk use 1 ms for rx and 2 ms for tx. Make these values configurable
using the standard rx/tx-internal-delay-ps ethernet binding and apply
qsdk values by default. The connected gmac doesn't add any delay so no
additional delay is added to tx/rx.
On this switch the delay is actually in ms so value should be in the
1000 order. Any value converted from ps to ms by deviding it by 1000
as the switch max value for delay is 3ms.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 82 ++++++++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/qca8k.h | 11 +++---
 2 files changed, 86 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index cc9ab35f8b17..ff46d253e345 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -777,6 +777,68 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 	return 0;
 }
 
+static int
+qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
+{
+	struct device_node *port_dn;
+	phy_interface_t mode;
+	struct dsa_port *dp;
+	u32 val;
+
+	/* CPU port is already checked */
+	dp = dsa_to_port(priv->ds, 0);
+
+	port_dn = dp->dn;
+
+	/* Check if port 0 is set to the correct type */
+	of_get_phy_mode(port_dn, &mode);
+	if (mode != PHY_INTERFACE_MODE_RGMII_ID &&
+	    mode != PHY_INTERFACE_MODE_RGMII_RXID &&
+	    mode != PHY_INTERFACE_MODE_RGMII_TXID) {
+		return 0;
+	}
+
+	switch (mode) {
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		if (of_property_read_u32(port_dn, "rx-internal-delay-ps", &val))
+			val = 2;
+		else
+			/* Switch regs accept value in ms, convert ps to ms */
+			val = val / 1000;
+
+		if (val > QCA8K_MAX_DELAY) {
+			dev_err(priv->dev, "rgmii rx delay is limited to a max value of 3ms, setting to the max value");
+			val = 3;
+		}
+
+		priv->rgmii_rx_delay = val;
+		/* Stop here if we need to check only for rx delay */
+		if (mode != PHY_INTERFACE_MODE_RGMII_ID)
+			break;
+
+		fallthrough;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		if (of_property_read_u32(port_dn, "tx-internal-delay-ps", &val))
+			val = 1;
+		else
+			/* Switch regs accept value in ms, convert ps to ms */
+			val = val / 1000;
+
+		if (val > QCA8K_MAX_DELAY) {
+			dev_err(priv->dev, "rgmii tx delay is limited to a max value of 3ms, setting to the max value");
+			val = 3;
+		}
+
+		priv->rgmii_tx_delay = val;
+		break;
+	default:
+		return 0;
+	}
+
+	return 0;
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -802,6 +864,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_of_rgmii_delay(priv);
+	if (ret)
+		return ret;
+
 	/* Enable CPU Port */
 	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
 			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
@@ -970,6 +1036,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	case 0: /* 1st CPU port */
 		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
 		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_TXID &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_RXID &&
 		    state->interface != PHY_INTERFACE_MODE_SGMII)
 			return;
 
@@ -985,6 +1053,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	case 6: /* 2nd CPU port / external PHY */
 		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
 		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_TXID &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_RXID &&
 		    state->interface != PHY_INTERFACE_MODE_SGMII &&
 		    state->interface != PHY_INTERFACE_MODE_1000BASEX)
 			return;
@@ -1008,14 +1078,18 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		qca8k_write(priv, reg, QCA8K_PORT_PAD_RGMII_EN);
 		break;
 	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
 		/* RGMII_ID needs internal delay. This is enabled through
 		 * PORT5_PAD_CTRL for all ports, rather than individual port
 		 * registers
 		 */
 		qca8k_write(priv, reg,
 			    QCA8K_PORT_PAD_RGMII_EN |
-			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
+			    QCA8K_PORT_PAD_RGMII_TX_DELAY(priv->rgmii_tx_delay) |
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY(priv->rgmii_rx_delay) |
+			    QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		/* QCA8337 requires to set rgmii rx delay */
 		if (priv->switch_id == QCA8K_ID_QCA8337)
 			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
@@ -1073,6 +1147,8 @@ qca8k_phylink_validate(struct dsa_switch *ds, int port,
 		if (state->interface != PHY_INTERFACE_MODE_NA &&
 		    state->interface != PHY_INTERFACE_MODE_RGMII &&
 		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_TXID &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_RXID &&
 		    state->interface != PHY_INTERFACE_MODE_SGMII)
 			goto unsupported;
 		break;
@@ -1090,6 +1166,8 @@ qca8k_phylink_validate(struct dsa_switch *ds, int port,
 		if (state->interface != PHY_INTERFACE_MODE_NA &&
 		    state->interface != PHY_INTERFACE_MODE_RGMII &&
 		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_TXID &&
+		    state->interface != PHY_INTERFACE_MODE_RGMII_RXID &&
 		    state->interface != PHY_INTERFACE_MODE_SGMII &&
 		    state->interface != PHY_INTERFACE_MODE_1000BASEX)
 			goto unsupported;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 338277978ec0..a878486d9bcd 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -38,12 +38,11 @@
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
 #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
-#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		\
-						((0x8 + (x & 0x3)) << 22)
-#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		\
-						((0x10 + (x & 0x3)) << 20)
-#define   QCA8K_MAX_DELAY				3
+#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		((x) << 22)
+#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		((x) << 20)
+#define	  QCA8K_PORT_PAD_RGMII_TX_DELAY_EN		BIT(25)
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
+#define   QCA8K_MAX_DELAY				3
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
 #define QCA8K_REG_PWS					0x010
 #define   QCA8K_PWS_SERDES_AEN_DIS			BIT(7)
@@ -254,6 +253,8 @@ struct qca8k_match_data {
 struct qca8k_priv {
 	u8 switch_id;
 	u8 switch_revision;
+	u8 rgmii_tx_delay;
+	u8 rgmii_rx_delay;
 	struct regmap *regmap;
 	struct mii_bus *bus;
 	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
-- 
2.30.2

