Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA8A6EC754
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 09:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjDXHni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 03:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbjDXHng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 03:43:36 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CE51BD6;
        Mon, 24 Apr 2023 00:43:30 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-2fa0ce30ac2so3712851f8f.3;
        Mon, 24 Apr 2023 00:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682322209; x=1684914209;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fjdNC4xhs+QxluvD9GzJYp7E/BZY4/oUnsXHbQ3i3o0=;
        b=VMjDnENYtVCpPnY3IpUNGvYUj+VforToK5/O/1EKmiRDIm1myjqTJfXvKgq1e/aWA4
         c8kNkLxKGzKfpcMht3GM+gDvST+/dj/4WR46mAOAA1QYid0HGntCWXqIMfJQCpvJBisY
         7ivPYDOyE+0SnWDTQJNop24X7xagKMoyh3qmneCay3ls5CmDBSNmsa0zGmZ7QRUMYy6e
         Tu5e6pkH68LYZZu1pPm+KCZcr1HntGVcEXid9W3jQ/Da0SvYEJ+LSQmQHN8hcgYwf1a/
         b3QLsgDmH/Dc8uYAe10BNjC6iIQB7mQDOywBpIsRLWOqpOLt6QKoEUk+wHvkJjIkrZ7E
         oNYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682322209; x=1684914209;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fjdNC4xhs+QxluvD9GzJYp7E/BZY4/oUnsXHbQ3i3o0=;
        b=UgysYItDXVSJenWZkZCEYe0kyX4aSDTCrIduezKew8M9BvKudPi9lWek24dPNXQvJP
         g3uYGffmk31JQv0YDeWg8ZPgRmE21YtIUJbmILtF0Lox9tb4+oY+8JGkqIzoJWiU7Gz/
         kaKUwg7oaDHEDZ6ibhmk9Gm/1YM6WKCBcrEd3LTrDTMQix/rx9nBoHAnTuVAxM/ZbVXf
         wpnze4trT3/oNYyzWjOMSKDjKQS8IlgbrcYh2wZmeeoLt2VEDXaeWr/TUDSVUg8RCbqd
         D826MgljI+dsQVUyhJf1ELHahqEbgLlFXUCbOskAHs0Mj4Wh7NCQFKXzg+ehvRbph9Te
         0dOg==
X-Gm-Message-State: AAQBX9d/WFlbrMyegsV1k58Zd5EFdC95rJRKe26Jo/2ZrIyKbdZtERLn
        SAVhtmg6xopHS/8sZKDS/60=
X-Google-Smtp-Source: AKy350ZKnmdTNgW0myOwiDxyeVQDtqONhZcMl6t8EjSPgGj0W1iHebmXS3VM1gRoQm9Y/S/liQhdPg==
X-Received: by 2002:adf:dcc5:0:b0:2f6:620f:92ca with SMTP id x5-20020adfdcc5000000b002f6620f92camr9534182wrm.23.1682322208621;
        Mon, 24 Apr 2023 00:43:28 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id h15-20020a05600c314f00b003f1978bbcd6sm8755483wmo.3.2023.04.24.00.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 00:43:27 -0700 (PDT)
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
        Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v2] mm/gup: disallow GUP writing to file-backed mappings by default
Date:   Mon, 24 Apr 2023 08:43:18 +0100
Message-Id: <c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com>
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

It isn't safe to write to file-backed mappings as GUP does not ensure that
the semantics associated with such a write are performed correctly, for
instance file systems which rely upon write-notify will not be correctly
notified.

There are exceptions to this - shmem and hugetlb mappings pose no such
concern so we do permit this operation in these cases.

In addition, if no pinning takes place (neither FOLL_GET nor FOLL_PIN is
specified and neither flags gets implicitly set) then no writing can occur
so we do not perform the check in this instance.

This is an important exception, as populate_vma_page_range() invokes
__get_user_pages() in this way (and thus so does __mm_populate(), used by
MAP_POPULATE mmap() and mlock() invocations).

There are GUP users within the kernel that do nevertheless rely upon this
behaviour, so we introduce the FOLL_ALLOW_BROKEN_FILE_MAPPING flag to
explicitly permit this kind of GUP access.

This is required in order to not break userspace in instances where the
uAPI might permit file-mapped addresses - a number of RDMA users require
this for instance, as do the process_vm_[read/write]v() system calls,
/proc/$pid/mem, ptrace and SDT uprobes. Each of these callers have been
updated to use this flag.

Making this change is an important step towards a more reliable GUP, and
explicitly indicates which callers might encounter issues moving forward.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
v2:
- Add accidentally excluded ptrace_access_vm() use of
  FOLL_ALLOW_BROKEN_FILE_MAPPING.
- Tweak commit message.

v1:
https://lore.kernel.org/all/f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com/

 drivers/infiniband/hw/qib/qib_user_pages.c |  3 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c   |  2 +-
 drivers/infiniband/sw/siw/siw_mem.c        |  3 +-
 fs/proc/base.c                             |  3 +-
 include/linux/mm_types.h                   |  8 +++++
 kernel/events/uprobes.c                    |  3 +-
 kernel/ptrace.c                            |  3 +-
 mm/gup.c                                   | 36 +++++++++++++++++++++-
 mm/memory.c                                |  3 +-
 mm/process_vm_access.c                     |  2 +-
 net/xdp/xdp_umem.c                         |  2 +-
 11 files changed, 58 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
index f693bc753b6b..b9019dad8008 100644
--- a/drivers/infiniband/hw/qib/qib_user_pages.c
+++ b/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -110,7 +110,8 @@ int qib_get_user_pages(unsigned long start_page, size_t num_pages,
 	for (got = 0; got < num_pages; got += ret) {
 		ret = pin_user_pages(start_page + got * PAGE_SIZE,
 				     num_pages - got,
-				     FOLL_LONGTERM | FOLL_WRITE,
+				     FOLL_LONGTERM | FOLL_WRITE |
+				     FOLL_ALLOW_BROKEN_FILE_MAPPING,
 				     p + got, NULL);
 		if (ret < 0) {
 			mmap_read_unlock(current->mm);
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 2a5cac2658ec..33cf79b248a9 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -85,7 +85,7 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 				int dmasync, struct usnic_uiom_reg *uiomr)
 {
 	struct list_head *chunk_list = &uiomr->chunk_list;
-	unsigned int gup_flags = FOLL_LONGTERM;
+	unsigned int gup_flags = FOLL_LONGTERM | FOLL_ALLOW_BROKEN_FILE_MAPPING;
 	struct page **page_list;
 	struct scatterlist *sg;
 	struct usnic_uiom_chunk *chunk;
diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
index f51ab2ccf151..bc3e8c0898e5 100644
--- a/drivers/infiniband/sw/siw/siw_mem.c
+++ b/drivers/infiniband/sw/siw/siw_mem.c
@@ -368,7 +368,8 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 	struct mm_struct *mm_s;
 	u64 first_page_va;
 	unsigned long mlock_limit;
-	unsigned int foll_flags = FOLL_LONGTERM;
+	unsigned int foll_flags =
+		FOLL_LONGTERM | FOLL_ALLOW_BROKEN_FILE_MAPPING;
 	int num_pages, num_chunks, i, rv = 0;

 	if (!can_do_mlock())
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 96a6a08c8235..3e3f5ea9849f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -855,7 +855,8 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
 	if (!mmget_not_zero(mm))
 		goto free;

-	flags = FOLL_FORCE | (write ? FOLL_WRITE : 0);
+	flags = FOLL_FORCE | FOLL_ALLOW_BROKEN_FILE_MAPPING |
+		(write ? FOLL_WRITE : 0);

 	while (count > 0) {
 		size_t this_len = min_t(size_t, count, PAGE_SIZE);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3fc9e680f174..e76637b4c78f 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1185,6 +1185,14 @@ enum {
 	FOLL_PCI_P2PDMA = 1 << 10,
 	/* allow interrupts from generic signals */
 	FOLL_INTERRUPTIBLE = 1 << 11,
+	/*
+	 * By default we disallow write access to known broken file-backed
+	 * memory mappings (i.e. anything other than hugetlb/shmem
+	 * mappings). Some code may rely upon being able to access this
+	 * regardless for legacy reasons, thus we provide a flag to indicate
+	 * this.
+	 */
+	FOLL_ALLOW_BROKEN_FILE_MAPPING = 1 << 12,

 	/* See also internal only FOLL flags in mm/internal.h */
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 59887c69d54c..ec330d3b0218 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -373,7 +373,8 @@ __update_ref_ctr(struct mm_struct *mm, unsigned long vaddr, short d)
 		return -EINVAL;

 	ret = get_user_pages_remote(mm, vaddr, 1,
-			FOLL_WRITE, &page, &vma, NULL);
+				    FOLL_WRITE | FOLL_ALLOW_BROKEN_FILE_MAPPING,
+				    &page, &vma, NULL);
 	if (unlikely(ret <= 0)) {
 		/*
 		 * We are asking for 1 page. If get_user_pages_remote() fails,
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 0786450074c1..db5022b21b8e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -58,7 +58,8 @@ int ptrace_access_vm(struct task_struct *tsk, unsigned long addr,
 		return 0;
 	}

-	ret = __access_remote_vm(mm, addr, buf, len, gup_flags);
+	ret = __access_remote_vm(mm, addr, buf, len,
+				 gup_flags | FOLL_ALLOW_BROKEN_FILE_MAPPING);
 	mmput(mm);

 	return ret;
diff --git a/mm/gup.c b/mm/gup.c
index 1f72a717232b..68d5570c0bae 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -959,16 +959,46 @@ static int faultin_page(struct vm_area_struct *vma,
 	return 0;
 }

+/*
+ * Writing to file-backed mappings using GUP is a fundamentally broken operation
+ * as kernel write access to GUP mappings may not adhere to the semantics
+ * expected by a file system.
+ *
+ * In most instances we disallow this broken behaviour, however there are some
+ * exceptions to this enforced here.
+ */
+static inline bool can_write_file_mapping(struct vm_area_struct *vma,
+					  unsigned long gup_flags)
+{
+	struct file *file = vma->vm_file;
+
+	/* If we aren't pinning then no problematic write can occur. */
+	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
+		return true;
+
+	/* Special mappings should pose no problem. */
+	if (!file)
+		return true;
+
+	/* Has the caller explicitly indicated this case is acceptable? */
+	if (gup_flags & FOLL_ALLOW_BROKEN_FILE_MAPPING)
+		return true;
+
+	/* shmem and hugetlb mappings do not have problematic semantics. */
+	return vma_is_shmem(vma) || is_file_hugepages(file);
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
@@ -978,6 +1008,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 		return -EFAULT;

 	if (write) {
+		if (!vma_anon &&
+		    WARN_ON_ONCE(!can_write_file_mapping(vma, gup_flags)))
+			return -EFAULT;
+
 		if (!(vm_flags & VM_WRITE)) {
 			if (!(gup_flags & FOLL_FORCE))
 				return -EFAULT;
diff --git a/mm/memory.c b/mm/memory.c
index 146bb94764f8..e3d535991548 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5683,7 +5683,8 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr,
 	if (!mm)
 		return 0;

-	ret = __access_remote_vm(mm, addr, buf, len, gup_flags);
+	ret = __access_remote_vm(mm, addr, buf, len,
+				 gup_flags | FOLL_ALLOW_BROKEN_FILE_MAPPING);

 	mmput(mm);

diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 78dfaf9e8990..ef126c08e89c 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -81,7 +81,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
 	ssize_t rc = 0;
 	unsigned long max_pages_per_loop = PVM_MAX_KMALLOC_PAGES
 		/ sizeof(struct pages *);
-	unsigned int flags = 0;
+	unsigned int flags = FOLL_ALLOW_BROKEN_FILE_MAPPING;

 	/* Work out address and page range required */
 	if (len == 0)
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 02207e852d79..b93cfcaccb0d 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -93,7 +93,7 @@ void xdp_put_umem(struct xdp_umem *umem, bool defer_cleanup)

 static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 {
-	unsigned int gup_flags = FOLL_WRITE;
+	unsigned int gup_flags = FOLL_WRITE | FOLL_ALLOW_BROKEN_FILE_MAPPING;
 	long npgs;
 	int err;

--
2.40.0
