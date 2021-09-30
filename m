Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992DD41DF0E
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 18:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351271AbhI3QcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 12:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351188AbhI3Qb4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 12:31:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 940646159A;
        Thu, 30 Sep 2021 16:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633019413;
        bh=Kie/gOIzUZvE2ENVRX6DrQyhmQzd5nJeuliASVP2b7Y=;
        h=From:To:Cc:Subject:Date:From;
        b=BhQppSNwxQsrV/qLop+GOOClkVOIalP3Da9TM1s93fBxnlb40dkK5kAzx4YmVEI2j
         KnPtjxHe8OVEzBbKAt/wFn0ovEwJYgS9YGjAhZne7DNM0B4KEPv6iZWDm/faEIcFa5
         bcka3KMZ7RKoOgZDB7pV1XVtmgtuhUonguCHJZb7uw22TZXtNOnXaFdnZMigOkrtH4
         /tBN8QpPfnvt1XUhHatfS1bDuhbDl0CLhEKz4R+1ULgFJD+UrlQ+JakFZU9j+rip0e
         ECENjrt4Egcedlko99zQWO/CNF2W3ag6f+7mAUzUsVaZ+G1HfaSHrlfK8o9lIkQgUy
         vLr7yPpv1i/Tg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        johannes@sipsolutions.net, pablo@netfilter.org
Subject: [GIT PULL] Networking for 5.15-rc4
Date:   Thu, 30 Sep 2021 09:30:02 -0700
Message-Id: <20210930163002.4159171-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit 9bc62afe03afdf33904f5e784e1ad68c50ff00bb:

  Merge tag 'net-5.15-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-09-23 10:30:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.15-rc4

for you to fetch changes up to 35306eb23814444bd4021f8a1c3047d3cb0c8b2b:

  af_unix: fix races in sk_peer_pid and sk_peer_cred accesses (2021-09-30 14:18:40 +0100)

----------------------------------------------------------------
Networking fixes for 5.15-rc4, including fixes from mac80211, netfilter
and bpf.

Current release - regressions:

 - bpf, cgroup: assign cgroup in cgroup_sk_alloc when called from
   interrupt

 - mdio: revert mechanical patches which broke handling of optional
   resources

 - dev_addr_list: prevent address duplication

Previous releases - regressions:

 - sctp: break out if skb_header_pointer returns NULL in sctp_rcv_ootb
   (NULL deref)

 - Revert "mac80211: do not use low data rates for data frames with no
   ack flag", fixing broadcast transmissions

 - mac80211: fix use-after-free in CCMP/GCMP RX

 - netfilter: include zone id in tuple hash again, minimize collisions

 - netfilter: nf_tables: unlink table before deleting it (race -> UAF)

 - netfilter: log: work around missing softdep backend module

 - mptcp: don't return sockets in foreign netns

 - sched: flower: protect fl_walk() with rcu (race -> UAF)

 - ixgbe: fix NULL pointer dereference in ixgbe_xdp_setup

 - smsc95xx: fix stalled rx after link change

 - enetc: fix the incorrect clearing of IF_MODE bits

 - ipv4: fix rtnexthop len when RTA_FLOW is present

 - dsa: mv88e6xxx: 6161: use correct MAX MTU config method for this SKU

 - e100: fix length calculation & buffer overrun in ethtool::get_regs

Previous releases - always broken:

 - mac80211: fix using stale frag_tail skb pointer in A-MSDU tx

 - mac80211: drop frames from invalid MAC address in ad-hoc mode

 - af_unix: fix races in sk_peer_pid and sk_peer_cred accesses
   (race -> UAF)

 - bpf, x86: Fix bpf mapping of atomic fetch implementation

 - bpf: handle return value of BPF_PROG_TYPE_STRUCT_OPS prog

 - netfilter: ip6_tables: zero-initialize fragment offset

 - mhi: fix error path in mhi_net_newlink

 - af_unix: return errno instead of NULL in unix_create1() when
   over the fs.file-max limit

Misc:

 - bpf: exempt CAP_BPF from checks against bpf_jit_limit

 - netfilter: conntrack: make max chain length random, prevent guessing
   buckets by attackers

 - netfilter: nf_nat_masquerade: make async masq_inet6_event handling
   generic, defer conntrack walk to work queue (prevent hogging RTNL lock)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aaro Koskinen (1):
      smsc95xx: fix stalled rx after link change

Alexander Wetzel (1):
      mac80211: Fix Ptk0 rekey documentation

Andrea Claudi (1):
      ipvs: check that ip_vs_conn_tab_bits is between 8 and 20

Andrew Lunn (3):
      dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
      dsa: mv88e6xxx: Fix MTU definition
      dsa: mv88e6xxx: Include tagger overhead when setting MTU for DSA and CPU ports

Arnd Bergmann (3):
      net: ks8851: fix link error
      dmascc: add CONFIG_VIRT_TO_BUS dependency
      net: hns3: fix hclge_dbg_dump_tm_pg() stack usage

Cai Huoqing (1):
      net: mdio-ipq4019: Fix the error for an optional regs resource

Chih-Kang Chang (1):
      mac80211: Fix ieee80211_amsdu_aggregate frag_tail bug

Colin Ian King (1):
      net: hns: Fix spelling mistake "maped" -> "mapped"

Daniel Borkmann (2):
      bpf, cgroup: Assign cgroup in cgroup_sk_alloc when called from interrupt
      bpf, test, cgroup: Use sk_{alloc,free} for test cases

Daniele Palmas (1):
      drivers: net: mhi: fix error path in mhi_net_newlink

Dave Marchevsky (1):
      MAINTAINERS: Add btf headers to BPF

David S. Miller (6):
      Merge branch 'mptcp-fixes'
      Merge branch 'mv88e6xxx-mtu-fixes'
      Merge tag 'mac80211-for-net-2021-09-27' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/t nguy/net-queue
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'hns3-fixes'

Davide Caratti (1):
      mptcp: allow changing the 'backup' bit when no sockets are open

Desnes A. Nunes do Rosario (1):
      Revert "ibmvnic: check failover_pending in login response"

Eric Dumazet (3):
      netfilter: conntrack: serialize hash resizes and cleanups
      net: udp: annotate data race around udp_sk(sk)->corkflag
      af_unix: fix races in sk_peer_pid and sk_peer_cred accesses

Felix Fietkau (1):
      Revert "mac80211: do not use low data rates for data frames with no ack flag"

Feng Zhou (1):
      ixgbe: Fix NULL pointer dereference in ixgbe_xdp_setup

Florian Fainelli (1):
      net: phy: bcm7xxx: Fixed indirect MMD operations

Florian Westphal (11):
      netfilter: conntrack: make max chain length random
      netfilter: conntrack: include zone id in tuple hash again
      netfilter: nat: include zone id in nat table hash again
      selftests: netfilter: add selftest for directional zone support
      selftests: netfilter: add zone stress test with colliding tuples
      netfilter: nf_tables: unlink table before deleting it
      netfilter: nf_nat_masquerade: make async masq_inet6_event handling generic
      netfilter: nf_nat_masquerade: defer conntrack walk to work queue
      netfilter: iptable_raw: drop bogus net_init annotation
      netfilter: log: work around missing softdep backend module
      mptcp: don't return sockets in foreign netns

Guangbin Huang (3):
      net: hns3: PF enable promisc for VF when mac table is overflow
      net: hns3: fix always enable rx vlan filter problem after selftest
      net: hns3: disable firmware compatible features when uninstall PF

Horatiu Vultur (1):
      net: mdio: mscc-miim: Fix the mdio controller

Hou Tao (1):
      bpf: Handle return value of BPF_PROG_TYPE_STRUCT_OPS prog

Jacob Keller (2):
      e100: fix length calculation in e100_get_regs_len
      e100: fix buffer overrun in e100_get_regs

Jakub Kicinski (2):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      net: dev_addr_list: handle first address in __hw_addr_add_ex

Jeremy Sowden (1):
      netfilter: ip6_tables: zero-initialize fragment offset

Jian Shen (5):
      net: hns3: do not allow call hns3_nic_net_open repeatedly
      net: hns3: remove tc enable checking
      net: hns3: don't rollback when destroy mqprio fail
      net: hns3: fix mixed flag HCLGE_FLAG_MQPRIO_ENABLE and HCLGE_FLAG_DCB_ENABLE
      net: hns3: fix show wrong state when add existing uc mac address

Jiri Benc (2):
      selftests, bpf: Fix makefile dependencies on libbpf
      selftests, bpf: test_lwt_ip_encap: Really disable rp_filter

Johan Almbladh (1):
      bpf, x86: Fix bpf mapping of atomic fetch implementation

Johannes Berg (3):
      mac80211: mesh: fix potentially unaligned access
      mac80211-hwsim: fix late beacon hrtimer handling
      mac80211: fix use-after-free in CCMP/GCMP RX

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix oversized kvmalloc() calls

Kumar Kartikeya Dwivedi (1):
      libbpf: Fix segfault in static linker for objects without BTF

Kuniyuki Iwashima (1):
      af_unix: Return errno instead of NULL in unix_create1().

Lorenz Bauer (1):
      bpf: Exempt CAP_BPF from checks against bpf_jit_limit

Lorenzo Bianconi (1):
      mac80211: limit injected vht mcs/nss in ieee80211_parse_tx_radiotap

Matthew Hagan (1):
      net: bgmac-platform: handle mac-address deferral

MichelleJin (1):
      mac80211: check return value of rhashtable_init

Pablo Neira Ayuso (1):
      netfilter: nf_tables: Fix oversized kvmalloc() calls

Paolo Abeni (1):
      net: introduce and use lock_sock_fast_nested()

Piotr Krysiuk (1):
      bpf, mips: Validate conditional branch offsets

Randy Dunlap (1):
      net: sun: SUNVNET_COMMON should depend on INET

Shannon Nelson (1):
      ionic: fix gathering of debug stats

Thomas Gleixner (1):
      net: bridge: mcast: Associate the seqcount with its protecting lock.

Vlad Buslov (1):
      net: sched: flower: protect fl_walk() with rcu

Vladimir Oltean (1):
      net: enetc: fix the incorrect clearing of IF_MODE bits

Wong Vee Khee (1):
      net: stmmac: fix EEE init issue when paired with EEE capable PHYs

Xiao Liang (1):
      net: ipv4: Fix rtnexthop len when RTA_FLOW is present

Xin Long (1):
      sctp: break out if skb_header_pointer returns NULL in sctp_rcv_ootb

Xu Liang (1):
      net: phy: enhance GPY115 loopback disable function

Yanfei Xu (1):
      net: mdiobus: Fix memory leak in __mdiobus_register

YueHaibing (1):
      mac80211: Drop frames from invalid MAC address in ad-hoc mode

王贇 (1):
      net: prevent user from passing illegal stab size

 MAINTAINERS                                        |   2 +
 arch/mips/net/bpf_jit.c                            |  57 +++-
 arch/x86/net/bpf_jit_comp.c                        |  66 +++--
 drivers/net/dsa/mv88e6xxx/chip.c                   |  17 +-
 drivers/net/dsa/mv88e6xxx/chip.h                   |   1 +
 drivers/net/dsa/mv88e6xxx/global1.c                |   2 +
 drivers/net/dsa/mv88e6xxx/port.c                   |   2 +
 drivers/net/ethernet/broadcom/bgmac-platform.c     |   3 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   3 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  16 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   6 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |  21 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  29 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  28 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  27 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  33 +--
 drivers/net/ethernet/hisilicon/hns_mdio.c          |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   8 -
 drivers/net/ethernet/intel/e100.c                  |  22 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   8 +-
 drivers/net/ethernet/micrel/Makefile               |   6 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |   8 +
 drivers/net/ethernet/pensando/ionic/ionic_stats.c  |   9 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +
 drivers/net/ethernet/sun/Kconfig                   |   1 +
 drivers/net/hamradio/Kconfig                       |   1 +
 drivers/net/mdio/mdio-ipq4019.c                    |   6 +-
 drivers/net/mdio/mdio-mscc-miim.c                  |  15 +-
 drivers/net/mhi_net.c                              |   6 +-
 drivers/net/phy/bcm7xxx.c                          | 114 +++++++-
 drivers/net/phy/mdio_bus.c                         |   1 +
 drivers/net/phy/mxl-gpy.c                          |  23 +-
 drivers/net/usb/smsc95xx.c                         |   3 +
 drivers/net/wireless/mac80211_hwsim.c              |   4 +-
 include/linux/bpf.h                                |   3 +-
 include/net/ip_fib.h                               |   2 +-
 include/net/mac80211.h                             |   8 +-
 include/net/nexthop.h                              |   2 +-
 include/net/pkt_sched.h                            |   1 +
 include/net/sock.h                                 |  33 ++-
 kernel/bpf/bpf_struct_ops.c                        |   7 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/cgroup/cgroup.c                             |  17 +-
 net/bpf/test_run.c                                 |  14 +-
 net/bridge/br_multicast.c                          |   6 +-
 net/bridge/br_private.h                            |   2 +-
 net/core/dev_addr_lists.c                          |   6 +
 net/core/sock.c                                    |  52 ++--
 net/ipv4/fib_semantics.c                           |  16 +-
 net/ipv4/netfilter/iptable_raw.c                   |   2 +-
 net/ipv4/udp.c                                     |  10 +-
 net/ipv6/netfilter/ip6_tables.c                    |   1 +
 net/ipv6/route.c                                   |   5 +-
 net/ipv6/udp.c                                     |   2 +-
 net/mac80211/mesh_pathtbl.c                        |   5 +-
 net/mac80211/mesh_ps.c                             |   3 +-
 net/mac80211/rate.c                                |   4 -
 net/mac80211/rx.c                                  |   3 +-
 net/mac80211/tx.c                                  |  12 +
 net/mac80211/wpa.c                                 |   6 +
 net/mptcp/mptcp_diag.c                             |   2 +-
 net/mptcp/pm_netlink.c                             |   4 +-
 net/mptcp/protocol.c                               |   2 +-
 net/mptcp/protocol.h                               |   2 +-
 net/mptcp/subflow.c                                |   2 +-
 net/mptcp/syncookies.c                             |  13 +-
 net/mptcp/token.c                                  |  11 +-
 net/mptcp/token_test.c                             |  14 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   4 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   4 +
 net/netfilter/nf_conntrack_core.c                  | 154 ++++++----
 net/netfilter/nf_nat_core.c                        |  17 +-
 net/netfilter/nf_nat_masquerade.c                  | 168 ++++++-----
 net/netfilter/nf_tables_api.c                      |  30 +-
 net/netfilter/nft_compat.c                         |  17 +-
 net/netfilter/xt_LOG.c                             |  10 +-
 net/netfilter/xt_NFLOG.c                           |  10 +-
 net/sched/cls_flower.c                             |   6 +
 net/sched/sch_api.c                                |   6 +
 net/sctp/input.c                                   |   2 +-
 net/unix/af_unix.c                                 |  83 ++++--
 tools/lib/bpf/linker.c                             |   8 +-
 tools/testing/selftests/bpf/Makefile               |   3 +-
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh   |  13 +-
 tools/testing/selftests/netfilter/nft_nat_zones.sh | 309 +++++++++++++++++++++
 .../testing/selftests/netfilter/nft_zones_many.sh  | 156 +++++++++++
 88 files changed, 1384 insertions(+), 447 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_nat_zones.sh
 create mode 100755 tools/testing/selftests/netfilter/nft_zones_many.sh
