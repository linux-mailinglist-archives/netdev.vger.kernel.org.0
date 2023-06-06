Return-Path: <netdev+bounces-8346-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C33A723C6D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:00:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07D98281559
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5921328C1C;
	Tue,  6 Jun 2023 09:00:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D81E3D8A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:00:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E01E8
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686042007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nE77/PGW00ePiumkpu3hzk+sXBS9GQxpADNCUK4kjrY=;
	b=Zd6h0pO2VbnpXJpd+rsZjDGfrQx/lcqEioNfSBNMENfGDpW1CFyQxJT5kqIhXO6JN/9hpa
	2y3NlTBi/fhi3W+2fIYm+FjLJMZs2xNCGeqxg83f7VwEc9e63BRvxntSZCxSsy9ixNaRyT
	0f56+UfYLnHiLBry8Y1hiMK90NOBveM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-1tI9oq-tOq-_vI2O3Z6dAw-1; Tue, 06 Jun 2023 05:00:06 -0400
X-MC-Unique: 1tI9oq-tOq-_vI2O3Z6dAw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f7e6648625so2817145e9.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 02:00:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686042005; x=1688634005;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nE77/PGW00ePiumkpu3hzk+sXBS9GQxpADNCUK4kjrY=;
        b=BmSFRLiZqhIutfEKWnb4X8hx4livq8syGP2+jbNIV1ESsF/hOBOcZyYr+6OPtThm1P
         KdTrxA+j8xpjKH2rnqjP8TE9bc2CF0CvGCkQbpqOqxE6J4sVlArZjXSuvsZz1l5iW0q/
         NGx59SqR85BPl5DZFtw8SaxUxQdLVu909N+tRro3ObA/37zvdRvvDtFSAWu8V+Z9YHdG
         ZJUQtnbN55oAyuiEQCPsjTIKsoChk0qAV6xRO+SpLjXyK2d03Jbr3m1GzO8wb6HmrYC9
         Cto3UMhbLqhK8T5ViFjlTkT3fVZv2AHJt5AjozRk/a4qF37Gij8GEPHxVGor75bxhM7J
         Z8hg==
X-Gm-Message-State: AC+VfDzXVAQPE9X2NSOM6ns3ca036t2PzNLLxPfRf9TZV+byp7GIgrtA
	ybYmfxW0dYJCySpcivgrkO0gMmdt+9Z0uWfSzq5IfYf5wDxIhB1YXLzB4q4uZlu55XCSLwKOO7X
	B9UGj496YET2xJG/3
X-Received: by 2002:a05:600c:1c26:b0:3f7:3a2f:35ec with SMTP id j38-20020a05600c1c2600b003f73a2f35ecmr2121567wms.2.1686042005099;
        Tue, 06 Jun 2023 02:00:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4nMW2ZxYmp2BjKFt0zgPi8AR01qUkYolCtDK0fOgYD9ytZTIMSa1sHbzT24zAhoWWsDDQWaw==
X-Received: by 2002:a05:600c:1c26:b0:3f7:3a2f:35ec with SMTP id j38-20020a05600c1c2600b003f73a2f35ecmr2121536wms.2.1686042004812;
        Tue, 06 Jun 2023 02:00:04 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-89.dyn.eolo.it. [146.241.114.89])
        by smtp.gmail.com with ESMTPSA id f18-20020a1cc912000000b003f4e3ed98ffsm13282106wmb.35.2023.06.06.02.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 02:00:04 -0700 (PDT)
Message-ID: <9eb5ab9385ba4af322f5bb9e8c9112414ab7027b.camel@redhat.com>
Subject: Re: [PATCH net-next v2 01/10] Drop the netfs_ prefix from
 netfs_extract_iter_to_sg()
From: Paolo Abeni <pabeni@redhat.com>
To: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>,  linux-crypto@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,  Jeff Layton
 <jlayton@kernel.org>, Steve French <sfrench@samba.org>, Shyam Prasad N
 <nspmangalore@gmail.com>,  Rohith Surabattula <rohiths.msft@gmail.com>,
 linux-cachefs@redhat.com, linux-cifs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
Date: Tue, 06 Jun 2023 11:00:02 +0200
In-Reply-To: <20230530141635.136968-2-dhowells@redhat.com>
References: <20230530141635.136968-1-dhowells@redhat.com>
	 <20230530141635.136968-2-dhowells@redhat.com>
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

On Tue, 2023-05-30 at 15:16 +0100, David Howells wrote:
> Rename netfs_extract_iter_to_sg() and its auxiliary functions to drop the
> netfs_ prefix.
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jeff Layton <jlayton@kernel.org>
> cc: Steve French <sfrench@samba.org>
> cc: Shyam Prasad N <nspmangalore@gmail.com>
> cc: Rohith Surabattula <rohiths.msft@gmail.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: linux-crypto@vger.kernel.org
> cc: linux-cachefs@redhat.com
> cc: linux-cifs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
>=20
> Notes:
>     ver #2:
>      - Put the "netfs_" prefix removal first to shorten lines and avoid
>        checkpatch 80-char warnings.
>=20
>  fs/cifs/smb2ops.c     |  4 +--
>  fs/cifs/smbdirect.c   |  2 +-

This patch does not apply anymore to net-next as the cifs contents have
been moved into fs/smb/client.

You need at least to rebase the series on top of commit
38c8a9a52082579090e34c033d439ed2cd1a462d.

Thanks!

Paolo


