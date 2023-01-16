Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C017E66BA16
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjAPJRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjAPJRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:17:00 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AA713D52
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:16:59 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id fl11-20020a05600c0b8b00b003daf72fc844so2010491wmb.0
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dgMVlL2MF8oJlM5fHKB3o7u/n5s4tpW/nx3DYglTQ3w=;
        b=Lr4KnPV/ZIdVdUiIdzHEdrmaBFGlMJloHnaJrFmO/qO3VrpXI4HlI7LXFihXAyOiFt
         j0S0HNEvZc8XljiIxnte4D/7wNW6aT0pCuK3IuBSPOpcJYflJpJXHuZfJ9llVWviSmZ8
         Km5EQeN8BjjFJRcy4AaP3VryWUiUEx2j5pIkudJ/NK3QlS0QOivUoTfUh5XhWNtylr7p
         U68c68omVyvLRE97q4nsbw8KZWlUuwX0fZp7+sPDPk8lb800d3tH/nKWmT5F7UNbD7tg
         jGIY2PwRYdE28wRkg6y4eTdbGmlhqWk+GuiebLPxiLWx32Nt6Nb0n4D/TBmBZy49nyPR
         pyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dgMVlL2MF8oJlM5fHKB3o7u/n5s4tpW/nx3DYglTQ3w=;
        b=cQpEvr8s6h7GJSwH5lkrs3CmOiMCMEgUbSI5m6qj82LYdZrx38vhJpNnJQQO0nt8hE
         VVK2yac1hwba1QQb9YWAUMCBiUPzJZU/h9Hw10fdWPKJPKqo6qUpJ16rrDof92nzqAu3
         m6DGawsz3e2XNHJGvWSV03HO3YQh8KJ7yShzx0rIR2jHHZzVCw7HMQGlTx/Glm+5t6SJ
         lxfxQUM9BZK4+yX4nNuDrghH92xguImg5tf3k97t3NkhZZvSzKvBJC4YV3k7wE8jxwU0
         fGUSqw1bK71dFWIGE1xEzL+jHuQ8AHqzooeCdir8VsCJnkqw6A8y+stKrKaA5UZZqwj2
         TzqA==
X-Gm-Message-State: AFqh2koIsgrSIaltUDlu/f9x1vrLLIHNAffoJ+oMxLPUEYFgkl1lcsjj
        MudpWir9rGSKBPWarvYT0bhhQ9B/nwh/jOhO
X-Google-Smtp-Source: AMrXdXvOiiNUcVFngBw4gAvrjG+E6mQhC5DXwRwZ8wY63DLaMVfmjULbmGpFfCrm6Ii7+EGmgSNykQ==
X-Received: by 2002:a05:600c:1e8c:b0:3d6:2952:679b with SMTP id be12-20020a05600c1e8c00b003d62952679bmr65977500wmb.34.1673860617638;
        Mon, 16 Jan 2023 01:16:57 -0800 (PST)
Received: from localhost.localdomain (82-65-169-74.subs.proxad.net. [82.65.169.74])
        by smtp.googlemail.com with ESMTPSA id h19-20020a05600c351300b003d9a86a13bfsm35923491wmq.28.2023.01.16.01.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 01:16:57 -0800 (PST)
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: mdio: add amlogic gxl mdio mux support
Date:   Mon, 16 Jan 2023 10:16:36 +0100
Message-Id: <20230116091637.272923-3-jbrunet@baylibre.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116091637.272923-1-jbrunet@baylibre.com>
References: <20230116091637.272923-1-jbrunet@baylibre.com>
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

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
---
 drivers/net/mdio/Kconfig              |  11 ++
 drivers/net/mdio/Makefile             |   1 +
 drivers/net/mdio/mdio-mux-meson-gxl.c | 160 ++++++++++++++++++++++++++
 3 files changed, 172 insertions(+)
 create mode 100644 drivers/net/mdio/mdio-mux-meson-gxl.c

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index bfa16826a6e1..80f3e10b1be1 100644
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
+	  the amlogic gxl SoC. The multiplexers connects either the external
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
index 000000000000..205095d845ea
--- /dev/null
+++ b/drivers/net/mdio/mdio-mux-meson-gxl.c
@@ -0,0 +1,160 @@
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
+static int gxl_enable_internal_mdio(struct gxl_mdio_mux *priv)
+{
+	u32 val;
+
+ 	/* Setup the internal phy */
+	val = (REG3_ENH |
+	       FIELD_PREP(REG3_CFGMODE, 0x7) |
+	       REG3_AUTOMDIX |
+	       FIELD_PREP(REG3_PHYADDR, 8) |
+	       REG3_LEDPOL |
+	       REG3_PHYMDI |
+	       REG3_CLKINEN |
+	       REG3_PHYIP);
+
+	writel_relaxed(REG4_PWRUPRSTSIG, priv->regs + ETH_REG4);
+	writel_relaxed(val, priv->regs + ETH_REG3);
+	mdelay(10);
+
+	/* Set the internal phy id */
+	writel_relaxed(FIELD_PREP(REG2_PHYID, 0x110181),
+		       priv->regs + ETH_REG2);
+
+	/* Enable the internal phy */
+	val |= REG3_PHYEN;
+	writel_relaxed(val, priv->regs + ETH_REG3);
+	writel_relaxed(0, priv->regs + ETH_REG4);
+
+	/* The phy needs a bit of time to come up */
+	mdelay(10);
+
+	return 0;
+}
+
+static int gxl_enable_external_mdio(struct gxl_mdio_mux *priv)
+{
+ 	/* Reset the mdio bus mux to the external phy */
+	writel_relaxed(0, priv->regs + ETH_REG3);
+
+	return 0;
+}
+
+static int gxl_mdio_switch_fn(int current_child, int desired_child,
+			       void *data)
+{
+	struct gxl_mdio_mux *priv = dev_get_drvdata(data);
+
+	if (current_child == desired_child)
+		return 0;
+
+	switch (desired_child) {
+	case MESON_GXL_MDIO_EXTERNAL_ID:
+		return gxl_enable_external_mdio(priv);
+	case MESON_GXL_MDIO_INTERNAL_ID:
+		return gxl_enable_internal_mdio(priv);
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct of_device_id gxl_mdio_mux_match[] = {
+	{ .compatible = "amlogic,gxl-mdio-mux", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, gxl_mdio_mux_match);
+
+
+static int gxl_mdio_mux_probe(struct platform_device *pdev){
+	struct device *dev = &pdev->dev;
+	struct clk *rclk;
+	struct gxl_mdio_mux *priv;
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
+MODULE_LICENSE("GPL v2");
-- 
2.39.0

