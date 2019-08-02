Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC9F7E9B7
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390789AbfHBCUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:20:31 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35195 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390704AbfHBCUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:24 -0400
Received: by mail-pl1-f196.google.com with SMTP id w24so33011752plp.2;
        Thu, 01 Aug 2019 19:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o2GwgSJoRuvPfZ2J7Awdgxw+WyrY01QvDnyFb1fV9Xk=;
        b=JHrYMRfeJbxJPRvVu2mUWlOPSRz5X9TsMoYGj7w11YGTme72BLb2VCmJtiT1crMj8E
         WFW+MhbnbkJpTwkrKMzEtbVI7vTqXv+SI+hFx6FZWh0IsKOr81DSRZrT3ou0zge/dnd5
         EXgsdat7mGxiPUC4r8AnIJEtDvOIZL+G3eepAaSt906tZ2zy13M8CWEIWzA2V9xqXZwe
         3r8aKK6oVTx9NMfrfbSmVNdddYS2ismfu/I+qiVZNMv3LWt0KFKP68hGnbZ9FH7YXxJX
         ux6o95ZiuMx2wtoGxh0CwNNs1fyU+QkDE3uHv/C0GSypFYyOdTrFbpn3G312jKYOi/u7
         rhUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o2GwgSJoRuvPfZ2J7Awdgxw+WyrY01QvDnyFb1fV9Xk=;
        b=RVOgkgzP1W5ApdZT6dPDdesNg+AFXGrnw47X9S8qompGJHk4Eig8n4E/mhsicMwZ6m
         58B6O2at+oPrLZ7E7BdXJtj6PuCpzMKuUcBwLVLZZBqOxKbhK1x+XQy2AeWup027oMM/
         0XXzmA5qSEbfeNN5G7Z/KBV21opgE+BQ9fZqAhVaHCSLD9wX5Fg6ao7bLeerr6kpsysq
         EcFHFXQHJnWUNaUu41mcIxBAzZW5VlfGi2ZjY5TsjM87ofA0LaYpHAgdNSjGtGXdus7w
         dZ8YQx5Yqli9bbIJeGr/Zp4K2jL3/WWC7SgTkFmvO3B4ZlLp6elNgyKeBxq/LlzGpfVQ
         WYxg==
X-Gm-Message-State: APjAAAXpx603NQZ+H8yZbGF4eFlJsiy5FdPLQWRZEZCikXtMDC/XDqjs
        tWzyyH+8i8MRb56zx+YwToI=
X-Google-Smtp-Source: APXvYqzAaZbEuJQ23N6QFJdC6uFCaO+rLm14VcZtE9+tOy9uyfg9aPHBipIj9sgNkOpEwRVfN6Xk3w==
X-Received: by 2002:a17:902:9688:: with SMTP id n8mr126124101plp.227.1564712422766;
        Thu, 01 Aug 2019 19:20:22 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:22 -0700 (PDT)
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
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Zhou <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH 07/34] drm/radeon: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:19:38 -0700
Message-Id: <20190802022005.5117-8-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802022005.5117-1-jhubbard@nvidia.com>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
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

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: David (ChunMing) Zhou <David1.Zhou@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index fb3696bc616d..4c9943fa10df 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -540,7 +540,7 @@ static int radeon_ttm_tt_pin_userptr(struct ttm_tt *ttm)
 	kfree(ttm->sg);
 
 release_pages:
-	release_pages(ttm->pages, pinned);
+	put_user_pages(ttm->pages, pinned);
 	return r;
 }
 
-- 
2.22.0

