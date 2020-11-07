Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC94C2AA610
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 15:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgKGO6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 09:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgKGO6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 09:58:20 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE19C0613CF;
        Sat,  7 Nov 2020 06:58:20 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id o129so4293109pfb.1;
        Sat, 07 Nov 2020 06:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DzDbmpa7PDJNmNrEu59aNS3VURkIYbrGEZmNsFTPCzU=;
        b=NHA1maLZmOecbN33cjXcE99lZ+lgnKBnZGsxwkuenOCv+Y8EHj2f27ibH2e+fTX6Dt
         cVY4sMgBd+fO0ObwvJABQYr8NUaF4fTZhge+nppanK/5wHts9GPIqfPeR4jiha2n6pwA
         93zyU83/g/wFPX8jODmqinzVHI9boqSEkOZLZeuN+qjPpmqnJ5yXMCWrFT7U+OZanNTE
         DIk9h3UQqwnOPfb3GsW1UYP5phHVsJTdJPO+7B7BmuzPIgV/LtXOwJ/iWqCEkh4Nuret
         KPThvC6+B+Ep1nT5xlVtc7onaNqRyYzXGZZEKmGtYMkEBsf+RnkagcPXrVK3CN6m9BXq
         tR6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DzDbmpa7PDJNmNrEu59aNS3VURkIYbrGEZmNsFTPCzU=;
        b=CiDZHxE9wPoIvPBVeyziDB3v/hRwZaFrUlQy9/mMWlpkiNEpBoYueXLpyoilHTPrQJ
         KT5S/t8Dswjhi4trESyrj/ZZd0VUmgmhpsvJPWuGTZirxKtS1wN6AsD9KMyDYQ06833B
         Nj8LZ6oVNZ7INxpM79wUMSXgJ9JGueFe2ekDzrYKioU4waNU2NA4wKTsmMAKOZeJ7YwM
         pU4vnLUT13MqEbBZqiALiRT5l/disYMbECxTKZtr8xjNmmxshprGeg+Yx/7080rSbjJS
         sbDORFGV2z7S1aLlauDgaigQML/9Fq56p8CjLuN3tlyTQizGrM/XIJW8E3lTvX4LJIYZ
         2ybA==
X-Gm-Message-State: AOAM533xVY+yCJ55JgrCHQrWhGVwlJBm6QmqTw+KVAw/PR3H2oi6MScR
        AscmvJtlGSdBDzwVdUijkHY=
X-Google-Smtp-Source: ABdhPJyCd6kue3qJnlBdJ5eJ/4VKHU30TyXUos1sUhUEuvpMGzIETJfbuNvycSSqWcS02M8mYNxDCQ==
X-Received: by 2002:a05:6a00:1647:b029:18b:e825:8a6c with SMTP id m7-20020a056a001647b029018be8258a6cmr756850pfc.19.1604761100425;
        Sat, 07 Nov 2020 06:58:20 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id r6sm5903023pfh.166.2020.11.07.06.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 06:58:19 -0800 (PST)
Date:   Sat, 7 Nov 2020 06:58:16 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Samuel Zou <zou_wei@huawei.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [V2] [PATCH] net/ethernet: update ret when ptp_clock is ERROR
Message-ID: <20201107145816.GB9653@hoboy.vegasvil.org>
References: <1604720323-3586-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604720323-3586-1-git-send-email-wangqing@vivo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 07, 2020 at 11:38:38AM +0800, Wang Qing wrote:
> We always have to update the value of ret, otherwise the error value
>  may be the previous one. And ptp_clock_register() never return NULL
>  when PTP_1588_CLOCK enable, so we use IS_ERR here.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  drivers/net/ethernet/ti/am65-cpts.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
> index 75056c1..ec8e56d
> --- a/drivers/net/ethernet/ti/am65-cpts.c
> +++ b/drivers/net/ethernet/ti/am65-cpts.c
> @@ -998,11 +998,10 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
>  	am65_cpts_settime(cpts, ktime_to_ns(ktime_get_real()));
>  
>  	cpts->ptp_clock = ptp_clock_register(&cpts->ptp_info, cpts->dev);
> -	if (IS_ERR_OR_NULL(cpts->ptp_clock)) {

This test was correct.

> +	if (IS_ERR(cpts->ptp_clock)) {

This one is wrong.

Thanks,
Richard


>  		dev_err(dev, "Failed to register ptp clk %ld\n",
>  			PTR_ERR(cpts->ptp_clock));
> -		if (!cpts->ptp_clock)
> -			ret = -ENODEV;
> +		ret = PTR_ERR(cpts->ptp_clock);
>  		goto refclk_disable;
>  	}
>  	cpts->phc_index = ptp_clock_index(cpts->ptp_clock);
> -- 
> 2.7.4
> 
