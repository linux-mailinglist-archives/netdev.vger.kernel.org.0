Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989566B8E16
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjCNJF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCNJFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:05:19 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F9392BDC;
        Tue, 14 Mar 2023 02:05:17 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 378506603089;
        Tue, 14 Mar 2023 09:05:15 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1678784716;
        bh=ndNerwISvzBHF0GHqZpkwq64TDAwzpfvyAXABgssNz8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HmXWS6xRpAwi3aYB2kC2oml58VZ0DQya5t+wwtAIyVfQHHuF3j0lzKcrCuCxUfny6
         w+AuywTY0JESu81NJ7pPW0/UvULI9/q8L0yDFv3S4mABITih5GMyXskjqZQinzzUFZ
         kepdlW/IHs2M6nCJtaawrlexmlA4/79goOfEBb2QBRxj0v96A59pBsz4gOH5R+DWkR
         3+Fj1/xJEfay3dOjs1WNOum9pgrub8m+5KW2A07RNby59DHjiA+Y6xioK+rtsm7fnY
         UCDd7mJQUJvfeR+7Gv+dZ7xvfuqKq0BfaipbjVG5iXS3Kgly1jzxMMH8ixdm9Te9ah
         EK1zirVdv14dg==
Message-ID: <0fa530f3-f22b-ce45-e030-d746ae5896d5@collabora.com>
Date:   Tue, 14 Mar 2023 10:05:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v6 05/19] clk: mediatek: Add MT8188 infrastructure clock
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
 <20230309135419.30159-6-Garmin.Chang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230309135419.30159-6-Garmin.Chang@mediatek.com>
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
> Add MT8188 infrastructure clock controller which provides
> clock gate control for basic IP like pwm, uart, spi and so on.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
> ---
>   drivers/clk/mediatek/Makefile              |   2 +-
>   drivers/clk/mediatek/clk-mt8188-infra_ao.c | 196 +++++++++++++++++++++
>   2 files changed, 197 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/clk/mediatek/clk-mt8188-infra_ao.c
> 
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index f38a5cea2925..172aaef29d5d 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -92,7 +92,7 @@ obj-$(CONFIG_COMMON_CLK_MT8186) += clk-mt8186-mcu.o clk-mt8186-topckgen.o clk-mt
>   				   clk-mt8186-img.o clk-mt8186-vdec.o clk-mt8186-venc.o \
>   				   clk-mt8186-cam.o clk-mt8186-mdp.o clk-mt8186-ipe.o
>   obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o \
> -				   clk-mt8188-peri_ao.o
> +				   clk-mt8188-peri_ao.o clk-mt8188-infra_ao.o
>   obj-$(CONFIG_COMMON_CLK_MT8192) += clk-mt8192.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_AUDSYS) += clk-mt8192-aud.o
>   obj-$(CONFIG_COMMON_CLK_MT8192_CAMSYS) += clk-mt8192-cam.o
> diff --git a/drivers/clk/mediatek/clk-mt8188-infra_ao.c b/drivers/clk/mediatek/clk-mt8188-infra_ao.c
> new file mode 100644
> index 000000000000..edc0ba18c67f
> --- /dev/null
> +++ b/drivers/clk/mediatek/clk-mt8188-infra_ao.c
> @@ -0,0 +1,196 @@
> +// SPDX-License-Identifier: GPL-2.0-only

> +//
> +// Copyright (c) 2022 MediaTek Inc.
> +// Author: Garmin Chang <garmin.chang@mediatek.com>

Please use C-style comments (apart from the SPDX header) to be consistent with
the other clock drivers.

> +
> +#include <linux/clk-provider.h>
> +#include <linux/platform_device.h>
> +#include <dt-bindings/clock/mediatek,mt8188-clk.h>

order by name.

> +

..snip..

> +
> +static const struct mtk_clk_desc infra_ao_desc = {
> +	.clks = infra_ao_clks,
> +	.num_clks = ARRAY_SIZE(infra_ao_clks),
> +};
> +
> +static const struct of_device_id of_match_clk_mt8188_infra_ao[] = {
> +	{ .compatible = "mediatek,mt8188-infracfg-ao", .data = &infra_ao_desc },
> +	{ /* sentinel */ }
> +};

MODULE_DEVICE_TABLE is missing

> +
> +static struct platform_driver clk_mt8188_infra_ao_drv = {
> +	.probe = mtk_clk_simple_probe,
> +	.remove = mtk_clk_simple_remove,
> +	.driver = {
> +		.name = "clk-mt8188-infra_ao",
> +		.of_match_table = of_match_clk_mt8188_infra_ao,
> +	},
> +};
> +builtin_platform_driver(clk_mt8188_infra_ao_drv);

module_platform_driver()

MODULE_LICENSE


Regards,
Angelo
