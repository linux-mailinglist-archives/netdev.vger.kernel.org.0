Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3539A2AA61B
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 16:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgKGPIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 10:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbgKGPIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 10:08:07 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331C3C0613CF;
        Sat,  7 Nov 2020 07:08:07 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id ei22so57336pjb.2;
        Sat, 07 Nov 2020 07:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AHUD2fSWmRWCnVwJ7/g4Q565pbRjksATWCU4DrhoO2w=;
        b=nrR7ELNUGn6L1HcAGcqBahsXy9FW4LFsKPn+KBQ8wkHZZuBKzrs2MoKkaSQUvO4gpS
         IaRYWaALBsMyCUOwubt5HYYKAjWESp911JX5zFOLrDya4fPY9VrnSxJuo/6WxyvSzJDt
         1ytr5W/Tp/1KRY/4SaGMZNvHjlhMPlaOuGinssUQuOyXIP2na/9dBh0YnwYEUamDLeYB
         0hJt7ogXDxPfNcCTgd2ABHRibrQCz44H9n8KFh6QpJX/fA+LSV1AiPFpAJyCfMT1b6cb
         /5+GrminvHizmdPZiccOzZtojiEDtnJ+/awmJq0dnl/sCKUQt0NgjXK7/cXWaR6X2Tvy
         +87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AHUD2fSWmRWCnVwJ7/g4Q565pbRjksATWCU4DrhoO2w=;
        b=fNA9N4VBDBmMmuqc0BK0N/qqDYYP29nZLmr2SPDrrec820Xdokeb7GCkr/BRr1k8NR
         GR4FxxTJJz4qjg2jaLwdrd+kmviVdOVJ7ULyVGfvn2RqZ71y4edc1GhXGvmC15vtyHum
         DcR3UCyY7rqTmAnbniCIywsTwa1t+71KjfWEJD12/6FEF9QtJfiZ6K7zMPf4imQFTCxc
         gRSxin3H/7kpCjO7By+6h/ifiRVT1C0n3Po9Dn2f3pKgUCSgSxPdbf83BWINfAMuZ9TU
         8RmDDXrYd58aYf2jaTyfiFKE4PcNY8fyaG3PerphZLK14ZJlaVaLruWTYXrcZvcgRdHh
         6YZg==
X-Gm-Message-State: AOAM5315k539IVWwVXbCtxljj+vwQMCV2DPpn2SSUlP1Jurc+Y476zAD
        EqKTZ9qZF5fNI2pxhiTpdxQ=
X-Google-Smtp-Source: ABdhPJw+o+JKvzKjEARCmDPUYYiMDHuEN2uzQNsnbcjUT1n391HjVsg6Kadv7AD8diHxLYX5GAtf+w==
X-Received: by 2002:a17:902:788e:b029:d6:9a57:ccab with SMTP id q14-20020a170902788eb02900d69a57ccabmr2776243pll.41.1604761686809;
        Sat, 07 Nov 2020 07:08:06 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id i130sm5220585pgc.7.2020.11.07.07.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 07:08:06 -0800 (PST)
Date:   Sat, 7 Nov 2020 07:08:03 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ethernet: update ret when ptp_clock is ERROR
Message-ID: <20201107150803.GD9653@hoboy.vegasvil.org>
References: <1604649411-24886-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604649411-24886-1-git-send-email-wangqing@vivo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 03:56:45PM +0800, Wang Qing wrote:
> We always have to update the value of ret, otherwise the
>  error value may be the previous one.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>


> ---
>  drivers/net/ethernet/ti/am65-cpts.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
> index 75056c1..b77ff61
> --- a/drivers/net/ethernet/ti/am65-cpts.c
> +++ b/drivers/net/ethernet/ti/am65-cpts.c
> @@ -1001,8 +1001,7 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
>  	if (IS_ERR_OR_NULL(cpts->ptp_clock)) {
>  		dev_err(dev, "Failed to register ptp clk %ld\n",
>  			PTR_ERR(cpts->ptp_clock));
> -		if (!cpts->ptp_clock)
> -			ret = -ENODEV;
> +		ret = cpts->ptp_clock ? cpts->ptp_clock : (-ENODEV);
>  		goto refclk_disable;
>  	}
>  	cpts->phc_index = ptp_clock_index(cpts->ptp_clock);
> -- 
> 2.7.4
> 
