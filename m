Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E537262F
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfGXEZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:25:54 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33377 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfGXEZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 00:25:37 -0400
Received: by mail-pl1-f194.google.com with SMTP id c14so21403885plo.0;
        Tue, 23 Jul 2019 21:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ConQbG+Oem1Q8xZVMGorLyFV++CtkhuR2d2QhctIH1U=;
        b=rzlDdGXtnPNF/N6VGSj5OlnkKQVNzuJZSX88h3k0QaSU7x9XxY6d4zWea62ZR3fNtS
         gNMZr45iIvfH5HQRUOMwyNN/jLIH836GcUp8Lf+aNFxxaV9vdrr625gCfyA8XZW5PN/Q
         pwujb2Pq5pgz78btiFjK3sxUmpLDWtYh/fYuVQy1tXkvqQxjANX5Mpn0h7bykgaCkfn1
         tCFvQq5xWW5YoxVJrXQ4tXX8LNF75ePai0HBYrs+WY7yUOWhn6yI6XBVflq1lgPq7qJv
         MiEt1P/meAHMnJy5EKWXyM1HfNJ7Mhgk5eJlB+ONmrDSnY2e4Df2D52oQWcyMMCO39pJ
         Eo+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ConQbG+Oem1Q8xZVMGorLyFV++CtkhuR2d2QhctIH1U=;
        b=gqq0hC8pLvpViSGHgy+tAyVN/mm+fRNg+vzn50fDt9BmPpFApXwp5FHuFt+Za9nX9y
         X21X64CPz2ZYFs1DnLNoJ64aXkp3zvIYLm9t7KYrzIagPwG3Lv1GFQchZ3iowL9bg8P7
         eTc+qmgj5PArB3EDuImgpFg4p0+OootFwXovyoiivicH95JvGqhyTsRhMbkX824O6bOs
         Y1EDaVrZ9rBFTnux2Mui27ZM+IeehIXnXHrimHAEY6uY5W3wCGyjln7KNf5ZLG9VzDGJ
         2HJbm/fqdarLXaHThhhzRYSrfMasmpk+4m13RlLbW2uMNjspcGUkmysgSoNlwC1y/iEG
         yLCw==
X-Gm-Message-State: APjAAAWjz9QfEhD2hP8DaeEAwp0/0woWdKGAk9B0L+OcZDvARY1O44zK
        6Z7AOGZQB2zKOFln9R51UX8=
X-Google-Smtp-Source: APXvYqyQhtv0FnqZ/I/TW3TWJg4eP/mju41WYZg75l/6hWymbmp//VEgOy1EsZaAb3L+vlqi+tLiHg==
X-Received: by 2002:a17:902:6b44:: with SMTP id g4mr83239156plt.152.1563942335854;
        Tue, 23 Jul 2019 21:25:35 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id a15sm34153364pgw.3.2019.07.23.21.25.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 21:25:35 -0700 (PDT)
From:   john.hubbard@gmail.com
X-Google-Original-From: jhubbard@nvidia.com
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, ceph-devel@vger.kernel.org,
        kvm@vger.kernel.org, linux-block@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, samba-technical@lists.samba.org,
        v9fs-developer@lists.sourceforge.net,
        virtualization@lists.linux-foundation.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 10/12] fs/ceph: convert put_page() to put_user_page*()
Date:   Tue, 23 Jul 2019 21:25:16 -0700
Message-Id: <20190724042518.14363-11-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724042518.14363-1-jhubbard@nvidia.com>
References: <20190724042518.14363-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

For pages that were retained via get_user_pages*(), release those pages
via the new put_user_page*() routines, instead of via put_page().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Changes from Jérôme's original patch:

* Use the enhanced put_user_pages_dirty_lock().

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: ceph-devel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: "Yan, Zheng" <zyan@redhat.com>
Cc: Sage Weil <sage@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
---
 fs/ceph/file.c | 62 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 685a03cc4b77..c628a1f96978 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -158,18 +158,26 @@ static ssize_t iter_get_bvecs_alloc(struct iov_iter *iter, size_t maxsize,
 	return bytes;
 }
 
-static void put_bvecs(struct bio_vec *bvecs, int num_bvecs, bool should_dirty)
+static void put_bvecs(struct bio_vec *bv, int num_bvecs, bool should_dirty,
+		      bool from_gup)
 {
 	int i;
 
+
 	for (i = 0; i < num_bvecs; i++) {
-		if (bvecs[i].bv_page) {
+		if (!bv[i].bv_page)
+			continue;
+
+		if (from_gup) {
+			put_user_pages_dirty_lock(&bv[i].bv_page, 1,
+						  should_dirty);
+		} else {
 			if (should_dirty)
-				set_page_dirty_lock(bvecs[i].bv_page);
-			put_page(bvecs[i].bv_page);
+				set_page_dirty_lock(bv[i].bv_page);
+			put_page(bv[i].bv_page);
 		}
 	}
-	kvfree(bvecs);
+	kvfree(bv);
 }
 
 /*
@@ -730,6 +738,7 @@ struct ceph_aio_work {
 };
 
 static void ceph_aio_retry_work(struct work_struct *work);
+static void ceph_aio_from_gup_retry_work(struct work_struct *work);
 
 static void ceph_aio_complete(struct inode *inode,
 			      struct ceph_aio_request *aio_req)
@@ -774,7 +783,7 @@ static void ceph_aio_complete(struct inode *inode,
 	kfree(aio_req);
 }
 
-static void ceph_aio_complete_req(struct ceph_osd_request *req)
+static void _ceph_aio_complete_req(struct ceph_osd_request *req, bool from_gup)
 {
 	int rc = req->r_result;
 	struct inode *inode = req->r_inode;
@@ -793,7 +802,9 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 
 		aio_work = kmalloc(sizeof(*aio_work), GFP_NOFS);
 		if (aio_work) {
-			INIT_WORK(&aio_work->work, ceph_aio_retry_work);
+			INIT_WORK(&aio_work->work, from_gup ?
+				  ceph_aio_from_gup_retry_work :
+				  ceph_aio_retry_work);
 			aio_work->req = req;
 			queue_work(ceph_inode_to_client(inode)->inode_wq,
 				   &aio_work->work);
@@ -830,7 +841,7 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	}
 
 	put_bvecs(osd_data->bvec_pos.bvecs, osd_data->num_bvecs,
-		  aio_req->should_dirty);
+		  aio_req->should_dirty, from_gup);
 	ceph_osdc_put_request(req);
 
 	if (rc < 0)
@@ -840,7 +851,17 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	return;
 }
 
-static void ceph_aio_retry_work(struct work_struct *work)
+static void ceph_aio_complete_req(struct ceph_osd_request *req)
+{
+	_ceph_aio_complete_req(req, false);
+}
+
+static void ceph_aio_from_gup_complete_req(struct ceph_osd_request *req)
+{
+	_ceph_aio_complete_req(req, true);
+}
+
+static void _ceph_aio_retry_work(struct work_struct *work, bool from_gup)
 {
 	struct ceph_aio_work *aio_work =
 		container_of(work, struct ceph_aio_work, work);
@@ -891,7 +912,8 @@ static void ceph_aio_retry_work(struct work_struct *work)
 
 	ceph_osdc_put_request(orig_req);
 
-	req->r_callback = ceph_aio_complete_req;
+	req->r_callback = from_gup ? ceph_aio_from_gup_complete_req :
+			  ceph_aio_complete_req;
 	req->r_inode = inode;
 	req->r_priv = aio_req;
 
@@ -899,13 +921,23 @@ static void ceph_aio_retry_work(struct work_struct *work)
 out:
 	if (ret < 0) {
 		req->r_result = ret;
-		ceph_aio_complete_req(req);
+		_ceph_aio_complete_req(req, from_gup);
 	}
 
 	ceph_put_snap_context(snapc);
 	kfree(aio_work);
 }
 
+static void ceph_aio_retry_work(struct work_struct *work)
+{
+	_ceph_aio_retry_work(work, false);
+}
+
+static void ceph_aio_from_gup_retry_work(struct work_struct *work)
+{
+	_ceph_aio_retry_work(work, true);
+}
+
 static ssize_t
 ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		       struct ceph_snap_context *snapc,
@@ -927,6 +959,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t pos = iocb->ki_pos;
 	bool write = iov_iter_rw(iter) == WRITE;
 	bool should_dirty = !write && iter_is_iovec(iter);
+	bool from_gup = iov_iter_get_pages_use_gup(iter);
 
 	if (write && ceph_snap(file_inode(file)) != CEPH_NOSNAP)
 		return -EROFS;
@@ -1023,7 +1056,8 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 			aio_req->num_reqs++;
 			atomic_inc(&aio_req->pending_reqs);
 
-			req->r_callback = ceph_aio_complete_req;
+			req->r_callback = !from_gup ? ceph_aio_complete_req :
+					  ceph_aio_from_gup_complete_req;
 			req->r_inode = inode;
 			req->r_priv = aio_req;
 			list_add_tail(&req->r_private_item, &aio_req->osd_reqs);
@@ -1054,7 +1088,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 				len = ret;
 		}
 
-		put_bvecs(bvecs, num_pages, should_dirty);
+		put_bvecs(bvecs, num_pages, should_dirty, from_gup);
 		ceph_osdc_put_request(req);
 		if (ret < 0)
 			break;
@@ -1093,7 +1127,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 							      req, false);
 			if (ret < 0) {
 				req->r_result = ret;
-				ceph_aio_complete_req(req);
+				_ceph_aio_complete_req(req, from_gup);
 			}
 		}
 		return -EIOCBQUEUED;
-- 
2.22.0

