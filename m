Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171B855CE97
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238549AbiF0PvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 11:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237670AbiF0PvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 11:51:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A763193CB
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 08:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656345059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=d2N3t1uLLFd3tbeSCYzNndzlSKHoLHoiZV7zauWsqwQ=;
        b=C/b4th0PE0PHJNnpXgaVNfOfFzHFIOHjLuWTiikrfeY4hdcQ74ECeBDIwL8hH3Jfzmw0Fq
        hcJw+d3COWN+wMN9V9OmgsuWsYu5MRwUwGg8MJh/N/cZp57e3jHgC04rNTuYB5qR6aYye9
        M5w8kuhRVDAaRfL9OiHzamdVU6v2d1I=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-zlzB_azONVC1JdCzhPDR3A-1; Mon, 27 Jun 2022 11:50:38 -0400
X-MC-Unique: zlzB_azONVC1JdCzhPDR3A-1
Received: by mail-ed1-f70.google.com with SMTP id v16-20020a056402349000b00435a1c942a9so7516447edc.15
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 08:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=d2N3t1uLLFd3tbeSCYzNndzlSKHoLHoiZV7zauWsqwQ=;
        b=L+ro74Sq1OKzfQsJDGhhPq3eyD8OqN9RDfp17ZUNDhusp99lhI0MYifofGOkbYgh0m
         R9GS+z2NeCTay9G+CTnziBcmQMt/nb6ThP1Lnrm9MMLMtHBnYe3NVXFE4k0wFA6gz/D3
         AOHTvs4+g1hDNEnl6v0iZR3r30PZI5i/VYIFV1FQS34WlvOusFEU/fFEjSFi2jX2f/b1
         Yham2YIQgavXrehxtBtRzT2w9LXTjM+N5PxF9MynMD5LVInyR8ZsxjLGxazjX5H5Y/2s
         ngG7TNYfNrsatVtGccYyYdRQ72nUeLySzjWPjsbPeT76VpSCVakuZ7YtAGT2trBeB3qb
         gMiQ==
X-Gm-Message-State: AJIora/yWbDuztibjfTY7dbVwuMS7zldtqwt9QqUWPrpvp4Dep7XQI34
        /d059sKC8It1ypnjYDGItAzbcRY8ku9tQG5zyyG4YSaOFRtTcvUY43OFIUiExTwLI8Ygl23Fifq
        Fkp8Ft0gc2WUU7Ujh
X-Received: by 2002:a05:6402:2929:b0:435:6dfc:c4f2 with SMTP id ee41-20020a056402292900b004356dfcc4f2mr17235989edb.284.1656345034861;
        Mon, 27 Jun 2022 08:50:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t9WduttwuVIwVX53FDNgXbP08lIvO3IwG/IkW/gZFLxJ/LK30Gor89dpwiWdlE1Y3HvzMjUQ==
X-Received: by 2002:a05:6402:2929:b0:435:6dfc:c4f2 with SMTP id ee41-20020a056402292900b004356dfcc4f2mr17235967edb.284.1656345034631;
        Mon, 27 Jun 2022 08:50:34 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207e:1f30:b6f8:324d:b101:20ff])
        by smtp.gmail.com with ESMTPSA id c20-20020a056402101400b004358cec9ce1sm7776739edu.65.2022.06.27.08.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 08:50:33 -0700 (PDT)
Date:   Mon, 27 Jun 2022 11:50:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        huangjie.albert@bytedance.com, jasowang@redhat.com,
        liubo03@inspur.com, mst@redhat.com, parav@nvidia.com,
        sgarzare@redhat.com, stephan.gerhold@kernkonzept.com,
        wangdeming@inspur.com
Subject: [GIT PULL] virtio,vdpa: fixes
Message-ID: <20220627115024-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit a111daf0c53ae91e71fd2bfe7497862d14132e3e:

  Linux 5.19-rc3 (2022-06-19 15:06:47 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to c7cc29aaebf9eaa543b4c70801e0ecef1101b3c8:

  virtio_ring: make vring_create_virtqueue_split prettier (2022-06-27 08:05:35 -0400)

----------------------------------------------------------------
virtio,vdpa: fixes

Fixes all over the place, most notably we are disabling
IRQ hardening (again!).

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Bo Liu (1):
      virtio: Remove unnecessary variable assignments

Deming Wang (1):
      virtio_ring: make vring_create_virtqueue_split prettier

Eli Cohen (2):
      vdpa/mlx5: Update Control VQ callback information
      vdpa/mlx5: Initialize CVQ vringh only once

Jason Wang (3):
      virtio: disable notification hardening by default
      virtio-net: fix race between ndo_open() and virtio_device_ready()
      caif_virtio: fix race between virtio_device_ready() and ndo_open()

Parav Pandit (1):
      vduse: Tie vduse mgmtdev and its device

Stefano Garzarella (1):
      vhost-vdpa: call vhost_vdpa_cleanup during the release

Stephan Gerhold (2):
      virtio_mmio: Add missing PM calls to freeze/restore
      virtio_mmio: Restore guest page size on resume

huangjie.albert (1):
      virtio_ring : keep used_wrap_counter in vq->last_used_idx

 drivers/net/caif/caif_virtio.c         | 10 +++-
 drivers/net/virtio_net.c               |  8 ++-
 drivers/s390/virtio/virtio_ccw.c       |  9 +++-
 drivers/vdpa/mlx5/net/mlx5_vnet.c      | 33 ++++++++-----
 drivers/vdpa/vdpa_user/vduse_dev.c     | 60 ++++++++++++++---------
 drivers/vhost/vdpa.c                   |  2 +-
 drivers/virtio/Kconfig                 | 13 +++++
 drivers/virtio/virtio.c                |  2 +
 drivers/virtio/virtio_mmio.c           | 26 ++++++++++
 drivers/virtio/virtio_pci_modern_dev.c |  2 -
 drivers/virtio/virtio_ring.c           | 89 +++++++++++++++++++++++-----------
 include/linux/virtio_config.h          |  2 +
 12 files changed, 187 insertions(+), 69 deletions(-)

