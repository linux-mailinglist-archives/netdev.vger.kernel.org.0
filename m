Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1728B370F93
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbhEBXIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbhEBXIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:12 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0E7C061756;
        Sun,  2 May 2021 16:07:20 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id u13so1573431edd.3;
        Sun, 02 May 2021 16:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2NYuZaCqqvoH2mLVl7M64mOu6lWF/fLGnZuczjNcSRE=;
        b=JhRJzX8PX1neGFFHEgw+U/UQgggV/Xn++dnG/ylLQouUCQ516+z/U+LK5Wkpx42/4z
         XdyA3tRiIC5IeWvGtxXdEccH9M3JP8bRFqmOUNxKY7GPqyR4ZBQDu/uiabt32gpka+ol
         ouwKXwQHXdvfatTKS5DMKdNNtECv/cp1kyhmYILy77AqJ+fK+2OQYz+CSfFLIyuYdk1w
         XKyk4KOXIH6YJYT17FO4Nm8NaPm4WQWSl/XQgnQ7skwsSPHGbdHHpKHHb1mfFjYGMmE3
         WeoDbPL3OvIAf0W6FCe+A7xAlAyz3mM8HhrZON55uge7RXl5OJPrRV4Ur5A3EEBFHMMr
         ViQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2NYuZaCqqvoH2mLVl7M64mOu6lWF/fLGnZuczjNcSRE=;
        b=o/yyZGuzA811gZofiP8N1bt/RS0hSm298ePzn0JJ2iUDd7OlsfeHtsifbKHk9hG/Yt
         jklXR19BO7OGSbT9Tw8UMotn4PWi4kT6nHEE1zXkuBVwtCO/KelvyUmNZ9DKiniZmsSN
         KtKY5hsNWFMbDmwhmD+7Umwsbjcqlk5uSvwrVWFZ9T/3Aas5dxEmVIMqBTJNhS7Qj04v
         QITUUTX+dUivtyh/4qIc9+LVt2hBQUJ8YTx45BcDUWc8C+muNt9qKqNXWkR2/VEAsV20
         y5M4zV89S3yqBNuqOOFc+BNA3PxFEYWtXfjBR8UFpmi+m//FfSxA1ndmu0cF0Vn7VgFl
         juRg==
X-Gm-Message-State: AOAM530S6ykTDbhHDr3nHQxDnRlBO3leH3IwbvIDxIo85b25e6d/13gq
        WCn3chVTsXqnsGDVjQ8BJOM=
X-Google-Smtp-Source: ABdhPJzEpS2NRe4jF69G9uEuFkF1JLWDR0H0xjghVnY9R47O4to2wl2qRoLw5g2p0YXMYqn98VsOmg==
X-Received: by 2002:a05:6402:4251:: with SMTP id g17mr3715791edb.205.1619996839181;
        Sun, 02 May 2021 16:07:19 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:18 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 05/17] net: dsa: qca8k: add support for qca8327 switch
Date:   Mon,  3 May 2021 01:06:57 +0200
Message-Id: <20210502230710.30676-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
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
index 0678c213065f..acfe072e9430 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1522,6 +1522,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 static int
 qca8k_sw_probe(struct mdio_device *mdiodev)
 {
+	const struct qca8k_match_data *data;
 	struct qca8k_priv *priv;
 	int ret;
 	u32 id;
@@ -1550,6 +1551,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		gpiod_set_value_cansleep(priv->reset_gpio, 0);
 	}
 
+	/* get the switches ID from the compatible */
+	data = of_device_get_match_data(&mdiodev->dev);
+	if (!data)
+		return -ENODEV;
+
 	/* read the switches ID register */
 	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &id);
 	if (ret)
@@ -1557,8 +1563,10 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 
 	id >>= QCA8K_MASK_CTRL_ID_S;
 	id &= QCA8K_MASK_CTRL_ID_M;
-	if (id != QCA8K_ID_QCA8337)
+	if (id != data->id) {
+		dev_err(&mdiodev->dev, "Switch id detected %x but expected %x", id, data->id);
 		return -ENODEV;
+	}
 
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
@@ -1623,9 +1631,18 @@ static int qca8k_resume(struct device *dev)
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

