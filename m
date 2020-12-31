Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2272E813C
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 17:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgLaQ3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 11:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgLaQ3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 11:29:54 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4099C061573;
        Thu, 31 Dec 2020 08:29:13 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id f132so22220234oib.12;
        Thu, 31 Dec 2020 08:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Vn+j/WNjIhIUuxZEWw5e5TKYZNMJfqI1mbpEqq5yOpc=;
        b=Lca1oWR8tl2XHHisLTpXhvuv+Ls10CS/+osfKC33Rx20E6kwWRnyinO44PwVvlhvnc
         V+Qozk4haEM5fRG8i7cEloJsfTFgRipSMEF1/4Rew1KQklmIRZBnOmAcmzb8PaIsoBko
         jemzG1S6Xv5hkShir32jvxcT5hFfgDhOrJK4zhR5xqJRKG1KvE+eNtIgC1knLtgU7teI
         Vh7haWxi14nYWxeawQQ6QwJXmJKpxuJsQWhQHlPM6aI2HOvssYoWCoxf3LdinmcDN6iv
         3E8ca2zDcByYZBW9VhKQvuTuG931EMm6g9PLi2B6CwzPnLEq6o9zsVf48tCSQOHQcCzE
         LxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Vn+j/WNjIhIUuxZEWw5e5TKYZNMJfqI1mbpEqq5yOpc=;
        b=e+pv9q35sDCMLdyF+LABFrXtGLDtqnk6DfMi5LcFusAN1VnKv282TRXvyHaaC/WbZm
         savmmtTdQCH51TFHYRn/YauEJPjiLZ+rBGIrTe8PCvdSR34kU1wUuD850GdestIgOm3V
         zrYERVQ5pDggcKvC+6oLB1Xai7GOdrryDkZFb8X0cJzdZ4y/27TCzoxFQkwTvj23UpwI
         QnVjiNrYTPRRcyC/DHsSVi5yit2wCQ17dEjPwzSCGdBmb+ijMmDbL+vVA2QzD7OnH+NR
         6Ny1FttZxqjgNQlPyfjOWgEa6sYPnbP5URPCRhPWbujbmNfAoRYr4hlcG8h1CBqdo2CD
         GZjg==
X-Gm-Message-State: AOAM530xDZabUNjhC8RBVxj7ldc7uZwrd6dMZN/IdGdDn/4z4lCyKxNp
        ak1c1Yhh7/2l4ObwEcpfFVE=
X-Google-Smtp-Source: ABdhPJwPHc9yRDYcP8A75erYXDsjLxi3zJHLATqhDNoBmgWT6m6ovj1aNE/EuuNF8pSA7GaKBELYmg==
X-Received: by 2002:aca:474b:: with SMTP id u72mr8706432oia.114.1609432153315;
        Thu, 31 Dec 2020 08:29:13 -0800 (PST)
Received: from localhost ([184.21.204.5])
        by smtp.gmail.com with ESMTPSA id c204sm10955890oob.44.2020.12.31.08.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Dec 2020 08:29:12 -0800 (PST)
Date:   Thu, 31 Dec 2020 08:29:04 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, magnus.karlsson@intel.com
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "(open list:XDP SOCKETS \\(AF_XDP\\))" <netdev@vger.kernel.org>,
        bpf@vger.kernel.org (open list:XDP SOCKETS \(AF_XDP\)),
        "(open list:XDP SOCKETS \\(AF_XDP\\) open list)" 
        <linux-kernel@vger.kernel.org>
Message-ID: <5fedfc50493de_4b796208cb@john-XPS-13-9370.notmuch>
In-Reply-To: <9830fcef7159a47bae361fc213c589449f6a77d3.1608713585.git.xuanzhuo@linux.alibaba.com>
References: <9830fcef7159a47bae361fc213c589449f6a77d3.1608713585.git.xuanzhuo@linux.alibaba.com>
Subject: RE: [PATCH bpf-next] xsk: build skb by page
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xuan Zhuo wrote:
> This patch is used to construct skb based on page to save memory copy
> overhead.
> 
> Taking into account the problem of addr unaligned, and the
> possibility of frame size greater than page in the future.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  net/xdp/xsk.c | 68 ++++++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 51 insertions(+), 17 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index ac4a317..7cab40f 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -430,6 +430,55 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>  	sock_wfree(skb);
>  }
>  
> +static struct sk_buff *xsk_build_skb_bypage(struct xdp_sock *xs, struct xdp_desc *desc)
> +{
> +	char *buffer;
> +	u64 addr;
> +	u32 len, offset, copy, copied;
> +	int err, i;
> +	struct page *page;
> +	struct sk_buff *skb;
> +
> +	skb = sock_alloc_send_skb(&xs->sk, 0, 1, &err);

Because this is just grabbing an skb did you consider build_skb?

> +	if (unlikely(!skb))
> +		return NULL;

I think it would be best to push err back to caller here with ERR_PTR().

> +
> +	addr = desc->addr;
> +	len = desc->len;
> +
> +	buffer = xsk_buff_raw_get_data(xs->pool, addr);
> +	offset = offset_in_page(buffer);
> +	addr = buffer - (char *)xs->pool->addrs;
> +
> +	for (copied = 0, i = 0; copied < len; ++i) {
> +		page = xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> +
> +		get_page(page);

Is it obvious why this get_page() is needed? Maybe a small comment would
be nice. Something like, "we need to inc refcnt on page to ensure skb
does not release page from pool".

> +
> +		copy = min((u32)(PAGE_SIZE - offset), len - copied);
> +

nit: take it or leave it, seems like a lot of new lines imo. I would
just put all these together. Not really important though.

> +		skb_fill_page_desc(skb, i, page, offset, copy);
> +
> +		copied += copy;
> +		addr += copy;
> +		offset = 0;
> +	}
> +
> +	skb->len += len;
> +	skb->data_len += len;
> +	skb->truesize += len;
> +
> +	refcount_add(len, &xs->sk.sk_wmem_alloc);
> +
> +	skb->dev = xs->dev;
> +	skb->priority = xs->sk.sk_priority;
> +	skb->mark = xs->sk.sk_mark;
> +	skb_shinfo(skb)->destructor_arg = (void *)(long)addr;
> +	skb->destructor = xsk_destruct_skb;
> +
> +	return skb;
> +}
> +
>  static int xsk_generic_xmit(struct sock *sk)
>  {
>  	struct xdp_sock *xs = xdp_sk(sk);
> @@ -445,40 +494,25 @@ static int xsk_generic_xmit(struct sock *sk)
>  		goto out;
>  
>  	while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
> -		char *buffer;
> -		u64 addr;
> -		u32 len;
> -
>  		if (max_batch-- == 0) {
>  			err = -EAGAIN;
>  			goto out;
>  		}
>  
> -		len = desc.len;
> -		skb = sock_alloc_send_skb(sk, len, 1, &err);
> +		skb = xsk_build_skb_bypage(xs, &desc);
>  		if (unlikely(!skb))

Is err set here? Either way if skb is an ERR_PTR we can use that
here for better error handling.

>  			goto out;
>  
> -		skb_put(skb, len);
> -		addr = desc.addr;
> -		buffer = xsk_buff_raw_get_data(xs->pool, addr);
> -		err = skb_store_bits(skb, 0, buffer, len);
>  		/* This is the backpressure mechanism for the Tx path.
>  		 * Reserve space in the completion queue and only proceed
>  		 * if there is space in it. This avoids having to implement
>  		 * any buffering in the Tx path.
>  		 */
> -		if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
> +		if (xskq_prod_reserve(xs->pool->cq)) {
>  			kfree_skb(skb);

Same here, do we need to set err now that its not explicit above in
err = skb_store_bits...

>  			goto out;
>  		}
>  
> -		skb->dev = xs->dev;
> -		skb->priority = sk->sk_priority;
> -		skb->mark = sk->sk_mark;
> -		skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
> -		skb->destructor = xsk_destruct_skb;
> -
>  		err = __dev_direct_xmit(skb, xs->queue_id);
>  		if  (err == NETDEV_TX_BUSY) {
>  			/* Tell user-space to retry the send */
> -- 
> 1.8.3.1
> 
