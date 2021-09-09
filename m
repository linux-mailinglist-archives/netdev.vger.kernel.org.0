Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2258540585D
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354278AbhIIN6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:58:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55960 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355114AbhIIN5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 09:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631195775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=FJ3vx9ItWF84RR27z81TE9j4hUoJb+a4RSamUREx5R8=;
        b=dn05rc+PBT7TETFotzbxttrddwrDru9isvwU9Ms1pjh5HYouKcFep9EbXwV6rA34jZf7F1
        mLfhGjLm4cXsWsGsdi850s6GQ/f8U4cjvt2nigXQ0ODQ9JeOZS15zFGjey4g5nGZ38aDNY
        jUI9X75y+AfbzsCiFMZusy/dTphbH0o=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-YFT7OKgTP7qdN-qb-PFvTQ-1; Thu, 09 Sep 2021 09:56:14 -0400
X-MC-Unique: YFT7OKgTP7qdN-qb-PFvTQ-1
Received: by mail-ej1-f72.google.com with SMTP id o7-20020a170906288700b005bb05cb6e25so827155ejd.23
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 06:56:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=FJ3vx9ItWF84RR27z81TE9j4hUoJb+a4RSamUREx5R8=;
        b=SlWQ43yVfb+sIdHB+CLX5PLMtlJb92lwvi2h8QlFJ8gKs4JwcpBoY3ciiBFWYuJCH3
         mCiDxWp+kG7TDVfEKVIjS4HqtIdyvORYXXFuV+LVb4T4uCAU5M28wLnNsyqatD3LXglo
         15WfHVf/UkzSFWlZeMmOBWfw3Tz79fx3YKdhy+nwsGaXEo0BGH+Sdu3rB5Jl9TnYwdiy
         3ODI7VQSlmBOqfsUVTQ2zpC1qOkmBvkiPbvqA1qpheViPuG4t9PSzdu1yalwJ3t9u39e
         eAShAfxAEme2/HBLBpOtA1siklp+UdzoefQ2h2pzgl1p4gUdP/+HIenyKlRNAOqmbt4i
         AfDg==
X-Gm-Message-State: AOAM533S+hWJnjJSByPa+52plRz0LAe/0Y7jF11N5rwurx8e4oOfiIUc
        szeWTp9dc2LN6yGCHz6UQr3jKbG4bB6XiXdaOwMctJBZpaEdNXy04ZIFMvdYcqXAk9pbcudiDt0
        Ic2vbs00beVKLPIfi
X-Received: by 2002:a17:906:12c8:: with SMTP id l8mr3453443ejb.515.1631195772675;
        Thu, 09 Sep 2021 06:56:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4tBPafNVgPmrZd3KYi1ABh5Zl7/eVhQcwR6Yr2RpP9yEYDIYrmgjs2t9Ub19JNtKWg/PAtg==
X-Received: by 2002:a17:906:12c8:: with SMTP id l8mr3453415ejb.515.1631195772487;
        Thu, 09 Sep 2021 06:56:12 -0700 (PDT)
Received: from redhat.com ([2.55.145.189])
        by smtp.gmail.com with ESMTPSA id t19sm987072ejb.115.2021.09.09.06.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 06:56:11 -0700 (PDT)
Date:   Thu, 9 Sep 2021 09:56:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arseny.krasnov@kaspersky.com, caihuoqing@baidu.com,
        elic@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        mgurtovoy@nvidia.com, mst@redhat.com, viresh.kumar@linaro.org,
        will@kernel.org, wsa@kernel.org, xianting.tian@linux.alibaba.com,
        xieyongji@bytedance.com
Subject: [GIT PULL] virtio,vdpa,vhost: features, fixes
Message-ID: <20210909095608-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 7d2a07b769330c34b4deabeed939325c77a7ec2f:

  Linux 5.14 (2021-08-29 15:04:50 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 7bc7f61897b66bef78bb5952e3d1e9f3aaf9ccca:

  Documentation: Add documentation for VDUSE (2021-09-06 07:20:58 -0400)

----------------------------------------------------------------
virtio,vdpa,vhost: features, fixes

vduse driver supporting blk
virtio-vsock support for end of record with SEQPACKET
vdpa: mac and mq support for ifcvf and mlx5
vdpa: management netlink for ifcvf
virtio-i2c, gpio dt bindings

misc fixes, cleanups

NB: when merging this with
b542e383d8c0 ("eventfd: Make signal recursion protection a task bit")
from Linus' tree, replace eventfd_signal_count with
eventfd_signal_allowed, and drop the export of eventfd_wake_count from
("eventfd: Export eventfd_wake_count to modules").

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Arseny Krasnov (6):
      virtio/vsock: rename 'EOR' to 'EOM' bit.
      virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOR' bit.
      vhost/vsock: support MSG_EOR bit processing
      virtio/vsock: support MSG_EOR bit processing
      af_vsock: rename variables in receive loop
      vsock_test: update message bounds test for MSG_EOR

Cai Huoqing (2):
      vhost scsi: Convert to SPDX identifier
      vdpa: Make use of PFN_PHYS/PFN_UP/PFN_DOWN helper macro

Eli Cohen (6):
      vdpa/mlx5: Remove redundant header file inclusion
      vdpa/mlx5: function prototype modifications in preparation to control VQ
      vdpa/mlx5: Decouple virtqueue callback from struct mlx5_vdpa_virtqueue
      vdpa/mlx5: Ensure valid indices are provided
      vdpa/mlx5: Add support for control VQ and MAC setting
      vdpa/mlx5: Add multiqueue support

Max Gurtovoy (1):
      virtio-blk: remove unneeded "likely" statements

Viresh Kumar (5):
      dt-bindings: virtio: Add binding for virtio devices
      dt-bindings: i2c: Add bindings for i2c-virtio
      dt-bindings: gpio: Add bindings for gpio-virtio
      uapi: virtio_ids: Sync ids with specification
      virtio: Bind virtio device to device-tree node

Xianting Tian (1):
      virtio-balloon: Use virtio_find_vqs() helper

Xie Yongji (14):
      vdpa_sim: Use iova_shift() for the size passed to alloc_iova()
      iova: Export alloc_iova_fast() and free_iova_fast()
      eventfd: Export eventfd_wake_count to modules
      file: Export receive_fd() to modules
      vdpa: Fix some coding style issues
      vdpa: Add reset callback in vdpa_config_ops
      vhost-vdpa: Handle the failure of vdpa_reset()
      vhost-iotlb: Add an opaque pointer for vhost IOTLB
      vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
      vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()
      vdpa: Support transferring virtual addressing during DMA mapping
      vduse: Implement an MMU-based software IOTLB
      vduse: Introduce VDUSE - vDPA Device in Userspace
      Documentation: Add documentation for VDUSE

Zhu Lingshan (4):
      vDPA/ifcvf: introduce get_dev_type() which returns virtio dev id
      vDPA/ifcvf: implement management netlink framework for ifcvf
      vDPA/ifcvf: detect and use the onboard number of queues directly
      vDPA/ifcvf: enable multiqueue and control vq

 .../devicetree/bindings/gpio/gpio-virtio.yaml      |   59 +
 .../devicetree/bindings/i2c/i2c-virtio.yaml        |   51 +
 Documentation/devicetree/bindings/virtio/mmio.yaml |    3 +-
 .../devicetree/bindings/virtio/virtio-device.yaml  |   41 +
 Documentation/userspace-api/index.rst              |    1 +
 Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
 Documentation/userspace-api/vduse.rst              |  233 +++
 drivers/block/virtio_blk.c                         |    4 +-
 drivers/iommu/iova.c                               |    2 +
 drivers/vdpa/Kconfig                               |   11 +
 drivers/vdpa/Makefile                              |    1 +
 drivers/vdpa/ifcvf/ifcvf_base.c                    |    8 +-
 drivers/vdpa/ifcvf/ifcvf_base.h                    |   25 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    |  257 ++-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |   26 +-
 drivers/vdpa/mlx5/core/mr.c                        |   81 +-
 drivers/vdpa/mlx5/core/resources.c                 |   35 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  555 ++++++-
 drivers/vdpa/vdpa.c                                |    9 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   29 +-
 drivers/vdpa/vdpa_user/Makefile                    |    5 +
 drivers/vdpa/vdpa_user/iova_domain.c               |  545 +++++++
 drivers/vdpa/vdpa_user/iova_domain.h               |   73 +
 drivers/vdpa/vdpa_user/vduse_dev.c                 | 1641 ++++++++++++++++++++
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |   17 +-
 drivers/vhost/iotlb.c                              |   20 +-
 drivers/vhost/scsi.c                               |   14 +-
 drivers/vhost/vdpa.c                               |  188 ++-
 drivers/vhost/vsock.c                              |   28 +-
 drivers/virtio/virtio.c                            |   57 +-
 drivers/virtio/virtio_balloon.c                    |    4 +-
 fs/eventfd.c                                       |    1 +
 fs/file.c                                          |    6 +
 include/linux/file.h                               |    7 +-
 include/linux/vdpa.h                               |   62 +-
 include/linux/vhost_iotlb.h                        |    3 +
 include/uapi/linux/vduse.h                         |  306 ++++
 include/uapi/linux/virtio_ids.h                    |   12 +
 include/uapi/linux/virtio_vsock.h                  |    3 +-
 net/vmw_vsock/af_vsock.c                           |   10 +-
 net/vmw_vsock/virtio_transport_common.c            |   23 +-
 tools/testing/vsock/vsock_test.c                   |    8 +-
 42 files changed, 4136 insertions(+), 329 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-virtio.yaml
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-virtio.yaml
 create mode 100644 Documentation/devicetree/bindings/virtio/virtio-device.yaml
 create mode 100644 Documentation/userspace-api/vduse.rst
 create mode 100644 drivers/vdpa/vdpa_user/Makefile
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
 create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
 create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
 create mode 100644 include/uapi/linux/vduse.h

