Return-Path: <netdev+bounces-5922-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51A6F713578
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 17:48:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F0CD28150E
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6715B134BA;
	Sat, 27 May 2023 15:48:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5648C3FEF
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 15:48:04 +0000 (UTC)
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA4AA2;
	Sat, 27 May 2023 08:48:02 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-256531ad335so322313a91.0;
        Sat, 27 May 2023 08:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685202482; x=1687794482;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J49g5r+C8X2NVCkBgl8IzrTCMvTMcQQzUyfAMjxZsPg=;
        b=bUL5aHRkLeXZgL9zLh88p3YSSEdIcCAWRafE5CCYjGxTY3b4C3Nvx9HyPTyr/MFIOy
         XNJoF8YCF/UuX9K7KUHu0+XrePH07oMRCWX8Xbo1x7sNks0uPXrC7DyAE2YZ4nRJbxmX
         R+vS/qobWvWDwbY/vp3IFGaoobPrHdxLodkySGURPv0utOVIMAyhkSVf+YGDr2He0s2+
         mFeAz0s4hFMt6E5OhaapTV9xjhbS5h7hmrocjChFeleEtRzzQxiyNpffZQ1mkdD3wp6N
         kwic0v4RCyjRUeyXdYulrgWtKqFCkPBnTY7+z+AWj+P7a+4sVK3Mo/U26rqt0pp8KAYf
         6I9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685202482; x=1687794482;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J49g5r+C8X2NVCkBgl8IzrTCMvTMcQQzUyfAMjxZsPg=;
        b=PH50FTu4ko7yvm2Fk2JnQ26AuDnuOWGzIB6d8MfhR60zmBTY6wGlN5vQX0BpSkGxJJ
         9Y7nVtKuwh4DkoRYr55ee60cswz3X3nxzdJ/tGYeTZlDBjagJFFn2jceKEOxBxsOZLiE
         T1x7pnkkXutNV1J0wOYcxvpa4P+2EpotPbArR1ai7B4pXQcHJ0gl0RxuKB2qQM2+E9Ip
         Lqpqwsx2kGncuZML3CrQ9sBRJvFST8vkGZ6EB7laypT21xOzb4oZbG4ir9qID6mQZPUX
         c8O0StfYtd2ZXdQv33nuhUmp9UQT+VQGH9vtoieN7AiE2Gl/kp0Vwz2eqLMcT/sKfUrC
         bTRQ==
X-Gm-Message-State: AC+VfDzOydpZ7h6/FqkiKCvq2DJw7iX2h93/5WfnSuPoNr1CdtLQetZN
	aa1rqM/9r86l/GpIoFGE5Y8=
X-Google-Smtp-Source: ACHHUZ7QPh85GAe4qtDoAAFctO3cPI86At/IRUfb5BaooKwKJwDEqjmatrKZ0/p6N1NdUk4vgS+bMw==
X-Received: by 2002:a17:90a:7021:b0:250:7d1f:938b with SMTP id f30-20020a17090a702100b002507d1f938bmr6504460pjk.23.1685202481899;
        Sat, 27 May 2023 08:48:01 -0700 (PDT)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id 5-20020a17090a000500b00253311d508esm6598798pja.27.2023.05.27.08.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 08:48:01 -0700 (PDT)
Message-ID: <f7919c2c9e1cb6218a0b0f55ddaa9a34f7d2b9a7.camel@gmail.com>
Subject: Re: [PATCH net-next 04/12] mm: Make the page_frag_cache allocator
 use multipage folios
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Yunsheng Lin <linyunsheng@huawei.com>, David Howells
 <dhowells@redhat.com>,  netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jeroen de Borst <jeroendb@google.com>, 
 Catherine Sullivan <csully@google.com>, Shailend Chand
 <shailend@google.com>, Felix Fietkau <nbd@nbd.name>, John Crispin
 <john@phrozen.org>, Sean Wang <sean.wang@mediatek.com>, Mark Lee
 <Mark-MC.Lee@mediatek.com>, Lorenzo Bianconi <lorenzo@kernel.org>, Matthias
 Brugger <matthias.bgg@gmail.com>,  AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@fb.com>,  Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>,  linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org,  linux-nvme@lists.infradead.org
Date: Sat, 27 May 2023 08:47:58 -0700
In-Reply-To: <a819dd80-54cc-695f-f142-e3d42ce815a7@huawei.com>
References: <20230524153311.3625329-1-dhowells@redhat.com>
	 <20230524153311.3625329-5-dhowells@redhat.com>
	 <a819dd80-54cc-695f-f142-e3d42ce815a7@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 2023-05-26 at 19:56 +0800, Yunsheng Lin wrote:
> On 2023/5/24 23:33, David Howells wrote:
> > Change the page_frag_cache allocator to use multipage folios rather tha=
n
> > groups of pages.  This reduces page_frag_free to just a folio_put() or
> > put_page().
>=20
> Hi, David
>=20
> put_page() is not used in this patch, perhaps remove it to avoid
> the confusion?
> Also, Is there any significant difference between __free_pages()
> and folio_put()? IOW, what does the 'reduces' part means here?
>=20
> I followed some disscusion about folio before, but have not really
> understood about real difference between 'multipage folios' and
> 'groups of pages' yet. Is folio mostly used to avoid the confusion
> about whether a page is 'headpage of compound page', 'base page' or
> 'tailpage of compound page'? Or is there any abvious benefit about
> folio that I missed?
>=20
> >=20
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 306a3d1a0fa6..d7c52a5979cc 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -420,18 +420,13 @@ static inline void *folio_get_private(struct foli=
o *folio)
> >  }
> > =20
> >  struct page_frag_cache {
> > -	void * va;
> > -#if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
> > -	__u16 offset;
> > -	__u16 size;
> > -#else
> > -	__u32 offset;
> > -#endif
> > +	struct folio	*folio;
> > +	unsigned int	offset;
> >  	/* we maintain a pagecount bias, so that we dont dirty cache line
> >  	 * containing page->_refcount every time we allocate a fragment.
> >  	 */
> > -	unsigned int		pagecnt_bias;
> > -	bool pfmemalloc;
> > +	unsigned int	pagecnt_bias;
> > +	bool		pfmemalloc;
> >  };
>=20
> It seems 'va' and 'size' field is used to avoid touching 'stuct page' to
> avoid possible cache bouncing when there is more frag can be allocated
> from the page while other frags is freed at the same time before this pat=
ch?
> It might be worth calling that out in the commit log or split it into ano=
ther
> patch to make it clearer and easier to review?

Yes, there is a cost for going from page to virtual address. That is
why we only use the page when we finally get to freeing or resetting
the pagecnt_bias.

Also I have some concerns about going from page to folio as it seems
like the folio_alloc setups the transparent hugepage destructor instead
of using the compound page destructor. I would think that would slow
down most users as it looks like there is a spinlock that is taken in
the hugepage destructor that isn't there in the compound page
destructor.

