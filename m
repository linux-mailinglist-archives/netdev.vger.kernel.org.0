Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F626C7449
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 00:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjCWXvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 19:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCWXvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 19:51:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A39129E3A;
        Thu, 23 Mar 2023 16:51:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C925462903;
        Thu, 23 Mar 2023 23:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34CDC433D2;
        Thu, 23 Mar 2023 23:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679615467;
        bh=bniGwea4jL7PzUX7TSfFAmfUdyMWbUL5QTyrxWPNQnk=;
        h=From:To:Cc:Subject:Date:From;
        b=BasXYLFAdjIRjD1R7J5MY3JFMbfO65bbQh87utFwAh7AQQ5rhDeU4uhQDAnvzcQGm
         HdCTRK/qhEiHV3NR3JwjKQGIHlfUr2xh+6F8C3e4gdvZ2a8fH9YHCa1uJUzUB7W+ac
         ybX7xxWhlzKfxy1AAo2ybQMIAa4t+/37FwWIHeIT+HkxBD6Ji4g7dfPoqRT0n+iAFJ
         mO3zVdFkysOQZZSvqrHWwKbkiLWsVrakQ9y5qcmjmCMDpFN+ujmhgNdVqZjK+nsk5Y
         58+thQotmj7wmPSUd1PvCO5xI3zNuMuelm1+tfxemzQZEBC98gCgO0QQZAH20YUFju
         f65IM7xdXLImg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for v6.3-rc4
Date:   Thu, 23 Mar 2023 16:51:06 -0700
Message-Id: <20230323235106.51289-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 478a351ce0d69cef2d2bf2a686a09b356b63a66c:

  Merge tag 'net-6.3-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-03-17 13:31:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc4

for you to fetch changes up to 1b4ae19e432dfec785d980993c09593cbb182754:

  Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2023-03-23 16:03:33 -0700)

----------------------------------------------------------------
Including fixes from bpf, wifi and bluetooth.

Current release - regressions:

 - wifi: mt76: mt7915: add back 160MHz channel width support for MT7915

 - libbpf: revert poisoning of strlcpy, it broke uClibc-ng

Current release - new code bugs:

 - bpf: improve the coverage of the "allow reads from uninit stack"
   feature to fix verification complexity problems

 - eth: am65-cpts: reset PPS genf adj settings on enable

Previous releases - regressions:

 - wifi: mac80211: serialize ieee80211_handle_wake_tx_queue()

 - wifi: mt76: do not run mt76_unregister_device() on unregistered hw,
   fix null-deref

 - Bluetooth: btqcomsmd: fix command timeout after setting BD address

 - eth: igb: revert rtnl_lock() that causes a deadlock

 - dsa: mscc: ocelot: fix device specific statistics

Previous releases - always broken:

 - xsk: add missing overflow check in xdp_umem_reg()

 - wifi: mac80211:
   - fix QoS on mesh interfaces
   - fix mesh path discovery based on unicast packets

 - Bluetooth:
   - ISO: fix timestamped HCI ISO data packet parsing
   - remove "Power-on" check from Mesh feature

 - usbnet: more fixes to drivers trusting packet length

 - wifi: iwlwifi: mvm: fix mvmtxq->stopped handling

 - Bluetooth: btintel: iterate only bluetooth device ACPI entries

 - eth: iavf: fix inverted Rx hash condition leading to disabled hash

 - eth: igc: fix the validation logic for taprio's gate list

 - dsa: tag_brcm: legacy: fix daisy-chained switches

Misc:

 - bpf: adjust insufficient default bpf_jit_limit to account for
   growth of BPF use over the last 5 years

 - xdp: bpf_xdp_metadata() use EOPNOTSUPP as unique errno indicating
   no driver support

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
AKASHI Takahiro (1):
      igc: fix the validation logic for taprio's gate list

Ahmed Zaki (1):
      iavf: do not track VLAN 0 filters

Akihiko Odaki (2):
      igb: Enable SR-IOV after reinit
      igbvf: Regard vf reset nack as success

Alexander Lobakin (2):
      iavf: fix inverted Rx hash condition leading to disabled hash
      iavf: fix non-tunneled IPv6 UDP packet type and hashing

Alexander Wetzel (1):
      wifi: mac80211: Serialize ieee80211_handle_wake_tx_queue()

Alexei Starovoitov (4):
      Merge branch 'bpf: Allow reads from uninit stack'
      selftests/bpf: Fix progs/find_vma_fail1.c build error.
      selftests/bpf: Fix progs/test_deny_namespace.c issues.
      Merge branch 'bpf: Allow reads from uninit stack'

Arınç ÜNAL (3):
      net: dsa: mt7530: move enabling disabling core clock to mt7530_pll_setup()
      net: dsa: mt7530: move lowering TRGMII driving to mt7530_setup()
      net: dsa: mt7530: move setting ssc_delta to PHY_INTERFACE_MODE_TRGMII case

Brian Gix (1):
      Bluetooth: Remove "Power-on" check from Mesh feature

Dan Carpenter (1):
      net/mlx5: E-Switch, Fix an Oops in error handling code

Daniel Borkmann (1):
      bpf: Adjust insufficient default bpf_jit_limit

Daniil Tatianin (1):
      qed/qed_sriov: guard against NULL derefs from qed_iov_get_vf_info

David S. Miller (3):
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'mdiobus-module-owner'
      Merge branch 'ps3_gelic_net-fixes'

Donald Hunter (1):
      tools: ynl: Fix genlmsg header encoding formats

Eduard Zingerman (2):
      bpf: Allow reads from uninit stack
      selftests/bpf: Tests for uninitialized stack reads

Emeel Hakim (1):
      net/mlx5e: Overcome slow response for first macsec ASO WQE

Eric Dumazet (1):
      erspan: do not use skb_mac_header() in ndo_start_xmit()

Felix Fietkau (3):
      wifi: mt76: mt7915: add back 160MHz channel width support for MT7915
      wifi: mac80211: fix qos on mesh interfaces
      wifi: mac80211: fix mesh path discovery based on unicast packets

Florian Fainelli (2):
      net: phy: Ensure state transitions are processed from phy_stop()
      net: mdio: fix owner field for mdio buses registered using ACPI

Gaosheng Cui (1):
      intel/igbvf: free irq on the error path in igbvf_request_msix()

Gavin Li (2):
      net/mlx5e: Set uplink rep as NETNS_LOCAL
      net/mlx5e: Block entering switchdev mode with ns inconsistency

Geoff Levand (2):
      net/ps3_gelic_net: Fix RX sk_buff length
      net/ps3_gelic_net: Use dma_mapping_error

Grant Grundler (1):
      net: asix: fix modprobe "sysfs: cannot create duplicate filename"

Grygorii Strashko (1):
      net: ethernet: ti: am65-cpts: reset pps genf adj settings on enable

Howard Chung (1):
      Bluetooth: mgmt: Fix MGMT add advmon with RSSI command

Ido Schimmel (2):
      mlxsw: core_thermal: Fix fan speed in maximum cooling state
      mlxsw: spectrum_fid: Fix incorrect local port type

Jakub Kicinski (8):
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'fix-trainwreck-with-ocelot-switch-statistics-counters'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'mlx5-fixes-2023-03-21' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'wireless-2023-03-23' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge tag 'for-net-2023-03-23' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Jesper Dangaard Brouer (1):
      xdp: bpf_xdp_metadata use EOPNOTSUPP for no driver support

Jesus Sanchez-Palencia (1):
      libbpf: Revert poisoning of strlcpy

Jiasheng Jiang (1):
      octeontx2-vf: Add missing free for alloc_percpu

Jochen Henneberg (1):
      net: stmmac: Fix for mismatched host/device DMA address width

Johannes Berg (2):
      wifi: iwlwifi: mvm: fix mvmtxq->stopped handling
      wifi: iwlwifi: mvm: protect TXQ list manipulation

Joshua Washington (1):
      gve: Cache link_speed value from device

Kal Conley (1):
      xsk: Add missing overflow check in xdp_umem_reg

Kiran K (2):
      Bluetooth: btintel: Iterate only bluetooth device ACPI entries
      Bluetooth: btinel: Check ACPI handle for NULL before accessing

Krzysztof Kozlowski (1):
      wifi: mwifiex: mark OF related data as maybe unused

Lama Kayal (1):
      net/mlx5: Fix steering rules cleanup

Li Zetao (1):
      atm: idt77252: fix kmemleak when rmmod idt77252

Liang He (1):
      net: mdio: thunder: Add missing fwnode_handle_put()

Lin Ma (1):
      igb: revert rtnl_lock() that causes deadlock

Lorenzo Bianconi (2):
      wifi: mt76: do not run mt76_unregister_device() on unregistered hw
      wifi: mt76: connac: do not check WED status for non-mmio devices

Luiz Augusto von Dentz (3):
      Bluetooth: hci_core: Detect if an ACL packet is in fact an ISO packet
      Bluetooth: btusb: Remove detection of ISO packets over bulk
      Bluetooth: L2CAP: Fix responding with wrong PDU type

Maher Sanalla (1):
      net/mlx5: Read the TC mapping of all priorities on ETS query

Maxime Bizon (1):
      net: mdio: fix owner field for mdio buses registered using device-tree

Michal Swiatkowski (2):
      ice: check if VF exists before mode check
      ice: remove filters only if VSI is deleted

Min Li (1):
      Bluetooth: Fix race condition in hci_cmd_sync_clear

Pauli Virtanen (1):
      Bluetooth: ISO: fix timestamped HCI ISO data packet parsing

Piotr Raczynski (1):
      ice: fix rx buffers handling for flow director packets

Radoslaw Tyl (1):
      i40e: fix flow director packet filter programming

Roy Novich (1):
      net/mlx5e: Initialize link speed to zero

Russell King (Oracle) (1):
      net: sfp: fix state loss when updating state_hw_mask

Stefan Assmann (1):
      iavf: fix hang on reboot with ice

Stephan Gerhold (1):
      Bluetooth: btqcomsmd: Fix command timeout after setting BD address

Sungwoo Kim (1):
      Bluetooth: HCI: Fix global-out-of-bounds

Szymon Heidrich (2):
      net: usb: smsc95xx: Limit packet length to skb->len
      net: usb: lan78xx: Limit packet length to skb->len

Tom Rix (1):
      usb: plusb: remove unused pl_clear_QuickLink_features function

Vladimir Oltean (5):
      net: dsa: report rx_bytes unadjusted for ETH_HLEN
      net: mscc: ocelot: fix stats region batching
      net: mscc: ocelot: fix transfer from region->buf to ocelot->stats
      net: mscc: ocelot: add TX_MM_HOLD to ocelot_mm_stats_layout
      net: enetc: fix aggregate RMON counters not showing the ranges

Zhang Changzhong (1):
      net/sonic: use dma_mapping_error() for error check

Zheng Wang (3):
      xirc2ps_cs: Fix use after free bug in xirc2ps_detach
      net: qcom/emac: Fix use after free bug in emac_remove due to race condition
      Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work

Zhengping Jiang (1):
      Bluetooth: hci_sync: Resume adv with no RPA when active scan

Álvaro Fernández Rojas (2):
      net: dsa: b53: mmap: fix device tree support
      net: dsa: tag_brcm: legacy: fix daisy-chained switches

 Documentation/networking/xdp-rx-metadata.rst       |   7 +-
 drivers/atm/idt77252.c                             |  11 ++
 drivers/bluetooth/btintel.c                        |  51 +++++---
 drivers/bluetooth/btintel.h                        |   7 --
 drivers/bluetooth/btqcomsmd.c                      |  17 ++-
 drivers/bluetooth/btsdio.c                         |   1 +
 drivers/bluetooth/btusb.c                          |  10 --
 drivers/net/dsa/b53/b53_mmap.c                     |   2 +-
 drivers/net/dsa/mt7530.c                           |  49 ++++----
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |  11 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   8 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c      |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  13 ++
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   2 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |   2 -
 drivers/net/ethernet/intel/ice/ice_lib.c           |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   8 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |   8 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   1 +
 drivers/net/ethernet/intel/igb/igb_main.c          | 137 +++++++++------------
 drivers/net/ethernet/intel/igbvf/netdev.c          |   8 +-
 drivers/net/ethernet/intel/igbvf/vf.c              |  13 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  20 +--
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   2 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  19 +++
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |   7 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c |   4 +-
 drivers/net/ethernet/mscc/ocelot_stats.c           |  11 +-
 drivers/net/ethernet/natsemi/sonic.c               |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |   5 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |   6 +
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  30 ++---
 drivers/net/ethernet/ti/am65-cpts.c                |   4 +
 drivers/net/ethernet/toshiba/ps3_gelic_net.c       |  41 +++---
 drivers/net/ethernet/toshiba/ps3_gelic_net.h       |   5 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |   5 +
 drivers/net/mdio/acpi_mdio.c                       |  10 +-
 drivers/net/mdio/mdio-thunder.c                    |   1 +
 drivers/net/mdio/of_mdio.c                         |  12 +-
 drivers/net/phy/mdio_devres.c                      |  11 +-
 drivers/net/phy/phy.c                              |  23 ++--
 drivers/net/phy/sfp.c                              |   5 +
 drivers/net/usb/asix_devices.c                     |  32 ++++-
 drivers/net/usb/lan78xx.c                          |  18 ++-
 drivers/net/usb/plusb.c                            |   6 -
 drivers/net/usb/smsc95xx.c                         |   6 +
 drivers/net/veth.c                                 |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  50 +++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  29 ++++-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   8 ++
 drivers/net/wireless/mediatek/mt76/mt76.h          |   1 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  40 ++++--
 include/linux/acpi_mdio.h                          |   9 +-
 include/linux/of_mdio.h                            |  22 +++-
 include/linux/stmmac.h                             |   2 +-
 include/net/bluetooth/hci_core.h                   |   1 +
 kernel/bpf/core.c                                  |   2 +-
 kernel/bpf/verifier.c                              |  11 +-
 net/bluetooth/hci_core.c                           |  23 +++-
 net/bluetooth/hci_sync.c                           |  68 +++++++---
 net/bluetooth/iso.c                                |   9 +-
 net/bluetooth/l2cap_core.c                         | 117 ++++++++++++------
 net/bluetooth/mgmt.c                               |   9 +-
 net/core/xdp.c                                     |  10 +-
 net/dsa/tag.c                                      |   2 +-
 net/dsa/tag_brcm.c                                 |  10 +-
 net/ipv4/ip_gre.c                                  |   4 +-
 net/ipv6/ip6_gre.c                                 |   4 +-
 net/mac80211/ieee80211_i.h                         |   3 +
 net/mac80211/main.c                                |   2 +
 net/mac80211/rx.c                                  |  22 ++--
 net/mac80211/util.c                                |   3 +
 net/mac80211/wme.c                                 |   6 +-
 net/xdp/xdp_umem.c                                 |  13 +-
 tools/lib/bpf/libbpf_internal.h                    |   4 +-
 tools/net/ynl/lib/ynl.py                           |   6 +-
 .../selftests/bpf/prog_tests/uninit_stack.c        |   9 ++
 tools/testing/selftests/bpf/progs/find_vma_fail1.c |   1 +
 .../selftests/bpf/progs/test_deny_namespace.c      |  10 +-
 .../selftests/bpf/progs/test_global_func10.c       |   8 +-
 tools/testing/selftests/bpf/progs/uninit_stack.c   |  87 +++++++++++++
 tools/testing/selftests/bpf/verifier/calls.c       |  13 +-
 .../selftests/bpf/verifier/helper_access_var_len.c | 104 ++++++++++------
 tools/testing/selftests/bpf/verifier/int_ptr.c     |   9 +-
 .../selftests/bpf/verifier/search_pruning.c        |  13 +-
 tools/testing/selftests/bpf/verifier/sock.c        |  27 ----
 tools/testing/selftests/bpf/verifier/spill_fill.c  |   7 +-
 tools/testing/selftests/bpf/verifier/var_off.c     |  52 --------
 106 files changed, 980 insertions(+), 579 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/uninit_stack.c
 create mode 100644 tools/testing/selftests/bpf/progs/uninit_stack.c
