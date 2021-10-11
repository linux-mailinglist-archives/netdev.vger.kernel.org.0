Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D834284A3
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbhJKBcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbhJKBcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:32:45 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA80C061570;
        Sun, 10 Oct 2021 18:30:46 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id d9so37230780edh.5;
        Sun, 10 Oct 2021 18:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+GGW6PTvGR0dV/Uc2T12R80rWJP3U3Bf3ZdChQaR0iw=;
        b=fdH8v5LUIieCGUrggBFs1oVQzL//uFaK029X0nKQ64sEnAKJl1NzhIx+wbTWFJ0fOW
         6fJjjKve3bjpPGEtA59bxTtT0Xos1D4n5Urobe8oW5oxb+aVu/qAJPD6gXcgxjyd2wyZ
         qJML7v1utvpO7vMBqq2yGYwhbM9Z/wIT7M6wTq6tCS8J2GF1WsU+mDSD3av6vq0esSdH
         LINGy9m9/q+/P10NCujmP82F3TaWktHhv9Kag4NmFFEPZ7K2Gu8Z7idUlZ1TswSmt9i6
         SHvHB6ja01RJoWGqE1h0DIcdTcJk8fnk8VBuaZ6hPlLsExEWGpcjkhmKFughOXlxE92g
         l7Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+GGW6PTvGR0dV/Uc2T12R80rWJP3U3Bf3ZdChQaR0iw=;
        b=eHXWJjs9Egrn8WdwJwE/oA+mbI7LM8Imr7YOMHkK1cm1AjNzh3BrwygD5FMCfc9bys
         39poDPROA6CiGcaB0DIe90Bsm9kwCzaQlyo8+LYZkh5x5szjOzdLVITitAIJ3EBM71b/
         WDQNuYbjSpyyxigKDkRRcUlb7xG7F9zK+jpF7sNJA77zNiJlLxG2e95gQlvNrH+POpYZ
         7zJiIyhfd25mp8vn5BdArPzqFz1/b7fJteC0hkD9bvEu727E5tRkDgB+u0mEIDXcS7jM
         bGkycg4stheN1gnUZ87uVPehy0dk+ukDpbeHUyqMJrquI/vl8pchkJ+eF3uOOeWz4nTl
         oc1A==
X-Gm-Message-State: AOAM532UFfGgmDsDXLBktzrzndF0wFEaUpaQQvdDAbMRDjs4hYIDd8x9
        fxaRUFg3XLaZsJocbegN//Jagy1Wg+Y=
X-Google-Smtp-Source: ABdhPJw2u/FyUHQJiNv3lNkR/pnx7USk1YCNpfhyLagrV+ng3fOMbcVgreQ/ppYuMKYpo/7/U4lnDQ==
X-Received: by 2002:a17:906:230c:: with SMTP id l12mr21700463eja.52.1633915844815;
        Sun, 10 Oct 2021 18:30:44 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:44 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: [net-next PATCH v5 03/14] net: dsa: qca8k: add support for sgmii falling edge
Date:   Mon, 11 Oct 2021 03:30:13 +0200
Message-Id: <20211011013024.569-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for this in the qca8k driver. Also add support for SGMII
rx/tx clock falling edge. This is only present for pad0, pad5 and
pad6 have these bit reserved from Documentation. Add a comment that this
is hardcoded to PAD0 as qca8327/28/34/37 have an unique sgmii line and
setting falling in port0 applies to both configuration with sgmii used
for port0 or port6.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 57 +++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  4 +++
 2 files changed, 61 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a892b897cd0d..e335a4cfcb75 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -977,6 +977,36 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
 	return ret;
 }
 
+static int
+qca8k_parse_port_config(struct qca8k_priv *priv)
+{
+	struct device_node *port_dn;
+	phy_interface_t mode;
+	struct dsa_port *dp;
+	int port;
+
+	/* We have 2 CPU port. Check them */
+	for (port = 0; port < QCA8K_NUM_PORTS; port++) {
+		/* Skip every other port */
+		if (port != 0 && port != 6)
+			continue;
+
+		dp = dsa_to_port(priv->ds, port);
+		port_dn = dp->dn;
+
+		of_get_phy_mode(port_dn, &mode);
+		if (mode == PHY_INTERFACE_MODE_SGMII) {
+			if (of_property_read_bool(port_dn, "qca,sgmii-txclk-falling-edge"))
+				priv->sgmii_tx_clk_falling_edge = true;
+
+			if (of_property_read_bool(port_dn, "qca,sgmii-rxclk-falling-edge"))
+				priv->sgmii_rx_clk_falling_edge = true;
+		}
+	}
+
+	return 0;
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -990,6 +1020,11 @@ qca8k_setup(struct dsa_switch *ds)
 		return -EINVAL;
 	}
 
+	/* Parse CPU port config to be later used in phy_link mac_config */
+	ret = qca8k_parse_port_config(priv);
+	if (ret)
+		return ret;
+
 	mutex_init(&priv->reg_mutex);
 
 	/* Start by setting up the register mapping */
@@ -1274,6 +1309,28 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		}
 
 		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
+
+		/* For qca8327/qca8328/qca8334/qca8338 sgmii is unique and
+		 * falling edge is set writing in the PORT0 PAD reg
+		 */
+		if (priv->switch_id == QCA8K_ID_QCA8327 ||
+		    priv->switch_id == QCA8K_ID_QCA8337)
+			reg = QCA8K_REG_PORT0_PAD_CTRL;
+
+		val = 0;
+
+		/* SGMII Clock phase configuration */
+		if (priv->sgmii_rx_clk_falling_edge)
+			val |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
+
+		if (priv->sgmii_tx_clk_falling_edge)
+			val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
+
+		if (val)
+			ret = qca8k_rmw(priv, reg,
+					QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
+					QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
+					val);
 		break;
 	default:
 		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index fc7db94cc0c9..bc9c89dd7e71 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -35,6 +35,8 @@
 #define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
 #define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
 #define QCA8K_REG_PORT0_PAD_CTRL			0x004
+#define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
+#define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
 #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
@@ -260,6 +262,8 @@ struct qca8k_priv {
 	u8 switch_revision;
 	u8 rgmii_tx_delay;
 	u8 rgmii_rx_delay;
+	bool sgmii_rx_clk_falling_edge;
+	bool sgmii_tx_clk_falling_edge;
 	bool legacy_phy_port_mapping;
 	struct regmap *regmap;
 	struct mii_bus *bus;
-- 
2.32.0

