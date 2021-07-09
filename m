Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0903C22B9
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 13:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhGILXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 07:23:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230091AbhGILXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 07:23:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625829633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=hKiczKxzAPI29UJiV3gO14mPIUiI0XC1F52rfsccKc4=;
        b=IqW7gtrQChaxTvuJvquiAlEok1N5aQ3WLxabKnW4yIsccVAY2pwhsdja1+3B7lXUoBvRZP
        O9UPhhaJV7d8iStAEybQDrLHjEaUMNG8uKwdtSyURHqYnFQVSED6bos1dwC4LASl05fYoy
        cTISw/tRr5JBOys5D9cmpnxflKr4QSw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-QHlrJBAfPvSIle4gEf4V3w-1; Fri, 09 Jul 2021 07:20:03 -0400
X-MC-Unique: QHlrJBAfPvSIle4gEf4V3w-1
Received: by mail-ed1-f71.google.com with SMTP id w1-20020a0564022681b0290394cedd8a6aso5054466edd.14
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 04:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=hKiczKxzAPI29UJiV3gO14mPIUiI0XC1F52rfsccKc4=;
        b=YBjVoMsnJIiORz8KkrVEBttVJeCBgi+nqvqdsrjEkGefvm2YY/ZXV5NaXZSlRB0VXQ
         EXhUADGI5zYjCLb8Dv5ZK4q69gBp+ukNkr2WZCgCbSrbsuHIl9AgNxOmujF2BDYzPeeV
         sKnpRWe6p1aybBAAXxITyhkWXkS8hBNRXgrX/r+AFLxNfLRWEA5s/lWFS7QcR9xMD6Aj
         4GtdITzABLDyI7PF78cnTDMYbGlyZa+iLbE2rmCILo6JTCSh/CzK9RSu7FRe6DucMrBY
         U0gm3OTIIaaqyIhHxU+wTlCGWSJThdhAsX3E0e9NtilZYdwd+EE4eyENXNMCC9RCNT4L
         /S1A==
X-Gm-Message-State: AOAM531hMmd+zyzT2WLpg24Tyn2CAIqVY37B1hZzCwBWJVYgI1f5DNbG
        BF2VOp5YduG1wB1oNXTM3L4oq98FhlBQn42tWx/YYWDUOA2lZxZEAEtSpxK9YXxgJaP74Qr0wV6
        qMrNMyfo+xJqSZHUQ
X-Received: by 2002:a17:907:3d8e:: with SMTP id he14mr37164181ejc.374.1625829602230;
        Fri, 09 Jul 2021 04:20:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtc4xWGn+OHTWUqQ2ZN7QMBLRjQS+tqvvgK+bB1PKTcn/km2lYNbAnqdYoxRG3K4UGhWeOuQ==
X-Received: by 2002:a17:907:3d8e:: with SMTP id he14mr37164137ejc.374.1625829601998;
        Fri, 09 Jul 2021 04:20:01 -0700 (PDT)
Received: from redhat.com ([2.55.150.102])
        by smtp.gmail.com with ESMTPSA id s4sm2830932edu.49.2021.07.09.04.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 04:20:01 -0700 (PDT)
Date:   Fri, 9 Jul 2021 07:19:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com, dan.carpenter@oracle.com,
        david@redhat.com, elic@nvidia.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, lkp@intel.com, michael.christie@oracle.com,
        mst@redhat.com, sgarzare@redhat.com, sohaib.amhmd@gmail.com,
        stefanha@redhat.com, wanjiabing@vivo.com, xieyongji@bytedance.com,
        yang.lee@linux.alibaba.com, zhangshaokun@hisilicon.com
Subject: [GIT PULL] virtio,vhost,vdpa: features, fixes
Message-ID: <20210709071952-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 3dbdb38e286903ec220aaf1fb29a8d94297da246:

  Merge branch 'for-5.14' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup (2021-07-01 17:22:14 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to db7b337709a15d33cc5e901d2ee35d3bb3e42b2f:

  virtio-mem: prioritize unplug from ZONE_MOVABLE in Big Block Mode (2021-07-08 07:49:02 -0400)

----------------------------------------------------------------
virtio,vhost,vdpa: features, fixes

Doorbell remapping for ifcvf, mlx5.
virtio_vdpa support for mlx5.
Validate device input in several drivers (for SEV and friends).
ZONE_MOVABLE aware handling in virtio-mem.
Misc fixes, cleanups.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
David Hildenbrand (7):
      virtio-mem: don't read big block size in Sub Block Mode
      virtio-mem: use page_zonenum() in virtio_mem_fake_offline()
      virtio-mem: simplify high-level plug handling in Sub Block Mode
      virtio-mem: simplify high-level unplug handling in Sub Block Mode
      virtio-mem: prioritize unplug from ZONE_MOVABLE in Sub Block Mode
      virtio-mem: simplify high-level unplug handling in Big Block Mode
      virtio-mem: prioritize unplug from ZONE_MOVABLE in Big Block Mode

Eli Cohen (8):
      vdpa/mlx5: Fix umem sizes assignments on VQ create
      vdpa/mlx5: Fix possible failure in umem size calculation
      vdpa/mlx5: Support creating resources with uid == 0
      vdp/mlx5: Fix setting the correct dma_device
      vdpa/mlx5: Add support for running with virtio_vdpa
      vdpa/mlx5: Add support for doorbell bypassing
      vdpa/mlx5: Clear vq ready indication upon device reset
      virtio/vdpa: clear the virtqueue state during probe

Jason Wang (11):
      vp_vdpa: correct the return value when fail to map notification
      virtio-ring: maintain next in extra state for packed virtqueue
      virtio_ring: rename vring_desc_extra_packed
      virtio-ring: factor out desc_extra allocation
      virtio_ring: secure handling of mapping errors
      virtio_ring: introduce virtqueue_desc_add_split()
      virtio: use err label in __vring_new_virtqueue()
      virtio-ring: store DMA metadata in desc_extra for split virtqueue
      vdpa: support packed virtqueue for set/get_vq_state()
      virtio-pci library: introduce vp_modern_get_driver_features()
      vp_vdpa: allow set vq state to initial state after reset

Michael S. Tsirkin (4):
      virtio_net: move tx vq operation under tx queue lock
      virtio_net: move txq wakeups under tx q lock
      virtio: fix up virtio_disable_cb
      virtio_net: disable cb aggressively

Mike Christie (5):
      vhost: remove work arg from vhost_work_flush
      vhost-scsi: remove extra flushes
      vhost-scsi: reduce flushes during endpoint clearing
      vhost: fix poll coding style
      vhost: fix up vhost_work coding style

Shaokun Zhang (1):
      vhost: Remove the repeated declaration

Sohaib (1):
      virtio_blk: cleanups: remove check obsoleted by CONFIG_LBDAF removal

Stefan Hajnoczi (1):
      virtio-blk: limit seg_max to a safe value

Stefano Garzarella (1):
      vhost-iotlb: fix vhost_iotlb_del_range() documentation

Wan Jiabing (1):
      vdpa_sim_blk: remove duplicate include of linux/blkdev.h

Xie Yongji (3):
      virtio-blk: Fix memory leak among suspend/resume procedure
      virtio_net: Fix error handling in virtnet_restore()
      virtio_console: Assure used length from device is limited

Yang Li (1):
      virtio_ring: Fix kernel-doc

Zhu Lingshan (4):
      vDPA/ifcvf: record virtio notify base
      vDPA/ifcvf: implement doorbell mapping for ifcvf
      virtio: update virtio id table, add transitional ids
      vDPA/ifcvf: reuse pre-defined macros for device ids and vendor ids

 drivers/block/virtio_blk.c             |  17 +-
 drivers/char/virtio_console.c          |   4 +-
 drivers/net/virtio_net.c               |  53 +++--
 drivers/vdpa/ifcvf/ifcvf_base.c        |   4 +
 drivers/vdpa/ifcvf/ifcvf_base.h        |  14 +-
 drivers/vdpa/ifcvf/ifcvf_main.c        |  43 ++--
 drivers/vdpa/mlx5/core/mlx5_vdpa.h     |   2 +
 drivers/vdpa/mlx5/core/mr.c            |  97 ++++++---
 drivers/vdpa/mlx5/core/resources.c     |   7 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c      |  67 +++++--
 drivers/vdpa/vdpa_sim/vdpa_sim.c       |   4 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c   |   1 -
 drivers/vdpa/virtio_pci/vp_vdpa.c      |  43 +++-
 drivers/vhost/iotlb.c                  |   2 +-
 drivers/vhost/scsi.c                   |  21 +-
 drivers/vhost/vdpa.c                   |   4 +-
 drivers/vhost/vhost.c                  |   8 +-
 drivers/vhost/vhost.h                  |  21 +-
 drivers/vhost/vsock.c                  |   2 +-
 drivers/virtio/virtio_mem.c            | 346 +++++++++++++++++----------------
 drivers/virtio/virtio_pci_modern_dev.c |  21 ++
 drivers/virtio/virtio_ring.c           | 229 ++++++++++++++++------
 drivers/virtio/virtio_vdpa.c           |  15 ++
 include/linux/mlx5/mlx5_ifc.h          |   4 +-
 include/linux/vdpa.h                   |  25 ++-
 include/linux/virtio_pci_modern.h      |   1 +
 include/uapi/linux/virtio_ids.h        |  12 ++
 27 files changed, 713 insertions(+), 354 deletions(-)

