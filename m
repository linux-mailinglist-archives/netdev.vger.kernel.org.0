Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456EE241898
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 10:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgHKI41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 04:56:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50272 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728397AbgHKI40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 04:56:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597136183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=d88xcVVVwUczUwSPBmg1oFZLtRXHohyyivhvTCzox5c=;
        b=ZfVtKnrQy2+ll3udE0z7QQEMpTxd+3kCFg6tYlIVwODRNFzv41YlFM1QhKh5LGaKeTlxUr
        ChU1DgfQVncsFdzArq7T2nopNrIvHOZxf29VsqZbEIGe6SvVc+99jW6mqk560hXo6sKGBI
        rDRm1/ar03FyecR5sD8HEzOTafw4hfU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-LQOxbywtMEaYCtzUPF-90Q-1; Tue, 11 Aug 2020 04:56:21 -0400
X-MC-Unique: LQOxbywtMEaYCtzUPF-90Q-1
Received: by mail-wr1-f72.google.com with SMTP id t12so5348891wrp.0
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 01:56:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=d88xcVVVwUczUwSPBmg1oFZLtRXHohyyivhvTCzox5c=;
        b=QsUnBekWcSolJ0qb20cELv4ETfocMvGBpdVL9ap4/QZT5K2Eukg5Ye9m9WrGERbjuj
         HakIFo6kHEvVMNJBXtVMMJg8Mjd9sMq9ElSSU1P8yE8ROWwBTE+uTvWieLLS5FPQiR2A
         OEvildtktNT6R/cDOnTRzyaNAFxMriit35Bd/OkUXlAfag/DzXxgI5S8sbypO8DuVFuN
         u6618/IizRBsacPvp50autlkwUVjMb8umZk9ErY00iVcbWJwzr3snckmz3w9wQQF69b9
         lnlcVd07QhA2LOC3avlW25Pfm4CNnMGXAo6/1Ny89Quy0uTEJZDw7bKQrOvBltH1chxK
         7F7A==
X-Gm-Message-State: AOAM532/xfj2/vtAmRQqCR+R5z2UXfD8ehSW4J8tzrVpKO86NcXmzbeW
        gblw89+V1Cm4k82wRE99hprxhxhfOEViyXNhWehbwnprUicS70BX3df/cooU1kKyP9u4ixeGgdW
        S10WXSfStrHUcfb9+
X-Received: by 2002:adf:f248:: with SMTP id b8mr30092880wrp.247.1597136180009;
        Tue, 11 Aug 2020 01:56:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytzwO8E3CNR4SmeuTaD5pfM/K8artOAdX7C77z9smbpOM/a84oJwE9y6glNyYTcgPnJ5upKw==
X-Received: by 2002:adf:f248:: with SMTP id b8mr30092826wrp.247.1597136179687;
        Tue, 11 Aug 2020 01:56:19 -0700 (PDT)
Received: from redhat.com (bzq-79-180-0-181.red.bezeqint.net. [79.180.0.181])
        by smtp.gmail.com with ESMTPSA id c4sm25337308wrt.41.2020.08.11.01.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 01:56:18 -0700 (PDT)
Date:   Tue, 11 Aug 2020 04:56:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.dewar@gmx.co.uk, andy.shevchenko@gmail.com, cohuck@redhat.com,
        colin.king@canonical.com, dan.carpenter@oracle.com,
        david@redhat.com, elic@nvidia.com, eli@mellanox.com,
        gustavoars@kernel.org, jasowang@redhat.com, leonro@mellanox.com,
        liao.pingfang@zte.com.cn, lingshan.zhu@intel.com, lkp@intel.com,
        lulu@redhat.com, maorg@mellanox.com, maxg@mellanox.com,
        meirl@mellanox.com, michaelgur@mellanox.com, mst@redhat.com,
        parav@mellanox.com, rong.a.chen@intel.com, saeedm@mellanox.com,
        stable@vger.kernel.org, tariqt@mellanox.com, vgoyal@redhat.com,
        wang.yi59@zte.com.cn, wenan.mao@linux.alibaba.com
Subject: [GIT PULL] virtio: features, fixes
Message-ID: <20200811045613-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OK, some patches in the series add buggy code which is then fixed by
follow-up patches, but none of the bugs fixed are severe regressions on
common configs (e.g. compiler warnings, lockdep/rt errors, or bugs in
new drivers). So I thought it's more important to preserve the credit
for the fixes.

I had to pull 5 patches from git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux mlx5-next
to get the mlx5 things to work, this seems to be how mellanox guys are
always managing things, and they told me they are ok with it.

The following changes since commit bcf876870b95592b52519ed4aafcf9d95999bc9c:

  Linux 5.8 (2020-08-02 14:21:45 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 8a7c3213db068135e816a6a517157de6443290d6:

  vdpa/mlx5: fix up endian-ness for mtu (2020-08-10 10:38:55 -0400)

----------------------------------------------------------------
virtio: fixes, features

IRQ bypass support for vdpa and IFC
MLX5 vdpa driver
Endian-ness fixes for virtio drivers
Misc other fixes

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alex Dewar (1):
      vdpa/mlx5: Fix uninitialised variable in core/mr.c

Colin Ian King (1):
      vdpa/mlx5: fix memory allocation failure checks

Dan Carpenter (2):
      vdpa/mlx5: Fix pointer math in mlx5_vdpa_get_config()
      vdpa: Fix pointer math bug in vdpasim_get_config()

Eli Cohen (9):
      net/mlx5: Support setting access rights of dma addresses
      net/mlx5: Add VDPA interface type to supported enumerations
      net/mlx5: Add interface changes required for VDPA
      net/vdpa: Use struct for set/get vq state
      vdpa: Modify get_vq_state() to return error code
      vdpa/mlx5: Add hardware descriptive header file
      vdpa/mlx5: Add support library for mlx5 VDPA implementation
      vdpa/mlx5: Add shared memory registration code
      vdpa/mlx5: Add VDPA driver for supported mlx5 devices

Gustavo A. R. Silva (1):
      vhost: Use flex_array_size() helper in copy_from_user()

Jason Wang (6):
      vhost: vdpa: remove per device feature whitelist
      vhost-vdpa: refine ioctl pre-processing
      vhost: generialize backend features setting/getting
      vhost-vdpa: support get/set backend features
      vhost-vdpa: support IOTLB batching hints
      vdpasim: support batch updating

Liao Pingfang (1):
      virtio_pci_modern: Fix the comment of virtio_pci_find_capability()

Mao Wenan (1):
      virtio_ring: Avoid loop when vq is broken in virtqueue_poll

Maor Gottlieb (2):
      net/mlx5: Export resource dump interface
      net/mlx5: Add support in query QP, CQ and MKEY segments

Max Gurtovoy (2):
      vdpasim: protect concurrent access to iommu iotlb
      vdpa: remove hard coded virtq num

Meir Lichtinger (1):
      RDMA/mlx5: ConnectX-7 new capabilities to set relaxed ordering by UMR

Michael Guralnik (2):
      net/mlx5: Enable QP number request when creating IPoIB underlay QP
      net/mlx5: Enable count action for rules with allow action

Michael S. Tsirkin (44):
      virtio: VIRTIO_F_IOMMU_PLATFORM -> VIRTIO_F_ACCESS_PLATFORM
      virtio: virtio_has_iommu_quirk -> virtio_has_dma_quirk
      virtio_balloon: fix sparse warning
      virtio_ring: sparse warning fixup
      virtio: allow __virtioXX, __leXX in config space
      virtio_9p: correct tags for config space fields
      virtio_balloon: correct tags for config space fields
      virtio_blk: correct tags for config space fields
      virtio_console: correct tags for config space fields
      virtio_crypto: correct tags for config space fields
      virtio_fs: correct tags for config space fields
      virtio_gpu: correct tags for config space fields
      virtio_input: correct tags for config space fields
      virtio_iommu: correct tags for config space fields
      virtio_mem: correct tags for config space fields
      virtio_net: correct tags for config space fields
      virtio_pmem: correct tags for config space fields
      virtio_scsi: correct tags for config space fields
      virtio_config: disallow native type fields
      mlxbf-tmfifo: sparse tags for config access
      vdpa: make sure set_features is invoked for legacy
      vhost/vdpa: switch to new helpers
      virtio_vdpa: legacy features handling
      vdpa_sim: fix endian-ness of config space
      virtio_config: cread/write cleanup
      virtio_config: rewrite using _Generic
      virtio_config: disallow native type fields (again)
      virtio_config: LE config space accessors
      virtio_caif: correct tags for config space fields
      virtio_config: add virtio_cread_le_feature
      virtio_balloon: use LE config space accesses
      virtio_input: convert to LE accessors
      virtio_fs: convert to LE accessors
      virtio_crypto: convert to LE accessors
      virtio_pmem: convert to LE accessors
      drm/virtio: convert to LE accessors
      virtio_mem: convert to LE accessors
      virtio-iommu: convert to LE accessors
      virtio_config: drop LE option from config space
      virtio_net: use LE accessors for speed/duplex
      Merge branch 'mlx5-next' of git://git.kernel.org/.../mellanox/linux into HEAD
      virtio_config: fix up warnings on parisc
      vdpa_sim: init iommu lock
      vdpa/mlx5: fix up endian-ness for mtu

Parav Pandit (2):
      net/mlx5: Avoid RDMA file inclusion in core driver
      net/mlx5: Avoid eswitch header inclusion in fs core layer

Tariq Toukan (1):
      net/mlx5: kTLS, Improve TLS params layout structures

Zhu Lingshan (7):
      vhost: introduce vhost_vring_call
      kvm: detect assigned device via irqbypass manager
      vDPA: add get_vq_irq() in vdpa_config_ops
      vhost_vdpa: implement IRQ offloading in vhost_vdpa
      ifcvf: implement vdpa_config_ops.get_vq_irq()
      irqbypass: do not start cons/prod when failed connect
      vDPA: dont change vq irq after DRIVER_OK

 arch/um/drivers/virtio_uml.c                       |    2 +-
 arch/x86/kvm/x86.c                                 |   12 +-
 drivers/crypto/virtio/virtio_crypto_core.c         |   46 +-
 drivers/gpu/drm/virtio/virtgpu_kms.c               |   16 +-
 drivers/gpu/drm/virtio/virtgpu_object.c            |    2 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |    4 +-
 drivers/iommu/virtio-iommu.c                       |   34 +-
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c    |   11 +-
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    |    6 +
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.h    |   33 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |    2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |    2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   14 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   10 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   10 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |    7 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    3 +
 drivers/net/virtio_net.c                           |    9 +-
 drivers/nvdimm/virtio_pmem.c                       |    4 +-
 drivers/platform/mellanox/mlxbf-tmfifo.c           |   13 +-
 drivers/scsi/virtio_scsi.c                         |    4 +-
 drivers/vdpa/Kconfig                               |   19 +
 drivers/vdpa/Makefile                              |    1 +
 drivers/vdpa/ifcvf/ifcvf_base.c                    |    4 +-
 drivers/vdpa/ifcvf/ifcvf_base.h                    |    6 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    |   31 +-
 drivers/vdpa/mlx5/Makefile                         |    4 +
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |   91 +
 drivers/vdpa/mlx5/core/mlx5_vdpa_ifc.h             |  168 ++
 drivers/vdpa/mlx5/core/mr.c                        |  486 +++++
 drivers/vdpa/mlx5/core/resources.c                 |  284 +++
 drivers/vdpa/mlx5/net/main.c                       |   76 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  | 1974 ++++++++++++++++++++
 drivers/vdpa/mlx5/net/mlx5_vnet.h                  |   24 +
 drivers/vdpa/vdpa.c                                |    4 +
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |  124 +-
 drivers/vhost/Kconfig                              |    1 +
 drivers/vhost/net.c                                |   22 +-
 drivers/vhost/vdpa.c                               |  183 +-
 drivers/vhost/vhost.c                              |   39 +-
 drivers/vhost/vhost.h                              |   11 +-
 drivers/virtio/virtio_balloon.c                    |   30 +-
 drivers/virtio/virtio_input.c                      |   32 +-
 drivers/virtio/virtio_mem.c                        |   30 +-
 drivers/virtio/virtio_pci_modern.c                 |    1 +
 drivers/virtio/virtio_ring.c                       |    7 +-
 drivers/virtio/virtio_vdpa.c                       |    9 +-
 fs/fuse/virtio_fs.c                                |    4 +-
 include/linux/mlx5/cq.h                            |    1 -
 include/linux/mlx5/device.h                        |   13 +-
 include/linux/mlx5/driver.h                        |    2 +
 include/linux/mlx5/mlx5_ifc.h                      |  134 +-
 include/linux/mlx5/qp.h                            |    2 +-
 include/linux/mlx5/rsc_dump.h                      |   51 +
 include/linux/vdpa.h                               |   66 +-
 include/linux/virtio_caif.h                        |    6 +-
 include/linux/virtio_config.h                      |  191 +-
 include/linux/virtio_ring.h                        |   19 +-
 include/uapi/linux/vhost.h                         |    2 +
 include/uapi/linux/vhost_types.h                   |   11 +
 include/uapi/linux/virtio_9p.h                     |    4 +-
 include/uapi/linux/virtio_balloon.h                |   10 +-
 include/uapi/linux/virtio_blk.h                    |   26 +-
 include/uapi/linux/virtio_config.h                 |   10 +-
 include/uapi/linux/virtio_console.h                |    8 +-
 include/uapi/linux/virtio_crypto.h                 |   26 +-
 include/uapi/linux/virtio_fs.h                     |    2 +-
 include/uapi/linux/virtio_gpu.h                    |    8 +-
 include/uapi/linux/virtio_input.h                  |   18 +-
 include/uapi/linux/virtio_iommu.h                  |   12 +-
 include/uapi/linux/virtio_mem.h                    |   14 +-
 include/uapi/linux/virtio_net.h                    |    8 +-
 include/uapi/linux/virtio_pmem.h                   |    4 +-
 include/uapi/linux/virtio_scsi.h                   |   20 +-
 tools/virtio/linux/virtio_config.h                 |    6 +-
 virt/lib/irqbypass.c                               |   16 +-
 78 files changed, 4116 insertions(+), 487 deletions(-)
 create mode 100644 drivers/vdpa/mlx5/Makefile
 create mode 100644 drivers/vdpa/mlx5/core/mlx5_vdpa.h
 create mode 100644 drivers/vdpa/mlx5/core/mlx5_vdpa_ifc.h
 create mode 100644 drivers/vdpa/mlx5/core/mr.c
 create mode 100644 drivers/vdpa/mlx5/core/resources.c
 create mode 100644 drivers/vdpa/mlx5/net/main.c
 create mode 100644 drivers/vdpa/mlx5/net/mlx5_vnet.c
 create mode 100644 drivers/vdpa/mlx5/net/mlx5_vnet.h
 create mode 100644 include/linux/mlx5/rsc_dump.h

