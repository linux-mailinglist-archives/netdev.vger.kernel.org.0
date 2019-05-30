Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4D330521
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 01:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfE3XFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 19:05:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33788 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfE3XFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 19:05:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5419014DDFEDE;
        Thu, 30 May 2019 16:05:07 -0700 (PDT)
Date:   Thu, 30 May 2019 16:05:06 -0700 (PDT)
Message-Id: <20190530.160506.886914005164704233.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 16:05:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Fix OOPS during nf_tables rule dump, from Florian Westphal.

2) Use after free in ip_vs_in, from Yue Haibing.

3) Fix various kTLS bugs (NULL deref during device removal resync,
   netdev notification ignoring, etc.)  From Jakub Kicinski.

4) Fix ipv6 redirects with VRF, from David Ahern.

5) Memory leak fix in igmpv3_del_delrec(), from Eric Dumazet.

6) Missing memory allocation failure check in ip6_ra_control(), from
   Gen Zhang.  And likewise fix ip_ra_control().

7) TX clean budget logic error in aquantia, from Igor Russkikh.

8) SKB leak in llc_build_and_send_ui_pkt(), from Eric Dumazet.

9) Double frees in mlx5, from Parav Pandit.

10) Fix lost MAC address in r8169 during PCI D3, from Heiner Kallweit.

11) Fix botched register access in mvpp2, from Antoine Tenart.

12) Use after free in napi_gro_frags(), from Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit 54dee406374ce8adb352c48e175176247cb8db7c:

  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux (2019-05-22 08:36:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net 

for you to fetch changes up to 100f6d8e09905c59be45b6316f8f369c0be1b2d8:

  net: correct zerocopy refcnt with udp MSG_MORE (2019-05-30 15:54:04 -0700)

----------------------------------------------------------------
Amit Cohen (1):
      mlxsw: spectrum: Prevent force of 56G

Andreas Oetken (1):
      hsr: fix don't prune the master node from the node_db

Andy Duan (1):
      net: fec: fix the clk mismatch in failed_reset path

Antoine Tenart (1):
      net: mvpp2: fix bad MVPP2_TXQ_SCHED_TOKEN_CNTR_REG queue value

Biao Huang (3):
      net: stmmac: update rx tail pointer register to fix rx dma hang issue.
      net: stmmac: fix csr_clk can't be zero issue
      net: stmmac: dwmac-mediatek: modify csr_clk value to fix mdio read/write fail

Claudiu Beznea (1):
      net: macb: save/restore the remaining registers and features

Claudiu Manoil (1):
      ocelot: Dont allocate another multicast list, use __dev_mc_sync

Dan Carpenter (2):
      mISDN: Fix indenting in dsp_cmx.c
      mISDN: make sure device name is NUL terminated

David Ahern (1):
      ipv6: Fix redirect with VRF

David S. Miller (13):
      Merge branch 'Documentation-tls--add-offload-documentation'
      Merge branch 'net-tls-fix-device-surprise-removal-with-offload'
      Merge branch 'bnxt_en-Bug-fixes'
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'fix-some-bugs-in-stmmac'
      Merge branch 'dpaa2-eth-Fix-smatch-warnings'
      Merge branch 'net-tls-two-fixes-for-rx_list-pre-handling'
      Merge branch 'aquantia-fixes'
      Merge branch 'net-phy-dp83867-add-some-fixes'
      Merge branch 'XDP-generic-fixes'
      Merge tag 'mlx5-fixes-2019-05-28' of git://git.kernel.org/.../saeed/linux
      Merge branch 'mlxsw-Two-small-fixes'
      Merge branch 'Fixes-for-DSA-tagging-using-802-1Q'

Dmitry Bogdanov (2):
      net: aquantia: check rx csum for all packets in LRO session
      net: aquantia: fix LRO with FCS error

Eric Dumazet (4):
      ipv4/igmp: fix another memory leak in igmpv3_del_delrec()
      ipv4/igmp: fix build error if !CONFIG_IP_MULTICAST
      llc: fix skb leak in llc_build_and_send_ui_pkt()
      net-gro: fix use-after-free read in napi_gro_frags()

Florian Fainelli (1):
      Documentation: net-sysfs: Remove duplicate PHY device documentation

Florian Westphal (7):
      netfilter: nf_tables: fix oops during rule dump
      netfilter: nat: fix udp checksum corruption
      netfilter: nf_flow_table: ignore DF bit setting
      netfilter: nft_flow_offload: set liberal tracking mode for tcp
      netfilter: nft_flow_offload: don't offload when sequence numbers need adjustment
      netfilter: nft_flow_offload: IPCB is only valid for ipv4 family
      selftests: netfilter: add flowtable test script

Gen Zhang (2):
      ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()
      ip_sockglue: Fix missing-check bug in ip_ra_control()

Heiner Kallweit (1):
      r8169: fix MAC address being lost in PCI D3

Igor Russkikh (1):
      net: aquantia: tx clean budget logic error

Ioana Ciornei (1):
      net: dsa: tag_8021q: Change order of rx_vid setup

Ioana Radulescu (3):
      dpaa2-eth: Fix potential spectre issue
      dpaa2-eth: Use PTR_ERR_OR_ZERO where appropriate
      dpaa2-eth: Make constant 64-bit long

Jagdish Motwani (1):
      netfilter: nf_queue: fix reinject verdict handling

Jakub Kicinski (11):
      Documentation: net: move device drivers docs to a submenu
      Documentation: tls: RSTify the ktls documentation
      Documentation: add TLS offload documentation
      net/tls: avoid NULL-deref on resync during device removal
      net/tls: fix state removal with feature flags off
      net/tls: don't ignore netdev notifications if no TLS features
      net/tls: fix lowat calculation if some data came from previous record
      selftests/tls: test for lowat overshoot with multiple records
      net/tls: fix no wakeup on partial reads
      selftests/tls: add test for sleeping even though there is data
      net: don't clear sock->sk early to avoid trouble in strparser

Jarod Wilson (1):
      bonding/802.3ad: fix slave link initialization transition states

Jeffrin Jose T (1):
      selftests: netfilter: missing error check when setting up veth interface

Jiri Pirko (1):
      mlxsw: spectrum_acl: Avoid warning after identical rules insertion

Jisheng Zhang (2):
      net: stmmac: fix reset gpio free missing
      net: mvneta: Fix err code path of probe

Kees Cook (1):
      net: tulip: de4x5: Drop redundant MODULE_DEVICE_TABLE()

Madalin Bucur (1):
      dpaa_eth: use only online CPU portals

Max Uvarov (4):
      net: phy: dp83867: fix speed 10 in sgmii mode
      net: phy: dp83867: increase SGMII autoneg timer duration
      net: phy: dp83867: do not call config_init twice
      net: phy: dp83867: Set up RGMII TX delay

Maxim Mikityanskiy (1):
      Validate required parameters in inet6_validate_link_af

Maxime Chevallier (3):
      net: mvpp2: cls: Fix leaked ethtool_rx_flow_rule
      net: ethtool: Document get_rxfh_context and set_rxfh_context ethtool ops
      ethtool: Check for vlan etype or vlan tci when parsing flow_rule

Michael Chan (3):
      bnxt_en: Fix aggregation buffer leak under OOM condition.
      bnxt_en: Fix possible BUG() condition when calling pci_disable_msix().
      bnxt_en: Reduce memory usage when running in kdump kernel.

Nikita Danilov (1):
      net: aquantia: tcp checksum 0xffff being handled incorrectly

Parav Pandit (3):
      net/mlx5: Avoid double free of root ns in the error flow path
      net/mlx5: Avoid double free in fs init error unwinding path
      net/mlx5: Allocate root ns memory using kzalloc to match kfree

Phil Sutter (1):
      netfilter: nft_fib: Fix existence check support

Raju Rangoju (1):
      cxgb4: offload VLAN flows regardless of VLAN ethtype

Rasmus Villemoes (1):
      net: dsa: mv88e6xxx: fix handling of upper half of STATS_TYPE_PORT

Russell King (2):
      net: phylink: ensure consistent phy interface mode
      net: phy: marvell10g: report if the PHY fails to boot firmware

Saeed Mahameed (2):
      net/mlx5: Fix error handling in mlx5_load()
      net/mlx5e: Disable rxhash when CQE compress is enabled

Sean Tranchetti (1):
      udp: Avoid post-GRO UDP checksum recalculation

Stefano Brivio (1):
      selftests: pmtu: Fix encapsulating device in pmtu_vti6_link_change_mtu

Stephen Hemminger (2):
      netvsc: unshare skb in VF rx handler
      net: core: support XDP generic on stacked devices.

Thierry Reding (1):
      net: stmmac: Do not output error on deferred probe

Vasundhara Volam (1):
      bnxt_en: Device serial number is supported only for PFs.

Vishal Kulkarni (1):
      cxgb4: Revert "cxgb4: Remove SGE_HOST_PAGE_SIZE dependency on page size"

Vlad Buslov (1):
      net: sched: don't use tc_action->order during action dump

Vladimir Oltean (1):
      net: dsa: tag_8021q: Create a stable binary format

Willem de Bruijn (1):
      net: correct zerocopy refcnt with udp MSG_MORE

Yoshihiro Shimoda (1):
      net: sh_eth: fix mdio access in sh_eth_close() for R-Car Gen2 and RZ/A1 SoCs

Young Xiao (1):
      ipv4: tcp_input: fix stack out of bounds when parsing TCP options.

YueHaibing (1):
      ipvs: Fix use-after-free in ip_vs_in

wenxu (1):
      net/mlx5e: restrict the real_dev of vlan device is the same as uplink device

 Documentation/ABI/testing/sysfs-bus-mdio                  |  29 -----
 Documentation/ABI/testing/sysfs-class-net-phydev          |  19 ++--
 Documentation/networking/device_drivers/index.rst         |  30 ++++++
 Documentation/networking/index.rst                        |  16 +--
 Documentation/networking/tls-offload-layers.svg           |   1 +
 Documentation/networking/tls-offload-reorder-bad.svg      |   1 +
 Documentation/networking/tls-offload-reorder-good.svg     |   1 +
 Documentation/networking/tls-offload.rst                  | 482 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/networking/{tls.txt => tls.rst}             |  44 +++++---
 drivers/isdn/mISDN/dsp_cmx.c                              | 427 ++++++++++++++++++++++++++++++++++++------------------------------------
 drivers/isdn/mISDN/socket.c                               |   5 +-
 drivers/net/bonding/bond_main.c                           |  15 ++-
 drivers/net/dsa/mv88e6xxx/chip.c                          |   2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c          |  51 ++++++---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c |  64 +++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                 |  30 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                 |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c         |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c             |   2 +-
 drivers/net/ethernet/cadence/macb.h                       |   7 ++
 drivers/net/ethernet/cadence/macb_main.c                  | 111 ++++++++++++++-----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c      |   5 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                |  11 ++
 drivers/net/ethernet/dec/tulip/de4x5.c                    |   1 -
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c            |   9 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c        |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c          |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h          |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c      |   3 +
 drivers/net/ethernet/freescale/fec_main.c                 |   2 +-
 drivers/net/ethernet/marvell/mvneta.c                     |   4 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c            |   3 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c           |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c         |  13 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c          |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c         |  24 ++---
 drivers/net/ethernet/mellanox/mlx5/core/main.c            |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c            |   4 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c    |  11 +-
 drivers/net/ethernet/mscc/ocelot.c                        |  43 ++------
 drivers/net/ethernet/mscc/ocelot.h                        |   4 -
 drivers/net/ethernet/realtek/r8169.c                      |   3 +
 drivers/net/ethernet/renesas/sh_eth.c                     |   4 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c   |   6 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c      |   2 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c         |   7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c         |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c     |   5 +-
 drivers/net/hyperv/netvsc_drv.c                           |   6 ++
 drivers/net/phy/dp83867.c                                 |  41 ++++++-
 drivers/net/phy/marvell10g.c                              |  13 +++
 drivers/net/phy/phylink.c                                 |  10 +-
 include/linux/ethtool.h                                   |   9 ++
 include/net/netfilter/nft_fib.h                           |   2 +-
 include/net/udp.h                                         |   9 +-
 net/core/dev.c                                            |  60 +++--------
 net/core/ethtool.c                                        |   8 +-
 net/core/skbuff.c                                         |   6 +-
 net/dsa/tag_8021q.c                                       |  79 +++++++++++---
 net/hsr/hsr_framereg.c                                    |   8 ++
 net/ipv4/af_inet.c                                        |   2 +-
 net/ipv4/igmp.c                                           |  47 +++++---
 net/ipv4/ip_output.c                                      |   4 +-
 net/ipv4/ip_sockglue.c                                    |   2 +
 net/ipv4/netfilter/nft_fib_ipv4.c                         |  23 +---
 net/ipv4/tcp_input.c                                      |   2 +
 net/ipv6/addrconf.c                                       |  57 ++++++----
 net/ipv6/ip6_output.c                                     |   4 +-
 net/ipv6/ipv6_sockglue.c                                  |   2 +
 net/ipv6/netfilter/nft_fib_ipv6.c                         |  16 +--
 net/ipv6/route.c                                          |   6 ++
 net/llc/llc_output.c                                      |   2 +
 net/netfilter/ipvs/ip_vs_core.c                           |   2 +-
 net/netfilter/nf_flow_table_ip.c                          |   3 +-
 net/netfilter/nf_nat_helper.c                             |   2 +-
 net/netfilter/nf_queue.c                                  |   1 +
 net/netfilter/nf_tables_api.c                             |  20 ++--
 net/netfilter/nft_fib.c                                   |   6 +-
 net/netfilter/nft_flow_offload.c                          |  31 ++++--
 net/sched/act_api.c                                       |   3 +-
 net/tls/tls_device.c                                      |  24 ++---
 net/tls/tls_sw.c                                          |  19 ++--
 tools/testing/selftests/net/pmtu.sh                       |  14 +--
 tools/testing/selftests/net/tls.c                         |  34 ++++++
 tools/testing/selftests/netfilter/Makefile                |   2 +-
 tools/testing/selftests/netfilter/nft_flowtable.sh        | 324 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/netfilter/nft_nat.sh              |   6 +-
 87 files changed, 1765 insertions(+), 680 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-bus-mdio
 create mode 100644 Documentation/networking/device_drivers/index.rst
 create mode 100644 Documentation/networking/tls-offload-layers.svg
 create mode 100644 Documentation/networking/tls-offload-reorder-bad.svg
 create mode 100644 Documentation/networking/tls-offload-reorder-good.svg
 create mode 100644 Documentation/networking/tls-offload.rst
 rename Documentation/networking/{tls.txt => tls.rst} (88%)
 create mode 100755 tools/testing/selftests/netfilter/nft_flowtable.sh
