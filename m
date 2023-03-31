Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F405A6D1A21
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjCaIfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjCaIe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:34:58 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCE81C1EC
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:52 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e18so21583395wra.9
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251691;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xHB6iDThXcrHPiUZPbOms1jUqgGK29VYjf8IjMfRyFw=;
        b=OU1zLuH7o+NOr2m6B7SrO4o0iHam3EmzoXHKLsgK9BYloCMtfK/nowyatORufCCuN1
         0S2YS1Jf8IdII/0kL6aZikOCpl4gPmJusga/jGIu5RJTCZQSnPRu0bT6l47T3zz10RP6
         McxdVUz7aOeaWEmmB93vHrWKRqDR0V4G8KIQheRtjvbxfjYUC7p1Tr/gQJhUqodf9UbX
         cfPIB4b7qt3CGsKHc7troZnh6xgZkYMWXzKDJwnMrJ6hhKvoxgQ/Hhd3Wgg51BPEfzhN
         yPMp3R5Ti2h1FWChvDvtH7XyexKUL1drTYJ0fwNaM4djZfI2kHkDr7Fn1XDVvEJpp7zv
         vtFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251691;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xHB6iDThXcrHPiUZPbOms1jUqgGK29VYjf8IjMfRyFw=;
        b=lahWM0QNLquN2DnPVewWyTkstW96YgI7+dTlu1Xam+dpekO/7zXZDccuQwB4eCYL5h
         HtX3z2svSmsntWTC7cnQ/raAVuG9LX6fNOl0UiaIq4IsbUvhMm/PTjM1pG7xvvxBo9sa
         Ch41CVt+V9BUe2dgBA5ggLeJUnwx+kKHIFz9qslTsXnrDdk9GFo0Cp+zYX9xv9F+/DPY
         n2xO+Fc/gyZplVAGrQBjgFbqXUtubrSvnxSeK98VDKUYUIYAghIktpvEjE8xj8OulZoX
         hVmJ+aeu6h79eZrBjBnvvgauCblgUynlngg3PVn+Ql8jSdcQMSxBNqgrM1opzpYCW66K
         jEuA==
X-Gm-Message-State: AAQBX9cNvvL/nxbuahGE661KSmmgeMChf95chaK28156JglErhpWL57g
        VLlKurz2+USR8KryDLkOwwfvMQ==
X-Google-Smtp-Source: AKy350YZVgjYN18xwfhWJYe5j5yka9+JqQ6bvN6apomApI+PZnxn/a2kxojIM0PPJc8qiiYSR2kMoA==
X-Received: by 2002:a5d:5411:0:b0:2c7:a9ec:3 with SMTP id g17-20020a5d5411000000b002c7a9ec0003mr21286471wrv.65.1680251691044;
        Fri, 31 Mar 2023 01:34:51 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:34:50 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:43 +0200
Subject: [PATCH RFC 05/20] clk: oxnas: remove obsolete clock driver
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-5-5bd58fd1dd1f@linaro.org>
References: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
In-Reply-To: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sebastian Reichel <sre@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to lack of maintainance and stall of development for a few years now,
and since no new features will ever be added upstream, remove support
for OX810 and OX820 clock driver.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/clk/Kconfig     |   7 --
 drivers/clk/Makefile    |   1 -
 drivers/clk/clk-oxnas.c | 251 ------------------------------------------------
 3 files changed, 259 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index b6c5bf69a2b2..7ac31d00f03a 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -351,13 +351,6 @@ config COMMON_CLK_PXA
 	help
 	  Support for the Marvell PXA SoC.
 
-config COMMON_CLK_OXNAS
-	bool "Clock driver for the OXNAS SoC Family"
-	depends on ARCH_OXNAS || COMPILE_TEST
-	select MFD_SYSCON
-	help
-	  Support for the OXNAS SoC Family clocks.
-
 config COMMON_CLK_RS9_PCIE
 	tristate "Clock driver for Renesas 9-series PCIe clock generators"
 	depends on I2C
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index e3ca0d058a25..fea32d60f1d9 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -50,7 +50,6 @@ obj-$(CONFIG_ARCH_MOXART)		+= clk-moxart.o
 obj-$(CONFIG_ARCH_NOMADIK)		+= clk-nomadik.o
 obj-$(CONFIG_ARCH_NPCM7XX)	    	+= clk-npcm7xx.o
 obj-$(CONFIG_ARCH_NSPIRE)		+= clk-nspire.o
-obj-$(CONFIG_COMMON_CLK_OXNAS)		+= clk-oxnas.o
 obj-$(CONFIG_COMMON_CLK_PALMAS)		+= clk-palmas.o
 obj-$(CONFIG_CLK_LS1028A_PLLDIG)	+= clk-plldig.o
 obj-$(CONFIG_COMMON_CLK_PWM)		+= clk-pwm.o
diff --git a/drivers/clk/clk-oxnas.c b/drivers/clk/clk-oxnas.c
deleted file mode 100644
index 584e293156ad..000000000000
--- a/drivers/clk/clk-oxnas.c
+++ /dev/null
@@ -1,251 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright (C) 2010 Broadcom
- * Copyright (C) 2012 Stephen Warren
- * Copyright (C) 2016 Neil Armstrong <narmstrong@baylibre.com>
- */
-
-#include <linux/clk-provider.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
-#include <linux/platform_device.h>
-#include <linux/stringify.h>
-#include <linux/regmap.h>
-#include <linux/mfd/syscon.h>
-
-#include <dt-bindings/clock/oxsemi,ox810se.h>
-#include <dt-bindings/clock/oxsemi,ox820.h>
-
-/* Standard regmap gate clocks */
-struct clk_oxnas_gate {
-	struct clk_hw hw;
-	unsigned int bit;
-	struct regmap *regmap;
-};
-
-struct oxnas_stdclk_data {
-	struct clk_hw_onecell_data *onecell_data;
-	struct clk_oxnas_gate **gates;
-	unsigned int ngates;
-	struct clk_oxnas_pll **plls;
-	unsigned int nplls;
-};
-
-/* Regmap offsets */
-#define CLK_STAT_REGOFFSET	0x24
-#define CLK_SET_REGOFFSET	0x2c
-#define CLK_CLR_REGOFFSET	0x30
-
-static inline struct clk_oxnas_gate *to_clk_oxnas_gate(struct clk_hw *hw)
-{
-	return container_of(hw, struct clk_oxnas_gate, hw);
-}
-
-static int oxnas_clk_gate_is_enabled(struct clk_hw *hw)
-{
-	struct clk_oxnas_gate *std = to_clk_oxnas_gate(hw);
-	int ret;
-	unsigned int val;
-
-	ret = regmap_read(std->regmap, CLK_STAT_REGOFFSET, &val);
-	if (ret < 0)
-		return ret;
-
-	return val & BIT(std->bit);
-}
-
-static int oxnas_clk_gate_enable(struct clk_hw *hw)
-{
-	struct clk_oxnas_gate *std = to_clk_oxnas_gate(hw);
-
-	regmap_write(std->regmap, CLK_SET_REGOFFSET, BIT(std->bit));
-
-	return 0;
-}
-
-static void oxnas_clk_gate_disable(struct clk_hw *hw)
-{
-	struct clk_oxnas_gate *std = to_clk_oxnas_gate(hw);
-
-	regmap_write(std->regmap, CLK_CLR_REGOFFSET, BIT(std->bit));
-}
-
-static const struct clk_ops oxnas_clk_gate_ops = {
-	.enable = oxnas_clk_gate_enable,
-	.disable = oxnas_clk_gate_disable,
-	.is_enabled = oxnas_clk_gate_is_enabled,
-};
-
-static const char *const osc_parents[] = {
-	"oscillator",
-};
-
-static const char *const eth_parents[] = {
-	"gmacclk",
-};
-
-#define OXNAS_GATE(_name, _bit, _parents)				\
-struct clk_oxnas_gate _name = {						\
-	.bit = (_bit),							\
-	.hw.init = &(struct clk_init_data) {				\
-		.name = #_name,						\
-		.ops = &oxnas_clk_gate_ops,				\
-		.parent_names = _parents,				\
-		.num_parents = ARRAY_SIZE(_parents),			\
-		.flags = (CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED),	\
-	},								\
-}
-
-static OXNAS_GATE(ox810se_leon, 0, osc_parents);
-static OXNAS_GATE(ox810se_dma_sgdma, 1, osc_parents);
-static OXNAS_GATE(ox810se_cipher, 2, osc_parents);
-static OXNAS_GATE(ox810se_sata, 4, osc_parents);
-static OXNAS_GATE(ox810se_audio, 5, osc_parents);
-static OXNAS_GATE(ox810se_usbmph, 6, osc_parents);
-static OXNAS_GATE(ox810se_etha, 7, eth_parents);
-static OXNAS_GATE(ox810se_pciea, 8, osc_parents);
-static OXNAS_GATE(ox810se_nand, 9, osc_parents);
-
-static struct clk_oxnas_gate *ox810se_gates[] = {
-	&ox810se_leon,
-	&ox810se_dma_sgdma,
-	&ox810se_cipher,
-	&ox810se_sata,
-	&ox810se_audio,
-	&ox810se_usbmph,
-	&ox810se_etha,
-	&ox810se_pciea,
-	&ox810se_nand,
-};
-
-static OXNAS_GATE(ox820_leon, 0, osc_parents);
-static OXNAS_GATE(ox820_dma_sgdma, 1, osc_parents);
-static OXNAS_GATE(ox820_cipher, 2, osc_parents);
-static OXNAS_GATE(ox820_sd, 3, osc_parents);
-static OXNAS_GATE(ox820_sata, 4, osc_parents);
-static OXNAS_GATE(ox820_audio, 5, osc_parents);
-static OXNAS_GATE(ox820_usbmph, 6, osc_parents);
-static OXNAS_GATE(ox820_etha, 7, eth_parents);
-static OXNAS_GATE(ox820_pciea, 8, osc_parents);
-static OXNAS_GATE(ox820_nand, 9, osc_parents);
-static OXNAS_GATE(ox820_ethb, 10, eth_parents);
-static OXNAS_GATE(ox820_pcieb, 11, osc_parents);
-static OXNAS_GATE(ox820_ref600, 12, osc_parents);
-static OXNAS_GATE(ox820_usbdev, 13, osc_parents);
-
-static struct clk_oxnas_gate *ox820_gates[] = {
-	&ox820_leon,
-	&ox820_dma_sgdma,
-	&ox820_cipher,
-	&ox820_sd,
-	&ox820_sata,
-	&ox820_audio,
-	&ox820_usbmph,
-	&ox820_etha,
-	&ox820_pciea,
-	&ox820_nand,
-	&ox820_etha,
-	&ox820_pciea,
-	&ox820_ref600,
-	&ox820_usbdev,
-};
-
-static struct clk_hw_onecell_data ox810se_hw_onecell_data = {
-	.hws = {
-		[CLK_810_LEON]	= &ox810se_leon.hw,
-		[CLK_810_DMA_SGDMA]	= &ox810se_dma_sgdma.hw,
-		[CLK_810_CIPHER]	= &ox810se_cipher.hw,
-		[CLK_810_SATA]	= &ox810se_sata.hw,
-		[CLK_810_AUDIO]	= &ox810se_audio.hw,
-		[CLK_810_USBMPH]	= &ox810se_usbmph.hw,
-		[CLK_810_ETHA]	= &ox810se_etha.hw,
-		[CLK_810_PCIEA]	= &ox810se_pciea.hw,
-		[CLK_810_NAND]	= &ox810se_nand.hw,
-	},
-	.num = ARRAY_SIZE(ox810se_gates),
-};
-
-static struct clk_hw_onecell_data ox820_hw_onecell_data = {
-	.hws = {
-		[CLK_820_LEON]	= &ox820_leon.hw,
-		[CLK_820_DMA_SGDMA]	= &ox820_dma_sgdma.hw,
-		[CLK_820_CIPHER]	= &ox820_cipher.hw,
-		[CLK_820_SD]	= &ox820_sd.hw,
-		[CLK_820_SATA]	= &ox820_sata.hw,
-		[CLK_820_AUDIO]	= &ox820_audio.hw,
-		[CLK_820_USBMPH]	= &ox820_usbmph.hw,
-		[CLK_820_ETHA]	= &ox820_etha.hw,
-		[CLK_820_PCIEA]	= &ox820_pciea.hw,
-		[CLK_820_NAND]	= &ox820_nand.hw,
-		[CLK_820_ETHB]	= &ox820_ethb.hw,
-		[CLK_820_PCIEB]	= &ox820_pcieb.hw,
-		[CLK_820_REF600]	= &ox820_ref600.hw,
-		[CLK_820_USBDEV]	= &ox820_usbdev.hw,
-	},
-	.num = ARRAY_SIZE(ox820_gates),
-};
-
-static struct oxnas_stdclk_data ox810se_stdclk_data = {
-	.onecell_data = &ox810se_hw_onecell_data,
-	.gates = ox810se_gates,
-	.ngates = ARRAY_SIZE(ox810se_gates),
-};
-
-static struct oxnas_stdclk_data ox820_stdclk_data = {
-	.onecell_data = &ox820_hw_onecell_data,
-	.gates = ox820_gates,
-	.ngates = ARRAY_SIZE(ox820_gates),
-};
-
-static const struct of_device_id oxnas_stdclk_dt_ids[] = {
-	{ .compatible = "oxsemi,ox810se-stdclk", &ox810se_stdclk_data },
-	{ .compatible = "oxsemi,ox820-stdclk", &ox820_stdclk_data },
-	{ }
-};
-
-static int oxnas_stdclk_probe(struct platform_device *pdev)
-{
-	struct device_node *np = pdev->dev.of_node, *parent_np;
-	const struct oxnas_stdclk_data *data;
-	struct regmap *regmap;
-	int ret;
-	int i;
-
-	data = of_device_get_match_data(&pdev->dev);
-
-	parent_np = of_get_parent(np);
-	regmap = syscon_node_to_regmap(parent_np);
-	of_node_put(parent_np);
-	if (IS_ERR(regmap)) {
-		dev_err(&pdev->dev, "failed to have parent regmap\n");
-		return PTR_ERR(regmap);
-	}
-
-	for (i = 0 ; i < data->ngates ; ++i)
-		data->gates[i]->regmap = regmap;
-
-	for (i = 0; i < data->onecell_data->num; i++) {
-		if (!data->onecell_data->hws[i])
-			continue;
-
-		ret = devm_clk_hw_register(&pdev->dev,
-					   data->onecell_data->hws[i]);
-		if (ret)
-			return ret;
-	}
-
-	return of_clk_add_hw_provider(np, of_clk_hw_onecell_get,
-				      data->onecell_data);
-}
-
-static struct platform_driver oxnas_stdclk_driver = {
-	.probe = oxnas_stdclk_probe,
-	.driver	= {
-		.name = "oxnas-stdclk",
-		.suppress_bind_attrs = true,
-		.of_match_table = oxnas_stdclk_dt_ids,
-	},
-};
-builtin_platform_driver(oxnas_stdclk_driver);

-- 
2.34.1

