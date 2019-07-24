Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0E272615
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfGXEZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:25:33 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34213 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfGXEZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 00:25:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so21482631plt.1;
        Tue, 23 Jul 2019 21:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CtboR7Ufy9O9fDFcRIuCIk1t8EIvDdcqQ3tCIzPpVTU=;
        b=BFNUQlsly9hFNZnfDRf69ho0wDvCVUqoj8dGJpNcOiGYgy46obMbORHEMN/I5tUQuy
         K86xGPjY4b4QO+54v/Zv7nQ40O3fVB4kil84sULCnYrDgJVTXlsEFmALWYldAbZAgMBP
         fvIXv3sy0T/Ns+lBLfXM4dLPELbccf6aa9owKLeIZQZMk4ea+nMOdmYcBOB36dALtS4z
         0SnWHD/Ra8zQZlPYXX9NedMId4XeBIsKRL/2j4wXYAsw4ctlt6Th0vAum9effAlS+CNc
         g0HRax01vlO2YL0JWYjboqvm7PfjfxsTzbm2nbAhIfIebOVYGUr1FquaKAPIEQbTrE+e
         0YTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CtboR7Ufy9O9fDFcRIuCIk1t8EIvDdcqQ3tCIzPpVTU=;
        b=DGgaTpaQ44/dNT0RGpfVhyiNyCI+atbx/yYS62gUPiAbwoblGbIUKFgBg/SoGrA1OF
         uURIjf2vKwUIlbIkugvm6g38wHrd0f8tYz+PI8xxW2q6WhAuBGEvU9gcDfAhlQ0/OrRF
         r9N2hZDAE5jCE/t9tLVnKEkWgF2XuId+x7ydjVMKZrcBvIQW3Lo98Eusvet9vcMvUqxm
         L+kqwBxzfU28a9Bbu+5rbMtYbkYs9IicGtosyOFG3jbqSp0c7MsW0+si0d36p7mE1j8+
         AVgRTOasuBzki1TsqYfrZhI2j0YRm+oAh5qG1Xq34yagm5hT4rcPBL+Jxb3z+lMewBXH
         OHHg==
X-Gm-Message-State: APjAAAWBro4S/E6UiKux7c7uwvnnT4WqNgGgtj9fuswNTbtHOYwRykGS
        6Dthta66I8haQq5Nc6AZfEZ5tgx5
X-Google-Smtp-Source: APXvYqw2fBb16YWxNCvrkJttPP2qps3nLx7+Bn7G811lLUhuqyz8ucaB8iJLC4by+I8yTQYjbx90Ag==
X-Received: by 2002:a17:902:2ec5:: with SMTP id r63mr82774537plb.21.1563942328383;
        Tue, 23 Jul 2019 21:25:28 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id a15sm34153364pgw.3.2019.07.23.21.25.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 21:25:27 -0700 (PDT)
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
        Boaz Harrosh <boaz@plexistor.com>
Subject: [PATCH 05/12] block_dev: convert put_page() to put_user_page*()
Date:   Tue, 23 Jul 2019 21:25:11 -0700
Message-Id: <20190724042518.14363-6-jhubbard@nvidia.com>
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
via the new put_user_page*() routines, instead of via put_page() or
release_pages().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Changes from Jérôme's original patch:

* reworked to be compatible with recent bio_release_pages() changes.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org
Cc: linux-mm@kvack.org
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
---
 block/bio.c         | 13 +++++++++++++
 fs/block_dev.c      | 22 +++++++++++++++++-----
 include/linux/bio.h |  8 ++++++++
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 74f9eba2583b..3b9f66e64bc1 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1746,6 +1746,19 @@ void bio_check_pages_dirty(struct bio *bio)
 	__bio_check_pages_dirty(bio, false);
 }
 
+enum bio_rp_flags_t bio_rp_flags(struct iov_iter *iter, bool mark_dirty)
+{
+	enum bio_rp_flags_t flags = BIO_RP_NORMAL;
+
+	if (mark_dirty)
+		flags |= BIO_RP_MARK_DIRTY;
+
+	if (iov_iter_get_pages_use_gup(iter))
+		flags |= BIO_RP_FROM_GUP;
+
+	return flags;
+}
+
 void update_io_ticks(struct hd_struct *part, unsigned long now)
 {
 	unsigned long stamp;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9fe6616f8788..d53abaf31e54 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -259,7 +259,7 @@ __blkdev_direct_IO_simple(struct kiocb *iocb, struct iov_iter *iter,
 	}
 	__set_current_state(TASK_RUNNING);
 
-	bio_release_pages(&bio, bio_rp_dirty_flag(should_dirty));
+	bio_release_pages(&bio, bio_rp_flags(iter, should_dirty));
 	if (unlikely(bio.bi_status))
 		ret = blk_status_to_errno(bio.bi_status);
 
@@ -295,7 +295,7 @@ static int blkdev_iopoll(struct kiocb *kiocb, bool wait)
 	return blk_poll(q, READ_ONCE(kiocb->ki_cookie), wait);
 }
 
-static void blkdev_bio_end_io(struct bio *bio)
+static void _blkdev_bio_end_io(struct bio *bio, bool from_gup)
 {
 	struct blkdev_dio *dio = bio->bi_private;
 	bool should_dirty = dio->should_dirty;
@@ -327,13 +327,23 @@ static void blkdev_bio_end_io(struct bio *bio)
 	}
 
 	if (should_dirty) {
-		bio_check_pages_dirty(bio);
+		__bio_check_pages_dirty(bio, from_gup);
 	} else {
-		bio_release_pages(bio, BIO_RP_NORMAL);
+		bio_release_pages(bio, bio_rp_gup_flag(from_gup));
 		bio_put(bio);
 	}
 }
 
+static void blkdev_bio_end_io(struct bio *bio)
+{
+	_blkdev_bio_end_io(bio, false);
+}
+
+static void blkdev_bio_from_gup_end_io(struct bio *bio)
+{
+	_blkdev_bio_end_io(bio, true);
+}
+
 static ssize_t
 __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 {
@@ -380,7 +390,9 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		bio->bi_iter.bi_sector = pos >> 9;
 		bio->bi_write_hint = iocb->ki_hint;
 		bio->bi_private = dio;
-		bio->bi_end_io = blkdev_bio_end_io;
+		bio->bi_end_io = iov_iter_get_pages_use_gup(iter) ?
+				 blkdev_bio_from_gup_end_io :
+				 blkdev_bio_end_io;
 		bio->bi_ioprio = iocb->ki_ioprio;
 
 		ret = bio_iov_iter_get_pages(bio, iter);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d68a40c2c9d4..b9460d1a4679 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -452,6 +452,13 @@ static inline enum bio_rp_flags_t bio_rp_dirty_flag(bool mark_dirty)
 	return mark_dirty ? BIO_RP_MARK_DIRTY : BIO_RP_NORMAL;
 }
 
+static inline enum bio_rp_flags_t bio_rp_gup_flag(bool from_gup)
+{
+	return from_gup ? BIO_RP_FROM_GUP : BIO_RP_NORMAL;
+}
+
+enum bio_rp_flags_t bio_rp_flags(struct iov_iter *iter, bool mark_dirty);
+
 void bio_release_pages(struct bio *bio, enum bio_rp_flags_t flags);
 struct rq_map_data;
 extern struct bio *bio_map_user_iov(struct request_queue *,
@@ -463,6 +470,7 @@ extern struct bio *bio_copy_kern(struct request_queue *, void *, unsigned int,
 				 gfp_t, int);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
+void __bio_check_pages_dirty(struct bio *bio, bool from_gup);
 
 void generic_start_io_acct(struct request_queue *q, int op,
 				unsigned long sectors, struct hd_struct *part);
-- 
2.22.0

