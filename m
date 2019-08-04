Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4474280E8F
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfHDWtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:49:43 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42533 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfHDWtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:41 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so38581762pff.9;
        Sun, 04 Aug 2019 15:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=60C6UutqWDg70MnmR2wOYRHcozVv05mGJual4EWfkd0=;
        b=dlbSsRNX77Ei4qlHR7ScPLtFWbFA/wSFhYs9NQOll92MElLIHH0XM5uWEMJZOCpSZn
         fw6jxIpOESniygQ2CP+jqWxww/Yc9BpBnk334qu29zs2vzmgy87c6XuHVe23RKpRZPxO
         jThG9GtjK3Wnrebfh/rbMsq7112krYjWlIxKkWaUHxL2oFoS1RUMIQu8ytggftTKUFm3
         IZx5EXAb50Ed18W0N5uy/HOdcsYR51BeefJ+gL6tmEuCp3+fjY6YxhqUW4uaaLKgEtr0
         EwxJMkmMabXGRdUgV0PB/zPRqhRIlzaqolidM2g4cvymDIwFa+iZFzPQhAPl2KRAIsyu
         jBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=60C6UutqWDg70MnmR2wOYRHcozVv05mGJual4EWfkd0=;
        b=VXRIvQiD73GG/l8ggnZH3DORLY4330RzDfbUCB4ROO0WQh/wWtNqPl15Uv9eC2ZBch
         QhZFXtF4m6UvdjDKMdmHIiuqwULZnnx0nr4BMruYh+HPzq5wGJvf00qZ/8FuEqkMiK2J
         BD7pJS6Lzb7ITV2Q/Hc193ao6cGph1qEDI8E3r/joodSSu3xdVpVYqngdlPQbCxY3Oyh
         GNr8F/Ot5rhFCFBKgzhF7JAwPARyy7k06bnyJIDKWhyo5KOM8aD0Pd3Q9QGNhd4kBnTL
         yyc46mipxTgjMT/WlAVRcZb7B0+v/AJ85IjPZ8cGUMCxbMQZcmxb8s7y6yhaJ7sdIUux
         ZYNA==
X-Gm-Message-State: APjAAAWX/8c2rUfpPrDoKXd9YIKPTBX4YG0UdLpz043kmJgjZ2ng9wt9
        EUZKwtpRF8wYX1nr/aIKlOY=
X-Google-Smtp-Source: APXvYqxgxAYQpO8e4Spo4W3ynw/PKZNsgndpQrQdEvTtqBpVU8mbg8ThNNd4XLW1NQVXChaVjFCWhA==
X-Received: by 2002:a05:6a00:4c:: with SMTP id i12mr70639006pfk.134.1564958979908;
        Sun, 04 Aug 2019 15:49:39 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:39 -0700 (PDT)
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
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ioan Nicu <ioan.nicu.ext@nokia.com>,
        Kees Cook <keescook@chromium.org>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH v2 13/34] rapidio: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:48:54 -0700
Message-Id: <20190804224915.28669-14-jhubbard@nvidia.com>
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

Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Ioan Nicu <ioan.nicu.ext@nokia.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index 8155f59ece38..0e8ea0e5a89e 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -572,14 +572,12 @@ static void dma_req_free(struct kref *ref)
 	struct mport_dma_req *req = container_of(ref, struct mport_dma_req,
 			refcount);
 	struct mport_cdev_priv *priv = req->priv;
-	unsigned int i;
 
 	dma_unmap_sg(req->dmach->device->dev,
 		     req->sgt.sgl, req->sgt.nents, req->dir);
 	sg_free_table(&req->sgt);
 	if (req->page_list) {
-		for (i = 0; i < req->nr_pages; i++)
-			put_page(req->page_list[i]);
+		put_user_pages(req->page_list, req->nr_pages);
 		kfree(req->page_list);
 	}
 
@@ -815,7 +813,7 @@ rio_dma_transfer(struct file *filp, u32 transfer_mode,
 	struct mport_dma_req *req;
 	struct mport_dev *md = priv->md;
 	struct dma_chan *chan;
-	int i, ret;
+	int ret;
 	int nents;
 
 	if (xfer->length == 0)
@@ -946,8 +944,7 @@ rio_dma_transfer(struct file *filp, u32 transfer_mode,
 
 err_pg:
 	if (!req->page_list) {
-		for (i = 0; i < nr_pages; i++)
-			put_page(page_list[i]);
+		put_user_pages(page_list, nr_pages);
 		kfree(page_list);
 	}
 err_req:
-- 
2.22.0

