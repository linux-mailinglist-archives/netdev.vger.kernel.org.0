Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D057984112
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbfHGBk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:40:59 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45749 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728828AbfHGBeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:34:04 -0400
Received: by mail-pl1-f195.google.com with SMTP id y8so38602500plr.12;
        Tue, 06 Aug 2019 18:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wKnEf1dGeTf0vHOLp5WCTJvqak8NT8hcLNnzrVdQpMI=;
        b=K8d7XfBVJ8I/mb7D/So0s6zKV29K6nxqxOt+bscjBjWDfj0QC4+NZ8AYd4oczxdsUX
         7wYPGKgQnoRkCSwDEzT5rYkfZH7JJhJa6zaR/ydsa7uoMZJ2HjI2/BwiodCRxy0cgQ7K
         XR5LIHl94MzAJMcKyHWewTAlNkEf03nHhilsBgX1FcYreTK5la4X960fbNds2SN0gwIm
         bKXQLrcvXV5StThdICG212KTTY6r0QHSstMpGRVtwfJea1D8uaBa/9MN3hrGQMnPOq1P
         vjikEXBKeoKeYn0bHuTZu93yS1xwpaeL4dzZeJbSwqGj8iWMWHA9ZukGsRqP3BMDHZZx
         L72g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wKnEf1dGeTf0vHOLp5WCTJvqak8NT8hcLNnzrVdQpMI=;
        b=DqdjRNBtHbOLmaEBpRyj/1/qZaWsSnp0iPjL/l7hlkDjlBShkHnngJUmjyRQK+0A1g
         OmsBnr2j3lHp5NWxn99lprXdLZWOfg//sXa2aTP7BvteSwQG5hQi3lu1sYHanOXBNHTV
         Rm0WI/1UiaIpdzgvhC89PNFyHS+yFB+k1OKysK1596F5XqThjVh+xRhKofy9hlY1bDBi
         edFZkLn5gE+8yg83+aDQLHj9Ui6fhChUr/8yJb/R0Am7s+cmoMeIivfUE4ct+OyOc4kZ
         SPOh8Ai5Z4LexAcGidqZ9YS5+U03Bi5Z2jFzkJagKlNpTaPvO3kMl11AOKQd9ZQqyZ3M
         rN9w==
X-Gm-Message-State: APjAAAVkEmft6UXoIzuJVdTCz0bl7/TGPDbQGQMpjOOhx2vJazJa3N//
        1VlEp18hYrDNgggE/vd35Ns=
X-Google-Smtp-Source: APXvYqyq3BsS9DZUg5HbsH/cxAQFP71mzzuud27zN7KWsFT/18m4ES12yBRl2dAxm3nkOU3YhT47jw==
X-Received: by 2002:a17:902:e30b:: with SMTP id cg11mr5920567plb.335.1565141643695;
        Tue, 06 Aug 2019 18:34:03 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.34.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:34:03 -0700 (PDT)
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frank Haverkamp <haver@linux.vnet.ibm.com>,
        "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 12/41] genwqe: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:11 -0700
Message-Id: <20190807013340.9706-13-jhubbard@nvidia.com>
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

This changes the release code slightly, because each page slot in the
page_list[] array is no longer checked for NULL. However, that check
was wrong anyway, because the get_user_pages() pattern of usage here
never allowed for NULL entries within a range of pinned pages.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Cc: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/misc/genwqe/card_utils.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index 2e1c4d2905e8..2a888f31d2c5 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -517,24 +517,13 @@ int genwqe_free_sync_sgl(struct genwqe_dev *cd, struct genwqe_sgl *sgl)
 /**
  * genwqe_free_user_pages() - Give pinned pages back
  *
- * Documentation of get_user_pages is in mm/gup.c:
- *
- * If the page is written to, set_page_dirty (or set_page_dirty_lock,
- * as appropriate) must be called after the page is finished with, and
- * before put_page is called.
+ * The pages may have been written to, so we call put_user_pages_dirty_lock(),
+ * rather than put_user_pages().
  */
 static int genwqe_free_user_pages(struct page **page_list,
 			unsigned int nr_pages, int dirty)
 {
-	unsigned int i;
-
-	for (i = 0; i < nr_pages; i++) {
-		if (page_list[i] != NULL) {
-			if (dirty)
-				set_page_dirty_lock(page_list[i]);
-			put_page(page_list[i]);
-		}
-	}
+	put_user_pages_dirty_lock(page_list, nr_pages, dirty);
 	return 0;
 }
 
-- 
2.22.0

