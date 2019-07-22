Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C6770CB8
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 00:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733250AbfGVWeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 18:34:23 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32863 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbfGVWeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 18:34:21 -0400
Received: by mail-pf1-f196.google.com with SMTP id g2so18061379pfq.0;
        Mon, 22 Jul 2019 15:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Smy6CazaiFl/H6ExmdJz5h/Ca61boss3Hwy2iE3dK+Q=;
        b=U6/9IuL/TDFPDdHP/xEXC6qMrm1JOrSFcurq01xiF+Ds4AZyxPEN0zUc6M5cA6Ac2S
         lkz9/GilaTPQsdifymQ/iRSnBB3jF8OL7EtArtnl3P24bowo3fJlj3rjN86K6voNS6GH
         Dqmbtb60GhmjYXSXo6GRkm723W8wBuMOSeua5HmsQ6B7GzeInFzsL3p7urhRUckE7nOz
         cZAS/lxZQg2opPLxvraqp1cJo6cbVXc0mSOp571t2fjxJq+aMSbg5Xu5EFd+E1lReoM9
         BS3AbtelcWJr2yfzvyHmXxv8QcBg7OH7i3yTert2ueqfUr/6ie3hJa/sawyB9+pwB1Ts
         W4KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Smy6CazaiFl/H6ExmdJz5h/Ca61boss3Hwy2iE3dK+Q=;
        b=Ng2UUl2LuM+IcF/2WVTTxLeArX4t6iz6uVkruAOHE4eKCa8atjSauyUIhkvT/2Oa0N
         7ey0f2KHCLnWnNCtyTx0G1Y09pEx/2nFDKnEuNpoubDQZJeYG/FTFnYEEHo5WZSydMiY
         Up5CYCbmiZrwHmoD3a4Gdl+0XBt3zotmVvRPrEweloHRk59s4LFpv/3b2aycfLfOUp1C
         TrwUuxwj3nm8wYlmAys+sXhIN6FpQ70srvFDZnfK+ZrLRuoXVUpFXkyVk6jab+CT/Y0H
         hZq6Hx34rPEhVgidzuUK4w5mYLJSoA/IJ9RyBS+Od3tJqvptCdmohnvu55U39yvNa4U7
         5TQQ==
X-Gm-Message-State: APjAAAUd4EPyvDo8Miyg28SUhS5FlVjZu7+U0qiPpodyw0TcKroeSaGK
        BY2bATiwmTTAXej/uCQzaJA=
X-Google-Smtp-Source: APXvYqz/H2LrvbsAG7WTQI6TytjdHd6yi9WvqhWVYARGR3hkdauf6CDVf8InQZb+IHek/f+tTcf/6A==
X-Received: by 2002:a62:1444:: with SMTP id 65mr2422112pfu.145.1563834860576;
        Mon, 22 Jul 2019 15:34:20 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r18sm30597570pfg.77.2019.07.22.15.34.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 15:34:20 -0700 (PDT)
From:   john.hubbard@gmail.com
X-Google-Original-From: jhubbard@nvidia.com
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ilya Dryomov <idryomov@gmail.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ming Lei <ming.lei@redhat.com>, Sage Weil <sage@redhat.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Yan Zheng <zyan@redhat.com>, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 1/3] mm/gup: introduce __put_user_pages()
Date:   Mon, 22 Jul 2019 15:34:13 -0700
Message-Id: <20190722223415.13269-2-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190722223415.13269-1-jhubbard@nvidia.com>
References: <20190722223415.13269-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

Add a more capable variation of put_user_pages() to the
API set, and call it from the simple ones.

The new __put_user_pages() takes an enum that handles the various
combinations of needing to call set_page_dirty() or
set_page_dirty_lock(), before calling put_user_page().

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 include/linux/mm.h |  58 ++++++++++++++++++-
 mm/gup.c           | 137 ++++++++++++++++++++++-----------------------
 2 files changed, 124 insertions(+), 71 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0334ca97c584..7218585681b2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1057,8 +1057,62 @@ static inline void put_user_page(struct page *page)
 	put_page(page);
 }
 
-void put_user_pages_dirty(struct page **pages, unsigned long npages);
-void put_user_pages_dirty_lock(struct page **pages, unsigned long npages);
+enum pup_flags_t {
+	PUP_FLAGS_CLEAN		= 0,
+	PUP_FLAGS_DIRTY		= 1,
+	PUP_FLAGS_LOCK		= 2,
+	PUP_FLAGS_DIRTY_LOCK	= 3,
+};
+
+void __put_user_pages(struct page **pages, unsigned long npages,
+		      enum pup_flags_t flags);
+
+/**
+ * put_user_pages_dirty() - release and dirty an array of gup-pinned pages
+ * @pages:  array of pages to be marked dirty and released.
+ * @npages: number of pages in the @pages array.
+ *
+ * "gup-pinned page" refers to a page that has had one of the get_user_pages()
+ * variants called on that page.
+ *
+ * For each page in the @pages array, make that page (or its head page, if a
+ * compound page) dirty, if it was previously listed as clean. Then, release
+ * the page using put_user_page().
+ *
+ * Please see the put_user_page() documentation for details.
+ *
+ * set_page_dirty(), which does not lock the page, is used here.
+ * Therefore, it is the caller's responsibility to ensure that this is
+ * safe. If not, then put_user_pages_dirty_lock() should be called instead.
+ *
+ */
+static inline void put_user_pages_dirty(struct page **pages,
+					unsigned long npages)
+{
+	__put_user_pages(pages, npages, PUP_FLAGS_DIRTY);
+}
+
+/**
+ * put_user_pages_dirty_lock() - release and dirty an array of gup-pinned pages
+ * @pages:  array of pages to be marked dirty and released.
+ * @npages: number of pages in the @pages array.
+ *
+ * For each page in the @pages array, make that page (or its head page, if a
+ * compound page) dirty, if it was previously listed as clean. Then, release
+ * the page using put_user_page().
+ *
+ * Please see the put_user_page() documentation for details.
+ *
+ * This is just like put_user_pages_dirty(), except that it invokes
+ * set_page_dirty_lock(), instead of set_page_dirty().
+ *
+ */
+static inline void put_user_pages_dirty_lock(struct page **pages,
+					     unsigned long npages)
+{
+	__put_user_pages(pages, npages, PUP_FLAGS_DIRTY_LOCK);
+}
+
 void put_user_pages(struct page **pages, unsigned long npages);
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
diff --git a/mm/gup.c b/mm/gup.c
index 98f13ab37bac..6831ef064d76 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -29,87 +29,86 @@ struct follow_page_context {
 	unsigned int page_mask;
 };
 
-typedef int (*set_dirty_func_t)(struct page *page);
-
-static void __put_user_pages_dirty(struct page **pages,
-				   unsigned long npages,
-				   set_dirty_func_t sdf)
-{
-	unsigned long index;
-
-	for (index = 0; index < npages; index++) {
-		struct page *page = compound_head(pages[index]);
-
-		/*
-		 * Checking PageDirty at this point may race with
-		 * clear_page_dirty_for_io(), but that's OK. Two key cases:
-		 *
-		 * 1) This code sees the page as already dirty, so it skips
-		 * the call to sdf(). That could happen because
-		 * clear_page_dirty_for_io() called page_mkclean(),
-		 * followed by set_page_dirty(). However, now the page is
-		 * going to get written back, which meets the original
-		 * intention of setting it dirty, so all is well:
-		 * clear_page_dirty_for_io() goes on to call
-		 * TestClearPageDirty(), and write the page back.
-		 *
-		 * 2) This code sees the page as clean, so it calls sdf().
-		 * The page stays dirty, despite being written back, so it
-		 * gets written back again in the next writeback cycle.
-		 * This is harmless.
-		 */
-		if (!PageDirty(page))
-			sdf(page);
-
-		put_user_page(page);
-	}
-}
-
 /**
- * put_user_pages_dirty() - release and dirty an array of gup-pinned pages
+ * __put_user_pages() - release an array of gup-pinned pages.
  * @pages:  array of pages to be marked dirty and released.
  * @npages: number of pages in the @pages array.
+ * @flags: additional hints, to be applied to each page:
  *
- * "gup-pinned page" refers to a page that has had one of the get_user_pages()
- * variants called on that page.
+ *	PUP_FLAGS_CLEAN: no additional steps required. (Consider calling
+ *			 put_user_pages() directly, instead.)
  *
- * For each page in the @pages array, make that page (or its head page, if a
- * compound page) dirty, if it was previously listed as clean. Then, release
- * the page using put_user_page().
+ *	PUP_FLAGS_DIRTY: Call set_page_dirty() on the page (if not already
+ *			 dirty).
  *
- * Please see the put_user_page() documentation for details.
+ *      PUP_FLAGS_LOCK: meaningless by itself, but included in order to show
+ *			the numeric relationship between the flags.
  *
- * set_page_dirty(), which does not lock the page, is used here.
- * Therefore, it is the caller's responsibility to ensure that this is
- * safe. If not, then put_user_pages_dirty_lock() should be called instead.
+ *      PUP_FLAGS_DIRTY_LOCK: Call set_page_dirty_lock() on the page (if not
+ *			      already dirty).
  *
+ * For each page in the @pages array, release the page using put_user_page().
  */
-void put_user_pages_dirty(struct page **pages, unsigned long npages)
+void __put_user_pages(struct page **pages, unsigned long npages,
+		      enum pup_flags_t flags)
 {
-	__put_user_pages_dirty(pages, npages, set_page_dirty);
-}
-EXPORT_SYMBOL(put_user_pages_dirty);
+	unsigned long index;
 
-/**
- * put_user_pages_dirty_lock() - release and dirty an array of gup-pinned pages
- * @pages:  array of pages to be marked dirty and released.
- * @npages: number of pages in the @pages array.
- *
- * For each page in the @pages array, make that page (or its head page, if a
- * compound page) dirty, if it was previously listed as clean. Then, release
- * the page using put_user_page().
- *
- * Please see the put_user_page() documentation for details.
- *
- * This is just like put_user_pages_dirty(), except that it invokes
- * set_page_dirty_lock(), instead of set_page_dirty().
- *
- */
-void put_user_pages_dirty_lock(struct page **pages, unsigned long npages)
-{
-	__put_user_pages_dirty(pages, npages, set_page_dirty_lock);
+	/*
+	 * TODO: this can be optimized for huge pages: if a series of pages is
+	 * physically contiguous and part of the same compound page, then a
+	 * single operation to the head page should suffice.
+	 */
+
+	for (index = 0; index < npages; index++) {
+		struct page *page = compound_head(pages[index]);
+
+		switch (flags) {
+		case PUP_FLAGS_CLEAN:
+			break;
+
+		case PUP_FLAGS_DIRTY:
+			/*
+			 * Checking PageDirty at this point may race with
+			 * clear_page_dirty_for_io(), but that's OK. Two key
+			 * cases:
+			 *
+			 * 1) This code sees the page as already dirty, so it
+			 * skips the call to set_page_dirty(). That could happen
+			 * because clear_page_dirty_for_io() called
+			 * page_mkclean(), followed by set_page_dirty().
+			 * However, now the page is going to get written back,
+			 * which meets the original intention of setting it
+			 * dirty, so all is well: clear_page_dirty_for_io() goes
+			 * on to call TestClearPageDirty(), and write the page
+			 * back.
+			 *
+			 * 2) This code sees the page as clean, so it calls
+			 * set_page_dirty(). The page stays dirty, despite being
+			 * written back, so it gets written back again in the
+			 * next writeback cycle. This is harmless.
+			 */
+			if (!PageDirty(page))
+				set_page_dirty(page);
+			break;
+
+		case PUP_FLAGS_LOCK:
+			VM_WARN_ON_ONCE(flags == PUP_FLAGS_LOCK);
+			/*
+			 * Shouldn't happen, but treat it as _DIRTY_LOCK if
+			 * it does: fall through.
+			 */
+
+		case PUP_FLAGS_DIRTY_LOCK:
+			/* Same comments as for PUP_FLAGS_DIRTY apply here. */
+			if (!PageDirty(page))
+				set_page_dirty_lock(page);
+			break;
+		};
+		put_user_page(page);
+	}
 }
-EXPORT_SYMBOL(put_user_pages_dirty_lock);
+EXPORT_SYMBOL(__put_user_pages);
 
 /**
  * put_user_pages() - release an array of gup-pinned pages.
-- 
2.22.0

