Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37F3379C89
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhEKCJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhEKCIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:08:43 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46F3C061345;
        Mon, 10 May 2021 19:07:32 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id s82so10195040wmf.3;
        Mon, 10 May 2021 19:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K9KqwbyK1Q3VDjWrofbQ+zgHpIlHIo2ipNbgP/x0V4A=;
        b=K5X0zV+Zkd5d7CX00utxdvr2QHv4JpC8FViHQNilA9IgCHd2C/6bYx0rL0oKhwRVOb
         OG98rTOd8oqo86e2/5cwAuEx5dLt5bV5bK74zeGgxqKziYZmA0DO2FEnXCWTXhZRBNYd
         LPrcI6q6wp1E1Kxh+aR0iqrDkGM7tlKYzTMfSN0j1U9wz2wjc5rB93ahSSwlL9kT0x0+
         auTRGYFRhCwL1VKnLRbzs5TEOJrdka+9ndKsWqQIOR6Atezm46g4lubrVcjpGwBo3cEF
         guQrGjZQa7IpPJY3faaDBVNJww1Kj9bekWq0XVSC+XO1YvTkBBYfA5yRfR8IN2/PbEB8
         uqLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K9KqwbyK1Q3VDjWrofbQ+zgHpIlHIo2ipNbgP/x0V4A=;
        b=kenDatWcAftmlo2T0TPdHWf0pAhnFxotiE0kfYyJ+xJlk+A7c5t7us0wf091G9LIQ0
         s+BZ4vmYuZr7QE3OJoW7FPZyjxnTJw7YXpi2D8drUGsQngRu94BUPjdzmcNQtEIW6+/l
         M4QxgCFfiDyHn6tTqiHo0CMRaQMZBvxxclLaMm3aN/I0+kbbliPWTKe7BY8ntjzlBBIk
         laI/5rK+hDfLthqvuwustgLeMShiQOp01mtg/UrFtteGMOTko/Xr5io01P3ZOxTuGLL9
         uI/Iz41zQB2LxgDEN6JnNlFhEj8tCq580g0/BE3gBfPtKIiailVP4m6hKYEPar3wSWVm
         huAQ==
X-Gm-Message-State: AOAM532fnmmT3HjbOoSqwSKhTibe8yd3pMO5DNJ0+l0tGT3aXpinTXFe
        ALRJwIt6ecm9c7K1dpO0YW8=
X-Google-Smtp-Source: ABdhPJwZSgKZOn0Aj2jvDS/6j8IacjRVpE/MOGtjjGECrHhUBIhsGUIMgStJOcxI0qNL4ATcjhtjog==
X-Received: by 2002:a7b:c1da:: with SMTP id a26mr28848955wmj.40.1620698851354;
        Mon, 10 May 2021 19:07:31 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:31 -0700 (PDT)
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
Subject: [RFC PATCH net-next v5 09/25] net: dsa: qca8k: add support for qca8327 switch
Date:   Tue, 11 May 2021 04:04:44 +0200
Message-Id: <20210511020500.17269-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
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

