Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8063137B0F6
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 23:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhEKVrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 17:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhEKVrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 17:47:45 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD5CC061574;
        Tue, 11 May 2021 14:46:38 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id t20so11528078qtx.8;
        Tue, 11 May 2021 14:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CI7rDEDtz1d2fQifqo/5S6PRjTuydn46pxGEr7OVTEE=;
        b=noq13ruScaFSKVE89dykL7FiOcjU24r7t49tfQR3Ym18qhyxV5bBWQXewkwX1Tml/G
         hJGfA6fcbX5HV5RHQMIv/lTA0YNVU+m1jDET/VE0qDoqSQdq7vwRXT3ulNTHxBz58jZE
         PmiFjnQyV4ZNyxvJCiLeSOj3HZB9Jzj9l3P/XRIZ9cuqzdy/d5VFLS0WJcrbX8f98rrs
         lH2HOiJK7u0/xFUZRV3XFe8CbJ76KMTB5+lt3XGJBhNQhjQLjBUWhLoICBt+82OTfCNT
         3/iy/aaORkZJLKSltmTDI1sY/HgSvHtqFKFgIMYa8Y3EwPt+y2sQCwPZQQhTmEx2+Psj
         Mokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CI7rDEDtz1d2fQifqo/5S6PRjTuydn46pxGEr7OVTEE=;
        b=SCY6pPCSHXLl0wbDa4jimSqhEKk/NyWdTefr3succeu6VN/WeCA4zifkIMInbIsEZW
         2qlaBn0c5QnriJPd5IYaSUzGn7GhxuLItpMwzA5sHz9+iBgEi7au5AAC+lCDr1zIYLCR
         OKW4q76UuSiknY1vEUFxoFi7s0wcAmfg9TWxDWedDJKMSglzEWxSkoU+3RoQHkBBDiVh
         XY8W9d+OouDpcJ40A8mNpGay47AraID+E/KZnUM2lbJonFXedxSrK2/vslB9fisD45vJ
         EGOE9evglgiccNY9S9KIClV3ggEWw6530f5zhEwQTvBa+5K41tBfXi0PG2GPgVYJHXEI
         Ztsw==
X-Gm-Message-State: AOAM5328rU1RcdW6zBmST3uuW+eoxMhSitDSctTET+vyGuT6fPXVPSwh
        cBgAttd+TJ/HExTGUimJZste/kzxVVQoBkG0
X-Google-Smtp-Source: ABdhPJzhyX2eb++sGrkD6pl7DL2WFr91ZhoKaLvQLeYUgVjIiB8wRIMLr7X+0Pvc1bi4g3QpV1iNFA==
X-Received: by 2002:ac8:5cd2:: with SMTP id s18mr14368907qta.223.1620769597616;
        Tue, 11 May 2021 14:46:37 -0700 (PDT)
Received: from master-laptop.sparksnet ([2601:153:980:85b1:f9ba:6614:640b:eee1])
        by smtp.gmail.com with ESMTPSA id l10sm16413093qtn.28.2021.05.11.14.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 14:46:37 -0700 (PDT)
From:   Peter Geis <pgwipeout@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Peter Geis <pgwipeout@gmail.com>
Subject: [PATCH] net: phy: add driver for Motorcomm yt8511 phy
Date:   Tue, 11 May 2021 17:46:06 -0400
Message-Id: <20210511214605.2937099-1-pgwipeout@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a driver for the Motorcomm yt8511 phy that will be used in the
production Pine64 rk3566-quartz64 development board.
It supports gigabit transfer speeds, rgmii, and 125mhz clk output.

Signed-off-by: Peter Geis <pgwipeout@gmail.com>
---
 MAINTAINERS                 |  6 +++
 drivers/net/phy/Kconfig     |  6 +++
 drivers/net/phy/Makefile    |  1 +
 drivers/net/phy/motorcomm.c | 85 +++++++++++++++++++++++++++++++++++++
 4 files changed, 98 insertions(+)
 create mode 100644 drivers/net/phy/motorcomm.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 601b5ae0368a..2a2e406238fc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12388,6 +12388,12 @@ F:	Documentation/userspace-api/media/drivers/meye*
 F:	drivers/media/pci/meye/
 F:	include/uapi/linux/meye.h
 
+MOTORCOMM PHY DRIVER
+M:	Peter Geis <pgwipeout@gmail.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/phy/motorcomm.c
+
 MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
 S:	Orphan
 F:	Documentation/driver-api/serial/moxa-smartio.rst
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 288bf405ebdb..16db9f8037b5 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -229,6 +229,12 @@ config MICROSEMI_PHY
 	help
 	  Currently supports VSC8514, VSC8530, VSC8531, VSC8540 and VSC8541 PHYs
 
+config MOTORCOMM_PHY
+	tristate "Motorcomm PHYs"
+	help
+	  Enables support for Motorcomm network PHYs.
+	  Currently supports the YT8511 gigabit PHY.
+
 config NATIONAL_PHY
 	tristate "National Semiconductor PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index bcda7ed2455d..37ffbc6e3c87 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_MICREL_PHY)	+= micrel.o
 obj-$(CONFIG_MICROCHIP_PHY)	+= microchip.o
 obj-$(CONFIG_MICROCHIP_T1_PHY)	+= microchip_t1.o
 obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
+obj-$(CONFIG_MOTORCOMM_PHY)	+= motorcomm.o
 obj-$(CONFIG_NATIONAL_PHY)	+= national.o
 obj-$(CONFIG_NXP_C45_TJA11XX_PHY)	+= nxp-c45-tja11xx.o
 obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
new file mode 100644
index 000000000000..c6923dcf9f8f
--- /dev/null
+++ b/drivers/net/phy/motorcomm.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Driver for Motorcomm PHYs
+ *
+ * Author: Peter Geis <pgwipeout@gmail.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/phy.h>
+
+#define PHY_ID_YT8511		0x0000010a
+
+#define YT8511_PAGE_SELECT	0x1e
+#define YT8511_PAGE		0x1f
+#define YT8511_EXT_CLK_GATE	0x0c
+#define YT8511_EXT_SLEEP_CTRL	0x27
+
+/* 2b00 25m from pll
+ * 2b01 25m from xtl *default*
+ * 2b10 62.m from pll
+ * 2b11 125m from pll
+ */
+#define YT8511_CLK_125M		(BIT(2) | BIT(1))
+
+static int yt8511_read_page(struct phy_device *phydev)
+{
+	return __phy_read(phydev, YT8511_PAGE_SELECT);
+};
+
+static int yt8511_write_page(struct phy_device *phydev, int page)
+{
+	return __phy_write(phydev, YT8511_PAGE_SELECT, page);
+};
+
+static int yt8511_config_init(struct phy_device *phydev)
+{
+	int ret, val, oldpage;
+
+	/* set clock mode to 125mhz */
+	oldpage = phy_select_page(phydev, YT8511_EXT_CLK_GATE);
+	if (oldpage < 0)
+		goto err_restore_page;
+
+	val = __phy_read(phydev, YT8511_PAGE);
+	val |= (YT8511_CLK_125M);
+	ret = __phy_write(phydev, YT8511_PAGE, val);
+
+	/* disable auto sleep */
+	ret = __phy_write(phydev, YT8511_PAGE_SELECT, YT8511_EXT_SLEEP_CTRL);
+	val = __phy_read(phydev, YT8511_PAGE);
+	val &= (~BIT(15));
+	ret = __phy_write(phydev, YT8511_PAGE, val);
+
+err_restore_page:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
+static struct phy_driver motorcomm_phy_drvs[] = {
+	{
+		PHY_ID_MATCH_EXACT(PHY_ID_YT8511),
+		.name		= "YT8511 Gigabit Ethernet",
+		.config_init	= &yt8511_config_init,
+		.get_features	= genphy_read_abilities,
+		.config_aneg	= genphy_config_aneg,
+		.read_status	= genphy_read_status,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.read_page	= yt8511_read_page,
+		.write_page	= yt8511_write_page,
+	},
+};
+
+module_phy_driver(motorcomm_phy_drvs);
+
+MODULE_DESCRIPTION("Motorcomm PHY driver");
+MODULE_AUTHOR("Peter Geis");
+MODULE_LICENSE("GPL");
+
+static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
+	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
+	{ /* sentinal */ }
+};
+
+MODULE_DEVICE_TABLE(mdio, motorcomm_tbl);
-- 
2.25.1

