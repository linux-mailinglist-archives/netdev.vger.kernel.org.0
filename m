Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFBC370F9B
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhEBXIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbhEBXIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:18 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0182C06174A;
        Sun,  2 May 2021 16:07:24 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b17so1248128ede.0;
        Sun, 02 May 2021 16:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M7IuqxRJ6jU2t1Hv3Nddvu1V+0+EBDkzBN54YvUkIFk=;
        b=Cd8hnCBRLLmTWTHFbsKHXTj+QlcrZpTjmk4Yf0MSaiLnxyNAqM/32pedYb+7G3Mv2X
         FLCheRxoG+3uJozJaACCZBoSGSogLpDRTXG15uknq8T2uQHVjVF5ACJgahwrCuhxoJAg
         +J+GPGjXLBoWDc6CRaO6dqDos+dSoAE6LSYJyf4n2XybtW2UYeQbDmPUfempaDS4K40k
         XS+wMJQL0MGLHwQN0VLRrJ/zCsWMWOoz3yGn3OGmxHxLAHTcF1nEdQvYGSRpVnLZoGmL
         NnTZuJrEnR9JIs6jDM05tWXg13Q1yVqOl6TzDDEpcxrcsVGUUnWTAUASLFvG69f825af
         tpBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M7IuqxRJ6jU2t1Hv3Nddvu1V+0+EBDkzBN54YvUkIFk=;
        b=adPA13HBsI6kQaNFO3D1sYW8U6ylZnxEjjFa/ZGaG/LNyS8LP4yGL/FE2oeS5XpjfJ
         +JavESNcyZu0nRYTWCJ1m1mfL1N5BHqyDwSQ2MnDmTUzvN9V+ZgwN4Wg65sNk+SP00sJ
         +QWm4TlWCaqoHvUBtYNWwtFhkCpMWW0FdP9biuPvYYiRSzWWhzj39asen/VsMdUCpcXp
         utlrPXnueMCao71Qca1aEM134pUkPZmy4kgYmCtWgVsuYnrqpuXYvN53YXpqSBozP6Ww
         TFxZ6BOauxon+TS6K39i/8nKTn/dRD2Hs3vmnsafHKUzSTJdYqL9IXgXmG1JfJ5fsLO2
         Xwbg==
X-Gm-Message-State: AOAM5332Zcho9RPPJg3VS4KX4Fg8OJ9iFEoGPUW80pG5LuKZfCvqesGN
        uwP7tUN6iQN7xa3/kBVF9Dw=
X-Google-Smtp-Source: ABdhPJyQp/zvvXW+y1DD9DV3RhZKfKc7kKRB9gKX9aLiCKe+wJp4RuerGKX7prGvVD+y7g+kOpCVMA==
X-Received: by 2002:aa7:d915:: with SMTP id a21mr17553679edr.357.1619996843520;
        Sun, 02 May 2021 16:07:23 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:23 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 09/17] net: dsa: qca8k: add support for switch rev
Date:   Mon,  3 May 2021 01:07:01 +0200
Message-Id: <20210502230710.30676-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 46 +++++++++++++++++++++++++++--------------
 drivers/net/dsa/qca8k.h |  6 ++++--
 2 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 3f42d731756c..5478bee39c6e 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1578,13 +1578,39 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
 };
 
+static int qca8k_read_switch_id(struct qca8k_priv *priv)
+{
+	const struct qca8k_match_data *data;
+	int ret;
+	u32 val;
+	u8 id;
+
+	/* get the switches ID from the compatible */
+	data = of_device_get_match_data(priv->dev);
+	if (!data)
+		return -ENODEV;
+
+	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
+	if (ret)
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
 	int ret;
-	u32 id;
 
 	/* allocate the private data struct so that we can probe the switches
 	 * ID register
@@ -1610,23 +1636,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		gpiod_set_value_cansleep(priv->reset_gpio, 0);
 	}
 
-	/* get the switches ID from the compatible */
-	data = of_device_get_match_data(&mdiodev->dev);
-	if (!data)
-		return -ENODEV;
-
-	/* read the switches ID register */
-	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &id);
+	/* Check the detected switch id */
+	ret = qca8k_read_switch_id(priv);
 	if (ret)
 		return ret;
 
-	id >>= QCA8K_MASK_CTRL_ID_S;
-	id &= QCA8K_MASK_CTRL_ID_M;
-	if (id != data->id) {
-		dev_err(&mdiodev->dev, "Switch id detected %x but expected %x", id, data->id);
-		return -ENODEV;
-	}
-
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
 		return -ENOMEM;
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

