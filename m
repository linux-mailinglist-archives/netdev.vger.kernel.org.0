Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567DC6B8E34
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjCNJKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCNJKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:10:49 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD1A91B6C;
        Tue, 14 Mar 2023 02:10:48 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id C810F6603089;
        Tue, 14 Mar 2023 09:10:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1678785047;
        bh=/JnhxMieB4QtSnsBxyC6QFaTCEZesuuyuB0kMdcSOHQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bH0vJ5ldKG15K6Z0QkpQvKAXFHbLtW/tXYRcpNDQ0i8QUsXDI9u2p1fPZSyUWm/q6
         TJkMpDlSOtMwSTMM8b1sUyO97gt/hbQUkQ3uyam99cyajGeeSMtd3/zGEto1jOntoi
         ndpfb5j8U1g8JHjTfL20UXH8gFjHBe8mBfoyt3rid1/kPzYO90QoVDE4gSXYEXbI+z
         4Jlm2w4saP7DYRnCVtVKPKEcmPq0g9xsWFpoggYjGYUSOti4djjNq9QkO77N6ixwrp
         +Jg1Ed3W46B5DwbFENG8Neso9US211CuxFZpdFyxJGkG1sYZF56vlt7gRbAGl0ILWe
         aMGpcG7VmoyDA==
Message-ID: <69ae7cc9-5f75-20a1-922c-a0d505a94fef@collabora.com>
Date:   Tue, 14 Mar 2023 10:10:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v6 08/19] clk: mediatek: Add MT8188 imgsys clock support
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
 <20230309135419.30159-9-Garmin.Chang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20230309135419.30159-9-Garmin.Chang@mediatek.com>
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
> Add MT8188 imgsys clock controllers which provide clock gate
> control for image IP blocks.
> 
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>
> ---
>   drivers/clk/mediatek/Makefile         |   2 +-
>   drivers/clk/mediatek/clk-mt8188-img.c | 110 ++++++++++++++++++++++++++
>   2 files changed, 111 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/clk/mediatek/clk-mt8188-img.c
> 
> diff --git a/drivers/clk/mediatek/Makefile b/drivers/clk/mediatek/Makefile
> index fb66d25e98fd..935805632018 100644
> --- a/drivers/clk/mediatek/Makefile
> +++ b/drivers/clk/mediatek/Makefile
> @@ -93,7 +93,7 @@ obj-$(CONFIG_COMMON_CLK_MT8186) += clk-mt8186-mcu.o clk-mt8186-topckgen.o clk-mt
>   				   clk-mt8186-cam.o clk-mt8186-mdp.o clk-mt8186-ipe.o
>   obj-$(CONFIG_COMMON_CLK_MT8188) += clk-mt8188-apmixedsys.o clk-mt8188-topckgen.o \
>   				   clk-mt8188-peri_ao.o clk-mt8188-infra_ao.o \
> -				   clk-mt8188-cam.o clk-mt8188-ccu.o
> +				   clk-mt8188-cam.o clk-mt8188-ccu.o clk-mt8188-img.o

imgsys can go under a different config option.

I won't send any more comments on the other 10 clocks for the same reason, so
please split the clocks as needed. Check the others like MT8186, MT8192, MT8195.

