Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4272D53BF5F
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 22:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237631AbiFBULh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 16:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236160AbiFBULf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 16:11:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8055F627A
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 13:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654200692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BYY7dcXsY44fX5UAyrBEQpdxF2tKWWA11PscTbyg+9s=;
        b=UKdb2aF0dVlujJ9iknSFOGo5TJkxT0G3VdVM7yNmb41UVzwunpyJbUFFQtG6pT2GW/SKbM
        IAPqA4AjY9UwAHjMwb9NhWoFrONXQK4pvfobLJwHal8IJIv6bNsqabznryLm5r1d/D9lCZ
        XUlbFQoYzftuWPy2XIsZOoImqdMJzfo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-WJRR2NWTNyG65PZ7vZAA4g-1; Thu, 02 Jun 2022 16:11:31 -0400
X-MC-Unique: WJRR2NWTNyG65PZ7vZAA4g-1
Received: by mail-wm1-f71.google.com with SMTP id k16-20020a7bc310000000b0038e6cf00439so3349583wmj.0
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 13:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=BYY7dcXsY44fX5UAyrBEQpdxF2tKWWA11PscTbyg+9s=;
        b=JtKlE05dWfw2Gimi3RvK86UCmkhVJpjDNtBBbyC4oDRaeU0QJgUfnpCZc7p4LFbqdB
         iMICAGdniysp0UsDhd065Fxj1h917tNbgeb6VgWrEY4jaa8uTtR89dcS25StiobRrZxk
         t9CPMzM4ZHH41+NlaLCmXyRXGTlkas3EEmja2NNRBwHUOfB2l8iBCKeWroGEDxBJSzWL
         IBf+Q7jIFnpRIvBRpbZudF73Me9FUj4PRB3PxK+1dkYeE3OVn4lipujvZrnKJCn9d6ae
         fsJ4C7qhGO+7ZWqHbd3/HzoxeiXbdAjJQ8kkXIFAfR/9PHZogAJ81B/R6D7m/JBO4uHm
         QkUA==
X-Gm-Message-State: AOAM5301dRz/6E9WBc5gP2rXZDElzyKY/pmlFxt+S2eGvxrDEDMqVBgX
        eP0uHvuxw5UMGGbMX2jVo0d1zKetIgJYNA84fdfJ+aPtediunIu6z7bHrdORh/pnPQNWVMMvTf2
        77TPCuEvxRST70bbX
X-Received: by 2002:adf:e10d:0:b0:20c:dc8f:e5a5 with SMTP id t13-20020adfe10d000000b0020cdc8fe5a5mr5038001wrz.265.1654200690440;
        Thu, 02 Jun 2022 13:11:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzneIx0zMilxr+W1BaJYsoq6s6IQhmzotnKWEdtoLNMkaqVhZmbNrt2KDMUSeYLfo6yVFEAAg==
X-Received: by 2002:adf:e10d:0:b0:20c:dc8f:e5a5 with SMTP id t13-20020adfe10d000000b0020cdc8fe5a5mr5037980wrz.265.1654200690187;
        Thu, 02 Jun 2022 13:11:30 -0700 (PDT)
Received: from redhat.com ([2.55.40.171])
        by smtp.gmail.com with ESMTPSA id n4-20020a1c7204000000b003949dbc3790sm7063981wmc.18.2022.06.02.13.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 13:11:29 -0700 (PDT)
Date:   Thu, 2 Jun 2022 16:11:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arbn@yandex-team.com, arei.gonglei@huawei.com,
        christophe.jaillet@wanadoo.fr, cohuck@redhat.com,
        dan.carpenter@oracle.com, dinechin@redhat.com, elic@nvidia.com,
        eperezma@redhat.com, gautam.dawar@xilinx.com, gdawar@xilinx.com,
        helei.sig11@bytedance.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, linux-s390@vger.kernel.org,
        liuke94@huawei.com, lkp@intel.com, lulu@redhat.com, maz@kernel.org,
        michael.christie@oracle.com, mst@redhat.com, muriloo@linux.ibm.com,
        oberpar@linux.ibm.com, pasic@linux.ibm.com, paulmck@kernel.org,
        peterz@infradead.org, pizhenwei@bytedance.com, sgarzare@redhat.com,
        solomonbstoner@protonmail.ch, stable@vger.kernel.org,
        suwan.kim027@gmail.com, tglx@linutronix.de, vneethv@linux.ibm.com,
        xianting.tian@linux.alibaba.com, zheyuma97@gmail.com
Subject: [GIT PULL] vhost,virtio,vdpa: features, fixes, cleanups
Message-ID: <20220602161124-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 8ab2afa23bd197df47819a87f0265c0ac95c5b6a:

  Merge tag 'for-5.19/fbdev-1' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/linux-fbdev (2022-05-30 12:46:49 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to bd8bb9aed56b1814784a975e2dfea12a9adcee92:

  vdpa: ifcvf: set pci driver data in probe (2022-06-01 02:16:38 -0400)

----------------------------------------------------------------
vhost,virtio,vdpa: features, fixes, cleanups

mac vlan filter and stats support in mlx5 vdpa
irq hardening in virtio
performance improvements in virtio crypto
polling i/o support in virtio blk
ASID support in vhost
fixes, cleanups all over the place

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Andrey Ryabinin (4):
      vhost: get rid of vhost_poll_flush() wrapper
      vhost_net: get rid of vhost_net_flush_vq() and extra flush calls
      vhost_test: remove vhost_test_flush_vq()
      vhost_vsock: simplify vhost_vsock_flush()

Christophe JAILLET (1):
      virtio: pci: Fix an error handling path in vp_modern_probe()

Cindy Lu (1):
      vdpa/vp_vdpa : add vdpa tool support in vp_vdpa

Dan Carpenter (2):
      vdpasim: Off by one in vdpasim_set_group_asid()
      vhost-vdpa: return -EFAULT on copy_to_user() failure

Eli Cohen (8):
      vdpa: Fix error logic in vdpa_nl_cmd_dev_get_doit
      vdpa: Add support for querying vendor statistics
      net/vdpa: Use readers/writers semaphore instead of vdpa_dev_mutex
      net/vdpa: Use readers/writers semaphore instead of cf_mutex
      vdpa/mlx5: Add support for reading descriptor statistics
      vdpa/mlx5: Use readers/writers semaphore instead of mutex
      vdpa/mlx5: Remove flow counter from steering
      vdpa/mlx5: Add RX MAC VLAN filter support

Eugenio Pérez (1):
      vdpasim: allow to enable a vq repeatedly

Gautam Dawar (19):
      vhost: move the backend feature bits to vhost_types.h
      virtio-vdpa: don't set callback if virtio doesn't need it
      vhost-vdpa: passing iotlb to IOMMU mapping helpers
      vhost-vdpa: switch to use vhost-vdpa specific IOTLB
      vdpa: introduce virtqueue groups
      vdpa: multiple address spaces support
      vdpa: introduce config operations for associating ASID to a virtqueue group
      vhost_iotlb: split out IOTLB initialization
      vhost: support ASID in IOTLB API
      vhost-vdpa: introduce asid based IOTLB
      vhost-vdpa: introduce uAPI to get the number of virtqueue groups
      vhost-vdpa: introduce uAPI to get the number of address spaces
      vhost-vdpa: uAPI to get virtqueue group id
      vhost-vdpa: introduce uAPI to set group ASID
      vhost-vdpa: support ASID based IOTLB API
      vdpa_sim: advertise VIRTIO_NET_F_MTU
      vdpa_sim: factor out buffer completion logic
      vdpa_sim: filter destination mac address
      vdpasim: control virtqueue support

Jason Wang (9):
      virtio: use virtio_reset_device() when possible
      virtio: introduce config op to synchronize vring callbacks
      virtio-pci: implement synchronize_cbs()
      virtio-mmio: implement synchronize_cbs()
      virtio-ccw: implement synchronize_cbs()
      virtio: allow to unbreak virtqueue
      virtio: harden vring IRQ
      virtio: use WARN_ON() to warning illegal status value
      vdpa: ifcvf: set pci driver data in probe

Mike Christie (4):
      vhost: flush dev once during vhost_dev_stop
      vhost-scsi: drop flush after vhost_dev_cleanup
      vhost-test: drop flush after vhost_dev_cleanup
      vhost: rename vhost_work_dev_flush

Murilo Opsfelder Araujo (1):
      virtio-pci: Remove wrong address verification in vp_del_vqs()

Solomon Tan (2):
      virtio: Replace unsigned with unsigned int
      virtio: Replace long long int with long long

Stefano Garzarella (1):
      virtio: use virtio_device_ready() in virtio_device_restore()

Suwan Kim (2):
      virtio-blk: support polling I/O
      virtio-blk: support mq_ops->queue_rqs()

Xianting Tian (2):
      virtio_ring: remove unnecessary to_vvq call in vring hot path
      virtio_ring: add unlikely annotation for free descs check

Zhu Lingshan (1):
      vDPA/ifcvf: fix uninitialized config_vector warning

keliu (1):
      virtio: Directly use ida_alloc()/free()

lei he (2):
      virtio-crypto: adjust dst_len at ops callback
      virtio-crypto: enable retry for virtio-crypto-dev

zhenwei pi (3):
      virtio-crypto: change code style
      virtio-crypto: use private buffer for control request
      virtio-crypto: wait ctrl queue instead of busy polling

 drivers/block/virtio_blk.c                         | 224 +++++++++-
 .../crypto/virtio/virtio_crypto_akcipher_algs.c    |  95 ++--
 drivers/crypto/virtio/virtio_crypto_common.h       |  21 +-
 drivers/crypto/virtio/virtio_crypto_core.c         |  55 ++-
 .../crypto/virtio/virtio_crypto_skcipher_algs.c    | 138 +++---
 drivers/s390/virtio/virtio_ccw.c                   |  34 ++
 drivers/vdpa/alibaba/eni_vdpa.c                    |   2 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    |  23 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |   2 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  | 491 +++++++++++++++++----
 drivers/vdpa/vdpa.c                                | 257 +++++++++--
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   | 107 ++++-
 drivers/vdpa/vdpa_sim/vdpa_sim.h                   |   3 +
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c               | 169 +++++--
 drivers/vdpa/vdpa_user/vduse_dev.c                 |   3 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c                  | 161 +++++--
 drivers/vhost/iotlb.c                              |  23 +-
 drivers/vhost/net.c                                |  11 +-
 drivers/vhost/scsi.c                               |   4 +-
 drivers/vhost/test.c                               |  14 +-
 drivers/vhost/vdpa.c                               | 271 +++++++++---
 drivers/vhost/vhost.c                              |  45 +-
 drivers/vhost/vhost.h                              |   7 +-
 drivers/vhost/vsock.c                              |   7 +-
 drivers/virtio/virtio.c                            |  32 +-
 drivers/virtio/virtio_balloon.c                    |  12 +-
 drivers/virtio/virtio_mmio.c                       |  27 +-
 drivers/virtio/virtio_pci_common.c                 |  15 +-
 drivers/virtio/virtio_pci_common.h                 |  10 +-
 drivers/virtio/virtio_pci_legacy.c                 |  11 +-
 drivers/virtio/virtio_pci_modern.c                 |  14 +-
 drivers/virtio/virtio_pci_modern_dev.c             |   6 +
 drivers/virtio/virtio_ring.c                       |  55 ++-
 drivers/virtio/virtio_vdpa.c                       |  12 +-
 include/linux/mlx5/mlx5_ifc.h                      |   1 +
 include/linux/mlx5/mlx5_ifc_vdpa.h                 |  39 ++
 include/linux/vdpa.h                               |  61 ++-
 include/linux/vhost_iotlb.h                        |   2 +
 include/linux/virtio.h                             |   1 +
 include/linux/virtio_config.h                      |  47 +-
 include/uapi/linux/vdpa.h                          |   6 +
 include/uapi/linux/vhost.h                         |  26 +-
 include/uapi/linux/vhost_types.h                   |  11 +-
 43 files changed, 1964 insertions(+), 591 deletions(-)

