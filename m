Return-Path: <netdev+bounces-36-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAD5A6F4D3F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 00:54:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01FDC1C20A09
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 369EDBA38;
	Tue,  2 May 2023 22:53:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F0ABA29
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 22:53:38 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D84640D1;
	Tue,  2 May 2023 15:53:00 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f1cfed93e2so44245045e9.3;
        Tue, 02 May 2023 15:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683067905; x=1685659905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I8p5NIpA9DMewRAQNQjxkQ5r3xTcqhG7+oiUMHxc0wc=;
        b=P5UW/H3UqLwf9ZKM9ympqwlTNWPFq0bGVt+/eaHOSrn65WQ7cIfOkr6rp3qeGqIE7Z
         tdaeNhGfnDNqYPchak1KRCFthkx/uYpoOcmzcXBI2Bf/HsHVYZEfXgBorswtxGHn3yXF
         I9RRheL9mLk+UxmeTSGtEfwKQNQ8weR57sTuXut/9ApJ1m2wQeojVJdp3/JrqHPTEtK2
         glyWaqIP3HK2hJHbG9HP88ROSWXUrW26xoOA+W946UTkcaJEvwUHBXhntijSVR5yQIvW
         OtxOzKcwpxvQUL4KJeSnNgxY9LwhIHNTpv5ORXo+9BnWIs+/cxm+Ri/Fc18wgMWaPQA0
         8Wew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683067905; x=1685659905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I8p5NIpA9DMewRAQNQjxkQ5r3xTcqhG7+oiUMHxc0wc=;
        b=CV3Fhs0GoYYgVD6WGuDRblzD2KFA1sDvqiBsFBDLclJFEtOq8Q+1t7HENxFO0uy1PU
         UyjEIWQyd0PmNbbYqGBF30qDHDRbBUJTmSNLQaJ7JLasSylYkLGhfKoQd+CnmROCOEbE
         n4NA1/tDnyVT+C3lXVFEFGaWiYVhDHR3/qmU2T9SaQYqEGl4t7Kk5nvtMydZD7HrJJjP
         9C3k6egCLtO7qrTcMEa967z2hrFdzGbK46K01NES+8URHkQAn+bl/RKbrCsfhIoeE1hk
         Hr3Jpi85rqQnjQlghhRSFlQrtv2e4dee0HQLyLxh6EkrHf6KJuqcQyRfH5B6Q6rkV8NE
         3pgg==
X-Gm-Message-State: AC+VfDwvEhYlJqfg8PKkR1nsi7tR7fjF1itfIz+lF75ARhRXtpR1VFVF
	47Ko//TiqeBf/Dyy+5lgfDc=
X-Google-Smtp-Source: ACHHUZ64KWlrQuSaN0V8bh12LO/QrIO554St0eFyal7t3THLKpBGuKEWET8df8qXdGG35E6VnaGW8A==
X-Received: by 2002:a1c:7317:0:b0:3f0:46ca:f201 with SMTP id d23-20020a1c7317000000b003f046caf201mr13181114wmb.1.1683067905407;
        Tue, 02 May 2023 15:51:45 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id o18-20020a05600c379200b003f17300c7dcsm58143wmr.48.2023.05.02.15.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 15:51:44 -0700 (PDT)
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
Subject: [PATCH v8 2/3] mm/gup: disallow FOLL_LONGTERM GUP-nonfast writing to file-backed mappings
Date: Tue,  2 May 2023 23:51:34 +0100
Message-Id: <f7533317ee29a1a4aa54afe0002367a4cd288a1d.1683067198.git.lstoakes@gmail.com>
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

This patch changes only the slow-path GUP functions, a following patch
adapts the GUP-fast path along similar lines.

[1]:https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz/

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 mm/gup.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index ff689c88a357..0ea9ebec9547 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -959,16 +959,54 @@ static int faultin_page(struct vm_area_struct *vma,
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
+static bool writable_file_mapping_allowed(struct vm_area_struct *vma,
+					  unsigned long gup_flags)
+{
+	/*
+	 * If we aren't pinning then no problematic write can occur. A long term
+	 * pin is the most egregious case so this is the case we disallow.
+	 */
+	if ((gup_flags & (FOLL_PIN | FOLL_LONGTERM)) !=
+	    (FOLL_PIN | FOLL_LONGTERM))
+		return true;
+
+	/*
+	 * If the VMA does not require dirty tracking then no problematic write
+	 * can occur either.
+	 */
+	return !vma_needs_dirty_tracking(vma);
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
@@ -978,6 +1016,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 		return -EFAULT;
 
 	if (write) {
+		if (!vma_anon &&
+		    !writable_file_mapping_allowed(vma, gup_flags))
+			return -EFAULT;
+
 		if (!(vm_flags & VM_WRITE)) {
 			if (!(gup_flags & FOLL_FORCE))
 				return -EFAULT;
-- 
2.40.1


