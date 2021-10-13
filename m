Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4621B42CE9C
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhJMWlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhJMWle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:34 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF765C061753;
        Wed, 13 Oct 2021 15:39:30 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g10so16517153edj.1;
        Wed, 13 Oct 2021 15:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nv0JI2Yi8F4ugKm2nq2I47PKUAQY85Q9w+53j/w2fIA=;
        b=d1yUoAb0YfhGJRb/FtnWkxWQ8dbtshxvu6gZ6JZ4dWTe1ByHMLGi3owwrdPK90TtrS
         ePzupmaOrimaqaYuXIGJXfu4xZYcEWzxzo+TtM+8UWGrl3Uou0KbqphviBR+1eemlx55
         /bDgJe5u8cM4UmhjKblu9ODcOJs49yARcgsmtglUO2CCQAWD23RM9bhIBtcADtYrxKs5
         Obj82eY0gP0mI32BvR1G3Krg9bDgdkzZbCHY66PPDmqz5gEcV6goFfk2CQbl4Ni9GZA/
         smsc1JILCyE5Xj928sEMxw+Gb4WTq7YItLNe4ugM1h82JdVsHd6uyWbY42E/8+5QQJ+y
         a9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nv0JI2Yi8F4ugKm2nq2I47PKUAQY85Q9w+53j/w2fIA=;
        b=Lx0c9x8CYCn/M/mIkeGY1iCW++0vgmSXIHlGGvGT7R2LjdnOFWXkm6FioiY7y3v6Xi
         9FNFsQVGaAYiqbdQVRQPwGHupwwlGnkICe4k9/3a8RYYZ16lhraox56MutTQ/caY5FQ7
         HnE0jaqlFDtc2cL07GdqZ1ErG5RGF5u9O0c4RrCRCT1kc1XtG/Gw/4+1UZIuLKcOp4ZD
         fdWZ6/RdhVO9MJ8xxLhg/YUNH/UUb5RFlzwoB7aO8Kfw8ScE5KByjVFNa8uH96Tte2tz
         eByzeUtLbdCXNLlpkuKQA0Phc++mxkFZx5rUJPKnj1c1Ih1VPGR3rzMiz7o07QLkwAEf
         vaaw==
X-Gm-Message-State: AOAM531DwOXOG2aCm2SNUvcfBmPZZ3f8sN3AQgKBi8ZLkr3LgCeZ/Xyf
        ShMCFZqrNHwzhuER1V6onyM=
X-Google-Smtp-Source: ABdhPJwEGRGDTNLloL977h0IFWyAzwMpBr57ada6wBInjvS16HU1vrWn25e5s1wNj/+ciNNFS2KPzg==
X-Received: by 2002:a17:906:374b:: with SMTP id e11mr2305320ejc.492.1634164769188;
        Wed, 13 Oct 2021 15:39:29 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:28 -0700 (PDT)
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
Cc:     Matthew Hagan <mnhagan88@gmail.com>
Subject: [net-next PATCH v7 03/16] net: dsa: qca8k: add support for sgmii falling edge
Date:   Thu, 14 Oct 2021 00:39:08 +0200
Message-Id: <20211013223921.4380-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
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

Co-developed-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 63 +++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  4 +++
 2 files changed, 67 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a892b897cd0d..22d6e4abb986 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -977,6 +977,42 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
 	return ret;
 }
 
+static int
+qca8k_parse_port_config(struct qca8k_priv *priv)
+{
+	struct device_node *port_dn;
+	phy_interface_t mode;
+	struct dsa_port *dp;
+	int port, ret;
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
+		if (!of_device_is_available(port_dn))
+			continue;
+
+		ret = of_get_phy_mode(port_dn, &mode);
+		if (ret)
+			continue;
+
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
@@ -990,6 +1026,11 @@ qca8k_setup(struct dsa_switch *ds)
 		return -EINVAL;
 	}
 
+	/* Parse CPU port config to be later used in phy_link mac_config */
+	ret = qca8k_parse_port_config(priv);
+	if (ret)
+		return ret;
+
 	mutex_init(&priv->reg_mutex);
 
 	/* Start by setting up the register mapping */
@@ -1274,6 +1315,28 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
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

