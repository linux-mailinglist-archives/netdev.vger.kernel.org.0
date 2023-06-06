Return-Path: <netdev+bounces-8328-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3992D723B77
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A70D51C20DFC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 806B928C2F;
	Tue,  6 Jun 2023 08:25:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C765660
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:25:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FBFE43
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 01:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686039927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tl5oPK3uVnMf7j5Be8wyxIVYpd+Z0ksF6FBEMTvD5A0=;
	b=MAwBma/NoJewOe6gy43cdmJRszhhKW3kFYDYQAONRDW6s0aTdlTe8z/96mwr/i3rMSLUk1
	XUySc+hqHYLo2OHhiRVkb1xvanx2zWMm5YdkRWqzoWtbT+wwbtvEgHOZ20h8iDmj2T7zLF
	lz1UB3SAfQ7btOn0Wh4rj6liKKdYAzQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-WVBBMtVdOw6x8tgl-6tseQ-1; Tue, 06 Jun 2023 04:25:22 -0400
X-MC-Unique: WVBBMtVdOw6x8tgl-6tseQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52E34811E78;
	Tue,  6 Jun 2023 08:25:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 38D27492B00;
	Tue,  6 Jun 2023 08:25:14 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <f7919c2c9e1cb6218a0b0f55ddaa9a34f7d2b9a7.camel@gmail.com>
References: <f7919c2c9e1cb6218a0b0f55ddaa9a34f7d2b9a7.camel@gmail.com> <20230524153311.3625329-1-dhowells@redhat.com> <20230524153311.3625329-5-dhowells@redhat.com> <a819dd80-54cc-695f-f142-e3d42ce815a7@huawei.com>
To: Alexander H Duyck <alexander.duyck@gmail.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>,
    David Howells <dhowells@redhat.com>, netdev@vger.kernel.org,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>,
    Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
    David Ahern <dsahern@kernel.org>,
    Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    linux-mm@kvack.org, linux-kernel@vger.kernel.org,
    Jeroen de Borst <jeroendb@google.com>,
    Catherine Sullivan <csully@google.com>,
    Shailend Chand <shailend@google.com>, Felix Fietkau <nbd@nbd.name>,
    John Crispin <john@phrozen.org>, Sean Wang <sean.wang@mediatek.com>,
    Mark Lee <Mark-MC.Lee@mediatek.com>,
    Lorenzo Bianconi <lorenzo@kernel.org>,
    Matthias Brugger <matthias.bgg@gmail.com>,
    AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
    Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
    Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
    Chaitanya Kulkarni <kch@nvidia.com>,
    Andrew Morton <akpm@linux-foundation.org>,
    linux-arm-kernel@lists.infradead.org,
    linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH net-next 04/12] mm: Make the page_frag_cache allocator use multipage folios
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1841893.1686039890.1@warthog.procyon.org.uk>
From: David Howells <dhowells@redhat.com>
Date: Tue, 06 Jun 2023 09:25:13 +0100
Message-ID: <1841913.1686039913@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Alexander H Duyck <alexander.duyck@gmail.com> wrote:

> Also I have some concerns about going from page to folio as it seems
> like the folio_alloc setups the transparent hugepage destructor instead
> of using the compound page destructor. I would think that would slow
> down most users as it looks like there is a spinlock that is taken in
> the hugepage destructor that isn't there in the compound page
> destructor.

Note that this code is going to have to move to folios[*] at some point.
"Old-style" compound pages are going to go away, I believe.  Matthew Wilcox
and the mm folks are on a drive towards simplifying memory management,
formalising chunks larger than a single page - with the ultimate aim of
reducing the page struct to a single, typed pointer.

So, take, for example, a folio: As I understand it, this will no longer
overlay struct page, but rather will become a single, dynamically-allocated
struct that covers a pow-of-2 number of pages.  A contiguous subset of page
structs will point at it.

However, rather than using a folio, we could define a "page fragment" memory
type.  Rather than having all the flags and fields to be found in struct
folio, it could have just the set to be found in page_frag_cache.

David

[*] It will be possible to have some other type than "folio".  See "struct
slab" in mm/slab.h for example.  struct slab corresponds to a set of pages
and, in the future, a number of struct pages will point at it.


