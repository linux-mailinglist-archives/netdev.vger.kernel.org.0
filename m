Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79425726E0
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfGXEpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:45:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43417 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfGXEpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 00:45:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so20258683pfg.10;
        Tue, 23 Jul 2019 21:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a82RGTEXPGUxT9wrhIl0SGm+IUg23fG0znFClaoZF2M=;
        b=Kd6PSC/URd7UIKcw58+fxXgQ892se8NpHm4OEg6NafKMnFMjvCAiIWdHCoPlLPqc8L
         aJ2qPkFGF7rV4DRVYtDw+kzTyKz++lpvKqFQcAl7iCYllE6k6lUQW6B8w5u+byvfT5Fa
         Q+WPYT0yXJJOYRou8VbShLD+Gu3cc60uHbegYi/Y7R4SDcQBKGF+uJ9+OtewKzKdHYa4
         mDkxAnsVFsH5foR59Pl19TCg37A2eC/JUZHs5kG/6JwxZW5fVI4ecC6e+3X2Ighkd2ts
         XemnURq3vKLirIn4/+d6ODT0qlTyYo8BgEmwVl9sISBYhC7Lqlq4LZICijaj0IvIIAaT
         a7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a82RGTEXPGUxT9wrhIl0SGm+IUg23fG0znFClaoZF2M=;
        b=FRE7a5aR//GVD+LMfnaWDexQH/FwXBnzPOBvwAI+11t+Dg9fluuayZGU7zQDcKnXJV
         6aixU8fQ2HD5oRE+p1FtxGzP6eJZlv+KBKzxoVZeRJLhQgC++q0swsp0Zs12Z9j2SRMI
         BuQ0IAatLMxsJ1BMgBgUu7WSqmTiSawfiW3YKKt5r/7Sd7wnPX1QpiitehUPlGkzcYNZ
         OIJcHsH+lpzeZwvNz4qlCRfpGld7HFR28VJL0lFKJLT2r/IpP0+sZxbhoOi2omgMaMTH
         g3zQdpIokcJbhl7HK8aFrevWdLyxsLFOLv18uJdVxrcL5r9o1HYJ3OL23luOp/Ilr4iY
         Umxg==
X-Gm-Message-State: APjAAAUs6LbTQPxGLoExDJ1RihAYNWP4213TTnr8wpq0e/nNPO0oXG/b
        KKTx05BXxwzbNATJTMiy0hc=
X-Google-Smtp-Source: APXvYqxX+DOW07WMhb+fJsFbx0LQzjFWgiNXaRMsjDo7bpqayKueY9DMdaxKoauo3MlhyMuoWNYR+w==
X-Received: by 2002:a63:1749:: with SMTP id 9mr27042805pgx.0.1563943543120;
        Tue, 23 Jul 2019 21:45:43 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id b30sm65685861pfr.117.2019.07.23.21.45.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 21:45:42 -0700 (PDT)
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
Subject: [PATCH v3 0/3] mm/gup: add make_dirty arg to put_user_pages_dirty_lock()
Date:   Tue, 23 Jul 2019 21:45:34 -0700
Message-Id: <20190724044537.10458-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

Hi,

I apologize for the extra emails (v2 was sent pretty recently), but I
didn't want to leave a known-broken version sitting out there, creating
problems.

Changes since v2:

* Critical bug fix: remove a stray "break;" from the new routine.

Changes since v1:

* Instead of providing __put_user_pages(), add an argument to
  put_user_pages_dirty_lock(), and delete put_user_pages_dirty().
  This is based on the following points:

    1. Lots of call sites become simpler if a bool is passed
    into put_user_page*(), instead of making the call site
    choose which put_user_page*() variant to call.

    2. Christoph Hellwig's observation that set_page_dirty_lock()
    is usually correct, and set_page_dirty() is usually a
    bug, or at least questionable, within a put_user_page*()
    calling chain.

* Added the Infiniband driver back to the patch series, because it is
  a caller of put_user_pages_dirty_lock().

Unchanged parts from the v1 cover letter (except for the diffstat):

Notes about the remaining patches to come:

There are about 50+ patches in my tree [2], and I'll be sending out the
remaining ones in a few more groups:

    * The block/bio related changes (Jerome mostly wrote those, but I've
      had to move stuff around extensively, and add a little code)

    * mm/ changes

    * other subsystem patches

    * an RFC that shows the current state of the tracking patch set. That
      can only be applied after all call sites are converted, but it's
      good to get an early look at it.

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

John Hubbard (3):
  mm/gup: add make_dirty arg to put_user_pages_dirty_lock()
  drivers/gpu/drm/via: convert put_page() to put_user_page*()
  net/xdp: convert put_page() to put_user_page*()

 drivers/gpu/drm/via/via_dmablit.c          |  10 +-
 drivers/infiniband/core/umem.c             |   5 +-
 drivers/infiniband/hw/hfi1/user_pages.c    |   5 +-
 drivers/infiniband/hw/qib/qib_user_pages.c |   5 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c   |   5 +-
 drivers/infiniband/sw/siw/siw_mem.c        |   8 +-
 include/linux/mm.h                         |   5 +-
 mm/gup.c                                   | 115 +++++++++------------
 net/xdp/xdp_umem.c                         |   9 +-
 9 files changed, 61 insertions(+), 106 deletions(-)

-- 
2.22.0

