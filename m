Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E431497F9
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 22:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgAYVlz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 25 Jan 2020 16:41:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52990 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbgAYVly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 16:41:54 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AEA6B15B736A9;
        Sat, 25 Jan 2020 13:41:52 -0800 (PST)
Date:   Sat, 25 Jan 2020 22:41:48 +0100 (CET)
Message-Id: <20200125.224148.1422830886922555363.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 13:41:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Off by one in mt76 airtime calculation, from Dan Carpenter.

2) Fix TLV fragment allocation loop condition in iwlwifi, from Luca
   Coelho.

3) Don't confirm neigh entries when doing ipsec pmtu updates, from
   Xu Wang.

4) More checks to make sure we only send TSO packets to lan78xx chips
   that they can actually handle.  From James Hughes.

5) Fix ip_tunnel namespace move, from William Dauchy.

6) Fix unintended packet reordering due to cooperation between
   listification done by GRO and non-GRO paths.  From Maxim
   Mikityanskiy.

7) Add Jakub Kicincki formally as networking co-maintainer.

8) Info leak in airo ioctls, from Michael Ellerman.

9) IFLA_MTU attribute needs validation during rtnl_create_link(),
   from Eric Dumazet.

10) Use after free during reload in mlxsw, from Ido Schimmel.

11) Dangling pointers are possible in tp->highest_sack, fix from
    Eric Dumazet.

12) Missing *pos++ in various networking seq_next handlers, from
    Vasily Averin.

13) CHELSIO_GET_MEM operation neds CAP_NET_ADMIN check, from
    Michael Ellerman.

Please pull, thanks a lot!

The following changes since commit 7008ee121089b8193aea918b98850fe87d996508:

  Merge tag 'riscv/for-v5.5-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux (2020-01-19 12:10:28 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to fa865ba183d61c1ec8cbcab8573159c3b72b89a4:

  firestream: fix memory leaks (2020-01-25 22:01:51 +0100)

----------------------------------------------------------------
Ajay Gupta (1):
      net: stmmac: platform: fix probe for ACPI devices

Andrew Lunn (1):
      MAINTAINERS: Make Russell King designated reviewer of phylib

Arnd Bergmann (1):
      mt76: fix LED link time failure

Colin Ian King (4):
      i40e: fix spelling mistake "to" -> "too"
      ipvs: fix spelling mistake "to" -> "too"
      caif_usb: fix spelling mistake "to" -> "too"
      net/rose: fix spelling mistake "to" -> "too"

Cong Wang (1):
      net_sched: fix datalen for ematch

Dan Carpenter (1):
      mt76: Off by one in mt76_calc_rx_airtime()

David S. Miller (9):
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec
      net: Add Jakub to MAINTAINERS for networking general.
      Merge branch 'r8152-serial-fixes'
      Merge tag 'wireless-drivers-2020-01-23' of git://git.kernel.org/.../kvalo/wireless-drivers
      Merge branch 'net-fsl-fman-address-erratum-A011043'
      Merge branch 'Fixes-for-SONIC-ethernet-driver'
      Merge branch 'netdev-seq_file-next-functions-should-increase-position-index'
      Merge tag 'mlx5-fixes-2020-01-24' of git://git.kernel.org/.../saeed/linux
      Merge git://git.kernel.org/.../pablo/nf

Dmytro Linkin (1):
      net/mlx5e: Clear VF config when switching modes

Eli Cohen (1):
      net/mlx5: E-Switch, Prevent ingress rate configuration of uplink rep

Emmanuel Grumbach (1):
      iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues

Erez Shitrit (2):
      net/mlx5: DR, Enable counter on non-fwd-dest objects
      net/mlx5: DR, use non preemptible call to get the current cpu number

Eric Dumazet (5):
      net_sched: use validated TCA_KIND attribute in tc_new_tfilter()
      net: rtnetlink: validate IFLA_MTU attribute in rtnl_create_link()
      gtp: make sure only SOCK_DGRAM UDP sockets are accepted
      tun: add mutex_unlock() call and napi.skb clearing in tun_get_user()
      tcp: do not leave dangling pointers in tp->highest_sack

Finn Thain (12):
      net/sonic: Add mutual exclusion for accessing shared state
      net/sonic: Clear interrupt flags immediately
      net/sonic: Use MMIO accessors
      net/sonic: Fix interface error stats collection
      net/sonic: Fix receive buffer handling
      net/sonic: Avoid needless receive descriptor EOL flag updates
      net/sonic: Improve receive descriptor status flag check
      net/sonic: Fix receive buffer replenishment
      net/sonic: Quiesce SONIC before re-initializing descriptor memory
      net/sonic: Fix command register usage
      net/sonic: Fix CAM initialization
      net/sonic: Prevent tx watchdog timeout

Florian Fainelli (1):
      net: bcmgenet: Use netif_tx_napi_add() for TX NAPI

Florian Westphal (1):
      netfilter: nft_osf: add missing check for DREG attribute

Gil Adam (1):
      iwlwifi: don't send PPAG command if disabled

Haim Dreyfuss (1):
      iwlwifi: Don't ignore the cap field upon mcc update

Hayes Wang (9):
      r8152: fix runtime resume for linking change
      r8152: reset flow control patch when linking on for RTL8153B
      r8152: get default setting of WOL before initializing
      r8152: disable U2P3 for RTL8153B
      r8152: Disable PLA MCU clock speed down
      r8152: disable test IO for RTL8153B
      r8152: don't enable U1U2 with USB_SPEED_HIGH for RTL8153B
      r8152: avoid the MCU to clear the lanwake
      r8152: disable DelayPhyPwrChg

Ido Schimmel (1):
      mlxsw: spectrum_acl: Fix use-after-free during reload

Jakub Sitnicki (1):
      net, sk_msg: Don't check if sock is locked when tearing down psock

James Hughes (1):
      net: usb: lan78xx: Add .ndo_features_check

Jiri Wiesner (1):
      netfilter: conntrack: sctp: use distinct states for new SCTP connections

Johannes Berg (8):
      iwlwifi: pcie: move page tracking into get_page_hdr()
      iwlwifi: pcie: work around DMA hardware bug
      iwlwifi: pcie: detect the DMA bug and warn if it happens
      iwlwifi: pcie: allocate smaller dev_cmd for TX headers
      iwlwifi: mvm: report TX rate to mac80211 directly for RS offload
      iwlwifi: pcie: extend hardware workaround to context-info
      iwlwifi: mvm: fix SKB leak on invalid queue
      iwlwifi: mvm: fix potential SKB leak on TXQ TX

Jon Maloy (1):
      tipc: change maintainer email address

Jouni Hogander (1):
      net-sysfs: Fix reference count leak

Kadlecsik József (1):
      netfilter: ipset: use bitmap infrastructure completely

Kalle Valo (1):
      Merge tag 'iwlwifi-for-kalle-2020-01-11' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Kristian Evensen (1):
      fou: Fix IPv6 netlink policy

Luca Coelho (6):
      iwlwifi: fix TLV fragment allocation loop
      iwlwifi: mvm: fix NVM check for 3168 devices
      iwlwifi: pcie: rename L0S_ENABLED bit to L0S_DISABLED
      iwlwifi: pcie: always disable L0S states
      iwlwifi: remove lar_disable module parameter
      iwlwifi: fw: make pos static in iwl_sar_get_ewrd_table() loop

Madalin Bucur (4):
      dt-bindings: net: add fsl,erratum-a011043
      powerpc/fsl/dts: add fsl,erratum-a011043
      net/fsl: treat fsl,erratum-a011043
      net: fsl/fman: rename IF_MODE_XGMII to IF_MODE_10G

Manish Chopra (1):
      qlcnic: Fix CPU soft lockup while collecting firmware dump

Maxim Mikityanskiy (1):
      net: Fix packet reordering caused by GRO and listified RX cooperation

Mehmet Akif Tasova (1):
      Revert "iwlwifi: mvm: fix scan config command size"

Meir Lichtinger (1):
      net/mlx5: Update the list of the PCI supported devices

Michael Ellerman (3):
      airo: Fix possible info leak in AIROOLDIOCTL/SIOCDEVPRIVATE
      airo: Add missing CAP_NET_ADMIN check in AIROOLDIOCTL/SIOCDEVPRIVATE
      net: cxgb3_main: Add CAP_NET_ADMIN check to CHELSIO_GET_MEM

Nicolas Dichtel (2):
      vti[6]: fix packet tx through bpf_redirect()
      xfrm interface: fix packet tx through bpf_redirect()

Niko Kortstrom (1):
      net: ip6_gre: fix moving ip6gre between namespaces

Pablo Neira Ayuso (2):
      netfilter: nf_tables: add __nft_chain_type_get()
      netfilter: nf_tables: autoload modules from the abort path

Paolo Abeni (1):
      Revert "udp: do rmem bulk free even if the rx sk queue is empty"

Paul Blakey (1):
      net/mlx5: Fix lowest FDB pool size

Praveen Chaudhary (1):
      net: Fix skb->csum update in inet_proto_csum_replace16().

Richard Palethorpe (1):
      can, slip: Protect tty->disc_data in write_wakeup and close with RCU

Shahar S Matityahu (1):
      iwlwifi: dbg: force stop the debug monitor HW

Stanislaw Gruszka (1):
      MAINTAINERS: change Gruszka's email address

Tariq Toukan (3):
      net/mlx5e: kTLS, Fix corner-case checks in TX resync flow
      net/mlx5e: kTLS, Remove redundant posts in TX resync flow
      net/mlx5e: kTLS, Do not send decrypted-marked SKBs via non-accel path

Theodore Dubois (1):
      tcp: remove redundant assigment to snd_cwnd

Ulrich Weber (1):
      xfrm: support output_mark for offload ESP packets

Vasily Averin (6):
      seq_tab_next() should increase position index
      l2t_seq_next should increase position index
      vcc_seq_next should increase position index
      neigh_stat_seq_next() should increase position index
      rt_cpu_seq_next should increase position index
      ipv6_route_seq_next should increase position index

Wen Huang (1):
      libertas: Fix two buffer overflows at parsing bss descriptor

Wen Yang (1):
      tcp_bbr: improve arithmetic division in bbr_update_bw()

Wenwen Wang (1):
      firestream: fix memory leaks

William Dauchy (2):
      net, ip_tunnel: fix namespaces move
      net, ip6_tunnel: fix namespaces move

Xu Wang (1):
      xfrm: interface: do not confirm neighbor when do pmtu update

Yuki Taguchi (1):
      ipv6: sr: remove SKB_GSO_IPXIP6 on End.D* actions

wenxu (1):
      netfilter: nf_tables_offload: fix check the chain offload flag

xiaofeng.yan (1):
      hsr: Fix a compilation error

 Documentation/devicetree/bindings/net/fsl-fman.txt             |  13 +++
 MAINTAINERS                                                    |   8 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi             |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi             |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi              |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi              |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi              |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi              |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi              |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi              |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi             |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi             |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi              |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi              |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi              |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi              |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi              |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi              |   1 +
 drivers/atm/firestream.c                                       |   3 +
 drivers/net/can/slcan.c                                        |  12 ++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                 |   4 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c                |   2 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c             |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.c                       |   3 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c               |   4 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c                    |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c                  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c     |  49 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c              |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c     |  13 ++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c                 |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c     |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c       |  42 ++++++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c             |  16 +++-
 drivers/net/ethernet/natsemi/sonic.c                           | 380 +++++++++++++++++++++++++++++++++++++++++++++++-------------------------------
 drivers/net/ethernet/natsemi/sonic.h                           |  44 ++++++---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c          |   1 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c           |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c          |   6 +-
 drivers/net/gtp.c                                              |  10 ++-
 drivers/net/slip/slip.c                                        |  12 ++-
 drivers/net/tun.c                                              |   4 +
 drivers/net/usb/lan78xx.c                                      |  15 ++++
 drivers/net/usb/r8152.c                                        | 125 +++++++++++++++++++++++---
 drivers/net/wireless/cisco/airo.c                              |  20 ++---
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c                    |   3 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c                   |  10 +--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c                    |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h                   |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c               |   9 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                   |   3 -
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h             |   2 -
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c             |  61 +++++++++++--
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h             |   9 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c                 |  10 +--
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h                 |  26 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h             |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                    |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c              | 157 +++++++++++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                   |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c                   |  12 +--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c                  |  19 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c                  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                    |  21 ++---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c            |  45 +++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h             |  19 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                   |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                |  47 ++++++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c              | 208 +++++++++++++++++++++++++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c                   |  68 +++++++++-----
 drivers/net/wireless/marvell/libertas/cfg.c                    |  16 +++-
 drivers/net/wireless/mediatek/mt76/airtime.c                   |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c                  |   3 +-
 include/linux/netdevice.h                                      |   2 +
 include/linux/netfilter/ipset/ip_set.h                         |   7 --
 include/linux/netfilter/nfnetlink.h                            |   2 +-
 include/net/netns/nftables.h                                   |   1 +
 net/atm/proc.c                                                 |   3 +-
 net/caif/caif_usb.c                                            |   2 +-
 net/core/dev.c                                                 |  97 +++++++++++---------
 net/core/neighbour.c                                           |   1 +
 net/core/rtnetlink.c                                           |  13 ++-
 net/core/skmsg.c                                               |   2 -
 net/core/utils.c                                               |  20 ++++-
 net/hsr/hsr_main.h                                             |   2 +-
 net/ipv4/esp4_offload.c                                        |   2 +
 net/ipv4/fou.c                                                 |   4 +-
 net/ipv4/ip_tunnel.c                                           |   4 +-
 net/ipv4/ip_vti.c                                              |  13 ++-
 net/ipv4/route.c                                               |   1 +
 net/ipv4/tcp.c                                                 |   2 +-
 net/ipv4/tcp_bbr.c                                             |   3 +-
 net/ipv4/tcp_input.c                                           |   1 +
 net/ipv4/tcp_output.c                                          |   1 +
 net/ipv4/udp.c                                                 |   3 +-
 net/ipv6/esp6_offload.c                                        |   2 +
 net/ipv6/ip6_fib.c                                             |   7 +-
 net/ipv6/ip6_gre.c                                             |   3 -
 net/ipv6/ip6_tunnel.c                                          |   4 +-
 net/ipv6/ip6_vti.c                                             |  13 ++-
 net/ipv6/seg6_local.c                                          |   4 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h                        |   2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c                         |   6 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c                      |   6 +-
 net/netfilter/ipset/ip_set_bitmap_port.c                       |   6 +-
 net/netfilter/ipvs/ip_vs_sync.c                                |   2 +-
 net/netfilter/nf_conntrack_proto_sctp.c                        |   6 +-
 net/netfilter/nf_tables_api.c                                  | 155 ++++++++++++++++++++++----------
 net/netfilter/nf_tables_offload.c                              |   2 +-
 net/netfilter/nfnetlink.c                                      |   6 +-
 net/netfilter/nft_osf.c                                        |   3 +
 net/rose/af_rose.c                                             |   2 +-
 net/sched/cls_api.c                                            |   5 +-
 net/sched/ematch.c                                             |   2 +-
 net/xfrm/xfrm_interface.c                                      |  34 +++++--
 118 files changed, 1469 insertions(+), 603 deletions(-)
