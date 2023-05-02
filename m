Return-Path: <netdev+bounces-35-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A5126F4D3C
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 00:53:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB1A3280D8D
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 690DEBA2B;
	Tue,  2 May 2023 22:53:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5570CBA29
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 22:53:37 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B52240CF;
	Tue,  2 May 2023 15:53:00 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f19a80a330so27693645e9.2;
        Tue, 02 May 2023 15:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683067903; x=1685659903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=utbIHhK4wvUzVzlg7i40WhaoVe7w/JFe99oXtjkYjPc=;
        b=pZL+7YJbWjeADWZx5flP5hVUrT+JvjgzA+u3HdsodMLCQYzbpXEQIHzxteQ7NLFhi7
         gUDLZOY9jhDk3yd9v8ST15XbgqcXa1FZPAX4jDeUGUfsRWJTe5WEzg3DgwzIsFYKjAo+
         In7V5Fv2JUGZsbNPESCMSHYGg/6I+vvIA1aD2zBqm50sJiML/E9dikFfH8LwRg7vpqx6
         LdOhxLsQgodswMbIKOSCIExDirUjQafPpKES85LgXavzINfx/Pd62dYzAaafECSLW+p0
         PN69+CnKXXeVS3QqS3Fx2JPZ7Dm+7lOqEHs1XssScC/bt5DT9AsAGJ84LwbPYQwkmpa+
         c8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683067903; x=1685659903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=utbIHhK4wvUzVzlg7i40WhaoVe7w/JFe99oXtjkYjPc=;
        b=J5SUWdWTWmBOUJtakLdaX4odaSeT2syaNOA6l7F7sQY9/OTofqmkqyLR1HliI2Iiw4
         vgrShIlwgQbaFhpaj0YjRH5/+0MmypzmU3oO9TbEFouyJETcgI+2MvbXv92XdR6P+qDW
         x+TdT4dHeuBwfpj0+xuOIanbLgnCzWuS5AN3FIqqMTFsqVLUHN+CgHZIWK0d3lCC1Gjv
         6GY5/vGNZRVOutD/ETabFBOTD1oWanSGI/35HED3+5wqBMl04YkZl45r++7LsR2YwkXD
         Iwy50mtGDdhe1QDfoo1OZeORt6vSMxdc2RLRXT17UmkaP4ZfL6NszpYSBaldjiOOErho
         Ra5A==
X-Gm-Message-State: AC+VfDwMov6moaEaZuCrWnS8weP0AL7vGDFKV7m0o6h7wNGQ8uqdNGw4
	q/dOw7m9vnB36j9yfPTvZ8yzhTFEOB5GGQ==
X-Google-Smtp-Source: ACHHUZ5OBX4FgEkeYzT01g0/epXCyD/tDNeCwyw+NJ8+hKqbotIe7EqbFj90ifgNu5oLw88lOz8Cvw==
X-Received: by 2002:a7b:c8d9:0:b0:3f1:94fe:65e0 with SMTP id f25-20020a7bc8d9000000b003f194fe65e0mr13581859wml.26.1683067903209;
        Tue, 02 May 2023 15:51:43 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id o18-20020a05600c379200b003f17300c7dcsm58143wmr.48.2023.05.02.15.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 15:51:42 -0700 (PDT)
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
Subject: [PATCH v8 1/3] mm/mmap: separate writenotify and dirty tracking logic
Date: Tue,  2 May 2023 23:51:33 +0100
Message-Id: <7ac8bb557517bcdc9225b4e4893a2ca7f603fcc4.1683067198.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683067198.git.lstoakes@gmail.com>
References: <cover.1683067198.git.lstoakes@gmail.com>
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
filesystem performs dirty tracking.

Separate out the notions of dirty tracking and PTE write notify checking in
order that we can invoke the dirty tracking check from elsewhere.

Note that this change introduces a very small duplicate check of the
separated out vm_ops_needs_writenotify() and vma_is_shared_writable()
functions. This is necessary to avoid making vma_needs_dirty_tracking()
needlessly complicated (e.g. passing flags or having it assume checks were
already performed). This is small enough that it doesn't seem too
egregious.

We check to ensure the mapping is shared writable, as any GUP caller will
be safe - MAP_PRIVATE mappings will be CoW'd and read-only file-backed
shared mappings are not permitted access, even with FOLL_FORCE.

Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/mm.h |  1 +
 mm/mmap.c          | 53 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 41 insertions(+), 13 deletions(-)

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
index 5522130ae606..fa7442e44cc2 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1475,6 +1475,42 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
 }
 #endif /* __ARCH_WANT_SYS_OLD_MMAP */
 
+/* Do VMA operations imply write notify is required? */
+static bool vm_ops_needs_writenotify(const struct vm_operations_struct *vm_ops)
+{
+	return vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite);
+}
+
+/* Is this VMA shared and writable? */
+static bool vma_is_shared_writable(struct vm_area_struct *vma)
+{
+	return (vma->vm_flags & (VM_WRITE | VM_SHARED)) ==
+		(VM_WRITE | VM_SHARED);
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
@@ -1483,21 +1519,18 @@ SYSCALL_DEFINE1(old_mmap, struct mmap_arg_struct __user *, arg)
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
@@ -1511,13 +1544,7 @@ int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
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
2.40.1


