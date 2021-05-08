Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98335376DC9
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhEHAbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhEHAak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:40 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE484C061346;
        Fri,  7 May 2021 17:29:38 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id m9so10873040wrx.3;
        Fri, 07 May 2021 17:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+h+ej8+g7K6vmS4t/5VTu2T/0hfaLSCmNjTS7IqFOgY=;
        b=sMJZr77+1/wamSKH/xUsZN+mc9C2LRhaCYwIW98u+p3FhHx9derCBCW+HGgWOwuPEa
         or96BhYc+/fC+OG/RS5CTtqhl3Gu9kWG/TTcpGwdUkAlbpnS9EtqtG21/zlaMYtAzR8l
         AsbK2XfqAY6dkshISoWF+8u5X9wEpBpw6XvqBzUy3ZfDjQS63MWiGYBzLxEx0jzEKKGF
         WAMewSi270f1Sz9klMIU1SlItUkqChOBxJ+vyMk0Duyun2+C3KS7gPh8vXFgiGzg77o2
         NA0ZdHmvv0yUUA6vk88Dur4kAqTs1v6Wgfp7RrFXREoxiynlAfZxSVL8D7Zb/Hf1NMQH
         aAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+h+ej8+g7K6vmS4t/5VTu2T/0hfaLSCmNjTS7IqFOgY=;
        b=gslR4ntH3DhAsl5mvQdpeyAtpOjQpqtuCR18odgZdd5g07drzdm4IehBlAqUyWGSpk
         B0kCIF91BpNazmmhVFIG5zjdy3kkXHvMNFOm0yXr2VT3+57tYP1grlaT3r/UYd17EMTK
         d0h9orsfmYhEMhDsDpt/RZAkQv9haxmtICas+cJIPRjFefpn1xnxxsgEKq4Ci+tWJ9kW
         dJH0gl7+XnRtYq261dQVrT2AtdU/q65iUvFwdocVxM00exNn6R3dij4i5vVY3JLyLelL
         GF/JApLBLJM9JtHf7+9sRQut35LbsvW64p0TnO1AHMM6c97rWKzx8TW3h50TDkMFk58L
         h6EQ==
X-Gm-Message-State: AOAM533109aSvaKtQG6q8DdGrrbbOcJ/GaLJJ8pwjbrnLJL2ep+WaX6E
        wWxHS2cvkfnvf6ZChrAvVIY=
X-Google-Smtp-Source: ABdhPJzGe3xuQ84gdFqTNK1f457u/DJD1Y2yuy6kSlAa4lkGjQewp7/GgDjczJoetoF5oCQzdCaruQ==
X-Received: by 2002:a5d:64c7:: with SMTP id f7mr15499727wri.257.1620433777425;
        Fri, 07 May 2021 17:29:37 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:37 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 17/28] net: dsa: qca8k: add support for switch rev
Date:   Sat,  8 May 2021 02:29:07 +0200
Message-Id: <20210508002920.19945-17-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 53 ++++++++++++++++++++++++++---------------
 drivers/net/dsa/qca8k.h |  7 ++++--
 2 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 301bb94aba84..9905a2631420 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1591,12 +1591,40 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
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
@@ -1622,24 +1650,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
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

