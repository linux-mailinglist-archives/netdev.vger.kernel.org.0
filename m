Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC9C6F48E9
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 19:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbjEBRJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 13:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbjEBRJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 13:09:19 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4A2AB;
        Tue,  2 May 2023 10:09:18 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-2f7db354092so2547448f8f.2;
        Tue, 02 May 2023 10:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683047356; x=1685639356;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gDM4DO3TbkRL3r8IKhcmVsV7m/y1S1/C/3x0ontbi30=;
        b=i+Ng0svdbjvDz1lU1l9oIS0x0EA11QMmwFOFitHGKRiM43QlOtWkKU0hY0Wfdcw2VC
         qKmLjZ3YTZRUzcb8DpjLz1C1aVhCEfv2AiLR2PidmVAfbisNEPMEJD7T11Cjm6V0j2qV
         OPzJ0R8I0moMTXA0GQeoWhzKPav3yvaX9dsvS99xspaIb2zr0tlLFodP62ffsXdp5Yn5
         GtxZ3CQn8XTbv0skW4BbfKpsRnMi/9O3HqdEYcpdQ6ogwMNuen5Omd0vKURs3DEamOy8
         EkmyOsBLGiuzYnHV+oxhTz1r4oqQUsZSGKJRZ2Pa92PMlXCAv3hbvO7bL5Mc/Peyj7iR
         GCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683047357; x=1685639357;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gDM4DO3TbkRL3r8IKhcmVsV7m/y1S1/C/3x0ontbi30=;
        b=ZiHCCgJhndn9QbGw0nJ1BFztNyfwqufJqf48E3gcVp1AVhkXmfRtotG5gE/fPreDcK
         ErG/99shDgetbP7uxX6jwblHju99c2XPwpnEctvonBlX7HSPJnrWBXvYPXhC3nz2edm/
         UTz5pSKAa7DYHz7CjpJ1YSCz8sL1hauhv8W+PJbUFHq6HmgQbWUuIB/jB9LFjMfd566q
         V0DHgDgR34sItx5CoVVkgGvJiiywFFQ0j4j9oqZXpvCFFcnM7dTYHR6RsG7JvCKeu+h3
         g2GKUVUD+5Y4PBfe0EoCab52wyCnFdo5GoO2NOu0ovaXkL4/GvhK1M76H+uoXHQ7+/Pl
         r6zA==
X-Gm-Message-State: AC+VfDxlA3V0SZD3gmI6Jh9GI8WCDY7vZ0DjVSqUQA5SeCkycqGwjY99
        zJ4XcCHPbIr8Gmvg7+MDHOw33wQe7XNiCA==
X-Google-Smtp-Source: ACHHUZ67SZ98oJMphSxIhf0uSE7eN4Ao8YqWJiz9F+C/o0E3hx9WQ6hyoZ7xmQUSgxWHDuBu53CiFw==
X-Received: by 2002:a5d:6d4b:0:b0:2f5:8e8b:572c with SMTP id k11-20020a5d6d4b000000b002f58e8b572cmr12254538wri.49.1683047356442;
        Tue, 02 May 2023 10:09:16 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id g2-20020a5d5402000000b002da75c5e143sm31378906wrv.29.2023.05.02.10.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 10:09:15 -0700 (PDT)
Date:   Tue, 2 May 2023 18:09:14 +0100
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
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v7 1/3] mm/mmap: separate writenotify and dirty tracking
 logic
Message-ID: <bf04a98a-9de6-4532-a36c-59572d22dd7c@lucifer.local>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <72a90af5a9e4445a33ae44efa710f112c2694cb1.1683044162.git.lstoakes@gmail.com>
 <56696a72-24fa-958e-e6a1-7a17c9e54081@redhat.com>
 <f777a151-edfc-4882-8aca-9a926179c5bb@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f777a151-edfc-4882-8aca-9a926179c5bb@lucifer.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 05:53:46PM +0100, Lorenzo Stoakes wrote:
> On Tue, May 02, 2023 at 06:38:53PM +0200, David Hildenbrand wrote:
> > On 02.05.23 18:34, Lorenzo Stoakes wrote:
> > > vma_wants_writenotify() is specifically intended for setting PTE page table
> > > flags, accounting for existing PTE flag state and whether that might
> > > already be read-only while mixing this check with a check whether the
> > > filesystem performs dirty tracking.
> > >
> > > Separate out the notions of dirty tracking and a PTE write notify checking
> > > in order that we can invoke the dirty tracking check from elsewhere.
> > >
> > > Note that this change introduces a very small duplicate check of the
> > > separated out vm_ops_needs_writenotify(). This is necessary to avoid making
> > > vma_needs_dirty_tracking() needlessly complicated (e.g. passing a
> > > check_writenotify flag or having it assume this check was already
> > > performed). This is such a small check that it doesn't seem too egregious
> > > to do this.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> > > Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> > > Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >   include/linux/mm.h |  1 +
> > >   mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
> > >   2 files changed, 28 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 27ce77080c79..7b1d4e7393ef 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -2422,6 +2422,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
> > >   #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
> > >   					    MM_CP_UFFD_WP_RESOLVE)
> > > +bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
> > >   int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
> > >   static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
> > >   {
> > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > index 5522130ae606..295c5f2e9bd9 100644
> > > --- a/mm/mmap.c
> > > +++ b/mm/mmap.c
> > > @@ -1475,6 +1475,31 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
> > >   }
> > >   #endif /* __ARCH_WANT_SYS_OLD_MMAP */
> > > +/* Do VMA operations imply write notify is required? */
> > > +static bool vm_ops_needs_writenotify(const struct vm_operations_struct *vm_ops)
> > > +{
> > > +	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
> > > +}
> > > +
> > > +/*
> > > + * Does this VMA require the underlying folios to have their dirty state
> > > + * tracked?
> > > + */
> > > +bool vma_needs_dirty_tracking(struct vm_area_struct *vma)
> > > +{
> >
> > Sorry for not noticing this earlier, but ...
>
> pints_owed++
>
> >
> > what about MAP_PRIVATE mappings? When we write, we populate an anon page,
> > which will work as expected ... because we don't have to notify the fs?
> >
> > I think you really also want the "If it was private or non-writable, the
> > write bit is already clear */" part as well and remove "false" in that case.
> >
>
> Not sure a 'write bit is already clear' case is relevant to checking
> whether a filesystem dirty tracks? That seems specific entirely to the page
> table bits.
>
> That's why I didn't include it,
>
> A !VM_WRITE shouldn't be GUP-writable except for FOLL_FORCE, and that
> surely could be problematic if VM_MAYWRITE later?
>
> Thinking about it though a !VM_SHARE should probably can be safely assumed
> to not be dirty-trackable, so we probably do need to add a check for
> !VM_SHARED -> !vma_needs_dirty_tracking
>

On second thoughts, we explicitly check FOLL_FORCE && !is_cow_mapping() in
check_vma_flags() so that case cannot occur.

So actually yes we should probably include this on the basis of that and
the fact that a FOLL_WRITE operation will CoW the MAP_PRIVATE mapping.

This was an (over)abundance of caution.

Will fix on respin.

> > Or was there a good reason to disallow private mappings as well?
> >
>
> Until the page is CoW'd walking the page tables will get you to the page
> cache page right? This was the reason I (perhaps rather too quickly) felt
> MAP_PRIVATE should be excluded.
>
> However a FOLL_WRITE would trigger CoW... and then we'd be trivially OK.
>
> So yeah, ok perhaps I dismissed that a little too soon. I was concerned
> about some sort of egregious FOLL_FORCE case where somehow we'd end up with
> the page cache folio. But actually, that probably can't happen...
>
> > --
> > Thanks,
> >
> > David / dhildenb
> >
