Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEAD2723A0
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 03:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfGXB0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 21:26:15 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35839 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbfGXB0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 21:26:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id s1so13989888pgr.2;
        Tue, 23 Jul 2019 18:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SsIRGkPWeq5HvTZzTxF/TGZYHjIKFiRIBMhKcsnvtic=;
        b=OWgPLaU3grtQYfYlP989m4hDqCY0ebI6/NdlbTukxlvyq11BxlHjkqN3hD9v30eXop
         EG5XcRymjdkeuqUefZiFos4WvvjABKFpbsNii0SJgJLYNmAuW/FgFPitHO+2/3McUV+7
         gf56g8I7oolPT/XjyQlyJvxXGT9o0Tu+Faj3GJRN83dbqyEdOZuIUG6zQmH21j9c8JN1
         CA/rkJKw8eGWS4zO87DNqwXtLIaNHKrSMu5zMWSkni8YHEGOTZRgi0t/AK2jYfN3o74B
         SwC/fjv0b2UQOsULLgn4oGhZFx9tErfDTI6/TzoSyDwqgD9ppDPsMbY1I5zyCPDekHFd
         ripQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SsIRGkPWeq5HvTZzTxF/TGZYHjIKFiRIBMhKcsnvtic=;
        b=SFiVyk86DxcFd5s52ymS2evUQxcnMEfsFGzDDnk9JLeouXTJeAAtDvLGYxUwieI3u5
         l6SzeLx8jUd8H/MgvpwwgFCI9ad2xEXr5lZRg4eVUBmiCdCkVlhnKP0Wln/DNP6v4KAN
         TvuZn2lsXWO5vTQXFCFYhb9tUJVlF8/s5E7iUBuVjaTUyh0803Qvl6DsESr/yOO+iyyz
         pGDRq/V4cV7lTOqzrftYy1X3WjrCcDbeIxCbRKSSRlxmY1mRFpOzACWRuX2Dug0BAtHj
         pS8F+Zk6CDMrYa3+mxWhSEIp8/7hlQjMCZcsdCayZfjNzU/BJVG5GD4uETfT27c8b9+J
         +wWg==
X-Gm-Message-State: APjAAAVSkYYJLdjL8PCFON32R6esDuFv5T6gvbD/5jBRTMszOMFkC5kX
        FctdKgtftjVX2ZRtW0Tcv+k=
X-Google-Smtp-Source: APXvYqwiARTqBX+BzXGVMSiMYY2ywuebKHgAP9ok+GCLfuKMFIizwJOl34+Vo9ygsJn6Z3ecH0s+Ow==
X-Received: by 2002:a63:490a:: with SMTP id w10mr77642193pga.6.1563931572866;
        Tue, 23 Jul 2019 18:26:12 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id k36sm45950119pgl.42.2019.07.23.18.26.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 18:26:12 -0700 (PDT)
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
Subject: [PATCH v2 2/3] drivers/gpu/drm/via: convert put_page() to put_user_page*()
Date:   Tue, 23 Jul 2019 18:26:05 -0700
Message-Id: <20190724012606.25844-3-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724012606.25844-1-jhubbard@nvidia.com>
References: <20190724012606.25844-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

For pages that were retained via get_user_pages*(), release those pages
via the new put_user_page*() routines, instead of via put_page() or
release_pages().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Also reverse the order of a comparison, in order to placate
checkpatch.pl.

Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/gpu/drm/via/via_dmablit.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via_dmablit.c
index 062067438f1d..b5b5bf0ba65e 100644
--- a/drivers/gpu/drm/via/via_dmablit.c
+++ b/drivers/gpu/drm/via/via_dmablit.c
@@ -171,7 +171,6 @@ via_map_blit_for_device(struct pci_dev *pdev,
 static void
 via_free_sg_info(struct pci_dev *pdev, drm_via_sg_info_t *vsg)
 {
-	struct page *page;
 	int i;
 
 	switch (vsg->state) {
@@ -186,13 +185,8 @@ via_free_sg_info(struct pci_dev *pdev, drm_via_sg_info_t *vsg)
 		kfree(vsg->desc_pages);
 		/* fall through */
 	case dr_via_pages_locked:
-		for (i = 0; i < vsg->num_pages; ++i) {
-			if (NULL != (page = vsg->pages[i])) {
-				if (!PageReserved(page) && (DMA_FROM_DEVICE == vsg->direction))
-					SetPageDirty(page);
-				put_page(page);
-			}
-		}
+		put_user_pages_dirty_lock(vsg->pages, vsg->num_pages,
+					  (vsg->direction == DMA_FROM_DEVICE));
 		/* fall through */
 	case dr_via_pages_alloc:
 		vfree(vsg->pages);
-- 
2.22.0

