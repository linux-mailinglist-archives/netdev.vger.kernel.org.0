Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A336F43DC
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 14:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbjEBM1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 08:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbjEBM1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 08:27:47 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921AE55B2;
        Tue,  2 May 2023 05:27:45 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f178da219bso36034405e9.1;
        Tue, 02 May 2023 05:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683030464; x=1685622464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZN+pooP8nd+FXQmX2bQBwmYVFsxwnGNnZBxQw0pqYZA=;
        b=pnedyj4oEvrOpSDxWQpNYOPf1Yxqe5RF0zu0rC20hWNl+D3yv7xKL1usMcIfA/yM4S
         /8BfK39477afR6q8Z3jp3yG3WXJMcYTUaLo2KsuOC6f315SSD233kSRZneWMBB9KLyQe
         vpgLMgDAUd2LzM9S4J8FnfcPv7I/hodf1mBBHPrDJfi82uqdzC3I8/2+jCU3JwfAh9Ok
         ViL9nuzGqA7IAFWkBweZCMgVTyuIZWzwXbUMPT3yQWBlqoS12JyHgpWmysya2Q+9swPc
         AScrvbJgA15fgZa/qWiMoyj4XrARkayt4lWa8EFFZyT+kloFfeLF1MNUOv0RBDCmrj3S
         1qLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683030464; x=1685622464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZN+pooP8nd+FXQmX2bQBwmYVFsxwnGNnZBxQw0pqYZA=;
        b=NCTU9ymcz9rV8DsFcQXzgpcmr6teArPYV3Ac5FFBAz9n8+do0VijQLpI8jZDye/5v0
         P+EzbFSJzJAMPP6PR5KIbLRyMw+Ht7zIQE3v3V75lWFY40mGhAiBwEgum3n43CtVbsLq
         qG3QTywzRvO7tIaj9/A5jPnRVn2Ot3lc2tI9TAiXeDmJrffk0ulYcgp/yJ1wUvLMV1SJ
         0tGOIczozIprMckJu3wzGgwU8GWXqAPFwuGIa51r0cO5ukSeMbiA4hD9gqU0BrSOU5jg
         YfRPlydT81+sEHuHT0Ts4wPZ7N0y0EcNgJ2/sUXgepDmO+p/7bIpU48PaS4ht1hfJQLt
         dEtw==
X-Gm-Message-State: AC+VfDwO3kviWLVgjNRZOGfpzK2SGsqWZKv1HqdEABy1hZdnEAYk+ikp
        t69VOZcMSnLPVU8h04iovhzZ7BvWt4kkcg==
X-Google-Smtp-Source: ACHHUZ4+DQOWWJ1+EFDDG7oTmHd8+g/1rY3vrIA73s5XXOKVAggQWkPQcEm0YidgqeEZ5RK9+IFzLw==
X-Received: by 2002:a05:600c:2309:b0:3ea:f73e:9d8a with SMTP id 9-20020a05600c230900b003eaf73e9d8amr12689569wmo.30.1683030463792;
        Tue, 02 May 2023 05:27:43 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id p5-20020a05600c468500b003f18141a016sm38543498wmo.18.2023.05.02.05.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 05:27:43 -0700 (PDT)
Date:   Tue, 2 May 2023 13:27:42 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
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
        David Hildenbrand <david@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Paul McKenney <paulmck@kernel.org>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <44ee78e9-6cc9-4aee-92fd-e5335576a55c@lucifer.local>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <20230502111334.GP1597476@hirez.programming.kicks-ass.net>
 <ab66d15a-acd0-4d9b-aa12-49cddd12c6a5@lucifer.local>
 <20230502120810.GD1597538@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502120810.GD1597538@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 02:08:10PM +0200, Peter Zijlstra wrote:
> On Tue, May 02, 2023 at 12:25:54PM +0100, Lorenzo Stoakes wrote:
> > On Tue, May 02, 2023 at 01:13:34PM +0200, Peter Zijlstra wrote:
> > > On Tue, May 02, 2023 at 12:11:49AM +0100, Lorenzo Stoakes wrote:
> > > > @@ -95,6 +96,77 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
> > > >  	return folio;
> > > >  }
> > > >
> > > > +#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > > > +static bool stabilise_mapping_rcu(struct folio *folio)
> > > > +{
> > > > +	struct address_space *mapping = READ_ONCE(folio->mapping);
> > > > +
> > > > +	rcu_read_lock();
> > > > +
> > > > +	return mapping == READ_ONCE(folio->mapping);
> > >
> > > This doesn't make sense; why bother reading the same thing twice?
> >
> > The intent is to see whether the folio->mapping has been truncated from
> > underneath us, as per the futex code that Kirill referred to which does
> > something similar [1].
>
> Yeah, but per that 3rd load you got nothing here. Also that futex code
> did the early load to deal with the !mapping case, but you're not doing
> that.
>

OK I drafted a response three times then deleted which shows you how this
stuff messes with your mind :)

I realise now that literally it is checking whether the previous !mapping
case and lack of action taken on that was valid for futex, rendering this
pointless for the logic here.

We do check !mapping later but obviously with the 'stable' mapping whose
relation to pre-rcu lock is irrelevant.

Thanks for patiently explaining this :) RCU remains an area I need to take
a closer look at generally.

> > > Who cares if the thing changes from before; what you care about is that
> > > the value you see has stable storage, this doesn't help with that.
> > >
> > > > +}
> > > > +
> > > > +static void unlock_rcu(void)
> > > > +{
> > > > +	rcu_read_unlock();
> > > > +}
> > > > +#else
> > > > +static bool stabilise_mapping_rcu(struct folio *)
> > > > +{
> > > > +	return true;
> > > > +}
> > > > +
> > > > +static void unlock_rcu(void)
> > > > +{
> > > > +}
> > > > +#endif
> > >
> > > Anyway, this all can go away. RCU can't progress while you have
> > > interrupts disabled anyway.
> >
> > There seems to be other code in the kernel that assumes that this is not
> > the case,
>
> Yeah, so Paul went back on forth on that a bit. It used to be true in
> the good old days when everything was simple. Then Paul made things
> complicated by separating out sched-RCU bh-RCU and 'regular' RCU
> flavours.
>
> At that point disabling IRQs would only (officially) inhibit sched and
> bh RCU flavours, but not the regular RCU.
>
> But then some years ago Linus convinced Paul that having all these
> separate RCU flavours with separate QS rules was a big pain in the
> backside and Paul munged them all together again.
>
> So now, anything that inhibits any of the RCU flavours inhibits them
> all. So disabling IRQs is sufficient.
>
> > i.e. the futex code, though not sure if that's being run with
> > IRQs disabled...
>
> That futex code runs in preemptible context, per the lock_page() that
> can sleep etc.. :-)

OK I am actually really happy to hear this because this means I can go
simplify this code significantly!

>
> > > > +/*
> > > > + * Used in the GUP-fast path to determine whether a FOLL_PIN | FOLL_LONGTERM |
> > > > + * FOLL_WRITE pin is permitted for a specific folio.
> > > > + *
> > > > + * This assumes the folio is stable and pinned.
> > > > + *
> > > > + * Writing to pinned file-backed dirty tracked folios is inherently problematic
> > > > + * (see comment describing the writeable_file_mapping_allowed() function). We
> > > > + * therefore try to avoid the most egregious case of a long-term mapping doing
> > > > + * so.
> > > > + *
> > > > + * This function cannot be as thorough as that one as the VMA is not available
> > > > + * in the fast path, so instead we whitelist known good cases.
> > > > + *
> > > > + * The folio is stable, but the mapping might not be. When truncating for
> > > > + * instance, a zap is performed which triggers TLB shootdown. IRQs are disabled
> > > > + * so we are safe from an IPI, but some architectures use an RCU lock for this
> > > > + * operation, so we acquire an RCU lock to ensure the mapping is stable.
> > > > + */
> > > > +static bool folio_longterm_write_pin_allowed(struct folio *folio)
> > > > +{
> > > > +	bool ret;
> > > > +
> > > > +	/* hugetlb mappings do not require dirty tracking. */
> > > > +	if (folio_test_hugetlb(folio))
> > > > +		return true;
> > > > +
> > >
> > > This:
> > >
> > > > +	if (stabilise_mapping_rcu(folio)) {
> > > > +		struct address_space *mapping = folio_mapping(folio);
> > >
> > > And this is 3rd read of folio->mapping, just for giggles?
> >
> > I like to giggle :)
> >
> > Actually this is to handle the various cases in which the mapping might not
> > be what we want (i.e. have PAGE_MAPPING_FLAGS set) which doesn't appear to
> > have a helper exposed for a check. Given previous review about duplication
> > I felt best to reuse this even though it does access again... yes I felt
> > weird about doing that.
>
> Right, I had a peek inside folio_mapping(), but the point is that this
> 3rd load might see yet *another* value of mapping from the prior two
> loads, rendering them somewhat worthless.
>
> > > > +
> > > > +		/*
> > > > +		 * Neither anonymous nor shmem-backed folios require
> > > > +		 * dirty tracking.
> > > > +		 */
> > > > +		ret = folio_test_anon(folio) ||
> > > > +			(mapping && shmem_mapping(mapping));
> > > > +	} else {
> > > > +		/* If the mapping is unstable, fallback to the slow path. */
> > > > +		ret = false;
> > > > +	}
> > > > +
> > > > +	unlock_rcu();
> > > > +
> > > > +	return ret;
> > >
> > > then becomes:
> > >
> > >
> > > 	if (folio_test_anon(folio))
> > > 		return true;
> >
> > This relies on the mapping so belongs below the lockdep assert imo.
>
> Oh, right you are.
>
> > >
> > > 	/*
> > > 	 * Having IRQs disabled (as per GUP-fast) also inhibits RCU
> > > 	 * grace periods from making progress, IOW. they imply
> > > 	 * rcu_read_lock().
> > > 	 */
> > > 	lockdep_assert_irqs_disabled();
> > >
> > > 	/*
> > > 	 * Inodes and thus address_space are RCU freed and thus safe to
> > > 	 * access at this point.
> > > 	 */
> > > 	mapping = folio_mapping(folio);
> > > 	if (mapping && shmem_mapping(mapping))
> > > 		return true;
> > >
> > > 	return false;
> > >
> > > > +}
> >
> > I'm more than happy to do this (I'd rather drop the RCU bits if possible)
> > but need to be sure it's safe.
>
> GUP-fast as a whole relies on it :-)

Indeed, the only question was what happened with
CONFIG_MMU_GATHER_RCU_TABLE_FREE arches which appeared to require special
handling, but I'm very happy to hear they don't!

Will respin along the lines of your suggestion.
