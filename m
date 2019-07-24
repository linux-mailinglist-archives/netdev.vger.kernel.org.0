Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A106D72680
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 06:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfGXEZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 00:25:23 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39785 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfGXEZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 00:25:22 -0400
Received: by mail-pf1-f195.google.com with SMTP id f17so16235614pfn.6;
        Tue, 23 Jul 2019 21:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=czbKIXOb/Go0XhMRs2MEN6VnTG6u3MuZundQHh6fuSE=;
        b=drt6EjFdosCAcMEHtdm6+Wwi0M6mSxOzFkxqawZr6IPXLSVzqb/W29XJdPWwpIC0hK
         6O36OujVLFyXEay6jApmdcKGKaFf8ZHrynwkSnL37TGZQHVi5dSIejM/BVPUxQ7VV65S
         fWBfNJcl5fT06CyStqADu0QhfKQgev+DV1jB/43XtDAQrRVBT4D8hAHyS32+/jE194Ee
         9IJK8BdynnPV24hoHobSOouQX3yA4+C8Ogba9Jjmu1EUBDg3exofJAkPMZ4BVkwyR1FN
         DpKTuGd8V6acalOBWqjEaikoQcAKX4Ix3w6DkaRL7W59P9w2XZ6f+kz4iv47D5f4dYHi
         ARbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=czbKIXOb/Go0XhMRs2MEN6VnTG6u3MuZundQHh6fuSE=;
        b=Rw/FoVxyf7G530+xTrSsfsezIOn56PVIzMdw5uSPJCWXG7DRQtalifYk5M5c9+EhLv
         O52MtOven3BP6beICwYTanQ0SvpycyZFDGwo9811B3Y1AGpN76gSsI9DOmv379PCYhu4
         7vgpaOHAMwvR7+caYQplJ/QN4562GuqHgXHmGmeOD1mr7GEUx2UPNPHuvM+vKj1ZOltD
         5lIi3g5wdyyg5VXhNRFKtXwPdCJCtcI5DZPXB9bHENHHqOTH7oiODHFRqVpNky+ZabI/
         swUXb9D6Rr4k1/OPeyJngqfX64qAOVmdwUP/Vj9E1oFRW4BAndYbEcAhIS+jNSAT/WaS
         I9ww==
X-Gm-Message-State: APjAAAVN1VhOyoqLz9R6b2/m+bXT5auNuPEOYanYrK8iQ4AVv+nB3sZ2
        iWqUG7k5/DG8qXrtoPw3DpQ=
X-Google-Smtp-Source: APXvYqwbbPiJvrG7YMdt1a1WYUqGY2Z5kAsIWFPe6nz2zmmLERZ6mi3tyMsrNzYm3HTPDg7yUokVfw==
X-Received: by 2002:a65:6288:: with SMTP id f8mr74189986pgv.292.1563942321242;
        Tue, 23 Jul 2019 21:25:21 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id a15sm34153364pgw.3.2019.07.23.21.25.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 21:25:20 -0700 (PDT)
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
Subject: [PATCH 00/12] block/bio, fs: convert put_page() to put_user_page*()
Date:   Tue, 23 Jul 2019 21:25:06 -0700
Message-Id: <20190724042518.14363-1-jhubbard@nvidia.com>
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

This is mostly Jerome's work, converting the block/bio and related areas
to call put_user_page*() instead of put_page(). Because I've changed
Jerome's patches, in some cases significantly, I'd like to get his
feedback before we actually leave him listed as the author (he might
want to disown some or all of these).

I added a new patch, in order to make this work with Christoph Hellwig's
recent overhaul to bio_release_pages(): "block: bio_release_pages: use
flags arg instead of bool".

I've started the series with a patch that I've posted in another
series ("mm/gup: add make_dirty arg to put_user_pages_dirty_lock()"[1]),
because I'm not sure which of these will go in first, and this allows each
to stand alone.

Testing: not much beyond build and boot testing has been done yet. And
I'm not set up to even exercise all of it (especially the IB parts) at
run time.

Anyway, changes here are:

* Store, in the iov_iter, a "came from gup (get_user_pages)" parameter.
  Then, use the new iov_iter_get_pages_use_gup() to retrieve it when
  it is time to release the pages. That allows choosing between put_page()
  and put_user_page*().

* Pass in one more piece of information to bio_release_pages: a "from_gup"
  parameter. Similar use as above.

* Change the block layer, and several file systems, to use
  put_user_page*().

[1] https://lore.kernel.org/r/20190724012606.25844-2-jhubbard@nvidia.com
    And please note the correction email that I posted as a follow-up,
    if you're looking closely at that patch. :) The fixed version is
    included here.

John Hubbard (3):
  mm/gup: add make_dirty arg to put_user_pages_dirty_lock()
  block: bio_release_pages: use flags arg instead of bool
  fs/ceph: fix a build warning: returning a value from void function

Jérôme Glisse (9):
  iov_iter: add helper to test if an iter would use GUP v2
  block: bio_release_pages: convert put_page() to put_user_page*()
  block_dev: convert put_page() to put_user_page*()
  fs/nfs: convert put_page() to put_user_page*()
  vhost-scsi: convert put_page() to put_user_page*()
  fs/cifs: convert put_page() to put_user_page*()
  fs/fuse: convert put_page() to put_user_page*()
  fs/ceph: convert put_page() to put_user_page*()
  9p/net: convert put_page() to put_user_page*()

 block/bio.c                                |  81 ++++++++++++---
 drivers/infiniband/core/umem.c             |   5 +-
 drivers/infiniband/hw/hfi1/user_pages.c    |   5 +-
 drivers/infiniband/hw/qib/qib_user_pages.c |   5 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c   |   5 +-
 drivers/infiniband/sw/siw/siw_mem.c        |   8 +-
 drivers/vhost/scsi.c                       |  13 ++-
 fs/block_dev.c                             |  22 +++-
 fs/ceph/debugfs.c                          |   2 +-
 fs/ceph/file.c                             |  62 ++++++++---
 fs/cifs/cifsglob.h                         |   3 +
 fs/cifs/file.c                             |  22 +++-
 fs/cifs/misc.c                             |  19 +++-
 fs/direct-io.c                             |   2 +-
 fs/fuse/dev.c                              |  22 +++-
 fs/fuse/file.c                             |  53 +++++++---
 fs/nfs/direct.c                            |  10 +-
 include/linux/bio.h                        |  22 +++-
 include/linux/mm.h                         |   5 +-
 include/linux/uio.h                        |  11 ++
 mm/gup.c                                   | 115 +++++++++------------
 net/9p/trans_common.c                      |  14 ++-
 net/9p/trans_common.h                      |   3 +-
 net/9p/trans_virtio.c                      |  18 +++-
 24 files changed, 357 insertions(+), 170 deletions(-)

-- 
2.22.0

