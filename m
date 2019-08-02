Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6BBB7E96A
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389609AbfHBCYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:24:49 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39900 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390865AbfHBCUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:40 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so35241237pgi.6;
        Thu, 01 Aug 2019 19:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0y5rJgolnpdx1vwnOpLTxW7O4fuw+3wJL+gU2Q7/qgc=;
        b=XcvG9OtyU86jk5JnQKO48GBJW89xfPHHxg+Ne0d0GJwSK2IuihtMCJFR8pabDqBzEF
         DuPSfNePU528rZ6hBUi+QFYoZILMY8tdggEmTr3mN7PzDRJ7a6OmrfV2tsrS8kf2+6HI
         Zo6kU0MY4gjn6C4vTTeXk9IHVKARwawE7INoHfJ5sfq56uo1gVj3e8g1oiz6b7OI/wgS
         KnIyWK9Z49VV7ULXr41yNDN0bWyja3EYTBz6mLtPsaZCe7aB+yHXvCTEBAOwbU3wp1bf
         uiomAHYjSX4K0Tach88phQCyk3zfRucll/enDp2U+3MmHAZ/atNajIitsMHfeEHfycq9
         ft2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0y5rJgolnpdx1vwnOpLTxW7O4fuw+3wJL+gU2Q7/qgc=;
        b=oF40EQAHQazFru3n+0SQS2GqdTuxmyS5asVTXRj9LrwSiHxPXjMBO09jZt1bKA/f/S
         PSuYBKN5RVVltawn9iQ9DQ2mLWS+Ny51vTMHUy3X+JxJ8mopA8QqX9zH78DImQ+/ztax
         Fp86cOPwks8TwDdZZzr1h/9R4iJtU7KGo4HMtTUeOL0/QgDAYiMmmgaBdhWtIOqv2OXK
         1TntABk2SpuFJC6PhGjqV2spzia/DUGTblLQBmCbGiuy1cjSl2ug+llYxfFGp06bYd9k
         KsB857o6Yn/8RicaKzX+Gr1un4cZpb5QmbpI5wl9ZWZopC1gVp/npcmlPxJJJm0KBQ/Y
         H+bw==
X-Gm-Message-State: APjAAAVo3nGdreQ/UWzgQnV/9/5SCRGv068e57l2kwDsPdkCLD1pptaV
        PUD7ttqQoz46l9gjsWReSI0=
X-Google-Smtp-Source: APXvYqwl6c8l8akPJ/a0xk+3KepmeSM3zSOQCzHQzAg87pSWv9yrqkhky05R7WwjG4AiAw2gALdPbw==
X-Received: by 2002:a17:90a:b908:: with SMTP id p8mr1903028pjr.94.1564712438974;
        Thu, 01 Aug 2019 19:20:38 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:38 -0700 (PDT)
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
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 17/34] vfio: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:19:48 -0700
Message-Id: <20190802022005.5117-18-jhubbard@nvidia.com>
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

Note that this effectively changes the code's behavior in
qp_release_pages(): it now ultimately calls set_page_dirty_lock(),
instead of set_page_dirty(). This is probably more accurate.

As Christophe Hellwig put it, "set_page_dirty() is only safe if we are
dealing with a file backed page where we have reference on the inode it
hangs off." [1]

[1] https://lore.kernel.org/r/20190723153640.GB720@lst.de

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 054391f30fa8..5a5461a14299 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -320,9 +320,9 @@ static int put_pfn(unsigned long pfn, int prot)
 {
 	if (!is_invalid_reserved_pfn(pfn)) {
 		struct page *page = pfn_to_page(pfn);
-		if (prot & IOMMU_WRITE)
-			SetPageDirty(page);
-		put_page(page);
+		bool dirty = prot & IOMMU_WRITE;
+
+		put_user_pages_dirty_lock(&page, 1, dirty);
 		return 1;
 	}
 	return 0;
@@ -356,7 +356,7 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 		 */
 		if (ret > 0 && vma_is_fsdax(vmas[0])) {
 			ret = -EOPNOTSUPP;
-			put_page(page[0]);
+			put_user_page(page[0]);
 		}
 	}
 	up_read(&mm->mmap_sem);
-- 
2.22.0

