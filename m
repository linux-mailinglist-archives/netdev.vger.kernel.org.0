Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6249E7E6DA
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 01:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388446AbfHAXrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 19:47:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42895 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388000AbfHAXro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 19:47:44 -0400
Received: by mail-pg1-f196.google.com with SMTP id t132so35047654pgb.9;
        Thu, 01 Aug 2019 16:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GHzc1obwFKwJgG7nswfPGhmCYytguM8zaNUDmj5ciqU=;
        b=E+zHlnIpYzBr1HZfJIsD6iVbo/tVCWCbZWGouwMcKWXf5pRqLr+7fu6t6wyR76gxrS
         Pw0XWBh+4s5Kr4C0zZ1uLNkWtKi03BCdpa29tA51sk8I+Bq12u0svuAUfdj+sK8H6N5H
         /8lixInmiBO+tmKzSLyeiGhsebOFRuv5X1HYeJ9NG7mhRRnXPabVEo0th3yVnfWLj1Ya
         c7rmaefTzcGx11D0smecmd6tI08T3Ivoz0JbFA+LCWcAMomm5K9oYs5qsT1cHM0HE8Jc
         UMhXpM08RliBjrRUsniYuwevqpn1x1w55S5+T81xoskFTv+eqpjGrmLmlIP9IsRGKn2i
         cHVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GHzc1obwFKwJgG7nswfPGhmCYytguM8zaNUDmj5ciqU=;
        b=JjQj06NvW0tuDk5dXz02puMHpI4hGYufOcxy1pHOB3npYUZMCWl9BsfSOmc52xxZdU
         8qSPFiSWa/Es2ZFvGy62O90bw+WGs056e3WMwlMvb8BaeJczdwfuRsM7lflT5KDCYrvI
         4U2T+4Zra/WMSapxnp5+zXOymrq1VIH9xC+X7cpGAqT0wWlL3PFmM8PlY75PRi/KxcGO
         a0rOhq3Pz6mW+RdPLZ1VExkSMrkHv7t4X6bWbAnrAj0m1hAbjQ6NQvuzCR4RvRvkgJK5
         RgPRI/7O9Qhn/XJEwgSAV5M55OqL6J1SxsL2jY6gmtDJyPlXvwTxc8CX6N4CLaQQNNE6
         tuMQ==
X-Gm-Message-State: APjAAAVguG+9l/vDRfMNEG8zJndXb0IJhneyloIBtXOcWpna9DIj1I3T
        srKCenHZ06qIjg7R5WTb9k4=
X-Google-Smtp-Source: APXvYqwtPIy/q9DIVACpqZOM6oV+V9VPUP/5mN1kfjPMf5x4eodvXZuVHIq97aECtPB0t2lwdk42bg==
X-Received: by 2002:a62:ce8e:: with SMTP id y136mr57190606pfg.29.1564703264155;
        Thu, 01 Aug 2019 16:47:44 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id q7sm79090792pff.2.2019.08.01.16.47.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 16:47:43 -0700 (PDT)
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
Subject: [PATCH v5 3/3] net/xdp: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 16:47:35 -0700
Message-Id: <20190801234735.2149-4-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190801234735.2149-1-jhubbard@nvidia.com>
References: <20190801234735.2149-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Acked-by: Björn Töpel <bjorn.topel@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 net/xdp/xdp_umem.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 83de74ca729a..17c4b3d3dc34 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -166,14 +166,7 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
 
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 {
-	unsigned int i;
-
-	for (i = 0; i < umem->npgs; i++) {
-		struct page *page = umem->pgs[i];
-
-		set_page_dirty_lock(page);
-		put_page(page);
-	}
+	put_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
 
 	kfree(umem->pgs);
 	umem->pgs = NULL;
-- 
2.22.0

