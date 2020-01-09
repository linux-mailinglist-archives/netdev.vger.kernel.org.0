Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1886135364
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 07:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgAIGzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 01:55:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgAIGzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 01:55:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B4D3B1553EF6F;
        Wed,  8 Jan 2020 22:55:49 -0800 (PST)
Date:   Wed, 08 Jan 2020 22:55:47 -0800 (PST)
Message-Id: <20200108.225547.2138089804633960284.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 22:55:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Missing netns pointer init in arp_tables, from Florian Westphal.

2) Fix normal tcp SACK being treated as D-SACK, from Pengcheng Yang.

3) Fix divide by zero in sch_cake, from Wen Yang.

4) Len passed to skb_put_padto() is wrong in qrtr code, from Carl
   Huang.

5) cmd->obj.chunk is leaked in sctp code error paths, from Xin Long.

6) cgroup bpf programs can be released out of order, fix from Roman
   Gushchin.

7) Make sure stmmac debugfs entry name is changed when device name
   changes, from Jiping Ma.

8) Fix memory leak in vlan_dev_set_egress_priority(), from Eric
   Dumazet.

9) SKB leak in lan78xx usb driver, also from Eric Dumazet.

10) Rediculous TCA_FQ_QUANTUM values configured can cause loops in fq
    packet scheduler, reject them.  From Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit 738d2902773e30939a982c8df7a7f94293659810:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2019-12-31 11:14:58 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net 

for you to fetch changes up to 9546a0b7ce0077d827470f603f2522b845ce5954:

  tipc: fix wrong connect() return code (2020-01-08 15:57:35 -0800)

----------------------------------------------------------------
Andrew Lunn (2):
      net: freescale: fec: Fix ethtool -d runtime PM
      net: dsa: mv88e6xxx: Preserve priority when setting CPU port.

Arnd Bergmann (1):
      atm: eni: fix uninitialized variable warning

Baruch Siach (1):
      net: dsa: mv88e6xxx: force cmode write on 6141/6341

Carl Huang (1):
      net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue

Chen-Yu Tsai (2):
      net: stmmac: dwmac-sunxi: Allow all RGMII modes
      net: stmmac: dwmac-sun8i: Allow all RGMII modes

Dan Murphy (2):
      can: tcan4x5x: tcan4x5x_can_probe(): turn on the power before parsing the config
      can: tcan4x5x: tcan4x5x_parse_config(): Disable the INH pin device-state GPIO is unavailable

Daniel Borkmann (1):
      bpf: Fix passing modified ctx to ld/abs/ind instruction

David S. Miller (9):
      net: Correct type of tcp_syncookies sysctl.
      Merge tag 'linux-can-fixes-for-5.5-20200102' of git://git.kernel.org/.../mkl/linux-can
      net: Update GIT url in maintainers.
      Merge branch 'atlantic-bugfixes'
      Merge tag 'mlx5-fixes-2020-01-06' of git://git.kernel.org/.../saeed/linux
      Merge git://git.kernel.org/.../bpf/bpf
      Merge branch 'vlan-rtnetlink-newlink-fixes'
      Merge branch 'net-ungraft-prio'
      Merge git://git.kernel.org/.../pablo/nf

Dmytro Linkin (1):
      net/mlx5e: Avoid duplicating rule destinations

Eli Cohen (1):
      net/mlx5e: Fix hairpin RSS table size

Eran Ben Elisha (1):
      net/mlx5e: Always print health reporter message to dmesg

Erez Shitrit (1):
      net/mlx5: DR, Init lists that are used in rule's member

Eric Dumazet (6):
      vlan: fix memory leak in vlan_dev_set_egress_priority
      vlan: vlan_changelink() should propagate errors
      net: usb: lan78xx: fix possible skb leak
      pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
      gtp: fix bad unlock balance in gtp_encap_enable_socket
      macvlan: do not assume mac_header is set in macvlan_broadcast()

Fenghua Yu (1):
      drivers/net/b44: Change to non-atomic bit operations on pwol_mask

Florian Faber (1):
      can: mscan: mscan_rx_poll(): fix rx path lockup when returning from polling to irq mode

Florian Westphal (3):
      netfilter: arp_tables: init netns pointer in xt_tgchk_param struct
      netfilter: conntrack: dccp, sctp: handle null timeout argument
      netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present

Gustavo A. R. Silva (1):
      can: tcan4x5x: tcan4x5x_parse_config(): fix inconsistent IS_ERR and PTR_ERR

Hangbin Liu (2):
      vxlan: fix tos value before xmit
      selftests: loopback.sh: skip this test if the driver does not support

Igor Russkikh (3):
      net: atlantic: broken link status on old fw
      net: atlantic: loopback configuration in improper place
      net: atlantic: remove duplicate entries

Jesper Dangaard Brouer (1):
      doc/net: Update git https URLs in netdev-FAQ documentation

Jiping Ma (1):
      stmmac: debugfs entry name is not be changed when udev rename device name.

Johan Hovold (2):
      can: kvaser_usb: fix interface sanity check
      can: gs_usb: gs_usb_probe(): use descriptors of current altsetting

Jose Abreu (1):
      net: stmmac: Fixed link does not need MDIO Bus

Krzysztof Kozlowski (3):
      MAINTAINERS: Drop obsolete entries from Samsung sxgbe ethernet driver
      net: wan: sdla: Fix cast from pointer to integer of different size
      net: ethernet: sxgbe: Rename Samsung to lowercase

Liran Alon (1):
      net: Google gve: Remove dma_wmb() before ringing doorbell

Masahiro Yamada (2):
      tipc: do not add socket.o to tipc-y twice
      tipc: remove meaningless assignment in Makefile

Michael Guralnik (1):
      net/mlx5: Move devlink registration before interfaces load

Niklas Cassel (1):
      MAINTAINERS: Remove myself as co-maintainer for qcom-ethqos

Oliver Hartkopp (1):
      can: can_dropped_invalid_skb(): ensure an initialized headroom in outgoing CAN sk_buffs

Pablo Neira Ayuso (2):
      netfilter: nf_tables: unbind callbacks from flowtable destroy path
      netfilter: flowtable: add nf_flowtable_time_stamp

Parav Pandit (1):
      Revert "net/mlx5: Support lockless FTE read lookups"

Pengcheng Yang (1):
      tcp: fix "old stuff" D-SACK causing SACK to be treated as D-SACK

Petr Machata (2):
      mlxsw: spectrum_qdisc: Ignore grafting of invisible FIFO
      net: sch_prio: When ungrafting, replace with FIFO

Roman Gushchin (1):
      bpf: cgroup: prevent out-of-order release of cgroup bpf

Russell King (1):
      net: phylink: fix failure to register on x86 systems

Sean Nyekjaer (2):
      can: tcan4x5x: tcan4x5x_can_probe(): get the device out of standby before register access
      can: tcan4x5x: tcan4x5x_parse_config(): reset device before register access

Stephen Boyd (1):
      macb: Don't unregister clks unconditionally

Tuong Lien (2):
      tipc: fix link overflow issue at socket shutdown
      tipc: fix wrong connect() return code

Vikas Gupta (1):
      firmware: tee_bnxt: Fix multiple call to tee_client_close_context

Wen Yang (1):
      sch_cake: avoid possible divide by zero in cake_enqueue()

Xin Long (1):
      sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY

Yevgeny Kliteynik (1):
      net/mlx5: DR, No need for atomic refcount for internal SW steering resources

Ying Xue (1):
      tipc: eliminate KMSAN: uninit-value in __tipc_nl_compat_dumpit error

wenxu (4):
      netfilter: nft_flow_offload: fix underflow in flowtable reference counter
      netfilter: nf_flow_table_offload: fix incorrect ethernet dst address
      netfilter: nf_flow_table_offload: check the status of dst_neigh
      netfilter: nf_flow_table_offload: fix the nat port mangle.

 Documentation/networking/ip-sysctl.txt                       |  2 +-
 Documentation/networking/netdev-FAQ.rst                      |  4 ++--
 MAINTAINERS                                                  | 13 +++++--------
 drivers/atm/eni.c                                            |  4 ++--
 drivers/firmware/broadcom/tee_bnxt_fw.c                      |  1 -
 drivers/net/can/m_can/tcan4x5x.c                             | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 drivers/net/can/mscan/mscan.c                                | 21 ++++++++++-----------
 drivers/net/can/usb/gs_usb.c                                 |  4 ++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c            |  2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c             |  2 +-
 drivers/net/dsa/mv88e6xxx/global1.c                          |  5 +++++
 drivers/net/dsa/mv88e6xxx/global1.h                          |  1 +
 drivers/net/dsa/mv88e6xxx/port.c                             | 12 ++++++------
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c              |  4 ++--
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c    |  3 ---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c |  4 +---
 drivers/net/ethernet/broadcom/b44.c                          |  9 ++++++---
 drivers/net/ethernet/cadence/macb_main.c                     |  4 +---
 drivers/net/ethernet/freescale/fec_main.c                    |  9 +++++++++
 drivers/net/ethernet/google/gve/gve_rx.c                     |  2 --
 drivers/net/ethernet/google/gve/gve_tx.c                     |  6 ------
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h              | 16 ++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c          |  7 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c              | 16 ----------------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c              | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c            | 70 +++++++++++++++-------------------------------------------------------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h            |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c               | 16 +++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c   |  5 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c    | 10 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h  | 14 ++++++++------
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c         |  7 +++++++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c              |  2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c            |  3 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c            |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c            | 32 ++++++++++++++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c        |  2 +-
 drivers/net/gtp.c                                            |  5 +++--
 drivers/net/macvlan.c                                        |  2 +-
 drivers/net/phy/phylink.c                                    |  3 +++
 drivers/net/usb/lan78xx.c                                    |  9 +++------
 drivers/net/vxlan.c                                          |  4 ++--
 drivers/net/wan/sdla.c                                       |  2 +-
 include/linux/can/dev.h                                      | 34 ++++++++++++++++++++++++++++++++++
 include/linux/if_ether.h                                     |  8 ++++++++
 include/linux/sxgbe_platform.h                               |  2 +-
 include/net/netfilter/nf_flow_table.h                        |  6 ++++++
 kernel/bpf/cgroup.c                                          | 11 +++++++++--
 kernel/bpf/verifier.c                                        |  9 +++++++--
 net/8021q/vlan.h                                             |  1 +
 net/8021q/vlan_dev.c                                         |  3 ++-
 net/8021q/vlan_netlink.c                                     | 19 ++++++++++++-------
 net/ipv4/netfilter/arp_tables.c                              | 27 ++++++++++++++++-----------
 net/ipv4/tcp_input.c                                         |  5 ++++-
 net/netfilter/ipset/ip_set_core.c                            |  3 ++-
 net/netfilter/nf_conntrack_proto_dccp.c                      |  3 +++
 net/netfilter/nf_conntrack_proto_sctp.c                      |  3 +++
 net/netfilter/nf_flow_table_core.c                           |  7 +------
 net/netfilter/nf_flow_table_ip.c                             |  4 ++--
 net/netfilter/nf_flow_table_offload.c                        | 50 ++++++++++++++++++++++++++++++++++++--------------
 net/netfilter/nf_tables_api.c                                |  8 ++++++--
 net/netfilter/nft_flow_offload.c                             |  3 ---
 net/qrtr/qrtr.c                                              |  2 +-
 net/sched/sch_cake.c                                         |  2 +-
 net/sched/sch_fq.c                                           |  6 ++++--
 net/sched/sch_prio.c                                         | 10 ++++++++--
 net/sctp/sm_sideeffect.c                                     | 28 ++++++++++++++++++----------
 net/tipc/Makefile                                            |  4 +---
 net/tipc/netlink_compat.c                                    |  4 ++--
 net/tipc/socket.c                                            | 57 ++++++++++++++++++++++++++++++++++-----------------------
 tools/testing/selftests/net/forwarding/loopback.sh           |  8 ++++++++
 71 files changed, 515 insertions(+), 275 deletions(-)
