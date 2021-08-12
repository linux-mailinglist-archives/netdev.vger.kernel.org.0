Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C523EAAD9
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbhHLTWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhHLTWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 15:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 669846103A;
        Thu, 12 Aug 2021 19:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628796135;
        bh=uOb4Wu6GPBrA2zVMI7afxJKIf2hhgzq7HRBqBPzRUlA=;
        h=From:To:Cc:Subject:Date:From;
        b=rwvLeqb4AyD9f9R28IZ6mU7CzLF3Hn22HuA4qnXwugrQB/rS0k80SyYf3TRlscROO
         FMhuVpQMgxQoo0trQFaBcEqAA9uy7bFAs2mmbgjVowoyrLC9Kd2plSJ7Er/n/U4k6b
         5KG4cbL5/XS2atUc6Fv/+0f5q6qCmQZmjynEOfv09ol7J7kFrH3J0957PNjMfFNvez
         qSLuW4W7Hdja9s8aVVv/bZOfMkSWKh6tWxwUo69IhL2o2sJeriPbFPQnOEA4Yz9gdC
         /WWqzroG0X+XzASpVkcnbi0/QveCc0BHv+yTAQBTIsmLNSPhn8jNTTSk8bpXJ8vzNV
         zEyIvWVqOLqJA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.14-rc6
Date:   Thu, 12 Aug 2021 12:22:14 -0700
Message-Id: <20210812192214.397695-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The size of the PR is pretty normal, but we got more fixes for 5.14
changes this week than last week. Nothing major but the trend is
the opposite of what we like. We'll see how the next week goes..

The following changes since commit 902e7f373fff2476b53824264c12e4e76c7ec02a:

  Merge tag 'net-5.14-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-08-05 12:26:00 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.14-rc6

for you to fetch changes up to a9a507013a6f98218d1797c8808bd9ba1e79782d:

  Merge tag 'ieee802154-for-davem-2021-08-12' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan (2021-08-12 11:50:17 -0700)

----------------------------------------------------------------
Networking fixes for 5.14-rc6, including fixes from netfilter, bpf,
can and ieee802154.

Current release - regressions:

 - r8169: fix ASPM-related link-up regressions

 - bridge: fix flags interpretation for extern learn fdb entries

 - phy: micrel: fix link detection on ksz87xx switch

 - Revert "tipc: Return the correct errno code"

 - ptp: fix possible memory leak caused by invalid cast

Current release - new code bugs:

 - bpf: add missing bpf_read_[un]lock_trace() for syscall program

 - bpf: fix potentially incorrect results with bpf_get_local_storage()

 - page_pool: mask the page->signature before the checking, avoid
      dma mapping leaks

 - netfilter: nfnetlink_hook: 5 fixes to information in netlink dumps

 - bnxt_en: fix firmware interface issues with PTP

 - mlx5: Bridge, fix ageing time

Previous releases - regressions:

 - linkwatch: fix failure to restore device state across suspend/resume

 - bareudp: fix invalid read beyond skb's linear data

Previous releases - always broken:

 - bpf: fix integer overflow involving bucket_size

 - ppp: fix issues when desired interface name is specified via netlink

 - wwan: mhi_wwan_ctrl: fix possible deadlock

 - dsa: microchip: ksz8795: fix number of VLAN related bugs

 - dsa: drivers: fix broken backpressure in .port_fdb_dump

 - dsa: qca: ar9331: make proper initial port defaults

Misc:

 - bpf: add lockdown check for probe_write_user helper

 - netfilter: conntrack: remove offload_pickup sysctl before 5.14 is out

 - netfilter: conntrack: collect all entries in one cycle,
	      heuristically slow down garbage collection scans
	      on idle systems to prevent frequent wake ups

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alex Vesker (1):
      net/mlx5: DR, Add fail on error check on decap

Andy Shevchenko (1):
      wwan: core: Avoid returning NULL from wwan_create_dev()

Anirudh Venkataramanan (2):
      ice: Prevent probing virtual functions
      ice: Stop processing VF messages during teardown

Aya Levin (2):
      net/mlx5: Block switchdev mode while devlink traps are active
      net/mlx5: Fix return value from tracer initialization

Baruch Siach (1):
      MAINTAINERS: fix Microchip CAN BUS Analyzer Tool entry typo

Ben Hutchings (8):
      net: phy: micrel: Fix link detection on ksz87xx switch"
      net: dsa: microchip: Fix ksz_read64()
      net: dsa: microchip: ksz8795: Fix PVID tag insertion
      net: dsa: microchip: ksz8795: Reject unsupported VLAN configuration
      net: dsa: microchip: ksz8795: Fix VLAN untagged flag change on deletion
      net: dsa: microchip: ksz8795: Use software untagging on CPU port
      net: dsa: microchip: ksz8795: Fix VLAN filtering
      net: dsa: microchip: ksz8795: Don't use phy_port_cnt in VLAN table lookup

Brett Creeley (1):
      ice: don't remove netdev->dev_addr from uc sync list

Chris Mi (1):
      net/mlx5e: TC, Fix error handling memory leak

DENG Qingfang (1):
      net: dsa: mt7530: add the missing RxUnicast MIB counter

Daniel Borkmann (2):
      bpf: Add _kernel suffix to internal lockdown_bpf_read
      bpf: Add lockdown check for probe_write_user helper

Daniel Xu (1):
      libbpf: Do not close un-owned FD 0 on errors

David S. Miller (9):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'r8169-RTL8106e'
      Merge branch 'bnxt_en-ptp-fixes'
      Merge branch 'smc-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'mlx5-fixes-2021-08-09' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'linux-can-fixes-for-5.14-20210810' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'ks8795-vlan-fixes'
      Merge branch 'fdb-backpressure-fixes'

Dongliang Mu (2):
      ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
      ieee802154: hwsim: fix GPF in hwsim_new_edge_nl

Eric Dumazet (2):
      net: igmp: fix data-race in igmp_ifc_timer_expire()
      net: igmp: increase size of mr_ifc_count

Florian Westphal (2):
      netfilter: conntrack: collect all entries in one cycle
      netfilter: conntrack: remove offload_pickup sysctl again

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix min eth packet size for non-switch use-cases

Guillaume Nault (1):
      bareudp: Fix invalid read beyond skb's linear data

Guvenc Gulce (1):
      net/smc: Correct smc link connection counter in case of smc client

Hangbin Liu (1):
      net: sched: act_mirred: Reset ct info when mirror/redirect skb

Hayes Wang (2):
      Revert "r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM"
      r8169: change the L0/L1 entrance latencies for RTL8106e

Hoang Le (1):
      Revert "tipc: Return the correct errno code"

Hussein Alasadi (1):
      can: m_can: m_can_set_bittiming(): fix setting M_CAN_DBTP register

Jakub Kicinski (3):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge tag 'ieee802154-for-davem-2021-08-12' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan

John Hubbard (1):
      net: mvvp2: fix short frame size on s390

Jozsef Kadlecsik (1):
      netfilter: ipset: Limit the maximal range of consecutive elements to add/delete

Karsten Graul (1):
      net/smc: fix wait on already cleared link

Kefeng Wang (1):
      once: Fix panic when module unload

Leon Romanovsky (1):
      net/mlx5: Don't skip subfunction cleanup in case of error in module init

Loic Poulain (1):
      net: wwan: mhi_wwan_ctrl: Fix possible deadlock

Longpeng(Mike) (1):
      vsock/virtio: avoid potential deadlock when vsock device remove

Mark Brown (1):
      net: mscc: Fix non-GPL export of regmap APIs

Maxim Mikityanskiy (1):
      net/mlx5e: Destroy page pool after XDP SQ to fix use-after-free

Md Fahad Iqbal Polash (1):
      iavf: Set RSS LUT and key in reset handle path

Michael Chan (3):
      bnxt_en: Update firmware interface to 1.10.2.52
      bnxt_en: Update firmware call to retrieve TX PTP timestamp
      bnxt_en: Use register window 6 instead of 5 to read the PHC

Neal Cardwell (1):
      tcp_bbr: fix u32 wrap bug in round logic if bbr_init() called after 2B packets

Nikolay Aleksandrov (1):
      net: bridge: fix flags interpretation for extern learn fdb entries

Oleksij Rempel (1):
      net: dsa: qca: ar9331: make proper initial port defaults

Pablo Neira Ayuso (5):
      netfilter: nfnetlink_hook: strip off module name from hookfn
      netfilter: nfnetlink_hook: missing chain family
      netfilter: nfnetlink_hook: use the sequence number of the request message
      netfilter: nfnetlink_hook: Use same family as request message
      netfilter: nfnetlink_hook: translate inet ingress to netdev

Pali Rohár (2):
      ppp: Fix generating ifname when empty IFLA_IFNAME is specified
      ppp: Fix generating ppp unit id when ifname is not specified

Randy Dunlap (4):
      libbpf, doc: Eliminate warnings in libbpf_naming_convention
      dccp: add do-while-0 stubs for dccp_pr_debug macros
      net: openvswitch: fix kernel-doc warnings in flow.c
      bpf, core: Fix kernel-doc notation

Robin Gögge (1):
      libbpf: Fix probe for BPF_PROG_TYPE_CGROUP_SOCKOPT

Roi Dayan (2):
      psample: Add a fwd declaration for skbuff
      net/mlx5e: Avoid creating tunnel headers for local route

Sergey Shtylyov (1):
      MAINTAINERS: switch to my OMP email for Renesas Ethernet drivers

Shay Drory (4):
      net/mlx5: Fix order of functions in mlx5_irq_detach_nb()
      net/mlx5: Set all field of mlx5_irq before inserting it to the xarray
      net/mlx5: Destroy pool->mutex
      net/mlx5: Synchronize correct IRQ when destroying CQ

Takeshi Misawa (1):
      net: Fix memory leak in ieee802154_raw_deliver

Tatsuhiko Yasumatsu (1):
      bpf: Fix integer overflow involving bucket_size

Vinicius Costa Gomes (1):
      ptp: Fix possible memory leak caused by invalid cast

Vlad Buslov (1):
      net/mlx5: Bridge, fix ageing time

Vladimir Oltean (6):
      net: dsa: hellcreek: fix broken backpressure in .port_fdb_dump
      net: dsa: lan9303: fix broken backpressure in .port_fdb_dump
      net: dsa: lantiq: fix broken backpressure in .port_fdb_dump
      net: dsa: sja1105: fix broken backpressure in .port_fdb_dump
      net: switchdev: zero-initialize struct switchdev_notifier_fdb_info emitted by drivers towards the bridge
      net: dsa: sja1105: unregister the MDIO buses during teardown

Willy Tarreau (1):
      net: linkwatch: fix failure to restore device state across suspend/resume

Wong Vee Khee (1):
      net: pcs: xpcs: fix error handling on failed to allocate memory

Yajun Deng (1):
      netfilter: nf_conntrack_bridge: Fix memory leak when error

Yang Yingliang (1):
      net: bridge: fix memleak in br_add_if()

Yonghong Song (2):
      bpf: Add missing bpf_read_[un]lock_trace() for syscall program
      bpf: Fix potentially incorrect results with bpf_get_local_storage()

Yunsheng Lin (1):
      page_pool: mask the page->signature before the checking

 .../bpf/libbpf/libbpf_naming_convention.rst        |  4 +-
 Documentation/networking/nf_conntrack-sysctl.rst   | 10 ---
 MAINTAINERS                                        |  4 +-
 drivers/infiniband/hw/mlx5/cq.c                    |  4 +-
 drivers/infiniband/hw/mlx5/devx.c                  |  3 +-
 drivers/net/bareudp.c                              | 16 +++--
 drivers/net/can/m_can/m_can.c                      |  8 +--
 drivers/net/dsa/hirschmann/hellcreek.c             |  7 +-
 drivers/net/dsa/lan9303-core.c                     | 34 +++++----
 drivers/net/dsa/lantiq_gswip.c                     | 14 ++--
 drivers/net/dsa/microchip/ksz8795.c                | 82 ++++++++++++++++++----
 drivers/net/dsa/microchip/ksz8795_reg.h            |  4 ++
 drivers/net/dsa/microchip/ksz_common.h             |  9 +--
 drivers/net/dsa/mt7530.c                           |  1 +
 drivers/net/dsa/qca/ar9331.c                       | 73 ++++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_main.c             |  5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 76 ++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      | 10 +--
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 13 ++--
 drivers/net/ethernet/intel/ice/ice.h               |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c          | 28 +++++---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  7 ++
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |  2 +-
 .../ethernet/marvell/prestera/prestera_switchdev.c |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |  1 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   | 11 ++-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 33 ++++-----
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       | 20 ++++--
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  6 +-
 .../net/ethernet/mellanox/mlx5/core/esw/sample.c   |  1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 14 +++-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h   |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 12 ++--
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  | 10 ++-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  4 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |  2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  4 +-
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |  2 +-
 .../ethernet/microchip/sparx5/sparx5_mactable.c    |  2 +-
 drivers/net/ethernet/mscc/ocelot_io.c              | 16 ++---
 drivers/net/ethernet/realtek/r8169_main.c          |  4 ++
 drivers/net/ethernet/rocker/rocker_main.c          |  2 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c         |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c      |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |  7 +-
 drivers/net/ethernet/ti/cpsw_priv.h                |  4 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c           |  2 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |  6 +-
 drivers/net/pcs/pcs-xpcs.c                         |  2 +-
 drivers/net/phy/micrel.c                           |  2 -
 drivers/net/ppp/ppp_generic.c                      | 21 ++++--
 drivers/net/wwan/mhi_wwan_ctrl.c                   | 12 ++--
 drivers/net/wwan/wwan_core.c                       | 12 ++--
 drivers/ptp/ptp_sysfs.c                            |  2 +-
 drivers/s390/net/qeth_l2_main.c                    |  4 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  3 +-
 include/linux/bpf-cgroup.h                         |  4 +-
 include/linux/inetdevice.h                         |  2 +-
 include/linux/mlx5/driver.h                        |  3 +-
 include/linux/netfilter/ipset/ip_set.h             |  3 +
 include/linux/once.h                               |  4 +-
 include/linux/security.h                           |  3 +-
 include/net/netns/conntrack.h                      |  2 -
 include/net/psample.h                              |  2 +
 include/uapi/linux/neighbour.h                     |  7 +-
 include/uapi/linux/netfilter/nfnetlink_hook.h      |  9 +++
 kernel/bpf/core.c                                  |  7 +-
 kernel/bpf/hashtab.c                               |  4 +-
 kernel/bpf/helpers.c                               |  8 +--
 kernel/trace/bpf_trace.c                           | 13 ++--
 lib/once.c                                         | 11 ++-
 net/bpf/test_run.c                                 |  4 ++
 net/bridge/br.c                                    |  3 +-
 net/bridge/br_fdb.c                                | 11 ++-
 net/bridge/br_if.c                                 |  2 +
 net/bridge/br_private.h                            |  2 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |  6 ++
 net/core/link_watch.c                              |  5 +-
 net/core/page_pool.c                               | 10 ++-
 net/dccp/dccp.h                                    |  6 +-
 net/dsa/slave.c                                    |  2 +-
 net/ieee802154/socket.c                            |  7 +-
 net/ipv4/igmp.c                                    | 21 ++++--
 net/ipv4/tcp_bbr.c                                 |  2 +-
 net/netfilter/ipset/ip_set_hash_ip.c               |  9 ++-
 net/netfilter/ipset/ip_set_hash_ipmark.c           | 10 ++-
 net/netfilter/ipset/ip_set_hash_ipport.c           |  3 +
 net/netfilter/ipset/ip_set_hash_ipportip.c         |  3 +
 net/netfilter/ipset/ip_set_hash_ipportnet.c        |  3 +
 net/netfilter/ipset/ip_set_hash_net.c              | 11 ++-
 net/netfilter/ipset/ip_set_hash_netiface.c         | 10 ++-
 net/netfilter/ipset/ip_set_hash_netnet.c           | 16 ++++-
 net/netfilter/ipset/ip_set_hash_netport.c          | 11 ++-
 net/netfilter/ipset/ip_set_hash_netportnet.c       | 16 ++++-
 net/netfilter/nf_conntrack_core.c                  | 71 ++++++-------------
 net/netfilter/nf_conntrack_proto_tcp.c             |  1 -
 net/netfilter/nf_conntrack_proto_udp.c             |  1 -
 net/netfilter/nf_conntrack_standalone.c            | 16 -----
 net/netfilter/nf_flow_table_core.c                 | 11 ++-
 net/netfilter/nfnetlink_hook.c                     | 24 +++++--
 net/openvswitch/flow.c                             | 13 ++--
 net/sched/act_mirred.c                             |  3 +
 net/smc/af_smc.c                                   |  2 +-
 net/smc/smc_core.c                                 |  4 +-
 net/smc/smc_core.h                                 |  4 ++
 net/smc/smc_llc.c                                  | 10 ++-
 net/smc/smc_tx.c                                   | 18 ++++-
 net/smc/smc_wr.c                                   | 10 +++
 net/tipc/link.c                                    |  6 +-
 net/vmw_vsock/virtio_transport.c                   |  7 +-
 security/security.c                                |  3 +-
 tools/lib/bpf/btf.c                                |  3 +-
 tools/lib/bpf/libbpf_probes.c                      |  4 +-
 118 files changed, 763 insertions(+), 372 deletions(-)
