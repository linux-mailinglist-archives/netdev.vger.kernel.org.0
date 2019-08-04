Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E63080E6F
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbfHDWxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:53:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42541 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfHDWtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:47 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so38581858pff.9;
        Sun, 04 Aug 2019 15:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1X33MY8P1PVcaLkCZcp6PkXiHV9wvPThIXgNE9TFbj4=;
        b=L35X2QFh0M4JIQvOmPagjixwdLqggClkiY/ITRED3vd5cYmML5rpnhsQYVeJG55L7X
         lfpM/Rw8+9+KW1xLlbUjjd2pEukAuHL9FPW2brNIFLNAAe+xFNLiBhvXwHgfebwSPh6b
         PQimMsMZnxgRdBC8pyrRMZ9Xs902qjGDWwSRlQpLzHZkXMK6vYaJ7jNHAlwygvXZxKWD
         HRNszvS/yLW3PMoeuHrejzjB7JHf9PJVVvjCC1Gi8OYeSyaj8QqsLJjtyVPXxwKbhU1l
         56SfAsWTx6H5Myy0JvyaDz6KAPklX1grAzJq4JD5PKOSOMwKa+X4MP3JYOJahIqu806a
         4oGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1X33MY8P1PVcaLkCZcp6PkXiHV9wvPThIXgNE9TFbj4=;
        b=oCPGFPSDS4T7TX3IEnMmJTOghSrlU2eHc69u5U1uO2wXrueTSkjXppMxtYOCb/ZOgm
         Dcr3zX0+GN0oQPZXwCxktjZiKDYQ9OOvBh9YQdBhZuiKkBTilqfyc5w4NGmFuw+D81KN
         jy9UM3ntP0gTs0m6tAkbnSWKUoWUDrt7hJOmuzo9t4sF1VDdIsBObVr++ywRlCtW1cz8
         ml4vTUxYOCGDZaFaq3h01SrqbWWffpcapz9MZBTa8yMVLA0duWckmCBr+lQFtDE9xtAX
         xux1aLH7woS3mBssCCa5fBMaTG380DVr44KNWlSohxIh0BpQ3Ko+rR4qkueH09r5slJd
         HD1Q==
X-Gm-Message-State: APjAAAVaIERQtzKGdWBEwK98gdO6JUtRA+7nApUHLOUfPhrQmeH2G4MF
        aDzvaU5ykQRO9zoQNU77Eek=
X-Google-Smtp-Source: APXvYqzQPIYoNRubdZIOtSxTDDzyPgcMaQ5zki3KNapO18w6JwMFrcpCjaVO/4MzoXfe6L31Al4dig==
X-Received: by 2002:a65:6859:: with SMTP id q25mr22221333pgt.181.1564958986332;
        Sun, 04 Aug 2019 15:49:46 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:45 -0700 (PDT)
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
Subject: [PATCH v2 17/34] vfio: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:48:58 -0700
Message-Id: <20190804224915.28669-18-jhubbard@nvidia.com>
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

