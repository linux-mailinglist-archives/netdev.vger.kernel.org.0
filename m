Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDB5358372
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 14:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhDHMjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 08:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhDHMjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 08:39:49 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5F3C061760;
        Thu,  8 Apr 2021 05:39:38 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id l123so1707395pfl.8;
        Thu, 08 Apr 2021 05:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n4wqHMiN29lzV6muE8pN4a6Ibkd52ctj3SwR+DOuyIE=;
        b=myl1K0+w0+1r1+Vd8CU+eSLoUnmGJ13NizjkOwGT5McXLJp4i4biKLfToFr1efN0pS
         DsiErq84Yb/KLIdNKmt7+Y9knMUH2E0btjQX7AJoptL9G+jWMVwhuNZDq8ihmQjB5tY0
         XddaR892sh8gUMholPbYwPsNsTwoZkkLczfxQD8TpRVqlDdzQRMlD2ilZefABrPMBB5+
         0YmHEbk2+fkfw+5hMC3Or57kBaOAvfrWTwfG2oPumWb8nmOl3tbLlgzZbsn5goipBY59
         5Q04wY5HMlEUMw979yQIYEkPXH5mLJ5oUErCbP7lF0xeg364VJSxK7tthZQzfIF0ciLd
         QucA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n4wqHMiN29lzV6muE8pN4a6Ibkd52ctj3SwR+DOuyIE=;
        b=uAMIOeBWTPxKskgnSAeRyvKPLr4LHSa7e+4+LV0kwA1d6YN+U+W9SAjDSb/48yNxTm
         lSjgJXk412xLUCnCYyyft1ZUcNh2Anrma4r84U6IB8S7nONJU+ajM6Xc3IsOjQiYKKz2
         +lD/VoQAPbZ2343kd8AV0bzcGAv5+H5KFOVY5Q/GYvj0IhOi+0qfcZ6P/Xl5ajHA4xGI
         T1uWC92Re+FrSs0eGBFVbpPQ73YdOCVhSxG0hIA3vpeth7KC96kg6L+88tGsTS4GuUHn
         Gq7/g6xEKnCw5LoCzkC45OBThFtNOwRoMRHjUT0+tAt8rUe26wKNDdckcLJDTwd9FRwf
         eAXw==
X-Gm-Message-State: AOAM5310rYmS0paqg3MwgqX+lJxEG5Y3m4kEdBdIsDbwgRtzT+y/sLOM
        Bd2gm1/pBToGauOk+wBm/CI=
X-Google-Smtp-Source: ABdhPJwUcMhWWlJb1haZYAryuyyVs8e7/OQeBjb8LJ0KSxr3RO/9MqLXQ1l+Sr+8Ts2f6bVHkyDJdw==
X-Received: by 2002:aa7:9804:0:b029:1f1:5340:77c1 with SMTP id e4-20020aa798040000b02901f1534077c1mr7384855pfl.72.1617885577843;
        Thu, 08 Apr 2021 05:39:37 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id e65sm25831311pfe.9.2021.04.08.05.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 05:39:37 -0700 (PDT)
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
Subject: [RFC v3 net-next 1/4] net: phy: add MediaTek PHY driver
Date:   Thu,  8 Apr 2021 20:39:16 +0800
Message-Id: <20210408123919.2528516-2-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210408123919.2528516-1-dqfext@gmail.com>
References: <20210408123919.2528516-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MediaTek PHYs found in MT7530 and MT7531 switches.
The initialization procedure is from the vendor driver, but due to lack
of documentation, the function of some register values remains unknown.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
RFC v2 -> RFC v3:
- No changes.

 drivers/net/phy/Kconfig    |   5 ++
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/mediatek.c | 112 +++++++++++++++++++++++++++++++++++++
 3 files changed, 118 insertions(+)
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
index 000000000000..1faed57e2ed9
--- /dev/null
+++ b/drivers/net/phy/mediatek.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include <linux/module.h>
+#include <linux/phy.h>
+#include <linux/version.h>
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

