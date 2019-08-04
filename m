Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFAE680CC9
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 23:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfHDVku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 17:40:50 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45917 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfHDVkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 17:40:49 -0400
Received: by mail-pl1-f194.google.com with SMTP id y8so35656809plr.12;
        Sun, 04 Aug 2019 14:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SsIRGkPWeq5HvTZzTxF/TGZYHjIKFiRIBMhKcsnvtic=;
        b=H+p30VSjG2bf5AhOggB5BMZsW4m9risk1SBKygWZEa4RLF2QVvj46onSB9Iu63cBhz
         /42BdWC1CpQTI/gGo4HQcAmlqUhbQCDZyO1er4CKT+ES4DgPE9pjxTxvrM2Ml2etyUAT
         1Jtn0wq64e1geuJnx4qMRvHAZBG/LKpdwbNiHwhnrbMTIkPJsHZzbHJBHtuUZ+gVzsbV
         zw4cg6zSDS23YxXKB9O6N3MS4xcetMMvqcuy9hwn1XOQsF1ghps+HImfUVntNxOD9trO
         /ykc4DpaFmLktsZjHWpryrOPu7Yfj6Ao/n7wqskKVhmAebiL+EbFEYmmU1Z31P50MkGX
         IaUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SsIRGkPWeq5HvTZzTxF/TGZYHjIKFiRIBMhKcsnvtic=;
        b=Hk1ueckUHA4P93CYqobOdnVd9X8HLSzSfhof1rszUGJA4HUoT/xNsoGLFxD19kqIj4
         Ehr59qg83xhq9XWEXvOrejQVynp1p/GrV2HZgWyvQm9fU77469fyEqg+UozUGaSu4SPa
         hr+ZHMxvzOd8ywdNbPNTYysAokDKke/bWzN8UK9GUy7l0HO4RjhdR3xTzKqy2c2wARKS
         IS+tZoM0yUMXnBKHw8ZALEceaPD2PSOC0NbbtiZ3qO1LcZe68L/BlK5F9X8hjuC5C2PI
         ve89qzm2pc45Osk02IuEgo9GsJeZ6mcNYSI06hbua482qBYOag5SoICubp8ZPTOygYAm
         1Xig==
X-Gm-Message-State: APjAAAUb0oq2MtcrAPGV36oaqroIoEpfMUb+m7x+0m24rBDAJjv5/P7v
        aXyivzaVB+FZCJPX99XHuI8=
X-Google-Smtp-Source: APXvYqydipLt//yx7Zzw8Y7M/UPDM4z+2keifWIA9ZuDE301mL9AEMh6QPc9OqCc5SJgqPJLA9fETg==
X-Received: by 2002:a17:902:16f:: with SMTP id 102mr136326006plb.94.1564954848548;
        Sun, 04 Aug 2019 14:40:48 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id 143sm123751024pgc.6.2019.08.04.14.40.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 14:40:47 -0700 (PDT)
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
Subject: [PATCH v6 2/3] drivers/gpu/drm/via: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 14:40:41 -0700
Message-Id: <20190804214042.4564-3-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190804214042.4564-1-jhubbard@nvidia.com>
References: <20190804214042.4564-1-jhubbard@nvidia.com>
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

