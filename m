Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B520280DDE
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbfHDWwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:52:06 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41376 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727609AbfHDWuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:50:01 -0400
Received: by mail-pl1-f195.google.com with SMTP id m9so35552091pls.8;
        Sun, 04 Aug 2019 15:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uQGOdku7Vl3REPvOJ8nTMNJxS9zoi9IIquO7PYdcYIA=;
        b=oIs58MXEzvjiKDUeW9Xx92JohiWAGomnLQHItXPj3gpTBXaBLirgbU7J3jjvMstF5d
         BR9zwxRQqnHrZHmC+32LB+Dm9++A3dYw7Z2gJLbUoT9k9Up7ZxFGUG2x0WkDD/8qau+X
         8ICuV69VxIrVLbwg5iBoAnxA83TGhAb0DJKf1XP2ErlJJVcbhXrO4o1FNI28ciyGEPgV
         qFlJ/47uB+ONPIryHewnPf7OnXpaPBMbJVHPddHFRguTyQ/cP/UdMYVUDXMppTee+whc
         a4C30SWihk27rz0hGEMgPT9159ZIY9uL4Q4yGaDE4CFFho6QVBfddU7eeA74Zc4mT+ns
         u84Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uQGOdku7Vl3REPvOJ8nTMNJxS9zoi9IIquO7PYdcYIA=;
        b=W50wVLfFTSWyQO/u7uMvTwNatnCFK5Ur9jjjSCQy7yDm40Xgj2oy8SKE+APkHGh6ZQ
         d9DbamcFUne+mEu/di3XXVwDU315CZWhP7CHsftkz3IN08EpdKkEOcR5FFEhr/IHjVVD
         zP6rFZDH6/U+8r0isS/2QIr7AK97d9OA5ce2VkGc8BDY10nGDzPg6sD/DppM68HaoAlW
         xm9wCeICDp/W5tqAA70Msh1QaJ8dL9/vif5fTFwNJMStwxhn9YGVuibb0YxusG9dgx20
         zoWfkIwH/TNeYtCLTkuFvuk10A2voez68LqfJD1fjU4cZQOZSJdQhKKICWDBUM2YST8u
         FOxA==
X-Gm-Message-State: APjAAAVPs8BZg1YyjuufvMRisY5occes6vDQw55BxoJjYxOEMnd1X+96
        IHH34UNADISN1jH83iz5KlQ=
X-Google-Smtp-Source: APXvYqw3vCtbIdRevAqGeALSRYvYtlE73TuMq0puGfIkY6Ze8a3qg+Hme5vTx4BKBMgk8zaLu9jyhw==
X-Received: by 2002:a17:902:2b8a:: with SMTP id l10mr141386929plb.283.1564959000721;
        Sun, 04 Aug 2019 15:50:00 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:50:00 -0700 (PDT)
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
        Keith Busch <keith.busch@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 26/34] mm/gup_benchmark.c: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:49:07 -0700
Message-Id: <20190804224915.28669-27-jhubbard@nvidia.com>
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

Reviewed-by: Keith Busch <keith.busch@intel.com>

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/gup_benchmark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/gup_benchmark.c b/mm/gup_benchmark.c
index 7dd602d7f8db..515ac8eeb6ee 100644
--- a/mm/gup_benchmark.c
+++ b/mm/gup_benchmark.c
@@ -79,7 +79,7 @@ static int __gup_benchmark_ioctl(unsigned int cmd,
 	for (i = 0; i < nr_pages; i++) {
 		if (!pages[i])
 			break;
-		put_page(pages[i]);
+		put_user_page(pages[i]);
 	}
 	end_time = ktime_get();
 	gup->put_delta_usec = ktime_us_delta(end_time, start_time);
-- 
2.22.0

