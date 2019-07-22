Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2124A6F843
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 06:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfGVEPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 00:15:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38522 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfGVEPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 00:15:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC28C14F15214;
        Sun, 21 Jul 2019 21:15:19 -0700 (PDT)
Date:   Sun, 21 Jul 2019 21:13:21 -0700 (PDT)
Message-Id: <20190721.211321.455757135945724538.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 21:15:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Several netfilter fixes including a nfnetlink deadlock fix from
   Florian Westphal and fix for dropping VRF packets from Miaohe Lin.

2) Flow offload fixes from Pablo Neira Ayuso including a fix to
   restore proper block sharing.

3) Fix r8169 PHY init from Thomas Voegtle.

4) Fix memory leak in mac80211, from Lorenzo Bianconi.

5) Missing NULL check on object allocation in cxgb4, from Navid
   Emamdoost.

6) Fix scaling of RX power in sfp phy driver, from Andrew Lunn.

7) Check that there is actually an ip header to access in skb->data in
   VRF, from Peter Kosyh.

8) Remove spurious rcu unlock in hv_netvsc, from Haiyang Zhang.

9) One more tweak the the TCP fragmentation memory limit changes, to
   be less harmful to applications setting small SO_SNDBUF values.
   From Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit 31cc088a4f5d83481c6f5041bd6eb06115b974af:

  Merge tag 'drm-next-2019-07-19' of git://anongit.freedesktop.org/drm/drm (2019-07-19 12:29:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 

for you to fetch changes up to b617158dc096709d8600c53b6052144d12b89fab:

  tcp: be more careful in tcp_fragment() (2019-07-21 20:41:24 -0700)

----------------------------------------------------------------
Andrew Lunn (1):
      net: phy: sfp: hwmon: Fix scaling of RX power

Arnd Bergmann (1):
      netfilter: bridge: make NF_TABLES_BRIDGE tristate

Benjamin Poirier (1):
      be2net: Synchronize be_update_queues with dev_watchdog

Brian King (1):
      bnx2x: Prevent load reordering in tx completion processing

Brian Norris (1):
      mac80211: don't warn about CW params when not using them

Christian Hesse (1):
      netfilter: nf_tables: fix module autoload for redir

Christophe JAILLET (3):
      tipc: Fix a typo
      net: hns3: typo in the name of a constant
      chelsio: Fix a typo in a function name

David S. Miller (3):
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'flow_offload-fixes'
      Merge tag 'mac80211-for-davem-2019-07-20' of git://git.kernel.org/.../jberg/mac80211

Eric Dumazet (1):
      tcp: be more careful in tcp_fragment()

Fernando Fernandez Mancera (2):
      netfilter: synproxy: fix erroneous tcp mss option
      netfilter: synproxy: fix rst sequence number mismatch

Florian Westphal (3):
      netfilter: nfnetlink: avoid deadlock due to synchronous request_module
      netfilter: conntrack: always store window size un-scaled
      netfilter: nf_tables: don't fail when updating base chain policy

Frederick Lawler (3):
      cxgb4: Prefer pcie_capability_read_word()
      igc: Prefer pcie_capability_read_word()
      qed: Prefer pcie_capability_read_word()

Haiyang Zhang (1):
      hv_netvsc: Fix extra rcu_read_unlock in netvsc_recv_callback()

Jeremy Sowden (1):
      kbuild: add net/netfilter/nf_tables_offload.h to header-test blacklist.

Johannes Berg (2):
      wireless: fix nl80211 vendor commands
      nl80211: fix VENDOR_CMD_RAW_DATA

John Crispin (1):
      nl80211: fix NL80211_HE_MAX_CAPABILITY_LEN

Laura Garcia Liebana (1):
      netfilter: nft_hash: fix symhash with modulus one

Lorenzo Bianconi (1):
      mac80211: fix possible memory leak in ieee80211_assign_beacon

Miaohe Lin (1):
      netfilter: Fix rpfilter dropping vrf packets by mistake

Navid Emamdoost (1):
      allocate_flower_entry: should check for null deref

Pablo Neira Ayuso (6):
      netfilter: nft_meta: skip EAGAIN if nft_meta_bridge is not a module
      netfilter: bridge: NF_CONNTRACK_BRIDGE does not depend on NF_TABLES_BRIDGE
      net: openvswitch: rename flow_stats to sw_flow_stats
      net: flow_offload: remove netns parameter from flow_block_cb_alloc()
      net: flow_offload: rename tc_setup_cb_t to flow_setup_cb_t
      net: flow_offload: add flow_block structure and use it

Peter Kosyh (1):
      vrf: make sure skb->data contains ip header to make routing

Phil Sutter (1):
      netfilter: nf_tables: Support auto-loading for inet nat

Thomas Voegtle (1):
      r8169: fix RTL8168g PHY init

Vasily Averin (1):
      connector: remove redundant input callback from cn_dev

Vlad Buslov (1):
      net: sched: verify that q!=NULL before setting q->flags

Yonatan Goldschmidt (1):
      netfilter: Update obsolete comments referring to ip_conntrack

xiao ruizhu (1):
      netfilter: nf_conntrack_sip: fix expectation clash

 drivers/connector/connector.c                             |  6 +-----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c           |  3 +++
 drivers/net/ethernet/chelsio/cxgb/my3126.c                |  4 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c           |  6 ++----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c      |  3 ++-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                |  9 +++------
 drivers/net/ethernet/emulex/benet/be_main.c               |  5 +++++
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h           |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c    |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c  |  4 ++--
 drivers/net/ethernet/intel/igc/igc_main.c                 | 12 ++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c          |  5 ++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c            | 15 ++++++++-------
 drivers/net/ethernet/mscc/ocelot_flower.c                 | 11 +++++------
 drivers/net/ethernet/mscc/ocelot_tc.c                     |  6 +++---
 drivers/net/ethernet/netronome/nfp/flower/offload.c       | 11 +++++------
 drivers/net/ethernet/qlogic/qed/qed_rdma.c                |  5 ++---
 drivers/net/ethernet/realtek/r8169_main.c                 |  4 ++--
 drivers/net/hyperv/netvsc_drv.c                           |  1 -
 drivers/net/phy/sfp.c                                     |  2 +-
 drivers/net/vrf.c                                         | 58 +++++++++++++++++++++++++++++++++++-----------------------
 drivers/net/wireless/ath/wil6210/cfg80211.c               |  4 ++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c |  1 +
 drivers/net/wireless/ti/wlcore/vendor_cmd.c               |  3 +++
 include/Kbuild                                            |  1 +
 include/linux/connector.h                                 |  1 -
 include/linux/netfilter/nf_conntrack_h323_asn1.h          |  3 +--
 include/net/cfg80211.h                                    |  2 +-
 include/net/flow_offload.h                                | 30 ++++++++++++++++++++++--------
 include/net/netfilter/nf_conntrack_expect.h               | 12 +++++++++---
 include/net/netfilter/nf_conntrack_synproxy.h             |  1 +
 include/net/netfilter/nf_tables.h                         |  5 +++--
 include/net/pkt_cls.h                                     |  5 ++---
 include/net/sch_generic.h                                 |  8 +++-----
 include/net/tcp.h                                         |  5 +++++
 include/uapi/linux/nl80211.h                              |  2 +-
 net/bridge/netfilter/Kconfig                              |  6 +++---
 net/core/flow_offload.c                                   | 22 ++++++++++------------
 net/dsa/slave.c                                           |  6 +++---
 net/ipv4/netfilter/ipt_CLUSTERIP.c                        |  4 ++--
 net/ipv4/netfilter/ipt_SYNPROXY.c                         |  2 ++
 net/ipv4/netfilter/ipt_rpfilter.c                         |  1 +
 net/ipv4/netfilter/nf_nat_h323.c                          | 12 ++++++------
 net/ipv4/tcp_output.c                                     | 13 +++++++++++--
 net/ipv6/netfilter/ip6t_SYNPROXY.c                        |  2 ++
 net/ipv6/netfilter/ip6t_rpfilter.c                        |  8 ++++++--
 net/mac80211/cfg.c                                        |  8 ++++++--
 net/mac80211/driver-ops.c                                 | 13 +++++++++----
 net/netfilter/Kconfig                                     |  6 ++----
 net/netfilter/ipvs/ip_vs_nfct.c                           |  2 +-
 net/netfilter/nf_conntrack_amanda.c                       |  2 +-
 net/netfilter/nf_conntrack_broadcast.c                    |  2 +-
 net/netfilter/nf_conntrack_core.c                         |  4 +---
 net/netfilter/nf_conntrack_expect.c                       | 26 +++++++++++++++++++-------
 net/netfilter/nf_conntrack_ftp.c                          |  2 +-
 net/netfilter/nf_conntrack_h323_asn1.c                    |  5 ++---
 net/netfilter/nf_conntrack_h323_main.c                    | 18 +++++++++---------
 net/netfilter/nf_conntrack_irc.c                          |  2 +-
 net/netfilter/nf_conntrack_netlink.c                      |  4 ++--
 net/netfilter/nf_conntrack_pptp.c                         |  4 ++--
 net/netfilter/nf_conntrack_proto_gre.c                    |  2 --
 net/netfilter/nf_conntrack_proto_icmp.c                   |  2 +-
 net/netfilter/nf_conntrack_proto_tcp.c                    |  8 +++++---
 net/netfilter/nf_conntrack_sane.c                         |  2 +-
 net/netfilter/nf_conntrack_sip.c                          | 10 +++++++---
 net/netfilter/nf_conntrack_tftp.c                         |  2 +-
 net/netfilter/nf_nat_amanda.c                             |  2 +-
 net/netfilter/nf_nat_core.c                               |  2 +-
 net/netfilter/nf_nat_ftp.c                                |  2 +-
 net/netfilter/nf_nat_irc.c                                |  2 +-
 net/netfilter/nf_nat_sip.c                                |  8 +++++---
 net/netfilter/nf_nat_tftp.c                               |  2 +-
 net/netfilter/nf_synproxy_core.c                          |  8 ++++----
 net/netfilter/nf_tables_api.c                             |  4 +++-
 net/netfilter/nf_tables_offload.c                         |  5 +++--
 net/netfilter/nfnetlink.c                                 |  2 +-
 net/netfilter/nft_chain_filter.c                          |  2 +-
 net/netfilter/nft_chain_nat.c                             |  3 +++
 net/netfilter/nft_ct.c                                    |  2 +-
 net/netfilter/nft_hash.c                                  |  2 +-
 net/netfilter/nft_meta.c                                  |  2 +-
 net/netfilter/nft_redir.c                                 |  2 +-
 net/netfilter/nft_synproxy.c                              |  2 ++
 net/openvswitch/flow.c                                    |  8 ++++----
 net/openvswitch/flow.h                                    |  4 ++--
 net/openvswitch/flow_table.c                              |  8 ++++----
 net/sched/cls_api.c                                       | 16 +++++++++++-----
 net/sched/cls_bpf.c                                       |  2 +-
 net/sched/cls_flower.c                                    |  2 +-
 net/sched/cls_matchall.c                                  |  2 +-
 net/sched/cls_u32.c                                       |  6 +++---
 net/tipc/topsrv.c                                         |  2 +-
 92 files changed, 323 insertions(+), 236 deletions(-)
