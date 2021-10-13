Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F350542CEBE
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhJMWmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhJMWl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:57 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3071C061775;
        Wed, 13 Oct 2021 15:39:42 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r18so16218742edv.12;
        Wed, 13 Oct 2021 15:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KYdrbAZ4Duko7XIDZb7sktzy8cdlZfwtkZmR8VvFb5o=;
        b=f4TfWpUAEVJElH/KcVoU7UEKQVTBfgR8wFpWGss/oRLYH2ipZM5k5B+uku2zquajYA
         F3TE5Ogbll2qLO6x1Orgr0WXdA20mtOePgIdS2y29NiP0Rdtw8mRDmQTvQE85xPmBU2M
         5Jo/6p+TsKpff9Qkj/3NBcIIgYZxqq7GS92ga7gJ8f0Lw4+2V2uD8MtWNfRj9ttV1RaB
         DlSQzYlyKG466Da+Qwhiwh4XOKKDzazfu4okaJRdz726TuRbYgqJOIQk0ceKqKLoJd+9
         OzREarfJFsjh3CKSmW80odmp0myVK7swDwxIT95vu59wyq04O2LOWmozRdQuLVMDMnhD
         XPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KYdrbAZ4Duko7XIDZb7sktzy8cdlZfwtkZmR8VvFb5o=;
        b=MtN56kFrANHE6IvX1FDU0+M1viW25Ku5uxlp0ntvOPulaKi7SFH8UpPbLVDVopWB65
         eUjXh2LCxSodCJ57QRlFPAAOTPbFUmMyHBOtO2Q8O+8d6wrg0dXBGNRCzwTYY5iE7X32
         41TJX+t0uTGFUk1J3xM3pFHLhPXYWbXRR4IVRGUooACM7FPxRdbdyNJjkYvw3cLBir8P
         MjkjK/abj5fmW8IrndNBSN5CqivCRT7r5ianRRqDar3SEINX5NIw+rwQhrywKyFYmIp5
         UBcKA8WvBbVN/uNikhJbZ9HdT8b7M+cETCqPDZ9DvXJzqozX9IR3y3UWsz6K3AoHe5e5
         WZ6Q==
X-Gm-Message-State: AOAM533+VCQGDFJYXLaFpqEMEWVssSt4mxYTawfrJdUfWGsPbo8nGQfz
        ppFDrCqczMo+QKibsIGm24Y=
X-Google-Smtp-Source: ABdhPJxGUhkE0r22zWNodrg/PKlENIdsx0HLiDcPWVL+9K1LdO0S1ndNKPH6ouPezOx2r6f83XNrdQ==
X-Received: by 2002:a17:907:7755:: with SMTP id kx21mr2276132ejc.463.1634164781284;
        Wed, 13 Oct 2021 15:39:41 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:40 -0700 (PDT)
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
Subject: [net-next PATCH v7 13/16] net: dsa: qca8k: set internal delay also for sgmii
Date:   Thu, 14 Oct 2021 00:39:18 +0200
Message-Id: <20211013223921.4380-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
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
index 6dcb2546388a..91f2ab3af251 100644
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
 
@@ -1260,13 +1266,54 @@ qca8k_setup(struct dsa_switch *ds)
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
@@ -1315,32 +1362,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
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
@@ -1411,6 +1436,13 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
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

