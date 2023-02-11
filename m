Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6782692DBE
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjBKDTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjBKDTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:19:24 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD97F85B09;
        Fri, 10 Feb 2023 19:18:56 -0800 (PST)
Received: from localhost (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 46C9F6602116;
        Sat, 11 Feb 2023 03:18:55 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676085535;
        bh=TwwenY6La9ML4nip9B8ZX+9fLGGbM4jAo/uXYp0Qk4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKKkxrnUMuOi0Jh4iaoScbQdgxmTpT21oDKQCOanqE8R1krG6V9W13cJ50yrqcsVo
         +ucoeJ7OsadEO/0r4YYaXdoMCiUprTqbLHRIbmesNRuTkWJZcGF4WHwNEWFlMiDv7V
         cOX+NXcfXAB8TL+niHinGc5huEX+FnSVX89Jlvock4vuc54MDerKLyeQxlPSplwOFB
         N6fGJaqAHupHho1yyqlmwZqx+xRY2NkM3BM1zTh8UFFWe8KdmkWU2iYgbibZ3yPwmX
         om419IAXnIh0hH6Nq1tCvUHRsdq/OvvC60e6GbktI11Ny1+1hSiprEMCd0UVRLRt31
         ukA0TQq82HJYw==
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
To:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Subject: [PATCH 08/12] net: stmmac: Add glue layer for StarFive JH7100 SoC
Date:   Sat, 11 Feb 2023 05:18:17 +0200
Message-Id: <20230211031821.976408-9-cristian.ciocaltea@collabora.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emil Renner Berthing <kernel@esmil.dk>

This adds a glue layer for the Synopsys DesignWare MAC IP core on the
StarFive JH7100 SoC.

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
[drop references to JH7110, update JH7100 compatible string]
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
---
 MAINTAINERS                                   |   1 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 155 ++++++++++++++++++
 4 files changed, 169 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c

diff --git a/MAINTAINERS b/MAINTAINERS
index d48468b81b94..defedaff6041 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19820,6 +19820,7 @@ STARFIVE DWMAC GLUE LAYER
 M:	Emil Renner Berthing <kernel@esmil.dk>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/starfive,jh7100-dwmac.yaml
+F:	drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
 
 STARFIVE JH7100 CLOCK DRIVERS
 M:	Emil Renner Berthing <kernel@esmil.dk>
diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index f77511fe4e87..2c81aa594291 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -165,6 +165,18 @@ config DWMAC_SOCFPGA
 	  for the stmmac device driver. This driver is used for
 	  arria5 and cyclone5 FPGA SoCs.
 
+config DWMAC_STARFIVE
+	tristate "StarFive DWMAC support"
+	default m if SOC_STARFIVE
+	depends on SOC_STARFIVE || COMPILE_TEST
+	select MFD_SYSCON
+	help
+	  Support for ethernet controller on StarFive SOCs.
+
+	  This selects StarFive SoC glue layer support for the stmmac device
+	  driver. This driver is used for the JH71x0 series GMAC ethernet
+	  controller.
+
 config DWMAC_STI
 	tristate "STi GMAC support"
 	default ARCH_STI
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index 057e4bab5c08..8738fdbb4b2d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_DWMAC_OXNAS)	+= dwmac-oxnas.o
 obj-$(CONFIG_DWMAC_QCOM_ETHQOS)	+= dwmac-qcom-ethqos.o
 obj-$(CONFIG_DWMAC_ROCKCHIP)	+= dwmac-rk.o
 obj-$(CONFIG_DWMAC_SOCFPGA)	+= dwmac-altr-socfpga.o
+obj-$(CONFIG_DWMAC_STARFIVE)	+= dwmac-starfive.o
 obj-$(CONFIG_DWMAC_STI)		+= dwmac-sti.o
 obj-$(CONFIG_DWMAC_STM32)	+= dwmac-stm32.o
 obj-$(CONFIG_DWMAC_SUNXI)	+= dwmac-sunxi.o
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
new file mode 100644
index 000000000000..d4c81f1a5482
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * dwmac-starfive.c - DWMAC glue layer for StarFive JH7100 SoC
+ *
+ * Copyright (C) 2021 Emil Renner Berthing <kernel@esmil.dk>
+ */
+
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+
+#include "stmmac.h"
+#include "stmmac_platform.h"
+
+#define JH7100_SYSMAIN_REGISTER28 0x70
+/* The value below is not a typo, just really bad naming by StarFive ¯\_(ツ)_/¯ */
+#define JH7100_SYSMAIN_REGISTER49 0xc8
+
+struct dwmac_starfive {
+	struct device *dev;
+	struct clk *gtxc;
+};
+
+static int dwmac_starfive_jh7100_syscon_init(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct regmap *sysmain;
+	u32 gtxclk_dlychain;
+	int ret;
+
+	sysmain = syscon_regmap_lookup_by_phandle(np, "starfive,syscon");
+	if (IS_ERR(sysmain))
+		return dev_err_probe(dev, PTR_ERR(sysmain),
+				     "error getting sysmain registers\n");
+
+	/* Choose RGMII interface to the phy.
+	 * TODO: support other interfaces once we know the meaning of other
+	 * values in the register
+	 */
+	ret = regmap_update_bits(sysmain, JH7100_SYSMAIN_REGISTER28, 0x7, 1);
+	if (ret)
+		return dev_err_probe(dev, ret, "error selecting gmac interface\n");
+
+	if (!of_property_read_u32(np, "starfive,gtxclk-dlychain", &gtxclk_dlychain)) {
+		ret = regmap_write(sysmain, JH7100_SYSMAIN_REGISTER49, gtxclk_dlychain);
+		if (ret)
+			return dev_err_probe(dev, ret, "error selecting gtxclk delay chain\n");
+	}
+
+	return 0;
+}
+
+static void dwmac_starfive_fix_mac_speed(void *data, unsigned int speed)
+{
+	struct dwmac_starfive *dwmac = data;
+	unsigned long rate;
+	int ret;
+
+	switch (speed) {
+	case SPEED_1000:
+		rate = 125000000;
+		break;
+	case SPEED_100:
+		rate = 25000000;
+		break;
+	case SPEED_10:
+		rate = 2500000;
+		break;
+	default:
+		dev_warn(dwmac->dev, "unsupported link speed %u\n", speed);
+		return;
+	}
+
+	ret = clk_set_rate(dwmac->gtxc, rate);
+	if (ret)
+		dev_err(dwmac->dev, "error setting gtx clock rate: %d\n", ret);
+}
+
+static int dwmac_starfive_probe(struct platform_device *pdev)
+{
+	struct stmmac_resources stmmac_res;
+	struct plat_stmmacenet_data *plat;
+	struct dwmac_starfive *dwmac;
+	struct clk *txclk;
+	int (*syscon_init)(struct device *dev);
+	int ret;
+
+	dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
+	if (!dwmac)
+		return -ENOMEM;
+
+	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
+	if (ret)
+		return ret;
+
+	syscon_init = of_device_get_match_data(&pdev->dev);
+	if (syscon_init) {
+		ret = syscon_init(&pdev->dev);
+		if (ret)
+			return ret;
+	}
+
+	dwmac->gtxc = devm_clk_get_enabled(&pdev->dev, "gtxc");
+	if (IS_ERR(dwmac->gtxc))
+		return dev_err_probe(&pdev->dev, PTR_ERR(dwmac->gtxc),
+				     "error getting/enabling gtxc clock\n");
+
+	txclk = devm_clk_get_enabled(&pdev->dev, "tx");
+	if (IS_ERR(txclk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(txclk),
+				     "error getting/enabling tx clock\n");
+
+	plat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
+	if (IS_ERR(plat))
+		return dev_err_probe(&pdev->dev, PTR_ERR(plat),
+				     "dt configuration failed\n");
+
+	dwmac->dev = &pdev->dev;
+	plat->bsp_priv = dwmac;
+	plat->fix_mac_speed = dwmac_starfive_fix_mac_speed;
+
+	ret = stmmac_dvr_probe(&pdev->dev, plat, &stmmac_res);
+	if (ret) {
+		stmmac_remove_config_dt(pdev, plat);
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct of_device_id dwmac_starfive_match[] = {
+	{
+		.compatible = "starfive,jh7100-dwmac",
+		.data = dwmac_starfive_jh7100_syscon_init,
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, dwmac_starfive_match);
+
+static struct platform_driver dwmac_starfive_driver = {
+	.probe  = dwmac_starfive_probe,
+	.remove = stmmac_pltfr_remove,
+	.driver = {
+		.name           = "dwmac-starfive",
+		.pm		= &stmmac_pltfr_pm_ops,
+		.of_match_table = dwmac_starfive_match,
+	},
+};
+module_platform_driver(dwmac_starfive_driver);
+
+MODULE_AUTHOR("Emil Renner Berthing <kernel@esmil.dk>");
+MODULE_DESCRIPTION("StarFive DWMAC Glue Layer");
+MODULE_LICENSE("GPL");
-- 
2.39.1

