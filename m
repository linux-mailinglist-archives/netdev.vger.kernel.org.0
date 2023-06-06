Return-Path: <netdev+bounces-8518-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A436872471C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:00:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65756280FA0
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603EB1F16C;
	Tue,  6 Jun 2023 15:00:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C78A37B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:00:06 +0000 (UTC)
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCDE1998;
	Tue,  6 Jun 2023 07:59:41 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-543c6a2aa07so1127757a12.0;
        Tue, 06 Jun 2023 07:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686063580; x=1688655580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wqe+EMfTqwgCzibqmrP4x167w3kg6AGKeWhHsuYgmqo=;
        b=c89hhqFN81vIg5IN2rpZKauKAqHYf+KMSB7oh1dAt0i49A3ucUMkyTzxUCrj2WWs+g
         /LU3Xr/oSOgiCs+CzGUU8pWhEpDacm5mxkJpE/5clGHyANc/lNkJmfLq/aJVfdcjT8UL
         eBL06dgnIyAp6shIXHNvUuno3W6Sk3jssjkHEmrtsXS0ehGnvMz9fE+mUbSyT7V/DtJ8
         YEYyGAmkm7jdPB+ETVRV6oGB43zryHGlxwY1MiyEjreIcHwBO4xpm30cOGoi+5sxuVuw
         QGY0ItDFmMr8lVYp12VI5cDd1e62KrSFDl9FQbjPsohnlfnzU1oGnGODof+74Twn0KQQ
         vCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686063580; x=1688655580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wqe+EMfTqwgCzibqmrP4x167w3kg6AGKeWhHsuYgmqo=;
        b=M9kchvmXuRXWO1Gxhd25eSlmsJXMaMrjGVZ+OetUuvuG48I/yum5fa3dNUL5GuIc7d
         IiDZBu2zwMNrcXGE39FjCqvq4+ljf1rTav8g+uid4woRfooEu4aGWuROT4ypKRIbygvB
         yVrrqpT74A+csxzdKl6X0xx1nNj8KWUNVUop/JCnzS/NILJP/SUZG9OqAojnQ+01pRrg
         jxyZvJAouoARrfLkoc4d2EPJ2aAeZpF4pqBqhICKiRz/qNwgtAJGPImgighx6AvHISzI
         jUye4hD4q5iHvVfdl1Jj6hZSrtOE1mYZUD9LuilTPqT0ZzfbByb5OM4XEIZNUmWtoarl
         A8gg==
X-Gm-Message-State: AC+VfDyrHqMrqGKRIgM2qCyzU4+338HeZ9FSiaSaNODBtwiJ7gHa9XoY
	dZxZU+VXZ62f1dJZ2zSM9N2qng/EvGbONO+WStk=
X-Google-Smtp-Source: ACHHUZ7R3wIBiwS3qmIDAIVJhRLmDVW+rENmgn5tSeT1A0bMQm4kGe5M15s7kly86oJcM/F8JJJXG4R4/1qAqmUxppw=
X-Received: by 2002:a05:6a20:3d83:b0:117:a2f3:3c93 with SMTP id
 s3-20020a056a203d8300b00117a2f33c93mr14207pzi.2.1686063579863; Tue, 06 Jun
 2023 07:59:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230524153311.3625329-1-dhowells@redhat.com> <20230524153311.3625329-5-dhowells@redhat.com>
 <a819dd80-54cc-695f-f142-e3d42ce815a7@huawei.com> <f7919c2c9e1cb6218a0b0f55ddaa9a34f7d2b9a7.camel@gmail.com>
 <1841913.1686039913@warthog.procyon.org.uk>
In-Reply-To: <1841913.1686039913@warthog.procyon.org.uk>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Tue, 6 Jun 2023 07:59:02 -0700
Message-ID: <CAKgT0Ud=ZWVnpwqbLqGovjPM2VR_V1-Ak=meveqnG01tGWTTeA@mail.gmail.com>
Subject: Re: [PATCH net-next 04/12] mm: Make the page_frag_cache allocator use
 multipage folios
To: David Howells <dhowells@redhat.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>, netdev@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jeroen de Borst <jeroendb@google.com>, 
	Catherine Sullivan <csully@google.com>, Shailend Chand <shailend@google.com>, Felix Fietkau <nbd@nbd.name>, 
	John Crispin <john@phrozen.org>, Sean Wang <sean.wang@mediatek.com>, 
	Mark Lee <Mark-MC.Lee@mediatek.com>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Keith Busch <kbusch@kernel.org>, 
	Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	linux-nvme@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 1:25=E2=80=AFAM David Howells <dhowells@redhat.com> =
wrote:
>
> Alexander H Duyck <alexander.duyck@gmail.com> wrote:
>
> > Also I have some concerns about going from page to folio as it seems
> > like the folio_alloc setups the transparent hugepage destructor instead
> > of using the compound page destructor. I would think that would slow
> > down most users as it looks like there is a spinlock that is taken in
> > the hugepage destructor that isn't there in the compound page
> > destructor.
>
> Note that this code is going to have to move to folios[*] at some point.
> "Old-style" compound pages are going to go away, I believe.  Matthew Wilc=
ox
> and the mm folks are on a drive towards simplifying memory management,
> formalising chunks larger than a single page - with the ultimate aim of
> reducing the page struct to a single, typed pointer.

I'm not against making the move, but as others have pointed out this
is getting into unrelated things. One of those being the fact that to
transition to using folios we don't need to get rid of the use of the
virtual address. The idea behind using the virtual address here is
that we can avoid a bunch of address translation overhead since we
only need to use the folio if we are going to allocate, retire, or
recycle a page/folio. If we are using an order 3 page that shouldn't
be very often.

> So, take, for example, a folio: As I understand it, this will no longer
> overlay struct page, but rather will become a single, dynamically-allocat=
ed
> struct that covers a pow-of-2 number of pages.  A contiguous subset of pa=
ge
> structs will point at it.
>
> However, rather than using a folio, we could define a "page fragment" mem=
ory
> type.  Rather than having all the flags and fields to be found in struct
> folio, it could have just the set to be found in page_frag_cache.

I don't think we need a new memory type. For the most part the page
fragment code is really more a subset of something like a
__get_free_pages where the requester provides the size, is just given
a virtual address, and we shouldn't need to be allocating a new page
as often as ideally the allocations are 2K or less in size.

Also one thing I would want to avoid is adding complexity to the
freeing path. The general idea with page frags is that they are meant
to be lightweight in terms of freeing as well. So just as they are
similar to __get_free_pages in terms of allocation the freeing is
meant to be similar to free_pages.

> David
>
> [*] It will be possible to have some other type than "folio".  See "struc=
t
> slab" in mm/slab.h for example.  struct slab corresponds to a set of page=
s
> and, in the future, a number of struct pages will point at it.

I want to avoid getting anywhere near the complexity of a slab
allocator. The whole point of this was to keep it simple so that
drivers could use it and get decent performance. When I had
implemented it in the Intel drivers back in the day this approach was
essentially just a reference count/page offset hack that allowed us to
split a page in 2 and use the pages as a sort of mobius strip within
the ring buffer.

