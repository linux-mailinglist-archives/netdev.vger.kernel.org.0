Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D046F4856
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 18:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbjEBQeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 12:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbjEBQeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 12:34:20 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F961992;
        Tue,  2 May 2023 09:34:15 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-30639daee76so630924f8f.1;
        Tue, 02 May 2023 09:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683045254; x=1685637254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEh6qe0LJpI9PjPri6EZKbTs+kciBcl89x6Vk+ogtyI=;
        b=rV/tg4sPWK0Yd5OAkHs3STp3vCv7XgjCWJKFSObTKLQwJ4/9Q77hsil9WydXeZHB8N
         v/K4g3gaf34OKPjdwMCu5WCiclwfzN5ATZfm/F2jhrty05dMIUQSGStWMVl7S77m7TEE
         J5pXhpkUigoLyt8Mk6/SKM8OrczLwSN+hOEJ8mnXfR/s0cmOsz3xwJccQSnjnSeQ0F1F
         Cg/yMDM66fjILlrEcRKv1/l1ZYMSvc1SYzeK0nhuq5+Ivysgn0FW4NS/gCFrXddz26R6
         E2kfzXErHsRCoRDeOL6Ot9Va095idmF0z/w1XEMx6AfyYDsehDMjx5gncp0yaexJMinu
         uTmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683045254; x=1685637254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GEh6qe0LJpI9PjPri6EZKbTs+kciBcl89x6Vk+ogtyI=;
        b=SAGPRihcqQEb5prnBLIHlcXWQVa+DK/ABK/jI5Jd62u6YgbrJrAndT9kfjXbnE5SJ5
         WVkUVvIEctssQ6iAnbKGuAI9yUYE1UEyr4MRtWDrc1Wg7MjTPirwdPGs+ckloTKqZNJe
         ycNtPrY8lnpfb49sZuQNhcUUKidHmt2FY+kf5NkAjtks8+sA1pEE3EY/Mqdy712eR0SF
         2E3BpSY2+S5pal1LruvSDgFXgXM1EbyZGnBleE+VZVf9v+/YKwSXAleSxSOOIFdYAX8Q
         t5jVBk2LaI7GIZ4VizZzpFDceJHX858dici/+8r+h4ojEwP/8napq4gcSxPfT275+ekH
         MVtA==
X-Gm-Message-State: AC+VfDzbbQ+k+0E1PHXVMn72hqziRIoicqqjEGafWOQJSaJZrd75z5Lu
        YsW+CRPpGMiN307+AIf1Ywg=
X-Google-Smtp-Source: ACHHUZ50KL5lKzLS1EKe+OSGwWFCRqra//gPVIbku//UXjOKTsNJNyCy4Y3dFoKnwvlRlHT6/gbFig==
X-Received: by 2002:a5d:54d1:0:b0:306:2ff6:5cbf with SMTP id x17-20020a5d54d1000000b003062ff65cbfmr5310165wrv.24.1683045253445;
        Tue, 02 May 2023 09:34:13 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id b10-20020a5d550a000000b0030639a86f9dsm1789919wrv.51.2023.05.02.09.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 09:34:12 -0700 (PDT)
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
Subject: [PATCH v7 1/3] mm/mmap: separate writenotify and dirty tracking logic
Date:   Tue,  2 May 2023 17:34:03 +0100
Message-Id: <72a90af5a9e4445a33ae44efa710f112c2694cb1.1683044162.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683044162.git.lstoakes@gmail.com>
References: <cover.1683044162.git.lstoakes@gmail.com>
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

vma_wants_writenotify() is specifically intended for setting PTE page table
flags, accounting for existing PTE flag state and whether that might
already be read-only while mixing this check with a check whether the
filesystem performs dirty tracking.

Separate out the notions of dirty tracking and a PTE write notify checking
in order that we can invoke the dirty tracking check from elsewhere.

Note that this change introduces a very small duplicate check of the
separated out vm_ops_needs_writenotify(). This is necessary to avoid making
vma_needs_dirty_tracking() needlessly complicated (e.g. passing a
check_writenotify flag or having it assume this check was already
performed). This is such a small check that it doesn't seem too egregious
to do this.

Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/mm.h |  1 +
 mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
 2 files changed, 28 insertions(+), 9 deletions(-)

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
index 5522130ae606..295c5f2e9bd9 100644
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
2.40.1

