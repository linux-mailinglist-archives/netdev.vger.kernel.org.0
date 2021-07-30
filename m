Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F3A3DBFB6
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 22:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhG3UXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 16:23:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230217AbhG3UXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 16:23:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E129760F36;
        Fri, 30 Jul 2021 20:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627676583;
        bh=xAWRaVkt8EIuJcletqg0dJy1gSZ0Q0zRa2LPHG3KKdM=;
        h=From:To:Cc:Subject:Date:From;
        b=ZTV5Qp5Lvii0Cz55jb7a9CXd4frU52Lqz8DJitG7YDRUjLwSmNLXWOqIprZJos99c
         uZ04oCdUv3mfHbWKP//tRgsOFJI0QfgHf1SwqkGWDTzOVWb8644qM0Syxmr1be+RdL
         0kTOuT5IdFySdxgjvol5JDUhm54opYzB/hV0SV0jcSzbCUG/O4P+mB+NAgRCplqgu2
         abZ7WVgFaaE9QH2BVfUsYz43ntWTI06Wb6VN9v+xtTkShzWee9ZyOfPLH1f8b+rSCi
         B+yUVxrB7PnABgL0JvfAxuuSwgBTj0FQKfLc/Moby1t6rB9C5xuB00NfL7V8ZDIpfE
         rKs7ceKn8J0HA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.14-rc4
Date:   Fri, 30 Jul 2021 13:23:02 -0700
Message-Id: <20210730202302.2197672-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 9f42f674a89200d4f465a7db6070e079f3c6145f:

  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux (2021-07-22 10:38:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc4

for you to fetch changes up to 8d67041228acf41addabdee5a60073e1b729e308:

  Merge tag 'linux-can-fixes-for-5.14-20210730' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can (2021-07-30 19:29:52 +0200)

----------------------------------------------------------------
Networking fixes for 5.14-rc4, including fixes from bpf, can, WiFi (mac80211)
and netfilter trees.

Current release - regressions:

 - mac80211: fix starting aggregation sessions on mesh interfaces

Current release - new code bugs:

 - sctp: send pmtu probe only if packet loss in Search Complete state

 - bnxt_en: add missing periodic PHC overflow check

 - devlink: fix phys_port_name of virtual port and merge error

 - hns3: change the method of obtaining default ptp cycle

 - can: mcba_usb_start(): add missing urb->transfer_dma initialization

Previous releases - regressions:

 - set true network header for ECN decapsulation

 - mlx5e: RX, avoid possible data corruption w/ relaxed ordering and LRO

 - phy: re-add check for PHY_BRCM_DIS_TXCRXC_NOENRGY on the BCM54811 PHY

 - sctp: fix return value check in __sctp_rcv_asconf_lookup

Previous releases - always broken:

 - bpf:
       - more spectre corner case fixes, introduce a BPF nospec
         instruction for mitigating Spectre v4
       - fix OOB read when printing XDP link fdinfo
       - sockmap: fix cleanup related races

 - mac80211: fix enabling 4-address mode on a sta vif after assoc

 - can:
       - raw: raw_setsockopt(): fix raw_rcv panic for sock UAF
       - j1939: j1939_session_deactivate(): clarify lifetime of
              session object, avoid UAF
       - fix number of identical memory leaks in USB drivers

 - tipc:
       - do not blindly write skb_shinfo frags when doing decryption
       - fix sleeping in tipc accept routine

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Andrii Nakryiko (1):
      Merge branch 'sockmap fixes picked up by stress tests'

Arkadiusz Kubalewski (2):
      i40e: Fix logic of disabling queues
      i40e: Fix firmware LLDP agent related warning

Arnd Bergmann (1):
      netfilter: nfnl_hook: fix unused variable warning

Aya Levin (4):
      net/mlx5e: Consider PTP-RQ when setting RX VLAN stripping
      net/mlx5e: Fix page allocation failure for trap-RQ over SF
      net/mlx5e: Fix page allocation failure for ptp-RQ over SF
      net/mlx5: Unload device upon firmware fatal error

Catherine Sullivan (1):
      gve: Update MAINTAINERS list

Chen Shen (1):
      sctp: delete addr based on sin6_scope_id

Chris Mi (1):
      net/mlx5: Fix mlx5_vport_tbl_attr chain from u16 to u32

Dan Carpenter (1):
      can: hi311x: fix a signedness bug in hi3110_cmd()

Daniel Borkmann (5):
      bpf: Remove superfluous aux sanitation on subprog rejection
      bpf: Fix pointer arithmetic mask tightening under state pruning
      bpf, selftests: Add test cases for pointer alu from multiple paths
      bpf: Introduce BPF nospec instruction for mitigating Spectre v4
      bpf: Fix leakage due to insufficient speculative store bypass mitigation

David S. Miller (8):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge tag 'mac80211-for-net-2021-07-23' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'ionic-fixes'
      Merge tag 'linux-can-fixes-for-5.14-20210724' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'sctp-pmtu-probe'
      Merge tag 'mlx5-fixes-2021-07-27' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Dima Chumak (1):
      net/mlx5e: Fix nullptr in mlx5e_hairpin_get_mdev()

Dongliang Mu (1):
      netfilter: nf_tables: fix audit memory leak in nf_tables_commit

Felix Fietkau (2):
      mac80211: fix starting aggregation sessions on mesh interfaces
      mac80211: fix enabling 4-address mode on a sta vif after assoc

Florian Westphal (1):
      netfilter: conntrack: adjust stop timestamp to real expiry value

Geetha sowjanya (2):
      octeontx2-af: Fix PKIND overlap between LBK and LMAC interfaces
      octeontx2-pf: Fix interface down flag on error

Gilad Naaman (1):
      net: Set true network header for ECN decapsulation

Hariprasad Kelam (1):
      octeontx2-pf: Dont enable backpressure on LBK links

Harshvardhan Jha (1):
      net: qede: Fix end of loop tests for list_for_each_entry

Hoang Le (1):
      tipc: fix sleeping in tipc accept routine

Jakub Kicinski (1):
      Merge tag 'linux-can-fixes-for-5.14-20210730' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can

Jedrzej Jagielski (2):
      i40e: Fix queue-to-TC mapping on Tx
      i40e: Fix log TC creation failure when max num of queues is exceeded

Jiapeng Chong (1):
      mlx4: Fix missing error code in mlx4_load_one()

Joakim Zhang (1):
      arm64: dts: imx8mp: remove fallback compatible string for FlexCAN

Johan Almbladh (1):
      mac80211: Do not strip skb headroom on monitor frames

Johannes Berg (1):
      nl80211: limit band information in non-split data

John Fastabend (3):
      bpf, sockmap: Zap ingress queues after stopping strparser
      bpf, sockmap: On cleanup we additionally need to remove cached skb
      bpf, sockmap: Fix memleak on ingress msg enqueue

Kangmin Park (1):
      ipv6: decrease hop limit counter in ip6_forward()

Kevin Lo (1):
      net: phy: broadcom: re-add check for PHY_BRCM_DIS_TXCRXC_NOENRGY on the BCM54811 PHY

Krzysztof Kozlowski (1):
      nfc: nfcsim: fix use after free during module unload

Letu Ren (1):
      net/qla3xxx: fix schedule while atomic in ql_wait_for_drvr_lock and ql_adapter_reset

Loic Poulain (1):
      wwan: core: Fix missing RTM_NEWLINK event for default link

Lorenz Bauer (1):
      bpf: Fix OOB read when printing XDP link fdinfo

Lukasz Cieplicki (1):
      i40e: Add additional info to PHY type error

Maor Dickman (2):
      net/mlx5e: Disable Rx ntuple offload for uplink representor
      net/mlx5: E-Switch, Set destination vport vhca id only when merged eswitch is supported

Maor Gottlieb (1):
      net/mlx5: Fix flow table chaining

Marc Kleine-Budde (2):
      can: mcp251xfd: mcp251xfd_irq(): stop timestamping worker in case error in IRQ
      MAINTAINERS: add Yasushi SHOJI as reviewer for the Microchip CAN BUS Analyzer Tool driver

Marcelo Ricardo Leitner (1):
      sctp: fix return value check in __sctp_rcv_asconf_lookup

Matteo Croce (1):
      virt_wifi: fix error on connect

Maxim Mikityanskiy (1):
      net/mlx5e: Add NETIF_F_HW_TC to hw_features when HTB offload is available

Michael Chan (1):
      bnxt_en: Add missing periodic PHC overflow check

Mohammad Athari Bin Ismail (1):
      net: stmmac: add est_irq_status callback function for GMAC 4.10 and 5.10

Nguyen Dinh Phi (1):
      cfg80211: Fix possible memory leak in function cfg80211_bss_update

Oleksij Rempel (1):
      can: j1939: j1939_session_deactivate(): clarify lifetime of session object

Pablo Neira Ayuso (3):
      netfilter: flowtable: avoid possible false sharing
      netfilter: nft_last: avoid possible false sharing
      netfilter: nft_nat: allow to specify layer 4 protocol NAT only

Parav Pandit (1):
      devlink: Fix phys_port_name of virtual port and merge error

Paul Jakma (1):
      NIU: fix incorrect error return, missed in previous revert

Pavel Skripkin (6):
      net: qrtr: fix memory leaks
      net: llc: fix skb_over_panic
      can: mcba_usb_start(): add missing urb->transfer_dma initialization
      can: usb_8dev: fix memory leak
      can: ems_usb: fix memory leak
      can: esd_usb2: fix memory leak

Roi Dayan (1):
      net/mlx5: E-Switch, handle devcom events only for ports on the same device

Shannon Nelson (5):
      ionic: make all rx_mode work threadsafe
      ionic: catch no ptp support earlier
      ionic: remove intr coalesce update from napi
      ionic: fix up dim accounting for tx and rx
      ionic: count csum_none when offload enabled

Somnath Kotur (1):
      bnxt_en: Fix static checker warning in bnxt_fw_reset_task()

Stephane Grosjean (1):
      can: peak_usb: pcan_usb_handle_bus_evt(): fix reading rxerr/txerr values

Subbaraya Sundeep (1):
      octeontx2-af: Fix uninitialized variables in rvu_switch

Sunil Goutham (2):
      octeontx2-af: Remove unnecessary devm_kfree
      octeontx2-af: Do NIX_RX_SW_SYNC twice

Tang Bin (2):
      nfc: s3fwrn5: fix undefined parameter values in dev_err()
      nfc: s3fwrn5: fix undefined parameter values in dev_err()

Tariq Toukan (1):
      net/mlx5e: RX, Avoid possible data corruption when relaxed ordering and LRO combined

Vladimir Oltean (1):
      net: dsa: mv88e6xxx: silently accept the deletion of VID 0 too

Wang Hai (2):
      tulip: windbond-840: Fix missing pci_disable_device() in probe and remove
      sis900: Fix missing pci_disable_device() in probe and remove

Xin Long (4):
      tipc: fix implicit-connect for SYN+
      tipc: do not write skb_shinfo frags when doing decrytion
      sctp: improve the code for pmtu probe send and recv update
      sctp: send pmtu probe only if packet loss in Search Complete state

Yufeng Mo (1):
      net: hns3: change the method of obtaining default ptp cycle

Zhang Changzhong (1):
      can: j1939: j1939_xtp_rx_dat_one(): fix rxtimer value between consecutive TP.DT to 750ms

Ziyang Xuan (1):
      can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF

zhang kai (1):
      net: let flow have same hash in two directions

 MAINTAINERS                                        |  12 +-
 arch/arm/net/bpf_jit_32.c                          |   3 +
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   4 +-
 arch/arm64/net/bpf_jit_comp.c                      |  13 ++
 arch/mips/net/ebpf_jit.c                           |   3 +
 arch/powerpc/net/bpf_jit_comp32.c                  |   6 +
 arch/powerpc/net/bpf_jit_comp64.c                  |   6 +
 arch/riscv/net/bpf_jit_comp32.c                    |   4 +
 arch/riscv/net/bpf_jit_comp64.c                    |   4 +
 arch/s390/net/bpf_jit_comp.c                       |   5 +
 arch/sparc/net/bpf_jit_comp_64.c                   |   3 +
 arch/x86/net/bpf_jit_comp.c                        |   7 +
 arch/x86/net/bpf_jit_comp32.c                      |   6 +
 drivers/net/can/spi/hi311x.c                       |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   1 +
 drivers/net/can/usb/ems_usb.c                      |  14 +-
 drivers/net/can/usb/esd_usb2.c                     |  16 +-
 drivers/net/can/usb/mcba_usb.c                     |   2 +
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  10 +-
 drivers/net/can/usb/usb_8dev.c                     |  15 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   7 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |   4 +
 drivers/net/ethernet/dec/tulip/winbond-840.c       |   7 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |  36 +++-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  61 +++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  50 +++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |   2 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   3 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   6 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  17 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  11 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_switch.c |  11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  14 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   7 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   5 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  38 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  33 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  12 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 197 +++++++++---------
 drivers/net/ethernet/pensando/ionic/ionic_lif.h    |  11 +-
 drivers/net/ethernet/pensando/ionic/ionic_phc.c    |  10 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  41 ++--
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |   4 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |   6 +-
 drivers/net/ethernet/sis/sis900.c                  |   7 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +
 drivers/net/ethernet/sun/niu.c                     |   3 +-
 drivers/net/phy/broadcom.c                         |   2 +-
 drivers/net/wireless/virt_wifi.c                   |  52 +++--
 drivers/net/wwan/wwan_core.c                       |   2 +
 drivers/nfc/nfcsim.c                               |   3 +-
 drivers/nfc/s3fwrn5/firmware.c                     |   2 +-
 include/linux/bpf_types.h                          |   1 +
 include/linux/bpf_verifier.h                       |   3 +-
 include/linux/filter.h                             |  15 ++
 include/linux/skmsg.h                              |  54 +++--
 include/net/llc_pdu.h                              |  31 ++-
 include/net/sctp/structs.h                         |   5 +-
 kernel/bpf/core.c                                  |  19 +-
 kernel/bpf/disasm.c                                |  16 +-
 kernel/bpf/verifier.c                              | 148 +++++--------
 net/can/j1939/transport.c                          |  11 +-
 net/can/raw.c                                      |  20 +-
 net/core/devlink.c                                 |  10 +-
 net/core/flow_dissector.c                          |  18 +-
 net/core/skmsg.c                                   |  39 +++-
 net/ipv4/ip_tunnel.c                               |   2 +-
 net/ipv6/ip6_output.c                              |   5 +-
 net/llc/af_llc.c                                   |  10 +-
 net/llc/llc_s_ac.c                                 |   2 +-
 net/mac80211/cfg.c                                 |  19 ++
 net/mac80211/ieee80211_i.h                         |   2 +
 net/mac80211/mlme.c                                |   4 +-
 net/mac80211/rx.c                                  |   3 +-
 net/mac80211/tx.c                                  |  57 ++---
 net/netfilter/nf_conntrack_core.c                  |   7 +-
 net/netfilter/nf_flow_table_core.c                 |   6 +-
 net/netfilter/nf_tables_api.c                      |  12 ++
 net/netfilter/nfnetlink_hook.c                     |   2 +
 net/netfilter/nft_last.c                           |  20 +-
 net/netfilter/nft_nat.c                            |   4 +-
 net/qrtr/qrtr.c                                    |   6 +-
 net/sctp/input.c                                   |   2 +-
 net/sctp/ipv6.c                                    |   5 +-
 net/sctp/sm_statefuns.c                            |  15 +-
 net/sctp/transport.c                               |  45 ++--
 net/tipc/crypto.c                                  |  14 +-
 net/tipc/socket.c                                  |  30 +--
 net/wireless/nl80211.c                             |   5 +-
 net/wireless/scan.c                                |   6 +-
 .../selftests/bpf/verifier/value_ptr_arith.c       | 229 +++++++++++++++++++++
 104 files changed, 1230 insertions(+), 547 deletions(-)
