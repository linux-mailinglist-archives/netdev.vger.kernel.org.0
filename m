Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4686F6B8E18
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjCNJFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjCNJF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:05:27 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C0F911E0;
        Tue, 14 Mar 2023 02:05:23 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 97D6A660308C;
        Tue, 14 Mar 2023 09:05:21 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1678784722;
        bh=ptq6EkJVmXDGwfBJddGNKL/3hrADKcsADrPmLdk63kQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=DS0nF5SmRdK2GvflXBYiLas8U2FzRDkVdQw8T0ZokLIiuSW/VKrP/ygKXFACqEK6P
         FgeTZBmOd8Y2o6z9AeGksqlnOEl8NGFiV+BCgNsgsa1Zp7sPYhgFVyKbFq3sw3EXKG
         aZ8y4DA88Q+LOkuAkWXBGqLer8SNLkAolm3EqVKHYBj2sIdLqYzWkf9Cl7o6k+cbSM
         y81rljmjPcH8xDEm/eRMZrC9o4EBfK7URx06cNo2FQNbVHoT9Hl7LxfCmM9tNBxXTN
         k0GULECdGaJBYJ1PwaiQofINtLkeA1j5MbmD+6CkVgBcviBYYDPWKN6QkWQidQPGtF
         UDdKf3QOoaOsw==
Message-ID: <dda4c31e-e9d3-ec3d-c63e-71b3ad99734c@collabora.com>
Date:   Tue, 14 Mar 2023 10:05:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v6 02/19] clk: mediatek: Add MT8188 apmixedsys clock
 support
Content-Language: en-US
To:     "Garmin.Chang" <Garmin.Chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Project_Global_Chrome_Upstream_Group@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
References: <20230309135419.30159-1-Garmin.Chang@mediatek.com>
 <20230309135419.30159-3-Garmin.Chang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230309135419.30159-3-Garmin.Chang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 09/03/23 14:54, Garmin.Chang ha scritto:
> Add MT8188 apmixedsys clock controller which provides Plls
> generated from SoC 26m and ssusb clock gate control.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> ---
>   drivers/clk/mediatek/Kconfig                 |  11 ++
>   drivers/clk/mediatek/Makefile                |   1 +
>   drivers/clk/mediatek/clk-mt8188-apmixedsys.c | 154 +++++++++++++++++++
>   3 files changed, 166 insertions(+)
>   create mode 100644 drivers/clk/mediatek/clk-mt8188-apmixedsys.c
> 
> diff --git a/drivers/clk/mediatek/Kconfig b/drivers/clk/mediatek/Kconfig
> index 2d14855dd37e..d7115089c4f6 100644
> --- a/drivers/clk/mediatek/Kconfig
> +++ b/drivers/clk/mediatek/Kconfig
> @@ -604,6 +604,17 @@ config COMMON_CLK_MT8186
>   	help
>   	  This driver supports MediaTek MT8186 clocks.
>   
> +config COMMON_CLK_MT8188
> +	bool "Clock driver for MediaTek MT8188"

this can be a tristate.

> +	depends on ARM64 || COMPILE_TEST
> +	select COMMON_CLK_MEDIATEK
> +	default ARCH_MEDIATEK
> +	help
> +	  This driver supports MediaTek MT8188 basic clocks and clocks
> +	  required for various peripheral found on MediaTek. Choose
> +	  M or Y here if you want to use clocks such as peri_ao,
> +	  infra_ao, etc.
> +
>   config COMMON_CLK_MT8192
>   	bool "Clock driver for MediaTek MT8192"
>   	depends on ARM64 || COMPILE_TEST
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index e5d018270ed0..1f822fcf6084 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -91,6 +91,7 @@ obj-$(CONFIG_COMMON_CLK_MT8186) += clk-mt8186-mcu.o clk-mt8186-topckgen.o clk-mt
>   				   clk-mt8186-mfg.o clk-mt8186-mm.o clk-mt8186-wpe.o \
>   				   clk-mt8186-img.o clk-mt8186-vdec.o clk-mt8186-venc.o \
>   				   clk-mt8186-cam.o clk-mt8186-mdp.o clk-mt8186-ipe.o
> +obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o
>   obj-$(CONFIG_COMMON_CLK_MT8192) += clk-mt8192.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_AUDSYS) += clk-mt8192-aud.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_CAMSYS) += clk-mt8192-cam.o
> diff --git a/drivers/clk/mediatek/clk-mt8188-apmixedsys.c b/drivers/clk/mediatek/clk-mt8188-apmixedsys.c
> new file mode 100644
> index 000000000000..db64340386d9
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mt8188-apmixedsys.c
> @@ -0,0 +1,154 @@
> +// SPDX-License-Identifier: GPL-2.0-only

// SPDX ...
/*
  * Copyright ...
  * Author ..
  */

> +//
> +// Copyright (c) 2022 MediaTek Inc.
> +// Author: Garmin Chang <garmin.chang@mediatek.com>
> +
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <dt-bindings/clock/mediatek,mt8188-clk.h>

Please order by name: dt-bindings goes first.

> +
> +#include "clk-gate.h"
> +#include "clk-mtk.h"
> +#include "clk-pll.h"
> +
> +static const struct mtk_gate_regs apmixed_cg_regs = {
> +	.set_ofs = 0x8,
> +	.clr_ofs = 0x8,
> +	.sta_ofs = 0x8,
> +};
> +
> +#define GATE_APMIXED(_id, _name, _parent, _shift)			\
> +	GATE_MTK(_id, _name, _parent, &apmixed_cg_regs, _shift, &mtk_clk_gate_ops_no_setclr_inv)
> +
> +static const struct mtk_gate apmixed_clks[] = {
> +	GATE_APMIXED(CLK_APMIXED_PLL_SSUSB26M_EN, "pll_ssusb26m_en", "clk26m", 1),
> +};
> +
> +#define MT8188_PLL_FMAX		(3800UL * MHZ)
> +#define MT8188_PLL_FMIN		(1500UL * MHZ)
> +#define MT8188_INTEGER_BITS	8
> +
> +#define PLL(_id, _name, _reg, _pwr_reg, _en_mask, _flags,		\
> +	    _rst_bar_mask, _pcwbits, _pd_reg, _pd_shift,		\
> +	    _tuner_reg, _tuner_en_reg, _tuner_en_bit,			\
> +	    _pcw_reg, _pcw_shift, _pcw_chg_reg,				\
> +	    _en_reg, _pll_en_bit) {					\
> +		.id = _id,						\
> +		.name = _name,						\
> +		.reg = _reg,						\
> +		.pwr_reg = _pwr_reg,					\
> +		.en_mask = _en_mask,					\
> +		.flags = _flags,					\
> +		.rst_bar_mask = _rst_bar_mask,				\
> +		.fmax = MT8188_PLL_FMAX,				\
> +		.fmin = MT8188_PLL_FMIN,				\
> +		.pcwbits = _pcwbits,					\
> +		.pcwibits = MT8188_INTEGER_BITS,			\
> +		.pd_reg = _pd_reg,					\
> +		.pd_shift = _pd_shift,					\
> +		.tuner_reg = _tuner_reg,				\
> +		.tuner_en_reg = _tuner_en_reg,				\
> +		.tuner_en_bit = _tuner_en_bit,				\
> +		.pcw_reg = _pcw_reg,					\
> +		.pcw_shift = _pcw_shift,				\
> +		.pcw_chg_reg = _pcw_chg_reg,				\
> +		.en_reg = _en_reg,					\
> +		.pll_en_bit = _pll_en_bit,				\
> +	}
> +
> +static const struct mtk_pll_data plls[] = {
> +	PLL(CLK_APMIXED_ETHPLL, "ethpll", 0x044C, 0x0458, 0,
> +	    0, 0, 22, 0x0450, 24, 0, 0, 0, 0x0450, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_MSDCPLL, "msdcpll", 0x0514, 0x0520, 0,
> +	    0, 0, 22, 0x0518, 24, 0, 0, 0, 0x0518, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_TVDPLL1, "tvdpll1", 0x0524, 0x0530, 0,
> +	    0, 0, 22, 0x0528, 24, 0, 0, 0, 0x0528, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_TVDPLL2, "tvdpll2", 0x0534, 0x0540, 0,
> +	    0, 0, 22, 0x0538, 24, 0, 0, 0, 0x0538, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_MMPLL, "mmpll", 0x0544, 0x0550, 0xff000000,
> +	    HAVE_RST_BAR, BIT(23), 22, 0x0548, 24, 0, 0, 0, 0x0548, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_MAINPLL, "mainpll", 0x045C, 0x0468, 0xff000000,
> +	    HAVE_RST_BAR, BIT(23), 22, 0x0460, 24, 0, 0, 0, 0x0460, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_IMGPLL, "imgpll", 0x0554, 0x0560, 0,
> +	    0, 0, 22, 0x0558, 24, 0, 0, 0, 0x0558, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_UNIVPLL, "univpll", 0x0504, 0x0510, 0xff000000,
> +	    HAVE_RST_BAR, BIT(23), 22, 0x0508, 24, 0, 0, 0, 0x0508, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_ADSPPLL, "adsppll", 0x042C, 0x0438, 0,
> +	    0, 0, 22, 0x0430, 24, 0, 0, 0, 0x0430, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_APLL1, "apll1", 0x0304, 0x0314, 0,
> +	    0, 0, 32, 0x0308, 24, 0x0034, 0x0000, 12, 0x030C, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_APLL2, "apll2", 0x0318, 0x0328, 0,
> +	    0, 0, 32, 0x031C, 24, 0x0038, 0x0000, 13, 0x0320, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_APLL3, "apll3", 0x032C, 0x033C, 0,
> +	    0, 0, 32, 0x0330, 24, 0x003C, 0x0000, 14, 0x0334, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_APLL4, "apll4", 0x0404, 0x0414, 0,
> +	    0, 0, 32, 0x0408, 24, 0x0040, 0x0000, 15, 0x040C, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_APLL5, "apll5", 0x0418, 0x0428, 0,
> +	    0, 0, 32, 0x041C, 24, 0x0044, 0x0000, 16, 0x0420, 0, 0, 0, 9),
> +	PLL(CLK_APMIXED_MFGPLL, "mfgpll", 0x0340, 0x034C, 0,
> +	    0, 0, 22, 0x0344, 24, 0, 0, 0, 0x0344, 0, 0, 0, 9),
> +};
> +
> +static const struct of_device_id of_match_clk_mt8188_apmixed[] = {
> +	{ .compatible = "mediatek,mt8188-apmixedsys", },

You don't need the comma after compatible

	{ .compatible = "mediatek,mt8188-apmixedsys" },

> +	{}

At the end, please say what the last entry is; a common way to do this is:

	{ /* sentinel */ }

...since that's a sentinel! :-)

> +};

You miss just one little step for module auto-loading here.

MODULE_DEVICE_TABLE(of, of_match_clk_mt8188_apmixed);

> +
> +static int clk_mt8188_apmixed_probe(struct platform_device *pdev)
> +{
> +	struct clk_hw_onecell_data *clk_data;
> +	struct device_node *node = pdev->dev.of_node;
> +	int r;
> +
> +	clk_data = mtk_alloc_clk_data(CLK_APMIXED_NR_CLK);
> +	if (!clk_data)
> +		return -ENOMEM;
> +
> +	r = mtk_clk_register_plls(node, plls, ARRAY_SIZE(plls), clk_data);
> +	if (r)
> +		goto free_apmixed_data;
> +
> +	r = mtk_clk_register_gates(&pdev->dev, node, apmixed_clks,
> +				   ARRAY_SIZE(apmixed_clks), clk_data);
> +	if (r)
> +		goto unregister_plls;
> +
> +	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
> +	if (r)
> +		goto unregister_gates;
> +
> +	platform_set_drvdata(pdev, clk_data);
> +
> +	return r;

Reaching this point means that no error occurred, so here...

	return 0;

> +
> +unregister_gates:
> +	mtk_clk_unregister_gates(apmixed_clks, ARRAY_SIZE(apmixed_clks), clk_data);
> +unregister_plls:
> +	mtk_clk_unregister_plls(plls, ARRAY_SIZE(plls), clk_data);
> +free_apmixed_data:
> +	mtk_free_clk_data(clk_data);
> +	return r;
> +}
> +
> +static int clk_mt8188_apmixed_remove(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	struct clk_hw_onecell_data *clk_data = platform_get_drvdata(pdev);
> +
> +	of_clk_del_provider(node);
> +	mtk_clk_unregister_gates(apmixed_clks, ARRAY_SIZE(apmixed_clks), clk_data);
> +	mtk_clk_unregister_plls(plls, ARRAY_SIZE(plls), clk_data);
> +	mtk_free_clk_data(clk_data);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver clk_mt8188_apmixed_drv = {
> +	.probe = clk_mt8188_apmixed_probe,
> +	.remove = clk_mt8188_apmixed_remove,
> +	.driver = {
> +		.name = "clk-mt8188-apmixed",
> +		.of_match_table = of_match_clk_mt8188_apmixed,
> +	},
> +};
> +builtin_platform_driver(clk_mt8188_apmixed_drv);

You can change builtin_platform_driver() to module_platform_driver() here to
achieve modularity.

Regards,
Angelo

