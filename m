Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98977264F
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfGXE0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:26:32 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40826 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfGXEZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 00:25:32 -0400
Received: by mail-pl1-f196.google.com with SMTP id a93so21418454pla.7;
        Tue, 23 Jul 2019 21:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BJP8QYXxp7VfUt7Eaw5PwJTw08pU7M/uVeuocSBpfVU=;
        b=JkQ04mWEAa/01zFb0tlIM6Uj/lB55wPCkF6GMvnL5gHq24gOeLxpu2syudv1ZeubVR
         o/2/SbGfs0MBuqHwUIG/UqiIYwjvwRdM1smByZv+PMbXD0dTKJlqPSntSI4p9XbD0/EP
         dCEFzTMQ+3jKQsrfKqZebfyOsyegrsrPG3hntSrqUGy/c3DI5jDFIn00D4+KacGWHwyg
         5+f61ycblG2ySUuAZOjASXUKEg6G7NHj0n1tTzQ86l9qr5EKD1HA2V/yosWmHzLAWWAj
         WxbUEPr8ZwbT/LJAb0AztRPHVuEiMh11F1nlDvqA1UHHjZuRTFB0keSEGorINX0fFgb2
         sO/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BJP8QYXxp7VfUt7Eaw5PwJTw08pU7M/uVeuocSBpfVU=;
        b=thFSL7sx+r4akzxXmiEiA2LrLmSrS9j5zLA+uw2lkNI3L4Apc86cvdqIuxGvixua93
         duDNYw+/Pc4iL2C/Ad6rfKQb+Q2NI8gA5V3CXQuwE3YthEp4BjHaFNg6T78UtRiPCFJ6
         1Dfc5u6MWa4n7AEiL8VqokdDjh2Aef8J2fCRVlD5L9n1zAWTw4PmeFdotycXAOOIpkal
         mRU1KFYM1+783i7E4MdDyY/U15XwuMzcDCsjWQ6/6mcm9+8pDqowRpeaQIBFsTB8pkzn
         ewxnhyrH9DpyBMwQUs7EI1IowHQ8dLePK9c9GKhQ1n5dZdg1YltIO7DnhNTnycfw2aP5
         sy4A==
X-Gm-Message-State: APjAAAU7VCyAr9Bo2cxQSduPNOD1zAXPdJmX6NL2jGq7peXohtXEdC01
        2m72QEVJRJAYucQEIXGTr4Y=
X-Google-Smtp-Source: APXvYqwp+g/SqY8cK+RhyrKnPd9NNEiEh2F/BoaBOdfDPn2MZtzIjgPt3GPtA4VFQfpQXahpL/YYYg==
X-Received: by 2002:a17:902:ac85:: with SMTP id h5mr84794603plr.198.1563942331371;
        Tue, 23 Jul 2019 21:25:31 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id a15sm34153364pgw.3.2019.07.23.21.25.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 21:25:30 -0700 (PDT)
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
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 07/12] vhost-scsi: convert put_page() to put_user_page*()
Date:   Tue, 23 Jul 2019 21:25:13 -0700
Message-Id: <20190724042518.14363-8-jhubbard@nvidia.com>
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

* Changed a WARN_ON to a BUG_ON.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: virtualization@lists.linux-foundation.org
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
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
---
 drivers/vhost/scsi.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index a9caf1bc3c3e..282565ab5e3f 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -329,11 +329,11 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 
 	if (tv_cmd->tvc_sgl_count) {
 		for (i = 0; i < tv_cmd->tvc_sgl_count; i++)
-			put_page(sg_page(&tv_cmd->tvc_sgl[i]));
+			put_user_page(sg_page(&tv_cmd->tvc_sgl[i]));
 	}
 	if (tv_cmd->tvc_prot_sgl_count) {
 		for (i = 0; i < tv_cmd->tvc_prot_sgl_count; i++)
-			put_page(sg_page(&tv_cmd->tvc_prot_sgl[i]));
+			put_user_page(sg_page(&tv_cmd->tvc_prot_sgl[i]));
 	}
 
 	vhost_scsi_put_inflight(tv_cmd->inflight);
@@ -630,6 +630,13 @@ vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
 	size_t offset;
 	unsigned int npages = 0;
 
+	/*
+	 * Here in all cases we should have an IOVEC which use GUP. If that is
+	 * not the case then we will wrongly call put_user_page() and the page
+	 * refcount will go wrong (this is in vhost_scsi_release_cmd())
+	 */
+	WARN_ON(!iov_iter_get_pages_use_gup(iter));
+
 	bytes = iov_iter_get_pages(iter, pages, LONG_MAX,
 				VHOST_SCSI_PREALLOC_UPAGES, &offset);
 	/* No pages were pinned */
@@ -681,7 +688,7 @@ vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, bool write,
 			while (p < sg) {
 				struct page *page = sg_page(p++);
 				if (page)
-					put_page(page);
+					put_user_page(page);
 			}
 			return ret;
 		}
-- 
2.22.0

