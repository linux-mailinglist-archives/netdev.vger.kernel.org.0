Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8091B675A6D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 17:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjATQuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 11:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjATQuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 11:50:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C2870297;
        Fri, 20 Jan 2023 08:50:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01BD361FF1;
        Fri, 20 Jan 2023 16:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F53AC433D2;
        Fri, 20 Jan 2023 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674233405;
        bh=EhWxsbveokQJRvbbQE6Xi2IntLMzLL7D6c/bkuCycF4=;
        h=From:To:Cc:Subject:Date:From;
        b=jjhBrdddMzCe0G1rMcWED2ZR0YGZIZ02JC5c2JWKPdgYquzcrv8278z5+ZaBPJarO
         aaTODaSSULy149Jz267JcGZcIVhC7Ueh8TSl4Nfes1K+tnTygROhRbqZDLzn5CTuc8
         QsZsnOS2VtmgVxXIoAgMfHTyla8BzZlap/hU3hEt2gidlyRY1SJaISfdefnMBWAFPL
         B+f4lrXwcUHmSDCzsmRA2JnKSekSIy0yDPw6eRgS1/GHu7A9bTNvhpZrR5s9EvOi2r
         6y8tb/RWzA1adxebzKdpFA2rCYAb/SVDXHD59RKsfwrxJXlzO+WmgJf6FA4sGVc8KM
         Tu0d8vnmzfdcA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL v2] Networking for v6.2-rc5
Date:   Fri, 20 Jan 2023 08:50:04 -0800
Message-Id: <20230120165004.1372146-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
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

The WiFi fixes here were likely the most eagerly awaited.

The following changes since commit d9fc1511728c15df49ff18e49a494d00f78b7cd4:

  Merge tag 'net-6.2-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-01-12 18:20:44 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc5-2

for you to fetch changes up to 45a919bbb21c642e0c34dac483d1e003560159dc:

  Revert "Merge branch 'octeontx2-af-CPT'" (2023-01-20 08:38:23 -0800)

----------------------------------------------------------------
Including fixes from wireless, bluetooth, bpf and netfilter.

Current release - regressions:

 - Revert "net: team: use IFF_NO_ADDRCONF flag to prevent ipv6
   addrconf", fix nsna_ping mode of team

 - wifi: mt76: fix bugs in Rx queue handling and DMA mapping

 - eth: mlx5:
   - add missing mutex_unlock in error reporter
   - protect global IPsec ASO with a lock

Current release - new code bugs:

 - rxrpc: fix wrong error return in rxrpc_connect_call()

Previous releases - regressions:

 - bluetooth: hci_sync: fix use of HCI_OP_LE_READ_BUFFER_SIZE_V2

 - wifi:
   - mac80211: fix crashes on Rx due to incorrect initialization of
     rx->link and rx->link_sta
   - mac80211: fix bugs in iTXQ conversion - Tx stalls, incorrect
     aggregation handling, crashes
   - brcmfmac: fix regression for Broadcom PCIe wifi devices
   - rndis_wlan: prevent buffer overflow in rndis_query_oid

 - netfilter: conntrack: handle tcp challenge acks during connection
   reuse

 - sched: avoid grafting on htb_destroy_class_offload when destroying

 - virtio-net: correctly enable callback during start_xmit, fix stalls

 - tcp: avoid the lookup process failing to get sk in ehash table

 - ipa: disable ipa interrupt during suspend

 - eth: stmmac: enable all safety features by default

Previous releases - always broken:

 - bpf:
   - fix pointer-leak due to insufficient speculative store bypass
     mitigation (Spectre v4)
   - skip task with pid=1 in send_signal_common() to avoid a splat
   - fix BPF program ID information in BPF_AUDIT_UNLOAD as well as
     PERF_BPF_EVENT_PROG_UNLOAD events
   - fix potential deadlock in htab_lock_bucket from same bucket index
     but different map_locked index

 - bluetooth:
   - fix a buffer overflow in mgmt_mesh_add()
   - hci_qca: fix driver shutdown on closed serdev
   - ISO: fix possible circular locking dependency
   - CIS: hci_event: fix invalid wait context

 - wifi: brcmfmac: fixes for survey dump handling

 - mptcp: explicitly specify sock family at subflow creation time

 - netfilter: nft_payload: incorrect arithmetics when fetching VLAN
   header bits

 - tcp: fix rate_app_limited to default to 1

 - l2tp: close all race conditions in l2tp_tunnel_register()

 - eth: mlx5: fixes for QoS config and eswitch configuration

 - eth: enetc: avoid deadlock in enetc_tx_onestep_tstamp()

 - eth: stmmac: fix invalid call to mdiobus_get_phy()

Misc:

 - ethtool: add netlink attr in rss get reply only if the value is
   not empty

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Adham Faris (1):
      net/mlx5e: Remove redundant xsk pointer check in mlx5e_mpwrq_validate_xsk

Alexander Wetzel (3):
      wifi: mac80211: Proper mark iTXQs for resumption
      wifi: mac80211: sdata can be NULL during AMPDU start
      wifi: mac80211: Fix iTXQ AMPDU fragmentation handling

Aloka Dixit (1):
      wifi: mac80211: reset multiple BSSID options in stop_ap()

Andrew Halaney (1):
      net: stmmac: enable all safety features by default

Arend van Spriel (3):
      wifi: brcmfmac: avoid handling disabled channels for survey dump
      wifi: brcmfmac: avoid NULL-deref in survey dump for 2G only device
      wifi: brcmfmac: fix regression for Broadcom PCIe wifi devices

Caleb Connolly (1):
      net: ipa: disable ipa interrupt during suspend

Chris Mi (2):
      net/mlx5e: Set decap action based on attr for sample
      net/mlx5: E-switch, Fix switchdev mode after devlink reload

Clément Léger (1):
      net: lan966x: add missing fwnode_handle_put() for ports node

Cong Wang (2):
      l2tp: convert l2tp_tunnel_list to idr
      l2tp: close all race conditions in l2tp_tunnel_register()

David Howells (1):
      rxrpc: Fix wrong error return in rxrpc_connect_call()

David Morley (1):
      tcp: fix rate_app_limited to default to 1

David S. Miller (4):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'l2tp-races'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'octeontx2-af-CPT'

Eric Dumazet (3):
      net/sched: sch_taprio: fix possible use-after-free
      Revert "wifi: mac80211: fix memory leak in ieee80211_if_add()"
      l2tp: prevent lockdep issue in l2tp_tunnel_register()

Esina Ekaterina (1):
      net: wan: Add checks for NULL for utdm in undo_uhdlc_init and unmap_si_regs

Felix Fietkau (3):
      wifi: mac80211: fix initialization of rx->link and rx->link_sta
      wifi: mac80211: fix MLO + AP_VLAN check
      wifi: mt76: dma: fix a regression in adding rx buffers

Florian Westphal (2):
      selftests: netfilter: fix transaction test script timeout handling
      netfilter: conntrack: handle tcp challenge acks during connection reuse

Gavrilov Ilia (1):
      netfilter: ipset: Fix overflow before widen in the bitmap_ip_create() function.

Geetha sowjanya (1):
      octeontx2-pf: Avoid use of GFP_KERNEL in atomic context

Hao Sun (2):
      bpf: Skip invalid kfunc call in backtrack_insn
      bpf: Skip task with pid=1 in send_signal_common()

Harshit Mogalapalli (1):
      Bluetooth: Fix a buffer overflow in mgmt_mesh_add()

Heiner Kallweit (2):
      net: mdio: validate parameter addr in mdiobus_get_phy()
      net: stmmac: fix invalid call to mdiobus_get_phy()

Jakub Kicinski (9):
      Merge tag 'wireless-2023-01-12' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge branch 'amd-xgbe-pfc-and-kr-training-fixes'
      Merge branch 'mptcp-userspace-pm-create-sockets-for-the-right-family'
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge tag 'for-net-2023-01-17' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth
      Merge tag 'wireless-2023-01-18' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      net: sched: gred: prevent races when adding offloads to stats
      MAINTAINERS: add networking entries for Willem
      Revert "Merge branch 'octeontx2-af-CPT'"

Jason Wang (1):
      virtio-net: correctly enable callback during start_xmit

Jason Xing (1):
      tcp: avoid the lookup process failing to get sk in ehash table

Jisoo Jang (1):
      net: nfc: Fix use-after-free in local_cleanup()

Kees Cook (1):
      bnxt: Do not read past the end of test names

Kevin Hao (1):
      octeontx2-pf: Fix the use of GFP_KERNEL in atomic context on rt

Krzysztof Kozlowski (1):
      Bluetooth: hci_qca: Fix driver shutdown on closed serdev

Kurt Kanzenbach (1):
      net: stmmac: Fix queue statistics reading

Leon Romanovsky (2):
      net/mlx5e: Remove optimization which prevented update of ESN state
      net/mlx5e: Protect global IPsec ASO

Lorenzo Bianconi (2):
      wifi: mt76: dma: do not increment queue head if mt76_dma_add_buf fails
      wifi: mt76: handle possible mt76_rx_token_consume failures

Luis Gerhorst (1):
      bpf: Fix pointer-leak due to insufficient speculative store bypass mitigation

Luiz Augusto von Dentz (4):
      Bluetooth: hci_sync: Fix use HCI_OP_LE_READ_BUFFER_SIZE_V2
      Bluetooth: ISO: Fix possible circular locking dependency
      Bluetooth: hci_event: Fix Invalid wait context
      Bluetooth: ISO: Fix possible circular locking dependency

Maor Dickman (2):
      net/mlx5: E-switch, Fix setting of reserved fields on MODIFY_SCHEDULING_ELEMENT
      net/mlx5e: QoS, Fix wrongfully setting parent_element_id on MODIFY_SCHEDULING_ELEMENT

Matthieu Baerts (2):
      mptcp: netlink: respect v4/v6-only sockets
      selftests: mptcp: userspace: validate v4-v6 subflows mix

Nithin Dabilpuram (1):
      octeontx2-af: restore rxc conf after teardown sequence

Pablo Neira Ayuso (1):
      netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits

Paolo Abeni (3):
      mptcp: explicitly specify sock family at subflow creation time
      Merge tag 'mlx5-fixes-2023-01-18' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      net/ulp: use consistent error code when blocking ULP

Paul Moore (2):
      bpf: restore the ebpf program ID for BPF_AUDIT_UNLOAD and PERF_BPF_EVENT_PROG_UNLOAD
      bpf: remove the do_idr_lock parameter from bpf_prog_free_id()

Rahul Rameshbabu (1):
      sch_htb: Avoid grafting on htb_destroy_class_offload when destroying htb

Raju Rangoju (2):
      amd-xgbe: TX Flow Ctrl Registers are h/w ver dependent
      amd-xgbe: Delay AN timeout during KR training

Rakesh Sankaranarayanan (1):
      net: dsa: microchip: ksz9477: port map correction in ALU table entry register

Randy Dunlap (1):
      net: mlx5: eliminate anonymous module_init & module_exit

Robert Hancock (1):
      net: macb: fix PTP TX timestamp failure due to packet padding

Shyam Sundar S K (1):
      MAINTAINERS: Update AMD XGBE driver maintainers

Sriram R (1):
      mac80211: Fix MLO address translation for multiple bss case

Srujana Challa (6):
      octeontx2-af: recover CPT engine when it gets fault
      octeontx2-af: add mbox for CPT LF reset
      octeontx2-af: modify FLR sequence for CPT
      octeontx2-af: optimize cpt pf identification
      octeontx2-af: update cpt lf alloc mailbox
      octeontx2-af: add mbox to return CPT_AF_FLT_INT info

Sudheer Mogilappagari (1):
      ethtool: add netlink attr in rss get reply only if value is not null

Szymon Heidrich (2):
      wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid
      net: usb: sr9700: Handle negative len

Tonghao Zhang (1):
      bpf: hash map, avoid deadlock with suitable hash mask

Vlad Buslov (1):
      net/mlx5e: Avoid false lock dependency warning on tc_ht even more

Vladimir Oltean (1):
      net: enetc: avoid deadlock in enetc_tx_onestep_tstamp()

Willem de Bruijn (1):
      selftests/net: toeplitz: fix race on tpacket_v3 block close

Xin Long (1):
      Revert "net: team: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf"

Yang Yingliang (1):
      net/mlx5: fix missing mutex_unlock in mlx5_fw_fatal_reporter_err_work()

Ying Hsu (1):
      Bluetooth: Fix possible deadlock in rfcomm_sk_state_change

Zhengchao Shao (2):
      Bluetooth: hci_conn: Fix memory leaks
      Bluetooth: hci_sync: fix memory leak in hci_update_adv_data()

 MAINTAINERS                                        |  21 +-
 drivers/bluetooth/hci_qca.c                        |   7 +
 drivers/net/dsa/microchip/ksz9477.c                |   4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |  23 ++-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |  24 +++
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  13 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      |   9 +-
 drivers/net/ethernet/cadence/macb_main.c           |   9 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  11 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/htb.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |   5 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   7 +-
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/qos.c      |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/qos.h      |   2 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |  13 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |  14 ++
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   5 +
 drivers/net/ipa/ipa_interrupt.c                    |  10 +
 drivers/net/ipa/ipa_interrupt.h                    |  16 ++
 drivers/net/ipa/ipa_power.c                        |  17 ++
 drivers/net/phy/mdio_bus.c                         |   7 +-
 drivers/net/team/team.c                            |   2 -
 drivers/net/usb/sr9700.c                           |   2 +-
 drivers/net/virtio_net.c                           |   6 +-
 drivers/net/wan/fsl_ucc_hdlc.c                     |   6 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  37 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/dma.c           | 131 +++++++-----
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   7 +
 drivers/net/wireless/mediatek/mt76/tx.c            |   7 +-
 drivers/net/wireless/rndis_wlan.c                  |  19 +-
 include/linux/bpf.h                                |   2 +-
 include/net/mac80211.h                             |   4 -
 include/net/sch_generic.h                          |   7 +
 kernel/bpf/hashtab.c                               |   4 +-
 kernel/bpf/offload.c                               |   3 -
 kernel/bpf/syscall.c                               |  24 +--
 kernel/bpf/verifier.c                              |  10 +-
 kernel/trace/bpf_trace.c                           |   3 +
 net/bluetooth/hci_conn.c                           |  18 +-
 net/bluetooth/hci_event.c                          |   5 +-
 net/bluetooth/hci_sync.c                           |  19 +-
 net/bluetooth/iso.c                                |  64 +++---
 net/bluetooth/mgmt_util.h                          |   2 +-
 net/bluetooth/rfcomm/sock.c                        |   7 +-
 net/ethtool/rss.c                                  |  11 +-
 net/ipv4/inet_hashtables.c                         |  17 +-
 net/ipv4/inet_timewait_sock.c                      |   8 +-
 net/ipv4/tcp.c                                     |   2 +
 net/ipv4/tcp_ulp.c                                 |   2 +-
 net/l2tp/l2tp_core.c                               | 102 +++++-----
 net/mac80211/agg-tx.c                              |   8 +-
 net/mac80211/cfg.c                                 |   7 +
 net/mac80211/debugfs_sta.c                         |   5 +-
 net/mac80211/driver-ops.c                          |   3 +
 net/mac80211/driver-ops.h                          |   2 +-
 net/mac80211/ht.c                                  |  31 +++
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/iface.c                               |   5 +-
 net/mac80211/rx.c                                  | 225 ++++++++++-----------
 net/mac80211/tx.c                                  |  34 ++--
 net/mac80211/util.c                                |  42 +---
 net/mptcp/pm.c                                     |  25 +++
 net/mptcp/pm_userspace.c                           |   7 +
 net/mptcp/protocol.c                               |   2 +-
 net/mptcp/protocol.h                               |   6 +-
 net/mptcp/subflow.c                                |   9 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   4 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  15 ++
 net/netfilter/nft_payload.c                        |   2 +-
 net/nfc/llcp_core.c                                |   1 +
 net/rxrpc/call_object.c                            |   2 +-
 net/sched/sch_gred.c                               |   2 +
 net/sched/sch_htb.c                                |  27 ++-
 net/sched/sch_taprio.c                             |   3 +
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |  47 +++++
 tools/testing/selftests/net/toeplitz.c             |  12 +-
 .../selftests/netfilter/nft_trans_stress.sh        |  16 +-
 tools/testing/selftests/netfilter/settings         |   1 +
 90 files changed, 804 insertions(+), 560 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/settings
