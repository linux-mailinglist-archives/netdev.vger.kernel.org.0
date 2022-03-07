Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959194CFCC3
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 12:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbiCGL1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 06:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242004AbiCGL1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 06:27:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6CA449F33
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 03:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646651019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=gNPPt7IcCgazViAJnPdJB9z9Owb+g+PUdYAZ9hinRqk=;
        b=gHCdzeOPcngl7boIMhqjUqDWcRNyq+HQWw/c9+Ehhd/lvK+RkdIL2n3z8dgOIg7mk1t4y5
        RJdfPGMtIkUooI0ZgKjMKJ0jpL+PMsHs5CiqIM6xbQ7qFzmlHJJ0PGptuvbYHQlwnPdJID
        1S6b7I83Z9/LhjTMy/391ccELCrM+bQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-THHxeabfO5yoovhGGF6WbQ-1; Mon, 07 Mar 2022 06:03:38 -0500
X-MC-Unique: THHxeabfO5yoovhGGF6WbQ-1
Received: by mail-ed1-f71.google.com with SMTP id x5-20020a50ba85000000b004161d68ace6so3284562ede.15
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 03:03:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=gNPPt7IcCgazViAJnPdJB9z9Owb+g+PUdYAZ9hinRqk=;
        b=CEqFasDcKf8sCRBAbJ4MQO3ZNNn69VISHS5bNBCgUeE7c/uico/Vpjlo1S5/s9bdr1
         ertEtIgYB/bEC+KpxhTUHWNvf2Gu5+aw2pECQF7gnuDOnjvgn5LfwFI2J3qVioep3YA8
         v5b2kCJf+ab/xHDmj1C9BdojU4GSjVFykmBQbStzsHe61x7BD4SqgzaC7iKU8u20LeWq
         h3z8crtqoV7etw5mqUdQH5ONa6d2oIDvFY1qMcPxdlW5cF6mzdXzx1P6dwtmCIx4oBkr
         hi+KHQSs372KG3Pe7x7dDp3cb/FoZcUGcdY1zePOJLSMRCpXsgR/cXyKG7PVQbx7471Q
         GJ0A==
X-Gm-Message-State: AOAM533+2kE05e+Atmtt0LBJeCmXbQb5aa/Smb6f75UhqKo5/t7js3PP
        y+jWec8H2kzFQBIFj282HdtstYlGHPz0aomS4VqAhqTCNhZgDrla5HvbBytc9t9/eVztZLeT+0n
        Fda90zrlHGGTp2fzL
X-Received: by 2002:a05:6402:1e91:b0:415:ecdb:bb42 with SMTP id f17-20020a0564021e9100b00415ecdbbb42mr10485774edf.367.1646651017437;
        Mon, 07 Mar 2022 03:03:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzm045HAXHomDdQ4eh2BMpTcblB2cVV+JVDBoNGC3+rpUKylFjFOJZk78RZ+xJFhn3Hw+5UaQ==
X-Received: by 2002:a05:6402:1e91:b0:415:ecdb:bb42 with SMTP id f17-20020a0564021e9100b00415ecdbbb42mr10485752edf.367.1646651017235;
        Mon, 07 Mar 2022 03:03:37 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id er12-20020a056402448c00b00413d03ac4a2sm5718316edb.69.2022.03.07.03.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 03:03:36 -0800 (PST)
Date:   Mon, 7 Mar 2022 06:03:32 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, david@redhat.com, jasowang@redhat.com,
        lkp@intel.com, mail@anirudhrb.com, mst@redhat.com,
        pasic@linux.ibm.com, sgarzare@redhat.com, si-wei.liu@oracle.com,
        stable@vger.kernel.org,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        wang.yi59@zte.com.cn, xieyongji@bytedance.com,
        zhang.min9@zte.com.cn
Subject: [GIT PULL] virtio: last minute fixes
Message-ID: <20220307060332-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 7e57714cd0ad2d5bb90e50b5096a0e671dec1ef3:

  Linux 5.17-rc6 (2022-02-27 14:36:33 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 3dd7d135e75cb37c8501ba02977332a2a487dd39:

  tools/virtio: handle fallout from folio work (2022-03-06 06:06:50 -0500)

----------------------------------------------------------------
virtio: last minute fixes

Some fixes that took a while to get ready. Not regressions,
but they look safe and seem to be worth to have.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Anirudh Rayabharam (1):
      vhost: fix hung thread due to erroneous iotlb entries

Michael S. Tsirkin (6):
      virtio: unexport virtio_finalize_features
      virtio: acknowledge all features before access
      virtio: document virtio_reset_device
      virtio_console: break out of buf poll on remove
      virtio: drop default for virtio-mem
      tools/virtio: handle fallout from folio work

Si-Wei Liu (3):
      vdpa: factor out vdpa_set_features_unlocked for vdpa internal use
      vdpa/mlx5: should verify CTRL_VQ feature exists for MQ
      vdpa/mlx5: add validation for VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET command

Stefano Garzarella (2):
      vhost: remove avail_event arg from vhost_update_avail_event()
      tools/virtio: fix virtio_test execution

Xie Yongji (3):
      vduse: Fix returning wrong type in vduse_domain_alloc_iova()
      virtio-blk: Don't use MAX_DISCARD_SEGMENTS if max_discard_seg is zero
      virtio-blk: Remove BUG_ON() in virtio_queue_rq()

Zhang Min (1):
      vdpa: fix use-after-free on vp_vdpa_remove

 drivers/block/virtio_blk.c           | 20 ++++++-------
 drivers/char/virtio_console.c        |  7 +++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c    | 34 ++++++++++++++++++++--
 drivers/vdpa/vdpa.c                  |  2 +-
 drivers/vdpa/vdpa_user/iova_domain.c |  2 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c    |  2 +-
 drivers/vhost/iotlb.c                | 11 +++++++
 drivers/vhost/vdpa.c                 |  2 +-
 drivers/vhost/vhost.c                |  9 ++++--
 drivers/virtio/Kconfig               |  1 -
 drivers/virtio/virtio.c              | 56 ++++++++++++++++++++++++------------
 drivers/virtio/virtio_vdpa.c         |  2 +-
 include/linux/vdpa.h                 | 18 ++++++++----
 include/linux/virtio.h               |  1 -
 include/linux/virtio_config.h        |  3 +-
 tools/virtio/linux/mm_types.h        |  3 ++
 tools/virtio/virtio_test.c           |  1 +
 17 files changed, 127 insertions(+), 47 deletions(-)
 create mode 100644 tools/virtio/linux/mm_types.h

