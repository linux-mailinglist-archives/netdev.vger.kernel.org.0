Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809B442CEA0
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhJMWll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbhJMWli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:38 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE5AC061746;
        Wed, 13 Oct 2021 15:39:34 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id i20so15883744edj.10;
        Wed, 13 Oct 2021 15:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CojXPOUKTWkF5OetXE7Fs7HsOasjVd06JvoNneFWj8U=;
        b=VypMrY3flPimSJh4o6Kx+sOaMYljXBXaBCGAp2hU202dicrmmn9hInWHB2ahU1zwI3
         +OrGuC/3ZDBeiPemw/IYdk5VW7JNUP8Q5Mir6nUgUNzHZe8EAeH5e4uMvMXBcg9gCXvw
         GwpR69TX/LgsEjG8iI1HJJLZ91NqqBzRUrEFnLwpJydTvcbf9TTNwTfNBYS+VgsqvXzR
         wGCG+X91qfw7QqTaLnSAUW50Wogck4hG1QfJDFWhYDg9wzYrilcQVnOmZzHr2S1e0J6R
         Hl9iaNAg7zD/vKfzVHXnM6pHU7/uzv4dkQiBZv6y9jjNOLJNJGSxoCTJZMORBgKA1ymZ
         sm5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CojXPOUKTWkF5OetXE7Fs7HsOasjVd06JvoNneFWj8U=;
        b=fapKSRoPtJSEyvtyPFoaxBJp85AIfhqdM/pfdZDAfgPr4f80G9Yjwce3zj1rtpfi83
         FrY/ACU06wNiGTflzbZLF4wwjXFFRKjUTZYiqJ7dCpmwBowxwtqGwidM9I1D9/Tjv+TE
         0iEt1aemukNkESXvuIsvV9c9mhIzmf6zavZBiPY8kpWa6Q3k85r+mLpHVTTAoFzU4rXC
         aT3RVK+A0tlN3BOK8rBfYnqlYLll71oIBHv7RttcG45tFNU9dI5QuxBfD9KKmZgb3noq
         qmwo8dB+/vY7FZ60JqVxM+8y2Ls52wzacGGZcpUb/W8Mmx7Ij8pNDlOuyF1UFODPGGEW
         smoQ==
X-Gm-Message-State: AOAM533asTMETuRw0axAM9SfhuBlzrakMK9775rMkXvNTOFW7k1AKBQZ
        lpKZtUqbk+YrLEJd593vtYkSdv+D3Mo=
X-Google-Smtp-Source: ABdhPJxpITw4ZLRCCDG5hDJ6Ch8fSV9W0O1Fg3HTY6d2pNHKZ6NtoxFkT/rvvZO56rny1uYna07xgw==
X-Received: by 2002:a05:6402:274b:: with SMTP id z11mr3224624edd.151.1634164772736;
        Wed, 13 Oct 2021 15:39:32 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:32 -0700 (PDT)
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
Subject: [net-next PATCH v7 06/16] net: dsa: qca8k: rework rgmii delay logic and scan for cpu port 6
Date:   Thu, 14 Oct 2021 00:39:11 +0200
Message-Id: <20211013223921.4380-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Future proof commit. This switch have 2 CPU ports and one valid
configuration is first CPU port set to sgmii and second CPU port set to
rgmii-id. The current implementation detects delay only for CPU port
zero set to rgmii and doesn't count any delay set in a secondary CPU
port. Drop the current delay scan function and move it to the sgmii
parser function to generalize and implicitly add support for secondary
CPU port set to rgmii-id. Introduce new logic where delay is enabled
also with internal delay binding declared and rgmii set as PHY mode.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 165 ++++++++++++++++++++--------------------
 drivers/net/dsa/qca8k.h |  10 ++-
 2 files changed, 89 insertions(+), 86 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index bbe3fe9cfaa8..dad8cc5fd1af 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -888,68 +888,6 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 	return 0;
 }
 
-static int
-qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
-{
-	struct device_node *port_dn;
-	phy_interface_t mode;
-	struct dsa_port *dp;
-	u32 val;
-
-	/* CPU port is already checked */
-	dp = dsa_to_port(priv->ds, 0);
-
-	port_dn = dp->dn;
-
-	/* Check if port 0 is set to the correct type */
-	of_get_phy_mode(port_dn, &mode);
-	if (mode != PHY_INTERFACE_MODE_RGMII_ID &&
-	    mode != PHY_INTERFACE_MODE_RGMII_RXID &&
-	    mode != PHY_INTERFACE_MODE_RGMII_TXID) {
-		return 0;
-	}
-
-	switch (mode) {
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-		if (of_property_read_u32(port_dn, "rx-internal-delay-ps", &val))
-			val = 2;
-		else
-			/* Switch regs accept value in ns, convert ps to ns */
-			val = val / 1000;
-
-		if (val > QCA8K_MAX_DELAY) {
-			dev_err(priv->dev, "rgmii rx delay is limited to a max value of 3ns, setting to the max value");
-			val = 3;
-		}
-
-		priv->rgmii_rx_delay = val;
-		/* Stop here if we need to check only for rx delay */
-		if (mode != PHY_INTERFACE_MODE_RGMII_ID)
-			break;
-
-		fallthrough;
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-		if (of_property_read_u32(port_dn, "tx-internal-delay-ps", &val))
-			val = 1;
-		else
-			/* Switch regs accept value in ns, convert ps to ns */
-			val = val / 1000;
-
-		if (val > QCA8K_MAX_DELAY) {
-			dev_err(priv->dev, "rgmii tx delay is limited to a max value of 3ns, setting to the max value");
-			val = 3;
-		}
-
-		priv->rgmii_tx_delay = val;
-		break;
-	default:
-		return 0;
-	}
-
-	return 0;
-}
-
 static int
 qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
 {
@@ -996,19 +934,21 @@ static int qca8k_find_cpu_port(struct dsa_switch *ds)
 static int
 qca8k_parse_port_config(struct qca8k_priv *priv)
 {
+	int port, cpu_port_index = 0, ret;
 	struct device_node *port_dn;
 	phy_interface_t mode;
 	struct dsa_port *dp;
-	int port, ret;
+	u32 delay;
 
 	/* We have 2 CPU port. Check them */
-	for (port = 0; port < QCA8K_NUM_PORTS; port++) {
+	for (port = 0; port < QCA8K_NUM_PORTS && cpu_port_index < QCA8K_NUM_CPU_PORTS; port++) {
 		/* Skip every other port */
 		if (port != 0 && port != 6)
 			continue;
 
 		dp = dsa_to_port(priv->ds, port);
 		port_dn = dp->dn;
+		cpu_port_index++;
 
 		if (!of_device_is_available(port_dn))
 			continue;
@@ -1017,12 +957,54 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 		if (ret)
 			continue;
 
-		if (mode == PHY_INTERFACE_MODE_SGMII) {
+		switch (mode) {
+		case PHY_INTERFACE_MODE_RGMII:
+		case PHY_INTERFACE_MODE_RGMII_ID:
+		case PHY_INTERFACE_MODE_RGMII_TXID:
+		case PHY_INTERFACE_MODE_RGMII_RXID:
+			delay = 0;
+
+			if (!of_property_read_u32(port_dn, "tx-internal-delay-ps", &delay))
+				/* Switch regs accept value in ns, convert ps to ns */
+				delay = delay / 1000;
+			else if (mode == PHY_INTERFACE_MODE_RGMII_ID ||
+				 mode == PHY_INTERFACE_MODE_RGMII_TXID)
+				delay = 1;
+
+			if (delay > QCA8K_MAX_DELAY) {
+				dev_err(priv->dev, "rgmii tx delay is limited to a max value of 3ns, setting to the max value");
+				delay = 3;
+			}
+
+			priv->rgmii_tx_delay[cpu_port_index] = delay;
+
+			delay = 0;
+
+			if (!of_property_read_u32(port_dn, "rx-internal-delay-ps", &delay))
+				/* Switch regs accept value in ns, convert ps to ns */
+				delay = delay / 1000;
+			else if (mode == PHY_INTERFACE_MODE_RGMII_ID ||
+				 mode == PHY_INTERFACE_MODE_RGMII_RXID)
+				delay = 2;
+
+			if (delay > QCA8K_MAX_DELAY) {
+				dev_err(priv->dev, "rgmii rx delay is limited to a max value of 3ns, setting to the max value");
+				delay = 3;
+			}
+
+			priv->rgmii_rx_delay[cpu_port_index] = delay;
+
+			break;
+		case PHY_INTERFACE_MODE_SGMII:
 			if (of_property_read_bool(port_dn, "qca,sgmii-txclk-falling-edge"))
 				priv->sgmii_tx_clk_falling_edge = true;
 
 			if (of_property_read_bool(port_dn, "qca,sgmii-rxclk-falling-edge"))
 				priv->sgmii_rx_clk_falling_edge = true;
+
+			break;
+		default:
+			continue;
 		}
 	}
 
@@ -1059,10 +1041,6 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	ret = qca8k_setup_of_rgmii_delay(priv);
-	if (ret)
-		return ret;
-
 	ret = qca8k_setup_mac_pwr_sel(priv);
 	if (ret)
 		return ret;
@@ -1229,8 +1207,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			 const struct phylink_link_state *state)
 {
 	struct qca8k_priv *priv = ds->priv;
-	u32 reg, val;
-	int ret;
+	int cpu_port_index, ret;
+	u32 reg, val, delay;
 
 	switch (port) {
 	case 0: /* 1st CPU port */
@@ -1242,6 +1220,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			return;
 
 		reg = QCA8K_REG_PORT0_PAD_CTRL;
+		cpu_port_index = QCA8K_CPU_PORT0;
 		break;
 	case 1:
 	case 2:
@@ -1260,6 +1239,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			return;
 
 		reg = QCA8K_REG_PORT6_PAD_CTRL;
+		cpu_port_index = QCA8K_CPU_PORT6;
 		break;
 	default:
 		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
@@ -1274,23 +1254,40 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
-		/* RGMII mode means no delay so don't enable the delay */
-		qca8k_write(priv, reg, QCA8K_PORT_PAD_RGMII_EN);
-		break;
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		/* RGMII_ID needs internal delay. This is enabled through
-		 * PORT5_PAD_CTRL for all ports, rather than individual port
-		 * registers
+		val = QCA8K_PORT_PAD_RGMII_EN;
+
+		/* Delay can be declared in 3 different way.
+		 * Mode to rgmii and internal-delay standard binding defined
+		 * rgmii-id or rgmii-tx/rx phy mode set.
+		 * The parse logic set a delay different than 0 only when one
+		 * of the 3 different way is used. In all other case delay is
+		 * not enabled. With ID or TX/RXID delay is enabled and set
+		 * to the default and recommended value.
+		 */
+		if (priv->rgmii_tx_delay[cpu_port_index]) {
+			delay = priv->rgmii_tx_delay[cpu_port_index];
+
+			val |= QCA8K_PORT_PAD_RGMII_TX_DELAY(delay) |
+			       QCA8K_PORT_PAD_RGMII_TX_DELAY_EN;
+		}
+
+		if (priv->rgmii_rx_delay[cpu_port_index]) {
+			delay = priv->rgmii_rx_delay[cpu_port_index];
+
+			val |= QCA8K_PORT_PAD_RGMII_RX_DELAY(delay) |
+			       QCA8K_PORT_PAD_RGMII_RX_DELAY_EN;
+		}
+
+		/* Set RGMII delay based on the selected values */
+		qca8k_write(priv, reg, val);
+
+		/* QCA8337 requires to set rgmii rx delay for all ports.
+		 * This is enabled through PORT5_PAD_CTRL for all ports,
+		 * rather than individual port registers.
 		 */
-		qca8k_write(priv, reg,
-			    QCA8K_PORT_PAD_RGMII_EN |
-			    QCA8K_PORT_PAD_RGMII_TX_DELAY(priv->rgmii_tx_delay) |
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY(priv->rgmii_rx_delay) |
-			    QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
-		/* QCA8337 requires to set rgmii rx delay */
 		if (priv->switch_id == QCA8K_ID_QCA8337)
 			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
 				    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 781521e6a965..5eb0c890dfe4 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -13,6 +13,7 @@
 #include <linux/gpio.h>
 
 #define QCA8K_NUM_PORTS					7
+#define QCA8K_NUM_CPU_PORTS				2
 #define QCA8K_MAX_MTU					9000
 
 #define PHY_ID_QCA8327					0x004dd034
@@ -255,13 +256,18 @@ struct qca8k_match_data {
 	u8 id;
 };
 
+enum {
+	QCA8K_CPU_PORT0,
+	QCA8K_CPU_PORT6,
+};
+
 struct qca8k_priv {
 	u8 switch_id;
 	u8 switch_revision;
-	u8 rgmii_tx_delay;
-	u8 rgmii_rx_delay;
 	bool sgmii_rx_clk_falling_edge;
 	bool sgmii_tx_clk_falling_edge;
+	u8 rgmii_rx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
+	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
 	bool legacy_phy_port_mapping;
 	struct regmap *regmap;
 	struct mii_bus *bus;
-- 
2.32.0

