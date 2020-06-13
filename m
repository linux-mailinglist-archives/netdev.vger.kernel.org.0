Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145E51F85C6
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 00:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgFMWyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 18:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgFMWyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 18:54:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5805AC03E96F;
        Sat, 13 Jun 2020 15:54:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 73CC011F5F637;
        Sat, 13 Jun 2020 15:54:04 -0700 (PDT)
Date:   Sat, 13 Jun 2020 15:54:03 -0700 (PDT)
Message-Id: <20200613.155403.1649160651516402937.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Jun 2020 15:54:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix cfg80211 deadlock, from Johannes Berg.

2) RXRPC fails to send norigications, from David Howells.

3) MPTCP RM_ADDR parsing has an off by one pointer error, fix
   from Geliang Tang.

4) Fix crash when using MSG_PEEK with sockmap, from Anny Hu.

5) The ucc_geth driver needs __netdev_watchdog_up exported, from
   Valentin Longchamp.

6) Fix hashtable memory leak in dccp, from Wang Hai.

7) Fix how nexthops are marked as FDB nexthops, from David Ahern.

8) Fix mptcp races between shutdown and recvmsg, from Paolo Abeni.

9) Fix crashes in tipc_disc_rcv(), from Tuong Lien.

10) Fix link speed reporting in iavf driver, from Brett Creeley.

11) When a channel is used for XSK and then reused again later for
    XSK, we forget to clear out the relevant data structures in
    mlx5 which causes all kinds of problems.  Fix from Maxim
    Mikityanskiy.

12) Fix memory leak in genetlink, from Cong Wang.

13) Disallow sockmap attachments to UDP sockets, it simply won't
    work.  From Lorenz Bauer.

Please pull, thanks a lot!

The following changes since commit af7b4801030c07637840191c69eb666917e4135d:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-06-07 17:27:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net 

for you to fetch changes up to bc139119a1708ae3db1ebb379630f286e28d06e8:

  net: ethernet: ti: ale: fix allmulti for nu type ale (2020-06-13 15:37:17 -0700)

----------------------------------------------------------------
Aleksandr Loktionov (1):
      iavf: use appropriate enum for comparison

Alex Elder (4):
      net: ipa: program metadata mask differently
      net: ipa: fix modem LAN RX endpoint id
      net: ipa: program upper nibbles of sequencer type
      net: ipa: header pad field only valid for AP->modem endpoint

Andrey Ignatov (1):
      bpf: Fix memlock accounting for sock_hash

Andrii Nakryiko (5):
      selftests/bpf: Fix ringbuf selftest sample counting undeterminism
      libbpf: Handle GCC noreturn-turned-volatile quirk
      tools/bpftool: Fix skeleton codegen
      libbpf: Support pre-initializing .bss global variables
      bpf: Undo internal BPF_PROBE_MEM in BPF insns dump

Arjun Roy (1):
      net-zerocopy: use vm_insert_pages() for tcp rcv zerocopy

Arnaldo Carvalho de Melo (1):
      libbpf: Define __WORDSIZE if not available

Aya Levin (1):
      net/mlx5e: Fix ethtool hfunc configuration change

Ayush Sawal (2):
      Crypto/chcr: Calculate src and dst sg lengths separately for dma map
      Crypto/chcr: Checking cra_refcnt before unregistering the algorithms

Brett Creeley (2):
      iavf: fix speed reporting over virtchnl
      iavf: Fix reporting 2.5 Gb and 5Gb speeds

Brett Mastbergen (1):
      tools, bpf: Do not force gcc as CC

Cong Wang (2):
      net: change addr_list_lock back to static key
      genetlink: clean up family attributes allocations

Corentin Labbe (1):
      net: cadence: macb: disable NAPI on error

Dan Carpenter (2):
      bpf: Fix an error code in check_btf_func()
      net/mlx5: E-Switch, Fix some error pointer dereferences

David Ahern (3):
      bpf: Reset data_meta before running programs attached to devmap entry
      nexthop: Fix fdb labeling for groups
      vxlan: Remove access to nexthop group struct

David Howells (3):
      rxrpc: Move the call completion handling out of line
      rxrpc: Fix missing notification
      rxrpc: Fix race between incoming ACK parser and retransmitter

David S. Miller (7):
      Merge tag 'mac80211-for-davem-2020-06-08' of git://git.kernel.org/.../jberg/mac80211
      Merge tag 'rxrpc-fixes-20200605' of git://git.kernel.org/.../dhowells/linux-fs
      Merge branch 'chcr-Fixing-issues-in-dma-mapping-and-driver-removal'
      Merge tag 'mlx5-fixes-2020-06-11' of git://git.kernel.org/.../saeed/linux
      Merge branch '40GbE' of git://git.kernel.org/.../jkirsher/net-queue
      Merge branch 'net-ipa-endpoint-configuration-fixes'
      Merge git://git.kernel.org/.../bpf/bpf

Denis Efremov (1):
      net/mlx5: DR, Fix freeing in dr_create_rc_qp()

Flavio Suligoi (3):
      doc: networking: wireless: fix wiki website url
      include: fix wiki website url in netlink interface header
      net: fix wiki website url mac80211 and wireless files

Geliang Tang (1):
      mptcp: bugfix for RM_ADDR option parsing

Grygorii Strashko (2):
      net: ethernet: ti: am65-cpsw-nuss: fix ale parameters init
      net: ethernet: ti: ale: fix allmulti for nu type ale

Jakub Kicinski (3):
      docs: networking: fix extra spaces in ethtool-netlink
      docs: networkng: fix lists and table in sja1105
      docs: networkng: convert sja1105's devlink info to RTS

Jakub Sitnicki (2):
      bpf, sockhash: Fix memory leak when unlinking sockets in sock_hash_free
      bpf, sockhash: Synchronize delete from bucket list on map free

Jean-Philippe Brucker (1):
      tracing/probe: Fix bpf_task_fd_query() for kprobes and uprobes

Jesper Dangaard Brouer (2):
      bpf: Devmap adjust uapi for attach bpf program
      bpf: Selftests and tools use struct bpf_devmap_val from uapi

Johannes Berg (2):
      cfg80211: fix management registrations deadlock
      mac80211: initialize return flags in HE 6 GHz operation parsing

Leon Romanovsky (1):
      net/mlx5: Don't fail driver on failure to create debugfs

Li RongQing (1):
      xdp: Fix xsk_generic_xmit errno

Liao Pingfang (1):
      net: atm: Remove the error message according to the atomic context

Lorenz Bauer (3):
      scripts: Require pahole v1.16 when generating BTF
      bpf: cgroup: Allow multi-attach program to replace itself
      bpf: sockmap: Don't attach programs to UDP sockets

Lorenzo Bianconi (1):
      net: mvneta: do not redirect frames during reconfiguration

Matthieu Baerts (1):
      bpf: Fix unused-var without NETDEVICES

Maxim Mikityanskiy (1):
      net/mlx5e: Fix repeated XSK usage on one channel

Oz Shlomo (1):
      net/mlx5e: CT: Fix ipv6 nat header rewrite actions

Pablo Neira Ayuso (1):
      net: flow_offload: remove indirect flow_block declarations leftover

Paolo Abeni (2):
      mptcp: fix races between shutdown and recvmsg
      mptcp: don't leak msk in token container

Parav Pandit (2):
      net/mlx5: Disable reload while removing the device
      net/mlx5: Fix devlink objects and devlink device unregister sequence

Paul Greenwalt (1):
      iavf: increase reset complete wait time

Pooja Trivedi (1):
      net/tls(TLS_SW): Add selftest for 'chunked' sendfile test

Sabrina Dubroca (1):
      bpf: tcp: Recv() should return 0 when the peer socket is closed

Shannon Nelson (3):
      ionic: wait on queue start until after IFF_UP
      ionic: remove support for mgmt device
      ionic: add pcie_print_link_status

Shay Drory (2):
      net/mlx5: drain health workqueue in case of driver load error
      net/mlx5: Fix fatal error handling during device load

Thomas Falcon (1):
      ibmvnic: Flush existing work items before device removal

Tobias Klauser (2):
      tools, bpftool: Fix memory leak in codegen error cases
      tools, bpftool: Exit on error in function codegen

Tuong Lien (2):
      tipc: fix kernel WARNING in tipc_msg_append()
      tipc: fix NULL pointer dereference in tipc_disc_rcv()

Valentin Longchamp (1):
      net: sched: export __netdev_watchdog_up()

Wang Hai (1):
      dccp: Fix possible memleak in dccp_init and dccp_fini

Xu Wang (1):
      drivers: dpaa2: Use devm_kcalloc() in setup_dpni()

YiFei Zhu (2):
      net/filter: Permit reading NET in load_bytes_relative when MAC not set
      selftests/bpf: Add cgroup_skb/egress test for load_bytes_relative

dihu (1):
      bpf/sockmap: Fix kernel panic at __tcp_bpf_recvmsg

tannerlove (2):
      selftests/net: in timestamping, strncpy needs to preserve null byte
      selftests/net: in rxtimestamp getopt_long needs terminating null entry

 Documentation/networking/devlink-params-sja1105.txt              |  27 ------------------
 Documentation/networking/devlink/index.rst                       |   1 +
 Documentation/networking/devlink/sja1105.rst                     |  49 +++++++++++++++++++++++++++++++++
 Documentation/networking/dsa/sja1105.rst                         |   6 ++--
 Documentation/networking/ethtool-netlink.rst                     |  12 ++++----
 Documentation/networking/mac80211-injection.rst                  |   2 +-
 Documentation/networking/regulatory.rst                          |   6 ++--
 drivers/crypto/chelsio/chcr_algo.c                               |  81 +++++++++++++++++++++++++++++++++++++++---------------
 drivers/net/bonding/bond_main.c                                  |   2 --
 drivers/net/bonding/bond_options.c                               |   2 --
 drivers/net/ethernet/cadence/macb_main.c                         |   5 +++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c                 |   5 ++--
 drivers/net/ethernet/ibm/ibmvnic.c                               |   3 ++
 drivers/net/ethernet/intel/iavf/iavf.h                           |  18 ++++++++++++
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c                   |  37 ++++++++++++++++---------
 drivers/net/ethernet/intel/iavf/iavf_main.c                      |  67 ++++++++++++++++++++++++++------------------
 drivers/net/ethernet/intel/iavf/iavf_txrx.c                      |  12 ++++----
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c                  | 106 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------
 drivers/net/ethernet/marvell/mvneta.c                            |  13 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c                |   2 --
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c               |  16 +++++------
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c           |   4 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c             |  41 ++++++++++++++-------------
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c   |   6 ++--
 drivers/net/ethernet/mellanox/mlx5/core/health.c                 |  14 ++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c                   |  40 +++++++++++++--------------
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c       |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic.h                      |   2 --
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c              |   7 +----
 drivers/net/ethernet/pensando/ionic/ionic_devlink.c              |   4 ---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c                  |  17 ++----------
 drivers/net/ethernet/ti/am65-cpsw-nuss.c                         |   2 +-
 drivers/net/ethernet/ti/cpsw_ale.c                               |  49 +++++++++++++++++++++++++++------
 drivers/net/hamradio/bpqether.c                                  |   2 ++
 drivers/net/ipa/ipa_data-sc7180.c                                |   2 +-
 drivers/net/ipa/ipa_endpoint.c                                   |  95 ++++++++++++++++++++++++++++++++++++++-------------------------
 drivers/net/ipa/ipa_reg.h                                        |   2 ++
 drivers/net/macsec.c                                             |   5 ++++
 drivers/net/macvlan.c                                            |  13 +++++++--
 drivers/net/vxlan.c                                              |  14 ++++------
 drivers/net/wireless/intersil/hostap/hostap_hw.c                 |   3 ++
 include/linux/netdevice.h                                        |  12 +++++---
 include/net/cfg80211.h                                           |   5 ++--
 include/net/flow_offload.h                                       |  24 ----------------
 include/net/inet_hashtables.h                                    |   6 ++++
 include/net/nexthop.h                                            |  28 ++++++++++++++++++-
 include/uapi/linux/bpf.h                                         |  13 +++++++++
 include/uapi/linux/nl80211.h                                     |   2 +-
 kernel/bpf/cgroup.c                                              |   2 +-
 kernel/bpf/devmap.c                                              |  18 ++++--------
 kernel/bpf/syscall.c                                             |  17 ++++++++----
 kernel/bpf/verifier.c                                            |   2 +-
 kernel/trace/trace_kprobe.c                                      |   2 +-
 kernel/trace/trace_uprobe.c                                      |   2 +-
 net/8021q/vlan_dev.c                                             |   8 ++++--
 net/atm/lec.c                                                    |   4 +--
 net/batman-adv/soft-interface.c                                  |   2 ++
 net/bridge/br_device.c                                           |   8 ++++++
 net/core/dev.c                                                   |  30 ++++++++++----------
 net/core/dev_addr_lists.c                                        |  12 ++++----
 net/core/filter.c                                                |  19 ++++++-------
 net/core/rtnetlink.c                                             |   1 -
 net/core/sock_map.c                                              |  38 +++++++++++++++++++++----
 net/dccp/proto.c                                                 |   7 +++--
 net/dsa/master.c                                                 |   4 +++
 net/ipv4/nexthop.c                                               |  82 ++++++++++++++++++++++++++++++++----------------------
 net/ipv4/tcp.c                                                   |  70 +++++++++++++++++++++++++++++++++++++++++-----
 net/ipv4/tcp_bpf.c                                               |   6 ++++
 net/mac80211/mlme.c                                              |   2 ++
 net/mac80211/rx.c                                                |   2 +-
 net/mptcp/options.c                                              |   2 ++
 net/mptcp/protocol.c                                             |  45 ++++++++++++++++--------------
 net/mptcp/subflow.c                                              |   1 +
 net/netlink/genetlink.c                                          |  28 ++++++++-----------
 net/netrom/af_netrom.c                                           |   2 ++
 net/rose/af_rose.c                                               |   2 ++
 net/rxrpc/ar-internal.h                                          | 119 +++++++++++++++++--------------------------------------------------------------
 net/rxrpc/call_event.c                                           |  30 ++++++++------------
 net/rxrpc/conn_event.c                                           |   7 ++---
 net/rxrpc/input.c                                                |   7 ++---
 net/rxrpc/peer_event.c                                           |   4 +--
 net/rxrpc/recvmsg.c                                              |  79 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/sendmsg.c                                              |   4 +--
 net/sched/sch_generic.c                                          |   1 +
 net/tipc/bearer.c                                                |   2 +-
 net/tipc/msg.c                                                   |   4 +--
 net/tipc/socket.c                                                |   3 +-
 net/wireless/Kconfig                                             |   2 +-
 net/wireless/core.c                                              |   6 ++--
 net/wireless/core.h                                              |   2 ++
 net/wireless/mlme.c                                              |  26 ++++++++++++++----
 net/xdp/xsk.c                                                    |   4 +--
 scripts/link-vmlinux.sh                                          |   4 +--
 tools/bpf/Makefile                                               |   1 -
 tools/bpf/bpftool/gen.c                                          |  11 ++++----
 tools/include/uapi/linux/bpf.h                                   |  13 +++++++++
 tools/lib/bpf/btf_dump.c                                         |  33 ++++++++++++++++------
 tools/lib/bpf/hashmap.h                                          |   7 ++---
 tools/lib/bpf/libbpf.c                                           |   4 ---
 tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c     |   7 +++++
 tools/testing/selftests/bpf/prog_tests/load_bytes_relative.c     |  71 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/ringbuf.c                 |  42 +++++++++++++++++++++++-----
 tools/testing/selftests/bpf/prog_tests/skeleton.c                |  45 ++++++++++++++++++++++++++----
 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c       |   8 ------
 tools/testing/selftests/bpf/progs/load_bytes_relative.c          |  48 ++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_skeleton.c                |  19 ++++++++++---
 tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c      |   2 +-
 tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c |   3 +-
 tools/testing/selftests/net/rxtimestamp.c                        |   1 +
 tools/testing/selftests/net/timestamping.c                       |  10 +++++--
 tools/testing/selftests/net/tls.c                                |  58 +++++++++++++++++++++++++++++++++++++++
 111 files changed, 1344 insertions(+), 647 deletions(-)
 delete mode 100644 Documentation/networking/devlink-params-sja1105.txt
 create mode 100644 Documentation/networking/devlink/sja1105.rst
 create mode 100644 tools/testing/selftests/bpf/prog_tests/load_bytes_relative.c
 create mode 100644 tools/testing/selftests/bpf/progs/load_bytes_relative.c
