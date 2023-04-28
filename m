Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F399E6F1D3C
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 19:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345699AbjD1RNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 13:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjD1RNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 13:13:40 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A91E5B;
        Fri, 28 Apr 2023 10:13:38 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f19ab994ccso79528105e9.2;
        Fri, 28 Apr 2023 10:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682702017; x=1685294017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MbLAx2LnX50Pa8IRbgZc/5rCjh9gLR+XLmRDEwxwfQQ=;
        b=MgFkGaN0cnH0b8haF3jyGA/gT6J28ROImE4Hm1er1/GoWP+W8NS0vTcqtkG6nnlsDH
         LkIxopt/o9wa/x1WfqdTlwtelQ3MKUItziArUt/IFtkXc3xbC5soOyy3PPvfjgQP8NtL
         dahxELxKsd2OOb4gWyRjQ7K40/KdbXCM1Ps2Cgmg2ZU7l9k6KQQCis8+VfvfQMxg9+HR
         HIzpLMpW4lbSz7puqLP/iRlmOpjtRyV/tym86g8HQoa9OmmSRZMx64diBzIEQMorNTdu
         iSD9r+u8gpiH3tk/bbRcm0zPeap7VWRoCKOGY6nWuMt45Kv6KZHPK+ZUhwVhIJIBspKd
         M4kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682702017; x=1685294017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MbLAx2LnX50Pa8IRbgZc/5rCjh9gLR+XLmRDEwxwfQQ=;
        b=CnkPG1OomvGIh0XA4+7LMlzOUL+qjOqfHe4ek8OcYAiAystbT3gdcskoJAVWGfwUwM
         4veLlxUyxPupFqYSFbrDDSJ1tovWpUQjPbujnOdEQ46ISblbDmn7Pz6B01TY8CD8NxiE
         GqufCYq8mQVpxrywlU3hklU7liZPpBObWp3rMXChp5jMuyHSYEzr1sPHX0UAtGBh5VrG
         H/JWAJ+teNPZxhJEYyRqTvf4SiHvdfK2jztSCbI40TSU/cmn66diFolM5lNHoX8AGK/D
         VO+iw8YdOlIBLGZ+WZ6T3t+mmuMZKitxW4aKPVvBYFO10oIVyfCRALqHoyjtXafm6k25
         gMtA==
X-Gm-Message-State: AC+VfDwEUVtmvKLfkCQAPKi22GugBoZSQ1WtnQIZvs6vqK+I/DwnaTph
        yK9eJ1LqlCOhOq423N3SSCs=
X-Google-Smtp-Source: ACHHUZ4F0XmEmjF4UX1pBtKJCfhATbaw6EI/uToH7e476Qzq9nncg1VGRyPbJRFuphlobHXfV9JibQ==
X-Received: by 2002:a7b:cc94:0:b0:3f1:69cc:475b with SMTP id p20-20020a7bcc94000000b003f169cc475bmr4839212wma.36.1682702016993;
        Fri, 28 Apr 2023 10:13:36 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id x2-20020a5d60c2000000b002de9a0b0a20sm21439126wrt.113.2023.04.28.10.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 10:13:36 -0700 (PDT)
Date:   Fri, 28 Apr 2023 18:13:35 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
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
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <bd470e63-e2e0-4532-8aab-cffe326688b6@lucifer.local>
References: <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
 <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
 <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name>
 <ZEv2196tk5yWvgW5@x1n>
 <173337c0-14f4-3246-15ff-7fbf03861c94@redhat.com>
 <40fc128f-1978-42db-b9c1-77ac3c2cebfe@lucifer.local>
 <3d7fcfab-e445-1dc7-f000-9fbe7bea04c0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d7fcfab-e445-1dc7-f000-9fbe7bea04c0@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 07:05:38PM +0200, David Hildenbrand wrote:
> On 28.04.23 19:01, Lorenzo Stoakes wrote:
> > On Fri, Apr 28, 2023 at 06:51:46PM +0200, David Hildenbrand wrote:
> > > On 28.04.23 18:39, Peter Xu wrote:
> > > > On Fri, Apr 28, 2023 at 07:22:07PM +0300, Kirill A . Shutemov wrote:
> > > > > On Fri, Apr 28, 2023 at 06:13:03PM +0200, David Hildenbrand wrote:
> > > > > > On 28.04.23 18:09, Kirill A . Shutemov wrote:
> > > > > > > On Fri, Apr 28, 2023 at 05:43:52PM +0200, David Hildenbrand wrote:
> > > > > > > > On 28.04.23 17:34, David Hildenbrand wrote:
> > > > > > > > > On 28.04.23 17:33, Lorenzo Stoakes wrote:
> > > > > > > > > > On Fri, Apr 28, 2023 at 05:23:29PM +0200, David Hildenbrand wrote:
> > > > > > > > > > > > >
> > > > > > > > > > > > > Security is the primary case where we have historically closed uAPI
> > > > > > > > > > > > > items.
> > > > > > > > > > > >
> > > > > > > > > > > > As this patch
> > > > > > > > > > > >
> > > > > > > > > > > > 1) Does not tackle GUP-fast
> > > > > > > > > > > > 2) Does not take care of !FOLL_LONGTERM
> > > > > > > > > > > >
> > > > > > > > > > > > I am not convinced by the security argument in regard to this patch.
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > If we want to sells this as a security thing, we have to block it
> > > > > > > > > > > > *completely* and then CC stable.
> > > > > > > > > > >
> > > > > > > > > > > Regarding GUP-fast, to fix the issue there as well, I guess we could do
> > > > > > > > > > > something similar as I did in gup_must_unshare():
> > > > > > > > > > >
> > > > > > > > > > > If we're in GUP-fast (no VMA), and want to pin a !anon page writable,
> > > > > > > > > > > fallback to ordinary GUP. IOW, if we don't know, better be safe.
> > > > > > > > > >
> > > > > > > > > > How do we determine it's non-anon in the first place? The check is on the
> > > > > > > > > > VMA. We could do it by following page tables down to folio and checking
> > > > > > > > > > folio->mapping for PAGE_MAPPING_ANON I suppose?
> > > > > > > > >
> > > > > > > > > PageAnon(page) can be called from GUP-fast after grabbing a reference.
> > > > > > > > > See gup_must_unshare().
> > > > > > > >
> > > > > > > > IIRC, PageHuge() can also be called from GUP-fast and could special-case
> > > > > > > > hugetlb eventually, as it's table while we hold a (temporary) reference.
> > > > > > > > Shmem might be not so easy ...
> > > > > > >
> > > > > > > page->mapping->a_ops should be enough to whitelist whatever fs you want.
> > > > > > >
> > > > > >
> > > > > > The issue is how to stabilize that from GUP-fast, such that we can safely
> > > > > > dereference the mapping. Any idea?
> > > > > >
> > > > > > At least for anon page I know that page->mapping only gets cleared when
> > > > > > freeing the page, and we don't dereference the mapping but only check a
> > > > > > single flag stored alongside the mapping. Therefore, PageAnon() is fine in
> > > > > > GUP-fast context.
> > > > >
> > > > > What codepath you are worry about that clears ->mapping on pages with
> > > > > non-zero refcount?
> > > > >
> > > > > I can only think of truncate (and punch hole). READ_ONCE(page->mapping)
> > > > > and fail GUP_fast if it is NULL should be fine, no?
> > > > >
> > > > > I guess we should consider if the inode can be freed from under us and the
> > > > > mapping pointer becomes dangling. But I think we should be fine here too:
> > > > > VMA pins inode and VMA cannot go away from under GUP.
> > > >
> > > > Can vma still go away if during a fast-gup?
> > > >
> > >
> > > So, after we grabbed the page and made sure the the PTE didn't change (IOW,
> > > the PTE was stable while we processed it), the page can get unmapped (but
> > > not freed, because we hold a reference) and the VMA can theoretically go
> > > away (and as far as I understand, nothing stops the file from getting
> > > deleted, truncated etc).
> > >
> > > So we might be looking at folio->mapping and the VMA is no longer there.
> > > Maybe even the file is no longer there.
> > >
> >
> > This shouldn't be an issue though right? Because after a pup call unlocks the
> > mmap_lock we're in the same situation anyway. GUP doesn't generally guarantee
> > the mapping remains valid, only pinning the underlying folio.
>
> Yes. But the issue here is rather dereferencing something that has already
> been freed, eventually leading to undefined behavior.
>

Is that an issue with interrupts disabled though? Will block page tables being
removed and as Kirill says (sorry I maybe misinterpreted you) we should be ok.

> Maybe de-referencing folio->mapping is fine ... but yes, we could handle
> that optimization in a separate patch.
>
> --
> Thanks,
>
> David / dhildenb
>
