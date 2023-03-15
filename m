Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF956BC189
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbjCOXgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjCOXfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:35:32 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89812A908A
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:34:20 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id d5-20020a17090ac24500b0023cb04ec86fso1613559pjx.7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678923197;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zzefk8SgM3BvZ7E023tVeRnVZ4q/QzzbfoKhkPy9ACo=;
        b=I7rl66G4dGT1Mu35njeaP+R8M6YP7aCOCbG+VylUjLftGXEK3ea049jBz5aG1mGvbc
         0oA/fl9NHqmlUP7HdOWKjz/6IE+oa5uyUh91T/p3Sj/bI5mWe1zZmtlIxPWd3DUVGVTT
         mgavqOSYaD+xFPl3ejJeHS6IhIvmF/qchNzx4PvM4a9boC5DP8Xjk3MzgObfjifwIVtb
         mIbrxu5uKCxn+/DgJwMuJsi7jnKAm0IqrO/ZUhp5YCuF6LK8CgzZ8hKKE3nXadjOMjNL
         wkbJf7EbiJZVEtgz4Cjt4klzFfd6z7TaZLV6Yh/rjE3zenMmtx1GRtD89lx5K77fqAtw
         XbCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678923197;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zzefk8SgM3BvZ7E023tVeRnVZ4q/QzzbfoKhkPy9ACo=;
        b=mHed5/NrU+ydjHixISzkteMz/EjTyUdB5g+b7nUhJpSfDymCd6u2R1Joezsl7p2G5C
         +9wlGkDtOsy0Reh5k+I8ff+YgjFzPbqpT8Nubq+aVlPS2QdWzvVfF77Cp9PYmMds76/H
         IxYoyNCNXyl1/eeC/4HUgvoFoHsX5PP584v7HojVmtAVL1Ab62InF12WXqu/RCM+i2uv
         g+TfydHw0SK/+Q0Ri2s1POKnwIow8AY8EyvzFiYIuI9BAimkc9yzsEMiO2ArXkVoXpxU
         Dx/+Epe8Qtn08rr3QC1RoZGvI1bHmunvK3J5+A4hcwlkykvticSWhkJpsJWMy255dgza
         Fyng==
X-Gm-Message-State: AO0yUKWQAoDfIPhOfBrUVk/NQh38PpuIqqhPJmUGQosnRwXDTKaAOgvi
        r5De7UdAEa/SlJNwz7DhOnyf4q75ptWOFY6I2NyvXWHByLEem3YkCQeCcMAg0exI2o/briwaXxw
        cPn6AjRiERXt9iHbeTlwK8PM0ZDup6OzaaGWwpA3MJyugxWsuYakqmwSefO9UuiYTboOLSy2NJw
        cjgg==
X-Google-Smtp-Source: AK7set/E/KPW1nmfuDbmobmvAL41UcidNL2nH20X69kIAILeVgEGz84TXdQOMrm3MMivnEUa13iuLljd/vWhFA3OBqo=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:736f:ac28:dd71:480f])
 (user=pkaligineedi job=sendgmr) by 2002:a05:6a00:1d98:b0:5a8:aaa1:6c05 with
 SMTP id z24-20020a056a001d9800b005a8aaa16c05mr678890pfw.2.1678923197289; Wed,
 15 Mar 2023 16:33:17 -0700 (PDT)
Date:   Wed, 15 Mar 2023 16:33:07 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315233312.568731-1-pkaligineedi@google.com>
Subject: [PATCH net-next v4 0/5] gve: Add XDP support for GQI-QPL format
From:   Praveen Kaligineedi <pkaligineedi@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michal.kubiak@intel.com,
        maciej.fijalkowski@intel.com,
        Praveen Kaligineedi <pkaligineedi@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for XDP DROP, PASS, TX, REDIRECT for GQI QPL format.
Add AF_XDP zero-copy support.

When an XDP program is installed, dedicated TX queues are created to
handle XDP traffic. The user needs to ensure that the number of
configured TX queues is equal to the number of configured RX queues; and
the number of TX/RX queues is less than or equal to half the maximum
number of TX/RX queues.

The XDP traffic from AF_XDP sockets and from other NICs (arriving via
XDP_REDIRECT) will also egress through the dedicated XDP TX queues.

Although these changes support AF_XDP socket in zero-copy mode, there is
still a copy happening within the driver between XSK buffer pool and QPL
bounce buffers in GQI-QPL format.

The following example demonstrates how the XDP packets are mapped to
TX queues:

Example configuration:
Max RX queues : 2N, Max TX queues : 2N
Configured RX queues : N, Configured TX queues : N

TX queue mapping:
TX queues with queue id 0,...,N-1 will handle traffic from the stack.
TX queues with queue id N,...,2N-1 will handle XDP traffic.

For the XDP packets transmitted using XDP_TX action:
<Egress TX queue id> = N + <Ingress RX queue id>

For the XDP packets that arrive from other NICs via XDP_REDIRECT action:
<Egress TX queue id> = N + ( smp_processor_id % N )

For AF_XDP zero-copy mode:
<Egress TX queue id> = N + <AF_XDP TX queue id>

Changes in v2:
- Removed gve_close/gve_open when adding XDP dedicated queues. Instead
we add and register additional TX queues when the XDP program is
installed. If the allocation/registration fails we return error and do
not install the XDP program. Added a new patch to enable adding TX queues
without gve_close/gve_open
- Removed xdp tx spin lock from this patch. It is needed for XDP_REDIRECT
support as both XDP_REDIRECT and XDP_TX traffic share the dedicated XDP
queues. Moved the code to add xdp tx spinlock to the subsequent patch
that adds XDP_REDIRECT support.
- Added netdev_err when the user tries to set rx/tx queues to the values
not supported when XDP is enabled.
- Removed rcu annotation for xdp_prog. We disable the napi prior to
adding/removing the xdp_prog and reenable it after the program has
been installed for all the queues.
- Ring the tx doorbell once for napi instead of every XDP TX packet.
- Added a new helper function for freeing the FIFO buffer
- Unregister xdp rxq for all the queues when the registration
fails during XDP program installation
- Register xsk rxq only when XSK buff pool is enabled
- Removed code accessing internal xsk_buff_pool fields
- Removed sleep driven code when disabling XSK buff pool. Disable
napi and re-enable it after disabling XSK pool.
- Make sure that we clean up dma mappings on XSK pool disable
- Use napi_if_scheduled_mark_missed to avoid unnecessary napi move
to the CPU calling ndo_xsk_wakeup()

Changes in v3:
- Padding bytes are used if the XDP TX packet headers do not
fit at tail of TX FIFO. Taking these padding bytes into account
while checking if enough space is available in TX FIFO.

Changes in v4:
- Turn on the carrier based on the link status synchronously rather
than asynchronously when XDP is installed/uninstalled
- Set the supported flags in net_device.xdp_features

Praveen Kaligineedi (5):
  gve: XDP support GQI-QPL: helper function changes
  gve: Changes to add new TX queues
  gve: Add XDP DROP and TX support for GQI-QPL format
  gve: Add XDP REDIRECT support for GQI-QPL format
  gve: Add AF_XDP zero-copy support for GQI-QPL format

 drivers/net/ethernet/google/gve/gve.h         | 114 ++-
 drivers/net/ethernet/google/gve/gve_adminq.c  |   8 +-
 drivers/net/ethernet/google/gve/gve_adminq.h  |   4 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c |  91 ++-
 drivers/net/ethernet/google/gve/gve_main.c    | 687 +++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_rx.c      | 147 +++-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |   2 +-
 drivers/net/ethernet/google/gve/gve_tx.c      | 298 +++++++-
 drivers/net/ethernet/google/gve/gve_utils.c   |   6 +-
 drivers/net/ethernet/google/gve/gve_utils.h   |   3 +-
 10 files changed, 1238 insertions(+), 122 deletions(-)

-- 
2.40.0.rc1.284.g88254d51c5-goog

