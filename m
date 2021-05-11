Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9688D379C8A
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhEKCJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbhEKCIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:08:44 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E08C0613ED;
        Mon, 10 May 2021 19:07:34 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l14so18489449wrx.5;
        Mon, 10 May 2021 19:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yD4Erupp9AwCtDe5FZLfHVR9rF7hUw4t5/pS+QNEVOM=;
        b=GeroTpCNkblwy2PlOEYdyOMfuAOF9673c4/92olkxC+kUaW+tgvBK5zXdUwBqCF+Rl
         Etw6MfFZ72Rv+XJ5LhmP4McX+wJ+lVrHHjFSFKRgYhQYB+PnoaitpoHbrqobeOjBHkPu
         eOhnMs6o1niiBn4zZI8cJuIleLf6y7MJX+taH5cLDTZcCFPC3i+U90ThTsT8lwR01D29
         Thl8c8AocW6AAlQxHlD3eoAqVu/a9JOX+j/mQeRwFhNHXCScxdG2HAg5QzZDEyciEQVH
         UKkYoWp+SOHMLRibtIhljee8/T3aqzi4atRO8PQ6PPxDaPg0KV0SCFk3lez8L/+fR5fw
         IcDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yD4Erupp9AwCtDe5FZLfHVR9rF7hUw4t5/pS+QNEVOM=;
        b=RCu95T9fB8bA1JGa8k/ooLCqiSEaL1x3y7q+o0g9xmpMhuVzh0+pnmKW3XHcHKBUc0
         Lzzkd1sGK0bXAvSnyH78YIc32V2p1YP1KC8tmuciWh4gOYxANG+F6CENQxUcrUDEOafB
         2bwhpqO+UyO/3dFk8DvM+5RHpTIYM/ycCFMkQ9+re39KlNinoIs4evR6G6D747dStq6W
         ZrxLh7njMGrnj49yJqS+trRg2X+GGVJ3ZY/suTafvyTdXWiKIQlfl3qi9/9LYlse80Mj
         BJ+FoUmErBxzcJQVJwn+IrT2ua8xsc8J9glxvhRS4zGWbBo90PCqtRC9T8PmrpCN/POo
         q/fA==
X-Gm-Message-State: AOAM530Wprrlox4em26bVFg/vKNJwTpeVne4mzRgRA+Heq6L5xTz4Sfh
        Md4BCA64KgfiDh5fFfDSEik=
X-Google-Smtp-Source: ABdhPJxPA5ya/quxKXhksliMSB4fWVKpE+hWckZiWmvm5gJ2/1hA8CUIOLBiys67FBY0UBl/UjP3DA==
X-Received: by 2002:a5d:638f:: with SMTP id p15mr34538414wru.255.1620698853274;
        Mon, 10 May 2021 19:07:33 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:33 -0700 (PDT)
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
Subject: [RFC PATCH net-next v5 11/25] net: dsa: qca8k: add priority tweak to qca8337 switch
Date:   Tue, 11 May 2021 04:04:46 +0200
Message-Id: <20210511020500.17269-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port 5 of the qca8337 have some problem in flood condition. The
original legacy driver had some specific buffer and priority settings
for the different port suggested by the QCA switch team. Add this
missing settings to improve switch stability under load condition.
The packet priority tweak is only needed for the qca8337 switch and
other qca8k switch are not affected.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 47 +++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h | 25 ++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 693bd9fd532b..65f27d136aef 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -779,6 +779,7 @@ qca8k_setup(struct dsa_switch *ds)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int ret, i;
+	u32 mask;
 
 	/* Make sure that port 0 is the cpu port */
 	if (!dsa_is_cpu_port(ds, 0)) {
@@ -884,6 +885,51 @@ qca8k_setup(struct dsa_switch *ds)
 		}
 	}
 
+	/* The port 5 of the qca8337 have some problem in flood condition. The
+	 * original legacy driver had some specific buffer and priority settings
+	 * for the different port suggested by the QCA switch team. Add this
+	 * missing settings to improve switch stability under load condition.
+	 * This problem is limited to qca8337 and other qca8k switch are not affected.
+	 */
+	if (priv->switch_id == QCA8K_ID_QCA8337) {
+		for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+			switch (i) {
+			/* The 2 CPU port and port 5 requires some different
+			 * priority than any other ports.
+			 */
+			case 0:
+			case 5:
+			case 6:
+				mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x4) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x4) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI4(0x6) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI5(0x8) |
+					QCA8K_PORT_HOL_CTRL0_EG_PORT(0x1e);
+				break;
+			default:
+				mask = QCA8K_PORT_HOL_CTRL0_EG_PRI0(0x3) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI1(0x4) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI2(0x6) |
+					QCA8K_PORT_HOL_CTRL0_EG_PRI3(0x8) |
+					QCA8K_PORT_HOL_CTRL0_EG_PORT(0x19);
+			}
+			qca8k_write(priv, QCA8K_REG_PORT_HOL_CTRL0(i), mask);
+
+			mask = QCA8K_PORT_HOL_CTRL1_ING(0x6) |
+			QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
+			QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
+			QCA8K_PORT_HOL_CTRL1_WRED_EN;
+			qca8k_rmw(priv, QCA8K_REG_PORT_HOL_CTRL1(i),
+				  QCA8K_PORT_HOL_CTRL1_ING_BUF |
+				  QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN |
+				  QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN |
+				  QCA8K_PORT_HOL_CTRL1_WRED_EN,
+				  mask);
+		}
+	}
+
 	/* Setup our port MTUs to match power on defaults */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
 		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
@@ -1569,6 +1615,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		return -ENODEV;
 	}
 
+	priv->switch_id = id;
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
 		return -ENOMEM;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 87a8b10459c6..42d90836dffa 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -168,6 +168,30 @@
 #define   QCA8K_PORT_LOOKUP_STATE			GENMASK(18, 16)
 #define   QCA8K_PORT_LOOKUP_LEARN			BIT(20)
 
+#define QCA8K_REG_PORT_HOL_CTRL0(_i)			(0x970 + (_i) * 0x8)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI0_BUF		GENMASK(3, 0)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI0(x)		((x) << 0)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI1_BUF		GENMASK(7, 4)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI1(x)		((x) << 4)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI2_BUF		GENMASK(11, 8)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI2(x)		((x) << 8)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI3_BUF		GENMASK(15, 12)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI3(x)		((x) << 12)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI4_BUF		GENMASK(19, 16)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI4(x)		((x) << 16)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI5_BUF		GENMASK(23, 20)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PRI5(x)		((x) << 20)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PORT_BUF		GENMASK(29, 24)
+#define   QCA8K_PORT_HOL_CTRL0_EG_PORT(x)		((x) << 24)
+
+#define QCA8K_REG_PORT_HOL_CTRL1(_i)			(0x974 + (_i) * 0x8)
+#define   QCA8K_PORT_HOL_CTRL1_ING_BUF			GENMASK(3, 0)
+#define   QCA8K_PORT_HOL_CTRL1_ING(x)			((x) << 0)
+#define   QCA8K_PORT_HOL_CTRL1_EG_PRI_BUF_EN		BIT(6)
+#define   QCA8K_PORT_HOL_CTRL1_EG_PORT_BUF_EN		BIT(7)
+#define   QCA8K_PORT_HOL_CTRL1_WRED_EN			BIT(8)
+#define   QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN		BIT(16)
+
 /* Pkt edit registers */
 #define QCA8K_EGRESS_VLAN(x)				(0x0c70 + (4 * (x / 2)))
 
@@ -220,6 +244,7 @@ struct qca8k_match_data {
 };
 
 struct qca8k_priv {
+	u8 switch_id;
 	struct regmap *regmap;
 	struct mii_bus *bus;
 	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
-- 
2.30.2

