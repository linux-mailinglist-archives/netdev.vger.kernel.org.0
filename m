Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7087E70CC2
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 00:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733229AbfGVWeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 18:34:20 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46416 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbfGVWeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 18:34:19 -0400
Received: by mail-pl1-f195.google.com with SMTP id c2so19731796plz.13;
        Mon, 22 Jul 2019 15:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QIVVOI9gQsNqxVjPu4etuG1LAE6h//kEaksqjz3X+CU=;
        b=BMDsv5gG591HtpdOHiM5RyNT1mlqGKuDllYZiTvtfU6CS37Na6fH30nZ9rafb98EIN
         Wlx6iYo9w1xSehuO8cIJ4H5bGxghqyq/GdTmn8CtSOjBrKbVjiTCAavuri+1MJ+5Lp9e
         ObaapI4WPRlWLRFRAe0E0R3/VMrPOqGwFLm0iaeIqT1zZr/EjHzUVR61q43igVVjThf5
         hfxKwYURdgHOehai2YXnoTuh01yL6YImTUqYbD+uXPyZT1gjMy3KpQ/FF0BCGEDZoSoL
         09JhKrG9WJuSpUXM5gobrsghXz+1i6xd9uKLZ5Miti6aS5v9RD3RibWcoah6SPr4u6OX
         ZMcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QIVVOI9gQsNqxVjPu4etuG1LAE6h//kEaksqjz3X+CU=;
        b=lqrdojt/VOGpZQAL0fEj0iJ5o8td0pqhVNbPUfygb1U/fle0lhMWHOLtlUcF6CkKGX
         uqpVEQ8piRw9FnS3RGlkGdxScuYsjpvTwrkRWPn/uevJr47mIRAoftJehOcpKR5DtK1S
         k0rpXZiYoIPfXtUOE8ZTAuqvuda6lIkI/FVUlvNK9rMeNyc3zwt4b4oeo46jZsnkqbFD
         091It22kbvLnqnDQCBoYBtg5If8NE+t6VI93MJmYC/a7ymIkyBPZanv7q9mw9/VBDGwF
         65irFD7lFOuOJAq8KG1FbpAmUDLovfCyiMYdQL3Di1JVtVLNBYWpgyTNyfo9xIZP3UDJ
         a01g==
X-Gm-Message-State: APjAAAVZzk04mr2XOmYuerCt7moKwkwTX6hi5lLpY6v5YoBiIbTA410N
        jmholzBwLg1oFcN6m8DYlck=
X-Google-Smtp-Source: APXvYqxp+r9/TLSrU0csTSoFktj9yzfPPZmms2rTPYm/o4pShtHwmlaILQQ11XVVhMCGVRsd5PF4qg==
X-Received: by 2002:a17:902:820c:: with SMTP id x12mr78020390pln.216.1563834859258;
        Mon, 22 Jul 2019 15:34:19 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r18sm30597570pfg.77.2019.07.22.15.34.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 15:34:18 -0700 (PDT)
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
Subject: [PATCH 0/3] introduce __put_user_pages(), convert a few call sites
Date:   Mon, 22 Jul 2019 15:34:12 -0700
Message-Id: <20190722223415.13269-1-jhubbard@nvidia.com>
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

As discussed in [1] just now, this adds a more capable variation of
put_user_pages() to the API set, and uses it to simplify both the
main implementation, and (especially) the call sites.

Thanks to Christoph for the simplifying ideas, and Matthew for (again)
recommending an enum in the API. Matthew, I seem to recall you asked
for enums before this, so I'm sorry it took until now for me to add
them. :)

The new __put_user_pages() takes an enum that handles the various
combinations of needing to call set_page_dirty() or
set_page_dirty_lock(), before calling put_user_page().

I'm using the same CC list as in [1], even though IB is no longer
included in the series. That's everyone can see what the end result
turns out to be.

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

[1] https://lore.kernel.org/r/20190722093355.GB29538@lst.de
[2] https://github.com/johnhubbard/linux/tree/gup_dma_core

John Hubbard (3):
  mm/gup: introduce __put_user_pages()
  drivers/gpu/drm/via: convert put_page() to put_user_page*()
  net/xdp: convert put_page() to put_user_page*()

 drivers/gpu/drm/via/via_dmablit.c |  11 +--
 include/linux/mm.h                |  58 +++++++++++-
 mm/gup.c                          | 149 +++++++++++++++---------------
 net/xdp/xdp_umem.c                |   9 +-
 4 files changed, 135 insertions(+), 92 deletions(-)

-- 
2.22.0

