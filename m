Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6FF5F0F6C
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiI3P7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 11:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiI3P7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 11:59:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D99140D2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 08:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664553579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=s0VdZiYvqssIOHfeT/CymYAuFjYTWH/3Mag29BcynOs=;
        b=aNA2Nw+odSeMwJhvURHsMk2krnNf/xM6GzQfbhT0eNx41TeuYsSPl86SVs3dRv3PXgE4s8
        Kr20FXW9ttv7+FNcJBpwwEgwRhmy2/i0Wnv1N2e80rdYhxu3QhYN36qEeWouvRGLG2+rXj
        TRYP9BgGN+1bPXNMknvPGd0NF5LfzOA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-445-P-rGmW_PPLisc4vNcZBlOg-1; Fri, 30 Sep 2022 11:59:38 -0400
X-MC-Unique: P-rGmW_PPLisc4vNcZBlOg-1
Received: by mail-ed1-f70.google.com with SMTP id t13-20020a056402524d00b00452c6289448so3888364edd.17
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 08:59:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=s0VdZiYvqssIOHfeT/CymYAuFjYTWH/3Mag29BcynOs=;
        b=eC5xDqrkgrW4zXNDjbOYK/Mdl3zMVXXYhrhkzy/7ZbXK43Is/J3oqPcSPAbiAjYIs8
         iRwFr5AB1T9HrfBJrd6Ce7BMmkMNvd7Z0j2PhaHaXaG2crNXgLy5o0prV43KsdYrBFrq
         A3waxrPcOsW30gQaXGe6lB1e+inTocoEIaDGEAD3+9F1+RzOuWiVGZr/emrtfUVfEqVL
         lHwSkVtPqUAzojsmCA4HYDQTki/NQyVWYUlESBzxLd/JiyfWJXCDusn6pFJ4S50r9cGC
         kCTxlwoGvLA5GNrL915bI3xszBi+Gfpzj0YCr+0dE22dUjglLcxZalyxJ7EBaOqXgECX
         /W2A==
X-Gm-Message-State: ACrzQf2JHQ4Ze8OTtzh+gR+fLyvGZzI/6yhhlqKhjvpd1bwTtGFUB2Rj
        n16FzghCeUZ9FN2/0Z+VjvKbYYzAC65bYBszBa1lAZDDAmPWL8Kbu49SASlGQmF4Bsk0TDnHN7B
        msTEq3Y2JkSHTaHx4
X-Received: by 2002:a17:907:9714:b0:783:954a:5056 with SMTP id jg20-20020a170907971400b00783954a5056mr6907768ejc.318.1664553577057;
        Fri, 30 Sep 2022 08:59:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7mz4/tv12OGuGnNdRMo9OH788yzGFfKJb5e2fxoM3bB4V0KuNZAwipaE4zg0MStjxYK9tRiA==
X-Received: by 2002:a17:907:9714:b0:783:954a:5056 with SMTP id jg20-20020a170907971400b00783954a5056mr6907749ejc.318.1664553576855;
        Fri, 30 Sep 2022 08:59:36 -0700 (PDT)
Received: from redhat.com ([2a06:c701:742e:6800:d12a:e12c:77cf:7dd6])
        by smtp.gmail.com with ESMTPSA id 14-20020a170906328e00b00787a6adab7csm1369697ejw.147.2022.09.30.08.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 08:59:36 -0700 (PDT)
Date:   Fri, 30 Sep 2022 11:59:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        acourbot@chromium.org, angus.chen@jaguarmicro.com, elic@nvidia.com,
        helei.sig11@bytedance.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, maxime.coquelin@redhat.com, mst@redhat.com,
        stefanha@redhat.com, suwan.kim027@gmail.com,
        xuanzhuo@linux.alibaba.com
Subject: [GIT PULL] virtio: fixes
Message-ID: <20220930115933-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit f76349cf41451c5c42a99f18a9163377e4b364ff:

  Linux 6.0-rc7 (2022-09-25 14:01:02 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to a43ae8057cc154fd26a3a23c0e8643bef104d995:

  vdpa/mlx5: Fix MQ to support non power of two num queues (2022-09-27 18:32:45 -0400)

----------------------------------------------------------------
virtio: fixes

Some last minute fixes. virtio-blk is the most important one
since it was actually seen in the field, but the rest
of them are small and clearly safe, everything here has
been in next for a while.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Angus Chen (1):
      vdpa/ifcvf: fix the calculation of queuepair

Eli Cohen (1):
      vdpa/mlx5: Fix MQ to support non power of two num queues

Maxime Coquelin (1):
      vduse: prevent uninitialized memory accesses

Suwan Kim (1):
      virtio-blk: Fix WARN_ON_ONCE in virtio_queue_rq()

Xuan Zhuo (1):
      virtio_test: fixup for vq reset

lei he (1):
      virtio-crypto: fix memory-leak

 drivers/block/virtio_blk.c                          | 11 +++++------
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c |  4 ++++
 drivers/vdpa/ifcvf/ifcvf_base.c                     |  4 ++--
 drivers/vdpa/mlx5/net/mlx5_vnet.c                   | 17 ++++++++++-------
 drivers/vdpa/vdpa_user/vduse_dev.c                  |  9 +++++++--
 tools/virtio/linux/virtio.h                         |  3 +++
 tools/virtio/linux/virtio_config.h                  |  5 +++++
 7 files changed, 36 insertions(+), 17 deletions(-)

