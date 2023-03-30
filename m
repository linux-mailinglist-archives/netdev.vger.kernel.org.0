Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632ED6D0D30
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbjC3RzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjC3RzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:55:23 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56912B776;
        Thu, 30 Mar 2023 10:55:21 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id x8so14630373qvr.9;
        Thu, 30 Mar 2023 10:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680198920; x=1682790920;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bT5Jd1+THvKq1SAoxJ0RmL0CWt0HENziWG2ORFrQswY=;
        b=FGBMPfNmbeDptza2nmg7r5EeE+xiRg1lkhuHyFbUOZmb7lpXSmxMTP6dNlG6TSsttf
         r3OmBG6hlvE5xcGcekTIO1cTscBzD1NDRzIhijEwyCctjiK2nVd0Sc+8T+9O8bxXZT29
         l6L9MfC4LNS+n5QD+97vt94iXbipQcWMBpjxQdtlSXqZxlAE4x3kUJUgvghxTUsmbhPi
         8vyzmPd6IPX9kqp5trftoJFHu3For+PGgz9HeXaP2vFg+jUFKPKsUKKdyaAUFoJo37be
         1y4Xt9Q3cToQeC+U+IfAPZ7MXxZ+BJu1fVivUV85nqkfDP+WgG3iw5EDmwdgSZsA5gYg
         m6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680198920; x=1682790920;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bT5Jd1+THvKq1SAoxJ0RmL0CWt0HENziWG2ORFrQswY=;
        b=Fhxv0T5Zfaf2P0nSUhgVat2AItYxOxWvkInnWsIJIWNWW+M1uWcIru3/6cZtMtFdOZ
         7j3u9WjbiRIxbw1M40kEn7CH2zRERBYGVg2tfw9hZa6vSRIsvCJ8Q4x0/6/AyApDGkA5
         4q4XEGR8bCGbFYJk+1XtSpUSG7YQUzdjTIA8mMglycmhQ+o8HPG6LuQWev96ORtKX2FA
         bZC3GDfN7iXwyFRwI0ZuTh8eTWiB+wfm+6P9Me1+9bIU9lR3kBauazNIsYiPis7POyu6
         F9NEtWhrPt7y/4Kn3wYqruQ7o5i+pcoQm02BuWeNcrH4e46PJrzVTNkf+CbhD46Yfk1Q
         lhwg==
X-Gm-Message-State: AAQBX9eTSpwLAn7YCcA+Cz/BOmnAap6O57y1LqDk3QUJgXiths9VOBk6
        cDYlcix91miLKsYRQNNGxV4=
X-Google-Smtp-Source: AKy350Znw4NVAYfu219upnHEOkf12n8Ur23PQbvyNOTAnH/i6twLTHs+Gkyqmm5G2VB+Nq2FlhgmFg==
X-Received: by 2002:ad4:5962:0:b0:56f:5466:20dc with SMTP id eq2-20020ad45962000000b0056f546620dcmr34875995qvb.4.1680198920379;
        Thu, 30 Mar 2023 10:55:20 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id s184-20020ae9dec1000000b007426e664cdcsm15189qkf.133.2023.03.30.10.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 10:55:20 -0700 (PDT)
Date:   Thu, 30 Mar 2023 13:55:19 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     David Howells <dhowells@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Message-ID: <6425cd07c25dc_21f56920810@willemb.c.googlers.com.notmuch>
In-Reply-To: <854811.1680189069@warthog.procyon.org.uk>
References: <64259aca22046_21883920890@willemb.c.googlers.com.notmuch>
 <20230329141354.516864-1-dhowells@redhat.com>
 <20230329141354.516864-17-dhowells@redhat.com>
 <854811.1680189069@warthog.procyon.org.uk>
Subject: Re: [RFC PATCH v2 16/48] ip, udp: Support MSG_SPLICE_PAGES
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
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> 
> > > +	unsigned int maxfraglen, fragheaderlen, maxnonfragsize, xlength;
> > 
> > Does x here stand for anything?
> 
> Yeah... "bad naming".  How about if I call it initial_length?  I'm trying to
> avoid allocating bufferage for the data.

That's more informative, thanks. Let me not bikeshed this further for now.
 
> > This does add a lot of code to two functions that are already
> > unwieldy. It may be unavoidable, but it if can use helpers, that would
> > be preferable.
> 
> Something like the attached?  (This is on top of patches 16-17, but I would
> need to fold it in)

Yes exactly. I wasn't sure whether the inner loops required access to
too many function scope variables to pull this off. But seems like it
is doable. Great.

> 
> David
> ---
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index b38dbb2f9c3f..019ed9bb6745 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -956,6 +956,96 @@ csum_page(struct page *page, int offset, int copy)
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
> +			     void *from, size_t *pcopy)
> +{
> +	struct msghdr *msg = from;
> +	struct page *page = NULL, **pages = &page;
> +	ssize_t copy = *pcopy;
> +	size_t off;
> +	bool put = false;
> +	int err;
> +
> +	copy = iov_iter_extract_pages(&msg->msg_iter, &pages, copy, 1, 0, &off);
> +	if (copy <= 0)
> +		return copy ?: -EIO;
> +
> +	if (!sendpage_ok(page)) {
> +		const void *p = kmap_local_page(page);
> +		void *q;
> +
> +		q = page_frag_memdup(NULL, p + off, copy,
> +				     sk->sk_allocation, ULONG_MAX);
> +		kunmap_local(p);
> +		if (!q)
> +			return -ENOMEM;
> +		page = virt_to_page(q);
> +		off = offset_in_page(q);
> +		put = true;
> +	}
> +
> +	err = skb_append_pagefrags(skb, page, off, copy);
> +	if (put)
> +		put_page(page);
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
> +
>  static int __ip_append_data(struct sock *sk,
>  			    struct flowi4 *fl4,
>  			    struct sk_buff_head *queue,
> @@ -977,7 +1067,7 @@ static int __ip_append_data(struct sock *sk,
>  	int err;
>  	int offset = 0;
>  	bool zc = false;
> -	unsigned int maxfraglen, fragheaderlen, maxnonfragsize, xlength;
> +	unsigned int maxfraglen, fragheaderlen, maxnonfragsize, initial_length;
>  	int csummode = CHECKSUM_NONE;
>  	struct rtable *rt = (struct rtable *)cork->dst;
>  	unsigned int wmem_alloc_delta = 0;
> @@ -1017,7 +1107,7 @@ static int __ip_append_data(struct sock *sk,
>  	    (!exthdrlen || (rt->dst.dev->features & NETIF_F_HW_ESP_TX_CSUM)))
>  		csummode = CHECKSUM_PARTIAL;
>  
> -	xlength = length;
> +	initial_length = length;
>  	if ((flags & MSG_ZEROCOPY) && length) {
>  		struct msghdr *msg = from;
>  
> @@ -1053,7 +1143,7 @@ static int __ip_append_data(struct sock *sk,
>  			return -EPERM;
>  		if (!(rt->dst.dev->features & NETIF_F_SG))
>  			return -EOPNOTSUPP;
> -		xlength = transhdrlen; /* We need an empty buffer to attach stuff to */
> +		initial_length = transhdrlen; /* We need an empty buffer to attach stuff to */
>  	}
>  
>  	cork->length += length;
> @@ -1083,47 +1173,13 @@ static int __ip_append_data(struct sock *sk,
>  			struct sk_buff *skb_prev;
>  
>  			if (unlikely(flags & MSG_SPLICE_PAGES)) {
> -				skb_prev = skb;
> -				fraggap = skb_prev->len - maxfraglen;
> -
> -				alloclen = fragheaderlen + hh_len + fraggap + 15;
> -				skb = sock_wmalloc(sk, alloclen, 1, sk->sk_allocation);
> -				if (unlikely(!skb)) {
> -					err = -ENOBUFS;
> +				err = __ip_splice_alloc(sk, &skb, fragheaderlen,
> +							maxfraglen, hh_len);
> +				if (err < 0)
>  					goto error;
> -				}
> -
> -				/*
> -				 *	Fill in the control structures
> -				 */
> -				skb->ip_summed = CHECKSUM_NONE;
> -				skb->csum = 0;
> -				skb_reserve(skb, hh_len);
> -
> -				/*
> -				 *	Find where to start putting bytes.
> -				 */
> -				skb_put(skb, fragheaderlen + fraggap);
> -				skb_reset_network_header(skb);
> -				skb->transport_header = (skb->network_header +
> -							 fragheaderlen);
> -				if (fraggap) {
> -					skb->csum = skb_copy_and_csum_bits(
> -						skb_prev, maxfraglen,
> -						skb_transport_header(skb),
> -						fraggap);
> -					skb_prev->csum = csum_sub(skb_prev->csum,
> -								  skb->csum);
> -					pskb_trim_unique(skb_prev, maxfraglen);
> -				}
> -
> -				/*
> -				 * Put the packet on the pending queue.
> -				 */
> -				__skb_queue_tail(&sk->sk_write_queue, skb);
>  				continue;
>  			}
> -			xlength = length;
> +			initial_length = length;
>  
>  alloc_new_skb:
>  			skb_prev = skb;
> @@ -1136,7 +1192,7 @@ static int __ip_append_data(struct sock *sk,
>  			 * If remaining data exceeds the mtu,
>  			 * we know we need more fragment(s).
>  			 */
> -			datalen = xlength + fraggap;
> +			datalen = initial_length + fraggap;
>  			if (datalen > mtu - fragheaderlen)
>  				datalen = maxfraglen - fragheaderlen;
>  			fraglen = datalen + fragheaderlen;
> @@ -1150,7 +1206,7 @@ static int __ip_append_data(struct sock *sk,
>  			 * because we have no idea what fragment will be
>  			 * the last.
>  			 */
> -			if (datalen == xlength + fraggap)
> +			if (datalen == initial_length + fraggap)
>  				alloc_extra += rt->dst.trailer_len;
>  
>  			if ((flags & MSG_MORE) &&
> @@ -1258,48 +1314,9 @@ static int __ip_append_data(struct sock *sk,
>  				goto error;
>  			}
>  		} else if (flags & MSG_SPLICE_PAGES) {
> -			struct msghdr *msg = from;
> -			struct page *page = NULL, **pages = &page;
> -			size_t off;
> -			bool put = false;
> -
> -			copy = iov_iter_extract_pages(&msg->msg_iter, &pages,
> -						      copy, 1, 0, &off);
> -			if (copy <= 0) {
> -				err = copy ?: -EIO;
> -				goto error;
> -			}
> -
> -			if (!sendpage_ok(page)) {
> -				const void *p = kmap_local_page(page);
> -				void *q;
> -
> -				q = page_frag_memdup(NULL, p + off, copy,
> -						     sk->sk_allocation, ULONG_MAX);
> -				kunmap_local(p);
> -				if (!q) {
> -					err = copy ?: -ENOMEM;
> -					goto error;
> -				}
> -				page = virt_to_page(q);
> -				off = offset_in_page(q);
> -				put = true;
> -			}
> -
> -			err = skb_append_pagefrags(skb, page, off, copy);
> -			if (put)
> -				put_page(page);
> +			err = __ip_splice_pages(sk, skb, from, &copy);
>  			if (err < 0)
>  				goto error;
> -
> -			if (skb->ip_summed == CHECKSUM_NONE) {
> -				__wsum csum;
> -				csum = csum_page(page, off, copy);
> -				skb->csum = csum_block_add(skb->csum, csum, skb->len);
> -			}
> -
> -			skb_len_add(skb, copy);
> -			refcount_add(copy, &sk->sk_wmem_alloc);
>  		} else if (!zc) {
>  			int i = skb_shinfo(skb)->nr_frags;
>  


