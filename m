Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D77BE5EA50
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 19:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfGCRV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 13:21:28 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46692 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbfGCRV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 13:21:27 -0400
Received: by mail-lj1-f196.google.com with SMTP id v24so3277636ljg.13;
        Wed, 03 Jul 2019 10:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fUA70AhGkjFAyWQmQUkpwLIPYFCryqujMf1Aums5m7s=;
        b=l+TcirvDEUuAkmJiNEiOYsXsg80ufp8IITDDlsoKkWcr12Gk8f2pwVS4ga2ix4iPAx
         DfaXtdy6wyoKxi7EVgKCRBSSZWN9NlSsSXIyfinHVK3Opzw1yUa5W77fqTGiOeF8E4Bz
         4m9sSTfNMx948/mZ2JHPtH97aUzDD2ourIbDd70LUBe6JfnwIAYNFTnoPwKEj3HBaAYs
         m6GFo8+jo0WtUPYCQIDy0GSsVG0nQIw0Enyy889A0H/Yx7T/an+BNvFEY8DY8u3HDr0c
         BbzNhLjL/fTuYlpUeN+aWO7o8+CX2XsGJTgJ9tUwosGCjd5blAExrp5gdKnBixL0DROS
         /i7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fUA70AhGkjFAyWQmQUkpwLIPYFCryqujMf1Aums5m7s=;
        b=mLmS8FNfFPPVJvqw4iDPg6IEnqZWH6FzC2fOsuwrh2+ax1TWyqAfO81HlUbwNsGl0h
         e2DrvS8yjiz/9T6yPTs0WhBPrCQf2klmSpLLkOWEWKub6tbEEzp8UfZrnDBBjutW0FR+
         2hVJO2kzxCtWpD9C0W/w/MlTM0wwLDhHqZ7lFLzNRWD33f6c2IQ7tcY2b31ZoxxyWpXG
         CAilm9scKvdGvAA4m7P8traCHqvrMGX3TudRN9kP/VA5qf4cUVBclns6pgyApQeKaJnh
         hRWhGVy+Md/x3ySGyIV4YXO167bBvqxGeNmXrMICGryFitmZtR4vdCSKg1ZorXXxI4/f
         HY3g==
X-Gm-Message-State: APjAAAWHh21H//4wC9ZQ2kHwH8UFu5SiqKkrj7MNF8Yff/wwBuwoxhLO
        dqt+3JypkJXgLftmmCpmFnY=
X-Google-Smtp-Source: APXvYqxiW5pXEUsyUeZXyHXGBGfLeftFOhCVn46TReVlfAZFrTR1fJjg3s9vDLkWLYape8bBPH2zBw==
X-Received: by 2002:a2e:8846:: with SMTP id z6mr21204488ljj.20.1562174483351;
        Wed, 03 Jul 2019 10:21:23 -0700 (PDT)
Received: from krolik-desktop.lan ([91.238.216.6])
        by smtp.gmail.com with ESMTPSA id 11sm581165ljc.66.2019.07.03.10.21.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 10:21:22 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>, linus.walleij@linaro.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] net: dsa: vsc73xx: add support for parallel mode
Date:   Wed,  3 Jul 2019 19:19:23 +0200
Message-Id: <20190703171924.31801-4-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703171924.31801-1-paweldembicki@gmail.com>
References: <20190703171924.31801-1-paweldembicki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add platform part of vsc73xx driver.
It allows to use chip connected by parallel interface.

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
---
 drivers/net/dsa/Kconfig                    |   8 ++
 drivers/net/dsa/Makefile                   |   1 +
 drivers/net/dsa/vitesse-vsc73xx-platform.c | 160 +++++++++++++++++++++
 3 files changed, 169 insertions(+)
 create mode 100644 drivers/net/dsa/vitesse-vsc73xx-platform.c

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 4ab2aa09e2e4..80965808949d 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -116,4 +116,12 @@ config NET_DSA_VITESSE_VSC73XX_SPI
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
+	  and VSC7398 SparX integrated ethernet switches in Platform managed mode.
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
index 000000000000..f41dbacd0b19
--- /dev/null
+++ b/drivers/net/dsa/vitesse-vsc73xx-platform.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0
+/* DSA driver for:
+ * Vitesse VSC7385 SparX-G5 5+1-port Integrated Gigabit Ethernet Switch
+ * Vitesse VSC7388 SparX-G8 8-port Integrated Gigabit Ethernet Switch
+ * Vitesse VSC7395 SparX-G5e 5+1-port Integrated Gigabit Ethernet Switch
+ * Vitesse VSC7398 SparX-G8e 8-port Integrated Gigabit Ethernet Switch
+ *
+ * This driver takes control of the switch chip over Platform and
+ * configures it to route packages around when connected to a CPU port.
+ *
+ * Copyright (C) 2019 pawel Dembicki <paweldembicki@gmail.com>
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

