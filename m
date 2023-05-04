Return-Path: <netdev+bounces-471-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B216F780E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 23:28:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E188280BE2
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24980C151;
	Thu,  4 May 2023 21:28:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158E27C;
	Thu,  4 May 2023 21:28:04 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D181329B;
	Thu,  4 May 2023 14:28:02 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f315712406so78837455e9.0;
        Thu, 04 May 2023 14:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683235681; x=1685827681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qkndhYeKpdj265qSAWGVggIskUvt1UIo0+mdAihYUxw=;
        b=AteVRjKUbfb+r9a5MwmSJz52Wmk7nfvL2lLANu4qx3OoPEX4FJMC9P24blVvL9cJjT
         OkVTnGWwzhebc6uan6QVemWa/27AZspCXqPV6r+WIgwWPRAzoNPNu5PiMPI+8evUQtcS
         KGQX6bzuw7iDXbCgjyrVwry2YNqRe+iYpkEFDCjB9wq/nn9oFsxAPB6CSLHujtfhz176
         oT3yX4jmz2MaVgFF9lvB4RPVvln76a8cuESYaaQm/b8AV+brrNItdtIzinYmbDtltWrA
         YhOxHXkhh1ZZll/EuP3yHv5DVDGreaRiKo0VI6c2281o8cnjHSULah3iJQlKpBOz1uf2
         HrJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683235681; x=1685827681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qkndhYeKpdj265qSAWGVggIskUvt1UIo0+mdAihYUxw=;
        b=PWIhhCtRiUE7wb+llBwIle06s1R40yKhs3slN2oq08Zl/2cp7HpQwjdBZDzNXKrwna
         9UrY8H2wmjSBGWIwsZjmXFT28i5znwM3TktlbwEWQqbWjR/ArBHG7p8bt53D4xsarBlr
         lEuIOQHF5smyyzU8HfEoov4H7+kiucTBE9SzbAJUieD0AET6dUIZUA1OPyTzk95eLFR6
         mEv3JtG7+RqgGkLOvuvbsWBKNwKwE4YZU2jvTrPK65Pm1g7mlm+EangBG80x3QLKKF23
         MhQIaGefAadGr+aIDL7PSwWOvXmykxAVi/kP1bwCzefnu8skjFFdAQbUDc7DnJtRuogo
         Foyg==
X-Gm-Message-State: AC+VfDxHShfgNF1JLRLtC9VNxdDxFAdlfi9UZLTZpgd971t68/DT+wg7
	aKTbkPBivoizFIamdLBJ+q0=
X-Google-Smtp-Source: ACHHUZ7XJTWUqV1QKPwzQJmoCOnjvVDrmgLrIWoBnpZBrbofmSjOveRFSeqhevMmXudNjoinNCM53g==
X-Received: by 2002:a1c:c906:0:b0:3f1:72d8:a1b1 with SMTP id f6-20020a1cc906000000b003f172d8a1b1mr151060wmb.7.1683235681054;
        Thu, 04 May 2023 14:28:01 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id h15-20020a05600c314f00b003f1978bbcd6sm51617562wmo.3.2023.05.04.14.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 14:28:00 -0700 (PDT)
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
Subject: [PATCH v9 1/3] mm/mmap: separate writenotify and dirty tracking logic
Date: Thu,  4 May 2023 22:27:51 +0100
Message-Id: <0f218370bd49b4e6bbfbb499f7c7b92c26ba1ceb.1683235180.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683235180.git.lstoakes@gmail.com>
References: <cover.1683235180.git.lstoakes@gmail.com>
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

vma_wants_writenotify() is specifically intended for setting PTE page table
flags, accounting for existing page table flag state and whether the
underlying filesystem performs dirty tracking for a file-backed mapping.

Everything is predicated firstly on whether the mapping is shared writable,
as this is the only instance where dirty tracking is pertinent -
MAP_PRIVATE mappings will always be CoW'd and unshared, and read-only
file-backed shared mappings cannot be written to, even with FOLL_FORCE.

All other checks are in line with existing logic, though now separated into
checks eplicitily for dirty tracking and those for determining how to set
page table flags.

We make this change so we can perform checks in the GUP logic to determine
which mappings might be problematic when written to.

Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h |  1 +
 mm/mmap.c          | 58 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 27ce77080c79..7b1d4e7393ef 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2422,6 +2422,7 @@ extern unsigned long move_page_tables(struct vm_area_struct *vma,
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
 
+bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
 int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
diff --git a/mm/mmap.c b/mm/mmap.c
index 13678edaa22c..8ef5929057fc 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1475,6 +1475,48 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
 }
 #endif /* __ARCH_WANT_SYS_OLD_MMAP */
 
+static bool vm_ops_needs_writenotify(const struct vm_operations_struct *vm_ops)
+{
+	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
+}
+
+static bool vma_is_shared_writable(struct vm_area_struct *vma)
+{
+	return (vma->vm_flags & (VM_WRITE | VM_SHARED)) ==
+		(VM_WRITE | VM_SHARED);
+}
+
+static bool vma_fs_can_writeback(struct vm_area_struct *vma)
+{
+	/* No managed pages to writeback. */
+	if (vma->vm_flags & VM_PFNMAP)
+		return false;
+
+	return vma->vm_file && vma->vm_file->f_mapping &&
+		mapping_can_writeback(vma->vm_file->f_mapping);
+}
+
+/*
+ * Does this VMA require the underlying folios to have their dirty state
+ * tracked?
+ */
+bool vma_needs_dirty_tracking(struct vm_area_struct *vma)
+{
+	/* Only shared, writable VMAs require dirty tracking. */
+	if (!vma_is_shared_writable(vma))
+		return false;
+
+	/* Does the filesystem need to be notified? */
+	if (vm_ops_needs_writenotify(vma->vm_ops))
+		return true;
+
+	/*
+	 * Even if the filesystem doesn't indicate a need for writenotify, if it
+	 * can writeback, dirty tracking is still required.
+	 */
+	return vma_fs_can_writeback(vma);
+}
+
 /*
  * Some shared mappings will want the pages marked read-only
  * to track write events. If so, we'll downgrade vm_page_prot
@@ -1483,21 +1525,18 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
  */
 int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 {
-	vm_flags_t vm_flags = vma->vm_flags;
-	const struct vm_operations_struct *vm_ops = vma->vm_ops;
-
 	/* If it was private or non-writable, the write bit is already clear */
-	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
+	if (!vma_is_shared_writable(vma))
 		return 0;
 
 	/* The backer wishes to know when pages are first written to? */
-	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
+	if (vm_ops_needs_writenotify(vma->vm_ops))
 		return 1;
 
 	/* The open routine did something to the protections that pgprot_modify
 	 * won't preserve? */
 	if (pgprot_val(vm_page_prot) !=
-	    pgprot_val(vm_pgprot_modify(vm_page_prot, vm_flags)))
+	    pgprot_val(vm_pgprot_modify(vm_page_prot, vma->vm_flags)))
 		return 0;
 
 	/*
@@ -1511,13 +1550,8 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 	if (userfaultfd_wp(vma))
 		return 1;
 
-	/* Specialty mapping? */
-	if (vm_flags & VM_PFNMAP)
-		return 0;
-
 	/* Can the mapping track the dirty pages? */
-	return vma->vm_file && vma->vm_file->f_mapping &&
-		mapping_can_writeback(vma->vm_file->f_mapping);
+	return vma_fs_can_writeback(vma);
 }
 
 /*
-- 
2.40.1


