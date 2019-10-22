Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04921E0B77
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732622AbfJVSbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:31:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32952 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbfJVSbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:31:49 -0400
Received: by mail-pf1-f194.google.com with SMTP id c184so1651227pfb.0;
        Tue, 22 Oct 2019 11:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gq0C8TRzKJcucJI81WWH6nhSTS0UHGvhSIPibYL1P8M=;
        b=gXKklKpHfMMjD1q19dng7Ut1n/RrMM0Run8pcJG/MzUFJdTZLZ3STV8JpGKX3B+sGb
         9N8T/7SsLZEQJVjrb+Lw7TPVhXt43Ide0/mZkByYUpTm++TexXBgj20gShXWytVWxqU/
         bmpogeYIuqoi9jXnlfxdU9wlMs3WQ035hdluf75ZmeDm9fOJR7sIuCecMYt5v+un5FVm
         m5LVMZCd8XXYRIwyJALjfLhBIiLBteNxjrb/YpexVbVeyU/yqtyr1ruC8qJPMCOGlvOW
         xrXKeX7Rmua/Wa51sXhV2bj+FcQdOyfikAHtScbQy+FF3ogwd+genf348F5grF9ziTot
         BCCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gq0C8TRzKJcucJI81WWH6nhSTS0UHGvhSIPibYL1P8M=;
        b=Nd+H4LI6lYwdXj95zcvb+6qmoIIuO8idN+qbW3BRy13rGWItkfkkW02qFg5P+e/qDQ
         ElIb/99mXJhuuxBdiBB4vDBk8Kgv2ofLj7uQgtqK+5pyPmn/mZsKJW3rirjiJDBkbX4I
         vkl7CUQskxYsDz5k7hSz1bKjTsIOf1Jv5Y8ivtLPH1gxZj01OKCMaSfpXd0prXIFKFsO
         dr10M1fOcqgFY2yKkWxYZ597qWMqI1zZRX+6o/vkkHWDCfaEUy+9p8N0BUNbj8r3DU+v
         gIxM9U6XMvfeW7LpZO8YkFP59quqRhY3qGaBHDAQOVO5IDuccILQo9Zo94BexAuyN/81
         7SvQ==
X-Gm-Message-State: APjAAAVKv0aFuyBK2cEjkCvURdgcORdeiRxp1mvAhwD+bvJfnnokI/ZX
        c+3G21q88GiHRk771m/kguE=
X-Google-Smtp-Source: APXvYqzvfJPyFJScJCflmvcyrpvAsGefMEB8NEz+27rayAOIbSazC/fsgICpBfsFwnHSv0ORPPHsiA==
X-Received: by 2002:a63:cb0f:: with SMTP id p15mr5227906pgg.81.1571769107124;
        Tue, 22 Oct 2019 11:31:47 -0700 (PDT)
Received: from taoren-ubuntu-R90MNF91.thefacebook.com ([2620:10d:c090:200::2398])
        by smtp.gmail.com with ESMTPSA id m19sm16787947pjl.28.2019.10.22.11.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 11:31:46 -0700 (PDT)
From:   rentao.bupt@gmail.com
To:     "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Cc:     Tao Ren <taoren@fb.com>
Subject: [PATCH net-next v10 3/3] net: phy: broadcom: add 1000Base-X support for BCM54616S
Date:   Tue, 22 Oct 2019 11:31:08 -0700
Message-Id: <20191022183108.14029-4-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191022183108.14029-1-rentao.bupt@gmail.com>
References: <20191022183108.14029-1-rentao.bupt@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Ren <taoren@fb.com>

The BCM54616S PHY cannot work properly in RGMII->1000Base-X mode, mainly
because genphy functions are designed for copper links, and 1000Base-X
(clause 37) auto negotiation needs to be handled differently.

This patch enables 1000Base-X support for BCM54616S by customizing 3
driver callbacks, and it's verified to be working on Facebook CMM BMC
platform (RGMII->1000Base-KX):

  - probe: probe callback detects PHY's operation mode based on
    INTERF_SEL[1:0] pins and 1000X/100FX selection bit in SerDES 100-FX
    Control register.

  - config_aneg: calls genphy_c37_config_aneg when the PHY is running in
    1000Base-X mode; otherwise, genphy_config_aneg will be called.

  - read_status: calls genphy_c37_read_status when the PHY is running in
    1000Base-X mode; otherwise, genphy_read_status will be called.

Note: BCM54616S PHY can also be configured in RGMII->100Base-FX mode, and
100Base-FX support is not available as of now.

Signed-off-by: Tao Ren <taoren@fb.com>
Acked-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 No changes in v8/v9/v10.
 Changes in v7:
  - Add comment "BCM54616S 100Base-FX is not supported".
 Changes in v6:
  - nothing changed.
 Changes in v5:
  - include Heiner's patch "net: phy: add support for clause 37
    auto-negotiation" into the series.
  - use genphy_c37_config_aneg and genphy_c37_read_status in BCM54616S
    PHY driver's callback when the PHY is running in 1000Base-X mode.
 Changes in v4:
  - add bcm54616s_config_aneg_1000bx() to deal with auto negotiation in
    1000Base-X mode.
 Changes in v3:
  - rename bcm5482_read_status to bcm54xx_read_status so the callback can
    be shared by BCM5482 and BCM54616S.
 Changes in v2:
  - Auto-detect PHY operation mode instead of passing DT node.
  - move PHY mode auto-detect logic from config_init to probe callback.
  - only set speed (not including duplex) in read_status callback.
  - update patch description with more background to avoid confusion.
  - patch #1 in the series ("net: phy: broadcom: set features explicitly
    for BCM54616") is dropped.

 drivers/net/phy/broadcom.c | 57 +++++++++++++++++++++++++++++++++++---
 include/linux/brcmphy.h    | 10 +++++--
 2 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 4313c74b4fd8..7d68b28bb893 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -359,9 +359,9 @@ static int bcm5482_config_init(struct phy_device *phydev)
 		/*
 		 * Select 1000BASE-X register set (primary SerDes)
 		 */
-		reg = bcm_phy_read_shadow(phydev, BCM5482_SHD_MODE);
-		bcm_phy_write_shadow(phydev, BCM5482_SHD_MODE,
-				     reg | BCM5482_SHD_MODE_1000BX);
+		reg = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
+		bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE,
+				     reg | BCM54XX_SHD_MODE_1000BX);
 
 		/*
 		 * LED1=ACTIVITYLED, LED3=LINKSPD[2]
@@ -427,12 +427,47 @@ static int bcm5481_config_aneg(struct phy_device *phydev)
 	return ret;
 }
 
+static int bcm54616s_probe(struct phy_device *phydev)
+{
+	int val, intf_sel;
+
+	val = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
+	if (val < 0)
+		return val;
+
+	/* The PHY is strapped in RGMII-fiber mode when INTERF_SEL[1:0]
+	 * is 01b, and the link between PHY and its link partner can be
+	 * either 1000Base-X or 100Base-FX.
+	 * RGMII-1000Base-X is properly supported, but RGMII-100Base-FX
+	 * support is still missing as of now.
+	 */
+	intf_sel = (val & BCM54XX_SHD_INTF_SEL_MASK) >> 1;
+	if (intf_sel == 1) {
+		val = bcm_phy_read_shadow(phydev, BCM54616S_SHD_100FX_CTRL);
+		if (val < 0)
+			return val;
+
+		/* Bit 0 of the SerDes 100-FX Control register, when set
+		 * to 1, sets the MII/RGMII -> 100BASE-FX configuration.
+		 * When this bit is set to 0, it sets the GMII/RGMII ->
+		 * 1000BASE-X configuration.
+		 */
+		if (!(val & BCM54616S_100FX_MODE))
+			phydev->dev_flags |= PHY_BCM_FLAGS_MODE_1000BX;
+	}
+
+	return 0;
+}
+
 static int bcm54616s_config_aneg(struct phy_device *phydev)
 {
 	int ret;
 
 	/* Aneg firsly. */
-	ret = genphy_config_aneg(phydev);
+	if (phydev->dev_flags & PHY_BCM_FLAGS_MODE_1000BX)
+		ret = genphy_c37_config_aneg(phydev);
+	else
+		ret = genphy_config_aneg(phydev);
 
 	/* Then we can set up the delay. */
 	bcm54xx_config_clock_delay(phydev);
@@ -440,6 +475,18 @@ static int bcm54616s_config_aneg(struct phy_device *phydev)
 	return ret;
 }
 
+static int bcm54616s_read_status(struct phy_device *phydev)
+{
+	int err;
+
+	if (phydev->dev_flags & PHY_BCM_FLAGS_MODE_1000BX)
+		err = genphy_c37_read_status(phydev);
+	else
+		err = genphy_read_status(phydev);
+
+	return err;
+}
+
 static int brcm_phy_setbits(struct phy_device *phydev, int reg, int set)
 {
 	int val;
@@ -631,6 +678,8 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_aneg	= bcm54616s_config_aneg,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.read_status	= bcm54616s_read_status,
+	.probe		= bcm54616s_probe,
 }, {
 	.phy_id		= PHY_ID_BCM5464,
 	.phy_id_mask	= 0xfffffff0,
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 6db2d9a6e503..b475e7f20d28 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -200,9 +200,15 @@
 #define BCM5482_SHD_SSD		0x14	/* 10100: Secondary SerDes control */
 #define BCM5482_SHD_SSD_LEDM	0x0008	/* SSD LED Mode enable */
 #define BCM5482_SHD_SSD_EN	0x0001	/* SSD enable */
-#define BCM5482_SHD_MODE	0x1f	/* 11111: Mode Control Register */
-#define BCM5482_SHD_MODE_1000BX	0x0001	/* Enable 1000BASE-X registers */
 
+/* 10011: SerDes 100-FX Control Register */
+#define BCM54616S_SHD_100FX_CTRL	0x13
+#define	BCM54616S_100FX_MODE		BIT(0)	/* 100-FX SerDes Enable */
+
+/* 11111: Mode Control Register */
+#define BCM54XX_SHD_MODE		0x1f
+#define BCM54XX_SHD_INTF_SEL_MASK	GENMASK(2, 1)	/* INTERF_SEL[1:0] */
+#define BCM54XX_SHD_MODE_1000BX		BIT(0)	/* Enable 1000-X registers */
 
 /*
  * EXPANSION SHADOW ACCESS REGISTERS.  (PHY REG 0x15, 0x16, and 0x17)
-- 
2.17.1

