Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1BE72679
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfGXEZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:25:26 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46538 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfGXEZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 00:25:25 -0400
Received: by mail-pg1-f194.google.com with SMTP id k189so1468509pgk.13;
        Tue, 23 Jul 2019 21:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qETbyvDGXmWMmkqN4sOdgKXeFkWOntX3r/NRFgCZoWE=;
        b=KG/F7Sd5J79dEipElYhdvyhMIk0TxQlRtZu9bi85rUwY/TE5KUGgUZYMnF+3jcDsXr
         jk+YAZfWVg6gnp2IiqLCse5lUUZrgh27wRKMfQRWXUdRnaO5ZlXDztHkfwCA1gRbK+Qa
         Vdl/mcDwYDvc/aIthkQn3dHIfadxoz9OGVoTMkITstrb8gRinr4GRivAlsVYAzJkRXx3
         qijzZ8AyOYgc5Vk4JND+9sG/qLIVyx5s39WeHO+RM9Ey6ODD5O8kuqfL85vwwK9Febym
         eFolpJZ4Wkv3lsIz5mVKSWu4wewrN05ykT4POz6d2Mi/mkYtEQg5LGvW/0qsyHcM4WB5
         F1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qETbyvDGXmWMmkqN4sOdgKXeFkWOntX3r/NRFgCZoWE=;
        b=mDTylZHWeSo6qrwvCcaaiEvWc5nYOZAPJIEhmSGBd2+3uYQ9fqvcSgOQXKMtWaLtZZ
         uG+ul3tT5lrgX6P7vY2Oj5dRKQRb3w2JYwJj7edw/TgGdQDx5U+7EXgDS15AuTiRdWTk
         WlUrHvz5teCYDMTj4yHLxtB3VIfvVkPUOgMcEpm0o/AXgp4Nf9AtwdY11wRmIgIQ4eTs
         u4m4XHCx3bi1XbDX9QO0tvJNqyMJZBTuRtAIiP1aVOTqpWoZ61IcDRoQzI90qi9Y7dg4
         D3V+frb/PFrG88bAUa5OArCSScHGnjLLGcIzGtOlUmZCf97hSubyGDV2+DMprowr8dM0
         1z7g==
X-Gm-Message-State: APjAAAU4HJTAQZiWrf0O120A4wP01gpn3YeIAagFeudhIO2z3ZfjKqPO
        WD4CpY+PZSWNwxE4vQ/6mEo=
X-Google-Smtp-Source: APXvYqxkwpMUKWSZK/4NQcFDw+bDP7yRS/NluRzHQboqTdh3aehK42NKuj/IACv1wat7jP2wWUy+ng==
X-Received: by 2002:a65:4489:: with SMTP id l9mr81979980pgq.207.1563942324157;
        Tue, 23 Jul 2019 21:25:24 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id a15sm34153364pgw.3.2019.07.23.21.25.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 21:25:23 -0700 (PDT)
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
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/12] iov_iter: add helper to test if an iter would use GUP v2
Date:   Tue, 23 Jul 2019 21:25:08 -0700
Message-Id: <20190724042518.14363-3-jhubbard@nvidia.com>
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

Add a helper to test if call to iov_iter_get_pages*() with a given
iter would result in calls to GUP (get_user_pages*()). We want to
use different tracking of page references if they are coming from
GUP (get_user_pages*()) and thus  we need to know when GUP is used
for a given iter.

Changes since Jérôme's original patch:

* iov_iter_get_pages_use_gup(): do not return true for the ITER_PIPE
case, because iov_iter_get_pages() calls pipe_get_pages(), which in
turn uses get_page(), not get_user_pages().

* Remove some obsolete code, as part of rebasing onto Linux 5.3.

* Fix up the kerneldoc comment to "Return:" rather than "Returns:",
and a few other grammatical tweaks.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: John Hubbard <jhubbard@nvidia.com>
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
---
 include/linux/uio.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index ab5f523bc0df..2a179af8e5a7 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -86,6 +86,17 @@ static inline unsigned char iov_iter_rw(const struct iov_iter *i)
 	return i->type & (READ | WRITE);
 }
 
+/**
+ * iov_iter_get_pages_use_gup - report if iov_iter_get_pages(i) uses GUP
+ * @i: iterator
+ * Return: true if a call to iov_iter_get_pages*() with the iter provided in
+ *          the argument would result in the use of get_user_pages*()
+ */
+static inline bool iov_iter_get_pages_use_gup(const struct iov_iter *i)
+{
+	return iov_iter_type(i) == ITER_IOVEC;
+}
+
 /*
  * Total number of bytes covered by an iovec.
  *
-- 
2.22.0

