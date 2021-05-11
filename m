Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696D9379C94
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhEKCKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhEKCJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:09:07 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FEAC061353;
        Mon, 10 May 2021 19:07:37 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v12so18465866wrq.6;
        Mon, 10 May 2021 19:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JG08upf6UrkrE9/6eQmYrVuXphDJ1Y+Z5Abl1+0TU5o=;
        b=U4rnYZkftp0bF0e8Wuq9y4bb3KAnYwhp4044LskA3WaT0Qvr7c6YMkQM++3GdgfY/h
         Ch7nd3mRa8oIDtygJitb0vXtwACEuJWQrO8gpsaur73pw+7hnYXIGjHTOj7ZljMq/FRi
         7rkMjXcCdcHzR1k+AofIKfJop8czbZangyXv4uB2sjRB+LNfQBWjpCNrkDWIhjlE900Z
         qd2XdMHQfgqxsM1YPcHrvbWjP2iPaTagCJ9tlbBpESjnXhScGOTDVBP7xQZw6FjkhQOF
         vRhjbc4eTodIUzK3VFgU+AqBJKvVGxXvaRWbj/IEqCnZRP6hfGA4/LxdJvMen8oEmSMq
         mYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JG08upf6UrkrE9/6eQmYrVuXphDJ1Y+Z5Abl1+0TU5o=;
        b=cFfKujHDLWfPPlxkhvpAwCy3QS4NjBF5bMxXEIxYNkveIr9+CKIrEf2qf4GNAPZ+cJ
         sdODwY4Ae0+mKCBEb1dQFzCFKaXYpuWzC4+dYlHL7PM0HLrwjZhU+LAIJb1bO8Kd1omD
         fj0BAGlFwtCVWlKr1IbXEuj6U/DMk06JErRaCa0NX6McLmFYgpSlNvPT7ctsMls6+6G7
         4fb1jsZXzhPHOjFBTSw9zzShUHXubMjCO8OyACP5O/JKPMC3BQT0EERvjaX8d93GSumQ
         GYKiG+2jXXZQCYXaKXjLOdjz0jYM5iWLYK5y6+CjFisBX9FuFza/TQQVwR5NdoCWcRJZ
         f5Bg==
X-Gm-Message-State: AOAM530MXbvoQzJMyq1098JfT488FMNe8M0td1bUqjUInZz4ZOzUdVT1
        cOV6Fh7eFUkaRLkD4RlCJgE=
X-Google-Smtp-Source: ABdhPJyfWGhGzx99A0nSMPpcro3bOK4qaCtjFhRyvcUi5OBeuZUcCBxDSLG+GLCHaOSUVIN16qHA1A==
X-Received: by 2002:a5d:4649:: with SMTP id j9mr1480161wrs.360.1620698856250;
        Mon, 10 May 2021 19:07:36 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:36 -0700 (PDT)
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
Subject: [RFC PATCH net-next v5 14/25] net: dsa: qca8k: add support for switch rev
Date:   Tue, 11 May 2021 04:04:49 +0200
Message-Id: <20210511020500.17269-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k internal phy driver require some special debug value to be set
based on the switch revision. Rework the switch id read function to
also read the chip revision.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca8k.c | 53 ++++++++++++++++++++++++++---------------
 drivers/net/dsa/qca8k.h |  7 ++++--
 2 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 10e3e1ca7e95..35ff4cf08786 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1579,12 +1579,40 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
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
+	priv->switch_id = id;
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
@@ -1610,24 +1638,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
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
 
-	priv->switch_id = id;
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
 		return -ENOMEM;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index eceeacfe2c5d..338277978ec0 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -30,8 +30,10 @@
 
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
@@ -251,6 +253,7 @@ struct qca8k_match_data {
 
 struct qca8k_priv {
 	u8 switch_id;
+	u8 switch_revision;
 	struct regmap *regmap;
 	struct mii_bus *bus;
 	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
-- 
2.30.2

