Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C656F4925
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 19:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbjEBRbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 13:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbjEBRbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 13:31:31 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066DBE79;
        Tue,  2 May 2023 10:31:30 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f09b4a1527so42699625e9.0;
        Tue, 02 May 2023 10:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683048688; x=1685640688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kCAPbuVKXeBY3NxRBpe261J3m7++OAgwEdQm754iF8g=;
        b=mCxBV5ZYJzLUbZctDfi9hFDmZOYoLKZqzIPerPYG9FZXARz1KDgVBA/PTMd3eDi7DE
         SVC/AmdybF/V2kI18El9skoD0YhpSa4Vh7rAfPUgot2Y/QF05gp5/XQuubkN0gOx5cuA
         MfL3bbFuS/lNP+btkBZrM7gnM4mkxnia5X41hWyJkY3m5mxs3LEuh5J2+CAiCyDluIsg
         cB2yx6uoZL5S/ASk23YG8rrX7+pl8SE9FS0hukdVhC59Ou64m+CiYOQDUQ07yJIwTJoL
         HtK2OkkeSJodUoN86B/pwW6pCP2wxeFBD5vdgg00mgivQg1SuS97+byIOLkmEVTp7cjj
         X7oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683048688; x=1685640688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kCAPbuVKXeBY3NxRBpe261J3m7++OAgwEdQm754iF8g=;
        b=Gc0jmqmeQG3pxZL1d9ex7q62ctDxD4v6LgjVi5EnxJE04jGzT5cjWa9AKlFNU2SDZh
         1NyFjbSZgfGM9mMti9njgHT+UH8F8MmXLobPLXsaL5cW65yKgFVU4q4NY0uOHjzNgwMz
         Oqf1qxjClOToQPD0/FypHOs7TREub6pNGB5v4WcnW0hJW2DmuYLBaCc9uko7M6FkBEhY
         cgnXaniiIUr3MV6QVNKvVEbnUlmzaaaHLUHYRmJfTlzpkc2ATG8QsdLKQ3eKbebm8qe1
         Nm4j5Kdri8b+/HYd+CvDR2+OD0aOqrZDrSI7/RRlM70DQdPa3sYoVGrnga0TtXfEp7Xo
         hgXA==
X-Gm-Message-State: AC+VfDyjn0t9zgFEzQ9aXrlh+T0FapwgJVXWoVSxeCKDZhrBPDHJ//MS
        Ep4M929wC4KZbWR7gJbU7xd7Tfqp4jdNXw==
X-Google-Smtp-Source: ACHHUZ4WBDv5eM+nEXUKvlmKsApfvo3avLdkWErACy8liIsuKOAvHMj4F/xzvC+e07tUoWwAS2+vyw==
X-Received: by 2002:adf:db86:0:b0:2f4:a3ea:65d2 with SMTP id u6-20020adfdb86000000b002f4a3ea65d2mr13996931wri.57.1683048688267;
        Tue, 02 May 2023 10:31:28 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id t15-20020adfe44f000000b002f00793bd7asm31385628wrm.27.2023.05.02.10.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 10:31:27 -0700 (PDT)
Date:   Tue, 2 May 2023 18:31:26 +0100
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
Message-ID: <392debc7-2de8-440e-8b26-20f2d42cdf8d@lucifer.local>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <b3a4441cade9770e00d24f5ecb75c8f4481785a4.1683044162.git.lstoakes@gmail.com>
 <1691115d-dba4-636b-d736-6a20359a67c3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1691115d-dba4-636b-d736-6a20359a67c3@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 07:13:49PM +0200, David Hildenbrand wrote:
> [...]
>
> > +{
> > +	struct address_space *mapping;
> > +
> > +	/*
> > +	 * GUP-fast disables IRQs - this prevents IPIs from causing page tables
> > +	 * to disappear from under us, as well as preventing RCU grace periods
> > +	 * from making progress (i.e. implying rcu_read_lock()).
> > +	 *
> > +	 * This means we can rely on the folio remaining stable for all
> > +	 * architectures, both those that set CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > +	 * and those that do not.
> > +	 *
> > +	 * We get the added benefit that given inodes, and thus address_space,
> > +	 * objects are RCU freed, we can rely on the mapping remaining stable
> > +	 * here with no risk of a truncation or similar race.
> > +	 */
> > +	lockdep_assert_irqs_disabled();
> > +
> > +	/*
> > +	 * If no mapping can be found, this implies an anonymous or otherwise
> > +	 * non-file backed folio so in this instance we permit the pin.
> > +	 *
> > +	 * shmem and hugetlb mappings do not require dirty-tracking so we
> > +	 * explicitly whitelist these.
> > +	 *
> > +	 * Other non dirty-tracked folios will be picked up on the slow path.
> > +	 */
> > +	mapping = folio_mapping(folio);
> > +	return !mapping || shmem_mapping(mapping) || folio_test_hugetlb(folio);
>
> "Folios in the swap cache return the swap mapping" -- you might disallow
> pinning anonymous pages that are in the swap cache.
>
> I recall that there are corner cases where we can end up with an anon page
> that's mapped writable but still in the swap cache ... so you'd fallback to
> the GUP slow path (acceptable for these corner cases, I guess), however
> especially the comment is a bit misleading then.

How could that happen?

>
> So I'd suggest not dropping the folio_test_anon() check, or open-coding it
> ... which will make this piece of code most certainly easier to get when
> staring at folio_mapping(). Or to spell it out in the comment (usually I
> prefer code over comments).

I literally made this change based on your suggestion :) but perhaps I
misinterpreted what you meant.

I do spell it out in the comment that the page can be anonymous, But perhaps
explicitly checking the mapping flags is the way to go.

>
> > +}
> > +
> >   /**
> >    * try_grab_folio() - Attempt to get or pin a folio.
> >    * @page:  pointer to page to be grabbed
> > @@ -123,6 +170,8 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
> >    */
> >   struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
> >   {
> > +	bool is_longterm = flags & FOLL_LONGTERM;
> > +
> >   	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)))
> >   		return NULL;
> > @@ -136,8 +185,7 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
> >   		 * right zone, so fail and let the caller fall back to the slow
> >   		 * path.
> >   		 */
> > -		if (unlikely((flags & FOLL_LONGTERM) &&
> > -			     !is_longterm_pinnable_page(page)))
> > +		if (unlikely(is_longterm && !is_longterm_pinnable_page(page)))
> >   			return NULL;
> >   		/*
> > @@ -148,6 +196,16 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
> >   		if (!folio)
> >   			return NULL;
> > +		/*
> > +		 * Can this folio be safely pinned? We need to perform this
> > +		 * check after the folio is stabilised.
> > +		 */
> > +		if ((flags & FOLL_WRITE) && is_longterm &&
> > +		    !folio_longterm_write_pin_allowed(folio)) {
> > +			folio_put_refs(folio, refs);
> > +			return NULL;
> > +		}
>
> So we perform this change before validating whether the PTE changed.
>
> Hmm, naturally, I would have done it afterwards.
>
> IIRC, without IPI syncs during TLB flush (i.e.,
> CONFIG_MMU_GATHER_RCU_TABLE_FREE), there is the possibility that
> (1) We lookup the pte
> (2) The page was unmapped and free
> (3) The page gets reallocated and used
> (4) We pin the page
> (5) We dereference page->mapping

But we have an implied RCU lock from disabled IRQs right? Unless that CONFIG
option does something odd (I've not really dug into its brehaviour). It feels
like that would break GUP-fast as a whole.

>
> If we then de-reference page->mapping that gets used by whoever allocated it
> for something completely different (not a pointer to something reasonable),
> I wonder if we might be in trouble.
>
> Checking first, whether the PTE changed makes sure that what we pinned and
> what we're looking at is what we expected.
>
> ... I can spot that the page_is_secretmem() check is also done before that.
> But it at least makes sure that it's still an LRU page before staring at the
> mapping (making it a little safer?).

As do we :)

We also via try_get_folio() check to ensure that we aren't subject to a split.

>
> BUT, I keep messing up this part of the story. Maybe it all works as
> expected because we will be synchronizing RCU somehow before actually
> freeing the page in the !IPI case. ... but I think that's only true for page
> tables with CONFIG_MMU_GATHER_RCU_TABLE_FREE.

My understanding based on what Peter said is that the IRQs being disabled should
prevent anything bad from happening here.

>
> --
> Thanks,
>
> David / dhildenb
>
