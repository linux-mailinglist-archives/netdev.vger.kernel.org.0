Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0BB2033C0
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgFVJmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbgFVJll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:41:41 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21209C061796
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:41 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g18so6882665wrm.2
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r7nW5+M2kh3cyRyjmx7rE7/COR4QWlNL8CdVe/fIbIs=;
        b=XpSDFkYeVraxiwg/39otpkkJoHtYP4sFAfXMCtKdQJw1oTQbFoKREJWtbqNON3jfWc
         EGdzjWhRvetEZZlr/I5j+Y99sKov/il4jFxNvZDmEZqLsj05w9DscD2q2xxItOV7NEn0
         Ks0NxdCoBxv9IqVnzDoXUtuX3V4Tmr4PdQyGyVC2ZsCreOyID+ag5NQdk+BuXbrM9LaI
         BGdjyyH7GCr2qq1OPt17TJtEH06ciHZSyAqQx0XLoZ5bSNK1Mi5eNtUeINHTvTKl8gSE
         eNqCc3eEQOEUxA3S0GBF2Mfp+PTfRWQbgIYVM7JWIsVaP5PiUOxf3ffTQdRFjltEHbpn
         c0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r7nW5+M2kh3cyRyjmx7rE7/COR4QWlNL8CdVe/fIbIs=;
        b=WhdhkL9cT9CpFKIFht9lM19UHhpVIeaFhussPjdNzDb29kRIpcL9dXQeMDlpY3/kFv
         N2LKz3PnvD9o+pd61ezeAHEOyt9mES4ykaVsRteKwLz/I0ksM8F0JfaoxLegnfyHBzHW
         sQ1L+kKT+qt0g31ECrltKN4db37Y9WQx7vVlNfkXegeOc3c0mB3u2vE74zWEh+pmyxo5
         3lwIAeB4WJSdpmtrcT9pBqOs8eecR20mCvvhPhkhQOEicDT1+YKe2BWcWSizlt5fAiIO
         A0iqxmQDLyjyH2JCyuJ1pSJc5X2Bp/ryZffNDM+BZ2Io2u/FQiBZWzR5e5Z5DKIfz8Kv
         EtjA==
X-Gm-Message-State: AOAM532i69tvOqO0TLTdgSQ24uSz6glusdPNtumfYge7PAJdw8+viJ7c
        9yjNwoIILi2cvycXrecmkM+09g==
X-Google-Smtp-Source: ABdhPJziJYcTjk6jm0fDfnLPlChK17pDk1Ty5W2fRkaBHu9dXXGiCcXlDIMMSfver6mQJh4kbChvSQ==
X-Received: by 2002:adf:a34d:: with SMTP id d13mr17477047wrb.270.1592818899871;
        Mon, 22 Jun 2020 02:41:39 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id j24sm14392652wrd.43.2020.06.22.02.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:41:39 -0700 (PDT)
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
Subject: [PATCH 10/15] net: phy: simplify phy_device_create()
Date:   Mon, 22 Jun 2020 11:37:39 +0200
Message-Id: <20200622093744.13685-11-brgl@bgdev.pl>
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

The last argument passed to phy_device_create() (c45_ids) is never used
in current mainline outside of the core PHY code - it can only be
configured when reading the PHY ID from phy_device_read_id().

Let's drop this argument treewide.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/phy/nxp-tja11xx.c | 2 +-
 drivers/net/phy/phy_device.c  | 8 +++-----
 drivers/of/of_mdio.c          | 2 +-
 include/linux/phy.h           | 3 +--
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index a72fa0d2e7c7..b98b620ef88c 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -507,7 +507,7 @@ static void tja1102_p1_register(struct work_struct *work)
 		}
 
 		/* Real PHY ID of Port 1 is 0 */
-		phy = phy_device_create(bus, addr, PHY_ID_TJA1102, false, NULL);
+		phy = phy_device_create(bus, addr, PHY_ID_TJA1102, false);
 		if (IS_ERR(phy)) {
 			dev_err(dev, "Can't create PHY device for Port 1: %i\n",
 				addr);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 94944fffa9bb..ad7c4cd9d357 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -613,8 +613,7 @@ static int phy_request_driver_module(struct phy_device *phydev)
 }
 
 struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
-				     bool is_c45,
-				     struct phy_c45_device_ids *c45_ids)
+				     bool is_c45)
 {
 	struct phy_device *dev;
 	struct mdio_device *mdiodev;
@@ -647,8 +646,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 
 	dev->is_c45 = is_c45;
 	dev->phy_id = phy_id;
-	if (c45_ids)
-		dev->c45_ids = *c45_ids;
+
 	dev->irq = bus->irq[addr];
 	dev_set_name(&mdiodev->dev, PHY_ID_FMT, bus->id, addr);
 
@@ -829,7 +827,7 @@ static int phy_device_read_id(struct phy_device *phydev)
  */
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
-	return phy_device_create(bus, addr, PHY_ID_NONE, is_c45, NULL);
+	return phy_device_create(bus, addr, PHY_ID_NONE, is_c45);
 }
 EXPORT_SYMBOL(get_phy_device);
 
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index a04afe79529c..63843037673c 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -121,7 +121,7 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 					 "ethernet-phy-ieee802.3-c45");
 
 	if (!is_c45 && !of_get_phy_id(child, &phy_id))
-		phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
+		phy = phy_device_create(mdio, addr, phy_id, 0);
 	else
 		phy = get_phy_device(mdio, addr, is_c45);
 	if (IS_ERR(phy)) {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2a695cd90c7c..662919c1dd27 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1213,8 +1213,7 @@ int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
 		     u16 mask, u16 set);
 
 struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
-				     bool is_c45,
-				     struct phy_c45_device_ids *c45_ids);
+				     bool is_c45);
 #if IS_ENABLED(CONFIG_PHYLIB)
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
-- 
2.26.1

