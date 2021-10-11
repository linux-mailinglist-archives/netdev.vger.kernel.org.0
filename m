Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031AE4296A8
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 20:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234436AbhJKSRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 14:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234412AbhJKSRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 14:17:20 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AEFC06161C;
        Mon, 11 Oct 2021 11:15:19 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id f21so3106690plb.3;
        Mon, 11 Oct 2021 11:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MH+j5kT0lNOR5onkxg3uKJoFI/+8jsEEUIwv4asTgJw=;
        b=CbLfJd1SrBEZE8W2u/dJvZpcuk48MFrU/ZoQdD9mswIOZIfHKoPmJESpuo4I/VRkQE
         yMe9ifS5FOusc2o7fe1E6DidQXYZg0qtOxXiIvodUc1JDlItAssLiq8lFm8EO4vktFKW
         brPOJ5I5r6PqIpSAcsefNj2dxqUlsqfz2EiqX6nd9hOfss3dU0kuC+gUWT6CydQW4F64
         +oecVoUwN6KPogH/bXmy9pW8UN2SuTJO1fUc5+MhBTW3hXOfV15njpOkSDHV+tkOX7/2
         sfHKeOYpsPX/Dd6Jc2Q/9OOl727ej26EhK+iALgNocgqSER3hFgRJBu8e5Qq+Q24LiVC
         fjDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MH+j5kT0lNOR5onkxg3uKJoFI/+8jsEEUIwv4asTgJw=;
        b=UsiKC5wMywd8id/TuSVFthpI8uYX/0ELjyu/CUgxOchA2c7V1qGtwT/0Tz/7r1G5mX
         ggV3poLJRpuHEEmc1AO7VNv4AYY43h3qXoP0GeknsvYNgOEm7rU5RCfPzhMQ4aTW9G9Q
         ZqdS8pVqUPUq7KyqjOcHc372wBWXMUrXSy2cocA25ebSIgmkiwXCASPAgCQQkmLYL6fH
         tY4E0zqB4ebKIpXK/MCi19gKnQzVruyLIcHohDEVLCLIYCZQbb+ZwZO/s4LmezAtRDyu
         CPcyAEgj5EyOLa5ADkMt9OJcnOma2cA6WaZV/5n4ueXXl7+J8yxvP3ev0C7JxHhaEs21
         hKmA==
X-Gm-Message-State: AOAM532avqg9wBK1QyXPPTfT6AsiygL4WepOXp6LTugp2lrLzjdXFkfY
        A2WLMyIvBoTVWDDzU+AjqqMs/HvT0/0=
X-Google-Smtp-Source: ABdhPJxJKgMBmdBq0z02DcFmBijrf+J3GtnnfSDolXOJShKLtMss8/jdvGKOsotm3DTBdl9eAV3dEw==
X-Received: by 2002:a17:902:7ec2:b0:13d:b563:c39 with SMTP id p2-20020a1709027ec200b0013db5630c39mr25829583plb.14.1633976119013;
        Mon, 11 Oct 2021 11:15:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e22sm8372324pfn.101.2021.10.11.11.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 11:15:18 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org (open list:ETHERNET PHY LIBRARY)
Subject: [PATCH stable 4.14] net: phy: bcm7xxx: Fixed indirect MMD operations
Date:   Mon, 11 Oct 2021 11:15:16 -0700
Message-Id: <20211011181516.103835-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit d88fd1b546ff19c8040cfaea76bf16aed1c5a0bb upstream

When EEE support was added to the 28nm EPHY it was assumed that it would
be able to support the standard clause 45 over clause 22 register access
method. It turns out that the PHY does not support that, which is the
very reason for using the indirect shadow mode 2 bank 3 access method.

Implement {read,write}_mmd to allow the standard PHY library routines
pertaining to EEE querying and configuration to work correctly on these
PHYs. This forces us to implement a __phy_set_clr_bits() function that
does not grab the MDIO bus lock since the PHY driver's {read,write}_mmd
functions are always called with that lock held.

Fixes: 83ee102a6998 ("net: phy: bcm7xxx: add support for 28nm EPHY")
[florian: adjust locking since phy_{read,write}_mmd are called with no
PHYLIB locks held]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/phy/bcm7xxx.c | 94 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 3c5b2a2e2fcc..11f5a7116adb 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -30,7 +30,12 @@
 #define MII_BCM7XXX_SHD_2_ADDR_CTRL	0xe
 #define MII_BCM7XXX_SHD_2_CTRL_STAT	0xf
 #define MII_BCM7XXX_SHD_2_BIAS_TRIM	0x1a
+#define MII_BCM7XXX_SHD_3_PCS_CTRL	0x0
+#define MII_BCM7XXX_SHD_3_PCS_STATUS	0x1
+#define MII_BCM7XXX_SHD_3_EEE_CAP	0x2
 #define MII_BCM7XXX_SHD_3_AN_EEE_ADV	0x3
+#define MII_BCM7XXX_SHD_3_EEE_LP	0x4
+#define MII_BCM7XXX_SHD_3_EEE_WK_ERR	0x5
 #define MII_BCM7XXX_SHD_3_PCS_CTRL_2	0x6
 #define  MII_BCM7XXX_PCS_CTRL_2_DEF	0x4400
 #define MII_BCM7XXX_SHD_3_AN_STAT	0xb
@@ -462,6 +467,93 @@ static int bcm7xxx_28nm_ephy_config_init(struct phy_device *phydev)
 	return bcm7xxx_28nm_ephy_apd_enable(phydev);
 }
 
+#define MII_BCM7XXX_REG_INVALID	0xff
+
+static u8 bcm7xxx_28nm_ephy_regnum_to_shd(u16 regnum)
+{
+	switch (regnum) {
+	case MDIO_CTRL1:
+		return MII_BCM7XXX_SHD_3_PCS_CTRL;
+	case MDIO_STAT1:
+		return MII_BCM7XXX_SHD_3_PCS_STATUS;
+	case MDIO_PCS_EEE_ABLE:
+		return MII_BCM7XXX_SHD_3_EEE_CAP;
+	case MDIO_AN_EEE_ADV:
+		return MII_BCM7XXX_SHD_3_AN_EEE_ADV;
+	case MDIO_AN_EEE_LPABLE:
+		return MII_BCM7XXX_SHD_3_EEE_LP;
+	case MDIO_PCS_EEE_WK_ERR:
+		return MII_BCM7XXX_SHD_3_EEE_WK_ERR;
+	default:
+		return MII_BCM7XXX_REG_INVALID;
+	}
+}
+
+static bool bcm7xxx_28nm_ephy_dev_valid(int devnum)
+{
+	return devnum == MDIO_MMD_AN || devnum == MDIO_MMD_PCS;
+}
+
+static int bcm7xxx_28nm_ephy_read_mmd(struct phy_device *phydev,
+				      int devnum, u16 regnum)
+{
+	u8 shd = bcm7xxx_28nm_ephy_regnum_to_shd(regnum);
+	int ret;
+
+	if (!bcm7xxx_28nm_ephy_dev_valid(devnum) ||
+	    shd == MII_BCM7XXX_REG_INVALID)
+		return -EOPNOTSUPP;
+
+	/* set shadow mode 2 */
+	ret = phy_set_clr_bits(phydev, MII_BCM7XXX_TEST,
+			       MII_BCM7XXX_SHD_MODE_2, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Access the desired shadow register address */
+	ret = phy_write(phydev, MII_BCM7XXX_SHD_2_ADDR_CTRL, shd);
+	if (ret < 0)
+		goto reset_shadow_mode;
+
+	ret = phy_read(phydev, MII_BCM7XXX_SHD_2_CTRL_STAT);
+
+reset_shadow_mode:
+	/* reset shadow mode 2 */
+	phy_set_clr_bits(phydev, MII_BCM7XXX_TEST, 0,
+			 MII_BCM7XXX_SHD_MODE_2);
+	return ret;
+}
+
+static int bcm7xxx_28nm_ephy_write_mmd(struct phy_device *phydev,
+				       int devnum, u16 regnum, u16 val)
+{
+	u8 shd = bcm7xxx_28nm_ephy_regnum_to_shd(regnum);
+	int ret;
+
+	if (!bcm7xxx_28nm_ephy_dev_valid(devnum) ||
+	    shd == MII_BCM7XXX_REG_INVALID)
+		return -EOPNOTSUPP;
+
+	/* set shadow mode 2 */
+	ret = phy_set_clr_bits(phydev, MII_BCM7XXX_TEST,
+			       MII_BCM7XXX_SHD_MODE_2, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Access the desired shadow register address */
+	ret = phy_write(phydev, MII_BCM7XXX_SHD_2_ADDR_CTRL, shd);
+	if (ret < 0)
+		goto reset_shadow_mode;
+
+	/* Write the desired value in the shadow register */
+	phy_write(phydev, MII_BCM7XXX_SHD_2_CTRL_STAT, val);
+
+reset_shadow_mode:
+	/* reset shadow mode 2 */
+	return phy_set_clr_bits(phydev, MII_BCM7XXX_TEST, 0,
+				MII_BCM7XXX_SHD_MODE_2);
+}
+
 static int bcm7xxx_28nm_ephy_resume(struct phy_device *phydev)
 {
 	int ret;
@@ -637,6 +729,8 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
+	.read_mmd	= bcm7xxx_28nm_ephy_read_mmd,			\
+	.write_mmd	= bcm7xxx_28nm_ephy_write_mmd,			\
 }
 
 #define BCM7XXX_40NM_EPHY(_oui, _name)					\
-- 
2.25.1

