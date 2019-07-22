Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51D370CBA
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 00:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733262AbfGVWeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 18:34:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34709 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731792AbfGVWeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 18:34:22 -0400
Received: by mail-pf1-f193.google.com with SMTP id b13so18060427pfo.1;
        Mon, 22 Jul 2019 15:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H5rDEOeFRvjrpBGS4dvuQZ6SJfLiKadFXLHgUye++Ig=;
        b=Pcs9/tR3DaHZa4DyTRc+V1EBVautcG67Y8Rlu5OVhq9gKq6GUPJQe1wcWgSdEsQ2Kq
         Radfqy6wlFYNzaWH7qZJhs5OiX9krJynNgS9czJHFLw45UEGbEegviTKLi3BYeTqppE6
         wClCxR/cc9fseFTseNMdctyP1DsHiAKbtD3vrFPJ63NuNCU9kcF/wCkCf+3/B3Q0czjq
         ukVZJzmrau8htl9Bla/qPE0ArxviXBYhsjitL4/aZ7mWfpykEpu6jiXE0UB7wdf00smi
         8G8KNFJh7oVyyxUX3OS2FzQaqS9mTboIDnjdqYM5MTevgkbFpW/jwrfFQHv/btHh152l
         vo1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H5rDEOeFRvjrpBGS4dvuQZ6SJfLiKadFXLHgUye++Ig=;
        b=ZxmZHwNrtXhSBaQzMWb7u886gHd1ocabiV0WJOpaZMfqwMMSwXgGOR0RXSXzaxPmRl
         E1LmIRmvOZuT4/eBmht8mzrngb8rbun272t7f5fg6zRXPKKZnXVAtu2eYj4Z6pXVZpLA
         pSs8Xxr1kfgx7Lwz5ieZo+2ThimPkgw1k+3oZy/eRMPgy18TUIe1fNC4CSiO41sfsmCO
         VW2FLY0CgguomSJmoHWDOHWzr5KXLT8D0GH1wK76eHZdjI1o517DhfEZlrXh4CGHwMVR
         QwcjRPlvq1J80Keqt5U2I5a0CK1R6ZjwuA0ccx89aTTqs9kBgJneiSyxZgqMQrR7mQHV
         rb4w==
X-Gm-Message-State: APjAAAXrCq1IdglcGbYBpFTjM0+gKsYeuoxz/kigXa2XgX9GSqa4rEzC
        6LoF3R/R5uv1E8ESmArGLVI=
X-Google-Smtp-Source: APXvYqy5ILwW5Vkz7E3PJko1LlOqyK0nYxF3IsZhHj5oXXw0vxfHVHN4Sbd1j+lEz3Chtbcoljrf1w==
X-Received: by 2002:aa7:8705:: with SMTP id b5mr2598762pfo.27.1563834861925;
        Mon, 22 Jul 2019 15:34:21 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r18sm30597570pfg.77.2019.07.22.15.34.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 15:34:21 -0700 (PDT)
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
Subject: [PATCH 2/3] drivers/gpu/drm/via: convert put_page() to put_user_page*()
Date:   Mon, 22 Jul 2019 15:34:14 -0700
Message-Id: <20190722223415.13269-3-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190722223415.13269-1-jhubbard@nvidia.com>
References: <20190722223415.13269-1-jhubbard@nvidia.com>
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
 drivers/gpu/drm/via/via_dmablit.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via_dmablit.c
index 062067438f1d..754f2bb97d61 100644
--- a/drivers/gpu/drm/via/via_dmablit.c
+++ b/drivers/gpu/drm/via/via_dmablit.c
@@ -171,7 +171,6 @@ via_map_blit_for_device(struct pci_dev *pdev,
 static void
 via_free_sg_info(struct pci_dev *pdev, drm_via_sg_info_t *vsg)
 {
-	struct page *page;
 	int i;
 
 	switch (vsg->state) {
@@ -186,13 +185,9 @@ via_free_sg_info(struct pci_dev *pdev, drm_via_sg_info_t *vsg)
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
+		__put_user_pages(vsg->pages, vsg->num_pages,
+				 (vsg->direction == DMA_FROM_DEVICE) ?
+				 PUP_FLAGS_DIRTY : PUP_FLAGS_CLEAN);
 		/* fall through */
 	case dr_via_pages_alloc:
 		vfree(vsg->pages);
-- 
2.22.0

