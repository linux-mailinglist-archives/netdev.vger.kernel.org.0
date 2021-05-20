Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8709D38B449
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 18:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhETQeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 12:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbhETQeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 12:34:00 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3D0C061574;
        Thu, 20 May 2021 09:32:37 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id ee9so8910380qvb.8;
        Thu, 20 May 2021 09:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YRFowMpZrvdbqKPE9f+v5LypjlCrJrlAEfu9idu6oYU=;
        b=dZfU5rAP43oyGDRstd5cVxzYxKs3TSLNSaMNiaTNW/n5GBopmGxakhhJPCwH4GoFyi
         eksMeLkx7fd46BXMOzVR0P3h51j397/WHd1Az/dhytt9C4zG3MUXWFoY5MB8VUzeEg7i
         SxHFYrMJiRb86zcREAAE60Uy/5TP5g/x87FR26aifK9Si5lUo1qMG3iirTPoyIpyZ0kF
         opMJjYB9cI5+mcaSH4JSZHNT9LxxQnRUw/8CjFXLe7bkJ5nfr/l7fRh3YKTLxmfveeSn
         DqaWPvhxAnFFU/b1QvDo7PTfj99vMTVTrkjnovqERFgQAyFvs+dBOZgWwRyuNuHKgzaR
         m7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YRFowMpZrvdbqKPE9f+v5LypjlCrJrlAEfu9idu6oYU=;
        b=nbBX/IhqQH9PFkX+i4yMGMCBNVsbYQrQ9h2KhKnc5Rm65BsOE+fD9ovvLFpQXAUbS9
         zNhV1d6HWJnEEMwpdhYM/tunzUN/XTLT+gidIPUHOyUimgvxeKyhO1frYyX6BpByAzrc
         2Md03X3JKxuUEvWQwpnxt/CiAYYhzUgWFC+b5SeN2HJqts8Yep9BusjPxj+aeQN4orKM
         ypxgHf/nD7Tj8bbS7uXoUv+QGzQijc/FjwapwFpOp+kDdtEDq5XrDkChm5WrZsU/RfJh
         j/klLl5lngn4OFov1kmvaafc5J1TBSh37d+RRgOvmKHQ4PXOBcti6CX4EPtx5nCNVccc
         toMg==
X-Gm-Message-State: AOAM533pR54wj9MpW/401zlg4B66KPfy1+DD9uuyyRpNeDzIfKpJ3ZFr
        2rsVlPIu4PpAw60zCATqRTzFWHHgY7FJ5MVB
X-Google-Smtp-Source: ABdhPJxqe4Yxh48wy3cA8rJ2WbrFwRzxdmYoH7A0rrLm/5MDkyC7G2cZ6oactoLMNTbsFWGkyO5Frw==
X-Received: by 2002:a0c:f98a:: with SMTP id t10mr6376967qvn.54.1621528356584;
        Thu, 20 May 2021 09:32:36 -0700 (PDT)
Received: from master-laptop.sparksnet ([2601:153:980:85b1:5dfe:c926:d2fe:b4e9])
        by smtp.gmail.com with ESMTPSA id g1sm2168360qtr.32.2021.05.20.09.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 09:32:36 -0700 (PDT)
From:   Peter Geis <pgwipeout@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Peter Geis <pgwipeout@gmail.com>
Subject: [PATCH v4] net: phy: add driver for Motorcomm yt8511 phy
Date:   Thu, 20 May 2021 12:32:30 -0400
Message-Id: <20210520163230.3788942-1-pgwipeout@gmail.com>
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
Changes v4:
- Set fast ethernet delays as well
- Use __phy_modify for delay setting
- Enable PLL in sleep instead of disabling sleep
- Don't set genphy functions that are defaults
- Tested downshift and duplex detection

Changes v3:
- Add rgmii mode selection support

Changes v2:
- Change to __phy_modify
- Handle return errors
- Remove unnecessary &

 MAINTAINERS                 |   6 ++
 drivers/net/phy/Kconfig     |   6 ++
 drivers/net/phy/Makefile    |   1 +
 drivers/net/phy/motorcomm.c | 136 ++++++++++++++++++++++++++++++++++++
 4 files changed, 149 insertions(+)
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
index 000000000000..796b68f4b499
--- /dev/null
+++ b/drivers/net/phy/motorcomm.c
@@ -0,0 +1,136 @@
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
+#define YT8511_EXT_DELAY_DRIVE	0x0d
+#define YT8511_EXT_SLEEP_CTRL	0x27
+
+/* 2b00 25m from pll
+ * 2b01 25m from xtl *default*
+ * 2b10 62.m from pll
+ * 2b11 125m from pll
+ */
+#define YT8511_CLK_125M		(BIT(2) | BIT(1))
+#define YT8511_PLLON_SLP	BIT(14)
+
+/* RX Delay enabled = 1.8ns 1000T, 8ns 10/100T */
+#define YT8511_DELAY_RX		BIT(0)
+
+/* TX Gig-E Delay is bits 7:4, default 0x5
+ * TX Fast-E Delay is bits 15:12, default 0xf
+ * Delay = 150ps * N - 250ps
+ * On = 2000ps, off = 50ps
+ */
+#define YT8511_DELAY_GE_TX_EN	(0xf << 4)
+#define YT8511_DELAY_GE_TX_DIS	(0x2 << 4)
+#define YT8511_DELAY_FE_TX_EN	(0xf << 12)
+#define YT8511_DELAY_FE_TX_DIS	(0x2 << 12)
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
+	unsigned int ge, fe;
+	int ret, oldpage;
+
+	/* set clock mode to 125mhz */
+	oldpage = phy_select_page(phydev, YT8511_EXT_CLK_GATE);
+	if (oldpage < 0)
+		goto err_restore_page;
+
+	ret = __phy_modify(phydev, YT8511_PAGE, 0, YT8511_CLK_125M);
+	if (ret < 0)
+		goto err_restore_page;
+
+	/* set rgmii delay mode */
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		ge = YT8511_DELAY_GE_TX_DIS;
+		fe = YT8511_DELAY_FE_TX_DIS;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		ge = YT8511_DELAY_RX | YT8511_DELAY_GE_TX_DIS;
+		fe = YT8511_DELAY_FE_TX_DIS;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		ge = YT8511_DELAY_GE_TX_EN;
+		fe = YT8511_DELAY_FE_TX_EN;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		ge = YT8511_DELAY_RX | YT8511_DELAY_GE_TX_EN;
+		fe = YT8511_DELAY_FE_TX_EN;
+		break;
+	default: /* leave everything alone in other modes */
+		break;
+	}
+
+	ret = __phy_modify(phydev, YT8511_PAGE, (YT8511_DELAY_RX | YT8511_DELAY_GE_TX_EN), ge);
+	if (ret < 0)
+		goto err_restore_page;
+
+	/* fast ethernet delay is in a separate page */
+	ret = __phy_write(phydev, YT8511_PAGE_SELECT, YT8511_EXT_DELAY_DRIVE);
+	if (ret < 0)
+		goto err_restore_page;
+
+	ret = __phy_modify(phydev, YT8511_PAGE, YT8511_DELAY_FE_TX_EN, fe);
+	if (ret < 0)
+		goto err_restore_page;
+
+	/* leave pll enabled in sleep */
+	ret = __phy_write(phydev, YT8511_PAGE_SELECT, YT8511_EXT_SLEEP_CTRL);
+	if (ret < 0)
+		goto err_restore_page;
+
+	ret = __phy_modify(phydev, YT8511_PAGE, 0, YT8511_PLLON_SLP);
+	if (ret < 0)
+		goto err_restore_page;
+
+err_restore_page:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
+static struct phy_driver motorcomm_phy_drvs[] = {
+	{
+		PHY_ID_MATCH_EXACT(PHY_ID_YT8511),
+		.name		= "YT8511 Gigabit Ethernet",
+		.config_init	= yt8511_config_init,
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

