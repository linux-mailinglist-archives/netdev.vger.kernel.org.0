Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DBB80D2E
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfHDWt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:49:58 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38498 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727609AbfHDWtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:55 -0400
Received: by mail-pl1-f196.google.com with SMTP id az7so35652943plb.5;
        Sun, 04 Aug 2019 15:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3zvxFRr3gjg9t3ZKCwZWoMY3PeLUGF9FofBT0j+JfJs=;
        b=AoEeK7A3WmgkZN5yC8Z1Jl1RH2bH2yfr/Iui/v9Stf0ZewCCNe6BmkaFiQSbldZriZ
         wW6aM88ICV9MKKVMW7cufc693tFEoxlowWoPmOWeXRs1MOQDftxRpNdG7ZpLAs0zPCzH
         tfODbi7MeStQ2PUxDbHxfxCmnrrt0CpHHVErZgkFlHG1WBD9vc/idnDis+fOVKQL9lLN
         eIKxSh7vqFmdHH8HbCmTpqdNHN/40uH9dLamfPKCEqx0SSFV0Cay/FKPEfRs3UtCWLvV
         asJlUv7lGILmIRMgD+7Ndejmes/P11ltUT9gXu0ECiydPknotiGsbwT49fTUX3pXXK/J
         hBPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3zvxFRr3gjg9t3ZKCwZWoMY3PeLUGF9FofBT0j+JfJs=;
        b=twJXSeCHkK79Umv0JZx9CN4JApbwXN4tsLN6lJ5m/eSIN+exB0oYAxRzXsVxx/58X7
         khme4Twjv97KTuHaDAOVp1ZV7qCORGsCqIMPxGtAKu8RSFcOfwphw/4LO9KE7fIpck2q
         M3shb2T15h/e2X82CQvrbtETCnhPFqnv1uJEU7tcZzEBmPpx/M4brpie0edIr9MhiL62
         VrHuU7Wvp4ukkxaJkBeZcv5yIMyOl7dlt1Kvjkej0vDXLYuu4QeX0Cj/Q4X35hmZBHge
         zsGsWADiFBIadnPpZwPcxtXmvJlIxqJzgfkkQxJFmUGMymH7Z1cDpwWsDYYAtY0V7Zsf
         FfrQ==
X-Gm-Message-State: APjAAAVLsbyuyGU4VVS8XSjByPdbMw4P9uGybvIc0TFY2NAh7dP2CsI4
        9yY7Jj5/3R55l2DCkQveXIw=
X-Google-Smtp-Source: APXvYqzibwwPUnTUuHH+RVhfMiDAHi4Mt1y6avGQzxyYdtLRtPBxbmwrSqheIPeJWHdiQ7pwZ9ajtA==
X-Received: by 2002:a17:902:9688:: with SMTP id n8mr138434091plp.227.1564958993951;
        Sun, 04 Aug 2019 15:49:53 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:53 -0700 (PDT)
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
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>
Subject: [PATCH v2 22/34] orangefs: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:49:03 -0700
Message-Id: <20190804224915.28669-23-jhubbard@nvidia.com>
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

Cc: Mike Marshall <hubcap@omnibond.com>
Cc: Martin Brandenburg <martin@omnibond.com>
Cc: devel@lists.orangefs.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 fs/orangefs/orangefs-bufmap.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/orangefs/orangefs-bufmap.c b/fs/orangefs/orangefs-bufmap.c
index 2bb916d68576..f2f33a16d604 100644
--- a/fs/orangefs/orangefs-bufmap.c
+++ b/fs/orangefs/orangefs-bufmap.c
@@ -168,10 +168,7 @@ static DEFINE_SPINLOCK(orangefs_bufmap_lock);
 static void
 orangefs_bufmap_unmap(struct orangefs_bufmap *bufmap)
 {
-	int i;
-
-	for (i = 0; i < bufmap->page_count; i++)
-		put_page(bufmap->page_array[i]);
+	put_user_pages(bufmap->page_array, bufmap->page_count);
 }
 
 static void
@@ -280,7 +277,7 @@ orangefs_bufmap_map(struct orangefs_bufmap *bufmap,
 
 		for (i = 0; i < ret; i++) {
 			SetPageError(bufmap->page_array[i]);
-			put_page(bufmap->page_array[i]);
+			put_user_page(bufmap->page_array[i]);
 		}
 		return -ENOMEM;
 	}
-- 
2.22.0

