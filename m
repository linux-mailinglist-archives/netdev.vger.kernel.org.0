Return-Path: <netdev+bounces-470-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55F546F7805
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 23:28:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ACC6280F00
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CD9B156F0;
	Thu,  4 May 2023 21:28:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9C17C;
	Thu,  4 May 2023 21:28:02 +0000 (UTC)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDEA1208E;
	Thu,  4 May 2023 14:28:00 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-3062db220a3so724399f8f.0;
        Thu, 04 May 2023 14:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683235679; x=1685827679;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KC+4rdAZwJWGenCNR7ys2Od2uEdn44ram9bK1avxY1g=;
        b=VW8RtMCJoG4skxDpcHD2NTeefnts8zeezWC9cOE3j2TN2iMDgpZI7V84Z9Ac91TTNA
         66tYE6nKo0TJ1wTTDosvB9hGB4VYvC32zQ4fYMQvV9AKGweLMd0BsL/HKCkMMl8X7lC4
         yY3bpMhS0pvp2dwsPPyf2xwfafZVTsbFfIdKFQ4SC3TsxTWdfj7152kZG5mnDu29CZrF
         zIEwbDl229MICPHYSJ9iTGIWcOxoG+w5Sg5FQN7hoxOiEQfLDJUPUTXYqXZztZNm+IjD
         ppGEkrdUKUEhIUGsQmBAGvdWUWmeWyqXJDvO38NnmLCmEvpEMBWeD73Hs5FEHdK13AV5
         Z6fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683235679; x=1685827679;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KC+4rdAZwJWGenCNR7ys2Od2uEdn44ram9bK1avxY1g=;
        b=XZusevKACfSIgtxapjWPCB3CySYh3yafiwdUD726LFAoIsopP7s5MBsLo0mP9R8u60
         vdZSCeqqAd8abnNshM/yS1QUP394UbzQSJucHDS0RsWDJv7AZh8IqozSJT0oAvlqja5n
         vLGtX6bRRof9pY/rZiAnjAFBF85BfxqtpsfJtPq8hLpl/TghglYIRI+b1oVtWpM93P+Y
         e7Ny/mvbR6hHU1tde1XRx1cO+xcLM+La88sC+MnSZDOUwY6i0yt076n8HLOm1XOqauY3
         sw0gc0PzIrdBug70lM1qy0ypnZrK0QOpx0gXPM+NQEtu0T1DEUMI0ZFe44s/1AmsgPba
         OoRA==
X-Gm-Message-State: AC+VfDxQefQlCOS2xP33f0zcGuDYO0BrgtcGQk9QzLMHSzitVBcsbmze
	UwW1+m7rfz6D2exL4wV8+dXh1q7Bid8VKA==
X-Google-Smtp-Source: ACHHUZ7WgHnTySGE7UylZdBSEkgJId9O2hawXL/Fc1eWsSXRVEkunluwqLnhmxo5jrljgk6rsaqTeA==
X-Received: by 2002:a5d:4a92:0:b0:2ff:1e0f:fb2 with SMTP id o18-20020a5d4a92000000b002ff1e0f0fb2mr3565425wrq.13.1683235678688;
        Thu, 04 May 2023 14:27:58 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id h15-20020a05600c314f00b003f1978bbcd6sm51617562wmo.3.2023.05.04.14.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 14:27:57 -0700 (PDT)
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
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
	linux-fsdevel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jan Kara <jack@suse.cz>,
	"Kirill A . Shutemov" <kirill@shutemov.name>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mika Penttila <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v9 0/3] mm/gup: disallow GUP writing to file-backed mappings by default
Date: Thu,  4 May 2023 22:27:50 +0100
Message-Id: <cover.1683235180.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Writing to file-backed mappings which require folio dirty tracking using
GUP is a fundamentally broken operation, as kernel write access to GUP
mappings do not adhere to the semantics expected by a file system.

A GUP caller uses the direct mapping to access the folio, which does not
cause write notify to trigger, nor does it enforce that the caller marks
the folio dirty.

The problem arises when, after an initial write to the folio, writeback
results in the folio being cleaned and then the caller, via the GUP
interface, writes to the folio again.

As a result of the use of this secondary, direct, mapping to the folio no
write notify will occur, and if the caller does mark the folio dirty, this
will be done so unexpectedly.

For example, consider the following scenario:-

1. A folio is written to via GUP which write-faults the memory, notifying
   the file system and dirtying the folio.
2. Later, writeback is triggered, resulting in the folio being cleaned and
   the PTE being marked read-only.
3. The GUP caller writes to the folio, as it is mapped read/write via the
   direct mapping.
4. The GUP caller, now done with the page, unpins it and sets it dirty
   (though it does not have to).

This change updates both the PUP FOLL_LONGTERM slow and fast APIs. As
pin_user_pages_fast_only() does not exist, we can rely on a slightly
imperfect whitelisting in the PUP-fast case and fall back to the slow case
should this fail.

v9:
- Refactored vma_needs_dirty_tracking() and vma_wants_writenotify() to avoid
  duplicate check of shared writable/needs writenotify.
- Removed redundant comments.
- Improved vma_needs_dirty_tracking() commit message.
- Moved folio_fast_pin_allowed() into CONFIG_HAVE_FAST_GUP block as used by
  both the CONFIG_ARCH_HAS_PTE_SPECIAL and huge page cases, both of which
  are invoked under any CONFIG_HAVE_FAST_GUP configuration. Should fix
  mips/arm builds.
- Permit pins of swap cache anon pages.
- Permit KSM anon pages.

v8:
- Fixed typo writeable -> writable.
- Fixed bug in writable_file_mapping_allowed() - must check combination of
  FOLL_PIN AND FOLL_LONGTERM not either/or.
- Updated vma_needs_dirty_tracking() to include write/shared to account for
  MAP_PRIVATE mappings.
- Move to open-coding the checks in folio_pin_allowed() so we can
  READ_ONCE() the mapping and avoid unexpected compiler loads. Rename to
  account for fact we now check flags here.
- Disallow mapping == NULL or mapping & PAGE_MAPPING_FLAGS other than
  anon. Defer to slow path.
- Perform GUP-fast check _after_ the lowest page table level is confirmed to
  be stable.
- Updated comments and commit message for final patch as per Jason's
  suggestions.
https://lore.kernel.org/all/cover.1683067198.git.lstoakes@gmail.com/

v7:
- Fixed very silly bug in writeable_file_mapping_allowed() inverting the
  logic.
- Removed unnecessary RCU lock code and replaced with adaptation of Peter's
  idea.
- Removed unnecessary open-coded folio_test_anon() in
  folio_longterm_write_pin_allowed() and restructured to generally permit
  NULL folio_mapping().
https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com/

v6:
- Rebased on latest mm-unstable as of 28th April 2023.
- Add PUP-fast check with handling for rcu-locked TLB shootdown to synchronise
  correctly.
- Split patch series into 3 to make it more digestible.
https://lore.kernel.org/all/cover.1682981880.git.lstoakes@gmail.com/

v5:
- Rebased on latest mm-unstable as of 25th April 2023.
- Some small refactorings suggested by John.
- Added an extended description of the problem in the comment around
  writeable_file_mapping_allowed() for clarity.
- Updated commit message as suggested by Mika and John.
https://lore.kernel.org/all/6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com/

v4:
- Split out vma_needs_dirty_tracking() from vma_wants_writenotify() to
  reduce duplication and update to use this in the GUP check. Note that
  both separately check vm_ops_needs_writenotify() as the latter needs to
  test this before the vm_pgprot_modify() test, resulting in
  vma_wants_writenotify() checking this twice, however it is such a small
  check this should not be egregious.
https://lore.kernel.org/all/3b92d56f55671a0389252379237703df6e86ea48.1682464032.git.lstoakes@gmail.com/

v3:
- Rebased on latest mm-unstable as of 24th April 2023.
- Explicitly check whether file system requires folio dirtying. Note that
  vma_wants_writenotify() could not be used directly as it is very much focused
  on determining if the PTE r/w should be set (e.g. assuming private mapping
  does not require it as already set, soft dirty considerations).
- Tested code against shmem and hugetlb mappings - confirmed that these are not
  disallowed by the check.
- Eliminate FOLL_ALLOW_BROKEN_FILE_MAPPING flag and instead perform check only
  for FOLL_LONGTERM pins.
- As a result, limit check to internal GUP code.
 https://lore.kernel.org/all/23c19e27ef0745f6d3125976e047ee0da62569d4.1682406295.git.lstoakes@gmail.com/

v2:
- Add accidentally excluded ptrace_access_vm() use of
  FOLL_ALLOW_BROKEN_FILE_MAPPING.
- Tweak commit message.
https://lore.kernel.org/all/c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com/

v1:
https://lore.kernel.org/all/f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com/

Lorenzo Stoakes (3):
  mm/mmap: separate writenotify and dirty tracking logic
  mm/gup: disallow FOLL_LONGTERM GUP-nonfast writing to file-backed
    mappings
  mm/gup: disallow FOLL_LONGTERM GUP-fast writing to file-backed
    mappings

 include/linux/mm.h |   1 +
 mm/gup.c           | 145 ++++++++++++++++++++++++++++++++++++++++++++-
 mm/mmap.c          |  58 ++++++++++++++----
 3 files changed, 191 insertions(+), 13 deletions(-)

--
2.40.1

