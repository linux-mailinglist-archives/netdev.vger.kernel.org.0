Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6191E2033B2
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgFVJmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbgFVJls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:41:48 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77F2C061798
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:48 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id r9so14206953wmh.2
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=39tcT1sImiChTRqBAQCitq8OvfITErWq/Xk+xRkWTtw=;
        b=rox8r/P9m0M75MrSrW0gaefUbBrzsyQiQQ+nuSUyw7jmgK72RdIrEAET+9NDW80nJV
         6NoN3fQgrn8u3TAuYWY9vEZmFhT+PYmy+pixzcxBMoxFYd2WlDCvoisyxCnl9XIvgl4L
         2UaUBXGdTuKrvDtQtBHE5L7odP4nDBB7nbDPbFnH6FoanY0lq1FWTQXI+whJq1jJA2hU
         Ot3SzrgslqAj4dfBjZPmBbOgClucsuSk5FJIDeFu2gEMTSGwLi4/f1DXekQJh5ClPfdx
         IiB0mjGPZS7Om5sXsEMBsr/HJQuJgLUO0T+W94WaGsZzXwZOeddJTllPhKS2Nil1ZvIb
         szOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=39tcT1sImiChTRqBAQCitq8OvfITErWq/Xk+xRkWTtw=;
        b=nPj8bRT1m3um0ZcOl1PfIVaOboaXs6ma8kYAtDpmod1GTIJxlg42i8WNJb7if0lhAU
         e65nknANHB1zHX7kGE3m4XuDk+g9fAFaVv5jqPcEIChR266rXGL+Lajd/iGU4uXCCAU6
         PMLZkXz+eOa1Odpeh2RjOg9QN3c7jqHfwW0pcOzaBqEKy5kFLbODrna82Eq/BZbrFt+B
         moGghnYeEMe5obbGEbJkNeOVdAvPYBLEcMA1yXG2iHyebYiEXYguFUHO9ePpIjdoCBwT
         wcceXWAPAkMT0OCoKvOI26qrRsetV9ICsnAwduqo/cVSsokIFB9ZOjn4vsrPmlOhBPKx
         TaPQ==
X-Gm-Message-State: AOAM533xTuTcChDoBXQbX462beD2+duaulQB4Pf9WhJatqiOcTC2xxoi
        331R0NaecY8QI2Iv8aH60QI29Q==
X-Google-Smtp-Source: ABdhPJxuZnlfHnNwpXMmEqVCYAbLPujZmk1SV/mDkcx4Z73yrAJcet27yegyTxUrUHZ6wyfJf9ZIqA==
X-Received: by 2002:a1c:2d54:: with SMTP id t81mr18695221wmt.154.1592818907355;
        Mon, 22 Jun 2020 02:41:47 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id j24sm14392652wrd.43.2020.06.22.02.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:41:46 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 14/15] net: phy: add PHY regulator support
Date:   Mon, 22 Jun 2020 11:37:43 +0200
Message-Id: <20200622093744.13685-15-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200622093744.13685-1-brgl@bgdev.pl>
References: <20200622093744.13685-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The MDIO sub-system now supports PHY regulators. Let's reuse the code
to extend this support over to the PHY device.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/phy/phy_device.c | 49 ++++++++++++++++++++++++++++--------
 include/linux/phy.h          | 10 ++++++++
 2 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 58923826838b..d755adb748a5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -827,7 +827,12 @@ int phy_device_register(struct phy_device *phydev)
 
 	err = mdiobus_register_device(&phydev->mdio);
 	if (err)
-		return err;
+		goto err_out;
+
+	/* Enable the PHY regulator */
+	err = phy_device_power_on(phydev);
+	if (err)
+		goto err_unregister_mdio;
 
 	/* Deassert the reset signal */
 	phy_device_reset(phydev, 0);
@@ -846,22 +851,25 @@ int phy_device_register(struct phy_device *phydev)
 	err = phy_scan_fixups(phydev);
 	if (err) {
 		phydev_err(phydev, "failed to initialize\n");
-		goto out;
+		goto err_reset;
 	}
 
 	err = device_add(&phydev->mdio.dev);
 	if (err) {
 		phydev_err(phydev, "failed to add\n");
-		goto out;
+		goto err_reset;
 	}
 
 	return 0;
 
- out:
+err_reset:
 	/* Assert the reset signal */
 	phy_device_reset(phydev, 1);
-
+	/* Disable the PHY regulator */
+	phy_device_power_off(phydev);
+err_unregister_mdio:
 	mdiobus_unregister_device(&phydev->mdio);
+err_out:
 	return err;
 }
 EXPORT_SYMBOL(phy_device_register);
@@ -883,6 +891,8 @@ void phy_device_remove(struct phy_device *phydev)
 
 	/* Assert the reset signal */
 	phy_device_reset(phydev, 1);
+	/* Disable the PHY regulator */
+	phy_device_power_off(phydev);
 
 	mdiobus_unregister_device(&phydev->mdio);
 }
@@ -1064,6 +1074,11 @@ int phy_init_hw(struct phy_device *phydev)
 {
 	int ret = 0;
 
+	/* Enable the PHY regulator */
+	ret = phy_device_power_on(phydev);
+	if (ret)
+		return ret;
+
 	/* Deassert the reset signal */
 	phy_device_reset(phydev, 0);
 
@@ -1644,6 +1659,8 @@ void phy_detach(struct phy_device *phydev)
 
 	/* Assert the reset signal */
 	phy_device_reset(phydev, 1);
+	/* Disable the PHY regulator */
+	phy_device_power_off(phydev);
 }
 EXPORT_SYMBOL(phy_detach);
 
@@ -2684,13 +2701,18 @@ static int phy_probe(struct device *dev)
 
 	mutex_lock(&phydev->lock);
 
+	/* Enable the PHY regulator */
+	err = phy_device_power_on(phydev);
+	if (err)
+		goto out;
+
 	/* Deassert the reset signal */
 	phy_device_reset(phydev, 0);
 
 	if (phydev->drv->probe) {
 		err = phydev->drv->probe(phydev);
 		if (err)
-			goto out;
+			goto out_reset;
 	}
 
 	/* Start out supporting everything. Eventually,
@@ -2708,7 +2730,7 @@ static int phy_probe(struct device *dev)
 	}
 
 	if (err)
-		goto out;
+		goto out_reset;
 
 	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
 			       phydev->supported))
@@ -2751,11 +2773,16 @@ static int phy_probe(struct device *dev)
 	/* Set the state to READY by default */
 	phydev->state = PHY_READY;
 
-out:
-	/* Assert the reset signal */
-	if (err)
-		phy_device_reset(phydev, 1);
+	mutex_unlock(&phydev->lock);
+
+	return 0;
 
+out_reset:
+	/* Assert the reset signal */
+	phy_device_reset(phydev, 1);
+	/* Disable the PHY regulator */
+	phy_device_power_off(phydev);
+out:
 	mutex_unlock(&phydev->lock);
 
 	return err;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 01d24a934ad1..585ce8db32cf 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1291,6 +1291,16 @@ static inline void phy_device_reset(struct phy_device *phydev, int value)
 	mdio_device_reset(&phydev->mdio, value);
 }
 
+static inline int phy_device_power_on(struct phy_device *phydev)
+{
+	return mdio_device_power_on(&phydev->mdio);
+}
+
+static inline int phy_device_power_off(struct phy_device *phydev)
+{
+	return mdio_device_power_off(&phydev->mdio);
+}
+
 #define phydev_err(_phydev, format, args...)	\
 	dev_err(&_phydev->mdio.dev, format, ##args)
 
-- 
2.26.1

