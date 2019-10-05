Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99441CCCDE
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 23:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfJEVfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 17:35:01 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39975 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJEVfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 17:35:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id b24so8879457wmj.5
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 14:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+e1Y8RxIoVE0ZPHX9amUuhjp7DwnN1krgfl5YE3nta4=;
        b=C/pyWpcySWXUZm8H5NzUkgZ+TcLeAQPUO0Nfw65ESD5Fu2RRXnimgB4/jLQEfhiB2M
         9EXZ0nQPFq9crTmFwAcY1uwObnUMsVMMl9Kypo94ZukZxXSS81LI6EK7WfiaVwsJBpKA
         8gkU2eKlCuef2VZNqLyOCYfL95GX52+grmHr+Tquw6PTGoIGUM/qw/e+XmxKhd/DnSXT
         tipCXN5BHd4GYMpJRPbn66u3FKkMyPIhNgb60f21Vm1HK9KOy4lHDLtH4t0oFV8NkhFy
         TCfecLnz3pNwqOkMFi/oo37YWdwVLUV0nQ1EzBpn9f7zazJztn8dRbBVfsGzWrsxhD7k
         pdrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+e1Y8RxIoVE0ZPHX9amUuhjp7DwnN1krgfl5YE3nta4=;
        b=JOgwYAq45jJ6eZE08xRJ5Dm1aybFQC48MLhWKLNl6bUnYPTguEPqCkqnbdGtj8zA9C
         jIPqp6eIGoa35pOpp0Qel9wD8k9fj25Up7L67CxUAGh17nRtUT+f5wHKGP6nFxqIfvUS
         Ueed3IKOFn7sRTguJ/r9fDzXhc21lIt6JeJkgO3sM1U8KzIhO13nvp0uiEnNFc9CTnUz
         PeIY/+Oh4IUigbq6C16/5AEc+fFwAgTq3BmX72KlQE00vv/S601XtBrILF7w+iXr6a86
         A/ZdYJHuVEbhSxB/iO3dQCpSWIyaqby0Vas8VyaluAC0gBZ94tKXMXPAHimOeuhng9GI
         bsEA==
X-Gm-Message-State: APjAAAVnRRd81jW8VhGeuqw9getpzC5UPNAsgLEEsH3YGvTUW8dW5eLN
        PyU/Vlujfuu3UIvxxTdmLSSAaQ==
X-Google-Smtp-Source: APXvYqytIgAW37d+kBm6+2O+h8dunefnkJ1gf70LarEeS9ZdW7KlNd/Ha7tzGwLnRlh94Ws6YPa58A==
X-Received: by 2002:a1c:80d0:: with SMTP id b199mr6717092wmd.102.1570311297795;
        Sat, 05 Oct 2019 14:34:57 -0700 (PDT)
Received: from PC192.168.49.172 (ppp-94-65-93-45.home.otenet.gr. [94.65.93.45])
        by smtp.gmail.com with ESMTPSA id s12sm13662385wrn.90.2019.10.05.14.34.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 14:34:57 -0700 (PDT)
Date:   Sun, 6 Oct 2019 00:34:52 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, matteo.croce@redhat.com
Subject: Re: [PATCH 2/7] net: mvneta: introduce page pool API for sw buffer
 manager
Message-ID: <20191005213452.GA5019@PC192.168.49.172>
References: <cover.1570307172.git.lorenzo@kernel.org>
 <61f2fd6fc6a84083fe5d35c19f84da60ea373fe6.1570307172.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61f2fd6fc6a84083fe5d35c19f84da60ea373fe6.1570307172.git.lorenzo@kernel.org>
User-Agent: Mutt/1.9.5 (2018-04-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo, 

On Sat, Oct 05, 2019 at 10:44:35PM +0200, Lorenzo Bianconi wrote:
> Use the page_pool api for allocations and DMA handling instead of
> __dev_alloc_page()/dma_map_page() and free_page()/dma_unmap_page().
> Pages are unmapped using page_pool_release_page before packets
> go into the network stack.
> 
> The page_pool API offers buffer recycling capabilities for XDP but
> allocates one page per packet, unless the driver splits and manages
> the allocated page.
> This is a preliminary patch to add XDP support to mvneta driver
> 
> Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/Kconfig  |  1 +
>  drivers/net/ethernet/marvell/mvneta.c | 76 ++++++++++++++++++++-------
>  2 files changed, 58 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
> index fb942167ee54..3d5caea096fb 100644
> --- a/drivers/net/ethernet/marvell/Kconfig
> +++ b/drivers/net/ethernet/marvell/Kconfig
> @@ -61,6 +61,7 @@ config MVNETA
>  	depends on ARCH_MVEBU || COMPILE_TEST
>  	select MVMDIO
>  	select PHYLINK
> +	select PAGE_POOL
>  	---help---
>  	  This driver supports the network interface units in the
>  	  Marvell ARMADA XP, ARMADA 370, ARMADA 38x and
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 128b9fded959..8beae0e1eda7 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -37,6 +37,7 @@
>  #include <net/ip.h>
>  #include <net/ipv6.h>
>  #include <net/tso.h>
> +#include <net/page_pool.h>
>  
>  /* Registers */
>  #define MVNETA_RXQ_CONFIG_REG(q)                (0x1400 + ((q) << 2))
> @@ -603,6 +604,10 @@ struct mvneta_rx_queue {
>  	u32 pkts_coal;
>  	u32 time_coal;
>  
> +	/* page_pool */
> +	struct page_pool *page_pool;
> +	struct xdp_rxq_info xdp_rxq;
> +
>  	/* Virtual address of the RX buffer */
>  	void  **buf_virt_addr;
>  
> @@ -1815,19 +1820,12 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
>  	dma_addr_t phys_addr;
>  	struct page *page;
>  
> -	page = __dev_alloc_page(gfp_mask);
> +	page = page_pool_alloc_pages(rxq->page_pool,
> +				     gfp_mask | __GFP_NOWARN);
>  	if (!page)
>  		return -ENOMEM;

Is the driver syncing the buffer somewhere else? (for_device)
If not you'll have to do this here. 

On a non-cache coherent machine (and i think this one is) you may get dirty
cache lines handed to the device. Those dirty cache lines might get written back
*after* the device has DMA'ed it's data. You need to flush those first to avoid
any data corruption

>  
> -	/* map page for use */
> -	phys_addr = dma_map_page(pp->dev->dev.parent, page, 0, PAGE_SIZE,
> -				 DMA_FROM_DEVICE);
> -	if (unlikely(dma_mapping_error(pp->dev->dev.parent, phys_addr))) {
> -		__free_page(page);
> -		return -ENOMEM;
> -	}
> -
> -	phys_addr += pp->rx_offset_correction;
> +	phys_addr = page_pool_get_dma_addr(page) + pp->rx_offset_correction;
>  	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
>  	return 0;
>  }
> @@ -1894,10 +1892,11 @@ static void mvneta_rxq_drop_pkts(struct mvneta_port *pp,
>  		if (!data || !(rx_desc->buf_phys_addr))
>  			continue;
>  
> -		dma_unmap_page(pp->dev->dev.parent, rx_desc->buf_phys_addr,
> -			       PAGE_SIZE, DMA_FROM_DEVICE);
> -		__free_page(data);
> +		page_pool_put_page(rxq->page_pool, data, false);
>  	}
> +	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
> +		xdp_rxq_info_unreg(&rxq->xdp_rxq);
> +	page_pool_destroy(rxq->page_pool);
>  }
>  
>  static void
> @@ -2029,8 +2028,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  				skb_add_rx_frag(rxq->skb, frag_num, page,
>  						frag_offset, frag_size,
>  						PAGE_SIZE);
> -				dma_unmap_page(dev->dev.parent, phys_addr,
> -					       PAGE_SIZE, DMA_FROM_DEVICE);
> +				page_pool_release_page(rxq->page_pool, page);
>  				rxq->left_size -= frag_size;
>  			}
>  		} else {
> @@ -2060,9 +2058,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  						frag_offset, frag_size,
>  						PAGE_SIZE);
>  
> -				dma_unmap_page(dev->dev.parent, phys_addr,
> -					       PAGE_SIZE, DMA_FROM_DEVICE);
> -
> +				page_pool_release_page(rxq->page_pool, page);
>  				rxq->left_size -= frag_size;
>  			}
>  		} /* Middle or Last descriptor */
> @@ -2829,11 +2825,53 @@ static int mvneta_poll(struct napi_struct *napi, int budget)
>  	return rx_done;
>  }
>  
> +static int mvneta_create_page_pool(struct mvneta_port *pp,
> +				   struct mvneta_rx_queue *rxq, int size)
> +{
> +	struct page_pool_params pp_params = {
> +		.order = 0,
> +		.flags = PP_FLAG_DMA_MAP,
> +		.pool_size = size,
> +		.nid = cpu_to_node(0),
> +		.dev = pp->dev->dev.parent,
> +		.dma_dir = DMA_FROM_DEVICE,
> +	};
> +	int err;
> +
> +	rxq->page_pool = page_pool_create(&pp_params);
> +	if (IS_ERR(rxq->page_pool)) {
> +		err = PTR_ERR(rxq->page_pool);
> +		rxq->page_pool = NULL;
> +		return err;
> +	}
> +
> +	err = xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, 0);
> +	if (err < 0)
> +		goto err_free_pp;
> +
> +	err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
> +					 rxq->page_pool);
> +	if (err)
> +		goto err_unregister_rxq;
> +
> +	return 0;
> +
> +err_unregister_rxq:
> +	xdp_rxq_info_unreg(&rxq->xdp_rxq);
> +err_free_pp:
> +	page_pool_destroy(rxq->page_pool);
> +	return err;
> +}
> +
>  /* Handle rxq fill: allocates rxq skbs; called when initializing a port */
>  static int mvneta_rxq_fill(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  			   int num)
>  {
> -	int i;
> +	int i, err;
> +
> +	err = mvneta_create_page_pool(pp, rxq, num);
> +	if (err < 0)
> +		return err;
>  
>  	for (i = 0; i < num; i++) {
>  		memset(rxq->descs + i, 0, sizeof(struct mvneta_rx_desc));
> -- 
> 2.21.0
> 


Thanks
/Ilias
