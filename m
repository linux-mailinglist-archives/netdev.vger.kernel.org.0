Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C613037B206
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 00:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhEKXA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEKXA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 19:00:26 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45D9C061574;
        Tue, 11 May 2021 15:59:18 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id q136so20493039qka.7;
        Tue, 11 May 2021 15:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zIhPXLlFIfi7x+16X/rcVq/+DBuEAWSYMuS7Kv6syAE=;
        b=OnhYPgRZBl8D6pX3UPsh3ZvHXH6gC/p3RU7Yr7dkzYXvnyx6i+6SJaP1dgZj2v7oIa
         scw4DNrujyZBLBAxXdx+OTjpTI0hHx9silDcxVTW/dK20zTlKRKifj5xcEEhpbpaH07L
         WLkzIsy2r+RD7rexCRYj6YK+HlJgIvAyPWNUq9/WDOyJAIjeKOIH+ycQjIypFMexD0eC
         +YnDkePEEV/JBU5wa5yD5NQe/Rm/rWFIyHL6TyFrvha4lS32XV/oIoLKgZQI9vIOt2fS
         wJcb3DWUut4pqVzf8EIA98Ai59DsGMa2OgyrnOV2S5FnMQ1SyWGmgbnt5srutBbH3Arh
         x0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zIhPXLlFIfi7x+16X/rcVq/+DBuEAWSYMuS7Kv6syAE=;
        b=BfETNwQQH9a1HbYWIJ9GFWVyZPccJ1qCWDhqH9G3YAZfV9r2qdF+Uu0md2rFq48WOb
         z2XM5xFbOYDdNq6qKizDUk5gkWuXbEmDGIVwl+If6pxnDCULU1Z6tqOsdf0gwO53gyQI
         +7icyc47VBleqorA7lkZmvQMXSknsGsjVt9NI9bstGEVE3ga4SE8+7l6Ca+n8W9om6we
         4gWPT84HnwbsrVDr/0SNYey590XPQjhychuM9eY/vo2nI42+wR+u/5MQxYdFcscPpI1y
         PadWuopf/ZKgMIe7qV+11b2EaYzVKgd0FxV6asL6tqHVf9Cpk0Au87mKqhUiW/BPyz+f
         PNnA==
X-Gm-Message-State: AOAM533aJ3LiSaYRZnWMjIxCsf+lr+vzClxUmN5ezyMBsmaLQrj1gmLf
        laOcPG1Y7282ex4ydWZ/ZkY=
X-Google-Smtp-Source: ABdhPJxDPfMiMA+7RUHRgdPIRvMxKuUHTo07lpk4YegTL+cGeFCG06MDib3Q5G/BnOYU6hL+xrvuSA==
X-Received: by 2002:a05:620a:40ce:: with SMTP id g14mr9495703qko.149.1620773957869;
        Tue, 11 May 2021 15:59:17 -0700 (PDT)
Received: from master-laptop.sparksnet ([2601:153:980:85b1:f9ba:6614:640b:eee1])
        by smtp.gmail.com with ESMTPSA id m10sm13459172qtq.83.2021.05.11.15.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 15:59:17 -0700 (PDT)
From:   Peter Geis <pgwipeout@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Peter Geis <pgwipeout@gmail.com>
Subject: [PATCH v2] net: phy: add driver for Motorcomm yt8511 phy
Date:   Tue, 11 May 2021 18:59:13 -0400
Message-Id: <20210511225913.2951922-1-pgwipeout@gmail.com>
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
Changes v2:
- Change to __phy_modify
- Handle return errors
- Remove unnecessary &

 MAINTAINERS                 |  6 +++
 drivers/net/phy/Kconfig     |  6 +++
 drivers/net/phy/Makefile    |  1 +
 drivers/net/phy/motorcomm.c | 87 +++++++++++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+)
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
index 000000000000..580926f25dfc
--- /dev/null
+++ b/drivers/net/phy/motorcomm.c
@@ -0,0 +1,87 @@
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

