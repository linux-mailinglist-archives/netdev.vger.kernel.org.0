Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DCD4280CB
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhJJLTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbhJJLSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:22 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD22CC0613DF;
        Sun, 10 Oct 2021 04:16:20 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id d9so31490814edh.5;
        Sun, 10 Oct 2021 04:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TH+I2aVPtNSn1H4wrwimzYH2fn7rX1yhAgj/wkO2epY=;
        b=SAwKikuFE7Gqk2mpSPnL6vEAUJ7Wa4nTc98aaI0981t4K/Fno551seimvndVh+iO5/
         jP1HW0ArDjUIVrE74G1Cvg7ijRi0abJh8IrXwRZbS/9siNIX1352nYGCkiwKypUCN4rF
         ARCztPwpy1DZ+lIzB3vXN5xeltdvyVHFOPmU1sSdVYf7mLtD1wgtXxQrZis89t+MOylp
         U6WERl8sCxpJ2ohok9YghzcLLzq5xBy2ixOitUDZg/rF20cXy4LlTXhggDU2z6MmXYkc
         YJGV2ZrzgpToWqQt0TzDSHqWNd4zsMoeGx0+Zy8Vpw5hiDy/vjXrrZLKTBWJiYh2bqVj
         XXmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TH+I2aVPtNSn1H4wrwimzYH2fn7rX1yhAgj/wkO2epY=;
        b=jrosKiKB8QSvvQl81XKpaRFFnY+m6QmrXjEN52UvP7zSi5mAMQY4G38ckZpEpdi6JD
         zpAfdp6f9fsWwxs8gL4/6fbNi7gHZR4awTfE4hw4d62bCvXWLcP5MkOf3mB2E9c6bxwi
         I5SfDZu5wg1MpeHyDGrqwwV9GiZ6nbgLW5CcQjbysd8EfCQHzhl9ZyQzustNSZ4OmpeO
         RqpzNNGZutNql/zWKANtZnJl+xd0leIloGhh+7trjqzlTkeRqMVUwWShSLKTt9bFF3yD
         YaOx39ryHd+9EnmyZBouSatYIClIb4o4GdGUanCIoTbr4SDHk+1UCfn22N6T00g9pG9u
         sFKA==
X-Gm-Message-State: AOAM531cJIN3hMTvLg7AePOCD4n9mse+nx8dxy9Os5E9Wm+qLDkpU0Fe
        qxWtzE14KxKqPXZKO7ESFak=
X-Google-Smtp-Source: ABdhPJz92WfjiBDX77VFxq8S4b0B9O88QGuVYaRLINnw1XGWmfheI8GeS7+7V/3Td2y290GBherxLg==
X-Received: by 2002:a17:906:5cf:: with SMTP id t15mr18081370ejt.375.1633864579275;
        Sun, 10 Oct 2021 04:16:19 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:19 -0700 (PDT)
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
Subject: [net-next PATCH v4 13/13] drivers: net: dsa: qca8k: set internal delay also for sgmii
Date:   Sun, 10 Oct 2021 13:15:56 +0200
Message-Id: <20211010111556.30447-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010111556.30447-1-ansuelsmth@gmail.com>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 102 +++++++++++++++++++++++++---------------
 drivers/net/dsa/qca8k.h |   2 +
 2 files changed, 67 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 947346511514..444894d108ee 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1164,13 +1164,67 @@ qca8k_setup(struct dsa_switch *ds)
 	return 0;
 }
 
+static void
+qca8k_mac_config_setup_internal_delay(struct qca8k_priv *priv, struct dsa_port *dp,
+				      u32 reg, const struct phylink_link_state *state)
+{
+	u32 delay, val = 0;
+	int ret;
+
+	if (state->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    state->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
+	    state->interface == PHY_INTERFACE_MODE_SGMII) {
+		if (of_property_read_u32(dp->dn, "tx-internal-delay-ps", &delay))
+			delay = 1;
+		else
+			/* Switch regs accept value in ns, convert ps to ns */
+			delay = delay / 1000;
+
+		if (delay > QCA8K_MAX_DELAY) {
+			dev_err(priv->dev, "rgmii tx delay is limited to a max value of 3ns, setting to the max value");
+			delay = 3;
+		}
+
+		val |= QCA8K_PORT_PAD_RGMII_TX_DELAY(delay) |
+			QCA8K_PORT_PAD_RGMII_TX_DELAY_EN;
+	}
+
+	if (state->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    state->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
+	    state->interface == PHY_INTERFACE_MODE_SGMII) {
+		if (of_property_read_u32(dp->dn, "rx-internal-delay-ps", &delay))
+			delay = 2;
+		else
+			/* Switch regs accept value in ns, convert ps to ns */
+			delay = delay / 1000;
+
+		if (delay > QCA8K_MAX_DELAY) {
+			dev_err(priv->dev, "rgmii rx delay is limited to a max value of 3ns, setting to the max value");
+			delay = 3;
+		}
+
+		val |= QCA8K_PORT_PAD_RGMII_RX_DELAY(delay) |
+			QCA8K_PORT_PAD_RGMII_RX_DELAY_EN;
+	}
+
+	/* Set RGMII delay based on the selected values */
+	ret = qca8k_rmw(priv, reg,
+			QCA8K_PORT_PAD_RGMII_TX_DELAY_MASK |
+			QCA8K_PORT_PAD_RGMII_TX_DELAY_MASK |
+			QCA8K_PORT_PAD_RGMII_RX_DELAY_MASK |
+			QCA8K_PORT_PAD_RGMII_RX_DELAY_EN,
+			val);
+	if (ret)
+		dev_err(priv->dev, "Failed to set internal delay for CPU port %d", dp->index);
+}
+
 static void
 qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			 const struct phylink_link_state *state)
 {
 	struct qca8k_priv *priv = ds->priv;
 	struct dsa_port *dp;
-	u32 reg, val, delay;
+	u32 reg, val;
 	int ret;
 
 	switch (port) {
@@ -1222,44 +1276,11 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 		dp = dsa_to_port(ds, port);
-		val = QCA8K_PORT_PAD_RGMII_EN;
-
-		if (state->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-		    state->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
-			if (of_property_read_u32(dp->dn, "tx-internal-delay-ps", &delay))
-				delay = 1;
-			else
-				/* Switch regs accept value in ns, convert ps to ns */
-				delay = delay / 1000;
-
-			if (delay > QCA8K_MAX_DELAY) {
-				dev_err(priv->dev, "rgmii tx delay is limited to a max value of 3ns, setting to the max value");
-				delay = 3;
-			}
-
-			val |= QCA8K_PORT_PAD_RGMII_TX_DELAY(delay) |
-			       QCA8K_PORT_PAD_RGMII_TX_DELAY_EN;
-		}
 
-		if (state->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-		    state->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
-			if (of_property_read_u32(dp->dn, "rx-internal-delay-ps", &delay))
-				delay = 2;
-			else
-				/* Switch regs accept value in ns, convert ps to ns */
-				delay = delay / 1000;
-
-			if (delay > QCA8K_MAX_DELAY) {
-				dev_err(priv->dev, "rgmii rx delay is limited to a max value of 3ns, setting to the max value");
-				delay = 3;
-			}
-
-			val |= QCA8K_PORT_PAD_RGMII_RX_DELAY(delay) |
-			       QCA8K_PORT_PAD_RGMII_RX_DELAY_EN;
-		}
+		qca8k_write(priv, reg, QCA8K_PORT_PAD_RGMII_EN);
 
-		/* Set RGMII delay based on the selected values */
-		qca8k_write(priv, reg, val);
+		/* Configure rgmii delay from dp or taking advised values */
+		qca8k_mac_config_setup_internal_delay(priv, dp, reg, state);
 
 		/* QCA8337 requires to set rgmii rx delay for all ports.
 		 * This is enabled through PORT5_PAD_CTRL for all ports,
@@ -1341,6 +1362,13 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 					QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
 					QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
 					val);
+
+		/* From original code is reported port instability as SGMII also
+		 * require delay set. Apply advised values here or take them from DT.
+		 */
+		if (state->interface == PHY_INTERFACE_MODE_SGMII)
+			qca8k_mac_config_setup_internal_delay(priv, dp, reg, state);
+
 		break;
 	default:
 		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index c032db5e0d41..92867001cc34 100644
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

