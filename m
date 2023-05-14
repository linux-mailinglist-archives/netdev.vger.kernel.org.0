Return-Path: <netdev+bounces-2435-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6FD701F35
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 21:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9799F1C209BC
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 19:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6264EBA24;
	Sun, 14 May 2023 19:20:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409501877;
	Sun, 14 May 2023 19:20:12 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260B9E6F;
	Sun, 14 May 2023 12:20:10 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-30796c0cbcaso8254919f8f.1;
        Sun, 14 May 2023 12:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684092007; x=1686684007;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nODLkN3MsrdfKf/UAkqWHH+G5vP9gT0pKV8dR/DBu4s=;
        b=RDeF3wZRRt16EUG/SiYqKwSADKhumymGx1P92RXpCWJEihqbIAjCclHt6h5mkTO7pD
         T5XFBgMo/0pOlgZKSGzUdM5dVZBn6RlZtdNSUILDCuSMt8wMUCADU4uU7tUMV5esO0gN
         6ZKy02c5iPWnkatFiRS1BtzqwbMqPC03616pW70FyCISKY64mjDDdtYNV61AaCRd8GqE
         B+Ag52Ac22GWgZum4sdq7Gt3IYJBnwpffpv3Sidbf7VFUuK2E/8wlLhGnjoYccqNCrc8
         xHUgfuGtmVfJdQTrr/zu09e9f3xi2UKSAjE4ItYpNxeZX7I568I+F7BO6c1BXPtEl6n0
         c71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684092007; x=1686684007;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nODLkN3MsrdfKf/UAkqWHH+G5vP9gT0pKV8dR/DBu4s=;
        b=AtRp+86RR8sDiqPSh8GUbvDVPSieQBGBvCqj3xH6xz7UHqU2eHVSkWPaTlbwmb8blw
         Q5SVPVMiwL/rI6yZcpejlb4dYopU927OG8eIILOsDESxNvA9RyTNOmchPq3tPo3qzhQm
         Fz+5yCvHJFPYQ5qKuxHSKDy9QjCPNg9eLc5a1WgHRRtjTBJI9dl6zqt5WLG5RKYnuARj
         D6J/7X1SWN5O1ZZyVti3zkF531AWadXcOk9kZEegzlbybURYInt21n+xSjDuZdTu+ZsO
         3rJWeYnot0C/l8ym9YZ+vwzGz59vaGbB0frfwpi23816jTm9Kl231YsMlFfDCn1cWimE
         bZFA==
X-Gm-Message-State: AC+VfDz5c1FzT4p9XdCTnBVzc9r/nxFf5p+vyb3t6dtF61yCG4xjZQ/6
	T8WpeyzktFusUM2I4U+scG0=
X-Google-Smtp-Source: ACHHUZ4vkD1FNhCyar5Wr13d+5f42yS2y5SigsQHIIg0eQIr0a/1ANHo564HGxX9Z2ALlM8QkyE/Vw==
X-Received: by 2002:a5d:4c8c:0:b0:2f5:3dfd:f4d2 with SMTP id z12-20020a5d4c8c000000b002f53dfdf4d2mr22848833wrs.64.1684092006850;
        Sun, 14 May 2023 12:20:06 -0700 (PDT)
Received: from localhost ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003f07ef4e3e0sm25829024wmo.0.2023.05.14.12.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 12:20:05 -0700 (PDT)
Date: Sun, 14 May 2023 20:20:04 +0100
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
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
	David Hildenbrand <david@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v9 0/3] mm/gup: disallow GUP writing to file-backed
 mappings by default
Message-ID: <0eb31f6f-a122-4a5b-a959-03ed4dee1f3c@lucifer.local>
References: <cover.1683235180.git.lstoakes@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1683235180.git.lstoakes@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 10:27:50PM +0100, Lorenzo Stoakes wrote:
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
>    the file system and dirtying the folio.
> 2. Later, writeback is triggered, resulting in the folio being cleaned and
>    the PTE being marked read-only.
> 3. The GUP caller writes to the folio, as it is mapped read/write via the
>    direct mapping.
> 4. The GUP caller, now done with the page, unpins it and sets it dirty
>    (though it does not have to).
>
> This change updates both the PUP FOLL_LONGTERM slow and fast APIs. As
> pin_user_pages_fast_only() does not exist, we can rely on a slightly
> imperfect whitelisting in the PUP-fast case and fall back to the slow case
> should this fail.
[snip]

As discussed at LSF/MM, on the flight over I wrote a little repro [0] which
reliably triggers the ext4 warning by recreating the scenario described
above, using a small userland program and kernel module.

This code is not perfect (plane code :) but does seem to do the job
adequately, also obviously this should only be run in a VM environment
where data loss is acceptable (in my case a small qemu instance).

Hopefully this is useful in some way. Note that I explicitly use
pin_user_pages() without FOLL_LONGTERM here in order to not run into the
mitigation this very patch series provides! Obviously if you revert this
series you can see the same happening with FOLL_LONGTERM set.

I have licensed the code as GPLv2 so anybody's free to do with it as they
will if it's useful in any way!

[0]:https://github.com/lorenzo-stoakes/gup-repro

