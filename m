Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14C929FCB5
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 05:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgJ3Ec7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 00:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJ3Ec6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 00:32:58 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA31C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 21:32:58 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y12so5010254wrp.6
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 21:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E5OFe0kLsPAdJweLb3dL7wkiXZddlagYNZUuiyNCSK8=;
        b=BZ+CVyg58mauV4Se48Oman7o68ILmyQUyrB0FNbpg4qIg0FFEa0G3z7n928tgIbtPG
         t1LoKrY33EWfYBtCIdZdgoyzSyLIrH8QcC9HrciIGYh6Pl+ATF+u+tq8jS8JCWuaub6x
         BLaquUhUgMCAcjEqPfxH0KpOCkaRbH0RpPL5GenTAqovG9Ctu2vMAWOCmyBPdFm4lP6O
         DmN6QKZCI49Dp+nnzFIz3yN46CCRk7goNOvG578+/2E9+KZoo+PmqolnaUzDr+dAwSxX
         x9OoNLdda0GGeUrmPlC43IctZjJ8e3tYhDSnTsd5qu3ioIUGOXV7r9x8ucF+FaAtE1zq
         7o8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E5OFe0kLsPAdJweLb3dL7wkiXZddlagYNZUuiyNCSK8=;
        b=p543aWpu0hCp67Tr+UCVZj5JADaVXxdD2qY6K8xt3fN1G5FtB9LGYunS8JGfIdmeTo
         xUS6G+ngn7jOviyi9TF1Opc/EfC+hBsUl2YRQxT7ZOTQpA2FqWwIV/y10lNm77IQS/rV
         cqKpey7ouDTLMeyw0BDWE3izZspfDVAl88y2vMNK7e2hfidnLB1E5ps4/OuTPnpU3tXg
         WtIt+ecJQOvMBvh43YUiMX9ut5s9TLT2tDEFCIPuSTwXxk1cnmd0ixQuxcLDI47aw3H0
         Bhm/SCNGqdgT3obIsyN6ri34G6vD2en6SUnbUVw6Q2FG02lLoO+1iSBYgkWZCv2zqB5N
         c+1w==
X-Gm-Message-State: AOAM533N8N8qeWOZnbpMANkorNFjo4qcRF0tLbWetqJ5m2GV8iknDl3G
        +kDILzijA54cezPBgSolWoqK6A==
X-Google-Smtp-Source: ABdhPJx/qWV2jHBraRZeu2pxbdc4h4ATwa+ki4HCFVSbQF35xKS/qPAP+Pg2rweIwv7bekTP4n6rDg==
X-Received: by 2002:a5d:424e:: with SMTP id s14mr570753wrr.149.1604032376968;
        Thu, 29 Oct 2020 21:32:56 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id q6sm3336559wma.0.2020.10.29.21.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 21:32:56 -0700 (PDT)
Date:   Fri, 30 Oct 2020 06:32:54 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH v2 net-next 1/4] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201030043254.GA100756@apalos.home>
References: <cover.1603998519.git.lorenzo@kernel.org>
 <aaf417930ccfdd57ee3a7339e2fff59b8ad50409.1603998519.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaf417930ccfdd57ee3a7339e2fff59b8ad50409.1603998519.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo, 

On Thu, Oct 29, 2020 at 08:28:44PM +0100, Lorenzo Bianconi wrote:
> XDP bulk APIs introduce a defer/flush mechanism to return
> pages belonging to the same xdp_mem_allocator object
> (identified via the mem.id field) in bulk to optimize
> I-cache and D-cache since xdp_return_frame is usually run
> inside the driver NAPI tx completion loop.
> The bulk queue size is set to 16 to be aligned to how
> XDP_REDIRECT bulking works. The bulk is flushed when
> it is full or when mem.id changes.
> xdp_frame_bulk is usually stored/allocated on the function
> call-stack to avoid locking penalties.
> Current implementation considers only page_pool memory model.
> Convert mvneta driver to xdp_return_frame_bulk APIs.
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c |  5 ++-
>  include/net/xdp.h                     |  9 ++++
>  net/core/xdp.c                        | 61 +++++++++++++++++++++++++++
>  3 files changed, 74 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 54b0bf574c05..43ab8a73900e 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -1834,8 +1834,10 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
>  				 struct netdev_queue *nq, bool napi)
>  {
>  	unsigned int bytes_compl = 0, pkts_compl = 0;
> +	struct xdp_frame_bulk bq;
>  	int i;
>  
> +	bq.xa = NULL;
>  	for (i = 0; i < num; i++) {
>  		struct mvneta_tx_buf *buf = &txq->buf[txq->txq_get_index];
>  		struct mvneta_tx_desc *tx_desc = txq->descs +
> @@ -1857,9 +1859,10 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
>  			if (napi && buf->type == MVNETA_TYPE_XDP_TX)
>  				xdp_return_frame_rx_napi(buf->xdpf);
>  			else
> -				xdp_return_frame(buf->xdpf);
> +				xdp_return_frame_bulk(buf->xdpf, &bq);
>  		}
>  	}
> +	xdp_flush_frame_bulk(&bq);
>  
>  	netdev_tx_completed_queue(nq, pkts_compl, bytes_compl);
>  }

Sorry I completely forgot to mention this on the v1 review.
I think this belongs to a patch of it's own similar to mellanox and mvpp2 
drivers

> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 3814fb631d52..a1f48a73e6df 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -104,6 +104,12 @@ struct xdp_frame {
>  	struct net_device *dev_rx; /* used by cpumap */
>  };
>  
> +#define XDP_BULK_QUEUE_SIZE	16
> +struct xdp_frame_bulk {
> +	int count;
> +	void *xa;
> +	void *q[XDP_BULK_QUEUE_SIZE];
> +};
>  
>  static inline struct skb_shared_info *
>  xdp_get_shared_info_from_frame(struct xdp_frame *frame)
> @@ -194,6 +200,9 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
>  void xdp_return_frame(struct xdp_frame *xdpf);
>  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
>  void xdp_return_buff(struct xdp_buff *xdp);
> +void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq);
> +void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> +			   struct xdp_frame_bulk *bq);
>  
>  /* When sending xdp_frame into the network stack, then there is no
>   * return point callback, which is needed to release e.g. DMA-mapping
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 48aba933a5a8..66ac275a0360 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -380,6 +380,67 @@ void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
>  }
>  EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
>  
> +/* XDP bulk APIs introduce a defer/flush mechanism to return
> + * pages belonging to the same xdp_mem_allocator object
> + * (identified via the mem.id field) in bulk to optimize
> + * I-cache and D-cache.
> + * The bulk queue size is set to 16 to be aligned to how
> + * XDP_REDIRECT bulking works. The bulk is flushed when
> + * it is full or when mem.id changes.
> + * xdp_frame_bulk is usually stored/allocated on the function
> + * call-stack to avoid locking penalties.
> + */
> +void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq)
> +{
> +	struct xdp_mem_allocator *xa = bq->xa;
> +	int i;
> +
> +	if (unlikely(!xa))
> +		return;
> +
> +	for (i = 0; i < bq->count; i++) {
> +		struct page *page = virt_to_head_page(bq->q[i]);
> +
> +		page_pool_put_full_page(xa->page_pool, page, false);
> +	}
> +	bq->count = 0;
> +}
> +EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
> +
> +void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> +			   struct xdp_frame_bulk *bq)
> +{
> +	struct xdp_mem_info *mem = &xdpf->mem;
> +	struct xdp_mem_allocator *xa;
> +
> +	if (mem->type != MEM_TYPE_PAGE_POOL) {
> +		__xdp_return(xdpf->data, &xdpf->mem, false);
> +		return;
> +	}
> +
> +	rcu_read_lock();
> +
> +	xa = bq->xa;
> +	if (unlikely(!xa)) {
> +		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> +		bq->count = 0;
> +		bq->xa = xa;
> +	}
> +
> +	if (bq->count == XDP_BULK_QUEUE_SIZE)
> +		xdp_flush_frame_bulk(bq);
> +
> +	if (mem->id != xa->mem.id) {
> +		xdp_flush_frame_bulk(bq);
> +		bq->xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> +	}
> +
> +	bq->q[bq->count++] = xdpf->data;
> +
> +	rcu_read_unlock();
> +}
> +EXPORT_SYMBOL_GPL(xdp_return_frame_bulk);
> +
>  void xdp_return_buff(struct xdp_buff *xdp)
>  {
>  	__xdp_return(xdp->data, &xdp->rxq->mem, true);
> -- 
> 2.26.2
> 


Cheers
/Ilias
