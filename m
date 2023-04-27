Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB176F0F31
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 01:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344406AbjD0Xml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 19:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344277AbjD0Xmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 19:42:39 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D46930F1;
        Thu, 27 Apr 2023 16:42:38 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2f3fe12de15so5659696f8f.3;
        Thu, 27 Apr 2023 16:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682638956; x=1685230956;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5XGoYes4lZe9LymJ1b7BEtzp9oEzXqkK69ZXVdNGO28=;
        b=fL2eTb8MSCdfF5H27s7rWxS11eVMySNR+UgjCaYYPyw7IM6/KjLmevrV4cS/3ssY7q
         ZKuM9oVuXrzc+BmFpYkE8GriSs1WUGQwJZXOt4bIfKDFE3NIf3QyilBbtC4tYhmZQ6z2
         YD7LxwXGZSHZUjSJ8NTdeMEnbrP9bqIhM6GJHNXATHwmBNO/vOdyGR/tezN+6/zgO1KJ
         wOGuBclWRddmRNkp7hLbCm7EG4IDKsn+mUVcbDp5Tl/lRWGpaN0hA7JAh5l8hXH/Un/R
         rBJNVbIRvBBJk7wb9yB9vJbKAgSdRYeKaqtk7BJV4Kg99hInez3GR83H+MT5mmZdZF9X
         h8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682638956; x=1685230956;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5XGoYes4lZe9LymJ1b7BEtzp9oEzXqkK69ZXVdNGO28=;
        b=OVKSdhjL7Q2K/b3jn5nnLXBT/qoju04TybaFFAfbITHJzrPrTTY+VB8P0M3pUcOFWF
         sze95ib+5apKFqyLVIib+IZcHxOa7nywAizqAOkivLFZqZOnB3NzD3SbiVFDBxyoFCRf
         Y6lWm/3NDwuWJLrMM7xIZmCPfTCrBtEOjpRWxL6SBJqQ3MGvf/XbiDAXOwzVargVmxuC
         +nLqgYCXdubFas25nUgMeJyWgWUnEuSMP8h8G2a9D14xfErVcQG5xCD0hIr1/Dit+++Z
         AglN5kU6chY2Kyemjxwg6XkruDz5D48oiISyxhaXuwbksHKoTxWNB5DQMbcIhT+dL0I5
         oSiw==
X-Gm-Message-State: AC+VfDxyqSgKxmo9toTiobZsInnFUZoXiixkzSPeMf6EMLL1UGCcXSMw
        T/mKnhLCm1tILD7oJavME+0=
X-Google-Smtp-Source: ACHHUZ5syc0yXE2yBca5rqHV13IbDMibdyJ67dnjXrlxd6c+k+UUY77z8gG0q+NaJLFkvL+tcsHgEA==
X-Received: by 2002:a5d:620d:0:b0:2f5:3fa1:6226 with SMTP id y13-20020a5d620d000000b002f53fa16226mr2407368wru.14.1682638956261;
        Thu, 27 Apr 2023 16:42:36 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id 25-20020a05600c025900b003ed2c0a0f37sm22520047wmj.35.2023.04.27.16.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 16:42:35 -0700 (PDT)
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
        Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings by default
Date:   Fri, 28 Apr 2023 00:42:32 +0100
Message-Id: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
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

This results in both data being written to a folio without writenotify, and
the folio being dirtied unexpectedly (if the caller decides to do so).

This issue was first reported by Jan Kara [1] in 2018, where the problem
resulted in file system crashes.

This is only relevant when the mappings are file-backed and the underlying
file system requires folio dirty tracking. File systems which do not, such
as shmem or hugetlb, are not at risk and therefore can be written to
without issue.

Unfortunately this limitation of GUP has been present for some time and
requires future rework of the GUP API in order to provide correct write
access to such mappings.

However, for the time being we introduce this check to prevent the most
egregious case of this occurring, use of the FOLL_LONGTERM pin.

These mappings are considerably more likely to be written to after
folios are cleaned and thus simply must not be permitted to do so.

As part of this change we separate out vma_needs_dirty_tracking() as a
helper function to determine this which is distinct from
vma_wants_writenotify() which is specific to determining which PTE flags to
set.

[1]:https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz/

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
 include/linux/mm.h |  1 +
 mm/gup.c           | 41 ++++++++++++++++++++++++++++++++++++++++-
 mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
 3 files changed, 68 insertions(+), 10 deletions(-)

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
index 1f72a717232b..d36a5db9feb1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -959,16 +959,51 @@ static int faultin_page(struct vm_area_struct *vma,
 	return 0;
 }

+/*
+ * Writing to file-backed mappings which require folio dirty tracking using GUP
+ * is a fundamentally broken operation, as kernel write access to GUP mappings
+ * do not adhere to the semantics expected by a file system.
+ *
+ * Consider the following scenario:-
+ *
+ * 1. A folio is written to via GUP which write-faults the memory, notifying
+ *    the file system and dirtying the folio.
+ * 2. Later, writeback is triggered, resulting in the folio being cleaned and
+ *    the PTE being marked read-only.
+ * 3. The GUP caller writes to the folio, as it is mapped read/write via the
+ *    direct mapping.
+ * 4. The GUP caller, now done with the page, unpins it and sets it dirty
+ *    (though it does not have to).
+ *
+ * This results in both data being written to a folio without writenotify, and
+ * the folio being dirtied unexpectedly (if the caller decides to do so).
+ */
+static bool writeable_file_mapping_allowed(struct vm_area_struct *vma,
+					   unsigned long gup_flags)
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
@@ -978,6 +1013,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 		return -EFAULT;

 	if (write) {
+		if (!vma_anon &&
+		    !writeable_file_mapping_allowed(vma, gup_flags))
+			return -EFAULT;
+
 		if (!(vm_flags & VM_WRITE)) {
 			if (!(gup_flags & FOLL_FORCE))
 				return -EFAULT;
diff --git a/mm/mmap.c b/mm/mmap.c
index 536bbb8fa0ae..7b6344d1832a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1475,6 +1475,31 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
 }
 #endif /* __ARCH_WANT_SYS_OLD_MMAP */

+/* Do VMA operations imply write notify is required? */
+static bool vm_ops_needs_writenotify(const struct vm_operations_struct *vm_ops)
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
@@ -1484,14 +1509,13 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
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
@@ -1511,13 +1535,7 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
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
