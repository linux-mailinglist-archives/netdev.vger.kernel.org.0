Return-Path: <netdev+bounces-2453-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59786701FCA
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 23:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 500371C20A0C
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 21:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C49EBE7E;
	Sun, 14 May 2023 21:27:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7521FCE;
	Sun, 14 May 2023 21:27:12 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D9A19AD;
	Sun, 14 May 2023 14:27:03 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-3078fa679a7so8523692f8f.3;
        Sun, 14 May 2023 14:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684099621; x=1686691621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8xqzyCEy7iofGcOYzYypeQYEUsssg0r/A+Ok0DOjdDs=;
        b=aoQGznX+L0dqapBQrZ7tkkNVdcbVvdSJlnUDKwjlWhMHJsKAuaUDUnJC42eQD2DeDX
         34fO8/v7vg1LUopNvlyFJXzAO8PJUfjM3OQDqGW4BrssZLPdgbji8y3zkxIzTeu5JVw+
         FV+CRnz59VmbrLGfyt4pGVm2hqrgAeBWO/vmr91k4swlQ7b3D85FRtZxbGcfBOxjKMkn
         d6RdWLeX4B78nbG17RhE7r0ymv0s8n0GnnM29Du5pRxfNwNAvV4LSbovqFC2br4iXOY0
         F6V6C6RK12INseuaPzDfQvZ3a4AIEsBo87ya77kVsQ2VR2mFMjFu/AjnVpJftddk4v0z
         Z6og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684099621; x=1686691621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8xqzyCEy7iofGcOYzYypeQYEUsssg0r/A+Ok0DOjdDs=;
        b=lFPxqYFhqRmXmHyxFo1K79Im/VS+q/fEoZ5QLhBd8ubvmulMcRRY3TROkfuP36RUbG
         +xr6uO8zZyWa3wftZGc7b7qkFeh/hz6jQrnf5NbtDeNEdCQXWIE6ulFOT79a3dce+nJo
         LsHXiUElyvuGkjkKicUIYG1z4Gwu8ITuttliRA0GU51a2B3wwizQqdKKK5I9VMs2bAhY
         qsfopKL6Yp1fu27bg+kzWiAlIEpR8lTxLMlTSyoW26bbAGlYUoUnzac8yu7sTYs2CghT
         /TvCPBtgLfLq3LahxojvzxcBE+8LSssNXH9D1ICHCp5Pn/MlrHV9AiNuK6cE4EZHEl4x
         dX5Q==
X-Gm-Message-State: AC+VfDwwGJrQ+ICIo7LvTd8n1kKFZL3AKANYJMQZoOuWEjGtmwPmZA/e
	HDyTUMBMhgqFctQB/3Z2IrY=
X-Google-Smtp-Source: ACHHUZ6PRLUWV/JXBbb+jR9+33X81exRRn6i14eei9wAVcEb3WES66stfPnuGtQX6n6Zzc9+QFQNkQ==
X-Received: by 2002:adf:ec45:0:b0:306:3f97:4847 with SMTP id w5-20020adfec45000000b003063f974847mr21210684wrn.65.1684099621384;
        Sun, 14 May 2023 14:27:01 -0700 (PDT)
Received: from lucifer.home ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.googlemail.com with ESMTPSA id d18-20020adfe852000000b002fe13ec49fasm30174117wrn.98.2023.05.14.14.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 14:27:00 -0700 (PDT)
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Christian Benvenuti <benve@cisco.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Bjorn Topel <bjorn@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-rdma@vger.kernel.org,
	linux-media@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	io-uring@vger.kernel.org,
	bpf@vger.kernel.org,
	John Hubbard <jhubbard@nvidia.com>,
	Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v5 5/6] mm/gup: remove vmas parameter from pin_user_pages()
Date: Sun, 14 May 2023 22:26:58 +0100
Message-Id: <acd4a8c735c9bc1c736e1a52a9a036db5cc7d462.1684097002.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1684097001.git.lstoakes@gmail.com>
References: <cover.1684097001.git.lstoakes@gmail.com>
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

We are now in a position where no caller of pin_user_pages() requires the
vmas parameter at all, so eliminate this parameter from the function and
all callers.

This clears the way to removing the vmas parameter from GUP altogether.

Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com> (for qib)
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
 arch/powerpc/mm/book3s64/iommu_api.c       | 2 +-
 drivers/infiniband/hw/qib/qib_user_pages.c | 2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c   | 2 +-
 drivers/infiniband/sw/siw/siw_mem.c        | 2 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c  | 2 +-
 drivers/vdpa/vdpa_user/vduse_dev.c         | 2 +-
 drivers/vhost/vdpa.c                       | 2 +-
 include/linux/mm.h                         | 3 +--
 io_uring/rsrc.c                            | 2 +-
 mm/gup.c                                   | 9 +++------
 mm/gup_test.c                              | 9 ++++-----
 net/xdp/xdp_umem.c                         | 2 +-
 12 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s64/iommu_api.c
index 81d7185e2ae8..d19fb1f3007d 100644
--- a/arch/powerpc/mm/book3s64/iommu_api.c
+++ b/arch/powerpc/mm/book3s64/iommu_api.c
@@ -105,7 +105,7 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
 
 		ret = pin_user_pages(ua + (entry << PAGE_SHIFT), n,
 				FOLL_WRITE | FOLL_LONGTERM,
-				mem->hpages + entry, NULL);
+				mem->hpages + entry);
 		if (ret == n) {
 			pinned += n;
 			continue;
diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
index f693bc753b6b..1bb7507325bc 100644
--- a/drivers/infiniband/hw/qib/qib_user_pages.c
+++ b/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -111,7 +111,7 @@ int qib_get_user_pages(unsigned long start_page, size_t num_pages,
 		ret = pin_user_pages(start_page + got * PAGE_SIZE,
 				     num_pages - got,
 				     FOLL_LONGTERM | FOLL_WRITE,
-				     p + got, NULL);
+				     p + got);
 		if (ret < 0) {
 			mmap_read_unlock(current->mm);
 			goto bail_release;
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 2a5cac2658ec..84e0f41e7dfa 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -140,7 +140,7 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 		ret = pin_user_pages(cur_base,
 				     min_t(unsigned long, npages,
 				     PAGE_SIZE / sizeof(struct page *)),
-				     gup_flags, page_list, NULL);
+				     gup_flags, page_list);
 
 		if (ret < 0)
 			goto out;
diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
index f51ab2ccf151..e6e25f15567d 100644
--- a/drivers/infiniband/sw/siw/siw_mem.c
+++ b/drivers/infiniband/sw/siw/siw_mem.c
@@ -422,7 +422,7 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 		umem->page_chunk[i].plist = plist;
 		while (nents) {
 			rv = pin_user_pages(first_page_va, nents, foll_flags,
-					    plist, NULL);
+					    plist);
 			if (rv < 0)
 				goto out_sem_up;
 
diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 53001532e8e3..405b89ea1054 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -180,7 +180,7 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 		data, size, dma->nr_pages);
 
 	err = pin_user_pages(data & PAGE_MASK, dma->nr_pages, gup_flags,
-			     dma->pages, NULL);
+			     dma->pages);
 
 	if (err != dma->nr_pages) {
 		dma->nr_pages = (err >= 0) ? err : 0;
diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index de97e38c3b82..4d4405f058e8 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1052,7 +1052,7 @@ static int vduse_dev_reg_umem(struct vduse_dev *dev,
 		goto out;
 
 	pinned = pin_user_pages(uaddr, npages, FOLL_LONGTERM | FOLL_WRITE,
-				page_list, NULL);
+				page_list);
 	if (pinned != npages) {
 		ret = pinned < 0 ? pinned : -ENOMEM;
 		goto out;
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 8c1aefc865f0..61223fcbe82b 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -983,7 +983,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 	while (npages) {
 		sz2pin = min_t(unsigned long, npages, list_size);
 		pinned = pin_user_pages(cur_base, sz2pin,
-					gup_flags, page_list, NULL);
+					gup_flags, page_list);
 		if (sz2pin != pinned) {
 			if (pinned < 0) {
 				ret = pinned;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 679b41ef7a6d..db09c7062965 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2412,8 +2412,7 @@ static inline struct page *get_user_page_vma_remote(struct mm_struct *mm,
 long get_user_pages(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages);
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
-		    unsigned int gup_flags, struct page **pages,
-		    struct vm_area_struct **vmas);
+		    unsigned int gup_flags, struct page **pages);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
 long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index b6451f8bc5d5..b56bda46a9eb 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1044,7 +1044,7 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 	ret = 0;
 	mmap_read_lock(current->mm);
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
-			      pages, NULL);
+			      pages);
 	if (pret == nr_pages)
 		*npages = nr_pages;
 	else
diff --git a/mm/gup.c b/mm/gup.c
index 1493cc8dd526..36701b5f0123 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3274,8 +3274,6 @@ EXPORT_SYMBOL(pin_user_pages_remote);
  * @gup_flags:	flags modifying lookup behaviour
  * @pages:	array that receives pointers to the pages pinned.
  *		Should be at least nr_pages long.
- * @vmas:	array of pointers to vmas corresponding to each page.
- *		Or NULL if the caller does not require them.
  *
  * Nearly the same as get_user_pages(), except that FOLL_TOUCH is not set, and
  * FOLL_PIN is set.
@@ -3284,15 +3282,14 @@ EXPORT_SYMBOL(pin_user_pages_remote);
  * see Documentation/core-api/pin_user_pages.rst for details.
  */
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
-		    unsigned int gup_flags, struct page **pages,
-		    struct vm_area_struct **vmas)
+		    unsigned int gup_flags, struct page **pages)
 {
 	int locked = 1;
 
-	if (!is_valid_gup_args(pages, vmas, NULL, &gup_flags, FOLL_PIN))
+	if (!is_valid_gup_args(pages, NULL, NULL, &gup_flags, FOLL_PIN))
 		return 0;
 	return __gup_longterm_locked(current->mm, start, nr_pages,
-				     pages, vmas, &locked, gup_flags);
+				     pages, NULL, &locked, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages);
 
diff --git a/mm/gup_test.c b/mm/gup_test.c
index 9ba8ea23f84e..1668ce0e0783 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -146,18 +146,17 @@ static int __gup_test_ioctl(unsigned int cmd,
 						 pages + i);
 			break;
 		case PIN_BASIC_TEST:
-			nr = pin_user_pages(addr, nr, gup->gup_flags, pages + i,
-					    NULL);
+			nr = pin_user_pages(addr, nr, gup->gup_flags, pages + i);
 			break;
 		case PIN_LONGTERM_BENCHMARK:
 			nr = pin_user_pages(addr, nr,
 					    gup->gup_flags | FOLL_LONGTERM,
-					    pages + i, NULL);
+					    pages + i);
 			break;
 		case DUMP_USER_PAGES_TEST:
 			if (gup->test_flags & GUP_TEST_FLAG_DUMP_PAGES_USE_PIN)
 				nr = pin_user_pages(addr, nr, gup->gup_flags,
-						    pages + i, NULL);
+						    pages + i);
 			else
 				nr = get_user_pages(addr, nr, gup->gup_flags,
 						    pages + i);
@@ -270,7 +269,7 @@ static inline int pin_longterm_test_start(unsigned long arg)
 							gup_flags, pages);
 		else
 			cur_pages = pin_user_pages(addr, remaining_pages,
-						   gup_flags, pages, NULL);
+						   gup_flags, pages);
 		if (cur_pages < 0) {
 			pin_longterm_test_stop();
 			ret = cur_pages;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 02207e852d79..06cead2b8e34 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -103,7 +103,7 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 
 	mmap_read_lock(current->mm);
 	npgs = pin_user_pages(address, umem->npgs,
-			      gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
+			      gup_flags | FOLL_LONGTERM, &umem->pgs[0]);
 	mmap_read_unlock(current->mm);
 
 	if (npgs != umem->npgs) {
-- 
2.40.1


