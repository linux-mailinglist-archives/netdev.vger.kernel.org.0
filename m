Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737C2699CB9
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 19:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjBPS7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 13:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBPS7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 13:59:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1C04C3E3;
        Thu, 16 Feb 2023 10:59:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F18AA60909;
        Thu, 16 Feb 2023 18:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C910C433EF;
        Thu, 16 Feb 2023 18:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676573953;
        bh=nUKAxzBL/h/Q0N4ggMS+6durKy4ayMF7oPTsf1Dhs84=;
        h=From:To:Cc:Subject:Date:From;
        b=iHNjH3B9qY7w2FPhbyF82BAyvrVPC1sopjzabE5N1N/dSmrb2HtQkYyGby6bW5Qf+
         jI1zfKpNSlxJkG1sCEnzex8w6WH2YbMxudRZb+Bw19Szj8zQX+znd1e0TaBxve3A8Y
         PvgX2eJJEeGh3/C0mYbdhVDxaDQxd/nWI0wiDPGMLOJ8D08LZQRL46KMNJIF6+uqcJ
         LMaqEqzuhfWP8jw8KSM3pY2g9oJUjYOHjHXSxiM+Irm+WJRCPu3mqkuQDGC1F3/Na8
         RlLblpwYH3LQx4sqGNOGhyddNqfRk/W7UU0+d97fpAzYeAXhRGWhDaCqazZoY7lwaD
         Mbl1w4JM1oc7A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.2 final
Date:   Thu, 16 Feb 2023 10:59:12 -0800
Message-Id: <20230216185912.804993-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Slightly smaller PR than usual, probably because all sub-trees
have backed off and haven't submitted their changes.
None of the fixes here are particularly scary and no outstanding
regressions. In an ideal world the "current release" sections
would be empty at this stage but that never happens.


The following changes since commit 35674e787518768626d3a0ffce1c13a7eeed922d:

  Merge tag 'net-6.2-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-02-09 09:17:38 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-final

for you to fetch changes up to b20b8aec6ffc07bb547966b356780cd344f20f5b:

  devlink: Fix netdev notifier chain corruption (2023-02-16 11:53:47 +0100)

----------------------------------------------------------------
Fixes from the main networking tree only.

Current release - regressions:

  - fix unwanted sign extension in netdev_stats_to_stats64()

Current release - new code bugs:

 - initialize net->notrefcnt_tracker earlier

 - devlink: fix netdev notifier chain corruption

 - nfp: make sure mbox accesses in IPsec code are atomic

 - ice: fix check for weight and priority of a scheduling node

Previous releases - regressions:

 - ice: xsk: fix cleaning of XDP_TX frame, prevent inf loop

 - igb: fix I2C bit banging config with external thermal sensor

Previous releases - always broken:

 - sched: tcindex: update imperfect hash filters respecting rcu

 - mpls: fix stale pointer if allocation fails during device rename

 - dccp/tcp: avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions

 - remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues()

 - af_key: fix heap information leak

 - ipv6: fix socket connection with DSCP (correct interpretation
   of the tclass field vs fib rule matching)

 - tipc: fix kernel warning when sending SYN message

 - vmxnet3: read RSS information from the correct descriptor (eop)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Corinna Vinschen (1):
      igb: conditionalize I2C bit banging on external thermal sensor support

Cristian Ciocaltea (1):
      net: stmmac: Restrict warning on disabling DMA store and fwd mode

Eric Dumazet (2):
      net: initialize net->notrefcnt_tracker earlier
      net: use a bounce buffer for copying skb->mark

Felix Riemann (1):
      net: Fix unwanted sign extension in netdev_stats_to_stats64()

Guillaume Nault (3):
      ipv6: Fix datagram socket connection with DSCP.
      ipv6: Fix tcp socket connection with DSCP.
      selftests: fib_rule_tests: Test UDP and TCP connections with DSCP rules.

Hangyu Hua (1):
      net: openvswitch: fix possible memory leak in ovs_meter_cmd_set()

Hyunwoo Kim (1):
      af_key: Fix heap information leak

Ido Schimmel (1):
      devlink: Fix netdev notifier chain corruption

Jakub Kicinski (6):
      Merge branch 'nfp-fix-schedule-in-atomic-context-when-offloading-sa'
      Merge branch 'ipv6-fix-socket-connection-with-dscp-fib-rules'
      Merge branch 'sk-sk_forward_alloc-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      net: mpls: fix stale pointer if allocation fails during device rename
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Jason Xing (3):
      ixgbe: allow to increase MTU to 3K with XDP enabled
      i40e: add double of VLAN header when computing the max MTU
      ixgbe: add double of VLAN header when computing the max MTU

Jesse Brandeburg (1):
      ice: fix lost multicast packets in promisc mode

Johannes Zink (1):
      net: stmmac: fix order of dwmac5 FlexPPS parametrization sequence

Kuniyuki Iwashima (2):
      dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.
      net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().

Larysa Zaremba (1):
      ice: xsk: Fix cleaning of XDP_TX frames

Michael Chan (1):
      bnxt_en: Fix mqprio and XDP ring checking logic

Michal Wilczynski (1):
      ice: Fix check for weight and priority of a scheduling node

Miko Larsson (1):
      net/usb: kalmia: Don't pass act_len in usb_bulk_msg error path

Miroslav Lichvar (1):
      igb: Fix PPS input and output using 3rd and 4th SDP

Natalia Petrova (1):
      i40e: Add checking for null for nlmsg_find_attr()

Pedro Tammela (3):
      net/sched: tcindex: update imperfect hash filters respecting rcu
      net/sched: act_ctinfo: use percpu stats
      net/sched: tcindex: search key must be 16 bits

Pietro Borrello (1):
      sctp: sctp_sock_filter(): avoid list_entry() on possibly empty list

Rafał Miłecki (1):
      net: bgmac: fix BCM5358 support by setting correct flags

Ronak Doshi (1):
      vmxnet3: move rss code block under eop descriptor

Siddharth Vadapalli (1):
      net: ethernet: ti: am65-cpsw: Add RX DMA Channel Teardown Quirk

Tung Nguyen (1):
      tipc: fix kernel warning when sending SYN message

Yinjun Zhang (2):
      nfp: fix incorrect use of mbox in IPsec code
      nfp: fix schedule in atomic context when offloading sa

 drivers/net/ethernet/broadcom/bgmac-bcma.c         |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   4 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c       |   4 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  26 +++++
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  15 ++-
 drivers/net/ethernet/intel/igb/igb_main.c          |  54 ++++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  28 +++--
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c  |  39 ++++---
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |  25 +++-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    | 108 ++++++++---------
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h  |   1 -
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |   3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  12 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |   1 +
 drivers/net/usb/kalmia.c                           |   8 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  50 ++++----
 include/linux/netdevice.h                          |   2 -
 include/net/sock.h                                 |  13 +++
 net/caif/caif_socket.c                             |   1 +
 net/core/dev.c                                     |  10 +-
 net/core/devlink.c                                 |   5 +-
 net/core/net_namespace.c                           |  10 +-
 net/core/stream.c                                  |   1 -
 net/dccp/ipv6.c                                    |   7 +-
 net/ipv6/datagram.c                                |   2 +-
 net/ipv6/tcp_ipv6.c                                |  11 +-
 net/key/af_key.c                                   |   2 +-
 net/mpls/af_mpls.c                                 |   4 +
 net/openvswitch/meter.c                            |   4 +-
 net/sched/act_ctinfo.c                             |   6 +-
 net/sched/cls_tcindex.c                            |  34 +++++-
 net/sctp/diag.c                                    |   4 +-
 net/socket.c                                       |   9 +-
 net/tipc/socket.c                                  |   2 +
 tools/testing/selftests/net/fib_rule_tests.sh      | 128 ++++++++++++++++++++-
 tools/testing/selftests/net/nettest.c              |  51 +++++++-
 39 files changed, 508 insertions(+), 194 deletions(-)
