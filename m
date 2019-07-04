Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFF75FE6D
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 00:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfGDW3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 18:29:34 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42191 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbfGDW3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 18:29:32 -0400
Received: by mail-lj1-f194.google.com with SMTP id t28so7352364lje.9;
        Thu, 04 Jul 2019 15:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P6HfMwYf12E3ct2GXEIX2U2mOWgCld3CnHKJKlcSLK8=;
        b=FpNyGxi8bx/dEtFX4fPqV73QV5H2IlvWpdnC0ItGnI7JTmLXC8KnGh0BYt2uZMbuCz
         EaNOfRPCbb4W8TBaiAhU53IFiFuquRNUHIB3aJ8Y8UMunU3ogKLgfssLuBwERa/2ixlY
         8Hh/fN+ZlPxPJM2KmxVit5M46XqWR+shcuy6+DHI88lkS7swYZvJD9Tqpbm9wkWuOEMG
         pWdYqKgSKSPZNJfJvRGXVX3NhtAUJXJ22ps9T3TeOPFGc5BIE+F3CLPzuRQZUfUn1Sai
         t6hqINt+672M/jPOn57de8lcBeFJxT5KCfDljcpDJ1ryprEbpBkoMk3T7Iin1RLOajk8
         Gslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P6HfMwYf12E3ct2GXEIX2U2mOWgCld3CnHKJKlcSLK8=;
        b=GHz+0Bh21oHWcjM1Q6kebRD7hR+yjHVoRozP34LopE4+fzRpnVzb7cuW6DJzkV6rVi
         kra8chtamDiQ65cjyDC6hZwXCfS1lj6EizvJW0+NmlFf/ltfOC5uy2jYKJzFClEC8mOn
         z7/Ey8dzErdMOpVBLKL1D3M1jJoaZVxCAhgPXIYh5jZyISiL6gNjKw3HCkN1lwzzyyOW
         DoSs/BqoPowmP50aF4XLwh6V59brllUnm5nziKWrSS3f88wVAa92BdEecKkufNeDPab/
         QH8RbOPTqU+pH9bJYNIoR1iVowiivZMJTxtoiCRa7MEomjD3Du7YGSRVv+FoYATaF7dD
         Zmew==
X-Gm-Message-State: APjAAAUCjd99iU+EG2C3LLqmvcKIxyzxMGquaRYGzE8bHdbejbASdUam
        VFyS6GApH5WU+c3p3hOCOUI=
X-Google-Smtp-Source: APXvYqzIgQbppAN2otzro646zIALc9tdjRVjsybEXhpceW9Dc4wBHNEKdksVEZwrHmk9ATQ1m+HNBA==
X-Received: by 2002:a2e:968e:: with SMTP id q14mr205401lji.195.1562279369794;
        Thu, 04 Jul 2019 15:29:29 -0700 (PDT)
Received: from krolik-desktop.lan ([91.238.216.6])
        by smtp.gmail.com with ESMTPSA id t25sm403645lfg.7.2019.07.04.15.29.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 15:29:29 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>, linus.walleij@linaro.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] net: dsa: vsc73xx: add support for parallel mode
Date:   Fri,  5 Jul 2019 00:29:06 +0200
Message-Id: <20190704222907.2888-4-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190704222907.2888-1-paweldembicki@gmail.com>
References: <20190704222907.2888-1-paweldembicki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add platform part of vsc73xx driver.
It allows to use chip connected to a parallel memory bus and work in
memory-mapped I/O mode. (aka PI bus in chip manual)

By default device is working in big endian mode.

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/Kconfig                    |   9 ++
 drivers/net/dsa/Makefile                   |   1 +
 drivers/net/dsa/vitesse-vsc73xx-platform.c | 164 +++++++++++++++++++++
 3 files changed, 174 insertions(+)
 create mode 100644 drivers/net/dsa/vitesse-vsc73xx-platform.c

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 4ab2aa09e2e4..cf9dbd15dd2d 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -116,4 +116,13 @@ config NET_DSA_VITESSE_VSC73XX_SPI
 	---help---
 	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
 	  and VSC7398 SparX integrated ethernet switches in SPI managed mode.
+
+config NET_DSA_VITESSE_VSC73XX_PLATFORM
+	tristate "Vitesse VSC7385/7388/7395/7398 Platform mode support"
+	depends on HAS_IOMEM
+	select NET_DSA_VITESSE_VSC73XX
+	---help---
+	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
+	  and VSC7398 SparX integrated ethernet switches, connected over
+	  a CPU-attached address bus and work in memory-mapped I/O mode.
 endmenu
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index 117bf78be211..d5e4c668ac03 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_I2C) += lan9303_i2c.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX) += vitesse-vsc73xx-core.o
+obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM) += vitesse-vsc73xx-platform.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_SPI) += vitesse-vsc73xx-spi.o
 obj-y				+= b53/
 obj-y				+= microchip/
diff --git a/drivers/net/dsa/vitesse-vsc73xx-platform.c b/drivers/net/dsa/vitesse-vsc73xx-platform.c
new file mode 100644
index 000000000000..0541785f9fee
--- /dev/null
+++ b/drivers/net/dsa/vitesse-vsc73xx-platform.c
@@ -0,0 +1,164 @@
+// SPDX-License-Identifier: GPL-2.0
+/* DSA driver for:
+ * Vitesse VSC7385 SparX-G5 5+1-port Integrated Gigabit Ethernet Switch
+ * Vitesse VSC7388 SparX-G8 8-port Integrated Gigabit Ethernet Switch
+ * Vitesse VSC7395 SparX-G5e 5+1-port Integrated Gigabit Ethernet Switch
+ * Vitesse VSC7398 SparX-G8e 8-port Integrated Gigabit Ethernet Switch
+ *
+ * This driver takes control of the switch chip connected over CPU-attached
+ * address bus and configures it to route packages around when connected to
+ * a CPU port.
+ *
+ * Copyright (C) 2019 Pawel Dembicki <paweldembicki@gmail.com>
+ * Based on vitesse-vsc-spi.c by:
+ * Copyright (C) 2018 Linus Wallej <linus.walleij@linaro.org>
+ * Includes portions of code from the firmware uploader by:
+ * Copyright (C) 2009 Gabor Juhos <juhosg@openwrt.org>
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include "vitesse-vsc73xx.h"
+
+#define VSC73XX_CMD_PLATFORM_BLOCK_SHIFT		14
+#define VSC73XX_CMD_PLATFORM_BLOCK_MASK			0x7
+#define VSC73XX_CMD_PLATFORM_SUBBLOCK_SHIFT		10
+#define VSC73XX_CMD_PLATFORM_SUBBLOCK_MASK		0xf
+#define VSC73XX_CMD_PLATFORM_REGISTER_SHIFT		2
+
+/**
+ * struct vsc73xx_platform - VSC73xx Platform state container
+ */
+struct vsc73xx_platform {
+	struct platform_device	*pdev;
+	void __iomem		*base_addr;
+	struct vsc73xx		vsc;
+};
+
+static const struct vsc73xx_ops vsc73xx_platform_ops;
+
+static u32 vsc73xx_make_addr(u8 block, u8 subblock, u8 reg)
+{
+	u32 ret;
+
+	ret = (block & VSC73XX_CMD_PLATFORM_BLOCK_MASK)
+	    << VSC73XX_CMD_PLATFORM_BLOCK_SHIFT;
+	ret |= (subblock & VSC73XX_CMD_PLATFORM_SUBBLOCK_MASK)
+	    << VSC73XX_CMD_PLATFORM_SUBBLOCK_SHIFT;
+	ret |= reg << VSC73XX_CMD_PLATFORM_REGISTER_SHIFT;
+
+	return ret;
+}
+
+static int vsc73xx_platform_read(struct vsc73xx *vsc, u8 block, u8 subblock,
+				 u8 reg, u32 *val)
+{
+	struct vsc73xx_platform *vsc_platform = vsc->priv;
+	u32 offset;
+
+	if (!vsc73xx_is_addr_valid(block, subblock))
+		return -EINVAL;
+
+	offset = vsc73xx_make_addr(block, subblock, reg);
+	/* By default vsc73xx running in big-endian mode.
+	 * (See "Register Addressing" section 5.5.3 in the VSC7385 manual.)
+	 */
+	*val = ioread32be(vsc_platform->base_addr + offset);
+
+	return 0;
+}
+
+static int vsc73xx_platform_write(struct vsc73xx *vsc, u8 block, u8 subblock,
+				  u8 reg, u32 val)
+{
+	struct vsc73xx_platform *vsc_platform = vsc->priv;
+	u32 offset;
+
+	if (!vsc73xx_is_addr_valid(block, subblock))
+		return -EINVAL;
+
+	offset = vsc73xx_make_addr(block, subblock, reg);
+	iowrite32be(val, vsc_platform->base_addr + offset);
+
+	return 0;
+}
+
+static int vsc73xx_platform_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct vsc73xx_platform *vsc_platform;
+	struct resource *res = NULL;
+	int ret;
+
+	vsc_platform = devm_kzalloc(dev, sizeof(*vsc_platform), GFP_KERNEL);
+	if (!vsc_platform)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, vsc_platform);
+	vsc_platform->pdev = pdev;
+	vsc_platform->vsc.dev = dev;
+	vsc_platform->vsc.priv = vsc_platform;
+	vsc_platform->vsc.ops = &vsc73xx_platform_ops;
+
+	/* obtain I/O memory space */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "cannot obtain I/O memory space\n");
+		ret = -ENXIO;
+		return ret;
+	}
+
+	vsc_platform->base_addr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(vsc_platform->base_addr)) {
+		dev_err(&pdev->dev, "cannot request I/O memory space\n");
+		ret = -ENXIO;
+		return ret;
+	}
+
+	return vsc73xx_probe(&vsc_platform->vsc);
+}
+
+static int vsc73xx_platform_remove(struct platform_device *pdev)
+{
+	struct vsc73xx_platform *vsc_platform = platform_get_drvdata(pdev);
+
+	return vsc73xx_remove(&vsc_platform->vsc);
+}
+
+static const struct vsc73xx_ops vsc73xx_platform_ops = {
+	.read = vsc73xx_platform_read,
+	.write = vsc73xx_platform_write,
+};
+
+static const struct of_device_id vsc73xx_of_match[] = {
+	{
+		.compatible = "vitesse,vsc7385",
+	},
+	{
+		.compatible = "vitesse,vsc7388",
+	},
+	{
+		.compatible = "vitesse,vsc7395",
+	},
+	{
+		.compatible = "vitesse,vsc7398",
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, vsc73xx_of_match);
+
+static struct platform_driver vsc73xx_platform_driver = {
+	.probe = vsc73xx_platform_probe,
+	.remove = vsc73xx_platform_remove,
+	.driver = {
+		.name = "vsc73xx-platform",
+		.of_match_table = vsc73xx_of_match,
+	},
+};
+module_platform_driver(vsc73xx_platform_driver);
+
+MODULE_AUTHOR("Pawel Dembicki <paweldembicki@gmail.com>");
+MODULE_DESCRIPTION("Vitesse VSC7385/7388/7395/7398 Platform driver");
+MODULE_LICENSE("GPL v2");
-- 
2.20.1

