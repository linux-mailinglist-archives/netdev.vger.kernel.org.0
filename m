Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF34A7B4A0
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 22:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbfG3U5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 16:57:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39958 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbfG3U5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 16:57:13 -0400
Received: by mail-pf1-f193.google.com with SMTP id p184so30455139pfp.7;
        Tue, 30 Jul 2019 13:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zIg1AeRgD/CqkmVywbx+SzJM6fRrXplz7aYhAvptzng=;
        b=XPofLF/PHutz4HRxq81cl690l9JazNX7DE9Sz1LHW56Ma+PaWewPn4NCX7vVDtKrug
         q4GYLQHOLbQNIyzRjkilYec92LYHDHYE3s7umnjLyHZVoR8ACBwShBGZlhCQzJ0e/K9n
         G7PcNQdBdB1MIJeCd9Jz0A5GyrPYQBkVdaffdydfOlpBLG3dhqUxeiCBrG1LWqTE7Xqy
         zmL+9yVwrhVt2Kz5wb2SR2RniJWXisEJMoF7R3sZthPZBIVjkuCkP3ahQg4hWjCzfAjS
         HmJSUf3TZqxLbfGjRtE0Yjx4i11cxdEwGB/Fo/WLx+/qENW7fbOiVLgn4HM3pHlMEDwz
         K+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zIg1AeRgD/CqkmVywbx+SzJM6fRrXplz7aYhAvptzng=;
        b=Vx8slnE/HxNKYox/WR+/ciNJMUFQHwzvjhWAbz1FBZBGb5KQZX4ihvswFNUqRJ04Te
         nK73QQgZB9ypa1TiFBJglNEpeXDie2gHXPJKGxIFyKdUVXENngZqJ85Z9i4knajwbxgg
         Gcep/7OVYaZzXTiDtI56G/RgZkrAX98TFbMvqoV5YhNGvukGx+WVerLwfWwOhJ6oKTEi
         wDWotlkeZjxc/rw7Rty3Xn57777fsGNXkJBhU5LI7s8/A37o1neIzEGH6peQD5vvF7jO
         BV4H8T46aKgneyP563LK09BNS6MURWXliLZwFbHT4nlsVdEwgQj+SHBap/N6N+AIzdk8
         kSGw==
X-Gm-Message-State: APjAAAWMDlPTB2RUgo6mz1+w916IG2rCQWH70AcK0vOenSUEpVZx2C0G
        GN9EmeJKbIRtu+yyLEsdErs=
X-Google-Smtp-Source: APXvYqxsCn2vX6p1aDH+4gab5/zzeAvDw245fAqNqTfAzQelWKMC8Rw1mqVzx4xsB8ePETum3mpINg==
X-Received: by 2002:a63:121b:: with SMTP id h27mr95395492pgl.335.1564520232325;
        Tue, 30 Jul 2019 13:57:12 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id 137sm80565678pfz.112.2019.07.30.13.57.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 13:57:11 -0700 (PDT)
From:   john.hubbard@gmail.com
X-Google-Original-From: jhubbard@nvidia.com
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Benvenuti <benve@cisco.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jerome Glisse <jglisse@redhat.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v4 3/3] net/xdp: convert put_page() to put_user_page*()
Date:   Tue, 30 Jul 2019 13:57:05 -0700
Message-Id: <20190730205705.9018-4-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190730205705.9018-1-jhubbard@nvidia.com>
References: <20190730205705.9018-1-jhubbard@nvidia.com>
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

