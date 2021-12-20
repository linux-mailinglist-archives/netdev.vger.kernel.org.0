Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FB247A87F
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 12:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhLTLUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 06:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhLTLUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 06:20:21 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA688C061574;
        Mon, 20 Dec 2021 03:20:20 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id e5so19326778wrc.5;
        Mon, 20 Dec 2021 03:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EHCh6r9rSUzZ/WtBAei5gQAlNFlmbVYEHyjfRoUFZ7s=;
        b=fEVWBffJru8IdLqq0/poRqBNYp9BdtpI7gmLYKwH2icX36GcB2UZ+XpIHHadAn1suM
         OWKDH5Ch4A6Xu8NYopwoAKkWAK4cgy/ZenusZWIGKYKLqelwT3bpWfaFyu4+91/ZBVqy
         SOrOeHHglpl6NcQ7ZDM92PiyUI2gCk145cnbQbekEkUcu5aFSs6DNq1EUksgodu4qesU
         kyekcdTf6doPJH0+0/ZlAHLIUQ20SiJF3nQ/GOzRkq6xge618TG8BNQWLcaNlRlXQXFO
         daqN+V55O7XaR9LFsTRCJfqLUkZm/zv/SB0tNQ/XXftV2hGQ1v9ZflW1JSu7B8mULkUH
         AYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=EHCh6r9rSUzZ/WtBAei5gQAlNFlmbVYEHyjfRoUFZ7s=;
        b=hO0Fnketcua7QGHUAz8zSxz63YDF75d/Ic2fbnvCHDs8oFrUB5Q9VPXOqN81zb1JGi
         c/ZpKl5kwhUGZvtM7S6NphiafPExoDRRhsyNn2RPlxa1vEpLHldL2b4w7j8TspoR09ug
         f40/HyJP557zX39WiY4E6qRQ9AKdFp2786BfZCb0El0IAXw82Vl2cxdgsPKsDH5x3T2Z
         BOPur+5moUyyLwFPhr3nIAH2gkDvOvv+4VHPJwWUAyxkPmuzVb9xApKWHOYvmyqhFzZw
         aKNAzOyT3VNR0erf272EBIoitqLZWdu/T1GrYRtltt4dN3jsqYTQLA88F/liMsR+m9x2
         McWw==
X-Gm-Message-State: AOAM531v9p/am0S2+6z1/FhYosHhnqQqnJ0H6si1e2AErgZvsuKxS2uq
        xE0n3O7dnav5rZe6pOr33/E=
X-Google-Smtp-Source: ABdhPJwKyZ0pbjgqzvj4ZR4Gv09Oi5kKYLzREwH1BaSi81GKh6DEMSmDI5X1l7G91KXKkLMXG/DmzQ==
X-Received: by 2002:a5d:624f:: with SMTP id m15mr12176674wrv.13.1639999219382;
        Mon, 20 Dec 2021 03:20:19 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id m21sm15413494wrb.2.2021.12.20.03.20.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Dec 2021 03:20:18 -0800 (PST)
Date:   Mon, 20 Dec 2021 11:20:16 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v4] sfc: potential dereference null pointer of
 rx_queue->page_ring
Message-ID: <20211220112016.skhopsmnu6a4eapd@gmail.com>
Mail-Followup-To: Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211220023715.746815-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220023715.746815-1-jiasheng@iscas.ac.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 10:37:15AM +0800, Jiasheng Jiang wrote:
> The return value of kcalloc() needs to be checked.

Maybe my previous reply against v2 crossed with your later versions.

Your predicate is wrong. The code that uses rx_queue->page_ring
can deal with it being NULL.
The only thing you might want to do is set rx_queue->page_ptr_mask
to 0.
It is a mask, never use a signed value for it.

Martin

> To avoid dereference of null pointer in case of the failure of alloc,
> such as efx_fini_rx_recycle_ring().
> Therefore, it should be better to change the definition of page_ptr_mask
> to signed int and then assign the page_ptr_mask to -1 when page_ring is
> NULL, in order to avoid the use in the loop.
> 
> Fixes: 5a6681e22c14 ("sfc: separate out SFC4000 ("Falcon") support into new sfc-falcon driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
> Changelog:
> 
> v3 -> v4
> 
> *Change 1. Casade return -ENOMEM when alloc fails and deal with the
> error.
> *Change 2. Set size to -1 instead of return error.
> *Change 3. Change the Fixes tag.
> ---
>  drivers/net/ethernet/sfc/net_driver.h | 2 +-
>  drivers/net/ethernet/sfc/rx_common.c  | 5 ++++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 9b4b25704271..beba3e0a6027 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -407,7 +407,7 @@ struct efx_rx_queue {
>  	unsigned int page_recycle_count;
>  	unsigned int page_recycle_failed;
>  	unsigned int page_recycle_full;
> -	unsigned int page_ptr_mask;
> +	int page_ptr_mask;
>  	unsigned int max_fill;
>  	unsigned int fast_fill_trigger;
>  	unsigned int min_fill;
> diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
> index 68fc7d317693..d9d0a5805f1c 100644
> --- a/drivers/net/ethernet/sfc/rx_common.c
> +++ b/drivers/net/ethernet/sfc/rx_common.c
> @@ -150,7 +150,10 @@ static void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
>  					    efx->rx_bufs_per_page);
>  	rx_queue->page_ring = kcalloc(page_ring_size,
>  				      sizeof(*rx_queue->page_ring), GFP_KERNEL);
> -	rx_queue->page_ptr_mask = page_ring_size - 1;
> +	if (!rx_queue->page_ring)
> +		rx_queue->page_ptr_mask = -1;
> +	else
> +		rx_queue->page_ptr_mask = page_ring_size - 1;
>  }
>  
>  static void efx_fini_rx_recycle_ring(struct efx_rx_queue *rx_queue)
> -- 
> 2.25.1
