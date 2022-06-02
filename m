Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFBD53BE3B
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 20:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238295AbiFBSyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 14:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238273AbiFBSyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 14:54:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC872ED54;
        Thu,  2 Jun 2022 11:54:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28BFBB82140;
        Thu,  2 Jun 2022 18:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8E2C34114;
        Thu,  2 Jun 2022 18:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654196039;
        bh=uMdMgnutql/b90DsEjBVINo6/pqiZwqIt+g50lde500=;
        h=From:To:Cc:Subject:Date:From;
        b=KhxXYjYslWzcz6V+6ep03aUjgjg6f2PihHJVAuBbTZ9CA/M6/Dg/vsd2wQ9ktHjn9
         87gxuGi9Iuy7a7iTpVKZalchownze929tvjxdq9Q+K3TVQ9PF/HClPZbyYVvnLR612
         3AP+Lwij0Uu/XZGM+CL118q85mLcdm29QfRl00tLQXzvpR67yCWhUoJ3j7AH9kNmw4
         yJHX5hK8Ko4QodML1PXpcYYo5tXi3bogjWuokAV5Zut+PMLtXSLHoTmxiZXtvw4dUx
         RQWgeQfC2Um265gNRv3MS+TLkkiRAVqP5qZzMysKB/DIelpJq4QxYsmc/Vl2EPiD1J
         LP9Kw+IaLvhug==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.19-rc1
Date:   Thu,  2 Jun 2022 11:53:58 -0700
Message-Id: <20220602185358.4149770-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 7e062cda7d90543ac8c7700fc7c5527d0c0f22ad:

  Merge tag 'net-next-5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2022-05-25 12:22:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc1

for you to fetch changes up to 638696efc14729759c1d735e19e87606450b80a8:

  Merge branch 'net-af_packet-be-careful-when-expanding-mac-header-size' (2022-06-02 10:15:07 -0700)

----------------------------------------------------------------
Networking fixes for 5.19-rc1, including fixes from bpf, and netfilter.

Current release - new code bugs:

 - af_packet: make sure to pull the MAC header, avoid skb panic in GSO

 - ptp_clockmatrix: fix inverted logic in is_single_shot()

 - netfilter: flowtable: fix missing FLOWI_FLAG_ANYSRC flag

 - dt-bindings: net: adin: fix adi,phy-output-clock description syntax

 - wifi: iwlwifi: pcie: rename CAUSE macro, avoid MIPS build warning

Previous releases - regressions:

 - Revert "net: af_key: add check for pfkey_broadcast in function
   pfkey_process"

 - tcp: fix tcp_mtup_probe_success vs wrong snd_cwnd

 - nf_tables: disallow non-stateful expression in sets earlier

 - nft_limit: clone packet limits' cost value

 - nf_tables: double hook unregistration in netns path

 - ping6: fix ping -6 with interface name

Previous releases - always broken:

 - sched: fix memory barriers to prevent skbs from getting stuck
   in lockless qdiscs

 - neigh: set lower cap for neigh_managed_work rearming, avoid
   constantly scheduling the probe work

 - bpf: fix probe read error on big endian in ___bpf_prog_run()

 - amt: memory leak and error handling fixes

Misc:

 - ipv6: expand & rename accept_unsolicited_na to accept_untracked_na

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alex Elder (2):
      net: ipa: fix page free in ipa_endpoint_trans_release()
      net: ipa: fix page free in ipa_endpoint_replenish_one()

Alexander Lobakin (1):
      ice: fix access-beyond-end in the switch code

Alexandru Tachici (1):
      dt-bindings: net: Update ADIN PHY maintainers

Arun Ajith S (1):
      net/ipv6: Expand and rename accept_unsolicited_na to accept_untracked_na

Aya Levin (1):
      net: ping6: Fix ping -6 with interface name

Carlo Lobrano (1):
      net: usb: qmi_wwan: add Telit 0x1250 composition

Changcheng Liu (1):
      net/mlx5: correct ECE offset in query qp output

Christophe JAILLET (1):
      net: enetc: Use pci_release_region() to release some resources

Dan Carpenter (3):
      net: ethernet: mtk_eth_soc: out of bounds read in mtk_hwlro_get_fdir_entry()
      octeontx2-af: fix error code in is_valid_offset()
      net/sched: act_api: fix error code in tcf_ct_flow_table_fill_tuple_ipv6()

Daniel Borkmann (1):
      net, neigh: Set lower cap for neigh_managed_work rearming

David S. Miller (2):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'sfc-fixes'

Duoming Zhou (1):
      ax25: Fix ax25 session cleanup problems

Eric Dumazet (5):
      tcp: fix tcp_mtup_probe_success vs wrong snd_cwnd
      tcp: tcp_rtx_synack() can be called from process context
      net: CONFIG_DEBUG_NET depends on CONFIG_NET
      net: add debug info to __skb_pull()
      net/af_packet: make sure to pull mac header

Fei Qin (1):
      nfp: remove padding in nfp_nfdk_tx_desc

Florian Westphal (3):
      netfilter: nfnetlink: fix warn in nfnetlink_unbind
      netfilter: conntrack: re-fetch conntrack after insertion
      netfilter: cttimeout: fix slab-out-of-bounds read in cttimeout_net_exit

Geert Uytterhoeven (1):
      dt-bindings: net: adin: Fix adi,phy-output-clock description syntax

Guangguan Wang (1):
      net/smc: fixes for converting from "struct smc_cdc_tx_pend **" to "struct smc_wr_tx_pend_priv *"

Guoju Fang (1):
      net: sched: add barrier to fix packet stuck problem for lockless qdisc

Hangbin Liu (3):
      bonding: NS target should accept link local address
      bonding: show NS IPv6 targets in proc master info
      bonding: guard ns_targets by CONFIG_IPV6

Hoang Le (1):
      tipc: check attribute length for bearer name

Jakub Kicinski (10):
      Merge branch 'amt-fix-several-bugs'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'net-ipa-fix-page-free-in-two-spots'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge tag 'wireless-2022-06-01' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      Merge branch 'sfc-siena-fix-some-efx_separate_tx_channels-errors'
      Merge tag 'mlx5-fixes-2022-05-31' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'net-af_packet-be-careful-when-expanding-mac-header-size'

Johannes Berg (3):
      wifi: libertas: use variable-size data in assoc req/resp cmd
      wifi: iwlwifi: pcie: rename CAUSE macro
      wifi: mac80211: fix use-after-free in chanctx code

Juergen Gross (1):
      xen/netback: fix incorrect usage of RING_HAS_UNCONSUMED_REQUESTS()

Ke Liu (1):
      net: phy: Directly use ida_alloc()/free()

Leon Romanovsky (1):
      net/mlx5: Don't use already freed action pointer

Maciej Żenczykowski (1):
      xfrm: do not set IPv4 DF flag when encapsulating IPv6 frames <= 1280 bytes.

Maor Dickman (1):
      net/mlx5e: TC NIC mode, fix tc chains miss table

Martin Habets (2):
      sfc: fix considering that all channels have TX queues
      sfc/siena: fix considering that all channels have TX queues

Maxim Mikityanskiy (2):
      net/mlx5e: Disable softirq in mlx5e_activate_rq to avoid race condition
      net/mlx5e: Update netdev features after changing XDP state

Menglong Dong (1):
      bpf: Fix probe read error in ___bpf_prog_run()

Miaoqian Lin (2):
      net: ethernet: ti: am65-cpsw-nuss: Fix some refcount leaks
      net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register

Michael Sit Wei Hong (1):
      stmmac: intel: Add RPL-P PCI ID

Michael Walle (1):
      net: lan966x: check devm_of_phy_get() for -EDEFER_PROBE

Michal Kubecek (1):
      Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"

Min Li (1):
      ptp: ptp_clockmatrix: fix is_single_shot

Pablo Neira Ayuso (5):
      netfilter: nf_tables: disallow non-stateful expression in sets earlier
      netfilter: nf_tables: set element extended ACK reporting support
      netfilter: nf_tables: sanitize nft_set_desc_concat_parse()
      netfilter: nf_tables: hold mutex on netns pre_exit path
      netfilter: nf_tables: double hook unregistration in netns path

Paul Blakey (1):
      net/mlx5: CT: Fix header-rewrite re-use for tupels

Phil Sutter (1):
      netfilter: nft_limit: Clone packet limits' cost value

Ping-Ke Shih (1):
      wifi: rtw88: add a work to correct atomic scheduling warning of ::set_tim

Raju Lakkaraju (1):
      net: lan743x: PCI11010 / PCI11414 fix

Rasmus Villemoes (1):
      net: stmmac: use dev_err_probe() for reporting mdio bus registration failure

Saeed Mahameed (1):
      net/mlx5: Fix mlx5_get_next_dev() peer device matching

Sean Anderson (1):
      net: dpaa: Convert to SPDX identifiers

Siddharth Vadapalli (1):
      net: ethernet: ti: am65-cpsw: Fix fwnode passed to phylink_create()

Slark Xiao (1):
      net: usb: qmi_wwan: Add support for Cinterion MV31 with new baseline

Song Liu (1):
      selftests/bpf: fix stacktrace_build_id with missing kprobe/urandom_read

Taehee Yoo (3):
      amt: fix typo in amt
      amt: fix return value of amt_update_handler()
      amt: fix possible memory leak in amt_rcv()

Tobias Klauser (1):
      socket: Don't use u8 type in uapi socket.h

Vincent Ray (1):
      net: sched: fixed barrier to prevent skbuff sticking in qdisc backlog

Viorel Suman (1):
      net: phy: at803x: disable WOL at probe

Yu Xiao (1):
      nfp: only report pause frame configuration for physical device

Ziyang Xuan (1):
      macsec: fix UAF bug for real_dev

huhai (1):
      net: ipv4: Avoid bounds check warning

keliu (1):
      net: nfc: Directly use ida_alloc()/free()

liuyacan (1):
      net/smc: set ini->smcrv2.ib_dev_v2 to NULL if SMC-Rv2 is unavailable

luyun (1):
      selftests/net: enable lo.accept_local in psock_snd test

wenxu (2):
      netfilter: flowtable: fix missing FLOWI_FLAG_ANYSRC flag
      netfilter: flowtable: fix nft_flow_route source address for nat case

Íñigo Huguet (2):
      sfc: fix wrong tx channel offset with efx_separate_tx_channels
      sfc/siena: fix wrong tx channel offset with efx_separate_tx_channels

 .../devicetree/bindings/net/adi,adin.yaml          |   5 +-
 Documentation/networking/ip-sysctl.rst             |  23 +--
 drivers/net/amt.c                                  |   6 +-
 drivers/net/bonding/bond_main.c                    |   2 +
 drivers/net/bonding/bond_netlink.c                 |   5 -
 drivers/net/bonding/bond_options.c                 |  10 +-
 drivers/net/bonding/bond_procfs.c                  |  15 ++
 drivers/net/dsa/mv88e6xxx/chip.c                   |   1 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  31 +---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h     |  31 +---
 .../net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c   |  32 +---
 .../net/ethernet/freescale/dpaa/dpaa_eth_trace.h   |  32 +---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |  32 +---
 .../net/ethernet/freescale/enetc/enetc_pci_mdio.c  |   4 +-
 drivers/net/ethernet/intel/ice/Makefile            |   5 -
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |  58 +++----
 drivers/net/ethernet/intel/ice/ice_switch.c        | 188 ++++++++++-----------
 drivers/net/ethernet/intel/ice/ice_switch.h        |   3 -
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  34 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   1 +
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  19 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  29 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  38 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   9 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |  32 ++--
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   9 +-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c       |  12 +-
 drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h     |   3 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |  11 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   4 +-
 drivers/net/ethernet/sfc/efx_channels.c            |   6 +-
 drivers/net/ethernet/sfc/net_driver.h              |   2 +-
 drivers/net/ethernet/sfc/siena/efx_channels.c      |   6 +-
 drivers/net/ethernet/sfc/siena/net_driver.h        |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |   2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   8 +-
 drivers/net/ipa/ipa_endpoint.c                     |   9 +-
 drivers/net/macsec.c                               |   7 +
 drivers/net/phy/at803x.c                           |  33 ++--
 drivers/net/phy/fixed_phy.c                        |   6 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  34 ++--
 drivers/net/wireless/marvell/libertas/cfg.c        |   4 +-
 drivers/net/wireless/marvell/libertas/host.h       |   6 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |  10 ++
 drivers/net/wireless/realtek/rtw88/fw.h            |   1 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   4 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   2 +
 drivers/net/wireless/realtek/rtw88/main.h          |   1 +
 drivers/net/xen-netback/netback.c                  |   2 +-
 drivers/ptp/ptp_clockmatrix.c                      |   2 +-
 include/linux/ipv6.h                               |   2 +-
 include/linux/mlx5/mlx5_ifc.h                      |   5 +-
 include/linux/skbuff.h                             |   9 +-
 include/net/amt.h                                  |   2 +-
 include/net/ax25.h                                 |   1 +
 include/net/bonding.h                              |   6 +
 include/net/netfilter/nf_conntrack_core.h          |   7 +-
 include/net/sch_generic.h                          |  42 ++---
 include/uapi/linux/ipv6.h                          |   2 +-
 include/uapi/linux/socket.h                        |   2 +-
 kernel/bpf/core.c                                  |  14 +-
 net/Kconfig.debug                                  |   2 +-
 net/ax25/af_ax25.c                                 |  27 +--
 net/ax25/ax25_dev.c                                |   1 +
 net/ax25/ax25_subr.c                               |   2 +-
 net/core/neighbour.c                               |   2 +-
 net/ipv4/tcp_input.c                               |  11 +-
 net/ipv4/tcp_ipv4.c                                |   4 +-
 net/ipv4/tcp_output.c                              |   4 +-
 net/ipv6/addrconf.c                                |   6 +-
 net/ipv6/ndisc.c                                   |  42 +++--
 net/ipv6/ping.c                                    |   8 +-
 net/key/af_key.c                                   |  10 +-
 net/mac80211/chan.c                                |   7 +-
 net/netfilter/nf_tables_api.c                      | 106 ++++++++----
 net/netfilter/nfnetlink.c                          |  24 +--
 net/netfilter/nfnetlink_cttimeout.c                |   5 +-
 net/netfilter/nft_flow_offload.c                   |   6 +-
 net/netfilter/nft_limit.c                          |   2 +
 net/nfc/core.c                                     |   4 +-
 net/packet/af_packet.c                             |   6 +-
 net/sched/act_ct.c                                 |   2 +-
 net/smc/af_smc.c                                   |   1 +
 net/smc/smc_cdc.c                                  |   2 +-
 net/tipc/bearer.c                                  |   3 +-
 net/xfrm/xfrm_output.c                             |   3 +-
 .../selftests/bpf/progs/test_stacktrace_build_id.c |   2 +-
 .../selftests/net/ndisc_unsolicited_na_test.sh     |  23 ++-
 tools/testing/selftests/net/psock_snd.c            |   2 +
 101 files changed, 665 insertions(+), 611 deletions(-)
