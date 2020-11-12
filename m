Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4047D2B045D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgKLLv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:51:59 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36632 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727916AbgKLLvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:51:25 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201112115109euoutp0140fcfe94273fca635e54a20cd6a95080~GwGf2fERz0059200592euoutp01j
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:51:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201112115109euoutp0140fcfe94273fca635e54a20cd6a95080~GwGf2fERz0059200592euoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605181869;
        bh=oZuo6s/f5U2JgDO2jdRFnDM1X//sssammXkHxt/nwu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AAtK4dFZ2ysT7tAVmhTGM4wIsx1UGaD4ahf7uokplLcfchCYRJ4wnh5qfua6627Ud
         g4+pdn+5hBwdqPQttO+NqzsSXh7hfsA6DzvzlRydEsRbYI8Tqaa+lvNj0Q1cjnGZyo
         NsLacAR9bBGhYn0I0PVk15t6xOvFFvnTuYMlma3Q=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201112115109eucas1p1b4bfe02324885571ecc369aa54aa8294~GwGfgfFQQ3271432714eucas1p1W;
        Thu, 12 Nov 2020 11:51:09 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 56.EF.45488.DA12DAF5; Thu, 12
        Nov 2020 11:51:09 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201112115108eucas1p22790c6cdec17e5322424e026b3985305~GwGe9k_JX2194221942eucas1p2c;
        Thu, 12 Nov 2020 11:51:08 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201112115108eusmtrp2758028440a2187e01742fbeab43acf12~GwGe81vQ_2331023310eusmtrp2i;
        Thu, 12 Nov 2020 11:51:08 +0000 (GMT)
X-AuditID: cbfec7f5-c5fff7000000b1b0-c9-5fad21adba5d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 8F.79.21957.CA12DAF5; Thu, 12
        Nov 2020 11:51:08 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201112115108eusmtip1d9ae6b1cd63aaeaf968c14cfb8655b77~GwGeqBBIL0049700497eusmtip1K;
        Thu, 12 Nov 2020 11:51:08 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v6 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Date:   Thu, 12 Nov 2020 12:51:04 +0100
Message-Id: <20201112115106.16224-4-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112115106.16224-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7djPc7prFdfGG2zcKGlx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wARxSXTUpqTmZZapG+XQJXxqMFq1gLfkxjqVh35DRLA+PNHcxdjJwc
        EgImElfvbWXsYuTiEBJYwSjR/+UDlPOFUeL8wm5WCOczo8SiSw+BHA6wlo+3giDiyxkltjx+
        wA7hPGeUuL6/mwlkLpuAo0T/0hNg3SIC95gl1rc/AJvLLLCPUWLnvSlg24UFgiSWrjvACmKz
        CKhKfFp/ggXE5hWwlnh+4gMrxIXyEu3Lt7OB2JwCNhJLb15kh6gRlDg58wlYPb+AlsSaputg
        NjNQffPW2cwgyyQE9nNKXP25nw1ikIvE5YXToWxhiVfHt7BD2DIS/3fOZ4L4rV5i8iQziN4e
        Roltc36wQNRYS9w594sNpIZZQFNi/S59iHJHidMXKyBMPokbbwUhLuCTmLRtOjNEmFeio00I
        YoaKxLr+PVDzpCR6X61gnMCoNAvJL7OQ3D8LYdUCRuZVjOKppcW56anFxnmp5XrFibnFpXnp
        esn5uZsYgcnu9L/jX3cwrnj1Ue8QIxMH4yFGCQ5mJRFeZYc18UK8KYmVValF+fFFpTmpxYcY
        pTlYlMR5d20FSgmkJ5akZqemFqQWwWSZODilGph0VOoW2P9J9c02i334liO4blPN/5qLd5YU
        5Gjut9dvP8teKuzavNf2xb+nLdkrY1Xc2ma/cvxTWMppNnexVI75nct82Uqc707GHC9aoP6p
        dK3vp+97dM+zh9l+e63DtPccw6X8OwW33fn373q6c/IJidr2iunp3w0VnvOIK2lZuh+98uPF
        gSnbPJ7d4MqSP2n8Yf7FF/4y+37+X/Jn4XtGT9O7UbzbjIrtc55Wd9/X/xWnMOX+v8AS22tF
        pcUODx9d36l7wtO8KHxDxX/J1pSUXdcrr3LUhq8OuFF5UbPX8Ib5uqSGLfUPt+1Tu7Rgs+u6
        kysrYyTPZttfe7J5v1CFVOb6P3W957Usbq63aPJQYinOSDTUYi4qTgQA3SFqheUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t/xu7prFNfGG2xfbGpx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wAR5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6d
        TUpqTmZZapG+XYJexqMFq1gLfkxjqVh35DRLA+PNHcxdjBwcEgImEh9vBXUxcnEICSxllOiZ
        spYNIi4lsXJuehcjJ5ApLPHnWhcbRM1TRonGlnMsIAk2AUeJ/qUnWEESIgJvmCWa7r1lB3GY
        BfYxSuw/upgdpEpYIEDizuepTCA2i4CqxKf1J8C6eQWsJZ6f+MAKsUJeon35djYQm1PARmLp
        zYtgvUJANa0zP7ND1AtKnJz5hAXkOmYBdYn184RAwvwCWhJrmq6DjWQGGtO8dTbzBEahWUg6
        ZiF0zEJStYCReRWjSGppcW56brGhXnFibnFpXrpecn7uJkZgbG879nPzDsZ5rz7qHWJk4mA8
        xCjBwawkwqvssCZeiDclsbIqtSg/vqg0J7X4EKMp0GcTmaVEk/OBySWvJN7QzMDU0MTM0sDU
        0sxYSZx361ygJoH0xJLU7NTUgtQimD4mDk6pBqainBn1JhasjzhF1lhXp3PV/dsa/9P082fh
        nYzborZcrfh03OG9awDfVIfYFw3RN34U3nyeWFIene6e3syhrFSXczDQoufOcuvo01t7tKR3
        L368oSnmknLN+eX/25oNzd+XiK36/i+i6O9nx8RpNd2H5Lc2MjP5rF+U8cDgXotngqjKhA0P
        PC9oVZYsb5sxeWGFkmPTp/vvr25d8dv466t/GqsF9jxtOvLB2PS/13zxmwyzFzYblIR1KC98
        m/itXv66tHfw6sN5Bs4mL7lnx+abtEs0eFj6vZp/589jI8entn3Xih/unOPzoDb38qnLf9yP
        HvgXbVone3p+UIbXja2B6QdnhOhp7T2UcWi9pZISS3FGoqEWc1FxIgA5AhCCdgMAAA==
X-CMS-MailID: 20201112115108eucas1p22790c6cdec17e5322424e026b3985305
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201112115108eucas1p22790c6cdec17e5322424e026b3985305
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201112115108eucas1p22790c6cdec17e5322424e026b3985305
References: <20201112115106.16224-1-l.stelmach@samsung.com>
        <CGME20201112115108eucas1p22790c6cdec17e5322424e026b3985305@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
connected to a CPU with a 8/16-bit bus or with an SPI. This driver
supports SPI connection.

The driver has been ported from the vendor kernel for ARTIK5[2]
boards. Several changes were made to adapt it to the current kernel
which include:

+ updated DT configuration,
+ clock configuration moved to DT,
+ new timer, ethtool and gpio APIs,
+ dev_* instead of pr_* and custom printk() wrappers,
+ removed awkward vendor power managemtn.
+ introduced ethtool tunable to control SPI compression

[1] https://www.asix.com.tw/products.php?op=pItemdetail&PItemID=104;65;86&PLine=65
[2] https://git.tizen.org/cgit/profile/common/platform/kernel/linux-3.10-artik/

The other ax88796 driver is for NE2000 compatible AX88796L chip. These
chips are not compatible. Hence, two separate drivers are required.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 MAINTAINERS                                |    6 +
 drivers/net/ethernet/Kconfig               |    1 +
 drivers/net/ethernet/Makefile              |    1 +
 drivers/net/ethernet/asix/Kconfig          |   35 +
 drivers/net/ethernet/asix/Makefile         |    6 +
 drivers/net/ethernet/asix/ax88796c_ioctl.c |  237 ++++
 drivers/net/ethernet/asix/ax88796c_ioctl.h |   26 +
 drivers/net/ethernet/asix/ax88796c_main.c  | 1132 ++++++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h  |  561 ++++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c   |  109 ++
 drivers/net/ethernet/asix/ax88796c_spi.h   |   70 ++
 include/uapi/linux/ethtool.h               |    1 +
 net/ethtool/common.c                       |    1 +
 13 files changed, 2186 insertions(+)
 create mode 100644 drivers/net/ethernet/asix/Kconfig
 create mode 100644 drivers/net/ethernet/asix/Makefile
 create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.h
 create mode 100644 drivers/net/ethernet/asix/ax88796c_main.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_main.h
 create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 14b8ec0bb58b..930dc859d4f7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2812,6 +2812,12 @@ S:	Maintained
 F:	Documentation/hwmon/asc7621.rst
 F:	drivers/hwmon/asc7621.c
 
+ASIX AX88796C SPI ETHERNET ADAPTER
+M:	Łukasz Stelmach <l.stelmach@samsung.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/asix,ax99706c-spi.yaml
+F:	drivers/net/ethernet/asix/ax88796c_*
+
 ASPEED PINCTRL DRIVERS
 M:	Andrew Jeffery <andrew@aj.id.au>
 L:	linux-aspeed@lists.ozlabs.org (moderated for non-subscribers)
diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index de50e8b9e656..f3b218e45ea5 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -32,6 +32,7 @@ source "drivers/net/ethernet/apm/Kconfig"
 source "drivers/net/ethernet/apple/Kconfig"
 source "drivers/net/ethernet/aquantia/Kconfig"
 source "drivers/net/ethernet/arc/Kconfig"
+source "drivers/net/ethernet/asix/Kconfig"
 source "drivers/net/ethernet/atheros/Kconfig"
 source "drivers/net/ethernet/aurora/Kconfig"
 source "drivers/net/ethernet/broadcom/Kconfig"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index f8f38dcb5f8a..9eb368d93607 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_NET_XGENE) += apm/
 obj-$(CONFIG_NET_VENDOR_APPLE) += apple/
 obj-$(CONFIG_NET_VENDOR_AQUANTIA) += aquantia/
 obj-$(CONFIG_NET_VENDOR_ARC) += arc/
+obj-$(CONFIG_NET_VENDOR_ASIX) += asix/
 obj-$(CONFIG_NET_VENDOR_ATHEROS) += atheros/
 obj-$(CONFIG_NET_VENDOR_AURORA) += aurora/
 obj-$(CONFIG_NET_VENDOR_CADENCE) += cadence/
diff --git a/drivers/net/ethernet/asix/Kconfig b/drivers/net/ethernet/asix/Kconfig
new file mode 100644
index 000000000000..eed02453314c
--- /dev/null
+++ b/drivers/net/ethernet/asix/Kconfig
@@ -0,0 +1,35 @@
+#
+# Asix network device configuration
+#
+
+config NET_VENDOR_ASIX
+	bool "Asix devices"
+	default y
+	help
+	  If you have a network (Ethernet, non-USB, not NE2000 compatible)
+	  interface based on a chip from ASIX, say Y.
+
+if NET_VENDOR_ASIX
+
+config SPI_AX88796C
+	tristate "Asix AX88796C-SPI support"
+	select PHYLIB
+	depends on SPI
+	depends on GPIOLIB
+	help
+	  Say Y here if you intend to use ASIX AX88796C attached in SPI mode.
+
+config SPI_AX88796C_COMPRESSION
+	bool "SPI transfer compression"
+	default n
+	depends on SPI_AX88796C
+	help
+	  Say Y here to enable SPI transfer compression. It saves up
+	  to 24 dummy cycles during each transfer which may noticeably
+	  speed up short transfers. This sets the default value that is
+	  inherited by network interfaces during probe. It can be
+	  changed at run time via spi-compression ethtool tunable.
+
+	  If unsure say N.
+
+endif # NET_VENDOR_ASIX
diff --git a/drivers/net/ethernet/asix/Makefile b/drivers/net/ethernet/asix/Makefile
new file mode 100644
index 000000000000..0bfbbb042634
--- /dev/null
+++ b/drivers/net/ethernet/asix/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for the Asix network device drivers.
+#
+
+obj-$(CONFIG_SPI_AX88796C) += ax88796c.o
+ax88796c-y := ax88796c_main.o ax88796c_ioctl.o ax88796c_spi.o
diff --git a/drivers/net/ethernet/asix/ax88796c_ioctl.c b/drivers/net/ethernet/asix/ax88796c_ioctl.c
new file mode 100644
index 000000000000..1a397e9660f4
--- /dev/null
+++ b/drivers/net/ethernet/asix/ax88796c_ioctl.c
@@ -0,0 +1,237 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2010 ASIX Electronics Corporation
+ * Copyright (c) 2020 Samsung Electronics Co., Ltd.
+ *
+ * ASIX AX88796C SPI Fast Ethernet Linux driver
+ */
+
+#define pr_fmt(fmt)	"ax88796c: " fmt
+
+#include <linux/bitmap.h>
+#include <linux/iopoll.h>
+#include <linux/phy.h>
+#include <linux/netdevice.h>
+
+#include "ax88796c_main.h"
+#include "ax88796c_ioctl.h"
+
+static void
+ax88796c_get_drvinfo(struct net_device *ndev, struct ethtool_drvinfo *info)
+{
+	/* Inherit standard device info */
+	strncpy(info->driver, DRV_NAME, sizeof(info->driver));
+}
+
+static u32 ax88796c_get_msglevel(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+
+	return ax_local->msg_enable;
+}
+
+static void ax88796c_set_msglevel(struct net_device *ndev, u32 level)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+
+	ax_local->msg_enable = level;
+}
+
+static u32 ax88796c_ethtool_getmsglevel(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+
+	return ax_local->msg_enable;
+}
+
+static void ax88796c_ethtool_setmsglevel(struct net_device *ndev, u32 level)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+
+	ax_local->msg_enable = level;
+}
+
+static void
+ax88796c_get_pauseparam(struct net_device *ndev, struct ethtool_pauseparam *pause)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+
+	pause->tx_pause = !!(ax_local->flowctrl & AX_FC_TX);
+	pause->rx_pause = !!(ax_local->flowctrl & AX_FC_RX);
+	pause->autoneg = (ax_local->flowctrl & AX_FC_ANEG) ?
+		AUTONEG_ENABLE :
+		AUTONEG_DISABLE;
+}
+
+static int
+ax88796c_set_pauseparam(struct net_device *ndev, struct ethtool_pauseparam *pause)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	int fc;
+
+	/* The following logic comes from phylink_ethtool_set_pauseparam() */
+	fc = pause->tx_pause ? AX_FC_TX : 0;
+	fc |= pause->rx_pause ? AX_FC_RX : 0;
+	fc |= pause->autoneg ? AX_FC_ANEG : 0;
+
+	ax_local->flowctrl = fc;
+
+	if (pause->autoneg) {
+		phy_set_asym_pause(ax_local->phydev, pause->tx_pause,
+				   pause->rx_pause);
+	} else {
+		int maccr = 0;
+
+		phy_set_asym_pause(ax_local->phydev, 0, 0);
+		maccr |= (ax_local->flowctrl & AX_FC_RX) ? MACCR_RXFC_ENABLE : 0;
+		maccr |= (ax_local->flowctrl & AX_FC_TX) ? MACCR_TXFC_ENABLE : 0;
+
+		mutex_lock(&ax_local->spi_lock);
+
+		maccr |= AX_READ(&ax_local->ax_spi, P0_MACCR) &
+			~(MACCR_TXFC_ENABLE | MACCR_RXFC_ENABLE);
+		AX_WRITE(&ax_local->ax_spi, maccr, P0_MACCR);
+
+		mutex_unlock(&ax_local->spi_lock);
+	}
+
+	return 0;
+}
+
+static int ax88796c_get_regs_len(struct net_device *ndev)
+{
+	return AX88796C_REGDUMP_LEN + AX88796C_PHY_REGDUMP_LEN;
+}
+
+static void
+ax88796c_get_regs(struct net_device *ndev, struct ethtool_regs *regs, void *_p)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	int offset, i;
+	u16 *p = _p;
+
+	memset(p, 0, ax88796c_get_regs_len(ndev));
+
+	mutex_lock(&ax_local->spi_lock);
+
+	for (offset = 0; offset < AX88796C_REGDUMP_LEN; offset += 2) {
+		if (!test_bit(offset / 2, ax88796c_no_regs_mask))
+			*p = AX_READ(&ax_local->ax_spi, offset);
+		p++;
+	}
+
+	mutex_unlock(&ax_local->spi_lock);
+
+	for (i = 0; i < AX88796C_PHY_REGDUMP_LEN / 2; i++) {
+		*p = phy_read(ax_local->phydev, i);
+		p++;
+	}
+}
+
+static int
+ax88796c_set_tunable(struct net_device *ndev, const struct ethtool_tunable *tuna,
+		     const void *data)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+
+	switch (tuna->id) {
+	case ETHTOOL_SPI_COMPRESSION:
+		if (netif_running(ndev))
+			return -EBUSY;
+		if ((*(u32 *)data) != 1)
+			return -EINVAL;
+		ax_local->capabilities &= ~AX_CAP_COMP;
+		ax_local->capabilities |= (*(u32 *)data) == 1 ? AX_CAP_COMP : 0;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int
+ax88796c_get_tunable(struct net_device *ndev, const struct ethtool_tunable *tuna,
+		     void *data)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+
+	switch (tuna->id) {
+	case ETHTOOL_SPI_COMPRESSION:
+		*(u32 *)data = !!(ax_local->ax_spi.comp & AX_CAP_COMP);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+int ax88796c_mdio_read(struct mii_bus *mdiobus, int phy_id, int loc)
+{
+	struct ax88796c_device *ax_local = mdiobus->priv;
+	int ret;
+
+	mutex_lock(&ax_local->spi_lock);
+	AX_WRITE(&ax_local->ax_spi, MDIOCR_RADDR(loc)
+			| MDIOCR_FADDR(phy_id) | MDIOCR_READ, P2_MDIOCR);
+
+	ret = read_poll_timeout(AX_READ, ret,
+				(ret != 0),
+				0, jiffies_to_usecs(HZ / 100), false,
+				&ax_local->ax_spi, P2_MDIOCR);
+	if (!ret)
+		ret = AX_READ(&ax_local->ax_spi, P2_MDIODR);
+
+	mutex_unlock(&ax_local->spi_lock);
+
+	return ret;
+}
+
+int
+ax88796c_mdio_write(struct mii_bus *mdiobus, int phy_id, int loc, u16 val)
+{
+	struct ax88796c_device *ax_local = mdiobus->priv;
+	int ret;
+
+	mutex_lock(&ax_local->spi_lock);
+	AX_WRITE(&ax_local->ax_spi, val, P2_MDIODR);
+
+	AX_WRITE(&ax_local->ax_spi,
+		 MDIOCR_RADDR(loc) | MDIOCR_FADDR(phy_id)
+		 | MDIOCR_WRITE, P2_MDIOCR);
+
+	ret = read_poll_timeout(AX_READ, ret,
+				((ret & MDIOCR_VALID) != 0), 0,
+				jiffies_to_usecs(HZ / 100), false,
+				&ax_local->ax_spi, P2_MDIOCR);
+	mutex_unlock(&ax_local->spi_lock);
+
+	return ret;
+}
+
+const struct ethtool_ops ax88796c_ethtool_ops = {
+	.get_drvinfo		= ax88796c_get_drvinfo,
+	.get_link		= ethtool_op_get_link,
+	.get_msglevel		= ax88796c_get_msglevel,
+	.set_msglevel		= ax88796c_set_msglevel,
+	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
+	.nway_reset		= phy_ethtool_nway_reset,
+	.get_msglevel		= ax88796c_ethtool_getmsglevel,
+	.set_msglevel		= ax88796c_ethtool_setmsglevel,
+	.get_pauseparam		= ax88796c_get_pauseparam,
+	.set_pauseparam		= ax88796c_set_pauseparam,
+	.get_regs_len		= ax88796c_get_regs_len,
+	.get_regs		= ax88796c_get_regs,
+	.get_tunable		= ax88796c_get_tunable,
+	.set_tunable		= ax88796c_set_tunable,};
+
+int ax88796c_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
+{
+	int ret;
+
+	ret = phy_mii_ioctl(ndev->phydev, ifr, cmd);
+
+	return ret;
+}
diff --git a/drivers/net/ethernet/asix/ax88796c_ioctl.h b/drivers/net/ethernet/asix/ax88796c_ioctl.h
new file mode 100644
index 000000000000..34d2a7dcc5ef
--- /dev/null
+++ b/drivers/net/ethernet/asix/ax88796c_ioctl.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2010 ASIX Electronics Corporation
+ * Copyright (c) 2020 Samsung Electronics Co., Ltd.
+ *
+ * ASIX AX88796C SPI Fast Ethernet Linux driver
+ */
+
+#ifndef _AX88796C_IOCTL_H
+#define _AX88796C_IOCTL_H
+
+#include <linux/ethtool.h>
+#include <linux/netdevice.h>
+
+#include "ax88796c_main.h"
+
+extern const struct ethtool_ops ax88796c_ethtool_ops;
+
+bool ax88796c_check_power(const struct ax88796c_device *ax_local);
+bool ax88796c_check_power_and_wake(struct ax88796c_device *ax_local);
+void ax88796c_set_power_saving(struct ax88796c_device *ax_local, u8 ps_level);
+int ax88796c_mdio_read(struct mii_bus *mdiobus, int phy_id, int loc);
+int ax88796c_mdio_write(struct mii_bus *mdiobus, int phy_id, int loc, u16 val);
+int ax88796c_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+
+#endif
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
new file mode 100644
index 000000000000..56c7764deffe
--- /dev/null
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -0,0 +1,1132 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2010 ASIX Electronics Corporation
+ * Copyright (c) 2020 Samsung Electronics Co., Ltd.
+ *
+ * ASIX AX88796C SPI Fast Ethernet Linux driver
+ */
+
+#define pr_fmt(fmt)	"ax88796c: " fmt
+
+#include "ax88796c_main.h"
+#include "ax88796c_ioctl.h"
+
+#include <linux/bitmap.h>
+#include <linux/etherdevice.h>
+#include <linux/iopoll.h>
+#include <linux/mdio.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/of.h>
+#include <linux/phy.h>
+#include <linux/spi/spi.h>
+
+static int comp = IS_ENABLED(CONFIG_SPI_AX88796C_COMPRESSION);
+static int msg_enable = NETIF_MSG_PROBE |
+			NETIF_MSG_LINK |
+			NETIF_MSG_RX_ERR |
+			NETIF_MSG_TX_ERR;
+
+static char *no_regs_list = "80018001,e1918001,8001a001,fc0d0000";
+unsigned long ax88796c_no_regs_mask[AX88796C_REGDUMP_LEN / (sizeof(unsigned long) * 8)];
+
+module_param(msg_enable, int, 0444);
+MODULE_PARM_DESC(msg_enable, "Message mask (see linux/netdevice.h for bitmap)");
+
+static int ax88796c_soft_reset(struct ax88796c_device *ax_local)
+{
+	u16 temp;
+	int ret;
+
+	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
+
+	AX_WRITE(&ax_local->ax_spi, PSR_RESET, P0_PSR);
+	AX_WRITE(&ax_local->ax_spi, PSR_RESET_CLR, P0_PSR);
+
+	ret = read_poll_timeout(AX_READ, ret,
+				(ret & PSR_DEV_READY),
+				0, jiffies_to_usecs(160 * HZ / 1000), false,
+				&ax_local->ax_spi, P0_PSR);
+	if (ret)
+		return ret;
+
+	temp = AX_READ(&ax_local->ax_spi, P4_SPICR);
+	if (ax_local->capabilities & AX_CAP_COMP) {
+		AX_WRITE(&ax_local->ax_spi,
+			 (temp | SPICR_RCEN | SPICR_QCEN), P4_SPICR);
+		ax_local->ax_spi.comp = 1;
+	} else {
+		AX_WRITE(&ax_local->ax_spi,
+			 (temp & ~(SPICR_RCEN | SPICR_QCEN)), P4_SPICR);
+		ax_local->ax_spi.comp = 0;
+	}
+
+	return 0;
+}
+
+static int ax88796c_reload_eeprom(struct ax88796c_device *ax_local)
+{
+	int ret;
+
+	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
+
+	AX_WRITE(&ax_local->ax_spi, EECR_RELOAD, P3_EECR);
+
+	ret = read_poll_timeout(AX_READ, ret,
+				(ret & PSR_DEV_READY),
+				0, jiffies_to_usecs(2 * HZ / 1000), false,
+				&ax_local->ax_spi, P0_PSR);
+	if (ret) {
+		dev_err(&ax_local->spi->dev,
+			"timeout waiting for reload eeprom\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void ax88796c_set_hw_multicast(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	int mc_count = netdev_mc_count(ndev);
+	u16 rx_ctl = RXCR_AB;
+
+	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
+
+	memset(ax_local->multi_filter, 0, AX_MCAST_FILTER_SIZE);
+
+	if (ndev->flags & IFF_PROMISC) {
+		rx_ctl |= RXCR_PRO;
+
+	} else if (ndev->flags & IFF_ALLMULTI || mc_count > AX_MAX_MCAST) {
+		rx_ctl |= RXCR_AMALL;
+
+	} else if (mc_count == 0) {
+		/* just broadcast and directed */
+	} else {
+		u32 crc_bits;
+		int i;
+		struct netdev_hw_addr *ha;
+
+		netdev_for_each_mc_addr(ha, ndev) {
+			crc_bits = ether_crc(ETH_ALEN, ha->addr);
+			ax_local->multi_filter[crc_bits >> 29] |=
+						(1 << ((crc_bits >> 26) & 7));
+		}
+
+		for (i = 0; i < 4; i++) {
+			AX_WRITE(&ax_local->ax_spi,
+				 ((ax_local->multi_filter[i * 2 + 1] << 8) |
+				  ax_local->multi_filter[i * 2]), P3_MFAR(i));
+		}
+	}
+
+	AX_WRITE(&ax_local->ax_spi, rx_ctl, P2_RXCR);
+}
+
+static void ax88796c_set_mac_addr(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+
+	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
+
+	AX_WRITE(&ax_local->ax_spi, ((u16)(ndev->dev_addr[4] << 8) |
+			(u16)ndev->dev_addr[5]), P3_MACASR0);
+	AX_WRITE(&ax_local->ax_spi, ((u16)(ndev->dev_addr[2] << 8) |
+			(u16)ndev->dev_addr[3]), P3_MACASR1);
+	AX_WRITE(&ax_local->ax_spi, ((u16)(ndev->dev_addr[0] << 8) |
+			(u16)ndev->dev_addr[1]), P3_MACASR2);
+}
+
+static void ax88796c_load_mac_addr(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	u16 temp;
+
+	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
+
+	/* Try the device tree first */
+	if (!eth_platform_get_mac_address(&ax_local->spi->dev, ndev->dev_addr) &&
+	    is_valid_ether_addr(ndev->dev_addr)) {
+		if (netif_msg_probe(ax_local))
+			dev_info(&ax_local->spi->dev,
+				 "MAC address read from device tree\n");
+		return;
+	}
+
+	/* Read the MAC address from AX88796C */
+	temp = AX_READ(&ax_local->ax_spi, P3_MACASR0);
+	ndev->dev_addr[5] = (u8)temp;
+	ndev->dev_addr[4] = (u8)(temp >> 8);
+
+	temp = AX_READ(&ax_local->ax_spi, P3_MACASR1);
+	ndev->dev_addr[3] = (u8)temp;
+	ndev->dev_addr[2] = (u8)(temp >> 8);
+
+	temp = AX_READ(&ax_local->ax_spi, P3_MACASR2);
+	ndev->dev_addr[1] = (u8)temp;
+	ndev->dev_addr[0] = (u8)(temp >> 8);
+
+	if (is_valid_ether_addr(ndev->dev_addr)) {
+		if (netif_msg_probe(ax_local))
+			dev_info(&ax_local->spi->dev,
+				 "MAC address read from ASIX chip\n");
+		return;
+	}
+
+	/* Use random address if none found */
+	if (netif_msg_probe(ax_local))
+		dev_info(&ax_local->spi->dev, "Use random MAC address\n");
+	eth_hw_addr_random(ndev);
+}
+
+static void ax88796c_proc_tx_hdr(struct tx_pkt_info *info, u8 ip_summed)
+{
+	u16 pkt_len_bar = (~info->pkt_len & TX_HDR_SOP_PKTLENBAR);
+
+	/* Prepare SOP header */
+	info->sop.flags_len = info->pkt_len |
+		((ip_summed == CHECKSUM_NONE) ||
+		 (ip_summed == CHECKSUM_UNNECESSARY) ? TX_HDR_SOP_DICF : 0);
+
+	info->sop.seq_lenbar = ((info->seq_num << 11) & TX_HDR_SOP_SEQNUM)
+				| pkt_len_bar;
+	cpu_to_be16s(&info->sop.flags_len);
+	cpu_to_be16s(&info->sop.seq_lenbar);
+
+	/* Prepare Segment header */
+	info->seg.flags_seqnum_seglen = TX_HDR_SEG_FS | TX_HDR_SEG_LS
+						| info->pkt_len;
+
+	info->seg.eo_so_seglenbar = pkt_len_bar;
+
+	cpu_to_be16s(&info->seg.flags_seqnum_seglen);
+	cpu_to_be16s(&info->seg.eo_so_seglenbar);
+
+	/* Prepare EOP header */
+	info->eop.seq_len = ((info->seq_num << 11) &
+			     TX_HDR_EOP_SEQNUM) | info->pkt_len;
+	info->eop.seqbar_lenbar = ((~info->seq_num << 11) &
+				   TX_HDR_EOP_SEQNUMBAR) | pkt_len_bar;
+
+	cpu_to_be16s(&info->eop.seq_len);
+	cpu_to_be16s(&info->eop.seqbar_lenbar);
+}
+
+static int
+ax88796c_check_free_pages(struct ax88796c_device *ax_local, u8 need_pages)
+{
+	u8 free_pages;
+	u16 tmp;
+
+	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
+
+	free_pages = AX_READ(&ax_local->ax_spi, P0_TFBFCR) & TX_FREEBUF_MASK;
+	if (free_pages < need_pages) {
+		/* schedule free page interrupt */
+		tmp = AX_READ(&ax_local->ax_spi, P0_TFBFCR)
+				& TFBFCR_SCHE_FREE_PAGE;
+		AX_WRITE(&ax_local->ax_spi, tmp | TFBFCR_TX_PAGE_SET |
+				TFBFCR_SET_FREE_PAGE(need_pages),
+				P0_TFBFCR);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static struct sk_buff *
+ax88796c_tx_fixup(struct net_device *ndev, struct sk_buff_head *q)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	u8 spi_len = ax_local->ax_spi.comp ? 1 : 4;
+	struct sk_buff *skb, *tx_skb;
+	struct tx_pkt_info *info;
+	struct skb_data *entry;
+	u16 tol_len, pkt_len;
+	u8 padlen, seq_num;
+	u8 need_pages;
+	int headroom;
+	int tailroom;
+
+	if (skb_queue_empty(q))
+		return NULL;
+
+	skb = skb_peek(q);
+	pkt_len = skb->len;
+	need_pages = (pkt_len + TX_OVERHEAD + 127) >> 7;
+	if (ax88796c_check_free_pages(ax_local, need_pages) != 0)
+		return NULL;
+
+	headroom = skb_headroom(skb);
+	tailroom = skb_tailroom(skb);
+	padlen = ((pkt_len + 3) & 0x7FC) - pkt_len;
+	tol_len = ((pkt_len + 3) & 0x7FC) +
+			TX_OVERHEAD + TX_EOP_SIZE + spi_len;
+	seq_num = ++ax_local->seq_num & 0x1F;
+
+	info = (struct tx_pkt_info *)skb->cb;
+	info->pkt_len = pkt_len;
+
+	if ((!skb_cloned(skb)) &&
+	    (headroom >= (TX_OVERHEAD + spi_len)) &&
+	    (tailroom >= (padlen + TX_EOP_SIZE))) {
+		info->seq_num = seq_num;
+		ax88796c_proc_tx_hdr(info, skb->ip_summed);
+
+		/* SOP and SEG header */
+		memcpy(skb_push(skb, TX_OVERHEAD), &info->sop, TX_OVERHEAD);
+
+		/* Write SPI TXQ header */
+		memcpy(skb_push(skb, spi_len), tx_cmd_buf, spi_len);
+
+		/* Make 32-bit alignment */
+		skb_put(skb, padlen);
+
+		/* EOP header */
+		memcpy(skb_put(skb, TX_EOP_SIZE), &info->eop, TX_EOP_SIZE);
+
+		tx_skb = skb;
+		skb_unlink(skb, q);
+	} else {
+		tx_skb = alloc_skb(tol_len, GFP_KERNEL);
+		if (!tx_skb)
+			return NULL;
+
+		/* Write SPI TXQ header */
+		memcpy(skb_put(tx_skb, spi_len), tx_cmd_buf, spi_len);
+
+		info->seq_num = seq_num;
+		ax88796c_proc_tx_hdr(info, skb->ip_summed);
+
+		/* SOP and SEG header */
+		memcpy(skb_put(tx_skb, TX_OVERHEAD),
+		       &info->sop, TX_OVERHEAD);
+
+		/* Packet */
+		memcpy(skb_put(tx_skb, ((pkt_len + 3) & 0xFFFC)),
+		       skb->data, pkt_len);
+
+		/* EOP header */
+		memcpy(skb_put(tx_skb, TX_EOP_SIZE),
+		       &info->eop, TX_EOP_SIZE);
+
+		skb_unlink(skb, q);
+		dev_kfree_skb(skb);
+	}
+
+	entry = (struct skb_data *)tx_skb->cb;
+	memset(entry, 0, sizeof(*entry));
+	entry->len = pkt_len;
+
+	if (netif_msg_pktdata(ax_local)) {
+		char pfx[IFNAMSIZ + 7];
+
+		snprintf(pfx, sizeof(pfx), "%s:     ", ndev->name);
+
+		netdev_info(ndev, "TX packet len %d, total len %d, seq %d\n",
+			    pkt_len, tx_skb->len, seq_num);
+
+		netdev_info(ndev, "  SPI Header:\n");
+		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
+			       tx_skb->data, 4, 0);
+
+		netdev_info(ndev, "  TX SOP:\n");
+		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
+			       tx_skb->data + 4, TX_OVERHEAD, 0);
+
+		netdev_info(ndev, "  TX packet:\n");
+		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
+			       tx_skb->data + 4 + TX_OVERHEAD,
+			       tx_skb->len - TX_EOP_SIZE - 4 - TX_OVERHEAD, 0);
+
+		netdev_info(ndev, "  TX EOP:\n");
+		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
+			       tx_skb->data + tx_skb->len - 4, 4, 0);
+	}
+
+	return tx_skb;
+}
+
+static int ax88796c_hard_xmit(struct ax88796c_device *ax_local)
+{
+	struct sk_buff *tx_skb;
+	struct skb_data *entry;
+
+	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
+
+	tx_skb = ax88796c_tx_fixup(ax_local->ndev, &ax_local->tx_wait_q);
+
+	if (!tx_skb)
+		return 0;
+
+	entry = (struct skb_data *)tx_skb->cb;
+
+	AX_WRITE(&ax_local->ax_spi,
+		 (TSNR_TXB_START | TSNR_PKT_CNT(1)), P0_TSNR);
+
+	axspi_write_txq(&ax_local->ax_spi, tx_skb->data, tx_skb->len);
+
+	if (((AX_READ(&ax_local->ax_spi, P0_TSNR) & TXNR_TXB_IDLE) == 0) ||
+	    ((ISR_TXERR & AX_READ(&ax_local->ax_spi, P0_ISR)) != 0)) {
+		/* Ack tx error int */
+		AX_WRITE(&ax_local->ax_spi, ISR_TXERR, P0_ISR);
+
+		ax_local->stats.tx_dropped++;
+
+		netif_err(ax_local, tx_err, ax_local->ndev,
+			  "TX FIFO error, re-initialize the TX bridge\n");
+
+		/* Reinitial tx bridge */
+		AX_WRITE(&ax_local->ax_spi, TXNR_TXB_REINIT |
+			AX_READ(&ax_local->ax_spi, P0_TSNR), P0_TSNR);
+		ax_local->seq_num = 0;
+	} else {
+		ax_local->stats.tx_packets++;
+		ax_local->stats.tx_bytes += entry->len;
+	}
+
+	entry->state = tx_done;
+	dev_kfree_skb(tx_skb);
+
+	return 1;
+}
+
+static int
+ax88796c_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+
+	skb_queue_tail(&ax_local->tx_wait_q, skb);
+	if (skb_queue_len(&ax_local->tx_wait_q) > TX_QUEUE_HIGH_WATER) {
+		netif_err(ax_local, tx_queued, ndev,
+			  "Too many TX packets in queue %d\n",
+			  skb_queue_len(&ax_local->tx_wait_q));
+
+		netif_stop_queue(ndev);
+	}
+
+	set_bit(EVENT_TX, &ax_local->flags);
+	schedule_work(&ax_local->ax_work);
+
+	return NETDEV_TX_OK;
+}
+
+static void
+ax88796c_skb_return(struct ax88796c_device *ax_local, struct sk_buff *skb,
+		    struct rx_header *rxhdr)
+{
+	struct net_device *ndev = ax_local->ndev;
+	int status;
+
+	do {
+		if (!(ndev->features & NETIF_F_RXCSUM))
+			break;
+
+		/* checksum error bit is set */
+		if ((rxhdr->flags & RX_HDR3_L3_ERR) ||
+		    (rxhdr->flags & RX_HDR3_L4_ERR))
+			break;
+
+		/* Other types may be indicated by more than one bit. */
+		if ((rxhdr->flags & RX_HDR3_L4_TYPE_TCP) ||
+		    (rxhdr->flags & RX_HDR3_L4_TYPE_UDP))
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+	} while (0);
+
+	ax_local->stats.rx_packets++;
+	ax_local->stats.rx_bytes += skb->len;
+	skb->dev = ndev;
+
+	skb->truesize = skb->len + sizeof(struct sk_buff);
+	skb->protocol = eth_type_trans(skb, ax_local->ndev);
+
+	netif_info(ax_local, rx_status, ndev, "< rx, len %zu, type 0x%x\n",
+		   skb->len + sizeof(struct ethhdr), skb->protocol);
+
+	status = netif_rx(skb);
+	if (status != NET_RX_SUCCESS)
+		netif_info(ax_local, rx_err, ndev,
+			   "netif_rx status %d\n", status);
+}
+
+static void
+ax88796c_rx_fixup(struct ax88796c_device *ax_local, struct sk_buff *rx_skb)
+{
+	struct rx_header *rxhdr = (struct rx_header *)rx_skb->data;
+	struct net_device *ndev = ax_local->ndev;
+	u16 len;
+
+	be16_to_cpus(&rxhdr->flags_len);
+	be16_to_cpus(&rxhdr->seq_lenbar);
+	be16_to_cpus(&rxhdr->flags);
+
+	if ((((short)rxhdr->flags_len) & RX_HDR1_PKT_LEN) !=
+			 (~((short)rxhdr->seq_lenbar) & 0x7FF)) {
+		netif_err(ax_local, rx_err, ndev, "Header error\n");
+
+		ax_local->stats.rx_frame_errors++;
+		kfree_skb(rx_skb);
+		return;
+	}
+
+	if ((rxhdr->flags_len & RX_HDR1_MII_ERR) ||
+	    (rxhdr->flags_len & RX_HDR1_CRC_ERR)) {
+		netif_err(ax_local, rx_err, ndev, "CRC or MII error\n");
+
+		ax_local->stats.rx_crc_errors++;
+		kfree_skb(rx_skb);
+		return;
+	}
+
+	len = rxhdr->flags_len & RX_HDR1_PKT_LEN;
+	if (netif_msg_pktdata(ax_local)) {
+		char pfx[IFNAMSIZ + 7];
+
+		snprintf(pfx, sizeof(pfx), "%s:     ", ndev->name);
+		netdev_info(ndev, "RX data, total len %d, packet len %d\n",
+			    rx_skb->len, len);
+
+		netdev_info(ndev, "  Dump RX packet header:");
+		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
+			       rx_skb->data, sizeof(*rxhdr), 0);
+
+		netdev_info(ndev, "  Dump RX packet:");
+		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
+			       rx_skb->data + sizeof(*rxhdr), len, 0);
+	}
+
+	skb_pull(rx_skb, sizeof(*rxhdr));
+	__pskb_trim(rx_skb, len);
+
+	return ax88796c_skb_return(ax_local, rx_skb, rxhdr);
+}
+
+static int ax88796c_receive(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	struct skb_data *entry;
+	u16 w_count, pkt_len;
+	struct sk_buff *skb;
+	u8 pkt_cnt;
+
+	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
+
+	/* check rx packet and total word count */
+	AX_WRITE(&ax_local->ax_spi, AX_READ(&ax_local->ax_spi, P0_RTWCR)
+		  | RTWCR_RX_LATCH, P0_RTWCR);
+
+	pkt_cnt = AX_READ(&ax_local->ax_spi, P0_RXBCR2) & RXBCR2_PKT_MASK;
+	if (!pkt_cnt)
+		return 0;
+
+	pkt_len = AX_READ(&ax_local->ax_spi, P0_RCPHR) & 0x7FF;
+
+	w_count = ((pkt_len + 6 + 3) & 0xFFFC) >> 1;
+
+	skb = alloc_skb((w_count * 2), GFP_ATOMIC);
+	if (!skb) {
+		AX_WRITE(&ax_local->ax_spi, RXBCR1_RXB_DISCARD, P0_RXBCR1);
+		return 0;
+	}
+	entry = (struct skb_data *)skb->cb;
+
+	AX_WRITE(&ax_local->ax_spi, RXBCR1_RXB_START | w_count, P0_RXBCR1);
+
+	axspi_read_rxq(&ax_local->ax_spi,
+		       skb_put(skb, w_count * 2), skb->len);
+
+	/* Check if rx bridge is idle */
+	if ((AX_READ(&ax_local->ax_spi, P0_RXBCR2) & RXBCR2_RXB_IDLE) == 0) {
+		netif_err(ax_local, rx_err, ndev,
+			  "Rx Bridge is not idle\n");
+		AX_WRITE(&ax_local->ax_spi, RXBCR2_RXB_REINIT, P0_RXBCR2);
+
+		entry->state = rx_err;
+	} else {
+		entry->state = rx_done;
+	}
+
+	AX_WRITE(&ax_local->ax_spi, ISR_RXPKT, P0_ISR);
+
+	ax88796c_rx_fixup(ax_local, skb);
+
+	return 1;
+}
+
+static int ax88796c_process_isr(struct ax88796c_device *ax_local)
+{
+	struct net_device *ndev = ax_local->ndev;
+	u8 done = 0;
+	u16 isr;
+
+	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
+
+	isr = AX_READ(&ax_local->ax_spi, P0_ISR);
+	AX_WRITE(&ax_local->ax_spi, isr, P0_ISR);
+
+	netif_dbg(ax_local, intr, ndev, "  ISR 0x%04x\n", isr);
+
+	if (isr & ISR_TXERR) {
+		netif_dbg(ax_local, intr, ndev, "  TXERR interrupt\n");
+		AX_WRITE(&ax_local->ax_spi, TXNR_TXB_REINIT, P0_TSNR);
+		ax_local->seq_num = 0x1f;
+	}
+
+	if (isr & ISR_TXPAGES) {
+		netif_dbg(ax_local, intr, ndev, "  TXPAGES interrupt\n");
+		set_bit(EVENT_TX, &ax_local->flags);
+	}
+
+	if (isr & ISR_LINK) {
+		netif_dbg(ax_local, intr, ndev, "  Link change interrupt\n");
+		phy_mac_interrupt(ax_local->ndev->phydev);
+	}
+
+	if (isr & ISR_RXPKT) {
+		netif_dbg(ax_local, intr, ndev, "  RX interrupt\n");
+		done = ax88796c_receive(ax_local->ndev);
+	}
+
+	return done;
+}
+
+static irqreturn_t ax88796c_interrupt(int irq, void *dev_instance)
+{
+	struct ax88796c_device *ax_local;
+	struct net_device *ndev;
+
+	ndev = dev_instance;
+	if (!ndev) {
+		pr_err("irq %d for unknown device.\n", irq);
+		return IRQ_RETVAL(0);
+	}
+	ax_local = to_ax88796c_device(ndev);
+
+	disable_irq_nosync(irq);
+
+	netif_dbg(ax_local, intr, ndev, "Interrupt occurred\n");
+
+	set_bit(EVENT_INTR, &ax_local->flags);
+	schedule_work(&ax_local->ax_work);
+
+	return IRQ_HANDLED;
+}
+
+static void ax88796c_work(struct work_struct *work)
+{
+	struct ax88796c_device *ax_local =
+			container_of(work, struct ax88796c_device, ax_work);
+
+	mutex_lock(&ax_local->spi_lock);
+
+	if (test_bit(EVENT_SET_MULTI, &ax_local->flags)) {
+		ax88796c_set_hw_multicast(ax_local->ndev);
+		clear_bit(EVENT_SET_MULTI, &ax_local->flags);
+	}
+
+	if (test_bit(EVENT_INTR, &ax_local->flags)) {
+		AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
+
+		while (1) {
+			if (!ax88796c_process_isr(ax_local))
+				break;
+		}
+
+		clear_bit(EVENT_INTR, &ax_local->flags);
+
+		AX_WRITE(&ax_local->ax_spi, IMR_DEFAULT, P0_IMR);
+
+		enable_irq(ax_local->ndev->irq);
+	}
+
+	if (test_bit(EVENT_TX, &ax_local->flags)) {
+		while (skb_queue_len(&ax_local->tx_wait_q)) {
+			if (!ax88796c_hard_xmit(ax_local))
+				break;
+		}
+
+		clear_bit(EVENT_TX, &ax_local->flags);
+
+		if (netif_queue_stopped(ax_local->ndev) &&
+		    (skb_queue_len(&ax_local->tx_wait_q) < TX_QUEUE_LOW_WATER))
+			netif_wake_queue(ax_local->ndev);
+	}
+
+	mutex_unlock(&ax_local->spi_lock);
+}
+
+static struct net_device_stats *ax88796c_get_stats(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+
+	return &ax_local->stats;
+}
+
+static void ax88796c_set_mac(struct  ax88796c_device *ax_local)
+{
+	u16 maccr;
+
+	maccr = (ax_local->link) ? MACCR_RXEN : 0;
+
+	switch (ax_local->speed) {
+	case SPEED_100:
+		maccr |= MACCR_SPEED_100;
+	case SPEED_10:
+	case SPEED_UNKNOWN:
+		break;
+	default:
+		return;
+	}
+
+	switch (ax_local->duplex) {
+	case DUPLEX_FULL:
+		maccr |= MACCR_SPEED_100;
+	case DUPLEX_HALF:
+	case DUPLEX_UNKNOWN:
+		break;
+	default:
+		return;
+	}
+
+	if (ax_local->flowctrl & AX_FC_ANEG &&
+	    ax_local->phydev->autoneg) {
+		maccr |= ax_local->pause ? MACCR_RXFC_ENABLE : 0;
+		maccr |= !ax_local->pause != !ax_local->asym_pause ?
+			MACCR_TXFC_ENABLE : 0;
+	} else {
+		maccr |= (ax_local->flowctrl & AX_FC_RX) ? MACCR_RXFC_ENABLE : 0;
+		maccr |= (ax_local->flowctrl & AX_FC_TX) ? MACCR_TXFC_ENABLE : 0;
+	}
+
+	mutex_lock(&ax_local->spi_lock);
+
+	maccr |= AX_READ(&ax_local->ax_spi, P0_MACCR) &
+		~(MACCR_DUPLEX_FULL | MACCR_SPEED_100 |
+		  MACCR_TXFC_ENABLE | MACCR_RXFC_ENABLE);
+	AX_WRITE(&ax_local->ax_spi, maccr, P0_MACCR);
+
+	mutex_unlock(&ax_local->spi_lock);
+}
+
+static void ax88796c_handle_link_change(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	struct phy_device *phydev = ndev->phydev;
+	bool update = false;
+
+	if (phydev->link && (ax_local->speed != phydev->speed ||
+			     ax_local->duplex != phydev->duplex ||
+			     ax_local->pause != phydev->pause ||
+			     ax_local->asym_pause != phydev->asym_pause)) {
+		ax_local->speed = phydev->speed;
+		ax_local->duplex = phydev->duplex;
+		ax_local->pause = phydev->pause;
+		ax_local->asym_pause = phydev->asym_pause;
+		update = true;
+	}
+
+	if (phydev->link != ax_local->link) {
+		if (!phydev->link) {
+			ax_local->speed = SPEED_UNKNOWN;
+			ax_local->duplex = DUPLEX_UNKNOWN;
+		}
+
+		ax_local->link = phydev->link;
+		update = true;
+	}
+
+	if (update)
+		ax88796c_set_mac(ax_local);
+
+	if (net_ratelimit())
+		phy_print_status(ndev->phydev);
+}
+
+static void ax88796c_set_csums(struct ax88796c_device *ax_local)
+{
+	struct net_device *ndev = ax_local->ndev;
+
+	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
+
+	if (ndev->features & NETIF_F_RXCSUM) {
+		AX_WRITE(&ax_local->ax_spi, COERCR0_DEFAULT, P4_COERCR0);
+		AX_WRITE(&ax_local->ax_spi, COERCR1_DEFAULT, P4_COERCR1);
+	} else {
+		AX_WRITE(&ax_local->ax_spi, 0, P4_COERCR0);
+		AX_WRITE(&ax_local->ax_spi, 0, P4_COERCR1);
+	}
+
+	if (ndev->features & NETIF_F_HW_CSUM) {
+		AX_WRITE(&ax_local->ax_spi, COETCR0_DEFAULT, P4_COETCR0);
+		AX_WRITE(&ax_local->ax_spi, COETCR1_TXPPPE, P4_COETCR1);
+	} else {
+		AX_WRITE(&ax_local->ax_spi, 0, P4_COETCR0);
+		AX_WRITE(&ax_local->ax_spi, 0, P4_COETCR1);
+	}
+}
+
+static int
+ax88796c_open(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	unsigned long irq_flag = IRQF_SHARED;
+	int fc = AX_FC_NONE;
+	int ret;
+
+	ret = request_irq(ndev->irq, ax88796c_interrupt,
+			  irq_flag, ndev->name, ndev);
+	if (ret) {
+		netdev_err(ndev, "unable to get IRQ %d (errno=%d).\n",
+			   ndev->irq, ret);
+		return ret;
+	}
+
+	mutex_lock(&ax_local->spi_lock);
+
+	ret = ax88796c_soft_reset(ax_local);
+	if (ret < 0) {
+		mutex_unlock(&ax_local->spi_lock);
+		return ret;
+	}
+	ax_local->seq_num = 0x1f;
+
+	ax88796c_set_mac_addr(ndev);
+	ax88796c_set_csums(ax_local);
+
+	/* Disable stuffing packet */
+	AX_WRITE(&ax_local->ax_spi,
+		 AX_READ(&ax_local->ax_spi, P1_RXBSPCR)
+		 & ~RXBSPCR_STUF_ENABLE, P1_RXBSPCR);
+
+	/* Enable RX packet process */
+	AX_WRITE(&ax_local->ax_spi, RPPER_RXEN, P1_RPPER);
+
+	AX_WRITE(&ax_local->ax_spi, AX_READ(&ax_local->ax_spi, P0_FER)
+		 | FER_RXEN | FER_TXEN | FER_BSWAP | FER_IRQ_PULL, P0_FER);
+
+	/* Setup LED mode */
+	AX_WRITE(&ax_local->ax_spi,
+		 (LCR_LED0_EN | LCR_LED0_DUPLEX | LCR_LED1_EN |
+		 LCR_LED1_100MODE), P2_LCR0);
+	AX_WRITE(&ax_local->ax_spi,
+		 (AX_READ(&ax_local->ax_spi, P2_LCR1) & LCR_LED2_MASK) |
+		 LCR_LED2_EN | LCR_LED2_LINK, P2_LCR1);
+
+	/* Disable PHY auto-polling */
+	AX_WRITE(&ax_local->ax_spi, PCR_PHYID(AX88796C_PHY_ID), P2_PCR);
+
+	/* Enable MAC interrupts */
+	AX_WRITE(&ax_local->ax_spi, IMR_DEFAULT, P0_IMR);
+
+	mutex_unlock(&ax_local->spi_lock);
+
+	/* Setup flow-control configuration */
+	phy_support_asym_pause(ax_local->phydev);
+
+	if (ax_local->phydev->advertising &&
+	    (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			       ax_local->phydev->advertising) ||
+	     linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			       ax_local->phydev->advertising)))
+		fc |= AX_FC_ANEG;
+
+	fc |= linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+				ax_local->phydev->advertising) ? AX_FC_RX : 0;
+	fc |= (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+				 ax_local->phydev->advertising) !=
+	       linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+				 ax_local->phydev->advertising)) ? AX_FC_TX : 0;
+	ax_local->flowctrl = fc;
+
+	phy_start(ax_local->ndev->phydev);
+
+	netif_start_queue(ndev);
+
+	spi_message_init(&ax_local->ax_spi.rx_msg);
+
+	return 0;
+}
+
+static void ax88796c_free_skb_queue(struct sk_buff_head *q)
+{
+	struct sk_buff *skb;
+
+	while (q->qlen) {
+		skb = skb_dequeue(q);
+		kfree_skb(skb);
+	}
+}
+
+static int
+ax88796c_close(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+
+	netif_stop_queue(ndev);
+	phy_stop(ndev->phydev);
+
+	mutex_lock(&ax_local->spi_lock);
+
+	/* Disable MAC interrupts */
+	AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
+	ax88796c_free_skb_queue(&ax_local->tx_wait_q);
+	ax88796c_soft_reset(ax_local);
+
+	mutex_unlock(&ax_local->spi_lock);
+
+	free_irq(ndev->irq, ndev);
+
+	return 0;
+}
+
+static int
+ax88796c_set_features(struct net_device *ndev, netdev_features_t features)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	netdev_features_t changed = features ^ ndev->features;
+
+	if (!(changed & (NETIF_F_RXCSUM | NETIF_F_HW_CSUM)))
+		return 0;
+
+	ndev->features = features;
+
+	if (changed & (NETIF_F_RXCSUM | NETIF_F_HW_CSUM))
+		ax88796c_set_csums(ax_local);
+
+	return 0;
+}
+
+static const struct net_device_ops ax88796c_netdev_ops = {
+	.ndo_open		= ax88796c_open,
+	.ndo_stop		= ax88796c_close,
+	.ndo_start_xmit		= ax88796c_start_xmit,
+	.ndo_get_stats		= ax88796c_get_stats,
+	.ndo_do_ioctl		= ax88796c_ioctl,
+	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_set_features	= ax88796c_set_features,
+};
+
+static int ax88796c_hard_reset(struct ax88796c_device *ax_local)
+{
+	struct device *dev = (struct device *)&ax_local->spi->dev;
+	struct gpio_desc *reset_gpio;
+
+	/* reset info */
+	reset_gpio = gpiod_get(dev, "reset", 0);
+	if (IS_ERR(reset_gpio)) {
+		dev_err(dev, "Could not get 'reset' GPIO: %ld", PTR_ERR(reset_gpio));
+		return PTR_ERR(reset_gpio);
+	}
+
+	/* set reset */
+	gpiod_direction_output(reset_gpio, 1);
+	msleep(100);
+	gpiod_direction_output(reset_gpio, 0);
+	gpiod_put(reset_gpio);
+	msleep(20);
+
+	return 0;
+}
+
+static int ax88796c_probe(struct spi_device *spi)
+{
+	char phy_id[MII_BUS_ID_SIZE + 3];
+	struct ax88796c_device *ax_local;
+	struct net_device *ndev;
+	u16 temp;
+	int ret;
+
+	ndev = devm_alloc_etherdev(&spi->dev, sizeof(*ax_local));
+	if (!ndev)
+		return -ENOMEM;
+
+	SET_NETDEV_DEV(ndev, &spi->dev);
+
+	ax_local = to_ax88796c_device(ndev);
+	memset(ax_local, 0, sizeof(*ax_local));
+
+	dev_set_drvdata(&spi->dev, ax_local);
+	ax_local->spi = spi;
+	ax_local->ax_spi.spi = spi;
+
+	ax_local->ndev = ndev;
+	ax_local->capabilities |= comp ? AX_CAP_COMP : 0;
+	ax_local->msg_enable = msg_enable;
+	mutex_init(&ax_local->spi_lock);
+
+	ax_local->mdiobus = devm_mdiobus_alloc(&spi->dev);
+	if (!ax_local->mdiobus)
+		return -ENOMEM;
+
+	ax_local->mdiobus->priv = ax_local;
+	ax_local->mdiobus->read = ax88796c_mdio_read;
+	ax_local->mdiobus->write = ax88796c_mdio_write;
+	ax_local->mdiobus->name = "ax88976c-mdiobus";
+	ax_local->mdiobus->phy_mask = ~BIT(AX88796C_PHY_ID);
+	ax_local->mdiobus->parent = &spi->dev;
+
+	snprintf(ax_local->mdiobus->id, MII_BUS_ID_SIZE,
+		 "ax88796c-%s.%u", dev_name(&spi->dev), spi->chip_select);
+
+	ret = devm_mdiobus_register(&spi->dev, ax_local->mdiobus);
+	if (ret < 0) {
+		dev_err(&spi->dev, "Could not register MDIO bus\n");
+		return ret;
+	}
+
+	if (netif_msg_probe(ax_local)) {
+		dev_info(&spi->dev, "AX88796C-SPI Configuration:\n");
+		dev_info(&spi->dev, "    Compression : %s\n",
+			 ax_local->capabilities & AX_CAP_COMP ? "ON" : "OFF");
+	}
+
+	ndev->irq = spi->irq;
+	ndev->netdev_ops = &ax88796c_netdev_ops;
+	ndev->ethtool_ops = &ax88796c_ethtool_ops;
+	ndev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	ndev->features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	ndev->hard_header_len += (TX_OVERHEAD + 4);
+
+	mutex_lock(&ax_local->spi_lock);
+
+	/* ax88796c gpio reset */
+	ax88796c_hard_reset(ax_local);
+
+	/* Reset AX88796C */
+	ret = ax88796c_soft_reset(ax_local);
+	if (ret < 0) {
+		ret = -ENODEV;
+		goto err;
+	}
+	/* Check board revision */
+	temp = AX_READ(&ax_local->ax_spi, P2_CRIR);
+	if ((temp & 0xF) != 0x0) {
+		dev_err(&spi->dev, "spi read failed: %d\n", temp);
+		ret = -ENODEV;
+		goto err;
+	}
+
+	temp = AX_READ(&ax_local->ax_spi, P0_BOR);
+	if (temp == 0x1234) {
+		ax_local->plat_endian = PLAT_LITTLE_ENDIAN;
+	} else {
+		AX_WRITE(&ax_local->ax_spi, 0xFFFF, P0_BOR);
+		ax_local->plat_endian = PLAT_BIG_ENDIAN;
+	}
+
+	/*Reload EEPROM*/
+	ax88796c_reload_eeprom(ax_local);
+
+	ax88796c_load_mac_addr(ndev);
+
+	if (netif_msg_probe(ax_local))
+		dev_info(&spi->dev,
+			 "irq %d, MAC addr %02X:%02X:%02X:%02X:%02X:%02X\n",
+			 ndev->irq,
+			 ndev->dev_addr[0], ndev->dev_addr[1],
+			 ndev->dev_addr[2], ndev->dev_addr[3],
+			 ndev->dev_addr[4], ndev->dev_addr[5]);
+
+	/* Disable power saving */
+	AX_WRITE(&ax_local->ax_spi, (AX_READ(&ax_local->ax_spi, P0_PSCR)
+				     & PSCR_PS_MASK) | PSCR_PS_D0, P0_PSCR);
+
+	mutex_unlock(&ax_local->spi_lock);
+
+	INIT_WORK(&ax_local->ax_work, ax88796c_work);
+
+	skb_queue_head_init(&ax_local->tx_wait_q);
+
+	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
+		 ax_local->mdiobus->id, AX88796C_PHY_ID);
+	ax_local->phydev = phy_connect(ax_local->ndev, phy_id,
+				       ax88796c_handle_link_change,
+				       PHY_INTERFACE_MODE_MII);
+	if (IS_ERR(ax_local->phydev)) {
+		ret = PTR_ERR(ax_local->phydev);
+		goto err;
+	}
+	ax_local->phydev->irq = PHY_POLL;
+
+	ret = devm_register_netdev(&spi->dev, ndev);
+	if (ret) {
+		dev_err(&spi->dev, "failed to register a network device\n");
+		goto err_phy_dis;
+	}
+
+	netif_info(ax_local, probe, ndev, "%s %s registered\n",
+		   dev_driver_string(&spi->dev),
+		   dev_name(&spi->dev));
+	phy_attached_info(ax_local->phydev);
+
+	return 0;
+
+err_phy_dis:
+	phy_disconnect(ax_local->phydev);
+err:
+	return ret;
+}
+
+static int ax88796c_remove(struct spi_device *spi)
+{
+	struct ax88796c_device *ax_local = dev_get_drvdata(&spi->dev);
+	struct net_device *ndev = ax_local->ndev;
+
+	phy_disconnect(ndev->phydev);
+
+	netif_info(ax_local, probe, ndev, "removing network device %s %s\n",
+		   dev_driver_string(&spi->dev),
+		   dev_name(&spi->dev));
+
+	return 0;
+}
+
+static const struct of_device_id ax88796c_dt_ids[] = {
+	{ .compatible = "asix,ax88796c" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ax88796c_dt_ids);
+
+static const struct spi_device_id asix_id[] = {
+	{ "ax88796c", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, asix_id);
+
+static struct spi_driver ax88796c_spi_driver = {
+	.driver = {
+		.name = DRV_NAME,
+		.of_match_table = of_match_ptr(ax88796c_dt_ids),
+	},
+	.probe = ax88796c_probe,
+	.remove = ax88796c_remove,
+	.id_table = asix_id,
+};
+
+static __init int ax88796c_spi_init(void)
+{
+	int ret;
+
+	bitmap_zero(ax88796c_no_regs_mask, AX88796C_REGDUMP_LEN);
+	ret = bitmap_parse(no_regs_list, 35,
+			   ax88796c_no_regs_mask, AX88796C_REGDUMP_LEN);
+	if (ret) {
+		bitmap_fill(ax88796c_no_regs_mask, AX88796C_REGDUMP_LEN);
+		pr_err("Invalid bitmap description, masking all registers\n");
+	}
+
+	return spi_register_driver(&ax88796c_spi_driver);
+}
+
+static __exit void ax88796c_spi_exit(void)
+{
+	spi_unregister_driver(&ax88796c_spi_driver);
+}
+
+module_init(ax88796c_spi_init);
+module_exit(ax88796c_spi_exit);
+
+MODULE_AUTHOR("ASIX");
+MODULE_DESCRIPTION("ASIX AX88796C SPI Ethernet driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/asix/ax88796c_main.h b/drivers/net/ethernet/asix/ax88796c_main.h
new file mode 100644
index 000000000000..229906d5737f
--- /dev/null
+++ b/drivers/net/ethernet/asix/ax88796c_main.h
@@ -0,0 +1,561 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2010 ASIX Electronics Corporation
+ * Copyright (c) 2020 Samsung Electronics
+ *
+ * ASIX AX88796C SPI Fast Ethernet Linux driver
+ */
+
+#ifndef _AX88796C_MAIN_H
+#define _AX88796C_MAIN_H
+
+#include <linux/netdevice.h>
+#include <linux/mii.h>
+
+#include "ax88796c_spi.h"
+
+/* These identify the driver base version and may not be removed. */
+#define DRV_NAME	"ax88796c"
+#define ADP_NAME	"ASIX AX88796C SPI Ethernet Adapter"
+
+#define TX_QUEUE_HIGH_WATER		45	/* Tx queue high water mark */
+#define TX_QUEUE_LOW_WATER		20	/* Tx queue low water mark */
+
+#define AX88796C_REGDUMP_LEN		256
+#define AX88796C_PHY_REGDUMP_LEN	14
+#define AX88796C_PHY_ID			0x10
+
+#define TX_OVERHEAD			8
+#define TX_EOP_SIZE			4
+
+#define AX_MCAST_FILTER_SIZE		8
+#define AX_MAX_MCAST			64
+#define AX_MAX_CLK                      80000000
+#define TX_HDR_SOP_DICF			0x8000
+#define TX_HDR_SOP_CPHI			0x4000
+#define TX_HDR_SOP_INT			0x2000
+#define TX_HDR_SOP_MDEQ			0x1000
+#define TX_HDR_SOP_PKTLEN		0x07FF
+#define TX_HDR_SOP_SEQNUM		0xF800
+#define TX_HDR_SOP_PKTLENBAR		0x07FF
+
+#define TX_HDR_SEG_FS			0x8000
+#define TX_HDR_SEG_LS			0x4000
+#define TX_HDR_SEG_SEGNUM		0x3800
+#define TX_HDR_SEG_SEGLEN		0x0700
+#define TX_HDR_SEG_EOFST		0xC000
+#define TX_HDR_SEG_SOFST		0x3800
+#define TX_HDR_SEG_SEGLENBAR		0x07FF
+
+#define TX_HDR_EOP_SEQNUM		0xF800
+#define TX_HDR_EOP_PKTLEN		0x07FF
+#define TX_HDR_EOP_SEQNUMBAR		0xF800
+#define TX_HDR_EOP_PKTLENBAR		0x07FF
+
+/* Rx header fields mask */
+#define RX_HDR1_MCBC			0x8000
+#define RX_HDR1_STUFF_PKT		0x4000
+#define RX_HDR1_MII_ERR			0x2000
+#define RX_HDR1_CRC_ERR			0x1000
+#define RX_HDR1_PKT_LEN			0x07FF
+
+#define RX_HDR2_SEQ_NUM			0xF800
+#define RX_HDR2_PKT_LEN_BAR		0x7FFF
+
+#define RX_HDR3_PE			0x8000
+#define RX_HDR3_L3_TYPE_IPV4V6		0x6000
+#define RX_HDR3_L3_TYPE_IP		0x4000
+#define RX_HDR3_L3_TYPE_IPV6		0x2000
+#define RX_HDR3_L4_TYPE_ICMPV6		0x1400
+#define RX_HDR3_L4_TYPE_TCP		0x1000
+#define RX_HDR3_L4_TYPE_IGMP		0x0c00
+#define RX_HDR3_L4_TYPE_ICMP		0x0800
+#define RX_HDR3_L4_TYPE_UDP		0x0400
+#define RX_HDR3_L3_ERR			0x0200
+#define RX_HDR3_L4_ERR			0x0100
+#define RX_HDR3_PRIORITY(x)		((x) << 4)
+#define RX_HDR3_STRIP			0x0008
+#define RX_HDR3_VLAN_ID			0x0007
+
+struct ax88796c_device {
+	struct spi_device	*spi;
+	struct net_device	*ndev;
+	struct net_device_stats	stats;
+
+	struct work_struct	ax_work;
+
+	struct mutex		spi_lock; /* device access */
+
+	struct sk_buff_head	tx_wait_q;
+
+	struct axspi_data	ax_spi;
+
+	struct mii_bus		*mdiobus;
+	struct phy_device	*phydev;
+
+	int			msg_enable;
+
+	u16			seq_num;
+
+	u8			multi_filter[AX_MCAST_FILTER_SIZE];
+
+	int			link;
+	int			speed;
+	int			duplex;
+	int			pause;
+	int			asym_pause;
+	int			flowctrl;
+		#define AX_FC_NONE		0
+		#define AX_FC_RX		BIT(0)
+		#define AX_FC_TX		BIT(1)
+		#define AX_FC_ANEG		BIT(2)
+
+	unsigned long		capabilities;
+		#define AX_CAP_COMP		BIT(0)
+
+	u8			plat_endian;
+		#define PLAT_LITTLE_ENDIAN	0
+		#define PLAT_BIG_ENDIAN		1
+
+	unsigned long		flags;
+		#define EVENT_INTR		BIT(0)
+		#define EVENT_TX		BIT(1)
+		#define EVENT_SET_MULTI		BIT(2)
+
+};
+
+#define to_ax88796c_device(ndev) ((struct ax88796c_device *)netdev_priv(ndev))
+
+enum skb_state {
+	illegal = 0,
+	tx_done,
+	rx_done,
+	rx_err,
+};
+
+struct skb_data {
+	enum skb_state state;
+	struct net_device *ndev;
+	struct sk_buff *skb;
+	size_t len;
+};
+
+/* A88796C register definition */
+	/* Definition of PAGE0 */
+#define P0_PSR		(0x00)
+	#define PSR_DEV_READY		BIT(7)
+	#define PSR_RESET		(0 << 15)
+	#define PSR_RESET_CLR		BIT(15)
+#define P0_BOR		(0x02)
+#define P0_FER		(0x04)
+	#define FER_IPALM		BIT(0)
+	#define FER_DCRC		BIT(1)
+	#define FER_RH3M		BIT(2)
+	#define FER_HEADERSWAP		BIT(7)
+	#define FER_WSWAP		BIT(8)
+	#define FER_BSWAP		BIT(9)
+	#define FER_INTHI		BIT(10)
+	#define FER_INTLO		(0 << 10)
+	#define FER_IRQ_PULL		BIT(11)
+	#define FER_RXEN		BIT(14)
+	#define FER_TXEN		BIT(15)
+#define P0_ISR		(0x06)
+	#define ISR_RXPKT		BIT(0)
+	#define ISR_MDQ			BIT(4)
+	#define ISR_TXT			BIT(5)
+	#define ISR_TXPAGES		BIT(6)
+	#define ISR_TXERR		BIT(8)
+	#define ISR_LINK		BIT(9)
+#define P0_IMR		(0x08)
+	#define IMR_RXPKT		BIT(0)
+	#define IMR_MDQ			BIT(4)
+	#define IMR_TXT			BIT(5)
+	#define IMR_TXPAGES		BIT(6)
+	#define IMR_TXERR		BIT(8)
+	#define IMR_LINK		BIT(9)
+	#define IMR_MASKALL		(0xFFFF)
+	#define IMR_DEFAULT		(IMR_TXERR)
+#define P0_WFCR		(0x0A)
+	#define WFCR_PMEIND		BIT(0) /* PME indication */
+	#define WFCR_PMETYPE		BIT(1) /* PME I/O type */
+	#define WFCR_PMEPOL		BIT(2) /* PME polarity */
+	#define WFCR_PMERST		BIT(3) /* Reset PME */
+	#define WFCR_SLEEP		BIT(4) /* Enable sleep mode */
+	#define WFCR_WAKEUP		BIT(5) /* Enable wakeup mode */
+	#define WFCR_WAITEVENT		BIT(6) /* Reserved */
+	#define WFCR_CLRWAKE		BIT(7) /* Clear wakeup */
+	#define WFCR_LINKCH		BIT(8) /* Enable link change */
+	#define WFCR_MAGICP		BIT(9) /* Enable magic packet */
+	#define WFCR_WAKEF		BIT(10) /* Enable wakeup frame */
+	#define WFCR_PMEEN		BIT(11) /* Enable PME pin */
+	#define WFCR_LINKCHS		BIT(12) /* Link change status */
+	#define WFCR_MAGICPS		BIT(13) /* Magic packet status */
+	#define WFCR_WAKEFS		BIT(14) /* Wakeup frame status */
+	#define WFCR_PMES		BIT(15) /* PME pin status */
+#define P0_PSCR		(0x0C)
+	#define PSCR_PS_MASK		(0xFFF0)
+	#define PSCR_PS_D0		(0)
+	#define PSCR_PS_D1		BIT(0)
+	#define PSCR_PS_D2		BIT(1)
+	#define PSCR_FPS		BIT(3) /* Enable fiber mode PS */
+	#define PSCR_SWPS		BIT(4) /* Enable software */
+						 /* PS control */
+	#define PSCR_WOLPS		BIT(5) /* Enable WOL PS */
+	#define PSCR_SWWOL		BIT(6) /* Enable software select */
+						 /* WOL PS */
+	#define PSCR_PHYOSC		BIT(7) /* Internal PHY OSC control */
+	#define PSCR_FOFEF		BIT(8) /* Force PHY generate FEF */
+	#define PSCR_FOF		BIT(9) /* Force PHY in fiber mode */
+	#define PSCR_PHYPD		BIT(10) /* PHY power down. */
+						  /* Active high */
+	#define PSCR_PHYRST		BIT(11) /* PHY reset signal. */
+						  /* Active low */
+	#define PSCR_PHYCSIL		BIT(12) /* PHY cable energy detect */
+	#define PSCR_PHYCOFF		BIT(13) /* PHY cable off */
+	#define PSCR_PHYLINK		BIT(14) /* PHY link status */
+	#define PSCR_EEPOK		BIT(15) /* EEPROM load complete */
+#define P0_MACCR	(0x0E)
+	#define MACCR_RXEN		BIT(0) /* Enable RX */
+	#define MACCR_DUPLEX_FULL	BIT(1) /* 1: Full, 0: Half */
+	#define MACCR_SPEED_100		BIT(2) /* 1: 100Mbps, 0: 10Mbps */
+	#define MACCR_RXFC_ENABLE	BIT(3)
+	#define MACCR_RXFC_MASK		0xFFF7
+	#define MACCR_TXFC_ENABLE	BIT(4)
+	#define MACCR_TXFC_MASK		0xFFEF
+	#define MACCR_PSI		BIT(6) /* Software Cable-Off */
+					       /* Power Saving Interrupt */
+	#define MACCR_PF		BIT(7)
+	#define MACCR_PMM_BITS		8
+	#define MACCR_PMM_MASK		(0x1F00)
+	#define MACCR_PMM_RESET		BIT(8)
+	#define MACCR_PMM_WAIT		(2 << 8)
+	#define MACCR_PMM_READY		(3 << 8)
+	#define MACCR_PMM_D1		(4 << 8)
+	#define MACCR_PMM_D2		(5 << 8)
+	#define MACCR_PMM_WAKE		(7 << 8)
+	#define MACCR_PMM_D1_WAKE	(8 << 8)
+	#define MACCR_PMM_D2_WAKE	(9 << 8)
+	#define MACCR_PMM_SLEEP		(10 << 8)
+	#define MACCR_PMM_PHY_RESET	(11 << 8)
+	#define MACCR_PMM_SOFT_D1	(16 << 8)
+	#define MACCR_PMM_SOFT_D2	(17 << 8)
+#define P0_TFBFCR	(0x10)
+	#define TFBFCR_SCHE_FREE_PAGE	0xE07F
+	#define TFBFCR_FREE_PAGE_BITS	0x07
+	#define TFBFCR_FREE_PAGE_LATCH	BIT(6)
+	#define TFBFCR_SET_FREE_PAGE(x)	(((x) & 0x3F) << TFBFCR_FREE_PAGE_BITS)
+	#define TFBFCR_TX_PAGE_SET	BIT(13)
+	#define TFBFCR_MANU_ENTX	BIT(15)
+	#define TX_FREEBUF_MASK		0x003F
+	#define TX_DPTSTART		0x4000
+
+#define P0_TSNR		(0x12)
+	#define TXNR_TXB_ERR		BIT(5)
+	#define TXNR_TXB_IDLE		BIT(6)
+	#define TSNR_PKT_CNT(x)		(((x) & 0x3F) << 8)
+	#define TXNR_TXB_REINIT		BIT(14)
+	#define TSNR_TXB_START		BIT(15)
+#define P0_RTDPR	(0x14)
+#define P0_RXBCR1	(0x16)
+	#define RXBCR1_RXB_DISCARD	BIT(14)
+	#define RXBCR1_RXB_START	BIT(15)
+#define P0_RXBCR2	(0x18)
+	#define RXBCR2_PKT_MASK		(0xFF)
+	#define RXBCR2_RXPC_MASK	(0x7F)
+	#define RXBCR2_RXB_READY	BIT(13)
+	#define RXBCR2_RXB_IDLE		BIT(14)
+	#define RXBCR2_RXB_REINIT	BIT(15)
+#define P0_RTWCR	(0x1A)
+	#define RTWCR_RXWC_MASK		(0x3FFF)
+	#define RTWCR_RX_LATCH		BIT(15)
+#define P0_RCPHR	(0x1C)
+
+	/* Definition of PAGE1 */
+#define P1_RPPER	(0x22)
+	#define RPPER_RXEN		BIT(0)
+#define P1_MRCR		(0x28)
+#define P1_MDR		(0x2A)
+#define P1_RMPR		(0x2C)
+#define P1_TMPR		(0x2E)
+#define P1_RXBSPCR	(0x30)
+	#define RXBSPCR_STUF_WORD_CNT(x)	(((x) & 0x7000) >> 12)
+	#define RXBSPCR_STUF_ENABLE		BIT(15)
+#define P1_MCR		(0x32)
+	#define MCR_SBP			BIT(8)
+	#define MCR_SM			BIT(9)
+	#define MCR_CRCENLAN		BIT(11)
+	#define MCR_STP			BIT(12)
+	/* Definition of PAGE2 */
+#define P2_CIR		(0x42)
+#define P2_PCR		(0x44)
+	#define PCR_POLL_EN		BIT(0)
+	#define PCR_POLL_FLOWCTRL	BIT(1)
+	#define PCR_POLL_BMCR		BIT(2)
+	#define PCR_PHYID(x)		((x) << 8)
+#define P2_PHYSR	(0x46)
+#define P2_MDIODR	(0x48)
+#define P2_MDIOCR	(0x4A)
+	#define MDIOCR_RADDR(x)		((x) & 0x1F)
+	#define MDIOCR_FADDR(x)		(((x) & 0x1F) << 8)
+	#define MDIOCR_VALID		BIT(13)
+	#define MDIOCR_READ		BIT(14)
+	#define MDIOCR_WRITE		BIT(15)
+#define P2_LCR0		(0x4C)
+	#define LCR_LED0_EN		BIT(0)
+	#define LCR_LED0_100MODE	BIT(1)
+	#define LCR_LED0_DUPLEX		BIT(2)
+	#define LCR_LED0_LINK		BIT(3)
+	#define LCR_LED0_ACT		BIT(4)
+	#define LCR_LED0_COL		BIT(5)
+	#define LCR_LED0_10MODE		BIT(6)
+	#define LCR_LED0_DUPCOL		BIT(7)
+	#define LCR_LED1_EN		BIT(8)
+	#define LCR_LED1_100MODE	BIT(9)
+	#define LCR_LED1_DUPLEX		BIT(10)
+	#define LCR_LED1_LINK		BIT(11)
+	#define LCR_LED1_ACT		BIT(12)
+	#define LCR_LED1_COL		BIT(13)
+	#define LCR_LED1_10MODE		BIT(14)
+	#define LCR_LED1_DUPCOL		BIT(15)
+#define P2_LCR1		(0x4E)
+	#define LCR_LED2_MASK		(0xFF00)
+	#define LCR_LED2_EN		BIT(0)
+	#define LCR_LED2_100MODE	BIT(1)
+	#define LCR_LED2_DUPLEX		BIT(2)
+	#define LCR_LED2_LINK		BIT(3)
+	#define LCR_LED2_ACT		BIT(4)
+	#define LCR_LED2_COL		BIT(5)
+	#define LCR_LED2_10MODE		BIT(6)
+	#define LCR_LED2_DUPCOL		BIT(7)
+#define P2_IPGCR	(0x50)
+#define P2_CRIR		(0x52)
+#define P2_FLHWCR	(0x54)
+#define P2_RXCR		(0x56)
+	#define RXCR_PRO		BIT(0)
+	#define RXCR_AMALL		BIT(1)
+	#define RXCR_SEP		BIT(2)
+	#define RXCR_AB			BIT(3)
+	#define RXCR_AM			BIT(4)
+	#define RXCR_AP			BIT(5)
+	#define RXCR_ARP		BIT(6)
+#define P2_JLCR		(0x58)
+#define P2_MPLR		(0x5C)
+
+	/* Definition of PAGE3 */
+#define P3_MACASR0	(0x62)
+	#define P3_MACASR(x)		(P3_MACASR0 + 2 * (x))
+	#define MACASR_LOWBYTE_MASK	0x00FF
+	#define MACASR_HIGH_BITS	0x08
+#define P3_MACASR1	(0x64)
+#define P3_MACASR2	(0x66)
+#define P3_MFAR01	(0x68)
+#define P3_MFAR_BASE	(0x68)
+	#define P3_MFAR(x)		(P3_MFAR_BASE + 2 * (x))
+
+#define P3_MFAR23	(0x6A)
+#define P3_MFAR45	(0x6C)
+#define P3_MFAR67	(0x6E)
+#define P3_VID0FR	(0x70)
+#define P3_VID1FR	(0x72)
+#define P3_EECSR	(0x74)
+#define P3_EEDR		(0x76)
+#define P3_EECR		(0x78)
+	#define EECR_ADDR_MASK		(0x00FF)
+	#define EECR_READ_ACT		BIT(8)
+	#define EECR_WRITE_ACT		BIT(9)
+	#define EECR_WRITE_DISABLE	BIT(10)
+	#define EECR_WRITE_ENABLE	BIT(11)
+	#define EECR_EE_READY		BIT(13)
+	#define EECR_RELOAD		BIT(14)
+	#define EECR_RESET		BIT(15)
+#define P3_TPCR		(0x7A)
+	#define TPCR_PATT_MASK		(0xFF)
+	#define TPCR_RAND_PKT_EN	BIT(14)
+	#define TPCR_FIXED_PKT_EN	BIT(15)
+#define P3_TPLR		(0x7C)
+	/* Definition of PAGE4 */
+#define P4_SPICR	(0x8A)
+	#define SPICR_RCEN		BIT(0)
+	#define SPICR_QCEN		BIT(1)
+	#define SPICR_RBRE		BIT(3)
+	#define SPICR_PMM		BIT(4)
+	#define SPICR_LOOPBACK		BIT(8)
+	#define SPICR_CORE_RES_CLR	BIT(10)
+	#define SPICR_SPI_RES_CLR	BIT(11)
+#define P4_SPIISMR	(0x8C)
+
+#define P4_COERCR0	(0x92)
+	#define COERCR0_RXIPCE		BIT(0)
+	#define COERCR0_RXIPVE		BIT(1)
+	#define COERCR0_RXV6PE		BIT(2)
+	#define COERCR0_RXTCPE		BIT(3)
+	#define COERCR0_RXUDPE		BIT(4)
+	#define COERCR0_RXICMP		BIT(5)
+	#define COERCR0_RXIGMP		BIT(6)
+	#define COERCR0_RXICV6		BIT(7)
+
+	#define COERCR0_RXTCPV6		BIT(8)
+	#define COERCR0_RXUDPV6		BIT(9)
+	#define COERCR0_RXICMV6		BIT(10)
+	#define COERCR0_RXIGMV6		BIT(11)
+	#define COERCR0_RXICV6V6	BIT(12)
+
+	#define COERCR0_DEFAULT		(COERCR0_RXIPCE | COERCR0_RXV6PE | \
+					 COERCR0_RXTCPE | COERCR0_RXUDPE | \
+					 COERCR0_RXTCPV6 | COERCR0_RXUDPV6)
+#define P4_COERCR1	(0x94)
+	#define COERCR1_IPCEDP		BIT(0)
+	#define COERCR1_IPVEDP		BIT(1)
+	#define COERCR1_V6VEDP		BIT(2)
+	#define COERCR1_TCPEDP		BIT(3)
+	#define COERCR1_UDPEDP		BIT(4)
+	#define COERCR1_ICMPDP		BIT(5)
+	#define COERCR1_IGMPDP		BIT(6)
+	#define COERCR1_ICV6DP		BIT(7)
+	#define COERCR1_RX64TE		BIT(8)
+	#define COERCR1_RXPPPE		BIT(9)
+	#define COERCR1_TCP6DP		BIT(10)
+	#define COERCR1_UDP6DP		BIT(11)
+	#define COERCR1_IC6DP		BIT(12)
+	#define COERCR1_IG6DP		BIT(13)
+	#define COERCR1_ICV66DP		BIT(14)
+	#define COERCR1_RPCE		BIT(15)
+
+	#define COERCR1_DEFAULT		(COERCR1_RXPPPE)
+
+#define P4_COETCR0	(0x96)
+	#define COETCR0_TXIP		BIT(0)
+	#define COETCR0_TXTCP		BIT(1)
+	#define COETCR0_TXUDP		BIT(2)
+	#define COETCR0_TXICMP		BIT(3)
+	#define COETCR0_TXIGMP		BIT(4)
+	#define COETCR0_TXICV6		BIT(5)
+	#define COETCR0_TXTCPV6		BIT(8)
+	#define COETCR0_TXUDPV6		BIT(9)
+	#define COETCR0_TXICMV6		BIT(10)
+	#define COETCR0_TXIGMV6		BIT(11)
+	#define COETCR0_TXICV6V6	BIT(12)
+
+	#define COETCR0_DEFAULT		(COETCR0_TXIP | COETCR0_TXTCP | \
+					 COETCR0_TXUDP | COETCR0_TXTCPV6 | \
+					 COETCR0_TXUDPV6)
+#define P4_COETCR1	(0x98)
+	#define COETCR1_TX64TE		BIT(0)
+	#define COETCR1_TXPPPE		BIT(1)
+
+#define P4_COECEDR	(0x9A)
+#define P4_L2CECR	(0x9C)
+
+	/* Definition of PAGE5 */
+#define P5_WFTR		(0xA2)
+	#define WFTR_2MS		(0x01)
+	#define WFTR_4MS		(0x02)
+	#define WFTR_8MS		(0x03)
+	#define WFTR_16MS		(0x04)
+	#define WFTR_32MS		(0x05)
+	#define WFTR_64MS		(0x06)
+	#define WFTR_128MS		(0x07)
+	#define WFTR_256MS		(0x08)
+	#define WFTR_512MS		(0x09)
+	#define WFTR_1024MS		(0x0A)
+	#define WFTR_2048MS		(0x0B)
+	#define WFTR_4096MS		(0x0C)
+	#define WFTR_8192MS		(0x0D)
+	#define WFTR_16384MS		(0x0E)
+	#define WFTR_32768MS		(0x0F)
+#define P5_WFCCR	(0xA4)
+#define P5_WFCR03	(0xA6)
+	#define WFCR03_F0_EN		BIT(0)
+	#define WFCR03_F1_EN		BIT(4)
+	#define WFCR03_F2_EN		BIT(8)
+	#define WFCR03_F3_EN		BIT(12)
+#define P5_WFCR47	(0xA8)
+	#define WFCR47_F4_EN		BIT(0)
+	#define WFCR47_F5_EN		BIT(4)
+	#define WFCR47_F6_EN		BIT(8)
+	#define WFCR47_F7_EN		BIT(12)
+#define P5_WF0BMR0	(0xAA)
+#define P5_WF0BMR1	(0xAC)
+#define P5_WF0CR	(0xAE)
+#define P5_WF0OBR	(0xB0)
+#define P5_WF1BMR0	(0xB2)
+#define P5_WF1BMR1	(0xB4)
+#define P5_WF1CR	(0xB6)
+#define P5_WF1OBR	(0xB8)
+#define P5_WF2BMR0	(0xBA)
+#define P5_WF2BMR1	(0xBC)
+
+	/* Definition of PAGE6 */
+#define P6_WF2CR	(0xC2)
+#define P6_WF2OBR	(0xC4)
+#define P6_WF3BMR0	(0xC6)
+#define P6_WF3BMR1	(0xC8)
+#define P6_WF3CR	(0xCA)
+#define P6_WF3OBR	(0xCC)
+#define P6_WF4BMR0	(0xCE)
+#define P6_WF4BMR1	(0xD0)
+#define P6_WF4CR	(0xD2)
+#define P6_WF4OBR	(0xD4)
+#define P6_WF5BMR0	(0xD6)
+#define P6_WF5BMR1	(0xD8)
+#define P6_WF5CR	(0xDA)
+#define P6_WF5OBR	(0xDC)
+
+/* Definition of PAGE7 */
+#define P7_WF6BMR0	(0xE2)
+#define P7_WF6BMR1	(0xE4)
+#define P7_WF6CR	(0xE6)
+#define P7_WF6OBR	(0xE8)
+#define P7_WF7BMR0	(0xEA)
+#define P7_WF7BMR1	(0xEC)
+#define P7_WF7CR	(0xEE)
+#define P7_WF7OBR	(0xF0)
+#define P7_WFR01	(0xF2)
+#define P7_WFR23	(0xF4)
+#define P7_WFR45	(0xF6)
+#define P7_WFR67	(0xF8)
+#define P7_WFPC0	(0xFA)
+#define P7_WFPC1	(0xFC)
+
+/* Tx headers structure */
+struct tx_sop_header {
+	/* bit 15-11: flags, bit 10-0: packet length */
+	u16 flags_len;
+	/* bit 15-11: sequence number, bit 11-0: packet length bar */
+	u16 seq_lenbar;
+} __packed;
+
+struct tx_segment_header {
+	/* bit 15-14: flags, bit 13-11: segment number */
+	/* bit 10-0: segment length */
+	u16 flags_seqnum_seglen;
+	/* bit 15-14: end offset, bit 13-11: start offset */
+	/* bit 10-0: segment length bar */
+	u16 eo_so_seglenbar;
+} __packed;
+
+struct tx_eop_header {
+	/* bit 15-11: sequence number, bit 10-0: packet length */
+	u16 seq_len;
+	/* bit 15-11: sequence number bar, bit 10-0: packet length bar */
+	u16 seqbar_lenbar;
+} __packed;
+
+struct tx_pkt_info {
+	struct tx_sop_header sop;
+	struct tx_segment_header seg;
+	struct tx_eop_header eop;
+	u16 pkt_len;
+	u16 seq_num;
+} __packed;
+
+/* Rx headers structure */
+struct rx_header {
+	u16 flags_len;
+	u16 seq_lenbar;
+	u16 flags;
+} __packed;
+
+extern unsigned long ax88796c_no_regs_mask[];
+
+#endif /* #ifndef _AX88796C_MAIN_H */
diff --git a/drivers/net/ethernet/asix/ax88796c_spi.c b/drivers/net/ethernet/asix/ax88796c_spi.c
new file mode 100644
index 000000000000..1f2e20d88557
--- /dev/null
+++ b/drivers/net/ethernet/asix/ax88796c_spi.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2010 ASIX Electronics Corporation
+ * Copyright (c) 2020 Samsung Electronics Co., Ltd.
+ *
+ * ASIX AX88796C SPI Fast Ethernet Linux driver
+ */
+
+#define pr_fmt(fmt)	"ax88796c: " fmt
+
+#include <linux/string.h>
+#include <linux/spi/spi.h>
+
+#include "ax88796c_spi.h"
+
+/* driver bus management functions */
+int axspi_wakeup(struct axspi_data *ax_spi)
+{
+	int ret;
+
+	ax_spi->cmd_buf[0] = AX_SPICMD_EXIT_PWD;	/* OP */
+	ret = spi_write(ax_spi->spi, ax_spi->cmd_buf, 1);
+	if (ret)
+		dev_err(&ax_spi->spi->dev, "%s() failed: ret = %d\n", __func__, ret);
+	return ret;
+}
+
+int axspi_read_status(struct axspi_data *ax_spi, struct spi_status *status)
+{
+	int ret;
+
+	/* OP */
+	ax_spi->cmd_buf[0] = AX_SPICMD_READ_STATUS;
+	ret = spi_write_then_read(ax_spi->spi, ax_spi->cmd_buf, 1, (u8 *)&status, 3);
+	if (ret)
+		dev_err(&ax_spi->spi->dev, "%s() failed: ret = %d\n", __func__, ret);
+	else
+		le16_to_cpus(&status->isr);
+
+	return ret;
+}
+
+int axspi_read_rxq(struct axspi_data *ax_spi, void *data, int len)
+{
+	struct spi_transfer *xfer = ax_spi->spi_rx_xfer;
+	int ret;
+
+	memcpy(ax_spi->cmd_buf, rx_cmd_buf, 5);
+
+	xfer->tx_buf = ax_spi->cmd_buf;
+	xfer->rx_buf = NULL;
+	xfer->len = ax_spi->comp ? 2 : 5;
+	xfer->bits_per_word = 8;
+	spi_message_add_tail(xfer, &ax_spi->rx_msg);
+
+	xfer++;
+	xfer->rx_buf = data;
+	xfer->tx_buf = NULL;
+	xfer->len = len;
+	xfer->bits_per_word = 8;
+	spi_message_add_tail(xfer, &ax_spi->rx_msg);
+	ret = spi_sync(ax_spi->spi, &ax_spi->rx_msg);
+	if (ret)
+		dev_err(&ax_spi->spi->dev, "%s() failed: ret = %d\n", __func__, ret);
+
+	return ret;
+}
+
+int axspi_write_txq(const struct axspi_data *ax_spi, void *data, int len)
+{
+	return spi_write(ax_spi->spi, data, len);
+}
+
+u16 axspi_read_reg(struct axspi_data *ax_spi, u8 reg)
+{
+	int ret;
+	int len = ax_spi->comp ? 3 : 4;
+
+	ax_spi->cmd_buf[0] = 0x03;	/* OP code read register */
+	ax_spi->cmd_buf[1] = reg;	/* register address */
+	ax_spi->cmd_buf[2] = 0xFF;	/* dumy cycle */
+	ax_spi->cmd_buf[3] = 0xFF;	/* dumy cycle */
+	ret = spi_write_then_read(ax_spi->spi,
+				  ax_spi->cmd_buf, len,
+				  ax_spi->rx_buf, 2);
+	if (ret)
+		dev_err(&ax_spi->spi->dev, "%s() failed: ret = %d\n", __func__, ret);
+	else
+		le16_to_cpus(ax_spi->rx_buf);
+
+	return *(u16 *)ax_spi->rx_buf;
+}
+
+int axspi_write_reg(struct axspi_data *ax_spi, u8 reg, u16 value)
+{
+	int ret;
+
+	memset(ax_spi->cmd_buf, 0, sizeof(ax_spi->cmd_buf));
+	ax_spi->cmd_buf[0] = AX_SPICMD_WRITE_REG;	/* OP code read register */
+	ax_spi->cmd_buf[1] = reg;			/* register address */
+	ax_spi->cmd_buf[2] = value;
+	ax_spi->cmd_buf[3] = value >> 8;
+
+	ret = spi_write(ax_spi->spi, ax_spi->cmd_buf, 4);
+	if (ret)
+		dev_err(&ax_spi->spi->dev, "%s() failed: ret = %d\n", __func__, ret);
+	return ret;
+}
+
diff --git a/drivers/net/ethernet/asix/ax88796c_spi.h b/drivers/net/ethernet/asix/ax88796c_spi.h
new file mode 100644
index 000000000000..aa606cc15756
--- /dev/null
+++ b/drivers/net/ethernet/asix/ax88796c_spi.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2010 ASIX Electronics Corporation
+ * Copyright (c) 2020 Samsung Electronics Co., Ltd.
+ *
+ * ASIX AX88796C SPI Fast Ethernet Linux driver
+ */
+
+#ifndef _AX88796C_SPI_H
+#define _AX88796C_SPI_H
+
+#include <linux/spi/spi.h>
+#include <linux/types.h>
+
+/* Definition of SPI command */
+#define AX_SPICMD_WRITE_TXQ		0x02
+#define AX_SPICMD_READ_REG		0x03
+#define AX_SPICMD_READ_STATUS		0x05
+#define AX_SPICMD_READ_RXQ		0x0B
+#define AX_SPICMD_BIDIR_WRQ		0xB2
+#define AX_SPICMD_WRITE_REG		0xD8
+#define AX_SPICMD_EXIT_PWD		0xAB
+
+static const u8 rx_cmd_buf[5] = {AX_SPICMD_READ_RXQ, 0xFF, 0xFF, 0xFF, 0xFF};
+static const u8 tx_cmd_buf[4] = {AX_SPICMD_WRITE_TXQ, 0xFF, 0xFF, 0xFF};
+
+struct axspi_data {
+	struct spi_device	*spi;
+	struct spi_message	rx_msg;
+	struct spi_transfer	spi_rx_xfer[2];
+	u8			cmd_buf[6];
+	u8			rx_buf[6];
+	u8			comp;
+};
+
+struct spi_status {
+	u16 isr;
+	u8 status;
+#	define AX_STATUS_READY		0x80
+};
+
+int axspi_read_rxq(struct axspi_data *ax_spi, void *data, int len);
+int axspi_write_txq(const struct axspi_data *ax_spi, void *data, int len);
+u16 axspi_read_reg(struct axspi_data *ax_spi, u8 reg);
+int axspi_write_reg(struct axspi_data *ax_spi, u8 reg, u16 value);
+int axspi_read_status(struct axspi_data *ax_spi, struct spi_status *status);
+int axspi_wakeup(struct axspi_data *ax_spi);
+
+static inline u16 AX_READ(struct axspi_data *ax_spi, u8 offset)
+{
+	return axspi_read_reg(ax_spi, offset);
+}
+
+static inline int AX_WRITE(struct axspi_data *ax_spi, u16 value, u8 offset)
+{
+	return axspi_write_reg(ax_spi, offset, value);
+}
+
+static inline int AX_READ_STATUS(struct axspi_data *ax_spi,
+				 struct spi_status *status)
+{
+	return axspi_read_status(ax_spi, status);
+}
+
+static inline int AX_WAKEUP(struct axspi_data *ax_spi)
+{
+	return axspi_wakeup(ax_spi);
+}
+#endif
+
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 9ca87bc73c44..f7621c3a938e 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -221,6 +221,7 @@ enum tunable_id {
 	ETHTOOL_RX_COPYBREAK,
 	ETHTOOL_TX_COPYBREAK,
 	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
+	ETHTOOL_SPI_COMPRESSION,     /* SPI transfer compression */
 	/*
 	 * Add your fresh new tunable attribute above and remember to update
 	 * tunable_strings[] in net/core/ethtool.c
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 24036e3055a1..bd49f83d7daa 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -83,6 +83,7 @@ tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_RX_COPYBREAK]	= "rx-copybreak",
 	[ETHTOOL_TX_COPYBREAK]	= "tx-copybreak",
 	[ETHTOOL_PFC_PREVENTION_TOUT] = "pfc-prevention-tout",
+	[ETHTOOL_SPI_COMPRESSION] = "spi-compression",
 };
 
 const char
-- 
2.26.2

