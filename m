Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F65F680F1
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 21:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbfGNTL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 15:11:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40682 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728125AbfGNTL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 15:11:26 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so6417374pfp.7;
        Sun, 14 Jul 2019 12:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wTnR4jFSZHgDyQlzGAnxJLHPwWt9ff7eR4/YXCAXskI=;
        b=J6HG5WoHErAl5v76PYLUAOefrG8S1mG5ji2ajAmi5iUq3zdhofWNi8R7FD/ZClvCkS
         YZRIbPxD9g4+z4/DKU3BnFzdBGd4B6hqacPQJCYiMAyTsjeQD0VnMRdVjMwT5iXX3Wf8
         K+dbgDP1QPuW9rFsXWNsx8mrnpo7er2XDn6BWvY/4l765HNnJzRdfTLFd1FC4ox/btui
         ANCUJV2jLkQANmaHn5GDebVXYHTnQ3iJntGgl9m+NUdNzEI4foq7AImezy1e0F0aWScj
         VTeFTRsX3XhDhFo4Vbx8wmcHarhMhRhIWCsne9M3/awdd48pqQRhjBDTphYabLqRYTaO
         N99A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wTnR4jFSZHgDyQlzGAnxJLHPwWt9ff7eR4/YXCAXskI=;
        b=nxQSYNkJOc1wNLQfY3X+GYLn1XTJHbnHvpHezIMjxbmj9yrF6+X8kB/RTLnENrkqir
         1Wz1tSz1piYmZHhb+87mllrR8q7xMmYUofc+5guLbqBI898cTipGLjhIbg7U9I4LrMi9
         IWPlfPS/RA4vZfJQf4PQeZxdf4SAMso4UkJpbz2sqJ4BtXWvLgoqNtkdxqoxV3gxqyBj
         vd+0m0kM7h27A44pVnuE5VlKey9No9yfBVWxtLHOu8XhweEPNGtkBBu/bl/K1DhVXh1m
         t9hDZw8IdsZKIFcdUeIdtuSpogOVOy7PjzEYTULEhS1/rjM9qxX4jNXir6WgYlExRNFV
         mq7w==
X-Gm-Message-State: APjAAAUNo9lh8RxDvrDCJnAHngqRI1Tp7f4eV7551CFuidqB3os5QXEK
        3whkAA3LmtzPBPeaua6RiPu906NLj2s=
X-Google-Smtp-Source: APXvYqyoHwB+daqurf2TSePudMpL8bWbCxyh/0egoU2EbeU8TkfMkMtKnPM0Ke06j90ArJCf2o75Kg==
X-Received: by 2002:a63:bf01:: with SMTP id v1mr22482786pgf.278.1563131484751;
        Sun, 14 Jul 2019 12:11:24 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.34])
        by smtp.gmail.com with ESMTPSA id m6sm15239358pfb.151.2019.07.14.12.11.22
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 14 Jul 2019 12:11:24 -0700 (PDT)
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     akpm@linux-foundation.org, ira.weiny@intel.com, jhubbard@nvidia.com
Cc:     Bharath Vedartham <linux.bhar@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Enrico Weigelt <info@metux.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Matt Sickler <Matt.Sickler@daktronics.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        YueHaibing <yuehaibing@huawei.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        kvm@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org
Subject: [PATCH] mm/gup: Use put_user_page*() instead of put_page*()
Date:   Mon, 15 Jul 2019 00:38:34 +0530
Message-Id: <1563131456-11488-1-git-send-email-linux.bhar@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts all call sites of get_user_pages
to use put_user_page*() instead of put_page*() functions to
release reference to gup pinned pages.

This is a bunch of trivial conversions which is a part of an effort
by John Hubbard to solve issues with gup pinned pages and 
filesystem writeback.

The issue is more clearly described in John Hubbard's patch[1] where
put_user_page*() functions are introduced.

Currently put_user_page*() simply does put_page but future implementations
look to change that once treewide change of put_page callsites to 
put_user_page*() is finished.

The lwn article describing the issue with gup pinned pages and filesystem 
writeback [2].

This patch has been tested by building and booting the kernel as I don't
have the required hardware to test the device drivers.

I did not modify gpu/drm drivers which use release_pages instead of
put_page() to release reference of gup pinned pages as I am not clear
whether release_pages and put_page are interchangable. 

[1] https://lkml.org/lkml/2019/3/26/1396

[2] https://lwn.net/Articles/784574/

Signed-off-by: Bharath Vedartham <linux.bhar@gmail.com>
---
 drivers/media/v4l2-core/videobuf-dma-sg.c | 3 +--
 drivers/misc/sgi-gru/grufault.c           | 2 +-
 drivers/staging/kpc2000/kpc_dma/fileops.c | 4 +---
 drivers/vfio/vfio_iommu_type1.c           | 2 +-
 fs/io_uring.c                             | 7 +++----
 mm/gup_benchmark.c                        | 6 +-----
 net/xdp/xdp_umem.c                        | 7 +------
 7 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 66a6c6c..d6eeb43 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -349,8 +349,7 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
 	BUG_ON(dma->sglen);
 
 	if (dma->pages) {
-		for (i = 0; i < dma->nr_pages; i++)
-			put_page(dma->pages[i]);
+		put_user_pages(dma->pages, dma->nr_pages);
 		kfree(dma->pages);
 		dma->pages = NULL;
 	}
diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
index 4b713a8..61b3447 100644
--- a/drivers/misc/sgi-gru/grufault.c
+++ b/drivers/misc/sgi-gru/grufault.c
@@ -188,7 +188,7 @@ static int non_atomic_pte_lookup(struct vm_area_struct *vma,
 	if (get_user_pages(vaddr, 1, write ? FOLL_WRITE : 0, &page, NULL) <= 0)
 		return -EFAULT;
 	*paddr = page_to_phys(page);
-	put_page(page);
+	put_user_page(page);
 	return 0;
 }
 
diff --git a/drivers/staging/kpc2000/kpc_dma/fileops.c b/drivers/staging/kpc2000/kpc_dma/fileops.c
index 6166587..26dceed 100644
--- a/drivers/staging/kpc2000/kpc_dma/fileops.c
+++ b/drivers/staging/kpc2000/kpc_dma/fileops.c
@@ -198,9 +198,7 @@ int  kpc_dma_transfer(struct dev_private_data *priv, struct kiocb *kcb, unsigned
 	sg_free_table(&acd->sgt);
  err_dma_map_sg:
  err_alloc_sg_table:
-	for (i = 0 ; i < acd->page_count ; i++){
-		put_page(acd->user_pages[i]);
-	}
+	put_user_pages(acd->user_pages, acd->page_count);
  err_get_user_pages:
 	kfree(acd->user_pages);
  err_alloc_userpages:
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index add34ad..c491524 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -369,7 +369,7 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 		 */
 		if (ret > 0 && vma_is_fsdax(vmas[0])) {
 			ret = -EOPNOTSUPP;
-			put_page(page[0]);
+			put_user_page(page[0]);
 		}
 	}
 	up_read(&mm->mmap_sem);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4ef62a4..b4a4549 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2694,10 +2694,9 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
 			 * if we did partial map, or found file backed vmas,
 			 * release any pages we did get
 			 */
-			if (pret > 0) {
-				for (j = 0; j < pret; j++)
-					put_page(pages[j]);
-			}
+			if (pret > 0)
+				put_user_pages(pages, pret);
+
 			if (ctx->account_mem)
 				io_unaccount_mem(ctx->user, nr_pages);
 			kvfree(imu->bvec);
diff --git a/mm/gup_benchmark.c b/mm/gup_benchmark.c
index 7dd602d..15fc7a2 100644
--- a/mm/gup_benchmark.c
+++ b/mm/gup_benchmark.c
@@ -76,11 +76,7 @@ static int __gup_benchmark_ioctl(unsigned int cmd,
 	gup->size = addr - gup->addr;
 
 	start_time = ktime_get();
-	for (i = 0; i < nr_pages; i++) {
-		if (!pages[i])
-			break;
-		put_page(pages[i]);
-	}
+	put_user_pages(pages, nr_pages);
 	end_time = ktime_get();
 	gup->put_delta_usec = ktime_us_delta(end_time, start_time);
 
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 9c6de4f..6103e19 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -173,12 +173,7 @@ static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 {
 	unsigned int i;
 
-	for (i = 0; i < umem->npgs; i++) {
-		struct page *page = umem->pgs[i];
-
-		set_page_dirty_lock(page);
-		put_page(page);
-	}
+	put_user_pages_dirty_lock(umem->pgs, umem->npgs);
 
 	kfree(umem->pgs);
 	umem->pgs = NULL;
-- 
1.8.3.1

