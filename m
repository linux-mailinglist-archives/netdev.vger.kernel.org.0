Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E79EECC09
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 00:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfKAXud convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 1 Nov 2019 19:50:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47808 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAXuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 19:50:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6303E151D0534;
        Fri,  1 Nov 2019 16:50:31 -0700 (PDT)
Date:   Fri, 01 Nov 2019 16:50:29 -0700 (PDT)
Message-Id: <20191101.165029.1804551650613208564.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 16:50:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix free/alloc races in batmanadv, from Sven Eckelmann.

2) Several leaks and other fixes in kTLS support of mlx5 driver,
   from Tariq Toukan.

3) BPF devmap_hash cost calculation can overflow on 32-bit, from
   Toke Høiland-Jørgensen.

4) Add an r8152 device ID, from Kazutoshi Noguchi.

5) Missing include in ipv6's addrconf.c, from Ben Dooks.

6) Use siphash in flow dissector, from Eric Dumazet.  Attackers can
   easily infer the 32-bit secret otherwise etc.

7) Several netdevice nesting depth fixes from Taehee Yoo.

8) Fix several KCSAN reported errors, from Eric Dumazet.  For example,
   when doing lockless skb_queue_empty() checks, and accessing
   sk_napi_id/sk_incoming_cpu lockless as well.

9) Fix jumbo packet handling in RXRPC, from David Howells.

10) Bump SOMAXCONN and tcp_max_syn_backlog values, from Eric
    Dumazet.

11) Fix DMA synchronization in gve driver, from Yangchun Fu.

12) Several bpf offload fixes, from Jakub Kicinski.

13) Fix sk_page_frag() recursion during memory reclaim, from Tejun
    Heo.

14) Fix ping latency during high traffic rates in hisilicon driver,
    from Jiangfent Xiao.

Please pull, thanks a lot!

The following changes since commit 531e93d11470aa2e14e6a3febef50d9bc7bab7a1:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2019-10-19 17:09:11 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to aeb1b85c340c54dc1d68ff96b02d439d6a4f7150:

  Merge branch 'fix-BPF-offload-related-bugs' (2019-11-01 15:16:01 -0700)

----------------------------------------------------------------
Anson Huang (2):
      net: fec_main: Use platform_get_irq_byname_optional() to avoid error message
      net: fec_ptp: Use platform_get_irq_xxx_optional() to avoid error message

Arnd Bergmann (2):
      dynamic_debug: provide dynamic_hex_dump stub
      net: dsa: sja1105: improve NET_DSA_SJA1105_TAS dependency

Aya Levin (2):
      net/mlx5e: Fix ethtool self test: link speed
      net/mlx5e: Initialize on stack link modes bitmap

Ayala Beker (1):
      iwlwifi: fw api: support new API for scan config cmd

Ben Dooks (Codethink) (3):
      ipv6: include <net/addrconf.h> for missing declarations
      net: mvneta: make stub functions static inline
      net: hwbm: if CONFIG_NET_HWBM unset, make stub functions static

Benjamin Herrenschmidt (1):
      net: ethernet: ftgmac100: Fix DMA coherency issue with SW checksum

Chuhong Yuan (1):
      net: ethernet: arc: add the missed clk_disable_unprepare

Colin Ian King (1):
      qed: fix spelling mistake "queuess" -> "queues"

Daniel Borkmann (2):
      bpf: Fix use after free in subprog's jited symbol removal
      bpf: Fix use after free in bpf_get_prog_name

Daniel Wagner (1):
      net: usb: lan78xx: Disable interrupts before calling generic_handle_irq()

David Ahern (1):
      selftests: Make l2tp.sh executable

David Howells (1):
      rxrpc: Fix handling of last subpacket of jumbo packet

David S. Miller (15):
      Merge tag 'mlx5-fixes-2019-10-18' of git://git.kernel.org/.../saeed/linux
      Merge branch 'net-fix-nested-device-bugs'
      Merge branch 'smc-fixes'
      Merge branch 'ipv4-fix-route-update-on-metric-change'
      Merge git://git.kernel.org/.../bpf/bpf
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'net-avoid-KCSAN-splats'
      Merge tag 'batadv-net-for-davem-20191025' of git://git.open-mesh.org/linux-merge
      Merge branch 'VLAN-fixes-for-Ocelot-switch'
      Merge tag 'mlx5-fixes-2019-10-24' of git://git.kernel.org/.../saeed/linux
      Merge branch 'hv_netvsc-fix-error-handling-in-netvsc_attach-set_features'
      Merge tag 'mac80211-for-net-2019-10-31' of git://git.kernel.org/.../jberg/mac80211
      Merge tag 'wireless-drivers-2019-11-01' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge branch '1GbE' of git://git.kernel.org/.../jkirsher/net-queue
      Merge branch 'fix-BPF-offload-related-bugs'

Davide Caratti (1):
      ipvs: don't ignore errors in case refcounting ip_vs module fails

Dmytro Linkin (2):
      net/mlx5e: Determine source port properly for vlan push action
      net/mlx5e: Remove incorrect match criteria assignment line

Eli Britstein (1):
      net/mlx5: Fix NULL pointer dereference in extended destination

Eran Ben Elisha (1):
      net/mlx4_core: Dynamically set guaranteed amount of counters per VF

Eric Dumazet (14):
      ipv4: fix IPSKB_FRAG_PMTU handling with fragmentation
      net/flow_dissector: switch to siphash
      ipvs: move old_secure_tcp into struct netns_ipvs
      net: add skb_queue_empty_lockless()
      udp: use skb_queue_empty_lockless()
      net: use skb_queue_empty_lockless() in poll() handlers
      net: use skb_queue_empty_lockless() in busy poll contexts
      net: add READ_ONCE() annotation in __skb_wait_for_more_packets()
      udp: fix data-race in udp_set_dev_scratch()
      net: annotate accesses to sk->sk_incoming_cpu
      net: annotate lockless accesses to sk->sk_napi_id
      net: increase SOMAXCONN to 4096
      tcp: increase tcp_max_syn_backlog max value
      inet: stop leaking jiffies on the wire

Florian Fainelli (2):
      net: phylink: Fix phylink_dbg() macro
      net: dsa: bcm_sf2: Fix IMP setup for port different than 8

Guillaume Nault (1):
      netns: fix GFP flags in rtnl_net_notifyid()

Haiyang Zhang (2):
      hv_netvsc: Fix error handling in netvsc_set_features()
      hv_netvsc: Fix error handling in netvsc_attach()

Heiner Kallweit (1):
      r8169: fix wrong PHY ID issue with RTL8168dp

Hillf Danton (1):
      net: openvswitch: free vport unless register_netdevice() succeeds

Ido Schimmel (1):
      netdevsim: Fix use-after-free during device dismantle

Igor Pylypiv (1):
      ixgbe: Remove duplicate clear_bit() call

Jakub Kicinski (5):
      Merge branch 'bnxt_en-bug-fixes'
      MAINTAINERS: remove Dave Watson as TLS maintainer
      selftests: bpf: Skip write only files in debugfs
      net: cls_bpf: fix NULL deref on offload filter removal
      net: fix installing orphaned programs

Jeff Kirsher (1):
      i40e: Fix receive buffer starvation for AF_XDP

Jiangfeng Xiao (2):
      net: hisilicon: Fix "Trying to free already-free IRQ"
      net: hisilicon: Fix ping latency when deal with high throughput

Jiri Benc (2):
      bpf: lwtunnel: Fix reroute supplying invalid dst
      selftests/bpf: More compatible nc options in test_tc_edt

Jiri Pirko (1):
      mlxsw: core: Unpublish devlink parameters during reload

Johannes Berg (1):
      iwlwifi: mvm: handle iwl_mvm_tvqm_enable_txq() error return

Jonathan Neuschäfer (1):
      Documentation: networking: device drivers: Remove stray asterisks

Kazutoshi Noguchi (1):
      r8152: add device id for Lenovo ThinkPad USB-C Dock Gen 2

Larry Finger (1):
      rtlwifi: rtl_pci: Fix problem of too small skb->len

Laura Abbott (1):
      rtlwifi: Fix potential overflow on P2P code

Lorenzo Bianconi (2):
      mt76: mt76x2e: disable pcie_aspm by default
      mt76: dma: fix buffer unmap with non-linear skbs

Luca Coelho (5):
      iwlwifi: pcie: fix merge damage on making QnJ exclusive
      iwlwifi: pcie: fix PCI ID 0x2720 configs that should be soc
      iwlwifi: pcie: fix all 9460 entries for qnj
      iwlwifi: pcie: add workaround for power gating in integrated 22000
      iwlwifi: pcie: 0x2720 is qu and 0x30DC is not

Lyude Paul (1):
      igb/igc: Don't warn on fatal read failures when the device is removed

Magnus Karlsson (1):
      xsk: Fix registration of Rx-only sockets

Manfred Rudigier (2):
      igb: Enable media autosense for the i350.
      igb: Fix constant media auto sense switching when no cable is connected

Maor Gottlieb (1):
      net/mlx5e: Replace kfree with kvfree when free vhca stats

Markus Theil (1):
      nl80211: fix validation of mesh path nexthop

Martin Fuzzey (1):
      net: phy: smsc: LAN8740: add PHY_RST_AFTER_CLK_EN flag

Masashi Honma (1):
      nl80211: Disallow setting of HT for channel 14

Maxim Mikityanskiy (1):
      net/mlx5e: Fix handling of compressed CQEs in case of low NAPI budget

Michael Chan (1):
      bnxt_en: Fix devlink NVRAM related byte order related issues.

Navid Emamdoost (3):
      net/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq
      net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump
      wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle

Nikolay Aleksandrov (1):
      net: rtnetlink: fix a typo fbd -> fdb

Nishad Kamdar (2):
      net: ethernet: Use the correct style for SPDX License Identifier
      net: dpaa2: Use the correct style for SPDX License Identifier

Pablo Neira Ayuso (3):
      netfilter: nf_flow_table: set timeout before insertion into hashes
      netfilter: nf_tables_offload: restore basechain deletion
      Merge tag 'ipvs-fixes-for-v5.4' of https://git.kernel.org/.../horms/ipvs

Paolo Abeni (2):
      ipv4: fix route update on metric change.
      selftests: fib_tests: add more tests for metric update

Parav Pandit (1):
      net/mlx5: Fix rtable reference leak

Raju Rangoju (1):
      cxgb4: request the TX CIDX updates to status page

Roi Dayan (1):
      net/mlx5: Fix flow counter list auto bits struct

Sudarsana Reddy Kalluru (1):
      qed: Optimize execution time for nvm attributes configuration.

Sven Eckelmann (2):
      batman-adv: Avoid free/alloc race when handling OGM2 buffer
      batman-adv: Avoid free/alloc race when handling OGM buffer

Taehee Yoo (12):
      net: core: limit nested device depth
      net: core: add generic lockdep keys
      bonding: fix unexpected IFF_BONDING bit unset
      bonding: use dynamic lockdep key instead of subclass
      team: fix nested locking lockdep warning
      macsec: fix refcnt leak in module exit routine
      net: core: add ignore flag to netdev_adjacent structure
      vxlan: add adjacent link to limit depth level
      net: remove unnecessary variables and callback
      virt_wifi: fix refcnt leak in module exit routine
      bonding: fix using uninitialized mode_lock
      vxlan: fix unexpected failure of vxlan_changelink()

Takeshi Misawa (1):
      keys: Fix memory leak in copy_net_ns

Tariq Toukan (13):
      net/mlx5e: Tx, Fix assumption of single WQEBB of NOP in cleanup flow
      net/mlx5e: Tx, Zero-memset WQE info struct upon update
      net/mlx5e: kTLS, Release reference on DUMPed fragments in shutdown flow
      net/mlx5e: kTLS, Size of a Dump WQE is fixed
      net/mlx5e: kTLS, Save only the frag page to release at completion
      net/mlx5e: kTLS, Save by-value copy of the record frags
      net/mlx5e: kTLS, Fix page refcnt leak in TX resync error flow
      net/mlx5e: kTLS, Fix missing SQ edge fill
      net/mlx5e: kTLS, Limit DUMP wqe size
      net/mlx5e: kTLS, Remove unneeded cipher type checks
      net/mlx5e: kTLS, Save a copy of the crypto info
      net/mlx5e: kTLS, Enhance TX resync flow
      net/mlx5e: TX, Fix consumer index of error cqe dump

Tejun Heo (1):
      net: fix sk_page_frag() recursion from memory reclaim

Toke Høiland-Jørgensen (2):
      xdp: Prevent overflow in devmap_hash cost calculation for 32-bit builds
      xdp: Handle device unregister for devmap_hash map type

Ursula Braun (3):
      net/smc: fix closing of fallback SMC sockets
      net/smc: keep vlan_id for SMC-R in smc_listen_work()
      net/smc: fix refcounting for non-blocking connect()

Vasundhara Volam (4):
      bnxt_en: Fix the size of devlink MSIX parameters.
      bnxt_en: Adjust the time to wait before polling firmware readiness.
      bnxt_en: Minor formatting changes in FW devlink_health_reporter
      bnxt_en: Avoid disabling pci device in bnxt_remove_one() for already disabled device.

Vincent Prince (1):
      net: sch_generic: Use pfifo_fast as fallback scheduler for CAN hardware

Vishal Kulkarni (1):
      cxgb4: fix panic when attaching to ULD fail

Vlad Buslov (2):
      net/mlx5e: Only skip encap flows update when encap init failed
      net/mlx5e: Don't store direct pointer to action's tunnel info

Vladimir Oltean (2):
      net: mscc: ocelot: fix vlan_filtering when enslaving to bridge before link is up
      net: mscc: ocelot: refuse to overwrite the port's native vlan

Wei Wang (1):
      selftests: net: reuseport_dualstack: fix uninitalized parameter

Wenwen Wang (1):
      e1000: fix memory leaks

Will Deacon (1):
      fjes: Handle workqueue allocation failure

Xin Long (2):
      erspan: fix the tun_info options_len check for erspan
      vxlan: check tun_info options_len properly

Yangchun Fu (1):
      gve: Fixes DMA synchronization.

Yi Wang (1):
      net: sched: taprio: fix -Wmissing-prototypes warnings

wenxu (1):
      netfilter: nft_payload: fix missing check for matching length in offloads

yuqi jin (1):
      net: stmmac: Fix the problem of tso_xmit

zhanglin (1):
      net: Zeroing the structure ethtool_wolinfo in ethtool_get_wol()

 Documentation/networking/device_drivers/intel/e100.rst             |  14 +-
 Documentation/networking/device_drivers/intel/e1000.rst            |  12 +-
 Documentation/networking/device_drivers/intel/e1000e.rst           |  14 +-
 Documentation/networking/device_drivers/intel/fm10k.rst            |  10 +-
 Documentation/networking/device_drivers/intel/i40e.rst             |   8 +-
 Documentation/networking/device_drivers/intel/iavf.rst             |   8 +-
 Documentation/networking/device_drivers/intel/ice.rst              |   6 +-
 Documentation/networking/device_drivers/intel/igb.rst              |  12 +-
 Documentation/networking/device_drivers/intel/igbvf.rst            |   6 +-
 Documentation/networking/device_drivers/intel/ixgbe.rst            |  10 +-
 Documentation/networking/device_drivers/intel/ixgbevf.rst          |   6 +-
 Documentation/networking/device_drivers/pensando/ionic.rst         |   6 +-
 Documentation/networking/ip-sysctl.txt                             |  11 +-
 MAINTAINERS                                                        |   1 -
 drivers/crypto/chelsio/chtls/chtls_cm.c                            |   2 +-
 drivers/crypto/chelsio/chtls/chtls_io.c                            |   2 +-
 drivers/isdn/capi/capi.c                                           |   2 +-
 drivers/net/bonding/bond_alb.c                                     |   2 +-
 drivers/net/bonding/bond_main.c                                    |  28 ++--
 drivers/net/dsa/bcm_sf2.c                                          |  36 +++--
 drivers/net/dsa/sja1105/Kconfig                                    |   4 +-
 drivers/net/ethernet/arc/emac_rockchip.c                           |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                          |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c                  | 112 +++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h                  |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c                     |  28 ++--
 drivers/net/ethernet/chelsio/cxgb4/sge.c                           |   8 +-
 drivers/net/ethernet/cortina/gemini.h                              |   2 +-
 drivers/net/ethernet/faraday/ftgmac100.c                           |  25 ++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h                   |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h                   |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dprtc.h                       |   2 +-
 drivers/net/ethernet/freescale/fec_main.c                          |   2 +-
 drivers/net/ethernet/freescale/fec_ptp.c                           |   4 +-
 drivers/net/ethernet/google/gve/gve_rx.c                           |   2 +
 drivers/net/ethernet/google/gve/gve_tx.c                           |  24 +++-
 drivers/net/ethernet/hisilicon/hip04_eth.c                         |  16 ++-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c                   |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c                         |   5 -
 drivers/net/ethernet/intel/igb/e1000_82575.c                       |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c                          |   8 +-
 drivers/net/ethernet/intel/igc/igc_main.c                          |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                      |   1 -
 drivers/net/ethernet/marvell/mvneta_bm.h                           |  32 +++--
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c              |  42 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en.h                       |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c         |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c                |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h                  |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c            |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h            |  29 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c         | 190 ++++++++++++++----------
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c               |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                  |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c                   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                    |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c              |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c                 |  16 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h                 |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                    |  36 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c                    |  35 +++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c         |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c |  22 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c                |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c                   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c                   |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c                         |   4 +-
 drivers/net/ethernet/mscc/ocelot.c                                 |  11 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c                  |  18 ---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                    |   2 +
 drivers/net/ethernet/pensando/ionic/ionic_main.c                   |   2 +
 drivers/net/ethernet/qlogic/qed/qed_main.c                         |  27 +++-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c                        |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c                          |   4 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                  |   1 +
 drivers/net/fjes/fjes_main.c                                       |  15 +-
 drivers/net/hamradio/bpqether.c                                    |  22 ---
 drivers/net/hyperv/netvsc_drv.c                                    |  15 +-
 drivers/net/ipvlan/ipvlan_main.c                                   |   2 -
 drivers/net/macsec.c                                               |  18 ---
 drivers/net/macvlan.c                                              |  19 ---
 drivers/net/netdevsim/dev.c                                        |   5 +
 drivers/net/phy/phylink.c                                          |  16 +++
 drivers/net/phy/smsc.c                                             |   1 +
 drivers/net/ppp/ppp_generic.c                                      |   2 -
 drivers/net/team/team.c                                            |  16 ++-
 drivers/net/usb/cdc_ether.c                                        |   7 +
 drivers/net/usb/lan78xx.c                                          |   5 +-
 drivers/net/usb/r8152.c                                            |   1 +
 drivers/net/vrf.c                                                  |   1 -
 drivers/net/vxlan.c                                                |  62 ++++++--
 drivers/net/wimax/i2400m/op-rfkill.c                               |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h                   |  22 ++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h                       |   3 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h                       |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h                      |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                       |   6 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c                      |  40 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                       | 140 ++++++++++--------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                      | 131 +++++++++--------
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c               |  25 ++++
 drivers/net/wireless/intersil/hostap/hostap_hw.c                   |  25 ----
 drivers/net/wireless/mediatek/mt76/Makefile                        |   2 +
 drivers/net/wireless/mediatek/mt76/dma.c                           |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76.h                          |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c                    |   2 +
 drivers/net/wireless/mediatek/mt76/pci.c                           |  46 ++++++
 drivers/net/wireless/realtek/rtlwifi/pci.c                         |   3 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c                          |   6 +
 drivers/net/wireless/virt_wifi.c                                   |  54 ++++++-
 drivers/nvme/host/tcp.c                                            |   2 +-
 include/linux/dynamic_debug.h                                      |   6 +
 include/linux/filter.h                                             |   1 -
 include/linux/gfp.h                                                |  23 +++
 include/linux/if_macvlan.h                                         |   1 -
 include/linux/if_team.h                                            |   1 +
 include/linux/if_vlan.h                                            |  11 --
 include/linux/mlx5/mlx5_ifc.h                                      |   3 +-
 include/linux/netdevice.h                                          |  61 ++++----
 include/linux/skbuff.h                                             |  36 +++--
 include/linux/socket.h                                             |   2 +-
 include/net/bonding.h                                              |   2 +-
 include/net/busy_poll.h                                            |   6 +-
 include/net/flow_dissector.h                                       |   3 +-
 include/net/fq.h                                                   |   2 +-
 include/net/fq_impl.h                                              |   4 +-
 include/net/hwbm.h                                                 |  10 +-
 include/net/ip.h                                                   |   4 +-
 include/net/ip_vs.h                                                |   1 +
 include/net/net_namespace.h                                        |   2 +-
 include/net/sock.h                                                 |  15 +-
 include/net/vxlan.h                                                |   1 +
 kernel/bpf/core.c                                                  |   2 +-
 kernel/bpf/devmap.c                                                |  33 ++++-
 kernel/bpf/syscall.c                                               |  31 ++--
 net/8021q/vlan.c                                                   |   1 -
 net/8021q/vlan_dev.c                                               |  33 -----
 net/atm/common.c                                                   |   2 +-
 net/batman-adv/bat_iv_ogm.c                                        |  61 ++++++--
 net/batman-adv/bat_v_ogm.c                                         |  41 ++++--
 net/batman-adv/hard-interface.c                                    |   2 +
 net/batman-adv/soft-interface.c                                    |  32 -----
 net/batman-adv/types.h                                             |   7 +
 net/bluetooth/6lowpan.c                                            |   8 --
 net/bluetooth/af_bluetooth.c                                       |   4 +-
 net/bridge/br_device.c                                             |   8 --
 net/bridge/netfilter/nf_conntrack_bridge.c                         |   2 +-
 net/caif/caif_socket.c                                             |   2 +-
 net/core/datagram.c                                                |   8 +-
 net/core/dev.c                                                     | 623 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
 net/core/dev_addr_lists.c                                          |  12 +-
 net/core/ethtool.c                                                 |   4 +-
 net/core/flow_dissector.c                                          |  38 +++--
 net/core/lwt_bpf.c                                                 |   7 +-
 net/core/net_namespace.c                                           |  18 +--
 net/core/rtnetlink.c                                               |  17 +--
 net/core/sock.c                                                    |   6 +-
 net/dccp/ipv4.c                                                    |   2 +-
 net/decnet/af_decnet.c                                             |   2 +-
 net/dsa/master.c                                                   |   5 -
 net/dsa/slave.c                                                    |  12 --
 net/ieee802154/6lowpan/core.c                                      |   8 --
 net/ipv4/datagram.c                                                |   2 +-
 net/ipv4/fib_frontend.c                                            |   2 +-
 net/ipv4/inet_hashtables.c                                         |   2 +-
 net/ipv4/ip_gre.c                                                  |   4 +-
 net/ipv4/ip_output.c                                               |  11 +-
 net/ipv4/tcp.c                                                     |   4 +-
 net/ipv4/tcp_ipv4.c                                                |   6 +-
 net/ipv4/udp.c                                                     |  29 ++--
 net/ipv6/addrconf_core.c                                           |   1 +
 net/ipv6/inet6_hashtables.c                                        |   2 +-
 net/ipv6/ip6_gre.c                                                 |   4 +-
 net/ipv6/udp.c                                                     |   2 +-
 net/l2tp/l2tp_eth.c                                                |   1 -
 net/netfilter/ipvs/ip_vs_app.c                                     |  12 +-
 net/netfilter/ipvs/ip_vs_ctl.c                                     |  29 ++--
 net/netfilter/ipvs/ip_vs_pe.c                                      |   3 +-
 net/netfilter/ipvs/ip_vs_sched.c                                   |   3 +-
 net/netfilter/ipvs/ip_vs_sync.c                                    |  13 +-
 net/netfilter/nf_flow_table_core.c                                 |   3 +-
 net/netfilter/nf_tables_offload.c                                  |   2 +-
 net/netfilter/nft_payload.c                                        |  38 +++++
 net/netrom/af_netrom.c                                             |  23 ---
 net/nfc/llcp_sock.c                                                |   4 +-
 net/openvswitch/datapath.c                                         |  20 +--
 net/openvswitch/vport-internal_dev.c                               |  11 +-
 net/phonet/socket.c                                                |   4 +-
 net/rose/af_rose.c                                                 |  23 ---
 net/rxrpc/ar-internal.h                                            |   1 +
 net/rxrpc/recvmsg.c                                                |  18 ++-
 net/sched/cls_bpf.c                                                |   8 +-
 net/sched/sch_generic.c                                            |  19 ++-
 net/sched/sch_hhf.c                                                |   8 +-
 net/sched/sch_sfb.c                                                |  13 +-
 net/sched/sch_sfq.c                                                |  14 +-
 net/sched/sch_taprio.c                                             |   2 +-
 net/sctp/socket.c                                                  |   8 +-
 net/smc/af_smc.c                                                   |  13 +-
 net/smc/smc_core.c                                                 |   2 +-
 net/smc/smc_pnet.c                                                 |   2 +-
 net/tipc/socket.c                                                  |   4 +-
 net/unix/af_unix.c                                                 |   6 +-
 net/vmw_vsock/af_vsock.c                                           |   2 +-
 net/wireless/chan.c                                                |   5 +
 net/wireless/nl80211.c                                             |   2 +-
 net/wireless/util.c                                                |   3 +-
 net/xdp/xdp_umem.c                                                 |   6 +
 tools/testing/selftests/bpf/test_offload.py                        |   5 +
 tools/testing/selftests/bpf/test_tc_edt.sh                         |   2 +-
 tools/testing/selftests/net/fib_tests.sh                           |  21 +++
 tools/testing/selftests/net/l2tp.sh                                |   0
 tools/testing/selftests/net/reuseport_dualstack.c                  |   3 +-
 213 files changed, 2133 insertions(+), 1289 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/pci.c
 mode change 100644 => 100755 tools/testing/selftests/net/l2tp.sh
