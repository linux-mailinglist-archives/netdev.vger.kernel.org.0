Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE01374923
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 22:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbhEEUMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 16:12:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55692 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233900AbhEEUMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 16:12:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620245503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=trH/NfkKL9hdKsJ9LaR25jQCqSBLEA1C4zT+z7TQZuM=;
        b=QVLwlc0TtYccFN/ffftD+qVTCDhW4v3x/wIATXzk07ZCcoj2cA1c4oDM/NQKo9/2h5FhXI
        Ngr3a2vdeQEw0SWBBGTN5KnHayLZaIBhD59c2LnKtLJrpu66KcNwdbhUM0ouDAsvfVkOeX
        KtHHlGrmKzgy0Q6xQud96UAdpq7eNXs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-vDeIevrDPAiPG6cJ-lzlyQ-1; Wed, 05 May 2021 16:11:39 -0400
X-MC-Unique: vDeIevrDPAiPG6cJ-lzlyQ-1
Received: by mail-wr1-f72.google.com with SMTP id 65-20020adf82c70000b0290107593a42c3so1153180wrc.5
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 13:11:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=trH/NfkKL9hdKsJ9LaR25jQCqSBLEA1C4zT+z7TQZuM=;
        b=NxVidphoCY82SQN0yj2PZiW7Y0oQJB36w330lbjb8jBWL7Ceg4AafzoBaRh1iUCyHj
         5zkR9+5YSsUfWPgQQLRzflWpEiXmjpXQ7hR22EQivJLj3jg9QDLrqXA+/FTILkw24Zhx
         y62e99Y5noyNcYlg4GT9dRj6CtNN1skLLrVIozwUO7QIvuzC5SpTlO5VcyrrppIxd3Ug
         W1S4oafJxJzJTsDwyA7HgPSEjodfKoeX3N2Nzk83z8TcnH/oHWofftvHzJiGxf4h5zlz
         7dN7NPESAjPTHh0d/Rpr15cSsInzyuhVgh+XlK03vJM2tJ1u9QSub0aDs4frYqt+X8R7
         UkJw==
X-Gm-Message-State: AOAM532LrsfaJl3SiFbQ05F+l7Zy+82KMXJnfMKsROC2NF8a10mzSgD8
        BJHdYj8JIqrif+blxAllAXo+zdOLRgOsM+uhMANb3CB4chgJejgqWrrSQBx59mKPPBEPwGmtACj
        2dAw6H+NiztoyWSEE
X-Received: by 2002:a05:600c:190c:: with SMTP id j12mr11647201wmq.41.1620245498492;
        Wed, 05 May 2021 13:11:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztjSMo+WrOGeWsi0rPU8vWa/2MQe6CfpFZS59vZKcAjfy+3i8GW0D8k1kGMxQrBXfQFIf4Ug==
X-Received: by 2002:a05:600c:190c:: with SMTP id j12mr11647184wmq.41.1620245498339;
        Wed, 05 May 2021 13:11:38 -0700 (PDT)
Received: from redhat.com ([2a10:800c:8fce:0:8e1b:40f0:6a74:513b])
        by smtp.gmail.com with ESMTPSA id m6sm533139wrp.29.2021.05.05.13.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:11:38 -0700 (PDT)
Date:   Wed, 5 May 2021 16:11:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        liu.xiang@zlingsmart.com, lkp@intel.com, mgurtovoy@nvidia.com,
        mst@redhat.com, parav@nvidia.com, sgarzare@redhat.com,
        stable@vger.kernel.org, xieyongji@bytedance.com
Subject: [GIT PULL] virtio,vhost,vdpa: features, fixes
Message-ID: <20210505161135-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 9f4ad9e425a1d3b6a34617b8ea226d56a119a717:

  Linux 5.12 (2021-04-25 13:49:08 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to d7bce85aa7b92b5de8f69b3bcedfe51d7b1aabe1:

  virtio_pci_modern: correct sparse tags for notify (2021-05-04 04:19:59 -0400)

----------------------------------------------------------------
virtio,vhost,vdpa: features, fixes

A bunch of new drivers including vdpa support for block
and virtio-vdpa. Beginning of vq kick (aka doorbell) mapping support.
Misc fixes.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eli Cohen (1):
      vdpa/mlx5: Enable user to add/delete vdpa device

Jason Wang (9):
      vdpa: introduce virtio pci driver
      virtio_pci_modern: introduce helper to map vq notify area
      virtio-pci library: switch to use vp_modern_map_vq_notify()
      vp_vdpa: switch to use vp_modern_map_vq_notify()
      virtio_pci_modern: hide vp_modern_get_queue_notify_off()
      virito_pci libray: hide vp_modern_map_capability()
      virtio-pci library: report resource address
      vp_vdpa: report doorbell address
      vhost-vdpa: fix vm_flags for virtqueue doorbell mapping

Liu Xiang (1):
      virtio-balloon: fix a typo in comment of virtballoon_migratepage()

Max Gurtovoy (2):
      virtio-net: don't allocate control_buf if not supported
      vdpa: add vdpa simulator for block device

Michael S. Tsirkin (2):
      virtio_pci_modern: __force cast the notify mapping
      virtio_pci_modern: correct sparse tags for notify

Parav Pandit (2):
      vdpa: Follow kdoc comment style
      vdpa: Follow kdoc comment style

Stefano Garzarella (12):
      vdpa_sim: use iova module to allocate IOVA addresses
      vringh: add 'iotlb_lock' to synchronize iotlb accesses
      vringh: reset kiov 'consumed' field in __vringh_iov()
      vringh: explain more about cleaning riov and wiov
      vringh: implement vringh_kiov_advance()
      vringh: add vringh_kiov_length() helper
      vdpa_sim: cleanup kiovs in vdpasim_free()
      vdpa: add get_config_size callback in vdpa_config_ops
      vhost/vdpa: use get_config_size callback in vhost_vdpa_config_validate()
      vdpa_sim_blk: implement ramdisk behaviour
      vdpa_sim_blk: handle VIRTIO_BLK_T_GET_ID
      vdpa_sim_blk: add support for vdpa management tool

Xie Yongji (1):
      vhost/vdpa: Remove the restriction that only supports virtio-net devices

Zhu Lingshan (10):
      vDPA/ifcvf: get_vendor_id returns a device specific vendor id
      vDPA/ifcvf: enable Intel C5000X-PL virtio-net for vDPA
      vDPA/ifcvf: rename original IFCVF dev ids to N3000 ids
      vDPA/ifcvf: remove the version number string
      vDPA/ifcvf: fetch device feature bits when probe
      vDPA/ifcvf: verify mandatory feature bits for vDPA
      vDPA/ifcvf: deduce VIRTIO device ID from pdev ids
      vDPA/ifcvf: deduce VIRTIO device ID when probe
      vDPA/ifcvf: enable Intel C5000X-PL virtio-block for vDPA
      vDPA/ifcvf: get_config_size should return dev specific config size

 drivers/Makefile                       |   1 +
 drivers/net/virtio_net.c               |  10 +-
 drivers/vdpa/Kconfig                   |  15 +
 drivers/vdpa/Makefile                  |   1 +
 drivers/vdpa/ifcvf/ifcvf_base.c        |  24 +-
 drivers/vdpa/ifcvf/ifcvf_base.h        |  26 +-
 drivers/vdpa/ifcvf/ifcvf_main.c        |  86 +++++-
 drivers/vdpa/mlx5/net/mlx5_vnet.c      |  85 +++++-
 drivers/vdpa/vdpa.c                    |  12 +-
 drivers/vdpa/vdpa_sim/Makefile         |   1 +
 drivers/vdpa/vdpa_sim/vdpa_sim.c       | 127 ++++++---
 drivers/vdpa/vdpa_sim/vdpa_sim.h       |   2 +
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c   | 338 +++++++++++++++++++++++
 drivers/vdpa/virtio_pci/Makefile       |   2 +
 drivers/vdpa/virtio_pci/vp_vdpa.c      | 484 +++++++++++++++++++++++++++++++++
 drivers/vhost/vdpa.c                   |  16 +-
 drivers/vhost/vringh.c                 |  69 +++--
 drivers/virtio/virtio_balloon.c        |   2 +-
 drivers/virtio/virtio_pci_modern.c     |  27 +-
 drivers/virtio/virtio_pci_modern_dev.c |  67 ++++-
 include/linux/vdpa.h                   |  42 +--
 include/linux/virtio_pci_modern.h      |  11 +-
 include/linux/vringh.h                 |  19 +-
 23 files changed, 1295 insertions(+), 172 deletions(-)
 create mode 100644 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
 create mode 100644 drivers/vdpa/virtio_pci/Makefile
 create mode 100644 drivers/vdpa/virtio_pci/vp_vdpa.c

