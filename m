Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3105837326C
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbhEDWbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbhEDWao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:44 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF862C06134A;
        Tue,  4 May 2021 15:29:47 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id zg3so15586248ejb.8;
        Tue, 04 May 2021 15:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WdmMqy47LbsKzfMsmzOvIPOome7OVoX6XWH5q47dxMY=;
        b=AbhEDjYMAZX+uoBmnYbdOVezP6G8s4dqWASFK25gQQGxp5cuob3W32vv9OG1tPCvlW
         +7mijRH0XKAjgckL73H8ku/p2kOY5Cl/yWksV6l8SP8ByYhas8rYyNZogr48r0sSMtA0
         UeNSapLoyZ6Ia9MN/DDmDSpr2Fzmwl1yiqFKJLMoGphc8cY1YZp1sMFmdBWG5mdqdeIf
         et/1kbxXDLCB4csXAoy2JgGIB5K9rz9TOJV/Gk+MyL9wn+WCcyGiDPyB2E0s1hkbmpvZ
         +KeDYAoHTDTGZlVH49tBPSg7aMIO38P8Y1HDH08KqLIfSU91nYj1kkJw/CZVE2hl68Uh
         RshQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WdmMqy47LbsKzfMsmzOvIPOome7OVoX6XWH5q47dxMY=;
        b=ihq1WNsN1tahr+0C4+z9lr7DD9N6tyHp0XSXJBaiPRSwVgDKsUaCyG6ftwTmCb/5X8
         6KbXidFz8G/NjgcHhvIkHtX5F9BX/LC093MFFHh52LUqSld7Az3N/OBhIoUMm2lg5iA8
         Bvos7wWS7IIzq6S3g5Y3uhdpgQIusZ9ltuRgGP3D/bPSfxIx8iho31PFMVIMHuO1jCo+
         qT7BoSMcgjgIoGI7s/dKAtzRT1lOqGwduf23qchTeeCwaWQGUqr14YqGf8Dm5nQ3MTlf
         oMnbH0GvIWzF4cA2bvnOUjfyc94ecbEc4YMTB9eC/5cE0i4WKquTwt2V5+lthedE+Q17
         VZWA==
X-Gm-Message-State: AOAM530WFPUcnhSgynJIaVZtT/bCDCPIPpgdCfO9ziBMVXof2idPWOZk
        QAayFRLuS0WKgKPUdeBsOhYo/E0utFLTEw==
X-Google-Smtp-Source: ABdhPJw505w4g/1rbVrRfTUCV9D8Lr4Xi2AcEXbbsuXQu7pVfqesOOiFSsn+9mp/JEovpvF7TlpACQ==
X-Received: by 2002:a17:906:4e82:: with SMTP id v2mr18068703eju.278.1620167386359;
        Tue, 04 May 2021 15:29:46 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:45 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 12/20] net: dsa: qca8k: add support for switch rev
Date:   Wed,  5 May 2021 00:29:06 +0200
Message-Id: <20210504222915.17206-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k internal phy driver require some special debug value to be set
based on the switch revision. Rework the switch id read function to
also read the chip revision.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 50 ++++++++++++++++++++++++++---------------
 drivers/net/dsa/qca8k.h |  6 +++--
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ce3606d8e6a4..22334d416f53 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1586,12 +1586,38 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
 };
 
+static int qca8k_read_switch_id(struct qca8k_priv *priv)
+{
+	const struct qca8k_match_data *data;
+	u32 val;
+	u8 id;
+
+	/* get the switches ID from the compatible */
+	data = of_device_get_match_data(priv->dev);
+	if (!data)
+		return -ENODEV;
+
+	val = qca8k_read(priv, QCA8K_REG_MASK_CTRL);
+	if (val < 0)
+		return -ENODEV;
+
+	id = QCA8K_MASK_CTRL_DEVICE_ID(val & QCA8K_MASK_CTRL_DEVICE_ID_MASK);
+	if (id != data->id) {
+		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
+		return -ENODEV;
+	}
+
+	/* Save revision to communicate to the internal PHY driver */
+	priv->switch_revision = (val & QCA8K_MASK_CTRL_REV_ID_MASK);
+
+	return 0;
+}
+
 static int
 qca8k_sw_probe(struct mdio_device *mdiodev)
 {
-	const struct qca8k_match_data *data;
 	struct qca8k_priv *priv;
-	u32 id;
+	int ret;
 
 	/* allocate the private data struct so that we can probe the switches
 	 * ID register
@@ -1617,22 +1643,10 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		gpiod_set_value_cansleep(priv->reset_gpio, 0);
 	}
 
-	/* get the switches ID from the compatible */
-	data = of_device_get_match_data(&mdiodev->dev);
-	if (!data)
-		return -ENODEV;
-
-	/* read the switches ID register */
-	id = qca8k_read(priv, QCA8K_REG_MASK_CTRL);
-	if (id < 0)
-		return id;
-
-	id >>= QCA8K_MASK_CTRL_ID_S;
-	id &= QCA8K_MASK_CTRL_ID_M;
-	if (id != data->id) {
-		dev_err(&mdiodev->dev, "Switch id detected %x but expected %x", id, data->id);
-		return -ENODEV;
-	}
+	/* Check the detected switch id */
+	ret = qca8k_read_switch_id(priv);
+	if (ret)
+		return ret;
 
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 5fb68dbfa85a..0b503f78bf92 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -28,8 +28,10 @@
 
 /* Global control registers */
 #define QCA8K_REG_MASK_CTRL				0x000
-#define   QCA8K_MASK_CTRL_ID_M				0xff
-#define   QCA8K_MASK_CTRL_ID_S				8
+#define   QCA8K_MASK_CTRL_REV_ID_MASK			GENMASK(7, 0)
+#define   QCA8K_MASK_CTRL_REV_ID(x)			((x) >> 0)
+#define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
+#define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
 #define QCA8K_REG_PORT0_PAD_CTRL			0x004
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
-- 
2.30.2

