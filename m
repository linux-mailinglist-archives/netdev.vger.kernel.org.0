Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2597E6F4854
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 18:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbjEBQeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 12:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbjEBQeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 12:34:18 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF2B2118;
        Tue,  2 May 2023 09:34:13 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f315735514so177339865e9.1;
        Tue, 02 May 2023 09:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683045251; x=1685637251;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nhB0IRLxm4wa8w9P3E/cdWzsBE01Yv6OZVORbiaGFU0=;
        b=YDFDqEJ+jijwp5Xgg/zBZJk2pHuAaVfH0bTQh5Mrnd1dph4E8MvglusxT3BuafMYy1
         DVe+bCUpVIn7Ccx1KONHTZeXDPCp7GngAD0qCinV13UOdX/AYKB7XF6w5oojkaW5SECR
         0jJRXb9qpzxRcnIbrypKHg69v5VPTgGHcSTyda1NSD6eBknGyD6uHPAGcpDkV4b0NDBq
         uSfHI+69oBeKj+esZHhrHxYOsgkKcFLKejeQz5jqI9ubOTvquyG7F/83hFZ+Q/N2jAup
         jKUkYHHwZ5dNION3PSM1f3FGp+MBzXts47JF0cihHh6jeLfE8uzIC4P8Vjcesfge9BpE
         FwBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683045251; x=1685637251;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nhB0IRLxm4wa8w9P3E/cdWzsBE01Yv6OZVORbiaGFU0=;
        b=eD2NNr0dwrVslhao0m2HbqGF87qrjbaCyBBd8BM7KYRxM3NTrdVQww2PuW4V/09UqN
         fdyCyHFksVDkGGj1zwn9qmRkYDi6JrcnPEUqbtp8BRorGYUUaupIQBFtI/ihPsIaIobC
         rK8wUbSGeGetZ3MYSSOsm7xb1nnri8zw2iaDZxoWBh9BLCq/7lfphQuCOcXsNg8TJYzr
         o3YIZiZWsUSVBDrR2N0tSru5LTzbFptNygACHk+G8SE7kOCOATTcArTRRml6gExlq3eS
         Ki/2IikobsG17Rxdaiwyo7Q9a2LP9TmMcOz2nm0PJkWHO9AiCuL2eVaq5WGWe+AviVek
         978Q==
X-Gm-Message-State: AC+VfDwlFSoVgowCX/sFOoSXdGfTnRVBk/o8o1xd5fyxo3VcxdsueaVX
        0vncl7MzUo/vMqjYd7MaC0I=
X-Google-Smtp-Source: ACHHUZ7hKieE98kyd/eS6F3YMd/T4yvdygso79NLb5rerMkb0AJc+PQqfb8trJsSQW8QIQ9Cj9O/6g==
X-Received: by 2002:a5d:564d:0:b0:2fa:88d3:f8b8 with SMTP id j13-20020a5d564d000000b002fa88d3f8b8mr16041618wrw.12.1683045251445;
        Tue, 02 May 2023 09:34:11 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id b10-20020a5d550a000000b0030639a86f9dsm1789919wrv.51.2023.05.02.09.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 09:34:10 -0700 (PDT)
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
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
        David Hildenbrand <david@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v7 0/3] mm/gup: disallow GUP writing to file-backed mappings by default
Date:   Tue,  2 May 2023 17:34:02 +0100
Message-Id: <cover.1683044162.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

v7:
- Fixed very silly bug in writeable_file_mapping_allowed() inverting the
  logic.
- Removed unnecessary RCU lock code and replaced with adaptation of Peter's
  idea.
- Removed unnecessary open-coded folio_test_anon() in
  folio_longterm_write_pin_allowed() and restructured to generally permit
  NULL folio_mapping().

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
 mm/gup.c           | 105 +++++++++++++++++++++++++++++++++++++++++++--
 mm/mmap.c          |  36 ++++++++++++----
 3 files changed, 130 insertions(+), 12 deletions(-)

--
2.40.1
