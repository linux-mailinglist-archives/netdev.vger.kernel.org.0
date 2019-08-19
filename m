Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D22191B16
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 04:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfHSCqT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 18 Aug 2019 22:46:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52204 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfHSCqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 22:46:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4CBE3149C1E8D;
        Sun, 18 Aug 2019 19:46:17 -0700 (PDT)
Date:   Sun, 18 Aug 2019 19:46:15 -0700 (PDT)
Message-Id: <20190818.194615.2174476213333990592.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 19:46:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix jmp to 1st instruction in x64 JIT, from Alexei Starovoitov.

2) Severl kTLS fixes in mlx5 driver, from Tariq Toukan.

3) Fix severe performance regression due to lack of SKB coalescing
   of fragments during local delivery, from Guillaume Nault.

4) Error path memory leak in sch_taprio, from Ivan Khoronzhuk.

5) Fix batched events in skbedit packet action, from Roman Mashak.

6) Propagate VLAN TX offload to hw_enc_features in bond and team drivers,
   from Yue Haibing.

7) RXRPC local endpoint refcounting fix and read after free in
   rxrpc_queue_local(), from David Howells.

8) Fix endian bug in ibmveth multicast list handling, from Thomas
   Falcon.

9) Oops, make nlmsg_parse() wrap around the correct function,
   __nlmsg_parse not __nla_parse().  Fix from David Ahern.

10) Memleak in sctp_scend_reset_streams(), fro Zheng Bin.

11) Fix memory leak in cxgb4, from Wenwen Wang.

12) Yet another race in AF_PACKET, from Eric Dumazet.

13) Fix false detection of retransmit failures in tipc, from Tuong
    Lien.

14) Use after free in ravb_tstamp_skb, from Tho Vu.

Please pull, thanks a lot!

The following changes since commit 33920f1ec5bf47c5c0a1d2113989bdd9dfb3fae9:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2019-08-06 17:11:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to cfef46d692efd852a0da6803f920cc756eea2855:

  ravb: Fix use-after-free ravb_tstamp_skb (2019-08-18 14:19:14 -0700)

----------------------------------------------------------------
Alexei Starovoitov (2):
      bpf: fix x64 JIT code generation for jmp to 1st insn
      selftests/bpf: tests for jmp to 1st insn

Anders Roxell (1):
      selftests: net: tcp_fastopen_backup_key.sh: fix shellcheck issue

Andrii Nakryiko (2):
      libbpf: fix erroneous multi-closing of BTF FD
      libbpf: set BTF FD for prog only when there is supported .BTF.ext data

André Draszik (1):
      net: phy: at803x: stop switching phy delay config needlessly

Aya Levin (3):
      net/mlx5e: Fix false negative indication on tx reporter CQE recovery
      net/mlx5e: Fix error flow of CQE recovery on tx reporter
      net/mlx5e: Remove redundant check in CQE recovery flow of tx reporter

Balakrishna Godavarthi (1):
      Bluetooth: btqca: Reset download type to default

Chen-Yu Tsai (1):
      net: dsa: Check existence of .port_mdb_add callback before calling it

Chris Packham (1):
      tipc: initialise addr_trail_end when setting node addresses

Claire Chang (1):
      Bluetooth: btqca: release_firmware after qca_inject_cmd_complete_event

Daniel Borkmann (3):
      Merge branch 'bpf-bpftool-pinning-error-msg'
      sock: make cookie generation global instead of per netns
      bpf: sync bpf.h to tools infrastructure

David Ahern (2):
      netdevsim: Restore per-network namespace accounting for fib entries
      netlink: Fix nlmsg_parse as a wrapper for strict message parsing

David Howells (5):
      rxrpc: Fix local endpoint refcounting
      rxrpc: Don't bother generating maxSkew in the ACK packet
      rxrpc: Fix local refcounting
      rxrpc: Fix local endpoint replacement
      rxrpc: Fix read-after-free in rxrpc_queue_local()

David S. Miller (12):
      Merge tag 'batadv-net-for-davem-20190808' of git://git.open-mesh.org/linux-merge
      Merge branch 'skbedit-batch-fixes'
      Merge tag 'rxrpc-fixes-20190809' of git://git.kernel.org/.../dhowells/linux-fs
      Merge branch 'Fix-collisions-in-socket-cookie-generation'
      Merge tag 'mlx5-fixes-2019-08-08' of git://git.kernel.org/.../saeed/linux
      Merge git://git.kernel.org/.../bpf/bpf
      Merge tag 'mlx5-fixes-2019-08-15' of git://git.kernel.org/.../saeed/linux
      Merge git://git.kernel.org/.../pablo/nf
      Merge tag 'rxrpc-fixes-20190814' of git://git.kernel.org/.../dhowells/linux-fs
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth
      Merge branch 'bnxt_en-Bug-fixes'
      Merge branch 'flow_offload-hardware-priority-fixes'

Denis Efremov (2):
      MAINTAINERS: PHY LIBRARY: Update files in the record
      MAINTAINERS: r8169: Update path to the driver

Dexuan Cui (1):
      hv_netvsc: Fix a warning of suspicious RCU usage

Dirk Morris (1):
      netfilter: conntrack: Use consistent ct id hash calculation

Eran Ben Elisha (1):
      net/mlx5e: Fix compatibility issue with ethtool flash device

Eric Dumazet (1):
      net/packet: fix race in tpacket_snd()

Fabian Henneke (1):
      Bluetooth: hidp: Let hidp_send_message return number of queued bytes

Florian Westphal (2):
      selftests: netfilter: extend flowtable test script for ipsec
      netfilter: nf_flow_table: fix offload for flows that are subject to xfrm

Fuqian Huang (1):
      net: tundra: tsi108: use spin_lock_irqsave instead of spin_lock_irq in IRQ context

Guillaume Nault (1):
      inet: frags: re-introduce skb coalescing for local delivery

Harish Bandi (1):
      Bluetooth: hci_qca: Send VS pre shutdown command.

Heiner Kallweit (1):
      net: phy: consider AN_RESTART status when reading link status

Huy Nguyen (2):
      net/mlx5: Support inner header match criteria for non decap flow action
      net/mlx5e: Only support tx/rx pause setting for port owner

Ivan Khoronzhuk (1):
      net: sched: sch_taprio: fix memleak in error path for sched list parse

Jakub Kicinski (4):
      net/tls: prevent skb_orphan() from leaking TLS plain text with offload
      tools: bpftool: fix error message (prog -> object)
      tools: bpftool: add error message on pin failure
      net/tls: swap sk_write_space on close

John Fastabend (1):
      net: tls, fix sk_write_space NULL write when tx disabled

Jonathan Neuschäfer (1):
      net: nps_enet: Fix function names in doc comments

Julian Wiedmann (1):
      s390/qeth: serialize cmd reply with concurrent timeout

Manish Chopra (1):
      bnx2x: Fix VF's VLAN reconfiguration in reload.

Marcel Holtmann (1):
      Bluetooth: Add debug setting for changing minimum encryption key size

Matthias Kaehlcke (2):
      Bluetooth: btqca: Add a short delay before downloading the NVM
      Bluetooth: btqca: Use correct byte format for opcode of injected command

Maxim Mikityanskiy (2):
      net/mlx5e: Use flow keys dissector to parse packets for ARFS
      net/mlx5e: Fix a race with XSKICOSQ in XSK wakeup flow

Michael Chan (2):
      bnxt_en: Fix VNIC clearing logic for 57500 chips.
      bnxt_en: Improve RX doorbell sequence.

Mohamad Heib (1):
      net/mlx5e: ethtool, Avoid setting speed to 56GBASE when autoneg off

Nathan Chancellor (1):
      net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx

Pablo Neira Ayuso (6):
      netfilter: nf_tables: use-after-free in failing rule with bound set
      netfilter: nf_flow_table: conntrack picks up expired flows
      netfilter: nf_flow_table: teardown flow timeout race
      netfilter: nft_flow_offload: skip tcp rst and fin packets
      net: sched: use major priority number as hardware priority
      netfilter: nf_tables: map basechain priority to hardware priority

Petr Machata (1):
      mlxsw: spectrum_ptp: Keep unmatched entries in a linked list

Rocky Liao (1):
      Bluetooth: hci_qca: Skip 1 error print in device_want_to_sleep()

Roman Mashak (2):
      net sched: update skbedit action for batched events operations
      tc-testing: updated skbedit action tests with batch create/delete

Ross Lagerwall (1):
      xen/netback: Reset nr_frags before freeing skb

Somnath Kotur (1):
      bnxt_en: Fix to include flow direction in L2 key

Stephen Hemminger (3):
      docs: admin-guide: remove references to IPX and token-ring
      net: docs: replace IPX in tuntap documentation
      net: cavium: fix driver name

Sven Eckelmann (2):
      batman-adv: Fix netlink dumping of all mcast_flags buckets
      batman-adv: Fix deletion of RTR(4|6) mcast list entries

Taehee Yoo (1):
      ixgbe: fix possible deadlock in ixgbe_service_task()

Takshak Chahande (1):
      libbpf : make libbpf_num_possible_cpus function thread safe

Tariq Toukan (5):
      net/mlx5: crypto, Fix wrong offset in encryption key command
      net/mlx5: kTLS, Fix wrong TIS opmod constants
      net/mlx5e: kTLS, Fix progress params context WQE layout
      net/mlx5e: kTLS, Fix tisn field name
      net/mlx5e: kTLS, Fix tisn field placement

Tho Vu (1):
      ravb: Fix use-after-free ravb_tstamp_skb

Thomas Falcon (2):
      ibmveth: Convert multicast list size for little-endian system
      ibmvnic: Unmap DMA address of TX descriptor buffers after use

Tuong Lien (1):
      tipc: fix false detection of retransmit failures

Vasundhara Volam (2):
      bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd fails
      bnxt_en: Suppress HWRM errors for HWRM_NVM_GET_VARIABLE command

Venkat Duvvuru (1):
      bnxt_en: Use correct src_fid to determine direction of the flow

Wei Yongjun (2):
      Bluetooth: btusb: Fix error return code in btusb_mtk_setup_firmware()
      Bluetooth: hci_qca: Use kfree_skb() instead of kfree()

Wenwen Wang (8):
      net/mlx4_en: fix a memory leak bug
      cxgb4: fix a memory leak bug
      liquidio: add cleanup in octeon_setup_iq()
      net: myri10ge: fix memory leaks
      lan78xx: Fix memory leaks
      cx82310_eth: fix a memory leak bug
      net: kalmia: fix memory leaks
      wimax/i2400m: fix a memory leak bug

Xin Long (1):
      sctp: fix the transport error_count check

YueHaibing (3):
      bonding: Add vlan tx offload to hw_enc_features
      net: dsa: sja1105: remove set but not used variables 'tx_vid' and 'rx_vid'
      team: Add vlan tx offload to hw_enc_features

zhengbin (1):
      sctp: fix memleak in sctp_send_reset_streams

 Documentation/admin-guide/sysctl/net.rst                         |  29 +---------------
 Documentation/networking/tls-offload.rst                         |  18 ----------
 Documentation/networking/tuntap.txt                              |   4 +--
 MAINTAINERS                                                      |   4 +--
 arch/x86/net/bpf_jit_comp.c                                      |   9 ++---
 drivers/bluetooth/btqca.c                                        |  29 ++++++++++++++--
 drivers/bluetooth/btqca.h                                        |   7 ++++
 drivers/bluetooth/btusb.c                                        |   4 ++-
 drivers/bluetooth/hci_qca.c                                      |   9 +++--
 drivers/net/bonding/bond_main.c                                  |   2 ++
 drivers/net/dsa/sja1105/sja1105_main.c                           |   4 ---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c                  |   7 ++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h                  |   2 ++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c                 |  17 +++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                        |  36 +++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c                |   9 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                |  12 +++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c                     |   8 ++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h                     |   6 ++--
 drivers/net/ethernet/cavium/common/cavium_ptp.c                  |   2 +-
 drivers/net/ethernet/cavium/liquidio/request_manager.c           |   4 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c               |   4 ++-
 drivers/net/ethernet/ezchip/nps_enet.h                           |   4 +--
 drivers/net/ethernet/ibm/ibmveth.c                               |   9 ++---
 drivers/net/ethernet/ibm/ibmvnic.c                               |  11 ++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                    |   5 +--
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                       |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h                     |  11 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c         |  19 +++++------
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c           |   3 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h          |   6 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c       |  10 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c                |  97 +++++++++++++++++++-----------------------------------
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c             |  46 ++++++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                  |  33 ++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h                |   4 +--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c       |  12 +++----
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c          |   9 +++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c             |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c               |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c               | 138 +++++++++++++++++++++++++++++++----------------------------------------------
 drivers/net/ethernet/mscc/ocelot_flower.c                        |  12 ++-----
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c                 |   2 +-
 drivers/net/ethernet/netronome/nfp/flower/qos_conf.c             |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c                         |   8 +++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c                  |   2 +-
 drivers/net/ethernet/toshiba/tc35815.c                           |   2 +-
 drivers/net/ethernet/tundra/tsi108_eth.c                         |   5 +--
 drivers/net/hyperv/netvsc_drv.c                                  |   9 +++--
 drivers/net/netdevsim/dev.c                                      |  63 ++++++++++++++---------------------
 drivers/net/netdevsim/fib.c                                      | 102 ++++++++++++++++++++++++++++++++++-----------------------
 drivers/net/netdevsim/netdev.c                                   |   9 ++++-
 drivers/net/netdevsim/netdevsim.h                                |  10 +++---
 drivers/net/phy/at803x.c                                         |  32 +++++-------------
 drivers/net/phy/phy-c45.c                                        |  14 ++++++++
 drivers/net/phy/phy_device.c                                     |  12 ++++++-
 drivers/net/team/team.c                                          |   2 ++
 drivers/net/usb/cx82310_eth.c                                    |   3 +-
 drivers/net/usb/kalmia.c                                         |   6 ++--
 drivers/net/usb/lan78xx.c                                        |   8 +++--
 drivers/net/wimax/i2400m/fw.c                                    |   4 ++-
 drivers/net/xen-netback/netback.c                                |   2 ++
 drivers/s390/net/qeth_core.h                                     |   1 +
 drivers/s390/net/qeth_core_main.c                                |  20 ++++++++++++
 include/linux/mlx5/device.h                                      |   4 +--
 include/linux/mlx5/mlx5_ifc.h                                    |   5 ++-
 include/linux/skbuff.h                                           |   8 +++++
 include/linux/socket.h                                           |   3 ++
 include/net/bluetooth/hci_core.h                                 |   1 +
 include/net/inet_frag.h                                          |   2 +-
 include/net/net_namespace.h                                      |   1 -
 include/net/netfilter/nf_tables.h                                |   9 +++--
 include/net/netfilter/nf_tables_offload.h                        |   2 ++
 include/net/netlink.h                                            |   5 ++-
 include/net/pkt_cls.h                                            |   2 +-
 include/net/sock.h                                               |  10 +++++-
 include/trace/events/rxrpc.h                                     |   6 ++--
 include/uapi/linux/bpf.h                                         |   4 +--
 net/batman-adv/multicast.c                                       |   8 +++--
 net/bluetooth/hci_core.c                                         |   1 +
 net/bluetooth/hci_debugfs.c                                      |  31 ++++++++++++++++++
 net/bluetooth/hidp/core.c                                        |   9 +++--
 net/bluetooth/l2cap_core.c                                       |   2 +-
 net/core/sock.c                                                  |  19 ++++++++---
 net/core/sock_diag.c                                             |   3 +-
 net/dsa/switch.c                                                 |   3 ++
 net/ieee802154/6lowpan/reassembly.c                              |   2 +-
 net/ipv4/inet_fragment.c                                         |  39 +++++++++++++++-------
 net/ipv4/ip_fragment.c                                           |   8 ++++-
 net/ipv4/tcp.c                                                   |   3 ++
 net/ipv4/tcp_bpf.c                                               |   6 +++-
 net/ipv4/tcp_output.c                                            |   3 ++
 net/ipv6/netfilter/nf_conntrack_reasm.c                          |   2 +-
 net/ipv6/reassembly.c                                            |   2 +-
 net/netfilter/nf_conntrack_core.c                                |  16 ++++-----
 net/netfilter/nf_flow_table_core.c                               |  43 +++++++++++++++++-------
 net/netfilter/nf_flow_table_ip.c                                 |  43 ++++++++++++++++++++++++
 net/netfilter/nf_tables_api.c                                    |  19 ++++++++---
 net/netfilter/nf_tables_offload.c                                |  17 ++++++++--
 net/netfilter/nft_flow_offload.c                                 |   9 +++--
 net/packet/af_packet.c                                           |   7 ++++
 net/rxrpc/af_rxrpc.c                                             |   6 ++--
 net/rxrpc/ar-internal.h                                          |   8 +++--
 net/rxrpc/call_event.c                                           |  15 ++++-----
 net/rxrpc/input.c                                                |  59 ++++++++++++++++-----------------
 net/rxrpc/local_object.c                                         | 103 +++++++++++++++++++++++++++++++++++----------------------
 net/rxrpc/output.c                                               |   3 +-
 net/rxrpc/recvmsg.c                                              |   6 ++--
 net/sched/act_skbedit.c                                          |  12 +++++++
 net/sched/sch_taprio.c                                           |   3 +-
 net/sctp/sm_sideeffect.c                                         |   2 +-
 net/sctp/stream.c                                                |   1 +
 net/tipc/addr.c                                                  |   1 +
 net/tipc/link.c                                                  |  92 ++++++++++++++++++++++++++++-----------------------
 net/tipc/msg.h                                                   |   8 +++--
 net/tls/tls_device.c                                             |   9 +++--
 net/tls/tls_main.c                                               |   2 ++
 tools/bpf/bpftool/common.c                                       |   8 +++--
 tools/include/uapi/linux/bpf.h                                   |  11 ++++---
 tools/lib/bpf/libbpf.c                                           |  33 ++++++++++---------
 tools/testing/selftests/bpf/verifier/loops1.c                    |  28 ++++++++++++++++
 tools/testing/selftests/net/tcp_fastopen_backup_key.sh           |   2 +-
 tools/testing/selftests/netfilter/nft_flowtable.sh               |  48 +++++++++++++++++++++++++++
 tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json |  47 ++++++++++++++++++++++++++
 125 files changed, 1156 insertions(+), 688 deletions(-)
