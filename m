Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6544373264
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbhEDWap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbhEDWak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:40 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F23DC06138F;
        Tue,  4 May 2021 15:29:43 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id u3so15558766eja.12;
        Tue, 04 May 2021 15:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xi+9NEHElecCCVEE9f3dEwF3dNr9tC0W1TG8iJrQ2XQ=;
        b=RPQamhQ5fkItp7sKX3xE3r75QEMJFExP11tcnbonv0GX2HgeXcLmswV/ZjVk+QFOXw
         dTFNmfJVxAXdxbq9cFEpk7bJ5ffaqSHHHJpIp4NxAqC5gvubw087uQrYQDMBjD9Hxp0a
         3FuL202RhIlrtAMUYNvTkg3vsWUT0kGMKdQ0HluGhL3iA1oTy2Rmq3Hwn+dQFUy/VRb0
         9FUQA7AOYMskYG6O10RTE6jfuqNpYLW/YcsHNj08e/rf6dD9nKwXRFKWfSJv4UPZOJet
         fdUY39/Pxsk7ct1oY3rRKM5czuIrjcDSzxvsFQK7fSQMutntvSNK5dcAvk+I/0CbR2t1
         MOGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xi+9NEHElecCCVEE9f3dEwF3dNr9tC0W1TG8iJrQ2XQ=;
        b=X1Qu+AVjpqxCv1qid9gskyq9QmGT98ioT21SClFeGUUke3SLGMh0r7drzosEdHdOu3
         Zhy2+kWC7SfozaqkJY8Y0PVQMMq1rgbk2qgGPdKa1SVLuL9NipvFO4aJaXcg3LiVoz84
         py9sOyqTpT5T9xMgZkEaQR98gN08o7K3Euc/lxQ1tcqLtCHjUWQ0xYzPfjqIDW/dzkQs
         mTCnPC4/yOPoK8od0SB1GbGcrKSEoe3kHj3zxtGS6ViX3ua8Kcu1LW971RVQWlIdFyvf
         p83p4TEBE/lNdmWzN+QLS7SgfvCqXcA7h/+LGCLb5ok1tr+6WFFMee8kV35W2tBxMYlq
         FHPA==
X-Gm-Message-State: AOAM53356wP1eTF2Wf+2xwK4ujfUa37B15fH68WfEj+HAY2WXHQhu+1E
        8S9+ePvvnb/uSqwOM9Tl7DE=
X-Google-Smtp-Source: ABdhPJztFP6IdxTLTYl/rbb90t+G2cc1bidJu87kbQb/BdO61+CKwsQzStNEMOcz9APfOilsJBrZZg==
X-Received: by 2002:a17:907:f86:: with SMTP id kb6mr23656405ejc.428.1620167382069;
        Tue, 04 May 2021 15:29:42 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:33 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 08/20] net: dsa: qca8k: add support for qca8327 switch
Date:   Wed,  5 May 2021 00:29:02 +0200
Message-Id: <20210504222915.17206-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8327 switch is a low tier version of the more recent qca8337.
It does share the same regs used by the qca8k driver and can be
supported with minimal change.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 23 ++++++++++++++++++++---
 drivers/net/dsa/qca8k.h |  6 ++++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 33875ad58d59..17c6fd4afa7d 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1529,6 +1529,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 static int
 qca8k_sw_probe(struct mdio_device *mdiodev)
 {
+	const struct qca8k_match_data *data;
 	struct qca8k_priv *priv;
 	u32 id;
 
@@ -1556,6 +1557,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		gpiod_set_value_cansleep(priv->reset_gpio, 0);
 	}
 
+	/* get the switches ID from the compatible */
+	data = of_device_get_match_data(&mdiodev->dev);
+	if (!data)
+		return -ENODEV;
+
 	/* read the switches ID register */
 	id = qca8k_read(priv, QCA8K_REG_MASK_CTRL);
 	if (id < 0)
@@ -1563,8 +1569,10 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 
 	id >>= QCA8K_MASK_CTRL_ID_S;
 	id &= QCA8K_MASK_CTRL_ID_M;
-	if (id != QCA8K_ID_QCA8337)
+	if (id != data->id) {
+		dev_err(&mdiodev->dev, "Switch id detected %x but expected %x", id, data->id);
 		return -ENODEV;
+	}
 
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
@@ -1629,9 +1637,18 @@ static int qca8k_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(qca8k_pm_ops,
 			 qca8k_suspend, qca8k_resume);
 
+static const struct qca8k_match_data qca832x = {
+	.id = QCA8K_ID_QCA8327,
+};
+
+static const struct qca8k_match_data qca833x = {
+	.id = QCA8K_ID_QCA8337,
+};
+
 static const struct of_device_id qca8k_of_match[] = {
-	{ .compatible = "qca,qca8334" },
-	{ .compatible = "qca,qca8337" },
+	{ .compatible = "qca,qca8327", .data = &qca832x },
+	{ .compatible = "qca,qca8334", .data = &qca833x },
+	{ .compatible = "qca,qca8337", .data = &qca833x },
 	{ /* sentinel */ },
 };
 
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 7ca4b93e0bb5..86e8d479c9f9 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -15,6 +15,8 @@
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_MAX_MTU					9000
 
+#define PHY_ID_QCA8327					0x004dd034
+#define QCA8K_ID_QCA8327				0x12
 #define PHY_ID_QCA8337					0x004dd036
 #define QCA8K_ID_QCA8337				0x13
 
@@ -211,6 +213,10 @@ struct ar8xxx_port_status {
 	int enabled;
 };
 
+struct qca8k_match_data {
+	u8 id;
+};
+
 struct qca8k_priv {
 	struct regmap *regmap;
 	struct mii_bus *bus;
-- 
2.30.2

