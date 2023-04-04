Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECB36D69AA
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 18:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbjDDQ6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 12:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbjDDQ6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 12:58:33 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AD3B8;
        Tue,  4 Apr 2023 09:58:32 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id k12so5082654qvo.13;
        Tue, 04 Apr 2023 09:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680627511; x=1683219511;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NsG84S7OAbnWjOyHKzhM0ljkFZxh+zI+v+7k2r+dTjw=;
        b=TxXEJvllS1G2uEJdcucUV/OdoTfbbuy6q+sunSzArW/cGw7ffjtYQhh/JEQXfBE9Iw
         jzLJrHSSKfONnL2wYv+Z7hgJ6SpaV3D7wvQycWNxiYwJTk1j5N2jT4BO4Vyvr5SUHDsi
         axTLPG5zQb6VET9TJsWPOcc0Adif+MF7PCFbnQwYXFSAKR5QpoaG55hDjkiBBa78MdhI
         IzBY3xNonCUnkbSF9oMxekuSP1Si12vhSpY9esK5uGyaSdbnZa/v/qog2HE08RDPJPs/
         ofqGgDOz3Rtng8dzyDkvldqST2IO6SPNaYRcu2gkvc+pYHzxpwn1Qz+T2AJ9hkiE6aK7
         BfSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680627511; x=1683219511;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NsG84S7OAbnWjOyHKzhM0ljkFZxh+zI+v+7k2r+dTjw=;
        b=d6Y/7xmTtFwo7tn8tO+vr7oI0dzqOpdejJIyROVbwn5lhbA5u8I1n1qWYh223bfpEv
         hGVjyZJ6AePvpyTSZpr/yawqqPKwhoI6yjJUuTM30fUVwQnomZryOTHxrBlmsa4Jhqv4
         JpTpQPdt22IGrFVkMLtZxshKRcAeE+2ogYxxrR9TrWkhBTMrYJCtPkmC2mM2fA3VZTqT
         sIhBSBc2P+YFEJJN3GnaVB7/w3jEV6Nr6li8RytTg81qMGoSUKNpmtlBvciQRMMD8waG
         x0dSIS+BogQHpgXo6NosLWnpL95ejOQcGDc8vw6Q8k+9J91ud3f81BQU8sSAhKylSi/j
         MehQ==
X-Gm-Message-State: AAQBX9enIIqHdOAVj9VowfSW9LcHgoz4DGnhXxMKKqOnRPoJHy6J5YX7
        MYLBsBhG75PR/zpBPtqFj4U=
X-Google-Smtp-Source: AKy350Ys/ftAGsooASf/PYV9c6Rr7BEpf81yJlJmJfLltppTsxAFgDL6GHHPG2KWeVbU/J+Z+D+KSw==
X-Received: by 2002:a05:6214:20c7:b0:5d8:ed66:309e with SMTP id 7-20020a05621420c700b005d8ed66309emr5366142qve.11.1680627511125;
        Tue, 04 Apr 2023 09:58:31 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id mk23-20020a056214581700b005dd8b9345c6sm3526920qvb.94.2023.04.04.09.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 09:58:26 -0700 (PDT)
Date:   Tue, 04 Apr 2023 12:58:25 -0400
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
Message-ID: <642c5731a7cc5_337e2c208b0@willemb.c.googlers.com.notmuch>
In-Reply-To: <2258798.1680559496@warthog.procyon.org.uk>
References: <642ad8b66acfe_302ae1208e7@willemb.c.googlers.com.notmuch>
 <64299af9e8861_2d2a20208e6@willemb.c.googlers.com.notmuch>
 <20230331160914.1608208-1-dhowells@redhat.com>
 <20230331160914.1608208-16-dhowells@redhat.com>
 <1818504.1680515446@warthog.procyon.org.uk>
 <2258798.1680559496@warthog.procyon.org.uk>
Subject: Re: [PATCH v3 15/55] ip, udp: Support MSG_SPLICE_PAGES
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
> > The code already has to avoid allocation in the MSG_ZEROCOPY case. I
> > added alloc_len and paged_len for that purpose.
> > 
> > Only the transhdrlen will be copied with getfrag due to
> > 
> >     copy = datalen - transhdrlen - fraggap - pagedlen
> > 
> > On next iteration in the loop, when remaining data fits in the skb,
> > there are three cases. The first is skipped due to !NETIF_F_SG. The
> > other two are either copy to page frags or zerocopy page frags.
> > 
> > I think your code should be able to fit in. Maybe easier if it could
> > reuse the existing alloc_new_skb code to copy the transport header, as
> > MSG_ZEROCOPY does, rather than adding a new __ip_splice_alloc branch
> > that short-circuits that. Then __ip_splice_pages also does not need
> > code to copy the initial header. But this is trickier. It's fine to
> > leave as is.
> > 
> > Since your code currently does call continue before executing the rest
> > of that branch, no need to modify any code there? Notably replacing
> > length with initial_length, which itself is initialized to length in
> > all cases expect for MSG_SPLICE_PAGES.
> 
> Okay.  How about the attached?  This seems to work.  Just setting "paged" to
> true seems to do the right thing in __ip_append_data() when allocating /
> setting up the skbuff, and then __ip_splice_pages() is called to add the
> pages.

If this works, much preferred. Looks great to me.

As said, then __ip_splice_pages() probably no longer needs the
preamble to copy initial header bytes.

> David
> ---
> commit 9ac72c83407c8aef4be0c84513ec27bac9cfbcaa
> Author: David Howells <dhowells@redhat.com>
> Date:   Thu Mar 9 14:27:29 2023 +0000
> 
>     ip, udp: Support MSG_SPLICE_PAGES
>     
>     Make IP/UDP sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
>     spliced from the source iterator.
>     
>     This allows ->sendpage() to be replaced by something that can handle
>     multiple multipage folios in a single transaction.
>     
>     Signed-off-by: David Howells <dhowells@redhat.com>
>     cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
>     cc: "David S. Miller" <davem@davemloft.net>
>     cc: Eric Dumazet <edumazet@google.com>
>     cc: Jakub Kicinski <kuba@kernel.org>
>     cc: Paolo Abeni <pabeni@redhat.com>
>     cc: Jens Axboe <axboe@kernel.dk>
>     cc: Matthew Wilcox <willy@infradead.org>
>     cc: netdev@vger.kernel.org
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 6109a86a8a4b..fe2e48874191 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -956,6 +956,41 @@ csum_page(struct page *page, int offset, int copy)
>  	return csum;
>  }
>  
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
> +
>  static int __ip_append_data(struct sock *sk,
>  			    struct flowi4 *fl4,
>  			    struct sk_buff_head *queue,
> @@ -1047,6 +1082,15 @@ static int __ip_append_data(struct sock *sk,
>  				skb_zcopy_set(skb, uarg, &extra_uref);
>  			}
>  		}
> +	} else if ((flags & MSG_SPLICE_PAGES) && length) {
> +		if (inet->hdrincl)
> +			return -EPERM;
> +		if (rt->dst.dev->features & NETIF_F_SG) {
> +			/* We need an empty buffer to attach stuff to */
> +			paged = true;
> +		} else {
> +			flags &= ~MSG_SPLICE_PAGES;
> +		}
>  	}
>  
>  	cork->length += length;
> @@ -1206,6 +1250,10 @@ static int __ip_append_data(struct sock *sk,
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


