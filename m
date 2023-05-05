Return-Path: <netdev+bounces-633-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E94AD6F8A90
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 23:13:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70A05280EA6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 21:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AC7FD2FF;
	Fri,  5 May 2023 21:12:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F22AC2E4;
	Fri,  5 May 2023 21:12:52 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8A6525D;
	Fri,  5 May 2023 14:12:49 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-2fe3fb8e25fso1560913f8f.0;
        Fri, 05 May 2023 14:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683321168; x=1685913168;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ivGNSditmdzeyn97THXeuK5ctfSInTGF99RwYTHxIyU=;
        b=Se4RPOYgOfoiULFR7wuPRZx0PsUzRm5UV2nhzweK+31TUkjUE6hKIdXlZgE09l+KRu
         lRwdl2KESe9bIc7ePbVexlK589ChfPZjGVTj6cw9jl2YhiUNWUWigagPt2ir8DoQefZD
         T+j1ZcJzgqjcHyyPs/nRMUHX+VNVayUJHgnywRuBRa+NpWNWtksGrDjfcUOR+7zXYEeK
         0A7cuMoIOjMgMsgPWidsQ6IMbMhgdb2YllCI0JNK1bU+uvsVJJKjtrmp2sImuntq/wMT
         HAZExBVApKK+sE7XsIFEHYMN+XbHQ1Ctx0rwgWlpooKzIDjA9Ox1W0DLx6oz4zcqQMLi
         uPXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683321168; x=1685913168;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ivGNSditmdzeyn97THXeuK5ctfSInTGF99RwYTHxIyU=;
        b=Es6DK2AepcOx/ib44iqCJVZ8pCHpAJ8TfPDEbC2FsfKfh5ILJUKgkclL7uvp9lC22U
         x3S1dL2Pcne6HOGk8eVgKwINCU+qszKoE+mPmoA6uvqw+w8fgDuwBlgHZhJjg864mX16
         mj2NFA/1kv6tfLHvEqXPtekiMdPfEOGl8Ft3xbNW5n6FXpn0Gi6HNHltmutplLDB7NT0
         vRgx9T92uLivT+bQ5kiFAzwPifnjxU6kEZ5NHT6BUhexUTnZ8HStH/K1ZUXOHw2evvjg
         Jqbgq/2bCk/XNVjF8Fql+aXny9MDCY55L2J+pY8hyFZYEGuumAOKeMd+gaG+o9zTZiR8
         6GnQ==
X-Gm-Message-State: AC+VfDzR7sK4kHGORvkD+7J1Is911yxTLVzjwr6Ao09kVEa5TIA+5UzW
	jV9DTWFJB3Js0u9EXJVIJLw=
X-Google-Smtp-Source: ACHHUZ4PoDkiooUQXPtEqVD0dJPVF0uY7rTGd+8/bIp0RwQ/+pfrOoEqfDcAJezNAwrh0MAE+evlug==
X-Received: by 2002:adf:e987:0:b0:306:64b7:5413 with SMTP id h7-20020adfe987000000b0030664b75413mr2160113wrm.71.1683321167903;
        Fri, 05 May 2023 14:12:47 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id l8-20020a5d4bc8000000b0030631f199f9sm3354382wrt.34.2023.05.05.14.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 14:12:46 -0700 (PDT)
Date: Fri, 5 May 2023 22:12:45 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
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
Subject: Re: [PATCH v9 0/3] mm/gup: disallow GUP writing to file-backed
 mappings by default
Message-ID: <69c4a74f-18bc-4efe-89ac-a7ddf8f8d0a1@lucifer.local>
References: <cover.1683235180.git.lstoakes@gmail.com>
 <6e96358e-bcb5-cc36-18c3-ec5153867b9a@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e96358e-bcb5-cc36-18c3-ec5153867b9a@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 10:21:21PM +0200, David Hildenbrand wrote:
> On 04.05.23 23:27, Lorenzo Stoakes wrote:
> > Writing to file-backed mappings which require folio dirty tracking using
> > GUP is a fundamentally broken operation, as kernel write access to GUP
> > mappings do not adhere to the semantics expected by a file system.
> >
> > A GUP caller uses the direct mapping to access the folio, which does not
> > cause write notify to trigger, nor does it enforce that the caller marks
> > the folio dirty.
> >
> > The problem arises when, after an initial write to the folio, writeback
> > results in the folio being cleaned and then the caller, via the GUP
> > interface, writes to the folio again.
> >
> > As a result of the use of this secondary, direct, mapping to the folio no
> > write notify will occur, and if the caller does mark the folio dirty, this
> > will be done so unexpectedly.
> >
> > For example, consider the following scenario:-
> >
> > 1. A folio is written to via GUP which write-faults the memory, notifying
> >     the file system and dirtying the folio.
> > 2. Later, writeback is triggered, resulting in the folio being cleaned and
> >     the PTE being marked read-only.
> > 3. The GUP caller writes to the folio, as it is mapped read/write via the
> >     direct mapping.
> > 4. The GUP caller, now done with the page, unpins it and sets it dirty
> >     (though it does not have to).
> >
> > This change updates both the PUP FOLL_LONGTERM slow and fast APIs. As
> > pin_user_pages_fast_only() does not exist, we can rely on a slightly
> > imperfect whitelisting in the PUP-fast case and fall back to the slow case
> > should this fail.
> >
> >
>
> Thanks a lot, this looks pretty good to me!

Thanks!

>
> I started writing some selftests (assuming none would be in the works) using
> iouring and and the gup_tests interface. So far, no real surprises for the general
> GUP interaction [1].
>

Nice! I was using the cow selftests as just looking for something that
touches FOLL_LONGTERM with PUP_fast, I hacked it so it always wrote just to
test patches but clearly we need something more thorough.

>
> There are two things I noticed when registering an iouring fixed buffer (that differ
> now from generic gup_test usage):
>
>
> (1) Registering a fixed buffer targeting an unsupported MAP_SHARED FS file now fails with
>     EFAULT (from pin_user_pages()) instead of EOPNOTSUPP (from io_pin_pages()).
>
> The man page for io_uring_register documents:
>
>        EOPNOTSUPP
>               User buffers point to file-backed memory.
>
> ... we'd have to do some kind of errno translation in io_pin_pages(). But the
> translation is not simple (sometimes we want to forward EOPNOTSUPP). That also
> applies once we remove that special-casing in io_uring code.
>
> ... maybe we can simply update the manpage (stating that older kernels returned
> EOPNOTSUPP) and start returning EFAULT?

Yeah I noticed this discrepancy when going through initial attempts to
refactor in the vmas patch series, I wonder how important it is to
differentiate? I have a feeling it probably doesn't matter too much but
obviously need input from Jens and Pavel.

>
>
> (2) Registering a fixed buffer targeting a MAP_PRIVATE FS file fails with EOPNOTSUPP
>     (from io_pin_pages()). As discussed, there is nothing wrong with pinning all-anon
>     pages (resulting from breaking COW).
>
> That could be easily be handled (allow any !VM_MAYSHARE), and would automatically be
> handled once removing the iouring special-casing.

The entire intent of this series (for me :)) was to allow io_uring to just
drop this code altogether so we can unblock my drop the 'vmas' parameter
from GUP series [1].

I always intended to respin that after this settled down, Jens and Pavel
seemed onboard with this (and really they shouldn't need to be doing that
check, that was always a failing in GUP).

I will do a v5 of this soon.

[1]: https://lore.kernel.org/all/cover.1681831798.git.lstoakes@gmail.com/

>
>
> [1]
>
> # ./pin_longterm
> # [INFO] detected hugetlb size: 2048 KiB
> # [INFO] detected hugetlb size: 1048576 KiB
> TAP version 13
> 1..50
> # [RUN] R/W longterm GUP pin in MAP_SHARED file mapping ... with memfd
> ok 1 Pinning succeeded as expected
> # [RUN] R/W longterm GUP pin in MAP_SHARED file mapping ... with tmpfile
> ok 2 Pinning succeeded as expected
> # [RUN] R/W longterm GUP pin in MAP_SHARED file mapping ... with local tmpfile
> ok 3 Pinning failed as expected
> # [RUN] R/W longterm GUP pin in MAP_SHARED file mapping ... with memfd hugetlb (2048 kB)
> ok 4 # SKIP need more free huge pages
> # [RUN] R/W longterm GUP pin in MAP_SHARED file mapping ... with memfd hugetlb (1048576 kB)
> ok 5 Pinning succeeded as expected
> # [RUN] R/W longterm GUP-fast pin in MAP_SHARED file mapping ... with memfd
> ok 6 Pinning succeeded as expected
> # [RUN] R/W longterm GUP-fast pin in MAP_SHARED file mapping ... with tmpfile
> ok 7 Pinning succeeded as expected
> # [RUN] R/W longterm GUP-fast pin in MAP_SHARED file mapping ... with local tmpfile
> ok 8 Pinning failed as expected
> # [RUN] R/W longterm GUP-fast pin in MAP_SHARED file mapping ... with memfd hugetlb (2048 kB)
> ok 9 # SKIP need more free huge pages
> # [RUN] R/W longterm GUP-fast pin in MAP_SHARED file mapping ... with memfd hugetlb (1048576 kB)
> ok 10 Pinning succeeded as expected
> # [RUN] R/O longterm GUP pin in MAP_SHARED file mapping ... with memfd
> ok 11 Pinning succeeded as expected
> # [RUN] R/O longterm GUP pin in MAP_SHARED file mapping ... with tmpfile
> ok 12 Pinning succeeded as expected
> # [RUN] R/O longterm GUP pin in MAP_SHARED file mapping ... with local tmpfile
> ok 13 Pinning succeeded as expected
> # [RUN] R/O longterm GUP pin in MAP_SHARED file mapping ... with memfd hugetlb (2048 kB)
> ok 14 # SKIP need more free huge pages
> # [RUN] R/O longterm GUP pin in MAP_SHARED file mapping ... with memfd hugetlb (1048576 kB)
> ok 15 Pinning succeeded as expected
> # [RUN] R/O longterm GUP-fast pin in MAP_SHARED file mapping ... with memfd
> ok 16 Pinning succeeded as expected
> # [RUN] R/O longterm GUP-fast pin in MAP_SHARED file mapping ... with tmpfile
> ok 17 Pinning succeeded as expected
> # [RUN] R/O longterm GUP-fast pin in MAP_SHARED file mapping ... with local tmpfile
> ok 18 Pinning succeeded as expected
> # [RUN] R/O longterm GUP-fast pin in MAP_SHARED file mapping ... with memfd hugetlb (2048 kB)
> ok 19 # SKIP need more free huge pages
> # [RUN] R/O longterm GUP-fast pin in MAP_SHARED file mapping ... with memfd hugetlb (1048576 kB)
> ok 20 Pinning succeeded as expected
> # [RUN] R/W longterm GUP pin in MAP_PRIVATE file mapping ... with memfd
> ok 21 Pinning succeeded as expected
> # [RUN] R/W longterm GUP pin in MAP_PRIVATE file mapping ... with tmpfile
> ok 22 Pinning succeeded as expected
> # [RUN] R/W longterm GUP pin in MAP_PRIVATE file mapping ... with local tmpfile
> ok 23 Pinning succeeded as expected
> # [RUN] R/W longterm GUP pin in MAP_PRIVATE file mapping ... with memfd hugetlb (2048 kB)
> ok 24 # SKIP need more free huge pages
> # [RUN] R/W longterm GUP pin in MAP_PRIVATE file mapping ... with memfd hugetlb (1048576 kB)
> ok 25 Pinning succeeded as expected
> # [RUN] R/W longterm GUP-fast pin in MAP_PRIVATE file mapping ... with memfd
> ok 26 Pinning succeeded as expected
> # [RUN] R/W longterm GUP-fast pin in MAP_PRIVATE file mapping ... with tmpfile
> ok 27 Pinning succeeded as expected
> # [RUN] R/W longterm GUP-fast pin in MAP_PRIVATE file mapping ... with local tmpfile
> ok 28 Pinning succeeded as expected
> # [RUN] R/W longterm GUP-fast pin in MAP_PRIVATE file mapping ... with memfd hugetlb (2048 kB)
> ok 29 # SKIP need more free huge pages
> # [RUN] R/W longterm GUP-fast pin in MAP_PRIVATE file mapping ... with memfd hugetlb (1048576 kB)
> ok 30 Pinning succeeded as expected
> # [RUN] R/O longterm GUP pin in MAP_PRIVATE file mapping ... with memfd
> ok 31 Pinning succeeded as expected
> # [RUN] R/O longterm GUP pin in MAP_PRIVATE file mapping ... with tmpfile
> ok 32 Pinning succeeded as expected
> # [RUN] R/O longterm GUP pin in MAP_PRIVATE file mapping ... with local tmpfile
> ok 33 Pinning succeeded as expected
> # [RUN] R/O longterm GUP pin in MAP_PRIVATE file mapping ... with memfd hugetlb (2048 kB)
> ok 34 # SKIP need more free huge pages
> # [RUN] R/O longterm GUP pin in MAP_PRIVATE file mapping ... with memfd hugetlb (1048576 kB)
> ok 35 Pinning succeeded as expected
> # [RUN] R/O longterm GUP-fast pin in MAP_PRIVATE file mapping ... with memfd
> ok 36 Pinning succeeded as expected
> # [RUN] R/O longterm GUP-fast pin in MAP_PRIVATE file mapping ... with tmpfile
> ok 37 Pinning succeeded as expected
> # [RUN] R/O longterm GUP-fast pin in MAP_PRIVATE file mapping ... with local tmpfile
> ok 38 Pinning succeeded as expected
> # [RUN] R/O longterm GUP-fast pin in MAP_PRIVATE file mapping ... with memfd hugetlb (2048 kB)
> ok 39 # SKIP need more free huge pages
> # [RUN] R/O longterm GUP-fast pin in MAP_PRIVATE file mapping ... with memfd hugetlb (1048576 kB)
> ok 40 Pinning succeeded as expected
> # [RUN] iouring fixed buffer with MAP_SHARED file mapping ... with memfd
> ok 41 Pinning succeeded as expected
> # [RUN] iouring fixed buffer with MAP_SHARED file mapping ... with tmpfile
> ok 42 Pinning succeeded as expected
> # [RUN] iouring fixed buffer with MAP_SHARED file mapping ... with local tmpfile
> ok 43 Pinning failed as expected
> # [RUN] iouring fixed buffer with MAP_SHARED file mapping ... with memfd hugetlb (2048 kB)
> ok 44 # SKIP need more free huge pages
> # [RUN] iouring fixed buffer with MAP_SHARED file mapping ... with memfd hugetlb (1048576 kB)
> ok 45 Pinning succeeded as expected
> # [RUN] iouring fixed buffer with MAP_PRIVATE file mapping ... with memfd
> ok 46 Pinning succeeded as expected
> # [RUN] iouring fixed buffer with MAP_PRIVATE file mapping ... with tmpfile
> ok 47 Pinning succeeded as expected
> # [RUN] iouring fixed buffer with MAP_PRIVATE file mapping ... with local tmpfile
> not ok 48 Pinning failed as expected
> # [RUN] iouring fixed buffer with MAP_PRIVATE file mapping ... with memfd hugetlb (2048 kB)
> ok 49 # SKIP need more free huge pages
> # [RUN] iouring fixed buffer with MAP_PRIVATE file mapping ... with memfd hugetlb (1048576 kB)
> ok 50 Pinning succeeded as expected
> Bail out! 1 out of 50 tests failed
> # Totals: pass:39 fail:1 xfail:0 xpass:0 skip:10 error:0
>
>
> --
> Thanks,
>
> David / dhildenb
>

