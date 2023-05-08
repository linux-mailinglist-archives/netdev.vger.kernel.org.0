Return-Path: <netdev+bounces-927-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4350D6FB663
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 20:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D59E8280C61
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47A7B11189;
	Mon,  8 May 2023 18:43:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3592F11188
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 18:43:39 +0000 (UTC)
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3249759E9;
	Mon,  8 May 2023 11:43:37 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-7577e7a83a2so73145385a.3;
        Mon, 08 May 2023 11:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683571416; x=1686163416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HSI1cyMftkfD9gEVAn4dh2LDnuC+DWvnH++idemGV1s=;
        b=NZlGUytzCI1frZrMMQooFV51EpEkQ64RmUZKdOiBdLTSLWQl3GEkKuIJ305bxA9mQ+
         H9UwCjZ5b45pYna2/sb66BEiO40vR/4p+QAL349e+j7Ure6hZ22N5J9GL9Y1xXFW2JIh
         76aWwtOQnkcgkxIWepFtNtpIcB+Ve95RRbuMB8NasMqIqMO0cmEf0LnIwHQfkoabqOhV
         S+8zCh70NVEzn8eKY2yI3dTR/jcnsBHjBGJkJ4mfjqV0YhIaVqzteKjh1IOF650i0UZ9
         JO+e0uRblIl47vnx6XE6u7JdQsPJfObxuXu0wAjEw6lHWoVp8HXpSkLUq6y94X6zyPtR
         BonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683571416; x=1686163416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HSI1cyMftkfD9gEVAn4dh2LDnuC+DWvnH++idemGV1s=;
        b=F8TK+s33aaIUaTvQ2Xa2f2ACONfxaBAAwaT/3sbDjEepdm0Jc9yX1xcHUQ+P7lZKMz
         szuvTjoI41d/x4r71Yek77JrZCm6lmt+4UXS9Fxyl4fgWVmLaAMSsA3zcSDdewgXwDfB
         Q7kGabiENoQxOZdZf+Q5z/2FrDtHe9OkMJVXAQg/bLfK0qnOZVNPClXvh8W6XVUUOZsj
         TqAWmZitzgsdK1h+mq1ifhhj3P+T1VWleDkesOszgNpahDdsQj9ahFIMJjPkBqP1i6qY
         r693JJbKVeLoAzKWl8qFSvKxzzEcP+EPVNitzqeQ4nytAaT6rfQnyQ0ZeoU6DLONMuJv
         3HPg==
X-Gm-Message-State: AC+VfDzEl/ZDup8ZHY4rEGLwNNxqPPkdxRXZDODw0rxmQSj9Md5BRDks
	ZRZKMv1TB/YcEh9ZFaTBLjMFt38pad0=
X-Google-Smtp-Source: ACHHUZ5By6VubEzc3EoHUZdPyyeBEgAoCXBKR2ckrESzZSi5o0AH8SM+nRe3le9cNjDE1v+CC0NxUw==
X-Received: by 2002:a05:622a:14cc:b0:3ef:336f:56c6 with SMTP id u12-20020a05622a14cc00b003ef336f56c6mr18611137qtx.17.1683571415729;
        Mon, 08 May 2023 11:43:35 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v26-20020ac83d9a000000b003d3a34d2eb2sm3193988qtf.41.2023.05.08.11.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 11:43:34 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Peter Geis <pgwipeout@gmail.com>,
	Frank <Frank.Sae@motor-comm.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 1/3] net: phy: Let drivers check Wake-on-LAN status
Date: Mon,  8 May 2023 11:43:07 -0700
Message-Id: <20230508184309.1628108-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230508184309.1628108-1-f.fainelli@gmail.com>
References: <20230508184309.1628108-1-f.fainelli@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A few PHY drivers are currently attempting to not suspend the PHY when
Wake-on-LAN is enabled, however that code is not currently executing at
all due to an early check in phy_suspend().

This prevents PHY drivers from making an appropriate decisions and put
the hardware into a low power state if desired.

In order to allow the PHY framework to always call into the PHY driver's
->suspend routine whether Wake-on-LAN is enabled or not, provide a
phydev::wol_enabled boolean that tracks whether the PHY or the attached
MAC has Wake-on-LAN enabled.

If phydev::wol_enabled then the PHY shall not prevent its own
Wake-on-LAN detection logic from working and shall not prevent the
Ethernet MAC from receiving packets for matching.

The check for -EBUSY is also removed since it would have prevented a PHY
being in an always on power domain and thus retaining its Wake-on-LAN
configuration from allowing the system to suspend.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/aquantia_main.c   |  3 +++
 drivers/net/phy/at803x.c          | 10 ++++++++++
 drivers/net/phy/bcm7xxx.c         |  3 +++
 drivers/net/phy/broadcom.c        |  6 ++++++
 drivers/net/phy/dp83822.c         |  2 +-
 drivers/net/phy/dp83867.c         |  3 +++
 drivers/net/phy/dp83tc811.c       |  2 +-
 drivers/net/phy/marvell-88x2222.c |  3 +++
 drivers/net/phy/marvell.c         |  3 +++
 drivers/net/phy/marvell10g.c      |  3 +++
 drivers/net/phy/micrel.c          |  3 +++
 drivers/net/phy/microchip.c       |  4 +---
 drivers/net/phy/motorcomm.c       |  2 +-
 drivers/net/phy/phy-c45.c         |  3 +++
 drivers/net/phy/phy_device.c      |  7 +++++--
 drivers/net/phy/realtek.c         |  3 +++
 include/linux/phy.h               |  3 +++
 17 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 334a6904ca5a..ffe4e8f16c07 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -691,6 +691,9 @@ static int aqr107_suspend(struct phy_device *phydev)
 {
 	int err;
 
+	if (phydev->wol_enabled)
+		return 0;
+
 	err = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, MDIO_CTRL1,
 			       MDIO_CTRL1_LPOWER);
 	if (err)
diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 656136628ffd..acd941beeb8e 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -569,6 +569,13 @@ static int at803x_suspend(struct phy_device *phydev)
 	int value;
 	int wol_enabled;
 
+	/* We cannot isolate if the attached network device has
+	 * Wake-on-LAN enabled since we would not be passing
+	 * packets through it.
+	 */
+	if (phydev->attached_dev->wol_enabled)
+		return 0;
+
 	value = phy_read(phydev, AT803X_INTR_ENABLE);
 	wol_enabled = value & AT803X_INTR_ENABLE_WOL;
 
@@ -1701,6 +1708,9 @@ static int qca83xx_suspend(struct phy_device *phydev)
 {
 	u16 mask = 0;
 
+	if (phydev->wol_enabled)
+		return 0;
+
 	/* Only QCA8337 support actual suspend.
 	 * QCA8327 cause port unreliability when phy suspend
 	 * is set.
diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 06be71ecd2f8..f060a5783694 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -747,6 +747,9 @@ static int bcm7xxx_suspend(struct phy_device *phydev)
 	};
 	unsigned int i;
 
+	if (phydev->wol_enabled)
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(bcm7xxx_suspend_cfg); i++) {
 		ret = phy_write(phydev,
 				bcm7xxx_suspend_cfg[i].reg,
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index ad71c88c87e7..3f142dc266a9 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -443,6 +443,9 @@ static int bcm54xx_suspend(struct phy_device *phydev)
 
 	bcm54xx_ptp_stop(phydev);
 
+	if (phydev->wol_enabled)
+		return 0;
+
 	/* We cannot use a read/modify/write here otherwise the PHY gets into
 	 * a bad state where its LEDs keep flashing, thus defeating the purpose
 	 * of low power mode.
@@ -770,6 +773,9 @@ static int brcm_fet_suspend(struct phy_device *phydev)
 {
 	int reg, err, err2, brcmtest;
 
+	if (phydev->wol_enabled)
+		return 0;
+
 	/* We cannot use a read/modify/write here otherwise the PHY continues
 	 * to drive LEDs which defeats the purpose of low power mode.
 	 */
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index b7cb71817780..2ab0cbd1a60f 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -573,7 +573,7 @@ static int dp83822_suspend(struct phy_device *phydev)
 
 	value = phy_read_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG);
 
-	if (!(value & DP83822_WOL_EN))
+	if (!(value & DP83822_WOL_EN) && !phydev->wol_enabled)
 		genphy_suspend(phydev);
 
 	return 0;
diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index d75f526a20a4..8f2b19e57f90 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -708,6 +708,9 @@ static int dp83867_suspend(struct phy_device *phydev)
 		dp83867_config_intr(phydev);
 	}
 
+	if (phydev->wol_enabled)
+		return 0;
+
 	return genphy_suspend(phydev);
 }
 
diff --git a/drivers/net/phy/dp83tc811.c b/drivers/net/phy/dp83tc811.c
index 7ea32fb77190..2106f9ea15f5 100644
--- a/drivers/net/phy/dp83tc811.c
+++ b/drivers/net/phy/dp83tc811.c
@@ -368,7 +368,7 @@ static int dp83811_suspend(struct phy_device *phydev)
 
 	value = phy_read_mmd(phydev, DP83811_DEVADDR, MII_DP83811_WOL_CFG);
 
-	if (!(value & DP83811_WOL_EN))
+	if (!(value & DP83811_WOL_EN) && !phydev->wol_enabled)
 		genphy_suspend(phydev);
 
 	return 0;
diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
index f83cae64585d..9c13e4dd1807 100644
--- a/drivers/net/phy/marvell-88x2222.c
+++ b/drivers/net/phy/marvell-88x2222.c
@@ -458,6 +458,9 @@ static int mv2222_resume(struct phy_device *phydev)
 
 static int mv2222_suspend(struct phy_device *phydev)
 {
+	/* No need to check for phydev->wol_enabled since we only disable the
+	 * transmitter
+	 */
 	return mv2222_tx_disable(phydev);
 }
 
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 43b6cb725551..c08ad1c3f4c3 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1741,6 +1741,9 @@ static int marvell_suspend(struct phy_device *phydev)
 {
 	int err;
 
+	if (phydev->wol_enabled)
+		return 0;
+
 	/* Suspend the fiber mode first */
 	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
 			      phydev->supported)) {
diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 55d9d7acc32e..6d45a94e5bea 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -559,6 +559,9 @@ static void mv3310_remove(struct phy_device *phydev)
 
 static int mv3310_suspend(struct phy_device *phydev)
 {
+	if (phydev->wol_enabled)
+		return 0;
+
 	return mv3310_power_down(phydev);
 }
 
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 3f81bb8dac44..fe71ab8926fc 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1826,6 +1826,9 @@ static int kszphy_suspend(struct phy_device *phydev)
 			phydev->drv->config_intr(phydev);
 	}
 
+	if (phydev->wol_enabled)
+		return 0;
+
 	return genphy_suspend(phydev);
 }
 
diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index 0b88635f4fbc..5290fd684c93 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -74,10 +74,8 @@ static irqreturn_t lan88xx_handle_interrupt(struct phy_device *phydev)
 
 static int lan88xx_suspend(struct phy_device *phydev)
 {
-	struct lan88xx_priv *priv = phydev->priv;
-
 	/* do not power down PHY when WOL is enabled */
-	if (!priv->wolopts)
+	if (!phydev->wol_enabled)
 		genphy_suspend(phydev);
 
 	return 0;
diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 2fa5a90e073b..50472708c15e 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -1414,7 +1414,7 @@ static int yt8521_suspend(struct phy_device *phydev)
 		return wol_config;
 
 	/* if wol enable, do nothing */
-	if (wol_config & YTPHY_WCR_ENABLE)
+	if ((wol_config & YTPHY_WCR_ENABLE) || phydev->wol_enabled)
 		return 0;
 
 	return yt8521_modify_utp_fiber_bmcr(phydev, 0, BMCR_PDOWN);
diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index fee514b96ab1..355e78c441a8 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -64,6 +64,9 @@ EXPORT_SYMBOL_GPL(genphy_c45_pma_resume);
  */
 int genphy_c45_pma_suspend(struct phy_device *phydev)
 {
+	if (phydev->wol_enabled)
+		return 0;
+
 	if (!genphy_c45_pma_can_sleep(phydev))
 		return -EOPNOTSUPP;
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 17d0d0555a79..ae86e169a578 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1862,8 +1862,8 @@ int phy_suspend(struct phy_device *phydev)
 
 	/* If the device has WOL enabled, we cannot suspend the PHY */
 	phy_ethtool_get_wol(phydev, &wol);
-	if (wol.wolopts || (netdev && netdev->wol_enabled))
-		return -EBUSY;
+	phydev->wol_enabled = !!(wol.wolopts || (netdev &&
+				netdev->wol_enabled));
 
 	if (!phydrv || !phydrv->suspend)
 		return 0;
@@ -2687,6 +2687,9 @@ EXPORT_SYMBOL(genphy_write_mmd_unsupported);
 
 int genphy_suspend(struct phy_device *phydev)
 {
+	if (phydev->wol_enabled)
+		return 0;
+
 	return phy_set_bits(phydev, MII_BMCR, BMCR_PDOWN);
 }
 EXPORT_SYMBOL(genphy_suspend);
diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 3d99fd6664d7..316f9e868d84 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -482,6 +482,9 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 
 static int rtl8211b_suspend(struct phy_device *phydev)
 {
+	if (phydev->wol_enabled)
+		return 0;
+
 	phy_write(phydev, MII_MMD_DATA, BIT(9));
 
 	return genphy_suspend(phydev);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index c5a0dc829714..e36dfc8236b4 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -548,6 +548,8 @@ struct macsec_ops;
  * @downshifted_rate: Set true if link speed has been downshifted.
  * @is_on_sfp_module: Set true if PHY is located on an SFP module.
  * @mac_managed_pm: Set true if MAC driver takes of suspending/resuming PHY
+ * @wol_enabled: Set to true if the PHY or the attached MAC have Wake-on-LAN
+ *		 enabled.
  * @state: State of the PHY for management purposes
  * @dev_flags: Device-specific flags used by the PHY driver.
  *
@@ -644,6 +646,7 @@ struct phy_device {
 	unsigned downshifted_rate:1;
 	unsigned is_on_sfp_module:1;
 	unsigned mac_managed_pm:1;
+	unsigned wol_enabled:1;
 
 	unsigned autoneg:1;
 	/* The most recently read link state */
-- 
2.34.1


