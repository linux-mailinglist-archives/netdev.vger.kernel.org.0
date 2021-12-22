Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C87A47D299
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 14:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbhLVNEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 08:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236759AbhLVNEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 08:04:01 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4989C061574;
        Wed, 22 Dec 2021 05:04:00 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id e5so4796637wrc.5;
        Wed, 22 Dec 2021 05:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HKQIWNLYPt7amFrpeIymAqoGxzo0Cgh8nYeaaa5M1uA=;
        b=cU2XA5CSGjYISQe4AfmNub7qo8y8L/husj6deVctxz4Xgli5etSpWH8JllQMSio9x3
         briBu/f9ljZ06KDlZCq9JDZZLFCUvQMpoBhtJg2MkURnQmKBoDmp+6Mv8L1JucF0GqP/
         jNIGNEdolu7nsR6BSolLWALOaMq8bDJiUg8x5DiM4E9xtTi6v+R71J96clEsHz34KgnZ
         cBwLjbpjjiBvRFQRyJ2ADZdWRUynpfVx5QrM7zNLRNXqX2OKRfp4gD9whOfWG2o+Rh9x
         lia5QnhFMtZC/fRI1Wn0qr03tZdUUqj8P4K6VX659vUzLq/4dHxaUt9kfAlowcLQ9aKS
         hupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=HKQIWNLYPt7amFrpeIymAqoGxzo0Cgh8nYeaaa5M1uA=;
        b=of59V/wdHdxKU4ks4p7wqkSea+gGoRLvLP18a047jDFtC0LMYH5Q38DHZ1RrugfwPa
         BAdMm6haZIs5YnHGEPFPx9+YXav35+3uT0GAFtAqFUX8GWZ6F880IXS/muidlIX+fuZQ
         TGnCW57lsjc6EZCxJe1GUPCOearTvSENFV0xJnRa/6Omeucbe1WqRBWbpALlCKPS+sqK
         hUkICmxNMgTG7o44EFeb2slesRgPCsJqGi1T/ls0oUASLmUWfCbTZEMcpUCzHxHKP4w2
         ZHKiDnqpcOOVHdPYIBHT3WD4NnpobSNjeOjkNuqmfM0bFrptkCmr+PKgcY9DnFYon2mo
         /KIA==
X-Gm-Message-State: AOAM531Ua0JSbdG/gMg+xpCcCkzJYkj8Rj/wTL9MSPdXFK/rYVh5cvxF
        SXmKE6YzU0FqxP+TMfPogD0=
X-Google-Smtp-Source: ABdhPJzCSUsI+1Rnpp2auPNEAsP95AYQmrBIBFI047rty/ezPIaz/pYqp95RjJUYc00ugUrjw3lvdQ==
X-Received: by 2002:adf:f188:: with SMTP id h8mr2054843wro.663.1640178239296;
        Wed, 22 Dec 2021 05:03:59 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id g1sm1937049wri.103.2021.12.22.05.03.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Dec 2021 05:03:58 -0800 (PST)
Date:   Wed, 22 Dec 2021 13:03:56 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] sfc: Check null pointer of rx_queue->page_ring
Message-ID: <20211222130356.xlzmhoyexrnctkrs@gmail.com>
Mail-Followup-To: Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20211220135603.954944-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220135603.954944-1-jiasheng@iscas.ac.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 09:56:03PM +0800, Jiasheng Jiang wrote:
> Because of the possible failure of the kcalloc, it should be better to
> set rx_queue->page_ptr_mask to 0 when it happens in order to maintain
> the consistency.
> 
> Fixes: 5a6681e22c14 ("sfc: separate out SFC4000 ("Falcon") support into new sfc-falcon driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/rx_common.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
> index 68fc7d317693..0983abc0cc5f 100644
> --- a/drivers/net/ethernet/sfc/rx_common.c
> +++ b/drivers/net/ethernet/sfc/rx_common.c
> @@ -150,7 +150,10 @@ static void efx_init_rx_recycle_ring(struct efx_rx_queue *rx_queue)
>  					    efx->rx_bufs_per_page);
>  	rx_queue->page_ring = kcalloc(page_ring_size,
>  				      sizeof(*rx_queue->page_ring), GFP_KERNEL);
> -	rx_queue->page_ptr_mask = page_ring_size - 1;
> +	if (!rx_queue->page_ring)
> +		rx_queue->page_ptr_mask = 0;
> +	else
> +		rx_queue->page_ptr_mask = page_ring_size - 1;
>  }
>  
>  static void efx_fini_rx_recycle_ring(struct efx_rx_queue *rx_queue)
> -- 
> 2.25.1
