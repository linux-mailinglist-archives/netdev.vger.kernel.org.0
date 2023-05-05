Return-Path: <netdev+bounces-630-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15B066F8A1B
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 22:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C767228108C
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 20:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 295A7D2EF;
	Fri,  5 May 2023 20:21:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFA3BE73
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 20:21:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F8144B4
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 13:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683318087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fsggkaMmsBvOy5xyONdITFWw/iHmRz4dl3tGfhzjtDI=;
	b=AsFjbdPgh+Wyv+dUSCHG+cSIT9hLp+oJwF4hPJY2dVon5WDio+pwNGjk+unG7FAgvlM4IQ
	ziM3qZQPg5Tn2FVyf044sYxkLxz7CiktUkFs1DRSRcPLwSs6xh0sihQk3diC05DRR/tFlC
	KECQzO7obsc3ZKb/H5PrvPPlARgxFfA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-cQZzOYecNdqN_ATYtB-zQw-1; Fri, 05 May 2023 16:21:26 -0400
X-MC-Unique: cQZzOYecNdqN_ATYtB-zQw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-2f8c2258b48so785010f8f.1
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 13:21:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683318085; x=1685910085;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fsggkaMmsBvOy5xyONdITFWw/iHmRz4dl3tGfhzjtDI=;
        b=N3yNuYJkWN3WZLkLtRFf314b0kvilkPdfSPHvRBv4nvEh954yE3MQ4ksJ9pEcoAAgD
         3mbdxx/CMh9dK/JY+Sn166ugQzYy7rvQUTUSAagMbt/OShjZ5paxZzx3FcYS/PsUTc3S
         k+izWUMKdRvA2WO6kBEEDBY66aqVIbftzbchctq3So4QwEr+Yo286dEH/S52Nfes9Tl7
         dr9HwF1kSdgmKDDeK0gcWjfV0YBhMtjN/OJ46VggqR2Wea4LWy3tBWGUxZwHcaIKfePB
         ieVJi/bOMirEZT59Hhc1bvzTvghMhzRLw0VwrHhnvtGqEUEGQlhWlzwsW3ZQhuOE5L1A
         Ndag==
X-Gm-Message-State: AC+VfDwQHGXOl9ZCxMIS8QAh8jl0cB/aHY+8sWQ/ZuahZoi5D+9+9SUB
	FzEBNLWmPRFqHvfBBnu/+wn2izBaBH+37zagZxJyL/c5DE5E+AAnj9H2zbXaGu1c25WNmw7oTuD
	AJvGqRk/fy3wAVoAj
X-Received: by 2002:a5d:4570:0:b0:2fe:c0ea:18b5 with SMTP id a16-20020a5d4570000000b002fec0ea18b5mr2183567wrc.35.1683318085030;
        Fri, 05 May 2023 13:21:25 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7FviCLOGbcNtThAkyINVmphT4Em0kBlGhMilbIRI+JzZwkEaqvefxxGYCQlWMeGdaho0noZA==
X-Received: by 2002:a5d:4570:0:b0:2fe:c0ea:18b5 with SMTP id a16-20020a5d4570000000b002fec0ea18b5mr2183541wrc.35.1683318084651;
        Fri, 05 May 2023 13:21:24 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71f:6900:2b25:fc69:599e:3986? (p200300cbc71f69002b25fc69599e3986.dip0.t-ipconnect.de. [2003:cb:c71f:6900:2b25:fc69:599e:3986])
        by smtp.gmail.com with ESMTPSA id q18-20020a056000137200b003063176ef09sm3377323wrz.6.2023.05.05.13.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 May 2023 13:21:24 -0700 (PDT)
Message-ID: <6e96358e-bcb5-cc36-18c3-ec5153867b9a@redhat.com>
Date: Fri, 5 May 2023 22:21:21 +0200
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
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Jens Axboe <axboe@kernel.dk>
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
References: <cover.1683235180.git.lstoakes@gmail.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v9 0/3] mm/gup: disallow GUP writing to file-backed
 mappings by default
In-Reply-To: <cover.1683235180.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 04.05.23 23:27, Lorenzo Stoakes wrote:
> Writing to file-backed mappings which require folio dirty tracking using
> GUP is a fundamentally broken operation, as kernel write access to GUP
> mappings do not adhere to the semantics expected by a file system.
> 
> A GUP caller uses the direct mapping to access the folio, which does not
> cause write notify to trigger, nor does it enforce that the caller marks
> the folio dirty.
> 
> The problem arises when, after an initial write to the folio, writeback
> results in the folio being cleaned and then the caller, via the GUP
> interface, writes to the folio again.
> 
> As a result of the use of this secondary, direct, mapping to the folio no
> write notify will occur, and if the caller does mark the folio dirty, this
> will be done so unexpectedly.
> 
> For example, consider the following scenario:-
> 
> 1. A folio is written to via GUP which write-faults the memory, notifying
>     the file system and dirtying the folio.
> 2. Later, writeback is triggered, resulting in the folio being cleaned and
>     the PTE being marked read-only.
> 3. The GUP caller writes to the folio, as it is mapped read/write via the
>     direct mapping.
> 4. The GUP caller, now done with the page, unpins it and sets it dirty
>     (though it does not have to).
> 
> This change updates both the PUP FOLL_LONGTERM slow and fast APIs. As
> pin_user_pages_fast_only() does not exist, we can rely on a slightly
> imperfect whitelisting in the PUP-fast case and fall back to the slow case
> should this fail.
> 
>

Thanks a lot, this looks pretty good to me!

I started writing some selftests (assuming none would be in the works) using
iouring and and the gup_tests interface. So far, no real surprises for the general
GUP interaction [1].


There are two things I noticed when registering an iouring fixed buffer (that differ
now from generic gup_test usage):


(1) Registering a fixed buffer targeting an unsupported MAP_SHARED FS file now fails with
     EFAULT (from pin_user_pages()) instead of EOPNOTSUPP (from io_pin_pages()).

The man page for io_uring_register documents:

        EOPNOTSUPP
               User buffers point to file-backed memory.

... we'd have to do some kind of errno translation in io_pin_pages(). But the
translation is not simple (sometimes we want to forward EOPNOTSUPP). That also
applies once we remove that special-casing in io_uring code.

... maybe we can simply update the manpage (stating that older kernels returned
EOPNOTSUPP) and start returning EFAULT?


(2) Registering a fixed buffer targeting a MAP_PRIVATE FS file fails with EOPNOTSUPP
     (from io_pin_pages()). As discussed, there is nothing wrong with pinning all-anon
     pages (resulting from breaking COW).

That could be easily be handled (allow any !VM_MAYSHARE), and would automatically be
handled once removing the iouring special-casing.


[1]

# ./pin_longterm
# [INFO] detected hugetlb size: 2048 KiB
# [INFO] detected hugetlb size: 1048576 KiB
TAP version 13
1..50
# [RUN] R/W longterm GUP pin in MAP_SHARED file mapping ... with memfd
ok 1 Pinning succeeded as expected
# [RUN] R/W longterm GUP pin in MAP_SHARED file mapping ... with tmpfile
ok 2 Pinning succeeded as expected
# [RUN] R/W longterm GUP pin in MAP_SHARED file mapping ... with local tmpfile
ok 3 Pinning failed as expected
# [RUN] R/W longterm GUP pin in MAP_SHARED file mapping ... with memfd hugetlb (2048 kB)
ok 4 # SKIP need more free huge pages
# [RUN] R/W longterm GUP pin in MAP_SHARED file mapping ... with memfd hugetlb (1048576 kB)
ok 5 Pinning succeeded as expected
# [RUN] R/W longterm GUP-fast pin in MAP_SHARED file mapping ... with memfd
ok 6 Pinning succeeded as expected
# [RUN] R/W longterm GUP-fast pin in MAP_SHARED file mapping ... with tmpfile
ok 7 Pinning succeeded as expected
# [RUN] R/W longterm GUP-fast pin in MAP_SHARED file mapping ... with local tmpfile
ok 8 Pinning failed as expected
# [RUN] R/W longterm GUP-fast pin in MAP_SHARED file mapping ... with memfd hugetlb (2048 kB)
ok 9 # SKIP need more free huge pages
# [RUN] R/W longterm GUP-fast pin in MAP_SHARED file mapping ... with memfd hugetlb (1048576 kB)
ok 10 Pinning succeeded as expected
# [RUN] R/O longterm GUP pin in MAP_SHARED file mapping ... with memfd
ok 11 Pinning succeeded as expected
# [RUN] R/O longterm GUP pin in MAP_SHARED file mapping ... with tmpfile
ok 12 Pinning succeeded as expected
# [RUN] R/O longterm GUP pin in MAP_SHARED file mapping ... with local tmpfile
ok 13 Pinning succeeded as expected
# [RUN] R/O longterm GUP pin in MAP_SHARED file mapping ... with memfd hugetlb (2048 kB)
ok 14 # SKIP need more free huge pages
# [RUN] R/O longterm GUP pin in MAP_SHARED file mapping ... with memfd hugetlb (1048576 kB)
ok 15 Pinning succeeded as expected
# [RUN] R/O longterm GUP-fast pin in MAP_SHARED file mapping ... with memfd
ok 16 Pinning succeeded as expected
# [RUN] R/O longterm GUP-fast pin in MAP_SHARED file mapping ... with tmpfile
ok 17 Pinning succeeded as expected
# [RUN] R/O longterm GUP-fast pin in MAP_SHARED file mapping ... with local tmpfile
ok 18 Pinning succeeded as expected
# [RUN] R/O longterm GUP-fast pin in MAP_SHARED file mapping ... with memfd hugetlb (2048 kB)
ok 19 # SKIP need more free huge pages
# [RUN] R/O longterm GUP-fast pin in MAP_SHARED file mapping ... with memfd hugetlb (1048576 kB)
ok 20 Pinning succeeded as expected
# [RUN] R/W longterm GUP pin in MAP_PRIVATE file mapping ... with memfd
ok 21 Pinning succeeded as expected
# [RUN] R/W longterm GUP pin in MAP_PRIVATE file mapping ... with tmpfile
ok 22 Pinning succeeded as expected
# [RUN] R/W longterm GUP pin in MAP_PRIVATE file mapping ... with local tmpfile
ok 23 Pinning succeeded as expected
# [RUN] R/W longterm GUP pin in MAP_PRIVATE file mapping ... with memfd hugetlb (2048 kB)
ok 24 # SKIP need more free huge pages
# [RUN] R/W longterm GUP pin in MAP_PRIVATE file mapping ... with memfd hugetlb (1048576 kB)
ok 25 Pinning succeeded as expected
# [RUN] R/W longterm GUP-fast pin in MAP_PRIVATE file mapping ... with memfd
ok 26 Pinning succeeded as expected
# [RUN] R/W longterm GUP-fast pin in MAP_PRIVATE file mapping ... with tmpfile
ok 27 Pinning succeeded as expected
# [RUN] R/W longterm GUP-fast pin in MAP_PRIVATE file mapping ... with local tmpfile
ok 28 Pinning succeeded as expected
# [RUN] R/W longterm GUP-fast pin in MAP_PRIVATE file mapping ... with memfd hugetlb (2048 kB)
ok 29 # SKIP need more free huge pages
# [RUN] R/W longterm GUP-fast pin in MAP_PRIVATE file mapping ... with memfd hugetlb (1048576 kB)
ok 30 Pinning succeeded as expected
# [RUN] R/O longterm GUP pin in MAP_PRIVATE file mapping ... with memfd
ok 31 Pinning succeeded as expected
# [RUN] R/O longterm GUP pin in MAP_PRIVATE file mapping ... with tmpfile
ok 32 Pinning succeeded as expected
# [RUN] R/O longterm GUP pin in MAP_PRIVATE file mapping ... with local tmpfile
ok 33 Pinning succeeded as expected
# [RUN] R/O longterm GUP pin in MAP_PRIVATE file mapping ... with memfd hugetlb (2048 kB)
ok 34 # SKIP need more free huge pages
# [RUN] R/O longterm GUP pin in MAP_PRIVATE file mapping ... with memfd hugetlb (1048576 kB)
ok 35 Pinning succeeded as expected
# [RUN] R/O longterm GUP-fast pin in MAP_PRIVATE file mapping ... with memfd
ok 36 Pinning succeeded as expected
# [RUN] R/O longterm GUP-fast pin in MAP_PRIVATE file mapping ... with tmpfile
ok 37 Pinning succeeded as expected
# [RUN] R/O longterm GUP-fast pin in MAP_PRIVATE file mapping ... with local tmpfile
ok 38 Pinning succeeded as expected
# [RUN] R/O longterm GUP-fast pin in MAP_PRIVATE file mapping ... with memfd hugetlb (2048 kB)
ok 39 # SKIP need more free huge pages
# [RUN] R/O longterm GUP-fast pin in MAP_PRIVATE file mapping ... with memfd hugetlb (1048576 kB)
ok 40 Pinning succeeded as expected
# [RUN] iouring fixed buffer with MAP_SHARED file mapping ... with memfd
ok 41 Pinning succeeded as expected
# [RUN] iouring fixed buffer with MAP_SHARED file mapping ... with tmpfile
ok 42 Pinning succeeded as expected
# [RUN] iouring fixed buffer with MAP_SHARED file mapping ... with local tmpfile
ok 43 Pinning failed as expected
# [RUN] iouring fixed buffer with MAP_SHARED file mapping ... with memfd hugetlb (2048 kB)
ok 44 # SKIP need more free huge pages
# [RUN] iouring fixed buffer with MAP_SHARED file mapping ... with memfd hugetlb (1048576 kB)
ok 45 Pinning succeeded as expected
# [RUN] iouring fixed buffer with MAP_PRIVATE file mapping ... with memfd
ok 46 Pinning succeeded as expected
# [RUN] iouring fixed buffer with MAP_PRIVATE file mapping ... with tmpfile
ok 47 Pinning succeeded as expected
# [RUN] iouring fixed buffer with MAP_PRIVATE file mapping ... with local tmpfile
not ok 48 Pinning failed as expected
# [RUN] iouring fixed buffer with MAP_PRIVATE file mapping ... with memfd hugetlb (2048 kB)
ok 49 # SKIP need more free huge pages
# [RUN] iouring fixed buffer with MAP_PRIVATE file mapping ... with memfd hugetlb (1048576 kB)
ok 50 Pinning succeeded as expected
Bail out! 1 out of 50 tests failed
# Totals: pass:39 fail:1 xfail:0 xpass:0 skip:10 error:0


-- 
Thanks,

David / dhildenb


