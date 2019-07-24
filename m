Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F15C372626
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfGXEZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:25:41 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44293 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfGXEZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 00:25:39 -0400
Received: by mail-pg1-f193.google.com with SMTP id i18so20511859pgl.11;
        Tue, 23 Jul 2019 21:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I1wDMaqOj/gzGRufAfLYBvs0e80ibIJerHEY6qRx+9Q=;
        b=AJiRp1Uswxxxj2fjLfbqacoLwH06WJ9mszsK/zlNhFuhNoSLtvKRmhFo9KLI7JLl8B
         hxIxG1xThvmkqqGsj4H+PIkZgqzG39WvTfqHCYX31eWH9qZ8HHJptRyRkIYZTdhpSSJA
         nZA7WnB2fukiDrq9dsIiMnZ4oXRSDbx8C0GrWwEoTfJ4nGsrUGvTe9DUv98TbDoHZftU
         2sPJK+pDMsCNPpAzyI5pMUhaliFeOadZMdLhzw1frV4a114QmQGutmlMg9ocT4gPTziz
         ZW1wdryUHfhxRuoKX5pPJ1KukLjcZAbAo24BFz30vzwXdEBQHRvTjXN7uylJkrR8anzL
         2E2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I1wDMaqOj/gzGRufAfLYBvs0e80ibIJerHEY6qRx+9Q=;
        b=Nm9JBfyjZZRpKI39U9r5n8J23vF8EW0fqfdDCkmf9aBgUf4hmqu3GV1JHLRrvCjgav
         7ajV9Wig5bhzAkmozNLVjrsXLNeK8cSpNsOJpvJzi/44SrZEihQxrUi2mrn3lQvXtPCf
         VaEnVe5ByQDxiaRNmvbS550+6zgctRHVvxOaMsl6dxz8hdXh4b/EYxcU3YY3Ue83ZlMJ
         XifOgyxu4jw+pMjT1QMjJHrcDvdzPYMDWqpJ5LfUF9NUM2DmpYx9C0aWg8bbgS5IO0eP
         Zagn/++uqNhC+hRMg5wNk329CJhJ6RsO7IMsuO3mCl/YIE4Ch1W9QMMpuNii6HGlz9AQ
         SBlQ==
X-Gm-Message-State: APjAAAVfcaP/BgUygBi+bAdiEZv1tCKB/k4SLrePn+5mLz4Ph4VhxJL7
        gt3jOXEyc4mAYsIb6M9ll+4=
X-Google-Smtp-Source: APXvYqwVZxneCPfv2nDeo72FQ4K0Ri4nG9i/Jh52gTbxtuFDM1ER91LNrK6Q0r6xmbSBuioIPNnbSg==
X-Received: by 2002:a62:38c6:: with SMTP id f189mr9250236pfa.157.1563942338440;
        Tue, 23 Jul 2019 21:25:38 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id a15sm34153364pgw.3.2019.07.23.21.25.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 21:25:38 -0700 (PDT)
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
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 12/12] fs/ceph: fix a build warning: returning a value from void function
Date:   Tue, 23 Jul 2019 21:25:18 -0700
Message-Id: <20190724042518.14363-13-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724042518.14363-1-jhubbard@nvidia.com>
References: <20190724042518.14363-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

Trivial build warning fix: don't return a value from a function
whose type is "void".

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 fs/ceph/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 2eb88ed22993..fa14c8e8761d 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -294,7 +294,7 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 
 void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 {
-	return 0;
+	return;
 }
 
 void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
-- 
2.22.0

