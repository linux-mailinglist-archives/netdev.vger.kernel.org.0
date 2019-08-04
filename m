Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3352E80CCA
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 23:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfHDVkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 17:40:55 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33591 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfHDVku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 17:40:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so38554760pfq.0;
        Sun, 04 Aug 2019 14:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GHzc1obwFKwJgG7nswfPGhmCYytguM8zaNUDmj5ciqU=;
        b=HKywskhQFfCisurHq0YN1aLN2VuiPqiZvr/Y0yCqSOvBpKBB6dfn1Ks85FkIOYLagt
         IEjEo2P7HBbsv7VlhjnKuygjXzMpnPaIGsP10h9HDIdzZHjUPIC3xbgsZDjtJvPBVGli
         Q0JbJ4saQdgIeAacaN8voYvTrpABTrxgQ2M5TdIqar+aiYV4J+PYrFEofW0vtuiB1W8d
         opC4ViUFAQNDeWpOVJhlcHdA/+i8Qx8dpZcNxVU8J71QwLdaBiQj1o1QAdYA4aqniQge
         UufbAYoYs/svUAkwE0+PqikjTcfydpE8p7sULH9rSBFGj62Li+L68qWV/CJi6vPwTNy0
         c48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GHzc1obwFKwJgG7nswfPGhmCYytguM8zaNUDmj5ciqU=;
        b=S+2vXdcCSZ2oKqQg3wmkUMWHyUhrOaFQcPYlboSJA6hRiZxdnV9jlMyLPcpL3kAezp
         9aqf4YrcO9IDGp+8mMgDAehH3P3r0QuOOTJzjrxuZo9bXclGBvPDDApS8E0iBk3Thq38
         +at3fS+/fIOU4ieU9/becpJIjfBUygjELF3YNML3+1FtkqfDSYeZT/iQv4kYiuBBXJMW
         8LF+fiT63rDNG2vHr78kfjG6+McRuD0La3+6h2GYweqWum+Lh5Nm5N51pCcvRiVOophq
         hJj9STlyBlXK+CXi+YEQmqUyvvcGA7VdpnUBkzQ71rmsxkLbeMoxSTUIqOetAvmhy/pm
         GbqA==
X-Gm-Message-State: APjAAAUdAO2c/xSChLm17Ki+JeFuOcZ/ERlrYgL4wr5QXyou2NvvVMvL
        NAiBNrIm5OmYIHSLDB83k+Y=
X-Google-Smtp-Source: APXvYqy8FgpOqv4dwZxEbnr2U6myskz4yWgwHk7iGYAw3xfiu+D0Vw5P3EnbA0kXFBgzC5qKDZtyLg==
X-Received: by 2002:a17:90a:bf08:: with SMTP id c8mr15109867pjs.75.1564954849997;
        Sun, 04 Aug 2019 14:40:49 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id 143sm123751024pgc.6.2019.08.04.14.40.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 14:40:49 -0700 (PDT)
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
Subject: [PATCH v6 3/3] net/xdp: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 14:40:42 -0700
Message-Id: <20190804214042.4564-4-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190804214042.4564-1-jhubbard@nvidia.com>
References: <20190804214042.4564-1-jhubbard@nvidia.com>
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

