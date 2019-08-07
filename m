Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E75B83FE5
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbfHGBgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:36:33 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42637 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729676AbfHGBek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:34:40 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so38635695plb.9;
        Tue, 06 Aug 2019 18:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=46lxAY1z81U+mrrESVpVIrQ+fWJc6iHl4OExj8KwBEA=;
        b=WuyyNqtpvvlvZwulsOSyl6jjDfFZFL7/Zx5rMnqGOdxDRsEuGcdgN1IewvAvlX+Ui3
         X7btLnm2F40F8RrpBhgVrMU3HOKje9DtE5nK+fpNzyjny+e0S7JZDS2kjkLoxOZDXhQl
         8/grXg9y3uP/GW5F5PAwd4bWzrVFH3BCp78Eig9BKFd6aIXye5gDuBBhD5viuX1OApXQ
         9VIP+L4AUKM2VFr2nldHjLjmSVNA49QX09uR5xAkxNN9xQUujG5Q/Q0AKTjDZbsxdlOq
         g4tQx0EnIYd52Zy5p9V4faNYnaj9xyaWhFJDGaxmSVhObIkgzad4uex02Ars3KOUlzef
         YWIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=46lxAY1z81U+mrrESVpVIrQ+fWJc6iHl4OExj8KwBEA=;
        b=C7ZFyjjb0YV18GgLJ6nThE66O7R63akxZeghvqF5mHMGVUU1mDfQ3ncSp/E7n6jY3g
         tc7CgM5RjrMQ61VDt67hR/LH42dgVUIet1lraP2dk9yNiYQ2wiOUehl5ynbP0wKrF7qs
         mE/lB3LozvMt0dVeX7PvcciL/TFwF9iBqKO5UYXAD5sdxHq1LhvmbTowrdWLueu63EX9
         +PF9HBp6fNY6f55qZBi9vSKdulvKFO4reL0p4rzHRPDZSpR75iZ8vFcL+hJfK/LhkvyN
         XH0iDlqlEVAuDFithRSjDKdeY2w10wYKYOovW8faz8Bj7JgQNcdCkYjgaL5mSOhW79IX
         165Q==
X-Gm-Message-State: APjAAAUqNbqQ01MFRyNpyAejWoyoAuQQdmRMj2c1VbKlja7r3HEzsJnX
        GzgdsUwezCb9oSKsIAogyXA=
X-Google-Smtp-Source: APXvYqxeu3U+gXlTZOXb8hdX/T/5F9QSVWlhZwpRfNn+ISG+GmBUrBJWAvgFajanndvmV9JUd/JHZg==
X-Received: by 2002:a17:902:a606:: with SMTP id u6mr5434497plq.275.1565141679262;
        Tue, 06 Aug 2019 18:34:39 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.34.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:34:38 -0700 (PDT)
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
Subject: [PATCH v3 34/41] goldfish_pipe: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:33 -0700
Message-Id: <20190807013340.9706-35-jhubbard@nvidia.com>
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

