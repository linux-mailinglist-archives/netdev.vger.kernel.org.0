Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454226D38AC
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjDBPK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjDBPKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:10:53 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94028B74C;
        Sun,  2 Apr 2023 08:10:51 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id ev7so555579qvb.5;
        Sun, 02 Apr 2023 08:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680448250; x=1683040250;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BHC0GFWUwq2JnOuNQ5ZOk+vWFfVa0/7RcD29gvIoxDw=;
        b=FQEaAngQkHhMdTI5rcyg59rY9t+Y0cgwgpzLxRnxlucn8XpzfIujXvSwBsZE6DGCm1
         yDqKORXWV2Uam/Ny5+nlFIh9C3Y3lO5s/2qj8FwczyUcuOq0rVoAxdOd8coHaOnzo8yB
         TzB7ScCNUkMxw9TnrzA6G+MJef4UC12owUWWYryO8qXn99UfDOItwuXV/zuVmNzTRWLX
         w+VLlhuzJzhdwSGTbCZPJ/hx3Z6hm5Y1Ep4FixdzcViEetZaiAigjtEUSDzKBe5All1v
         NS/X1uEPKsJT97Q4kg8RDc2iRfB7rIOletDCj7Dvt7a8u/4G73KgkFx5uKwWA26XFAT2
         GKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680448250; x=1683040250;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BHC0GFWUwq2JnOuNQ5ZOk+vWFfVa0/7RcD29gvIoxDw=;
        b=j9era0lXufMtFn8WabtQU3C6nGZNQSgrRXrWFa35GERATqQJnroBJPFaLfQtukwez9
         KaOHnwpzmghAwodbUxgGirw157Sta4XhPZMILk7P0YREN4QyL3XxEIb4hNweYG+eXc2s
         awC/FuzLVQLkoMcENh0gywOVJHjdr1/DlrYk1bE2biTLlJqqlOfSAxKy7XUknEDk0RM1
         J/i5f3tiDWtUR69gKPMv6xSJnaSsuNhhxdfMdSRIAhNoJ9zVF5kiblJobyYypilbPq99
         iMF+hbpJgw1Q3BPMm6Y/BUrqCpve1uOQTTVWC9Q3oF/Xus99vZJBUwDpyttrVZRe1Iv+
         Oshw==
X-Gm-Message-State: AAQBX9dsGcTMKqgkm4xfNkXfnxuu1DerFoU4PexyFALoz90D4bJaUNhf
        OE3VXwt3Opnnfgto0BsucDs=
X-Google-Smtp-Source: AKy350ZX70VyypDcKzgDCIFtwpdv3xFpsjXteqYT0mVokk1I3cZ6ka1KubBvzH5Ch7y19hqmtCyJGQ==
X-Received: by 2002:ad4:5ca2:0:b0:56e:9ef7:e76d with SMTP id q2-20020ad45ca2000000b0056e9ef7e76dmr58249480qvh.1.1680448250672;
        Sun, 02 Apr 2023 08:10:50 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id jy21-20020a0562142b5500b005e35629b7c4sm1098645qvb.3.2023.04.02.08.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 08:10:50 -0700 (PDT)
Date:   Sun, 02 Apr 2023 11:10:49 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Message-ID: <64299af9e8861_2d2a20208e6@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230331160914.1608208-16-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
 <20230331160914.1608208-16-dhowells@redhat.com>
Subject: RE: [PATCH v3 15/55] ip, udp: Support MSG_SPLICE_PAGES
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Howells wrote:
> Make IP/UDP sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
> spliced from the source iterator.
> 
> This allows ->sendpage() to be replaced by something that can handle
> multiple multipage folios in a single transaction.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netdev@vger.kernel.org
> ---
>  net/ipv4/ip_output.c | 102 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 99 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 4e4e308c3230..e2eaba817c1f 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -956,6 +956,79 @@ csum_page(struct page *page, int offset, int copy)
>  	return csum;
>  }
>  
> +/*
> + * Allocate a packet for MSG_SPLICE_PAGES.
> + */
> +static int __ip_splice_alloc(struct sock *sk, struct sk_buff **pskb,
> +			     unsigned int fragheaderlen, unsigned int maxfraglen,
> +			     unsigned int hh_len)
> +{
> +	struct sk_buff *skb_prev = *pskb, *skb;
> +	unsigned int fraggap = skb_prev->len - maxfraglen;
> +	unsigned int alloclen = fragheaderlen + hh_len + fraggap + 15;
> +
> +	skb = sock_wmalloc(sk, alloclen, 1, sk->sk_allocation);
> +	if (unlikely(!skb))
> +		return -ENOBUFS;
> +
> +	/* Fill in the control structures */
> +	skb->ip_summed = CHECKSUM_NONE;
> +	skb->csum = 0;
> +	skb_reserve(skb, hh_len);
> +
> +	/* Find where to start putting bytes. */
> +	skb_put(skb, fragheaderlen + fraggap);
> +	skb_reset_network_header(skb);
> +	skb->transport_header = skb->network_header + fragheaderlen;
> +	if (fraggap) {
> +		skb->csum = skb_copy_and_csum_bits(skb_prev, maxfraglen,
> +						   skb_transport_header(skb),
> +						   fraggap);
> +		skb_prev->csum = csum_sub(skb_prev->csum, skb->csum);
> +		pskb_trim_unique(skb_prev, maxfraglen);
> +	}
> +
> +	/* Put the packet on the pending queue. */
> +	__skb_queue_tail(&sk->sk_write_queue, skb);
> +	*pskb = skb;
> +	return 0;
> +}
> +
> +/*
> + * Add (or copy) data pages for MSG_SPLICE_PAGES.
> + */
> +static int __ip_splice_pages(struct sock *sk, struct sk_buff *skb,
> +			     void *from, int *pcopy)
> +{
> +	struct msghdr *msg = from;
> +	struct page *page = NULL, **pages = &page;
> +	ssize_t copy = *pcopy;
> +	size_t off;
> +	int err;
> +
> +	copy = iov_iter_extract_pages(&msg->msg_iter, &pages, copy, 1, 0, &off);
> +	if (copy <= 0)
> +		return copy ?: -EIO;
> +
> +	err = skb_append_pagefrags(skb, page, off, copy);
> +	if (err < 0) {
> +		iov_iter_revert(&msg->msg_iter, copy);
> +		return err;
> +	}
> +
> +	if (skb->ip_summed == CHECKSUM_NONE) {
> +		__wsum csum;
> +
> +		csum = csum_page(page, off, copy);
> +		skb->csum = csum_block_add(skb->csum, csum, skb->len);
> +	}
> +
> +	skb_len_add(skb, copy);
> +	refcount_add(copy, &sk->sk_wmem_alloc);
> +	*pcopy = copy;
> +	return 0;
> +}

These functions are derived from and replace ip_append_page.
That can be removed once udp_sendpage is converted?

>
>  static int __ip_append_data(struct sock *sk,
>  			    struct flowi4 *fl4,
>  			    struct sk_buff_head *queue,
> @@ -977,7 +1050,7 @@ static int __ip_append_data(struct sock *sk,
>  	int err;
>  	int offset = 0;
>  	bool zc = false;
> -	unsigned int maxfraglen, fragheaderlen, maxnonfragsize;
> +	unsigned int maxfraglen, fragheaderlen, maxnonfragsize, initial_length;
>  	int csummode = CHECKSUM_NONE;
>  	struct rtable *rt = (struct rtable *)cork->dst;
>  	unsigned int wmem_alloc_delta = 0;
> @@ -1017,6 +1090,7 @@ static int __ip_append_data(struct sock *sk,
>  	    (!exthdrlen || (rt->dst.dev->features & NETIF_F_HW_ESP_TX_CSUM)))
>  		csummode = CHECKSUM_PARTIAL;
>  
> +	initial_length = length;
>  	if ((flags & MSG_ZEROCOPY) && length) {
>  		struct msghdr *msg = from;
>  
> @@ -1047,6 +1121,14 @@ static int __ip_append_data(struct sock *sk,
>  				skb_zcopy_set(skb, uarg, &extra_uref);
>  			}
>  		}
> +	} else if ((flags & MSG_SPLICE_PAGES) && length) {
> +		if (inet->hdrincl)
> +			return -EPERM;
> +		if (rt->dst.dev->features & NETIF_F_SG)
> +			/* We need an empty buffer to attach stuff to */
> +			initial_length = transhdrlen;

I still don't entirely understand what initial_length means.

More importantly, transhdrlen can be zero. If not called for UDP
but for RAW. Or if this is a subsequent call to a packet that is
being held with MSG_MORE.

This works fine for existing use-cases, which go to alloc_new_skb.
Not sure how this case would be different. But the comment alludes
that it does.

> +		else
> +			flags &= ~MSG_SPLICE_PAGES;
>  	}
>  
>  	cork->length += length;
> @@ -1074,6 +1156,16 @@ static int __ip_append_data(struct sock *sk,
>  			unsigned int alloclen, alloc_extra;
>  			unsigned int pagedlen;
>  			struct sk_buff *skb_prev;
> +
> +			if (unlikely(flags & MSG_SPLICE_PAGES)) {
> +				err = __ip_splice_alloc(sk, &skb, fragheaderlen,
> +							maxfraglen, hh_len);
> +				if (err < 0)
> +					goto error;
> +				continue;
> +			}
> +			initial_length = length;
> +
>  alloc_new_skb:
>  			skb_prev = skb;
>  			if (skb_prev)
> @@ -1085,7 +1177,7 @@ static int __ip_append_data(struct sock *sk,
>  			 * If remaining data exceeds the mtu,
>  			 * we know we need more fragment(s).
>  			 */
> -			datalen = length + fraggap;
> +			datalen = initial_length + fraggap;
>  			if (datalen > mtu - fragheaderlen)
>  				datalen = maxfraglen - fragheaderlen;
>  			fraglen = datalen + fragheaderlen;
> @@ -1099,7 +1191,7 @@ static int __ip_append_data(struct sock *sk,
>  			 * because we have no idea what fragment will be
>  			 * the last.
>  			 */
> -			if (datalen == length + fraggap)
> +			if (datalen == initial_length + fraggap)
>  				alloc_extra += rt->dst.trailer_len;
>  
>  			if ((flags & MSG_MORE) &&
> @@ -1206,6 +1298,10 @@ static int __ip_append_data(struct sock *sk,
>  				err = -EFAULT;
>  				goto error;
>  			}
> +		} else if (flags & MSG_SPLICE_PAGES) {
> +			err = __ip_splice_pages(sk, skb, from, &copy);
> +			if (err < 0)
> +				goto error;
>  		} else if (!zc) {
>  			int i = skb_shinfo(skb)->nr_frags;
>  
> 


