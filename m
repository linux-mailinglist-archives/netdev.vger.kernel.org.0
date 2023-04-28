Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A706F1D18
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 19:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjD1RCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 13:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346252AbjD1RCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 13:02:09 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF035BB2;
        Fri, 28 Apr 2023 10:01:52 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f315735514so69202265e9.1;
        Fri, 28 Apr 2023 10:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682701311; x=1685293311;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=enibV5jjvXXD+9T0mSZmRELNc6TJEPGRaHEL3xkjr4g=;
        b=p47hnQpCoSM2raO5h30nylblO+/gxiJKCQD4btAglQ9CVgvJRUjuLfC1c1uxOqpitm
         FRBmjW/dhR42vlOrBxqJNRzVVCe9g6EsGxHWGaAPdz5a1HWBktWoWwGlnMtLDGxfjr/A
         7uozTl4sgpFn1DAWMH4C8Zf71Gs72fKu7Ka6lSUniFHBPCeL4oO86PN2UdaYocqUvhlX
         xIRTRED2ja+mCxPZ0EkYzvAIgyduZELL7qBLnfsl1i858L/QBFL82SqirmzF7aUZJ7qa
         oPB2nVQrLvRoweIXd1v34bvYYKOkyOSX3Pa7u2e+4wccJFyYfOmuq0dE2wI/b6zRKcpb
         tIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682701311; x=1685293311;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=enibV5jjvXXD+9T0mSZmRELNc6TJEPGRaHEL3xkjr4g=;
        b=XCkSy2urCM8tIQNS6OtbjBPqAihzEsJxQGnqVi9KsMEsXa1WzPwgVspBAguoO4qEZS
         GA1sO0TiTd4jPXWsTlnzxfWLRZux5/BPf3EaHGzHDXlE0rdDmmQDOMkbqZfc9Yccp2Lu
         MNG6lgCDyLuQWgQoU/NEmykdG6wvjyNsA9zAXSJGO+z2wFmON2y97ze5CGYxy7eJ9Ttx
         dE1hE6D9tq2RijfBqxuwSEbKkU3qP/Ru73D2CZcOoVwAVvtnAHgwsWe5BkiYFO0hLRwY
         KdhVG1rLNMTJrYbJJjUc0bRLwEv+a0XELSF2ioDox6G/wSw0fFQAyueSD5rH5jxQhRpN
         qzQw==
X-Gm-Message-State: AC+VfDyYT9zq5LxI3fTrJqhjXCWHwsCNmILx6UFL4npsXsD5onrxhkQj
        fi75qcG8xzHg1a6wskK8MTc=
X-Google-Smtp-Source: ACHHUZ5eOFK7TLniTEYeQwmHoBHsJdnADKkJSXPamAdlOt4aeVyQGuBN9SqvNz189bRBjMlijDd4GA==
X-Received: by 2002:a05:600c:2281:b0:3f1:72db:454c with SMTP id 1-20020a05600c228100b003f172db454cmr4718172wmf.19.1682701310816;
        Fri, 28 Apr 2023 10:01:50 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id iv18-20020a05600c549200b003f17b91c3adsm28870445wmb.28.2023.04.28.10.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Apr 2023 10:01:50 -0700 (PDT)
Date:   Fri, 28 Apr 2023 18:01:49 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     "Kirill A . Shutemov" <kirill@shutemov.name>
Cc:     David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
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
Message-ID: <3604708a-bf24-4c39-a257-771b93ae70c0@lucifer.local>
References: <400da248-a14e-46a4-420a-a3e075291085@redhat.com>
 <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
 <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
 <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name>
 <ZEv2196tk5yWvgW5@x1n>
 <173337c0-14f4-3246-15ff-7fbf03861c94@redhat.com>
 <20230428165623.pqchgi5gtfhxd5b5@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428165623.pqchgi5gtfhxd5b5@box.shutemov.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 07:56:23PM +0300, Kirill A . Shutemov wrote:
> On Fri, Apr 28, 2023 at 06:51:46PM +0200, David Hildenbrand wrote:
> > On 28.04.23 18:39, Peter Xu wrote:
> > > On Fri, Apr 28, 2023 at 07:22:07PM +0300, Kirill A . Shutemov wrote:
> > > > On Fri, Apr 28, 2023 at 06:13:03PM +0200, David Hildenbrand wrote:
> > > > > On 28.04.23 18:09, Kirill A . Shutemov wrote:
> > > > > > On Fri, Apr 28, 2023 at 05:43:52PM +0200, David Hildenbrand wrote:
> > > > > > > On 28.04.23 17:34, David Hildenbrand wrote:
> > > > > > > > On 28.04.23 17:33, Lorenzo Stoakes wrote:
> > > > > > > > > On Fri, Apr 28, 2023 at 05:23:29PM +0200, David Hildenbrand wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > Security is the primary case where we have historically closed uAPI
> > > > > > > > > > > > items.
> > > > > > > > > > >
> > > > > > > > > > > As this patch
> > > > > > > > > > >
> > > > > > > > > > > 1) Does not tackle GUP-fast
> > > > > > > > > > > 2) Does not take care of !FOLL_LONGTERM
> > > > > > > > > > >
> > > > > > > > > > > I am not convinced by the security argument in regard to this patch.
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > If we want to sells this as a security thing, we have to block it
> > > > > > > > > > > *completely* and then CC stable.
> > > > > > > > > >
> > > > > > > > > > Regarding GUP-fast, to fix the issue there as well, I guess we could do
> > > > > > > > > > something similar as I did in gup_must_unshare():
> > > > > > > > > >
> > > > > > > > > > If we're in GUP-fast (no VMA), and want to pin a !anon page writable,
> > > > > > > > > > fallback to ordinary GUP. IOW, if we don't know, better be safe.
> > > > > > > > >
> > > > > > > > > How do we determine it's non-anon in the first place? The check is on the
> > > > > > > > > VMA. We could do it by following page tables down to folio and checking
> > > > > > > > > folio->mapping for PAGE_MAPPING_ANON I suppose?
> > > > > > > >
> > > > > > > > PageAnon(page) can be called from GUP-fast after grabbing a reference.
> > > > > > > > See gup_must_unshare().
> > > > > > >
> > > > > > > IIRC, PageHuge() can also be called from GUP-fast and could special-case
> > > > > > > hugetlb eventually, as it's table while we hold a (temporary) reference.
> > > > > > > Shmem might be not so easy ...
> > > > > >
> > > > > > page->mapping->a_ops should be enough to whitelist whatever fs you want.
> > > > > >
> > > > >
> > > > > The issue is how to stabilize that from GUP-fast, such that we can safely
> > > > > dereference the mapping. Any idea?
> > > > >
> > > > > At least for anon page I know that page->mapping only gets cleared when
> > > > > freeing the page, and we don't dereference the mapping but only check a
> > > > > single flag stored alongside the mapping. Therefore, PageAnon() is fine in
> > > > > GUP-fast context.
> > > >
> > > > What codepath you are worry about that clears ->mapping on pages with
> > > > non-zero refcount?
> > > >
> > > > I can only think of truncate (and punch hole). READ_ONCE(page->mapping)
> > > > and fail GUP_fast if it is NULL should be fine, no?
> > > >
> > > > I guess we should consider if the inode can be freed from under us and the
> > > > mapping pointer becomes dangling. But I think we should be fine here too:
> > > > VMA pins inode and VMA cannot go away from under GUP.
> > >
> > > Can vma still go away if during a fast-gup?
> > >
> >
> > So, after we grabbed the page and made sure the the PTE didn't change (IOW,
> > the PTE was stable while we processed it), the page can get unmapped (but
> > not freed, because we hold a reference) and the VMA can theoretically go
> > away (and as far as I understand, nothing stops the file from getting
> > deleted, truncated etc).
> >
> > So we might be looking at folio->mapping and the VMA is no longer there.
> > Maybe even the file is no longer there.
>
> No. VMA cannot get away before PTEs are unmapped and TLB is flushed. And
> TLB flushing is serialized against GUP_fast().
>

But the lockless path doesn't hold the PTL? So PTE can disappear at anytime,
since we use ptep_get_lockless().

But it won't matter because then the fast path will just fail anyway and can
revert back to slow one.

> --
>   Kiryl Shutsemau / Kirill A. Shutemov
