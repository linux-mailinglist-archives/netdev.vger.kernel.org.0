Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C818624F34
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 02:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbiKKBFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 20:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiKKBFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 20:05:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FBF17428;
        Thu, 10 Nov 2022 17:05:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 050B460B43;
        Fri, 11 Nov 2022 01:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C79C433D6;
        Fri, 11 Nov 2022 01:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668128721;
        bh=3bOQLdf8xtx9shgeko5PyyX9ncAWwIjbXCr6ACZXL9E=;
        h=From:To:Cc:Subject:Date:From;
        b=vRg4KfpXQyUVExW3/d/g55chnIWWLPrQT737Cxn+ROTDGusWIDBaVDvkmeOGZFTt2
         q/c37UyaCIbGamHRGOzU1WWAbgzPClMZaiVdsaEPJN4Cs6UcBXdqBQKuRWqKke7kiJ
         xZ2IpAHywbg4Qyh+5srqfB0z+jP1vIgk+Ia4Mp+oggcpjmrtD97bAFtuY7pUCFWcVe
         cmLZUHwDDBrwTdSDS4dJPqU788Va2fLCf20TLzm22fK+6LBdzGy1Xx/VNj7zx5gxjN
         6O6YmnaBi/hqIeixK4GWz3ynBA57lFN87Utr9k/EZ56V8wYZYfoCo6Zit9U/7NAUfx
         jJBho5X/4qkmA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.1-rc5
Date:   Thu, 10 Nov 2022 17:05:20 -0800
Message-Id: <20221111010520.3435537-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
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

Still one fix pending for 6.1 changes which involves failure paths
for socket binding, but overall fells relatively calm.

The following changes since commit 9521c9d6a53df9c44a5f5ddbc229ceaf3cf79ef6:

  Merge tag 'net-6.1-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-11-03 10:51:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc5

for you to fetch changes up to abd5ac18ae661681fbacd8c9d0a577943da4c89e:

  Merge tag 'mlx5-fixes-2022-11-09' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2022-11-10 16:29:57 -0800)

----------------------------------------------------------------
Including fixes from netfilter, wifi, can and bpf.

Current release - new code bugs:

 - can: af_can: can_exit(): add missing dev_remove_pack() of canxl_packet

Previous releases - regressions:

 - bpf, sockmap: fix the sk->sk_forward_alloc warning

 - wifi: mac80211: fix general-protection-fault in
   ieee80211_subif_start_xmit()

 - can: af_can: fix NULL pointer dereference in can_rx_register()

 - can: dev: fix skb drop check, avoid o-o-b access

 - nfnetlink: fix potential dead lock in nfnetlink_rcv_msg()

Previous releases - always broken:

 - bpf: fix wrong reg type conversion in release_reference()

 - gso: fix panic on frag_list with mixed head alloc types

 - wifi: brcmfmac: fix buffer overflow in brcmf_fweh_event_worker()

 - wifi: mac80211: set TWT Information Frame Disabled bit as 1

 - eth: macsec offload related fixes, make sure to clear the keys
   from memory

 - tun: fix memory leaks in the use of napi_get_frags

 - tun: call napi_schedule_prep() to ensure we own a napi

 - tcp: prohibit TCP_REPAIR_OPTIONS if data was already sent

 - ipv6: addrlabel: fix infoleak when sending struct ifaddrlblmsg
   to network

 - tipc: fix a msg->req tlv length check

 - sctp: clear out_curr if all frag chunks of current msg are pruned,
   avoid list corruption

 - mctp: fix an error handling path in mctp_init(), avoid leaks

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Adrien Thierry (1):
      selftests/net: give more time to udpgro bg processes to complete startup

Alex Barba (1):
      bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer

Alexander Potapenko (1):
      ipv6: addrlabel: fix infoleak when sending struct ifaddrlblmsg to network

Andrii Nakryiko (2):
      net/ipv4: Fix linux/in.h header dependencies
      tools/headers: Pull in stddef.h to uapi to fix BPF selftests build in CI

Antoine Tenart (2):
      net: phy: mscc: macsec: clear encryption keys when freeing a flow
      net: atlantic: macsec: clear encryption keys from the stack

Arend van Spriel (1):
      wifi: cfg80211: fix memory leak in query_regdb_file()

Chen Zhongjin (1):
      can: af_can: can_exit(): add missing dev_remove_pack() of canxl_packet

Chris Mi (1):
      net/mlx5: E-switch, Set to legacy mode if failed to change switchdev mode

Chuang Wang (1):
      net: macvlan: fix memory leaks of macvlan_common_newlink

Cong Wang (1):
      bpf, sock_map: Move cancel_work_sync() out of sock lock

David S. Miller (3):
      Merge branch 'macsec-offload-fixes'
      Merge branch 'wwan-iosm-fixes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Dokyung Song (1):
      wifi: brcmfmac: Fix potential buffer overflow in brcmf_fweh_event_worker()

Eric Dumazet (1):
      net: tun: call napi_schedule_prep() to ensure we own a napi

Florian Fainelli (1):
      MAINTAINERS: Move Vivien to CREDITS

Geert Uytterhoeven (1):
      can: rcar_canfd: Add missing ECC error checks for channels 2-7

Guangbin Huang (1):
      net: hns3: fix get wrong value of function hclge_get_dscp_prio()

HW He (2):
      net: wwan: iosm: fix memory leak in ipc_wwan_dellink
      net: wwan: mhi: fix memory leak in mhi_mbim_dellink

Howard Hsu (1):
      wifi: mac80211: Set TWT Information Frame Disabled bit as 1

Jakub Kicinski (7):
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge tag 'wireless-2022-11-03' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge branch 'bnxt_en-bug-fixes'
      Merge branch 'sctp-fix-a-null-pointer-dereference-in-sctp_sched_dequeue_common'
      Merge tag 'linux-can-fixes-for-6.1-20221107' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'mlx5-fixes-2022-11-09' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux

Jason A. Donenfeld (2):
      wifi: rt2x00: use explicitly signed or unsigned types
      wifi: airo: do not assign -1 to unsigned char

Jianbo Liu (1):
      net/mlx5e: TC, Fix wrong rejection of packet-per-second policing

Jiri Benc (1):
      net: gso: fix panic on frag_list with mixed head alloc types

Johannes Berg (1):
      wifi: cfg80211: silence a sparse RCU warning

Jonas Jelonek (1):
      wifi: mac80211_hwsim: fix debugfs attribute ps with rc table support

Kees Cook (1):
      bpf, verifier: Fix memory leak in array reallocation for stack state

Lu Wei (1):
      tcp: prohibit TCP_REPAIR_OPTIONS if data was already sent

M Chetan Kumar (4):
      net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg
      net: wwan: iosm: fix driver not working with INTEL_IOMMU disabled
      net: wwan: iosm: fix invalid mux header type
      net: wwan: iosm: fix kernel test robot reported errors

Maxim Mikityanskiy (2):
      net/mlx5e: Add missing sanity checks for max TX WQE size
      net/mlx5e: Fix usage of DMA sync API

Michael Chan (1):
      bnxt_en: Fix possible crash in bnxt_hwrm_set_coal()

Michal Jaron (1):
      iavf: Fix VF driver counting VLAN 0 filters

Miquel Raynal (1):
      dt-bindings: net: tsnep: Fix typo on generic nvmem property

Nick Child (1):
      ibmveth: Reduce default tx queues to 8

Nicolas Cavallari (1):
      wifi: mac80211: Fix ack frame idr leak when mesh has no route

Norbert Zulinski (1):
      ice: Fix spurious interrupt during removal of trusted VF

Oliver Hartkopp (3):
      can: isotp: fix tx state handling for echo tx processing
      can: j1939: j1939_send_one(): fix missing CAN header initialization
      can: dev: fix skb drop check

Paolo Abeni (2):
      Merge branch 'stmmac-dwmac-loongson-fixes-three-leaks'
      Merge branch 'macsec-clear-encryption-keys-in-h-w-drivers'

Paul Zhang (1):
      wifi: cfg80211: Fix bitrates overflow issue

Phil Sutter (1):
      selftests: netfilter: Fix and review rpath.sh

Pu Lehui (1):
      bpftool: Fix NULL pointer dereference when pin {PROG, MAP, LINK} without FILE

Randy Dunlap (1):
      net: octeontx2-pf: mcs: consider MACSEC setting

Rasmus Villemoes (1):
      net: stmmac: dwmac-meson8b: fix meson8b_devm_clk_prepare_enable()

Ratheesh Kannoth (2):
      octeontx2-pf: NIX TX overwrites SQ_CTX_HW_S[SQ_INT]
      octeontx2-pf: Fix SQE threshold checking

Roger Quadros (1):
      net: ethernet: ti: am65-cpsw: Fix segmentation fault at module unload

Roi Dayan (3):
      net/mlx5e: Fix tc acts array not to be dependent on enum order
      net/mlx5e: E-Switch, Fix comparing termination table instance
      net/mlx5e: TC, Fix slab-out-of-bounds in parse_tc_actions

Roy Novich (1):
      net/mlx5: Allow async trigger completion execution on single CPU systems

Sabrina Dubroca (5):
      Revert "net: macsec: report real_dev features when HW offloading is enabled"
      macsec: delete new rxsc when offload fails
      macsec: fix secy->n_rx_sc accounting
      macsec: fix detection of RXSCs when toggling offloading
      macsec: clear encryption keys from the stack after setting up offload

Sean Anderson (1):
      net: fman: Unregister ethernet device on removal

Shay Drory (1):
      net/mlx5: fw_reset: Don't try to load device in case PCI isn't working

Shigeru Yoshida (1):
      netfilter: Cleanup nft_net->module_list from nf_tables_exit_net()

Tan, Tee Min (1):
      stmmac: intel: Update PCH PTP clock rate from 200MHz to 204.8MHz

Tyler J. Stachecki (1):
      wifi: ath11k: Fix QCN9074 firmware boot on x86

Vikas Gupta (2):
      bnxt_en: refactor bnxt_cancel_reservations()
      bnxt_en: fix the handling of PCIE-AER

Vlad Buslov (1):
      net/mlx5: Bridge, verify LAG state when adding bond to bridge

Wang Yufen (2):
      bpf, sockmap: Fix the sk->sk_forward_alloc warning of sk_stream_kill_queues
      net: tun: Fix memory leaks of napi_get_frags

Wei Yongjun (2):
      mctp: Fix an error handling path in mctp_init()
      eth: sp7021: drop free_netdev() from spl2sw_init_netdev()

Wen Gong (1):
      wifi: ath11k: avoid deadlock during regulatory update in ath11k_regd_update()

Xin Long (3):
      tipc: fix the msg->req tlv len check in tipc_nl_compat_name_table_dump_header
      sctp: remove the unnecessary sinfo_stream check in sctp_prsctp_prune_unsent
      sctp: clear out_curr if all frag chunks of current msg are pruned

Yang Yingliang (4):
      octeontx2-pf: fix build error when CONFIG_OCTEONTX2_PF=y
      stmmac: dwmac-loongson: fix missing pci_disable_msi() while module exiting
      stmmac: dwmac-loongson: fix missing pci_disable_device() in loongson_dwmac_probe()
      stmmac: dwmac-loongson: fix missing of_node_put() while module exiting

Youlin Li (2):
      bpf: Fix wrong reg type conversion in release_reference()
      selftests/bpf: Add verifier test for release_reference()

YueHaibing (1):
      net: broadcom: Fix BCMGENET Kconfig

Zhaoping Shu (1):
      net: wwan: iosm: Remove unnecessary if_mutex lock

Zhengchao Shao (15):
      wifi: mac80211: fix general-protection-fault in ieee80211_subif_start_xmit()
      net: lapbether: fix issue of dev reference count leakage in lapbeth_device_event()
      hamradio: fix issue of dev reference count leakage in bpq_device_event()
      can: af_can: fix NULL pointer dereference in can_rx_register()
      net: lapbether: fix issue of invalid opcode in lapbeth_open()
      net: ethernet: mtk-star-emac: disable napi when connect and start PHY failed in mtk_star_enable()
      drivers: net: xgene: disable napi when register irq failed in xgene_enet_open()
      net: marvell: prestera: fix memory leak in prestera_rxtx_switch_init()
      net: nixge: disable napi when enable interrupts failed in nixge_open()
      net: cpsw: disable napi in cpsw_ndo_open()
      net: cxgb3_main: disable napi when bind qsets failed in cxgb_up()
      cxgb4vf: shut down the adapter when t4vf_update_port_info() failed in cxgb4vf_open()
      ethernet: s2io: disable napi when start nic failed in s2io_card_up()
      net: mv643xx_eth: disable napi when init rxq or txq failed in mv643xx_eth_open()
      ethernet: tundra: free irq when alloc ring failed in tsi108_open()

Ziyang Xuan (1):
      netfilter: nfnetlink: fix potential dead lock in nfnetlink_rcv_msg()

taozhang (1):
      wifi: mac80211: fix memory free error when registering wiphy fail

 CREDITS                                            |   5 +
 .../devicetree/bindings/net/engleder,tsnep.yaml    |   2 +-
 MAINTAINERS                                        |   2 -
 drivers/net/can/at91_can.c                         |   2 +-
 drivers/net/can/c_can/c_can_main.c                 |   2 +-
 drivers/net/can/can327.c                           |   2 +-
 drivers/net/can/cc770/cc770.c                      |   2 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c           |   2 +-
 drivers/net/can/dev/skb.c                          |  10 +-
 drivers/net/can/flexcan/flexcan-core.c             |   2 +-
 drivers/net/can/grcan.c                            |   2 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c              |   2 +-
 drivers/net/can/janz-ican3.c                       |   2 +-
 drivers/net/can/kvaser_pciefd.c                    |   2 +-
 drivers/net/can/m_can/m_can.c                      |   2 +-
 drivers/net/can/mscan/mscan.c                      |   2 +-
 drivers/net/can/pch_can.c                          |   2 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |   2 +-
 drivers/net/can/rcar/rcar_can.c                    |   2 +-
 drivers/net/can/rcar/rcar_canfd.c                  |  15 +--
 drivers/net/can/sja1000/sja1000.c                  |   2 +-
 drivers/net/can/slcan/slcan-core.c                 |   2 +-
 drivers/net/can/softing/softing_main.c             |   2 +-
 drivers/net/can/spi/hi311x.c                       |   2 +-
 drivers/net/can/spi/mcp251x.c                      |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c       |   2 +-
 drivers/net/can/sun4i_can.c                        |   2 +-
 drivers/net/can/ti_hecc.c                          |   2 +-
 drivers/net/can/usb/ems_usb.c                      |   2 +-
 drivers/net/can/usb/esd_usb.c                      |   2 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   2 +-
 drivers/net/can/usb/gs_usb.c                       |   2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   2 +-
 drivers/net/can/usb/mcba_usb.c                     |   2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/can/usb/ucan.c                         |   2 +-
 drivers/net/can/usb/usb_8dev.c                     |   2 +-
 drivers/net/can/xilinx_can.c                       |   2 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c   |   4 +-
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c |   2 +
 .../ethernet/aquantia/atlantic/macsec/macsec_api.c |  18 +--
 drivers/net/ethernet/broadcom/Kconfig              |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  54 +++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c     |   3 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   1 +
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   2 +-
 drivers/net/ethernet/freescale/fman/mac.c          |   9 ++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   8 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   3 +-
 drivers/net/ethernet/ibm/ibmveth.h                 |   1 +
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |   2 +
 drivers/net/ethernet/intel/ice/ice_base.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  25 ++++
 drivers/net/ethernet/intel/ice/ice_lib.h           |   1 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |   5 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |   1 +
 drivers/net/ethernet/marvell/octeontx2/Kconfig     |   2 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 135 ++++++++++++++++-----
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  57 +++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  32 +++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   1 +
 .../net/ethernet/marvell/prestera/prestera_rxtx.c  |   7 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  11 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  31 +++++
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |  92 +++++---------
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  24 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   7 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  27 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  14 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  14 ++-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  18 +--
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |  14 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   3 +-
 drivers/net/ethernet/neterion/s2io.c               |  29 +++--
 drivers/net/ethernet/ni/nixge.c                    |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  11 +-
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |  39 ++++--
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |   8 +-
 drivers/net/ethernet/sunplus/spl2sw_driver.c       |   1 -
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
 drivers/net/ethernet/ti/cpsw.c                     |   2 +
 drivers/net/ethernet/tundra/tsi108_eth.c           |   5 +-
 drivers/net/hamradio/bpqether.c                    |   2 +-
 drivers/net/macsec.c                               |  50 +++-----
 drivers/net/macvlan.c                              |   4 +-
 drivers/net/phy/mscc/mscc_macsec.c                 |   1 +
 drivers/net/tun.c                                  |  18 ++-
 drivers/net/wan/lapbether.c                        |   3 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |   2 +-
 drivers/net/wireless/ath/ath11k/reg.c              |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |   4 +
 drivers/net/wireless/cisco/airo.c                  |  18 ++-
 drivers/net/wireless/mac80211_hwsim.c              |   5 +
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2400pci.h     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.h     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c     |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.h     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  60 ++++-----
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h     |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |   6 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.h       |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c       |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.h       |   2 +-
 drivers/net/wwan/Kconfig                           |   2 +-
 drivers/net/wwan/iosm/iosm_ipc_coredump.c          |   1 +
 drivers/net/wwan/iosm/iosm_ipc_devlink.c           |   1 +
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c          |   8 ++
 drivers/net/wwan/iosm/iosm_ipc_mux.h               |   1 +
 drivers/net/wwan/iosm/iosm_ipc_pcie.c              |  18 ++-
 drivers/net/wwan/iosm/iosm_ipc_wwan.c              |  43 ++-----
 drivers/net/wwan/mhi_wwan_mbim.c                   |   1 +
 include/linux/can/dev.h                            |  16 +++
 include/linux/skmsg.h                              |   2 +-
 include/uapi/linux/in.h                            |   1 +
 kernel/bpf/verifier.c                              |  17 ++-
 net/can/af_can.c                                   |   3 +-
 net/can/isotp.c                                    |  71 ++++++-----
 net/can/j1939/main.c                               |   3 +
 net/core/skbuff.c                                  |  36 +++---
 net/core/skmsg.c                                   |   7 +-
 net/core/sock_map.c                                |   7 +-
 net/ipv4/tcp.c                                     |   2 +-
 net/ipv4/tcp_bpf.c                                 |   8 +-
 net/ipv6/addrlabel.c                               |   1 +
 net/mac80211/main.c                                |   8 +-
 net/mac80211/mesh_pathtbl.c                        |   2 +-
 net/mac80211/s1g.c                                 |   3 +
 net/mac80211/tx.c                                  |   5 +
 net/mctp/af_mctp.c                                 |   4 +-
 net/mctp/route.c                                   |   2 +-
 net/netfilter/nf_tables_api.c                      |   3 +-
 net/netfilter/nfnetlink.c                          |   1 +
 net/sctp/outqueue.c                                |  13 +-
 net/tipc/netlink_compat.c                          |   2 +-
 net/wireless/reg.c                                 |  12 +-
 net/wireless/scan.c                                |   4 +-
 net/wireless/util.c                                |   6 +-
 tools/bpf/bpftool/common.c                         |   3 +
 tools/include/uapi/linux/in.h                      |   1 +
 tools/include/uapi/linux/stddef.h                  |  47 +++++++
 .../testing/selftests/bpf/verifier/ref_tracking.c  |  36 ++++++
 tools/testing/selftests/net/udpgro.sh              |   4 +-
 tools/testing/selftests/net/udpgro_bench.sh        |   2 +-
 tools/testing/selftests/net/udpgro_frglist.sh      |   2 +-
 tools/testing/selftests/netfilter/rpath.sh         |  14 ++-
 154 files changed, 984 insertions(+), 513 deletions(-)
 create mode 100644 tools/include/uapi/linux/stddef.h
