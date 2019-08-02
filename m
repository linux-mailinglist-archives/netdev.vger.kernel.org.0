Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4067E8DB
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391040AbfHBCWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:22:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37205 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390941AbfHBCVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:21:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id d1so2419613pgp.4;
        Thu, 01 Aug 2019 19:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b/YV2nCBRUvj+JHalhe5VKLnhqnMLLZTxEiSQrNBGLQ=;
        b=LoaCL2H2RUJBCIOglYnaArkmIVWTYlGIsKjGOYisZuAUApfhu5gEmc6qkNjj0+H7tu
         P+8Dh9t16ihvD6gplnd7Tc9AK6ZGCZeLjxm8tt5yZaZLJjevhgAQKR5u0bAClFOVBiw3
         mudk+AK8dwI6nYLVBSSjbYQjnEo/x77kPGPgsQFzLk0mY0MTwpLYueBrrkls4g4lNcFE
         23WeAWQvuXbP3ljk10sU7SrPFsFGjeRWLbXNTJO4ixgqQlxC9gc1Tv3tUxDQgjI0BYi3
         8BhTJVYtfR/r0jUz//rNUXMcepW6CTlPDrLR0cTlbj3o8jhk3sRuBiigNZ2CjgqdDsZo
         Ctuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b/YV2nCBRUvj+JHalhe5VKLnhqnMLLZTxEiSQrNBGLQ=;
        b=bIQWsVED0u1aKJwC3CyXN34cP+gb2Lc4CAh2w0DZYYRYlx+raDcKSLDXQqIhOZ+0YZ
         GAMT4AuV4unWwEzZcNm99bh4ArPMYsIVjYlnJmY/c83PzbnQWjt6dfxq86o2gB1Fwn9+
         Run2UmyxabnmqK6hMd6PHeeOIrfCbiG+zpSptWRRPFiMrixuEtnpPTW4cjBiXF0mpCDX
         hQTD/InUu/4oKCESRAHyyZ7fCsnYFNjHSXyTMXOUaLqbELIw8NU2vOaA64ALQEvGIeso
         xBGnnneg162gDK4aJlRaRW5/pj0funxdEb0wTADH8gyeq9cIPG9VTwUymow4nSXlRmMc
         6YsQ==
X-Gm-Message-State: APjAAAVhWT2GE43tX+/7Sg6H2JbD+A2aGfV7vQBA6BGhyGAuwq7vXUmq
        Licv+GXlPVriZf4lyoPRPL4=
X-Google-Smtp-Source: APXvYqwGNmSeCqbGUwEK1nMIVRCwdEn4NOX6aNf7I9lvnteHEiZ+Pa2UbMiy7LcaaaYIQGQbOjX2Vg==
X-Received: by 2002:a17:90a:3086:: with SMTP id h6mr1977670pjb.14.1564712460540;
        Thu, 01 Aug 2019 19:21:00 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:21:00 -0700 (PDT)
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
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>
Subject: [PATCH 31/34] nfs: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:20:02 -0700
Message-Id: <20190802022005.5117-32-jhubbard@nvidia.com>
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

Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 fs/nfs/direct.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 0cb442406168..b00b89dda3c5 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -278,9 +278,7 @@ ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 
 static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
 {
-	unsigned int i;
-	for (i = 0; i < npages; i++)
-		put_page(pages[i]);
+	put_user_pages(pages, npages);
 }
 
 void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
-- 
2.22.0

