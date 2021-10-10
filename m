Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A67427E64
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhJJB7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhJJB6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:25 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB62BC06177B;
        Sat,  9 Oct 2021 18:56:24 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id a25so36067227edx.8;
        Sat, 09 Oct 2021 18:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=65S6lCh47tZ5HxQyo6DocfizCuDWrcJIBiYIGFhvY1k=;
        b=mJWQtEL0O+3B0eLbY62Rh4f1pwQ7EXajJNKfLKm+Qo0CjYjQzRvwMYFEBmbCX4VccU
         PtxrHPANjnZF8Ybbs3SrpC/4iAoZZjl5xQ9fgxE32YHjWaOIl83rL0UOBC0OJgV8SBIf
         7ChvswFvD4mGjV85RPTl7vUDPX/dqzPLk98zzkhlwNFI5F67QvP9WRhkfFYlnj+LifAR
         dHXV6U4su96n/9v3hUAErwokU7SB/h0sfm4Es7L2UPkxqnPGx/XUKKXDD0535Vzlm8IW
         8/Qjqes1gIZERVtH7koafHvPbbfCYCLKOJoRehekKwaldLlOzmaq598PDcSM81dGp/jd
         nGFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=65S6lCh47tZ5HxQyo6DocfizCuDWrcJIBiYIGFhvY1k=;
        b=PZ1m8wp5MnzKo8CjTxZbZ31CN6i6jPAzLtveH437GYJ/USCEdT62HRI6v06wszcAX8
         obvop6spYbIJheWQJSudimKCTYaE57PRzrgfP+RMlgHPARKqnNuIP8eX0zfDPkD3m+Hm
         r+FaqkLbG4OiwSf9tak+CnVycKcOvI/ONNpQchckfknT4fD1z0lTz0sdjlhyWuBgPfUn
         hhlANdrcj+7Yc3zucFfnT53wzxIngS2SFYfWVJ/k/gSQPd1x+DFB5gylbMnBKGknphMz
         liCBrEE4mnVZfU92Ogny0WDy0XYIcghPhNd0THjqq4uU7ZWC3hZU+duPUzRMbEYwS8ov
         AvRA==
X-Gm-Message-State: AOAM532qPTr9aV0orpOobxvWIUDLfreL8y9zXvTQbXWXPcKjH32/9uh0
        g6g5M8W4vrqnXUPzKepUBCY=
X-Google-Smtp-Source: ABdhPJxMIt7F4ILICHqyAP5I4Py4EGQsUUf5FxCti1SBd22xO3sSAhGimgGMvv4FQEqyiIH61oXTiw==
X-Received: by 2002:a50:cf4d:: with SMTP id d13mr28232129edk.50.1633830983188;
        Sat, 09 Oct 2021 18:56:23 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:22 -0700 (PDT)
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
Subject: [net-next PATCH v3 13/13] drivers: net: dsa: qca8k: set internal delay also for sgmii
Date:   Sun, 10 Oct 2021 03:56:03 +0200
Message-Id: <20211010015603.24483-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010015603.24483-1-ansuelsmth@gmail.com>
References: <20211010015603.24483-1-ansuelsmth@gmail.com>
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
index 7c68c272ce3a..21776826bf2e 100644
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

