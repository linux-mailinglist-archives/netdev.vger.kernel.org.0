Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9516F434F
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 14:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbjEBMJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 08:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbjEBMJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 08:09:04 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C0F358B;
        Tue,  2 May 2023 05:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pz1BFTrMbjtmTLSMUAMwv5KDjqVuW0L+OFuL8UBqI6M=; b=UKrjov+EaCK9CHW/8De9JD8ppd
        WIAvUqI3xCyhKeUEWy4dg8GrMF+zoqXiitSmj2yLsjJX0In/tnDn/SnOJ9OVUF6SZHXf8cPpDv2KE
        rQ08+4D83uNLFOaaJ2q9zRzM+XirpW5wcRZ0o9EhGPYg91REe8sz6VwLFkn+kslAqtCMzi0BJcgEi
        2mr1mvcT0Gp95Sl5NZZEslKSWB2BTNGr+UHLLJMIQkfBdBgAuQbzT9kDg2CBJnJzMrLvk0Kvuyj12
        uaKVqyt/rexm5oBsVlZbGOAF6Y7t+B9aFsOSgAjh7TQJeIMXCkXoyKQBxq5l4v4HqLq1hhn/9fIjc
        G2Q4Popw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1ptonk-00GIcJ-0E;
        Tue, 02 May 2023 12:08:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B838C300165;
        Tue,  2 May 2023 14:08:10 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 784D023C5C351; Tue,  2 May 2023 14:08:10 +0200 (CEST)
Date:   Tue, 2 May 2023 14:08:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
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
Message-ID: <20230502120810.GD1597538@hirez.programming.kicks-ass.net>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <20230502111334.GP1597476@hirez.programming.kicks-ass.net>
 <ab66d15a-acd0-4d9b-aa12-49cddd12c6a5@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab66d15a-acd0-4d9b-aa12-49cddd12c6a5@lucifer.local>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 12:25:54PM +0100, Lorenzo Stoakes wrote:
> On Tue, May 02, 2023 at 01:13:34PM +0200, Peter Zijlstra wrote:
> > On Tue, May 02, 2023 at 12:11:49AM +0100, Lorenzo Stoakes wrote:
> > > @@ -95,6 +96,77 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
> > >  	return folio;
> > >  }
> > >
> > > +#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > > +static bool stabilise_mapping_rcu(struct folio *folio)
> > > +{
> > > +	struct address_space *mapping = READ_ONCE(folio->mapping);
> > > +
> > > +	rcu_read_lock();
> > > +
> > > +	return mapping == READ_ONCE(folio->mapping);
> >
> > This doesn't make sense; why bother reading the same thing twice?
> 
> The intent is to see whether the folio->mapping has been truncated from
> underneath us, as per the futex code that Kirill referred to which does
> something similar [1].

Yeah, but per that 3rd load you got nothing here. Also that futex code
did the early load to deal with the !mapping case, but you're not doing
that.

> > Who cares if the thing changes from before; what you care about is that
> > the value you see has stable storage, this doesn't help with that.
> >
> > > +}
> > > +
> > > +static void unlock_rcu(void)
> > > +{
> > > +	rcu_read_unlock();
> > > +}
> > > +#else
> > > +static bool stabilise_mapping_rcu(struct folio *)
> > > +{
> > > +	return true;
> > > +}
> > > +
> > > +static void unlock_rcu(void)
> > > +{
> > > +}
> > > +#endif
> >
> > Anyway, this all can go away. RCU can't progress while you have
> > interrupts disabled anyway.
> 
> There seems to be other code in the kernel that assumes that this is not
> the case,

Yeah, so Paul went back on forth on that a bit. It used to be true in
the good old days when everything was simple. Then Paul made things
complicated by separating out sched-RCU bh-RCU and 'regular' RCU
flavours.

At that point disabling IRQs would only (officially) inhibit sched and
bh RCU flavours, but not the regular RCU.

But then some years ago Linus convinced Paul that having all these
separate RCU flavours with separate QS rules was a big pain in the
backside and Paul munged them all together again.

So now, anything that inhibits any of the RCU flavours inhibits them
all. So disabling IRQs is sufficient.

> i.e. the futex code, though not sure if that's being run with
> IRQs disabled...

That futex code runs in preemptible context, per the lock_page() that
can sleep etc.. :-)

> > > +/*
> > > + * Used in the GUP-fast path to determine whether a FOLL_PIN | FOLL_LONGTERM |
> > > + * FOLL_WRITE pin is permitted for a specific folio.
> > > + *
> > > + * This assumes the folio is stable and pinned.
> > > + *
> > > + * Writing to pinned file-backed dirty tracked folios is inherently problematic
> > > + * (see comment describing the writeable_file_mapping_allowed() function). We
> > > + * therefore try to avoid the most egregious case of a long-term mapping doing
> > > + * so.
> > > + *
> > > + * This function cannot be as thorough as that one as the VMA is not available
> > > + * in the fast path, so instead we whitelist known good cases.
> > > + *
> > > + * The folio is stable, but the mapping might not be. When truncating for
> > > + * instance, a zap is performed which triggers TLB shootdown. IRQs are disabled
> > > + * so we are safe from an IPI, but some architectures use an RCU lock for this
> > > + * operation, so we acquire an RCU lock to ensure the mapping is stable.
> > > + */
> > > +static bool folio_longterm_write_pin_allowed(struct folio *folio)
> > > +{
> > > +	bool ret;
> > > +
> > > +	/* hugetlb mappings do not require dirty tracking. */
> > > +	if (folio_test_hugetlb(folio))
> > > +		return true;
> > > +
> >
> > This:
> >
> > > +	if (stabilise_mapping_rcu(folio)) {
> > > +		struct address_space *mapping = folio_mapping(folio);
> >
> > And this is 3rd read of folio->mapping, just for giggles?
> 
> I like to giggle :)
> 
> Actually this is to handle the various cases in which the mapping might not
> be what we want (i.e. have PAGE_MAPPING_FLAGS set) which doesn't appear to
> have a helper exposed for a check. Given previous review about duplication
> I felt best to reuse this even though it does access again... yes I felt
> weird about doing that.

Right, I had a peek inside folio_mapping(), but the point is that this
3rd load might see yet *another* value of mapping from the prior two
loads, rendering them somewhat worthless.

> > > +
> > > +		/*
> > > +		 * Neither anonymous nor shmem-backed folios require
> > > +		 * dirty tracking.
> > > +		 */
> > > +		ret = folio_test_anon(folio) ||
> > > +			(mapping && shmem_mapping(mapping));
> > > +	} else {
> > > +		/* If the mapping is unstable, fallback to the slow path. */
> > > +		ret = false;
> > > +	}
> > > +
> > > +	unlock_rcu();
> > > +
> > > +	return ret;
> >
> > then becomes:
> >
> >
> > 	if (folio_test_anon(folio))
> > 		return true;
> 
> This relies on the mapping so belongs below the lockdep assert imo.

Oh, right you are.

> >
> > 	/*
> > 	 * Having IRQs disabled (as per GUP-fast) also inhibits RCU
> > 	 * grace periods from making progress, IOW. they imply
> > 	 * rcu_read_lock().
> > 	 */
> > 	lockdep_assert_irqs_disabled();
> >
> > 	/*
> > 	 * Inodes and thus address_space are RCU freed and thus safe to
> > 	 * access at this point.
> > 	 */
> > 	mapping = folio_mapping(folio);
> > 	if (mapping && shmem_mapping(mapping))
> > 		return true;
> >
> > 	return false;
> >
> > > +}
> 
> I'm more than happy to do this (I'd rather drop the RCU bits if possible)
> but need to be sure it's safe.

GUP-fast as a whole relies on it :-)
