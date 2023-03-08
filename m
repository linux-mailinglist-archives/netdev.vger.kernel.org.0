Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015106B12B8
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 21:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCHUNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 15:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjCHUNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 15:13:52 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADC7D2394
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 12:13:50 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536d63d17dbso182611687b3.22
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 12:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678306430;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NzHYsT4+HGWQuCxpHgMAXDKVIrFzCyrACxvs/hquqHQ=;
        b=BbMI3erwNIiT5M+u4xpqLHNPm5w77o3E4PrE7wPe2whirxnuNkuJacYkTrcWc2V5Q9
         PTeqru9DJn7u4jFVBFvpC18Z9v6+0LcWWpFh6r7tXbJeR6b/n69qFWsZ2XlsRS15oSl3
         rAqr/FP3KexSEHp8hSYnxM6QvIgYv71gs9RrCt1fFWpkQitcQdm9oMrzWZQSUNND3T0O
         9n7844hMcZb+s0iYBIBvLKcNhaXBkYaVx+9A5lHsQLbm2mNQxTNWGrJJ5ZwykneJA8AS
         ltgPe6euRsQeji0bForWxpm8ZnSgJbIlWE3aQFuH5Mv7N9GQRnxhj8Dynyy1SsTc5KXn
         aQmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678306430;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NzHYsT4+HGWQuCxpHgMAXDKVIrFzCyrACxvs/hquqHQ=;
        b=iGcCML3gD7K3G9uaXOu5gvobOcvV4xndhSwkb7k1i0WAHPjzYcup61gniqjNnxmPSU
         BWklHLk9HZC7RzhruxTgaOay/Geartz54pkfo/a8xG30myjoWCpr3FZQo+zX5pjHGjjh
         WoEzpENBnQKFwCIAnL7Jc3kBpv/f6j4tJq8lN62VAH2bbLs589KkijlTLxw+zrkXxnee
         DllQV4o1daQG1Bp6s7aWpb/zqmgTAUYFc7HoaQudrTO9rnE0/+xF06/+u7CO7K+mGmFP
         PoUjVXpWu0gcmH0vpS1uryXI6FCf5uBdB9YE7CI99ZmczuKb9kf00U58rEvvsjwXGTAN
         H8Rw==
X-Gm-Message-State: AO0yUKU9OvHzote0MruCDthEBbLg9wunFIVriY5RinB6CmqHVdKu41Pz
        VCR34ksOsteNo9RQB8IfBE+Xpa3DhUdCcHjrASzi8hWh6TneTUuVJHBjCxDFEz5lON6qM8pqxKV
        s+twO3YiqPjp6R8laJgwPUa7XI0f4b8/qSXZOwzB8nLkBTjRIFa3vWH1jgMW/JAzgyUZ/TXeTXa
        L2kg==
X-Google-Smtp-Source: AK7set9jVAWN1Y1bYqRw+8Zo7XbFX8bEeAh4e44KPGdd7nQLkvCV7tP7BFjqlJQiTlAAGodZCLXYBh1Y5ChvD2UNRFQ=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:cf18:68c8:1237:ef3])
 (user=pkaligineedi job=sendgmr) by 2002:a5b:b0d:0:b0:aa3:f90f:369b with SMTP
 id z13-20020a5b0b0d000000b00aa3f90f369bmr9348732ybp.6.1678306429960; Wed, 08
 Mar 2023 12:13:49 -0800 (PST)
Date:   Wed,  8 Mar 2023 12:13:23 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230308201328.3094150-1-pkaligineedi@google.com>
Subject: [PATCH net-next v2 0/5] gve: Add XDP support for GQI-QPL format
From:   Praveen Kaligineedi <pkaligineedi@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, maciej.fijalkowski@intel.com,
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

Praveen Kaligineedi (5):
  gve: XDP support GQI-QPL: helper function changes
  gve: Changes to add new TX queues
  gve: Add XDP DROP and TX support for GQI-QPL format
  gve: Add XDP REDIRECT support for GQI-QPL format
  gve: Add AF_XDP zero-copy support for GQI-QPL format

 drivers/net/ethernet/google/gve/gve.h         | 112 ++-
 drivers/net/ethernet/google/gve/gve_adminq.c  |   8 +-
 drivers/net/ethernet/google/gve/gve_adminq.h  |   4 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c |  91 ++-
 drivers/net/ethernet/google/gve/gve_main.c    | 670 +++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_rx.c      | 147 +++-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |   2 +-
 drivers/net/ethernet/google/gve/gve_tx.c      | 298 +++++++-
 drivers/net/ethernet/google/gve/gve_utils.c   |   6 +-
 drivers/net/ethernet/google/gve/gve_utils.h   |   3 +-
 10 files changed, 1220 insertions(+), 121 deletions(-)

-- 
2.40.0.rc0.216.gc4246ad0f0-goog

