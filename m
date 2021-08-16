Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67D03ECDC5
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 06:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhHPEvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 00:51:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50612 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229550AbhHPEvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 00:51:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629089460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=rZs3mSB34nogWH2zmgxUCeVHfLL1OdFQlCndY96/B/0=;
        b=LUdJlzPTp7GpIpDcHcYdiVGG1vqrkDSyfmKonYW5Wjx5ygVgiaqEUGCY1Mdz7kpnrtjg5a
        9MlhlqvtYe1oDr5804k1S/TOrUdvupUhBFlPOXHwdsr8TMTSbEoqMiFTHiRiM8CttCc05B
        EOlzHQz48nDwabNx9UjhdngNcKrzjp4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-QVQjq6a6ONKwODau9SYckw-1; Mon, 16 Aug 2021 00:50:59 -0400
X-MC-Unique: QVQjq6a6ONKwODau9SYckw-1
Received: by mail-wm1-f69.google.com with SMTP id b196-20020a1c80cd0000b02902e677003785so7378230wmd.7
        for <netdev@vger.kernel.org>; Sun, 15 Aug 2021 21:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=rZs3mSB34nogWH2zmgxUCeVHfLL1OdFQlCndY96/B/0=;
        b=VC/FCOD0XB0FeYGnaLwGETF3l3ByRWJ72UwJuq8AakaAOtEqTph0PSLn/DCd4+BM0Y
         Hu98lXBs0WmChE8h5iGf2VzbNu2irDTV1Rqqia1vmlYGIh4hb9Imk+VoehMdEPqpUGCF
         uGTBmJq6G3NoMSkuRKEykB2resXyrGPVNUfN0TY6n2HpJiTp++KHSNNbyoxdtlx9srZp
         ZIXPCxdAz1stiROwWXsmq7Xf8szBwVE6a6RkwtYC+wfYFFsFAqB7qodyt0OztRJ1DN3w
         uNF79my5+bVrc9aEyPjHFMBvsWe0StuoKvs1esk+bjuLBNTCtqg/HXXJC3UlzndpyyGe
         AtMg==
X-Gm-Message-State: AOAM532e2xdOgE//S8n3LlmRajtpqoQ2macFwxArY5Vqth1tRIQ/epBf
        f4dty52IV4wXh4YjeHnLBvEW0+Nx99REDJuLHhwDGfoRYatG/divxcYwBV5ZnDaiF2wghmHQvmI
        bvCgJQCwMUxRogePr
X-Received: by 2002:a5d:4602:: with SMTP id t2mr1228066wrq.378.1629089458121;
        Sun, 15 Aug 2021 21:50:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjBjilHWhHeVXJ212gHSVnkj7N49KZUrKpxQq7yztn932X8qS+NGWF0om+LCe2aMv5wZThUw==
X-Received: by 2002:a5d:4602:: with SMTP id t2mr1228046wrq.378.1629089457942;
        Sun, 15 Aug 2021 21:50:57 -0700 (PDT)
Received: from redhat.com ([2.55.8.239])
        by smtp.gmail.com with ESMTPSA id m10sm12398087wro.63.2021.08.15.21.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 21:50:57 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:50:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, elic@nvidia.com, jasowang@redhat.com,
        mst@redhat.com, neeraju@codeaurora.org, parav@nvidia.com,
        vincent.whitchurch@axis.com, xieyongji@bytedance.com
Subject: [GIT PULL] virtio,vhost,vdpa: bugfixes
Message-ID: <20210816005054-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 36a21d51725af2ce0700c6ebcb6b9594aac658a6:

  Linux 5.14-rc5 (2021-08-08 13:49:31 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 879753c816dbbdb2a9a395aa4448d29feee92d1a:

  vdpa/mlx5: Fix queue type selection logic (2021-08-11 06:44:43 -0400)

----------------------------------------------------------------
virtio,vhost,vdpa: bugfixes

Fixes in virtio,vhost,vdpa drivers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eli Cohen (2):
      vdpa/mlx5: Avoid destroying MR on empty iotlb
      vdpa/mlx5: Fix queue type selection logic

Michael S. Tsirkin (3):
      vringh: pull in spinlock header
      virtio_ring: pull in spinlock header
      tools/virtio: fix build

Neeraj Upadhyay (1):
      vringh: Use wiov->used to check for read/write desc order

Parav Pandit (4):
      virtio: Improve vq->broken access to avoid any compiler optimization
      virtio: Keep vring_del_virtqueue() mirror of VQ create
      virtio: Protect vqs list access
      virtio_pci: Support surprise removal of virtio pci device

Vincent Whitchurch (1):
      virtio_vdpa: reject invalid vq indices

Xie Yongji (7):
      vhost-vdpa: Fix integer overflow in vhost_vdpa_process_iotlb_update()
      vhost: Fix the calculation in vhost_overflow()
      vdpa_sim: Fix return value check for vdpa_alloc_device()
      vp_vdpa: Fix return value check for vdpa_alloc_device()
      vDPA/ifcvf: Fix return value check for vdpa_alloc_device()
      vdpa: Add documentation for vdpa_alloc_device() macro
      virtio-blk: Add validation for block size in config space

 drivers/block/virtio_blk.c         | 39 ++++++++++++++++++++++----
 drivers/vdpa/ifcvf/ifcvf_main.c    |  4 +--
 drivers/vdpa/mlx5/core/mr.c        |  9 ------
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 14 +++++++---
 drivers/vdpa/vdpa_sim/vdpa_sim.c   |  4 ++-
 drivers/vdpa/virtio_pci/vp_vdpa.c  |  4 +--
 drivers/vhost/vdpa.c               |  3 +-
 drivers/vhost/vhost.c              | 10 +++++--
 drivers/vhost/vringh.c             |  2 +-
 drivers/virtio/virtio.c            |  1 +
 drivers/virtio/virtio_pci_common.c |  7 +++++
 drivers/virtio/virtio_ring.c       | 18 ++++++++++--
 drivers/virtio/virtio_vdpa.c       |  3 ++
 include/linux/mlx5/mlx5_ifc_vdpa.h | 10 ++++---
 include/linux/vdpa.h               | 11 ++++++++
 include/linux/virtio.h             |  1 +
 include/linux/vringh.h             |  1 +
 tools/virtio/Makefile              |  3 +-
 tools/virtio/linux/spinlock.h      | 56 ++++++++++++++++++++++++++++++++++++++
 tools/virtio/linux/virtio.h        |  2 ++
 20 files changed, 166 insertions(+), 36 deletions(-)
 create mode 100644 tools/virtio/linux/spinlock.h

