Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B08080EAB
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfHDWtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:49:41 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42534 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbfHDWth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:37 -0400
Received: by mail-pg1-f193.google.com with SMTP id t132so38659688pgb.9;
        Sun, 04 Aug 2019 15:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=34zW6BJN89MycamN6XZc+aPi3iIpUXsyW4mngm2d11Q=;
        b=Vl3ziFlsVP8d5c8y0YmW6fDZsGTWTBWfBuMUsCvUNMfO41hPRu5nz6knOx+9Exr4dm
         faLIZ6PGv5svewcMn6NrpUtC2sVsC+7jyMTiSPQOkMWSlMNBGkEc5Hzdhl1GLUQ+lU00
         s8/u7LPhlwjUp5vP9Cq58ZxyRYaJggFlYisUFFtIS444ycMw8U/APZaIEYWga3Yussps
         tKIhHu6BLxxDR9A3QUeopRp/JQJFEZSB+ASswX2FluN7nR+bVi9w3B9Wm/JRet3KnCM9
         BzOgVm6BdbLPf53jqaXQstPr6PLJxFbgM+ClIPWs4p2Wp5bWVtpTaVjy3ylfOWo6XjbI
         VLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=34zW6BJN89MycamN6XZc+aPi3iIpUXsyW4mngm2d11Q=;
        b=WD2++toZrTPeY0hWKVCFoQg9J8pLj6+JQwcf083rLQ7ZwBM5MjOAk4fk79xvXi7600
         o2SHdA1p5bARhftAIk1jCqkbsH9+7aHswzhA+KD9er3vbHSndUi/dByky8qZAcZcd3Kq
         xL/TmzJ8zD+xIuKg9OLvMri+5XsOZpF9XkzlzxxyiYxzuiVYEOB7dymmU/wcczhM83he
         XwHkdMYw13AfWIlTSWss+c+z3i1aLTVVgg8ddImB/5kOozFUgVmBo3W6Yba5XwH0KvhE
         FWbGuLTuB95ECXN07LiM/ZSpgWCIU8+1U4LsvS3QfU0NpBje1fz/O4OGW09kcqUgRYHq
         hNVw==
X-Gm-Message-State: APjAAAV69j+uKDvFCr+JZjq8TR92LjRYt1VPDjHBOcC+nfGqmdZZpXKH
        aoZh4OBJM532y0yt1RrsiQg=
X-Google-Smtp-Source: APXvYqzZzuc1CJxZdFJgWU/FwmUoZ/p878RlqbCeEzJ5+atuTCZn+89D3JrxmbErf1XY9IXgA3NZ2A==
X-Received: by 2002:a17:90a:f498:: with SMTP id bx24mr15350312pjb.91.1564958976783;
        Sun, 04 Aug 2019 15:49:36 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:36 -0700 (PDT)
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
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Joerg Roedel <jroedel@suse.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 11/34] scif: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:48:52 -0700
Message-Id: <20190804224915.28669-12-jhubbard@nvidia.com>
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

Cc: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/misc/mic/scif/scif_rma.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/mic/scif/scif_rma.c b/drivers/misc/mic/scif/scif_rma.c
index 01e27682ea30..d84ed9466920 100644
--- a/drivers/misc/mic/scif/scif_rma.c
+++ b/drivers/misc/mic/scif/scif_rma.c
@@ -113,13 +113,14 @@ static int scif_destroy_pinned_pages(struct scif_pinned_pages *pin)
 	int writeable = pin->prot & SCIF_PROT_WRITE;
 	int kernel = SCIF_MAP_KERNEL & pin->map_flags;
 
-	for (j = 0; j < pin->nr_pages; j++) {
-		if (pin->pages[j] && !kernel) {
+	if (kernel) {
+		for (j = 0; j < pin->nr_pages; j++) {
 			if (writeable)
-				SetPageDirty(pin->pages[j]);
+				set_page_dirty_lock(pin->pages[j]);
 			put_page(pin->pages[j]);
 		}
-	}
+	} else
+		put_user_pages_dirty_lock(pin->pages, pin->nr_pages, writeable);
 
 	scif_free(pin->pages,
 		  pin->nr_pages * sizeof(*pin->pages));
@@ -1385,11 +1386,9 @@ int __scif_pin_pages(void *addr, size_t len, int *out_prot,
 				if (ulimit)
 					__scif_dec_pinned_vm_lock(mm, nr_pages);
 				/* Roll back any pinned pages */
-				for (i = 0; i < pinned_pages->nr_pages; i++) {
-					if (pinned_pages->pages[i])
-						put_page(
-						pinned_pages->pages[i]);
-				}
+				put_user_pages(pinned_pages->pages,
+					       pinned_pages->nr_pages);
+
 				prot &= ~SCIF_PROT_WRITE;
 				try_upgrade = false;
 				goto retry;
-- 
2.22.0

