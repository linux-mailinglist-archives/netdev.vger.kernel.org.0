Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D478C56B454
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 10:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237691AbiGHISG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 04:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236902AbiGHISF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 04:18:05 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732E181481;
        Fri,  8 Jul 2022 01:18:04 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id a20so7723278ilk.9;
        Fri, 08 Jul 2022 01:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=P6Gd+dIUTT3KkGrv9ENkxJer9nCvFgdfmHoOd7OvfxA=;
        b=MXWXmsdiLUQnCnslmIwo2CH3pAvsVQmDpyWIyYp9f7wga1G+VyuLRAz/FltCJ0DMon
         qlSREkRY0G2UDgvQV1IwPGaoISST0gSuQeBY1XKGFgQvEqllJbydZSWKtUURftpz5Hpe
         XfeNCZpdv6p7oe/Yzhqb8WqZcTs8SmmIYIG+je+fKAwtkecCAzBbiWVMoIz7jAcMAzI2
         Uze4Yo3RQ7KwKqDvf+Uvsdp7aANozHX4n0LESp/DxleVp2ocNDmEeOirGG5BQU4Fw5V2
         Dques4ELlQEy+G+X5jOJEmyaldF5VIGSUmFxL6jOzUC0sIO25BQkgaferMTWPufdyidJ
         aTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P6Gd+dIUTT3KkGrv9ENkxJer9nCvFgdfmHoOd7OvfxA=;
        b=hxNU/o/DEvafv3YhtIsyhK/iBA7iuVgrEBp9x3BHSsXOZ7CGhARz1MaTPGWmLfLRVy
         /pPznyBGmg++vNRx3xONMX87e8bRy87xqm+c7sZl2htfyd3cDqhTcEujL8pQR9f0LbON
         E+Kih3TqZTYVaqu4arzXrwX2g3ssKn7R1/crA23k7oqszrFnoRIorkcgBLngJi1d+8Fs
         VAbZgYHPEt2Mt8BwUugKOm8bp+43706x9HIZ1O8vc7/ZwFe83/dKQ/eeeNiC6srOZEL9
         jUdsD0xrUvN4v78pZ5BjWJqJRnn0XEoHqQB9dcde2h+TFjfWcxDIRAke/dTbDqGW4LiW
         eJZg==
X-Gm-Message-State: AJIora+EFbsbSZ2eM2XxARziXUDWpNld3TdrVaZaW5475TRPRp+4eEaO
        Ag+Ej5FaLsXHwjvMg8iu9Jk=
X-Google-Smtp-Source: AGRyM1sMYLA3oN2FhV8iRlBxBKPC6Ma2VfIhQd5iP198thNMgX+FuuPQHfTYCjFgSpS9UIvXNT8yBA==
X-Received: by 2002:a05:6e02:1549:b0:2dc:616a:1dd4 with SMTP id j9-20020a056e02154900b002dc616a1dd4mr47747ilu.131.1657268283864;
        Fri, 08 Jul 2022 01:18:03 -0700 (PDT)
Received: from [192.168.1.145] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id g18-20020a05663810f200b0033cbfb5202esm2928253jae.11.2022.07.08.01.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 01:18:02 -0700 (PDT)
Message-ID: <c088f936-00a1-4a7b-c995-dd49b011494f@gmail.com>
Date:   Fri, 8 Jul 2022 10:17:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net v2] stmmac: dwmac-mediatek: fix clock issue
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
References: <20220708075622.26342-1-biao.huang@mediatek.com>
 <20220708075622.26342-2-biao.huang@mediatek.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <20220708075622.26342-2-biao.huang@mediatek.com>
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



On 08/07/2022 09:56, Biao Huang wrote:
> Since clocks are handled in mediatek_dwmac_clks_config(),
> remove the clocks configuration in init()/exit(), and
> invoke mediatek_dwmac_clks_config instead.
> 
> This issue is found in suspend/resume test.
> 
> Fixes: 3186bdad97d5 ("stmmac: dwmac-mediatek: add platform level clocks management")
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>   .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 32 ++++++-------------
>   1 file changed, 10 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> index 6ff88df58767..6d82cf2658e0 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> @@ -576,32 +576,12 @@ static int mediatek_dwmac_init(struct platform_device *pdev, void *priv)
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
>   }
>   
>   static void mediatek_dwmac_exit(struct platform_device *pdev, void *priv)
>   {
> -	struct mediatek_dwmac_plat_data *plat = priv;
> -	const struct mediatek_dwmac_variant *variant = plat->variant;
> -
> -	clk_disable_unprepare(plat->rmii_internal_clk);
> -	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
> +	/* nothing to do now */

We can just leave the function pointer point to NULL, that get checked before 
calling exit.

Regards,
Matthias

>   }
>   
>   static int mediatek_dwmac_clks_config(void *priv, bool enabled)
> @@ -712,13 +692,21 @@ static int mediatek_dwmac_probe(struct platform_device *pdev)
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
