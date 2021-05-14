Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C89381257
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhENVCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbhENVBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:47 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942C8C06138A;
        Fri, 14 May 2021 14:00:33 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id j14so602475ejy.1;
        Fri, 14 May 2021 14:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2FwLFI+RNlCt5/RGXBGlEgk7FI82Cg4V9bv7/kv4W1c=;
        b=Up6RnNYPplUJ1/UDbUn8afDXiCA2G9PLoNnAl1HDqBphgV5lYjHU2IKYxgIavNz+1n
         myAYJ2YAmGvfT2UVtwg3nEgUmb7wNG9ZIj9M9jlx70n9MsCY7iZTSlvwNszJqHo2Yght
         jl//zXxh6DB2bGjOoQIWzADq3zxSnIKBFqAnCzB8YUoLknDEF6L9PhiypkLr6TemQxfs
         CyzuFkLjKJK/xRRK2kMpnqnEy6wrxejvkhYsStdEfdEYDoXojrkgu0WntnKuW2NtoLyb
         FvSSTFDXZ7EBbc9zmIfombTPzfh/hU/QnFjFC2QzvZQtt7p/FRPxmrWSpCWAcgPo7lGE
         R+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2FwLFI+RNlCt5/RGXBGlEgk7FI82Cg4V9bv7/kv4W1c=;
        b=Xx5yqZ1Q/6E44mj3fBKfFgOyvmZOTPSb6+Pc7Wqc9tCyCI8EY1+NpLi8/fRsP4RqRz
         ZEplc6AQIh8So2uHPPHGeieWxgy3HGbW0pAjKfKBuRwkz6Mw1r6if8wwF3/ZK/I8HrDA
         4xEfUIhdNulYhAAylk+oRiKFAUipnxSrVdE2uzZQEE1Ag4tEebSNaSlViFUCveEHvgnz
         s9TUT7jeDxVA7ozJsJcWLdrGiTs9G6gR/nn2lwxXOPRpOx4PDICfZOfgR6/u/rXfp2xh
         qV80YrzwbXODMe8sMN1afZDsN6QWZbkG2/iIOdpIPryT477tHYitXnC0c+SLS6tPvNb3
         hfQw==
X-Gm-Message-State: AOAM533EvyZH8h+jguYkZc9LrxjAAckbTU6lin7FbeisXMWkv5VVvR2G
        AojPUMf24TRE5YoF00ZDG/Y=
X-Google-Smtp-Source: ABdhPJw+VjQl1bNfzgjycvbdpDGEpF3f/z/o/9zPurhPIIQeCTEkvABkNJQj9lmrQFfCdwFi4ePvTw==
X-Received: by 2002:a17:906:c44b:: with SMTP id ck11mr4510315ejb.53.1621026032207;
        Fri, 14 May 2021 14:00:32 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:31 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 16/25] net: dsa: qca8k: make rgmii delay configurable
Date:   Fri, 14 May 2021 23:00:06 +0200
Message-Id: <20210514210015.18142-17-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The legacy qsdk code used a different delay instead of the max value.
Qsdk use 1 ns for rx and 2 ns for tx. Make these values configurable
using the standard rx/tx-internal-delay-ps ethernet binding and apply
qsdk values by default. The connected gmac doesn't add any delay so no
additional delay is added to tx/rx.
On this switch the delay is actually in ns so value should be in the
1000 order. Any value converted from ps to ns by dividing it by 1000
as the switch max value for delay is 3ns.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 82 ++++++++++++++++++++++++++++++++++++++++-
 drivers/net/dsa/qca8k.h | 11 +++---
 2 files changed, 86 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index cc9ab35f8b17..dedbc6565516 100644
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
+			/* Switch regs accept value in ns, convert ps to ns */
+			val = val / 1000;
+
+		if (val > QCA8K_MAX_DELAY) {
+			dev_err(priv->dev, "rgmii rx delay is limited to a max value of 3ns, setting to the max value");
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
+			/* Switch regs accept value in ns, convert ps to ns */
+			val = val / 1000;
+
+		if (val > QCA8K_MAX_DELAY) {
+			dev_err(priv->dev, "rgmii tx delay is limited to a max value of 3ns, setting to the max value");
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

