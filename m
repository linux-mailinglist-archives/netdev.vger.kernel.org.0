Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D24EF137063
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgAJO4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:56:38 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53261 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728310AbgAJO4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 09:56:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id m24so2313745wmc.3
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 06:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z5xEiIwweisv7uGkMK7SCdhdi2LzwAtdwuz+Dm7/uSM=;
        b=x89hDITqj+0CECIaebqQ+Dxw8J52pCxPKJi2w4JvCTig2J/eNjrdchZow8YGAhZePo
         o1Z8q1e7jIzNtAF9/9XivhBEaAt2Hlmjt/KOgVmrEMKVR7Wy1ntdkGobkb52/8+wMRMN
         HHcsPJaPJoGB5fvubNggj7CvJguVTpNPyT7w/GaeR9XkB7etM3DrBTRaIH69rslKdCKz
         7BCLSh3ocRYjZg+4U8IH0M8Pja7+F9DfszpzrM1ldDHEL/VmvYS9il0mMip1H8DO6K7v
         0nFlXcPF1ybJX0WxxlgmzQ2hn71iRzBQGi+jCGkiaIzqBsOtbS6HXwFWj/mlUlLesufF
         OZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z5xEiIwweisv7uGkMK7SCdhdi2LzwAtdwuz+Dm7/uSM=;
        b=j/M32JlE7ZI0AQF4z9TqjQ5D/wVz3V9MJ3e1ubxwxI9e9q+uLwMaJV2Zcd0/Rbm2cS
         ZojN6Vg4IbEuu4dnsC4h4ug/gau+NWBMRj1ojkHdOnlaihXjTuoEkPIHgHmI+IXPZbdX
         uW2l+wgzISqSpVQm8qhMp0rngWXoB4oHrxfXlJoM4DG46RMHj63rnMjdorZh69eTQtYR
         A9hHYz8Y/DCKG42BGxUhMoqdYDxrasXBzewDw2pih4x3I5AGdiNzYzo7P2Hqx5a7I3x/
         YXlVD+M57fA1A7eQ5d8s56bWjHWYO7zZ6psLwqOKkOLMm9mu7iSHmz9SSPKEMWjkwBVn
         eJ5g==
X-Gm-Message-State: APjAAAVGFo9zmQBpt/Ls2Zbh5d5r08BhCKpdjk/n1d4OlWv3ofuWqoU6
        aAaOek9hpWMsBaVcdS2fKrSzsA==
X-Google-Smtp-Source: APXvYqwMlVA5ec+JKxcZ7q7TEeffu2ZEQi0CtcwGaY/Gfb/yuz8aoRCobi2H6Xhy9+rJim4Xt8NwVg==
X-Received: by 2002:a7b:c3d7:: with SMTP id t23mr5023101wmj.33.1578668195148;
        Fri, 10 Jan 2020 06:56:35 -0800 (PST)
Received: from apalos.home (athedsl-321073.home.otenet.gr. [85.72.109.207])
        by smtp.gmail.com with ESMTPSA id z21sm2422867wml.5.2020.01.10.06.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 06:56:34 -0800 (PST)
Date:   Fri, 10 Jan 2020 16:56:31 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, brouer@redhat.com, davem@davemloft.net,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next] net: socionext: get rid of huge dma sync in
 netsec_alloc_rx_data
Message-ID: <20200110145631.GA69461@apalos.home>
References: <81eeb4aaf1cbbbdcd4f58c5a7f06bdab67f20633.1578664483.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81eeb4aaf1cbbbdcd4f58c5a7f06bdab67f20633.1578664483.git.lorenzo@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 02:57:44PM +0100, Lorenzo Bianconi wrote:
> Socionext driver can run on dma coherent and non-coherent devices.
> Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_data since
> now the driver can let page_pool API to managed needed DMA sync
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - rely on original frame size for dma sync
> ---
>  drivers/net/ethernet/socionext/netsec.c | 43 +++++++++++++++----------
>  1 file changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index b5a9e947a4a8..45c76b437457 100644
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
> @@ -883,6 +881,8 @@ static u32 netsec_xdp_xmit_back(struct netsec_priv *priv, struct xdp_buff *xdp)
>  static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
>  			  struct xdp_buff *xdp)
>  {
> +	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> +	unsigned int len = xdp->data_end - xdp->data;

We need to account for XDP expanding the headers as well here. 
So something like max(xdp->data_end(before bpf), xdp->data_end(after bpf)) -
xdp->data (original)

>  	u32 ret = NETSEC_XDP_PASS;
>  	int err;
>  	u32 act;
> @@ -896,7 +896,9 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
>  	case XDP_TX:
>  		ret = netsec_xdp_xmit_back(priv, xdp);
>  		if (ret != NETSEC_XDP_TX)
> -			xdp_return_buff(xdp);
> +			__page_pool_put_page(dring->page_pool,
> +				     virt_to_head_page(xdp->data),
> +				     len, true);
>  		break;
>  	case XDP_REDIRECT:
>  		err = xdp_do_redirect(priv->ndev, xdp, prog);
> @@ -904,7 +906,9 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
>  			ret = NETSEC_XDP_REDIR;
>  		} else {
>  			ret = NETSEC_XDP_CONSUMED;
> -			xdp_return_buff(xdp);
> +			__page_pool_put_page(dring->page_pool,
> +				     virt_to_head_page(xdp->data),
> +				     len, true);
>  		}
>  		break;
>  	default:
> @@ -915,7 +919,9 @@ static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
>  		/* fall through -- handle aborts by dropping packet */
>  	case XDP_DROP:
>  		ret = NETSEC_XDP_CONSUMED;
> -		xdp_return_buff(xdp);
> +		__page_pool_put_page(dring->page_pool,
> +				     virt_to_head_page(xdp->data),
> +				     len, true);
>  		break;
>  	}
>  
> @@ -1014,7 +1020,8 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  			 * cache state. Since we paid the allocation cost if
>  			 * building an skb fails try to put the page into cache
>  			 */
> -			page_pool_recycle_direct(dring->page_pool, page);
> +			__page_pool_put_page(dring->page_pool, page,
> +					     pkt_len, true);

Same here, a bpf prog with XDP_PASS verdict might change lenghts

>  			netif_err(priv, drv, priv->ndev,
>  				  "rx failed to build skb\n");
>  			break;
> @@ -1272,17 +1279,19 @@ static int netsec_setup_rx_dring(struct netsec_priv *priv)
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
