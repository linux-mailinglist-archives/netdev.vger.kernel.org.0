Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF5076F88B
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 06:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfGVEaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 00:30:16 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33227 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfGVEaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 00:30:16 -0400
Received: by mail-pg1-f196.google.com with SMTP id f20so7797551pgj.0;
        Sun, 21 Jul 2019 21:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JVt6ZsruZdEjCeuPEiZoevmx4LJB3+Wj53DW9JaZ1Yk=;
        b=VOdsVprSu9cGW1iqrmfPQX3xmYU5Z1o9cHF6pOzbJltiYhuYCge33pdD6CwMEXjvNM
         sFi5J1se+WaXJ91/TKlPNrLGUHwxnpIw4qn7UAwShRFJ/W8Nr1RUSKFA7n+45aPr6x5C
         WXA+RxInAR0EH7vDnRS0n0aIDe479ShZenlcHSFgtmJCj4AKpuj0qM5VYVp+YAGkHdwE
         O4cIZ7alr6idAM7ATqKQj8tHNYN+A4KH9dTbPVf+Boq9vCTQQ+AaVmGwBppTWRbLCXxn
         GvquR0RX9Yva+IepmKTElD2ekCLJhgD/84GbCKePJ9GNR9JpwzZV3DJPl7z/yc4lJjwJ
         ABng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JVt6ZsruZdEjCeuPEiZoevmx4LJB3+Wj53DW9JaZ1Yk=;
        b=NO+X1840YjipeTX9e7QqUJ5bnfCBv8G5tVALj6POnogMDhbSOxfyx25rbyNGowq+Ge
         5LLDusijfx+tCQCF8qNDaZL+4bhish+XXw0kG737pMSnmMY8IUY6dRf+63C0hIPS7wx1
         i/+q2QgQoSa2xXx5X68mM9PfTaKJA/hKii9Jvf3MZaF9k9GpTjfsWzGuTVxqAM3JPoOF
         HfnmmJc4TeGs0V6/sv7VMzeKDDGEa9e64Ow2Uf2rSjwe5eYsRMgIdldMt5iRyhxQ9JPe
         yeWvh/+TAiuu7jLu48XP7Rdv9KfJ5r4+n4NVYdS79e5qZTryhoTn7Bq7q8MILDTerkp8
         eSZA==
X-Gm-Message-State: APjAAAWEzM7bNSeu3wseysHDtBsEnFJsPBgxDli45BVSZcIJSRDE0agQ
        YNKnQvWGyYLKGF9gSmh2KCU=
X-Google-Smtp-Source: APXvYqztu+uwlucjHIzVmQ0L57MjZIIjZ2e8k8CcXoJiraVsvVA60l6ON4zhkWJGUUfJVOo89G9VTA==
X-Received: by 2002:a17:90a:e397:: with SMTP id b23mr74049775pjz.140.1563769815699;
        Sun, 21 Jul 2019 21:30:15 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id t96sm34285690pjb.1.2019.07.21.21.30.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 21 Jul 2019 21:30:15 -0700 (PDT)
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
Subject: [PATCH 0/4] put_user_page: new put_user_page_dirty*() helpers
Date:   Sun, 21 Jul 2019 21:30:09 -0700
Message-Id: <20190722043012.22945-1-jhubbard@nvidia.com>
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

Here is the first small batch of call site conversions for put_page()
to put_user_page().

This batch includes some, but not all of the places that benefit from the
two new put_user_page_dirty*() helper functions. (The ordering of call site
conversion patch submission makes it better to wait until later, to convert
the rest.)

There are about 50+ patches in my tree [1], and I'll be sending out the
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

[1] https://github.com/johnhubbard/linux/tree/gup_dma_core

John Hubbard (4):
  drivers/gpu/drm/via: convert put_page() to put_user_page*()
  net/xdp: convert put_page() to put_user_page*()
  net/rds: convert put_page() to put_user_page*()
  gup: new put_user_page_dirty*() helpers

 drivers/gpu/drm/via/via_dmablit.c        |  5 +++--
 drivers/infiniband/core/umem.c           |  2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c |  2 +-
 include/linux/mm.h                       | 10 ++++++++++
 net/rds/info.c                           |  5 ++---
 net/rds/message.c                        |  2 +-
 net/rds/rdma.c                           | 15 +++++++--------
 net/xdp/xdp_umem.c                       |  3 +--
 8 files changed, 26 insertions(+), 18 deletions(-)

-- 
2.22.0

