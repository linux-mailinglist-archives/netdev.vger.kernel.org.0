Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB6442B21F
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbhJMBTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237273AbhJMBSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:51 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EACC061773;
        Tue, 12 Oct 2021 18:16:42 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r18so3057177edv.12;
        Tue, 12 Oct 2021 18:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=TuRIlkJdtqL0gPG5D7UDvqMp8AhmcdfXDRObs+gzAyw=;
        b=pujEicU7sjpgpK9WsE/u9Xuxn1NAZNkQp5a84kiKNv5td66MbUxJDHqP4ur4OlxjBf
         Qudke+TxpywctmzJKOWZtH9S6K6K5zWU835LcCMVKR5o9iEzErg4m2QHS63Ok1/LtYzT
         4pmCvUQuDhHZgkj+RMP85osN5Uv+E5w8q7Gr/I5nohcSnxC9G01TslmXFIIccY0QiTRb
         oTbnJZ3np4A/VeGODexKvBf75AO6UJ0e1JE/+EUR19bB2vkhoz8y58OOkghMxePWWKIx
         Tkvxs4F8IQf7IwmAAcnXzYmvO28YtSa8ILuwsqfGX4dVuQHPQoag9lgHrZP915fTWbPE
         JAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TuRIlkJdtqL0gPG5D7UDvqMp8AhmcdfXDRObs+gzAyw=;
        b=47EEPHxthxv17XMbpQR1+fRrloYcVGDzn5T7ebJxs8eF8svWDuWzg+jgG7jtFN1sK9
         TP6rOV7LPgh5lT7wFGA7uoDdqXEJM4WhLlLQjPHg63zdD0dasD74rfjdORQ5ZchZMZA1
         Ay4hTjDn2wCCA6H9IJBXNs9t2TGm/uP59JJi0eBgEYJ/+mc+mY4NX+5a0/zKQchOwTYW
         Egfg1DSdwP/kaZ8eDWjN/IOHTbQ2MqvM6yKpW+2OZQ+T4Ir00rjgMqIbzwg01aFZijRY
         kw6ywv8LL4g9Nastf7PqhxImn16YCbIrVbRsDuNwDIGc/w9YEmeO6yla/zsQowIQLOdM
         8wxA==
X-Gm-Message-State: AOAM530xBAkZ2lxH5J/k7kvTJGnholBPZk+RoUSuyylRbX07aMnWhkQ7
        z5UWUhg4R6helcQ1uBK9CRo=
X-Google-Smtp-Source: ABdhPJwfobrcxYpcUYRMPs30LSV/40zRwDkmYvzYD+cyQQiKOUFjSBAvOHhN4VQKHEY1kQkXjvKASw==
X-Received: by 2002:a17:906:c256:: with SMTP id bl22mr25439454ejb.459.1634087801422;
        Tue, 12 Oct 2021 18:16:41 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:41 -0700 (PDT)
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
Subject: [net-next PATCH v6 13/16] net: dsa: qca8k: set internal delay also for sgmii
Date:   Wed, 13 Oct 2021 03:16:19 +0200
Message-Id: <20211013011622.10537-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QCA original code report port instability and sa that SGMII also require
to set internal delay. Generalize the rgmii delay function and apply the
advised value if they are not defined in DT.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 88 ++++++++++++++++++++++++++++-------------
 drivers/net/dsa/qca8k.h |  2 +
 2 files changed, 62 insertions(+), 28 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index fc42f86ca898..2937c6b73e8e 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1004,6 +1004,7 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 		case PHY_INTERFACE_MODE_RGMII_ID:
 		case PHY_INTERFACE_MODE_RGMII_TXID:
 		case PHY_INTERFACE_MODE_RGMII_RXID:
+		case PHY_INTERFACE_MODE_SGMII:
 			delay = 0;
 
 			if (!of_property_read_u32(port_dn, "tx-internal-delay-ps", &delay))
@@ -1036,8 +1037,13 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 
 			priv->rgmii_rx_delay[cpu_port_index] = delay;
 
-			break;
-		case PHY_INTERFACE_MODE_SGMII:
+			/* Skip sgmii parsing for rgmii* mode */
+			if (mode == PHY_INTERFACE_MODE_RGMII ||
+			    mode == PHY_INTERFACE_MODE_RGMII_ID ||
+			    mode == PHY_INTERFACE_MODE_RGMII_TXID ||
+			    mode == PHY_INTERFACE_MODE_RGMII_RXID)
+				break;
+
 			if (of_property_read_bool(port_dn, "qca,sgmii-txclk-falling-edge"))
 				priv->sgmii_tx_clk_falling_edge = true;
 
@@ -1261,13 +1267,54 @@ qca8k_setup(struct dsa_switch *ds)
 	return 0;
 }
 
+static void
+qca8k_mac_config_setup_internal_delay(struct qca8k_priv *priv, int cpu_port_index,
+				      u32 reg)
+{
+	u32 delay, val = 0;
+	int ret;
+
+	/* Delay can be declared in 3 different way.
+	 * Mode to rgmii and internal-delay standard binding defined
+	 * rgmii-id or rgmii-tx/rx phy mode set.
+	 * The parse logic set a delay different than 0 only when one
+	 * of the 3 different way is used. In all other case delay is
+	 * not enabled. With ID or TX/RXID delay is enabled and set
+	 * to the default and recommended value.
+	 */
+	if (priv->rgmii_tx_delay[cpu_port_index]) {
+		delay = priv->rgmii_tx_delay[cpu_port_index];
+
+		val |= QCA8K_PORT_PAD_RGMII_TX_DELAY(delay) |
+			QCA8K_PORT_PAD_RGMII_TX_DELAY_EN;
+	}
+
+	if (priv->rgmii_rx_delay[cpu_port_index]) {
+		delay = priv->rgmii_rx_delay[cpu_port_index];
+
+		val |= QCA8K_PORT_PAD_RGMII_RX_DELAY(delay) |
+			QCA8K_PORT_PAD_RGMII_RX_DELAY_EN;
+	}
+
+	/* Set RGMII delay based on the selected values */
+	ret = qca8k_rmw(priv, reg,
+			QCA8K_PORT_PAD_RGMII_TX_DELAY_MASK |
+			QCA8K_PORT_PAD_RGMII_RX_DELAY_MASK |
+			QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
+			QCA8K_PORT_PAD_RGMII_RX_DELAY_EN,
+			val);
+	if (ret)
+		dev_err(priv->dev, "Failed to set internal delay for CPU port%d",
+			cpu_port_index == QCA8K_CPU_PORT0 ? 0 : 6);
+}
+
 static void
 qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			 const struct phylink_link_state *state)
 {
 	struct qca8k_priv *priv = ds->priv;
 	int cpu_port_index, ret;
-	u32 reg, val, delay;
+	u32 reg, val;
 
 	switch (port) {
 	case 0: /* 1st CPU port */
@@ -1316,32 +1363,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		val = QCA8K_PORT_PAD_RGMII_EN;
-
-		/* Delay can be declared in 3 different way.
-		 * Mode to rgmii and internal-delay standard binding defined
-		 * rgmii-id or rgmii-tx/rx phy mode set.
-		 * The parse logic set a delay different than 0 only when one
-		 * of the 3 different way is used. In all other case delay is
-		 * not enabled. With ID or TX/RXID delay is enabled and set
-		 * to the default and recommended value.
-		 */
-		if (priv->rgmii_tx_delay[cpu_port_index]) {
-			delay = priv->rgmii_tx_delay[cpu_port_index];
-
-			val |= QCA8K_PORT_PAD_RGMII_TX_DELAY(delay) |
-			       QCA8K_PORT_PAD_RGMII_TX_DELAY_EN;
-		}
-
-		if (priv->rgmii_rx_delay[cpu_port_index]) {
-			delay = priv->rgmii_rx_delay[cpu_port_index];
-
-			val |= QCA8K_PORT_PAD_RGMII_RX_DELAY(delay) |
-			       QCA8K_PORT_PAD_RGMII_RX_DELAY_EN;
-		}
+		qca8k_write(priv, reg, QCA8K_PORT_PAD_RGMII_EN);
 
-		/* Set RGMII delay based on the selected values */
-		qca8k_write(priv, reg, val);
+		/* Configure rgmii delay */
+		qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
 
 		/* QCA8337 requires to set rgmii rx delay for all ports.
 		 * This is enabled through PORT5_PAD_CTRL for all ports,
@@ -1412,6 +1437,13 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 					QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
 					QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
 					val);
+
+		/* From original code is reported port instability as SGMII also
+		 * require delay set. Apply advised values here or take them from DT.
+		 */
+		if (state->interface == PHY_INTERFACE_MODE_SGMII)
+			qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
+
 		break;
 	default:
 		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 9c115cfe613b..c5ca6277b45b 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -39,7 +39,9 @@
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
 #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
+#define   QCA8K_PORT_PAD_RGMII_TX_DELAY_MASK		GENMASK(23, 22)
 #define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		((x) << 22)
+#define   QCA8K_PORT_PAD_RGMII_RX_DELAY_MASK		GENMASK(21, 20)
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		((x) << 20)
 #define	  QCA8K_PORT_PAD_RGMII_TX_DELAY_EN		BIT(25)
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
-- 
2.32.0

