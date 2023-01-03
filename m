Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6080E65C359
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 16:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjACPvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 10:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237609AbjACPu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 10:50:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D901260C
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 07:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672761008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WC94+qRtcsQoAZV6EJBwTDdUsyIqcyvTkPy2eHYVDF8=;
        b=OFyURnmbFg0cC+vNLuzrbt1KiNpz9JvFigltZ8RIt2XZvWSuz0ISdsbdzn13jMMVYU9KNE
        ncMV09k+GbRFdNTuqLMdiDBffzbFcXujmIKzxhRu6qCNOKtwerGnnTj8vYr06lbwav59UK
        9bDDgOalmseCl9MVfnqrlVeR0Y7sTAU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-477-IRsdk0x9MYax08LphXxvOQ-1; Tue, 03 Jan 2023 10:49:53 -0500
X-MC-Unique: IRsdk0x9MYax08LphXxvOQ-1
Received: by mail-wm1-f71.google.com with SMTP id j1-20020a05600c1c0100b003d99070f529so10984426wms.9
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 07:49:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WC94+qRtcsQoAZV6EJBwTDdUsyIqcyvTkPy2eHYVDF8=;
        b=Gj1O7Wol/ycYJ2L8rsGWDadqo7kqjOWMz5lwIn/hDkwDaDP7DrBxMVwWwZHWczGT3o
         LHz0vA2eECeMJrq+Nd7LF6+AdU3epet0u2r7cd+FbCWupdQ0kb4VdBZUG1PyVG9bSFSD
         2JLPfCkUV1IdbB5XmYmXdqV8uq9ZB5cbU+IdNg2i7w2h5yiPlLWzBvVxPEK3zbjJ7bHm
         5yPCtUZzAEdQBW7GYoSLeIY2bpkt+rqGsDjTHdRhQyaxzuUbcR7T1lCht0McUj6hWvGZ
         Heg433QWsWC5CUNvtclkeVTZKfrDpp4sveouoB/4e3TOkSOMwTWBJ6yvB+FZit7epCtJ
         /2jg==
X-Gm-Message-State: AFqh2kou6jU83ObXDfTYyVtP9T87yqqOxwE4FFZMCopKHCDM8Zc9nfx/
        5Hx3KPA5MIvwu/75m4crPwPOj/VCQJyOUfcOXfJvcaJtNvEYXOsEJ5VxzWGc3QTp5BEQ0sZzt1N
        w/TjCNd/Tn7vK3w/Q
X-Received: by 2002:a05:600c:4fcf:b0:3d1:d396:1ade with SMTP id o15-20020a05600c4fcf00b003d1d3961ademr31416058wmq.9.1672760992124;
        Tue, 03 Jan 2023 07:49:52 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvBokw4ntbihohzRlAT/7Kd2Eqgl7eiuIEN+Pul08FB9XjA5yr3GOYK70ZuUvwnVXP0KlLXRw==
X-Received: by 2002:a05:600c:4fcf:b0:3d1:d396:1ade with SMTP id o15-20020a05600c4fcf00b003d1d3961ademr31416049wmq.9.1672760991925;
        Tue, 03 Jan 2023 07:49:51 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id r10-20020a05600c458a00b003d9a86a13bfsm15382532wmo.28.2023.01.03.07.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 07:49:51 -0800 (PST)
Date:   Tue, 3 Jan 2023 10:49:46 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        angus.chen@jaguarmicro.com, colin.i.king@gmail.com,
        dave@stgolabs.net, dengshaomin@cdjrlc.com, dmitry.fomichev@wdc.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        harshit.m.mogalapalli@oracle.com, jasowang@redhat.com,
        lulu@redhat.com, mst@redhat.com, pizhenwei@bytedance.com,
        rafaelmendsr@gmail.com, ricardo.canuelo@collabora.com,
        ruanjinjie@huawei.com, set_pte_at@outlook.com, sgarzare@redhat.com,
        shaoqin.huang@intel.com, si-wei.liu@oracle.com,
        stable@vger.kernel.org, sunnanyong@huawei.com,
        wangjianli@cdjrlc.com, wangrong68@huawei.com,
        weiyongjun1@huawei.com, yuancan@huawei.com
Subject: [GIT PULL v2] virtio,vhost,vdpa: fixes, cleanups
Message-ID: <20230103104946-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These fixes have been in next, though not as these commits.

I'd like to apologize again to contributors for missing the merge
window with new features. These by necessity have been pushed out
to the next merge window. This pull only has bugfixes.

I put automation in place to help prevent missing merge window
in the future.

The following changes since commit 1b929c02afd37871d5afb9d498426f83432e71c2:

  Linux 6.2-rc1 (2022-12-25 13:41:39 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to a26116c1e74028914f281851488546c91cbae57d:

  virtio_blk: Fix signedness bug in virtblk_prep_rq() (2022-12-28 05:28:11 -0500)

----------------------------------------------------------------
virtio,vhost,vdpa: fixes, cleanups

mostly fixes all over the place, a couple of cleanups.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Angus Chen (2):
      virtio_pci: modify ENOENT to EINVAL
      virtio_blk: use UINT_MAX instead of -1U

Cindy Lu (2):
      vhost_vdpa: fix the crash in unmap a large memory
      vdpa_sim_net: should not drop the multicast/broadcast packet

Colin Ian King (1):
      RDMA/mlx5: remove variable i

Davidlohr Bueso (2):
      tools/virtio: remove stray characters
      tools/virtio: remove smp_read_barrier_depends()

Dawei Li (1):
      virtio: Implementing attribute show with sysfs_emit

Dmitry Fomichev (1):
      virtio-blk: use a helper to handle request queuing errors

Eli Cohen (5):
      vdpa/mlx5: Fix rule forwarding VLAN to TIR
      vdpa/mlx5: Return error on vlan ctrl commands if not supported
      vdpa/mlx5: Fix wrong mac address deletion
      vdpa/mlx5: Avoid using reslock in event_handler
      vdpa/mlx5: Avoid overwriting CVQ iotlb

Harshit Mogalapalli (1):
      vduse: Validate vq_num in vduse_validate_config()

Jason Wang (2):
      vdpa: conditionally fill max max queue pair for stats
      vdpasim: fix memory leak when freeing IOTLBs

Rafael Mendonca (1):
      virtio_blk: Fix signedness bug in virtblk_prep_rq()

Ricardo Cañuelo (1):
      tools/virtio: initialize spinlocks in vring_test.c

Rong Wang (1):
      vdpa/vp_vdpa: fix kfree a wrong pointer in vp_vdpa_remove

Shaomin Deng (1):
      tools: Delete the unneeded semicolon after curly braces

Shaoqin Huang (2):
      virtio_pci: use helper function is_power_of_2()
      virtio_ring: use helper function is_power_of_2()

Si-Wei Liu (1):
      vdpa: merge functionally duplicated dev_features attributes

Stefano Garzarella (4):
      vringh: fix range used in iotlb_translate()
      vhost: fix range used in translate_desc()
      vhost-vdpa: fix an iotlb memory leak
      vdpa_sim: fix vringh initialization in vdpasim_queue_ready()

Wei Yongjun (1):
      virtio-crypto: fix memory leak in virtio_crypto_alg_skcipher_close_session()

Yuan Can (1):
      vhost/vsock: Fix error handling in vhost_vsock_init()

ruanjinjie (1):
      vdpa_sim: fix possible memory leak in vdpasim_net_init() and vdpasim_blk_init()

wangjianli (1):
      tools/virtio: Variable type completion

 drivers/block/virtio_blk.c                         | 35 +++++-----
 .../crypto/virtio/virtio_crypto_skcipher_algs.c    |  3 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |  5 +-
 drivers/vdpa/mlx5/core/mr.c                        | 46 +++++++------
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  | 78 +++++++---------------
 drivers/vdpa/vdpa.c                                | 11 ++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |  7 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |  4 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c               |  7 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  3 +
 drivers/vdpa/virtio_pci/vp_vdpa.c                  |  2 +-
 drivers/vhost/vdpa.c                               | 52 +++++++++------
 drivers/vhost/vhost.c                              |  4 +-
 drivers/vhost/vringh.c                             |  5 +-
 drivers/vhost/vsock.c                              |  9 ++-
 drivers/virtio/virtio.c                            | 12 ++--
 drivers/virtio/virtio_pci_modern.c                 |  4 +-
 drivers/virtio/virtio_ring.c                       |  2 +-
 include/uapi/linux/vdpa.h                          |  4 +-
 tools/virtio/ringtest/main.h                       | 37 +++++-----
 tools/virtio/virtio-trace/trace-agent-ctl.c        |  2 +-
 tools/virtio/virtio_test.c                         |  2 +-
 tools/virtio/vringh_test.c                         |  2 +
 23 files changed, 173 insertions(+), 163 deletions(-)

