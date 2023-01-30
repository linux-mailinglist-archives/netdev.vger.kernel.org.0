Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B9C681498
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjA3PRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238090AbjA3PQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:16:56 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4F431E27
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 07:16:32 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so10273991wma.1
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 07:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyC0WPiESVFATZgdkk9pkTr4ui49YzPabZztaAdxpeA=;
        b=H4mXe/vo/lr7dTr9p6kfKeuOyyEgETFP+/ki0D99l4xb14APKN8+cfkmRyVp20QkvH
         RAVgEma2eqZp+SGaakRv+DyUYmGASnODJnH0Jfy/62URsADj0mhsKCf5F2SecRpu2l7G
         NL1zrAP/rCGVnTU2+RceRTOo2yaZHEZsPclFB6HfbNMrCpndXKytwm/Kw977S9ANneCg
         eHw7sUv5eWbo9u6cjOWkq3koIEnr5HGy1FLvbJSfxC0lkJcxCt37Imb4WgnE6gec0U/I
         YCT5QkWXnwO8hB49VFIlqaxMjRpVYJhhGxlO3mjGJMgeNc18K+fbntCD+U5y9qsAEtuZ
         jiMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyC0WPiESVFATZgdkk9pkTr4ui49YzPabZztaAdxpeA=;
        b=CpYW2zYbUzQ7g7nkBHklk0q/godA8a2kxv4yTZbrBI0ioZMyou4T8gSP2GN/HM5GuL
         V3Ci5uTo9D3kUZtCn3rmu3AzbD0H6tQM9ZDN12zdY+N5aHOcTkjqScDWv+fI03/NIqsR
         33+aJkY+XPp7aUgVeGuSu2sv5zI4LCeySm14m05aVe5zr+4AIzhvGzwdTmQUV/4QVloQ
         DTVK+NpOA3e6FPFvu9KcuGrm4tE+H5Yd0JvINtdcCerVAN1BM557hyYCj9ouXh4XbFk2
         BkRpf9zCf7vN9+zleQdLnG21a/jGTQWBm762fT/2pA4CJ2qX7mWiBeenDbbjTPHxaX7u
         newA==
X-Gm-Message-State: AO0yUKW2XE0x0Hn8zR0Mhvxzk75FTbLvhzzeO3ge3LveQ8N2npM6sL8t
        A0+QHwpU0F+Y9IGLBQCxmdAdvRpPUmSuGd9L
X-Google-Smtp-Source: AK7set+iSv4SoypTeDtrUTj78tmVgk0ig3A61r9Gs7gXD6xA1NkAgzeiEYDRuZCPpajWX5wOJmcTFg==
X-Received: by 2002:a05:600c:21d5:b0:3dc:50c2:cc1 with SMTP id x21-20020a05600c21d500b003dc50c20cc1mr7092137wmj.23.1675091786745;
        Mon, 30 Jan 2023 07:16:26 -0800 (PST)
Received: from jackdaw.baylibre (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id u12-20020a05600c19cc00b003db0ee277b2sm18735802wmq.5.2023.01.30.07.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 07:16:26 -0800 (PST)
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 2/2] net: mdio: add amlogic gxl mdio mux support
Date:   Mon, 30 Jan 2023 16:16:16 +0100
Message-Id: <20230130151616.375168-3-jbrunet@baylibre.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230130151616.375168-1-jbrunet@baylibre.com>
References: <20230130151616.375168-1-jbrunet@baylibre.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the mdio mux and internal phy glue of the GXL SoC
family

Reported-by: Da Xue <da@lessconfused.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
---
 drivers/net/mdio/Kconfig              |  11 ++
 drivers/net/mdio/Makefile             |   1 +
 drivers/net/mdio/mdio-mux-meson-gxl.c | 164 ++++++++++++++++++++++++++
 3 files changed, 176 insertions(+)
 create mode 100644 drivers/net/mdio/mdio-mux-meson-gxl.c

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index bfa16826a6e1..90309980686e 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -215,6 +215,17 @@ config MDIO_BUS_MUX_MESON_G12A
 	  the amlogic g12a SoC. The multiplexers connects either the external
 	  or the internal MDIO bus to the parent bus.
 
+config MDIO_BUS_MUX_MESON_GXL
+	tristate "Amlogic GXL based MDIO bus multiplexer"
+	depends on ARCH_MESON || COMPILE_TEST
+	depends on OF_MDIO && HAS_IOMEM && COMMON_CLK
+	select MDIO_BUS_MUX
+	default m if ARCH_MESON
+	help
+	  This module provides a driver for the MDIO multiplexer/glue of
+	  the amlogic GXL SoC. The multiplexer connects either the external
+	  or the internal MDIO bus to the parent bus.
+
 config MDIO_BUS_MUX_BCM6368
 	tristate "Broadcom BCM6368 MDIO bus multiplexers"
 	depends on OF && OF_MDIO && (BMIPS_GENERIC || COMPILE_TEST)
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
index 15f8dc4042ce..7d4cb4c11e4e 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -28,5 +28,6 @@ obj-$(CONFIG_MDIO_BUS_MUX_BCM6368)	+= mdio-mux-bcm6368.o
 obj-$(CONFIG_MDIO_BUS_MUX_BCM_IPROC)	+= mdio-mux-bcm-iproc.o
 obj-$(CONFIG_MDIO_BUS_MUX_GPIO)		+= mdio-mux-gpio.o
 obj-$(CONFIG_MDIO_BUS_MUX_MESON_G12A)	+= mdio-mux-meson-g12a.o
+obj-$(CONFIG_MDIO_BUS_MUX_MESON_GXL)	+= mdio-mux-meson-gxl.o
 obj-$(CONFIG_MDIO_BUS_MUX_MMIOREG) 	+= mdio-mux-mmioreg.o
 obj-$(CONFIG_MDIO_BUS_MUX_MULTIPLEXER) 	+= mdio-mux-multiplexer.o
diff --git a/drivers/net/mdio/mdio-mux-meson-gxl.c b/drivers/net/mdio/mdio-mux-meson-gxl.c
new file mode 100644
index 000000000000..76188575ca1f
--- /dev/null
+++ b/drivers/net/mdio/mdio-mux-meson-gxl.c
@@ -0,0 +1,164 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Baylibre, SAS.
+ * Author: Jerome Brunet <jbrunet@baylibre.com>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/mdio-mux.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#define ETH_REG2		0x0
+#define  REG2_PHYID		GENMASK(21, 0)
+#define   EPHY_GXL_ID		0x110181
+#define  REG2_LEDACT		GENMASK(23, 22)
+#define  REG2_LEDLINK		GENMASK(25, 24)
+#define  REG2_DIV4SEL		BIT(27)
+#define  REG2_ADCBYPASS		BIT(30)
+#define  REG2_CLKINSEL		BIT(31)
+#define ETH_REG3		0x4
+#define  REG3_ENH		BIT(3)
+#define  REG3_CFGMODE		GENMASK(6, 4)
+#define  REG3_AUTOMDIX		BIT(7)
+#define  REG3_PHYADDR		GENMASK(12, 8)
+#define  REG3_PWRUPRST		BIT(21)
+#define  REG3_PWRDOWN		BIT(22)
+#define  REG3_LEDPOL		BIT(23)
+#define  REG3_PHYMDI		BIT(26)
+#define  REG3_CLKINEN		BIT(29)
+#define  REG3_PHYIP		BIT(30)
+#define  REG3_PHYEN		BIT(31)
+#define ETH_REG4		0x8
+#define  REG4_PWRUPRSTSIG	BIT(0)
+
+#define MESON_GXL_MDIO_EXTERNAL_ID 0
+#define MESON_GXL_MDIO_INTERNAL_ID 1
+
+struct gxl_mdio_mux {
+	void __iomem *regs;
+	void *mux_handle;
+};
+
+static void gxl_enable_internal_mdio(struct gxl_mdio_mux *priv)
+{
+	u32 val;
+
+	/* Setup the internal phy */
+	val = (REG3_ENH |
+	       FIELD_PREP(REG3_CFGMODE, 0x7) |
+	       REG3_AUTOMDIX |
+	       FIELD_PREP(REG3_PHYADDR, 8) |
+	       REG3_LEDPOL |
+	       REG3_PHYMDI |
+	       REG3_CLKINEN |
+	       REG3_PHYIP);
+
+	writel(REG4_PWRUPRSTSIG, priv->regs + ETH_REG4);
+	writel(val, priv->regs + ETH_REG3);
+	mdelay(10);
+
+	/* NOTE: The HW kept the phy id configurable at runtime.
+	 * The id below is arbitrary. It is the one used in the vendor code.
+	 * The only constraint is that it must match the one in
+	 * drivers/net/phy/meson-gxl.c to properly match the PHY.
+	 */
+	writel(FIELD_PREP(REG2_PHYID, EPHY_GXL_ID),
+	       priv->regs + ETH_REG2);
+
+	/* Enable the internal phy */
+	val |= REG3_PHYEN;
+	writel(val, priv->regs + ETH_REG3);
+	writel(0, priv->regs + ETH_REG4);
+
+	/* The phy needs a bit of time to power up */
+	mdelay(10);
+}
+
+static void gxl_enable_external_mdio(struct gxl_mdio_mux *priv)
+{
+	/* Reset the mdio bus mux to the external phy */
+	writel(0, priv->regs + ETH_REG3);
+}
+
+static int gxl_mdio_switch_fn(int current_child, int desired_child,
+			      void *data)
+{
+	struct gxl_mdio_mux *priv = dev_get_drvdata(data);
+
+	if (current_child == desired_child)
+		return 0;
+
+	switch (desired_child) {
+	case MESON_GXL_MDIO_EXTERNAL_ID:
+		gxl_enable_external_mdio(priv);
+		break;
+	case MESON_GXL_MDIO_INTERNAL_ID:
+		gxl_enable_internal_mdio(priv);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct of_device_id gxl_mdio_mux_match[] = {
+	{ .compatible = "amlogic,gxl-mdio-mux", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, gxl_mdio_mux_match);
+
+static int gxl_mdio_mux_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct gxl_mdio_mux *priv;
+	struct clk *rclk;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, priv);
+
+	priv->regs = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(priv->regs))
+		return PTR_ERR(priv->regs);
+
+	rclk = devm_clk_get_enabled(dev, "ref");
+	if (IS_ERR(rclk))
+		return dev_err_probe(dev, PTR_ERR(rclk),
+				     "failed to get reference clock\n");
+
+	ret = mdio_mux_init(dev, dev->of_node, gxl_mdio_switch_fn,
+			    &priv->mux_handle, dev, NULL);
+	if (ret)
+		dev_err_probe(dev, ret, "mdio multiplexer init failed\n");
+
+	return ret;
+}
+
+static int gxl_mdio_mux_remove(struct platform_device *pdev)
+{
+	struct gxl_mdio_mux *priv = platform_get_drvdata(pdev);
+
+	mdio_mux_uninit(priv->mux_handle);
+
+	return 0;
+}
+
+static struct platform_driver gxl_mdio_mux_driver = {
+	.probe		= gxl_mdio_mux_probe,
+	.remove		= gxl_mdio_mux_remove,
+	.driver		= {
+		.name	= "gxl-mdio-mux",
+		.of_match_table = gxl_mdio_mux_match,
+	},
+};
+module_platform_driver(gxl_mdio_mux_driver);
+
+MODULE_DESCRIPTION("Amlogic GXL MDIO multiplexer driver");
+MODULE_AUTHOR("Jerome Brunet <jbrunet@baylibre.com>");
+MODULE_LICENSE("GPL");
-- 
2.39.0

