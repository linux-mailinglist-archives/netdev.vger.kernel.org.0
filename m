Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B49D7265E
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfGXE0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:26:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35428 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfGXEZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 00:25:30 -0400
Received: by mail-pg1-f194.google.com with SMTP id s1so14201142pgr.2;
        Tue, 23 Jul 2019 21:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sE4MQj+XhMD6UPTZi8xJ0bNX4cYnp7r/5/gkEQk0tas=;
        b=N74tfFByAZggYZcsUYTvgYBqmp8bGoZSPNbPePQDgI9xHOKtDI+JBR5Z/IiOFQ1dt4
         oWVFdgGyfImD0LwBldj16IkrMRl7/f0OT/Q4l6ls05QNNVgjJIUWu+aeK2CLI7WrmOO1
         TCwZxwbVGwL+85kP8X47MDnZlnY5CwsAaw+XO6UEjqntQs8fO4Oc87gAiS/1YP6rdwM3
         9NVpw94/A/DYK3lq7v7X4QjwLe8vgVS0TAdSk8ZgDg7r0yVNM7SKDo6TuP97iAlISt79
         gTDmZw4nL2v0p7bxSBy6D4Zi0oq/Mz2I8pSvkTef9m0MiEMvo0WtG93wFrP09qcMFi9e
         QIZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sE4MQj+XhMD6UPTZi8xJ0bNX4cYnp7r/5/gkEQk0tas=;
        b=iqYADaZtIG7BUtRGDNhhm0cJujxU1dDY8swrKM2zvEA+pV9PZUyC5R9+W9Zc7/SvzK
         KsJTuu1xjy4PKSIbhtNPPLRu7O5fzLyQsHcaAeUM1hudtJwVplcis7Ror9LYadTQuBog
         3BWfZgNLA+XhFgSyo+d35y6qoHKbfU/7QUPY0FEDu+rZ6svYQwExjfHa1Va64Bu0Eutx
         /3FQqE0bSo90WH7Z5mljWp6sLeBrZO8cQNMsWpSPKF3rDyZfFCVkkbZEv3aisrSNNkZL
         bjI9+aWI7EKqvXzKhGjv/OH6iltPHQHdPD9CfaFbV2+RfrLdPbIAWFyZ+HSCeXuRQFaR
         RkPw==
X-Gm-Message-State: APjAAAU10qn9GNfZkl9QGRVAa/uRfjmas9wonDo9j7v0BdG9Jkxu+PgT
        XeVYF6LWoH+8tZTC3nv6BHU=
X-Google-Smtp-Source: APXvYqxW3prZwkWHWgnoMEubD7xNwrSIeIAF1uZdix4e6/fDDx4fF84KKWNkiOUj/KQ81cpzXumLMA==
X-Received: by 2002:a62:4d85:: with SMTP id a127mr9256862pfb.148.1563942329748;
        Tue, 23 Jul 2019 21:25:29 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id a15sm34153364pgw.3.2019.07.23.21.25.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 21:25:29 -0700 (PDT)
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
Subject: [PATCH 06/12] fs/nfs: convert put_page() to put_user_page*()
Date:   Tue, 23 Jul 2019 21:25:12 -0700
Message-Id: <20190724042518.14363-7-jhubbard@nvidia.com>
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

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-nfs@vger.kernel.org
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
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
---
 fs/nfs/direct.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 0cb442406168..35f30fe2900f 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -512,7 +512,10 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 			pos += req_len;
 			dreq->bytes_left -= req_len;
 		}
-		nfs_direct_release_pages(pagevec, npages);
+		if (iov_iter_get_pages_use_gup(iter))
+			put_user_pages(pagevec, npages);
+		else
+			nfs_direct_release_pages(pagevec, npages);
 		kvfree(pagevec);
 		if (result < 0)
 			break;
@@ -935,7 +938,10 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 			pos += req_len;
 			dreq->bytes_left -= req_len;
 		}
-		nfs_direct_release_pages(pagevec, npages);
+		if (iov_iter_get_pages_use_gup(iter))
+			put_user_pages(pagevec, npages);
+		else
+			nfs_direct_release_pages(pagevec, npages);
 		kvfree(pagevec);
 		if (result < 0)
 			break;
-- 
2.22.0

