Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C985D80E96
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfHDWtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:49:42 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39834 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbfHDWtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:39 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so38667051pgi.6;
        Sun, 04 Aug 2019 15:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j5bjFl/k0oxV1FIP4HazX0NuQurNmMvZSnaBil5PKNk=;
        b=MqpI7yn2v8JiaESKRamQoMhID5IYen684AVXtcKPVHm7ukeZx5WJLqHqdIEJqV0WrU
         VfCpQM5hioJATjULHPTYB3nfhDV1hZvNLdoXtUM170GmrlC8kjyYeFhBDtjPQS6eYlGi
         Z1KZbaNfekNsK96f9fHDqC8EM5JDem4jjQqa0uOUzUD0HnkcyB0RGrqGZafbKz+HSERm
         ycJb8r/hMPkJxrohrkltdvb3Bv5T3e9OF54rrvF1bh8OIMrv7vUbWFQiw+cjVGvVjkWZ
         fASWr56xEv6QUfwcZwREb2sSNIm1Ysoe7red/z7MjIlPR6uaG4NZls/tzbyEvLg9FjxD
         24hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j5bjFl/k0oxV1FIP4HazX0NuQurNmMvZSnaBil5PKNk=;
        b=L6FHDsvzLb0Vu8eeuOvWYygPUGxZONZTgyG6tW57aangYzKHzdD97TlhJXtLKMEOG/
         aRin8xoxDsxQsYK3sRThFy7vNHgqpEnEPWpUXDaLWwnHGten9dzdR6i1gpmcABmAyJMe
         lcTKi2XuyyQsnVfvlnx7hrvGYi5uqR7xXFweFKx17HCT4N3sjfTXBelptuqKpLazfBXA
         V/PSI8dNs1oD4ROMs75Ioa6uS5lHi5RWLHLUomvFsweeomNX58jmomBOAlwTph8oT8dl
         AbLVo7SkzvkkVy2W4wRKcmIids7C/dQhKjGVXYvIK/ZZPx/B5X+D+34TdczO0MgomZpT
         WDjA==
X-Gm-Message-State: APjAAAXkCeRoVBuY7Fv9zK60oVjza54YzRCUQsBiAv/MF43GwHPWRPQE
        ydg7ULw//TrTDEYuw3j9zXg=
X-Google-Smtp-Source: APXvYqwTnNt3iCmBWtT8pTi/FFYixGudghLt9/4mGGXij726CsdCF3vK7jbIkfaYxVJp0BLjNqynIA==
X-Received: by 2002:a17:90a:b908:: with SMTP id p8mr15231945pjr.94.1564958978299;
        Sun, 04 Aug 2019 15:49:38 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:37 -0700 (PDT)
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
        Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 12/34] vmci: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:48:53 -0700
Message-Id: <20190804224915.28669-13-jhubbard@nvidia.com>
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

Note that this effectively changes the code's behavior in
qp_release_pages(): it now ultimately calls set_page_dirty_lock(),
instead of set_page_dirty(). This is probably more accurate.

As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
dealing with a file backed page where we have reference on the inode it
hangs off." [1]

[1] https://lore.kernel.org/r/20190723153640.GB720@lst.de

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Gustavo A. R. Silva <gustavo@embeddedor.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/misc/vmw_vmci/vmci_context.c    |  2 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c | 11 ++---------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_context.c b/drivers/misc/vmw_vmci/vmci_context.c
index 16695366ec92..9daa52ee63b7 100644
--- a/drivers/misc/vmw_vmci/vmci_context.c
+++ b/drivers/misc/vmw_vmci/vmci_context.c
@@ -587,7 +587,7 @@ void vmci_ctx_unset_notify(struct vmci_ctx *context)
 
 	if (notify_page) {
 		kunmap(notify_page);
-		put_page(notify_page);
+		put_user_page(notify_page);
 	}
 }
 
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index 8531ae781195..e5434551d0ef 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -626,15 +626,8 @@ static void qp_release_queue_mutex(struct vmci_queue *queue)
 static void qp_release_pages(struct page **pages,
 			     u64 num_pages, bool dirty)
 {
-	int i;
-
-	for (i = 0; i < num_pages; i++) {
-		if (dirty)
-			set_page_dirty(pages[i]);
-
-		put_page(pages[i]);
-		pages[i] = NULL;
-	}
+	put_user_pages_dirty_lock(pages, num_pages, dirty);
+	memset(pages, 0, num_pages * sizeof(struct page *));
 }
 
 /*
-- 
2.22.0

