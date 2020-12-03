Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA662CE2AB
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 00:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgLCX3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 18:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgLCX27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 18:28:59 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFC7C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 15:28:19 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id b18so3530173ots.0
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 15:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=19kM80HD8C/ry8leq9oAcgd7dznTHbfusHUaV72L7yc=;
        b=R5qQq40V3xSTF0yj4dk7I2AYHeA0bSzM/adQ6OHcPo3lXhJa3g+cIkejDZDIz4OBL8
         ytNCw2hjPhYy4Z6Y3L15YR4at7iOD45Zj+UragKQArgegWQ9Qcfqr7WtFIScwSkdpjN8
         j97MRjE2JnQ8mncc6MxcxeMZEcLGy2bfL9EU/xhJ1ijH6OneXeYIkoXNA41rnvm8C/tv
         RDZHrxjccz2MSVxi48cbfwABgVEy6ckJ1vKtiKXSvSnHguv7jupuZEXGUgIrg9JFgtiZ
         0mAx8fI3cbPlcqdD7Lgx5N1iZYDnqjwk1toiJphbi7FqbiUNMOHWAZH/kp8utjB9lSOW
         xx8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=19kM80HD8C/ry8leq9oAcgd7dznTHbfusHUaV72L7yc=;
        b=QaQT7tZ6Rag1LyFCh6t5TABtdhY2FhMkHcyJ1SJyCU1+bJFhMSh+ZO158B8npDp3y9
         Xp6FQc/GB+5bCo70Fh2Iu6LcoUDPGNWRQElivCoMUDN8ppGkZkl+hWWsiRX/eqpPDqDX
         tGSbm7Ome9AooQAJ5G4BeLjbXj/PTTcA38nEZZ5u702TZweJGeyTTbO+Xa+v5gORQNvs
         KOhjYCNz8W0at8gg8DAVE6tiwU0RcB0dthbpOiukcS49/ciV0f0kHOio/kmBQK0I4q80
         d67ury5LRZWjZirJB2dB6eDOy7is0WJivMtHyi4X0TpxGFCctp/LnSwoWrpBpUUVKqDD
         Uihw==
X-Gm-Message-State: AOAM530yMRL5uSmYlX/eqrXvRvDShp+7Zn4ywMPn4xR87Ud+X+JPioqy
        NhTrTB3rGC89xzhrn4ghKxSslrvLrb68/w==
X-Google-Smtp-Source: ABdhPJwDp5dMa72NvqwQsNj4Lo4e8SGwIHy1kOCb5htuMwlIoQKq0Ez5JBFAM1EwRDnLJbKivYe4dw==
X-Received: by 2002:a05:6830:114e:: with SMTP id x14mr1366088otq.253.1607038098944;
        Thu, 03 Dec 2020 15:28:18 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id 94sm220427otw.41.2020.12.03.15.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 15:28:18 -0800 (PST)
Date:   Thu, 3 Dec 2020 17:28:16 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, swboyd@chromium.org,
        sujitka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/1] net: ipa: pass the correct size when freeing DMA
 memory
Message-ID: <X8l0kGv2uvo4ueOn@builder.lan>
References: <20201203215106.17450-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203215106.17450-1-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 03 Dec 15:51 CST 2020, Alex Elder wrote:

> When the coherent memory is freed in gsi_trans_pool_exit_dma(), we
> are mistakenly passing the size of a single element in the pool
> rather than the actual allocated size.  Fix this bug.
> 
> Fixes: 9dd441e4ed575 ("soc: qcom: ipa: GSI transactions")
> Reported-by: Stephen Boyd <swboyd@chromium.org>
> Tested-by: Sujit Kautkar <sujitka@chromium.org>
> Signed-off-by: Alex Elder <elder@linaro.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  drivers/net/ipa/gsi_trans.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
> index e8599bb948c08..6c3ed5b17b80c 100644
> --- a/drivers/net/ipa/gsi_trans.c
> +++ b/drivers/net/ipa/gsi_trans.c
> @@ -156,6 +156,9 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
>  	/* The allocator will give us a power-of-2 number of pages.  But we
>  	 * can't guarantee that, so request it.  That way we won't waste any
>  	 * memory that would be available beyond the required space.
> +	 *
> +	 * Note that gsi_trans_pool_exit_dma() assumes the total allocated
> +	 * size is exactly (count * size).
>  	 */
>  	total_size = get_order(total_size) << PAGE_SHIFT;
>  
> @@ -175,7 +178,9 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
>  
>  void gsi_trans_pool_exit_dma(struct device *dev, struct gsi_trans_pool *pool)
>  {
> -	dma_free_coherent(dev, pool->size, pool->base, pool->addr);
> +	size_t total_size = pool->count * pool->size;
> +
> +	dma_free_coherent(dev, total_size, pool->base, pool->addr);
>  	memset(pool, 0, sizeof(*pool));
>  }
>  
> -- 
> 2.20.1
> 
