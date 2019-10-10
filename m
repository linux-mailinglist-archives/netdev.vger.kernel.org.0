Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B018FD2199
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 09:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732960AbfJJHWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 03:22:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40038 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733043AbfJJHQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 03:16:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id h4so6414297wrv.7
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 00:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J3tuY77IJ1OwVA3iUu6W/Q0wVe7sBTVNPHzXvkReN1c=;
        b=blg47UslAPhN0dpneusznvi20BwNznaEORS945k2b2rWBiC8tvLxrUJeBzUmaM5qXV
         lMyyFGbxXmnXDzPlfZAcE7JIfJ5Iiw29tkDLkJrttt16nDda6Wo1joPP/LIhpWDAEPla
         iwzzLtfEsf1tGjFLjTVZedS2rgTd10qLKdq4PiYyGFdCdDfqIc2uy53rIVr1ZGzPDAUR
         MXuf35VfX/j0r09JC9R9ELpYYigfVyudGSUC6Y6J0zaerav+u82iouOrZeddPOmZLexG
         bsglFkQ1pF1Dt92BQhRBBskOXBsVOtcnTrwG0dm26Ca76PSL+/+nx/UXxoi4lkkCBLX2
         l6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=J3tuY77IJ1OwVA3iUu6W/Q0wVe7sBTVNPHzXvkReN1c=;
        b=MZszD9EdHclOKTPnKV8bpTIOrrq6ZWFDoTUEglROCDJAbjUFOJd/GeG47ORPFxl4PV
         tXN67U7cV8KxiCudvIUOsH+26TJ+WexwLu/iRCilPOjI8arcWIyw2Kkgnd7SGOm3WL1n
         ziLQuWjDYKjWQzc2mlQhW4i/dLwQwNAk8B6T7HeVE2DhsdNr/9eVEFIc9rhDObgh08UF
         lf7nBXU3TJrIu5OL5oESmJzHfN82oq27E+wnmKOvLOqiRlXN/AIzihmv61dy3nXnIxcO
         4O741/ShexAlGtI9Oca3uzt3/TBU3l/Z7ARmBWwNTMZerji6NYFJFc3GVZ8e3Un3gGry
         vf2g==
X-Gm-Message-State: APjAAAWwyY0lmNM0aQztGz5bNIblzvDbpyEkFUDX+MBCtG0b+aLfZTD/
        0CSJJXgFcIY0m4PVG/e9CL2sTA==
X-Google-Smtp-Source: APXvYqxmw0syFs+HFjJfqw3biJwi184cKSQKW0lugzMSL3Qs1H6KCzd27i9cv3I/tGMBrmi/7WaOOw==
X-Received: by 2002:adf:ed03:: with SMTP id a3mr6793421wro.282.1570691815673;
        Thu, 10 Oct 2019 00:16:55 -0700 (PDT)
Received: from apalos.home (ppp-94-65-93-45.home.otenet.gr. [94.65.93.45])
        by smtp.gmail.com with ESMTPSA id r65sm5840226wmr.9.2019.10.10.00.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 00:16:54 -0700 (PDT)
Date:   Thu, 10 Oct 2019 10:16:52 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v2 net-next 3/8] net: mvneta: rely on build_skb in
 mvneta_rx_swbm poll routine
Message-ID: <20191010071652.GA31160@apalos.home>
References: <cover.1570662004.git.lorenzo@kernel.org>
 <e9ad915633d1e7e02d4b9021761d325d4b130101.1570662004.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9ad915633d1e7e02d4b9021761d325d4b130101.1570662004.git.lorenzo@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo, 

On Thu, Oct 10, 2019 at 01:18:33AM +0200, Lorenzo Bianconi wrote:
> Refactor mvneta_rx_swbm code introducing mvneta_swbm_rx_frame and
> mvneta_swbm_add_rx_fragment routines. Rely on build_skb in oreder to
> allocate skb since the previous patch introduced buffer recycling using
> the page_pool API.
> This patch fixes even an issue in the original driver where dma buffers
> are accessed before dma sync
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 198 ++++++++++++++------------
>  1 file changed, 104 insertions(+), 94 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 31cecc1ed848..79a6bac0192b 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -323,6 +323,11 @@
>  	      ETH_HLEN + ETH_FCS_LEN,			     \
>  	      cache_line_size())
>  
> +#define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) + \
> +			 NET_SKB_PAD))
> +#define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
> +#define MVNETA_MAX_RX_BUF_SIZE	(PAGE_SIZE - MVNETA_SKB_PAD)
> +
>  #define IS_TSO_HEADER(txq, addr) \
>  	((addr >= txq->tso_hdrs_phys) && \
>  	 (addr < txq->tso_hdrs_phys + txq->size * TSO_HEADER_SIZE))
> @@ -646,7 +651,6 @@ static int txq_number = 8;
>  static int rxq_def;
>  
>  static int rx_copybreak __read_mostly = 256;
> -static int rx_header_size __read_mostly = 128;
>  
>  /* HW BM need that each port be identify by a unique ID */
>  static int global_port_id;
> +	if (rxq->left_size > MVNETA_MAX_RX_BUF_SIZE) {

[...]

> +		len = MVNETA_MAX_RX_BUF_SIZE;
> +		data_len = len;
> +	} else {
> +		len = rxq->left_size;
> +		data_len = len - ETH_FCS_LEN;
> +	}
> +	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
> +	dma_sync_single_range_for_cpu(dev->dev.parent,
> +				      rx_desc->buf_phys_addr, 0,
> +				      len, dma_dir);
> +	if (data_len > 0) {
> +		/* refill descriptor with new buffer later */
> +		skb_add_rx_frag(rxq->skb,
> +				skb_shinfo(rxq->skb)->nr_frags,
> +				page, NET_SKB_PAD, data_len,
> +				PAGE_SIZE);
> +
> +		page_pool_release_page(rxq->page_pool, page);
> +		rx_desc->buf_phys_addr = 0;

Shouldn't we unmap and set the buf_phys_addr to 0 regardless of the data_len?

> +	}
> +	rxq->left_size -= len;
> +}
> +
>  		mvneta_rxq_buf_size_set(pp, rxq, PAGE_SIZE < SZ_64K ?

[...]

> -					PAGE_SIZE :
> +					MVNETA_MAX_RX_BUF_SIZE :
>  					MVNETA_RX_BUF_SIZE(pp->pkt_size));
>  		mvneta_rxq_bm_disable(pp, rxq);
>  		mvneta_rxq_fill(pp, rxq, rxq->size);
> @@ -4656,7 +4666,7 @@ static int mvneta_probe(struct platform_device *pdev)
>  	SET_NETDEV_DEV(dev, &pdev->dev);
>  
>  	pp->id = global_port_id++;
> -	pp->rx_offset_correction = 0; /* not relevant for SW BM */
> +	pp->rx_offset_correction = NET_SKB_PAD;
>  
>  	/* Obtain access to BM resources if enabled and already initialized */
>  	bm_node = of_parse_phandle(dn, "buffer-manager", 0);
> -- 
> 2.21.0
> 

Regards
/Ilias
