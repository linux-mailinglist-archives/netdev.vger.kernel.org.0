Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8506F889
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 06:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfGVEaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 00:30:19 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37583 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfGVEaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 00:30:19 -0400
Received: by mail-pl1-f194.google.com with SMTP id b3so18574750plr.4;
        Sun, 21 Jul 2019 21:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D+V1JOqHKw89xuQJyKyrQPxBPg1TKqg5mmM4KBGZiv0=;
        b=ZjncIryvRUENukVshJFmndluvLLU2arKIPK+YYicUChsIoVAk47zJe62/xRGnaP5sO
         2dIVuxokgzVnbQHvCzkTXpkUYAmteOI1byf9i0Eh4Nry32SQ9hACfIfRqzVmd9cJiRLV
         K9HwOtYgSWbkF9G0wSK5xDI2GGAAixptvpE4fTe363E9YhkxmADQ/Mu9XRx8bTc2aorh
         N1o7z9m3WHPe2EsrnhH9xUt6CS36Mz9r/OpIcDwkj8s1H6FUiNK+g6MeR3C2qRQdfIdw
         al2E1lXQJ0Y1vWlKKViZ99Kmj6ELgJUAJ+cq1tdYD2dh7ezt2sYlt89O5gvFrEpEQJG1
         ZAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D+V1JOqHKw89xuQJyKyrQPxBPg1TKqg5mmM4KBGZiv0=;
        b=GMJIw0P5FdXu0ek0WSxrDhJSr5mPvUasIBTqo69Y/u3LP7Wr/kIw/c9uCiWCUeNmX5
         qx4Y6tijLjdRaqN1PGJ3oYZBNayJuQ5BHCgBY398BI7LSPseiKSPxiW/HMo5al1I8Irj
         7k2jGaKZyX0SsF1f72yjfBq47rUjafvMn/2B4VeNlVk84DQh0pdBtkz/D+QkW/9Jqo5i
         rNX+pWr4wT+52N5FeZZ9dyfavyd6ACiYx1cbtEgGuVoFgVtDEFgY/AMpTfPFkT/1c2MI
         9oEz/gWVtGVyDIsxnrVmL1HmBCnpKgN0VHRZfzPzsYADODvIWic5rRA6Es8znQ8XhwFE
         kZXQ==
X-Gm-Message-State: APjAAAW4zxo5GC6SAZXbqJnpa0RVnUZ8TwTyvrXp3IfJyw9ejpAfcV7K
        5aVGLTioIDtWv6mp+vH1iQE=
X-Google-Smtp-Source: APXvYqxl80v/klDkLGiV/45cokVowIxuUImE7kMceTFkzRgYtQ9KqbkKZkwGuHiecTAs8feNRgDMBA==
X-Received: by 2002:a17:902:6b86:: with SMTP id p6mr74936264plk.14.1563769818237;
        Sun, 21 Jul 2019 21:30:18 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id t96sm34285690pjb.1.2019.07.21.21.30.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 21 Jul 2019 21:30:17 -0700 (PDT)
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
Subject: [PATCH 2/3] net/xdp: convert put_page() to put_user_page*()
Date:   Sun, 21 Jul 2019 21:30:11 -0700
Message-Id: <20190722043012.22945-3-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190722043012.22945-1-jhubbard@nvidia.com>
References: <20190722043012.22945-1-jhubbard@nvidia.com>
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
 net/xdp/xdp_umem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 83de74ca729a..9cbbb96c2a32 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -171,8 +171,7 @@ static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 	for (i = 0; i < umem->npgs; i++) {
 		struct page *page = umem->pgs[i];
 
-		set_page_dirty_lock(page);
-		put_page(page);
+		put_user_pages_dirty_lock(&page, 1);
 	}
 
 	kfree(umem->pgs);
-- 
2.22.0

