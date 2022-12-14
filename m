Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E3764CE07
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbiLNQbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238774AbiLNQbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:31:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CA46277
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671035431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MvzKkMsF15Ii2v8T6zm7fsybd7ToFL1MzDuE6XhV9TM=;
        b=V+qT101Cch3PYQ3AfepLCnAGvWi20veldxUwzMFigTJNLsR4iE9OJaWByy8PFZxd4lNjdt
        lFUDZ5cSR5hip/uNoxNkRXPe9s4BS9Ix/Eio6h/AdXSOHJ7Bl2mfrjOH0nRphALRw7CGHy
        +lkuMm1FGdlVCYW+5PjtOnWr0noh/yw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-600-pquE-wBJP7OH8gEjZmqanA-1; Wed, 14 Dec 2022 11:30:29 -0500
X-MC-Unique: pquE-wBJP7OH8gEjZmqanA-1
Received: by mail-wm1-f71.google.com with SMTP id i9-20020a1c3b09000000b003d21fa95c38so4648607wma.3
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:30:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MvzKkMsF15Ii2v8T6zm7fsybd7ToFL1MzDuE6XhV9TM=;
        b=kCI+nONmeL9Ak3bPmEcSozk1AXLi1sX1XtM7ykw2ZrsX59ggJhV/9cTzTbNms1Npeh
         OcBKHCKY3vJGlAMdKAWzUvjS1WRj51BbJRJCEphDowoxu3rRByLSRma7Xx1ceKvg8yUs
         o2INHjIv7816px4PfTa4F5egE8UhBTcbUbAdU6oUFGNiAbdAkQ2ZM4ZjJ13xy5R97T8o
         ybeyywEEHp+9nwngSO5Wf7i3OgYFUQ1y76Ey+J6Fag36SR62MKIE6I2g2G+XuSCY5CZU
         ak5fUzs+MdHFg727/gXjpZ+SKzaZooVYhLyTXXgxo/hjfs8wfT2ib7BN4yVIXRPsWNdV
         6ANw==
X-Gm-Message-State: ANoB5pkGHZIac4OOZALsoHgvmuQ9LN2ermgB8lY1CPHKr9aNd2BIuUqg
        z5cRe0MOMks0f6j4AlV1CjiHtTSENh6+0Zfx1flfPyfspFdYrLoLmmQKsj3Wlvk3wOxBU+f6gJG
        wgbrO/TVMIr2HhHHK
X-Received: by 2002:a5d:470a:0:b0:242:d4f:96c with SMTP id y10-20020a5d470a000000b002420d4f096cmr15025773wrq.0.1671035428443;
        Wed, 14 Dec 2022 08:30:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4GfaS136t9dUD0TzONcVTtwml5/pPsXD/CEUDFgE57pufF23Sy+4PdxYOWCLOsS1OfTnwS5w==
X-Received: by 2002:a5d:470a:0:b0:242:d4f:96c with SMTP id y10-20020a5d470a000000b002420d4f096cmr15025759wrq.0.1671035428229;
        Wed, 14 Dec 2022 08:30:28 -0800 (PST)
Received: from step1.redhat.com (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id e17-20020adffd11000000b002422816aa25sm3791759wrr.108.2022.12.14.08.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 08:30:27 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com,
        stefanha@redhat.com, netdev@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [RFC PATCH 0/6] vdpa_sim: add support for user VA
Date:   Wed, 14 Dec 2022 17:30:19 +0100
Message-Id: <20221214163025.103075-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the use of user virtual addresses in the
vDPA simulator devices.

The main reason for this change is to lift the pinning of all guest memory.
Especially with virtio devices implemented in software.

The next step would be to generalize the code in vdpa-sim to allow the
implementation of in-kernel software devices. Similar to vhost, but using vDPA
so we can reuse the same software stack (e.g. in QEMU) for both HW and SW
devices.

For example, we have never merged vhost-blk, and lately there has been interest.
So it would be nice to do it directly with vDPA to reuse the same code in the
VMM for both HW and SW vDPA block devices.

The main problem (addressed by this series) was due to the pinning of all
guest memory, which thus prevented the overcommit of guest memory.

There are still some TODOs to be fixed, but I would like to have your feedback
on this RFC.

Thanks,
Stefano

Note: this series is based on Linux v6.1 + couple of fixes (that I needed to
run libblkio tests) already posted but not yet merged.

Tree available here: https://gitlab.com/sgarzarella/linux/-/tree/vdpa-sim-use-va

Stefano Garzarella (6):
  vdpa: add bind_mm callback
  vhost-vdpa: use bind_mm device callback
  vringh: support VA with iotlb
  vdpa_sim: make devices agnostic for work management
  vdpa_sim: use kthread worker
  vdpa_sim: add support for user VA

 drivers/vdpa/vdpa_sim/vdpa_sim.h     |   7 +-
 include/linux/vdpa.h                 |   8 +
 include/linux/vringh.h               |   5 +-
 drivers/vdpa/mlx5/core/resources.c   |   3 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c    |   2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 132 +++++++++++++-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |   6 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |   6 +-
 drivers/vhost/vdpa.c                 |  22 +++
 drivers/vhost/vringh.c               | 250 +++++++++++++++++++++------
 10 files changed, 370 insertions(+), 71 deletions(-)

-- 
2.38.1

