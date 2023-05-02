Return-Path: <netdev+bounces-37-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 832C86F4D41
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 00:54:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFC8D280D55
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B6BCBA44;
	Tue,  2 May 2023 22:53:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E88BA41
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 22:53:38 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5393C30;
	Tue,  2 May 2023 15:53:01 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f315735514so3070335e9.1;
        Tue, 02 May 2023 15:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683067908; x=1685659908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xf2/3xrrY6zTi/UvbQtqx+EfWva2KHubX5xnIkqzf5o=;
        b=LVh6KnutrVzZP3pKjiBLHQPMNpZfapIZr7zSwXpKJ0A5l8snJuAcm6cwIPPs0vsGwT
         J0IMunQq4OHRkaRX8hOsyanireDdl0ndKtBcflF99xWsMEK60BmE0t3wFOE09R27GZi5
         8cE4YKI3F26zrrubCrRma9v5r/EHhlL4PAdQYlJTKgGLBRgKC8HyKwBDQiiIsQYnVwwz
         7p26ZV5u7WztCcD8Cs7KXhSC0EaNPc0li67nnnBnfdWQN2omgbc8Ec3gUO2v4JTZokBr
         qRc8thucpJ1mefYIPzzKLCympyWJjwM43Yl7Ltv4LSjbjGtayfbarJbF80B11A9ec9Md
         R6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683067908; x=1685659908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xf2/3xrrY6zTi/UvbQtqx+EfWva2KHubX5xnIkqzf5o=;
        b=DZYgyAVxJqYUTDfn6fyA6slelpiHY61+Qz+fNOh+JlDcvd5cDVd5pkZWp28JmoLrRP
         p+hzyc1sJFIZzaznurbMHsgJQubWd5hG0c00pYZhmwuxIi0Vj0jni9J0UH5BSJmesuHm
         KNkM/8noN/3iSF2R10w5jiQOffTf15eYymRneh8zExUl4Q8052ZFMtFC57GfJbYFYFJK
         2srCwIOvcvk+Q82Z+/jivHeT8lEYTF0csMrAbmE+oSU+fRt2QESNYcdllNGv7aikRbk1
         KLIJhGc/CgT/rFAgXBfKgssqqdyIsYNl9LkvBjSZFj0DLXecKAKvrIRQpKpU0VYUbuSU
         NDUg==
X-Gm-Message-State: AC+VfDz48UGX6lj0OyH+q7XBlzYetX7tI0v+nG8VMx14pygoF0hF37iW
	IHqMJjban/VsUz4SmmLpNRI=
X-Google-Smtp-Source: ACHHUZ7vhDe+CgbzjS9jNex535nFUk5hsHjTOf2+N8I98mBkquvJQo+U4kMiAWFHgSO2v935Y7MWyg==
X-Received: by 2002:a05:600c:6024:b0:3f1:89de:7e51 with SMTP id az36-20020a05600c602400b003f189de7e51mr77204wmb.12.1683067907725;
        Tue, 02 May 2023 15:51:47 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id o18-20020a05600c379200b003f17300c7dcsm58143wmr.48.2023.05.02.15.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 15:51:46 -0700 (PDT)
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
Subject: [PATCH v8 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing to file-backed mappings
Date: Tue,  2 May 2023 23:51:35 +0100
Message-Id: <a690186fc37e1ea92556a7dbd0887fe201fcc709.1683067198.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683067198.git.lstoakes@gmail.com>
References: <cover.1683067198.git.lstoakes@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Writing to file-backed dirty-tracked mappings via GUP is inherently broken
as we cannot rule out folios being cleaned and then a GUP user writing to
them again and possibly marking them dirty unexpectedly.

This is especially egregious for long-term mappings (as indicated by the
use of the FOLL_LONGTERM flag), so we disallow this case in GUP-fast as
we have already done in the slow path.

We have access to less information in the fast path as we cannot examine
the VMA containing the mapping, however we can determine whether the folio
is anonymous or belonging to a whitelisted filesystem - specifically
hugetlb and shmem mappings.

We take special care to ensure that both the folio and mapping are safe to
access when performing these checks and document folio_fast_pin_allowed()
accordingly.

It's important to note that there are no APIs allowing users to specify
FOLL_FAST_ONLY for a PUP-fast let alone with FOLL_LONGTERM, so we can
always rely on the fact that if we fail to pin on the fast path, the code
will fall back to the slow path which can perform the more thorough check.

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Kirill A . Shutemov <kirill@shutemov.name>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
 mm/gup.c | 102 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index 0ea9ebec9547..1ab369b5d889 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -18,6 +18,7 @@
 #include <linux/migrate.h>
 #include <linux/mm_inline.h>
 #include <linux/sched/mm.h>
+#include <linux/shmem_fs.h>
 
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
@@ -95,6 +96,83 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
 	return folio;
 }
 
+/*
+ * Used in the GUP-fast path to determine whether a pin is permitted for a
+ * specific folio.
+ *
+ * This call assumes the caller has pinned the folio, that the lowest page table
+ * level still points to this folio, and that interrupts have been disabled.
+ *
+ * Writing to pinned file-backed dirty tracked folios is inherently problematic
+ * (see comment describing the writable_file_mapping_allowed() function). We
+ * therefore try to avoid the most egregious case of a long-term mapping doing
+ * so.
+ *
+ * This function cannot be as thorough as that one as the VMA is not available
+ * in the fast path, so instead we whitelist known good cases and if in doubt,
+ * fall back to the slow path.
+ */
+static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
+{
+	struct address_space *mapping;
+	unsigned long mapping_flags;
+
+	/*
+	 * If we aren't pinning then no problematic write can occur. A long term
+	 * pin is the most egregious case so this is the one we disallow.
+	 */
+	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
+	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
+		return true;
+
+	/* The folio is pinned, so we can safely access folio fields. */
+
+	/* Neither of these should be possible, but check to be sure. */
+	if (unlikely(folio_test_slab(folio) || folio_test_swapcache(folio)))
+		return false;
+
+	/* hugetlb mappings do not require dirty-tracking. */
+	if (folio_test_hugetlb(folio))
+		return true;
+
+	/*
+	 * GUP-fast disables IRQs. When IRQS are disabled, RCU grace periods
+	 * cannot proceed, which means no actions performed under RCU can
+	 * proceed either.
+	 *
+	 * inodes and thus their mappings are freed under RCU, which means the
+	 * mapping cannot be freed beneath us and thus we can safely dereference
+	 * it.
+	 */
+	lockdep_assert_irqs_disabled();
+
+	/*
+	 * However, there may be operations which _alter_ the mapping, so ensure
+	 * we read it once and only once.
+	 */
+	mapping = READ_ONCE(folio->mapping);
+
+	/*
+	 * The mapping may have been truncated, in any case we cannot determine
+	 * if this mapping is safe - fall back to slow path to determine how to
+	 * proceed.
+	 */
+	if (!mapping)
+		return false;
+
+	/* Anonymous folios are fine, other non-file backed cases are not. */
+	mapping_flags = (unsigned long)mapping & PAGE_MAPPING_FLAGS;
+	if (mapping_flags)
+		return mapping_flags == PAGE_MAPPING_ANON;
+
+	/*
+	 * At this point, we know the mapping is non-null and points to an
+	 * address_space object. The only remaining whitelisted file system is
+	 * shmem.
+	 */
+	return shmem_mapping(mapping);
+}
+
 /**
  * try_grab_folio() - Attempt to get or pin a folio.
  * @page:  pointer to page to be grabbed
@@ -2464,6 +2542,11 @@ static int gup_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
 			goto pte_unmap;
 		}
 
+		if (!folio_fast_pin_allowed(folio, flags)) {
+			gup_put_folio(folio, 1, flags);
+			goto pte_unmap;
+		}
+
 		if (!pte_write(pte) && gup_must_unshare(NULL, flags, page)) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
@@ -2656,6 +2739,11 @@ static int gup_hugepte(pte_t *ptep, unsigned long sz, unsigned long addr,
 		return 0;
 	}
 
+	if (!folio_fast_pin_allowed(folio, flags)) {
+		gup_put_folio(folio, refs, flags);
+		return 0;
+	}
+
 	if (!pte_write(pte) && gup_must_unshare(NULL, flags, &folio->page)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
@@ -2722,6 +2810,10 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 		return 0;
 	}
 
+	if (!folio_fast_pin_allowed(folio, flags)) {
+		gup_put_folio(folio, refs, flags);
+		return 0;
+	}
 	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
@@ -2762,6 +2854,11 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
 		return 0;
 	}
 
+	if (!folio_fast_pin_allowed(folio, flags)) {
+		gup_put_folio(folio, refs, flags);
+		return 0;
+	}
+
 	if (!pud_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
@@ -2797,6 +2894,11 @@ static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, unsigned long addr,
 		return 0;
 	}
 
+	if (!folio_fast_pin_allowed(folio, flags)) {
+		gup_put_folio(folio, refs, flags);
+		return 0;
+	}
+
 	*nr += refs;
 	folio_set_referenced(folio);
 	return 1;
-- 
2.40.1


