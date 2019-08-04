Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACEFF80D5E
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfHDWuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:50:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42565 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727800AbfHDWuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:50:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id t132so38660098pgb.9;
        Sun, 04 Aug 2019 15:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sx0x91HVjVXCVkLMMHrdncyqT4rW2sU28Vf+3l+oloA=;
        b=M7iDvAmPBRpGJcJpcoqgvaoi3nLFkyQK4dkSIj4ojX3FvseJtfjnZyfckr18kI2oDa
         LHzSPof56TngxWHSp0ym44XehwQNp0Dvit6wm4Dt65OPXwL2baR6+4zLMuIAexRHFzmx
         ZFMgjeYMSC1sErMdOV/WNMAc2Iu4rRWK81eLPAWfZwZdfeXx16tZd5680zs185LTKzUq
         VYv2LHkMnMPv4yg/Pui3fxt3Z+TxPOd1GexxLj8LbBhnNpT3XVb8jW9mQwG5C5+4ClkN
         g/MAUKuZK56HuoBkHT35BiifdFKR3pPYOWepAjU+8QcCzdVYmtG3jMaPBQTkt/nS1dsZ
         WZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sx0x91HVjVXCVkLMMHrdncyqT4rW2sU28Vf+3l+oloA=;
        b=rd4bPfUAbGVSxor4WaiOV0rV6Zuazuc40QWA7Z4d/N8lccOuDRqZXpGQGlh9YA1NUO
         sXF2lvkkXHUqhR2q8QOniB4f5TuzINFVDdboxqdE6JgfMxdnOp6AEb42unIjSzbjQRNC
         q2R95cuixvmRLQkBk+LxFtY8rt7nolqszU4jhN8GEiCBR+AnQD4CYpD6sLSq/wYUOIVY
         6wl4np9oPDlCkl1O5qmCzwoqZW9TfqiZ1nhfcZb/ESvaVjHAJX4eeFUit5WTbHyHLhZ/
         dV2Yf8emnClP2nPGLE6jpDdz1mq5j2dxxp43Du24uq0gWQKdQc9DKvnwEWfdHosON/5m
         fTBA==
X-Gm-Message-State: APjAAAVCouOw6l4AzO6xbPBNoUGkubQyyxguZWLjMpengPwihzsOWXql
        6vxJYkeWEPFi2BIm8uYLMZA=
X-Google-Smtp-Source: APXvYqzdBAOi64WyR4vf0DFOxQNVALmaSa46GoCIBIpjxflBtAErOscOmlieUmCz4Qhdah1mimse2w==
X-Received: by 2002:a63:7358:: with SMTP id d24mr133542074pgn.224.1564959008549;
        Sun, 04 Aug 2019 15:50:08 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.50.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:50:08 -0700 (PDT)
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
Subject: [PATCH v2 31/34] fs/nfs: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:49:12 -0700
Message-Id: <20190804224915.28669-32-jhubbard@nvidia.com>
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

Cc: Calum Mackay <calum.mackay@oracle.com>
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

