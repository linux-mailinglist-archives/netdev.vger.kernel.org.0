Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D4921F0F
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfEQUZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:25:30 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35235 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfEQUZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 16:25:30 -0400
Received: by mail-pl1-f194.google.com with SMTP id g5so3842605plt.2
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 13:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references:to;
        bh=uZY2MwGoQLhOmDNDojM/PSC/gF9SihtqbqXWnNEgFQo=;
        b=oatAWze3Q4K/NxfGiIywx4lhkn+1YXlCbV56mj3ZX8rToO1RZM4YtfEHugnpiyKwCB
         3hCsLi+V831UoG5v4FFcvx5+DHLayvzzdBNO7qxWruKMBG7UqhW+0/6M5FEAnUNjdtZI
         2OOZUGNs5XPkK+F6ANcyzcvDLSGg2vFjdBwlMFQOSHvmOiMnjGGaYREa1YkNlWFctQrW
         5PtP4GuVHOS1pBNWrOSOEhf07yOmg/QF8lPiiPT/Qz4DSEUlHl+2RxB6jH283eUlx2YW
         aAmJtOsAowe9PV65SNb70LJYyfUVPI8ZNCod6Gwm5++hdabBTe5BdYx9lkxBDMAzrHb1
         tJOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references:to;
        bh=uZY2MwGoQLhOmDNDojM/PSC/gF9SihtqbqXWnNEgFQo=;
        b=lZHn08snjLXawNNSdgZMVVjpldYAxyDUPwIGaEESkHIsw4BiWrjlOJVlCieT7PIFaI
         epBGFgpk8Nd0wWP5B/gt9wrNQfF+uA3HNrWMjJ0cj6LmPq4Txf/kmyHVUVDfWro4mvWe
         JX1SQ/0wrmja29h4Voy1BuQaF8Z2Yd2Wl6GwIfMe5RENz390dxMGhMTIdJ0GRhmYkvP9
         7OTwgJw1dSn4cdHwUvYaBjjUVvKoBCVqgE4oU4rpIzG2U1k3jxIRR3oxFlj+yJOBT4Ga
         BN3TB9QvroIeypHshw1bx4OuAmzqI1tAAxFt9h6pYJwBnKdCaJ+NsOp/MiAM8B/dgC7r
         2Stg==
X-Gm-Message-State: APjAAAVEHTr0w8q+dK/DowRTrVCIntQwnYU1ZmSCaiQlT2h8WHtboBaG
        GgElIeU+HtV4pQfdFehuOmw=
X-Google-Smtp-Source: APXvYqzHCmqaVufjgWX5TDyYZ1eU1AQMtMaxiD/yyRMaFShBsaoSuj4+Isj+Lf3zBnTiwi19e8PIsQ==
X-Received: by 2002:a17:902:e287:: with SMTP id cf7mr59356262plb.217.1558124729415;
        Fri, 17 May 2019 13:25:29 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id w194sm26661149pfd.56.2019.05.17.13.25.28
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 17 May 2019 13:25:29 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id DBE0C360082; Sat, 18 May 2019 08:25:25 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     netdev@vger.kernel.org
Cc:     schmitz@debian.org, Michael Schmitz <schmitzmic@gmail.com>,
        sfr@canb.auug.org.au, davem@davemloft.net
Subject: [PATCH 1/3] net: phy: new ax88796b.c Asix Electronics PHY driver
Date:   Sat, 18 May 2019 08:25:16 +1200
Message-Id: <1558124718-19209-2-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1558124718-19209-1-git-send-email-schmitzmic@gmail.com>
References: <1558124718-19209-1-git-send-email-schmitzmic@gmail.com>
In-Reply-To: <20190514105649.512267cd@canb.auug.org.au>
References: <20190514105649.512267cd@canb.auug.org.au>
To:     netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The asix.c driver name causes a module name conflict with a driver
of the same name in drivers/net/usb. Add new ax88796b.c driver to
prepare for removal of drivers/net/phy/asix.c later.

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Fixes: 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
---
 drivers/net/phy/Kconfig    |  6 +++++
 drivers/net/phy/Makefile   |  1 +
 drivers/net/phy/ax88796b.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index d629971..1647473 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -259,6 +259,12 @@ config ASIX_PHY
 	  Currently supports the Asix Electronics PHY found in the X-Surf 100
 	  AX88796B package.
 
+config AX88796B_PHY
+	tristate "Asix PHYs"
+	help
+	  Currently supports the Asix Electronics PHY found in the X-Surf 100
+	  AX88796B package.
+
 config AT803X_PHY
 	tristate "AT803X PHYs"
 	---help---
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 27d7f9f..cc5758a 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -53,6 +53,7 @@ aquantia-objs			+= aquantia_hwmon.o
 endif
 obj-$(CONFIG_AQUANTIA_PHY)	+= aquantia.o
 obj-$(CONFIG_ASIX_PHY)		+= asix.o
+obj-$(CONFIG_AX88796B_PHY)	+= ax88796b.o
 obj-$(CONFIG_AT803X_PHY)	+= at803x.o
 obj-$(CONFIG_BCM63XX_PHY)	+= bcm63xx.o
 obj-$(CONFIG_BCM7XXX_PHY)	+= bcm7xxx.o
diff --git a/drivers/net/phy/ax88796b.c b/drivers/net/phy/ax88796b.c
new file mode 100644
index 0000000..79bf7ef
--- /dev/null
+++ b/drivers/net/phy/ax88796b.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Driver for Asix PHYs
+ *
+ * Author: Michael Schmitz <schmitzmic@gmail.com>
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mii.h>
+#include <linux/phy.h>
+
+#define PHY_ID_ASIX_AX88796B		0x003b1841
+
+MODULE_DESCRIPTION("Asix PHY driver");
+MODULE_AUTHOR("Michael Schmitz <schmitzmic@gmail.com>");
+MODULE_LICENSE("GPL");
+
+/**
+ * asix_soft_reset - software reset the PHY via BMCR_RESET bit
+ * @phydev: target phy_device struct
+ *
+ * Description: Perform a software PHY reset using the standard
+ * BMCR_RESET bit and poll for the reset bit to be cleared.
+ * Toggle BMCR_RESET bit off to accommodate broken AX8796B PHY implementation
+ * such as used on the Individual Computers' X-Surf 100 Zorro card.
+ *
+ * Returns: 0 on success, < 0 on failure
+ */
+static int asix_soft_reset(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Asix PHY won't reset unless reset bit toggles */
+	ret = phy_write(phydev, MII_BMCR, 0);
+	if (ret < 0)
+		return ret;
+
+	return genphy_soft_reset(phydev);
+}
+
+static struct phy_driver asix_driver[] = { {
+	.phy_id		= PHY_ID_ASIX_AX88796B,
+	.name		= "Asix Electronics AX88796B",
+	.phy_id_mask	= 0xfffffff0,
+	/* PHY_BASIC_FEATURES */
+	.soft_reset	= asix_soft_reset,
+} };
+
+module_phy_driver(asix_driver);
+
+static struct mdio_device_id __maybe_unused asix_tbl[] = {
+	{ PHY_ID_ASIX_AX88796B, 0xfffffff0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, asix_tbl);
-- 
1.9.1

