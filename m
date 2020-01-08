Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 292FC134562
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 15:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAHOx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 09:53:29 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39825 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbgAHOx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 09:53:28 -0500
Received: by mail-wm1-f66.google.com with SMTP id 20so2803692wmj.4
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 06:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oDgawAjx9LE1mCBJFYzV7pKgwkqN30nBQSzbJMJzKRY=;
        b=fzA8xz6mJ13TNMk4G8p9p6gJSEL56kcdIbge0WKwx9fmkHDpEOby5xgvGU15dGPiBt
         LryASkTUDunQDs9hiS2Uxw8ew1+bqoZkfP6KL2hrwHwq0+1Xg6J9wMDF5EjRMpy2a8O9
         6sTFIYFvrofneuRHgBORBJoUpLYflQtGoyURZvyyW4cWl5F1mH9bA/tI0OfVHuKWMuZN
         XpTTc9zUiYNJA/CDMjXn2zft8GYs81cEhibJimGjOEuI1L1x2RHF5ZkRost+99kLHH+H
         Cq/GLAw4nBIf3PicXt5mY/Dxl7+YLq268pb0qgum/+j8IaJSMfxyLyx0ySbchwucVDqA
         SmYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oDgawAjx9LE1mCBJFYzV7pKgwkqN30nBQSzbJMJzKRY=;
        b=fABsUb8TwSd+RWoPzjTi0/l2nHUcT6rIQYznxvMntdMDG/RILwDPDMSYNqJib5puDk
         c6PQ50+vZRGQ0Png2tuC3ATPz0EpfF2gy8sFZOVVQInhCObdxbqMPAdDiuvUw/GspB97
         pwGiF61rAQ2lPgNAHMKyV25nMqASmhDYZL+3hiRcmEgmV7CQfYMHE5xH7RLUTWVWb/uj
         yyvlqGU/jibNHUlJ7riXtaYFvsMbKcwWjf6dmSVdKN9yD4mGj7QQYcezcmvGPgp49A2d
         GftV08sDtvMSaNhNdd1Zg4C/aaxy/GnXuhFrjxWUmOyo3mDFr8yT1R4HKH8y31Fp5VsR
         B81Q==
X-Gm-Message-State: APjAAAU7g+7xsKuLie3Agu92QV3edIrVxyN82xPS1MHgHtLgOS5Ks/l/
        +Ecja8jjPqCweMm9xLQhBOiDdmy7iAE=
X-Google-Smtp-Source: APXvYqw61Hfet51ZxuHAPYVe+YpbF6wTrF4OCdUFLQ5s2PyCJQqWxTRvOmc3k+nh4z8jCyZAbHFRPg==
X-Received: by 2002:a1c:2089:: with SMTP id g131mr4507733wmg.63.1578495205855;
        Wed, 08 Jan 2020 06:53:25 -0800 (PST)
Received: from apalos.home (athedsl-321073.home.otenet.gr. [85.72.109.207])
        by smtp.gmail.com with ESMTPSA id f1sm3279422wmc.45.2020.01.08.06.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 06:53:25 -0800 (PST)
Date:   Wed, 8 Jan 2020 16:53:22 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, brouer@redhat.com, davem@davemloft.net,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH] net: socionext: get rid of huge dma sync in
 netsec_alloc_rx_data
Message-ID: <20200108145322.GA2975@apalos.home>
References: <5ed1bbf3e27f5b0105346838dfe405670183d723.1578410912.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ed1bbf3e27f5b0105346838dfe405670183d723.1578410912.git.lorenzo@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo, 

On Tue, Jan 07, 2020 at 04:30:32PM +0100, Lorenzo Bianconi wrote:
> Socionext driver can run on dma coherent and non-coherent devices.
> Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_data since
> now the driver can let page_pool API to managed needed DMA sync
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/socionext/netsec.c | 45 +++++++++++++++----------
>  1 file changed, 28 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index b5a9e947a4a8..00404fef17e8 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -243,6 +243,7 @@
>  			       NET_IP_ALIGN)
>  #define NETSEC_RX_BUF_NON_DATA (NETSEC_RXBUF_HEADROOM + \
>  				SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
> +#define NETSEC_RX_BUF_SIZE	(PAGE_SIZE - NETSEC_RX_BUF_NON_DATA)
>  
>  #define DESC_SZ	sizeof(struct netsec_de)
>  
> @@ -719,7 +720,6 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
>  {
>  
>  	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> -	enum dma_data_direction dma_dir;
>  	struct page *page;
>  
>  	page = page_pool_dev_alloc_pages(dring->page_pool);
> @@ -734,9 +734,7 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
>  	/* Make sure the incoming payload fits in the page for XDP and non-XDP
>  	 * cases and reserve enough space for headroom + skb_shared_info
>  	 */
> -	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
> -	dma_dir = page_pool_get_dma_dir(dring->page_pool);
> -	dma_sync_single_for_device(priv->dev, *dma_handle, *desc_len, dma_dir);
> +	*desc_len = NETSEC_RX_BUF_SIZE;
>  
>  	return page_address(page);
>  }
> @@ -883,6 +881,7 @@ static u32 netsec_xdp_xmit_back(struct netsec_priv *priv, struct xdp_buff *xdp)
>  static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
>  			  struct xdp_buff *xdp)
>  {
> +	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
>  	u32 ret = NETSEC_XDP_PASS;
>  	int err;
>  	u32 act;
> @@ -896,7 +895,10 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
>  	case XDP_TX:
>  		ret = netsec_xdp_xmit_back(priv, xdp);
>  		if (ret != NETSEC_XDP_TX)
> -			xdp_return_buff(xdp);
> +			__page_pool_put_page(dring->page_pool,
> +				     virt_to_head_page(xdp->data),
> +				     xdp->data_end - xdp->data_hard_start,

Do we have to include data_hard_start?

@Jesper i know bpf programs can modify the packet, but isn't it safe
to only sync for xdp->data_end - xdp->data in this case since the DMA transfer
in this driver will always start *after* the XDP headroom?

> +				     true);
>  		break;
>  	case XDP_REDIRECT:
>  		err = xdp_do_redirect(priv->ndev, xdp, prog);
> @@ -904,7 +906,10 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
>  			ret = NETSEC_XDP_REDIR;
>  		} else {
>  			ret = NETSEC_XDP_CONSUMED;
> -			xdp_return_buff(xdp);
> +			__page_pool_put_page(dring->page_pool,
> +				     virt_to_head_page(xdp->data),
> +				     xdp->data_end - xdp->data_hard_start,
 
Ditto

> +				     true);
>  		}
>  		break;
>  	default:
> @@ -915,7 +920,10 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
>  		/* fall through -- handle aborts by dropping packet */
>  	case XDP_DROP:
>  		ret = NETSEC_XDP_CONSUMED;
> -		xdp_return_buff(xdp);
> +		__page_pool_put_page(dring->page_pool,
> +				     virt_to_head_page(xdp->data),
> +				     xdp->data_end - xdp->data_hard_start,

Ditto

> +				     true);
>  		break;
>  	}
>  
> @@ -1014,7 +1022,8 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  			 * cache state. Since we paid the allocation cost if
>  			 * building an skb fails try to put the page into cache
>  			 */
> -			page_pool_recycle_direct(dring->page_pool, page);
> +			__page_pool_put_page(dring->page_pool, page,
> +					     desc->len, true);

I think you can sync for pkt_len here only, since that's the area the DMA engine
touched. Syncing for desc->len, will sync the entire area (like the older
version did).
Keep in mind that the driver always starts the DMA transfer after 
NETSEC_RXBUF_HEADROOM which is 192 or 256 bytes depending on XDP running or not.

So in the default SKB case if the pkt_len = 60 the 
xdp.data_end - xdp.data_hard_start = 316.

I think it's safe here to only sync pkt_len, since noone will touch the XDP
headroom

>  			netif_err(priv, drv, priv->ndev,
>  				  "rx failed to build skb\n");
>  			break;
> @@ -1272,17 +1281,19 @@ static int netsec_setup_rx_dring(struct netsec_priv *priv)
>  {
>  	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
>  	struct bpf_prog *xdp_prog = READ_ONCE(priv->xdp_prog);
> -	struct page_pool_params pp_params = { 0 };
> +	struct page_pool_params pp_params = {
> +		.order = 0,
> +		/* internal DMA mapping in page_pool */
> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> +		.pool_size = DESC_NUM,
> +		.nid = NUMA_NO_NODE,
> +		.dev = priv->dev,
> +		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
> +		.offset = NETSEC_RXBUF_HEADROOM,
> +		.max_len = NETSEC_RX_BUF_SIZE,
> +	};
>  	int i, err;
>  
> -	pp_params.order = 0;
> -	/* internal DMA mapping in page_pool */
> -	pp_params.flags = PP_FLAG_DMA_MAP;
> -	pp_params.pool_size = DESC_NUM;
> -	pp_params.nid = NUMA_NO_NODE;
> -	pp_params.dev = priv->dev;
> -	pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
> -
>  	dring->page_pool = page_pool_create(&pp_params);
>  	if (IS_ERR(dring->page_pool)) {
>  		err = PTR_ERR(dring->page_pool);
> -- 
> 2.21.1
> 


Thanks
/Ilias
