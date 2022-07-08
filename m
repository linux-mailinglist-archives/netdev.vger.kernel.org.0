Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7512A56B574
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 11:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbiGHJXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 05:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237588AbiGHJXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 05:23:01 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D032B63B;
        Fri,  8 Jul 2022 02:23:00 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id u20so19157004iob.8;
        Fri, 08 Jul 2022 02:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=U7/XgC9RN4le35mQLRbV3pgGUKx0V1tiTu9hGjasAGI=;
        b=SEK73+0Tdh+TtsYAOudd9GcFL0cnMQL6EwVH3NZG1Q30TqNpGfwvwxVJ2yocAZX8c+
         tgT9JhTrxCYfJbYfH0P20SPZcvRqLljpJC9Lqbn8Ai+p4Hoy88XH5B3Ha0zLOPlN4iYB
         3ZTQwMWmO1icAlPKhiYJqlojNR+8r3BJDGPkPcVh20KoN95cOiE3gUDbDhl+BsQJcDLy
         mqhmI2yhnR3shxv2ESZ1BlMBJuSty2Y+4vKsbAG+W5Bwi1tXBKgHR+vlDlxZFWQW26qz
         32gBntj83aot+8Ro4KWE1AXAxSgNtonorWstIOMmxwFD7D813RUTpEPn1XeNoGb+rtg7
         CaVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U7/XgC9RN4le35mQLRbV3pgGUKx0V1tiTu9hGjasAGI=;
        b=kfBr5X3HeN2JY++eG/ItYFqpKtJ3aTVTCms68d7RuG/FnxySOBcH3IkBiHy2dgPQ27
         3GSe+bf/sQ27l0DzGkHfRWcUBU21QIDaORBJF4yM+xuGtdoB+Hf6n9mf6tVtJjLwrB91
         Vq9t45elgbmWJVegYGJ9tKNI6mcfYJFjRsTSE/fQ9vw/BG3n32mHAKkKdrUuORR7vRiE
         HsorF5gUi1uYm1ipirAr1u753hQiJsYYRqQXNC+9OLE89FtW1QMkJTPWhn1fPNPRZ2hM
         rBFzyMWTOEyvaeEC4rRdTkBnpdYN0EqBDGYJC5LNvZlrScqnRCe9P2Ee/lGZ6yb0Wlax
         /BYw==
X-Gm-Message-State: AJIora8adFYtAnlzPVXaOBvXltXwivHQHsaqzxwoGYqcyfMAWpqYJjI6
        EKjLMdngXyficDf/06xXBO0=
X-Google-Smtp-Source: AGRyM1t2xWCoYr09Jo0vvMoTX8WrRJ5XuGWsryJmy0bfppS9LrrILQXKs9QWucfoDSuMtqnmbOifuQ==
X-Received: by 2002:a05:6602:164a:b0:678:682f:568b with SMTP id y10-20020a056602164a00b00678682f568bmr1403979iow.187.1657272179559;
        Fri, 08 Jul 2022 02:22:59 -0700 (PDT)
Received: from [192.168.1.145] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id l10-20020a92d94a000000b002dc616d93acsm63916ilq.28.2022.07.08.02.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 02:22:58 -0700 (PDT)
Message-ID: <14bf5e6b-4230-fffc-4134-c3015cf4d262@gmail.com>
Date:   Fri, 8 Jul 2022 11:22:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net v3] stmmac: dwmac-mediatek: fix clock issue
Content-Language: en-US
To:     Biao Huang <biao.huang@mediatek.com>,
        David Miller <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, macpaul.lin@mediatek.com
References: <20220708083937.27334-1-biao.huang@mediatek.com>
 <20220708083937.27334-2-biao.huang@mediatek.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <20220708083937.27334-2-biao.huang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/07/2022 10:39, Biao Huang wrote:
> Since clocks are handled in mediatek_dwmac_clks_config(),
> remove the clocks configuration in init()/exit(), and
> invoke mediatek_dwmac_clks_config instead.
> 
> This issue is found in suspend/resume test.
> 

Commit message is rather confusing. Basically you are moving the clock enable 
into probe instead of init and remove it from exit. That means, clocks get 
enabled earlier and don't get disabled if the module gets unloaded. That doesn't 
sound correct, I think we would at least need to disable the clocks in remove 
function.

I suppose that suspend calls exit and that there was a problem when we disable 
the clocks there. Is this a HW issue that has no other possible fix?

Regards,
Matthias

> Fixes: 3186bdad97d5 ("stmmac: dwmac-mediatek: add platform level clocks management")
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>   .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 36 +++++--------------
>   1 file changed, 9 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> index 6ff88df58767..e86f3e125cb4 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> @@ -576,32 +576,7 @@ static int mediatek_dwmac_init(struct platform_device *pdev, void *priv)
>   		}
>   	}
>   
> -	ret = clk_bulk_prepare_enable(variant->num_clks, plat->clks);
> -	if (ret) {
> -		dev_err(plat->dev, "failed to enable clks, err = %d\n", ret);
> -		return ret;
> -	}
> -
> -	ret = clk_prepare_enable(plat->rmii_internal_clk);
> -	if (ret) {
> -		dev_err(plat->dev, "failed to enable rmii internal clk, err = %d\n", ret);
> -		goto err_clk;
> -	}
> -
>   	return 0;
> -
> -err_clk:
> -	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
> -	return ret;
> -}
> -
> -static void mediatek_dwmac_exit(struct platform_device *pdev, void *priv)
> -{
> -	struct mediatek_dwmac_plat_data *plat = priv;
> -	const struct mediatek_dwmac_variant *variant = plat->variant;
> -
> -	clk_disable_unprepare(plat->rmii_internal_clk);
> -	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
>   }
>   
>   static int mediatek_dwmac_clks_config(void *priv, bool enabled)
> @@ -643,7 +618,6 @@ static int mediatek_dwmac_common_data(struct platform_device *pdev,
>   	plat->addr64 = priv_plat->variant->dma_bit_mask;
>   	plat->bsp_priv = priv_plat;
>   	plat->init = mediatek_dwmac_init;
> -	plat->exit = mediatek_dwmac_exit;
>   	plat->clks_config = mediatek_dwmac_clks_config;
>   	if (priv_plat->variant->dwmac_fix_mac_speed)
>   		plat->fix_mac_speed = priv_plat->variant->dwmac_fix_mac_speed;
> @@ -712,13 +686,21 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
>   	mediatek_dwmac_common_data(pdev, plat_dat, priv_plat);
>   	mediatek_dwmac_init(pdev, priv_plat);
>   
> +	ret = mediatek_dwmac_clks_config(priv_plat, true);
> +	if (ret)
> +		return ret;
> +
>   	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
>   	if (ret) {
>   		stmmac_remove_config_dt(pdev, plat_dat);
> -		return ret;
> +		goto err_drv_probe;
>   	}
>   
>   	return 0;
> +
> +err_drv_probe:
> +	mediatek_dwmac_clks_config(priv_plat, false);
> +	return ret;
>   }
>   
>   static const struct of_device_id mediatek_dwmac_match[] = {
