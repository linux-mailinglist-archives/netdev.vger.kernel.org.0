Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDA92EECC7
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbhAHFBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbhAHFBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:01:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3EF422E02;
        Fri,  8 Jan 2021 05:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610082060;
        bh=HLPaLeCEI4sxDBFYu6cnAzuboe0pGZsbflELOBXBOgA=;
        h=From:To:Cc:Subject:Date:From;
        b=NhFlvfLW9Aa7cVkp2DT7fT7xwIZ2hQGchfIzaH1PmuOy70PTOXIpSX7Qo5Ms+vqYR
         YKxy8IPnIrArxT+skrqHwGFkmva2oapRi8BMsj5TxwabJfcyI1NX1ZliesPcpk7g22
         EbOsEAc/BKmothfm37I6fJfojC1fSfZx3742JaSIhriZfOHvx+D4a8gGjHjPfxyzW9
         8L+69e1VStnS93HY+PrjGx8Cs466oK/6/SBSUZ8nCqdKXdlHAaHQetchvgj7VIdOST
         w0Bden+tpSqY7z3onCvMPmX3EPwNJpkIk4TMDG9pBcntWsmnjLeuzCOE0z63Pnnrrm
         x1InwHIgBFd8A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.11-rc3
Date:   Thu,  7 Jan 2021 21:00:59 -0800
Message-Id: <20210108050059.1254762-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Slightly lighter PR to get back into the Thu cadence.
The HighMem fixes not here yet, but I didn't think they
were urgent so no point delaying.

The following changes since commit f6e7a024bfe5e11d91ccff46bb576e3fb5a516ea:

  Merge tag 'arc-5.11-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc (2021-01-05 12:46:27 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.11-rc3-2

for you to fetch changes up to 220efcf9caf755bdf92892afd37484cb6859e0d2:

  Merge tag 'mlx5-fixes-2021-01-07' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2021-01-07 19:13:30 -0800)

----------------------------------------------------------------
Networking fixes for 5.11-rc3 (part 2), including fixes from bpf and
can trees.

Current release - always broken:

 - can: mcp251xfd: fix Tx/Rx ring buffer driver race conditions

 - dsa: hellcreek: fix led_classdev build errors

Previous releases - regressions:

 - ipv6: fib: flush exceptions when purging route to avoid netdev
              reference leak

 - ip_tunnels: fix pmtu check in nopmtudisc mode

 - ip: always refragment ip defragmented packets to avoid MTU issues
       when forwarding through tunnels, correct "packet too big"
       message is prohibitively tricky to generate

 - s390/qeth: fix locking for discipline setup / removal and during
              recovery to prevent both deadlocks and races

 - mlx5: Use port_num 1 instead of 0 when delete a RoCE address

Previous releases - always broken:

 - cdc_ncm: correct overhead calculation in delayed_ndp_size to prevent
            out of bound accesses with Huawei 909s-120 LTE module

 - stmmac: dwmac-sun8i: fix suspend/resume:
           - PHY being left powered off
           - MAC syscon configuration being reset
           - reference to the reset controller being improperly dropped

 - qrtr: fix null-ptr-deref in qrtr_ns_remove

 - can: tcan4x5x: fix bittiming const, use common bittiming from m_can
                  driver

 - mlx5e: CT: Use per flow counter when CT flow accounting is enabled

 - mlx5e: Fix SWP offsets when vlan inserted by driver

Misc:

 - bpf: Fix a task_iter bug caused by a bpf -> net merge conflict
        resolution

And the usual many fixes to various error paths.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Alaa Hleihel (1):
      net/mlx5: E-Switch, fix changing vf VLANID

Alan Maguire (1):
      bpftool: Fix compilation failure for net.o with older glibc

Aleksander Jan Bajkowski (1):
      net: dsa: lantiq_gswip: Exclude RMII from modes that report 1 GbE

Arnd Bergmann (7):
      qed: select CONFIG_CRC32
      phy: dp83640: select CONFIG_CRC32
      can: kvaser_pciefd: select CONFIG_CRC32
      wil6210: select CONFIG_CRC32
      cfg80211: select CONFIG_CRC32
      misdn: dsp: select CONFIG_BITREVERSE
      wan: ds26522: select CONFIG_BITREVERSE

Aya Levin (2):
      net/mlx5e: Add missing capability check for uplink follow
      net/mlx5e: ethtool, Fix restriction of autoneg with 56G

Ayush Sawal (7):
      chtls: Fix hardware tid leak
      chtls: Remove invalid set_tcb call
      chtls: Fix panic when route to peer not configured
      chtls: Avoid unnecessary freeing of oreq pointer
      chtls: Replace skb_dequeue with skb_peek
      chtls: Added a check to avoid NULL pointer dereference
      chtls: Fix chtls resources release sequence

Christophe JAILLET (1):
      net/sonic: Fix some resource leaks in error handling paths

Colin Ian King (1):
      octeontx2-af: fix memory leak of lmac and lmac->name

David S. Miller (2):
      Merge branch 'stmmac-fixes'
      Merge branch 'hns3-fixes'

Dinghao Liu (2):
      net/mlx5e: Fix two double free cases
      net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups

Florian Westphal (3):
      selftests: netfilter: add selftest for ipip pmtu discovery with enabled connection tracking
      net: fix pmtu check in nopmtudisc mode
      net: ip: always refragment ip defragmented packets

Ido Schimmel (3):
      nexthop: Fix off-by-one error in error path
      nexthop: Unlink nexthop group entry in error path
      selftests: fib_nexthops: Fix wrong mausezahn invocation

Jakub Kicinski (11):
      net: suggest L2 discards be counted towards rx_dropped
      net: vlan: avoid leaks on register_vlan_dev() failures
      docs: net: fix documentation on .ndo_get_stats
      net: bareudp: add missing error handling for bareudp_link_config()
      Merge tag 'linux-can-fixes-for-5.11-20210107' of git://git.kernel.org/.../mkl/linux-can
      Merge branch 'net-fix-netfilter-defrag-ip-tunnel-pmtu-blackhole'
      Merge https://git.kernel.org/.../bpf/bpf
      Merge branch 'bug-fixes-for-chtls-driver'
      Merge branch 'nexthop-various-fixes'
      Merge branch 's390-qeth-fixes-2021-01-07'
      Merge tag 'mlx5-fixes-2021-01-07' of git://git.kernel.org/.../saeed/linux

Jian Shen (1):
      net: hns3: fix incorrect handling of sctp6 rss tuple

Jiang Wang (1):
      selftests/bpf: Fix a compile error for BPF_F_BPRM_SECUREEXEC

Jiri Olsa (1):
      tools/resolve_btfids: Warn when having multiple IDs for single type

Jouni K. Seppänen (1):
      net: cdc_ncm: correct overhead in delayed_ndp_size

Julian Wiedmann (3):
      s390/qeth: fix deadlock during recovery
      s390/qeth: fix locking for discipline setup / removal
      s390/qeth: fix L2 header access in qeth_l3_osa_features_check()

Lad Prabhakar (1):
      can: rcar: Kconfig: update help description for CAN_RCAR config

Leon Romanovsky (1):
      net/mlx5: Release devlink object if adev fails

Lukas Bulwahn (1):
      docs: octeontx2: tune rst markup

Maor Dickman (1):
      net/mlx5e: In skb build skip setting mark in switchdev mode

Marc Kleine-Budde (4):
      can: m_can: m_can_class_unregister(): remove erroneous m_can_clk_stop()
      can: tcan4x5x: fix bittiming const, use common bittiming from m_can driver
      can: mcp251xfd: mcp251xfd_handle_tefif(): fix TEF vs. TX race condition
      can: mcp251xfd: mcp251xfd_handle_rxif_ring(): first increment RX tail pointer in HW, then in driver

Marek Behún (1):
      net: mvneta: fix error message when MTU too large for XDP

Mark Zhang (2):
      net/mlx5: Check if lag is supported before creating one
      net/mlx5: Use port_num 1 instead of 0 when delete a RoCE address

Michael Ellerman (1):
      net: ethernet: fs_enet: Add missing MODULE_LICENSE

Moshe Shemesh (1):
      net/mlx5e: Fix SWP offsets when vlan inserted by driver

Oz Shlomo (1):
      net/mlx5e: CT: Use per flow counter when CT flow accounting is enabled

Petr Machata (1):
      nexthop: Bounce NHA_GATEWAY in FDB nexthop groups

Po-Hsu Lin (1):
      selftests: fix the return value for UDP GRO test

Qinglang Miao (1):
      net: qrtr: fix null-ptr-deref in qrtr_ns_remove

Randy Dunlap (2):
      net: dsa: fix led_classdev build errors
      ptp: ptp_ines: prevent build when HAS_IOMEM is not set

Samuel Holland (4):
      net: stmmac: dwmac-sun8i: Fix probe error handling
      net: stmmac: dwmac-sun8i: Balance internal PHY resource references
      net: stmmac: dwmac-sun8i: Balance internal PHY power
      net: stmmac: dwmac-sun8i: Balance syscon (de)initialization

Sean Tranchetti (2):
      net: ipv6: fib: flush exceptions when purging route
      tools: selftests: add test for changing routes with PTMU exceptions

Sriram Dash (1):
      MAINTAINERS: Update MCAN MMIO device driver maintainer

Yonghong Song (1):
      bpf: Fix a task_iter bug caused by a merge conflict resolution

Yonglong Liu (1):
      net: hns3: fix a phy loopback fail issue

Yufeng Mo (1):
      net: hns3: fix the number of queues actually used by ARQ

 .../device_drivers/ethernet/marvell/octeontx2.rst  |  62 ++++---
 Documentation/networking/netdevices.rst            |   4 +-
 MAINTAINERS                                        |   2 +-
 drivers/isdn/mISDN/Kconfig                         |   1 +
 drivers/net/bareudp.c                              |  22 ++-
 drivers/net/can/Kconfig                            |   1 +
 drivers/net/can/m_can/m_can.c                      |   2 -
 drivers/net/can/m_can/tcan4x5x.c                   |  26 ---
 drivers/net/can/rcar/Kconfig                       |   4 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  17 +-
 drivers/net/dsa/hirschmann/Kconfig                 |   1 +
 drivers/net/dsa/lantiq_gswip.c                     |   7 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |  71 +++----
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |   1 +
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c   |   1 +
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   4 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   9 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   9 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   2 +
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  14 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  77 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   9 +
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  24 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   9 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |  27 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |   2 +-
 drivers/net/ethernet/natsemi/macsonic.c            |  12 +-
 drivers/net/ethernet/natsemi/xtsonic.c             |   7 +-
 drivers/net/ethernet/qlogic/Kconfig                |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  | 129 ++++++++-----
 drivers/net/usb/cdc_ncm.c                          |   8 +-
 drivers/net/wan/Kconfig                            |   1 +
 drivers/net/wireless/ath/wil6210/Kconfig           |   1 +
 drivers/ptp/Kconfig                                |   2 +
 drivers/s390/net/qeth_core.h                       |   3 +-
 drivers/s390/net/qeth_core_main.c                  |  38 ++--
 drivers/s390/net/qeth_l2_main.c                    |   2 +-
 drivers/s390/net/qeth_l3_main.c                    |   4 +-
 include/linux/mlx5/mlx5_ifc.h                      |   3 +-
 include/uapi/linux/if_link.h                       |   5 +-
 kernel/bpf/task_iter.c                             |   1 +
 net/8021q/vlan.c                                   |   3 +-
 net/ipv4/ip_output.c                               |   2 +-
 net/ipv4/ip_tunnel.c                               |  11 +-
 net/ipv4/nexthop.c                                 |   6 +-
 net/ipv6/ip6_fib.c                                 |   5 +-
 net/qrtr/ns.c                                      |   7 +-
 net/qrtr/qrtr.c                                    |  16 +-
 net/qrtr/qrtr.h                                    |   2 +-
 net/wireless/Kconfig                               |   1 +
 tools/bpf/bpftool/net.c                            |   1 -
 tools/bpf/resolve_btfids/main.c                    |  17 +-
 tools/testing/selftests/bpf/progs/bprm_opts.c      |   2 +-
 tools/testing/selftests/net/fib_nexthops.sh        |   2 +-
 tools/testing/selftests/net/pmtu.sh                |  71 ++++++-
 tools/testing/selftests/net/udpgro.sh              |  34 ++++
 tools/testing/selftests/netfilter/Makefile         |   3 +-
 .../selftests/netfilter/ipip-conntrack-mtu.sh      | 206 +++++++++++++++++++++
 66 files changed, 746 insertions(+), 309 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/ipip-conntrack-mtu.sh
