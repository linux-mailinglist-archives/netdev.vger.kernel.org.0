Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7B5370FAE
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhEBXK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbhEBXI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:29 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF61C061756;
        Sun,  2 May 2021 16:07:35 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id f24so5193351ejc.6;
        Sun, 02 May 2021 16:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8BSDZrcoNzp9syAi7bEm0jAyw49NztLzfWnEeA37gIc=;
        b=ZDYVD871lhik5K5mVNlJ99tXYD5swZCiTQt7fWVrl1VA0OiS3x31eEOPDElraz5kTn
         rCGWJGcUqJ5VS5bhx205wn3ZpFvujHyc2AUR/c+kWWS4YcXs5rJ/BrEYrk8V9DyXdsy1
         9/URq5N2nvLCkj92PL9H4ZYdCLmdFDsXVYMwR8WESX1xYBNLed7QHNAXrKSt3MLfO3Yg
         I8kdwh0OQQqwHbsXqq9CzWlur6FU/fQMD4PcnBy67PkWsr2Btw+zolYjZl4dkWDgEGxy
         Gfuipwf1O0TA1brqtCA7vwo+vUIzY4fBVTytW+B/hwTl9UTBT54I5NlojhixfHwysPrB
         o4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8BSDZrcoNzp9syAi7bEm0jAyw49NztLzfWnEeA37gIc=;
        b=fbxPgit75rk6Rpbo72VxeWB7NNoaCtRIDiDIWAD3u29DpF2qWS/YZwyOsOXMXYbCTm
         wqFJQglK/Mz0lHuaL3e9cmmVTd/LrqB6zPkx8hy1hwGvLpYRfjz8GyNYUuCGAR3S+yRC
         TgldirM/haOp9ao/O6XYZ4HlZKY8AunGMTkAzgQsnwP3pqK9zLV4ibW6DtBub46i27JF
         jjae6O3ipnPesSe2Bfr2Mg+V5VZV55TW8Mcdm1px0EoxV1Sca0JKjWcuLbZDeDhTQK0m
         Bx72AY2s7UZQWRB4QpJ++i5ngLIogjrTFly3gXoBOMAtaLszTDbY3xs+3+DueZLc9sC7
         YsjA==
X-Gm-Message-State: AOAM530hBYIOya3ZBsWsxym2ePeZ6L+tP2KDnllUwKx39ATF3KXHuUL6
        3n3ozwYSWPcknjvwn9IhziI=
X-Google-Smtp-Source: ABdhPJzi2VmcYnM6N+fKMgtDA2WTfH7iLLgMyoqSsXw+7wVpjnYuiTPoD4yV1wmed0+wjdvuNruycg==
X-Received: by 2002:a17:907:2623:: with SMTP id aq3mr13691136ejc.262.1619996853770;
        Sun, 02 May 2021 16:07:33 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:33 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC PATCH net-next v2 17/17] net: phy: add qca8k driver for qca8k switch internal PHY
Date:   Mon,  3 May 2021 01:07:09 +0200
Message-Id: <20210502230710.30676-17-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add initial support for qca8k internal PHYs. The internal PHYs requires
special mmd and debug values to be set based on the switch revision
passwd using the dev_flags. Supports output of idle, receive and eee_wake
errors stats.
Some debug values sets can't be translated as the documentation lacks any
reference about them.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/Kconfig  |   7 ++
 drivers/net/phy/Makefile |   1 +
 drivers/net/phy/qca8k.c  | 174 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 182 insertions(+)
 create mode 100644 drivers/net/phy/qca8k.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 698bea312adc..cdf01613eb37 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -245,6 +245,13 @@ config QSEMI_PHY
 	help
 	  Currently supports the qs6612
 
+config QCA8K_PHY
+	tristate "Qualcomm Atheros AR833x Internal PHYs"
+	help
+	  This PHY is for the internal PHYs present on the QCA833x switch.
+
+	  Currently supports the AR8334, AR8337 model
+
 config REALTEK_PHY
 	tristate "Realtek PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index a13e402074cf..5f3cfd5606bb 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -72,6 +72,7 @@ obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
 obj-$(CONFIG_NATIONAL_PHY)	+= national.o
 obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
 obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
+obj-$(CONFIG_QCA8K_PHY)		+= qca8k.o
 obj-$(CONFIG_REALTEK_PHY)	+= realtek.o
 obj-$(CONFIG_RENESAS_PHY)	+= uPD60620.o
 obj-$(CONFIG_ROCKCHIP_PHY)	+= rockchip.o
diff --git a/drivers/net/phy/qca8k.c b/drivers/net/phy/qca8k.c
new file mode 100644
index 000000000000..514250bb9e71
--- /dev/null
+++ b/drivers/net/phy/qca8k.c
@@ -0,0 +1,174 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include <linux/kernel.h>
+#include <linux/mii.h>
+#include <linux/phy.h>
+#include <linux/module.h>
+#include <linux/bitfield.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool_netlink.h>
+
+#define QCA8K_DEVFLAGS_REVISION_MASK		GENMASK(2, 0)
+
+#define QCA8K_PHY_ID_MASK			0xffffffff
+#define QCA8K_PHY_ID_QCA8327			0x004dd034
+#define QCA8K_PHY_ID_QCA8337			0x004dd036
+
+#define MDIO_AZ_DEBUG				0x800d
+
+#define MDIO_DBG_ANALOG_TEST			0x0
+#define MDIO_DBG_SYSTEM_CONTROL_MODE		0x5
+#define MDIO_DBG_CONTROL_FEATURE_CONF		0x3d
+
+/* QCA specific MII registers */
+#define MII_ATH_DBG_ADDR			0x1d
+#define MII_ATH_DBG_DATA			0x1e
+
+/* QCA specific MII registers access function */
+static void qca8k_phy_dbg_write(struct mii_bus *bus, int phy_addr, u16 dbg_addr, u16 dbg_data)
+{
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	bus->write(bus, phy_addr, MII_ATH_DBG_ADDR, dbg_addr);
+	bus->write(bus, phy_addr, MII_ATH_DBG_DATA, dbg_data);
+	mutex_unlock(&bus->mdio_lock);
+}
+
+enum stat_access_type {
+	PHY,
+	MMD
+};
+
+struct qca8k_hw_stat {
+	const char *string;
+	u8 reg;
+	u32 mask;
+	enum stat_access_type access_type;
+};
+
+static struct qca8k_hw_stat qca8k_hw_stats[] = {
+	{ "phy_idle_errors", 0xa, GENMASK(7, 0), PHY},
+	{ "phy_receive_errors", 0x15, GENMASK(15, 0), PHY},
+	{ "eee_wake_errors", 0x16, GENMASK(15, 0), MMD},
+};
+
+struct qca8k_phy_priv {
+	u8 switch_revision;
+	u64 stats[ARRAY_SIZE(qca8k_hw_stats)];
+};
+
+static int qca8k_get_sset_count(struct phy_device *phydev)
+{
+	return ARRAY_SIZE(qca8k_hw_stats);
+}
+
+static void qca8k_get_strings(struct phy_device *phydev, u8 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(qca8k_hw_stats); i++) {
+		strscpy(data + i * ETH_GSTRING_LEN,
+			qca8k_hw_stats[i].string, ETH_GSTRING_LEN);
+	}
+}
+
+static u64 qca8k_get_stat(struct phy_device *phydev, int i)
+{
+	struct qca8k_hw_stat stat = qca8k_hw_stats[i];
+	struct qca8k_phy_priv *priv = phydev->priv;
+	int val;
+	u64 ret;
+
+	if (stat.access_type == MMD)
+		val = phy_read_mmd(phydev, MDIO_MMD_PCS, stat.reg);
+	else
+		val = phy_read(phydev, stat.reg);
+
+	if (val < 0) {
+		ret = U64_MAX;
+	} else {
+		val = val & stat.mask;
+		priv->stats[i] += val;
+		ret = priv->stats[i];
+	}
+
+	return ret;
+}
+
+static void qca8k_get_stats(struct phy_device *phydev,
+			    struct ethtool_stats *stats, u64 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(qca8k_hw_stats); i++)
+		data[i] = qca8k_get_stat(phydev, i);
+}
+
+static int qca8k_config_init(struct phy_device *phydev)
+{
+	struct qca8k_phy_priv *priv = phydev->priv;
+	struct mii_bus *bus = phydev->mdio.bus;
+	int phy_addr = phydev->mdio.addr;
+
+	priv->switch_revision = phydev->dev_flags & QCA8K_DEVFLAGS_REVISION_MASK;
+
+	switch (priv->switch_revision) {
+	case 1:
+		/* For 100M waveform */
+		qca8k_phy_dbg_write(bus, phy_addr, MDIO_DBG_ANALOG_TEST, 0x02ea);
+		/* Turn on Gigabit clock */
+		qca8k_phy_dbg_write(bus, phy_addr, MDIO_DBG_CONTROL_FEATURE_CONF, 0x68a0);
+		break;
+
+	case 2:
+		phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0x0);
+		fallthrough;
+	case 4:
+		phy_write_mmd(phydev, MDIO_MMD_PCS, MDIO_AZ_DEBUG, 0x803f);
+		qca8k_phy_dbg_write(bus, phy_addr, MDIO_DBG_CONTROL_FEATURE_CONF, 0x6860);
+		qca8k_phy_dbg_write(bus, phy_addr, MDIO_DBG_SYSTEM_CONTROL_MODE, 0x2c46);
+		qca8k_phy_dbg_write(bus, phy_addr, 0x3c, 0x6000);
+		break;
+	}
+
+	return 0;
+}
+
+static int qca8k_probe(struct phy_device *phydev)
+{
+	struct qca8k_phy_priv *priv;
+
+	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+
+	return 0;
+}
+
+static struct phy_driver qca8k_drivers[] = {
+	{
+		.phy_id = QCA8K_PHY_ID_QCA8337,
+		.phy_id_mask = QCA8K_PHY_ID_MASK,
+		.name = "QCA PHY 8337",
+		/* PHY_GBIT_FEATURES */
+		.probe = qca8k_probe,
+		.flags = PHY_IS_INTERNAL,
+		.config_init = qca8k_config_init,
+		.soft_reset = genphy_soft_reset,
+		.get_sset_count = qca8k_get_sset_count,
+		.get_strings = qca8k_get_strings,
+		.get_stats = qca8k_get_stats,
+	},
+};
+
+module_phy_driver(qca8k_drivers);
+
+static struct mdio_device_id __maybe_unused qca8k_tbl[] = {
+	{ QCA8K_PHY_ID_QCA8337, QCA8K_PHY_ID_MASK },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, qca8k_tbl);
+MODULE_DESCRIPTION("Qualcomm QCA8k PHY driver");
+MODULE_AUTHOR("Ansuel Smith");
+MODULE_LICENSE("GPL");
-- 
2.30.2

