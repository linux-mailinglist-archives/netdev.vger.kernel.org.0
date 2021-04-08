Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63822358CD1
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhDHSk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhDHSk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:40:27 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5681AC061760;
        Thu,  8 Apr 2021 11:40:16 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j7so1511483plx.2;
        Thu, 08 Apr 2021 11:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+czUxKMob0q1NuQM/0W/hXG96+CBBE2T8+lqVvX/Kdg=;
        b=UNXS02lIOu7nQkfGca0Clv3eY84A93/TxCN6k8WDIvU1bfwJgTJvCMbGB9peYVnQ6z
         VM2IwhtCTYx4poWPgdjgplKkZPxAyvRL4SW5acs+o77/kzU3mwzAUEIqFM9FYQYckR0q
         v0C7yybhR27xo3AYvXi2ZaftZSu/RztBZ2ulSwLHsbtfFzUNOxA3hnwIoH0ZoWdEJWSY
         Dm8kcOfivcocM8UGQgp/7FliTxlc3DfoxlxhHWbObVUtG0q78fTU9LX9YNC+SeRwTYd1
         bMptPKkbl2kUCp8pQW4SCOs/8E6HmBHPn4Ygn38c3yUII/qyjbJbOwkHFnWuEcV7ab1K
         CDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+czUxKMob0q1NuQM/0W/hXG96+CBBE2T8+lqVvX/Kdg=;
        b=SnW2b6oISe7ISzna4myi+QaKW4ikQHAuXO9m8AMr0KdHWLrJ2RfSXxr1yS3NVS96Pn
         bG4P2D0n8yIISauzb7nSbmSdXqaYLgzvCUeEvhyqOxRn05VvAJnXkcaNKWNTatIVqPBp
         /dwZYPknwU/6xtRktwFTtEZuGQ6MQbbhnxnK3JnHwKhNwbiAuDLxB19DDXX0lGb9Hz41
         lp6357LGeY4OUzh6lE7yfl+OJq3j71frIXOtSMU08XyB2v93m3fh4E9HPPVwrG8HJINA
         o1VbeaQ6PILs1UX/PZUxXa+Xuc3PIFlww3/qQXdvJV9s0WBVvhH73K2kB9YOhh0q5s9T
         96YA==
X-Gm-Message-State: AOAM532d2oSMLGTnwHlPLKn3BmLbEpzf7tf2sahT5Zfq15rUj9xjF3xe
        du9UWAlE0WIqnT4dT39IOGQ=
X-Google-Smtp-Source: ABdhPJzwmJduHOAsbSzv4XfI9AUWbvTaD3Yg04nS07A2BivUOK7IkPmwadDWO0yIKtWikDwjjgF1NA==
X-Received: by 2002:a17:90b:1c0e:: with SMTP id oc14mr9730255pjb.188.1617907215863;
        Thu, 08 Apr 2021 11:40:15 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w134sm175649pfd.173.2021.04.08.11.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 11:40:15 -0700 (PDT)
Date:   Thu, 8 Apr 2021 21:40:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 05/14] net: mvneta: add multi buffer support
 to XDP_TX
Message-ID: <20210408184002.k2om3nrittvh7z45@skbuf>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <9cd3048c42f686bd0f84378b7212d5e9f4a97abd.1617885385.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cd3048c42f686bd0f84378b7212d5e9f4a97abd.1617885385.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 02:50:57PM +0200, Lorenzo Bianconi wrote:
> Introduce the capability to map non-linear xdp buffer running
> mvneta_xdp_submit_frame() for XDP_TX and XDP_REDIRECT
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 94 +++++++++++++++++----------
>  1 file changed, 58 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 94e29cce693a..e95d8df0fcdb 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -1860,8 +1860,8 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
>  			bytes_compl += buf->skb->len;
>  			pkts_compl++;
>  			dev_kfree_skb_any(buf->skb);
> -		} else if (buf->type == MVNETA_TYPE_XDP_TX ||
> -			   buf->type == MVNETA_TYPE_XDP_NDO) {
> +		} else if ((buf->type == MVNETA_TYPE_XDP_TX ||
> +			    buf->type == MVNETA_TYPE_XDP_NDO) && buf->xdpf) {
>  			if (napi && buf->type == MVNETA_TYPE_XDP_TX)
>  				xdp_return_frame_rx_napi(buf->xdpf);
>  			else
> @@ -2057,45 +2057,67 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  
>  static int
>  mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
> -			struct xdp_frame *xdpf, bool dma_map)
> +			struct xdp_frame *xdpf, int *nxmit_byte, bool dma_map)
>  {
> -	struct mvneta_tx_desc *tx_desc;
> -	struct mvneta_tx_buf *buf;
> -	dma_addr_t dma_addr;
> +	struct mvneta_tx_desc *tx_desc = NULL;
> +	struct xdp_shared_info *xdp_sinfo;
> +	struct page *page;
> +	int i, num_frames;
> +
> +	xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
> +	num_frames = xdpf->mb ? xdp_sinfo->nr_frags + 1 : 1;
>  
> -	if (txq->count >= txq->tx_stop_threshold)
> +	if (txq->count + num_frames >= txq->size)
>  		return MVNETA_XDP_DROPPED;
>  
> -	tx_desc = mvneta_txq_next_desc_get(txq);
> +	for (i = 0; i < num_frames; i++) {

I get the feeling this is more like num_bufs than num_frames.

> +		struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
> +		skb_frag_t *frag = i ? &xdp_sinfo->frags[i - 1] : NULL;
> +		int len = i ? xdp_get_frag_size(frag) : xdpf->len;
> +		dma_addr_t dma_addr;
>  
> -	buf = &txq->buf[txq->txq_put_index];
> -	if (dma_map) {
> -		/* ndo_xdp_xmit */
> -		dma_addr = dma_map_single(pp->dev->dev.parent, xdpf->data,
> -					  xdpf->len, DMA_TO_DEVICE);
> -		if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
> -			mvneta_txq_desc_put(txq);
> -			return MVNETA_XDP_DROPPED;
> +		tx_desc = mvneta_txq_next_desc_get(txq);
> +		if (dma_map) {
> +			/* ndo_xdp_xmit */
> +			void *data;
> +
> +			data = frag ? xdp_get_frag_address(frag) : xdpf->data;
> +			dma_addr = dma_map_single(pp->dev->dev.parent, data,
> +						  len, DMA_TO_DEVICE);
> +			if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
> +				for (; i >= 0; i--)
> +					mvneta_txq_desc_put(txq);

Don't you need to unmap the previous buffers too?

> +				return MVNETA_XDP_DROPPED;
> +			}
> +			buf->type = MVNETA_TYPE_XDP_NDO;
> +		} else {
> +			page = frag ? xdp_get_frag_page(frag)
> +				    : virt_to_page(xdpf->data);
> +			dma_addr = page_pool_get_dma_addr(page);
> +			if (frag)
> +				dma_addr += xdp_get_frag_offset(frag);
> +			else
> +				dma_addr += sizeof(*xdpf) + xdpf->headroom;
> +			dma_sync_single_for_device(pp->dev->dev.parent,
> +						   dma_addr, len,
> +						   DMA_BIDIRECTIONAL);
> +			buf->type = MVNETA_TYPE_XDP_TX;
>  		}
> -		buf->type = MVNETA_TYPE_XDP_NDO;
> -	} else {
> -		struct page *page = virt_to_page(xdpf->data);
> +		buf->xdpf = i ? NULL : xdpf;
>  
> -		dma_addr = page_pool_get_dma_addr(page) +
> -			   sizeof(*xdpf) + xdpf->headroom;
> -		dma_sync_single_for_device(pp->dev->dev.parent, dma_addr,
> -					   xdpf->len, DMA_BIDIRECTIONAL);
> -		buf->type = MVNETA_TYPE_XDP_TX;
> +		tx_desc->command = !i ? MVNETA_TXD_F_DESC : 0;
> +		tx_desc->buf_phys_addr = dma_addr;
> +		tx_desc->data_size = len;
> +		*nxmit_byte += len;
> +
> +		mvneta_txq_inc_put(txq);
>  	}
> -	buf->xdpf = xdpf;
>  
> -	tx_desc->command = MVNETA_TXD_FLZ_DESC;
> -	tx_desc->buf_phys_addr = dma_addr;
> -	tx_desc->data_size = xdpf->len;
> +	/*last descriptor */
> +	tx_desc->command |= MVNETA_TXD_L_DESC | MVNETA_TXD_Z_PAD;
>  
> -	mvneta_txq_inc_put(txq);
> -	txq->pending++;
> -	txq->count++;
> +	txq->pending += num_frames;
> +	txq->count += num_frames;
>  
>  	return MVNETA_XDP_TX;
>  }
> @@ -2106,8 +2128,8 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
>  	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
>  	struct mvneta_tx_queue *txq;
>  	struct netdev_queue *nq;
> +	int cpu, nxmit_byte = 0;
>  	struct xdp_frame *xdpf;
> -	int cpu;
>  	u32 ret;
>  
>  	xdpf = xdp_convert_buff_to_frame(xdp);
> @@ -2119,10 +2141,10 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
>  	nq = netdev_get_tx_queue(pp->dev, txq->id);
>  
>  	__netif_tx_lock(nq, cpu);
> -	ret = mvneta_xdp_submit_frame(pp, txq, xdpf, false);
> +	ret = mvneta_xdp_submit_frame(pp, txq, xdpf, &nxmit_byte, false);
>  	if (ret == MVNETA_XDP_TX) {
>  		u64_stats_update_begin(&stats->syncp);
> -		stats->es.ps.tx_bytes += xdpf->len;
> +		stats->es.ps.tx_bytes += nxmit_byte;
>  		stats->es.ps.tx_packets++;
>  		stats->es.ps.xdp_tx++;
>  		u64_stats_update_end(&stats->syncp);
> @@ -2161,11 +2183,11 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
>  
>  	__netif_tx_lock(nq, cpu);
>  	for (i = 0; i < num_frame; i++) {
> -		ret = mvneta_xdp_submit_frame(pp, txq, frames[i], true);
> +		ret = mvneta_xdp_submit_frame(pp, txq, frames[i], &nxmit_byte,
> +					      true);
>  		if (ret != MVNETA_XDP_TX)
>  			break;
>  
> -		nxmit_byte += frames[i]->len;
>  		nxmit++;
>  	}
>  
> -- 
> 2.30.2
> 
