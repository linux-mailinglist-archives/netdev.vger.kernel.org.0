Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DF33DE6A1
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 08:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhHCGWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 02:22:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhHCGWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 02:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627971744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ofwSG05+cqdqfTm2t3p2kntFxSnEv6QKIgGTnP/SO6c=;
        b=ZYNb9aAj/KMbij709afrRcmEHRsI1obcKvvCVLEOwDV1VlI/i7wVBnx/E1qtxCbEMDDCTa
        ZpbcLCwYtMq7sHQlF6JJCjA5cONq15Cy4SXMA0EcHJizTNaU51wvSXNwIUUPsFns2OFvYl
        5lwcDSmZ0AZ1v/O02MMBdvtn6CobDO0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-7e_l8I2fNX25ICtm3zDXLQ-1; Tue, 03 Aug 2021 02:22:22 -0400
X-MC-Unique: 7e_l8I2fNX25ICtm3zDXLQ-1
Received: by mail-ed1-f69.google.com with SMTP id d6-20020a50f6860000b02903bc068b7717so9988500edn.11
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 23:22:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ofwSG05+cqdqfTm2t3p2kntFxSnEv6QKIgGTnP/SO6c=;
        b=qpVNTapdhRlH+6EtcKrRRovSiCrx0Qud+nXVGpGkZHnfqKNVGtADEbK6QNZIi6z5gq
         cHeOpqgcOFIr6GZ/bAwfduh8vlVXHM5tTls/bvO7dTw9uvxEb4vBQ36yu0ofHePPkStZ
         Kf9LKEXdYgLnFQQVzl9dum7N47Uf2jCBUsz+au8BheIjPN6R8DBKcVpALfD/HnejgcxX
         53/0Q64Ks/H5+Yb4bOuTCVA964oAN1Ny6JcjAZBPVBL0IFxHUy9hbXB1kk+gZPqVUw59
         dgjAQGoFC+/qcuJNT53BBRBdUhWc4s18nA1O5EyIu3siRLKlv9M7EGs9uATTJ02Qu+GP
         kkqQ==
X-Gm-Message-State: AOAM530/6ON06Gkg/SV8m9J5AZMcft2Rgo/5ta34fHRsqgwEIbKxbFXe
        5G/jJIPeSwa5PQv/Rthv3K/b2KFOWhdqBASpfdVLwy3SwW/wNGiKZXlmAPA5ou2Qs9PvAqBREeH
        aR7wivXvRPHbcNjkq
X-Received: by 2002:aa7:dc49:: with SMTP id g9mr20956920edu.301.1627971741745;
        Mon, 02 Aug 2021 23:22:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzXnX/RUQ7BQhbm/QhFHmCb8jPB1tiRSttz+5eM5x5jf0nTsyuseGxjSxftiDCS7p5B/w6Fg==
X-Received: by 2002:aa7:dc49:: with SMTP id g9mr20956906edu.301.1627971741630;
        Mon, 02 Aug 2021 23:22:21 -0700 (PDT)
Received: from redhat.com ([2.55.140.205])
        by smtp.gmail.com with ESMTPSA id ha26sm5662198ejb.87.2021.08.02.23.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 23:22:21 -0700 (PDT)
Date:   Tue, 3 Aug 2021 02:22:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next] virtio-net: realign page_to_skb() after merges
Message-ID: <20210803022140-mutt-send-email-mst@kernel.org>
References: <20210802175729.2042133-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802175729.2042133-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 10:57:29AM -0700, Jakub Kicinski wrote:
> We ended up merging two versions of the same patch set:
> 
> commit 8fb7da9e9907 ("virtio_net: get build_skb() buf by data ptr")
> commit 5c37711d9f27 ("virtio-net: fix for unable to handle page fault for address")
> 
> into net, and
> 
> commit 7bf64460e3b2 ("virtio-net: get build_skb() buf by data ptr")
> commit 6c66c147b9a4 ("virtio-net: fix for unable to handle page fault for address")
> 
> into net-next. Redo the merge from commit 126285651b7f ("Merge
> ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net"), so that
> the most recent code remains.
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

And maybe add

Fixes: 126285651b7f ("Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net")

so automated tools have an easier time finding this fixup.

> ---
>  drivers/net/virtio_net.c | 27 ++++++++-------------------
>  1 file changed, 8 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 56c3f8519093..74482a52f076 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -380,7 +380,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  				   struct page *page, unsigned int offset,
>  				   unsigned int len, unsigned int truesize,
>  				   bool hdr_valid, unsigned int metasize,
> -				   bool whole_page)
> +				   unsigned int headroom)
>  {
>  	struct sk_buff *skb;
>  	struct virtio_net_hdr_mrg_rxbuf *hdr;
> @@ -398,28 +398,16 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	else
>  		hdr_padded_len = sizeof(struct padded_vnet_hdr);
>  
> -	/* If whole_page, there is an offset between the beginning of the
> +	/* If headroom is not 0, there is an offset between the beginning of the
>  	 * data and the allocated space, otherwise the data and the allocated
>  	 * space are aligned.
>  	 *
>  	 * Buffers with headroom use PAGE_SIZE as alloc size, see
>  	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
>  	 */
> -	if (whole_page) {
> -		/* Buffers with whole_page use PAGE_SIZE as alloc size,
> -		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
> -		 */
> -		truesize = PAGE_SIZE;
> -
> -		/* page maybe head page, so we should get the buf by p, not the
> -		 * page
> -		 */
> -		tailroom = truesize - len - offset_in_page(p);
> -		buf = (char *)((unsigned long)p & PAGE_MASK);
> -	} else {
> -		tailroom = truesize - len;
> -		buf = p;
> -	}
> +	truesize = headroom ? PAGE_SIZE : truesize;
> +	tailroom = truesize - len - headroom;
> +	buf = p - headroom;
>  
>  	len -= hdr_len;
>  	offset += hdr_padded_len;
> @@ -978,7 +966,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  				put_page(page);
>  				head_skb = page_to_skb(vi, rq, xdp_page, offset,
>  						       len, PAGE_SIZE, false,
> -						       metasize, true);
> +						       metasize,
> +						       VIRTIO_XDP_HEADROOM);
>  				return head_skb;
>  			}
>  			break;
> @@ -1029,7 +1018,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  	rcu_read_unlock();
>  
>  	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
> -			       metasize, !!headroom);
> +			       metasize, headroom);
>  	curr_skb = head_skb;
>  
>  	if (unlikely(!curr_skb))
> -- 
> 2.31.1

