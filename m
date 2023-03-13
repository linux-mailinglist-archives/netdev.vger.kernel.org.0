Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160866B82A6
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCMU0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCMU0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:26:51 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CCF898EC
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:26:45 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-541888850d4so57107307b3.21
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678739204;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OAW4AJ5kKt2TE0CDS2aITxN5osKwPYJacnuTpeWU9IY=;
        b=Wu3qdYMFonBZQWH0DYeGa9FYToK0FYWBdtVRiqEXGp7Hs4f+FWCXSyu/kFNFtkkm1Q
         L6bKTStoYI0poz+QLqRLRqd+/Dkl1uT5zMO+6O6MtYinIfGVKyQUqpJaif4PLW9+NG2g
         Fai+WmHqGMu3Ac8G4vafruMjcTfKmGWoISBeBIVH6emip+BA0lxq6dNvLM8fESZJdOXU
         Pg5MsUCKhQF7oVyxRtZYfGHtpPn+1SMFgUxqViuxH8b2mM1DddXWE6LbmhMWsD7Rbtjz
         ngOxK9Fcro0FgRjkY3DSrrt4Gr+fqA4G0YopqvgGq1UsLwxSAdVP32FAaSDqSDxheJxb
         DjHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678739204;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OAW4AJ5kKt2TE0CDS2aITxN5osKwPYJacnuTpeWU9IY=;
        b=Z6aZ8QRWw7E4EM4ouENrUaEyTIWlLWdvW9dEWEpvrfd5WrG/oeNJO4g230BRKCdjqV
         8EanBGMfP7yacA02q1QRkpvdVXVzwmOsjvNkkwDE7SgMe6Q7GAGR5XM/KKOjtfegsFY2
         w1+Ad0XxqXlUfQ+XZ7NXG//O8V4RRrse//NYH/3IljPbYQ1DnpMqUeFYHEUJ3aPIEo6q
         aK/eYHL0WRfEZwF7Sap4la+s74qG5ObysxrAUylZDzCN8l76k5F1wXctjhCxHQwzk1E3
         +L47ncwm799a6IKjsDSQVYVvVFw9cCH75EoHfdVRRx1kiuSmQqRUNABFdOEudOUyJc0p
         6ZPQ==
X-Gm-Message-State: AO0yUKXKrVwYT6ft1+rCaHHKC9YVBQHafGDi8CDKYV3UACO/TvJzlhGs
        J+Uov+HmZ3z+rM3F0BRz19F5b+tFdDv81wo9hUlnlGkCDP2kTrpUgDxHCznzpRLvQePdUaoB6Kk
        YpmlryLsSYpYwXeZsOSoIj1wG26bZRzbAefgU8NL+A7foJgp7UFjltFzhSMqEGQ2ed6VsV5OTba
        YdWA==
X-Google-Smtp-Source: AK7set+HonypegFSYbynK7VseMWSS8LqTnb36/YQY/2TXadDbgY3BPV6D0aykPaUdZfNBvFrLpIZvjMa2iWLLp9iD8s=
X-Received: from pkaligineedi.sea.corp.google.com ([2620:15c:100:202:3bf9:461b:3c12:db6d])
 (user=pkaligineedi job=sendgmr) by 2002:a81:ed0d:0:b0:541:61aa:9e60 with SMTP
 id k13-20020a81ed0d000000b0054161aa9e60mr6442003ywm.6.1678739204668; Mon, 13
 Mar 2023 13:26:44 -0700 (PDT)
Date:   Mon, 13 Mar 2023 13:26:35 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313202640.4113427-1-pkaligineedi@google.com>
Subject: [PATCH net-next v3 0/5] gve: Add XDP support for GQI-QPL format
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

Changes in v3:
- Padding bytes are used if the XDP TX packet headers do not
fit at tail of TX FIFO. Taking these padding bytes into account
while checking if enough space is available in TX FIFO.

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
2.40.0.rc1.284.g88254d51c5-goog

