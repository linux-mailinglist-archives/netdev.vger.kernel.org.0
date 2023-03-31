Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A1F6D1D69
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbjCaJ4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbjCaJyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:54:49 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091C71E71A;
        Fri, 31 Mar 2023 02:54:17 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 425FD6603193;
        Fri, 31 Mar 2023 10:54:15 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680256455;
        bh=hrO+9NSRC8A7pRF/PfGSFBIT/KlisRF3mp3XM93I+9c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=i7vMGsiqpc4TBi36g69n2gj5dnKhp2oOkO0RbZPHkL6W7UBYK+thNqPsLFj8W/MtR
         WlAtxHP8JXf3wV14wbHag/8bnHhDRA4RTakbgUa6MW2xUEfyrH60u973tmetWUEfL5
         QqqkoAH4MfhtFlf+/TmWkL5ebFEnKB6ReKHPf9tRlYJx3i7WhmqS3cxlaBYSlK3A1+
         em2Z+2/S1Kr22cpzjYOB3v97/eDkZu2ss8Ku9LNv4vBFdA3gcML8sLS9OJYAkmSpUA
         /hgf9Y+AzmU4iQ7skUgXb/KbVxNjvGyR32uz+Cprc8b2i0A1hvIpzoBU7ixpnUh/sn
         VDlo3CCUKxTiA==
Message-ID: <f8ae97e2-ee51-1b70-4fc9-98d7655a7fb0@collabora.com>
Date:   Fri, 31 Mar 2023 11:54:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v7 07/19] clk: mediatek: Add MT8188 ccusys clock support
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
 <20230331082131.12517-8-Garmin.Chang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230331082131.12517-8-Garmin.Chang@mediatek.com>
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
> Add MT8188 ccusys clock controller which provides clock gate
> control in Camera Computing Unit.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> ---
>   drivers/clk/mediatek/Makefile         |  2 +-
>   drivers/clk/mediatek/clk-mt8188-ccu.c | 50 +++++++++++++++++++++++++++
>   2 files changed, 51 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/clk/mediatek/clk-mt8188-ccu.c
> 
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index c235e9a0d305..fc4faee04636 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -102,7 +102,7 @@ obj-$(CONFIG_COMMON_CLK_MT8186_VENCSYS) += clk-mt8186-venc.o
>   obj-$(CONFIG_COMMON_CLK_MT8186_WPESYS) += clk-mt8186-wpe.o
>   obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o \
>   				   clk-mt8188-peri_ao.o clk-mt8188-infra_ao.o
> -j-$(CONFIG_COMMON_CLK_MT8188_CAMSYS) += clk-mt8188-cam.o
> +obj-$(CONFIG_COMMON_CLK_MT8188_CAMSYS) += clk-mt8188-cam.o clk-mt8188-ccu.o

The 'obj' typo has to be fixed in patch [06/19], after which:

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


