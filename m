Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035E77E8D2
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389177AbfHBCU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:20:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35025 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390941AbfHBCUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:52 -0400
Received: by mail-pf1-f193.google.com with SMTP id u14so35170057pfn.2;
        Thu, 01 Aug 2019 19:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XDFswRI13oGzit66yuxshlgOj+nOKd4gwJhAdxr7MGM=;
        b=hP1EduyKMG+yuXrF7KrLXpEWytv06HPkyhEngT/TxypVjl15UFdBSQ01HK831DacB6
         y18d2lzANesimTaq9XDZY67ictckhnVqIa+djvmZG+RwwqwovWVosZPm2hXdPP8mZbc0
         0yKrCu+VZPWp1BX7LdN24uYM7pD4/H1JhmD/G5vWAzU3HcQxPlc6uryb9qFNED1nmvuy
         vlc0Xyq/DfVAu1bkczBpbXVhlvoDYp/Xx1PasljpvjsnXilMO1dGN5gCe8VOPhx84A7a
         m7JqyBz4DRJG/5S/1NCOJ5bKHp9eLh6RG6N9nPftC1UPm2sven5C2Ciggp1fXGl7R4y9
         0EuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XDFswRI13oGzit66yuxshlgOj+nOKd4gwJhAdxr7MGM=;
        b=sURmNL/n87UpE9rzITiaE0R72mcL4/DfoufbILtuNTHhz6wjDzWuYFSY6PK69x0Qr+
         kxkJ8apfcVg2O2yhd1Trw7tS/ICwtSBwi1V2ZG/6zcuR0+xxLwdMPLTfPVhFRrMRZKoM
         5QWbPxF4OZD9yDVZy5cOZikPd1IzlkslMRzxBmYepHpuKtZlc4Y9lwS0a8pkWUQme/jO
         5vxVZtmZrhTU/a+FblSPO1egcOlQH6t065F6TPEFCF0ZrtDkysGD0qpZOrhZ681i2DPk
         ifpPpMEV638ZX6HwksAHPzpayhdjFEAHcq6OYLPy1zbspN31eHCcsamLwzhyW7DXs4g4
         KoZw==
X-Gm-Message-State: APjAAAVTZYUlnx2uzvMhAmsX1Q92nVGs6BozX8t3ktqo8QSoFSE8vMEb
        9/e7zwkvGVctjRW09fGlbjM=
X-Google-Smtp-Source: APXvYqxrGBxtmn7yAK9mdNxfQbE+IWGBlk1o9qGDinrparVfdT4goa6Xy1ipLTWrwKQoX2yj/q+h8w==
X-Received: by 2002:aa7:8218:: with SMTP id k24mr54831158pfi.221.1564712450876;
        Thu, 01 Aug 2019 19:20:50 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:50 -0700 (PDT)
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
Subject: [PATCH 25/34] mm/frame_vector.c: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:19:56 -0700
Message-Id: <20190802022005.5117-26-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802022005.5117-1-jhubbard@nvidia.com>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
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

