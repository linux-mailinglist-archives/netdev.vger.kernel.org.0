Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93CA21931DC
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 21:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgCYUY1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Mar 2020 16:24:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47304 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbgCYUY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 16:24:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4593215A0E10E;
        Wed, 25 Mar 2020 13:24:25 -0700 (PDT)
Date:   Wed, 25 Mar 2020 13:24:24 -0700 (PDT)
Message-Id: <20200325.132424.1374007175286656428.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Mar 2020 13:24:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix deadlock in bpf_send_signal() from Yonghong Song.

2) Fix off by one in kTLS offload of mlx5, from Tariq Toukan.

3) Add missing locking in iwlwifi mvm code, from Avraham Stern.

4) Fix MSG_WAITALL handling in rxrpc, from David Howells.

5) Need to hold RTNL mutex in tcindex_partial_destroy_work(), from
   Cong Wang.

6) Fix producer race condition in AF_PACKET, from Willem de Bruijn.

7) cls_route removes the wrong filter during change operations, from
   Cong Wang.

8) Reject unrecognized request flags in ethtool netlink code, from
   Michal Kubecek.

9) Need to keep MAC in reset until PHY is up in bcmgenet driver,
   from Doug Berger.

10) Don't leak ct zone template in act_ct during replace, from Paul
    Blakey.

11) Fix flushing of offloaded netfilter flowtable flows, also from
    Paul Blakey.

12) Fix throughput drop during tx backpressure in cxgb4, from Rahul
    Lakkireddy.

13) Don't let a non-NULL skb->dev leave the TCP stack, from Eric
    Dumazet.

14) TCP_QUEUE_SEQ socket option has to update tp->copied_seq as well,
    also from Eric Dumazet.

15) Restrict macsec to ethernet devices, from Willem de Bruijn.

16) Fix reference leak in some ethtool *_SET handlers, from Michal
    Kubecek.

17) Fix accidental disabling of MSI for some r8169 chips, from Heiner
    Kallweit.

Please pull, thanks a lot!

The following changes since commit 0d81a3f29c0afb18ba2b1275dcccf21e0dd4da38:

  Merge tag 'drm-fixes-2020-03-13' of git://anongit.freedesktop.org/drm/drm (2020-03-12 18:05:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 2910594fd38d1cb3c32fbf235e6c6228c780ab87:

  Merge tag 'wireless-drivers-2020-03-25' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers (2020-03-25 13:12:26 -0700)

----------------------------------------------------------------
Alan Maguire (1):
      selftests/net: add definition for SOL_DCCP to fix compilation errors for old libc

Alexei Starovoitov (2):
      Merge branch 'fix_bpf_send_signal'
      Merge branch 'fix-BTF-enum'

Andre Przywara (1):
      net: phy: mdio-bcm-unimac: Fix clock handling

Andrii Nakryiko (2):
      bpf: Initialize storage pointers to NULL to prevent freeing garbage pointer
      bpf: Fix cgroup ref leak in cgroup_bpf_inherit on out-of-memory

Arthur Kiyanovski (4):
      net: ena: fix incorrect setting of the number of msix vectors
      net: ena: fix request of incorrect number of IRQ vectors
      net: ena: avoid memory access violation by validating req_id properly
      net: ena: fix continuous keep-alive resets

Avraham Stern (1):
      iwlwifi: mvm: take the required lock when clearing time event data

Aya Levin (4):
      net/mlx5e: Enhance ICOSQ WQE info fields
      net/mlx5e: Fix missing reset of SW metadata in Striding RQ reset
      net/mlx5e: Fix ICOSQ recovery flow with Striding RQ
      net/mlx5e: Do not recover from a non-fatal syndrome

Bruno Meneguele (1):
      net/bpfilter: fix dprintf usage for /dev/kmsg

Chris Packham (2):
      Revert "net: mvmdio: avoid error message for optional IRQ"
      net: mvmdio: avoid error message for optional IRQ

Cong Wang (3):
      net_sched: hold rtnl lock in tcindex_partial_destroy_work()
      net_sched: keep alloc_hash updated after hash allocation
      net_sched: cls_route: remove the right filter from hashtable

Dan Carpenter (1):
      NFC: fdp: Fix a signedness bug in fdp_nci_send_patch()

David Howells (6):
      rxrpc: Abstract out the calculation of whether there's Tx space
      rxrpc: Fix call interruptibility handling
      rxrpc: Fix sendmsg(MSG_WAITALL) handling
      afs: Fix some tracing details
      afs: Fix handling of an abort from a service handler
      afs: Fix client call Rx-phase signal handling

David S. Miller (18):
      Merge git://git.kernel.org/.../bpf/bpf
      Merge tag 'wireless-drivers-2020-03-13' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge branch 'net-Use-scnprintf-for-avoiding-potential-buffer-overflow'
      Merge branch 'hsr-fix-several-bugs-in-generic-netlink-callback'
      Merge branch 'ethtool-fail-with-error-if-request-has-unknown-flags'
      Merge branch 'QorIQ-DPAA-ARM-RDBs-need-internal-delay-on-RGMII'
      Merge branch 'net-mvmdio-avoid-error-message-for-optional-IRQ'
      Merge branch 'net-bcmgenet-revisit-MAC-reset'
      Merge branch 'ENA-driver-bug-fixes'
      Merge branch 'wireguard-fixes'
      Merge tag 'rxrpc-fixes-20200319' of git://git.kernel.org/.../dhowells/linux-fs
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'hinic-BugFixes'
      Merge tag 'mlx5-fixes-2020-03-05' of git://git.kernel.org/.../saeed/linux
      Merge branch 'bnxt_en-Bug-fixes'
      Merge tag 'mlx5-fixes-2020-03-24' of git://git.kernel.org/.../saeed/linux
      Merge git://git.kernel.org/.../pablo/nf
      Merge tag 'wireless-drivers-2020-03-25' of git://git.kernel.org/.../kvalo/wireless-drivers

Doug Berger (3):
      Revert "net: bcmgenet: use RGMII loopback for MAC reset"
      net: bcmgenet: keep MAC in reset until PHY is up
      net: bcmgenet: always enable status blocks

Edward Cree (1):
      netfilter: flowtable: populate addr_type mask

Edwin Peer (1):
      bnxt_en: fix memory leaks in bnxt_dcbnl_ieee_getets()

Eli Cohen (1):
      net/mlx5: Clear LAG notifier pointer after unregister

Emil Renner Berthing (1):
      net: stmmac: dwmac-rk: fix error path in rk_gmac_probe

Eric Dumazet (2):
      tcp: ensure skb->dev is NULL before leaving TCP stack
      tcp: repair: fix TCP_QUEUE_SEQ implementation

Florian Fainelli (1):
      net: dsa: Fix duplicate frames flooded by learning

Florian Westphal (3):
      geneve: move debug check after netdev unregister
      tcp: also NULL skb->dev when copy was needed
      selftests: netfilter: add nfqueue test case

Golan Ben Ami (1):
      iwlwifi: don't send GEO_TX_POWER_LIMIT if no wgds table

Grygorii Strashko (1):
      net: phy: dp83867: w/a for fld detect threshold bootstrapping issue

Guilherme G. Piccoli (1):
      net: ena: Add PCI shutdown handler to allow safe kexec

Haishuang Yan (2):
      netfilter: flowtable: reload ip{v6}h in nf_flow_nat_ip{v6}
      netfilter: flowtable: reload ip{v6}h in nf_flow_tuple_ip{v6}

Hamdan Igbaria (1):
      net/mlx5: DR, Fix postsend actions write length

Hangbin Liu (2):
      selftests/net: add missing tests to Makefile
      selftests/net/forwarding: define libs as TEST_PROGS_EXTENDED

Heiner Kallweit (1):
      r8169: re-enable MSI on RTL8168c

Ido Schimmel (2):
      mlxsw: reg: Increase register field length to 31 bits
      mlxsw: pci: Only issue reset when system is ready

Ilan Peer (1):
      iwlwifi: mvm: Fix rate scale NSS configuration

Jason A. Donenfeld (4):
      wireguard: selftests: test using new 64-bit time_t
      wireguard: queueing: account for skb->protocol==0
      wireguard: receive: remove dead code from default packet type case
      wireguard: noise: error out precomputed DH during handshake rather than config

Jisheng Zhang (1):
      net: mvneta: Fix the case where the last poll did not process all rx

Johannes Berg (1):
      wlcore: remove stray plus sign

John Fastabend (1):
      bpf, sockmap: Remove bucket->lock from sock_{hash|map}_free

Kalle Valo (1):
      Merge tag 'iwlwifi-for-kalle-2020-03-08' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Larry Finger (1):
      rtlwifi: rtl8188ee: Fix regression due to commit d1d1a96bdb44

Leon Romanovsky (1):
      net/mlx5_core: Set IB capability mask1 to fix ib_srpt connection failure

Luca Coelho (5):
      iwlwifi: check allocated pointer when allocating conf_tlvs
      iwlwifi: dbg: don't abort if sending DBGC_SUSPEND_RESUME fails
      iwlwifi: cfg: use antenna diversity with all AX101 devices
      MAINTAINERS: update web URL for iwlwifi
      iwlwifi: pcie: add 0x2526/0x401* devices back to cfg detection

Lukas Bulwahn (1):
      ionic: make spdxcheck.py happy

Luke Nelson (2):
      bpf, x32: Fix bug with JMP32 JSET BPF_X checking upper bits
      selftests: bpf: Add test for JMP32 JSET BPF_X with upper bits set

Luo bin (5):
      hinic: fix a bug of waitting for IO stopped
      hinic: fix the bug of clearing event queue
      hinic: fix out-of-order excution in arm cpu
      hinic: fix wrong para of wait_for_completion_timeout
      hinic: fix wrong value of MIN_SKB_LEN

Madalin Bucur (3):
      net: fsl/fman: treat all RGMII modes in memac_adjust_link()
      arm64: dts: ls1043a-rdb: correct RGMII delay mode to rgmii-id
      arm64: dts: ls1046ardb: set RGMII interfaces to RGMII_ID mode

Markus Fuchs (1):
      net: stmmac: platform: Fix misleading interrupt error msg

Martin KaFai Lau (2):
      bpf: Return better error value in delete_elem for struct_ops map
      bpf: Do not allow map_freeze in struct_ops map

Mauro Carvalho Chehab (2):
      net: phy: sfp-bus.c: get rid of docs warnings
      net: core: dev.c: fix a documentation warning

Michael Chan (3):
      bnxt_en: Fix Priority Bytes and Packets counters in ethtool -S.
      bnxt_en: Return error if bnxt_alloc_ctx_mem() fails.
      bnxt_en: Free context memory after disabling PCI in probe error path.

Michal Kubecek (5):
      netlink: allow extack cookie also for error messages
      netlink: add nl_set_extack_cookie_u32()
      ethtool: reject unrecognized request flags
      netlink: check for null extack in cookie helpers
      ethtool: fix reference leak in some *_SET handlers

Mordechay Goodstein (2):
      iwlwifi: consider HE capability when setting LDPC
      iwlwifi: yoyo: don't add TLV offset when reading FIFOs

Oliver Hartkopp (1):
      slcan: not call free_netdev before rtnl_unlock in slcan_open

Pablo Neira Ayuso (4):
      netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion
      netfilter: nft_fwd_netdev: validate family and chain type
      netfilter: nft_fwd_netdev: allow to redirect to ifb via ingress
      net: Fix CONFIG_NET_CLS_ACT=n and CONFIG_NFT_FWD_NETDEV={y, m} build

Paul Blakey (2):
      net/sched: act_ct: Fix leak of ct zone template on replace
      netfilter: flowtable: Fix flushing of offloaded flows on free

Pawel Dembicki (1):
      net: qmi_wwan: add support for ASKEY WWHC050

Petr Machata (2):
      net: ip_gre: Separate ERSPAN newlink / changelink callbacks
      net: ip_gre: Accept IFLA_INFO_DATA-less configuration

Qian Cai (1):
      ipv4: fix a RCU-list lock in inet_dump_fib()

Quentin Monnet (1):
      mailmap: Update email address

Rahul Lakkireddy (2):
      cxgb4: fix throughput drop during Tx backpressure
      cxgb4: fix Txq restart check during backpressure

Raju Rangoju (1):
      cxgb4/ptp: pass the sign of offset delta in FW CMD

Rayagonda Kokatanur (1):
      net: phy: mdio-mux-bcm-iproc: check clk_prepare_enable() return value

René van Dorst (1):
      net: dsa: mt7530: Change the LINK bit to reflect the link status

Sebastian Hense (1):
      net/mlx5e: Fix endianness handling in pedit mask

Shahjada Abul Husain (1):
      cxgb4: fix delete filter entry fail in unload path

Stefano Brivio (3):
      netfilter: nft_set_pipapo: Separate partial and complete overlap cases on insertion
      netfilter: nft_set_rbtree: Introduce and use nft_rbtree_interval_start()
      netfilter: nft_set_rbtree: Detect partial overlaps on insertion

Taehee Yoo (5):
      hsr: use rcu_read_lock() in hsr_get_node_{list/status}()
      hsr: add restart routine into hsr_get_node_list()
      hsr: set .netnsok flag
      vxlan: check return value of gro_cells_init()
      hsr: fix general protection fault in hsr_addr_is_self()

Takashi Iwai (6):
      net: caif: Use scnprintf() for avoiding potential buffer overflow
      net: mlx4: Use scnprintf() for avoiding potential buffer overflow
      net: nfp: Use scnprintf() for avoiding potential buffer overflow
      net: ionic: Use scnprintf() for avoiding potential buffer overflow
      net: sfc: Use scnprintf() for avoiding potential buffer overflow
      net: netdevsim: Use scnprintf() for avoiding potential buffer overflow

Tariq Toukan (2):
      net/mlx5e: kTLS, Fix TCP seq off-by-1 issue in TX resync flow
      net/mlx5e: kTLS, Fix wrong value in record tracker enum

Vadym Kochan (1):
      selftests/net/forwarding: add Makefile to install tests

Vasundhara Volam (1):
      bnxt_en: Reset rings if ring reservation fails during open()

Vladimir Oltean (1):
      net: dsa: tag_8021q: replace dsa_8021q_remove_header with __skb_vlan_pop

Willem de Bruijn (2):
      net/packet: tpacket_rcv: avoid a producer race condition
      macsec: restrict to ethernet devices

Yonghong Song (2):
      bpf: Fix deadlock with rq_lock in bpf_send_signal()
      selftests/bpf: Add send_signal_sched_switch test

Yoshiki Komachi (2):
      bpf/btf: Fix BTF verification of enum members in struct/union
      selftests/bpf: Add test for the packed enum member in struct/union

YueHaibing (1):
      wireguard: selftests: remove duplicated include <sys/types.h>

Zh-yuan Ye (1):
      net: cbs: Fix software cbs to consider packet sending time

Zheng Wei (1):
      net: vxge: fix wrong __VA_ARGS__ usage

 .mailmap                                                          |   1 +
 MAINTAINERS                                                       |   2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts                 |   4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts                 |   4 +-
 arch/x86/net/bpf_jit_comp32.c                                     |  10 ++-
 drivers/net/Kconfig                                               |   1 +
 drivers/net/caif/caif_spi.c                                       |  72 ++++++++--------
 drivers/net/can/slcan.c                                           |   3 +
 drivers/net/dsa/mt7530.c                                          |   4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c                      |  78 +++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                         |  28 ++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                         |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c                     |  15 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                 |   8 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                    | 142 +++++++++----------------------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h                    |   3 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c                |   6 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c                      |  40 ++-------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c                 |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c                    |   3 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c                          |  52 +++---------
 drivers/net/ethernet/freescale/fman/fman_memac.c                  |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c                 |   5 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c                  |  51 +----------
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c                  |  26 ++++--
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c                 |   5 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c                      |   3 +
 drivers/net/ethernet/huawei/hinic/hinic_tx.c                      |   4 +-
 drivers/net/ethernet/marvell/mvmdio.c                             |   4 +-
 drivers/net/ethernet/marvell/mvneta.c                             |   3 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c                          |  62 +++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en.h                      |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/health.h               |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c          |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h                 |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h           |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                 |  31 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                   |  11 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                   |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c                 |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag.c                     |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c      |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c        |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c                   |   3 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c                         |  50 ++++++++---
 drivers/net/ethernet/mellanox/mlxsw/reg.h                         |   2 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.h                  |   2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h                    |  14 +--
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c         |   8 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h                    |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                   |  14 +--
 drivers/net/ethernet/pensando/ionic/ionic_regs.h                  |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c                         |   2 +-
 drivers/net/ethernet/sfc/mcdi.c                                   |  32 ++++---
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c                    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c             |  14 ++-
 drivers/net/geneve.c                                              |   8 +-
 drivers/net/ifb.c                                                 |   6 +-
 drivers/net/macsec.c                                              |   3 +
 drivers/net/netdevsim/ipsec.c                                     |  30 +++----
 drivers/net/phy/dp83867.c                                         |  21 ++++-
 drivers/net/phy/mdio-bcm-unimac.c                                 |   6 +-
 drivers/net/phy/mdio-mux-bcm-iproc.c                              |   7 +-
 drivers/net/phy/sfp-bus.c                                         |  32 ++++---
 drivers/net/usb/qmi_wwan.c                                        |   1 +
 drivers/net/vxlan.c                                               |  11 ++-
 drivers/net/wireguard/device.c                                    |   2 +-
 drivers/net/wireguard/netlink.c                                   |   8 +-
 drivers/net/wireguard/noise.c                                     |  55 ++++++------
 drivers/net/wireguard/noise.h                                     |  12 +--
 drivers/net/wireguard/peer.c                                      |   7 +-
 drivers/net/wireguard/queueing.h                                  |  10 ++-
 drivers/net/wireguard/receive.c                                   |   7 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c                    |   2 +
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c                      |  14 +--
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h                      |  14 +--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c                       |  25 ++----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h                       |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                       |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c                    |  35 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c               |   4 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                     |   3 +
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h              |   1 +
 drivers/net/wireless/ti/wlcore/main.c                             |   2 +-
 drivers/nfc/fdp/fdp.c                                             |   5 +-
 fs/afs/cmservice.c                                                |  14 ++-
 fs/afs/internal.h                                                 |  12 ++-
 fs/afs/rxrpc.c                                                    |  74 +++-------------
 include/linux/dsa/8021q.h                                         |   7 --
 include/linux/netlink.h                                           |  13 +++
 include/linux/skbuff.h                                            |  36 +++++++-
 include/net/af_rxrpc.h                                            |  12 ++-
 include/net/sch_generic.h                                         |  16 ----
 include/trace/events/afs.h                                        |   2 +-
 kernel/bpf/bpf_struct_ops.c                                       |  14 ++-
 kernel/bpf/btf.c                                                  |   2 +-
 kernel/bpf/cgroup.c                                               |   7 +-
 kernel/bpf/syscall.c                                              |   5 ++
 kernel/trace/bpf_trace.c                                          |   2 +-
 net/Kconfig                                                       |   3 +
 net/bpfilter/main.c                                               |  14 +--
 net/core/dev.c                                                    |   6 +-
 net/core/pktgen.c                                                 |   2 +-
 net/core/sock_map.c                                               |  12 ++-
 net/dsa/tag_8021q.c                                               |  43 ----------
 net/dsa/tag_brcm.c                                                |   2 +
 net/dsa/tag_sja1105.c                                             |  19 ++---
 net/ethtool/debug.c                                               |   4 +-
 net/ethtool/linkinfo.c                                            |   4 +-
 net/ethtool/linkmodes.c                                           |   4 +-
 net/ethtool/netlink.c                                             |  16 +++-
 net/ethtool/wol.c                                                 |   4 +-
 net/hsr/hsr_framereg.c                                            |   9 +-
 net/hsr/hsr_netlink.c                                             |  70 +++++++++------
 net/hsr/hsr_slave.c                                               |   8 +-
 net/ipv4/fib_frontend.c                                           |   2 +
 net/ipv4/ip_gre.c                                                 | 105 +++++++++++++++++++----
 net/ipv4/tcp.c                                                    |   4 +-
 net/ipv4/tcp_output.c                                             |  12 ++-
 net/netfilter/nf_flow_table_core.c                                |   3 +
 net/netfilter/nf_flow_table_ip.c                                  |  14 ++-
 net/netfilter/nf_flow_table_offload.c                             |   1 +
 net/netfilter/nf_tables_api.c                                     |   5 ++
 net/netfilter/nft_fwd_netdev.c                                    |  12 +++
 net/netfilter/nft_set_pipapo.c                                    |  34 ++++++--
 net/netfilter/nft_set_rbtree.c                                    |  87 +++++++++++++++++--
 net/netlink/af_netlink.c                                          |  43 ++++------
 net/packet/af_packet.c                                            |  21 +++++
 net/packet/internal.h                                             |   5 +-
 net/rxrpc/af_rxrpc.c                                              |  37 ++------
 net/rxrpc/ar-internal.h                                           |   5 +-
 net/rxrpc/call_object.c                                           |   3 +-
 net/rxrpc/conn_client.c                                           |  13 ++-
 net/rxrpc/input.c                                                 |   1 -
 net/rxrpc/sendmsg.c                                               |  75 +++++++++++-----
 net/sched/act_ct.c                                                |   2 +-
 net/sched/act_mirred.c                                            |   6 +-
 net/sched/cls_route.c                                             |   4 +-
 net/sched/cls_tcindex.c                                           |   3 +
 net/sched/sch_cbs.c                                               |  12 ++-
 tools/testing/selftests/Makefile                                  |   1 +
 tools/testing/selftests/bpf/prog_tests/send_signal_sched_switch.c |  60 +++++++++++++
 tools/testing/selftests/bpf/progs/test_send_signal_kern.c         |   6 ++
 tools/testing/selftests/bpf/test_btf.c                            |  42 +++++++++
 tools/testing/selftests/bpf/verifier/jmp32.c                      |  15 ++++
 tools/testing/selftests/net/Makefile                              |   4 +-
 tools/testing/selftests/net/forwarding/Makefile                   |  76 +++++++++++++++++
 tools/testing/selftests/net/forwarding/ethtool_lib.sh             |   0
 tools/testing/selftests/net/reuseport_addr_any.c                  |   4 +
 tools/testing/selftests/netfilter/Makefile                        |   6 +-
 tools/testing/selftests/netfilter/config                          |   6 ++
 tools/testing/selftests/netfilter/nf-queue.c                      | 352 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/netfilter/nft_queue.sh                    | 332 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/wireguard/netns.sh                        |  15 ++--
 tools/testing/selftests/wireguard/qemu/Makefile                   |   2 +-
 tools/testing/selftests/wireguard/qemu/init.c                     |   1 -
 tools/testing/selftests/wireguard/qemu/kernel.config              |   1 -
 159 files changed, 2140 insertions(+), 945 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/send_signal_sched_switch.c
 create mode 100644 tools/testing/selftests/net/forwarding/Makefile
 mode change 100755 => 100644 tools/testing/selftests/net/forwarding/ethtool_lib.sh
 create mode 100644 tools/testing/selftests/netfilter/nf-queue.c
 create mode 100755 tools/testing/selftests/netfilter/nft_queue.sh
