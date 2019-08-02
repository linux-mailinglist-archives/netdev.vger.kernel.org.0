Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F4E7E946
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389565AbfHBCYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:24:17 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36965 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390898AbfHBCUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:44 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so35148529pfa.4;
        Thu, 01 Aug 2019 19:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NpCZQ4VK8hzAbP37Qxye6UhXG/4cH2zDttwN2tDhLJk=;
        b=hA+dHc1dKtzF01UNAT1GCb910It9M6OYeo1UwisVEiPximZ0Uizqhd58Gx7EN+cwqG
         oOXAC9GpXS9cMgyPAFeZsWw6yiG5HTsH6dTfrkzHKXhkxbTehvYO/DkXd3o8uGT1hUxz
         8W3I7PS2I6VpD8By/LG/APt7ortKYREWRihQ/MahJgv1XZqDU9aXSO+0f9WVFU4wcOzF
         PifhANph7r1h1aR2sJtcNbzpatSVDPr8LOmoCCwtkUnv/6xTTuq0KjPRlt5jI5AQn0Bo
         qGRQZk7nx9WeapKs5M+9pdwyKPbEullYlAI/CW2M7lTdWIAU5bo5Tw/OmRhRr64X9QFj
         r+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NpCZQ4VK8hzAbP37Qxye6UhXG/4cH2zDttwN2tDhLJk=;
        b=BGU04f1tPQIEAI8So7W7hrvDA5qn+hWxqIhH8lgwXodHmdPZbjAnf28pxkUgRBDw7O
         cNFremxENQLKihW6TpA6PnW0Xp+CBGLA5ippRT2vBoxLPe+D8+3a8p7Rn69d/tr5G1jo
         7i4t0yKihiUMW5eF2dqnjk4kRIIC2Dm3XRR/rVmYZ07k7y2VOt5oE74zPQc60oVRJeAi
         5WGza9gQR5aUOowrRE5WJIKKYeqq+wd7BNbSdX6f4aE2NZSQlUAJ1blwqA59hRZ03Rxc
         AMJxpJIu4kzuQF4UyqZ5ruO294ekpG1pDgWe+rlHHm9LJVEjBTwLYgAfAFsspn6k+g9g
         vDMg==
X-Gm-Message-State: APjAAAVPeDRb4gozhNeMof+Kksw6loQ3ZA/OvHHAH0NsSR2/SzrNwig7
        nUUg1wLVio9Tz9Kx3t4y92w=
X-Google-Smtp-Source: APXvYqwoCf/Pdnvn5s1n1tJ64nDODMRXeExgk7vpJhyWgRCwW2Xl8gxjUqSaBtscPD/0WWSuL29y+g==
X-Received: by 2002:a62:fb18:: with SMTP id x24mr55563811pfm.231.1564712443423;
        Thu, 01 Aug 2019 19:20:43 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:42 -0700 (PDT)
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
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 20/34] xen: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:19:51 -0700
Message-Id: <20190802022005.5117-21-jhubbard@nvidia.com>
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

Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: xen-devel@lists.xenproject.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/xen/gntdev.c  | 5 +----
 drivers/xen/privcmd.c | 7 +------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 4c339c7e66e5..2586b3df2bb6 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -864,10 +864,7 @@ static int gntdev_get_page(struct gntdev_copy_batch *batch, void __user *virt,
 
 static void gntdev_put_pages(struct gntdev_copy_batch *batch)
 {
-	unsigned int i;
-
-	for (i = 0; i < batch->nr_pages; i++)
-		put_page(batch->pages[i]);
+	put_user_pages(batch->pages, batch->nr_pages);
 	batch->nr_pages = 0;
 }
 
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 2f5ce7230a43..29e461dbee2d 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -611,15 +611,10 @@ static int lock_pages(
 
 static void unlock_pages(struct page *pages[], unsigned int nr_pages)
 {
-	unsigned int i;
-
 	if (!pages)
 		return;
 
-	for (i = 0; i < nr_pages; i++) {
-		if (pages[i])
-			put_page(pages[i]);
-	}
+	put_user_pages(pages, nr_pages);
 }
 
 static long privcmd_ioctl_dm_op(struct file *file, void __user *udata)
-- 
2.22.0

