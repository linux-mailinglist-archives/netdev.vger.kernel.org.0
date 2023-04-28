Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FB96F1AFF
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 16:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346119AbjD1O4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 10:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjD1O4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 10:56:04 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFC02122;
        Fri, 28 Apr 2023 07:56:02 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f1950f569eso58533455e9.2;
        Fri, 28 Apr 2023 07:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682693761; x=1685285761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fy8g7n1ksuLYc5oHMplux8drDSYz9YLH2497i/IFDxk=;
        b=GQEbe0JGlLWvexOsl7PvbUIEd4j37vZYle99oUD96/maniFehBnwtRTJg72d7NEBjP
         5MqPuVgyIwlF4moY7fpsOzPsSnUu5gboTYHZOlQmZPOBCTrCklnGXsrbYgxemhB7luEZ
         bE4BeeoxH3EDuxZNy1z9ngtkRWFNPn7yRa1XQ0vjh8CntblL52vLj9CgsiPS9j/YCi2I
         GDyfnPoD+FirCfeO45n10SxW4Au2GVyzKH3OPhrih0MutMPpID2wHCHlzU4f2lL0M5hv
         z04TNXuUK2EoPs8xWrDUaMJbrSxEax4njZ6eECClXXtHQyGalAzWsv2V22b5paN1Y3kI
         Mogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682693761; x=1685285761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fy8g7n1ksuLYc5oHMplux8drDSYz9YLH2497i/IFDxk=;
        b=DIgZ04/z5Kb2expHWzhMe8SaNp1xjkk/DxCwb0Lw0iFLTSzlNIcPRMwoZjfzDfXVzC
         bySi5e2dQ/EM4nWTv/GF8jjjTp3LlbgF8u+FXV7yUJKzZvtyDlE8zstRQZVNi1CSDYCa
         tnL08mNyZAMQ05Mmqn5SZsE8LvXa0DRcBKtDs7LsWGhzel3qrMD38XVWAl0+T05/5VDP
         Brj2HL85e1dMZLgtxWN5bh/AQg5DAnY77jaLCqOngkZfpw8gXyMxBaG7excp98MW0GCF
         kUc9cd8fp1WOS9H9hB+HvJOoToLyRS4nljI9ST7YWMkCgPQ1A1I/4WMJ+kAS237g2pT1
         z5Vw==
X-Gm-Message-State: AC+VfDySIANg7ccIXPibuoerHTd7WfTZZuO1Af59i4aIOOKt6+9w/aRa
        4izfCdq34lc9/G5pB8vLu10=
X-Google-Smtp-Source: ACHHUZ6hjlA6ewPP3BrmhivfEuQhiTVu46DBx2j2q0LolhxeDMASYqae/t0yVWBMD928cGvMeQFwlQ==
X-Received: by 2002:a7b:ca4a:0:b0:3f1:6ef6:c9d0 with SMTP id m10-20020a7bca4a000000b003f16ef6c9d0mr3924839wml.17.1682693760469;
        Fri, 28 Apr 2023 07:56:00 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id q10-20020a05600c46ca00b003f1957ace1fsm20826542wmo.13.2023.04.28.07.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 07:55:59 -0700 (PDT)
Date:   Fri, 28 Apr 2023 15:55:58 +0100
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
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <f60722d4-1474-4876-9291-5450c7192bd3@lucifer.local>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 04:20:46PM +0200, David Hildenbrand wrote:
> Sorry for jumping in late, I'm on vacation :)
>
> On 28.04.23 01:42, Lorenzo Stoakes wrote:
> > Writing to file-backed mappings which require folio dirty tracking using
> > GUP is a fundamentally broken operation, as kernel write access to GUP
> > mappings do not adhere to the semantics expected by a file system.
> >
> > A GUP caller uses the direct mapping to access the folio, which does not
> > cause write notify to trigger, nor does it enforce that the caller marks
> > the folio dirty.
>
> How should we enforce it? It would be a BUG in the GUP user.

There was discussion about holding locks when passing back pages but it's a
sticky question no doubt, but a bit out of scope here. This is more
documenting that this is a thing.

>
> >
> > The problem arises when, after an initial write to the folio, writeback
> > results in the folio being cleaned and then the caller, via the GUP
> > interface, writes to the folio again.
> >
> > As a result of the use of this secondary, direct, mapping to the folio no
> > write notify will occur, and if the caller does mark the folio dirty, this
> > will be done so unexpectedly.
>
> Right, in mprotect() code we only allow upgrading write permissions in this
> case if the pte is dirty, so we always go via the pagefault path.
>

In my ideal world we'd somehow do remote accesses via a kthread_use_mm()
style approach and page fault in every time. That's again a bit out of
scope though...

> >
> > For example, consider the following scenario:-
> >
> > 1. A folio is written to via GUP which write-faults the memory, notifying
> >     the file system and dirtying the folio.
> > 2. Later, writeback is triggered, resulting in the folio being cleaned and
> >     the PTE being marked read-only.
>
>
> How would that be triggered? Would that writeback triggered by e.g., fsync
> that Jan tried to tackle recently?

Yes or just perioditic writeback threads. The folio is dirty and needs
writeback, so at some point that'll happen. Obviously fsync/msync could
cause it too (I may be missing something here :)

>
>
> > 3. The GUP caller writes to the folio, as it is mapped read/write via the
> >     direct mapping.
> > 4. The GUP caller, now done with the page, unpins it and sets it dirty
> >     (though it does not have to).
> >
> > This results in both data being written to a folio without writenotify, and
> > the folio being dirtied unexpectedly (if the caller decides to do so).
> >
> > This issue was first reported by Jan Kara [1] in 2018, where the problem
> > resulted in file system crashes.
> >
> > This is only relevant when the mappings are file-backed and the underlying
> > file system requires folio dirty tracking. File systems which do not, such
> > as shmem or hugetlb, are not at risk and therefore can be written to
> > without issue.
> >
> > Unfortunately this limitation of GUP has been present for some time and
> > requires future rework of the GUP API in order to provide correct write
> > access to such mappings.
> >
> > However, for the time being we introduce this check to prevent the most
> > egregious case of this occurring, use of the FOLL_LONGTERM pin.
> >
> > These mappings are considerably more likely to be written to after
> > folios are cleaned and thus simply must not be permitted to do so.
> >
> > As part of this change we separate out vma_needs_dirty_tracking() as a
> > helper function to determine this which is distinct from
> > vma_wants_writenotify() which is specific to determining which PTE flags to
> > set.
> >
> > [1]:https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz/
> >
>
>
> This change has the potential to break existing setups. Simple example:
> libvirt domains configured for file-backed VM memory that also has a vfio
> device configured. It can easily be configured by users (evolving VM
> configuration, copy-paste etc.). And it works from a VM perspective, because
> the guest memory is essentially stale once the VM is shutdown and the pages
> were unpinned. At least we're not concerned about stale data on disk.
>
> With your changes, such VMs would no longer start, breaking existing user
> setups with a kernel update.

Which vfio vm_ops are we talking about? vfio_pci_mmap_ops for example
doesn't specify page_mkwrite or pfn_mkwrite. Unless you mean some arbitrary
file system in the guest?

I may well be missing context on this so forgive me if I'm being a little
dumb here, but it'd be good to get a specific example.

>
> I don't really see a lot of reasons to perform this change now. It's been
> known to be problematic for a long time. People are working on a fix (I see
> Jan is already CCed, CCing Dave and Christop). FOLL_LONGTERM check is only
> handling some of the problematic cases, so it's not even a complete blocker.

I am not a huge fan of the commentary along the lines of 'I don't really
see a lot of reasons to make this change' when people have gone to lengths
to posit reasons as to why this change is being made, by all means disagree
but it's more helpful if it's of the form 'you say we should do this for
reasons X, Y, Z I disagree for reasons a, b, c' (which you've done
elsewhere).

Also those people working on a longer term fix are supporting this change
;) I think to think that I myself may also contribute to this fix longer
term, perhaps.

>
> I know, Jason und John will disagree, but I don't think we want to be very
> careful with changing the default.
>
> Sure, we could warn, or convert individual users using a flag (io_uring).
> But maybe we should invest more energy on a fix?

This is proactively blocking a cleanup (eliminating vmas) that I believe
will be useful in moving things forward. I am not against an opt-in option
(I have been responding to community feedback in adapting my approach),
which is the way I implemented it all the way back then :)

But given we know this is both entirely broken and a potential security
issue, and FOLL_LONGTERM is about as egregious as you can get (user
explicitly saying they'll hold write access indefinitely) I feel it is an
important improvement and makes clear that this is not an acceptable usage.

I see Jason has said more on this also :)

>
>
>
>
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> > ---
> >   include/linux/mm.h |  1 +
> >   mm/gup.c           | 41 ++++++++++++++++++++++++++++++++++++++++-
> >   mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
> >   3 files changed, 68 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 37554b08bb28..f7da02fc89c6 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2433,6 +2433,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
> >   #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
> >   					    MM_CP_UFFD_WP_RESOLVE)
> >
> > +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
> >   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
> >   static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
> >   {
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 1f72a717232b..d36a5db9feb1 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -959,16 +959,51 @@ static int faultin_page(struct vm_area_struct *vma,
> >   	return 0;
> >   }
> >
> > +/*
> > + * Writing to file-backed mappings which require folio dirty tracking using GUP
> > + * is a fundamentally broken operation, as kernel write access to GUP mappings
> > + * do not adhere to the semantics expected by a file system.
> > + *
> > + * Consider the following scenario:-
> > + *
> > + * 1. A folio is written to via GUP which write-faults the memory, notifying
> > + *    the file system and dirtying the folio.
> > + * 2. Later, writeback is triggered, resulting in the folio being cleaned and
> > + *    the PTE being marked read-only.
> > + * 3. The GUP caller writes to the folio, as it is mapped read/write via the
> > + *    direct mapping.
> > + * 4. The GUP caller, now done with the page, unpins it and sets it dirty
> > + *    (though it does not have to).
> > + *
> > + * This results in both data being written to a folio without writenotify, and
> > + * the folio being dirtied unexpectedly (if the caller decides to do so).
> > + */
> > +static bool writeable_file_mapping_allowed(struct vm_area_struct *vma,
> > +					   unsigned long gup_flags)
> > +{
> > +	/* If we aren't pinning then no problematic write can occur. */
> > +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
> > +		return true;
>
> FOLL_LONGTERM only applies to FOLL_PIN. This check can be dropped.

I understand that of course (well maybe not of course, but I mean I do, I
have oodles of diagrams referencing this int he book :) This is intended to
document the fact that the check isn't relevant if we don't pin at all,
e.g. reading this you see:-

- (implicit) if not writing or anon we're good
- if not pin we're good
- ok we are only currently checking one especially egregious case
- finally, perform the dirty tracking check.

So this is intentional.

>
> > +
> > +	/* We limit this check to the most egregious case - a long term pin. */
> > +	if (!(gup_flags & FOLL_LONGTERM))
> > +		return true;
> > +
> > +	/* If the VMA requires dirty tracking then GUP will be problematic. */
> > +	return vma_needs_dirty_tracking(vma);
> > +}
> > +
> >   static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
> >   {
> >   	vm_flags_t vm_flags = vma->vm_flags;
> >   	int write = (gup_flags & FOLL_WRITE);
> >   	int foreign = (gup_flags & FOLL_REMOTE);
> > +	bool vma_anon = vma_is_anonymous(vma);
> >
> >   	if (vm_flags & (VM_IO | VM_PFNMAP))
> >   		return -EFAULT;
> >
> > -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
> > +	if ((gup_flags & FOLL_ANON) && !vma_anon)
> >   		return -EFAULT;
> >
> >   	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
> > @@ -978,6 +1013,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
> >   		return -EFAULT;
> >
> >   	if (write) {
> > +		if (!vma_anon &&
> > +		    !writeable_file_mapping_allowed(vma, gup_flags))
> > +			return -EFAULT;
> > +
> >   		if (!(vm_flags & VM_WRITE)) {
> >   			if (!(gup_flags & FOLL_FORCE))
> >   				return -EFAULT;
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 536bbb8fa0ae..7b6344d1832a 100644
> > --- a/mm/mmap.c
>
>
> I'm probably missing something, why don't we have to handle GUP-fast (having
> said that, it's hard to handle ;) )? The sequence you describe above should
> apply to GUP-fast as well, no?
>
> 1) Pin writable mapped page using GUP-fast
> 2) Trigger writeback
> 3) Write to page via pin
> 4) Unpin and set dirty

You're right, and this is an excellent point. I worry about other GUP use
cases too, but we're a bit out of luck there because we don't get to check
the VMA _at all_ (which opens yet another Pandora's box about how safe it
is to do unlocked pinning :)

But again, this comes down to the fact we're trying to make things
_incrementally__ better rather than throwing our hands up and saying one
day my ship will come in...

>
>
> --
> Thanks,
>
> David / dhildenb
>
>
