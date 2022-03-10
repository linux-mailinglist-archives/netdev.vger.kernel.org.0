Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6B64D4594
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 12:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiCJLWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 06:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbiCJLWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 06:22:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77C7C137584
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 03:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646911304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HZdailnkW9O2r+ZKmIcqf99IvkLTvKu0wm0rg9SHjm0=;
        b=F4pDhJHzFGylpyT2z8riIBG1GBlZyYU0MabN3EupQ2uYm1a9yhAfz//RUxYRsKBYyQuWtz
        7wOxDJHHL5nh0WlCKWaCiTVXct4NfQqcqBUQd46835QvJNZBQUdFhEJSd/b5jp5aXOIzPC
        ycOYIarK7f/T0aXaKbAUul1ZhK7JMTU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-kG74PRu9MvSYMvoP39VCEA-1; Thu, 10 Mar 2022 06:21:43 -0500
X-MC-Unique: kG74PRu9MvSYMvoP39VCEA-1
Received: by mail-ed1-f72.google.com with SMTP id cf6-20020a0564020b8600b00415e9b35c81so2914395edb.9
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 03:21:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HZdailnkW9O2r+ZKmIcqf99IvkLTvKu0wm0rg9SHjm0=;
        b=IYg3v0e1GcI/4HOAC9/QIyfFbohhR2zeIKAqsdRJ4pkgNJzZZYHw7XRegiFAU4potu
         /aZjC+2eef+G8jJ5bWPx7PmRcPxloLAGun/KJC2pqjgr7/SGGPy07uaf+Azk/LsLSm3p
         iQz7/deXhum+K4Teyf+dh/DEQD1l/IS4CS0gdI8zFcgJHYD97XEUeERPzY8sY2obcmnf
         LlnIfHAIlXhDrY8D3rGNbfIzSmclkMd9Ufgrt7Hs48f+AwF5pxH1JO6dYV9HdVTfWLnk
         YPw2HACE1R3XyOOE51XLrf66Fyt2HX/Xg//SjD8aevw3R7psBTNlDBg/zZrvgHy/esjt
         Prpg==
X-Gm-Message-State: AOAM532Ssn04oTbgRPApJuqjxA+uEwzPaABncH//YWTS3x9/DZ8MI6s2
        YiTA3dGHYf3zcBlwO7IM5zrCkQPJQGtCZ7bnVWR5AtQ6vGfesHFBwsdIKu2HmtUBKCYaTd4iJ89
        JFFgksGjHcmfS0CPq
X-Received: by 2002:a17:907:7b9e:b0:6db:2b7f:3024 with SMTP id ne30-20020a1709077b9e00b006db2b7f3024mr3730258ejc.29.1646911301780;
        Thu, 10 Mar 2022 03:21:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxnH5ryteuv1UnyKH+BJLjz+4y2I1BVLkd+KubkILRJkOiRfrbANv0lFhBl3qn3Pk69bd5YpQ==
X-Received: by 2002:a17:907:7b9e:b0:6db:2b7f:3024 with SMTP id ne30-20020a1709077b9e00b006db2b7f3024mr3730226ejc.29.1646911301323;
        Thu, 10 Mar 2022 03:21:41 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f15-20020a50e08f000000b004134a121ed2sm1970727edl.82.2022.03.10.03.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 03:21:40 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 94FEE192CCD; Thu, 10 Mar 2022 12:21:39 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, pabeni@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        toshiaki.makita1@gmail.com, andrii@kernel.org
Subject: Re: [PATCH v4 bpf-next 2/3] veth: rework veth_xdp_rcv_skb in order
 to accept non-linear skb
In-Reply-To: <24703dbc3477a4b3aaf908f6226a566d27969f83.1646755129.git.lorenzo@kernel.org>
References: <cover.1646755129.git.lorenzo@kernel.org>
 <24703dbc3477a4b3aaf908f6226a566d27969f83.1646755129.git.lorenzo@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 10 Mar 2022 12:21:39 +0100
Message-ID: <87ee3auk70.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Introduce veth_convert_xdp_buff_from_skb routine in order to
> convert a non-linear skb into a xdp buffer. If the received skb
> is cloned or shared, veth_convert_xdp_buff_from_skb will copy it
> in a new skb composed by order-0 pages for the linear and the
> fragmented area. Moreover veth_convert_xdp_buff_from_skb guarantees
> we have enough headroom for xdp.
> This is a preliminary patch to allow attaching xdp programs with frags
> support on veth devices.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

It's cool that we can do this! A few comments below:

> ---
>  drivers/net/veth.c | 174 ++++++++++++++++++++++++++++++---------------
>  net/core/xdp.c     |   1 +
>  2 files changed, 119 insertions(+), 56 deletions(-)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index b77ce3fdcfe8..47b21b1d2fd9 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -433,21 +433,6 @@ static void veth_set_multicast_list(struct net_device *dev)
>  {
>  }
>  
> -static struct sk_buff *veth_build_skb(void *head, int headroom, int len,
> -				      int buflen)
> -{
> -	struct sk_buff *skb;
> -
> -	skb = build_skb(head, buflen);
> -	if (!skb)
> -		return NULL;
> -
> -	skb_reserve(skb, headroom);
> -	skb_put(skb, len);
> -
> -	return skb;
> -}
> -
>  static int veth_select_rxq(struct net_device *dev)
>  {
>  	return smp_processor_id() % dev->real_num_rx_queues;
> @@ -695,72 +680,143 @@ static void veth_xdp_rcv_bulk_skb(struct veth_rq *rq, void **frames,
>  	}
>  }
>  
> -static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
> -					struct sk_buff *skb,
> -					struct veth_xdp_tx_bq *bq,
> -					struct veth_stats *stats)
> +static void veth_xdp_get(struct xdp_buff *xdp)
>  {
> -	u32 pktlen, headroom, act, metalen, frame_sz;
> -	void *orig_data, *orig_data_end;
> -	struct bpf_prog *xdp_prog;
> -	int mac_len, delta, off;
> -	struct xdp_buff xdp;
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	int i;
>  
> -	skb_prepare_for_gro(skb);
> +	get_page(virt_to_page(xdp->data));
> +	if (likely(!xdp_buff_has_frags(xdp)))
> +		return;
>  
> -	rcu_read_lock();
> -	xdp_prog = rcu_dereference(rq->xdp_prog);
> -	if (unlikely(!xdp_prog)) {
> -		rcu_read_unlock();
> -		goto out;
> -	}
> +	for (i = 0; i < sinfo->nr_frags; i++)
> +		__skb_frag_ref(&sinfo->frags[i]);
> +}
>  
> -	mac_len = skb->data - skb_mac_header(skb);
> -	pktlen = skb->len + mac_len;
> -	headroom = skb_headroom(skb) - mac_len;
> +static int veth_convert_xdp_buff_from_skb(struct veth_rq *rq,
> +					  struct xdp_buff *xdp,
> +					  struct sk_buff **pskb)
> +{

nit: It's not really "converting" and skb into an xdp_buff, since the
xdp_buff lives on the stack; so maybe 'veth_init_xdp_buff_from_skb()'?

> +	struct sk_buff *skb = *pskb;
> +	u32 frame_sz;
>  
>  	if (skb_shared(skb) || skb_head_is_locked(skb) ||
> -	    skb_is_nonlinear(skb) || headroom < XDP_PACKET_HEADROOM) {
> +	    skb_shinfo(skb)->nr_frags) {

So this always clones the skb if it has frags? Is that really needed?

Also, there's a lot of memory allocation and copying going on here; have
you measured the performance?

> +		u32 size, len, max_head_size, off;
>  		struct sk_buff *nskb;
> -		int size, head_off;
> -		void *head, *start;
>  		struct page *page;
> +		int i, head_off;
>  
> -		size = SKB_DATA_ALIGN(VETH_XDP_HEADROOM + pktlen) +
> -		       SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> -		if (size > PAGE_SIZE)
> +		/* We need a private copy of the skb and data buffers since
> +		 * the ebpf program can modify it. We segment the original skb
> +		 * into order-0 pages without linearize it.
> +		 *
> +		 * Make sure we have enough space for linear and paged area
> +		 */
> +		max_head_size = SKB_WITH_OVERHEAD(PAGE_SIZE -
> +						  VETH_XDP_HEADROOM);
> +		if (skb->len > PAGE_SIZE * MAX_SKB_FRAGS + max_head_size)
>  			goto drop;
>  
> +		/* Allocate skb head */
>  		page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
>  		if (!page)
>  			goto drop;
>  
> -		head = page_address(page);
> -		start = head + VETH_XDP_HEADROOM;
> -		if (skb_copy_bits(skb, -mac_len, start, pktlen)) {
> -			page_frag_free(head);
> +		nskb = build_skb(page_address(page), PAGE_SIZE);
> +		if (!nskb) {
> +			put_page(page);
>  			goto drop;
>  		}
>  
> -		nskb = veth_build_skb(head, VETH_XDP_HEADROOM + mac_len,
> -				      skb->len, PAGE_SIZE);
> -		if (!nskb) {
> -			page_frag_free(head);
> +		skb_reserve(nskb, VETH_XDP_HEADROOM);
> +		size = min_t(u32, skb->len, max_head_size);
> +		if (skb_copy_bits(skb, 0, nskb->data, size)) {
> +			consume_skb(nskb);
>  			goto drop;
>  		}
> +		skb_put(nskb, size);
>  
>  		skb_copy_header(nskb, skb);
>  		head_off = skb_headroom(nskb) - skb_headroom(skb);
>  		skb_headers_offset_update(nskb, head_off);
> +
> +		/* Allocate paged area of new skb */
> +		off = size;
> +		len = skb->len - off;
> +
> +		for (i = 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
> +			page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> +			if (!page) {
> +				consume_skb(nskb);
> +				goto drop;
> +			}
> +
> +			size = min_t(u32, len, PAGE_SIZE);
> +			skb_add_rx_frag(nskb, i, page, 0, size, PAGE_SIZE);
> +			if (skb_copy_bits(skb, off, page_address(page),
> +					  size)) {
> +				consume_skb(nskb);
> +				goto drop;
> +			}
> +
> +			len -= size;
> +			off += size;
> +		}
> +
>  		consume_skb(skb);
>  		skb = nskb;
> +	} else if (skb_headroom(skb) < XDP_PACKET_HEADROOM &&
> +		   pskb_expand_head(skb, VETH_XDP_HEADROOM, 0, GFP_ATOMIC)) {
> +		goto drop;
>  	}
>  
>  	/* SKB "head" area always have tailroom for skb_shared_info */
>  	frame_sz = skb_end_pointer(skb) - skb->head;
>  	frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> -	xdp_init_buff(&xdp, frame_sz, &rq->xdp_rxq);
> -	xdp_prepare_buff(&xdp, skb->head, skb->mac_header, pktlen, true);
> +	xdp_init_buff(xdp, frame_sz, &rq->xdp_rxq);
> +	xdp_prepare_buff(xdp, skb->head, skb_headroom(skb),
> +			 skb_headlen(skb), true);
> +
> +	if (skb_is_nonlinear(skb)) {
> +		skb_shinfo(skb)->xdp_frags_size = skb->data_len;
> +		xdp_buff_set_frags_flag(xdp);
> +	} else {
> +		xdp_buff_clear_frags_flag(xdp);
> +	}
> +	*pskb = skb;
> +
> +	return 0;
> +drop:
> +	consume_skb(skb);
> +	*pskb = NULL;
> +
> +	return -ENOMEM;
> +}
> +
> +static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
> +					struct sk_buff *skb,
> +					struct veth_xdp_tx_bq *bq,
> +					struct veth_stats *stats)
> +{
> +	void *orig_data, *orig_data_end;
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
> +	u32 act, metalen;
> +	int off;
> +
> +	skb_prepare_for_gro(skb);
> +
> +	rcu_read_lock();
> +	xdp_prog = rcu_dereference(rq->xdp_prog);
> +	if (unlikely(!xdp_prog)) {
> +		rcu_read_unlock();
> +		goto out;
> +	}
> +
> +	__skb_push(skb, skb->data - skb_mac_header(skb));
> +	if (veth_convert_xdp_buff_from_skb(rq, &xdp, &skb))
> +		goto drop;
>  
>  	orig_data = xdp.data;
>  	orig_data_end = xdp.data_end;
> @@ -771,7 +827,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
>  	case XDP_PASS:
>  		break;
>  	case XDP_TX:
> -		get_page(virt_to_page(xdp.data));
> +		veth_xdp_get(&xdp);
>  		consume_skb(skb);
>  		xdp.rxq->mem = rq->xdp_mem;
>  		if (unlikely(veth_xdp_tx(rq, &xdp, bq) < 0)) {
> @@ -783,7 +839,7 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
>  		rcu_read_unlock();
>  		goto xdp_xmit;
>  	case XDP_REDIRECT:
> -		get_page(virt_to_page(xdp.data));
> +		veth_xdp_get(&xdp);
>  		consume_skb(skb);
>  		xdp.rxq->mem = rq->xdp_mem;
>  		if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
> @@ -806,18 +862,24 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
>  	rcu_read_unlock();
>  
>  	/* check if bpf_xdp_adjust_head was used */
> -	delta = orig_data - xdp.data;
> -	off = mac_len + delta;
> +	off = orig_data - xdp.data;
>  	if (off > 0)
>  		__skb_push(skb, off);
>  	else if (off < 0)
>  		__skb_pull(skb, -off);
> -	skb->mac_header -= delta;
> +
> +	skb_reset_mac_header(skb);
>  
>  	/* check if bpf_xdp_adjust_tail was used */
>  	off = xdp.data_end - orig_data_end;
>  	if (off != 0)
>  		__skb_put(skb, off); /* positive on grow, negative on shrink */
> +
> +	if (xdp_buff_has_frags(&xdp))
> +		skb->data_len = skb_shinfo(skb)->xdp_frags_size;
> +	else
> +		skb->data_len = 0;

We can remove entire frags using xdp_adjust_tail, right? Will that get
propagated in the right way to the skb frags due to the dual use of
skb_shared_info, or?

