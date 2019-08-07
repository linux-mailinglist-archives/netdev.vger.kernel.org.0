Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A5483F26
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfHGBeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:34:44 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41343 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729743AbfHGBei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:34:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id m30so42508301pff.8;
        Tue, 06 Aug 2019 18:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=66nLgLSrAAtLnk7heFQOXwTIycZbzywZGh2gpdUQtHA=;
        b=hGadGekT36tWWF2x+rPXatg5Phju1cJkPhVohpTnvU9xcLgSYz3c/H9JfBuvb/eqpQ
         gJm9ULhd1h25PBFy4ZlpC+tAGAEAzuKiPxwK1X6/dMDelBe1FYe+sUe691h23Hpm09qn
         NtkXw7G9BBhwySB0UzQpKOHO5RlAvdX8JQycevy+XDQPWxcX8dLLfHqYFlfiIf28POCQ
         XQLWbzezNK3qTnHI7eGrMbtyoSKY/W2T3jkcfT5nC0QYcZ+CMjkTw7ZL3pOdyAZGwJLx
         tXBADMMsq1ukRK67JdNPKq0uGvf0IBEzyL0wmcyHhzZLuqxNXwAHA+z0PFrP2wNDYOQy
         6sYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=66nLgLSrAAtLnk7heFQOXwTIycZbzywZGh2gpdUQtHA=;
        b=p2hgyYE49GJQtLUSoDuvLkCqPl0q/qdp6hVPxKnYY7dwpZ8evgmoD8wl5dw9k514jN
         fzMnauhhUIuhHMG3qNOOQ40dLdOAJ6SZZQPOupdbiHX8MnKP2SUjJIPlzQPjkW1HV+Zr
         7FtyTgblSFKEeDDFy4yz/IiQPNwbxPqUNzTkJG4/QXXUbiSDmfoPuMaEwBo0WnIlz0pS
         BTY9ZVQhrbCKoOo9pPFuYA8SykjvKC8S40EQyy4dREzveE03XGpHfJB4GEJgrqx8l+aO
         bunJNAR5Or1UBCpN5G8gLIXZcgiJwO+Gz13nwikg9C6Bn5spBnNYpPbzM0eDZ78Ixnuj
         BRXw==
X-Gm-Message-State: APjAAAXeMEFGyAFdCJTakNWlvl+omKR+07+FVBnH/0z7J1trPOBeqLsg
        sTQXggNaOu9CV8oCcQYC66Y=
X-Google-Smtp-Source: APXvYqxVqy6uPNA5pMhiCuVlDYKPDVYd5IZkwA2Cp9U8q1WFZ9BX6VmEjp+QCN9e6zqU7bkXXXxyWA==
X-Received: by 2002:aa7:9197:: with SMTP id x23mr6650509pfa.95.1565141677758;
        Tue, 06 Aug 2019 18:34:37 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.34.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:34:37 -0700 (PDT)
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
        Calum Mackay <calum.mackay@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>
Subject: [PATCH v3 33/41] fs/nfs: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:32 -0700
Message-Id: <20190807013340.9706-34-jhubbard@nvidia.com>
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

Reviewed-by: Calum Mackay <calum.mackay@oracle.com>

Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 fs/nfs/direct.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 0cb442406168..c0c1b9f2c069 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -276,13 +276,6 @@ ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	return nfs_file_direct_write(iocb, iter);
 }
 
-static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
-{
-	unsigned int i;
-	for (i = 0; i < npages; i++)
-		put_page(pages[i]);
-}
-
 void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
 			      struct nfs_direct_req *dreq)
 {
@@ -512,7 +505,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 			pos += req_len;
 			dreq->bytes_left -= req_len;
 		}
-		nfs_direct_release_pages(pagevec, npages);
+		put_user_pages(pagevec, npages);
 		kvfree(pagevec);
 		if (result < 0)
 			break;
@@ -935,7 +928,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 			pos += req_len;
 			dreq->bytes_left -= req_len;
 		}
-		nfs_direct_release_pages(pagevec, npages);
+		put_user_pages(pagevec, npages);
 		kvfree(pagevec);
 		if (result < 0)
 			break;
-- 
2.22.0

