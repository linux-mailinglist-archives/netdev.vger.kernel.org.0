Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8941F6D1A48
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjCaIgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjCaIgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:36:03 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731471D915
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:59 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r11so21577344wrr.12
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251699;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oNLeYYmevUI4TEvtO58qWx9WKba4OWRb4gPC7pePliE=;
        b=QU/SMBwtauCDT26FDqkLVtUXOmKViF57BpBJbMyuNffLde2pjYSjYzzk4mMYgUY3RF
         Rv1j3nYCqzqWdV0ukZFmHVZEiyVWTayLisexL8iWTuSVhf0GnbgP1m/Kwr55kuXEC247
         H/1TlEwLAqO67ulQUFvz0q5cljRi5THKZtwqXZGj6DLmUrfgLnU8g5RDzJ3qX2TAyMkG
         JxtGinY/oJy51QsUfHANnB7s7NryhUeyS97DkLO3aOO3lWC99jyqeBVY2qo5YroHiBcG
         rbUVwa++BHOKgmdcC2Pxy8TIKtAb93DOo8j1YoPZJI3KBQiM7EvNk0av74pdYjvn/4oV
         D2Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251699;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oNLeYYmevUI4TEvtO58qWx9WKba4OWRb4gPC7pePliE=;
        b=bdo+1JGz89UUcxNUyww25nf2L+J373dlnRuTI/IsB/Vki7urZErfNiGsZNWz5w9Yfl
         7bg8fzXmjRAbKsoX0efZ5xp7TH2+8oQ8Qe8kZ65ucGADWmd4yf0Qk/Cq3LC7S3cPowq8
         Eq4r6d1ybmhhORk8DJ7F9WwjB13Q49DLQHHMkLAPa2NP17Ujcd45lLmA1vx9RdrxKIxK
         TNmJgOGX0SpwHDGGGZJT2AR5CvmwJ5tGOPOhjrC/vvTCsVLBAuTEt/t8a3l2AjCi+jUU
         m0dE5iJ9Mo4DSnj/Zqhbi/KbIsXWdWazHtpMHRTjh/gh8J0AtG4z9v/L6DGxIrLU4Zeh
         EgAg==
X-Gm-Message-State: AAQBX9dKMUQJ/6LYAisdgUO7FHtw3BM9o1gNvf3Whr9o7ugMod+/eIsC
        GJ88BP80b1jDO9pwJ2ZP+1LoJA==
X-Google-Smtp-Source: AKy350bU8fJMNCxfVc86Lv2m3v2OU/27OaMpg82cazbgj/q2eFNxD3gWemqObAljC1iPMvpM3rDX1w==
X-Received: by 2002:a5d:63d1:0:b0:2d5:b6a9:772a with SMTP id c17-20020a5d63d1000000b002d5b6a9772amr20187850wrw.17.1680251699431;
        Fri, 31 Mar 2023 01:34:59 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:34:59 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:49 +0200
Subject: [PATCH RFC 11/20] net: stmmac: dwmac-oxnas: remove obsolete dwmac
 glue driver
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-11-5bd58fd1dd1f@linaro.org>
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
for OX810 and OX820 ethernet.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig       |  11 -
 drivers/net/ethernet/stmicro/stmmac/Makefile      |   1 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c | 245 ----------------------
 3 files changed, 257 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index f77511fe4e87..8a0655d5f22e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -121,17 +121,6 @@ config DWMAC_MESON
 	  the stmmac device driver. This driver is used for Meson6,
 	  Meson8, Meson8b and GXBB SoCs.
 
-config DWMAC_OXNAS
-	tristate "Oxford Semiconductor OXNAS dwmac support"
-	default ARCH_OXNAS
-	depends on OF && COMMON_CLK && (ARCH_OXNAS || COMPILE_TEST)
-	select MFD_SYSCON
-	help
-	  Support for Ethernet controller on Oxford Semiconductor OXNAS SoCs.
-
-	  This selects the Oxford Semiconductor OXNASSoC glue layer support for
-	  the stmmac device driver. This driver is used for OX820.
-
 config DWMAC_QCOM_ETHQOS
 	tristate "Qualcomm ETHQOS support"
 	default ARCH_QCOM
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index 057e4bab5c08..9b56324ccf7d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -19,7 +19,6 @@ obj-$(CONFIG_DWMAC_IPQ806X)	+= dwmac-ipq806x.o
 obj-$(CONFIG_DWMAC_LPC18XX)	+= dwmac-lpc18xx.o
 obj-$(CONFIG_DWMAC_MEDIATEK)	+= dwmac-mediatek.o
 obj-$(CONFIG_DWMAC_MESON)	+= dwmac-meson.o dwmac-meson8b.o
-obj-$(CONFIG_DWMAC_OXNAS)	+= dwmac-oxnas.o
 obj-$(CONFIG_DWMAC_QCOM_ETHQOS)	+= dwmac-qcom-ethqos.o
 obj-$(CONFIG_DWMAC_ROCKCHIP)	+= dwmac-rk.o
 obj-$(CONFIG_DWMAC_SOCFPGA)	+= dwmac-altr-socfpga.o
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
deleted file mode 100644
index 62a69a91ab22..000000000000
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c
+++ /dev/null
@@ -1,245 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Oxford Semiconductor OXNAS DWMAC glue layer
- *
- * Copyright (C) 2016 Neil Armstrong <narmstrong@baylibre.com>
- * Copyright (C) 2014 Daniel Golle <daniel@makrotopia.org>
- * Copyright (C) 2013 Ma Haijun <mahaijuns@gmail.com>
- * Copyright (C) 2012 John Crispin <blogic@openwrt.org>
- */
-
-#include <linux/device.h>
-#include <linux/io.h>
-#include <linux/module.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
-#include <linux/platform_device.h>
-#include <linux/regmap.h>
-#include <linux/mfd/syscon.h>
-#include <linux/stmmac.h>
-
-#include "stmmac_platform.h"
-
-/* System Control regmap offsets */
-#define OXNAS_DWMAC_CTRL_REGOFFSET	0x78
-#define OXNAS_DWMAC_DELAY_REGOFFSET	0x100
-
-/* Control Register */
-#define DWMAC_CKEN_RX_IN        14
-#define DWMAC_CKEN_RXN_OUT      13
-#define DWMAC_CKEN_RX_OUT       12
-#define DWMAC_CKEN_TX_IN        10
-#define DWMAC_CKEN_TXN_OUT      9
-#define DWMAC_CKEN_TX_OUT       8
-#define DWMAC_RX_SOURCE         7
-#define DWMAC_TX_SOURCE         6
-#define DWMAC_LOW_TX_SOURCE     4
-#define DWMAC_AUTO_TX_SOURCE    3
-#define DWMAC_RGMII             2
-#define DWMAC_SIMPLE_MUX        1
-#define DWMAC_CKEN_GTX          0
-
-/* Delay register */
-#define DWMAC_TX_VARDELAY_SHIFT		0
-#define DWMAC_TXN_VARDELAY_SHIFT	8
-#define DWMAC_RX_VARDELAY_SHIFT		16
-#define DWMAC_RXN_VARDELAY_SHIFT	24
-#define DWMAC_TX_VARDELAY(d)		((d) << DWMAC_TX_VARDELAY_SHIFT)
-#define DWMAC_TXN_VARDELAY(d)		((d) << DWMAC_TXN_VARDELAY_SHIFT)
-#define DWMAC_RX_VARDELAY(d)		((d) << DWMAC_RX_VARDELAY_SHIFT)
-#define DWMAC_RXN_VARDELAY(d)		((d) << DWMAC_RXN_VARDELAY_SHIFT)
-
-struct oxnas_dwmac;
-
-struct oxnas_dwmac_data {
-	int (*setup)(struct oxnas_dwmac *dwmac);
-};
-
-struct oxnas_dwmac {
-	struct device	*dev;
-	struct clk	*clk;
-	struct regmap	*regmap;
-	const struct oxnas_dwmac_data	*data;
-};
-
-static int oxnas_dwmac_setup_ox810se(struct oxnas_dwmac *dwmac)
-{
-	unsigned int value;
-	int ret;
-
-	ret = regmap_read(dwmac->regmap, OXNAS_DWMAC_CTRL_REGOFFSET, &value);
-	if (ret < 0)
-		return ret;
-
-	/* Enable GMII_GTXCLK to follow GMII_REFCLK, required for gigabit PHY */
-	value |= BIT(DWMAC_CKEN_GTX)		|
-		 /* Use simple mux for 25/125 Mhz clock switching */
-		 BIT(DWMAC_SIMPLE_MUX);
-
-	regmap_write(dwmac->regmap, OXNAS_DWMAC_CTRL_REGOFFSET, value);
-
-	return 0;
-}
-
-static int oxnas_dwmac_setup_ox820(struct oxnas_dwmac *dwmac)
-{
-	unsigned int value;
-	int ret;
-
-	ret = regmap_read(dwmac->regmap, OXNAS_DWMAC_CTRL_REGOFFSET, &value);
-	if (ret < 0)
-		return ret;
-
-	/* Enable GMII_GTXCLK to follow GMII_REFCLK, required for gigabit PHY */
-	value |= BIT(DWMAC_CKEN_GTX)		|
-		 /* Use simple mux for 25/125 Mhz clock switching */
-		BIT(DWMAC_SIMPLE_MUX)		|
-		/* set auto switch tx clock source */
-		BIT(DWMAC_AUTO_TX_SOURCE)	|
-		/* enable tx & rx vardelay */
-		BIT(DWMAC_CKEN_TX_OUT)		|
-		BIT(DWMAC_CKEN_TXN_OUT)	|
-		BIT(DWMAC_CKEN_TX_IN)		|
-		BIT(DWMAC_CKEN_RX_OUT)		|
-		BIT(DWMAC_CKEN_RXN_OUT)	|
-		BIT(DWMAC_CKEN_RX_IN);
-	regmap_write(dwmac->regmap, OXNAS_DWMAC_CTRL_REGOFFSET, value);
-
-	/* set tx & rx vardelay */
-	value = DWMAC_TX_VARDELAY(4)	|
-		DWMAC_TXN_VARDELAY(2)	|
-		DWMAC_RX_VARDELAY(10)	|
-		DWMAC_RXN_VARDELAY(8);
-	regmap_write(dwmac->regmap, OXNAS_DWMAC_DELAY_REGOFFSET, value);
-
-	return 0;
-}
-
-static int oxnas_dwmac_init(struct platform_device *pdev, void *priv)
-{
-	struct oxnas_dwmac *dwmac = priv;
-	int ret;
-
-	/* Reset HW here before changing the glue configuration */
-	ret = device_reset(dwmac->dev);
-	if (ret)
-		return ret;
-
-	ret = clk_prepare_enable(dwmac->clk);
-	if (ret)
-		return ret;
-
-	ret = dwmac->data->setup(dwmac);
-	if (ret)
-		clk_disable_unprepare(dwmac->clk);
-
-	return ret;
-}
-
-static void oxnas_dwmac_exit(struct platform_device *pdev, void *priv)
-{
-	struct oxnas_dwmac *dwmac = priv;
-
-	clk_disable_unprepare(dwmac->clk);
-}
-
-static int oxnas_dwmac_probe(struct platform_device *pdev)
-{
-	struct plat_stmmacenet_data *plat_dat;
-	struct stmmac_resources stmmac_res;
-	struct oxnas_dwmac *dwmac;
-	int ret;
-
-	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
-	if (ret)
-		return ret;
-
-	plat_dat = stmmac_probe_config_dt(pdev, stmmac_res.mac);
-	if (IS_ERR(plat_dat))
-		return PTR_ERR(plat_dat);
-
-	dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
-	if (!dwmac) {
-		ret = -ENOMEM;
-		goto err_remove_config_dt;
-	}
-
-	dwmac->data = (const struct oxnas_dwmac_data *)of_device_get_match_data(&pdev->dev);
-	if (!dwmac->data) {
-		ret = -EINVAL;
-		goto err_remove_config_dt;
-	}
-
-	dwmac->dev = &pdev->dev;
-	plat_dat->bsp_priv = dwmac;
-	plat_dat->init = oxnas_dwmac_init;
-	plat_dat->exit = oxnas_dwmac_exit;
-
-	dwmac->regmap = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
-							"oxsemi,sys-ctrl");
-	if (IS_ERR(dwmac->regmap)) {
-		dev_err(&pdev->dev, "failed to have sysctrl regmap\n");
-		ret = PTR_ERR(dwmac->regmap);
-		goto err_remove_config_dt;
-	}
-
-	dwmac->clk = devm_clk_get(&pdev->dev, "gmac");
-	if (IS_ERR(dwmac->clk)) {
-		ret = PTR_ERR(dwmac->clk);
-		goto err_remove_config_dt;
-	}
-
-	ret = oxnas_dwmac_init(pdev, plat_dat->bsp_priv);
-	if (ret)
-		goto err_remove_config_dt;
-
-	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
-	if (ret)
-		goto err_dwmac_exit;
-
-
-	return 0;
-
-err_dwmac_exit:
-	oxnas_dwmac_exit(pdev, plat_dat->bsp_priv);
-err_remove_config_dt:
-	stmmac_remove_config_dt(pdev, plat_dat);
-
-	return ret;
-}
-
-static const struct oxnas_dwmac_data ox810se_dwmac_data = {
-	.setup = oxnas_dwmac_setup_ox810se,
-};
-
-static const struct oxnas_dwmac_data ox820_dwmac_data = {
-	.setup = oxnas_dwmac_setup_ox820,
-};
-
-static const struct of_device_id oxnas_dwmac_match[] = {
-	{
-		.compatible = "oxsemi,ox810se-dwmac",
-		.data = &ox810se_dwmac_data,
-	},
-	{
-		.compatible = "oxsemi,ox820-dwmac",
-		.data = &ox820_dwmac_data,
-	},
-	{ }
-};
-MODULE_DEVICE_TABLE(of, oxnas_dwmac_match);
-
-static struct platform_driver oxnas_dwmac_driver = {
-	.probe  = oxnas_dwmac_probe,
-	.remove = stmmac_pltfr_remove,
-	.driver = {
-		.name           = "oxnas-dwmac",
-		.pm		= &stmmac_pltfr_pm_ops,
-		.of_match_table = oxnas_dwmac_match,
-	},
-};
-module_platform_driver(oxnas_dwmac_driver);
-
-MODULE_AUTHOR("Neil Armstrong <narmstrong@baylibre.com>");
-MODULE_DESCRIPTION("Oxford Semiconductor OXNAS DWMAC glue layer");
-MODULE_LICENSE("GPL v2");

-- 
2.34.1

