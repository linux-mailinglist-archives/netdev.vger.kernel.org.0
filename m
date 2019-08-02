Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4427E7CA
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390683AbfHBCRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:17:04 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38226 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728255AbfHBCRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:17:03 -0400
Received: by mail-pf1-f194.google.com with SMTP id y15so35157527pfn.5;
        Thu, 01 Aug 2019 19:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qSYlns3rxzw4u/DyjG2ivKH4pSlvpz3tTvNpv+Vzl0A=;
        b=ri/g8fH5EMbaRGeRCBUMa0gqvf5sZKxxRTcoGNlKvndtobuEMarAmuyiWR0Or0yt3d
         ZgeLr0P+kW4cqW28KQH/rOYsII5pR9Pk0M0WFYUApB7SKz6vEgjXY+F34hxONagLYY9L
         Py6Blyj3NR1ZdTatlTm5llaJcajjxdcYrAkl23WVqTVg9XAD+0Qg+cC1rauwop+vVeNx
         bVVFBfM1nAEvoH8ncIKlerRWnqRBlhjzlfCDLJ981KoDXyQRyzFGpLUw/iRcSWFkJ5xl
         t+5zV5laKnX+3Bq/BiZ3lREDjIqp5Q8qRulPXvOqGHi7pfUVWIrfUbywjbnDPsqYnoHP
         +z/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qSYlns3rxzw4u/DyjG2ivKH4pSlvpz3tTvNpv+Vzl0A=;
        b=XZMe4VWepSzRYP8UfKwIQgcNVPi7T4oWjUKoJ/zaLDDn9OKiQ/4TFUtBI9K0iBeWFu
         GshMR9aCMIazDL2sP9SlMzF2d60qV7HsniUuLNuzIr93tQ2c0P3vfYQvH6XPdmiLZfzY
         cVbmpIs0FqXAjbQp/24n7DNFkbwon6xycMfrH8WryCEQwGMw9CwC5HMeX/oEPwny9i4q
         Q9SQ4OuuDWKkC+5uW+5whsaV/Pn4gBSfTn3DFjHDWyLCHSjG++1WP/WrCNz8ijslmXAw
         LvA3tDHg//dawpNGtEqmA7+X+5GNk1PV5Rs97z1b9uotfNu/LPZcr297Gy24RssPy5QJ
         ECDQ==
X-Gm-Message-State: APjAAAW9ErcAfOpiOx8HQwtIH0T4zToF5mWK8tf1miYJQmEB1pG8GpJ4
        xhL6yvGSwLkZC3QiKNE1BSU=
X-Google-Smtp-Source: APXvYqzbu0fqyx1S9wHk9TZWdOKFNLR8W4aJ20JQpVBVWnaUPwqEe+RFqTrVv58Rvjaf0s5gNM1HPA==
X-Received: by 2002:a17:90a:ba93:: with SMTP id t19mr1809345pjr.139.1564712221494;
        Thu, 01 Aug 2019 19:17:01 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id p187sm118200292pfg.89.2019.08.01.19.16.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:17:00 -0700 (PDT)
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
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 02/34] net/rds: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:16:21 -0700
Message-Id: <20190802021653.4882-3-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802021653.4882-1-jhubbard@nvidia.com>
References: <20190802021653.4882-1-jhubbard@nvidia.com>
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

Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: rds-devel@oss.oracle.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 net/rds/info.c    |  5 ++---
 net/rds/message.c |  2 +-
 net/rds/rdma.c    | 15 +++++++--------
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/rds/info.c b/net/rds/info.c
index 03f6fd56d237..ca6af2889adf 100644
--- a/net/rds/info.c
+++ b/net/rds/info.c
@@ -162,7 +162,6 @@ int rds_info_getsockopt(struct socket *sock, int optname, char __user *optval,
 	struct rds_info_lengths lens;
 	unsigned long nr_pages = 0;
 	unsigned long start;
-	unsigned long i;
 	rds_info_func func;
 	struct page **pages = NULL;
 	int ret;
@@ -235,8 +234,8 @@ int rds_info_getsockopt(struct socket *sock, int optname, char __user *optval,
 		ret = -EFAULT;
 
 out:
-	for (i = 0; pages && i < nr_pages; i++)
-		put_page(pages[i]);
+	if (pages)
+		put_user_pages(pages, nr_pages);
 	kfree(pages);
 
 	return ret;
diff --git a/net/rds/message.c b/net/rds/message.c
index 50f13f1d4ae0..d7b0d266c437 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -404,7 +404,7 @@ static int rds_message_zcopy_from_user(struct rds_message *rm, struct iov_iter *
 			int i;
 
 			for (i = 0; i < rm->data.op_nents; i++)
-				put_page(sg_page(&rm->data.op_sg[i]));
+				put_user_page(sg_page(&rm->data.op_sg[i]));
 			mmp = &rm->data.op_mmp_znotifier->z_mmp;
 			mm_unaccount_pinned_pages(mmp);
 			ret = -EFAULT;
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 916f5ec373d8..6762e8696b99 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -162,8 +162,7 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
 				  pages);
 
 	if (ret >= 0 && ret < nr_pages) {
-		while (ret--)
-			put_page(pages[ret]);
+		put_user_pages(pages, ret);
 		ret = -EFAULT;
 	}
 
@@ -276,7 +275,7 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 
 	if (IS_ERR(trans_private)) {
 		for (i = 0 ; i < nents; i++)
-			put_page(sg_page(&sg[i]));
+			put_user_page(sg_page(&sg[i]));
 		kfree(sg);
 		ret = PTR_ERR(trans_private);
 		goto out;
@@ -464,9 +463,10 @@ void rds_rdma_free_op(struct rm_rdma_op *ro)
 		 * to local memory */
 		if (!ro->op_write) {
 			WARN_ON(!page->mapping && irqs_disabled());
-			set_page_dirty(page);
+			put_user_pages_dirty_lock(&page, 1, true);
+		} else {
+			put_user_page(page);
 		}
-		put_page(page);
 	}
 
 	kfree(ro->op_notifier);
@@ -481,8 +481,7 @@ void rds_atomic_free_op(struct rm_atomic_op *ao)
 	/* Mark page dirty if it was possibly modified, which
 	 * is the case for a RDMA_READ which copies from remote
 	 * to local memory */
-	set_page_dirty(page);
-	put_page(page);
+	put_user_pages_dirty_lock(&page, 1, true);
 
 	kfree(ao->op_notifier);
 	ao->op_notifier = NULL;
@@ -867,7 +866,7 @@ int rds_cmsg_atomic(struct rds_sock *rs, struct rds_message *rm,
 	return ret;
 err:
 	if (page)
-		put_page(page);
+		put_user_page(page);
 	rm->atomic.op_active = 0;
 	kfree(rm->atomic.op_notifier);
 
-- 
2.22.0

