Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984FA38123E
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbhENVBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhENVBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:43 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D22C061347;
        Fri, 14 May 2021 14:00:26 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id v5so47192edc.8;
        Fri, 14 May 2021 14:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K9KqwbyK1Q3VDjWrofbQ+zgHpIlHIo2ipNbgP/x0V4A=;
        b=A9AnwpOzkPJvBzm0pPCx1GHzrBvcieOj2HShHwH2Ml4g0A6qBuvyy0RWVny15vWWLh
         2EGdKO+U4qwpz6ka8X0oJE7Gf5csDttYJBW/6lsIB/AdIHSp1eHPaGsXDCZzzjpGm5Wc
         YkoJtljX4HHpQT/iRxb8S/jES9Vy2PABIvg9FoTY4h0J2vmNqxQJFtfVov/H0WP5nJD7
         AClo+BczByJqWx8AlGSDqwlqIFUkMTxcqvAAg6k7TrHRZTK+wYWyAKxJLIhxTWNNYbig
         n5gL3lpYhmVUT7T0YWZA79J4DbF21Oi5oyxLbs+X+eq6xhlCWqi6KkSlP7Mw/RCeG/2s
         Ff1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K9KqwbyK1Q3VDjWrofbQ+zgHpIlHIo2ipNbgP/x0V4A=;
        b=VIHn5nXB2Ti+K2atPT4wqbdloodi/jL4NQVADYKOZvjFmABlPAbE1tEMWR9YsOd+MN
         veooqiGLk49Ei4tZC2VGzYuPuRzt0wp3AB3l9Nf7ohiBdKqaRLy5CieEnMyA2A2Dxmhz
         VMrz3vKx4hrH2O7eJllVPNJTTHO0z3D7K3CIKqE8W6vxD6YJzk6SAbK8oEPBrvWz7qLO
         UuMqZ27eAqQV/5hptnwE2nIuIPTizvnPc1c2/Bw5CeBUdDERFWc47ZY3QKlRvOVlKkBk
         JjQ2XBUC7opdNZM11HKHXf/c86c2M74V0z+S/dL2LcHNYnzE+SO6O3ljGh17U5zCn+Q6
         +FsQ==
X-Gm-Message-State: AOAM532BAsdgzFlgqJPqjyPkvyLhMRz7w4OqPcRKBeQRRhjRaIpvXlIk
        qmlqJk/9sHXkKX5Jo0et6E8=
X-Google-Smtp-Source: ABdhPJzWQax5ZKNFD/BqAdK82xyxL2nwTuDPpYNi8ZFjxXfpLl274LMF/F2m3fTulkVKrVi9j+Fc2A==
X-Received: by 2002:aa7:d2c1:: with SMTP id k1mr59780818edr.138.1621026025071;
        Fri, 14 May 2021 14:00:25 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:24 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 09/25] net: dsa: qca8k: add support for qca8327 switch
Date:   Fri, 14 May 2021 22:59:59 +0200
Message-Id: <20210514210015.18142-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8327 switch is a low tier version of the more recent qca8337.
It does share the same regs used by the qca8k driver and can be
supported with minimal change.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca8k.c | 23 ++++++++++++++++++++---
 drivers/net/dsa/qca8k.h |  6 ++++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d4e3f81576ec..693bd9fd532b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1524,6 +1524,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 static int
 qca8k_sw_probe(struct mdio_device *mdiodev)
 {
+	const struct qca8k_match_data *data;
 	struct qca8k_priv *priv;
 	u32 id;
 
@@ -1551,6 +1552,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
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
@@ -1558,8 +1564,10 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 
 	id >>= QCA8K_MASK_CTRL_ID_S;
 	id &= QCA8K_MASK_CTRL_ID_M;
-	if (id != QCA8K_ID_QCA8337)
+	if (id != data->id) {
+		dev_err(&mdiodev->dev, "Switch id detected %x but expected %x", id, data->id);
 		return -ENODEV;
+	}
 
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
@@ -1624,9 +1632,18 @@ static int qca8k_resume(struct device *dev)
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
index 86c585b7ec4a..87a8b10459c6 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -15,6 +15,8 @@
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_MAX_MTU					9000
 
+#define PHY_ID_QCA8327					0x004dd034
+#define QCA8K_ID_QCA8327				0x12
 #define PHY_ID_QCA8337					0x004dd036
 #define QCA8K_ID_QCA8337				0x13
 
@@ -213,6 +215,10 @@ struct ar8xxx_port_status {
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

