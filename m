Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F02FF80ECB
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfHDWz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:55:29 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38815 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbfHDWtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id z14so1431660pga.5;
        Sun, 04 Aug 2019 15:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wKnEf1dGeTf0vHOLp5WCTJvqak8NT8hcLNnzrVdQpMI=;
        b=UAVd4mr7vGvTBL1keSKDuwOUviwbBqcp6QKy80u93848ZN8eU6de8F8i32424yePdd
         zhJ1O4RduGczBUBLeccU6nytEoiOUUwRkUsjuEyue319dSQS2bud/HybqSeEP9UaizKY
         00ht31Ehoc2cMo40WzQ9rGK2yX18fybqCo7t+dG1vWpDgDbdQz/Q1YLF3bcEr/VsNC/+
         VEsECPXiobaIgfjOirKP1fhQQn2wJJKwgSQoEP5vN1KZqZSBZAcxorwveJr5kCfvgpyC
         h19lHwiz4dU7jiPcnb0kWz/BIQhyT1yRrfBg3wROHEiu6fO26e4X5u3gRUvcijrb3cqf
         EWfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wKnEf1dGeTf0vHOLp5WCTJvqak8NT8hcLNnzrVdQpMI=;
        b=jYPQF/6pC3kdwjY7bGeQTcWD8YIPLKthjV1FFm8jzwf+LRAs3tvcrIkiRk7153+51o
         eqgOXdNbKBobN8cNN6H4lkbfawnN94SspZ3SeEt51pxZqdGxI/IHysYMI516NfXeBieT
         zJnGLKfSWC/x2ih/ros579Fmrxr/roex9SD2YmrIzMtnhEPCZP2Pq6/28dWP1SZKZqjV
         masOXKlaxKvNST7tQZ2nFqcl6qzeH4zz+F2KU6hUEqUZWkVJZo4v6x0qsNUaU82JPPvL
         nos7nNLzmPZrdFz+HZJUcfcDEot815Glk51WDR6ejqv/cy9f4fGkkXBGlbNep8yk/DM4
         2mYA==
X-Gm-Message-State: APjAAAWpKI1PoYubhzY76mhmLOa1qUg8e+Qf1QFHWHmea5tDCSjk8hE/
        gvgS4EkRbQnhA2nwtIgzRWo=
X-Google-Smtp-Source: APXvYqzq3Lz+VjHUVJbOvV+K9KYqaCKO4VLPyE3SqnlHZP1nl3CDkSu6mPMA16qqbAvOmUhc3KYfTA==
X-Received: by 2002:a17:90a:1c1:: with SMTP id 1mr15255619pjd.72.1564958975035;
        Sun, 04 Aug 2019 15:49:35 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:34 -0700 (PDT)
From:   john.hubbard@gmail.com
X-Google-Original-From: jhubbard@nvidia.com
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, devel@lists.orangefs.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frank Haverkamp <haver@linux.vnet.ibm.com>,
        "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 10/34] genwqe: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:48:51 -0700
Message-Id: <20190804224915.28669-11-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190804224915.28669-1-jhubbard@nvidia.com>
References: <20190804224915.28669-1-jhubbard@nvidia.com>
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

This changes the release code slightly, because each page slot in the
page_list[] array is no longer checked for NULL. However, that check
was wrong anyway, because the get_user_pages() pattern of usage here
never allowed for NULL entries within a range of pinned pages.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Cc: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/misc/genwqe/card_utils.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index 2e1c4d2905e8..2a888f31d2c5 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -517,24 +517,13 @@ int genwqe_free_sync_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl)
 /**
  * genwqe_free_user_pages() - Give pinned pages back
  *
- * Documentation of get_user_pages is in mm/gup.c:
- *
- * If the page is written to, set_page_dirty (or set_page_dirty_lock,
- * as appropriate) must be called after the page is finished with, and
- * before put_page is called.
+ * The pages may have been written to, so we call put_user_pages_dirty_lock(),
+ * rather than put_user_pages().
  */
 static int genwqe_free_user_pages(struct page **page_list,
 			unsigned int nr_pages, int dirty)
 {
-	unsigned int i;
-
-	for (i = 0; i < nr_pages; i++) {
-		if (page_list[i] != NULL) {
-			if (dirty)
-				set_page_dirty_lock(page_list[i]);
-			put_page(page_list[i]);
-		}
-	}
+	put_user_pages_dirty_lock(page_list, nr_pages, dirty);
 	return 0;
 }
 
-- 
2.22.0

