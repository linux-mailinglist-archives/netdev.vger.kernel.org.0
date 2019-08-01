Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC8D27E6D3
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 01:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732277AbfHAXrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 19:47:41 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45998 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfHAXrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 19:47:40 -0400
Received: by mail-pf1-f194.google.com with SMTP id r1so34951135pfq.12;
        Thu, 01 Aug 2019 16:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vg4QzQ/7F17W/rUghukJhcqs5s9RAye4AZfxR//QV0o=;
        b=VXApa2bKtU/+qjnj54No4w9jeBNCs/2ouRrzJwhVcI9bqY8FfV+lWiNYwbsicvbOdl
         gMkx/W/bNkCq+wNmaOVEypvcnQYCBpMtS63geb51KtbNv6tA5o8AavZ/OkslLikGEpN7
         TZ6jcPk7YupGsAob95DLycEHEidCNCO3vJMcSsJfyWJdg5s82DlsF0VMt6NkiZ36SD/y
         ewsev+xHhO4YL7/M/T3jKGSqWEQRwKTVpHkem9aFrBpI2POpX89SLC42HKEqRQxV6KlB
         XyXV7Rr5gxVbGs2rlTCzOJkRGFi8/OkuUi2i3rMP7bEQkC5KSNXB3wChRcRIy1jl586G
         iecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vg4QzQ/7F17W/rUghukJhcqs5s9RAye4AZfxR//QV0o=;
        b=N1Lb8s5HpfyygsQOIpG9sj+ZBYy1wLqn6ewXAb6owpCvwBymhSEcUpPOh/UMhKFYMw
         wFoxmKOyDV7Af+2JyEiWEc/fMZDYs1PJL5wuhXJO0qIsQqKp7zyptCn1+vNR6kGZ089R
         y8wse0OY5zEfuPqXy8nO33Aq7mFqn+TdMXM76RJ4HsXrIsNOWh8Yg51njwpIJue/wI9k
         LCRVD8/qBsvKvKhpNlPpoHq4ROUPRzQT4luxp8VbpGbyQmVbh4mYstsfEPG0ifr2t+u2
         0IkKOcYZa+DNPZPmA4IlqFUyJJT9zhRMXfkcqei9hrbRzdwD0M2HZ/kzuko+sa8pFh1i
         6J7Q==
X-Gm-Message-State: APjAAAUadnpEirGaDcWbRXfq3TK+BrdjFpfViCN+4WwAw13G3P0Dcsom
        DjLGlvnnmqxuCPH+gH4sUFhj/fjP
X-Google-Smtp-Source: APXvYqwHoHG6JQ3jRjRVySMONqToxLBPphS71bd0Tygq+HVgAHEylGaHC3u+H2i9mxt915ePZzuW3w==
X-Received: by 2002:a63:e5a:: with SMTP id 26mr117179570pgo.3.1564703259868;
        Thu, 01 Aug 2019 16:47:39 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id q7sm79090792pff.2.2019.08.01.16.47.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 16:47:38 -0700 (PDT)
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
Subject: [PATCH v5 0/3]  mm/gup: add make_dirty arg to put_user_pages_dirty_lock()
Date:   Thu,  1 Aug 2019 16:47:32 -0700
Message-Id: <20190801234735.2149-1-jhubbard@nvidia.com>
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
 drivers/infiniband/sw/siw/siw_mem.c        |  18 +---
 include/linux/mm.h                         |   5 +-
 mm/gup.c                                   | 115 +++++++++------------
 net/xdp/xdp_umem.c                         |   9 +-
 9 files changed, 63 insertions(+), 122 deletions(-)

-- 
2.22.0

