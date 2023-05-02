Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFAE6F4455
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 14:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbjEBMyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 08:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbjEBMyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 08:54:51 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F357C55B7;
        Tue,  2 May 2023 05:54:44 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2f6401ce8f8so2288639f8f.3;
        Tue, 02 May 2023 05:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683032083; x=1685624083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pZWV4J/p+V2RsTLQQpuxXkHVnj5cQ9yrM686SedE9Ps=;
        b=exGo9QfzUuT4w3yzqeIHni6LyvJgGUfoTXpg/Lkddz7jH8JnMdnJxjq8WbrxrJk7Jd
         Mv6RuPP6nGfCBrYB6JbXHB+ZvwtQAER6Ci8jlG3nHy/5V6vR2gRzWJDkEQ6HvhF9Ncw+
         X8SfyEGHB//iBTdLeNVwahP3NeCXVwqD3ANA1t22fD6aBQ42NeAn+kZjj6TUE0jUgBuU
         dZ6ottaKFtSmhNEUXo++nmY3Hdo5YWNUyCjF3OitmEsTwIsepJYfG9drL9dJZwytDD8K
         hby81MpcEKa4qYEtRl43w+czZiZn64IgpO9X0dLH13u9oUbfXeEkAtzn0IUE/Lw7ebme
         rVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683032083; x=1685624083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZWV4J/p+V2RsTLQQpuxXkHVnj5cQ9yrM686SedE9Ps=;
        b=UvpZ/aSz3XRnmUY/NvnGYRn/b13uXxxXmi3e4WByPx5mhwyfDBvaUmaw2/lfsXb4Ul
         sss79331vUnUpDQK0kYJ6Hv9pIe79WmRBmyIbv6NoI4TUJ3NzD7ud4a0r08lfgxY5y3D
         cwxk9qyCU/T3Ne8jNrmxIHxy0+DbDXaBJMi3d23WDo8nuaOio9Qnh8YHRdVply8CiVwj
         +pU1/0W20krYb5VXv3NSnm1eo4pahD4GespfV7+sVGEXXSmfpHjp3t9AFVzT7GVAG/jB
         OkOH5M7RJu7aJk9vqymbDPs+xbfdp4EIG+6LYvMf/iXyZZLyNHOnLwewG+9KVKhUVLrq
         6iHg==
X-Gm-Message-State: AC+VfDxiu6jFKkOfk5DvRKvEHERWZNrEWvdcrJyA6HTyKLibQ70P+E4G
        KYHn522v5V/YmpjF7Dsp0BE=
X-Google-Smtp-Source: ACHHUZ4BqiRdCXa5j0BBKTIVvWOOPys+z0Y24apzR4Z/kS9oaG9D5SiLB4/CWZSUmTgBrSAblHzO1w==
X-Received: by 2002:adf:e4cb:0:b0:306:2de2:f583 with SMTP id v11-20020adfe4cb000000b003062de2f583mr4191054wrm.53.1683032083201;
        Tue, 02 May 2023 05:54:43 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id h3-20020a5d5043000000b002c70ce264bfsm30877530wrt.76.2023.05.02.05.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 05:54:42 -0700 (PDT)
Date:   Tue, 2 May 2023 13:54:41 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
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
        David Hildenbrand <david@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 02:46:28PM +0200, Christian Borntraeger wrote:
> Am 02.05.23 um 01:11 schrieb Lorenzo Stoakes:
> > Writing to file-backed dirty-tracked mappings via GUP is inherently broken
> > as we cannot rule out folios being cleaned and then a GUP user writing to
> > them again and possibly marking them dirty unexpectedly.
> >
> > This is especially egregious for long-term mappings (as indicated by the
> > use of the FOLL_LONGTERM flag), so we disallow this case in GUP-fast as
> > we have already done in the slow path.
>
> Hmm, does this interfer with KVM on s390 and PCI interpretion of interrupt delivery?
> It would no longer work with file backed memory, correct?
>
> See
> arch/s390/kvm/pci.c
>
> kvm_s390_pci_aif_enable
> which does have
> FOLL_WRITE | FOLL_LONGTERM
> to
>

Does this memory map a dirty-tracked file? It's kind of hard to dig into where
the address originates from without going through a ton of code. In worst case
if the fast code doesn't find a whitelist it'll fall back to slow path which
explicitly checks for dirty-tracked filesystem.

We can reintroduce a flag to permit exceptions if this is really broken, are you
able to test? I don't have an s390 sat around :)

> >
> > We have access to less information in the fast path as we cannot examine
> > the VMA containing the mapping, however we can determine whether the folio
> > is anonymous and then whitelist known-good mappings - specifically hugetlb
> > and shmem mappings.
> >
> > While we obtain a stable folio for this check, the mapping might not be, as
> > a truncate could nullify it at any time. Since doing so requires mappings
> > to be zapped, we can synchronise against a TLB shootdown operation.
> >
> > For some architectures TLB shootdown is synchronised by IPI, against which
> > we are protected as the GUP-fast operation is performed with interrupts
> > disabled. However, other architectures which specify
> > CONFIG_MMU_GATHER_RCU_TABLE_FREE use an RCU lock for this operation.
> >
> > In these instances, we acquire an RCU lock while performing our checks. If
> > we cannot get a stable mapping, we fall back to the slow path, as otherwise
> > we'd have to walk the page tables again and it's simpler and more effective
> > to just fall back.
> >
> > It's important to note that there are no APIs allowing users to specify
> > FOLL_FAST_ONLY for a PUP-fast let alone with FOLL_LONGTERM, so we can
> > always rely on the fact that if we fail to pin on the fast path, the code
> > will fall back to the slow path which can perform the more thorough check.
> >
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Suggested-by: Kirill A . Shutemov <kirill@shutemov.name>
> > Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> > ---
> >   mm/gup.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
> >   1 file changed, 85 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 0f09dec0906c..431618048a03 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -18,6 +18,7 @@
> >   #include <linux/migrate.h>
> >   #include <linux/mm_inline.h>
> >   #include <linux/sched/mm.h>
> > +#include <linux/shmem_fs.h>
> >   #include <asm/mmu_context.h>
> >   #include <asm/tlbflush.h>
> > @@ -95,6 +96,77 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
> >   	return folio;
> >   }
> > +#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > +static bool stabilise_mapping_rcu(struct folio *folio)
> > +{
> > +	struct address_space *mapping = READ_ONCE(folio->mapping);
> > +
> > +	rcu_read_lock();
> > +
> > +	return mapping == READ_ONCE(folio->mapping);
> > +}
> > +
> > +static void unlock_rcu(void)
> > +{
> > +	rcu_read_unlock();
> > +}
> > +#else
> > +static bool stabilise_mapping_rcu(struct folio *)
> > +{
> > +	return true;
> > +}
> > +
> > +static void unlock_rcu(void)
> > +{
> > +}
> > +#endif
> > +
> > +/*
> > + * Used in the GUP-fast path to determine whether a FOLL_PIN | FOLL_LONGTERM |
> > + * FOLL_WRITE pin is permitted for a specific folio.
> > + *
> > + * This assumes the folio is stable and pinned.
> > + *
> > + * Writing to pinned file-backed dirty tracked folios is inherently problematic
> > + * (see comment describing the writeable_file_mapping_allowed() function). We
> > + * therefore try to avoid the most egregious case of a long-term mapping doing
> > + * so.
> > + *
> > + * This function cannot be as thorough as that one as the VMA is not available
> > + * in the fast path, so instead we whitelist known good cases.
> > + *
> > + * The folio is stable, but the mapping might not be. When truncating for
> > + * instance, a zap is performed which triggers TLB shootdown. IRQs are disabled
> > + * so we are safe from an IPI, but some architectures use an RCU lock for this
> > + * operation, so we acquire an RCU lock to ensure the mapping is stable.
> > + */
> > +static bool folio_longterm_write_pin_allowed(struct folio *folio)
> > +{
> > +	bool ret;
> > +
> > +	/* hugetlb mappings do not require dirty tracking. */
> > +	if (folio_test_hugetlb(folio))
> > +		return true;
> > +
> > +	if (stabilise_mapping_rcu(folio)) {
> > +		struct address_space *mapping = folio_mapping(folio);
> > +
> > +		/*
> > +		 * Neither anonymous nor shmem-backed folios require
> > +		 * dirty tracking.
> > +		 */
> > +		ret = folio_test_anon(folio) ||
> > +			(mapping && shmem_mapping(mapping));
> > +	} else {
> > +		/* If the mapping is unstable, fallback to the slow path. */
> > +		ret = false;
> > +	}
> > +
> > +	unlock_rcu();
> > +
> > +	return ret;
> > +}
> > +
> >   /**
> >    * try_grab_folio() - Attempt to get or pin a folio.
> >    * @page:  pointer to page to be grabbed
> > @@ -123,6 +195,8 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
> >    */
> >   struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
> >   {
> > +	bool is_longterm = flags & FOLL_LONGTERM;
> > +
> >   	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)))
> >   		return NULL;
> > @@ -136,8 +210,7 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
> >   		 * right zone, so fail and let the caller fall back to the slow
> >   		 * path.
> >   		 */
> > -		if (unlikely((flags & FOLL_LONGTERM) &&
> > -			     !is_longterm_pinnable_page(page)))
> > +		if (unlikely(is_longterm && !is_longterm_pinnable_page(page)))
> >   			return NULL;
> >   		/*
> > @@ -148,6 +221,16 @@ struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags)
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
> > +
> >   		/*
> >   		 * When pinning a large folio, use an exact count to track it.
> >   		 *
