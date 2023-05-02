Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4276F494C
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 19:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbjEBRpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 13:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjEBRpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 13:45:50 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CE3C3;
        Tue,  2 May 2023 10:45:47 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-3062c1e7df8so1908144f8f.1;
        Tue, 02 May 2023 10:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683049546; x=1685641546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/465ioAn95NNEKxI/y1OxBfAvlwiRZKFhD46N2OZRqk=;
        b=MDLyOim5BMRn6hfXjaVej53KW+5dmIM3Kl9aUN5vg5pGtYXJB3mydYvJYPbHAvr5W0
         L8Nl8T5KFv+aMHZZ1EUjV0xn5gHIQQLJ8t/0RFiB3xgixHqpsIBsnCtLoPZ4M0IdEkae
         iFnNOgkq4akftSubl/G37wbbq8Ryyeyqjalcc/nswPnpN2ygGGeD/MNZpVYD5dQwKmn3
         Zw2waXt5myN4W17JESf1xHHsPzjuYjD9uQ8LE6SMACY0gesoDxJvnPXk89JVk2qVjwmn
         sJ6SWbpbNvuodR5JVQGnq1AfcxkDsORytjYHKofxm8N9wP29zJW0uKO4EHE9s6x0CyzG
         GzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683049546; x=1685641546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/465ioAn95NNEKxI/y1OxBfAvlwiRZKFhD46N2OZRqk=;
        b=ceQFAQ8hgXMJ8EMjf9oPuGecP19B+50yWH/j8g7UmuJNrow7YFoecdkIUWpDKJ05NM
         9nK9PTBulx+xKxBqn5OcwnNPrRmagiSBwDydw9dzsiCxj9rg05h+78thPbNvqEHxZxSQ
         xbky19i43AxaZrn7BnuBdhv3LfPlRoc2QDORyDwIsx0V1lvGbGZBn/w7P2sX+YKOMQdr
         EkCoYY1nfAEx1jsaQD6tFwROIEezzK3iJ2HRH8Ir4EeI/qSRZ8aIEKH2hx6tTn2KcoRO
         ZLJvvj4qelTNpUgvAF9XKhSlZp1YG8pXUSfFIWhbCd/A7KzXJNYvQaTjiFBg82pMz9Zy
         DRJA==
X-Gm-Message-State: AC+VfDwAfFNhZyaqFScTLnB/qVu01yO7l5uOQqKLa8w9buO1HIG+QzBZ
        8p1kVWsyb6M53faYa24IifU=
X-Google-Smtp-Source: ACHHUZ5GCNyVFMjZgxcHAoZ9opb9xSy+K8GBwSG7Hehx4pddEaJp9V9nLPRBUGf2oMsUu63waSSlog==
X-Received: by 2002:adf:ce05:0:b0:306:34f6:de85 with SMTP id p5-20020adfce05000000b0030634f6de85mr2709622wrn.58.1683049546176;
        Tue, 02 May 2023 10:45:46 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id f15-20020a7bcd0f000000b003f182cc55c4sm36031959wmj.12.2023.05.02.10.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 10:45:45 -0700 (PDT)
Date:   Tue, 2 May 2023 18:45:44 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v7 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <88fcd103-7302-4838-a730-f7e0f189cfe7@lucifer.local>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <b3a4441cade9770e00d24f5ecb75c8f4481785a4.1683044162.git.lstoakes@gmail.com>
 <1691115d-dba4-636b-d736-6a20359a67c3@redhat.com>
 <392debc7-2de8-440e-8b26-20f2d42cdf8d@lucifer.local>
 <6f17af6b-0925-12bd-5041-14462dab2768@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f17af6b-0925-12bd-5041-14462dab2768@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 07:38:27PM +0200, David Hildenbrand wrote:
> On 02.05.23 19:31, Lorenzo Stoakes wrote:
> > On Tue, May 02, 2023 at 07:13:49PM +0200, David Hildenbrand wrote:
> > > [...]
> > >
> > > > +{
> > > > +	struct address_space *mapping;
> > > > +
> > > > +	/*
> > > > +	 * GUP-fast disables IRQs - this prevents IPIs from causing page tables
> > > > +	 * to disappear from under us, as well as preventing RCU grace periods
> > > > +	 * from making progress (i.e. implying rcu_read_lock()).
> > > > +	 *
> > > > +	 * This means we can rely on the folio remaining stable for all
> > > > +	 * architectures, both those that set CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > > > +	 * and those that do not.
> > > > +	 *
> > > > +	 * We get the added benefit that given inodes, and thus address_space,
> > > > +	 * objects are RCU freed, we can rely on the mapping remaining stable
> > > > +	 * here with no risk of a truncation or similar race.
> > > > +	 */
> > > > +	lockdep_assert_irqs_disabled();
> > > > +
> > > > +	/*
> > > > +	 * If no mapping can be found, this implies an anonymous or otherwise
> > > > +	 * non-file backed folio so in this instance we permit the pin.
> > > > +	 *
> > > > +	 * shmem and hugetlb mappings do not require dirty-tracking so we
> > > > +	 * explicitly whitelist these.
> > > > +	 *
> > > > +	 * Other non dirty-tracked folios will be picked up on the slow path.
> > > > +	 */
> > > > +	mapping = folio_mapping(folio);
> > > > +	return !mapping || shmem_mapping(mapping) || folio_test_hugetlb(folio);
> > >
> > > "Folios in the swap cache return the swap mapping" -- you might disallow
> > > pinning anonymous pages that are in the swap cache.
> > >
> > > I recall that there are corner cases where we can end up with an anon page
> > > that's mapped writable but still in the swap cache ... so you'd fallback to
> > > the GUP slow path (acceptable for these corner cases, I guess), however
> > > especially the comment is a bit misleading then.
> >
> > How could that happen?
> >
> > >
> > > So I'd suggest not dropping the folio_test_anon() check, or open-coding it
> > > ... which will make this piece of code most certainly easier to get when
> > > staring at folio_mapping(). Or to spell it out in the comment (usually I
> > > prefer code over comments).
> >
> > I literally made this change based on your suggestion :) but perhaps I
> > misinterpreted what you meant.
> >
> > I do spell it out in the comment that the page can be anonymous, But perhaps
> > explicitly checking the mapping flags is the way to go.
> >
> > >
> > > > +}
> > > > +
> > > >    /**
> > > >     * try_grab_folio() - Attempt to get or pin a folio.
> > > >     * @page:  pointer to page to be grabbed
> > > > @@ -123,6 +170,8 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
> > > >     */
> > > >    struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
> > > >    {
> > > > +	bool is_longterm = flags & FOLL_LONGTERM;
> > > > +
> > > >    	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)))
> > > >    		return NULL;
> > > > @@ -136,8 +185,7 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
> > > >    		 * right zone, so fail and let the caller fall back to the slow
> > > >    		 * path.
> > > >    		 */
> > > > -		if (unlikely((flags & FOLL_LONGTERM) &&
> > > > -			     !is_longterm_pinnable_page(page)))
> > > > +		if (unlikely(is_longterm && !is_longterm_pinnable_page(page)))
> > > >    			return NULL;
> > > >    		/*
> > > > @@ -148,6 +196,16 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
> > > >    		if (!folio)
> > > >    			return NULL;
> > > > +		/*
> > > > +		 * Can this folio be safely pinned? We need to perform this
> > > > +		 * check after the folio is stabilised.
> > > > +		 */
> > > > +		if ((flags & FOLL_WRITE) && is_longterm &&
> > > > +		    !folio_longterm_write_pin_allowed(folio)) {
> > > > +			folio_put_refs(folio, refs);
> > > > +			return NULL;
> > > > +		}
> > >
> > > So we perform this change before validating whether the PTE changed.
> > >
> > > Hmm, naturally, I would have done it afterwards.
> > >
> > > IIRC, without IPI syncs during TLB flush (i.e.,
> > > CONFIG_MMU_GATHER_RCU_TABLE_FREE), there is the possibility that
> > > (1) We lookup the pte
> > > (2) The page was unmapped and free
> > > (3) The page gets reallocated and used
> > > (4) We pin the page
> > > (5) We dereference page->mapping
> >
> > But we have an implied RCU lock from disabled IRQs right? Unless that CONFIG
> > option does something odd (I've not really dug into its brehaviour). It feels
> > like that would break GUP-fast as a whole.
> >
> > >
> > > If we then de-reference page->mapping that gets used by whoever allocated it
> > > for something completely different (not a pointer to something reasonable),
> > > I wonder if we might be in trouble.
> > >
> > > Checking first, whether the PTE changed makes sure that what we pinned and
> > > what we're looking at is what we expected.
> > >
> > > ... I can spot that the page_is_secretmem() check is also done before that.
> > > But it at least makes sure that it's still an LRU page before staring at the
> > > mapping (making it a little safer?).
> >
> > As do we :)
> >
> > We also via try_get_folio() check to ensure that we aren't subject to a split.
> >
> > >
> > > BUT, I keep messing up this part of the story. Maybe it all works as
> > > expected because we will be synchronizing RCU somehow before actually
> > > freeing the page in the !IPI case. ... but I think that's only true for page
> > > tables with CONFIG_MMU_GATHER_RCU_TABLE_FREE.
> >
> > My understanding based on what Peter said is that the IRQs being disabled should
> > prevent anything bad from happening here.
>
>
> ... only if we verified that the PTE didn't change IIUC. IRQs disabled only
> protect you from the mapping getting freed and reused (because mappings are
> freed via RCU IIUC).
>
> But as far as I can tell, it doesn't protect you from the page itself
> getting freed and reused, and whoever freed the page uses page->mapping to
> store something completely different.

Ack, and we'd not have mapping->inode to save us in an anon case either.

I'd rather be as cautious as we can possibly be, so let's move this to after the
'PTE is the same' check then, will fix on respin.

>
> But, again, it's all complicated and confusing to me.
>

It's just a fiddly, complicated, delicate area I feel :) hence why I
endeavour to take on board the community's views on this series to ensure
we end up with the best possible implementation.

>
> page_is_secretmem() also doesn't use a READ_ONCE() ...

Perhaps one for a follow up patch...

>
> --
> Thanks,
>
> David / dhildenb
>
