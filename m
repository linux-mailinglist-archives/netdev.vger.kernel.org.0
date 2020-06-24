Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFC2206FB7
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388929AbgFXJIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:08:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41597 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387614AbgFXJIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 05:08:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592989687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VQoY+UTRP06W0gqpd2Juj7Hxof1/RYyQfXylaOH8G2E=;
        b=F8NLBw5tN6xoouLxkIAmkOlqr/gTHC94CEHbImfOM3BtLo8y9a30kna/RJLZh8V9D0PoGk
        YTB4D8EuRUl/NyUSJIDMmMNSXf0tXjixbnYl741kCOjUhW1u3BjcyhOJjI0lvRvJBkm8oB
        zFnUGAGN/X4oSy2Lfb5IiFN/nHmLWXM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-iZxZwoYGPNKeFyAaFY201A-1; Wed, 24 Jun 2020 05:08:05 -0400
X-MC-Unique: iZxZwoYGPNKeFyAaFY201A-1
Received: by mail-wm1-f70.google.com with SMTP id t18so2109842wmj.5
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 02:08:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=VQoY+UTRP06W0gqpd2Juj7Hxof1/RYyQfXylaOH8G2E=;
        b=WzkXsqJJNSPE68PGrczuJQmPSH78i8owzZZ6PThGNoIbKv5n5N115yP1golkG2CLAG
         RaU/xkZuHJnT1mrn5B7v75UPlTSnYc8xSekNwQi9xXbNw4j0qywIxd5ZESWED/n2eP1i
         4OJUGhSe3mPbWFSe0/jUKJ/yUR9Fcq0/10KrMkni2lsj3IY7DX0H1gVc07yi5l+YFIji
         WWJz3CK6ounzyVp7zAJjL8BVy3fB42T+Lo9pbwSFhAfY2vvpoiCyuVfUUDmBpMsfvFpV
         2Q+F55SSff3U0ll1X+302Mj280Ge/aB48GQoP4NJTKXeSvh+uU4FUt86gglfVLDeR5VM
         Cgxg==
X-Gm-Message-State: AOAM530x55y9OWYhW7PMo2EUFcyAi7lIsFJf0RrZ1HtoHJ2MBfO73kOR
        xtR+uS8b1ssjPgOyJmOQZQlD+0uVMWDVptdf29FwXmi18Bu8Je+LUdBrOX4FyKLizFqkByJ+RM2
        IZHglo5RGYg7YxbE0
X-Received: by 2002:a7b:cb4c:: with SMTP id v12mr28392156wmj.43.1592989684867;
        Wed, 24 Jun 2020 02:08:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbEhEN966Il4umYMTMjRrrueqoGcM5lQiV/3BTRS9Bm+7+N7X0YZSdV011xkOJs+ZR2fNnFw==
X-Received: by 2002:a7b:cb4c:: with SMTP id v12mr28392130wmj.43.1592989684670;
        Wed, 24 Jun 2020 02:08:04 -0700 (PDT)
Received: from redhat.com ([82.166.20.53])
        by smtp.gmail.com with ESMTPSA id e5sm26714788wrw.19.2020.06.24.02.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 02:08:03 -0700 (PDT)
Date:   Wed, 24 Jun 2020 05:08:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, david@redhat.com, eperezma@redhat.com,
        jasowang@redhat.com, mst@redhat.com, pankaj.gupta.linux@gmail.com,
        teawaterz@linux.alibaba.com
Subject: [GIT PULL] virtio: fixes, tests
Message-ID: <20200624050801-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 48778464bb7d346b47157d21ffde2af6b2d39110:

  Linux 5.8-rc2 (2020-06-21 15:45:29 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to cb91909e48a4809261ef4e967464e2009b214f06:

  tools/virtio: Use tools/include/list.h instead of stubs (2020-06-22 12:34:22 -0400)

----------------------------------------------------------------
virtio: fixes, tests

Fixes all over the place.

This includes a couple of tests that I would normally defer,
but since they have already been helpful in catching some bugs,
don't build for any users at all, and having them
upstream makes life easier for everyone, I think it's
ok even at this late stage.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Dan Carpenter (2):
      vhost_vdpa: Fix potential underflow in vhost_vdpa_mmap()
      virtio-mem: silence a static checker warning

David Hildenbrand (1):
      virtio-mem: add memory via add_memory_driver_managed()

Eugenio Pérez (7):
      tools/virtio: Add --batch option
      tools/virtio: Add --batch=random option
      tools/virtio: Add --reset
      tools/virtio: Use __vring_new_virtqueue in virtio_test.c
      tools/virtio: Extract virtqueue initialization in vq_reset
      tools/virtio: Reset index in virtio_test --reset.
      tools/virtio: Use tools/include/list.h instead of stubs

Jason Wang (1):
      vdpa: fix typos in the comments for __vdpa_alloc_device()

 drivers/vdpa/vdpa.c         |   2 +-
 drivers/vhost/test.c        |  57 ++++++++++++++++++
 drivers/vhost/test.h        |   1 +
 drivers/vhost/vdpa.c        |   2 +-
 drivers/virtio/virtio_mem.c |  27 +++++++--
 tools/virtio/linux/kernel.h |   7 +--
 tools/virtio/linux/virtio.h |   5 +-
 tools/virtio/virtio_test.c  | 139 +++++++++++++++++++++++++++++++++++++-------
 tools/virtio/vringh_test.c  |   2 +
 9 files changed, 207 insertions(+), 35 deletions(-)

