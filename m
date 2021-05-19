Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6659938854D
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 05:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353020AbhESDdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 23:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237387AbhESDdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 23:33:42 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D816C06175F;
        Tue, 18 May 2021 20:32:23 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q2so8901473pfh.13;
        Tue, 18 May 2021 20:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EFieo9GKLjNzFcw2I/kSmnmISdqv5y65syZ4W5f+otM=;
        b=jg+03OuU5Or5NrYsPpEbbtfkBc4h4o97IxMpzXgtuk/46U4fAZOvyQKQ9+Ydo6Sy3a
         3c437ZsmvF8wGt9T2xt5v1RNLGmiwTHfrSui0s9VQq0qvndKE8UgZ/RvUn52v+5lCcVo
         MPBC5oIBO2ZpnXevKyNVoJy6Y1NInpw4gX8qqJ00Zd1MhR+uGPoSJuJgLYlL+q9nhA7/
         2VDVGrvhoV2I8VdhG+GgRcUoslg66k4a5yLinUL2o080/aWNq81fT0e3hZ5qocIjzZxs
         B1QrtJOGxKXW1Ocv3gFR9hucw7To0FlM6bnJsRukY19dgEhuEEY3Oplew8PYzaQ0+khk
         eZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EFieo9GKLjNzFcw2I/kSmnmISdqv5y65syZ4W5f+otM=;
        b=K4L+LQdaZRB6oMdoulbg98Jme/ExT3eCRP4mj+KeC8+kF70rEjWdLfpXB/cH/Ystsu
         15gQ/sd9WHcD3WQJVtdKl4i2woD2HrCYGfgj9OEfMXuYFRRRwiskO3m2labLxQiHmYCZ
         qPNEUJN10HprMW230bOclwsTSDWL2KVPS3I+5Hz5FGCAI+tDM8oADmTKcmAENFYFhj2F
         pHdoKt0J7o7lB9NJKbxCod+WoxuP7xCnBNBDbONZw5xcV4twc92mg8Cj4wF3JVEzHQ6H
         /IwI6ScV8BPxEOQ1hzscQqWM5WrZhWpJssx2sploYc2LnSlKkUzGSUvgA7yj4O9Vvsfa
         3+fw==
X-Gm-Message-State: AOAM533Tfaq6C1tEbEyYKdQw1a9SLpJC0amWk8SgoIO4cDjjglQUqCxz
        rLGIERTv4sXDGBenWq0tKEU=
X-Google-Smtp-Source: ABdhPJx3N8GDQwe87LA8AIAi8nQP8xA6CsSgbEO+LriXkox2kVZQkH/3KSMxNrcosNAMXZPJczSuaA==
X-Received: by 2002:a62:7f51:0:b029:2dc:e1c9:ef71 with SMTP id a78-20020a627f510000b02902dce1c9ef71mr8594501pfd.33.1621395142620;
        Tue, 18 May 2021 20:32:22 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g13sm8244587pfr.75.2021.05.18.20.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 20:32:22 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH net-next v2 1/4] net: phy: add MediaTek Gigabit Ethernet PHY driver
Date:   Wed, 19 May 2021 11:31:59 +0800
Message-Id: <20210519033202.3245667-2-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210519033202.3245667-1-dqfext@gmail.com>
References: <20210519033202.3245667-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MediaTek Gigabit Ethernet PHYs found in MT7530 and
MT7531 switches.
The initialization procedure is from the vendor driver, but due to lack
of documentation, the function of some register values remains unknown.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
v1 -> v2:
Renamed to mediatek-ge.c

 drivers/net/phy/Kconfig       |   5 ++
 drivers/net/phy/Makefile      |   1 +
 drivers/net/phy/mediatek-ge.c | 112 ++++++++++++++++++++++++++++++++++
 3 files changed, 118 insertions(+)
 create mode 100644 drivers/net/phy/mediatek-ge.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 25511f39b01f..1534e408505b 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -207,6 +207,11 @@ config MARVELL_88X2222_PHY
 	  Support for the Marvell 88X2222 Dual-port Multi-speed Ethernet
 	  Transceiver.
 
+config MEDIATEK_GE_PHY
+	tristate "MediaTek Gigabit Ethernet PHYs"
+	help
+	  Supports the MediaTek Gigabit Ethernet PHYs.
+
 config MICREL_PHY
 	tristate "Micrel PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index bcda7ed2455d..24328d7cf931 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_LXT_PHY)		+= lxt.o
 obj-$(CONFIG_MARVELL_10G_PHY)	+= marvell10g.o
 obj-$(CONFIG_MARVELL_PHY)	+= marvell.o
 obj-$(CONFIG_MARVELL_88X2222_PHY)	+= marvell-88x2222.o
+obj-$(CONFIG_MEDIATEK_GE_PHY)	+= mediatek-ge.o
 obj-$(CONFIG_MESON_GXL_PHY)	+= meson-gxl.o
 obj-$(CONFIG_MICREL_KS8995MA)	+= spi_ks8995.o
 obj-$(CONFIG_MICREL_PHY)	+= micrel.o
diff --git a/drivers/net/phy/mediatek-ge.c b/drivers/net/phy/mediatek-ge.c
new file mode 100644
index 000000000000..11ff335d6228
--- /dev/null
+++ b/drivers/net/phy/mediatek-ge.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include <linux/bitfield.h>
+#include <linux/module.h>
+#include <linux/phy.h>
+
+#define MTK_EXT_PAGE_ACCESS		0x1f
+#define MTK_PHY_PAGE_STANDARD		0x0000
+#define MTK_PHY_PAGE_EXTENDED		0x0001
+#define MTK_PHY_PAGE_EXTENDED_2		0x0002
+#define MTK_PHY_PAGE_EXTENDED_3		0x0003
+#define MTK_PHY_PAGE_EXTENDED_2A30	0x2a30
+#define MTK_PHY_PAGE_EXTENDED_52B5	0x52b5
+
+static int mtk_gephy_read_page(struct phy_device *phydev)
+{
+	return __phy_read(phydev, MTK_EXT_PAGE_ACCESS);
+}
+
+static int mtk_gephy_write_page(struct phy_device *phydev, int page)
+{
+	return __phy_write(phydev, MTK_EXT_PAGE_ACCESS, page);
+}
+
+static void mtk_gephy_config_init(struct phy_device *phydev)
+{
+	/* Disable EEE */
+	phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
+
+	/* Enable HW auto downshift */
+	phy_modify_paged(phydev, MTK_PHY_PAGE_EXTENDED, 0x14, 0, BIT(4));
+
+	/* Increase SlvDPSready time */
+	phy_select_page(phydev, MTK_PHY_PAGE_EXTENDED_52B5);
+	__phy_write(phydev, 0x10, 0xafae);
+	__phy_write(phydev, 0x12, 0x2f);
+	__phy_write(phydev, 0x10, 0x8fae);
+	phy_restore_page(phydev, MTK_PHY_PAGE_STANDARD, 0);
+
+	/* Adjust 100_mse_threshold */
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x123, 0xffff);
+
+	/* Disable mcc */
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0xa6, 0x300);
+}
+
+static int mt7530_phy_config_init(struct phy_device *phydev)
+{
+	mtk_gephy_config_init(phydev);
+
+	/* Increase post_update_timer */
+	phy_write_paged(phydev, MTK_PHY_PAGE_EXTENDED_3, 0x11, 0x4b);
+
+	return 0;
+}
+
+static int mt7531_phy_config_init(struct phy_device *phydev)
+{
+	if (phydev->interface != PHY_INTERFACE_MODE_INTERNAL)
+		return -EINVAL;
+
+	mtk_gephy_config_init(phydev);
+
+	/* PHY link down power saving enable */
+	phy_set_bits(phydev, 0x17, BIT(4));
+	phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, 0xc6, 0x300);
+
+	/* Set TX Pair delay selection */
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x13, 0x404);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x14, 0x404);
+
+	return 0;
+}
+
+static struct phy_driver mtk_gephy_driver[] = {
+	{
+		PHY_ID_MATCH_EXACT(0x03a29412),
+		.name		= "MediaTek MT7530 PHY",
+		.config_init	= mt7530_phy_config_init,
+		/* Interrupts are handled by the switch, not the PHY
+		 * itself.
+		 */
+		.config_intr	= genphy_no_config_intr,
+		.handle_interrupt = genphy_handle_interrupt_no_ack,
+		.read_page	= mtk_gephy_read_page,
+		.write_page	= mtk_gephy_write_page,
+	},
+	{
+		PHY_ID_MATCH_EXACT(0x03a29441),
+		.name		= "MediaTek MT7531 PHY",
+		.config_init	= mt7531_phy_config_init,
+		/* Interrupts are handled by the switch, not the PHY
+		 * itself.
+		 */
+		.config_intr	= genphy_no_config_intr,
+		.handle_interrupt = genphy_handle_interrupt_no_ack,
+		.read_page	= mtk_gephy_read_page,
+		.write_page	= mtk_gephy_write_page,
+	},
+};
+
+module_phy_driver(mtk_gephy_driver);
+
+static struct mdio_device_id __maybe_unused mtk_gephy_tbl[] = {
+	{ PHY_ID_MATCH_VENDOR(0x03a29400) },
+	{ }
+};
+
+MODULE_DESCRIPTION("MediaTek Gigabit Ethernet PHY driver");
+MODULE_AUTHOR("DENG, Qingfang <dqfext@gmail.com>");
+MODULE_LICENSE("GPL");
+
+MODULE_DEVICE_TABLE(mdio, mtk_gephy_tbl);
-- 
2.25.1

