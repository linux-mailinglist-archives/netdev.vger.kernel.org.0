Return-Path: <netdev+bounces-317-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15F616F70B1
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:17:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17F53280DCB
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7A82BA31;
	Thu,  4 May 2023 17:17:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E987E7
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 17:17:19 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1E74225;
	Thu,  4 May 2023 10:17:17 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-50bcb00a4c2so1255348a12.1;
        Thu, 04 May 2023 10:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683220636; x=1685812636;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U2WuUou8YNL9Xp5WPJi0n6sPZ6G3kepjeD9YD/gQ+RQ=;
        b=I4tkKjcK+DCRLRIlqzczRjordUh+ogvbdiMmZfqh502Thdtfi/q7aT76ekiU4iHRdZ
         t1qVdUm0eYnur4o4d/BlTW8GiV9O6MJmiZigOqKlA4IT1Za7YOCjgc4lEvyyPPFNfT0S
         y3+SV7UjlabcX1EAKJhbDB4QrxqS2f20o6yFKxlVBQcgEJUTmzcxrxkS3sZ3WvseR/Pe
         Zl5fslr3SlxUnjd/Zup3Mijs3tlwakD0ubIfURE5AVo+V3qtwfWJ0oM1rXhjsOHZ3i+0
         dtWfq17zIiCZFJtalZQp1oNrmh0p2DvSzGHyV4WLoKaBR2DtUfDBLLbjghuLSbrFuwms
         xz7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683220636; x=1685812636;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U2WuUou8YNL9Xp5WPJi0n6sPZ6G3kepjeD9YD/gQ+RQ=;
        b=cHFOCKJZFp7t8FjXrvmSdYac39m+0I0WFCADNAlOAj/SbMsYV7Cl2crF/lqHze6Mco
         QkP/dhfor5tJRIoU3oibAFyNgmOH/TnmaN9ij4z8Xjj9fYem4EtbnqIcZ/FS8V+3/7GN
         9a3inFReZB/EcsFwWXmdn8rmOCb+bDqi2pQn3UE/mCODxR8OxEcseXzm5BIgWTWHMEUo
         WgUgk74mD2YZKeVAn3529u9mNWFTqyNo3Do5rbd29njFIJC3u2BBUZLgHII+IUf53Wre
         Nnls9IE3kSymJ8UDZqJmtPm35rfTzsC4iXtlRPyZ09YPkexdAL7Ftm07HqlzZ/J/oPPY
         MDTg==
X-Gm-Message-State: AC+VfDx80R5bAZzwaQnzWIgYdMxBoXl08HEnTAdF8anRiUZ+3s+fe+ri
	oqUiIkQ8+xDxiHpZF9gporA=
X-Google-Smtp-Source: ACHHUZ7hS0chlKJeb03YkuEHvrnLPRAC5OTXgIMbm4mSuuciM4Jg7fOaKJrWsPZEeSVaDWtycXLbRw==
X-Received: by 2002:a17:907:a426:b0:94a:9c9e:6885 with SMTP id sg38-20020a170907a42600b0094a9c9e6885mr7729969ejc.58.1683220635964;
        Thu, 04 May 2023 10:17:15 -0700 (PDT)
Received: from localhost ([2a00:23ee:19a0:5577:d26d:e6d:b920:1ba2])
        by smtp.gmail.com with ESMTPSA id fx21-20020a170906b75500b009531d9efcc4sm18900677ejb.133.2023.05.04.10.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 10:17:14 -0700 (PDT)
Date: Thu, 4 May 2023 18:17:13 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
	Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bjorn Topel <bjorn@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	netdev@vger.kernel.org, bpf@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	"Kirill A . Shutemov" <kirill@shutemov.name>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mika Penttila <mpenttil@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v8 1/3] mm/mmap: separate writenotify and dirty tracking
 logic
Message-ID: <ZFPomZbCUSmoLIid@murray>
References: <cover.1683067198.git.lstoakes@gmail.com>
 <7ac8bb557517bcdc9225b4e4893a2ca7f603fcc4.1683067198.git.lstoakes@gmail.com>
 <aa326283-468f-6c40-4c47-de7cf7cc5994@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aa326283-468f-6c40-4c47-de7cf7cc5994@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 03, 2023 at 04:31:36PM +0200, David Hildenbrand wrote:
> On 03.05.23 00:51, Lorenzo Stoakes wrote:
> > vma_wants_writenotify() is specifically intended for setting PTE page table
> > flags, accounting for existing page table flag state and whether the
> > filesystem performs dirty tracking.
> >
> > Separate out the notions of dirty tracking and PTE write notify checking in
> > order that we can invoke the dirty tracking check from elsewhere.
> >
> > Note that this change introduces a very small duplicate check of the
> > separated out vm_ops_needs_writenotify() and vma_is_shared_writable()
> > functions. This is necessary to avoid making vma_needs_dirty_tracking()
> > needlessly complicated (e.g. passing flags or having it assume checks were
> > already performed). This is small enough that it doesn't seem too
> > egregious.
> >
> > We check to ensure the mapping is shared writable, as any GUP caller will
> > be safe - MAP_PRIVATE mappings will be CoW'd and read-only file-backed
> > shared mappings are not permitted access, even with FOLL_FORCE.
> >
> > Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> > Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> > Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >   include/linux/mm.h |  1 +
> >   mm/mmap.c          | 53 ++++++++++++++++++++++++++++++++++------------
> >   2 files changed, 41 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 27ce77080c79..7b1d4e7393ef 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2422,6 +2422,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
> >   #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
> >   					    MM_CP_UFFD_WP_RESOLVE)
> > +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
> >   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
> >   static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
> >   {
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 5522130ae606..fa7442e44cc2 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1475,6 +1475,42 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
> >   }
> >   #endif /* __ARCH_WANT_SYS_OLD_MMAP */
> > +/* Do VMA operations imply write notify is required? */
>
> Nit: comment is superfluous, this is already self-documenting code.
>
> > +static bool vm_ops_needs_writenotify(const struct vm_operations_struct *vm_ops)
> > +{
> > +	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
> > +}
> > +
> > +/* Is this VMA shared and writable? */
>
> Nit: dito
>
> > +static bool vma_is_shared_writable(struct vm_area_struct *vma)
> > +{
> > +	return (vma->vm_flags & (VM_WRITE | VM_SHARED)) ==
> > +		(VM_WRITE | VM_SHARED);
> > +}
> > +
> > +/*
> > + * Does this VMA require the underlying folios to have their dirty state
> > + * tracked?
> > + */
>
> Nit: dito
>

Ack, was just trying to follow the pattern of comments on these helpers but
you're right, these aren't adding anything will strip.

> > +bool vma_needs_dirty_tracking(struct vm_area_struct *vma)
> > +{
> > +	/* Only shared, writable VMAs require dirty tracking. */
> > +	if (!vma_is_shared_writable(vma))
> > +		return false;
> > +
> > +	/* Does the filesystem need to be notified? */
> > +	if (vm_ops_needs_writenotify(vma->vm_ops))
> > +		return true;
> > +
> > +	/* Specialty mapping? */
> > +	if (vma->vm_flags & VM_PFNMAP)
> > +		return false;
> > +
> > +	/* Can the mapping track the dirty pages? */
> > +	return vma->vm_file && vma->vm_file->f_mapping &&
> > +		mapping_can_writeback(vma->vm_file->f_mapping);
> > +}
> > +
> >   /*
> >    * Some shared mappings will want the pages marked read-only
> >    * to track write events. If so, we'll downgrade vm_page_prot
> > @@ -1483,21 +1519,18 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
> >    */
> >   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
> >   {
> > -	vm_flags_t vm_flags = vma->vm_flags;
> > -	const struct vm_operations_struct *vm_ops = vma->vm_ops;
> > -
> >   	/* If it was private or non-writable, the write bit is already clear */
> > -	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
> > +	if (!vma_is_shared_writable(vma))
> >   		return 0;
> >   	/* The backer wishes to know when pages are first written to? */
> > -	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
> > +	if (vm_ops_needs_writenotify(vma->vm_ops))
> >   		return 1;
> >   	/* The open routine did something to the protections that pgprot_modify
> >   	 * won't preserve? */
> >   	if (pgprot_val(vm_page_prot) !=
> > -	    pgprot_val(vm_pgprot_modify(vm_page_prot, vm_flags)))
> > +	    pgprot_val(vm_pgprot_modify(vm_page_prot, vma->vm_flags)))
> >   		return 0;
> >   	/*
> > @@ -1511,13 +1544,7 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
> >   	if (userfaultfd_wp(vma))
> >   		return 1;
> > -	/* Specialty mapping? */
> > -	if (vm_flags & VM_PFNMAP)
> > -		return 0;
> > -
> > -	/* Can the mapping track the dirty pages? */
> > -	return vma->vm_file && vma->vm_file->f_mapping &&
> > -		mapping_can_writeback(vma->vm_file->f_mapping);
> > +	return vma_needs_dirty_tracking(vma);
> >   }
> >   /*
>
> We now have duplicate vma_is_shared_writable() and
> vm_ops_needs_writenotify() checks ...
>

Yes, this is noted in the commit message.

>
> Maybe move the VM_PFNMAP and "/* Can the mapping track the dirty pages? */"
> checks into a separate helper and call that from both,
> vma_wants_writenotify() and vma_needs_dirty_tracking() ?

I'll try to juggle it a bit more, the whole reason I'm doing these very
annoying duplications is because of the ordering and precedence of the
checks in both and wanting to avoid some hideious passing of flags or
splitting into too many bits or returning a non-bool value etc.

Will try to improve it in respin.

>
>
> In any case
>
> Acked-by: David Hildenbrand <david@redhat.com>
>

Thanks!

> --
> Thanks,
>
> David / dhildenb
>

