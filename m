Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59DF15680E
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 23:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgBHWgS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 8 Feb 2020 17:36:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55708 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbgBHWgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 17:36:18 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 796971515F5E8;
        Sat,  8 Feb 2020 14:36:16 -0800 (PST)
Date:   Sat, 08 Feb 2020 23:36:12 +0100 (CET)
Message-Id: <20200208.233612.1712791186124406955.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Feb 2020 14:36:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Unbalanced locking in mwifiex_process_country_ie, from Brian
   Norris.

2) Fix thermal zone registration in iwlwifi, from Andrei
   Otcheretianski.

3) Fix double free_irq in sgi ioc3 eth, from Thomas Bogendoerfer.

4) Use after free in mptcp, from Florian Westphal.

5) Use after free in wireguard's root_remove_peer_lists, from
   Eric Dumazet.

6) Properly access packets heads in bonding alb code, from Eric
   Dumazet.

7) Fix data race in skb_queue_len(), from Qian Cai.

8) Fix regression in r8169 on some chips, from Heiner Kallweit.

9) Fix XDP program ref counting in hv_netvsc, from Haiyang Zhang.

10) Certain kinds of set link netlink operations can cause a NULL
    deref in the ipv6 addrconf code.  Fix from Eric Dumazet.

11) Don't cancel uninitialized work queue in drop monitor, from
    Ido Schimmel.

Please pull, thanks a lot!

The following changes since commit 33b40134e5cfbbccad7f3040d1919889537a3df7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-02-04 13:32:20 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 29ca3b31756fb7cfbfc85f2d82a0475bf38cc1ed:

  net: thunderx: use proper interface type for RGMII (2020-02-08 15:28:09 +0100)

----------------------------------------------------------------
Alexei Starovoitov (1):
      bpf: Fix modifier skipping logic

Andrei Otcheretianski (2):
      iwlwifi: mvm: Fix thermal zone registration
      iwlwifi: mvm: Check the sta is not NULL in iwl_mvm_cfg_he_sta()

Andrii Nakryiko (1):
      selftests/bpf: Fix trampoline_count.c selftest compilation warning

Andy Shevchenko (2):
      net: dsa: b53: Platform data shan't include kernel.h
      net: dsa: microchip: Platform data shan't include kernel.h

Avraham Stern (1):
      iwlwifi: mvm: avoid use after free for pmsr request

Brian Norris (1):
      mwifiex: fix unbalanced locking in mwifiex_process_country_ie()

Chin-Yen Lee (1):
      rtw88: Fix return value of rtw_wow_check_fw_status

Cong Wang (1):
      net_sched: fix a resource leak in tcindex_set_parms()

Dan Carpenter (1):
      net: sched: prevent a use after free

Daniel Borkmann (1):
      Merge branch 'bpf-xsk-fixes'

David Howells (2):
      rxrpc: Fix service call disconnection
      rxrpc: Fix call RCU cleanup using non-bh-safe locks

David S. Miller (8):
      Merge branch 'wg-fixes'
      Merge branch 'macb-TSO-bug-fixes'
      Merge tag 'mlx5-fixes-2020-02-06' of git://git.kernel.org/.../saeed/linux
      Merge branch 'taprio-Some-fixes'
      Merge branch 'stmmac-fixes'
      Merge branch 'mlxsw-Various-fixes'
      Merge git://git.kernel.org/.../bpf/bpf
      Merge tag 'wireless-drivers-2020-02-08' of git://git.kernel.org/.../kvalo/wireless-drivers

Dejin Zheng (1):
      net: stmmac: fix a possible endless loop

Devulapally Shiva Krishna (1):
      cxgb4: Added tls stats prints.

Emmanuel Grumbach (1):
      iwlwifi: mvm: fix TDLS discovery with the new firmware API

Eric Dumazet (3):
      wireguard: allowedips: fix use-after-free in root_remove_peer_lists
      bonding/alb: properly access headers in bond_alb_xmit()
      ipv6/addrconf: fix potential NULL deref in inet6_set_link_af()

Florian Fainelli (3):
      net: systemport: Avoid RBUF stuck in Wake-on-LAN mode
      net: dsa: b53: Always use dev->vlan_enabled in b53_configure_vlan()
      net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port

Florian Westphal (2):
      mptcp: fix use-after-free on tcp fallback
      mptcp: fix use-after-free for ipv6

Golan Ben Ami (1):
      iwlwifi: mvm: update the DTS measurement type

Haiyang Zhang (1):
      hv_netvsc: Fix XDP refcnt for synthetic and VF NICs

Harini Katakam (2):
      net: macb: Remove unnecessary alignment check for TSO
      net: macb: Limit maximum GEM TX length in TSO

Heiner Kallweit (1):
      r8169: fix performance regression related to PCIe max read request size

Ido Schimmel (5):
      mlxsw: spectrum_router: Prevent incorrect replacement of local table routes
      selftests: mlxsw: Add test cases for local table route replacement
      mlxsw: spectrum_router: Clear offload indication from IPv6 nexthops on abort
      mlxsw: spectrum_dpipe: Add missing error path
      drop_monitor: Do not cancel uninitialized work item

Jacob Keller (1):
      devlink: report 0 after hitting end in region read

Jakub Sitnicki (3):
      bpf, sockmap: Don't sleep while holding RCU lock on tear-down
      bpf, sockhash: Synchronize_rcu before free'ing map
      selftests/bpf: Test freeing sockmap/sockhash with a socket in it

Jason A. Donenfeld (3):
      wireguard: noise: reject peers with low order public keys
      wireguard: selftests: ensure non-addition of peers with failed precomputation
      wireguard: selftests: tie socket waiting to target pid

Krzysztof Kozlowski (1):
      wireguard: selftests: cleanup CONFIG_ENABLE_WARN_DEPRECATED

Lorenz Bauer (1):
      bpf, sockmap: Check update requirements after locking

Lorenzo Bianconi (2):
      net: mvneta: move rx_dropped and rx_errors in per-cpu stats
      mt76: mt7615: fix max_nss in mt7615_eeprom_parse_hw_cap

Luca Coelho (1):
      iwlwifi: don't throw error when trying to remove IGTK

Maciej Fijalkowski (3):
      i40e: Relax i40e_xsk_wakeup's return value when PF is busy
      samples: bpf: Drop doubled variable declaration in xdpsock
      samples: bpf: Allow for -ENETDOWN in xdpsock

Madalin Bucur (1):
      dpaa_eth: support all modes with rate adapting PHYs

Maor Gottlieb (1):
      net/mlx5: Fix deadlock in fs_core

Martin KaFai Lau (2):
      bpf: Reuse log from btf_prase_vmlinux() in btf_struct_ops_init()
      bpf: Improve bucket_log calculation logic

Michal Rostecki (1):
      bpftool: Remove redundant "HAVE" prefix from the large INSN limit check

Mordechay Goodstein (1):
      iwlwifi: d3: read all FW CPUs error info

Moritz Fischer (1):
      net: ethernet: dec: tulip: Fix length mask in receive length calculation

Nicolai Stange (2):
      libertas: don't exit from lbs_ibss_join_existing() with RCU read lock held
      libertas: make lbs_ibss_join_existing() return error code on rates overflow

Ong Boon Leong (1):
      net: stmmac: xgmac: fix incorrect XGMAC_VLAN_TAG register writting

Qian Cai (1):
      skbuff: fix a data race in skb_queue_len()

Qing Xu (2):
      mwifiex: Fix possible buffer overflows in mwifiex_ret_wmm_get_status()
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_append_vsie_tlv()

Raed Salem (2):
      net/mlx5: IPsec, Fix esp modify function attribute
      net/mlx5: IPsec, fix memory leak at mlx5_fpga_ipsec_delete_sa_ctx

Razvan Stefanescu (1):
      net: dsa: microchip: enable module autoprobe

Song Liu (1):
      tools/bpf/runqslower: Rebuild libbpf.a on libbpf source change

Sudarsana Reddy Kalluru (1):
      qed: Fix timestamping issue for L2 unicast ptp packets.

Tan, Tee Min (2):
      net: stmmac: fix incorrect GMAC_VLAN_TAG register writting in GMAC4+
      net: stmmac: xgmac: fix missing IFF_MULTICAST checki in dwxgmac2_set_filter

Tariq Toukan (2):
      net/mlx5e: TX, Error completion is for last WQE in batch
      net/mlx5: Deprecate usage of generic TLS HW capability bit

Thomas Bogendoerfer (1):
      net: sgi: ioc3-eth: Remove leftover free_irq()

Tim Harvey (1):
      net: thunderx: use proper interface type for RGMII

Toke Høiland-Jørgensen (1):
      bpftool: Don't crash on missing xlated program instructions

Vadim Pasternak (1):
      mlxsw: core: Add validation of hardware device types for MGPIR register

Verma, Aashish (1):
      net: stmmac: fix missing IFF_MULTICAST check in dwmac4_set_filter

Vinicius Costa Gomes (5):
      taprio: Fix enabling offload with wrong number of traffic classes
      taprio: Fix still allowing changing the flags during runtime
      taprio: Add missing policy validation for flags
      taprio: Use taprio_reset_tc() to reset Traffic Classes configuration
      taprio: Fix dropping packets when using taprio + ETF offloading

Voon Weifeng (1):
      net: stmmac: update pci platform data to use phy_interface

Yulia Kartseva (1):
      runqslower: Fix Makefile

kbuild test robot (1):
      netdevsim: fix ptr_ret.cocci warnings

 drivers/net/bonding/bond_alb.c                              |  44 ++++++++++++++++++++++++++++++------------
 drivers/net/dsa/b53/b53_common.c                            |   2 +-
 drivers/net/dsa/bcm_sf2.c                                   |   4 +++-
 drivers/net/dsa/microchip/ksz9477_spi.c                     |   6 ++++++
 drivers/net/ethernet/broadcom/bcmsysport.c                  |   3 +++
 drivers/net/ethernet/cadence/macb_main.c                    |  14 ++++++++------
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c           |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c          |   7 +++++++
 drivers/net/ethernet/dec/tulip/de2104x.c                    |   5 ++++-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c              |  14 +++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c                  |   2 +-
 drivers/net/ethernet/marvell/mvneta.c                       |  31 +++++++++++++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h         |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c             |  16 +++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c             |  33 ++++++++++++++------------------
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c        |   3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c           |  15 ++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/fw.c                |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c            |   6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c          |   8 ++++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c        |   3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c       |  55 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/net/ethernet/qlogic/qed/qed_ptp.c                   |   4 ++--
 drivers/net/ethernet/realtek/r8169_main.c                   |   6 ++++++
 drivers/net/ethernet/sgi/ioc3-eth.c                         |   1 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c     |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c           |   9 +++++----
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c         |  10 +++++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c            |  14 ++++++++------
 drivers/net/hyperv/netvsc_bpf.c                             |  13 +++++++++++--
 drivers/net/hyperv/netvsc_drv.c                             |   5 ++++-
 drivers/net/netdevsim/dev.c                                 |   4 +---
 drivers/net/wireguard/allowedips.c                          |   1 +
 drivers/net/wireguard/netlink.c                             |   6 ++----
 drivers/net/wireguard/noise.c                               |  10 +++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c                 |  52 ++++++++++++++++++++++++++++++++++++++------------
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c      |   5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c           |  10 ++++------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                |  10 +++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c               |  10 ++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c         |  71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.h         |   4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c                 |  10 ++++++----
 drivers/net/wireless/marvell/libertas/cfg.c                 |   2 ++
 drivers/net/wireless/marvell/mwifiex/scan.c                 |   7 +++++++
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c            |   1 +
 drivers/net/wireless/marvell/mwifiex/wmm.c                  |   4 ++++
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c          |   3 ++-
 drivers/net/wireless/realtek/rtw88/wow.c                    |  23 +++++++++++-----------
 include/linux/bpf.h                                         |   7 +++++--
 include/linux/mlx5/mlx5_ifc.h                               |   7 ++++---
 include/linux/platform_data/b53.h                           |   2 +-
 include/linux/platform_data/microchip-ksz.h                 |   2 +-
 include/linux/skbuff.h                                      |  14 +++++++++++++-
 include/net/ipx.h                                           |   5 -----
 kernel/bpf/bpf_struct_ops.c                                 |   5 ++---
 kernel/bpf/btf.c                                            |  10 ++++------
 net/core/bpf_sk_storage.c                                   |   5 +++--
 net/core/devlink.c                                          |   6 ++++++
 net/core/drop_monitor.c                                     |   4 +++-
 net/core/sock_map.c                                         |  28 +++++++++++++++++----------
 net/ipv6/addrconf.c                                         |   3 +++
 net/mptcp/protocol.c                                        | 106 ++++++++++++++++++++++++++++++++++-------------------------------------------------------------------
 net/rxrpc/call_object.c                                     |  22 ++++++++++++++++++---
 net/rxrpc/conn_object.c                                     |   3 +--
 net/sched/cls_tcindex.c                                     |   3 +--
 net/sched/sch_fq_pie.c                                      |   2 +-
 net/sched/sch_taprio.c                                      |  92 +++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------
 net/unix/af_unix.c                                          |  11 +++++++++--
 samples/bpf/xdpsock_user.c                                  |   4 ++--
 tools/bpf/bpftool/feature.c                                 |   2 +-
 tools/bpf/bpftool/prog.c                                    |   2 +-
 tools/bpf/runqslower/Makefile                               |   4 ++--
 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c      |  74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/trampoline_count.c   |   2 +-
 tools/testing/selftests/drivers/net/mlxsw/fib.sh            |  76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/net/mptcp/mptcp_connect.c           |   9 +++++++++
 tools/testing/selftests/wireguard/netns.sh                  |  23 +++++++++++++---------
 tools/testing/selftests/wireguard/qemu/debug.config         |   1 -
 80 files changed, 782 insertions(+), 327 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
