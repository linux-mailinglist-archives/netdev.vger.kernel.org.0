Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65CB96F1B6B
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 17:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346397AbjD1PY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 11:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346368AbjD1PY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 11:24:27 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FE583;
        Fri, 28 Apr 2023 08:24:26 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-2f8405b3dc1so6282089f8f.3;
        Fri, 28 Apr 2023 08:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682695464; x=1685287464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vFxBFzzCkgMJp5wwZwbTmANgljskVv8ZGWWfh/YUqMw=;
        b=KaTij+70zbQI8GHYvi242m+Bo30QjzZy6AXy+3OqxSmifn+26MDDXfWHbJcvXnUhcs
         43NiqMNu1kC7BScNlCSgOKIX9nEoPt5N+UhB2O2mB//gVceRJ0GOg3Afz/tLy4xST9u/
         wtmZiCencwq3etaNFQCgNY3Mws+dZjuvXOaBLyQB+B6BrA5JKp/gmT8LeX6kxddP+7Ay
         8RdQ/RmOR8Frs+gJ73V/04u8Js/v/jllF7urG1nx8tyzPL7zX1rmq0d/3DJS2KtfufGN
         rGKXYhKuu+6A1pv7uSJxB4FxXPXfvbkx0eqvlscrc4VTnajvBMLc/DvHdjvIzJ5KkRmO
         RY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682695464; x=1685287464;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFxBFzzCkgMJp5wwZwbTmANgljskVv8ZGWWfh/YUqMw=;
        b=jevinRKtvWp+7oVKsxwmq+aWFMaGbp6iXNKVFJVzJviaHzhRG+jDTdy+5kKaXDdikC
         hVqIj/aNCBzec254cwX5AZTCLq30rchwTEoRu8NGoEUahPmFPoqBttmKGkyL1IT60bx4
         7/qmt0/AArcsXecb6ingTQ53ap6HgVNnQ7JZr1rUZpAloMGE/n8z9tz3dYoBYlkUMMe2
         DLNkYyNfZZrHj8hYttKL8LqdFChiAqyT6xaP+eY5r47d1FZRkvVAvtlbR5HrkyEpql2U
         hWeH3dlg7JB6Pj7IEvpON+2t/R4makZWdWHyj3Nq+JNKK045Z8+z2RNLCb7KCTTO6a0Q
         6KxA==
X-Gm-Message-State: AC+VfDzdG05VYybFiQ4SemufSFnEs+apAwXEXJRdPyQDR56MJQofA0or
        Ze2A1kwHzoeBYm+YsQwhAeM=
X-Google-Smtp-Source: ACHHUZ6ezHv3tx9rmeRSfxfjUqDo7s7uCIkTkU9KBWVitZvprpU4aJm9/SQIKGWI1IBZgzK4ZXHN0Q==
X-Received: by 2002:a5d:4090:0:b0:2c5:3cd2:b8e with SMTP id o16-20020a5d4090000000b002c53cd20b8emr3731220wrp.1.1682695464169;
        Fri, 28 Apr 2023 08:24:24 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id i11-20020adfe48b000000b002c3f81c51b6sm21336588wrm.90.2023.04.28.08.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 08:24:23 -0700 (PDT)
Date:   Fri, 28 Apr 2023 16:24:22 +0100
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
Message-ID: <49ebb100-afd2-4810-b901-1a0f51f45cfc@lucifer.local>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <f60722d4-1474-4876-9291-5450c7192bd3@lucifer.local>
 <a8561203-a4f3-4b3d-338a-06a60541bd6b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8561203-a4f3-4b3d-338a-06a60541bd6b@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 05:13:07PM +0200, David Hildenbrand wrote:
> [...]
>
> > > This change has the potential to break existing setups. Simple example:
> > > libvirt domains configured for file-backed VM memory that also has a vfio
> > > device configured. It can easily be configured by users (evolving VM
> > > configuration, copy-paste etc.). And it works from a VM perspective, because
> > > the guest memory is essentially stale once the VM is shutdown and the pages
> > > were unpinned. At least we're not concerned about stale data on disk.
> > >
> > > With your changes, such VMs would no longer start, breaking existing user
> > > setups with a kernel update.
> >
> > Which vfio vm_ops are we talking about? vfio_pci_mmap_ops for example
> > doesn't specify page_mkwrite or pfn_mkwrite. Unless you mean some arbitrary
> > file system in the guest?
>
> Sorry, you define a VM to have its memory backed by VM memory and, at the
> same time, define a vfio-pci device for your VM, which will end up long-term
> pinning the VM memory.

Ah ack. Jason seemed concerned that this was already a broken case, I guess
that's one for you two to hash out...

>
> >
> > I may well be missing context on this so forgive me if I'm being a little
> > dumb here, but it'd be good to get a specific example.
>
> I was giving to little details ;)
>
> [...]
>
> > >
> > > I know, Jason und John will disagree, but I don't think we want to be very
> > > careful with changing the default.
> > >
> > > Sure, we could warn, or convert individual users using a flag (io_uring).
> > > But maybe we should invest more energy on a fix?
> >
> > This is proactively blocking a cleanup (eliminating vmas) that I believe
> > will be useful in moving things forward. I am not against an opt-in option
> > (I have been responding to community feedback in adapting my approach),
> > which is the way I implemented it all the way back then :)
>
> There are alternatives: just use a flag as Jason initially suggested and use
> that in io_uring code. Then, you can also bail out on the GUP-fast path as
> "cannot support it right now, never do GUP-fast".

I already implemented the alternatives (look back through revisions to see :)
and there were objections for various reasons.

Personally my preference is to provide a FOLL_SAFE_FILE_WRITE flag or such and
replace the FOLL_LONGTERM check with this (that'll automatically get rejected
for GUP-fast so the GUP-fast conundrum wouldn't be a thing either).

GUP-fast is a problem as you say,, but it feels like a fundamental issue with
GUP-fast as a whole since you don't get to look at a VMA since you can't take
the mmap_lock. You could just look at the folio->mapping once you've walked the
page tables and say 'I'm out' if FOLL_WRITE and it's non-anon if that's what
you're suggesting?

I'm not against that change but this being incremental, I think that would be a
further increment.

>
> IMHO, this patch is not a prereq.
>
> >
> > But given we know this is both entirely broken and a potential security
> > issue, and FOLL_LONGTERM is about as egregious as you can get (user
> > explicitly saying they'll hold write access indefinitely) I feel it is an
> > important improvement and makes clear that this is not an acceptable usage.
> >
> > I see Jason has said more on this also :)
> >
> > >
> > >
> > >
> > >
> > > > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> > > > ---
> > > >    include/linux/mm.h |  1 +
> > > >    mm/gup.c           | 41 ++++++++++++++++++++++++++++++++++++++++-
> > > >    mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
> > > >    3 files changed, 68 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > > index 37554b08bb28..f7da02fc89c6 100644
> > > > --- a/include/linux/mm.h
> > > > +++ b/include/linux/mm.h
> > > > @@ -2433,6 +2433,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
> > > >    #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
> > > >    					    MM_CP_UFFD_WP_RESOLVE)
> > > >
> > > > +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
> > > >    int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
> > > >    static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
> > > >    {
> > > > diff --git a/mm/gup.c b/mm/gup.c
> > > > index 1f72a717232b..d36a5db9feb1 100644
> > > > --- a/mm/gup.c
> > > > +++ b/mm/gup.c
> > > > @@ -959,16 +959,51 @@ static int faultin_page(struct vm_area_struct *vma,
> > > >    	return 0;
> > > >    }
> > > >
> > > > +/*
> > > > + * Writing to file-backed mappings which require folio dirty tracking using GUP
> > > > + * is a fundamentally broken operation, as kernel write access to GUP mappings
> > > > + * do not adhere to the semantics expected by a file system.
> > > > + *
> > > > + * Consider the following scenario:-
> > > > + *
> > > > + * 1. A folio is written to via GUP which write-faults the memory, notifying
> > > > + *    the file system and dirtying the folio.
> > > > + * 2. Later, writeback is triggered, resulting in the folio being cleaned and
> > > > + *    the PTE being marked read-only.
> > > > + * 3. The GUP caller writes to the folio, as it is mapped read/write via the
> > > > + *    direct mapping.
> > > > + * 4. The GUP caller, now done with the page, unpins it and sets it dirty
> > > > + *    (though it does not have to).
> > > > + *
> > > > + * This results in both data being written to a folio without writenotify, and
> > > > + * the folio being dirtied unexpectedly (if the caller decides to do so).
> > > > + */
> > > > +static bool writeable_file_mapping_allowed(struct vm_area_struct *vma,
> > > > +					   unsigned long gup_flags)
> > > > +{
> > > > +	/* If we aren't pinning then no problematic write can occur. */
> > > > +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
> > > > +		return true;
> > >
> > > FOLL_LONGTERM only applies to FOLL_PIN. This check can be dropped.
> >
> > I understand that of course (well maybe not of course, but I mean I do, I
> > have oodles of diagrams referencing this int he book :) This is intended to
> > document the fact that the check isn't relevant if we don't pin at all,
> > e.g. reading this you see:-
> >
> > - (implicit) if not writing or anon we're good
> > - if not pin we're good
> > - ok we are only currently checking one especially egregious case
> > - finally, perform the dirty tracking check.
> >
> > So this is intentional.
> >
> > >
> > > > +
> > > > +	/* We limit this check to the most egregious case - a long term pin. */
> > > > +	if (!(gup_flags & FOLL_LONGTERM))
> > > > +		return true;
> > > > +
> > > > +	/* If the VMA requires dirty tracking then GUP will be problematic. */
> > > > +	return vma_needs_dirty_tracking(vma);
> > > > +}
> > > > +
> > > >    static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
> > > >    {
> > > >    	vm_flags_t vm_flags = vma->vm_flags;
> > > >    	int write = (gup_flags & FOLL_WRITE);
> > > >    	int foreign = (gup_flags & FOLL_REMOTE);
> > > > +	bool vma_anon = vma_is_anonymous(vma);
> > > >
> > > >    	if (vm_flags & (VM_IO | VM_PFNMAP))
> > > >    		return -EFAULT;
> > > >
> > > > -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
> > > > +	if ((gup_flags & FOLL_ANON) && !vma_anon)
> > > >    		return -EFAULT;
> > > >
> > > >    	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
> > > > @@ -978,6 +1013,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
> > > >    		return -EFAULT;
> > > >
> > > >    	if (write) {
> > > > +		if (!vma_anon &&
> > > > +		    !writeable_file_mapping_allowed(vma, gup_flags))
> > > > +			return -EFAULT;
> > > > +
> > > >    		if (!(vm_flags & VM_WRITE)) {
> > > >    			if (!(gup_flags & FOLL_FORCE))
> > > >    				return -EFAULT;
> > > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > > index 536bbb8fa0ae..7b6344d1832a 100644
> > > > --- a/mm/mmap.c
> > >
> > >
> > > I'm probably missing something, why don't we have to handle GUP-fast (having
> > > said that, it's hard to handle ;) )? The sequence you describe above should
> > > apply to GUP-fast as well, no?
> > >
> > > 1) Pin writable mapped page using GUP-fast
> > > 2) Trigger writeback
> > > 3) Write to page via pin
> > > 4) Unpin and set dirty
> >
> > You're right, and this is an excellent point. I worry about other GUP use
> > cases too, but we're a bit out of luck there because we don't get to check
> > the VMA _at all_ (which opens yet another Pandora's box about how safe it
> > is to do unlocked pinning :)
> >
> > But again, this comes down to the fact we're trying to make things
> > _incrementally__ better rather than throwing our hands up and saying one
> > day my ship will come in...
>
> That's not how security fixes are supposed to work IMHO, sorry.

Sure, but I don't think the 'let things continue to be terribly broken for X
more years' is also a great approach.

Personally I come at this from the 'I just want my vmas patch series' unblocked
perspective :) and feel there's a functional aspect here too.

>
> --
> Thanks,
>
> David / dhildenb
>
>
