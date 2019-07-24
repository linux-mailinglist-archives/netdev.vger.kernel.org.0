Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5E89723AC
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 03:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfGXB0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 21:26:11 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46897 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbfGXB0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 21:26:11 -0400
Received: by mail-pg1-f196.google.com with SMTP id k189so1257617pgk.13;
        Tue, 23 Jul 2019 18:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZQ3b3+gTPmIEd6M8rc0OL/oIvyoPA2pZ++cTTSt4GKc=;
        b=VecBxXs5rJxIUXj5tAX6w+Hu36MM21fpWyIYdvzDbaV5EtbHPF+1+bu2YHIo2FoU+h
         qgdi6MriW4QsnS2XTxhZ3CT9hHBmc1EVrlmoNyXHkWprvBI+Yn65R2PNVIuyQj7C+uon
         nfiSugQzYYHYckLsUa6rRl7irNjE5w2jdXZw55VW7ABnrd4ZUv6TxGXUQO6u5cvjdexn
         tPG75hjNwSOtjk7bSxDRlH3uvppfjJjUfzoCSGVP1Fe1uh8JE829or5noA5IrKenAWjY
         MKbFlG+EhvoMwVq1OJV+07GqhN9qs3wTDTL/YhnOg1Or6Ml8smZa2ujck3hWINs1JfYu
         58Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZQ3b3+gTPmIEd6M8rc0OL/oIvyoPA2pZ++cTTSt4GKc=;
        b=EvqATfmwbyMpaIMVAvYBK76tnRlM4UV//9rvCkTugQf8oEOc8SSAK7bd+DiwF0Omio
         4X1VsBZcfJRrhaYlh/AY8GEKjphb0Gu/r1hS8whl4dosXSfff2OpfF2G5OScrvL5ldlY
         zwWD523DKkEcaeCr/I9hGPAIVSWzxt0PsA1By91mgSACVWCR5PXo+fjsVXrofVUWRqbF
         ttbQ6vQ9mMdqM9eZds52XmzP8Nw6o2cTSyozwU+iBeovJ2npfzCUz2YUWENZbAPLMM+w
         /i1Bs9fUbMHHMwqRgaVTrSK/QMF9CIxqeFSh7drV7nzLe2Jc0APWcm2Ni0x4V52KfNOq
         UyQQ==
X-Gm-Message-State: APjAAAVE2F/bnbFjNCytyGexakunuuBc9o4aVYIYHvC4K7nh1ebDqXV4
        KobCW312sTFOAo+MaIbkP/go84/u
X-Google-Smtp-Source: APXvYqzuP5FE7dHH/rrJY8+GDem6uPH4CkCkgfNEStXt8Z11+GRlVjtJCHbhttMVX4qqkHRdu6Qg0Q==
X-Received: by 2002:a17:90a:bc42:: with SMTP id t2mr84709587pjv.121.1563931570150;
        Tue, 23 Jul 2019 18:26:10 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id k36sm45950119pgl.42.2019.07.23.18.26.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 18:26:09 -0700 (PDT)
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
Subject: [PATCH v2 0/3] mm/gup: add make_dirty arg to put_user_pages_dirty_lock()
Date:   Tue, 23 Jul 2019 18:26:03 -0700
Message-Id: <20190724012606.25844-1-jhubbard@nvidia.com>
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
 mm/gup.c                                   | 116 +++++++++------------
 net/xdp/xdp_umem.c                         |   9 +-
 9 files changed, 62 insertions(+), 106 deletions(-)

-- 
2.22.0

