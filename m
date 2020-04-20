Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1221B1485
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgDTSdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727813AbgDTSdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:33:11 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67013C061A0F
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:33:11 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t40so227391pjb.3
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wdK+ZmyHJ8BuX0/w8SfTfOuwr/SBH6XRoaemgO2Ls4k=;
        b=TDWwmuOPrMw4BsnZqSutMWg7WSm34HIymiEuI21b//vwc8Ww7xHBJugsufaMyRS0XU
         hq1/JpYxQuS8mOEE2j5xcJ5HbKdrGXk5Y+TqkmFC6VUixx5bK5E4hNF+pN65Chq8VWpu
         7eC3NORw0GIAGRU9irVR6UL43dRo24HAz0d2NUQCYcnDeyS9qm58V89HKAm95om9/iRA
         0biBxxm4gDFnaCnwl38FfSONyLeMmhw7KpHhNGBvPi4EERLQbd6pvg1aFh5HF074oihq
         FOkZYcu5mBikgrkDtEe3jNhNs0JcMEq4U2U9UIWhwq8SvjZIEX//KGkbNGYEjENgaGtJ
         Wkjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wdK+ZmyHJ8BuX0/w8SfTfOuwr/SBH6XRoaemgO2Ls4k=;
        b=SkXu5QSfXE/2JQDyLu1dv/hTVTgWQciRI2Ikz9EVp9UVF2gqkJejODk9xqj0eONMiV
         LyEhknw1n5FNE8FOu8SBw6eDEDS90cRCDhsIwtH7NzmbECPTcGKIMc17MLfjL5Koc0Lf
         VnpqkI7mNE2TGxomMdPKF3HrrZlT7a391fDNSio0ALWlpNVaraAzM2vTurZc3nq1Cmpv
         qgJ93d0X1dM73zIyYOGtA4VYuiugck7gZPHmWOBZFQzR7HdGgL8QvTUSXsQ1dBXhHjb7
         cwl5tbNjW5+K7wL7f0JdALoo6KKtzSN0PoVbw6EVqNeub7A3BNM3aSW/YAeyQ6DQVN/F
         IPuQ==
X-Gm-Message-State: AGi0PuaAVKNopiBYu3pC1Jinp7GaC0kRrHve5QltHAwoVAwYZCZl/Kfz
        qh7ALhB88Pw+lp7aQthNTy4G+FJu
X-Google-Smtp-Source: APiQypLRTdLbzTQn9KB6UKdzWAfjZEhM71ToOgaiu0P/1XoPeDZoaArvoT5ZWIw4sQlOowURMKCLVA==
X-Received: by 2002:a17:90a:224a:: with SMTP id c68mr919270pje.160.1587407590385;
        Mon, 20 Apr 2020 11:33:10 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t80sm197110pfc.23.2020.04.20.11.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 11:33:09 -0700 (PDT)
Subject: Re: [PATCH v1] net: bcmgenet: Use devm_clk_get_optional() to get the
 clocks
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200420183058.67457-1-andriy.shevchenko@linux.intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c8d2dfb4-2833-7b68-3641-4f3ce2139cb2@gmail.com>
Date:   Mon, 20 Apr 2020 11:33:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420183058.67457-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/2020 11:30 AM, Andy Shevchenko wrote:
> Conversion to devm_clk_get_optional() makes it explicit that clocks are
> optional. This change allows to handle deferred probe in case clocks are
> defined, but not yet probed. Due to above changes replace dev_dbg() by
> dev_err() and bail out in error case.
> 
> While here, check potential error when enable main clock.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>   .../net/ethernet/broadcom/genet/bcmgenet.c    | 25 +++++++++++--------
>   1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index ef275db018f73..045f7b7f0b5d3 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3487,13 +3487,16 @@ static int bcmgenet_probe(struct platform_device *pdev)
>   		priv->dma_max_burst_length = DMA_MAX_BURST_LENGTH;
>   	}
>   
> -	priv->clk = devm_clk_get(&priv->pdev->dev, "enet");
> +	priv->clk = devm_clk_get_optional(&priv->pdev->dev, "enet");
>   	if (IS_ERR(priv->clk)) {
> -		dev_dbg(&priv->pdev->dev, "failed to get enet clock\n");
> -		priv->clk = NULL;
> +		dev_err(&priv->pdev->dev, "failed to get enet clock\n");

Please maintain the dev_dbg() here and likewise for the rest of your 
changes. With that:

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
