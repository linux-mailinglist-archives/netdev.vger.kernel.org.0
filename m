Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B2580D05
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfHDWtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:49:24 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37310 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfHDWtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id b3so35710109plr.4;
        Sun, 04 Aug 2019 15:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qSYlns3rxzw4u/DyjG2ivKH4pSlvpz3tTvNpv+Vzl0A=;
        b=jybTYrVi3/xq5/4/5FbFZ3A+Avi8eGYC8zV2Lajlkkya81v1pvJ+j//mJRmP4os7lD
         Pd8/w1skHq1YhYCv/cTm/07sKK/5LLwMY8yKb56jpoRl4sOTEaO+YO4fS+uW5ibDjRY4
         SK47Sk33sgjSTM7WW3t5om3RQhbUAfKBukSB3Qa58elVFhWeS7gpKY2dEl5CUEmL0GkT
         cJU+T8cGekNAadyTXtrRFo2GhHLpIpM1jLMDjk030E5OQOxXyXaMHIl1GlqZCTT1a7gE
         aQRQ8be9PYnGm7aS2SHXD5MvGcDLHk+brY9g31PQLix1KL7YxVkXuE8j/pWB0S9GgrCJ
         uOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qSYlns3rxzw4u/DyjG2ivKH4pSlvpz3tTvNpv+Vzl0A=;
        b=SWT9t67bJWNPnkUhNvKAXRFl4+nOAfKh9SDszGEpVrZtpu39PlCqsBEorvewnUoJyc
         N9FSFLk7uY5bbu99aLIcQUqHuUMddmmRxmAb91ltzqbF0E1pk1D8Ip9ywL3DRWxfEZ2a
         M9o02ZGjGx4L2qsytcv9B71Nksci0lZcRoLZxENGnTUZ465xrz76lLltbxH8adYwt91J
         j0/O4axtEAz4g/G1CVRYaa7vMCUbs1sC8XeV0mUkM1rE7Ee4o3HOn7p1i3fjx7J0FjGK
         QvrW8bzP5zBskQQtBbeBuVoCqBEqSK1SRki8/YK7inh5rnemnFZwDkvp6vFUokge6R7x
         sAyw==
X-Gm-Message-State: APjAAAUWfCOF6oq8d3g7uELGaGyokIM178tO+VWrsInK0jkfg0LZPtsD
        yNXTJHcSeTzcZ7Pl6agUh/g=
X-Google-Smtp-Source: APXvYqzWB5R7n8mlQi4NRUdHeMD3L3s1VHDWKbtchA3/EyzJr1LK3u0mwvhN/yz/RE2XpFwfmsejNQ==
X-Received: by 2002:a17:902:b48c:: with SMTP id y12mr106521467plr.202.1564958962017;
        Sun, 04 Aug 2019 15:49:22 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:21 -0700 (PDT)
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
Subject: [PATCH v2 02/34] net/rds: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:48:43 -0700
Message-Id: <20190804224915.28669-3-jhubbard@nvidia.com>
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

