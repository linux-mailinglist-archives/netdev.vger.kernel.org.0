Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09627723AA
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 03:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfGXB0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 21:26:23 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37519 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbfGXB0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 21:26:15 -0400
Received: by mail-pf1-f194.google.com with SMTP id 19so20022821pfa.4;
        Tue, 23 Jul 2019 18:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zIg1AeRgD/CqkmVywbx+SzJM6fRrXplz7aYhAvptzng=;
        b=BXqsh80Nl4cDZcRUa+Nux4yM46naJJQtkxKxn8QzLhVcqDBWMLcxIvpEfojCwCxmNb
         KDP337fhhZiSsUY+ie+iYwy+2LsmwUDrAbCBafzWMLvZeUwJrYtszfn5BpBMhwbZRXEE
         ls7+Qu+a79sZuQw2/Y85G/uzux5nCGoCZnl7NXJeaNUrSOxj+wZ3LMZFEs4kUib49d55
         f/aP9kCOfXD7XfWhkmk5SMVUXE+iny9dOyzsBMo4r1sLMn0DtURnoVBQNLDjNrhOdtJB
         ZaPsyiQ+nd6BdhyOicPLzNhKQsZJ8Wv5E16OYyRJt7ANMgAFPyceIosc6BbyNvMrTUAr
         XRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zIg1AeRgD/CqkmVywbx+SzJM6fRrXplz7aYhAvptzng=;
        b=o9ApCmXhiFgJiYyWqh0UTPqIhAVZMkcOsAa4oPUZqJJ2pO3HSh+t2MW1X2HXTI8Dzm
         2Djfk0e7lxZe6xi11b9Ar3lVGk3nD7ZNDEu65SoIzC05MQMYlpiBxgCZz94FY0PsHD22
         tRswGkD6nSpSQFmT/oelTs2j8lc7P9MMMNO6ZgAL4HuMKMK5DMbgHstzEN6c6b7NxlqB
         smriQ0pBX3CdDY6sGdZHZWIDOglctNByPXOdj7zPN7xuM3PhqqdWejXdW1XafF6rvXQV
         nV88OC5MYLsEQ7u8jYhnnVjVqBlTkQ8ng/fMx5B7GHutC3uFWVYO95TvV7igp3RPnU3o
         NKew==
X-Gm-Message-State: APjAAAWq+JF7l1MuqRwDKtkTfPh9gJCmBuWmu+O/lOKKV6GkGsSasE8g
        o5hIi0huKOoPUxvzIDeP91c=
X-Google-Smtp-Source: APXvYqyCk61wnabNIK4Jxvfw+l2b6WmoUqrtPcNhmtW2WxlaOXFDgcDVuADNCkU4wpAGaRv/63OqTA==
X-Received: by 2002:a17:90a:db08:: with SMTP id g8mr82170764pjv.39.1563931574192;
        Tue, 23 Jul 2019 18:26:14 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id k36sm45950119pgl.42.2019.07.23.18.26.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 18:26:13 -0700 (PDT)
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
Subject: [PATCH v2 3/3] net/xdp: convert put_page() to put_user_page*()
Date:   Tue, 23 Jul 2019 18:26:06 -0700
Message-Id: <20190724012606.25844-4-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724012606.25844-1-jhubbard@nvidia.com>
References: <20190724012606.25844-1-jhubbard@nvidia.com>
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

Cc: Björn Töpel <bjorn.topel@intel.com>
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

