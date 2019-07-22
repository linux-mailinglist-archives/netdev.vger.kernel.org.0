Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B379C6F885
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 06:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfGVEaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 00:30:21 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38300 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbfGVEaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 00:30:20 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so16743333pfn.5;
        Sun, 21 Jul 2019 21:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Buo/x1ku3lZhKwc/x7LZHJLCV0/VJfVJkEd+jUfSemQ=;
        b=t+zktHb7vIG4ts5I2ltkQHV48J0ZrgypJDZXuh8Drmfq8ZU2ILeEdq1vHcQdIM9gdw
         V6T9AQozh+PvM/HqMIqy5Tm11lI/PpLyTVp0Vd74SuF5mClFEjFXDGjMIfpge1xQoCsm
         IhnhiaeU9cdQMTgVUWSOM6j8abtFujQkLro/ZEGxc5vfgAlJ/A2fXKxi+6ua/RqGJsAJ
         aF9WRDRmvUFsceuLPU8ZX2StoJI42RECfxqG70NX1cGm7d70CaK3aiDy2ueHCoMs6WN3
         fMhhkyT7kmlOi6Ja/WZU2mwWlGLAtDglCCekSpcUu5Vy9dQccxZDeZv6fJknPIHGCBXz
         Jv+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Buo/x1ku3lZhKwc/x7LZHJLCV0/VJfVJkEd+jUfSemQ=;
        b=L7fNY9E6SKsbeWDuG4LRGILKao+vdZ1OjN3+rsiCkZ+uW+e9mS4Wc3kyfPKQ3Pv1W7
         brAzVyoyWYnhemCZvJ8lR2UeKpFtd/KoPAiZRwhtrRu7EIA++o2nydrTeXinyE7nOUw8
         AB/VSA7b472UTf1QoweYhkI7Nyw77XLA97fMNQ1oKYIEXAS/C3KIg0sVm4xJLVXcdgke
         MpYCTdsDY7whGYyaxakRcX1WXstPlymTVukN6S9Lr6T9HeTOFtnoTdHZcUNvXMJ+RwPc
         prf1zVwenkvRVTuMrltY6x+cBeMe7vAEcrXHLq/C+ChYJHOIb0teDQVa4LaozwKwVvCP
         7zIA==
X-Gm-Message-State: APjAAAUm7urgIGHQ2ixKpUI4Jk5xpdIswvJphfBjaqhe8dUuHzImkcD+
        5Kc753cM+dJSKEvC1/VODT4=
X-Google-Smtp-Source: APXvYqz665JUdaZ8/qhWBT5//AwERdP9iGLvt+InEi3nlWem4n0SFx0hcOfAG8MfqjlewAESAxZqZQ==
X-Received: by 2002:a17:90a:9488:: with SMTP id s8mr76721358pjo.2.1563769819486;
        Sun, 21 Jul 2019 21:30:19 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id t96sm34285690pjb.1.2019.07.21.21.30.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 21 Jul 2019 21:30:19 -0700 (PDT)
From:   john.hubbard@gmail.com
X-Google-Original-From: jhubbard@nvidia.com
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ilya Dryomov <idryomov@gmail.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ming Lei <ming.lei@redhat.com>, Sage Weil <sage@redhat.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Yan Zheng <zyan@redhat.com>, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 3/3] gup: new put_user_page_dirty*() helpers
Date:   Sun, 21 Jul 2019 21:30:12 -0700
Message-Id: <20190722043012.22945-4-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190722043012.22945-1-jhubbard@nvidia.com>
References: <20190722043012.22945-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

While converting call sites to use put_user_page*() [1], quite a few
places ended up needing a single-page routine to put and dirty a
page.

Provide put_user_page_dirty() and put_user_page_dirty_lock(),
and use them in a few places: net/xdp, drm/via/, drivers/infiniband.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/gpu/drm/via/via_dmablit.c        |  2 +-
 drivers/infiniband/core/umem.c           |  2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c |  2 +-
 include/linux/mm.h                       | 10 ++++++++++
 net/xdp/xdp_umem.c                       |  2 +-
 5 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via_dmablit.c
index 219827ae114f..d30b2d75599f 100644
--- a/drivers/gpu/drm/via/via_dmablit.c
+++ b/drivers/gpu/drm/via/via_dmablit.c
@@ -189,7 +189,7 @@ via_free_sg_info(struct pci_dev *pdev, drm_via_sg_info_t *vsg)
 		for (i = 0; i < vsg->num_pages; ++i) {
 			if (NULL != (page = vsg->pages[i])) {
 				if (!PageReserved(page) && (DMA_FROM_DEVICE == vsg->direction))
-					put_user_pages_dirty(&page, 1);
+					put_user_page_dirty(page);
 				else
 					put_user_page(page);
 			}
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 08da840ed7ee..a7337cc3ca20 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -55,7 +55,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 	for_each_sg_page(umem->sg_head.sgl, &sg_iter, umem->sg_nents, 0) {
 		page = sg_page_iter_page(&sg_iter);
 		if (umem->writable && dirty)
-			put_user_pages_dirty_lock(&page, 1);
+			put_user_page_dirty_lock(page);
 		else
 			put_user_page(page);
 	}
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 0b0237d41613..d2ded624fb2a 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -76,7 +76,7 @@ static void usnic_uiom_put_pages(struct list_head *chunk_list, int dirty)
 			page = sg_page(sg);
 			pa = sg_phys(sg);
 			if (dirty)
-				put_user_pages_dirty_lock(&page, 1);
+				put_user_page_dirty_lock(page);
 			else
 				put_user_page(page);
 			usnic_dbg("pa: %pa\n", &pa);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0334ca97c584..c0584c6d9d78 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1061,6 +1061,16 @@ void put_user_pages_dirty(struct page **pages, unsigned long npages);
 void put_user_pages_dirty_lock(struct page **pages, unsigned long npages);
 void put_user_pages(struct page **pages, unsigned long npages);
 
+static inline void put_user_page_dirty(struct page *page)
+{
+	put_user_pages_dirty(&page, 1);
+}
+
+static inline void put_user_page_dirty_lock(struct page *page)
+{
+	put_user_pages_dirty_lock(&page, 1);
+}
+
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
 #endif
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 9cbbb96c2a32..1d122e52c6de 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -171,7 +171,7 @@ static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 	for (i = 0; i < umem->npgs; i++) {
 		struct page *page = umem->pgs[i];
 
-		put_user_pages_dirty_lock(&page, 1);
+		put_user_page_dirty_lock(page);
 	}
 
 	kfree(umem->pgs);
-- 
2.22.0

