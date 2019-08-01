Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E88F7E6DF
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 01:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390471AbfHAXrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 19:47:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34672 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733221AbfHAXrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 19:47:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id b13so34959452pfo.1;
        Thu, 01 Aug 2019 16:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SsIRGkPWeq5HvTZzTxF/TGZYHjIKFiRIBMhKcsnvtic=;
        b=BGeE6sBPyOFa3wBesZ//yTnmIYiW2qdWshkClQ7aPWJjL7akX61KxZpR3Bc5xMlShv
         hSn2MfOI/RkCSfFPfN1GHpHW0mpAeEndeA1Bkn/hiOqupu2eVuK/0+WqRsoNrkoiam1u
         mAtMgD/4OhHWCVjWeannJUrXJT5cdnwC8V126zhAy+M9nCbcd2/YN0KObjLuWC1rZPXx
         0AL6HjVWassUOkoH+wgHm7bpYMsDJhceK5sYbcW/PCa0rFZh5o/+tIRNg9imoY9BXY1x
         WJfFtHbODuo2mf66BZtQp/j03TkrW+CfXNYDl9m8qoTc8N6pWgt7ajKCVU594c51EagE
         tvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SsIRGkPWeq5HvTZzTxF/TGZYHjIKFiRIBMhKcsnvtic=;
        b=B33iMjuPZdZYhpsTMhIfZkOHAe3UYiB96wlA+hlC9Yf855mhs/bc7JEAtL74RnbQ31
         h22d+rAf5v8uDI26dfPZJLiFgE7zlYWYtVPLzhMK8DhQEMQnvjrfkVkdSMHHbEI4eckD
         /pGvihK3Xi2WTWc1dozEz+VYNreJc8aucgKQ7EbTfgMkHV1nkaj+ddvKjMZJxQxD3/76
         OkLqYF+umTB49wGPuNmhU1ZaWk8P6dfprG/JL1UCKgTQIyliV8W5XYYrqypuo+9p0GSU
         QGrOE5wvrQMkVQ6LccXvb5Lgx31WNHJOm8hpi8gmt3ScWzbEVDL+1v7akcjb2YxPdxHv
         EwCg==
X-Gm-Message-State: APjAAAUVdh3TWzBRILq0OdIkZMv6qxlTrAJ6bDnRNFVpg1Kp5vx11+ap
        t3FfOnuyjdkIa0dbz7NydDc=
X-Google-Smtp-Source: APXvYqxH8u29ZdpcjWLJrwgbMbyVAF40I2QUvMD98RL8LJpcLxolKyu7rs5+6caIWdcRdmo9vFlEcg==
X-Received: by 2002:aa7:82da:: with SMTP id f26mr56649423pfn.82.1564703262707;
        Thu, 01 Aug 2019 16:47:42 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id q7sm79090792pff.2.2019.08.01.16.47.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 16:47:42 -0700 (PDT)
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
Subject: [PATCH v5 2/3] drivers/gpu/drm/via: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 16:47:34 -0700
Message-Id: <20190801234735.2149-3-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190801234735.2149-1-jhubbard@nvidia.com>
References: <20190801234735.2149-1-jhubbard@nvidia.com>
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

