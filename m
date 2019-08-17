Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625F390FFE
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 12:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfHQKay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 06:30:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37728 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfHQKay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 06:30:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id z11so3902432wrt.4
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 03:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9wNoz7ijJoCTfhObFEBRQZooFA8ntqj0qgUNidYxe9M=;
        b=DIxHeEcU/3JDLUT7ahMfAB9Hu3qpvZ4VuScOuWybL9UtY1a6kFl8wOfR3EtAeWtPmb
         94QUcDnJblCpaBRBvlOV0TUd20yR+BkTBE4sIXDcOw5Uwu4vThQNzThXPE+g/onVbxps
         yJ7/Qr2DTiWUh/tRL1NZX+7z5dIYTNXpICHk/6oKqq0emN1N7+yWkE+wgxBFeGrzmmtN
         tJTE5VFde75aqgt6axsXx+QOa7JgNv7l7Pdq18gNuWfePeZJ1VcGVxJr1yIlIbrzM2xa
         GjNGGAajEsCvG1hopjVUwJKba6MTETKJ85iKj8af/QtZX0ALpmibm6Fvi15uaXwiyNiy
         yXiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9wNoz7ijJoCTfhObFEBRQZooFA8ntqj0qgUNidYxe9M=;
        b=SpOi823Xrwuh0fH1yodB+HJgP0An/gbBFt8MjAsuoHHt/UrKi2/QjYHFqF61B7tqzW
         5/BqYYCuPsQrY4l0pRUHeg8OCWz6W223o+bkiqx1oJzXH0gYiFy+TDRh1mxUrAfPQMCR
         4kXJQOlwnKc0VterN93+1Up2XwWnDtptT+vMZxKpFj12NHZoR6KohdaOVlrZwZNXpmvO
         AQxxykj55uP8aA6nzaVUh4IeNR9AhVKMTZ2YJ1lJVI5DCoGwX//tSnuclZ7F1iJCQ+yK
         zpg/uMrSs9F7TW6e53nMdjD3nn4F7kBX3Pb3njrVU1wIs+ayAgzTVRwJZaUTaZRYFHuB
         cXfw==
X-Gm-Message-State: APjAAAUH8mn7R/Mm+itphtYuGotbZhjREZDu9yGlMJfTGIkS9i8KK2fb
        /NyFucst/kX9TLMJG/IZVA0=
X-Google-Smtp-Source: APXvYqzpzRl+ZmZIYseIGX4xgKcQY+1pmRGAAPzQnB2zvQN2dWXIRKXom25m3UtLTYUzCxtSjmJw6w==
X-Received: by 2002:adf:ff8e:: with SMTP id j14mr15935552wrr.141.1566037851575;
        Sat, 17 Aug 2019 03:30:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f47:db00:ec01:10b1:c9a3:2488? ([2003:ea:8f47:db00:ec01:10b1:c9a3:2488])
        by smtp.googlemail.com with ESMTPSA id n12sm5663566wmc.24.2019.08.17.03.30.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 03:30:50 -0700 (PDT)
Subject: [PATCH net-next v3 1/3] net: phy: remove calls to genphy_config_init
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <8790db9d-af10-c3b1-bc65-ee21bb99e6d9@gmail.com>
Message-ID: <e0ced3f6-323a-2563-0d2a-5ea8a8931aca@gmail.com>
Date:   Sat, 17 Aug 2019 12:29:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8790db9d-af10-c3b1-bc65-ee21bb99e6d9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supported PHY features are either auto-detected or explicitly set.
In both cases calling genphy_config_init isn't needed. All that
genphy_config_init does is removing features that are set as
supported but can't be auto-detected. Basically it duplicates the
code in genphy_read_abilities. Therefore remove such calls from
all PHY drivers.

v2:
- remove call also from new adin PHY driver
v3:
- pass NULL as config_init function pointer for dp83848

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/adin.c         |  4 ----
 drivers/net/phy/at803x.c       |  4 ----
 drivers/net/phy/dp83822.c      |  5 -----
 drivers/net/phy/dp83848.c      | 11 +++--------
 drivers/net/phy/dp83tc811.c    |  4 ----
 drivers/net/phy/meson-gxl.c    |  2 +-
 drivers/net/phy/microchip.c    |  1 -
 drivers/net/phy/microchip_t1.c |  1 -
 drivers/net/phy/mscc.c         |  4 ++--
 drivers/net/phy/vitesse.c      |  6 +++---
 10 files changed, 9 insertions(+), 33 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index ac79e16cd..4dec83df0 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -356,10 +356,6 @@ static int adin_config_init(struct phy_device *phydev)
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
 
-	rc = genphy_config_init(phydev);
-	if (rc < 0)
-		return rc;
-
 	rc = adin_config_rgmii_mode(phydev);
 	if (rc < 0)
 		return rc;
diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 222ccd9ec..d98aa5671 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -249,10 +249,6 @@ static int at803x_config_init(struct phy_device *phydev)
 {
 	int ret;
 
-	ret = genphy_config_init(phydev);
-	if (ret < 0)
-		return ret;
-
 	/* The RX and TX delay default is:
 	 *   after HW reset: RX delay enabled and TX delay disabled
 	 *   after SW reset: RX delay enabled, while TX delay retains the
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 7ed4760fb..8a4b1d167 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -254,13 +254,8 @@ static int dp83822_config_intr(struct phy_device *phydev)
 
 static int dp83822_config_init(struct phy_device *phydev)
 {
-	int err;
 	int value;
 
-	err = genphy_config_init(phydev);
-	if (err < 0)
-		return err;
-
 	value = DP83822_WOL_MAGIC_EN | DP83822_WOL_SECURE_ON | DP83822_WOL_EN;
 
 	return phy_write_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
diff --git a/drivers/net/phy/dp83848.c b/drivers/net/phy/dp83848.c
index 6f9bc7d91..54c7c1b44 100644
--- a/drivers/net/phy/dp83848.c
+++ b/drivers/net/phy/dp83848.c
@@ -68,13 +68,8 @@ static int dp83848_config_intr(struct phy_device *phydev)
 
 static int dp83848_config_init(struct phy_device *phydev)
 {
-	int err;
 	int val;
 
-	err = genphy_config_init(phydev);
-	if (err < 0)
-		return err;
-
 	/* DP83620 always reports Auto Negotiation Ability on BMSR. Instead,
 	 * we check initial value of BMCR Auto negotiation enable bit
 	 */
@@ -113,13 +108,13 @@ MODULE_DEVICE_TABLE(mdio, dp83848_tbl);
 
 static struct phy_driver dp83848_driver[] = {
 	DP83848_PHY_DRIVER(TI_DP83848C_PHY_ID, "TI DP83848C 10/100 Mbps PHY",
-			   genphy_config_init),
+			   NULL),
 	DP83848_PHY_DRIVER(NS_DP83848C_PHY_ID, "NS DP83848C 10/100 Mbps PHY",
-			   genphy_config_init),
+			   NULL),
 	DP83848_PHY_DRIVER(TI_DP83620_PHY_ID, "TI DP83620 10/100 Mbps PHY",
 			   dp83848_config_init),
 	DP83848_PHY_DRIVER(TLK10X_PHY_ID, "TI TLK10X 10/100 Mbps PHY",
-			   genphy_config_init),
+			   NULL),
 };
 module_phy_driver(dp83848_driver);
 
diff --git a/drivers/net/phy/dp83tc811.c b/drivers/net/phy/dp83tc811.c
index ac27da168..06f08832e 100644
--- a/drivers/net/phy/dp83tc811.c
+++ b/drivers/net/phy/dp83tc811.c
@@ -277,10 +277,6 @@ static int dp83811_config_init(struct phy_device *phydev)
 {
 	int value, err;
 
-	err = genphy_config_init(phydev);
-	if (err < 0)
-		return err;
-
 	value = phy_read(phydev, MII_DP83811_SGMII_CTRL);
 	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
 		err = phy_write(phydev, MII_DP83811_SGMII_CTRL,
diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index fa80d6dce..e8f2ca625 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -136,7 +136,7 @@ static int meson_gxl_config_init(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
-	return genphy_config_init(phydev);
+	return 0;
 }
 
 /* This function is provided to cope with the possible failures of this phy
diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index eb1b3287f..a644e8e50 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -305,7 +305,6 @@ static int lan88xx_config_init(struct phy_device *phydev)
 {
 	int val;
 
-	genphy_config_init(phydev);
 	/*Zerodetect delay enable */
 	val = phy_read_mmd(phydev, MDIO_MMD_PCS,
 			   PHY_ARDENNES_MMD_DEV_3_PHY_CFG);
diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 3d09b4716..001def450 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -48,7 +48,6 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 
 		.features       = PHY_BASIC_T1_FEATURES,
 
-		.config_init    = genphy_config_init,
 		.config_aneg    = genphy_config_aneg,
 
 		.ack_interrupt  = lan87xx_phy_ack_interrupt,
diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 645d354ff..7ada1fd9c 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -1725,7 +1725,7 @@ static int vsc8584_config_init(struct phy_device *phydev)
 			return ret;
 	}
 
-	return genphy_config_init(phydev);
+	return 0;
 
 err:
 	mutex_unlock(&phydev->mdio.bus->mdio_lock);
@@ -1767,7 +1767,7 @@ static int vsc85xx_config_init(struct phy_device *phydev)
 			return rc;
 	}
 
-	return genphy_config_init(phydev);
+	return 0;
 }
 
 static int vsc8584_did_interrupt(struct phy_device *phydev)
diff --git a/drivers/net/phy/vitesse.c b/drivers/net/phy/vitesse.c
index 43691b1ac..bb6803527 100644
--- a/drivers/net/phy/vitesse.c
+++ b/drivers/net/phy/vitesse.c
@@ -197,7 +197,7 @@ static int vsc738x_config_init(struct phy_device *phydev)
 
 	vsc73xx_config_init(phydev);
 
-	return genphy_config_init(phydev);
+	return 0;
 }
 
 static int vsc739x_config_init(struct phy_device *phydev)
@@ -229,7 +229,7 @@ static int vsc739x_config_init(struct phy_device *phydev)
 
 	vsc73xx_config_init(phydev);
 
-	return genphy_config_init(phydev);
+	return 0;
 }
 
 static int vsc73xx_config_aneg(struct phy_device *phydev)
@@ -267,7 +267,7 @@ static int vsc8601_config_init(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	return genphy_config_init(phydev);
+	return 0;
 }
 
 static int vsc824x_ack_interrupt(struct phy_device *phydev)
-- 
2.22.1


