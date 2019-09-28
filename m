Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB9FC10FA
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 15:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfI1Ntt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 28 Sep 2019 09:49:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfI1Nts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 09:49:48 -0400
Received: from localhost (unknown [8.46.75.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D536A1550BA3A;
        Sat, 28 Sep 2019 06:49:41 -0700 (PDT)
Date:   Sat, 28 Sep 2019 15:49:21 +0200 (CEST)
Message-Id: <20190928.154921.125450732732799584.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 28 Sep 2019 06:49:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Sanity check URB networking device parameters to avoid divide by zero,
   from Oliver Neukum.

2) Disable global multicast filter in NCSI, otherwise LLDP and IPV6
   don't work properly.  Longer term this needs a better fix tho. From
   Vijay Khemka.

3) Small fixes to selftests (use ping when ping6 is not present, etc.)
   from David Ahern.

4) Bring back rt_uses_gateway member of struct rtable, it's semantics were
   not well understood and trying to remove it broke things.  From David
   Ahern.

5) Move usbnet snaity checking, ignore endpoints with invalid wMaxPacketSize.
   From Bjørn Mork.

6) Missing Kconfig deps for sja1105 driver, from Mao Wenan.

7) Various small fixes to the mlx5 DR steering code, from Alaa Hleihel,
   Alex Vesker, and Yevgeny Kliteynik

8) Missing CAP_NET_RAW checks in various places, from Ori Nimron.

9) Fix crash when removing sch_cbs entry while offloading is enabled,
   from Vinicius Costa Gomes.

10) Signedness bug fixes, generally in looking at the result given by
    of_get_phy_mode() and friends.  From Dan Crapenter.

11) Disable preemption around BPF_PROG_RUN() calls, from Eric Dumazet.

12) Don't create VRF ipv6 rules if ipv6 is disabled, from David Ahern.

13) Fix quantization code in tcp_bbr, from Kevin Yang.

Please pull, thanks a lot!

The following changes since commit b41dae061bbd722b9d7fa828f35d22035b218e18:

  Merge tag 'xfs-5.4-merge-7' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux (2019-09-18 18:32:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to faeacb6ddb13b7a020b50b9246fe098653cfbd6e:

  net: tap: clean up an indentation issue (2019-09-27 20:58:35 +0200)

----------------------------------------------------------------
Alaa Hleihel (1):
      net/mlx5: DR, Allow matching on vport based on vhca_id

Alex Vesker (2):
      net/mlx5: DR, Remove redundant vport number from action
      net/mlx5: DR, Fix getting incorrect prev node in ste_free

Alexandru Ardelean (2):
      dt-bindings: net: dwmac: fix 'mac-mode' type
      dt-bindings: net: remove un-implemented property

Alexei Starovoitov (2):
      bpf: fix BTF verification of enums
      bpf: fix BTF limits

Allan Zhang (1):
      bpf: Fix bpf_event_output re-entry issue

Andrew Lunn (1):
      net: dsa: qca8k: Fix port enable for CPU port

Andrii Nakryiko (4):
      libbpf: fix false uninitialized variable warning
      selftests/bpf: delete unused variables in test_sysctl
      selftests/bpf: adjust strobemeta loop to satisfy latest clang
      libbpf: Teach btf_dumper to emit stand-alone anonymous enum definitions

Arnd Bergmann (2):
      net: remove netx ethernet driver
      net: stmmac: selftest: avoid large stack usage

Biju Das (1):
      dt-bindings: net: ravb: Add support for r8a774b1 SoC

Bjorn Andersson (1):
      net: qrtr: Stop rx_worker before freeing node

Björn Töpel (1):
      xsk: relax UMEM headroom alignment

Bjørn Mork (2):
      cdc_ncm: fix divide-by-zero caused by invalid wMaxPacketSize
      usbnet: ignore endpoints with invalid wMaxPacketSize

Bodong Wang (1):
      net/mlx5: Add device ID of upcoming BlueField-2

Christophe JAILLET (1):
      qede: qede_fp: simplify a bit 'qede_rx_build_skb()'

Colin Ian King (5):
      atm: he: clean up an indentation issue
      bpf: Clean up indentation issue in BTF kflag processing
      NFC: st95hf: clean up indentation issue
      net: ena: clean up indentation issue
      net: tap: clean up an indentation issue

Cong Wang (2):
      net_sched: add max len check for TCA_KIND
      net_sched: add policy validation for action attributes

Dan Carpenter (14):
      ionic: Fix an error code in ionic_lif_alloc()
      wil6210: use after free in wil_netif_rx_any()
      net: aquantia: Fix aq_vec_isr_legacy() return value
      cxgb4: Signedness bug in init_one()
      net: hisilicon: Fix signedness bug in hix5hd2_dev_probe()
      net: broadcom/bcmsysport: Fix signedness in bcm_sysport_probe()
      net: netsec: Fix signedness bug in netsec_probe()
      enetc: Fix a signedness bug in enetc_of_get_phy()
      net: socionext: Fix a signedness bug in ave_probe()
      net: stmmac: dwmac-meson8b: Fix signedness bug in probe
      net: axienet: fix a signedness bug in probe
      of: mdio: Fix a signedness bug in of_phy_get_and_connect()
      net: nixge: Fix a signedness bug in nixge_probe()
      net: ethernet: stmmac: Fix signedness bug in ipq806x_gmac_of_parse()

Danielle Ratson (1):
      mlxsw: spectrum_flower: Fail in case user specifies multiple mirror actions

David Ahern (4):
      selftests: Update fib_tests to handle missing ping6
      selftests: Update fib_nexthop_multiprefix to handle missing ping6
      ipv4: Revert removal of rt_uses_gateway
      vrf: Do not attempt to create IPv6 mcast rule if IPv6 is disabled

David S. Miller (9):
      Merge branch 'check-CAP_NEW_RAW'
      Merge branch 'ibmvnic-serialization-fixes'
      Merge tag 'mlx5-fixes-2019-09-24' of git://git.kernel.org/.../saeed/linux
      Merge tag 'wireless-drivers-for-davem-2019-09-26' of https://git.kernel.org/.../kvalo/wireless-drivers
      Merge branch 'SO_PRIORITY'
      Merge branch 'qdisc-destroy'
      Merge git://git.kernel.org/.../bpf/bpf
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'mlxsw-Various-fixes'

Davide Caratti (1):
      net/sched: act_sample: don't push mac header on ip6gre ingress

Dmytro Linkin (1):
      net/mlx5e: Fix matching on tunnel addresses type

Donald Sharp (1):
      selftests: Add test cases for `ip nexthop flush proto XX`

Eric Dumazet (9):
      sch_netem: fix a divide by zero in tabledist()
      ipv6: fix a typo in fib6_rule_lookup()
      net: sched: fix possible crash in tcf_action_destroy()
      kcm: disable preemption in kcm_parse_func_strparser()
      sch_netem: fix rcu splat in netem_enqueue()
      ipv6: add priority parameter to ip6_xmit()
      ipv6: tcp: provide sk->sk_priority to ctl packets
      tcp: honor SO_PRIORITY in TIME_WAIT state
      tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state

Florian Westphal (2):
      netfilter: nf_tables: allow lookups in dynamic sets
      sk_buff: drop all skb extensions on free and skb scrubbing

Geert Uytterhoeven (1):
      zd1211rw: zd_usb: Use "%zu" to format size_t

Hans Andersson (1):
      net: phy: micrel: add Asym Pause workaround for KSZ9021

Ido Schimmel (2):
      mlxsw: spectrum: Clear VLAN filters during port initialization
      Documentation: Clarify trap's description

Jacob Keller (1):
      ptp: correctly disable flags on old ioctls

James Byrne (1):
      dt-bindings: net: Correct the documentation of KSZ9021 skew values

Jason A. Donenfeld (2):
      net: print proper warning on dst underflow
      ipv6: do not free rt if FIB_LOOKUP_NOREF is set on suppress rule

Johannes Berg (1):
      iwlwifi: mvm: fix build w/o CONFIG_THERMAL

Jonathan Lemon (1):
      bpf/xskmap: Return ERR_PTR for failure case instead of NULL.

Jose Abreu (1):
      net: stmmac: selftests: Flow Control test can also run with ASYM Pause

Juliet Kim (2):
      net/ibmvnic: unlock rtnl_lock in reset so linkwatch_event can run
      net/ibmvnic: prevent more than one thread from running in reset

Ka-Cheong Poon (1):
      net/rds: Check laddr_check before calling it

Kevin(Yudong) Yang (1):
      tcp_bbr: fix quantization code to not raise cwnd if not probing bandwidth

Krzysztof Kozlowski (2):
      net: Fix Kconfig indentation
      drivers: net: Fix Kconfig indentation

Kunihiko Hayashi (1):
      net: socionext: ave: Avoid using netdev_err() before calling register_netdev()

Laura Garcia Liebana (1):
      netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush

Li RongQing (1):
      openvswitch: change type of UPCALL_PID attribute to NLA_UNSPEC

Lorenzo Bianconi (1):
      mt76: mt7615: fix mt7615 firmware path definitions

Luca Coelho (1):
      iwlwifi: fw: don't send GEO_TX_POWER_LIMIT command to FW version 36

Mao Wenan (2):
      net: dsa: sja1105: Add dependency for NET_DSA_SJA1105_TAS
      net: ena: Select DIMLIB for ENA_ETHERNET

Marek Vasut (1):
      net: dsa: microchip: Always set regmap stride to 1

Masahiro Yamada (1):
      netfilter: ebtables: use __u8 instead of uint8_t in uapi header

Murilo Fossa Vicentini (1):
      ibmvnic: Warn unknown speed message only when carrier is present

Nathan Chancellor (1):
      ionic: Remove unnecessary ternary operator in ionic_debugfs_add_ident

Navid Emamdoost (3):
      nfp: flower: prevent memory leak in nfp_flower_spawn_phy_reprs
      nfp: flower: fix memory leak in nfp_flower_spawn_vnic_reprs
      nfp: abm: fix memory leak in nfp_abm_u32_knode_replace

Nishad Kamdar (2):
      net: dsa: b53: Use the correct style for SPDX License Identifier
      net: dsa: Use the correct style for SPDX License Identifier

Oliver Neukum (1):
      usbnet: sanity checking of packet sizes and device mtu

Ori Nimron (5):
      mISDN: enforce CAP_NET_RAW for raw sockets
      appletalk: enforce CAP_NET_RAW for raw sockets
      ax25: enforce CAP_NET_RAW for raw sockets
      ieee802154: enforce CAP_NET_RAW for raw sockets
      nfc: enforce CAP_NET_RAW for raw sockets

Pablo Neira Ayuso (2):
      netfilter: nf_tables: add NFT_CHAIN_POLICY_UNSET and use it
      netfilter: nf_tables_offload: fix always true policy is unset check

Paul Blakey (1):
      net/sched: Set default of CONFIG_NET_TC_SKB_EXT to N

Peter Mamonov (1):
      net/phy: fix DP83865 10 Mbps HDX loopback disable function

Rain River (1):
      MAINTAINERS: add Yanjun to FORCEDETH maintainers list

Randy Dunlap (1):
      lib: dimlib: fix help text typos

Saeed Mahameed (1):
      net/mlx5e: Fix traffic duplication in ethtool steering

Shubhrajyoti Datta (1):
      net: macb: Remove dead code

Stanislav Fomichev (1):
      selftests/bpf: test_progs: fix client/server race in tcp_rtt

Stephen Hemminger (1):
      skge: fix checksum byte order

Takeshi Misawa (1):
      ppp: Fix memory leak in ppp_write

Thierry Reding (1):
      net: stmmac: Fix page pool size

Toke Høiland-Jørgensen (1):
      libbpf: Remove getsockopt() check for XDP_OPTIONS

Uwe Kleine-König (2):
      arcnet: provide a buffer big enough to actually receive packets
      dimlib: make DIMLIB a hidden symbol

Vijay Khemka (1):
      net/ncsi: Disable global multicast filter

Vinicius Costa Gomes (1):
      net/sched: cbs: Fix not adding cbs instance to list

Vlad Buslov (3):
      net: sched: sch_htb: don't call qdisc_put() while holding tree lock
      net: sched: multiq: don't call qdisc_put() while holding tree lock
      net: sched: sch_sfb: don't call qdisc_put() while holding tree lock

Xin Long (1):
      macsec: drop skb sk before calling gro_cells_receive

Yan-Hsuan Chuang (3):
      rtw88: pci: extract skbs free routine for trx rings
      rtw88: pci: release tx skbs DMAed when stop
      rtw88: configure firmware after HCI started

Yevgeny Kliteynik (1):
      net/mlx5: DR, Fix SW steering HW bits and definitions

YueHaibing (1):
      gianfar: Make reset_gfar static

 Documentation/devicetree/bindings/net/adi,adin.yaml                |   7 --
 Documentation/devicetree/bindings/net/micrel-ksz90x1.txt           |  32 +++++++-
 Documentation/devicetree/bindings/net/renesas,ravb.txt             |   1 +
 Documentation/devicetree/bindings/net/snps,dwmac.yaml              |   2 +-
 Documentation/networking/devlink-trap.rst                          |   3 +-
 MAINTAINERS                                                        |   1 +
 drivers/atm/he.c                                                   |   2 +-
 drivers/infiniband/core/addr.c                                     |   2 +-
 drivers/isdn/mISDN/socket.c                                        |   2 +
 drivers/net/Kconfig                                                |   2 +-
 drivers/net/arcnet/Kconfig                                         |  26 +++----
 drivers/net/arcnet/arcnet.c                                        |  31 ++++----
 drivers/net/can/usb/Kconfig                                        |   8 +-
 drivers/net/dsa/b53/b53_serdes.h                                   |   4 +-
 drivers/net/dsa/lantiq_pce.h                                       |   2 +-
 drivers/net/dsa/microchip/ksz_common.h                             |   2 +-
 drivers/net/dsa/qca8k.c                                            |   3 +
 drivers/net/dsa/sja1105/Kconfig                                    |   1 +
 drivers/net/ethernet/Kconfig                                       |  11 ---
 drivers/net/ethernet/Makefile                                      |   1 -
 drivers/net/ethernet/allwinner/Kconfig                             |  10 +--
 drivers/net/ethernet/amazon/Kconfig                                |   1 +
 drivers/net/ethernet/amazon/ena/ena_eth_com.c                      |   4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c                    |  15 ++--
 drivers/net/ethernet/broadcom/bcmsysport.c                         |   2 +-
 drivers/net/ethernet/cadence/macb_main.c                           |   5 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                    |   2 +-
 drivers/net/ethernet/emulex/benet/Kconfig                          |   2 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c                    |   2 +-
 drivers/net/ethernet/freescale/gianfar.c                           |   2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c                      |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                                 | 269 ++++++++++++++++++++++++++++++++++++++++++++++++--------------------
 drivers/net/ethernet/ibm/ibmvnic.h                                 |   6 +-
 drivers/net/ethernet/marvell/skge.c                                |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig                    |  36 ++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c            |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                    |  89 ++++++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/main.c                     |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c       |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c      |  13 ++--
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c         |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c          |  50 +++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h        |   7 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c                     |   9 +++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c              |   6 ++
 drivers/net/ethernet/netronome/nfp/abm/cls.c                       |  14 +++-
 drivers/net/ethernet/netronome/nfp/flower/main.c                   |   7 ++
 drivers/net/ethernet/netx-eth.c                                    | 497 -----------------------------------------------------------------------------------------------------------------------------
 drivers/net/ethernet/ni/nixge.c                                    |   2 +-
 drivers/net/ethernet/nxp/Kconfig                                   |   8 +-
 drivers/net/ethernet/pensando/Kconfig                              |   4 +-
 drivers/net/ethernet/pensando/ionic/ionic_debugfs.c                |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                    |   1 +
 drivers/net/ethernet/qlogic/qede/qede_fp.c                         |   3 +-
 drivers/net/ethernet/socionext/netsec.c                            |   2 +-
 drivers/net/ethernet/socionext/sni_ave.c                           |   8 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c                |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c                |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c                |   5 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                  |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c             |  16 ++--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c                  |   2 +-
 drivers/net/macsec.c                                               |   1 +
 drivers/net/phy/Kconfig                                            |   6 +-
 drivers/net/phy/micrel.c                                           |   3 +
 drivers/net/phy/national.c                                         |   9 ++-
 drivers/net/ppp/ppp_generic.c                                      |   2 +
 drivers/net/tap.c                                                  |   2 +-
 drivers/net/usb/cdc_ncm.c                                          |   6 +-
 drivers/net/usb/usbnet.c                                           |   8 ++
 drivers/net/vrf.c                                                  |   3 +-
 drivers/net/wireless/ath/Kconfig                                   |   2 +-
 drivers/net/wireless/ath/ar5523/Kconfig                            |   4 +-
 drivers/net/wireless/ath/ath6kl/Kconfig                            |   2 +-
 drivers/net/wireless/ath/ath9k/Kconfig                             |   2 +-
 drivers/net/wireless/ath/carl9170/Kconfig                          |   6 +-
 drivers/net/wireless/ath/wil6210/txrx.c                            |   2 +-
 drivers/net/wireless/atmel/Kconfig                                 |  32 ++++----
 drivers/net/wireless/intel/ipw2x00/Kconfig                         | 116 ++++++++++++++---------------
 drivers/net/wireless/intel/iwlegacy/Kconfig                        |   6 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig                         |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c                        |   9 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c                    |  11 +--
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h                 |   6 +-
 drivers/net/wireless/ralink/rt2x00/Kconfig                         |  24 +++---
 drivers/net/wireless/realtek/rtw88/mac.c                           |   3 -
 drivers/net/wireless/realtek/rtw88/main.c                          |   4 +
 drivers/net/wireless/realtek/rtw88/pci.c                           |  48 +++++++++---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c                       |   2 +-
 drivers/nfc/st95hf/core.c                                          |   2 +-
 drivers/of/of_mdio.c                                               |   2 +-
 drivers/ptp/ptp_chardev.c                                          |   4 +-
 include/linux/mlx5/mlx5_ifc.h                                      |  28 +++----
 include/linux/platform_data/eth-netx.h                             |  13 ----
 include/linux/skbuff.h                                             |   9 +++
 include/net/inet_timewait_sock.h                                   |   1 +
 include/net/ipv6.h                                                 |   2 +-
 include/net/netfilter/nf_tables.h                                  |   6 ++
 include/net/route.h                                                |   3 +-
 include/net/sch_generic.h                                          |   5 ++
 include/uapi/linux/btf.h                                           |   4 +-
 include/uapi/linux/netfilter_bridge/ebtables.h                     |   6 +-
 include/uapi/linux/ptp_clock.h                                     |  22 ++++++
 kernel/bpf/btf.c                                                   |   7 +-
 kernel/bpf/xskmap.c                                                |   2 +-
 kernel/trace/bpf_trace.c                                           |  26 +++++--
 lib/Kconfig                                                        |   5 +-
 net/appletalk/ddp.c                                                |   5 ++
 net/ax25/af_ax25.c                                                 |   2 +
 net/batman-adv/Kconfig                                             |  10 +--
 net/core/dev.c                                                     |   4 +-
 net/core/dst.c                                                     |   4 +-
 net/core/skbuff.c                                                  |   2 +-
 net/dccp/ipv6.c                                                    |   5 +-
 net/ieee802154/socket.c                                            |   3 +
 net/ife/Kconfig                                                    |   2 +-
 net/ipv4/Kconfig                                                   |   4 +-
 net/ipv4/inet_connection_sock.c                                    |   4 +-
 net/ipv4/ip_forward.c                                              |   2 +-
 net/ipv4/ip_output.c                                               |   3 +-
 net/ipv4/route.c                                                   |  36 +++++----
 net/ipv4/tcp_bbr.c                                                 |   8 +-
 net/ipv4/tcp_ipv4.c                                                |   4 +
 net/ipv4/tcp_minisocks.c                                           |   1 +
 net/ipv4/tcp_timer.c                                               |   5 +-
 net/ipv4/xfrm4_policy.c                                            |   1 +
 net/ipv6/fib6_rules.c                                              |   3 +-
 net/ipv6/inet6_connection_sock.c                                   |   2 +-
 net/ipv6/ip6_fib.c                                                 |   2 +-
 net/ipv6/ip6_output.c                                              |   4 +-
 net/ipv6/netfilter/Kconfig                                         |  16 ++--
 net/ipv6/tcp_ipv6.c                                                |  24 +++---
 net/kcm/kcmsock.c                                                  |   6 +-
 net/ncsi/internal.h                                                |   7 +-
 net/ncsi/ncsi-manage.c                                             |  98 +++----------------------
 net/netfilter/Kconfig                                              |   2 +-
 net/netfilter/ipvs/Kconfig                                         |   6 +-
 net/netfilter/nf_tables_api.c                                      |  25 ++++++-
 net/netfilter/nf_tables_offload.c                                  |   2 +-
 net/netfilter/nft_flow_offload.c                                   |  19 +++++
 net/netfilter/nft_lookup.c                                         |   3 -
 net/nfc/llcp_sock.c                                                |   7 +-
 net/openvswitch/datapath.c                                         |   2 +-
 net/qrtr/qrtr.c                                                    |   1 +
 net/rds/Kconfig                                                    |   4 +-
 net/rds/bind.c                                                     |   5 +-
 net/sched/Kconfig                                                  | 145 ++++++++++++++++++-------------------
 net/sched/act_api.c                                                |  34 +++++----
 net/sched/act_sample.c                                             |   1 +
 net/sched/cls_api.c                                                |   6 +-
 net/sched/sch_api.c                                                |   3 +-
 net/sched/sch_cbs.c                                                |  30 ++++----
 net/sched/sch_htb.c                                                |   4 +-
 net/sched/sch_multiq.c                                             |  23 ++++--
 net/sched/sch_netem.c                                              |   4 +-
 net/sched/sch_sfb.c                                                |   7 +-
 net/sctp/ipv6.c                                                    |   2 +-
 net/xdp/xdp_umem.c                                                 |   2 -
 tools/lib/bpf/btf_dump.c                                           |  94 ++++++++++++++++++++++--
 tools/lib/bpf/xsk.c                                                |  11 ---
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c                   |  21 +++++-
 tools/testing/selftests/bpf/progs/strobemeta.h                     |   5 +-
 tools/testing/selftests/bpf/test_sysctl.c                          |   1 -
 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh |   7 --
 tools/testing/selftests/net/fib_nexthop_multiprefix.sh             |   6 +-
 tools/testing/selftests/net/fib_nexthops.sh                        |  14 ++++
 tools/testing/selftests/net/fib_tests.sh                           |  21 +++++-
 usr/include/Makefile                                               |   1 -
 169 files changed, 1225 insertions(+), 1307 deletions(-)
 delete mode 100644 drivers/net/ethernet/netx-eth.c
 delete mode 100644 include/linux/platform_data/eth-netx.h
