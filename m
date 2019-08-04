Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5679E80F05
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfHDWt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:49:27 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37103 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfHDWtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so38589442pfa.4;
        Sun, 04 Aug 2019 15:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WGaquJbd5n3vWHVjzVcVo6+uSZsjc3dg9cLGAnxVc2E=;
        b=S3jwFjBv5vti4GSNOLl7usS2vDqH0Q9mdQIeQBRHCABbXZXQSp9OsVY/w2xyL7nTP8
         ZYecNdZYrgO7L+BkQcVPzicUza9nsgbAymJTn56ppaJJ1MbzTKSlKgcZSuVPBHENjv96
         hkgFAzqYxwazXKgNX9N/DjLopqfptr24zOfeivm8zYWH/Y75M1kPiFzhZPYTKsRYejq8
         i/m0sGMLE0jqJ3DENlV+rsSfWOzYUSK0mHJPDAK/WyMC/O+T7ek80SstkS2+jwGF+2aN
         2FgMJxAUKbEXaB1QNjEZ05NRrBMlTBOCQS3Bubk6f7+zHMTxlbMDQcuH/aK8PZQ95vOe
         ii3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WGaquJbd5n3vWHVjzVcVo6+uSZsjc3dg9cLGAnxVc2E=;
        b=RpjqlaaaX4pat4OSpcXE1tzArAswqgkVuvdAraU/qccYChwBMBo1vMZOy1A4qqbpCm
         YtvN2s4VtDRGmZFnhNAU6d6fKiczTv6jVRugcDcC9mRcHFgZr5JdGMCHelPyhhR4m+q/
         E1kxAve7nDuGR7g3Nwnpcr+5VmJxQKE2Cz/owk5t4nxZcrVTaRiWeSSOxd3w0+4LvU4A
         fi5u0PHEBGHsqhwqvh03+LYSI23BoWM/ny+MiL3TWafuY7KDcx85HxHyLoCXT3nX0mBB
         2tBqFzZwBwLiHqFRQqd6HcAAg427MPBes7xjcgXy5bIB47iHKVRd/IywC6U7hrQZFEzj
         B0KQ==
X-Gm-Message-State: APjAAAX4glajkWwaQXd0viZPlIHow/gAtBsFCi+GzV0nTCO/uww6YjWz
        se+1ab207NKcs6JHKLuumgs=
X-Google-Smtp-Source: APXvYqzMm6zKD1x+1cfVe8U+T090I2azs0Ee52Xlzl7grLFlv9DOqy91TsDRd0lMc4ZI9h+s7gPOKQ==
X-Received: by 2002:a65:41c6:: with SMTP id b6mr76655023pgq.269.1564958963508;
        Sun, 04 Aug 2019 15:49:23 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:23 -0700 (PDT)
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
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v2 03/34] net/ceph: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:48:44 -0700
Message-Id: <20190804224915.28669-4-jhubbard@nvidia.com>
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

Acked-by: Jeff Layton <jlayton@kernel.org>

Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Sage Weil <sage@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: ceph-devel@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 net/ceph/pagevec.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/ceph/pagevec.c b/net/ceph/pagevec.c
index 64305e7056a1..c88fff2ab9bd 100644
--- a/net/ceph/pagevec.c
+++ b/net/ceph/pagevec.c
@@ -12,13 +12,7 @@
 
 void ceph_put_page_vector(struct page **pages, int num_pages, bool dirty)
 {
-	int i;
-
-	for (i = 0; i < num_pages; i++) {
-		if (dirty)
-			set_page_dirty_lock(pages[i]);
-		put_page(pages[i]);
-	}
+	put_user_pages_dirty_lock(pages, num_pages, dirty);
 	kvfree(pages);
 }
 EXPORT_SYMBOL(ceph_put_page_vector);
-- 
2.22.0

