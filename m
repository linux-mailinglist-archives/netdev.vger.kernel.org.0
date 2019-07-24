Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89EB9726D6
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfGXEpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:45:50 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34457 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfGXEps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 00:45:48 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so14312710pgc.1;
        Tue, 23 Jul 2019 21:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zIg1AeRgD/CqkmVywbx+SzJM6fRrXplz7aYhAvptzng=;
        b=arDVEhmzmwYc0UEKQFalOXDiIHqPt1pV7vU0JUv5mKmQ089wfTwsdopP42Bp86zZ12
         9WIcbg0FL0S7NcMN8EBa/ZsKL/7UCA0dKCKuCKM+lXn0ABjHzkKf7GbzTzgsqLNlu959
         x8Wf+GMGeki27TD3sIzrhRYDi+0to0FseWV9eOKqeTdGtNvmAsbUvqbDLALoFmNeN8lC
         q8qaQ09EwqFPHJ0FosCJ6TkG/MI4KAUit4mNdGB4LeHjfVsf4BvlJpxIDvO5f0c0rcDz
         cnxHWz5yRd1W3BrSj7Xo/RaJcRj1t3haKXhTaAtTRDrTJ75HdwRRYeQcAOlujCws3i0K
         8Xcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zIg1AeRgD/CqkmVywbx+SzJM6fRrXplz7aYhAvptzng=;
        b=EZhE+lrleyRwjQIqZzTR73Gc+axWiq3BPKi+SRd585HhO3rvq37sLDCY/9HhbCETbx
         BPuEmEcI3234O8YkWQKg3/YUvmusw9Pzq5i8JRe7tBKrpxeswWDdr9rM4i4QjJ4IBxrJ
         xyZ77tTl2y20nKISNq/6YxAkNeLUfhyDmuhrMK4k2odlYkRQh36cw+YNHAprl9R7rNPU
         /Zb886M2BLV2APK+p0IQgLF9io7jnBzhi46t4Ar3ZjHWDk0OuqzmKOEhaVM5PdZJCG20
         I1aWHVgrQ5GDI8kPN1zjW7lW1Nk0O0bWpDf3ROSk8y0XyvTp9FzV/gBlxEwYUSdkILk9
         DTkQ==
X-Gm-Message-State: APjAAAWmzGaNnf8mmHc0prQkrNDJDHvTvOrL8ep6hfU48mqX8ta0ApGZ
        5Y6LhLkYk7fMZorSR/T3TmA=
X-Google-Smtp-Source: APXvYqxa/GK/rSekD6RsEbqfAEidKg6pPzN0E429BN4FKlNPqtfCT9Yymo4uvci3p2qlK1ysgtHEgw==
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr83262648pjb.138.1563943547267;
        Tue, 23 Jul 2019 21:45:47 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id b30sm65685861pfr.117.2019.07.23.21.45.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 21:45:46 -0700 (PDT)
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
Subject: [PATCH v3 3/3] net/xdp: convert put_page() to put_user_page*()
Date:   Tue, 23 Jul 2019 21:45:37 -0700
Message-Id: <20190724044537.10458-4-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724044537.10458-1-jhubbard@nvidia.com>
References: <20190724044537.10458-1-jhubbard@nvidia.com>
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

