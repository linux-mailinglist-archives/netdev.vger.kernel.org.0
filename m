Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009F8368AA2
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240311AbhDWBtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240297AbhDWBso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:48:44 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3957C061574;
        Thu, 22 Apr 2021 18:48:00 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g17so55027325edm.6;
        Thu, 22 Apr 2021 18:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D3cw8fm79tu03HZeqWWBCB9/5cL3BWU3BhEukRCfA50=;
        b=JirCcRZzE38KXTwCoxRMnpWltAqGDjeLU+lPDPJH0+kw1y7puceIsdVZyoSKuMhNTg
         38DTN3ozvcCxn5h9e002yTNRMm2p0HMfUvK4it8fMT+MgAO1GG8x5yhMcUKbFYbkTqG+
         35t3+R2zK+1lYgwOUKwVF3E9ud2jav3jWpaZAcp3jFUy0MJSGfppMb2EA7JUWed/fXW+
         5Yow4KOZ0U906zdE21ezHvpu3VDEzf8FREiF9W5le9AsF/Zp8FqiLf1WFcZFZCrmBmOR
         repC89J7TZoUtLHMIp68eerN7DzOt2WDzwbt1/tf5P4qrc1GC40gyCmsGjvxWQ+9F+sO
         QL4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D3cw8fm79tu03HZeqWWBCB9/5cL3BWU3BhEukRCfA50=;
        b=LSLHqCvtP9kvFQRArOJda7GfPOn8TFOa5bPeIUndI5XReAVyW2ZBX5F6b5JVE+iCOi
         x6kuj5jIBJkYaEccpRnOANp6eIsMZp73r16FPk4t3VxbpwUX3ANHevSBeSuiB1Wtr+g6
         BcTD6DwaVFuL+px18fG3AWbM/Z/BNjYs18Yj+VaL/Qxg2I8hUNqfJ+hiwkjavU3Ajn9F
         46jP2JFCYkukaqAFNWJzmSEaSS9lTEqmeYhiNUC+B/Sm2p5ZLlJT0U97he7n3Ri1sYLt
         xQSVKQ05yRZULwmtFnyNRygksyELgrFo3Ao2+7f7sgHhGSMwslyi+sP8wJUILorF/vWl
         eFZQ==
X-Gm-Message-State: AOAM532yEBbtgA/sqCvs60GB7s1yulD3Nr/sQnYT6F9eBjT/erAcCuiB
        DSusUqWfNn2zrT+Q3yfLhDU=
X-Google-Smtp-Source: ABdhPJyP4HNFtCU/sMTdh48jKJRp4J1Ek17/8pKiNxfcVdGinBFzT6kv79G8t0yHrNkVx+7SsCEulg==
X-Received: by 2002:a05:6402:27d4:: with SMTP id c20mr1562376ede.271.1619142479364;
        Thu, 22 Apr 2021 18:47:59 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:47:59 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] drivers: net: dsa: qca8k: add support for qca8327 switch
Date:   Fri, 23 Apr 2021 03:47:31 +0200
Message-Id: <20210423014741.11858-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 21 ++++++++++++++++++---
 drivers/net/dsa/qca8k.h |  6 ++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 7408cbee05c2..ca12394c2ff7 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1440,6 +1440,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 static int
 qca8k_sw_probe(struct mdio_device *mdiodev)
 {
+	const struct qca8k_match_data *data;
 	struct qca8k_priv *priv;
 	u32 id;
 
@@ -1467,11 +1468,16 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		gpiod_set_value_cansleep(priv->reset_gpio, 0);
 	}
 
+	/* get the switches ID from the compatible */
+	data = of_device_get_match_data(&mdiodev->dev);
+	if (!data)
+		return -ENODEV;
+
 	/* read the switches ID register */
 	id = qca8k_read(priv, QCA8K_REG_MASK_CTRL);
 	id >>= QCA8K_MASK_CTRL_ID_S;
 	id &= QCA8K_MASK_CTRL_ID_M;
-	if (id != QCA8K_ID_QCA8337)
+	if (id != data->id)
 		return -ENODEV;
 
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
@@ -1537,9 +1543,18 @@ static int qca8k_resume(struct device *dev)
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
index 0ff7abbd40dc..d94129371a1c 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -15,6 +15,8 @@
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_MAX_MTU					9000
 
+#define PHY_ID_QCA8327					0x004dd034
+#define QCA8K_ID_QCA8327				0x12
 #define PHY_ID_QCA8337					0x004dd036
 #define QCA8K_ID_QCA8337				0x13
 
@@ -234,6 +236,10 @@ struct ar8xxx_port_status {
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

