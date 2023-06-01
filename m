Return-Path: <netdev+bounces-7050-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBCC87197A1
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:49:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7184D2816ED
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 09:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8990200B3;
	Thu,  1 Jun 2023 09:49:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5DD168A6
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:49:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE495124
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 02:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685612962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2bSBV8Q60GdSQ9cSAx/GWXvbTZ/nLQNHe8IPVOifGAA=;
	b=W0qgd7793UnjKotRFcLnHY8JrUmH9oxnBMnJ2Sg1FkrRSaVrezEJzjssRwkBpDNAxtsG0E
	ioKbT29BqcM5nOTiT2m4ORp6YK4XdPRFmZDuMCGQyCql+A4xOITJ5OsJaVWuxNJHsPoXXC
	caVL4CMSxmLBhexLXqDnaEYPtogjS4Y=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-Cmc64LchNAmC8Ovkcp5PQg-1; Thu, 01 Jun 2023 05:49:20 -0400
X-MC-Unique: Cmc64LchNAmC8Ovkcp5PQg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-75c9b116dddso7249585a.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 02:49:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685612960; x=1688204960;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2bSBV8Q60GdSQ9cSAx/GWXvbTZ/nLQNHe8IPVOifGAA=;
        b=iK5SIfWQH+Q7OSaqpyqYJOWy5kDosO6vR6RS64pMIrMT+GB8fXYKpfWXhLM+/e2vHa
         9wT3+2SPb2TMZj8ioBwChCYRuwQiKfcRtQMCwWdNamLI3KVmhzDO5ci8plmAUqYYVBTf
         v4tggO0e7TaO7lcCRKwS2MFB/tk/9ZARh4Qm6vGv226YcjBMPuKjsG9RR+RsXDbB9kAF
         xcJ6mxMECw2MpfUfnngUwXWr+aFu7Phe3Ks1OFrukK+BTneP/3oLFthK5UkSfbypW7tE
         6ESW9f5QaBDC0mnWosUAMJmGNl8VTBf8KeuvAZdpTN2PpWWKKgCGB3qhK7miuf71aNVI
         UF3g==
X-Gm-Message-State: AC+VfDyf/91AXGvLS+jC8raJQIdVY4KESm8TaShAvSwKjKOwHVn916Dg
	Apo3frwdnjh74o8ZJ+aUjIXQkpOeCl6wYpRz7wc4I9CvYsi3BUfg6r3j3stgXta7AsDW3Gew3yk
	BXWOkhDZ+z7tTtf2p
X-Received: by 2002:a05:620a:17ab:b0:75b:23a1:829f with SMTP id ay43-20020a05620a17ab00b0075b23a1829fmr5373381qkb.0.1685612960367;
        Thu, 01 Jun 2023 02:49:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5yBracybuX3X6v4h6rND3GfM88+X6dv2LFLqr5nImNW+d0uKGReZCHar0BcmPXwrs9IoB7eg==
X-Received: by 2002:a05:620a:17ab:b0:75b:23a1:829f with SMTP id ay43-20020a05620a17ab00b0075b23a1829fmr5373359qkb.0.1685612960126;
        Thu, 01 Jun 2023 02:49:20 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-89.dyn.eolo.it. [146.241.242.89])
        by smtp.gmail.com with ESMTPSA id t15-20020a05620a004f00b0075d22e15f1bsm367441qkt.129.2023.06.01.02.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 02:49:19 -0700 (PDT)
Message-ID: <bd2750e52b47af1782233e254114eb8d627f1073.camel@redhat.com>
Subject: Re: [PATCH net-next v2 08/10] crypto: af_alg: Support
 MSG_SPLICE_PAGES
From: Paolo Abeni <pabeni@redhat.com>
To: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>,  linux-crypto@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 01 Jun 2023 11:49:15 +0200
In-Reply-To: <20230530141635.136968-9-dhowells@redhat.com>
References: <20230530141635.136968-1-dhowells@redhat.com>
	 <20230530141635.136968-9-dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-30 at 15:16 +0100, David Howells wrote:
> Make AF_ALG sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
> spliced from the source iterator.
>=20
> This allows ->sendpage() to be replaced by something that can handle
> multiple multipage folios in a single transaction.
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: linux-crypto@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
>  crypto/af_alg.c         | 28 ++++++++++++++++++++++++++--
>  crypto/algif_aead.c     | 22 +++++++++++-----------
>  crypto/algif_skcipher.c |  8 ++++----
>  3 files changed, 41 insertions(+), 17 deletions(-)
>=20
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index fd56ccff6fed..62f4205d42e3 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -940,6 +940,10 @@ int af_alg_sendmsg(struct socket *sock, struct msghd=
r *msg, size_t size,
>  	bool init =3D false;
>  	int err =3D 0;
> =20
> +	if ((msg->msg_flags & MSG_SPLICE_PAGES) &&
> +	    !iov_iter_is_bvec(&msg->msg_iter))
> +		return -EINVAL;
> +
>  	if (msg->msg_controllen) {
>  		err =3D af_alg_cmsg_send(msg, &con);
>  		if (err)
> @@ -985,7 +989,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr=
 *msg, size_t size,
>  	while (size) {
>  		struct scatterlist *sg;
>  		size_t len =3D size;
> -		size_t plen;
> +		ssize_t plen;
> =20
>  		/* use the existing memory in an allocated page */
>  		if (ctx->merge) {
> @@ -1030,7 +1034,27 @@ int af_alg_sendmsg(struct socket *sock, struct msg=
hdr *msg, size_t size,
>  		if (sgl->cur)
>  			sg_unmark_end(sg + sgl->cur - 1);
> =20
> -		if (1 /* TODO check MSG_SPLICE_PAGES */) {
> +		if (msg->msg_flags & MSG_SPLICE_PAGES) {
> +			struct sg_table sgtable =3D {
> +				.sgl		=3D sg,
> +				.nents		=3D sgl->cur,
> +				.orig_nents	=3D sgl->cur,
> +			};
> +
> +			plen =3D extract_iter_to_sg(&msg->msg_iter, len, &sgtable,
> +						  MAX_SGL_ENTS, 0);

It looks like the above expect/supports only ITER_BVEC iterators, what
about adding a WARN_ON_ONCE(<other iov type>)?

Also, I'm keeping this series a bit more in pw to allow Herbert or
others to have a look.

Cheers,

Paolo


