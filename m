Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D954635B903
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 05:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbhDLDnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 23:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbhDLDnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 23:43:12 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CE0C061574;
        Sun, 11 Apr 2021 20:42:55 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h25so8334766pgm.3;
        Sun, 11 Apr 2021 20:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yZ5W7oXdZ8SNpPNFFttOnaomBLVx/4n5LPa5t4ANWJ0=;
        b=Q7B9AjeF9NMppAnZgPBNLnRMqmdegsCdvq2YpRpbdrse+fuZaDv5zijjMghvi4MwlL
         fe1IVZN1jikUJWBsSUm5yl7bGGePathlCm5raqrH3Az1+n/A4YFEvCG0JqRdl9aX31r5
         ByWNu2Sg/Y1sZD3EIod8MP2xOwdocVzTODczQncAueE6bhp6RZvpji2g+GTN6EYivneg
         roU/1XdizOS0Bw9+biWE0pI0pbFedGIUaET2ZemZ4yBY/aCNdDestY0EXNWpEWPZRlE4
         GJdDTJ785fYMAI611M22NEVDDptx2qGuYyQj/2/EEfnmcnsOycijsn4jQi3l+3HWqIq9
         WmKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yZ5W7oXdZ8SNpPNFFttOnaomBLVx/4n5LPa5t4ANWJ0=;
        b=BvSosH+woSCLbm0uniHTn0FgPsGAPrMDijyrh6OXh7aucFxebUhk13vqIXgCN9TcHa
         j7h5CwquqwOBmuNYmrzY0Wcz+dPMOaq4rBr9fgLq5sfqjie4GYUbskA1QPGH0T6NvOJ2
         SYoO1k0kNhddvX91I9IkDBYU4KVuYlluunhHkm+0/8oGiwvrbs+9Grc85+TH3V3v2xOs
         dDZN78ab5n6ZxS1JCV+hTd6ax4w9atERSIuR9yQj4R4i9CRz5hp3XEc6GaPCgGCFa+cw
         LfFwz/ME39VAzz9++qkXRVOqQZ/5/O4U1EpdLcq4Oa7qfJOM0mSb6s8LTYwvGVoO9uSw
         460A==
X-Gm-Message-State: AOAM532T11eP+eqHTQ7/+YGi7ZY6dTAqQrQ7d2owQAc8wT1WAk7DS/v8
        hNRfHSxVX7JLV5fey2NbVW0=
X-Google-Smtp-Source: ABdhPJwsvYhO4IziErJNUYCF3KDQeyuFzX4kE9/W+LyP7lyWchgraQcVo8Bm+Ia4zNVEPLv3dLDbmA==
X-Received: by 2002:aa7:8817:0:b029:24e:bb8:46e1 with SMTP id c23-20020aa788170000b029024e0bb846e1mr1293952pfo.0.1618198975316;
        Sun, 11 Apr 2021 20:42:55 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id v22sm5387185pff.105.2021.04.11.20.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 20:42:54 -0700 (PDT)
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
Subject: [RFC v4 net-next 1/4] net: phy: add MediaTek PHY driver
Date:   Mon, 12 Apr 2021 11:42:34 +0800
Message-Id: <20210412034237.2473017-2-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412034237.2473017-1-dqfext@gmail.com>
References: <20210412034237.2473017-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MediaTek PHYs found in MT7530 and MT7531 switches.
The initialization procedure is from the vendor driver, but due to lack
of documentation, the function of some register values remains unknown.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
RFC v3 -> RFC v4:
- Remove unused include.

 drivers/net/phy/Kconfig    |   5 ++
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/mediatek.c | 111 +++++++++++++++++++++++++++++++++++++
 3 files changed, 117 insertions(+)
 create mode 100644 drivers/net/phy/mediatek.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index a615b3660b05..edd858cec9ec 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -207,6 +207,11 @@ config MARVELL_88X2222_PHY
 	  Support for the Marvell 88X2222 Dual-port Multi-speed Ethernet
 	  Transceiver.
 
+config MEDIATEK_PHY
+	tristate "MediaTek PHYs"
+	help
+	  Supports the MediaTek switch integrated PHYs.
+
 config MICREL_PHY
 	tristate "Micrel PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index de683e3abe63..9ed7dbab7770 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_LXT_PHY)		+= lxt.o
 obj-$(CONFIG_MARVELL_10G_PHY)	+= marvell10g.o
 obj-$(CONFIG_MARVELL_PHY)	+= marvell.o
 obj-$(CONFIG_MARVELL_88X2222_PHY)	+= marvell-88x2222.o
+obj-$(CONFIG_MEDIATEK_PHY)	+= mediatek.o
 obj-$(CONFIG_MESON_GXL_PHY)	+= meson-gxl.o
 obj-$(CONFIG_MICREL_KS8995MA)	+= spi_ks8995.o
 obj-$(CONFIG_MICREL_PHY)	+= micrel.o
diff --git a/drivers/net/phy/mediatek.c b/drivers/net/phy/mediatek.c
new file mode 100644
index 000000000000..1627b7c04345
--- /dev/null
+++ b/drivers/net/phy/mediatek.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0+
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
+static int mtk_phy_read_page(struct phy_device *phydev)
+{
+	return __phy_read(phydev, MTK_EXT_PAGE_ACCESS);
+}
+
+static int mtk_phy_write_page(struct phy_device *phydev, int page)
+{
+	return __phy_write(phydev, MTK_EXT_PAGE_ACCESS, page);
+}
+
+static void mtk_phy_config_init(struct phy_device *phydev)
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
+	mtk_phy_config_init(phydev);
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
+	mtk_phy_config_init(phydev);
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
+static struct phy_driver mtk_phy_driver[] = {
+	{
+		PHY_ID_MATCH_EXACT(0x03a29412),
+		.name		= "MediaTek MT7530 PHY",
+		.config_init	= mt7530_phy_config_init,
+		/* Interrupts are handled by the switch, not the PHY
+		 * itself.
+		 */
+		.config_intr	= genphy_no_config_intr,
+		.handle_interrupt = genphy_handle_interrupt_no_ack,
+		.read_page	= mtk_phy_read_page,
+		.write_page	= mtk_phy_write_page,
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
+		.read_page	= mtk_phy_read_page,
+		.write_page	= mtk_phy_write_page,
+	},
+};
+
+module_phy_driver(mtk_phy_driver);
+
+static struct mdio_device_id __maybe_unused mtk_phy_tbl[] = {
+	{ PHY_ID_MATCH_VENDOR(0x03a29400) },
+	{ }
+};
+
+MODULE_DESCRIPTION("MediaTek switch integrated PHY driver");
+MODULE_AUTHOR("DENG, Qingfang <dqfext@gmail.com>");
+MODULE_LICENSE("GPL");
+
+MODULE_DEVICE_TABLE(mdio, mtk_phy_tbl);
-- 
2.25.1

