Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94025166C20
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 01:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgBUAuP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Feb 2020 19:50:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729365AbgBUAuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 19:50:15 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E01C133F0B08;
        Thu, 20 Feb 2020 16:50:14 -0800 (PST)
Date:   Thu, 20 Feb 2020 16:50:05 -0800 (PST)
Message-Id: <20200220.165005.109882010805629679.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 16:50:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Limit xt_hashlimit hash table size to avoid OOM or hung tasks, from
   Cong Wang.

2) Fix deadlock in xsk by publishing global consumer pointers when NAPI
   is finished, from Magnus Karlsson.

3) Set table field properly to RT_TABLE_COMPAT when necessary, from Jethro
   Beekman.

4) NLA_STRING attributes are not necessary NULL terminated, deal wiht
   that in IFLA_ALT_IFNAME.  From Eric Dumazet.

5) Fix checksum handling in atlantic driver, from Dmitry Bezrukov.

6) Handle mtu==0 devices properly in wireguard, from Jason A. Donenfeld.

7) Fix several lockdep warnings in bonding, from Taehee Yoo.

8) Fix cls_flower port blocking, from Jason Baron.

9) Sanitize internal map names in libbpf, from Toke Høiland-Jørgensen.

10) Fix RDMA race in qede driver, from Michal Kalderon.

11) Fix several false lockdep warnings by adding conditions to
    list_for_each_entry_rcu(), from Madhuparna Bhowmik.

12) Fix sleep in atomic in mlx5 driver, from Huy Nguyen.

13) Fix potential deadlock in bpf_map_do_batch(), from Yonghong Song.

14) Hey, variables declared in switch statement before any case statements
    are not initialized.  I learn something every day.  Get rids of this
    stuff in several parts of the networking, from Kees Cook.

Please pull, thanks a lot!

The following changes since commit 2019fc96af228b412bdb2e8e0ad4b1fc12046a51:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-02-14 12:40:38 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 36a44bcdd8df092d76c11bc213e81c5817d4e302:

  Merge branch 'bnxt_en-shutdown-and-kexec-kdump-related-fixes' (2020-02-20 16:05:42 -0800)

----------------------------------------------------------------
Alexandra Winter (1):
      s390/qeth: vnicc Fix EOPNOTSUPP precedence

Alexandre Belloni (3):
      net: macb: ensure interface is not suspended on at91rm9200
      net: cnic: fix spelling mistake "reserverd" -> "reserved"
      net: macb: Properly handle phylink on at91rm9200

Amol Grover (1):
      net: hsr: Pass lockdep expression to RCU lists

Arun Parameswaran (1):
      net: phy: restore mdio regs in the iproc mdio driver

Aya Levin (2):
      net/mlx5e: Reset RQ doorbell counter before moving RQ state from RST to RDY
      net/mlx5e: Fix crash in recovery flow without devlink reporter

Benjamin Poirier (2):
      ipv6: Fix route replacement with dev-only route
      ipv6: Fix nlmsg_flags when splitting a multipath route

Brett Creeley (2):
      ice: Don't reject odd values of usecs set by user
      ice: Wait for VF to be reset/ready before configuration

Brian Vazquez (1):
      bpf: Do not grab the bucket spinlock by default on htab batch ops

Christophe JAILLET (1):
      NFC: pn544: Fix a typo in a debug message

Cong Wang (2):
      netfilter: xt_hashlimit: reduce hashlimit_mutex scope for htable_put()
      netfilter: xt_hashlimit: limit the max size of hashtable

David S. Miller (9):
      Merge branch 'atlantic-fixes'
      Merge branch 'wireguard-fixes'
      Merge branch 'bonding-fix-bonding-interface-bugs'
      Merge git://git.kernel.org/.../pablo/nf
      Merge tag 'mlx5-fixes-2020-02-18' of git://git.kernel.org/.../saeed/linux
      Merge branch '100GbE' of git://git.kernel.org/.../jkirsher/net-queue
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 's390-fixes'
      Merge branch 'bnxt_en-shutdown-and-kexec-kdump-related-fixes'

Dmitry Bezrukov (1):
      net: atlantic: checksum compat issue

Dmitry Bogdanov (1):
      net: atlantic: fix out of range usage of active_vlans array

Dmitry Osipenko (1):
      nfc: pn544: Fix occasional HW initialization failure

Dmytro Linkin (1):
      net/mlx5e: Don't clear the whole vf config when switching modes

Egor Pomozov (1):
      net: atlantic: ptp gpio adjustments

Erez Shitrit (1):
      net/mlx5: DR, Handle reformat capability over sw-steering tables

Eric Dumazet (2):
      net: rtnetlink: fix bugs in rtnl_alt_ifname()
      net: add strict checks in netdev_name_node_alt_destroy()

Florian Fainelli (1):
      net: dsa: b53: Ensure the default VID is untagged

Florian Westphal (6):
      netfilter: flowtable: skip offload setup if disabled
      netfilter: conntrack: remove two args from resolve_clash
      netfilter: conntrack: place confirm-bit setting in a helper
      netfilter: conntrack: split resolve_clash function
      netfilter: conntrack: allow insertion of clashing entries
      mptcp: fix bogus socket flag values

Hamdan Igbaria (1):
      net/mlx5: DR, Fix matching on vport gvmi

Hangbin Liu (3):
      selftests: forwarding: use proto icmp for {gretap, ip6gretap}_mac testing
      selftests: forwarding: vxlan_bridge_1d: fix tos value
      selftests: forwarding: vxlan_bridge_1d: use more proper tos value

Hongbo Yao (1):
      bpf: Make btf_check_func_type_match() static

Horatiu Vultur (1):
      net: mscc: fix in frame extraction

Huy Nguyen (1):
      net/mlx5: Fix sleep while atomic in mlx5_eswitch_get_vepa

Igor Russkikh (1):
      net: atlantic: check rpc result and wait for rpc address

Jakub Sitnicki (1):
      selftests/bpf: Mark SYN cookie test skipped for UDP sockets

Jason A. Donenfeld (4):
      wireguard: selftests: reduce complexity and fix make races
      wireguard: receive: reset last_under_load to zero
      wireguard: send: account for mtu=0 devices
      wireguard: socket: remove extra call to synchronize_net

Jason Baron (1):
      net: sched: correct flower port blocking

Jethro Beekman (1):
      net: fib_rules: Correctly set table field when table number exceeds 8 bits

Johannes Krude (1):
      bpf, offload: Replace bitwise AND by logical AND in bpf_prog_offload_info_fill

John Fastabend (1):
      bpf: Selftests build error in sockmap_basic.c

Jonathan Neuschäfer (1):
      net: phy: broadcom: Fix a typo ("firsly")

Julian Wiedmann (2):
      s390/qeth: don't warn for napi with 0 budget
      s390/qeth: fix off-by-one in RX copybreak check

Kees Cook (3):
      net: core: Distribute switch variables for initialization
      net: ip6_gre: Distribute switch variables for initialization
      openvswitch: Distribute switch variables for initialization

Leon Romanovsky (1):
      net/rds: Track user mapped pages through special API

Madhuparna Bhowmik (7):
      net: netlabel: Use built-in RCU list checking
      netlabel_domainhash.c: Use built-in RCU list checking
      meter.c: Use built-in RCU list checking
      vport.c: Use built-in RCU list checking
      datapath.c: Use built-in RCU list checking
      flow_table.c: Use built-in RCU list checking
      bridge: br_stp: Use built-in RCU list checking

Magnus Karlsson (1):
      xsk: Publish global consumer pointers when NAPI is finished

Marek Vasut (3):
      net: ks8851-ml: Remove 8-bit bus accessors
      net: ks8851-ml: Fix 16-bit data access
      net: ks8851-ml: Fix 16-bit IO operation

Martin KaFai Lau (1):
      selftests/bpf: Fix error checking on reading the tcp_fastopen sysctl

Mat Martineau (1):
      mptcp: Protect subflow socket options before connection completes

Matthieu Baerts (1):
      mptcp: select CRYPTO

Michal Kalderon (1):
      qede: Fix race between rdma destroy workqueue and link change event

Michal Kubecek (1):
      ethtool: fix application of verbose no_mask bitset

Michal Swiatkowski (1):
      ice: Don't tell the OS that link is going down

Nikita Danilov (1):
      net: atlantic: better loopback mode handling

Nikolay Aleksandrov (1):
      net: netlink: cap max groups which will be considered in netlink_bind()

Paolo Abeni (1):
      Revert "net: dev: introduce support for sch BYPASS for lockless qdisc"

Paul Blakey (1):
      net/mlx5: Fix lowest FDB pool size

Paul Cercueil (1):
      net: ethernet: dm9000: Handle -EPROBE_DEFER in dm9000_parse_dt()

Pavel Belous (3):
      net: atlantic: fix use after free kasan warn
      net: atlantic: fix potential error handling
      net: atlantic: possible fault in transition to hibernation

Randy Dunlap (3):
      net/sock.h: fix all kernel-doc warnings
      skbuff: remove stale bit mask comments
      skbuff.h: fix all kernel-doc warnings

Rohit Maheshwari (1):
      net/tls: Fix to avoid gettig invalid tls record

Roman Kiryanov (1):
      net: disable BRIDGE_NETFILTER by default

Shannon Nelson (1):
      ionic: fix fw_status read

Stefano Brivio (2):
      netfilter: nft_set_pipapo: Fix mapping table example in comments
      netfilter: nft_set_pipapo: Don't abuse unlikely() in pipapo_refill()

Taehee Yoo (3):
      bonding: add missing netdev_update_lockdep_key()
      net: export netdev_next_lower_dev_rcu()
      bonding: fix lockdep warning in bond_get_stats()

Tim Harvey (1):
      net: thunderx: workaround BGX TX Underflow issue

Toke Høiland-Jørgensen (2):
      bpf, uapi: Remove text about bpf_redirect_map() giving higher performance
      libbpf: Sanitise internal map names so they are not rejected by the kernel

Vasundhara Volam (2):
      bnxt_en: Improve device shutdown method.
      bnxt_en: Issue PCIe FLR in kdump kernel to cleanup pending DMAs.

Willem de Bruijn (1):
      udp: rehash on disconnect

Xin Long (1):
      sctp: move the format error check out of __sctp_sf_do_9_1_abort

Yonghong Song (1):
      bpf: Fix a potential deadlock with bpf_map_do_batch

 drivers/net/bonding/bond_main.c                     |  55 +++++-
 drivers/net/bonding/bond_options.c                  |   2 +
 drivers/net/dsa/b53/b53_common.c                    |   3 +
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c |   5 +
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c |   2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h      |   2 +
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c     |   8 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c    |  13 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c    |  10 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h    |   3 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c   |  22 ++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c         |  19 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c    |  12 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c           |  12 +-
 drivers/net/ethernet/broadcom/cnic_defs.h           |   4 +-
 drivers/net/ethernet/cadence/macb.h                 |   1 +
 drivers/net/ethernet/cadence/macb_main.c            |  66 +++----
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c   |  62 ++++++-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.h   |   9 +
 drivers/net/ethernet/davicom/dm9000.c               |   2 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c        |  56 ++++--
 drivers/net/ethernet/intel/ice/ice_txrx.h           |   2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c    | 134 +++++++-------
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h    |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h   |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c   |  20 +--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c  |   4 +-
 .../mellanox/mlx5/core/eswitch_offloads_chains.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c   |   5 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c    |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/wq.c        |  39 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/wq.h        |   2 +
 drivers/net/ethernet/micrel/ks8851_mll.c            |  53 +-----
 drivers/net/ethernet/mscc/ocelot_board.c            |   8 +
 drivers/net/ethernet/pensando/ionic/ionic_dev.c     |  11 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h      |   1 +
 drivers/net/ethernet/qlogic/qede/qede.h             |   2 +
 drivers/net/ethernet/qlogic/qede/qede_rdma.c        |  29 +++-
 drivers/net/phy/broadcom.c                          |   4 +-
 drivers/net/phy/mdio-bcm-iproc.c                    |  20 +++
 drivers/net/wireguard/device.c                      |   7 +-
 drivers/net/wireguard/receive.c                     |   7 +-
 drivers/net/wireguard/send.c                        |  16 +-
 drivers/net/wireguard/socket.c                      |   1 -
 drivers/nfc/pn544/i2c.c                             |   1 +
 drivers/nfc/pn544/pn544.c                           |   2 +-
 drivers/s390/net/qeth_core_main.c                   |   3 +-
 drivers/s390/net/qeth_l2_main.c                     |  29 ++--
 include/linux/mlx5/mlx5_ifc.h                       |   5 +-
 include/linux/netdevice.h                           |   7 +-
 include/linux/rculist_nulls.h                       |   7 +
 include/linux/skbuff.h                              |  30 ++++
 include/net/flow_dissector.h                        |   9 +
 include/net/sock.h                                  |  38 +++-
 include/uapi/linux/bpf.h                            |  16 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h  |  12 +-
 kernel/bpf/btf.c                                    |   6 +-
 kernel/bpf/hashtab.c                                |  58 ++++++-
 kernel/bpf/offload.c                                |   2 +-
 net/Kconfig                                         |   1 -
 net/bridge/br_stp.c                                 |   3 +-
 net/core/dev.c                                      |  34 ++--
 net/core/fib_rules.c                                |   2 +-
 net/core/rtnetlink.c                                |  26 ++-
 net/core/skbuff.c                                   |   6 +-
 net/ethtool/bitset.c                                |   3 +
 net/hsr/hsr_framereg.c                              |   3 +-
 net/ipv4/udp.c                                      |   6 +-
 net/ipv6/ip6_fib.c                                  |   7 +-
 net/ipv6/ip6_gre.c                                  |   8 +-
 net/ipv6/ip6_tunnel.c                               |  13 +-
 net/ipv6/route.c                                    |   1 +
 net/mptcp/Kconfig                                   |   1 +
 net/mptcp/protocol.c                                |  48 ++----
 net/mptcp/protocol.h                                |   4 +-
 net/netfilter/nf_conntrack_core.c                   | 192 ++++++++++++++++++---
 net/netfilter/nf_conntrack_proto_udp.c              |  20 ++-
 net/netfilter/nf_flow_table_offload.c               |   6 +-
 net/netfilter/nft_set_pipapo.c                      |   6 +-
 net/netfilter/xt_hashlimit.c                        |  22 ++-
 net/netlabel/netlabel_domainhash.c                  |   3 +-
 net/netlabel/netlabel_unlabeled.c                   |   3 +-
 net/netlink/af_netlink.c                            |   5 +-
 net/openvswitch/datapath.c                          |   9 +-
 net/openvswitch/flow_netlink.c                      |  18 +-
 net/openvswitch/flow_table.c                        |   6 +-
 net/openvswitch/meter.c                             |   3 +-
 net/openvswitch/vport.c                             |   3 +-
 net/rds/rdma.c                                      |  24 +--
 net/sched/cls_flower.c                              |   1 +
 net/sctp/sm_statefuns.c                             |  29 +++-
 net/tls/tls_device.c                                |  20 ++-
 net/xdp/xsk.c                                       |   2 +
 net/xdp/xsk_queue.h                                 |   3 +-
 tools/include/uapi/linux/bpf.h                      |  16 +-
 tools/lib/bpf/libbpf.c                              |   8 +-
 .../selftests/bpf/prog_tests/select_reuseport.c     |   8 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c        |   5 +
 tools/testing/selftests/net/fib_tests.sh            |   6 +
 .../testing/selftests/net/forwarding/mirror_gre.sh  |  25 +--
 .../selftests/net/forwarding/vxlan_bridge_1d.sh     |   6 +-
 tools/testing/selftests/wireguard/qemu/Makefile     |  38 ++--
 104 files changed, 1132 insertions(+), 506 deletions(-)
