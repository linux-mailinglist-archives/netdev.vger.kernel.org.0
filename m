Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC2E6F881
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 06:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbfGVEaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 00:30:20 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46311 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfGVEaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 00:30:18 -0400
Received: by mail-pl1-f196.google.com with SMTP id c2so18541295plz.13;
        Sun, 21 Jul 2019 21:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WbaMzabtgu3hCeOMPX09tru106PZHAIJnqruZQI71c8=;
        b=p3HGgaINx4UXmNtxMRxq9ZG6NzncIA85CDVJwUAyirDvW3yCo2di+TLZl5eFlPnNmI
         tKBmRpm/+GE33EtGsFzwMuLEx975vOoVhficjaLeRIsopct9Hcl7v/XU1KBwOEf2xMZN
         BHRmQquzbiIcI70dnx/HawsVNNS5fDl4FFWtUv/EmNTaCRi74oUprzweRieVqW1lCakX
         xGU3Yfp0T2yQHASWYcYkRONsVHYAjwfmIRSdrvV1yxpWlXG/IgI4pD2tDC41W7YDhh8Y
         2xv+vtpzYgX36LzrXQsbqLPBzjZi80AqFoHhWGNEYVEtoMdLjAhgYaYrgI/kXAfMuWv+
         Cbsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WbaMzabtgu3hCeOMPX09tru106PZHAIJnqruZQI71c8=;
        b=kGPUU1aVeHLEtDfKUVz2QNFlkPwZVVkEpfrl0iUtLE6lBgEfmYvhaS8zUbwRp2CnUw
         6qPvj+6aimTmpiX6sMK/xFjs7g/CX08VmyZvfaz3eKfHoCsDBIfMcMMEYFLi8CIQ3hu6
         ay0sUz0Bqiqz1aTmAZOrAvcafXcqOG2hVZ8+GH2pun6ooD41iyuP2CejTSxkHrLNqBxv
         vl5tentpdHNcKokkNpSfeQHnOcOv7ogXyheYrSyGTy5cY+KH+u0yfuH+18R3Y/jCu12v
         vqaFtrhCd5Lo4haCzxAuBsypqh3h5Ji6C4yNA5t0+PMLnDOjksdmt0fUB9e3e1NzHQ0Z
         qjRQ==
X-Gm-Message-State: APjAAAUlTIe3br5Cu4l0BjmGfOINuPgKSM3ELmN/F5NcDFbuop6Ym5Kd
        iOaur0tQv5pNgjjGdeqygKQ=
X-Google-Smtp-Source: APXvYqyKR4WrwxhhqPsiCdGlG1x0qIsswj14hIfFs7IMQOgAz1KccUwekZlyy0ZSOgH/yneXklBTJA==
X-Received: by 2002:a17:902:ac87:: with SMTP id h7mr75701953plr.36.1563769816971;
        Sun, 21 Jul 2019 21:30:16 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id t96sm34285690pjb.1.2019.07.21.21.30.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 21 Jul 2019 21:30:16 -0700 (PDT)
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
Subject: [PATCH 1/3] drivers/gpu/drm/via: convert put_page() to put_user_page*()
Date:   Sun, 21 Jul 2019 21:30:10 -0700
Message-Id: <20190722043012.22945-2-jhubbard@nvidia.com>
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

For pages that were retained via get_user_pages*(), release those pages
via the new put_user_page*() routines, instead of via put_page() or
release_pages().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/gpu/drm/via/via_dmablit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via_dmablit.c
index 062067438f1d..219827ae114f 100644
--- a/drivers/gpu/drm/via/via_dmablit.c
+++ b/drivers/gpu/drm/via/via_dmablit.c
@@ -189,8 +189,9 @@ via_free_sg_info(struct pci_dev *pdev, drm_via_sg_info_t *vsg)
 		for (i = 0; i < vsg->num_pages; ++i) {
 			if (NULL != (page = vsg->pages[i])) {
 				if (!PageReserved(page) && (DMA_FROM_DEVICE == vsg->direction))
-					SetPageDirty(page);
-				put_page(page);
+					put_user_pages_dirty(&page, 1);
+				else
+					put_user_page(page);
 			}
 		}
 		/* fall through */
-- 
2.22.0

