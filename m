Return-Path: <netdev+bounces-34-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E346F4D34
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 00:53:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A068B1C20A15
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E01AD5B;
	Tue,  2 May 2023 22:53:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E287EE
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 22:53:34 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386FF3C3F;
	Tue,  2 May 2023 15:52:59 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-306281edf15so3737224f8f.1;
        Tue, 02 May 2023 15:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683067901; x=1685659901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0RFhupXU1bVDFi2Y2FIy6WlZs49rrUCoImKiEbU0jvo=;
        b=KbXfX1YpJ3tkmT8YtdRC9HoMl1YE/eK+LnhF5IbskCq9S7Qr5LqD7EFO8WnchX8nXP
         /4S96bW4EGUKAWkr3ZI8rGsKueU31xL4nABuldtbsbFrB9igBXq3mN9Yacp6KP8obs1G
         A24s1xvtrIw+vufOrF0ROpZ2bM2yDMEg5ml0HRVwLYe+h06f8yHOrmN+jxyvhSOejJyX
         zcl2CWSDEy18B8+atq8HACVJAJVDdnxFDiC+fC5oI/JpwvvYsp8GsL3YL1ftq/Yf5Wht
         IjQx1mYdQZRNYDawu5lMk2ySbsjyWjLCbTXlEsVcRFt1lJLuCbRRoUViRj1rV0t3luYM
         qKrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683067901; x=1685659901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0RFhupXU1bVDFi2Y2FIy6WlZs49rrUCoImKiEbU0jvo=;
        b=VXIP+4Bbd6JIqN7hFDu0gNHsKgFEYbjfaQPiKuLWLnGA8W7yBJxJxpsUZbwT9r1TBs
         mpuYHPofbwm1t0x5ooGH/6opRvFOZuXm9M+GiMznqoM3rsWxlAHQJBRpx8eNYsmBg83V
         CMjURueZyAOEeRH+o/Aaop8v+4au0CeThoRCzIgSd7xbX9EuNeC+CdBRDyIJXfGWxS2p
         C1wsJOQnPGKT5Bw0PVeNOtcNr8FB7pqns1xAcgSlYvhgiqQmlkYXSM8o+YsVtFM55mxf
         SbN1egmb+6+CaZdOxQgPaInY44UsbJEBgCHlVPmFImazKq12I413j+ETQJJiIoFn2I0p
         2nUw==
X-Gm-Message-State: AC+VfDxwGLUx0Gm6Tgxuyj2VQvZEkI6zL1gSC3hpgRT7kzBMjBdg9UMR
	s+Ihc01X00OyIVXWsOkJW0Q=
X-Google-Smtp-Source: ACHHUZ4aNEsEcnXg6h3ToPZJd5Ca5o5oFljNZdZ5oOlNez9c4dOziY2F3dUyGU2FAp1Sp0P0Ez9ihw==
X-Received: by 2002:a5d:4b0e:0:b0:304:a40c:43c6 with SMTP id v14-20020a5d4b0e000000b00304a40c43c6mr14850153wrq.11.1683067900566;
        Tue, 02 May 2023 15:51:40 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id o18-20020a05600c379200b003f17300c7dcsm58143wmr.48.2023.05.02.15.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 15:51:39 -0700 (PDT)
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
Subject: [PATCH v8 0/3] mm/gup: disallow GUP writing to file-backed mappings by default
Date: Tue,  2 May 2023 23:51:32 +0100
Message-Id: <cover.1683067198.git.lstoakes@gmail.com>
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
 mm/gup.c           | 146 ++++++++++++++++++++++++++++++++++++++++++++-
 mm/mmap.c          |  53 ++++++++++++----
 3 files changed, 186 insertions(+), 14 deletions(-)

--
2.40.1

