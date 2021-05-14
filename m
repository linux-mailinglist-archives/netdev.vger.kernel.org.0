Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF069380910
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 13:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhENL7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 07:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbhENL7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 07:59:46 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A09C061574;
        Fri, 14 May 2021 04:58:34 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id c20so17404309qkm.3;
        Fri, 14 May 2021 04:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A3gL2doE8fl4iTpq6l37jEk7PgXSqloCEeFI/slSopk=;
        b=Ib1w3P9Gd5qIw4fgynuBCUWCbb3VUzNhyV69TVs4Veu/LWsZ7a/Yanj7zCN2/lYypm
         3hadF9/v9zJeCu2X09ltSfJcIu4AIZSj7e5Iqra99jtRJ3+qdD71vaXncaJAmVtaRNRa
         xp1EtSU4Y9fIKuXS9yOfaf129j4a5SxcHQldkA0ONM1471nPwNmMTSMr+TbJ9+3H4lHv
         3hMxy6hiW5LnWfNVW+k2BUtQ4gJczDn/oD1LEZZqmToTn/SBHWFtVNqS3OMWFPXrC5lG
         m9HmEDV0SLQItDj+tlI0B/aKWMcHCJ3WCVwy+qyEBwmQfoDvLxL2O6Rik3M1XYMx2csK
         cGIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A3gL2doE8fl4iTpq6l37jEk7PgXSqloCEeFI/slSopk=;
        b=OdnAssosUZ6rhl+1Us/NdFRVnYe/0ViZsokPjUagtVfhX/cIz74lmRO4bEbnKt06x2
         XPbVmrheprHuGQBtbSZPMQke0RVnXo/WHZf1eLPmLt5WWUyuFOpi7FPIZ6WWYt4Nfjqf
         Qk6iAnbZuI1Gvih1hCeyd9uT3UJrWgtkT7zvO+VDHH65rOGKr+pvjIeaOoPKQZ8doiWL
         EFkv6s8BAAVt9sVs5rdOmrcVwIOaqFsWuzW+ywWEkeP9kxXh+WESgHSXdfWJGqGtdtOP
         HNN+i8vAr3EUu3G3geTNjivcB1lFjpbXtju//bbSleF2xgpLgZMLk8BydX2mIeqP9WFY
         2dzw==
X-Gm-Message-State: AOAM532J7euanMMy/GZ6WL/eS0w6jEdpVbsTL/QuAZnwAcAL5xvpDkFF
        6nOnEdNudbv7NuKv6Xw1bTM=
X-Google-Smtp-Source: ABdhPJyk/bLwL/zXmBd2f/rPaGG33YZpJWcJUbN+gcbEaqv6R07QwQKfjM0UXMQ2geEpuUzGxMcUYQ==
X-Received: by 2002:a37:58c5:: with SMTP id m188mr42633972qkb.327.1620993513532;
        Fri, 14 May 2021 04:58:33 -0700 (PDT)
Received: from master-laptop.sparksnet ([2601:153:980:85b1:7d30:cc80:9389:fb35])
        by smtp.gmail.com with ESMTPSA id m16sm4499780qkm.100.2021.05.14.04.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 04:58:33 -0700 (PDT)
From:   Peter Geis <pgwipeout@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Peter Geis <pgwipeout@gmail.com>
Subject: [PATCH v3] net: phy: add driver for Motorcomm yt8511 phy
Date:   Fri, 14 May 2021 07:58:26 -0400
Message-Id: <20210514115826.3025223-1-pgwipeout@gmail.com>
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
Changes v3:
- Add rgmii mode selection support

Changes v2:
- Change to __phy_modify
- Handle return errors
- Remove unnecessary &

 MAINTAINERS                 |   6 ++
 drivers/net/phy/Kconfig     |   6 ++
 drivers/net/phy/Makefile    |   1 +
 drivers/net/phy/motorcomm.c | 121 ++++++++++++++++++++++++++++++++++++
 4 files changed, 134 insertions(+)
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
index 000000000000..b85f10efa28e
--- /dev/null
+++ b/drivers/net/phy/motorcomm.c
@@ -0,0 +1,121 @@
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
+/* RX Delay enabled = 1.8ns 1000T, 8ns 10/100T */
+#define YT8511_DELAY_RX		BIT(0)
+
+/* TX Delay is bits 7:4, default 0x5
+ * Delay = 150ps * N - 250ps, Default = 500ps
+ */
+#define YT8511_DELAY_TX		(0x5 << 4)
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
+	int ret, oldpage, val;
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
+	val = __phy_read(phydev, YT8511_PAGE);
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		val &= ~(YT8511_DELAY_RX | YT8511_DELAY_TX);
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		val |= YT8511_DELAY_RX | YT8511_DELAY_TX;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		val &= ~(YT8511_DELAY_TX);
+		val |= YT8511_DELAY_RX;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		val &= ~(YT8511_DELAY_RX);
+		val |= YT8511_DELAY_TX;
+		break;
+	default: /* leave everything alone in other modes */
+		break;
+	}
+
+	ret = __phy_write(phydev, YT8511_PAGE, val);
+	if (ret < 0)
+		goto err_restore_page;
+
+	/* disable auto sleep */
+	ret = __phy_write(phydev, YT8511_PAGE_SELECT, YT8511_EXT_SLEEP_CTRL);
+	if (ret < 0)
+		goto err_restore_page;
+	ret = __phy_modify(phydev, YT8511_PAGE, BIT(15), 0);
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

