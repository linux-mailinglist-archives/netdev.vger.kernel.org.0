Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFAC6EEAF0
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 01:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbjDYXPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 19:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjDYXPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 19:15:44 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3454EBD;
        Tue, 25 Apr 2023 16:15:42 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f178da21b5so43991775e9.3;
        Tue, 25 Apr 2023 16:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682464540; x=1685056540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZepthuyfXWO/R7g3gyOdstMJqp904AnhCOVcdOoCQb0=;
        b=P/ZgbjiORZxfSpThRX4OlzffNCX8Ybcr1lBmTad9NQf7+dexFazlUkuxqanlqMWSjh
         jKJffLtWMQxKhG1CwTJwCEPfdZkkDQt3XiNqXg8s49c5JHiMVO89913P9zfMplKGt94d
         I+U8HApgNC+zXFC38f4veYPb0l0xJFoLMT2yq2Tr1qI5CXQu/qTxxN+TMmC1tqmDei4w
         6Hf1+XWAYtPVTMpHYmqLX+wAiGha6NIUv26p33Z9n0DfnkU7STnjTwu36Zzz/UWY+Wfp
         eJo9yW6IsTAlmoCJs6j2D1wQav0ZAnawZf2Cvx2N3nO4EjmtUWCQazmwwbqMu6GNaCtB
         TQQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682464540; x=1685056540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZepthuyfXWO/R7g3gyOdstMJqp904AnhCOVcdOoCQb0=;
        b=kDH1WlKjYtTQ148nJKpfFR8ba7219XOC2rQibp1rox0RxP7c8EhDEVDvn8wBjoyuuk
         /+vgTKpaVaI6YHn2KvCB6VGIkPgsX4lcljvdQDKm39YsyWJYQFcaB3wTgTlI7FSJOd3E
         RNlpnazZJ+FHiV9EavW1AQKNeYkxdbXBwepknjAsl20Qq9QNTFgN5jBNElthRtJHjmMS
         SKzuT7GBXu0shLbPXKQYkS60yhJ7tIDYxf5Hj/CRC8QwfKAF15lEU26Hk8xkMaOjkZ48
         wfAfcsEJw9igtgSxfJ0217NH/BZcSsIsfi+wTHSS2taK7J3t+lqcxw4Qh9Cs4jIAvQIl
         36wQ==
X-Gm-Message-State: AAQBX9drheVXs1mmXOY4fw51/YvYJq9EHlmdS0mCoyp87QLh35xJODLZ
        W+G+IIq2aIP2PHLSyGstoDg=
X-Google-Smtp-Source: AKy350Ynyb1uELx6zdIeynzAV1Y2Sqtuf7HOOmHPp7XqvNiP1RB8Z0vy1Oihgn31ZuCxpVCumCQrvQ==
X-Received: by 2002:a05:600c:2212:b0:3f1:6ead:34fe with SMTP id z18-20020a05600c221200b003f16ead34femr11542501wml.26.1682464540470;
        Tue, 25 Apr 2023 16:15:40 -0700 (PDT)
Received: from lucifer.home ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.googlemail.com with ESMTPSA id x24-20020a1c7c18000000b003f183127434sm16220321wmc.30.2023.04.25.16.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 16:15:39 -0700 (PDT)
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
        Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v4] mm/gup: disallow GUP writing to file-backed mappings by default
Date:   Wed, 26 Apr 2023 00:15:36 +0100
Message-Id: <3b92d56f55671a0389252379237703df6e86ea48.1682464032.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
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

GUP does not correctly implement write-notify semantics, nor does it
guarantee that the underlying pages are correctly dirtied, which could lead
to a kernel oops or data corruption when writing to file-backed mappings.

This is only relevant when the mappings are file-backed and the underlying
file system requires folio dirty tracking. File systems which do not, such
as shmem or hugetlb, are not at risk and therefore can be written to
without issue.

Unfortunately this limitation of GUP has been present for some time and
requires future rework of the GUP API in order to provide correct write
access to such mappings.

In the meantime, we add a check for the most broken GUP case -
FOLL_LONGTERM - which really under no circumstances can safely access
dirty-tracked file mappings.

As part of this change we separate out vma_needs_dirty_tracking() as a
helper function to determine this, which is distinct from
vma_wants_writenotify() which is specific to determining which PTE flags to
set.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
v4:
- Split out vma_needs_dirty_tracking() from vma_wants_writenotify() to reduce
  duplication and update to use this in the GUP check. Note that both separately
  check vm_ops_needs_writenotify() as the latter needs to test this before the
  vm_pgprot_modify() test, resulting in vma_wants_writenotify() checking this
  twice, however it is such a small check this should not be egregious.

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

 include/linux/mm.h |  1 +
 mm/gup.c           | 26 +++++++++++++++++++++++++-
 mm/mmap.c          | 37 ++++++++++++++++++++++++++++---------
 3 files changed, 54 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 37554b08bb28..f7da02fc89c6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2433,6 +2433,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
 
+bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
 int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
diff --git a/mm/gup.c b/mm/gup.c
index 1f72a717232b..53652453037c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -959,16 +959,37 @@ static int faultin_page(struct vm_area_struct *vma,
 	return 0;
 }
 
+/*
+ * Writing to file-backed mappings which require folio dirty tracking using GUP
+ * is a fundamentally broken operation as kernel write access to GUP mappings
+ * may not adhere to the semantics expected by a file system.
+ */
+static inline bool can_write_file_mapping(struct vm_area_struct *vma,
+					  unsigned long gup_flags)
+{
+	/* If we aren't pinning then no problematic write can occur. */
+	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
+		return true;
+
+	/* We limit this check to the most egregious case - a long term pin. */
+	if (!(gup_flags & FOLL_LONGTERM))
+		return true;
+
+	/* If the VMA requires dirty tracking then GUP will be problematic. */
+	return vma_needs_dirty_tracking(vma);
+}
+
 static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 {
 	vm_flags_t vm_flags = vma->vm_flags;
 	int write = (gup_flags & FOLL_WRITE);
 	int foreign = (gup_flags & FOLL_REMOTE);
+	bool vma_anon = vma_is_anonymous(vma);
 
 	if (vm_flags & (VM_IO | VM_PFNMAP))
 		return -EFAULT;
 
-	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
+	if ((gup_flags & FOLL_ANON) && !vma_anon)
 		return -EFAULT;
 
 	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
@@ -978,6 +999,9 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 		return -EFAULT;
 
 	if (write) {
+		if (!vma_anon && !can_write_file_mapping(vma, gup_flags))
+			return -EFAULT;
+
 		if (!(vm_flags & VM_WRITE)) {
 			if (!(gup_flags & FOLL_FORCE))
 				return -EFAULT;
diff --git a/mm/mmap.c b/mm/mmap.c
index 536bbb8fa0ae..aac638dd22cf 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1475,6 +1475,32 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
 }
 #endif /* __ARCH_WANT_SYS_OLD_MMAP */
 
+/* Do VMA operations imply write notify is required? */
+static inline bool vm_ops_needs_writenotify(
+	const struct vm_operations_struct *vm_ops)
+{
+	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
+}
+
+/*
+ * Does this VMA require the underlying folios to have their dirty state
+ * tracked?
+ */
+bool vma_needs_dirty_tracking(struct vm_area_struct *vma)
+{
+	/* Does the filesystem need to be notified? */
+	if (vm_ops_needs_writenotify(vma->vm_ops))
+		return true;
+
+	/* Specialty mapping? */
+	if (vma->vm_flags & VM_PFNMAP)
+		return false;
+
+	/* Can the mapping track the dirty pages? */
+	return vma->vm_file && vma->vm_file->f_mapping &&
+		mapping_can_writeback(vma->vm_file->f_mapping);
+}
+
 /*
  * Some shared mappings will want the pages marked read-only
  * to track write events. If so, we'll downgrade vm_page_prot
@@ -1484,14 +1510,13 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
 int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 {
 	vm_flags_t vm_flags = vma->vm_flags;
-	const struct vm_operations_struct *vm_ops = vma->vm_ops;
 
 	/* If it was private or non-writable, the write bit is already clear */
 	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
 		return 0;
 
 	/* The backer wishes to know when pages are first written to? */
-	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
+	if (vm_ops_needs_writenotify(vma->vm_ops))
 		return 1;
 
 	/* The open routine did something to the protections that pgprot_modify
@@ -1511,13 +1536,7 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 	if (userfaultfd_wp(vma))
 		return 1;
 
-	/* Specialty mapping? */
-	if (vm_flags & VM_PFNMAP)
-		return 0;
-
-	/* Can the mapping track the dirty pages? */
-	return vma->vm_file && vma->vm_file->f_mapping &&
-		mapping_can_writeback(vma->vm_file->f_mapping);
+	return vma_needs_dirty_tracking(vma);
 }
 
 /*
-- 
2.40.0

