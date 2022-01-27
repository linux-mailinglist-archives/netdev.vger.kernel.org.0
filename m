Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D5C49EA7D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 19:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbiA0Sp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 13:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiA0Sp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 13:45:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C000CC061714;
        Thu, 27 Jan 2022 10:45:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 11A3FCE2338;
        Thu, 27 Jan 2022 18:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A161C340E4;
        Thu, 27 Jan 2022 18:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643309124;
        bh=GhmHDooZR4wNADnRbTFgoF7zudOLU69gk8IqsyVJk3s=;
        h=From:To:Cc:Subject:Date:From;
        b=amnSMxkQEciHb00nX0iAQGuJocPRM2J8QSRdfsrxZX8Ac37iHRMzM/LtAOD3RnKNB
         Gn60XCXQcZGMl1XvUvb2SblYBZpp+cibpZhq+hb5ZUYF2nN9YSoIAPV9qrwdg7jJNw
         VXDGE0UY2zDohTUUhu1kQ7CnasUB3FzVXxVVsWRlM9midMC3bY8AEISXqyTKQtg1n8
         r4BBBBD301yow2FljlLILJEyY3cMYiYwDQ5+PASVM941G7xIVXZlEJJB2fOGhnDSrR
         O4vUi1/QyTD4odgNy3+5B3bimLe1GqaGIkO/bJFsY0Yjp+VcEq2QxoibvtbZoXV0z2
         Dze48VDtf0m+Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.17-rc2
Date:   Thu, 27 Jan 2022 10:45:19 -0800
Message-Id: <20220127184519.2269399-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit fa2e1ba3e9e39072fa7a6a9d11ac432c505b4ac7:

  Merge tag 'net-5.17-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-01-20 10:57:05 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.17-rc2

for you to fetch changes up to fd20d9738395cf8e27d0a17eba34169699fccdff:

  net: bridge: vlan: fix memory leak in __allowed_ingress (2022-01-27 09:01:25 -0800)

----------------------------------------------------------------
Networking fixes for 5.17-rc2, including fixes from netfilter and can.

Current release - new code bugs:

 - tcp: add a missing sk_defer_free_flush() in tcp_splice_read()

 - tcp: add a stub for sk_defer_free_flush(), fix CONFIG_INET=n

 - nf_tables: set last expression in register tracking area

 - nft_connlimit: fix memleak if nf_ct_netns_get() fails

 - mptcp: fix removing ids bitmap setting

 - bonding: use rcu_dereference_rtnl when getting active slave

 - fix three cases of sleep in atomic context in drivers: lan966x, gve

 - handful of build fixes for esoteric drivers after netdev->dev_addr
   was made const

Previous releases - regressions:

 - revert "ipv6: Honor all IPv6 PIO Valid Lifetime values", it broke
   Linux compatibility with USGv6 tests

 - procfs: show net device bound packet types

 - ipv4: fix ip option filtering for locally generated fragments

 - phy: broadcom: hook up soft_reset for BCM54616S

Previous releases - always broken:

 - ipv4: raw: lock the socket in raw_bind()

 - ipv4: decrease the use of shared IPID generator to decrease the
   chance of attackers guessing the values

 - procfs: fix cross-netns information leakage in /proc/net/ptype

 - ethtool: fix link extended state for big endian

 - bridge: vlan: fix single net device option dumping

 - ping: fix the sk_bound_dev_if match in ping_lookup

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Catherine Sullivan (1):
      gve: Fix GFP flags when allocing pages

Christophe JAILLET (1):
      net: atlantic: Use the bitmap API instead of hand-writing it

Congyu Liu (1):
      net: fix information leakage in /proc/net/ptype

David Howells (1):
      rxrpc: Adjust retransmission backoff

David S. Miller (7):
      Merge branch 'stmmac-fixes'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'wireless-2022-01-21' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless
      Merge branch 'octeontx2-af-fixes'
      Merge branch 'dev_addr-const-fixes'
      Merge branch 'lan966x-fixes'
      Merge branch 'stmmac-ptp-fix'

Eric Dumazet (6):
      tcp: add a missing sk_defer_free_flush() in tcp_splice_read()
      ipv6: annotate accesses to fn->fn_sernum
      ipv4: raw: lock the socket in raw_bind()
      ipv4: tcp: send zero IPID in SYNACK messages
      ipv4: avoid using shared IP generator for connected sockets
      ipv4: remove sparse error in ip_neigh_gw4()

Florian Westphal (2):
      netfilter: nf_conntrack_netbios_ns: fix helper module alias
      netfilter: conntrack: don't increment invalid counter on NF_REPEAT

Gal Pressman (1):
      tcp: Add a stub for sk_defer_free_flush()

Geetha sowjanya (5):
      octeontx2-af: Retry until RVU block reset complete
      octeontx2-af: cn10k: Use appropriate register for LMAC enable
      octeontx2-pf: cn10k: Ensure valid pointers are freed to aura
      octeontx2-af: Increase link credit restore polling timeout
      octeontx2-af: cn10k: Do not enable RPM loopback for LPC interfaces

Geliang Tang (1):
      mptcp: fix removing ids bitmap setting

Guillaume Nault (1):
      Revert "ipv6: Honor all IPv6 PIO Valid Lifetime values"

Hangbin Liu (1):
      bonding: use rcu_dereference_rtnl when get bonding active slave

Hangyu Hua (1):
      yam: fix a memory leak in yam_siocdevprivate()

Horatiu Vultur (2):
      net: lan966x: Fix sleep in atomic context when injecting frames
      net: lan966x: Fix sleep in atomic context when updating MAC table

Ido Schimmel (1):
      ipv6_tunnel: Rate limit warning messages

Jakub Kicinski (15):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge branch 'mptcp-a-few-fixes'
      ipv4: fix ip option filtering for locally generated fragments
      Merge tag 'linux-can-fixes-for-5.17-20220124' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      net: fec_mpc52xx: don't discard const from netdev->dev_addr
      ethernet: 3com/typhoon: don't write directly to netdev->dev_addr
      ethernet: tundra: don't write directly to netdev->dev_addr
      ethernet: broadcom/sb1250-mac: don't write directly to netdev->dev_addr
      ethernet: i825xx: don't write directly to netdev->dev_addr
      ethernet: 8390/etherh: don't write directly to netdev->dev_addr
      ethernet: seeq/ether3: don't write directly to netdev->dev_addr
      Merge branch 'pid-introduce-helper-task_is_in_root_ns'
      MAINTAINERS: add more files to eth PHY
      MAINTAINERS: add missing IPv4/IPv6 header paths
      Merge branch 'ipv4-less-uses-of-shared-ip-generator'

Jedrzej Jagielski (2):
      i40e: Increase delay to 1 s after global EMP reset
      i40e: Fix issue when maximum queues is exceeded

Jianguo Wu (1):
      net-procfs: show net devices bound packet types

Jisheng Zhang (3):
      net: stmmac: remove unused members in struct stmmac_priv
      net: stmmac: reduce unnecessary wakeups from eee sw timer
      net: stmmac: dwmac-sun8i: use return val of readl_poll_timeout()

Joe Damato (1):
      i40e: fix unsigned stat widths

Justin Iurman (1):
      selftests: net: ioam: expect support for Queue depth data

Kalle Valo (2):
      MAINTAINERS: add common wireless and wireless-next trees
      MAINTAINERS: remove extra wireless section

Karen Sornek (1):
      i40e: Fix for failed to init adminq while VF reset

Kees Cook (1):
      mptcp: Use struct_group() to avoid cross-field memset()

Kiran Kumar K (1):
      octeontx2-af: Add KPU changes to parse NGIO as separate layer

Leo Yan (2):
      pid: Introduce helper task_is_in_init_pid_ns()
      connector/cn_proc: Use task_is_in_init_pid_ns()

Marc Kleine-Budde (5):
      mailmap: update email address of Brian Silverman
      dt-bindings: can: tcan4x5x: fix mram-cfg RX FIFO config
      can: m_can: m_can_fifo_{read,write}: don't read or write from/to FIFO if length is 0
      can: tcan4x5x: regmap: fix max register value
      can: flexcan: mark RX via mailboxes as supported on MCF5441X

Marek Behún (2):
      phylib: fix potential use-after-free
      net: sfp: ignore disabled SFP node

Maxim Mikityanskiy (1):
      sch_htb: Fail on unsupported parameters when offload is requested

Menglong Dong (1):
      net: socket: rename SKB_DROP_REASON_SOCKET_FILTER

Mohammad Athari Bin Ismail (2):
      net: stmmac: configure PTP clock source prior to PTP initialization
      net: stmmac: skip only stmmac_ptp_register when resume from suspend

Moshe Tal (1):
      ethtool: Fix link extended state for big endian

Nikolay Aleksandrov (1):
      net: bridge: vlan: fix single net device option dumping

Pablo Neira Ayuso (3):
      netfilter: nf_tables: remove unused variable
      netfilter: nf_tables: set last expression in register tracking area
      netfilter: nft_connlimit: memleak if nf_ct_netns_get() fails

Paolo Abeni (2):
      mptcp: fix msk traversal in mptcp_nl_cmd_set_flags()
      selftests: mptcp: fix ipv6 routing setup

Robert Hancock (1):
      net: phy: broadcom: hook up soft_reset for BCM54616S

Subbaraya Sundeep (2):
      octeontx2-af: Do not fixup all VF action entries
      octeontx2-pf: Forward error codes to VF

Sukadev Bhattiprolu (4):
      ibmvnic: Allow extra failures before disabling
      ibmvnic: init ->running_cap_crqs early
      ibmvnic: don't spin in tasklet
      ibmvnic: remove unused ->wait_capability

Sunil Goutham (1):
      octeontx2-af: Fix LBK backpressure id count

Sylwester Dziedziuch (1):
      i40e: Fix queues reservation for XDP

Thomas Bogendoerfer (1):
      amd: declance: use eth_hw_addr_set()

Tim Yi (1):
      net: bridge: vlan: fix memory leak in __allowed_ingress

Toke Høiland-Jørgensen (1):
      net: cpsw: Properly initialise struct page_pool_params

Victor Nogueira (1):
      net: sched: Clarify error message when qdisc kind is unknown

Wen Gu (1):
      net/smc: Transitional solution for clcsock race issue

Xin Long (1):
      ping: fix the sk_bound_dev_if match in ping_lookup

Yufeng Mo (1):
      net: hns3: handle empty unknown interrupt for VF

Yuji Ishikawa (2):
      net: stmmac: dwmac-visconti: Fix bit definitions for ETHER_CLK_SEL
      net: stmmac: dwmac-visconti: Fix clock configuration for RMII mode

 .mailmap                                           |   1 +
 .../devicetree/bindings/net/can/tcan4x5x.txt       |   2 +-
 MAINTAINERS                                        |  32 ++--
 drivers/connector/cn_proc.c                        |   2 +-
 drivers/net/bonding/bond_main.c                    |   4 -
 drivers/net/can/flexcan/flexcan-core.c             |   1 +
 drivers/net/can/flexcan/flexcan.h                  |   2 +-
 drivers/net/can/m_can/m_can.c                      |   6 +
 drivers/net/can/m_can/tcan4x5x-regmap.c            |   2 +-
 drivers/net/ethernet/3com/typhoon.c                |   6 +-
 drivers/net/ethernet/8390/etherh.c                 |   6 +-
 drivers/net/ethernet/amd/declance.c                |   4 +-
 .../net/ethernet/aquantia/atlantic/aq_filters.c    |   6 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c         |   4 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |  12 +-
 drivers/net/ethernet/google/gve/gve.h              |   2 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   6 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |   3 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |   2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   3 +-
 drivers/net/ethernet/i825xx/ether1.c               |   4 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 | 167 ++++++++++++---------
 drivers/net/ethernet/ibm/ibmvnic.h                 |   1 -
 drivers/net/ethernet/intel/i40e/i40e.h             |   9 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  44 +++---
 drivers/net/ethernet/intel/i40e/i40e_register.h    |   3 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 103 ++++++++++++-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   2 +
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |   3 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   1 +
 .../ethernet/marvell/octeontx2/af/npc_profile.h    |  70 ++++-----
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |  66 ++++++--
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |   4 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   7 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  14 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  20 +--
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  22 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  20 ++-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   7 +-
 .../net/ethernet/microchip/lan966x/lan966x_mac.c   |  11 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   6 +-
 drivers/net/ethernet/seeq/ether3.c                 |   4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-visconti.c   |  42 ++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   2 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  36 ++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   3 -
 drivers/net/ethernet/ti/cpsw_priv.c                |   2 +-
 drivers/net/ethernet/tundra/tsi108_eth.c           |  35 ++---
 drivers/net/hamradio/yam.c                         |   4 +-
 drivers/net/phy/broadcom.c                         |   1 +
 drivers/net/phy/phy_device.c                       |   6 +-
 drivers/net/phy/sfp-bus.c                          |   5 +
 include/linux/ethtool.h                            |   2 +-
 include/linux/netdevice.h                          |   1 +
 include/linux/pid_namespace.h                      |   5 +
 include/linux/skbuff.h                             |   2 +-
 include/net/addrconf.h                             |   2 +
 include/net/bonding.h                              |   2 +-
 include/net/ip.h                                   |  21 ++-
 include/net/ip6_fib.h                              |   2 +-
 include/net/route.h                                |   2 +-
 include/net/tcp.h                                  |   4 +
 include/trace/events/skb.h                         |   2 +-
 net/bridge/br_vlan.c                               |   9 +-
 net/core/net-procfs.c                              |  38 ++++-
 net/ipv4/ip_output.c                               |  26 +++-
 net/ipv4/ping.c                                    |   3 +-
 net/ipv4/raw.c                                     |   5 +-
 net/ipv4/tcp.c                                     |   1 +
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv6/addrconf.c                                |  27 +++-
 net/ipv6/ip6_fib.c                                 |  23 +--
 net/ipv6/ip6_tunnel.c                              |   8 +-
 net/ipv6/route.c                                   |   2 +-
 net/mptcp/pm_netlink.c                             |  39 +++--
 net/mptcp/protocol.h                               |   6 +-
 net/netfilter/nf_conntrack_core.c                  |   8 +-
 net/netfilter/nf_conntrack_netbios_ns.c            |   5 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nft_connlimit.c                      |  11 +-
 net/packet/af_packet.c                             |   2 +
 net/rxrpc/call_event.c                             |   8 +-
 net/rxrpc/output.c                                 |   2 +-
 net/sched/sch_api.c                                |   2 +-
 net/sched/sch_htb.c                                |  20 +++
 net/smc/af_smc.c                                   |  63 ++++++--
 tools/testing/selftests/net/ioam6_parser.c         |   5 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   5 +-
 94 files changed, 811 insertions(+), 397 deletions(-)
