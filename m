Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B116B6D1D17
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbjCaJzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjCaJyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:54:23 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BF1172C;
        Fri, 31 Mar 2023 02:53:42 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id DAE666603193;
        Fri, 31 Mar 2023 10:53:40 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680256421;
        bh=lYuwy5PNbHveUqITfyBOBH4VBeg+QrO312pmvp34imI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=R1PP/ANMnDEwlLmop4KwyIE6ajslhceXPLKAsCRayaggPIqR5xHQ5m5d4HFfVc1Qo
         AXxK3es7x9/UWIv1GmGBcNB4B4MKyeNLM6joUQum6FBFgMyMXuT7j+mLS8RAIyYudS
         VIGUM5SNCbOnvTskxCLSyaYTMJABGprNzQI+D/9/SRNomkxfZjieBn9PKULNzCXE7c
         NkuCNJByDVJe7E60v84D5l9g4zUtoey5L1okU14Nz3z4xNEh2UIBuXWRtxz2iqOSRG
         0E/bsucStViM0HIYPj3j8Il3JOo4yXohFhAlqAmDBATea0gGUhVoItevidkdlxV3q4
         guk+DTUidFvgg==
Message-ID: <816f8d82-b66d-6fad-51d7-a37c241b0417@collabora.com>
Date:   Fri, 31 Mar 2023 11:53:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v7 06/19] clk: mediatek: Add MT8188 camsys clock support
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
References: <20230331082131.12517-1-Garmin.Chang@mediatek.com>
 <20230331082131.12517-7-Garmin.Chang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230331082131.12517-7-Garmin.Chang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 31/03/23 10:21, Garmin.Chang ha scritto:
> Add MT8188 camsys clock controllers which provide clock gate
> control for camera IP blocks.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
> ---
>   drivers/clk/mediatek/Kconfig          |   7 ++
>   drivers/clk/mediatek/Makefile         |   1 +
>   drivers/clk/mediatek/clk-mt8188-cam.c | 120 ++++++++++++++++++++++++++
>   3 files changed, 128 insertions(+)
>   create mode 100644 drivers/clk/mediatek/clk-mt8188-cam.c
> 
> diff --git a/drivers/clk/mediatek/Kconfig b/drivers/clk/mediatek/Kconfig
> index 681d392620c5..9170f76a8ee7 100644
> --- a/drivers/clk/mediatek/Kconfig
> +++ b/drivers/clk/mediatek/Kconfig
> @@ -692,6 +692,13 @@ config COMMON_CLK_MT8188
>   	help
>             This driver supports MediaTek MT8188 clocks.
>   
> +config COMMON_CLK_MT8188_CAMSYS
> +	tristate "Clock driver for MediaTek MT8188 camsys"
> +	depends on COMMON_CLK_MT8188_VPPSYS
> +	default COMMON_CLK_MT8188_VPPSYS
> +	help
> +	  This driver supports MediaTek MT8188 camsys and camsys_raw clocks.
> +
>   config COMMON_CLK_MT8192
>   	tristate "Clock driver for MediaTek MT8192"
>   	depends on ARM64 || COMPILE_TEST
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index 1a642510ce38..c235e9a0d305 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -102,6 +102,7 @@ obj-$(CONFIG_COMMON_CLK_MT8186_VENCSYS) += clk-mt8186-venc.o
>   obj-$(CONFIG_COMMON_CLK_MT8186_WPESYS) += clk-mt8186-wpe.o
>   obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o \
>   				   clk-mt8188-peri_ao.o clk-mt8188-infra_ao.o
> +j-$(CONFIG_COMMON_CLK_MT8188_CAMSYS) += clk-mt8188-cam.o

Please fix that typo here.

After which,
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


