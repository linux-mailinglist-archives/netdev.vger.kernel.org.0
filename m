Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB564296A5
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 20:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhJKSRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 14:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbhJKSRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 14:17:15 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5823AC061570;
        Mon, 11 Oct 2021 11:15:15 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso52240pjb.4;
        Mon, 11 Oct 2021 11:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7EvivvR4AP5hz1U9GTjeYeoyVBJH7aC/GlbhSD01mZE=;
        b=YOwCN8E20B7futCnjtUYDgnC6p3I2/Z2YNqKwK0SqYKfAHWFN2g6t1HwwS+CjIx+WC
         FYnzLSVutteTdQ0dfg2WK4xSM4nrBw54ro8BZyzh1NXg6t3YL/8pgfu8HHCvX0UkVuZO
         goeVr+FAm6Ya/D7fCayTjGyXvjqbL0RfBq0avPzJE1aIQcVc9bDXQXu3UWM1OJZkIUSN
         ze1aT2z6ZCuMA+gwJN7SZmH6JbGnFuFI0QiLZ/uyMkGJ4ZM8JSXgm0HXK6JKsQhX8d4O
         p3PHkIMDzIztAXUaFxh/7BcJp0uSorQlk34lWjsZZW7x3kwM3UcbDzfBVsu2YyrvPy9r
         DakA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7EvivvR4AP5hz1U9GTjeYeoyVBJH7aC/GlbhSD01mZE=;
        b=xe9UBPOlR7U/GwwMndGrzEIRD9YarhLFhma/PtQmA6RmGfVAuTOEi8WroafWRHqAhj
         zPFaka8l4yNU4LA1N69yEGsZYZKOfKNRn75NTBr5wN/uFfkedy/Q9pYl8EmH1GWoMjex
         L98aINPIEPRmqIDjlISWuFlayjz3ih6izz1Lst0FqNzji/k9cCU6MrIgzc7jfypxBb0N
         lltTmIIRaFQOYh463nAybBvzj+nFDwCPwPHRQIA0A5RXDw/udCrKY4fyObO4H4H/XOUx
         StHcqfXWVPR78vG+jHuLZS8NpHhWYnOlP2guMBQGLAZg0CIwtu3z6gM/Q6L4Xx5VcMRH
         ydSA==
X-Gm-Message-State: AOAM530NhMb5oZuQkehNk7oWqpw0torbLnFJfetwnCbnaq0Nldycnbs/
        i/kOY1Q04/gQw+mfDQypHNq8Azvnx24=
X-Google-Smtp-Source: ABdhPJz5PYlSLANQUdqENyrAifOJWX1tW+S4elEElPSNJDaJ6uc7ZOX1uGxsho5+/qsnr50u/eWvvQ==
X-Received: by 2002:a17:90b:38d0:: with SMTP id nn16mr583801pjb.96.1633976114555;
        Mon, 11 Oct 2021 11:15:14 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w9sm145849pjk.28.2021.10.11.11.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 11:15:14 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org (open list:ETHERNET PHY LIBRARY)
Subject: [PATCH stable 4.19] net: phy: bcm7xxx: Fixed indirect MMD operations
Date:   Mon, 11 Oct 2021 11:15:10 -0700
Message-Id: <20211011181511.103732-1-f.fainelli@gmail.com>
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
index acaf072bb4b0..35dc4ca696d3 100644
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
@@ -463,6 +468,93 @@ static int bcm7xxx_28nm_ephy_config_init(struct phy_device *phydev)
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
@@ -634,6 +726,8 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
+	.read_mmd	= bcm7xxx_28nm_ephy_read_mmd,			\
+	.write_mmd	= bcm7xxx_28nm_ephy_write_mmd,			\
 }
 
 #define BCM7XXX_40NM_EPHY(_oui, _name)					\
-- 
2.25.1

