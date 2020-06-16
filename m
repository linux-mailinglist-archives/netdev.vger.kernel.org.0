Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D981FC244
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 01:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgFPXZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 19:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPXZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 19:25:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82754C061573;
        Tue, 16 Jun 2020 16:25:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3261128EB054;
        Tue, 16 Jun 2020 16:25:51 -0700 (PDT)
Date:   Tue, 16 Jun 2020 16:25:51 -0700 (PDT)
Message-Id: <20200616.162551.466272432384185418.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jun 2020 16:25:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Don't get per-cpu pointer with preemption enabled in nft_set_pipapo,
   fix from Stefano Brivio.

2) Fix memory leak in ctnetlink, from Pablo Neira Ayuso.

3) Multiple definitions of MPTCP_PM_MAX_ADDR, from Geliang Tang.

4) Accidently disabling NAPI in non-error paths of macb_open(), from
   Charles Keepax.

5) Fix races between alx_stop and alx_remove, from Zekun Shen.

6) We forget to re-enable SRIOV during resume in bnxt_en driver,
   from Michael Chan.

7) Fix memory leak in ipv6_mc_destroy_dev(), from Wang Hai.

8) rxtx stats use wrong index in mvpp2 driver, from Sven Auhagen.

9) Fix memory leak in mptcp_subflow_create_socket error path,
   from Wei Yongjun.

10) We should not adjust the TCP window advertised when sending dup
    acks in non-SACK mode, because it won't be counted as a dup by the
    sender if the window size changes.  From Eric Dumazet.

11) Destroy the right number of queues during remove in mvpp2 driver,
    from Sven Auhagen.

12) Various WOL and PM fixes to e1000 driver, from Chen Yu, Vaibhav
    Gupta, and Arnd Bergmann.

Please pull, thanks a lot!

The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:

  Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net 

for you to fetch changes up to c9f66b43ee27409e1b614434d87e0e722efaa5f2:

  Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue (2020-06-16 16:16:24 -0700)

----------------------------------------------------------------
Aditya Pakki (2):
      test_objagg: Fix potential memory leak in error handling
      rocker: fix incorrect error handling in dma_rings_init

Alaa Hleihel (2):
      net/sched: act_ct: Make tcf_ct_flow_table_restore_skb inline
      netfilter: flowtable: Make nf_flow_table_offload_add/del_cb inline

Arnd Bergmann (1):
      e1000e: fix unused-function warning

Bartosz Golaszewski (1):
      net: ethernet: mtk-star-emac: simplify interrupt handling

Charles Keepax (1):
      net: macb: Only disable NAPI on the actual error path

Chen Yu (1):
      e1000e: Do not wake up the system via WOL if device wakeup is disabled

Colin Ian King (1):
      net: axienet: fix spelling mistake in comment "Exteneded" -> "extended"

David S. Miller (4):
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'bnxt_en-Bug-fixes'
      Merge branch 'remove-dependency-between-mlx5-act_ct-nf_flow_table'
      Merge branch '1GbE' of git://git.kernel.org/.../jkirsher/net-queue

Eric Dumazet (1):
      tcp: grow window for OOO packets only for SACK flows

Geliang Tang (2):
      mptcp: drop MPTCP_PM_MAX_ADDR
      mptcp: use list_first_entry_or_null

Ido Schimmel (1):
      mlxsw: spectrum: Adjust headroom buffers for 8x ports

Ka-Cheong Poon (1):
      net/rds: NULL pointer de-reference in rds_ib_add_one()

Martin (1):
      bareudp: Fixed configuration to avoid having garbage values

Michael Chan (3):
      bnxt_en: Simplify bnxt_resume().
      bnxt_en: Re-enable SRIOV during resume.
      bnxt_en: Fix AER reset logic on 57500 chips.

Pablo Neira Ayuso (2):
      netfilter: ctnetlink: memleak in filter initialization error path
      netfilter: nf_tables: hook list memleak in flowtable deletion

Sergei Shtylyov (1):
      MAINTAINERS: switch to my private email for Renesas Ethernet drivers

Stefano Brivio (2):
      netfilter: nft_set_rbtree: Don't account for expired elements on insertion
      netfilter: nft_set_pipapo: Disable preemption before getting per-CPU pointer

Sven Auhagen (2):
      mvpp2: ethtool rxtx stats fix
      mvpp2: remove module bugfix

Thomas Falcon (1):
      ibmvnic: Harden device login requests

Tim Harvey (1):
      lan743x: add MODULE_DEVICE_TABLE for module loading alias

Vaibhav Gupta (1):
      e1000: use generic power management

Vasundhara Volam (1):
      bnxt_en: Return from timer if interface is not in open state.

Vladimir Oltean (2):
      MAINTAINERS: merge entries for felix and ocelot drivers
      net: dsa: sja1105: fix PTP timestamping with large tc-taprio cycles

Wang Hai (1):
      mld: fix memory leak in ipv6_mc_destroy_dev()

Wang Qing (1):
      qlcnic: Use kobj_to_dev() instead

Wei Yongjun (1):
      mptcp: fix memory leak in mptcp_subflow_create_socket()

Zekun Shen (1):
      net: alx: fix race condition in alx_remove

 MAINTAINERS                                            |  30 ++++++++++-------------
 drivers/net/bareudp.c                                  |   2 ++
 drivers/net/dsa/sja1105/sja1105_ptp.c                  |   8 +++---
 drivers/net/ethernet/atheros/alx/main.c                |   9 ++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c              |  35 +++++++++++++--------------
 drivers/net/ethernet/cadence/macb_main.c               |   9 +++----
 drivers/net/ethernet/ibm/ibmvnic.c                     |  21 +++++++++++++---
 drivers/net/ethernet/intel/e1000/e1000_main.c          |  49 ++++++++++---------------------------
 drivers/net/ethernet/intel/e1000e/netdev.c             |  30 +++++++++++------------
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c        |  11 ++++++---
 drivers/net/ethernet/mediatek/mtk_star_emac.c          | 118 ++++++++++++++++++++++-------------------------------------------------------------------
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c         |   2 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h         |  13 ++++++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c    |   1 +
 drivers/net/ethernet/microchip/lan743x_main.c          |   2 ++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c      |  34 +++++++++++++-------------
 drivers/net/ethernet/rocker/rocker_main.c              |   4 +--
 drivers/net/ethernet/xilinx/xilinx_axienet.h           |   2 +-
 include/net/netfilter/nf_flow_table.h                  |  49 ++++++++++++++++++++++++++++++++++---
 include/net/tc_act/tc_ct.h                             |  11 ++++++++-
 lib/test_objagg.c                                      |   4 +--
 net/ipv4/tcp_input.c                                   |  12 +++++++--
 net/ipv6/mcast.c                                       |   1 +
 net/mptcp/protocol.h                                   |   7 +-----
 net/mptcp/subflow.c                                    |   4 ++-
 net/netfilter/nf_conntrack_netlink.c                   |  32 ++++++++++++++++--------
 net/netfilter/nf_flow_table_core.c                     |  45 ----------------------------------
 net/netfilter/nf_tables_api.c                          |  31 ++++++++++++++++++------
 net/netfilter/nft_set_pipapo.c                         |   6 ++++-
 net/netfilter/nft_set_rbtree.c                         |  21 ++++++++++------
 net/rds/ib.h                                           |   8 +++++-
 net/sched/act_ct.c                                     |  11 ---------
 33 files changed, 309 insertions(+), 314 deletions(-)
