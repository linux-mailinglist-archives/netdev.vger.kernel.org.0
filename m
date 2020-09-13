Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D49267D58
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 04:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgIMCuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 22:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgIMCuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 22:50:11 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E4CC061573
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 19:50:10 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id y6so13845444oie.5
        for <netdev@vger.kernel.org>; Sat, 12 Sep 2020 19:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6Z/KItHX4UBZ3A8mIN9UT3WhCljCauyu5FyzaVBHpJU=;
        b=GHohS+Qku3/9u4+xvBj0PjEnXJyhI/kZO1gOdb/ScR8fyGFLWV22hLZnVzOP3EhTxp
         O9SS059PbaT6wQbmBiluaCF4O3+JN5Qr4C4oZggRbD0PF48HDBKUTS4E/CdBnH6k5tTP
         OSq+mvcYCYFGfTHwdIbYgE+SRXzakFD5HbjbGacVwd3QRUiqM2DrTUnIwVhDJhewpebx
         FURW5qngcFtxSkQsxS8MO0fp6bqzTnTgAJlLkMUXSgjfIvPa1s/cj1F8DJ3JdL/DGxtz
         Z0WKdXHdsGUjWepc3x779dkrU7VsKHWfCfY+OUWh7SCe8xyc/C3qMs9GfZTjS01rbfia
         yFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Z/KItHX4UBZ3A8mIN9UT3WhCljCauyu5FyzaVBHpJU=;
        b=MDMjne5g3NArRH/oQN5ixKD2XYISxE2dTw2GmOQtyoLBniMj4BHkDjHmig17tRPsYO
         S5qoeeXSFgBT2wMck9GqcPYfACWrjN7tD1IYWySx5pbomFtjloECnSuwRcGJ0xUFv6vl
         0yzzAXxlwWF/+e4q+HW71Rrd9Mv0ODQK3Eu+ICa2D38gtynmDDNRbe5UOt5u9zj/2LkH
         8GtiLOCQU/sjA6ARWFoFS8FDZw3RSy77w301/p8zPddWDnMPcwNU89I/BFHdZGXB5PVm
         EvySbAIWu+mICnP9thK4QGhBYwO+kiy3gg14by8iVwZc8b6D9zhdfKCsgvCzNYS23KD9
         uPFA==
X-Gm-Message-State: AOAM531mnALxm5g5L1/r1xcP092X/EWpGnVOiOfYNBlzf37+967Pw2eB
        Ug9QKL0bj3RfQoS96pMldRjxqw==
X-Google-Smtp-Source: ABdhPJzSZ3tCGnysTLJnudFsNAeqb+9SEUgzYSYJzt/qdDSnjuxmYNF1qBZJ2ukDz5JkAQCBq4MYlQ==
X-Received: by 2002:aca:4901:: with SMTP id w1mr4969366oia.160.1599965409930;
        Sat, 12 Sep 2020 19:50:09 -0700 (PDT)
Received: from yoga ([2605:6000:e5cb:c100:8898:14ff:fe6d:34e])
        by smtp.gmail.com with ESMTPSA id i7sm1191491oto.62.2020.09.12.19.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 19:50:08 -0700 (PDT)
Date:   Sat, 12 Sep 2020 21:50:06 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 7/7] net: ipa: do not enable GSI interrupt
 for wakeup
Message-ID: <20200913025006.GQ3715@yoga>
References: <20200912004532.1386-1-elder@linaro.org>
 <20200912004532.1386-8-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912004532.1386-8-elder@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 11 Sep 19:45 CDT 2020, Alex Elder wrote:

> We now trigger a system resume when we receive an IPA SUSPEND
> interrupt.  We should *not* wake up on GSI interrupts.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/gsi.c | 17 ++++-------------
>  drivers/net/ipa/gsi.h |  1 -
>  2 files changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index 0e63d35320aaf..cb75f7d540571 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -1987,31 +1987,26 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
>  	}
>  	gsi->irq = irq;
>  
> -	ret = enable_irq_wake(gsi->irq);
> -	if (ret)
> -		dev_warn(dev, "error %d enabling gsi wake irq\n", ret);
> -	gsi->irq_wake_enabled = !ret;
> -
>  	/* Get GSI memory range and map it */
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gsi");
>  	if (!res) {
>  		dev_err(dev, "DT error getting \"gsi\" memory property\n");
>  		ret = -ENODEV;
> -		goto err_disable_irq_wake;
> +		goto err_free_irq;
>  	}
>  
>  	size = resource_size(res);
>  	if (res->start > U32_MAX || size > U32_MAX - res->start) {
>  		dev_err(dev, "DT memory resource \"gsi\" out of range\n");
>  		ret = -EINVAL;
> -		goto err_disable_irq_wake;
> +		goto err_free_irq;
>  	}
>  
>  	gsi->virt = ioremap(res->start, size);
>  	if (!gsi->virt) {
>  		dev_err(dev, "unable to remap \"gsi\" memory\n");
>  		ret = -ENOMEM;
> -		goto err_disable_irq_wake;
> +		goto err_free_irq;
>  	}
>  
>  	ret = gsi_channel_init(gsi, prefetch, count, data, modem_alloc);
> @@ -2025,9 +2020,7 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
>  
>  err_iounmap:
>  	iounmap(gsi->virt);
> -err_disable_irq_wake:
> -	if (gsi->irq_wake_enabled)
> -		(void)disable_irq_wake(gsi->irq);
> +err_free_irq:
>  	free_irq(gsi->irq, gsi);
>  
>  	return ret;
> @@ -2038,8 +2031,6 @@ void gsi_exit(struct gsi *gsi)
>  {
>  	mutex_destroy(&gsi->mutex);
>  	gsi_channel_exit(gsi);
> -	if (gsi->irq_wake_enabled)
> -		(void)disable_irq_wake(gsi->irq);
>  	free_irq(gsi->irq, gsi);
>  	iounmap(gsi->virt);
>  }
> diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
> index 061312773df09..3f9f29d531c43 100644
> --- a/drivers/net/ipa/gsi.h
> +++ b/drivers/net/ipa/gsi.h
> @@ -150,7 +150,6 @@ struct gsi {
>  	struct net_device dummy_dev;	/* needed for NAPI */
>  	void __iomem *virt;
>  	u32 irq;
> -	bool irq_wake_enabled;
>  	u32 channel_count;
>  	u32 evt_ring_count;
>  	struct gsi_channel channel[GSI_CHANNEL_COUNT_MAX];
> -- 
> 2.20.1
> 
