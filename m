Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D59A513B85
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 20:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351031AbiD1S3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 14:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351123AbiD1S3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 14:29:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D65138185;
        Thu, 28 Apr 2022 11:25:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02136618F3;
        Thu, 28 Apr 2022 18:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FADCC385AA;
        Thu, 28 Apr 2022 18:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651170355;
        bh=E1mgYHBD3f1aVmtK3ieTB65D5YVNXg1KxUihDzNbEIE=;
        h=From:To:Cc:Subject:Date:From;
        b=X6UFoPY6gFNKR+OijVZ4POgEQl+j9WFcWSy6hoEvL1yzMYAUG8NDwQNc1D77xGC9T
         eF5s9B2AXe0Ybu+Slgz46Hqf5CdpgyL38FCSOj2i97zDFrRJ6C0ZsHFS6rfe3NoJ+u
         u3wm4iIlmkmbEYZgemZ3yDGl4W3MzBv+Ru6FBKzu4TAGVIR7NYmpXt5YhuoptCtdhe
         oFLf+j+Q4lx34uCPRjrn56jXcj2LcQcpjPIoE57qPCrdEeETkTbyNoPbeeT4L5satY
         mgL3mRVWGuCCckPt2iQXN7muXjDWdcPc5iwwcaC7bdsOqHgibodZqFEeC5QeqTr3yI
         M8bbcwX1Wjk1Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.18-rc5
Date:   Thu, 28 Apr 2022 11:25:54 -0700
Message-Id: <20220428182554.2138218-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 59f0c2447e2553b0918b4a9fd38763a5c0587d02:

  Merge tag 'net-5.18-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-04-21 12:29:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc5

for you to fetch changes up to d9157f6806d1499e173770df1f1b234763de5c79:

  tcp: fix F-RTO may not work correctly when receiving DSACK (2022-04-28 10:35:38 -0700)

----------------------------------------------------------------
Networking fixes for 5.18-rc5, including fixes from bluetooth, bpf
and netfilter.

Current release - new code bugs:

 - bridge: switchdev: check br_vlan_group() return value

 - use this_cpu_inc() to increment net->core_stats, fix preempt-rt

Previous releases - regressions:

 - eth: stmmac: fix write to sgmii_adapter_base

Previous releases - always broken:

 - netfilter: nf_conntrack_tcp: re-init for syn packets only,
   resolving issues with TCP fastopen

 - tcp: md5: fix incorrect tcp_header_len for incoming connections

 - tcp: fix F-RTO may not work correctly when receiving DSACK

 - tcp: ensure use of most recently sent skb when filling rate samples

 - tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT

 - virtio_net: fix wrong buf address calculation when using xdp

 - xsk: fix forwarding when combining copy mode with busy poll

 - xsk: fix possible crash when multiple sockets are created

 - bpf: lwt: fix crash when using bpf_skb_set_tunnel_key() from
   bpf_xmit lwt hook

 - sctp: null-check asoc strreset_chunk in sctp_generate_reconf_event

 - wireguard: device: check for metadata_dst with skb_valid_dst()

 - netfilter: update ip6_route_me_harder to consider L3 domain

 - gre: make o_seqno start from 0 in native mode

 - gre: switch o_seqno to atomic to prevent races in collect_md mode

Misc:

 - add Eric Dumazet to networking maintainers

 - dt: dsa: realtek: remove realtek,rtl8367s string

 - netfilter: flowtable: Remove the empty file

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Adam Zabrocki (1):
      kprobes: Fix KRETPROBES when CONFIG_KRETPROBE_ON_RETHOOK is set

Baruch Siach (1):
      net: phy: marvell10g: fix return value on error

Clément Léger (1):
      net: bridge: switchdev: check br_vlan_group() return value

Dan Carpenter (1):
      net: lan966x: fix a couple off by one bugs

Dany Madden (1):
      Revert "ibmvnic: Add ethtool private flag for driver-defined queue limits"

David S. Miller (3):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'hns3-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net -queue

Dinh Nguyen (1):
      net: ethernet: stmmac: fix write to sgmii_adapter_base

Eric Dumazet (2):
      tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT
      tcp: make sure treq->af_specific is initialized

Eyal Birger (1):
      bpf, lwt: Fix crash when using bpf_skb_set_tunnel_key() from bpf_xmit lwt hook

Florian Fainelli (1):
      MAINTAINERS: Update BNXT entry with firmware files

Florian Westphal (2):
      netfilter: nf_conntrack_tcp: re-init for syn packets only
      netfilter: nft_socket: only do sk lookups when indev is available

Francesco Ruggeri (1):
      tcp: md5: incorrect tcp_header_len for incoming connections

Hao Chen (1):
      net: hns3: align the debugfs output to the left

Ivan Vecera (2):
      ice: Fix incorrect locking in ice_vc_process_vf_msg()
      ice: Protect vf_state check by cfg_lock in ice_vc_process_vf_msg()

Jacob Keller (1):
      ice: fix use-after-free when deinitializing mailbox snapshot

Jakub Kicinski (5):
      Merge branch 'wireguard-patches-for-5-18-rc4'
      Merge branch 'net-smc-two-fixes-for-smc-fallback'
      Add Eric Dumazet to networking maintainers
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf

Jason A. Donenfeld (1):
      wireguard: selftests: enable ACPI for SMP

Jian Shen (3):
      net: hns3: clear inited state and stop client after failed to register netdev
      net: hns3: add validity check for message data length
      net: hns3: add return value for mailbox handling in PF

Jie Wang (1):
      net: hns3: modify the return code of hclge_get_ring_chain_from_mbx

Jonathan Lemon (1):
      net: bcmgenet: hide status block before TX timestamping

Leon Romanovsky (1):
      ixgbe: ensure IPsec VF<->PF compatibility

Lin Ma (1):
      mctp: defer the kfree of object mdev->addrs

Luiz Angelo Daros de Luca (2):
      dt-bindings: net: dsa: realtek: cleanup compatible strings
      net: dsa: realtek: remove realtek,rtl8367s string

Luiz Augusto von Dentz (3):
      Bluetooth: hci_event: Fix checking for invalid handle on error status
      Bluetooth: hci_event: Fix creating hci_conn object on error status
      Bluetooth: hci_sync: Cleanup hci_conn if it cannot be aborted

Lv Ruyi (1):
      net: cosa: fix error check return value of register_chrdev()

Maciej Fijalkowski (2):
      xsk: Fix l2fwd for copy mode + busy poll combo
      xsk: Fix possible crash when multiple sockets are created

Manish Chopra (1):
      bnx2x: fix napi API usage sequence

Martin Blumenstingl (1):
      net: dsa: lantiq_gswip: Don't set GSWIP_MII_CFG_RMII_CLK

Martin Willi (1):
      netfilter: Update ip6_route_me_harder to consider L3 domain

Maxim Mikityanskiy (1):
      tls: Skip tls_append_frag on zero copy size

Miaoqian Lin (1):
      net: dsa: Add missing of_node_put() in dsa_port_link_register_of

Nathan Rossi (1):
      net: dsa: mv88e6xxx: Fix port_hidden_wait to account for port_base_addr

Nikolay Aleksandrov (2):
      wireguard: device: check for metadata_dst with skb_valid_dst()
      virtio_net: fix wrong buf address calculation when using xdp

Pablo Neira Ayuso (1):
      netfilter: nft_set_rbtree: overlap detection with element re-addition after deletion

Paolo Abeni (1):
      Merge tag 'for-net-2022-04-27' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth

Peilin Ye (3):
      ip_gre: Make o_seqno start from 0 in native mode
      ip6_gre: Make o_seqno start from 0 in native mode
      ip_gre, ip6_gre: Fix race condition on o_seqno in collect_md mode

Peng Li (1):
      net: hns3: fix error log of tx/rx tqps stats

Peng Wu (1):
      net: hns: Add missing fwnode_handle_put in hns_mac_init

Pengcheng Yang (3):
      ipvs: correctly print the memory size of ip_vs_conn_tab
      tcp: ensure to use the most recently sent skb when filling the rate sample
      tcp: fix F-RTO may not work correctly when receiving DSACK

Petr Oros (1):
      ice: wait 5 s for EMP reset after firmware flash

Rongguang Wei (1):
      netfilter: flowtable: Remove the empty file

Sebastian Andrzej Siewior (1):
      net: Use this_cpu_inc() to increment net->core_stats

Toke Høiland-Jørgensen (1):
      bpf: Fix release of page_pool in BPF_PROG_RUN in test runner

Vladimir Oltean (4):
      net: dsa: flood multicast to CPU when slave has IFF_PROMISC
      net: mscc: ocelot: ignore VID 0 added by 8021q module
      net: mscc: ocelot: don't add VID 0 to ocelot->vlans when leaving VLAN-aware bridge
      net: enetc: allow tc-etf offload even with NETIF_F_CSUM_MASK

Volodymyr Mytnyk (1):
      netfilter: conntrack: fix udp offload timeout sysctl

Wen Gu (2):
      net/smc: Only save the original clcsock callback functions
      net/smc: Fix slab-out-of-bounds issue in fallback

Xin Long (1):
      sctp: check asoc strreset_chunk in sctp_generate_reconf_event

Yang Yingliang (1):
      net: fec: add missing of_node_put() in fec_enet_init_stop_mode()

liuyacan (1):
      net/smc: sync err code when tcp connection was refused

 .../devicetree/bindings/net/dsa/realtek.yaml       |  35 +++---
 MAINTAINERS                                        |   4 +
 drivers/net/dsa/lantiq_gswip.c                     |   3 -
 drivers/net/dsa/mv88e6xxx/port_hidden.c            |   5 +-
 drivers/net/dsa/realtek/realtek-mdio.c             |   1 -
 drivers/net/dsa/realtek/realtek-smi.c              |   4 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   9 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   7 ++
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |   4 -
 drivers/net/ethernet/freescale/fec_main.c          |   2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |   6 +-
 .../hns3/hns3_common/hclge_comm_tqp_stats.c        |   4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  84 ++++++-------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   9 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  31 +++--
 drivers/net/ethernet/ibm/ibmvnic.c                 | 129 ++++++-------------
 drivers/net/ethernet/ibm/ibmvnic.h                 |   6 -
 drivers/net/ethernet/intel/ice/ice_main.c          |   3 +
 drivers/net/ethernet/intel/ice/ice_sriov.c         |   2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |  27 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |   3 +-
 .../net/ethernet/microchip/lan966x/lan966x_mac.c   |   4 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  14 ++-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |  12 +-
 drivers/net/phy/marvell10g.c                       |   2 +-
 drivers/net/virtio_net.c                           |  20 ++-
 drivers/net/wan/cosa.c                             |   2 +-
 drivers/net/wireguard/device.c                     |   3 +-
 include/linux/netdevice.h                          |  21 ++--
 include/net/bluetooth/hci.h                        |   1 +
 include/net/bluetooth/hci_core.h                   |   2 +-
 include/net/ip6_tunnel.h                           |   2 +-
 include/net/ip_tunnels.h                           |   2 +-
 include/net/tcp.h                                  |   8 ++
 include/net/xsk_buff_pool.h                        |   1 +
 kernel/kprobes.c                                   |   2 +-
 net/bluetooth/hci_conn.c                           |  32 +++--
 net/bluetooth/hci_event.c                          |  80 +++++++-----
 net/bluetooth/hci_sync.c                           |  11 +-
 net/bpf/test_run.c                                 |   5 +-
 net/bridge/br_switchdev.c                          |   2 +
 net/core/dev.c                                     |  14 +--
 net/core/lwt_bpf.c                                 |   7 +-
 net/dsa/port.c                                     |   2 +
 net/dsa/slave.c                                    |   2 +-
 net/ipv4/ip_gre.c                                  |  12 +-
 net/ipv4/netfilter/nf_flow_table_ipv4.c            |   0
 net/ipv4/syncookies.c                              |   8 +-
 net/ipv4/tcp_input.c                               |  15 ++-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/tcp_output.c                              |   1 +
 net/ipv4/tcp_rate.c                                |  11 +-
 net/ipv6/ip6_gre.c                                 |  16 +--
 net/ipv6/netfilter.c                               |  10 +-
 net/ipv6/syncookies.c                              |   3 +-
 net/mctp/device.c                                  |   2 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   2 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  21 +---
 net/netfilter/nf_conntrack_standalone.c            |   2 +-
 net/netfilter/nft_set_rbtree.c                     |   6 +-
 net/netfilter/nft_socket.c                         |  52 +++++---
 net/sctp/sm_sideeffect.c                           |   4 +
 net/smc/af_smc.c                                   | 137 ++++++++++++++-------
 net/smc/smc.h                                      |  29 +++++
 net/smc/smc_close.c                                |   5 +-
 net/tls/tls_device.c                               |  12 +-
 net/xdp/xsk.c                                      |  15 ++-
 net/xdp/xsk_buff_pool.c                            |  16 ++-
 .../selftests/wireguard/qemu/arch/i686.config      |   1 +
 .../selftests/wireguard/qemu/arch/x86_64.config    |   1 +
 70 files changed, 598 insertions(+), 414 deletions(-)
 delete mode 100644 net/ipv4/netfilter/nf_flow_table_ipv4.c
