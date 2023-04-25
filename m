Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667D36EDC4F
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 09:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbjDYHOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 03:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbjDYHOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 03:14:21 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748A69001;
        Tue, 25 Apr 2023 00:14:20 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f178da21afso35364495e9.1;
        Tue, 25 Apr 2023 00:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682406859; x=1684998859;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yjgzdqrbPo7+Td+Wlne0g57m41H7q9g5vLYpPDzT+qw=;
        b=H6uBR9WAiN3nmtRogzKnpHyF+tj7CFYbFApxatJP1VLKGlPzsCJ25finM3hrSD0TEB
         XfOldeEJUhs/ALeP7EP6+mTWtQrLcql/7gRagSd2UsEVk6dOtOVqwu+fHLSYibPjJ6sb
         lfh1f+YYWcf4GP7VXXXzEejq9r0Co3wq2ip3LqUMigGlznjo31/lUKWLuIIc0IlTJIDb
         dL+v/hGG5bbSSG9J0HDhLj+KsUrvRopsq2vI0ls5gl/cgjerlsF9u86OWWWjJDtKmUdV
         IFPEkfr3t8/hkfk2cywUJTNAy1Ngjcu0MDpEQ4OwgZG18kbtqh1YdMWEM5VVO0i0Srmw
         cGGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682406859; x=1684998859;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yjgzdqrbPo7+Td+Wlne0g57m41H7q9g5vLYpPDzT+qw=;
        b=HgSjYlBjnf3j6bjUP3fCF7i4Lte/biafaYzP5t/Druz1cGsIOijX84BW13D10JDqob
         fiiaT3F5gUAUGQZROeVRR3/3qA2zWRuNh7mHOrgttYh49nsqIUyUpEFR6941Bval7dIi
         N4h3o2EvCQGDcB/qIGZLhltiigVzlcXWt5sS726TQkdM6Aj7DrwJ5nE5zJeEREge+62Y
         Qq7iIe9hq5MYMgc/JfqL+Xl5H0IAgFI73XxPJSKbCz84cCVTEaLF/LD+btyubVJXs7lF
         ZJoSJ4tJuT9hS+v/L3Dl9NI7F/tZ3GaKS1h+7vdBnZnd55VuXzH1DWQej/dMfdggNiRa
         zwbQ==
X-Gm-Message-State: AAQBX9f5st0yzFymCtCwCnLx9uGHXzTWQoV6HrEAlDp+/0oEWtU0FxGN
        GdS4RufH3Nb9gLfEjnuhfT0=
X-Google-Smtp-Source: AKy350aSZ0ogFp8y55zCmLsghq92v+eab4GmjRhmzl2lUP7Ai4SILM+68B2FMmp0r+I/N2CUHcFWng==
X-Received: by 2002:a7b:cd09:0:b0:3f1:6980:2d2e with SMTP id f9-20020a7bcd09000000b003f169802d2emr9984982wmj.22.1682406858687;
        Tue, 25 Apr 2023 00:14:18 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id c16-20020a05600c0ad000b003f198dfbbfcsm8382138wmr.19.2023.04.25.00.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 00:14:17 -0700 (PDT)
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
Subject: [PATCH v3] mm/gup: disallow GUP writing to file-backed mappings by default
Date:   Tue, 25 Apr 2023 08:14:14 +0100
Message-Id: <23c19e27ef0745f6d3125976e047ee0da62569d4.1682406295.git.lstoakes@gmail.com>
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

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
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

v2:
- Add accidentally excluded ptrace_access_vm() use of
  FOLL_ALLOW_BROKEN_FILE_MAPPING.
- Tweak commit message.
https://lore.kernel.org/all/c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com/

v1:
https://lore.kernel.org/all/f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com/

 mm/gup.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index 1f72a717232b..f77810ee8a9f 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -4,6 +4,7 @@
 #include <linux/err.h>
 #include <linux/spinlock.h>

+#include <linux/backing-dev.h>
 #include <linux/mm.h>
 #include <linux/memremap.h>
 #include <linux/pagemap.h>
@@ -959,16 +960,58 @@ static int faultin_page(struct vm_area_struct *vma,
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
+	const struct vm_operations_struct *vm_ops = vma->vm_ops;
+	const struct file *file = vma->vm_file;
+
+	/* If we aren't pinning then no problematic write can occur. */
+	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
+		return true;
+
+	/* We limit this check to the most egregious case - a long term pin. */
+	if (!(gup_flags & FOLL_LONGTERM))
+		return true;
+
+	/*
+	 * If the underlying file system needs to be notified of writes, then it
+	 * requires correct dirty tracking which we cannot guarantee.
+	 */
+	if (vm_ops && (vm_ops->page_mkwrite || vm_ops->pfn_mkwrite))
+		return false;
+
+	/*
+	 * If no pfn_mkwrite() is specified, no dirty tracking is required for a
+	 * PFN map.
+	 */
+	if (vma->vm_flags & VM_PFNMAP)
+		return true;
+
+	/*
+	 * Even if the file system does not require write notification, if its
+	 * underlying mapping can writeback, dirty tracking will be required.
+	 */
+	return !file || !file->f_mapping ||
+		!mapping_can_writeback(file->f_mapping);
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
@@ -978,6 +1021,9 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 		return -EFAULT;

 	if (write) {
+		if (!vma_anon && !can_write_file_mapping(vma, gup_flags))
+			return -EFAULT;
+
 		if (!(vm_flags & VM_WRITE)) {
 			if (!(gup_flags & FOLL_FORCE))
 				return -EFAULT;
--
2.40.0
