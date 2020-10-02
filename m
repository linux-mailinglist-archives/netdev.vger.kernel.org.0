Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1045A281BC0
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388434AbgJBTXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:23:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41155 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388484AbgJBTWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 15:22:25 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201002192217euoutp01e87d823b133d0864ac0aabd06a4639b9~6QzrybLZM0907809078euoutp01E
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 19:22:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201002192217euoutp01e87d823b133d0864ac0aabd06a4639b9~6QzrybLZM0907809078euoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601666537;
        bh=8HKnBvSvirb1gwRF3gPl9QaGKImw6cG4eyNEypigb8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7VAO5BTPBBBacuFPznbemuKrUP7orFXDbym91T2dqmcTKMZbyKGeYhzra1akCDDK
         EH7nHLSr4fcMAsVzS+hd0uXBxw6QfajxjK29EC8c0QiDKMWpJvRSnXOXwipNP1xCNF
         ySHOauqaRaLTE6wfSKe6dByuZCPL3D3byyB8iSf8=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201002192217eucas1p2ab024440f2ce4f76b3679daa848d38fd~6QzrJZ6FB1913419134eucas1p2p;
        Fri,  2 Oct 2020 19:22:17 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 6E.37.06318.9ED777F5; Fri,  2
        Oct 2020 20:22:17 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201002192216eucas1p16f54584cf50fff56edc278102a66509e~6QzqRFtZq1165611656eucas1p1O;
        Fri,  2 Oct 2020 19:22:16 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201002192216eusmtrp28d9b6db67a50060b23c57ee83bfd95f8~6QzqQZGeK3070930709eusmtrp27;
        Fri,  2 Oct 2020 19:22:16 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-23-5f777de93217
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id A6.3F.06314.8ED777F5; Fri,  2
        Oct 2020 20:22:16 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201002192216eusmtip2265c445c3504e83e12d2ad4678ab1644~6Qzp-4sxJ2141921419eusmtip2O;
        Fri,  2 Oct 2020 19:22:15 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2 2/4] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Date:   Fri,  2 Oct 2020 21:22:08 +0200
Message-Id: <20201002192210.19967-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002192210.19967-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRju2znbjsvZcd4+NBcdklDwEmocUETLYP0q9JddtE0PKjm1zUtG
        onhNURdeSqepG4q2mveWm80fa2kiOcWyhFmQQamtElNchbXtTPLf87zv87zP98CHITwz0xfL
        zM6jJNnCLILFQTVTVlPwWnFhStjrCRfStGJAyOHWQSbZYapAyS7jHJNcspiZpGx1AyFNpiE2
        Oa9pYJLLhn5AjqwuMclFXQeLbDVNMkhDix6QauMKm5zq9iYr9UZ2LC5YXFpABGMPlxkCrXyF
        LRhR1bAEoz0lAu34FkPQMKYCgq0R/kXsEic6jcrKLKAkoTHXOBmrE4OM3Bc7yE2ZfBctBW/a
        kVrggkE8AjYt3WPWAg7Gw/sBrNnrATT5CWCPstK52QJwXa9m71uaFVNOVR+AH+raGTT5DODM
        FzPLrmLhcVDW+9Jh98Q1CPw6qkTtBMEnAdS+b3bEe+AJsM1kRe0YxQPgR5PZMefiUXBRqXPm
        HYPVfU8dV13waKgrG2LTGnc40/bJ4T2CB8HHZW8dGLHpy5/Y63Fs3noMTvxudnaNh8NWBYvG
        HnB9eswZcBT+1XbZOmA2XAKbGk/T3joANR27KK2Jgua5Xyy7BsED4aAulB7Hwe3vbYC2usF3
        Fnf6CW6wUXMfocdceKeKR6tPwAHZM+dBX1i/3g/uAkJ+oIz8QAH5/6xugKiAD5UvFadT0vBs
        qjBEKhRL87PTQ1JzxCPA9udm96a3x8HkH5EB4BggXLlYWGEKjykskBaJDQBiCOHJPfNqNpnH
        TRMW3aIkOSmS/CxKagB+GEr4cMOVa1d5eLowj7pOUbmUZH/LwFx8S0G1/5rKL21Ab/FGiKYH
        AT7oo7K6KGtiaeGmv4Gr9ffoPH7B6BcjE+Ht59qGvUSdkZE5/MvqjcqZHaDI9FIcWr5iiayq
        UYzlJanVfP63+ogY9+DY+WKJPulGgji+YplIJCTbMbzAHxUnZeVnk1NdNQvnb/cmbB7eFD1v
        ARvjBCrNEJ4KQiRS4T8Z+yjTbwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t/xe7ovasvjDXq/clucv3uI2WLjjPWs
        FnPOt7BYzD9yjtXi2ts7rBb9j18zW5w/v4Hd4sK2PlaLm4dWMFpsenyN1eLyrjlsFjPO72Oy
        ODR1L6PF2iN32S2OLRCzaN17hN1BwOPytYvMHltW3mTy2DnrLrvHplWdbB6bl9R77Nzxmcmj
        b8sqRo/Pm+QCOKL0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLL
        Uov07RL0Mh7vXs9UcPQbc0X/rB8sDYxXZzN3MXJySAiYSExZeIyxi5GLQ0hgKaPEzZXfgRIc
        QAkpiZVz0yFqhCX+XOtig6h5yijR8Os7C0iCTcBRon/pCVaQhIjAIWaJb0/OsIA4zAL7GCX2
        H13MDlIlLBAgMWn3cjYQm0VAVeLR+Ttgq3kFrCUuL9rFDrFCXqJ9+XawGk4BG4ldTRvA4kIg
        NTePMkLUC0qcnPmEBeQ6ZgF1ifXzhEDC/AJaEmuaroMdxAw0pnnrbOYJjEKzkHTMQuiYhaRq
        ASPzKkaR1NLi3PTcYkO94sTc4tK8dL3k/NxNjMCY3nbs5+YdjJc2Bh9iFOBgVOLhTTAqjxdi
        TSwrrsw9xCjBwawkwut09nScEG9KYmVValF+fFFpTmrxIUZToDcnMkuJJucD001eSbyhqaG5
        haWhubG5sZmFkjhvh8DBGCGB9MSS1OzU1ILUIpg+Jg5OqQZGQ+dyUcaTWyxmXNdqXbr/8S6f
        /J+9jb4GD57YFynYy6kVP8n0/llSMLF1qk1Pd2i1nr37k2m/QxtOJ4cZPLy/Mlo3bcP2LzX+
        u70+a8gGrHTrrDPW+1G2fj7HQ+VH+Xn316kqGxx/K7Py5VN9kXtZ2cwz267M2fHzbu8l9/OT
        RTOUOXR3Xa9SYinOSDTUYi4qTgQAhHlIFP8CAAA=
X-CMS-MailID: 20201002192216eucas1p16f54584cf50fff56edc278102a66509e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201002192216eucas1p16f54584cf50fff56edc278102a66509e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201002192216eucas1p16f54584cf50fff56edc278102a66509e
References: <20201002192210.19967-1-l.stelmach@samsung.com>
        <CGME20201002192216eucas1p16f54584cf50fff56edc278102a66509e@eucas1p1.samsung.com>
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

[1] https://www.asix.com.tw/products.php?op=pItemdetail&PItemID=104;65;86&PLine=65
[2] https://git.tizen.org/cgit/profile/common/platform/kernel/linux-3.10-artik/

The other ax88796 driver is for NE2000 compatible AX88796L chip. These
chips are not compatible. Hence, two separate drivers are required.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 MAINTAINERS                                |    6 +
 drivers/net/ethernet/Kconfig               |    1 +
 drivers/net/ethernet/Makefile              |    1 +
 drivers/net/ethernet/asix/Kconfig          |   21 +
 drivers/net/ethernet/asix/Makefile         |    6 +
 drivers/net/ethernet/asix/ax88796c_ioctl.c |  241 +++++
 drivers/net/ethernet/asix/ax88796c_ioctl.h |   27 +
 drivers/net/ethernet/asix/ax88796c_main.c  | 1041 ++++++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h  |  568 +++++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c   |  111 +++
 drivers/net/ethernet/asix/ax88796c_spi.h   |   69 ++
 11 files changed, 2092 insertions(+)
 create mode 100644 drivers/net/ethernet/asix/Kconfig
 create mode 100644 drivers/net/ethernet/asix/Makefile
 create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.h
 create mode 100644 drivers/net/ethernet/asix/ax88796c_main.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_main.h
 create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.h

diff --git a/MAINTAINERS b/MAINTAINERS
index deaafb617361..654eb0127479 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2822,6 +2822,12 @@ S:	Maintained
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
index 000000000000..7caa45607450
--- /dev/null
+++ b/drivers/net/ethernet/asix/Kconfig
@@ -0,0 +1,21 @@
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
+	depends on SPI
+	depends on GPIOLIB
+	help
+	  Say Y here if you intend to use ASIX AX88796C attached in SPI mode.
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
index 000000000000..b3e3ac96790d
--- /dev/null
+++ b/drivers/net/ethernet/asix/ax88796c_ioctl.c
@@ -0,0 +1,241 @@
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
+static void ax88796c_get_drvinfo(struct net_device *ndev,
+				 struct ethtool_drvinfo *info)
+{
+	/* Inherit standard device info */
+	strncpy(info->driver, DRV_NAME, sizeof(info->driver));
+}
+
+static u32 ax88796c_get_link(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+
+	mutex_lock(&ax_local->spi_lock);
+
+	phy_read_status(ndev->phydev);
+
+	mutex_unlock(&ax_local->spi_lock);
+
+	return ndev->phydev->link;
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
+static int
+ax88796c_get_link_ksettings(struct net_device *ndev,
+			    struct ethtool_link_ksettings *cmd)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	int ret;
+
+	mutex_lock(&ax_local->spi_lock);
+
+	ret = phy_ethtool_get_link_ksettings(ndev, cmd);
+
+	mutex_unlock(&ax_local->spi_lock);
+
+	return ret;
+}
+
+static int
+ax88796c_set_link_ksettings(struct net_device *ndev,
+			    const struct ethtool_link_ksettings *cmd)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	int ret;
+
+	mutex_lock(&ax_local->spi_lock);
+
+	ret = phy_ethtool_set_link_ksettings(ndev, cmd);
+
+	mutex_unlock(&ax_local->spi_lock);
+
+	return ret;
+}
+
+static int ax88796c_nway_reset(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	int ret;
+
+	mutex_lock(&ax_local->spi_lock);
+
+	ret = phy_ethtool_nway_reset(ndev);
+
+	mutex_unlock(&ax_local->spi_lock);
+
+	return ret;
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
+static int ax88796c_get_regs_len(struct net_device *ndev)
+{
+	return AX88796C_REGDUMP_LEN + AX88796C_PHY_REGDUMP_LEN;
+}
+
+static void
+ax88796c_get_regs(struct net_device *ndev, struct ethtool_regs *regs, void *_p)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	u16 *p = _p;
+	int offset, i;
+
+	memset(p, 0, AX88796C_REGDUMP_LEN);
+
+	for (offset = 0; offset < AX88796C_REGDUMP_LEN; offset += 2) {
+		if (!test_bit(offset / 2, ax88796c_no_regs_mask))
+			*p = AX_READ(&ax_local->ax_spi, offset);
+		p++;
+	}
+
+	for (i = 0; i < AX88796C_PHY_REGDUMP_LEN / 2; i++) {
+		*p = phy_read(ax_local->phydev, i);
+		p++;
+	}
+}
+
+int ax88796c_mdio_read(struct mii_bus *mdiobus, int phy_id, int loc)
+{
+	struct ax88796c_device *ax_local = mdiobus->priv;
+	int ret;
+
+	AX_WRITE(&ax_local->ax_spi, MDIOCR_RADDR(loc)
+			| MDIOCR_FADDR(phy_id) | MDIOCR_READ, P2_MDIOCR);
+
+	ret = read_poll_timeout(AX_READ, ret,
+				(ret != 0),
+				0, jiffies_to_usecs(HZ / 100), false,
+				&ax_local->ax_spi, P2_MDIOCR);
+	if (ret)
+		return -EBUSY;
+
+	return AX_READ(&ax_local->ax_spi, P2_MDIODR);
+}
+
+int
+ax88796c_mdio_write(struct mii_bus *mdiobus, int phy_id, int loc, u16 val)
+{
+	struct ax88796c_device *ax_local = mdiobus->priv;
+	int ret;
+
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
+	if (ret)
+		return -EIO;
+
+	if (loc == MII_ADVERTISE) {
+		AX_WRITE(&ax_local->ax_spi, (BMCR_FULLDPLX | BMCR_ANRESTART |
+			  BMCR_ANENABLE | BMCR_SPEED100), P2_MDIODR);
+		AX_WRITE(&ax_local->ax_spi, (MDIOCR_RADDR(MII_BMCR) |
+			  MDIOCR_FADDR(phy_id) | MDIOCR_WRITE),
+			  P2_MDIOCR);
+
+		ret = read_poll_timeout(AX_READ, ret,
+					((ret & MDIOCR_VALID) != 0), 0,
+					jiffies_to_usecs(HZ / 100), false,
+					&ax_local->ax_spi, P2_MDIOCR);
+		if (ret)
+			return -EIO;
+	}
+
+	return 0;
+}
+
+void ax88796c_set_csums(struct ax88796c_device *ax_local)
+{
+	struct net_device *ndev = ax_local->ndev;
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
+const struct ethtool_ops ax88796c_ethtool_ops = {
+	.get_drvinfo		= ax88796c_get_drvinfo,
+	.get_link		= ax88796c_get_link,
+	.get_msglevel		= ax88796c_get_msglevel,
+	.set_msglevel		= ax88796c_set_msglevel,
+	.get_link_ksettings	= ax88796c_get_link_ksettings,
+	.set_link_ksettings	= ax88796c_set_link_ksettings,
+	.nway_reset		= ax88796c_nway_reset,
+	.get_msglevel		= ax88796c_ethtool_getmsglevel,
+	.set_msglevel		= ax88796c_ethtool_setmsglevel,
+	.get_regs_len		= ax88796c_get_regs_len,
+	.get_regs		= ax88796c_get_regs,
+};
+
+int ax88796c_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	int ret;
+
+	mutex_lock(&ax_local->spi_lock);
+
+	ret = phy_mii_ioctl(ndev->phydev, ifr, cmd);
+
+	mutex_unlock(&ax_local->spi_lock);
+
+	return ret;
+}
diff --git a/drivers/net/ethernet/asix/ax88796c_ioctl.h b/drivers/net/ethernet/asix/ax88796c_ioctl.h
new file mode 100644
index 000000000000..d478981bf995
--- /dev/null
+++ b/drivers/net/ethernet/asix/ax88796c_ioctl.h
@@ -0,0 +1,27 @@
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
+void ax88796c_set_csums(struct ax88796c_device *ax_local);
+int ax88796c_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+
+#endif
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
new file mode 100644
index 000000000000..2148ea01362a
--- /dev/null
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -0,0 +1,1041 @@
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
+static int comp;
+static int msg_enable = NETIF_MSG_PROBE |
+			NETIF_MSG_LINK |
+			/* NETIF_MSG_TIMER | */
+			/* NETIF_MSG_IFDOWN | */
+			/* NETIF_MSG_IFUP | */
+			NETIF_MSG_RX_ERR |
+			NETIF_MSG_TX_ERR |
+			/* NETIF_MSG_TX_QUEUED | */
+			/* NETIF_MSG_INTR | */
+			/* NETIF_MSG_TX_DONE | */
+			/* NETIF_MSG_RX_STATUS | */
+			/* NETIF_MSG_PKTDATA | */
+			/* NETIF_MSG_HW | */
+			/* NETIF_MSG_WOL | */
+			0;
+
+static char *no_regs_list = "80018001,e1918001,8001a001,fc0d0000";
+unsigned long ax88796c_no_regs_mask[AX88796C_REGDUMP_LEN / (sizeof(unsigned long) * 8)];
+
+module_param(comp, int, 0444);
+MODULE_PARM_DESC(comp, "0=Non-Compression Mode, 1=Compression Mode");
+
+module_param(msg_enable, int, 0444);
+MODULE_PARM_DESC(msg_enable, "Message mask (see linux/netdevice.h for bitmap)");
+
+static int ax88796c_soft_reset(struct ax88796c_device *ax_local)
+{
+	u16 temp;
+	int ret;
+
+	AX_WRITE(&ax_local->ax_spi, PSR_RESET, P0_PSR);
+	AX_WRITE(&ax_local->ax_spi, PSR_RESET_CLR, P0_PSR);
+
+	ret = read_poll_timeout(AX_READ, ret,
+				(ret & PSR_DEV_READY),
+				0, jiffies_to_usecs(160 * HZ / 1000), false,
+				&ax_local->ax_spi, P0_PSR);
+	if (ret)
+		return -1;
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
+	AX_WRITE(&ax_local->ax_spi, EECR_RELOAD, P3_EECR);
+
+	ret = read_poll_timeout(AX_READ, ret,
+				(ret & PSR_DEV_READY),
+				0, jiffies_to_usecs(2 * HZ / 1000), false,
+				&ax_local->ax_spi, P0_PSR);
+	if (ret) {
+		dev_err(&ax_local->spi->dev,
+			"timeout waiting for reload eeprom\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static void ax88796c_set_hw_multicast(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	u16 rx_ctl = RXCR_AB;
+	int mc_count = netdev_mc_count(ndev);
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
+	AX_WRITE(&ax_local->ax_spi, ((u16)(ndev->dev_addr[4] << 8) |
+			(u16)ndev->dev_addr[5]), P3_MACASR0);
+	AX_WRITE(&ax_local->ax_spi, ((u16)(ndev->dev_addr[2] << 8) |
+			(u16)ndev->dev_addr[3]), P3_MACASR1);
+	AX_WRITE(&ax_local->ax_spi, ((u16)(ndev->dev_addr[0] << 8) |
+			(u16)ndev->dev_addr[1]), P3_MACASR2);
+}
+
+static int ax88796c_set_mac_address(struct net_device *ndev, void *p)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	struct sockaddr *addr = p;
+
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	memcpy(ndev->dev_addr, addr->sa_data, ndev->addr_len);
+
+	mutex_lock(&ax_local->spi_lock);
+
+	ax88796c_set_mac_addr(ndev);
+
+	mutex_unlock(&ax_local->spi_lock);
+
+	return 0;
+}
+
+static void ax88796c_load_mac_addr(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	u16 temp;
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
+	struct sk_buff *skb, *tx_skb;
+	struct tx_pkt_info *info;
+	struct skb_data *entry;
+	int headroom;
+	int tailroom;
+	u8 need_pages;
+	u16 tol_len, pkt_len;
+	u8 padlen, seq_num;
+	u8 spi_len = ax_local->ax_spi.comp ? 1 : 4;
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
+			  "Too much TX packets in queue %d\n",
+			  skb_queue_len(&ax_local->tx_wait_q));
+
+		netif_stop_queue(ndev);
+	}
+
+	set_bit(EVENT_TX, &ax_local->flags);
+	queue_work(ax_local->ax_work_queue, &ax_local->ax_work);
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
+	struct sk_buff *skb;
+	struct skb_data *entry;
+	u16 w_count, pkt_len;
+	u8 pkt_cnt;
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
+	skb = alloc_skb((w_count * 2), GFP_KERNEL);
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
+	u16 isr;
+	u8 done = 0;
+	struct net_device *ndev = ax_local->ndev;
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
+	struct net_device *ndev = dev_instance;
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+
+	if (!ndev) {
+		pr_err("irq %d for unknown device.\n", irq);
+		return IRQ_RETVAL(0);
+	}
+
+	disable_irq_nosync(irq);
+
+	netif_dbg(ax_local, intr, ndev, "Interrupt occurred\n");
+
+	set_bit(EVENT_INTR, &ax_local->flags);
+	queue_work(ax_local->ax_work_queue, &ax_local->ax_work);
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
+static void ax88796c_handle_link_change(struct net_device *ndev)
+{
+	if (net_ratelimit())
+		phy_print_status(ndev->phydev);
+}
+
+void ax88796c_phy_init(struct ax88796c_device *ax_local)
+{
+	/* Enable PHY auto-polling */
+	AX_WRITE(&ax_local->ax_spi,
+		 PCR_PHYID(0x10) | PCR_POLL_EN |
+		 PCR_POLL_FLOWCTRL | PCR_POLL_BMCR, P2_PCR);
+}
+
+static int
+ax88796c_open(struct net_device *ndev)
+{
+	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
+	int ret;
+	unsigned long irq_flag = IRQF_SHARED;
+
+	mutex_lock(&ax_local->spi_lock);
+
+	ret = ax88796c_soft_reset(ax_local);
+	if (ret < 0)
+		return -ENODEV;
+
+	ret = request_irq(ndev->irq, ax88796c_interrupt,
+			  irq_flag, ndev->name, ndev);
+	if (ret) {
+		netdev_err(ndev, "unable to get IRQ %d (errno=%d).\n",
+			   ndev->irq, ret);
+		return -ENXIO;
+	}
+
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
+	ax88796c_phy_init(ax_local);
+
+	phy_start(ax_local->ndev->phydev);
+
+	netif_start_queue(ndev);
+
+	AX_WRITE(&ax_local->ax_spi, IMR_DEFAULT, P0_IMR);
+
+	spi_message_init(&ax_local->ax_spi.rx_msg);
+
+	mutex_unlock(&ax_local->spi_lock);
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
+
+	free_irq(ndev->irq, ndev);
+
+	phy_stop(ndev->phydev);
+
+	mutex_lock(&ax_local->spi_lock);
+
+	AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
+	ax88796c_free_skb_queue(&ax_local->tx_wait_q);
+
+	ax88796c_soft_reset(ax_local);
+
+	mutex_unlock(&ax_local->spi_lock);
+	netif_carrier_off(ndev);
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
+	.ndo_set_mac_address	= ax88796c_set_mac_address,
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
+	struct net_device *ndev;
+	struct ax88796c_device *ax_local;
+	int ret;
+	u16 temp;
+
+	ndev = devm_alloc_etherdev(&spi->dev, sizeof(*ax_local));
+	if (!ndev) {
+		dev_err(&spi->dev, "AX88796C SPI: Could not allocate ethernet device\n");
+		return -ENOMEM;
+	}
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
+
+	ax_local->mdiobus = devm_mdiobus_alloc(&spi->dev);
+	if (!ax_local->mdiobus) {
+		dev_err(&spi->dev, "Could not allocate MDIO bus\n");
+		return -ENOMEM;
+	}
+
+	ax_local->mdiobus->priv = ax_local;
+	ax_local->mdiobus->read = ax88796c_mdio_read;
+	ax_local->mdiobus->write = ax88796c_mdio_write;
+	ax_local->mdiobus->name = "ax88976c-mdiobus";
+	ax_local->mdiobus->phy_mask = ~(1 << 0x10);
+	ax_local->mdiobus->parent = &spi->dev;
+
+	snprintf(ax_local->mdiobus->id, ARRAY_SIZE(ax_local->mdiobus->id),
+		 "ax88796c-spi-%s.%u", dev_name(&spi->dev), spi->chip_select);
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
+	INIT_WORK(&ax_local->ax_work, ax88796c_work);
+
+	ax_local->ax_work_queue =
+			create_singlethread_workqueue("ax88796c_work");
+
+	mutex_init(&ax_local->spi_lock);
+
+	skb_queue_head_init(&ax_local->tx_wait_q);
+
+	ret = devm_register_netdev(&spi->dev, ndev);
+	if (ret) {
+		dev_err(&spi->dev, "failed to register a network device\n");
+		destroy_workqueue(ax_local->ax_work_queue);
+		goto err;
+	}
+
+	ax_local->phydev = phy_find_first(ax_local->mdiobus);
+	if (!ax_local->phydev) {
+		dev_err(&spi->dev, "no PHY found\n");
+		ret = -ENODEV;
+		goto err;
+	}
+
+	ax_local->phydev->irq = PHY_IGNORE_INTERRUPT;
+	phy_connect_direct(ax_local->ndev, ax_local->phydev,
+			   ax88796c_handle_link_change,
+			   PHY_INTERFACE_MODE_MII);
+
+	netif_info(ax_local, probe, ndev, "%s %s registered\n",
+		   dev_driver_string(&spi->dev),
+		   dev_name(&spi->dev));
+	phy_attached_info(ax_local->phydev);
+
+	ret = 0;
+err:
+	return ret;
+}
+
+static int ax88796c_remove(struct spi_device *spi)
+{
+	struct ax88796c_device *ax_local = dev_get_drvdata(&spi->dev);
+	struct net_device *ndev = ax_local->ndev;
+
+	netif_info(ax_local, probe, ndev, "removing network device %s %s\n",
+		   dev_driver_string(&spi->dev),
+		   dev_name(&spi->dev));
+
+	destroy_workqueue(ax_local->ax_work_queue);
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
+#ifdef CONFIG_USE_OF
+		.of_match_table = of_match_ptr(ax88796c_dt_ids),
+#endif
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
+
+/* ax88796c_phy */
diff --git a/drivers/net/ethernet/asix/ax88796c_main.h b/drivers/net/ethernet/asix/ax88796c_main.h
new file mode 100644
index 000000000000..428833978fbf
--- /dev/null
+++ b/drivers/net/ethernet/asix/ax88796c_main.h
@@ -0,0 +1,568 @@
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
+#define DRV_VERSION	"1.2.0"
+
+#define TX_QUEUE_HIGH_WATER		45	/* Tx queue high water mark */
+#define TX_QUEUE_LOW_WATER		20	/* Tx queue low water mark */
+
+#define AX88796C_REGDUMP_LEN		256
+#define AX88796C_PHY_REGDUMP_LEN	12
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
+enum watchdog_state {
+	chk_link = 0,
+	chk_cable,
+	ax_nop,
+};
+
+struct ax88796c_device {
+	struct resource		*addr_res;   /* resources found */
+	struct resource		*addr_req;   /* resources requested */
+	struct resource		*irq_res;
+
+	struct spi_device	*spi;
+	struct net_device	*ndev;
+	struct net_device_stats	stats;
+
+	struct timer_list	watchdog;
+	enum watchdog_state	w_state;
+	size_t			w_ticks;
+
+	struct work_struct	ax_work;
+	struct workqueue_struct *ax_work_queue;
+	struct tasklet_struct	bh;
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
+	unsigned long		capabilities;
+		#define AX_CAP_DMA		1
+		#define AX_CAP_COMP		2
+		#define AX_CAP_BIDIR		4
+
+	u8			plat_endian;
+		#define PLAT_LITTLE_ENDIAN	0
+		#define PLAT_BIG_ENDIAN		1
+
+	unsigned long		flags;
+		#define EVENT_INTR		1
+		#define EVENT_TX		2
+		#define EVENT_SET_MULTI		4
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
+struct skb_data;
+
+struct skb_data {
+	enum skb_state state;
+	struct net_device *ndev;
+	struct sk_buff *skb;
+	size_t len;
+	dma_addr_t phy_addr;
+};
+
+/* A88796C register definition */
+	/* Definition of PAGE0 */
+#define P0_PSR		(0x00)
+	#define PSR_DEV_READY		(1 << 7)
+	#define PSR_RESET		(0 << 15)
+	#define PSR_RESET_CLR		(1 << 15)
+#define P0_BOR		(0x02)
+#define P0_FER		(0x04)
+	#define FER_IPALM		(1 << 0)
+	#define FER_DCRC		(1 << 1)
+	#define FER_RH3M		(1 << 2)
+	#define FER_HEADERSWAP		(1 << 7)
+	#define FER_WSWAP		(1 << 8)
+	#define FER_BSWAP		(1 << 9)
+	#define FER_INTHI		(1 << 10)
+	#define FER_INTLO		(0 << 10)
+	#define FER_IRQ_PULL		(1 << 11)
+	#define FER_RXEN		(1 << 14)
+	#define FER_TXEN		(1 << 15)
+#define P0_ISR		(0x06)
+	#define ISR_RXPKT		(1 << 0)
+	#define ISR_MDQ			(1 << 4)
+	#define ISR_TXT			(1 << 5)
+	#define ISR_TXPAGES		(1 << 6)
+	#define ISR_TXERR		(1 << 8)
+	#define ISR_LINK		(1 << 9)
+#define P0_IMR		(0x08)
+	#define IMR_RXPKT		(1 << 0)
+	#define IMR_MDQ			(1 << 4)
+	#define IMR_TXT			(1 << 5)
+	#define IMR_TXPAGES		(1 << 6)
+	#define IMR_TXERR		(1 << 8)
+	#define IMR_LINK		(1 << 9)
+	#define IMR_MASKALL		(0xFFFF)
+	#define IMR_DEFAULT		(IMR_TXERR)
+#define P0_WFCR		(0x0A)
+	#define WFCR_PMEIND		(1 << 0) /* PME indication */
+	#define WFCR_PMETYPE		(1 << 1) /* PME I/O type */
+	#define WFCR_PMEPOL		(1 << 2) /* PME polarity */
+	#define WFCR_PMERST		(1 << 3) /* Reset PME */
+	#define WFCR_SLEEP		(1 << 4) /* Enable sleep mode */
+	#define WFCR_WAKEUP		(1 << 5) /* Enable wakeup mode */
+	#define WFCR_WAITEVENT		(1 << 6) /* Reserved */
+	#define WFCR_CLRWAKE		(1 << 7) /* Clear wakeup */
+	#define WFCR_LINKCH		(1 << 8) /* Enable link change */
+	#define WFCR_MAGICP		(1 << 9) /* Enable magic packet */
+	#define WFCR_WAKEF		(1 << 10) /* Enable wakeup frame */
+	#define WFCR_PMEEN		(1 << 11) /* Enable PME pin */
+	#define WFCR_LINKCHS		(1 << 12) /* Link change status */
+	#define WFCR_MAGICPS		(1 << 13) /* Magic packet status */
+	#define WFCR_WAKEFS		(1 << 14) /* Wakeup frame status */
+	#define WFCR_PMES		(1 << 15) /* PME pin status */
+#define P0_PSCR		(0x0C)
+	#define PSCR_PS_MASK		(0xFFF0)
+	#define PSCR_PS_D0		(0)
+	#define PSCR_PS_D1		(1 << 0)
+	#define PSCR_PS_D2		(1 << 1)
+	#define PSCR_FPS		(1 << 3) /* Enable fiber mode PS */
+	#define PSCR_SWPS		(1 << 4) /* Enable software */
+						 /* PS control */
+	#define PSCR_WOLPS		(1 << 5) /* Enable WOL PS */
+	#define PSCR_SWWOL		(1 << 6) /* Enable software select */
+						 /* WOL PS */
+	#define PSCR_PHYOSC		(1 << 7) /* Internal PHY OSC control */
+	#define PSCR_FOFEF		(1 << 8) /* Force PHY generate FEF */
+	#define PSCR_FOF		(1 << 9) /* Force PHY in fiber mode */
+	#define PSCR_PHYPD		(1 << 10) /* PHY power down. */
+						  /* Active high */
+	#define PSCR_PHYRST		(1 << 11) /* PHY reset signal. */
+						  /* Active low */
+	#define PSCR_PHYCSIL		(1 << 12) /* PHY cable energy detect */
+	#define PSCR_PHYCOFF		(1 << 13) /* PHY cable off */
+	#define PSCR_PHYLINK		(1 << 14) /* PHY link status */
+	#define PSCR_EEPOK		(1 << 15) /* EEPROM load complete */
+#define P0_MACCR	(0x0E)
+	#define MACCR_RXFC_ENABLE	(1 << 3)
+	#define MACCR_RXFC_MASK		0xFFF7
+	#define MACCR_TXFC_ENABLE	(1 << 4)
+	#define MACCR_TXFC_MASK		0xFFEF
+	#define MACCR_PSI		(1 << 6) /* Software Cable-Off */
+						 /* Power Saving Interrupt */
+	#define MACCR_PF		(1 << 7)
+	#define MACCR_PMM_BITS		8
+	#define MACCR_PMM_MASK		(0x1F00)
+	#define MACCR_PMM_RESET		(1 << 8)
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
+	#define TFBFCR_FREE_PAGE_LATCH	(1 << 6)
+	#define TFBFCR_SET_FREE_PAGE(x)	(((x) & 0x3F) << TFBFCR_FREE_PAGE_BITS)
+	#define TFBFCR_TX_PAGE_SET	(1 << 13)
+	#define TFBFCR_MANU_ENTX	(1 << 15)
+	#define TX_FREEBUF_MASK		0x003F
+	#define TX_DPTSTART		0x4000
+
+#define P0_TSNR		(0x12)
+	#define TXNR_TXB_ERR		(1 << 5)
+	#define TXNR_TXB_IDLE		(1 << 6)
+	#define TSNR_PKT_CNT(x)		(((x) & 0x3F) << 8)
+	#define TXNR_TXB_REINIT		(1 << 14)
+	#define TSNR_TXB_START		(1 << 15)
+#define P0_RTDPR	(0x14)
+#define P0_RXBCR1	(0x16)
+	#define RXBCR1_RXB_DISCARD	(1 << 14)
+	#define RXBCR1_RXB_START	(1 << 15)
+#define P0_RXBCR2	(0x18)
+	#define RXBCR2_PKT_MASK		(0xFF)
+	#define RXBCR2_RXPC_MASK	(0x7F)
+	#define RXBCR2_RXB_READY	(1 << 13)
+	#define RXBCR2_RXB_IDLE		(1 << 14)
+	#define RXBCR2_RXB_REINIT	(1 << 15)
+#define P0_RTWCR	(0x1A)
+	#define RTWCR_RXWC_MASK		(0x3FFF)
+	#define RTWCR_RX_LATCH		(1 << 15)
+#define P0_RCPHR	(0x1C)
+
+	/* Definition of PAGE1 */
+#define P1_RPPER	(0x22)
+	#define RPPER_RXEN		(1 << 0)
+#define P1_MRCR		(0x28)
+#define P1_MDR		(0x2A)
+#define P1_RMPR		(0x2C)
+#define P1_TMPR		(0x2E)
+#define P1_RXBSPCR	(0x30)
+	#define RXBSPCR_STUF_WORD_CNT(x)	(((x) & 0x7000) >> 12)
+	#define RXBSPCR_STUF_ENABLE		(1 << 15)
+#define P1_MCR		(0x32)
+	#define MCR_SBP			(1 << 8)
+	#define MCR_SM			(1 << 9)
+	#define MCR_CRCENLAN		(1 << 11)
+	#define MCR_STP			(1 << 12)
+	/* Definition of PAGE2 */
+#define P2_CIR		(0x42)
+#define P2_PCR		(0x44)
+	#define PCR_POLL_EN		(1 << 0)
+	#define PCR_POLL_FLOWCTRL	(1 << 1)
+	#define PCR_POLL_BMCR		(1 << 2)
+	#define PCR_PHYID(x)		((x) << 8)
+#define P2_PHYSR	(0x46)
+#define P2_MDIODR	(0x48)
+#define P2_MDIOCR	(0x4A)
+	#define MDIOCR_RADDR(x)		((x) & 0x1F)
+	#define MDIOCR_FADDR(x)		(((x) & 0x1F) << 8)
+	#define MDIOCR_VALID		(1 << 13)
+	#define MDIOCR_READ		(1 << 14)
+	#define MDIOCR_WRITE		(1 << 15)
+#define P2_LCR0		(0x4C)
+	#define LCR_LED0_EN		(1 << 0)
+	#define LCR_LED0_100MODE	(1 << 1)
+	#define LCR_LED0_DUPLEX		(1 << 2)
+	#define LCR_LED0_LINK		(1 << 3)
+	#define LCR_LED0_ACT		(1 << 4)
+	#define LCR_LED0_COL		(1 << 5)
+	#define LCR_LED0_10MODE		(1 << 6)
+	#define LCR_LED0_DUPCOL		(1 << 7)
+	#define LCR_LED1_EN		(1 << 8)
+	#define LCR_LED1_100MODE	(1 << 9)
+	#define LCR_LED1_DUPLEX		(1 << 10)
+	#define LCR_LED1_LINK		(1 << 11)
+	#define LCR_LED1_ACT		(1 << 12)
+	#define LCR_LED1_COL		(1 << 13)
+	#define LCR_LED1_10MODE		(1 << 14)
+	#define LCR_LED1_DUPCOL		(1 << 15)
+#define P2_LCR1		(0x4E)
+	#define LCR_LED2_MASK		(0xFF00)
+	#define LCR_LED2_EN		(1 << 0)
+	#define LCR_LED2_100MODE	(1 << 1)
+	#define LCR_LED2_DUPLEX		(1 << 2)
+	#define LCR_LED2_LINK		(1 << 3)
+	#define LCR_LED2_ACT		(1 << 4)
+	#define LCR_LED2_COL		(1 << 5)
+	#define LCR_LED2_10MODE		(1 << 6)
+	#define LCR_LED2_DUPCOL		(1 << 7)
+#define P2_IPGCR	(0x50)
+#define P2_CRIR		(0x52)
+#define P2_FLHWCR	(0x54)
+#define P2_RXCR		(0x56)
+	#define RXCR_PRO		(1 << 0)
+	#define RXCR_AMALL		(1 << 1)
+	#define RXCR_SEP		(1 << 2)
+	#define RXCR_AB			(1 << 3)
+	#define RXCR_AM			(1 << 4)
+	#define RXCR_AP			(1 << 5)
+	#define RXCR_ARP		(1 << 6)
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
+	#define EECR_READ_ACT		(1 << 8)
+	#define EECR_WRITE_ACT		(1 << 9)
+	#define EECR_WRITE_DISABLE	(1 << 10)
+	#define EECR_WRITE_ENABLE	(1 << 11)
+	#define EECR_EE_READY		(1 << 13)
+	#define EECR_RELOAD		(1 << 14)
+	#define EECR_RESET		(1 << 15)
+#define P3_TPCR		(0x7A)
+	#define TPCR_PATT_MASK		(0xFF)
+	#define TPCR_RAND_PKT_EN	(1 << 14)
+	#define TPCR_FIXED_PKT_EN	(1 << 15)
+#define P3_TPLR		(0x7C)
+	/* Definition of PAGE4 */
+#define P4_SPICR	(0x8A)
+	#define SPICR_RCEN		(1 << 0)
+	#define SPICR_QCEN		(1 << 1)
+	#define SPICR_RBRE		(1 << 3)
+	#define SPICR_PMM		(1 << 4)
+	#define SPICR_LOOPBACK		(1 << 8)
+	#define SPICR_CORE_RES_CLR	(1 << 10)
+	#define SPICR_SPI_RES_CLR	(1 << 11)
+#define P4_SPIISMR	(0x8C)
+
+#define P4_COERCR0	(0x92)
+	#define COERCR0_RXIPCE		(1 << 0)
+	#define COERCR0_RXIPVE		(1 << 1)
+	#define COERCR0_RXV6PE		(1 << 2)
+	#define COERCR0_RXTCPE		(1 << 3)
+	#define COERCR0_RXUDPE		(1 << 4)
+	#define COERCR0_RXICMP		(1 << 5)
+	#define COERCR0_RXIGMP		(1 << 6)
+	#define COERCR0_RXICV6		(1 << 7)
+
+	#define COERCR0_RXTCPV6		(1 << 8)
+	#define COERCR0_RXUDPV6		(1 << 9)
+	#define COERCR0_RXICMV6		(1 << 10)
+	#define COERCR0_RXIGMV6		(1 << 11)
+	#define COERCR0_RXICV6V6	(1 << 12)
+
+	#define COERCR0_DEFAULT		(COERCR0_RXIPCE | COERCR0_RXV6PE | \
+					 COERCR0_RXTCPE | COERCR0_RXUDPE | \
+					 COERCR0_RXTCPV6 | COERCR0_RXUDPV6)
+#define P4_COERCR1	(0x94)
+	#define COERCR1_IPCEDP		(1 << 0)
+	#define COERCR1_IPVEDP		(1 << 1)
+	#define COERCR1_V6VEDP		(1 << 2)
+	#define COERCR1_TCPEDP		(1 << 3)
+	#define COERCR1_UDPEDP		(1 << 4)
+	#define COERCR1_ICMPDP		(1 << 5)
+	#define COERCR1_IGMPDP		(1 << 6)
+	#define COERCR1_ICV6DP		(1 << 7)
+	#define COERCR1_RX64TE		(1 << 8)
+	#define COERCR1_RXPPPE		(1 << 9)
+	#define COERCR1_TCP6DP		(1 << 10)
+	#define COERCR1_UDP6DP		(1 << 11)
+	#define COERCR1_IC6DP		(1 << 12)
+	#define COERCR1_IG6DP		(1 << 13)
+	#define COERCR1_ICV66DP		(1 << 14)
+	#define COERCR1_RPCE		(1 << 15)
+
+	#define COERCR1_DEFAULT		(COERCR1_RXPPPE)
+
+#define P4_COETCR0	(0x96)
+	#define COETCR0_TXIP		(1 << 0)
+	#define COETCR0_TXTCP		(1 << 1)
+	#define COETCR0_TXUDP		(1 << 2)
+	#define COETCR0_TXICMP		(1 << 3)
+	#define COETCR0_TXIGMP		(1 << 4)
+	#define COETCR0_TXICV6		(1 << 5)
+	#define COETCR0_TXTCPV6		(1 << 8)
+	#define COETCR0_TXUDPV6		(1 << 9)
+	#define COETCR0_TXICMV6		(1 << 10)
+	#define COETCR0_TXIGMV6		(1 << 11)
+	#define COETCR0_TXICV6V6	(1 << 12)
+
+	#define COETCR0_DEFAULT		(COETCR0_TXIP | COETCR0_TXTCP | \
+					 COETCR0_TXUDP | COETCR0_TXTCPV6 | \
+					 COETCR0_TXUDPV6)
+#define P4_COETCR1	(0x98)
+	#define COETCR1_TX64TE		(1 << 0)
+	#define COETCR1_TXPPPE		(1 << 1)
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
+	#define WFCR03_F0_EN		(1 << 0)
+	#define WFCR03_F1_EN		(1 << 4)
+	#define WFCR03_F2_EN		(1 << 8)
+	#define WFCR03_F3_EN		(1 << 12)
+#define P5_WFCR47	(0xA8)
+	#define WFCR47_F4_EN		(1 << 0)
+	#define WFCR47_F5_EN		(1 << 4)
+	#define WFCR47_F6_EN		(1 << 8)
+	#define WFCR47_F7_EN		(1 << 12)
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
index 000000000000..1a20bbeb4dc1
--- /dev/null
+++ b/drivers/net/ethernet/asix/ax88796c_spi.c
@@ -0,0 +1,111 @@
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
+int axspi_wakeup(const struct axspi_data *ax_spi)
+{
+	u8 tx_buf;
+	int ret;
+
+	tx_buf = AX_SPICMD_EXIT_PWD;	/* OP */
+	ret = spi_write(ax_spi->spi, &tx_buf, 1);
+	if (ret)
+		dev_err(&ax_spi->spi->dev, "%s() failed: ret = %d\n", __func__, ret);
+	return ret;
+}
+
+int axspi_read_status(const struct axspi_data *ax_spi, struct spi_status *status)
+{
+	u8 tx_buf;
+	int ret;
+
+	/* OP */
+	tx_buf = AX_SPICMD_READ_STATUS;
+	ret = spi_write_then_read(ax_spi->spi, &tx_buf, 1, (u8 *)&status, 3);
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
+u16 axspi_read_reg(const struct axspi_data *ax_spi, u8 reg)
+{
+	u8 tx_buf[4];
+	u16 rx_buf = 0;
+	int ret;
+	int len = ax_spi->comp ? 3 : 4;
+
+	tx_buf[0] = 0x03;	/* OP code read register */
+	tx_buf[1] = reg;	/* register address */
+	tx_buf[2] = 0xFF;	/* dumy cycle */
+	tx_buf[3] = 0xFF;	/* dumy cycle */
+	ret = spi_write_then_read(ax_spi->spi, tx_buf, len, (u8 *)&rx_buf, 2);
+	if (ret)
+		dev_err(&ax_spi->spi->dev, "%s() failed: ret = %d\n", __func__, ret);
+	else
+		le16_to_cpus(&rx_buf);
+
+	return rx_buf;
+}
+
+int axspi_write_reg(const struct axspi_data *ax_spi, u8 reg, u16 value)
+{
+	u8 tx_buf[4];
+	int ret;
+
+	tx_buf[0] = AX_SPICMD_WRITE_REG;	/* OP code read register */
+	tx_buf[1] = reg;			/* register address */
+	tx_buf[2] = value;
+	tx_buf[3] = value >> 8;
+
+	ret = spi_write(ax_spi->spi, tx_buf, 4);
+	if (ret)
+		dev_err(&ax_spi->spi->dev, "%s() failed: ret = %d\n", __func__, ret);
+	return ret;
+}
+
diff --git a/drivers/net/ethernet/asix/ax88796c_spi.h b/drivers/net/ethernet/asix/ax88796c_spi.h
new file mode 100644
index 000000000000..7a49205c2cfb
--- /dev/null
+++ b/drivers/net/ethernet/asix/ax88796c_spi.h
@@ -0,0 +1,69 @@
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
+u16 axspi_read_reg(const struct axspi_data *ax_spi, u8 reg);
+int axspi_write_reg(const struct axspi_data *ax_spi, u8 reg, u16 value);
+int axspi_read_status(const struct axspi_data *ax_spi, struct spi_status *status);
+int axspi_wakeup(const struct axspi_data *ax_spi);
+
+static inline u16 AX_READ(const struct axspi_data *ax_spi, u8 offset)
+{
+	return axspi_read_reg(ax_spi, offset);
+}
+
+static inline int AX_WRITE(const struct axspi_data *ax_spi, u16 value, u8 offset)
+{
+	return axspi_write_reg(ax_spi, offset, value);
+}
+
+static inline int AX_READ_STATUS(const struct axspi_data *ax_spi,
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
-- 
2.26.2

