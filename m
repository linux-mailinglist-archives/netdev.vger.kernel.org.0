Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E869F4B2F08
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 22:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242588AbiBKVCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 16:02:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234849AbiBKVCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 16:02:02 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819E0A5
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 13:01:59 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id x3so5638991pll.3
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 13:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yz38RNlOZaGDJ11OPh7x9N5SBPtZIV96QZKf5ph9jFI=;
        b=KSGB3XOU/zht6RcCfPNsk7rwVry1zBZ5nJ0Ue9y++f3unyuy7XEO0+pAGWoGtScUv1
         7JRR7w482Yh1pGWYHBTsFxCM9l53ixvF7IT/kqEF+q8MlbforDGXcFOmcSoUKdhoXXEe
         b7+QMp4ZwAUc78btD72BrnXSRIgPMiLlKr4NO9yp+PmeQY3xZlr7+XJvl3spzgllmDPG
         W8j41mxFMyIfiugxRuy/HxNVdjfXCE9WyKRNlYXI3enijPIj52Ew7Mp99aJTpzuMnV6r
         lDp8kdqOZg9NrbZnywuFzwqhxM31oKeS5+yy/dJ7vytvQIs+88WMouzLJgFnsdt/4KM0
         nEcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yz38RNlOZaGDJ11OPh7x9N5SBPtZIV96QZKf5ph9jFI=;
        b=HknXJwZZUwpN6YNHd8TWCxo+AkkorfAC7XvSHeVpwezan1xzFkkLx6FQ2iLR/eg9V3
         GQypl0uDRz8snuOXgE0JOY3HrnrubKq5c9gJavf3LyqcpJ/B14ZsEdwYUTJmoGPgQ/4S
         69o2CUjSwfprwrXmAmbge2g9ex7frMr5zpw0qhWgPIhZTOCZWzwy/BSkUt+dOKGjN2Ag
         d/8QYmql1U44WfhLA7WrwLW6Vv5WdY3wmtJLhDzuA+NdncbKN2XlvOQxcwd2EWXi/kFQ
         izVRJ/5vj/gC5aqUVmhL3clAYVmi+iztuBQbzwYqDan/Ias5BLYoENdJxaZyR64B6USX
         0Tqw==
X-Gm-Message-State: AOAM531rV6tOVD0V+5ZH3VlmhPDLnXSH5AV2tHpTGNj8s/NhfNVeWrwS
        WENlWP3DM2hLspHD7YJ6MlU=
X-Google-Smtp-Source: ABdhPJxCdyhKG/tDbs0kCwZdLolYVg9hS0d+2nv5LLi24wDsvcUasB1FhDlA2s38JL2uXED4sNOm6g==
X-Received: by 2002:a17:903:1c8:: with SMTP id e8mr3206999plh.75.1644613318490;
        Fri, 11 Feb 2022 13:01:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id me18sm3321513pjb.39.2022.02.11.13.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 13:01:57 -0800 (PST)
Subject: Re: [PATCH net-next] net: dsa: realtek: realtek-mdio: reset before
 setup
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Frank Wunderlich <frank-w@public-files.de>
References: <20220211051403.3952-1-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ccf3f079-4567-7de6-46f2-7b8896b06d77@gmail.com>
Date:   Fri, 11 Feb 2022 13:01:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220211051403.3952-1-luizluca@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 2/10/22 9:14 PM, Luiz Angelo Daros de Luca wrote:
> Some devices, like the switch in Banana Pi BPI R64 only starts to answer
> after a HW reset. It is the same reset code from realtek-smi.
> 
> Reported-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---

[snip]

>  	ret = priv->ops->detect(priv);
>  	if (ret) {
>  		dev_err(dev, "unable to detect switch\n");
> @@ -183,6 +198,10 @@ static void realtek_mdio_remove(struct mdio_device *mdiodev)
>  	if (!priv)
>  		return;
>  
> +	/* leave the device reset asserted */
> +	if (priv->reset)
> +		gpiod_set_value(priv->reset, 1);
> +
>  	dsa_unregister_switch(priv->ds);
>  
>  	dev_set_drvdata(&mdiodev->dev, NULL);
> diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
> index a849b5cbb4e4..cada5386f6a2 100644
> --- a/drivers/net/dsa/realtek/realtek-smi.c
> +++ b/drivers/net/dsa/realtek/realtek-smi.c
> @@ -43,8 +43,6 @@
>  #include "realtek.h"
>  
>  #define REALTEK_SMI_ACK_RETRY_COUNT		5
> -#define REALTEK_SMI_HW_STOP_DELAY		25	/* msecs */
> -#define REALTEK_SMI_HW_START_DELAY		100	/* msecs */
>  
>  static inline void realtek_smi_clk_delay(struct realtek_priv *priv)
>  {
> @@ -426,9 +424,9 @@ static int realtek_smi_probe(struct platform_device *pdev)
>  		dev_err(dev, "failed to get RESET GPIO\n");
>  		return PTR_ERR(priv->reset);
>  	}
> -	msleep(REALTEK_SMI_HW_STOP_DELAY);
> +	msleep(REALTEK_HW_STOP_DELAY);
>  	gpiod_set_value(priv->reset, 0);
> -	msleep(REALTEK_SMI_HW_START_DELAY);
> +	msleep(REALTEK_HW_START_DELAY);
>  	dev_info(dev, "deasserted RESET\n");

Maybe demote these to debug prints since they would show up every time
you load/unload the driver.
-- 
Florian
