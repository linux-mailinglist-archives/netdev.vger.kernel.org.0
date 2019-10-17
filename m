Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A15DA2FA
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 03:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393616AbfJQBUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 21:20:01 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37381 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389550AbfJQBUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 21:20:01 -0400
Received: by mail-lj1-f193.google.com with SMTP id l21so693689lje.4
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 18:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MXfuj/s0Ms6C6oB4LIMOymvOQsKi/1ZCix7B6aPVOmo=;
        b=CcI0DBsh7XmcjzGdwtBMMntYiyNIXPmO0cpbfJ0TtVRpzf180J0H8IPpnoaQ0qYyWw
         3lutRZK5labDJOojayOBC/UbgpYkOE5qULqw/VWXXyFwR7oOOz75AYyyuRVvj3ZFLLz/
         kRoocA90Lc8Y8MNqOUm8JBI/cR7auXiaG82ZfP865JHLmZ14eEiBX7EnLIk5ZWSKKF0C
         LDS/vCHOLE4qtMN/gw5ObqGiBkXlHOPPMNPgYTJ91FJdVzarMkBZO87pQDKvH9Qyrrs2
         n/QMRwpEz4xb7AQVbal6Pw6Qfxpm70uqa5wpHkmZbjUarC92bB6d4h5CXYAhxZqzQF96
         roDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MXfuj/s0Ms6C6oB4LIMOymvOQsKi/1ZCix7B6aPVOmo=;
        b=KIwh+kj+YNuPMgQDLWbDTmg4czqXbfCZQ2+belku/L5cNQIMtxBGE652+w6aP5jTkv
         +9NeIK59+46F2gOhDmpPeWY8zUjCA2w2XYysZJTwGfsGFd/kf3D0WKf+UeobwLZeuEeX
         ZOmRLK58kchpOWJo87j1CeN5vrB4A+6Rv9iPft3uTG9OL5CuVZO3cIkVXWLoqXVq9vHM
         YqB0l/FnbGVANNofu6Uq0mOtBBMmc61dRrrjtSozlp7ciQ5p+BdV6JpmJylY9Xq7gD+S
         K0MDa8sCUEqyIBAucl7j/UiOHwscbVtNT3VpHlzQ2sJZ8cK5hdzzKVFMLNOad3FIZXyb
         F6vw==
X-Gm-Message-State: APjAAAXM2u0ZL+ELevN5LgqDrC2zKNHe6nr7dSG87GhbEdX+eGRD/rTq
        yjaloELclso/QlHSUtlQ3w+IxA==
X-Google-Smtp-Source: APXvYqyrpCnkSndGL2xziuHzoJZp21IpZM/oSaza62LhlFOo8nETpRAOaqgkKb6DovXLcULcuwcc7A==
X-Received: by 2002:a05:651c:338:: with SMTP id b24mr553496ljp.65.1571275198342;
        Wed, 16 Oct 2019 18:19:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y135sm270654lfa.92.2019.10.16.18.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 18:19:58 -0700 (PDT)
Date:   Wed, 16 Oct 2019 18:19:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v4 net-next 3/7] net: mvneta: rely on build_skb in
 mvneta_rx_swbm poll routine
Message-ID: <20191016181946.16036f4a@cakuba.netronome.com>
In-Reply-To: <b4de987623c4c30620aa8d77e3f918289c5c7fd6.1571258792.git.lorenzo@kernel.org>
References: <cover.1571258792.git.lorenzo@kernel.org>
        <b4de987623c4c30620aa8d77e3f918289c5c7fd6.1571258792.git.lorenzo@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 23:03:08 +0200, Lorenzo Bianconi wrote:
> Refactor mvneta_rx_swbm code introducing mvneta_swbm_rx_frame and
> mvneta_swbm_add_rx_fragment routines. Rely on build_skb in oreder to
> allocate skb since the previous patch introduced buffer recycling using
> the page_pool API.
> This patch fixes even an issue in the original driver where dma buffers
> are accessed before dma sync.
> mvneta driver can run on not cache coherent devices so it is
> necessary to sync DMA buffers before sending them to the device
> in order to avoid memory corruptions. Running perf analysis we can
> see a performance cost associated with this DMA-sync (anyway it is
> already there in the original driver code). In follow up patches we
> will add more logic to reduce DMA-sync as much as possible.
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 201 ++++++++++++++------------
>  1 file changed, 107 insertions(+), 94 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 9e4d828787fd..2f8123224f6e 100644
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
> @@ -1817,6 +1821,7 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
>  			    struct mvneta_rx_queue *rxq,
>  			    gfp_t gfp_mask)
>  {
> +	enum dma_data_direction dma_dir;
>  	dma_addr_t phys_addr;
>  	struct page *page;
>  
> @@ -1826,6 +1831,9 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
>  		return -ENOMEM;
>  
>  	phys_addr = page_pool_get_dma_addr(page) + pp->rx_offset_correction;
> +	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
> +	dma_sync_single_for_device(pp->dev->dev.parent, phys_addr,
> +				   MVNETA_MAX_RX_BUF_SIZE, dma_dir);

This belongs in patch 2.

>  	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
>  
>  	return 0;
> @@ -1942,30 +1950,101 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
>  	return i;
>  }

>  /* Main rx processing when using software buffer management */
>  static int mvneta_rx_swbm(struct napi_struct *napi,
>  			  struct mvneta_port *pp, int budget,
>  			  struct mvneta_rx_queue *rxq)
>  {
> -	struct net_device *dev = pp->dev;
> -	int rx_todo, rx_proc;
> -	int refill = 0;
> -	u32 rcvd_pkts = 0;
> -	u32 rcvd_bytes = 0;
> +	int rcvd_pkts = 0, rcvd_bytes = 0;
> +	int rx_pending, refill, done = 0;
>  
>  	/* Get number of received packets */
> -	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
> -	rx_proc = 0;
> +	rx_pending = mvneta_rxq_busy_desc_num_get(pp, rxq);
>  
>  	/* Fairness NAPI loop */
> -	while ((rcvd_pkts < budget) && (rx_proc < rx_todo)) {
> +	while (done < budget && done < rx_pending) {
>  		struct mvneta_rx_desc *rx_desc = mvneta_rxq_next_desc_get(rxq);
>  		unsigned char *data;
>  		struct page *page;
> -		dma_addr_t phys_addr;
> -		u32 rx_status, index;
> -		int rx_bytes, skb_size, copy_size;
> -		int frag_num, frag_size, frag_offset;
> +		int index;
>  
>  		index = rx_desc - rxq->descs;
>  		page = (struct page *)rxq->buf_virt_addr[index];
> @@ -1973,98 +2052,33 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  		/* Prefetch header */
>  		prefetch(data);
>  
> -		phys_addr = rx_desc->buf_phys_addr;
> -		rx_status = rx_desc->status;
> -		rx_proc++;
>  		rxq->refill_num++;
> +		done++;
> +
> +		if (rx_desc->status & MVNETA_RXD_FIRST_DESC) {
> +			int err;
>  
> -		if (rx_status & MVNETA_RXD_FIRST_DESC) {

If I may nit pick - not removing the rx_status and dev local variables
could make this chunk a little bit more readable - could you experiment
in moving that to a separate patch?

>  			/* Check errors only for FIRST descriptor */
> -			if (rx_status & MVNETA_RXD_ERR_SUMMARY) {
> +			if (rx_desc->status & MVNETA_RXD_ERR_SUMMARY) {
>  				mvneta_rx_error(pp, rx_desc);
> -				dev->stats.rx_errors++;
> +				pp->dev->stats.rx_errors++;
>  				/* leave the descriptor untouched */
>  				continue;
>  			}
> -			rx_bytes = rx_desc->data_size -
> -				   (ETH_FCS_LEN + MVNETA_MH_SIZE);
>  
> -			/* Allocate small skb for each new packet */
> -			skb_size = max(rx_copybreak, rx_header_size);
> -			rxq->skb = netdev_alloc_skb_ip_align(dev, skb_size);
> -			if (unlikely(!rxq->skb)) {
> -				netdev_err(dev,
> -					   "Can't allocate skb on queue %d\n",
> -					   rxq->id);
> -				dev->stats.rx_dropped++;
> -				rxq->skb_alloc_err++;
> +			err = mvneta_swbm_rx_frame(pp, rx_desc, rxq, page);
> +			if (err)
>  				continue;
> -			}
> -			copy_size = min(skb_size, rx_bytes);
> -
> -			/* Copy data from buffer to SKB, skip Marvell header */
> -			memcpy(rxq->skb->data, data + MVNETA_MH_SIZE,
> -			       copy_size);
> -			skb_put(rxq->skb, copy_size);
> -			rxq->left_size = rx_bytes - copy_size;
> -
> -			mvneta_rx_csum(pp, rx_status, rxq->skb);
> -			if (rxq->left_size == 0) {
> -				int size = copy_size + MVNETA_MH_SIZE;
> -
> -				dma_sync_single_range_for_cpu(dev->dev.parent,
> -							      phys_addr, 0,
> -							      size,
> -							      DMA_FROM_DEVICE);
> -
> -				/* leave the descriptor and buffer untouched */
> -			} else {
> -				/* refill descriptor with new buffer later */
> -				rx_desc->buf_phys_addr = 0;
> -
> -				frag_num = 0;
> -				frag_offset = copy_size + MVNETA_MH_SIZE;
> -				frag_size = min(rxq->left_size,
> -						(int)(PAGE_SIZE - frag_offset));
> -				skb_add_rx_frag(rxq->skb, frag_num, page,
> -						frag_offset, frag_size,
> -						PAGE_SIZE);
> -				page_pool_release_page(rxq->page_pool, page);
> -				rxq->left_size -= frag_size;
> -			}
>  		} else {
> -			/* Middle or Last descriptor */
>  			if (unlikely(!rxq->skb)) {
>  				pr_debug("no skb for rx_status 0x%x\n",
> -					 rx_status);
> +					 rx_desc->status);
>  				continue;
>  			}
> -			if (!rxq->left_size) {
> -				/* last descriptor has only FCS */
> -				/* and can be discarded */
> -				dma_sync_single_range_for_cpu(dev->dev.parent,
> -							      phys_addr, 0,
> -							      ETH_FCS_LEN,
> -							      DMA_FROM_DEVICE);
> -				/* leave the descriptor and buffer untouched */
> -			} else {
> -				/* refill descriptor with new buffer later */
> -				rx_desc->buf_phys_addr = 0;
> -
> -				frag_num = skb_shinfo(rxq->skb)->nr_frags;
> -				frag_offset = 0;
> -				frag_size = min(rxq->left_size,
> -						(int)(PAGE_SIZE - frag_offset));
> -				skb_add_rx_frag(rxq->skb, frag_num, page,
> -						frag_offset, frag_size,
> -						PAGE_SIZE);
> -
> -				page_pool_release_page(rxq->page_pool, page);
> -				rxq->left_size -= frag_size;
> -			}
> +			mvneta_swbm_add_rx_fragment(pp, rx_desc, rxq, page);
>  		} /* Middle or Last descriptor */
>  
> -		if (!(rx_status & MVNETA_RXD_LAST_DESC))
> +		if (!(rx_desc->status & MVNETA_RXD_LAST_DESC))
>  			/* no last descriptor this time */
>  			continue;
>  
> @@ -2080,13 +2094,12 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  		rcvd_bytes += rxq->skb->len;
>  
>  		/* Linux processing */
> -		rxq->skb->protocol = eth_type_trans(rxq->skb, dev);
> +		rxq->skb->protocol = eth_type_trans(rxq->skb, pp->dev);
>  
>  		napi_gro_receive(napi, rxq->skb);
>  
>  		/* clean uncomplete skb pointer in queue */
>  		rxq->skb = NULL;
> -		rxq->left_size = 0;
>  	}
>  
>  	mvneta_update_stats(pp, rcvd_pkts, rcvd_bytes, false);
