Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8EB4284C2
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbhJKBdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbhJKBdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:33:07 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6380C061570;
        Sun, 10 Oct 2021 18:30:59 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g8so61224137edt.7;
        Sun, 10 Oct 2021 18:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0aoTGfzbGq5T/qyvNrEnw5XkC8wbWu8jYho5Y6r/vKM=;
        b=BJyf2fZKFPJdYRSdPZQ2ugBhItiKEX6RuIGHz0lXWp3cBjZ0iEdK2uLJ3EX8+azpXN
         rWxenQ25FAam4MIUCwxDizaqdLIVm1e72yYcsrajZzHqtoIHhaZitza/hUn7KYLKDIIB
         gb8CggxbIlCEqCjpMnP7L6pDJoQvxN8hg86K6h1ntFBPep4rftC1V22ZYG9xXRqUJGuo
         sues4vbzbsHnk9/Q/aRIVYSUxhfgnXZuh6AleCWZSRd6zqu/sv81rwOA9Lqb4GFgoNgF
         3cx1Ee7yaBT8zEF4rltfa1I1hhVdcy0SEgGLwf6pvukNorkEZDCnO/hSSEyWj8shzJt7
         U9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0aoTGfzbGq5T/qyvNrEnw5XkC8wbWu8jYho5Y6r/vKM=;
        b=4f2nIcPqLVv6dwHLPcH9UJIhnVoBhJW9Vy3jFC9kXRI6dHAn4aGSmHH0Jmy2AY7m4m
         pi0D6OwgjBI7UfTTK69t3L+hNbrcPSrC0jONZuwXii7cWj7NLAniNQTn7F+GUsyCD450
         DMTUvg/O/tA1LKdivfllw+Q3OM+Xbt1mHvqqymY5fZTg9o5UyWjXwftV9v530ZY0s7bk
         RViZ8Ac8T/l9FWUOV/hNkT0upyfVwZbEkobupkCsuPRosm4AeHIOmE11n1fYNYlIDT03
         SPJHbQw2Glr4c3MJY6JlWH/ExzoxjIsBZEcBUO8CjM0O7AB+YINFFsqbU9ZdKKSrXVt5
         ABFA==
X-Gm-Message-State: AOAM532DWjxZMZQIZgefQUXTGjkuwsboGtXxBh+akktvf7VfOmqishJ2
        l5NYQQ8utmOd+az3yaNmgzI=
X-Google-Smtp-Source: ABdhPJyrYIuu+/RbDUnGt9YmbyFtpY2KIxiw8kAqxQzP8ZOnv3U2dm7hVRGJe3m0tFBn5YxJB3lKuA==
X-Received: by 2002:a05:6402:1d52:: with SMTP id dz18mr26225968edb.49.1633915858156;
        Sun, 10 Oct 2021 18:30:58 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:57 -0700 (PDT)
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
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v5 13/14] drivers: net: dsa: qca8k: set internal delay also for sgmii
Date:   Mon, 11 Oct 2021 03:30:23 +0200
Message-Id: <20211011013024.569-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 81 +++++++++++++++++++++++++++--------------
 drivers/net/dsa/qca8k.h |  2 +
 2 files changed, 55 insertions(+), 28 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index cb66bdccc233..28635f4feaf5 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -998,6 +998,7 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 		case PHY_INTERFACE_MODE_RGMII_ID:
 		case PHY_INTERFACE_MODE_RGMII_TXID:
 		case PHY_INTERFACE_MODE_RGMII_RXID:
+		case PHY_INTERFACE_MODE_SGMII:
 			delay = 0;
 
 			if (!of_property_read_u32(port_dn, "tx-internal-delay-ps", &delay))
@@ -1030,8 +1031,6 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 
 			priv->rgmii_rx_delay[cpu_port_index] = delay;
 
-			break;
-		case PHY_INTERFACE_MODE_SGMII:
 			if (of_property_read_bool(port_dn, "qca,sgmii-txclk-falling-edge"))
 				priv->sgmii_tx_clk_falling_edge = true;
 
@@ -1254,13 +1253,54 @@ qca8k_setup(struct dsa_switch *ds)
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
@@ -1309,32 +1349,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
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
+		qca8k_write(priv, reg, QCA8K_PORT_PAD_RGMII_EN);
 
-		if (priv->rgmii_rx_delay[cpu_port_index]) {
-			delay = priv->rgmii_rx_delay[cpu_port_index];
-
-			val |= QCA8K_PORT_PAD_RGMII_RX_DELAY(delay) |
-			       QCA8K_PORT_PAD_RGMII_RX_DELAY_EN;
-		}
-
-		/* Set RGMII delay based on the selected values */
-		qca8k_write(priv, reg, val);
+		/* Configure rgmii delay */
+		qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
 
 		/* QCA8337 requires to set rgmii rx delay for all ports.
 		 * This is enabled through PORT5_PAD_CTRL for all ports,
@@ -1405,6 +1423,13 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
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

