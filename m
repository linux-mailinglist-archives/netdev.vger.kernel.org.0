Return-Path: <netdev+bounces-174-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 081B36F5A11
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 16:31:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9CDF281654
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 14:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EC01D518;
	Wed,  3 May 2023 14:31:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53229D30C
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 14:31:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEB561A7
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683124302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jwgVjcmprHBa8NpoaXgJYiwFaH2ANM6d4RKcdmTha7o=;
	b=Q6GVcGKPxt+rIoCcPh5uo49BjKX5nle7EeNLjtrzy0yxPZ3f5jPupRmoQ4sjnEjtaZtXk6
	mzvojxlSlCryN10ACBb1NlaA6Et8TmHEWYQLbQVHXfyhh6E32tBTw3j9281u/PwsVJyu4u
	PDKMB8NxxzhVQJCVQRJ8obrTKTH8jAo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-fEhygVPfPymqLTBVZwLY6A-1; Wed, 03 May 2023 10:31:41 -0400
X-MC-Unique: fEhygVPfPymqLTBVZwLY6A-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f195129aa4so32209065e9.2
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 07:31:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683124300; x=1685716300;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jwgVjcmprHBa8NpoaXgJYiwFaH2ANM6d4RKcdmTha7o=;
        b=JHarzlu+8qYpqzGZq58c23XAmtMmZz2O1QQWOj316n0EvLOfxDkA8n34Oiw0JW96zs
         35NpNRllIt9IVOanhUcRayNn3VXNHYIDMZw346WJi6jaNRau6im+uejoBwnZU/VXbxAv
         vnUaJGllEoCiVjAsCoDFcmO+/4ME95Qaix+cPVfC+fzglAuVQizB2M3uzC2slWWALPUm
         vP9PZSXpbNcfh4+Gg+94KW9JnIBcJY7J81RFTkX2FK65jc4HuIoefmT9LEE/mFVfZHG9
         Ukx2EDPBZMWNBHwuGR+MRq0jiu+lLM2AiWNAUg+XOTRPtyT4UjqJASCS7svp3qyOxbD/
         PSNQ==
X-Gm-Message-State: AC+VfDwDOH7n0H1EdjztwSQwKfSgBibtGudK1OBTikgxV+M25OTPDmHp
	Z7MwYA6lyZkWFcHL0N1DQVSnbiwXTDqPhGGpUnBqT+RVpA2aSZ0uXnR58QISR9lMGyAB5/ot+Rk
	/yxPPumAuU82sd7cY
X-Received: by 2002:a05:600c:2212:b0:3f1:6ebe:d598 with SMTP id z18-20020a05600c221200b003f16ebed598mr14513961wml.7.1683124299688;
        Wed, 03 May 2023 07:31:39 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4p6NwKtGvfJuosY5ZRZTEXkZFFMya7KCf1fgffm+RPeC5ZQYEbm68OqBiXftYqckyaEdvrXA==
X-Received: by 2002:a05:600c:2212:b0:3f1:6ebe:d598 with SMTP id z18-20020a05600c221200b003f16ebed598mr14513907wml.7.1683124299231;
        Wed, 03 May 2023 07:31:39 -0700 (PDT)
Received: from ?IPV6:2003:cb:c711:6a00:9109:6424:1804:a441? (p200300cbc7116a00910964241804a441.dip0.t-ipconnect.de. [2003:cb:c711:6a00:9109:6424:1804:a441])
        by smtp.gmail.com with ESMTPSA id n3-20020a7bc5c3000000b003f0b1b8cd9bsm2116716wmk.4.2023.05.03.07.31.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 07:31:38 -0700 (PDT)
Message-ID: <aa326283-468f-6c40-4c47-de7cf7cc5994@redhat.com>
Date: Wed, 3 May 2023 16:31:36 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To: Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
 Matthew Wilcox <willy@infradead.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Leon Romanovsky <leon@kernel.org>, Christian Benvenuti <benve@cisco.com>,
 Nelson Escobar <neescoba@cisco.com>, Bernard Metzler <bmt@zurich.ibm.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
 Bjorn Topel <bjorn@kernel.org>, Magnus Karlsson <magnus.karlsson@intel.com>,
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 Jonathan Lemon <jonathan.lemon@gmail.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Christian Brauner <brauner@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
 bpf@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
 Jan Kara <jack@suse.cz>, "Kirill A . Shutemov" <kirill@shutemov.name>,
 Pavel Begunkov <asml.silence@gmail.com>, Mika Penttila
 <mpenttil@redhat.com>, Dave Chinner <david@fromorbit.com>,
 Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <cover.1683067198.git.lstoakes@gmail.com>
 <7ac8bb557517bcdc9225b4e4893a2ca7f603fcc4.1683067198.git.lstoakes@gmail.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v8 1/3] mm/mmap: separate writenotify and dirty tracking
 logic
In-Reply-To: <7ac8bb557517bcdc9225b4e4893a2ca7f603fcc4.1683067198.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 03.05.23 00:51, Lorenzo Stoakes wrote:
> vma_wants_writenotify() is specifically intended for setting PTE page table
> flags, accounting for existing page table flag state and whether the
> filesystem performs dirty tracking.
> 
> Separate out the notions of dirty tracking and PTE write notify checking in
> order that we can invoke the dirty tracking check from elsewhere.
> 
> Note that this change introduces a very small duplicate check of the
> separated out vm_ops_needs_writenotify() and vma_is_shared_writable()
> functions. This is necessary to avoid making vma_needs_dirty_tracking()
> needlessly complicated (e.g. passing flags or having it assume checks were
> already performed). This is small enough that it doesn't seem too
> egregious.
> 
> We check to ensure the mapping is shared writable, as any GUP caller will
> be safe - MAP_PRIVATE mappings will be CoW'd and read-only file-backed
> shared mappings are not permitted access, even with FOLL_FORCE.
> 
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   include/linux/mm.h |  1 +
>   mm/mmap.c          | 53 ++++++++++++++++++++++++++++++++++------------
>   2 files changed, 41 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 27ce77080c79..7b1d4e7393ef 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2422,6 +2422,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
>   #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>   					    MM_CP_UFFD_WP_RESOLVE)
>   
> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
>   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
>   static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
>   {
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 5522130ae606..fa7442e44cc2 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1475,6 +1475,42 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
>   }
>   #endif /* __ARCH_WANT_SYS_OLD_MMAP */
>   
> +/* Do VMA operations imply write notify is required? */

Nit: comment is superfluous, this is already self-documenting code.

> +static bool vm_ops_needs_writenotify(const struct vm_operations_struct *vm_ops)
> +{
> +	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
> +}
> +
> +/* Is this VMA shared and writable? */

Nit: dito

> +static bool vma_is_shared_writable(struct vm_area_struct *vma)
> +{
> +	return (vma->vm_flags & (VM_WRITE | VM_SHARED)) ==
> +		(VM_WRITE | VM_SHARED);
> +}
> +
> +/*
> + * Does this VMA require the underlying folios to have their dirty state
> + * tracked?
> + */

Nit: dito

> +bool vma_needs_dirty_tracking(struct vm_area_struct *vma)
> +{
> +	/* Only shared, writable VMAs require dirty tracking. */
> +	if (!vma_is_shared_writable(vma))
> +		return false;
> +
> +	/* Does the filesystem need to be notified? */
> +	if (vm_ops_needs_writenotify(vma->vm_ops))
> +		return true;
> +
> +	/* Specialty mapping? */
> +	if (vma->vm_flags & VM_PFNMAP)
> +		return false;
> +
> +	/* Can the mapping track the dirty pages? */
> +	return vma->vm_file && vma->vm_file->f_mapping &&
> +		mapping_can_writeback(vma->vm_file->f_mapping);
> +}
> +
>   /*
>    * Some shared mappings will want the pages marked read-only
>    * to track write events. If so, we'll downgrade vm_page_prot
> @@ -1483,21 +1519,18 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
>    */
>   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>   {
> -	vm_flags_t vm_flags = vma->vm_flags;
> -	const struct vm_operations_struct *vm_ops = vma->vm_ops;
> -
>   	/* If it was private or non-writable, the write bit is already clear */
> -	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
> +	if (!vma_is_shared_writable(vma))
>   		return 0;
>   
>   	/* The backer wishes to know when pages are first written to? */
> -	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
> +	if (vm_ops_needs_writenotify(vma->vm_ops))
>   		return 1;
>   
>   	/* The open routine did something to the protections that pgprot_modify
>   	 * won't preserve? */
>   	if (pgprot_val(vm_page_prot) !=
> -	    pgprot_val(vm_pgprot_modify(vm_page_prot, vm_flags)))
> +	    pgprot_val(vm_pgprot_modify(vm_page_prot, vma->vm_flags)))
>   		return 0;
>   
>   	/*
> @@ -1511,13 +1544,7 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
>   	if (userfaultfd_wp(vma))
>   		return 1;
>   
> -	/* Specialty mapping? */
> -	if (vm_flags & VM_PFNMAP)
> -		return 0;
> -
> -	/* Can the mapping track the dirty pages? */
> -	return vma->vm_file && vma->vm_file->f_mapping &&
> -		mapping_can_writeback(vma->vm_file->f_mapping);
> +	return vma_needs_dirty_tracking(vma);
>   }
>   
>   /*

We now have duplicate vma_is_shared_writable() and 
vm_ops_needs_writenotify() checks ...


Maybe move the VM_PFNMAP and "/* Can the mapping track the dirty pages? 
*/" checks into a separate helper and call that from both, 
vma_wants_writenotify() and vma_needs_dirty_tracking() ?


In any case

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb


