Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4536ED254
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 18:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbjDXQWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 12:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjDXQWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 12:22:54 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B151061AA;
        Mon, 24 Apr 2023 09:22:51 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f19afc4fd8so14435145e9.2;
        Mon, 24 Apr 2023 09:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682353370; x=1684945370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K9irG/bEix1+KYF9uk9pS9vmKl/P69dI5CwfK8xC0es=;
        b=eydec3O2ja1dxI+XATjI9Ts1t5kcce4wCBb/23eA0BeHR8vtXMDBiHeiI2LLHwaURd
         F7VnWL+iSlB2HDMUpwNQ+1kifrTBBUhRuqQXWzkIHqzXJCoNRJPhwq3tjogkC05w/81e
         EYVMW/gLGdzRwXV7R6key3VZ0yt7I8r4/F03dNY97+tnHoN8/EvCoVYkCiDboG1asOFp
         oqP3xgTYWbItxjJvKY4z2GkjXLRY/hxKzlar756DgiV8rjtU06PpdD4hC3eIbiK5HsQf
         Bxp2urd9ARKx71viPsZnVw/NnUVaHTrqFA5N/eUsCL5/NyaOkI9xDYZA1mv+KdAhmX9F
         hb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682353370; x=1684945370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K9irG/bEix1+KYF9uk9pS9vmKl/P69dI5CwfK8xC0es=;
        b=dL2RH/xrzmE1gKJOx4TnfBSlvjpFAroFcoAVohMe1D1XzFZzszJdOjXgMiqKbUM+V2
         3bgNAJhUTSJBta76jgW8qEzGEQiKg1zl36IptqQ7+YnCo38RgF1A3z1TEPXn2iRneAXY
         2R28qQPuU8KwVChqas4VFEdGzeZ0TqVxd8XRbj8UYa3QHpBoqpHKI+PSWuqFVYee3tdP
         risf2RVX1RsLEiEHkQNZFWYsoCI3HiRAZ0WjKjiuQ8otL4P9vpxy5+jiJIuL6pCHreGh
         vxtk60qQgDQ0RzKL1vB3ojXYampygHEugfSLjhX1KH2gJyzsG9+8h9XKQRtinwU7sPrV
         lrbA==
X-Gm-Message-State: AAQBX9fmjCGFgaBKhbcAodsEKgstx5iQ68z24PN0EVhUvYd4qwBvwvMz
        C3RvHp7c05qhQ5J9fszHPOY=
X-Google-Smtp-Source: AKy350YvqTY7MwAxZaVXYqGuI2LMKgwI1CmQIdgj1QgzYPrSJ/bV2wJcI9m2zxlbc9gUQti5KM56gw==
X-Received: by 2002:a05:600c:2103:b0:3f1:7fc0:4dbc with SMTP id u3-20020a05600c210300b003f17fc04dbcmr7879580wml.38.1682353369898;
        Mon, 24 Apr 2023 09:22:49 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id w9-20020a05600c474900b003f17e37ce60sm15986944wmo.47.2023.04.24.09.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 09:22:49 -0700 (PDT)
Date:   Mon, 24 Apr 2023 17:22:47 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jan Kara <jack@suse.cz>
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
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH] mm/gup: disallow GUP writing to file-backed mappings by
 default
Message-ID: <aa4b9159-523e-44d7-b66d-1e335c1521f9@lucifer.local>
References: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
 <20230424160952.bvii2ahgxss2chev@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424160952.bvii2ahgxss2chev@quack3>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 06:09:52PM +0200, Jan Kara wrote:
> On Sat 22-04-23 14:37:05, Lorenzo Stoakes wrote:
> > It isn't safe to write to file-backed mappings as GUP does not ensure that
> > the semantics associated with such a write are performed correctly, for
> > instance filesystems which rely upon write-notify will not be correctly
> > notified.
>
> I agree that this is currently subtly broken. But we also know from the bug
> reports there are definitely users of this functionality out in the wild.
> After all that was the reason why John Hubbard (added to CC) added
> FOLL_PIN functionality to the kernel - so that filesystems can recognize
> the pages may be modified behind their back and act accordingly.
>
> So I'm maybe missing a bigger picture why we would like a change like this.
> Because we still need to teach filesystems to handle pinned pages for the
> usecases you don't forbid and for which we know there are users and then
> what's the benefit of this patch?
>
> 								Honza

The concern is that it is more than subtly broken, at least in some
instances. The fact that there are use cases is reflected in the effort to
provide a flag, the purpose is to explicitly disallow broken behaviour in
all but those we know need it.

A motivating case is io_uring which performs its own equivalent check
precisely because GUP does not, which is clearly a broken state of affairs.

While folio_maybe_dma_pinned() definitely helps avoid some broken
situations, it certainly does not bring this pinned pages in line with
file semantics.

The current state of the discussion is leaning towards simply disallowing
this for FOLL_WRITE | FOLL_PIN | FOLL_LONGTERM file-backed mappings for
file systems with write notify, which really under no circumstances should
be occurring.

I will respin a v3 shortly which will be much simplified along these lines.

>
> > There are exceptions to this - shmem and hugetlb mappings are (in effect)
> > anonymous mappings by other names so we do permit this operation in these
> > cases.
> >
> > In addition, if no pinning takes place (neither FOLL_GET nor FOLL_PIN is
> > specified and neither flags gets implicitly set) then no writing can occur
> > so we do not perform the check in this instance.
> >
> > This is an important exception, as populate_vma_page_range() invokes
> > __get_user_pages() in this way (and thus so does __mm_populate(), used by
> > MAP_POPULATE mmap() and mlock() invocations).
> >
> > There are GUP users within the kernel that do nevertheless rely upon this
> > behaviour, so we introduce the FOLL_ALLOW_BROKEN_FILE_MAPPING flag to
> > explicitly permit this kind of GUP access.
> >
> > This is required in order to not break userspace in instances where the
> > uAPI might permit file-mapped addresses - a number of RDMA users require
> > this for instance, as do the process_vm_[read/write]v() system calls,
> > /proc/$pid/mem, ptrace and SDT uprobes. Each of these callers have been
> > updated to use this flag.
> >
> > Making this change is an important step towards a more reliable GUP, and
> > explicitly indicates which callers might encouter issues moving forward.
> >
> > Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> > ---
> >  drivers/infiniband/hw/qib/qib_user_pages.c |  3 +-
> >  drivers/infiniband/hw/usnic/usnic_uiom.c   |  2 +-
> >  drivers/infiniband/sw/siw/siw_mem.c        |  3 +-
> >  fs/proc/base.c                             |  3 +-
> >  include/linux/mm_types.h                   |  8 +++++
> >  kernel/events/uprobes.c                    |  3 +-
> >  mm/gup.c                                   | 36 +++++++++++++++++++++-
> >  mm/memory.c                                |  3 +-
> >  mm/process_vm_access.c                     |  2 +-
> >  net/xdp/xdp_umem.c                         |  2 +-
> >  10 files changed, 56 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
> > index f693bc753b6b..b9019dad8008 100644
> > --- a/drivers/infiniband/hw/qib/qib_user_pages.c
> > +++ b/drivers/infiniband/hw/qib/qib_user_pages.c
> > @@ -110,7 +110,8 @@ int qib_get_user_pages(unsigned long start_page, size_t num_pages,
> >  	for (got = 0; got < num_pages; got += ret) {
> >  		ret = pin_user_pages(start_page + got * PAGE_SIZE,
> >  				     num_pages - got,
> > -				     FOLL_LONGTERM | FOLL_WRITE,
> > +				     FOLL_LONGTERM | FOLL_WRITE |
> > +				     FOLL_ALLOW_BROKEN_FILE_MAPPING,
> >  				     p + got, NULL);
> >  		if (ret < 0) {
> >  			mmap_read_unlock(current->mm);
> > diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
> > index 2a5cac2658ec..33cf79b248a9 100644
> > --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
> > +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> > @@ -85,7 +85,7 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
> >  				int dmasync, struct usnic_uiom_reg *uiomr)
> >  {
> >  	struct list_head *chunk_list = &uiomr->chunk_list;
> > -	unsigned int gup_flags = FOLL_LONGTERM;
> > +	unsigned int gup_flags = FOLL_LONGTERM | FOLL_ALLOW_BROKEN_FILE_MAPPING;
> >  	struct page **page_list;
> >  	struct scatterlist *sg;
> >  	struct usnic_uiom_chunk *chunk;
> > diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
> > index f51ab2ccf151..bc3e8c0898e5 100644
> > --- a/drivers/infiniband/sw/siw/siw_mem.c
> > +++ b/drivers/infiniband/sw/siw/siw_mem.c
> > @@ -368,7 +368,8 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
> >  	struct mm_struct *mm_s;
> >  	u64 first_page_va;
> >  	unsigned long mlock_limit;
> > -	unsigned int foll_flags = FOLL_LONGTERM;
> > +	unsigned int foll_flags =
> > +		FOLL_LONGTERM | FOLL_ALLOW_BROKEN_FILE_MAPPING;
> >  	int num_pages, num_chunks, i, rv = 0;
> >
> >  	if (!can_do_mlock())
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index 96a6a08c8235..3e3f5ea9849f 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -855,7 +855,8 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
> >  	if (!mmget_not_zero(mm))
> >  		goto free;
> >
> > -	flags = FOLL_FORCE | (write ? FOLL_WRITE : 0);
> > +	flags = FOLL_FORCE | FOLL_ALLOW_BROKEN_FILE_MAPPING |
> > +		(write ? FOLL_WRITE : 0);
> >
> >  	while (count > 0) {
> >  		size_t this_len = min_t(size_t, count, PAGE_SIZE);
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 3fc9e680f174..e76637b4c78f 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -1185,6 +1185,14 @@ enum {
> >  	FOLL_PCI_P2PDMA = 1 << 10,
> >  	/* allow interrupts from generic signals */
> >  	FOLL_INTERRUPTIBLE = 1 << 11,
> > +	/*
> > +	 * By default we disallow write access to known broken file-backed
> > +	 * memory mappings (i.e. anything other than hugetlb/shmem
> > +	 * mappings). Some code may rely upon being able to access this
> > +	 * regardless for legacy reasons, thus we provide a flag to indicate
> > +	 * this.
> > +	 */
> > +	FOLL_ALLOW_BROKEN_FILE_MAPPING = 1 << 12,
> >
> >  	/* See also internal only FOLL flags in mm/internal.h */
> >  };
> > diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> > index 59887c69d54c..ec330d3b0218 100644
> > --- a/kernel/events/uprobes.c
> > +++ b/kernel/events/uprobes.c
> > @@ -373,7 +373,8 @@ __update_ref_ctr(struct mm_struct *mm, unsigned long vaddr, short d)
> >  		return -EINVAL;
> >
> >  	ret = get_user_pages_remote(mm, vaddr, 1,
> > -			FOLL_WRITE, &page, &vma, NULL);
> > +				    FOLL_WRITE | FOLL_ALLOW_BROKEN_FILE_MAPPING,
> > +				    &page, &vma, NULL);
> >  	if (unlikely(ret <= 0)) {
> >  		/*
> >  		 * We are asking for 1 page. If get_user_pages_remote() fails,
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 1f72a717232b..68d5570c0bae 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -959,16 +959,46 @@ static int faultin_page(struct vm_area_struct *vma,
> >  	return 0;
> >  }
> >
> > +/*
> > + * Writing to file-backed mappings using GUP is a fundamentally broken operation
> > + * as kernel write access to GUP mappings may not adhere to the semantics
> > + * expected by a file system.
> > + *
> > + * In most instances we disallow this broken behaviour, however there are some
> > + * exceptions to this enforced here.
> > + */
> > +static inline bool can_write_file_mapping(struct vm_area_struct *vma,
> > +					  unsigned long gup_flags)
> > +{
> > +	struct file *file = vma->vm_file;
> > +
> > +	/* If we aren't pinning then no problematic write can occur. */
> > +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
> > +		return true;
> > +
> > +	/* Special mappings should pose no problem. */
> > +	if (!file)
> > +		return true;
> > +
> > +	/* Has the caller explicitly indicated this case is acceptable? */
> > +	if (gup_flags & FOLL_ALLOW_BROKEN_FILE_MAPPING)
> > +		return true;
> > +
> > +	/* shmem and hugetlb mappings do not have problematic semantics. */
> > +	return vma_is_shmem(vma) || is_file_hugepages(file);
> > +}
> > +
> >  static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
> >  {
> >  	vm_flags_t vm_flags = vma->vm_flags;
> >  	int write = (gup_flags & FOLL_WRITE);
> >  	int foreign = (gup_flags & FOLL_REMOTE);
> > +	bool vma_anon = vma_is_anonymous(vma);
> >
> >  	if (vm_flags & (VM_IO | VM_PFNMAP))
> >  		return -EFAULT;
> >
> > -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
> > +	if ((gup_flags & FOLL_ANON) && !vma_anon)
> >  		return -EFAULT;
> >
> >  	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
> > @@ -978,6 +1008,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
> >  		return -EFAULT;
> >
> >  	if (write) {
> > +		if (!vma_anon &&
> > +		    WARN_ON_ONCE(!can_write_file_mapping(vma, gup_flags)))
> > +			return -EFAULT;
> > +
> >  		if (!(vm_flags & VM_WRITE)) {
> >  			if (!(gup_flags & FOLL_FORCE))
> >  				return -EFAULT;
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 146bb94764f8..e3d535991548 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5683,7 +5683,8 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr,
> >  	if (!mm)
> >  		return 0;
> >
> > -	ret = __access_remote_vm(mm, addr, buf, len, gup_flags);
> > +	ret = __access_remote_vm(mm, addr, buf, len,
> > +				 gup_flags | FOLL_ALLOW_BROKEN_FILE_MAPPING);
> >
> >  	mmput(mm);
> >
> > diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
> > index 78dfaf9e8990..ef126c08e89c 100644
> > --- a/mm/process_vm_access.c
> > +++ b/mm/process_vm_access.c
> > @@ -81,7 +81,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
> >  	ssize_t rc = 0;
> >  	unsigned long max_pages_per_loop = PVM_MAX_KMALLOC_PAGES
> >  		/ sizeof(struct pages *);
> > -	unsigned int flags = 0;
> > +	unsigned int flags = FOLL_ALLOW_BROKEN_FILE_MAPPING;
> >
> >  	/* Work out address and page range required */
> >  	if (len == 0)
> > diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> > index 02207e852d79..b93cfcaccb0d 100644
> > --- a/net/xdp/xdp_umem.c
> > +++ b/net/xdp/xdp_umem.c
> > @@ -93,7 +93,7 @@ void xdp_put_umem(struct xdp_umem *umem, bool defer_cleanup)
> >
> >  static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
> >  {
> > -	unsigned int gup_flags = FOLL_WRITE;
> > +	unsigned int gup_flags = FOLL_WRITE | FOLL_ALLOW_BROKEN_FILE_MAPPING;
> >  	long npgs;
> >  	int err;
> >
> > --
> > 2.40.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
