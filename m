Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119F42B2618
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgKMU63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbgKMU63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:58:29 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8D8C0617A6
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:58:28 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id u12so4372421wrt.0
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fJQglkTPgrGpeLJvkZcI+xd5rSDqFf8jNChseOdz/6Q=;
        b=g1++PHh1+PsNoErTpeIYT8CBTHdxgKe83UbhxNXZPlZcOazNVDvJFfUlOvIN7q8Ptr
         GinfUf66EriUq9t81dH1XBgY2T/OiZDuuK95Y8rgzthtJYmnNhsZHOmJR4LCkKyg5rBK
         QYXbcqX7P8zGhLOrDxis6Ke/6Y74obaAL+lCyZIukKByqWJPYBV1+aLS7KauNjxgW48a
         nHtB4b1/8ZN3UupdgcyMSRokLi8bYm5+nF/kd08RIgCprxIn4IbBZkCm+x+yIyhZ//t9
         +6HDZk/cTX+C24VAPWxRGHOfJYh7rvxTam2Muga+aBmUEsXZMDMtHcOpnjTveKYBI0Uk
         nTCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fJQglkTPgrGpeLJvkZcI+xd5rSDqFf8jNChseOdz/6Q=;
        b=qUs3a+mx/eP/uBeMDjmBz11Jnfl4AECUvvTm/jHrf3+MabyMZWyXrvZxJrIJorcHfQ
         jctddVqARM3sJMKiSbM4MXPlemfrHaD8/9xTE6ZP4bNEL2ypVn4E+303D1Fyp9yk81cB
         r9fTfNYMyQp3k73KDyHmhlxbCSR8uitCC989Ifra8q0ADwnZepTVdqhD7qhW1k0c2J7q
         rqGmTgSfhMcB1TXRy4AL8mI1j5U5kENdZv9zG+0hvZLufaMKSeiqMJeQk45Ttrg+6Qzo
         MF0GgfDnmx/d8HW4nyJni0COxAhrLmL2nRUVAC/pnyjA4/COi4QrwBTYt2KrwKF8r/LK
         Z1Sw==
X-Gm-Message-State: AOAM532RvRBZa1u5cM/F8lSiV7omfg54kH+7Yuj4W6N8v4CoADGqy29L
        R60ZlJErjBGkSXF9Z/ovxaLT0A==
X-Google-Smtp-Source: ABdhPJwq6Hj0BXgnLkVMvi7Bu7zoMot9neY+TJC8bITGSRVgqefZuGz3L/PgrkbP5Q4mkd92utHAYQ==
X-Received: by 2002:adf:eb07:: with SMTP id s7mr5446549wrn.320.1605301107432;
        Fri, 13 Nov 2020 12:58:27 -0800 (PST)
Received: from apalos.home (ppp-94-64-112-220.home.otenet.gr. [94.64.112.220])
        by smtp.gmail.com with ESMTPSA id h62sm12337578wrh.82.2020.11.13.12.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 12:58:26 -0800 (PST)
Date:   Fri, 13 Nov 2020 22:58:23 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, john.fastabend@gmail.com
Subject: Re: [PATCH v6 net-nex 1/5] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201113205823.GA1267100@apalos.home>
References: <cover.1605267335.git.lorenzo@kernel.org>
 <e190c03eac71b20c8407ae0fc2c399eda7835f49.1605267335.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e190c03eac71b20c8407ae0fc2c399eda7835f49.1605267335.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 12:48:28PM +0100, Lorenzo Bianconi wrote:
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
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h | 17 +++++++++++++-
>  net/core/xdp.c    | 59 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 75 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 3814fb631d52..7d48b2ae217a 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -104,6 +104,18 @@ struct xdp_frame {
>  	struct net_device *dev_rx; /* used by cpumap */
>  };
>  
> +#define XDP_BULK_QUEUE_SIZE	16
> +struct xdp_frame_bulk {
> +	int count;
> +	void *xa;
> +	void *q[XDP_BULK_QUEUE_SIZE];
> +};
> +
> +static __always_inline void xdp_frame_bulk_init(struct xdp_frame_bulk *bq)
> +{
> +	/* bq->count will be zero'ed when bq->xa gets updated */
> +	bq->xa = NULL;
> +}
>  
>  static inline struct skb_shared_info *
>  xdp_get_shared_info_from_frame(struct xdp_frame *frame)
> @@ -194,6 +206,9 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
>  void xdp_return_frame(struct xdp_frame *xdpf);
>  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
>  void xdp_return_buff(struct xdp_buff *xdp);
> +void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq);
> +void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> +			   struct xdp_frame_bulk *bq);
>  
>  /* When sending xdp_frame into the network stack, then there is no
>   * return point callback, which is needed to release e.g. DMA-mapping
> @@ -245,6 +260,6 @@ bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
>  void xdp_attachment_setup(struct xdp_attachment_info *info,
>  			  struct netdev_bpf *bpf);
>  
> -#define DEV_MAP_BULK_SIZE 16
> +#define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
>  
>  #endif /* __LINUX_NET_XDP_H__ */
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 48aba933a5a8..bbaee7fdd44f 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -380,6 +380,65 @@ void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
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
> +	/* bq->xa is not cleared to save lookup, if mem.id same in next bulk */
> +	bq->count = 0;
> +}
> +EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
> +
> +/* Must be called with rcu_read_lock held */
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
> +	if (unlikely(mem->id != xa->mem.id)) {
> +		xdp_flush_frame_bulk(bq);
> +		bq->xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> +	}
> +
> +	bq->q[bq->count++] = xdpf->data;
> +}
> +EXPORT_SYMBOL_GPL(xdp_return_frame_bulk);
> +
>  void xdp_return_buff(struct xdp_buff *xdp)
>  {
>  	__xdp_return(xdp->data, &xdp->rxq->mem, true);
> -- 
> 2.26.2
> 

Could you add the changes in the Documentation as well (which can do in later)

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
