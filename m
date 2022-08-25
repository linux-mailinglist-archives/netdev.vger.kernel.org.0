Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1DC5A1A76
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243743AbiHYUi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiHYUi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:38:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1069BD09C;
        Thu, 25 Aug 2022 13:38:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B721CB826D9;
        Thu, 25 Aug 2022 20:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32EEC433C1;
        Thu, 25 Aug 2022 20:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661459900;
        bh=ux+AmLWs8S63UALXoBlKQf1hyToCfUTnSl1Gwr6m9KE=;
        h=From:To:Cc:Subject:Date:From;
        b=Q5/HgUK8xdYL7YL7y6mFg89CBqQsqnyjzAc56QDjA1HrK/dpNLDWkuLKFWSWLIGoa
         0lCyk0BZvjup71tLvm4I8N2YyTfNZkgevM7Eu1fgTwZQsKxlLcPNnoTsLHqfZpmKSj
         0r+EJ5IZyt2ic56LcBtLTe5RUH3TJThjiFiKTn1ULezJ5kFnJYqEPBV7P+Ztv8+6s+
         TpuI0Rp/qsUaFyHJtf7/gHrmmuJcoK4064LlsJx+AdAZgIaNyc45jpABYSGZAoQkKQ
         njwghDdPgb+b5kEO+O14IYRbWwZsIIiSRHtcZ1BeMzDj/HBffdR3GoLMNrVn40PjiQ
         0b0VI/yvMTPEw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for 6.0-rc3
Date:   Thu, 25 Aug 2022 13:38:19 -0700
Message-Id: <20220825203819.2507927-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 4c2d0b039c5cc0112206a5b22431b577cb1c57ad:

  Merge tag 'net-6.0-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-08-18 19:37:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.0-rc3

for you to fetch changes up to d974730c8884cd784810b4f2fe903ac882a5fec9:

  Merge branch 'net-lantiq_xrx200-fix-errors-under-memory-pressure' (2022-08-25 12:41:41 -0700)

----------------------------------------------------------------
Including fixes from ipsec and netfilter (with one broken Fixes tag).

Current release - new code bugs:

 - dsa: don't dereference NULL extack in dsa_slave_changeupper()

 - dpaa: fix <1G ethernet on LS1046ARDB

 - neigh: don't call kfree_skb() under spin_lock_irqsave()

Previous releases - regressions:

 - r8152: fix the RX FIFO settings when suspending

 - dsa: microchip: keep compatibility with device tree blobs with
   no phy-mode

 - Revert "net: macsec: update SCI upon MAC address change."

 - Revert "xfrm: update SA curlft.use_time", comply with RFC 2367

Previous releases - always broken:

 - netfilter: conntrack: work around exceeded TCP receive window

 - ipsec: fix a null pointer dereference of dst->dev on a metadata
   dst in xfrm_lookup_with_ifid

 - moxa: get rid of asymmetry in DMA mapping/unmapping

 - dsa: microchip: make learning configurable and keep it off
   while standalone

 - ice: xsk: prohibit usage of non-balanced queue id

 - rxrpc: fix locking in rxrpc's sendmsg

Misc:

 - another chunk of sysctl data race silencing

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aleksander Jan Bajkowski (3):
      net: lantiq_xrx200: confirm skb is allocated before using
      net: lantiq_xrx200: fix lock under memory pressure
      net: lantiq_xrx200: restore buffer if memory allocation failed

Alex Elder (1):
      net: ipa: don't assume SMEM is page-aligned

Antony Antony (3):
      Revert "xfrm: update SA curlft.use_time"
      xfrm: fix XFRMA_LASTUSED comment
      xfrm: clone missing x->lastused in xfrm_do_migrate

Aya Levin (1):
      net/mlx5e: Fix wrong application of the LRO state

Bernard Pidoux (1):
      rose: check NULL rose_loopback_neigh->loopback

Csókás Bence (1):
      fec: Restart PPS after link state change

Dan Carpenter (4):
      net/mlx5: unlock on error path in esw_vfs_changed_event_handler()
      net/mlx5e: kTLS, Use _safe() iterator in mlx5e_tls_priv_tx_list_cleanup()
      net/mlx5e: Fix use after free in mlx5e_fs_init()
      net/mlx5: Unlock on error in mlx5_sriov_enable()

David Howells (1):
      rxrpc: Fix locking in rxrpc's sendmsg

David S. Miller (3):
      Merge branch 'r8152-fixes'
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      Merge branch 'sysctl-data-races'

Duoming Zhou (1):
      nfc: pn533: Fix use-after-free bugs caused by pn532_cmd_timeout

Eli Cohen (2):
      net/mlx5: LAG, fix logic over MLX5_LAG_FLAG_NDEVS_READY
      net/mlx5: Eswitch, Fix forwarding decision to uplink

Eric Dumazet (1):
      netfilter: nf_defrag_ipv6: allow nf_conntrack_frag6_high_thresh increases

Florian Westphal (3):
      netfilter: ebtables: reject blobs that don't provide all entry points
      netfilter: conntrack: work around exceeded receive window
      netfilter: nft_tproxy: restrict to prerouting hook

Hayes Wang (2):
      r8152: fix the units of some registers for RTL8156A
      r8152: fix the RX FIFO settings when suspending

Heiner Kallweit (1):
      net: stmmac: work around sporadic tx issue on link-up

Herbert Xu (1):
      af_key: Do not call xfrm_probe_algs in parallel

Jacob Keller (1):
      ixgbe: stop resetting SYSTIME in ixgbe_ptp_start_cyclecounter

Jakub Kicinski (8):
      Merge branch 'bonding-802-3ad-fix-no-transmission-of-lacpdus'
      Merge branch 'bnxt_en-bug-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'mlx5-fixes-2022-08-22' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'ionic-bug-fixes'
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'net-lantiq_xrx200-fix-errors-under-memory-pressure'

Jonathan Toppins (3):
      selftests: include bonding tests into the kselftest infra
      bonding: 802.3ad: fix no transmission of LACPDUs
      bonding: 3ad: make ad_ticks_per_sec a const

Kuniyuki Iwashima (17):
      net: Fix data-races around sysctl_[rw]mem_(max|default).
      net: Fix data-races around weight_p and dev_weight_[rt]x_bias.
      net: Fix data-races around netdev_max_backlog.
      net: Fix data-races around netdev_tstamp_prequeue.
      ratelimit: Fix data-races in ___ratelimit().
      net: Fix data-races around sysctl_optmem_max.
      net: Fix a data-race around sysctl_tstamp_allow_data.
      net: Fix a data-race around sysctl_net_busy_poll.
      net: Fix a data-race around sysctl_net_busy_read.
      net: Fix a data-race around netdev_budget.
      net: Fix data-races around sysctl_max_skb_frags.
      net: Fix a data-race around netdev_budget_usecs.
      net: Fix data-races around sysctl_fb_tunnels_only_for_init_net.
      net: Fix data-races around sysctl_devconf_inherit_init_net.
      net: Fix a data-race around gro_normal_batch.
      net: Fix a data-race around netdev_unregister_timeout_secs.
      net: Fix a data-race around sysctl_somaxconn.

Lorenzo Bianconi (1):
      net: ethernet: mtk_eth_soc: fix hw hash reporting for MTK_NETSYS_V2

Lukas Bulwahn (1):
      MAINTAINERS: rectify file entry in BONDING DRIVER

Maciej Fijalkowski (2):
      ice: xsk: prohibit usage of non-balanced queue id
      ice: xsk: use Rx ring's XDP ring when picking NAPI context

Maciej Żenczykowski (1):
      net: ipvtap - add __init/__exit annotations to module init/exit funcs

Maor Dickman (1):
      net/mlx5e: Fix wrong tc flag used when set hw-tc-offload off

Moshe Shemesh (1):
      net/mlx5: Avoid false positive lockdep warning by adding lock_class_key

Nikolay Aleksandrov (1):
      xfrm: policy: fix metadata dst->dev xmit null pointer dereference

Pablo Neira Ayuso (10):
      netfilter: nf_tables: disallow updates of implicit chain
      netfilter: nf_tables: make table handle allocation per-netns friendly
      netfilter: nft_payload: report ERANGE for too long offset and length
      netfilter: nft_payload: do not truncate csum_offset and csum_type
      netfilter: nf_tables: do not leave chain stats enabled on error
      netfilter: nft_osf: restrict osf to ipv4, ipv6 and inet families
      netfilter: nft_tunnel: restrict it to netdev family
      netfilter: nf_tables: disallow binding to already bound chain
      netfilter: flowtable: add function to invoke garbage collection immediately
      netfilter: flowtable: fix stuck flows on cleanup due to pending work

Pavan Chebbi (1):
      bnxt_en: Use PAGE_SIZE to init buffer when multi buffer XDP is not in use

R Mohamed Shah (1):
      ionic: VF initial random MAC address if no assigned mac

Roi Dayan (1):
      net/mlx5e: TC, Add missing policer validation

Roy Novich (1):
      net/mlx5: Fix cmd error logging for manage pages cmd

Sabrina Dubroca (1):
      Revert "net: macsec: update SCI upon MAC address change."

Sean Anderson (1):
      net: dpaa: Fix <1G ethernet on LS1046ARDB

Sergei Antonov (1):
      net: moxa: get rid of asymmetry in DMA mapping/unmapping

Shannon Nelson (2):
      ionic: clear broken state on generation change
      ionic: fix up issues with handling EAGAIN on FW cmds

Sylwester Dziedziuch (1):
      i40e: Fix incorrect address type for IPv6 flow rules

Vikas Gupta (3):
      bnxt_en: set missing reload flag in devlink features
      bnxt_en: fix NQ resource accounting during vf creation on 57500 chips
      bnxt_en: fix LRO/GRO_HW features in ndo_fix_features callback

Vlad Buslov (2):
      net/mlx5e: Properly disable vlan strip on non-UL reps
      net/mlx5: Disable irq when locking lag_lock

Vladimir Oltean (3):
      net: dsa: microchip: keep compatibility with device tree blobs with no phy-mode
      net: dsa: don't dereference NULL extack in dsa_slave_changeupper()
      net: dsa: microchip: make learning configurable and keep it off while standalone

Xiaolei Wang (1):
      net: phy: Don't WARN for PHY_READY state in mdio_bus_phy_resume()

Xin Xiong (1):
      xfrm: fix refcount leak in __xfrm_policy_check()

Yang Yingliang (1):
      net: neigh: don't call kfree_skb() under spin_lock_irqsave()

lily (1):
      net/core/skbuff: Check the return value of skb_copy_bits()

 Documentation/admin-guide/sysctl/net.rst           |  2 +-
 MAINTAINERS                                        |  1 +
 drivers/net/bonding/bond_3ad.c                     | 41 ++++------
 drivers/net/bonding/bond_main.c                    |  2 +-
 drivers/net/dsa/microchip/ksz_common.c             | 53 +++++++++++-
 drivers/net/dsa/microchip/ksz_common.h             |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      | 10 ++-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  6 +-
 drivers/net/ethernet/freescale/fec.h               | 10 +++
 drivers/net/ethernet/freescale/fec_main.c          | 42 +++++++++-
 drivers/net/ethernet/freescale/fec_ptp.c           | 29 +++++++
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  2 +-
 drivers/net/ethernet/intel/ice/ice.h               | 36 +++++---
 drivers/net/ethernet/intel/ice/ice_lib.c           |  4 +-
 drivers/net/ethernet/intel/ice/ice_main.c          | 25 ++++--
 drivers/net/ethernet/intel/ice/ice_xsk.c           | 18 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       | 59 +++++++++++---
 drivers/net/ethernet/lantiq_xrx200.c               |  9 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        | 22 ++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |  5 ++
 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c |  4 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 12 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  2 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  7 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  | 57 +++++++------
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  4 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  9 +-
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |  2 +-
 drivers/net/ethernet/moxa/moxart_ether.c           | 11 +--
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 95 ++++++++++++++++++++--
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |  4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c    |  8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  9 +-
 drivers/net/ipa/ipa_mem.c                          |  2 +-
 drivers/net/ipvlan/ipvtap.c                        |  4 +-
 drivers/net/macsec.c                               | 11 ++-
 drivers/net/phy/phy_device.c                       |  8 +-
 drivers/net/usb/r8152.c                            | 27 +++---
 drivers/nfc/pn533/uart.c                           |  1 +
 include/linux/mlx5/driver.h                        |  1 +
 include/linux/netdevice.h                          | 20 ++++-
 include/linux/netfilter_bridge/ebtables.h          |  4 -
 include/net/bond_3ad.h                             |  2 +-
 include/net/busy_poll.h                            |  2 +-
 include/net/gro.h                                  |  2 +-
 include/net/netfilter/nf_flow_table.h              |  3 +
 include/net/netfilter/nf_tables.h                  |  1 +
 include/uapi/linux/xfrm.h                          |  2 +-
 lib/ratelimit.c                                    | 12 ++-
 net/bridge/netfilter/ebtable_broute.c              |  8 --
 net/bridge/netfilter/ebtable_filter.c              |  8 --
 net/bridge/netfilter/ebtable_nat.c                 |  8 --
 net/bridge/netfilter/ebtables.c                    |  8 +-
 net/core/bpf_sk_storage.c                          |  5 +-
 net/core/dev.c                                     | 20 ++---
 net/core/filter.c                                  | 13 +--
 net/core/gro_cells.c                               |  2 +-
 net/core/neighbour.c                               | 12 ++-
 net/core/skbuff.c                                  |  7 +-
 net/core/sock.c                                    | 18 ++--
 net/core/sysctl_net_core.c                         | 15 ++--
 net/dsa/slave.c                                    |  2 +-
 net/ipv4/devinet.c                                 | 16 ++--
 net/ipv4/ip_output.c                               |  2 +-
 net/ipv4/ip_sockglue.c                             |  6 +-
 net/ipv4/tcp.c                                     |  4 +-
 net/ipv4/tcp_output.c                              |  2 +-
 net/ipv6/addrconf.c                                |  5 +-
 net/ipv6/ipv6_sockglue.c                           |  4 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |  1 -
 net/key/af_key.c                                   |  3 +
 net/mptcp/protocol.c                               |  2 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |  4 +-
 net/netfilter/nf_conntrack_proto_tcp.c             | 31 +++++++
 net/netfilter/nf_flow_table_core.c                 | 15 ++--
 net/netfilter/nf_flow_table_offload.c              |  8 ++
 net/netfilter/nf_tables_api.c                      | 14 +++-
 net/netfilter/nft_osf.c                            | 18 +++-
 net/netfilter/nft_payload.c                        | 29 +++++--
 net/netfilter/nft_tproxy.c                         |  8 ++
 net/netfilter/nft_tunnel.c                         |  1 +
 net/rose/rose_loopback.c                           |  3 +-
 net/rxrpc/call_object.c                            |  4 +-
 net/rxrpc/sendmsg.c                                | 92 ++++++++++++---------
 net/sched/sch_generic.c                            |  2 +-
 net/socket.c                                       |  2 +-
 net/xfrm/espintcp.c                                |  2 +-
 net/xfrm/xfrm_input.c                              |  3 +-
 net/xfrm/xfrm_output.c                             |  1 -
 net/xfrm/xfrm_policy.c                             |  3 +-
 net/xfrm/xfrm_state.c                              |  1 +
 tools/testing/selftests/Makefile                   |  1 +
 .../testing/selftests/drivers/net/bonding/Makefile |  6 ++
 .../drivers/net/bonding/bond-break-lacpdu-tx.sh    | 81 ++++++++++++++++++
 tools/testing/selftests/drivers/net/bonding/config |  1 +
 .../testing/selftests/drivers/net/bonding/settings |  1 +
 102 files changed, 865 insertions(+), 358 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/bonding/Makefile
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/config
 create mode 100644 tools/testing/selftests/drivers/net/bonding/settings
