Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2647266F
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfGXE1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:27:10 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46543 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbfGXEZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 00:25:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id k189so1468587pgk.13;
        Tue, 23 Jul 2019 21:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VoKYI+UUiS6YcrnvVkznU7iujzeTV7cPJsbn4q5uYok=;
        b=srCEjuKdmgTtGGJA378IGBXmCqyTbsbIjMqfoeenayBrGBy5vehEwtDrFvuijZFoTd
         rScSFUBXDFgZSITel7jOkrOPuVU8F5rry3vtfpMM2D7CeG0RrJuH7hgFj+PRndl7N1gW
         deZirUtKYKLuIRRXAf1U+l262rmyF1+wQhnXfVmQ91LL1+9RzmuQ9g6DIyRbodwSmwkf
         luAgCx4Jh2U/kIoDrgk0a2bpkEIwsDMjxtnPpArcF/E8dH/PwetBRncfIHEHnvxafXic
         wOzPw8hX8ys1ZDuhUpTDpwmfZFOimd4ZZ9s54WJn7/lu6Or6c+DjhaXkLZqlThRstapF
         vwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VoKYI+UUiS6YcrnvVkznU7iujzeTV7cPJsbn4q5uYok=;
        b=XD+Nfve8tUVvuxREl6qoxvr5Cwjy9J+brs1Bv+dfA7ieaXZzV8FhppIJJx8kgE4bpz
         /Vnpc9/LQqZ8RB87nEUOpGFZpl8zxuJ3iVY5k9rmBy4UHeDY5bKtdtWn9tyRDHzVJjyF
         iTANlWi1MfcwPNx12ASHFavDwoYwjdLrhVDdYn52i8T1ghqHMMfdd3Wh5zwnhLs1WoJV
         fOqOvs+Tvz1RWgYZcYziuFJ1fuw74ebsDpHoqPchKMoej1BGj25dDQq9/BEf04yMzASC
         RMfOYJhJ3yPW7iZQ0WtaXDb8JSnjNeRDXsapbYrZ6gs3GRzZ6/rj38h1VU2Q8TYHNTP0
         +gvw==
X-Gm-Message-State: APjAAAUjXaFwgRlOzpTLqXqvVA19Z6IHikTCv7oY9z7DkGmaAx9cjguL
        2iaDo05VcsLYyTv6dP7XQzXrTioH
X-Google-Smtp-Source: APXvYqyK6xSNDGD+vqS3B3uhhp2vi85DZLeiUnQNXlrooXu4OGV2TbsZCsKTXuxuk/1vZZ0xEw9zNg==
X-Received: by 2002:aa7:9834:: with SMTP id q20mr9351362pfl.196.1563942326983;
        Tue, 23 Jul 2019 21:25:26 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id a15sm34153364pgw.3.2019.07.23.21.25.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 21:25:26 -0700 (PDT)
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
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Minwoo Im <minwoo.im.dev@gmail.com>
Subject: [PATCH 04/12] block: bio_release_pages: convert put_page() to put_user_page*()
Date:   Tue, 23 Jul 2019 21:25:10 -0700
Message-Id: <20190724042518.14363-5-jhubbard@nvidia.com>
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
    * reworked to be compatible with recent bio_release_pages() changes,
    * refactored slightly to remove some code duplication,
    * use an approach that changes fewer bio_check_pages_dirty()
      callers.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Minwoo Im <minwoo.im.dev@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/bio.c         | 60 ++++++++++++++++++++++++++++++++++++---------
 include/linux/bio.h |  1 +
 2 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 7675e2de509d..74f9eba2583b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -844,7 +844,11 @@ void bio_release_pages(struct bio *bio, enum bio_rp_flags_t flags)
 	bio_for_each_segment_all(bvec, bio, iter_all) {
 		if ((flags & BIO_RP_MARK_DIRTY) && !PageCompound(bvec->bv_page))
 			set_page_dirty_lock(bvec->bv_page);
-		put_page(bvec->bv_page);
+
+		if (flags & BIO_RP_FROM_GUP)
+			put_user_page(bvec->bv_page);
+		else
+			put_page(bvec->bv_page);
 	}
 }
 
@@ -1667,28 +1671,50 @@ static void bio_dirty_fn(struct work_struct *work);
 static DECLARE_WORK(bio_dirty_work, bio_dirty_fn);
 static DEFINE_SPINLOCK(bio_dirty_lock);
 static struct bio *bio_dirty_list;
+static struct bio *bio_gup_dirty_list;
 
-/*
- * This runs in process context
- */
-static void bio_dirty_fn(struct work_struct *work)
+static void __bio_dirty_fn(struct work_struct *work,
+			   struct bio **dirty_list,
+			   enum bio_rp_flags_t flags)
 {
 	struct bio *bio, *next;
 
 	spin_lock_irq(&bio_dirty_lock);
-	next = bio_dirty_list;
-	bio_dirty_list = NULL;
+	next = *dirty_list;
+	*dirty_list = NULL;
 	spin_unlock_irq(&bio_dirty_lock);
 
 	while ((bio = next) != NULL) {
 		next = bio->bi_private;
 
-		bio_release_pages(bio, BIO_RP_MARK_DIRTY);
+		bio_release_pages(bio, BIO_RP_MARK_DIRTY | flags);
 		bio_put(bio);
 	}
 }
 
-void bio_check_pages_dirty(struct bio *bio)
+/*
+ * This runs in process context
+ */
+static void bio_dirty_fn(struct work_struct *work)
+{
+	__bio_dirty_fn(work, &bio_dirty_list,     BIO_RP_NORMAL);
+	__bio_dirty_fn(work, &bio_gup_dirty_list, BIO_RP_FROM_GUP);
+}
+
+/**
+ * __bio_check_pages_dirty() - queue up pages on a workqueue to dirty them
+ * @bio: the bio struct containing the pages we should dirty
+ * @from_gup: did the pages in the bio came from GUP (get_user_pages*())
+ *
+ * This will go over all pages in the bio, and for each non dirty page, the
+ * bio is added to a list of bio's that need to get their pages dirtied.
+ *
+ * We also need to know if the pages in the bio are coming from GUP or not,
+ * as GUPed pages need to be released via put_user_page(), instead of
+ * put_page(). Please see Documentation/vm/get_user_pages.rst for details
+ * on that.
+ */
+void __bio_check_pages_dirty(struct bio *bio, bool from_gup)
 {
 	struct bio_vec *bvec;
 	unsigned long flags;
@@ -1699,17 +1725,27 @@ void bio_check_pages_dirty(struct bio *bio)
 			goto defer;
 	}
 
-	bio_release_pages(bio, BIO_RP_NORMAL);
+	bio_release_pages(bio, from_gup ? BIO_RP_FROM_GUP : BIO_RP_NORMAL);
 	bio_put(bio);
 	return;
 defer:
 	spin_lock_irqsave(&bio_dirty_lock, flags);
-	bio->bi_private = bio_dirty_list;
-	bio_dirty_list = bio;
+	if (from_gup) {
+		bio->bi_private = bio_gup_dirty_list;
+		bio_gup_dirty_list = bio;
+	} else {
+		bio->bi_private = bio_dirty_list;
+		bio_dirty_list = bio;
+	}
 	spin_unlock_irqrestore(&bio_dirty_lock, flags);
 	schedule_work(&bio_dirty_work);
 }
 
+void bio_check_pages_dirty(struct bio *bio)
+{
+	__bio_check_pages_dirty(bio, false);
+}
+
 void update_io_ticks(struct hd_struct *part, unsigned long now)
 {
 	unsigned long stamp;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2715e55679c1..d68a40c2c9d4 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -444,6 +444,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
 enum bio_rp_flags_t {
 	BIO_RP_NORMAL		= 0,
 	BIO_RP_MARK_DIRTY	= 1,
+	BIO_RP_FROM_GUP		= 2,
 };
 
 static inline enum bio_rp_flags_t bio_rp_dirty_flag(bool mark_dirty)
-- 
2.22.0

