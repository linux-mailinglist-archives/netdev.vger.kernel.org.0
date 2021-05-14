Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D55138124B
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhENVCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbhENVBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:46 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFCAC06134F;
        Fri, 14 May 2021 14:00:31 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id l4so530150ejc.10;
        Fri, 14 May 2021 14:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JG08upf6UrkrE9/6eQmYrVuXphDJ1Y+Z5Abl1+0TU5o=;
        b=h1okOKDoLEHTLoQidWg63hu99Lhu+BSb7TswTxjEOFNilrVhne35mUemEWCT33cGiT
         CEnSiYZxpZ8PfnojW3JC9veWTPdfMW9i3Nbx+Z6x5tcfOIanAqog1D+uos8BNs/268iZ
         G+337QMkeekS4nBdr9uUxCNaMHCwbsw/fFkJ7NhsYWBx+YsCwb6kiDkGSqgPBOWp6XXl
         9ua0sVrk9p8jgczH9Rau6TC5fqkkWwL0w00r3QCtCFBcyhjF23kaLpG4u0hJ/SKpYCqP
         3I+S9LCL/PjhreI5oLMMdtmVsdGVigtfOEzu8nTOlVG3m5HLctc+U4K58FtchFI0d+Zp
         rm6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JG08upf6UrkrE9/6eQmYrVuXphDJ1Y+Z5Abl1+0TU5o=;
        b=MfTvW7Ov5ddYy1LgiZ1GEt7stt9ho2B3QxK7QLgLdfWNA+eaDE6kGV5bBMN+F8Auz0
         uYEVKo8+Elf+jp0SebuxxmygDJt5zbLolH367t/XFnv3daVoLjV/iyGuFaD8Uykd4KNh
         N5zSPF+SdHX/Qnb88u0of9diz28x4f4/WQTcCxZFdjuXJICwVvvlTZ54Ro+7In4jaAkF
         0icJCsKg9v4qiHde1vlK8D2slgfbMbs9DBbizr9iFvyFVKXMOYEoxJxwCY+uoXLOKQuE
         aQ4AytS2yVAkTp/ZeST592XGdBJszkWDnesJ4egZiST3Oz9Q+QIwla0AYD+YwfRGpefj
         cKEA==
X-Gm-Message-State: AOAM531vbIwmV4gYo2ddoyFT4lrNRH4Q7IQsxbL2nd5A3bNz4ovXDhRq
        sEQvp118ZYRTdOgaWqsXv5g=
X-Google-Smtp-Source: ABdhPJxI5g6w7MFDBhzw7b8w/cqrbmcUumhY8ObPDfMAE8Vhqhwydiv6Z3whvhjedm2tjmgyNkh4zQ==
X-Received: by 2002:a17:906:1399:: with SMTP id f25mr13330730ejc.29.1621026030141;
        Fri, 14 May 2021 14:00:30 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:29 -0700 (PDT)
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
Subject: [PATCH net-next v6 14/25] net: dsa: qca8k: add support for switch rev
Date:   Fri, 14 May 2021 23:00:04 +0200
Message-Id: <20210514210015.18142-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
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

