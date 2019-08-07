Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C29D84034
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbfHGBhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:37:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36714 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729712AbfHGBe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:34:29 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so42540552pgm.3;
        Tue, 06 Aug 2019 18:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XDFswRI13oGzit66yuxshlgOj+nOKd4gwJhAdxr7MGM=;
        b=X+oC46vd7xsqyIlCfk9jfvvzV6KsruG8Ld3KbyZxbsoEi8/HO1GbnyS051djmD0t5e
         IHHS/+1UxUZwPEi5YIHD09i1hw+sYQFPMWL5MXVDvXn8jTsvyuss+94LZL/cM8p3bjpq
         d4b4EaFpAv2r0fuq82w4gX6G8xDhtpwliffNpgIRnaMzTN6SuMgZ7nNfOclK8ThivKOZ
         7xyX43NI19Uw1hhV+vBLTAkRAlmFP4cWwG7rBuQsdFHL+GJXdhmd4ykYSxe8XYPo9VdG
         z0ekXKuUssjo5Om7rTdk/VGJmbSK9hbVth13oi1xkOKAckGir4q2yshriVnE4uLo3fC5
         EABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XDFswRI13oGzit66yuxshlgOj+nOKd4gwJhAdxr7MGM=;
        b=gBo+KwoVYsjc76HHLlqsGgAogwvM9fLz2h/UGTkqf0P9aC6n0eUn5mPZP5ZxSX7J0e
         SskBfHRL7ZMFCVMaA0eKd+NiaohVNoQ8aAcBQXacl/gtcn5xvR6ZmouNmi/6uMcR7PyN
         rxcUbtlDAMd1EHaDOS1B1CTw/Td2hMkoWu7NXggUNtK16fXx/vnok3E3YMSxYm1kYW7y
         vs3We14/OX1gO2VYdcAgJR/Ccz11DJzF0vVgns+D85uZO8/3NK7sf4rd/3cG2/Sxys75
         6Ol2yjPvwOPwyXshpLYrxqkaOV7NqR3AfhvMNMdBCNL0MwuUXrQkyGBTdypQ/evx92EV
         e2Aw==
X-Gm-Message-State: APjAAAUaUCTfN21jQdSoYvv/TYKn8duvkCwEENxiAdT1NqMrcB4/KDn0
        O0THtrA2gTQm+Cax3QnW2A4=
X-Google-Smtp-Source: APXvYqyNVjxjb1rRFJ4zL7VZgTd8hKKqHIiZI2K7th6msFTgZFcONMzTsZWyvyMWu34CEbDocoskag==
X-Received: by 2002:a65:5202:: with SMTP id o2mr5279108pgp.29.1565141668202;
        Tue, 06 Aug 2019 18:34:28 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.34.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:34:27 -0700 (PDT)
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
        Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v3 27/41] mm/frame_vector.c: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:26 -0700
Message-Id: <20190807013340.9706-28-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190807013340.9706-1-jhubbard@nvidia.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
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

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/frame_vector.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index c64dca6e27c2..f590badac776 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -120,7 +120,6 @@ EXPORT_SYMBOL(get_vaddr_frames);
  */
 void put_vaddr_frames(struct frame_vector *vec)
 {
-	int i;
 	struct page **pages;
 
 	if (!vec->got_ref)
@@ -133,8 +132,7 @@ void put_vaddr_frames(struct frame_vector *vec)
 	 */
 	if (WARN_ON(IS_ERR(pages)))
 		goto out;
-	for (i = 0; i < vec->nr_frames; i++)
-		put_page(pages[i]);
+	put_user_pages(pages, vec->nr_frames);
 	vec->got_ref = false;
 out:
 	vec->nr_frames = 0;
-- 
2.22.0

