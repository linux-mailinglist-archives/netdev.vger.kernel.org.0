Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B85E48F349
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 00:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiANX5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 18:57:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231318AbiANX5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 18:57:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642204662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=D+0bgpxBAVMxLpxGa7wCKNbdJo62rz8/YJW57GNylKk=;
        b=TSzDohZXoJaB+36LlS8G1oFJoOCB42lTq3WS8bX/cQbCxLoev+0XXE7FUY89Bp8Zhoy8PN
        GqL8jcRxudPAPh2IV0sOOjLYDX8f8PcgcC848xCHL0jP6T+m7ZUXED/bcXJQQ42O9jEj9y
        ehn4pjqcSzO0qwNDO8CCwMXrMbupRbI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-f2tzhowUNUSn88fO7Suhig-1; Fri, 14 Jan 2022 18:57:41 -0500
X-MC-Unique: f2tzhowUNUSn88fO7Suhig-1
Received: by mail-ed1-f69.google.com with SMTP id v18-20020a056402349200b003f8d3b7ee8dso9460071edc.23
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 15:57:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=D+0bgpxBAVMxLpxGa7wCKNbdJo62rz8/YJW57GNylKk=;
        b=MGMNXU9FjAz+YePENCPek2yWYeLXK+/kKxdOhVdLaYi7c2MO+f5SNmu2LExkEQk088
         RRzeYkqr+d8O87OBDjRTf1C/jKuwg48MaK2AFk4zrWiWJMMWmU4vHcTp6hCkrxQA4leH
         v1uR7qeSENkT80QUWck39qw6RsrcmSE2otwB/tyyDzJTIAJ7jps+ZYRathxU3Si6i6dr
         4suyVcGI+ZUdtanRbX6FPb6iBArgVFVJHUUcDllk4s3lk6v2S+/aeye4vC++Hry58txB
         oPMwXl655zk0H27QXPJcMiXzMMX7mymkr5Zcyb2b7MIQtiBWBN8T8pjjHELFh4d/1ati
         JE3Q==
X-Gm-Message-State: AOAM530D6ilLAF5rCND8ZByvu/ckiI9kb0N9CVWf4POLWmFKyRQTapX+
        q93lzh16wkSpaxutswM2l+dRZdZBsz8aTG8hPUnexhVgSBFXE0kpOcD70uuxITnDOAKVIHQpgdS
        E0DKzqGvV8PDcxiCP
X-Received: by 2002:a17:906:5603:: with SMTP id f3mr8930236ejq.272.1642204659684;
        Fri, 14 Jan 2022 15:57:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzw9UwvSMW809qwJwiRcizTtUV722wKbEUu/04GUnOgOb1aKRqWeKtp1VUDA0VAb9OdhrEfqw==
X-Received: by 2002:a17:906:5603:: with SMTP id f3mr8930206ejq.272.1642204659427;
        Fri, 14 Jan 2022 15:57:39 -0800 (PST)
Received: from redhat.com ([2.55.154.210])
        by smtp.gmail.com with ESMTPSA id y7sm2277626edq.27.2022.01.14.15.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:57:38 -0800 (PST)
Date:   Fri, 14 Jan 2022 18:57:34 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christophe.jaillet@wanadoo.fr, dapeng1.mi@intel.com,
        david@redhat.com, elic@nvidia.com, eperezma@redhat.com,
        flyingpenghao@gmail.com, flyingpeng@tencent.com,
        gregkh@linuxfoundation.org, guanjun@linux.alibaba.com,
        jasowang@redhat.com, jiasheng@iscas.ac.cn, johan@kernel.org,
        keescook@chromium.org, labbott@kernel.org, lingshan.zhu@intel.com,
        lkp@intel.com, luolikang@nsfocus.com, lvivier@redhat.com,
        mst@redhat.com, sgarzare@redhat.com, somlo@cmu.edu,
        trix@redhat.com, wu000273@umn.edu, xianting.tian@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, yun.wang@linux.alibaba.com
Subject: [GIT PULL v2] virtio,vdpa,qemu_fw_cfg: features, cleanups, fixes
Message-ID: <20220114185734-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from v1:

Dropped iommu changes at author's request. Pity this was only
requested after I sent pull v1 :(

Note that since these were the first in queue other hashes
do not match what was in linux-next, however as the changes
are in a separate driver, this should not matter.

The following changes since commit c9e6606c7fe92b50a02ce51dda82586ebdf99b48:

  Linux 5.16-rc8 (2022-01-02 14:23:25 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to b03fc43e73877e180c1803a33aea3e7396642367:

  vdpa/mlx5: Fix tracking of current number of VQs (2022-01-14 18:50:54 -0500)

----------------------------------------------------------------
virtio,vdpa,qemu_fw_cfg: features, cleanups, fixes

partial support for < MAX_ORDER - 1 granularity for virtio-mem
driver_override for vdpa
sysfs ABI documentation for vdpa
multiqueue config support for mlx5 vdpa

Misc fixes, cleanups.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Christophe JAILLET (1):
      eni_vdpa: Simplify 'eni_vdpa_probe()'

Dapeng Mi (1):
      virtio: fix a typo in function "vp_modern_remove" comments.

David Hildenbrand (2):
      virtio-mem: prepare page onlining code for granularity smaller than MAX_ORDER - 1
      virtio-mem: prepare fake page onlining code for granularity smaller than MAX_ORDER - 1

Eli Cohen (20):
      net/mlx5_vdpa: Offer VIRTIO_NET_F_MTU when setting MTU
      vdpa/mlx5: Fix wrong configuration of virtio_version_1_0
      vdpa: Provide interface to read driver features
      vdpa/mlx5: Distribute RX virtqueues in RQT object
      vdpa: Sync calls set/get config/status with cf_mutex
      vdpa: Read device configuration only if FEATURES_OK
      vdpa: Allow to configure max data virtqueues
      vdpa/mlx5: Fix config_attr_mask assignment
      vdpa/mlx5: Support configuring max data virtqueue
      vdpa: Add support for returning device configuration information
      vdpa/mlx5: Restore cur_num_vqs in case of failure in change_num_qps()
      vdpa: Support reporting max device capabilities
      vdpa/mlx5: Report max device capabilities
      vdpa/vdpa_sim: Configure max supported virtqueues
      vdpa: Use BIT_ULL for bit operations
      vdpa/vdpa_sim_net: Report max device capabilities
      vdpa: Avoid taking cf_mutex lock on get status
      vdpa: Protect vdpa reset with cf_mutex
      vdpa/mlx5: Fix is_index_valid() to refer to features
      vdpa/mlx5: Fix tracking of current number of VQs

Eugenio Pérez (2):
      vdpa: Avoid duplicate call to vp_vdpa get_status
      vdpa: Mark vdpa_config_ops.get_vq_notification as optional

Guanjun (1):
      vduse: moving kvfree into caller

Johan Hovold (4):
      firmware: qemu_fw_cfg: fix NULL-pointer deref on duplicate entries
      firmware: qemu_fw_cfg: fix kobject leak in probe error path
      firmware: qemu_fw_cfg: fix sysfs information leak
      firmware: qemu_fw_cfg: remove sysfs entries explicitly

Laura Abbott (1):
      vdpa: clean up get_config_size ret value handling

Michael S. Tsirkin (3):
      virtio: wrap config->reset calls
      hwrng: virtio - unregister device before reset
      virtio_ring: mark ring unused on error

Peng Hao (2):
      virtio/virtio_mem: handle a possible NULL as a memcpy parameter
      virtio/virtio_pci_legacy_dev: ensure the correct return value

Stefano Garzarella (2):
      docs: document sysfs ABI for vDPA bus
      vdpa: add driver_override support

Xianting Tian (1):
      vhost/test: fix memory leak of vhost virtqueues

Zhu Lingshan (1):
      ifcvf/vDPA: fix misuse virtio-net device config size for blk dev

王贇 (1):
      virtio-pci: fix the confusing error message

 Documentation/ABI/testing/sysfs-bus-vdpa   |  57 ++++++++++
 MAINTAINERS                                |   1 +
 arch/um/drivers/virt-pci.c                 |   2 +-
 drivers/block/virtio_blk.c                 |   4 +-
 drivers/bluetooth/virtio_bt.c              |   2 +-
 drivers/char/hw_random/virtio-rng.c        |   2 +-
 drivers/char/virtio_console.c              |   4 +-
 drivers/crypto/virtio/virtio_crypto_core.c |   8 +-
 drivers/firmware/arm_scmi/virtio.c         |   2 +-
 drivers/firmware/qemu_fw_cfg.c             |  21 ++--
 drivers/gpio/gpio-virtio.c                 |   2 +-
 drivers/gpu/drm/virtio/virtgpu_kms.c       |   2 +-
 drivers/i2c/busses/i2c-virtio.c            |   2 +-
 drivers/iommu/virtio-iommu.c               |   2 +-
 drivers/net/caif/caif_virtio.c             |   2 +-
 drivers/net/virtio_net.c                   |   4 +-
 drivers/net/wireless/mac80211_hwsim.c      |   2 +-
 drivers/nvdimm/virtio_pmem.c               |   2 +-
 drivers/rpmsg/virtio_rpmsg_bus.c           |   2 +-
 drivers/scsi/virtio_scsi.c                 |   2 +-
 drivers/vdpa/alibaba/eni_vdpa.c            |  28 +++--
 drivers/vdpa/ifcvf/ifcvf_base.c            |  41 ++++++--
 drivers/vdpa/ifcvf/ifcvf_base.h            |   9 +-
 drivers/vdpa/ifcvf/ifcvf_main.c            |  40 +++----
 drivers/vdpa/mlx5/net/mlx5_vnet.c          | 156 ++++++++++++++++-----------
 drivers/vdpa/vdpa.c                        | 163 +++++++++++++++++++++++++----
 drivers/vdpa/vdpa_sim/vdpa_sim.c           |  21 ++--
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c       |   2 +
 drivers/vdpa/vdpa_user/vduse_dev.c         |  19 +++-
 drivers/vdpa/virtio_pci/vp_vdpa.c          |  16 ++-
 drivers/vhost/test.c                       |   1 +
 drivers/vhost/vdpa.c                       |  12 +--
 drivers/virtio/virtio.c                    |   6 ++
 drivers/virtio/virtio_balloon.c            |   2 +-
 drivers/virtio/virtio_input.c              |   2 +-
 drivers/virtio/virtio_mem.c                | 114 +++++++++++++-------
 drivers/virtio/virtio_pci_legacy.c         |   2 +-
 drivers/virtio/virtio_pci_legacy_dev.c     |   4 +-
 drivers/virtio/virtio_pci_modern_dev.c     |   2 +-
 drivers/virtio/virtio_ring.c               |   4 +-
 drivers/virtio/virtio_vdpa.c               |   7 +-
 fs/fuse/virtio_fs.c                        |   4 +-
 include/linux/vdpa.h                       |  39 +++++--
 include/linux/virtio.h                     |   1 +
 include/uapi/linux/vdpa.h                  |   6 ++
 net/9p/trans_virtio.c                      |   2 +-
 net/vmw_vsock/virtio_transport.c           |   4 +-
 sound/virtio/virtio_card.c                 |   4 +-
 48 files changed, 587 insertions(+), 249 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-vdpa

