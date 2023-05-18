Return-Path: <netdev+bounces-3531-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F04D707BFF
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:28:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A39AE1C20FF4
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 08:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0A8AD34;
	Thu, 18 May 2023 08:28:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283863C39
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:28:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904DD10D9
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 01:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684398516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bqtU7SQwnuw72dTPSwE1Q8pNrbFhJ19RSEhkS8/CzT8=;
	b=Zi26+dWqr/BVFXvYl4zhn/Cc23OkX4b3nLrtgEfIxI9B1RyRU0aE/GYwFzXbo9h2aylNv1
	NLT9Cek8mjJNLGnE/6g76SJod5WX4XbQEyNqGtngsX5wq/2KP8XpdDYDRDUURwR9PtdHbq
	GS2Hvbs0EXMNj2u+OIhiYToY/7PsPI8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-YYZxmfTYP5KtP_fyPZCVMw-1; Thu, 18 May 2023 04:28:35 -0400
X-MC-Unique: YYZxmfTYP5KtP_fyPZCVMw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-61b636b5f90so3446676d6.1
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 01:28:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684398515; x=1686990515;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bqtU7SQwnuw72dTPSwE1Q8pNrbFhJ19RSEhkS8/CzT8=;
        b=h9XM4hGbJki7cNHlqL8Rr4Lk3f94KZYpayE/MYnfsFcAtLZNlohJW0l4GPP42zdbyK
         SaZFaQ6TdBJvT0Oi0eif1iEBfRRRPhSAiopCV57hpWvho60z6ukg7o+JffTG38rh7mtv
         ftMoLMdDJ/ceq1tn8QgR/IclCJ9N26KfTKYmEme0COsP8mX6vjFeuJyeXvRMHUkaFku+
         J9mfI+0+ivjeuomzN76z4u+uG4+3blRGGLRMhcXnZGGmnxNnRXgI/qSUL3zW012UB+p9
         cQgTaFp1Ypc83T1uTZ1/yox3dP0V4EeLtJvq7dUfbP6enn0XliMNqCcjZvTmiF6u1jKy
         Fr+Q==
X-Gm-Message-State: AC+VfDzLvkOWiO45F2nDdkJcOJICpeg6qNUHgKtJxBPHLbEJyi8zOWI8
	XpXWHd5fcs1Z0rB58ATbim8ZDhktrZMb58eww5iOQ/UjazDyzISOwv2L7TbKQxUh5lzTcFIoYjf
	oKKlN5EqSwitZuw9s
X-Received: by 2002:a05:6214:21a7:b0:616:73d9:b9d8 with SMTP id t7-20020a05621421a700b0061673d9b9d8mr9887993qvc.3.1684398515049;
        Thu, 18 May 2023 01:28:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4uoh/r8B0Y63q2ufOzk7VFo95ja2zRNQIl1td7uCrceMoGYszLi1mmADmoo/pqk3JFZdLWYQ==
X-Received: by 2002:a05:6214:21a7:b0:616:73d9:b9d8 with SMTP id t7-20020a05621421a700b0061673d9b9d8mr9887975qvc.3.1684398514775;
        Thu, 18 May 2023 01:28:34 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-175.dyn.eolo.it. [146.241.239.175])
        by smtp.gmail.com with ESMTPSA id h5-20020a05620a10a500b0073b878e3f30sm254636qkk.59.2023.05.18.01.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 01:28:34 -0700 (PDT)
Message-ID: <93aba6cc363e94a6efe433b3c77ec1b6b54f2919.camel@redhat.com>
Subject: Re: [PATCH net-next v7 03/16] net: Add a function to splice pages
 into an skbuff for MSG_SPLICE_PAGES
From: Paolo Abeni <pabeni@redhat.com>
To: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, David Ahern <dsahern@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Jeff
 Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>, Chuck
 Lever III <chuck.lever@oracle.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 18 May 2023 10:28:29 +0200
In-Reply-To: <20230515093345.396978-4-dhowells@redhat.com>
References: <20230515093345.396978-1-dhowells@redhat.com>
	 <20230515093345.396978-4-dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-05-15 at 10:33 +0100, David Howells wrote:
> Add a function to handle MSG_SPLICE_PAGES being passed internally to
> sendmsg().  Pages are spliced into the given socket buffer if possible an=
d
> copied in if not (e.g. they're slab pages or have a zero refcount).
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Eric Dumazet <edumazet@google.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: David Ahern <dsahern@kernel.org>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Al Viro <viro@zeniv.linux.org.uk>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netdev@vger.kernel.org
> ---
>=20
> Notes:
>     ver #7)
>      - Export function.
>      - Never copy data, return -EIO if sendpage_ok() returns false.
>=20
>  include/linux/skbuff.h |  3 ++
>  net/core/skbuff.c      | 95 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 98 insertions(+)
>=20
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 4c0ad48e38ca..1c5f0ac6f8c3 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -5097,5 +5097,8 @@ static inline void skb_mark_for_recycle(struct sk_b=
uff *skb)
>  #endif
>  }
> =20
> +ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
> +			     ssize_t maxsize, gfp_t gfp);
> +
>  #endif	/* __KERNEL__ */
>  #endif	/* _LINUX_SKBUFF_H */
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 7f53dcb26ad3..56d629ea2f3d 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -6892,3 +6892,98 @@ nodefer:	__kfree_skb(skb);
>  	if (unlikely(kick) && !cmpxchg(&sd->defer_ipi_scheduled, 0, 1))
>  		smp_call_function_single_async(cpu, &sd->defer_csd);
>  }
> +
> +static void skb_splice_csum_page(struct sk_buff *skb, struct page *page,
> +				 size_t offset, size_t len)
> +{
> +	const char *kaddr;
> +	__wsum csum;
> +
> +	kaddr =3D kmap_local_page(page);
> +	csum =3D csum_partial(kaddr + offset, len, 0);
> +	kunmap_local(kaddr);
> +	skb->csum =3D csum_block_add(skb->csum, csum, skb->len);
> +}
> +
> +/**
> + * skb_splice_from_iter - Splice (or copy) pages to skbuff
> + * @skb: The buffer to add pages to
> + * @iter: Iterator representing the pages to be added
> + * @maxsize: Maximum amount of pages to be added
> + * @gfp: Allocation flags
> + *
> + * This is a common helper function for supporting MSG_SPLICE_PAGES.  It
> + * extracts pages from an iterator and adds them to the socket buffer if
> + * possible, copying them to fragments if not possible (such as if they'=
re slab
> + * pages).
> + *
> + * Returns the amount of data spliced/copied or -EMSGSIZE if there's
> + * insufficient space in the buffer to transfer anything.
> + */
> +ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
> +			     ssize_t maxsize, gfp_t gfp)
> +{
> +	struct page *pages[8], **ppages =3D pages;
> +	unsigned int i;
> +	ssize_t spliced =3D 0, ret =3D 0;
> +	size_t frag_limit =3D READ_ONCE(sysctl_max_skb_frags);

Minor nit: please respect the reverse x-mas tree order (there are a few
other occurrences around)

> +
> +	while (iter->count > 0) {
> +		ssize_t space, nr;
> +		size_t off, len;
> +
> +		ret =3D -EMSGSIZE;
> +		space =3D frag_limit - skb_shinfo(skb)->nr_frags;
> +		if (space < 0)
> +			break;
> +
> +		/* We might be able to coalesce without increasing nr_frags */
> +		nr =3D clamp_t(size_t, space, 1, ARRAY_SIZE(pages));
> +
> +		len =3D iov_iter_extract_pages(iter, &ppages, maxsize, nr, 0, &off);
> +		if (len <=3D 0) {
> +			ret =3D len ?: -EIO;
> +			break;
> +		}
> +
> +		if (space =3D=3D 0 &&
> +		    !skb_can_coalesce(skb, skb_shinfo(skb)->nr_frags,
> +				      pages[0], off)) {
> +			iov_iter_revert(iter, len);
> +			break;
> +		}

It looks like the above condition/checks duplicate what the later
skb_append_pagefrags() will perform below. I guess the above chunk
could be removed?

> +
> +		i =3D 0;
> +		do {
> +			struct page *page =3D pages[i++];
> +			size_t part =3D min_t(size_t, PAGE_SIZE - off, len);
> +
> +			ret =3D -EIO;
> +			if (!sendpage_ok(page))
> +				goto out;

My (limited) understanding is that the current sendpage code assumes
that the caller provides/uses pages suitable for such use. The existing
sendpage_ok() check is in place as way to try to catch possible code
bug - via the WARN_ONCE().

I think the same could be done here?

Thanks!

Paolo

> +
> +			ret =3D skb_append_pagefrags(skb, page, off, part,
> +						   frag_limit);
> +			if (ret < 0) {
> +				iov_iter_revert(iter, len);
> +				goto out;
> +			}
> +
> +			if (skb->ip_summed =3D=3D CHECKSUM_NONE)
> +				skb_splice_csum_page(skb, page, off, part);
> +
> +			off =3D 0;
> +			spliced +=3D part;
> +			maxsize -=3D part;
> +			len -=3D part;
> +		} while (len > 0);
> +
> +		if (maxsize <=3D 0)
> +			break;
> +	}
> +
> +out:
> +	skb_len_add(skb, spliced);
> +	return spliced ?: ret;
> +}
> +EXPORT_SYMBOL(skb_splice_from_iter);
>=20


