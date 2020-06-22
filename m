Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA502033A9
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgFVJlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgFVJln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:41:43 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2555AC061795
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:43 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so6114763wme.5
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l2sxOAERFa0J25cQccVz8/lQJT3JNRbkHzrHyMtlOx8=;
        b=nHZDq84vKrJqy5xXpj2+rJ5h5VIM3n4oN76Uizc9jBhIW16xOrH3B0Km9mgWsk8Lu6
         yvA1XNXVkC07+Pg/8MKlE82O8Zr8pe+ZvkBUKPDwUpNwKEh7ddGCtrK03jbkSOhkA97n
         64Op9mOQmTRVdF209L3WgAXdk3JQpz6prmFcnirM5Mh85gqh4wj4HfX8Dj95q3jZ4lEF
         /r+V+9jWRk4x4oJaqpBir5uBrXH2h5nhtFaRbptwV37IBb0FqLh8jpU7Qs3q7UwE/NC6
         FhTF3jLXUrGYuZgpSgC5QM7D/g7YPowxLmIGSyrPG0S+JZ6ohlL8NFMJuPMP9exEStSR
         efPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l2sxOAERFa0J25cQccVz8/lQJT3JNRbkHzrHyMtlOx8=;
        b=uC2noz+PT/jk7Aod5R9O7kFLvbdtet3tnRs5x2pl4rVDC3yXz0wiBR+dm3a7C+6pGj
         DBlMOHZGMnKe/oU2VrfPhCVBaiSKD+4mzx/0EL/Pl+HkfmK9Fl4WmOJOZCNMLAhG3cZP
         GTR+82mzrw1j3zdrw62iQrrn5oiUewe40rDU6umbEtZjLqIueMmkgx+14+ymL+lazOtS
         kHIXyzfptVBI1b2mZK8UwS0G4grocopc6CoSn3KvJ7hgKh6J2EJzYCM/ELdq9Fb/5m+X
         A2tGNgZ9OLcquFRH7PKp/ZrGYvbyVoqWuZmpGnp5umcY+OOP36wZ2o3v469d8IBxsttT
         TEyg==
X-Gm-Message-State: AOAM530FfTHPXwUjYUn3LL9F3WhaHbD4RLF7r9hZXvJpi94frWtQ3MKu
        /rQHNFsMmR87G3gVxHFdgVLjEw==
X-Google-Smtp-Source: ABdhPJzJR6KO8zeK/627bqE1LbuigMS0KsI1hp+YnRpdEX+tkt6lyQYjVo/pPkpTRjLvTnpZhm+r2Q==
X-Received: by 2002:a7b:c156:: with SMTP id z22mr16903035wmi.43.1592818901772;
        Mon, 22 Jun 2020 02:41:41 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id j24sm14392652wrd.43.2020.06.22.02.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:41:41 -0700 (PDT)
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
Subject: [PATCH 11/15] net: phy: drop get_phy_device()
Date:   Mon, 22 Jun 2020 11:37:40 +0200
Message-Id: <20200622093744.13685-12-brgl@bgdev.pl>
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

get_phy_device() has now become just a wrapper for phy_device_create()
with the phy_id argument set to PHY_ID_NONE. Let's remove this function
treewide and replace it with opencoded phy_device_create(). This has the
advantage of being more explicit about the PHY not having the ID set
when being created.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c            |  3 ++-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c       |  5 +++--
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c |  2 +-
 drivers/net/ethernet/socionext/netsec.c           |  3 ++-
 drivers/net/phy/fixed_phy.c                       |  2 +-
 drivers/net/phy/mdio-xgene.c                      |  2 +-
 drivers/net/phy/mdio_bus.c                        |  2 +-
 drivers/net/phy/phy_device.c                      | 14 --------------
 drivers/net/phy/sfp.c                             |  2 +-
 drivers/of/of_mdio.c                              | 11 +++++++----
 include/linux/phy.h                               |  7 -------
 11 files changed, 19 insertions(+), 34 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 1dd9e348152d..40c868382e03 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1183,7 +1183,8 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		if (ocelot_port->phy_mode == PHY_INTERFACE_MODE_USXGMII)
 			is_c45 = true;
 
-		pcs = get_phy_device(felix->imdio, port, is_c45);
+		pcs = phy_device_create(felix->imdio, port,
+					PHY_ID_NONE, is_c45);
 		if (IS_ERR(pcs))
 			continue;
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 46c3c1ca38d6..1117ed468abf 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1017,8 +1017,9 @@ static int xgbe_phy_find_phy_device(struct xgbe_prv_data *pdata)
 	}
 
 	/* Create and connect to the PHY device */
-	phydev = get_phy_device(phy_data->mii, phy_data->mdio_addr,
-				(phy_data->phydev_mode == XGBE_MDIO_MODE_CL45));
+	phydev = phy_device_create(phy_data->mii, phy_data->mdio_addr,
+			PHY_ID_NONE,
+			phy_data->phydev_mode == XGBE_MDIO_MODE_CL45);
 	if (IS_ERR(phydev)) {
 		netdev_err(pdata->netdev, "get_phy_device failed\n");
 		return -ENODEV;
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
index 9a907947ba19..75fa6a855727 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -703,7 +703,7 @@ hns_mac_register_phydev(struct mii_bus *mdio, struct hns_mac_cb *mac_cb,
 	else
 		return -ENODATA;
 
-	phy = get_phy_device(mdio, addr, is_c45);
+	phy = phy_device_create(mdio, addr, PHY_ID_NONE, is_c45);
 	if (!phy || IS_ERR(phy))
 		return -EIO;
 
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 328bc38848bb..48c405d81000 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1935,7 +1935,8 @@ static int netsec_register_mdio(struct netsec_priv *priv, u32 phy_addr)
 			return ret;
 		}
 
-		priv->phydev = get_phy_device(bus, phy_addr, false);
+		priv->phydev = phy_device_create(bus, phy_addr,
+						 PHY_ID_NONE, false);
 		if (IS_ERR(priv->phydev)) {
 			ret = PTR_ERR(priv->phydev);
 			dev_err(priv->dev, "get_phy_device err(%d)\n", ret);
diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index c4641b1704d6..9019f0035ef0 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -254,7 +254,7 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 		return ERR_PTR(ret);
 	}
 
-	phy = get_phy_device(fmb->mii_bus, phy_addr, false);
+	phy = phy_device_create(fmb->mii_bus, phy_addr, PHY_ID_NONE, false);
 	if (IS_ERR(phy)) {
 		fixed_phy_del(phy_addr);
 		return ERR_PTR(-EINVAL);
diff --git a/drivers/net/phy/mdio-xgene.c b/drivers/net/phy/mdio-xgene.c
index 34990eaa3298..6698e7caaf78 100644
--- a/drivers/net/phy/mdio-xgene.c
+++ b/drivers/net/phy/mdio-xgene.c
@@ -264,7 +264,7 @@ struct phy_device *xgene_enet_phy_register(struct mii_bus *bus, int phy_addr)
 {
 	struct phy_device *phy_dev;
 
-	phy_dev = get_phy_device(bus, phy_addr, false);
+	phy_dev = phy_device_create(bus, phy_addr, PHY_ID_NONE, false);
 	if (!phy_dev || IS_ERR(phy_dev))
 		return NULL;
 
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 296cf9771483..53e2fb0be7b9 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -742,7 +742,7 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
 	struct phy_device *phydev;
 	int err;
 
-	phydev = get_phy_device(bus, addr, false);
+	phydev = phy_device_create(bus, addr, PHY_ID_NONE, false);
 	if (IS_ERR(phydev))
 		return phydev;
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ad7c4cd9d357..58923826838b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -817,20 +817,6 @@ static int phy_device_read_id(struct phy_device *phydev)
 			  phydev->is_c45, &phydev->c45_ids);
 }
 
-/**
- * get_phy_device - create a phy_device withoug PHY ID
- * @bus: the target MII bus
- * @addr: PHY address on the MII bus
- * @is_c45: If true the PHY uses the 802.3 clause 45 protocol
- *
- * Allocates a new phy_device for @addr on the @bus.
- */
-struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
-{
-	return phy_device_create(bus, addr, PHY_ID_NONE, is_c45);
-}
-EXPORT_SYMBOL(get_phy_device);
-
 /**
  * phy_device_register - Register the phy device on the MDIO bus
  * @phydev: phy_device structure to be added to the MDIO bus
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 73c2969f11a4..0b165d928762 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1431,7 +1431,7 @@ static int sfp_sm_probe_phy(struct sfp *sfp, bool is_c45)
 	struct phy_device *phy;
 	int err;
 
-	phy = get_phy_device(sfp->i2c_mii, SFP_PHY_ADDR, is_c45);
+	phy = phy_device_create(sfp->i2c_mii, SFP_PHY_ADDR, PHY_ID_NONE, is_c45);
 	if (phy == ERR_PTR(-ENODEV))
 		return PTR_ERR(phy);
 	if (IS_ERR(phy)) {
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 63843037673c..af576d056e45 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -120,10 +120,13 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	is_c45 = of_device_is_compatible(child,
 					 "ethernet-phy-ieee802.3-c45");
 
-	if (!is_c45 && !of_get_phy_id(child, &phy_id))
-		phy = phy_device_create(mdio, addr, phy_id, 0);
-	else
-		phy = get_phy_device(mdio, addr, is_c45);
+	if (!is_c45) {
+		rc = of_get_phy_id(child, &phy_id);
+		if (rc)
+			phy_id = PHY_ID_NONE;
+	}
+
+	phy = phy_device_create(mdio, addr, phy_id, is_c45);
 	if (IS_ERR(phy)) {
 		if (mii_ts)
 			unregister_mii_timestamper(mii_ts);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 662919c1dd27..01d24a934ad1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1215,16 +1215,9 @@ int phy_modify_paged(struct phy_device *phydev, int page, u32 regnum,
 struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45);
 #if IS_ENABLED(CONFIG_PHYLIB)
-struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
-static inline
-struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
-{
-	return NULL;
-}
-
 static inline int phy_device_register(struct phy_device *phy)
 {
 	return 0;
-- 
2.26.1

