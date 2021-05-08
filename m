Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF70E376DFC
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 03:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhEHBA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 21:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhEHBAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 21:00:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE1F46140F;
        Sat,  8 May 2021 00:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620435593;
        bh=pYP1U0B5uJ7J+inMwLLFHw4/trIv77fYZJpgrUGZ4NY=;
        h=From:To:Cc:Subject:Date:From;
        b=Y9zfptvRMLhWXPOUSwkxIbYT8tHhvYTTCtga4ZbTXAXWFq5ihw2uCff/OHW7eVQpC
         pjMOcmJL8qdrD/qahaBC1btgVAc0nhppmH2ttR8Lny7wGu7iJelyFndvFucVt7sw7F
         9vWltmFRiA0joos0zurPHzUdwRczpkX8n3hpL2cu0RxIiuKHfYPMLFm1fjLzFNxdyB
         wKHJyRW251t0Re/L3x3zNjGBNA8liSZqsBprj2v0QAZYywD1HOQJ3AV9/lIB3WTnOk
         j1m55B2NMtlMi3TRXjQIyB8+yfqy/jTscA5MB3so5dDoD1zQaaAedmJ4Gk7R6Rw2id
         wFBhBMbQll6iA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.13-rc1
Date:   Fri,  7 May 2021 17:59:52 -0700
Message-Id: <20210508005952.3236141-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 9d31d2338950293ec19d9b095fbaa9030899dcb4:

  Merge tag 'net-next-5.13' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2021-04-29 11:57:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.13-rc1

for you to fetch changes up to 55bc1af3d9115d669570aa633e5428d6e2302e8f:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf (2021-05-07 16:10:12 -0700)

----------------------------------------------------------------
Networking fixes for 5.13-rc1, including fixes from bpf, can
and netfilter trees. Self-contained fixes, nothing risky.

Current release - new code bugs:

 - dsa: ksz: fix a few bugs found by static-checker in the new driver

 - stmmac: fix frame preemption handshake not triggering after
           interface restart

Previous releases - regressions:

 - make nla_strcmp handle more then one trailing null character

 - fix stack OOB reads while fragmenting IPv4 packets in openvswitch
   and net/sched

 - sctp: do asoc update earlier in sctp_sf_do_dupcook_a

 - sctp: delay auto_asconf init until binding the first addr

 - stmmac: clear receive all(RA) bit when promiscuous mode is off

 - can: mcp251x: fix resume from sleep before interface was brought up

Previous releases - always broken:

 - bpf: fix leakage of uninitialized bpf stack under speculation

 - bpf: fix masking negation logic upon negative dst register

 - netfilter: don't assume that skb_header_pointer() will never fail

 - only allow init netns to set default tcp cong to a restricted algo

 - xsk: fix xp_aligned_validate_desc() when len == chunk_size to
        avoid false positive errors

 - ethtool: fix missing NLM_F_MULTI flag when dumping

 - can: m_can: m_can_tx_work_queue(): fix tx_skb race condition

 - sctp: fix a SCTP_MIB_CURRESTAB leak in sctp_sf_do_dupcook_b

 - bridge: fix NULL-deref caused by a races between assigning
           rx_handler_data and setting the IFF_BRIDGE_PORT bit

Latecomer:

 - seg6: add counters support for SRv6 Behaviors

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alex Elder (1):
      net: ipa: fix inter-EE IRQ register definitions

Andrea Mayer (1):
      seg6: add counters support for SRv6 Behaviors

Arjun Roy (1):
      tcp: Specify cmsgbuf is user pointer for receive zerocopy.

Arkadiusz Kubalewski (1):
      i40e: Remove LLDP frame filters

Brendan Jackman (1):
      libbpf: Fix signed overflow in ringbuf_process_ring

Cong Wang (1):
      smc: disallow TCP_ULP in smc_setsockopt()

Dan Carpenter (1):
      can: mcp251xfd: mcp251xfd_probe(): fix an error pointer dereference in probe

Daniel Borkmann (2):
      bpf: Fix masking negation logic upon negative dst register
      bpf: Fix leakage of uninitialized bpf stack under speculation

Daniele Palmas (1):
      Documentation: ABI: sysfs-class-net-qmi: document pass-through file

David S. Miller (7):
      Merge branch 'fragment-stack-oob-read'
      Merge branch 'hns3-fixes'
      Merge branch 'hns3-fixes'
      Merge branch 'sctp-chunk-fix'
      Merge branch 'sctp-bad-revert'
      Merge branch 'sctp-race-fix'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

Davide Caratti (2):
      openvswitch: fix stack OOB read while fragmenting IPv4 packets
      net/sched: sch_frag: fix stack OOB read while fragmenting IPv4 packets

Eric Dumazet (3):
      netfilter: nfnetlink: add a missing rcu_read_unlock()
      netfilter: nftables: avoid overflows in nft_hash_buckets()
      netfilter: nftables: avoid potential overflows on 32bit arches

Fernando Fernandez Mancera (1):
      ethtool: fix missing NLM_F_MULTI flag when dumping

Florent Revest (1):
      selftests/bpf: Fix the snprintf test

Florian Westphal (1):
      netfilter: arptables: use pernet ops struct during unregister

Frieder Schrempf (1):
      can: mcp251x: fix resume from sleep before interface was brought up

Hao Chen (1):
      net: hns3: fix for vxlan gpe tx checksum bug

Ido Schimmel (1):
      mlxsw: spectrum_mr: Update egress RIF list before route's action

Jakub Kicinski (3):
      Merge tag 'linux-can-fixes-for-5.13-20210506' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf

Jaroslaw Gawin (1):
      i40e: fix the restart auto-negotiation after FEC modified

Jian Shen (1):
      net: hns3: add check for HNS3_NIC_STATE_INITED in hns3_reset_notify_up_enet()

Jiapeng Chong (1):
      net: macb: Remove redundant assignment to queue

Johannes Berg (1):
      net: atheros: nic-devel@qualcomm.com is dead

Jonathon Reinhart (1):
      net: Only allow init netns to set default tcp cong to a restricted algo

Lv Yunlong (1):
      ethernet:enic: Fix a use after free bug in enic_hard_start_xmit

Maciej Żenczykowski (1):
      net: fix nla_strcmp to handle more then one trailing null character

Magnus Karlsson (1):
      i40e: fix broken XDP support

Marc Dionne (1):
      afs, rxrpc: Add Marc Dionne as co-maintainer

Marc Kleine-Budde (2):
      can: mcp251xfd: mcp251xfd_probe(): add missing can_rx_offload_del() in error path
      can: m_can: m_can_tx_work_queue(): fix tx_skb race condition

Mateusz Palczewski (1):
      i40e: Fix PHY type identifiers for 2.5G and 5G adapters

Maxim Kochetkov (1):
      net: phy: marvell: enable downshift by default

Michael Walle (2):
      MAINTAINERS: remove Wingman Kwok
      MAINTAINERS: move Murali Karicheri to credits

Mohammad Athari Bin Ismail (1):
      net: stmmac: cleared __FPE_REMOVING bit in stmmac_fpe_start_wq()

Oleksij Rempel (3):
      net: dsa: ksz: ksz8863_smi_probe: fix possible NULL pointer dereference
      net: dsa: ksz: ksz8795_spi_probe: fix possible NULL pointer dereference
      net: dsa: ksz: ksz8863_smi_probe: set proper return value for ksz_switch_alloc()

Or Cohen (1):
      net/nfc: fix use-after-free llcp_sock_bind/connect

Pablo Neira Ayuso (4):
      netfilter: xt_SECMARK: add new revision to fix structure layout
      netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check
      netfilter: remove BUG_ON() after skb_header_pointer()
      netfilter: nftables: Fix a memleak from userdata error path in new objects

Paolo Abeni (1):
      mptcp: fix splat when closing unaccepted socket

Peng Li (1):
      net: hns3: use netif_tx_disable to stop the transmit queue

Phillip Potter (1):
      net: hsr: check skb can contain struct hsr_ethhdr in fill_frame_info

Ramesh Babu B (1):
      net: stmmac: Clear receive all(RA) bit when promiscuous mode is off

Sean Gloumeau (1):
      Fix spelling error from "eleminate" to "eliminate"

Wan Jiabing (1):
      net: stmmac: Remove duplicate declaration of stmmac_priv

Wei Ming Chen (1):
      atm: firestream: Use fallthrough pseudo-keyword

Xie He (1):
      Revert "drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit"

Xin Long (8):
      sctp: do asoc update earlier in sctp_sf_do_dupcook_a
      Revert "sctp: Fix bundling of SHUTDOWN with COOKIE-ACK"
      sctp: do asoc update earlier in sctp_sf_do_dupcook_b
      Revert "Revert "sctp: Fix bundling of SHUTDOWN with COOKIE-ACK""
      Revert "sctp: Fix SHUTDOWN CTSN Ack in the peer restart case"
      sctp: fix a SCTP_MIB_CURRESTAB leak in sctp_sf_do_dupcook_b
      Revert "net/sctp: fix race condition in sctp_destroy_sock"
      sctp: delay auto_asconf init until binding the first addr

Xuan Zhuo (1):
      xsk: Fix for xp_aligned_validate_desc() when len == chunk_size

Yang Li (3):
      net: Remove redundant assignment to err
      bnx2x: Remove redundant assignment to err
      vsock/vmci: Remove redundant assignment to err

Yannick Vignon (1):
      net: stmmac: Do not enable RX FIFO overflow interrupts

Yufeng Mo (4):
      net: hns3: fix incorrect configuration for igu_egu_hw_err
      net: hns3: initialize the message content in hclge_get_link_mode()
      net: hns3: clear unnecessary reset request in hclge_reset_rebuild
      net: hns3: disable phy loopback setting in hclge_mac_start_phy

Yunjian Wang (1):
      i40e: Fix use-after-free in i40e_client_subtask()

Zhang Zhengming (1):
      bridge: Fix possible races between assigning rx_handler_data and setting IFF_BRIDGE_PORT bit

Íñigo Huguet (1):
      net:CXGB4: fix leak if sk_buff is not used

 CREDITS                                            |   5 +
 Documentation/ABI/testing/sysfs-class-net-qmi      |  16 ++
 MAINTAINERS                                        |  16 +-
 drivers/atm/firestream.c                           |   1 +
 drivers/net/can/m_can/m_can.c                      |   3 +-
 drivers/net/can/spi/mcp251x.c                      |  35 ++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   8 +-
 drivers/net/dsa/microchip/ksz8795_spi.c            |   3 +
 drivers/net/dsa/microchip/ksz8863_smi.c            |   5 +-
 drivers/net/ethernet/atheros/alx/main.c            |   2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |   1 -
 drivers/net/ethernet/brocade/bna/bnad.c            |   2 +-
 drivers/net/ethernet/cadence/macb_main.c           |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |  16 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  12 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |   3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |   3 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   6 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   2 +
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 -
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h  |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c      |   1 +
 drivers/net/ethernet/intel/i40e/i40e_common.c      |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  42 -----
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h        |   7 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |  30 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |   7 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   1 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  15 +-
 drivers/net/ipa/gsi.c                              |   4 +-
 drivers/net/ipa/gsi_reg.h                          |  18 +-
 drivers/net/phy/marvell.c                          |  62 +++++--
 drivers/net/wan/hdlc_fr.c                          |   5 +-
 include/linux/bpf_verifier.h                       |   5 +-
 include/linux/netfilter_arp/arp_tables.h           |   3 +-
 include/net/sctp/command.h                         |   1 -
 include/uapi/linux/netfilter/xt_SECMARK.h          |   6 +
 include/uapi/linux/seg6_local.h                    |  30 ++++
 kernel/bpf/verifier.c                              |  33 ++--
 lib/nlattr.c                                       |   2 +-
 net/bridge/br_netlink.c                            |   5 +-
 net/ethtool/netlink.c                              |   3 +-
 net/hsr/hsr_forward.c                              |   4 +
 net/ipv4/netfilter/arp_tables.c                    |   5 +-
 net/ipv4/netfilter/arptable_filter.c               |   2 +-
 net/ipv4/tcp.c                                     |   1 +
 net/ipv4/tcp_cong.c                                |   4 +
 net/ipv6/seg6.c                                    |   3 -
 net/ipv6/seg6_local.c                              | 198 ++++++++++++++++++++-
 net/mptcp/subflow.c                                |   3 +-
 net/netfilter/nf_conntrack_ftp.c                   |   5 +-
 net/netfilter/nf_conntrack_h323_main.c             |   3 +-
 net/netfilter/nf_conntrack_irc.c                   |   5 +-
 net/netfilter/nf_conntrack_pptp.c                  |   4 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   6 +-
 net/netfilter/nf_conntrack_sane.c                  |   5 +-
 net/netfilter/nf_tables_api.c                      |  11 +-
 net/netfilter/nfnetlink.c                          |   1 +
 net/netfilter/nfnetlink_osf.c                      |   2 +
 net/netfilter/nft_set_hash.c                       |  20 ++-
 net/netfilter/xt_SECMARK.c                         |  88 +++++++--
 net/nfc/llcp_sock.c                                |   4 +
 net/openvswitch/actions.c                          |   8 +-
 net/sched/sch_frag.c                               |   8 +-
 net/sctp/sm_make_chunk.c                           |   6 +-
 net/sctp/sm_sideeffect.c                           |  26 ---
 net/sctp/sm_statefuns.c                            |  47 ++++-
 net/sctp/socket.c                                  |  38 ++--
 net/smc/af_smc.c                                   |   4 +-
 net/vmw_vsock/vmci_transport.c                     |   2 -
 net/xdp/xsk_queue.h                                |   7 +-
 tools/lib/bpf/ringbuf.c                            |  30 +++-
 tools/testing/selftests/bpf/prog_tests/snprintf.c  |   2 +
 tools/testing/selftests/bpf/progs/test_snprintf.c  |   5 +
 80 files changed, 689 insertions(+), 330 deletions(-)
