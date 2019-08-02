Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E1E7E816
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390849AbfHBCUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:20:37 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39497 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390798AbfHBCUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id f17so31161513pfn.6;
        Thu, 01 Aug 2019 19:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=60C6UutqWDg70MnmR2wOYRHcozVv05mGJual4EWfkd0=;
        b=OcjBgeGu8UZCjg/O5HE3tZTmbKV/JxG356gcwN7XI4m7laLxmDfYwr2J+xgouxj3fQ
         Co0dhwd0qY47xArJmyB+EhpJv8h8AiGjGK24lKEHkHPsH9RjihM7pMRvNW+41GJgCLyu
         4QfSp0AC2zblPx9c01ipPR4kYld7HwcvdeZgybQdYrqzUfXd232AEHGN5xFwKTyZmR0/
         4nQ8d9yxpivs4/vMxrtO/9Xc8hiQJpvET/VRicWc2zu2qdEUBl4z9cTSyxwtCJdabvcM
         Ei+d8hsTWnZC71PLDlgF5ytQlKruZFkMxa42zlyyGk4z93JPolm9Mu5LN9FxicLHKdhc
         nCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=60C6UutqWDg70MnmR2wOYRHcozVv05mGJual4EWfkd0=;
        b=UkIA+0+M20jvCQ/rSwGAA+C6lqfiywyTDgGNHxUoIibOte0hNXmxOCeo2Eu9oB/E3k
         nAavmmWxvgXBPXNhG2bp8xDCJpEAr6eLP3Lz5jmnvxYnHf/aO+0Tfdtu1GjYzFbdx+d4
         /Vnd4fOdAXwVBJbHHdVcnmqYZxp7wsabA3lq4PwV7ryzGmegfeMJUlCRqHJDrOh4jpsf
         ff3+W+8WtKBiPDz7XHaI1Y1sEhiWKg7qcL8vtMNljrwH4N3yRX+pe39UDOv5kYM6QpPQ
         kepn+zVmI6vVffpVGlEs15VIEEYXBcQ9MTIbDN6UuWakHf+urMbrOutmwq5LekYYVqs7
         L95g==
X-Gm-Message-State: APjAAAWlqTO+soWmXHZ2I+Z3a8LNfYc8ofIpKLujmgLlL7WvKzQRXo6t
        jGTwmXck0URo5HzEdO2ZtUo=
X-Google-Smtp-Source: APXvYqxJWuQ3PRZS25/rGW/r93tu8qJViELHafWX8OhR+SZHdvKx4eGJZdpIEmnFGk4IpVB5b1wjUA==
X-Received: by 2002:a62:d45d:: with SMTP id u29mr56669248pfl.135.1564712432510;
        Thu, 01 Aug 2019 19:20:32 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:32 -0700 (PDT)
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
Subject: [PATCH 13/34] rapidio: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:19:44 -0700
Message-Id: <20190802022005.5117-14-jhubbard@nvidia.com>
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

