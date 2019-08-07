Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B348405F
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbfHGBe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:34:27 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39214 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729578AbfHGBeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:34:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id b7so38640258pls.6;
        Tue, 06 Aug 2019 18:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3zvxFRr3gjg9t3ZKCwZWoMY3PeLUGF9FofBT0j+JfJs=;
        b=L/mKoqNBpvGTGBp3epVJp9Jwmcabm5Zof/TP6cMpNTp5QyY/bNS8ra/phjhs5sRAaN
         E5tTttcEItcQL3b5Zem0k5qJxKcKktTUshMTiNWzGKXLywBoBoQ5bitV/RkFpPMu2On5
         4WHRSoAhmad+Sq/Uze+Lrqj/EHMra+wpLWdL/I1wMa19gtn+2FmmEpJ2BiwYWrwVtu4s
         ErDZEb/zzGVZaJO6WBAU6eZcAtQlFXpJrdCTpwcNxdnIPyz2Lta4bzP9L9aVvEMuLhxO
         FtQSTpdSuYFA1RpMOlExoKqI8fe7oDB8Q9BkX/iI0jL+EMoGr57KcyP7PRTXBQFgsK3f
         6S2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3zvxFRr3gjg9t3ZKCwZWoMY3PeLUGF9FofBT0j+JfJs=;
        b=Wiku0SIadoGoJZyG8QeTGcnc3A71j180wVszEapG6nwv43TpkXveXZJiIK7KM2kTTC
         ut3iv3Bb61tIujGuehAkgwQSghrKL962BzPPG02AP1yMf+eI71fwF6j9M5baLc71GzZ5
         oBig2royLLzO5ZSyVQJiditdyLIYekkTjxBAugAqJff0EtQHAvYtG0JN/39bZoIrWMPv
         ZnalwY0wg27/jMquK6Tek8NYUz7+yA7bY1lR/BV/QGQvpAz4jJGWYgB1eYXX0KJ9sUhD
         d6W0mULnB+UzDUT9LfglM8CrjJIz+T5QbjYpnElHX/I1LFRABjpqSPK9W/ZM3zQcZLy+
         yOBQ==
X-Gm-Message-State: APjAAAVUVMB35CXpFn6r9x0Xfud5yjqAXMZN1PACIV0ID4up/Na87Un+
        8v8yqIPZgYZEDROsYBtT3yXyup4J
X-Google-Smtp-Source: APXvYqw776L+7/s1i5+0uj4rHYr4XOYwzb6gLf8HmDykG/CGNwoS9owiEzaUd2cmiWPaV4acbHnsQA==
X-Received: by 2002:a17:902:4683:: with SMTP id p3mr5420824pld.31.1565141663334;
        Tue, 06 Aug 2019 18:34:23 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.34.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:34:22 -0700 (PDT)
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
Subject: [PATCH v3 24/41] orangefs: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:23 -0700
Message-Id: <20190807013340.9706-25-jhubbard@nvidia.com>
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

