Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D70726DA
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfGXEpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:45:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45567 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfGXEpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 00:45:46 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so20521916pgp.12;
        Tue, 23 Jul 2019 21:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SsIRGkPWeq5HvTZzTxF/TGZYHjIKFiRIBMhKcsnvtic=;
        b=iRuMVn01zHeK0yiOSRK2Lr1EU7pc8CsdgSBtKjcFrXOm/+FFRVzrNNlrixeGJOHP8V
         iKetHK+5t9Ej+nI5uVMv4FAA+ES3uEQlIJ2baYiULutC43IaDSEvIuAPlCl0SkvBEe7z
         p5DawuDWDYqB6EvMkUh0m7OdFNUodM0kZKUBCZKxr8EDIZSemDwaSeWX7wTt5H/lcaHI
         UerhtDXokM+OXWJf65SFEnmVvk8moZsIkX+U07z7UpCTHRZuu0Trgg8Cc6r1Ng5el3Ex
         iN2WNf1PERhrfsMSIWn3T6NItLlHWkEtcgeAh3eh21j0v8PcRI9akyjAnn4iE7QkI1/G
         BN0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SsIRGkPWeq5HvTZzTxF/TGZYHjIKFiRIBMhKcsnvtic=;
        b=ZwvWROXRL808NW7NmLOK2yQLyYPIU9noAetLO4QUaWqg77WbLMY+2jVGnD3g3szvU4
         McN6wrCQWWeR+a6hzn2IQrnJNLlM+dnprlNhtIuJJ/CXHXeCxrOoLwgOplSeeXStlopJ
         CMcXy5fUE6o3FbNtM9X/ynS6QMgxrhnUANS3wa7/MMHjiqOXvzsqeGGcjpDBidTeX//s
         jyfwTu6nCfVvedk/mxJOkpUc03ZY71bQSIYljJoV27n17hYUlpMCAdqzP/NGNaHyfXND
         D0ZB6VHqE6Nddgpv7e//d10IHhzg8eXP7hGsTw8LNtVssQnlZgd7zASbEIuKMp43eirQ
         AaTg==
X-Gm-Message-State: APjAAAWziL005HeobM+xANH+F/rtsS1M63UBYxF4cUEwf68+IGmWTKBy
        eJUVUTvVngCv4ClIJte0Nyg=
X-Google-Smtp-Source: APXvYqxwR8jHApJyEKZyasPi8IFXLYmSKaODUc/eHgbbUMsE1K6Stn97aM6QVrRMJVmUoANrLpXphg==
X-Received: by 2002:aa7:8804:: with SMTP id c4mr9226277pfo.65.1563943546014;
        Tue, 23 Jul 2019 21:45:46 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id b30sm65685861pfr.117.2019.07.23.21.45.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 21:45:45 -0700 (PDT)
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
Subject: [PATCH v3 2/3] drivers/gpu/drm/via: convert put_page() to put_user_page*()
Date:   Tue, 23 Jul 2019 21:45:36 -0700
Message-Id: <20190724044537.10458-3-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724044537.10458-1-jhubbard@nvidia.com>
References: <20190724044537.10458-1-jhubbard@nvidia.com>
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

