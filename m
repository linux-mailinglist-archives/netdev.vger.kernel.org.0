Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFA81C7B5E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgEFUex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:34:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25992 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726815AbgEFUew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588797290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eBt21xotmA87CN5pxI4GbUVBNDAkGIKysoKBsGfMVZY=;
        b=O1v0Tict6AJnFeb0J3P6jUisO8vFUjsW+2KgyBnbxZBdI6ujoz//MPD+HD9w5CBh4emGF/
        sU2iUjQJqapL17b3R0kZ099R384SO2ZWF8IduVeJhkJT8abpJMdxFiF4Vg02fPLpH08vg3
        H9GP75FxuqsptS7tqvFPWEvhMij5KyY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-1pGM3lQQPvW3ygF8fP8Xjw-1; Wed, 06 May 2020 16:34:47 -0400
X-MC-Unique: 1pGM3lQQPvW3ygF8fP8Xjw-1
Received: by mail-wm1-f69.google.com with SMTP id f17so1323007wmm.5
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 13:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eBt21xotmA87CN5pxI4GbUVBNDAkGIKysoKBsGfMVZY=;
        b=JnkHO9GIaGPAlkd8yEvJnInZr0fpOhhkw1yw7rMD4gBLYY+M7QZnpQVMtkZKcJUyJv
         kYNPB8XWrbIfBQrQ+P4VTo3Szl7cRXQSuXeH72H7tN+tt21YEzBPkZqtE71ynxTcZNy0
         dizBg14FvLyQrH/TJbeyH2UQNzu2JwjSwpT1oAmSpoKsWbdHSwoYI9Hmr7lEGMNM/G3I
         wzPxXnMx0WMY4fHEbGzK/GZIXxliu6FCUMSOlduueCC8B1fFaXj6d/dQ93CK+mr7xRFD
         RWFKptl759fembRbK1QcHHat+lsLVp5qbc47hVsnTsUmVd2Go4wfvkj+nfq5d1Tyylde
         28uw==
X-Gm-Message-State: AGi0Pua9belvHLG4KGV7ImvQL5Hy7G9rfyeI04tBjj56d67g8kJ3UmOn
        MJu59TSaqC9ziOxAmSSxV63Th/0H+6gfrtv3nOzFw2fGs82ENoSg8U6tK2NyNC89CUq2x22NgJM
        WQiMDpdQR9O57kqoH
X-Received: by 2002:a5d:560c:: with SMTP id l12mr6959650wrv.309.1588797286689;
        Wed, 06 May 2020 13:34:46 -0700 (PDT)
X-Google-Smtp-Source: APiQypIx0CKuxgcCwEgOdhBxjP3ZoFYeyenRC8sTzIaPLUznlC1000CFpIJSDeH7XJFfRuz+Kerthw==
X-Received: by 2002:a5d:560c:: with SMTP id l12mr6959635wrv.309.1588797286475;
        Wed, 06 May 2020 13:34:46 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id c19sm4564603wrb.89.2020.05.06.13.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 13:34:45 -0700 (PDT)
Date:   Wed, 6 May 2020 16:34:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
Subject: Re: [PATCH net-next v2 21/33] virtio_net: add XDP frame size in two
 code paths
Message-ID: <20200506163414-mutt-send-email-mst@kernel.org>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
 <158824572816.2172139.1358700000273697123.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158824572816.2172139.1358700000273697123.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 01:22:08PM +0200, Jesper Dangaard Brouer wrote:
> The virtio_net driver is running inside the guest-OS. There are two
> XDP receive code-paths in virtio_net, namely receive_small() and
> receive_mergeable(). The receive_big() function does not support XDP.
> 
> In receive_small() the frame size is available in buflen. The buffer
> backing these frames are allocated in add_recvbuf_small() with same
> size, except for the headroom, but tailroom have reserved room for
> skb_shared_info. The headroom is encoded in ctx pointer as a value.
> 
> In receive_mergeable() the frame size is more dynamic. There are two
> basic cases: (1) buffer size is based on a exponentially weighted
> moving average (see DECLARE_EWMA) of packet length. Or (2) in case
> virtnet_get_headroom() have any headroom then buffer size is
> PAGE_SIZE. The ctx pointer is this time used for encoding two values;
> the buffer len "truesize" and headroom. In case (1) if the rx buffer
> size is underestimated, the packet will have been split over more
> buffers (num_buf info in virtio_net_hdr_mrg_rxbuf placed in top of
> buffer area). If that happens the XDP path does a xdp_linearize_page
> operation.
> 
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 11f722460513..1df3676da185 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -689,6 +689,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>  		xdp.data_end = xdp.data + len;
>  		xdp.data_meta = xdp.data;
>  		xdp.rxq = &rq->xdp_rxq;
> +		xdp.frame_sz = buflen;
>  		orig_data = xdp.data;
>  		act = bpf_prog_run_xdp(xdp_prog, &xdp);
>  		stats->xdp_packets++;
> @@ -797,10 +798,11 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  	int offset = buf - page_address(page);
>  	struct sk_buff *head_skb, *curr_skb;
>  	struct bpf_prog *xdp_prog;
> -	unsigned int truesize;
> +	unsigned int truesize = mergeable_ctx_to_truesize(ctx);
>  	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
> -	int err;
>  	unsigned int metasize = 0;
> +	unsigned int frame_sz;
> +	int err;
>  
>  	head_skb = NULL;
>  	stats->bytes += len - vi->hdr_len;
> @@ -821,6 +823,11 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  		if (unlikely(hdr->hdr.gso_type))
>  			goto err_xdp;
>  
> +		/* Buffers with headroom use PAGE_SIZE as alloc size,
> +		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
> +		 */
> +		frame_sz = headroom ? PAGE_SIZE : truesize;
> +
>  		/* This happens when rx buffer size is underestimated
>  		 * or headroom is not enough because of the buffer
>  		 * was refilled before XDP is set. This should only
> @@ -834,6 +841,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  						      page, offset,
>  						      VIRTIO_XDP_HEADROOM,
>  						      &len);
> +			frame_sz = PAGE_SIZE;
> +
>  			if (!xdp_page)
>  				goto err_xdp;
>  			offset = VIRTIO_XDP_HEADROOM;
> @@ -850,6 +859,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  		xdp.data_end = xdp.data + (len - vi->hdr_len);
>  		xdp.data_meta = xdp.data;
>  		xdp.rxq = &rq->xdp_rxq;
> +		xdp.frame_sz = frame_sz;
>  
>  		act = bpf_prog_run_xdp(xdp_prog, &xdp);
>  		stats->xdp_packets++;
> @@ -924,7 +934,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  	}
>  	rcu_read_unlock();
>  
> -	truesize = mergeable_ctx_to_truesize(ctx);
>  	if (unlikely(len > truesize)) {
>  		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
>  			 dev->name, len, (unsigned long)ctx);
> 
> 

