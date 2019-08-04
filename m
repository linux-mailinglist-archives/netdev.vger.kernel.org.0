Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C942980CCF
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 23:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfHDVkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 17:40:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46011 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfHDVkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 17:40:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id o13so38595940pgp.12;
        Sun, 04 Aug 2019 14:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u7QfHgAZJphiJkiML+n7+9xiXsnu4L5blHeWg2XiOgc=;
        b=u39I0RWzXaT9LZiMOuWXB1YMfdm9l0k5XildL+8oy8WG+Xp+HlNRUNYjNYcsIgMMTB
         ZpD/HwYg5a0o6ahOx9ZYRbmJlZZ3NLwUfe/ls4mO6JoAFJIx/C4wKRP28ihiEUB5VjhT
         D58n4BNw9c55IlGQPpiJrVPRnoEMM0g6/Xf+ahwHFl/B88xU2qGxK/pemUTTRjimFwRi
         t/D8fcfMolCCDTGQO+urRxWr1DbAd4j3hCpOP6OcV/VT/muTPpaFTvV1+DiX2EdeA9OL
         XsnejpGlwKFc3nz+z9brQ1fZaYH/JKmBK+jueenTXLYIBOez7qe7f8v+Db7b0LHhvgd6
         B7fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u7QfHgAZJphiJkiML+n7+9xiXsnu4L5blHeWg2XiOgc=;
        b=eD0MRIqa5Oj8GNBWMxatoMKxfLzjC7ouyELY647D/NYoMmEhvW2Aal2804l0PDCkVH
         0MNCBTfMQMhjhviBwK699xvSKz+xaBOS+tq+dyCNMhZFHLBowBEfcG0EenMH3oq5YgV0
         dRnKbqoZ0XokKnPp/3nhw2q4i7bLWy2YyLQ1f8ak8s/g4Y2BSQ1NszaEkKx+mh92DVoA
         X9eFN99IS8J4DRZw3zCluC1f/gXZdMilYnZ0OxXqtCVOsvrXNSjTb7TmdWpOVBjM762G
         CmqBY0NAsgfRwU/DCZCDFUYHF8+lRto9aa4CuVQUABTl7VaxPSHVNVn0+0bg9HbDfQ2I
         XeTw==
X-Gm-Message-State: APjAAAUkKgjXNKGXTJoltYtU1GCewByfllvZsFD9mNcNAo4QSw2shG3c
        BxdBpTAuhQhfLR8V+fLkL0U=
X-Google-Smtp-Source: APXvYqzFCjqlZU+HDCyGiBEvpK2/pADBDo3dD7v/H/FvucfCIeD6scQK7TlMDTLTVLBWsfhNeMf1fA==
X-Received: by 2002:a17:90a:bc0c:: with SMTP id w12mr14275839pjr.111.1564954845639;
        Sun, 04 Aug 2019 14:40:45 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id 143sm123751024pgc.6.2019.08.04.14.40.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 14:40:44 -0700 (PDT)
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
Subject: [PATCH v6 0/3] mm/gup: add make_dirty arg to put_user_pages_dirty_lock()
Date:   Sun,  4 Aug 2019 14:40:39 -0700
Message-Id: <20190804214042.4564-1-jhubbard@nvidia.com>
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

Changes since v5:

* Patch #1: Fixed a bug that I introduced in v4:
  drivers/infiniband/sw/siw/siw_mem.c needs to refer to
  umem->page_chunk[i].plist, rather than umem->page_chunk[i].

Changes since v4:

* Christophe Hellwig's review applied: deleted siw_free_plist() and
  __qib_release_user_pages(), now that put_user_pages_dirty_lock() does
  what those routines were doing.

* Applied Bjorn's ACK for net/xdp, and Christophe's Reviewed-by for patch
  #1.

Changes since v3:

* Fixed an unused variable warning in siw_mem.c

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
 drivers/infiniband/hw/qib/qib_user_pages.c |  13 +--
 drivers/infiniband/hw/usnic/usnic_uiom.c   |   5 +-
 drivers/infiniband/sw/siw/siw_mem.c        |  19 +---
 include/linux/mm.h                         |   5 +-
 mm/gup.c                                   | 115 +++++++++------------
 net/xdp/xdp_umem.c                         |   9 +-
 9 files changed, 64 insertions(+), 122 deletions(-)

-- 
2.22.0

