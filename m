Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CFF48F33B
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 00:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiANXtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 18:49:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38448 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231394AbiANXtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 18:49:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642204154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i0nek0sWysaoX19xFLe6n0NQKHBRZwfdOywS+ke9TsM=;
        b=eALr3jhE6m0h5XN0daGY+u7v2tdWeH0GIadGhX3Vhd5MTyFJnAok5qzuXFtDeZH+9xazsp
        WRjHcJ+EL6llh9WLPIHG2EnUIc6joXSBkvdFbgnauxH1RpMXejiMsedzqQALe/1PpV8a5i
        kj0C8/apbu3oVQRRpp/H7ru/ci5yb4U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-T6Co3zIGN3m45q0oO90wsw-1; Fri, 14 Jan 2022 18:49:13 -0500
X-MC-Unique: T6Co3zIGN3m45q0oO90wsw-1
Received: by mail-wm1-f69.google.com with SMTP id bg32-20020a05600c3ca000b00349f2aca1beso6432928wmb.9
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 15:49:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=i0nek0sWysaoX19xFLe6n0NQKHBRZwfdOywS+ke9TsM=;
        b=GyfaUesr6BYaektzu/KG9powAnd9wfibtDvq6Fx8E3yhrKyYDXEHIj2DSuq/hWDo4u
         ERk+Og8qXQv+lSDZt7ffr8EUy51B4pxMy5kNlbsV9tFGRn4NI3Zp76RjJm5O4mrIhDP1
         hw6jDtHLiST0TN4bILW1mSV1GWUUxk4et+JIIkb390+2khGheel0ysT/jqUtDqwmBFqd
         YHTSJmr9+lCF0+M1XjAu/dH7gZ9SmQGQLI28YfwicW/NtIaVRwLUMkb++YEAi0XJN47d
         jYlX+X4Fk9VF4lym8Tmz3irJp6CjwBee9cFiYVzW0qh7zpT9oIyj9P8ReEv1J9nO6y+o
         J84w==
X-Gm-Message-State: AOAM533YUEgjvpANcaP2MczxS31mw0K1QPZmKfHTVVPzawfw+lvcaolQ
        6X9U1gjXfh+ATzHocbER1FgGQPIZrVGC5OXIWWCA25VuJFjVuNMSI61onHCPmfWveFVKBKlqZc6
        CxBvHs2J2f+Y/6APR
X-Received: by 2002:a5d:6d41:: with SMTP id k1mr10487348wri.478.1642204152518;
        Fri, 14 Jan 2022 15:49:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhbcq3IrnxviaxbNRudcPg/bVTYJ0J6PhU04DEcOhtNqZFsRSUVQ2QTPmNay0KZc5zshsGqA==
X-Received: by 2002:a5d:6d41:: with SMTP id k1mr10487320wri.478.1642204152313;
        Fri, 14 Jan 2022 15:49:12 -0800 (PST)
Received: from redhat.com ([2.55.154.210])
        by smtp.gmail.com with ESMTPSA id 14sm7954410wry.23.2022.01.14.15.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 15:49:11 -0800 (PST)
Date:   Fri, 14 Jan 2022 18:49:04 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christophe.jaillet@wanadoo.fr, dapeng1.mi@intel.com,
        david@redhat.com, elic@nvidia.com, eperezma@redhat.com,
        flyingpenghao@gmail.com, flyingpeng@tencent.com,
        gregkh@linuxfoundation.org, guanjun@linux.alibaba.com,
        jasowang@redhat.com, jean-philippe@linaro.org,
        jiasheng@iscas.ac.cn, johan@kernel.org, keescook@chromium.org,
        labbott@kernel.org, lingshan.zhu@intel.com, lkp@intel.com,
        luolikang@nsfocus.com, lvivier@redhat.com, pasic@linux.ibm.com,
        sgarzare@redhat.com, somlo@cmu.edu, trix@redhat.com,
        wu000273@umn.edu, xianting.tian@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, yun.wang@linux.alibaba.com
Subject: Re: [GIT PULL] virtio,vdpa,qemu_fw_cfg: features, cleanups, fixes
Message-ID: <20220114184825-mutt-send-email-mst@kernel.org>
References: <20220114153515-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220114153515-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 03:35:15PM -0500, Michael S. Tsirkin wrote:
> The following changes since commit c9e6606c7fe92b50a02ce51dda82586ebdf99b48:
> 
>   Linux 5.16-rc8 (2022-01-02 14:23:25 -0800)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> 
> for you to fetch changes up to f04ac267029c8063fc35116b385cd37656b3c81a:
> 
>   virtio: acknowledge all features before access (2022-01-14 14:58:41 -0500)
> 
> ----------------------------------------------------------------
> virtio,vdpa,qemu_fw_cfg: features, cleanups, fixes
> 
> IOMMU bypass support in virtio-iommu
> partial support for < MAX_ORDER - 1 granularity for virtio-mem
> driver_override for vdpa
> sysfs ABI documentation for vdpa
> multiqueue config support for mlx5 vdpa
> 
> Misc fixes, cleanups.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

self-NACK at author's request.

Will send v2. Sorry.

> ----------------------------------------------------------------
> Christophe JAILLET (1):
>       eni_vdpa: Simplify 'eni_vdpa_probe()'
> 
> Dapeng Mi (1):
>       virtio: fix a typo in function "vp_modern_remove" comments.
> 
> David Hildenbrand (2):
>       virtio-mem: prepare page onlining code for granularity smaller than MAX_ORDER - 1
>       virtio-mem: prepare fake page onlining code for granularity smaller than MAX_ORDER - 1
> 
> Eli Cohen (20):
>       net/mlx5_vdpa: Offer VIRTIO_NET_F_MTU when setting MTU
>       vdpa/mlx5: Fix wrong configuration of virtio_version_1_0
>       vdpa: Provide interface to read driver features
>       vdpa/mlx5: Distribute RX virtqueues in RQT object
>       vdpa: Sync calls set/get config/status with cf_mutex
>       vdpa: Read device configuration only if FEATURES_OK
>       vdpa: Allow to configure max data virtqueues
>       vdpa/mlx5: Fix config_attr_mask assignment
>       vdpa/mlx5: Support configuring max data virtqueue
>       vdpa: Add support for returning device configuration information
>       vdpa/mlx5: Restore cur_num_vqs in case of failure in change_num_qps()
>       vdpa: Support reporting max device capabilities
>       vdpa/mlx5: Report max device capabilities
>       vdpa/vdpa_sim: Configure max supported virtqueues
>       vdpa: Use BIT_ULL for bit operations
>       vdpa/vdpa_sim_net: Report max device capabilities
>       vdpa: Avoid taking cf_mutex lock on get status
>       vdpa: Protect vdpa reset with cf_mutex
>       vdpa/mlx5: Fix is_index_valid() to refer to features
>       vdpa/mlx5: Fix tracking of current number of VQs
> 
> Eugenio Pérez (2):
>       vdpa: Avoid duplicate call to vp_vdpa get_status
>       vdpa: Mark vdpa_config_ops.get_vq_notification as optional
> 
> Guanjun (1):
>       vduse: moving kvfree into caller
> 
> Jean-Philippe Brucker (5):
>       iommu/virtio: Add definitions for VIRTIO_IOMMU_F_BYPASS_CONFIG
>       iommu/virtio: Support bypass domains
>       iommu/virtio: Sort reserved regions
>       iommu/virtio: Pass end address to viommu_add_mapping()
>       iommu/virtio: Support identity-mapped domains
> 
> Johan Hovold (4):
>       firmware: qemu_fw_cfg: fix NULL-pointer deref on duplicate entries
>       firmware: qemu_fw_cfg: fix kobject leak in probe error path
>       firmware: qemu_fw_cfg: fix sysfs information leak
>       firmware: qemu_fw_cfg: remove sysfs entries explicitly
> 
> Laura Abbott (1):
>       vdpa: clean up get_config_size ret value handling
> 
> Michael S. Tsirkin (5):
>       virtio: wrap config->reset calls
>       hwrng: virtio - unregister device before reset
>       virtio_ring: mark ring unused on error
>       virtio: unexport virtio_finalize_features
>       virtio: acknowledge all features before access
> 
> Peng Hao (2):
>       virtio/virtio_mem: handle a possible NULL as a memcpy parameter
>       virtio/virtio_pci_legacy_dev: ensure the correct return value
> 
> Stefano Garzarella (2):
>       docs: document sysfs ABI for vDPA bus
>       vdpa: add driver_override support
> 
> Xianting Tian (1):
>       vhost/test: fix memory leak of vhost virtqueues
> 
> Zhu Lingshan (1):
>       ifcvf/vDPA: fix misuse virtio-net device config size for blk dev
> 
> 王贇 (1):
>       virtio-pci: fix the confusing error message
> 
>  Documentation/ABI/testing/sysfs-bus-vdpa   |  57 ++++++++++
>  MAINTAINERS                                |   1 +
>  arch/um/drivers/virt-pci.c                 |   2 +-
>  drivers/block/virtio_blk.c                 |   4 +-
>  drivers/bluetooth/virtio_bt.c              |   2 +-
>  drivers/char/hw_random/virtio-rng.c        |   2 +-
>  drivers/char/virtio_console.c              |   4 +-
>  drivers/crypto/virtio/virtio_crypto_core.c |   8 +-
>  drivers/firmware/arm_scmi/virtio.c         |   2 +-
>  drivers/firmware/qemu_fw_cfg.c             |  21 ++--
>  drivers/gpio/gpio-virtio.c                 |   2 +-
>  drivers/gpu/drm/virtio/virtgpu_kms.c       |   2 +-
>  drivers/i2c/busses/i2c-virtio.c            |   2 +-
>  drivers/iommu/virtio-iommu.c               | 115 ++++++++++++++++----
>  drivers/net/caif/caif_virtio.c             |   2 +-
>  drivers/net/virtio_net.c                   |   4 +-
>  drivers/net/wireless/mac80211_hwsim.c      |   2 +-
>  drivers/nvdimm/virtio_pmem.c               |   2 +-
>  drivers/rpmsg/virtio_rpmsg_bus.c           |   2 +-
>  drivers/scsi/virtio_scsi.c                 |   2 +-
>  drivers/vdpa/alibaba/eni_vdpa.c            |  28 +++--
>  drivers/vdpa/ifcvf/ifcvf_base.c            |  41 ++++++--
>  drivers/vdpa/ifcvf/ifcvf_base.h            |   9 +-
>  drivers/vdpa/ifcvf/ifcvf_main.c            |  40 +++----
>  drivers/vdpa/mlx5/net/mlx5_vnet.c          | 156 ++++++++++++++++-----------
>  drivers/vdpa/vdpa.c                        | 163 +++++++++++++++++++++++++----
>  drivers/vdpa/vdpa_sim/vdpa_sim.c           |  21 ++--
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c       |   2 +
>  drivers/vdpa/vdpa_user/vduse_dev.c         |  19 +++-
>  drivers/vdpa/virtio_pci/vp_vdpa.c          |  16 ++-
>  drivers/vhost/test.c                       |   1 +
>  drivers/vhost/vdpa.c                       |  12 +--
>  drivers/virtio/virtio.c                    |  40 ++++---
>  drivers/virtio/virtio_balloon.c            |   2 +-
>  drivers/virtio/virtio_input.c              |   2 +-
>  drivers/virtio/virtio_mem.c                | 114 +++++++++++++-------
>  drivers/virtio/virtio_pci_legacy.c         |   2 +-
>  drivers/virtio/virtio_pci_legacy_dev.c     |   4 +-
>  drivers/virtio/virtio_pci_modern_dev.c     |   2 +-
>  drivers/virtio/virtio_ring.c               |   4 +-
>  drivers/virtio/virtio_vdpa.c               |   7 +-
>  fs/fuse/virtio_fs.c                        |   4 +-
>  include/linux/vdpa.h                       |  39 +++++--
>  include/linux/virtio.h                     |   2 +-
>  include/uapi/linux/vdpa.h                  |   6 ++
>  include/uapi/linux/virtio_iommu.h          |   8 +-
>  net/9p/trans_virtio.c                      |   2 +-
>  net/vmw_vsock/virtio_transport.c           |   4 +-
>  sound/virtio/virtio_card.c                 |   4 +-
>  49 files changed, 706 insertions(+), 286 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-vdpa

