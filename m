Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5ECE6B8E12
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjCNJFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjCNJF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:05:26 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC56395450;
        Tue, 14 Mar 2023 02:05:18 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 02221660308B;
        Tue, 14 Mar 2023 09:05:16 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1678784717;
        bh=GD3fiNQZaU9PW2uOAqk7geaQl1lfrpBoTqKOH6JtoiA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=g56EBxN6kQmaKmF56vUV7nGaSlyxmF2bNaDCJgfIUnlYqbYo7k7DrU7zMbpF1+V+D
         GTSBa8Lj3UTDWajjGDhx3MXGYcDNTaHezZN6zpOrz/YI0DRJtAjG3ke4TLSIXr/9r0
         fyhtfnHffCeMyVpRT8/pjXkp05ZNf4fXRy+eECd/YAjO2V1RCS8oJnhR7ysmxiPhRo
         TB6LqsUtK2QDIvhEusmVB+mGPfg7Yus2ocicgIocX73j+wG4UC36w0zrnaxTVtFq5u
         39dKZgveB1UP5QS3BGJDws6ehZLiYd8eDH4c+Uqmua6x15UTcsKAmQrmBx98BVL0K2
         lvgXLYVzBBkSA==
Message-ID: <5d0e98ee-3610-d07f-6060-a30050c41bd6@collabora.com>
Date:   Tue, 14 Mar 2023 10:05:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v6 04/19] clk: mediatek: Add MT8188 peripheral clock
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
 <20230309135419.30159-5-Garmin.Chang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230309135419.30159-5-Garmin.Chang@mediatek.com>
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
> Add MT8188 peripheral clock controller which provides clock
> gate control for ethernet/flashif/pcie/ssusb.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
> ---
>   drivers/clk/mediatek/Makefile             |  3 +-
>   drivers/clk/mediatek/clk-mt8188-peri_ao.c | 56 +++++++++++++++++++++++
>   2 files changed, 58 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/clk/mediatek/clk-mt8188-peri_ao.c
> 
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index d845bf7308c3..f38a5cea2925 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -91,7 +91,8 @@ obj-$(CONFIG_COMMON_CLK_MT8186) += clk-mt8186-mcu.o clk-mt8186-topckgen.o clk-mt
>   				   clk-mt8186-mfg.o clk-mt8186-mm.o clk-mt8186-wpe.o \
>   				   clk-mt8186-img.o clk-mt8186-vdec.o clk-mt8186-venc.o \
>   				   clk-mt8186-cam.o clk-mt8186-mdp.o clk-mt8186-ipe.o
> -obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o
> +obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o \
> +				   clk-mt8188-peri_ao.o
>   obj-$(CONFIG_COMMON_CLK_MT8192) += clk-mt8192.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_AUDSYS) += clk-mt8192-aud.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_CAMSYS) += clk-mt8192-cam.o
> diff --git a/drivers/clk/mediatek/clk-mt8188-peri_ao.c b/drivers/clk/mediatek/clk-mt8188-peri_ao.c
> new file mode 100644
> index 000000000000..683010453a10
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mt8188-peri_ao.c
> @@ -0,0 +1,56 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +//
> +// Copyright (c) 2022 MediaTek Inc.
> +// Author: Garmin Chang <garmin.chang@mediatek.com>
> +
> +#include <linux/clk-provider.h>
> +#include <linux/platform_device.h>
> +#include <dt-bindings/clock/mediatek,mt8188-clk.h>
> +
> +#include "clk-gate.h"
> +#include "clk-mtk.h"
> +
> +static const struct mtk_gate_regs peri_ao_cg_regs = {
> +	.set_ofs = 0x10,
> +	.clr_ofs = 0x14,
> +	.sta_ofs = 0x18,
> +};
> +
> +#define GATE_PERI_AO(_id, _name, _parent, _shift)			\
> +	GATE_MTK(_id, _name, _parent, &peri_ao_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
> +
> +static const struct mtk_gate peri_ao_clks[] = {
> +	GATE_PERI_AO(CLK_PERI_AO_ETHERNET, "peri_ao_ethernet", "top_axi", 0),
> +	GATE_PERI_AO(CLK_PERI_AO_ETHERNET_BUS, "peri_ao_ethernet_bus", "top_axi", 1),
> +	GATE_PERI_AO(CLK_PERI_AO_FLASHIF_BUS, "peri_ao_flashif_bus", "top_axi", 3),
> +	GATE_PERI_AO(CLK_PERI_AO_FLASHIF_26M, "peri_ao_flashif_26m", "clk26m", 4),
> +	GATE_PERI_AO(CLK_PERI_AO_FLASHIFLASHCK, "peri_ao_flashiflashck", "top_spinor", 5),
> +	GATE_PERI_AO(CLK_PERI_AO_SSUSB_2P_BUS, "peri_ao_ssusb_2p_bus", "top_usb_top_2p", 9),
> +	GATE_PERI_AO(CLK_PERI_AO_SSUSB_2P_XHCI, "peri_ao_ssusb_2p_xhci", "top_ssusb_xhci_2p", 10),
> +	GATE_PERI_AO(CLK_PERI_AO_SSUSB_3P_BUS, "peri_ao_ssusb_3p_bus", "top_usb_top_3p", 11),
> +	GATE_PERI_AO(CLK_PERI_AO_SSUSB_3P_XHCI, "peri_ao_ssusb_3p_xhci", "top_ssusb_xhci_3p", 12),
> +	GATE_PERI_AO(CLK_PERI_AO_SSUSB_BUS, "peri_ao_ssusb_bus", "top_usb_top", 13),
> +	GATE_PERI_AO(CLK_PERI_AO_SSUSB_XHCI, "peri_ao_ssusb_xhci", "top_ssusb_xhci", 14),
> +	GATE_PERI_AO(CLK_PERI_AO_ETHERNET_MAC, "peri_ao_ethernet_mac_clk", "top_snps_eth_250m", 16),
> +	GATE_PERI_AO(CLK_PERI_AO_PCIE_P0_FMEM, "peri_ao_pcie_p0_fmem", "hd_466m_fmem_ck", 24),
> +};
> +
> +static const struct mtk_clk_desc peri_ao_desc = {
> +	.clks = peri_ao_clks,
> +	.num_clks = ARRAY_SIZE(peri_ao_clks),
> +};
> +
> +static const struct of_device_id of_match_clk_mt8188_peri_ao[] = {
> +	{ .compatible = "mediatek,mt8188-pericfg-ao", .data = &peri_ao_desc },
> +	{ /* sentinel */ }
> +};

MODULE_DEVICE_TABLE is missing

> +
> +static struct platform_driver clk_mt8188_peri_ao_drv = {
> +	.probe = mtk_clk_simple_probe,
> +	.remove = mtk_clk_simple_remove,
> +	.driver = {
> +		.name = "clk-mt8188-peri_ao",
> +		.of_match_table = of_match_clk_mt8188_peri_ao,
> +	},
> +};
> +builtin_platform_driver(clk_mt8188_peri_ao_drv);

module_platform_driver()

MODULE_LICENSE
