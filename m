Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D6080D89
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfHDWuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:50:51 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39628 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbfHDWuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:50:11 -0400
Received: by mail-pl1-f195.google.com with SMTP id b7so35729367pls.6;
        Sun, 04 Aug 2019 15:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=46lxAY1z81U+mrrESVpVIrQ+fWJc6iHl4OExj8KwBEA=;
        b=TnoFvHk+U9GlniOKiXvWmHaHCeiVRyFhspf1Ucco3Opb6Zsra5EKt4aW1VdCEHOoOL
         B19ZrZSjdl4XOLjhMd/tz/suTkdRby0Q/hj5CJZSGF/pCKAPl5af/u3ds9o4NJugQJUH
         wah7eFEy+LBD8ieXrf5M4ghNwdqYF47d1zgnqfS2OWPzozoT/nJvTGXUM3ZYObcV1Nod
         /B+8RZc6MysuCMtgdDFKXIhBZ1vxh5KoYsW/S+ERZyza2fEF3JOhoez0XL3hqg3QsNHf
         A2vrE2EWhCkc/+2Bi4Qkus+K6o78OOjPZC/JIdc8d4G2oWHuj6EfQ91Jku0EJ0FsNSHa
         w9qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=46lxAY1z81U+mrrESVpVIrQ+fWJc6iHl4OExj8KwBEA=;
        b=ochFYl6AlOkGQNem6gwSJHbju1mISJID6vzwCMEMvcZ4CyQNj68HuFv2M0Gn52cbWf
         GSQaBs6bSb4fa+GK13u2Y4MHA38cBtM4ld+KN60CSb1NsV4wZh3wBoIbA1ENNETuETYy
         vXMS0sx6NYTIoiHUMW3k0y/8SetQ6+SCFW/M1197Y5RiZ6PsWpnuRlqrNRzIeSRDgFOh
         H46tamU8u/c/v54bEeLXxn+BtaF2bAFvemRJc+5cvzU8sLjothMmg5hMhi2jGcE62ueL
         t339jfWOmrIRhXr2RmyYYWYvWJe4WSfIP5v+Ct3Xc216pFcZ963MhD6154E5OLOcVkZ5
         1M7g==
X-Gm-Message-State: APjAAAWQBzWzKJwNYdAbSScaRHKeKQyqfuXahFKYijL0M9VceebEMP5A
        TJQRapXKGO+Duyy0ps3yof8=
X-Google-Smtp-Source: APXvYqzB7V+habp3I96Q8m7XMJqRYvky1QL0M1s1kWUjAVtyhhVWp0HvJtmcLDTq9kGGDNeFtLuO/Q==
X-Received: by 2002:a17:902:9a84:: with SMTP id w4mr21647219plp.160.1564959010056;
        Sun, 04 Aug 2019 15:50:10 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.50.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:50:09 -0700 (PDT)
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
        Roman Kiryanov <rkir@google.com>
Subject: [PATCH v2 32/34] goldfish_pipe: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:49:13 -0700
Message-Id: <20190804224915.28669-33-jhubbard@nvidia.com>
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

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Roman Kiryanov <rkir@google.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/platform/goldfish/goldfish_pipe.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
index cef0133aa47a..2bd21020e288 100644
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -288,15 +288,12 @@ static int pin_user_pages(unsigned long first_page,
 static void release_user_pages(struct page **pages, int pages_count,
 			       int is_write, s32 consumed_size)
 {
-	int i;
+	bool dirty = !is_write && consumed_size > 0;
 
-	for (i = 0; i < pages_count; i++) {
-		if (!is_write && consumed_size > 0)
-			set_page_dirty(pages[i]);
-		put_page(pages[i]);
-	}
+	put_user_pages_dirty_lock(pages, pages_count, dirty);
 }
 
+
 /* Populate the call parameters, merging adjacent pages together */
 static void populate_rw_params(struct page **pages,
 			       int pages_count,
-- 
2.22.0

