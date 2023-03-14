Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E88A6B8E10
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjCNJFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCNJFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:05:15 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8732915E;
        Tue, 14 Mar 2023 02:05:14 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id D6A1F6603009;
        Tue, 14 Mar 2023 09:05:11 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1678784712;
        bh=yAitrZI8HTxhHirjf5TQ/3qdG4ffZdDc2n3Ln+XdjNA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jVWJutHk3K5BXmdo5k0Kg2nRv5gYy/E1leXSpxUatrT8YwE7q/OJ+DIrPZu2t+YeY
         a38WQpUPQiBMNr1Q11dLRTlXzptPGEpFGy0EvC6ZS1DtyzwOtIrv2zpfV6frc4/kV0
         ThnI+u9e6sE7ik2367Q5UK+CmuYBL0aoM/iRHgMqx2EqrFKWy39pSp8A8WDF75asqz
         TEXfmlAbtXNHVwA9I++RP79xvyBmibk6yi0XgU46M1RJWpXpMhPbSWjg7iVVvRqWe3
         C2m4CsGJKEu3v8plGeIj8Kj6QdzSBIbNcX5nZFFPTbLY3IZxToUYNaZBA3YU6wvEAh
         nzJFSbO0glB+Q==
Message-ID: <500b5030-4dac-03c9-1a4c-2cf2e70b829c@collabora.com>
Date:   Tue, 14 Mar 2023 10:05:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v6 07/19] clk: mediatek: Add MT8188 ccusys clock support
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
 <20230309135419.30159-8-Garmin.Chang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230309135419.30159-8-Garmin.Chang@mediatek.com>
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
> Add MT8188 ccusys clock controller which provides clock gate
> control in Camera Computing Unit.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> ---
>   drivers/clk/mediatek/Makefile         |  2 +-
>   drivers/clk/mediatek/clk-mt8188-ccu.c | 48 +++++++++++++++++++++++++++
>   2 files changed, 49 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/clk/mediatek/clk-mt8188-ccu.c
> 
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index a4189d28cecc..fb66d25e98fd 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -93,7 +93,7 @@ obj-$(CONFIG_COMMON_CLK_MT8186) += clk-mt8186-mcu.o clk-mt8186-topckgen.o clk-mt
>   				   clk-mt8186-cam.o clk-mt8186-mdp.o clk-mt8186-ipe.o
>   obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o \
>   				   clk-mt8188-peri_ao.o clk-mt8188-infra_ao.o \
> -				   clk-mt8188-cam.o
> +				   clk-mt8188-cam.o clk-mt8188-ccu.o

clk-mt8188-cam and clk-mt8188-ccu can go under a different configuration option
for modularity.

For example...

obj-$(CONFIG_COMMON_CLK_MT8188_CAM) +=  ...ccu.o, ...cam.o

Please make sure, for boot performance purposes, to order them as:

obj-$(CONFIG_.....) += driver-clk1.o driver-requiring-clk1-clocks.o

>   obj-$(CONFIG_COMMON_CLK_MT8192) += clk-mt8192.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_AUDSYS) += clk-mt8192-aud.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_CAMSYS) += clk-mt8192-cam.o
> diff --git a/drivers/clk/mediatek/clk-mt8188-ccu.c b/drivers/clk/mediatek/clk-mt8188-ccu.c
> new file mode 100644
> index 000000000000..b7380060f906
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mt8188-ccu.c
> @@ -0,0 +1,48 @@
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
> +static const struct mtk_gate_regs ccu_cg_regs = {
> +	.set_ofs = 0x4,
> +	.clr_ofs = 0x8,
> +	.sta_ofs = 0x0,
> +};
> +
> +#define GATE_CCU(_id, _name, _parent, _shift)			\
> +	GATE_MTK(_id, _name, _parent, &ccu_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
> +
> +static const struct mtk_gate ccu_clks[] = {
> +	GATE_CCU(CLK_CCU_LARB27, "ccu_larb27", "top_ccu", 0),
> +	GATE_CCU(CLK_CCU_AHB, "ccu_ahb", "top_ccu", 1),
> +	GATE_CCU(CLK_CCU_CCU0, "ccu_ccu0", "top_ccu", 2),
> +};
> +
> +static const struct mtk_clk_desc ccu_desc = {
> +	.clks = ccu_clks,
> +	.num_clks = ARRAY_SIZE(ccu_clks),
> +};
> +
> +static const struct of_device_id of_match_clk_mt8188_ccu[] = {
> +	{ .compatible = "mediatek,mt8188-ccusys", .data = &ccu_desc},

Missing space: { [...] &ccu_desc },

> +	{ /* sentinel */ }
> +};
> +
> +static struct platform_driver clk_mt8188_ccu_drv = {
> +	.probe = mtk_clk_simple_probe,
> +	.remove = mtk_clk_simple_remove,
> +	.driver = {
> +		.name = "clk-mt8188-ccu",
> +		.of_match_table = of_match_clk_mt8188_ccu,
> +	},
> +};
> +
> +builtin_platform_driver(clk_mt8188_ccu_drv);

module_platform_driver

> +MODULE_LICENSE("GPL");

