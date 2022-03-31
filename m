Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C44F4EDAE2
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 15:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbiCaNuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 09:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237037AbiCaNuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 09:50:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEEE7CC6
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 06:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648734505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=bBNe6ZwO14A+VdUorhiFqNd6kC6eQKqel5DMkynNcGs=;
        b=AbQNSk7Yw68zwCkKw0EX0j6DjESKKjczVfaXPLfGIsFTlsnbMURk5gqWb2VOztkZhEnHt0
        lx837unlAL+C3DN+F+p2uCk54WH0k2LT5cp6QPDmUnFmPDsZypEqLuRBV3kn6nutATFooQ
        ylSNQHk6S9Znz0WsOxGyJduy5U/nB/o=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-FGqQ3DOdNk2xQtxxhrmj2g-1; Thu, 31 Mar 2022 09:48:24 -0400
X-MC-Unique: FGqQ3DOdNk2xQtxxhrmj2g-1
Received: by mail-ed1-f69.google.com with SMTP id x5-20020a50ba85000000b00418e8ce90ffso14957386ede.14
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 06:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=bBNe6ZwO14A+VdUorhiFqNd6kC6eQKqel5DMkynNcGs=;
        b=vDkJ/xZQ3KQIMLpWh2VnCIHz7G71QN2bsn46y6orfWS1WDwDmi2qe5fkkeVVIq0igB
         sognwL+Tej1s4cotWrjoQX11b8MeMFgeZ2cuNcA9PvAhMKXLOyfvarTQUqs/LCkjDWos
         ZXeE1AUc6QrBpc48yVmbdMx+pXGJXixlM8Hp2ID5KTm5jRouuQKbB5QVcgQhowMCdqBH
         PTwoPKnlUjWz9H5sTl9BNHwm3FeZB1d71amoAG+2hNv+YkzGY1+Tp78eexVyUsObLpAq
         FjWRmM6GRpoFf/XlA4jMFH2JWJRPc3WBb/zQMLmWuVIVRGFNZoiP9U7Wnc0kn4Pcq5aP
         6p2A==
X-Gm-Message-State: AOAM5304VPweRb0I4ctMlg4qXRY56K+N6rrKjl/DSMH77dgV+JZneQ6K
        J/lLJ2n76XxpGJhEkvKq8zbFo1FnvncAiv9myh/ideyO5ViqhfI2SoPvVrxTxw6ND0YtXlPEuwl
        BXECPwIAn1cOmd77F
X-Received: by 2002:a17:906:69d1:b0:6ce:7201:ec26 with SMTP id g17-20020a17090669d100b006ce7201ec26mr5115660ejs.105.1648734501766;
        Thu, 31 Mar 2022 06:48:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaOztpuiraqUm6TPegDkLmbLYAkWCcmmS2jBymLmYa/zJNRyuCbXtPFJnMPQ//0YMBauubEw==
X-Received: by 2002:a17:906:69d1:b0:6ce:7201:ec26 with SMTP id g17-20020a17090669d100b006ce7201ec26mr5115639ejs.105.1648734501541;
        Thu, 31 Mar 2022 06:48:21 -0700 (PDT)
Received: from redhat.com ([2.53.153.13])
        by smtp.gmail.com with ESMTPSA id h8-20020a1709066d8800b006e09a49a713sm8018933ejt.159.2022.03.31.06.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 06:48:21 -0700 (PDT)
Date:   Thu, 31 Mar 2022 09:48:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@daynix.com, david@redhat.com, elic@nvidia.com,
        gautam.dawar@xilinx.com, gdawar@xilinx.com, gshan@redhat.com,
        helei.sig11@bytedance.com, jasowang@redhat.com,
        Jonathan.Cameron@huawei.com, keirf@google.com,
        lingshan.zhu@intel.com, linmiaohe@huawei.com, lkp@intel.com,
        longpeng2@huawei.com, mail@anirudhrb.com, maz@kernel.org,
        mst@redhat.com, nathan@kernel.org, pizhenwei@bytedance.com,
        qiudayu@archeros.com, sgarzare@redhat.com, trix@redhat.com,
        willy@infradead.org, xuanzhuo@linux.alibaba.com
Subject: [GIT PULL] virtio: features, fixes
Message-ID: <20220331094816-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit f443e374ae131c168a065ea1748feac6b2e76613:

  Linux 5.17 (2022-03-20 13:14:17 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to ad6dc1daaf29f97f23cc810d60ee01c0e83f4c6b:

  vdpa/mlx5: Avoid processing works if workqueue was destroyed (2022-03-28 16:54:30 -0400)

----------------------------------------------------------------
virtio: features, fixes

vdpa generic device type support
More virtio hardening for broken devices
On the same theme, revert some virtio hotplug hardening patches -
they were misusing some interrupt flags, will have to be reverted.
RSS support in virtio-net
max device MTU support in mlx5 vdpa
akcipher support in virtio-crypto
shared IRQ support in ifcvf vdpa
a minor performance improvement in vhost
Enable virtio mem for ARM64
beginnings of advance dma support

Cleanups, fixes all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Andrew Melnychenko (4):
      drivers/net/virtio_net: Fixed padded vheader to use v1 with hash.
      drivers/net/virtio_net: Added basic RSS support.
      drivers/net/virtio_net: Added RSS hash report.
      drivers/net/virtio_net: Added RSS hash report control.

Anirudh Rayabharam (1):
      vhost: handle error while adding split ranges to iotlb

Eli Cohen (2):
      net/mlx5: Add support for configuring max device MTU
      vdpa/mlx5: Avoid processing works if workqueue was destroyed

Gautam Dawar (1):
      Add definition of VIRTIO_F_IN_ORDER feature bit

Gavin Shan (1):
      drivers/virtio: Enable virtio mem for ARM64

Jason Wang (2):
      Revert "virtio-pci: harden INTX interrupts"
      Revert "virtio_pci: harden MSI-X interrupts"

Keir Fraser (1):
      virtio: pci: check bar values read from virtio config space

Longpeng (3):
      vdpa: support exposing the config size to userspace
      vdpa: change the type of nvqs to u32
      vdpa: support exposing the count of vqs to userspace

Miaohe Lin (1):
      mm/balloon_compaction: make balloon page compaction callbacks static

Michael Qiu (1):
      vdpa/mlx5: re-create forwarding rules after mac modified

Michael S. Tsirkin (2):
      tools/virtio: fix after premapped buf support
      tools/virtio: compile with -pthread

Stefano Garzarella (2):
      vhost: cache avail index in vhost_enable_notify()
      virtio: use virtio_device_ready() in virtio_device_restore()

Xuan Zhuo (3):
      virtio_ring: rename vring_unmap_state_packed() to vring_unmap_extra_packed()
      virtio_ring: remove flags check for unmap split indirect desc
      virtio_ring: remove flags check for unmap packed indirect desc

Zhu Lingshan (5):
      vDPA/ifcvf: make use of virtio pci modern IO helpers in ifcvf
      vhost_vdpa: don't setup irq offloading when irq_num < 0
      vDPA/ifcvf: implement device MSIX vector allocator
      vDPA/ifcvf: implement shared IRQ feature
      vDPA/ifcvf: cacheline alignment for ifcvf_hw

zhenwei pi (4):
      virtio_crypto: Introduce VIRTIO_CRYPTO_NOSPC
      virtio-crypto: introduce akcipher service
      virtio-crypto: implement RSA algorithm
      virtio-crypto: rename skcipher algs

 drivers/crypto/virtio/Kconfig                      |   3 +
 drivers/crypto/virtio/Makefile                     |   3 +-
 .../crypto/virtio/virtio_crypto_akcipher_algs.c    | 585 +++++++++++++++++++++
 drivers/crypto/virtio/virtio_crypto_common.h       |   7 +-
 drivers/crypto/virtio/virtio_crypto_core.c         |   6 +-
 drivers/crypto/virtio/virtio_crypto_mgr.c          |  17 +-
 ...crypto_algs.c => virtio_crypto_skcipher_algs.c} |   4 +-
 drivers/net/virtio_net.c                           | 389 +++++++++++++-
 drivers/vdpa/ifcvf/ifcvf_base.c                    | 140 ++---
 drivers/vdpa/ifcvf/ifcvf_base.h                    |  24 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    | 323 ++++++++++--
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  84 ++-
 drivers/vdpa/vdpa.c                                |   6 +-
 drivers/vhost/iotlb.c                              |   6 +-
 drivers/vhost/vdpa.c                               |  45 +-
 drivers/vhost/vhost.c                              |   3 +-
 drivers/virtio/Kconfig                             |   7 +-
 drivers/virtio/virtio.c                            |   5 +-
 drivers/virtio/virtio_pci_common.c                 |  48 +-
 drivers/virtio/virtio_pci_common.h                 |   7 +-
 drivers/virtio/virtio_pci_legacy.c                 |   5 +-
 drivers/virtio/virtio_pci_modern.c                 |  18 +-
 drivers/virtio/virtio_pci_modern_dev.c             |   9 +-
 drivers/virtio/virtio_ring.c                       |  53 +-
 include/linux/balloon_compaction.h                 |  22 -
 include/linux/vdpa.h                               |   9 +-
 include/uapi/linux/vhost.h                         |   7 +
 include/uapi/linux/virtio_config.h                 |   6 +
 include/uapi/linux/virtio_crypto.h                 |  82 ++-
 mm/balloon_compaction.c                            |   6 +-
 tools/virtio/Makefile                              |   3 +-
 tools/virtio/linux/dma-mapping.h                   |   4 +-
 32 files changed, 1639 insertions(+), 297 deletions(-)
 create mode 100644 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
 rename drivers/crypto/virtio/{virtio_crypto_algs.c => virtio_crypto_skcipher_algs.c} (99%)

