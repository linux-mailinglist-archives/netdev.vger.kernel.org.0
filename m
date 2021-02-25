Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8A93255CD
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 19:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhBYStO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 13:49:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhBYStJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 13:49:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9233E64EFA;
        Thu, 25 Feb 2021 18:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614278908;
        bh=4UebTgRLi77SnAeLjgffrb31OrNc1IqCeOWcPmWIwNw=;
        h=From:To:Cc:Subject:Date:From;
        b=buM6bp7psz169tu7rI7xNajrkvlpxGG8nFaTJpHn72WsJkkoq1O4Zkny31KNU8Zfd
         KPu2fDOwPsdqNvbmeM3G0/KxcsSyjfr8tivbqT4OWZiVVPspvk+HFLDkD3jQpr7L1i
         5EC18TFZaZPt1L1jBkotv6DmWg1rKhoiPHr2sAutGYgMZlGoLv7joyJk8gVHXfjYwG
         f6V8bbNC/19kpGN55EwRJ1b9KpTiEj5E7dPWau12xqOUyYtGJAykZTswj7hSpkdSK3
         fvPL1+uf09s7yWgI0cqyJmQvj0vluuU//j+Lze3qXcUrpIX9HMAUxoHEps3NgI5I0w
         LyU2E7vqciVSg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.12-rc1
Date:   Thu, 25 Feb 2021 10:48:26 -0800
Message-Id: <20210225184826.2269264-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit d310ec03a34e92a77302edb804f7d68ee4f01ba0:

  Merge tag 'perf-core-2021-02-17' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2021-02-21 12:49:32 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.12-rc1

for you to fetch changes up to 6cf739131a15e4177e58a1b4f2bede9d5da78552:

  r8169: fix jumbo packet handling on RTL8168e (2021-02-25 09:55:16 -0800)

----------------------------------------------------------------
Networking fixes for 5.12-rc1. Rather small batch this time.

Current release - regressions:

 - bcm63xx_enet: fix sporadic kernel panic due to queue length
                 mis-accounting

Current release - new code bugs:

 - bcm4908_enet: fix RX path possible mem leak

 - bcm4908_enet: fix NAPI poll returned value

 - stmmac: fix missing spin_lock_init in visconti_eth_dwmac_probe()

 - sched: cls_flower: validate ct_state for invalid and reply flags

Previous releases - regressions:

 - net: introduce CAN specific pointer in the struct net_device to
        prevent mis-interpreting memory

 - phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8081

 - psample: fix netlink skb length with tunnel info

Previous releases - always broken:

 - icmp: pass zeroed opts from icmp{,v6}_ndo_send before sending

 - wireguard: device: do not generate ICMP for non-IP packets

 - mptcp: provide subflow aware release function to avoid a mem leak

 - hsr: add support for EntryForgetTime

 - r8169: fix jumbo packet handling on RTL8168e

 - octeontx2-af: fix an off by one in rvu_dbg_qsize_write()

 - i40e: fix flow for IPv6 next header (extension header)

 - phy: icplus: call phy_restore_page() when phy_select_page() fails

 - dpaa_eth: fix the access method for the dpaa_napi_portal

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Antonio Quartulli (1):
      wireguard: avoid double unlikely() notation when using IS_ERR()

Brett Creeley (2):
      ice: Set trusted VF as default VSI when setting allmulti on
      ice: Account for port VLAN in VF max packet size calculation

Camelia Groza (1):
      dpaa_eth: fix the access method for the dpaa_napi_portal

Chris Mi (1):
      net: psample: Fix netlink skb length with tunnel info

Christian Melki (1):
      net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8081

Chuhong Yuan (1):
      net/mlx4_core: Add missed mlx4_free_cmd_mailbox()

DENG Qingfang (1):
      net: ag71xx: remove unnecessary MTU reservation

Dan Carpenter (2):
      octeontx2-af: Fix an off by one in rvu_dbg_qsize_write()
      net: phy: icplus: call phy_restore_page() when phy_select_page() fails

Dave Ertman (2):
      ice: report correct max number of TCs
      ice: Fix state bits on LLDP mode switch

Florian Fainelli (3):
      net: dsa: Fix dependencies with HSR
      net: dsa: bcm_sf2: Wire-up br_flags_pre, br_flags and set_mrouter
      net: dsa: b53: Support setting learning on port

Florian Westphal (1):
      mptcp: provide subflow aware release function

Geert Uytterhoeven (1):
      net: dsa: sja1105: Remove unneeded cast in sja1105_crc32()

Hayes Wang (4):
      r8152: enable U1/U2 for USB_SPEED_SUPER
      r8152: check if the pointer of the function exists
      r8152: replace netif_err with dev_err
      r8152: spilt rtl_set_eee_plus and r8153b_green_en

Heiner Kallweit (1):
      r8169: fix jumbo packet handling on RTL8168e

Henry Tieman (1):
      ice: update the number of available RSS queues

Jakub Kicinski (6):
      Merge branch 'mptcp-a-bunch-of-fixes'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'net-dsa-learning-fixes-for-b53-bcm_sf2'
      Merge branch 'r8152-minor-adjustments'
      Merge branch 'wireguard-fixes-for-5-12-rc1'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue

Jann Horn (1):
      wireguard: socket: remove bogus __be32 annotation

Jason A. Donenfeld (6):
      net: icmp: pass zeroed opts from icmp{,v6}_ndo_send before sending
      wireguard: selftests: test multiple parallel streams
      wireguard: peer: put frequently used members above cache lines
      wireguard: device: do not generate ICMP for non-IP packets
      wireguard: queueing: get rid of per-peer ring buffers
      wireguard: kconfig: use arm chacha even with no neon

Keita Suzuki (1):
      i40e: Fix memory leak in i40e_probe

Krzysztof Halasa (1):
      Marvell Sky2 Ethernet adapter: fix warning messages.

Lech Perczak (1):
      net: usb: qmi_wwan: support ZTE P685M modem

Marco Wenzel (1):
      net: hsr: add support for EntryForgetTime

Mateusz Palczewski (4):
      i40e: Add zero-initialization of AQ command structures
      i40e: Fix overwriting flow control settings during driver loading
      i40e: Fix addition of RX filters after enabling FW LLDP agent
      i40e: Fix add TC filter for IPv6

Norbert Ciosek (1):
      i40e: Fix endianness conversions

Oleksij Rempel (1):
      net: introduce CAN specific pointer in the struct net_device

Paolo Abeni (3):
      mptcp: fix DATA_FIN processing for orphaned sockets
      mptcp: fix DATA_FIN generation on early shutdown
      mptcp: do not wakeup listener for MPJ subflows

Rafał Miłecki (2):
      net: broadcom: bcm4908_enet: fix RX path possible mem leak
      net: broadcom: bcm4908_enet: fix NAPI poll returned value

Sieng Piaw Liew (1):
      bcm63xx_enet: fix sporadic kernel panic

Slawomir Laba (1):
      i40e: Fix flow for IPv6 next header (extension header)

Song, Yoong Siang (1):
      net: stmmac: fix CBS idleslope and sendslope calculation

Stefan Chulski (1):
      net: mvpp2: skip RSS configurations on loopback port

Sukadev Bhattiprolu (1):
      ibmvnic: fix a race between open and reset

Sylwester Dziedziuch (1):
      i40e: Fix VFs not created

Taehee Yoo (1):
      vxlan: move debug check after netdev unregister

Takeshi Misawa (1):
      net: qrtr: Fix memory leak in qrtr_tun_open

Wei Yongjun (1):
      net: stmmac: Fix missing spin_lock_init in visconti_eth_dwmac_probe()

wenxu (1):
      net/sched: cls_flower: validate ct_state for invalid and reply flags

 drivers/net/Kconfig                                |  2 +-
 drivers/net/can/dev/dev.c                          |  4 +-
 drivers/net/can/slcan.c                            |  4 +-
 drivers/net/can/vcan.c                             |  2 +-
 drivers/net/can/vxcan.c                            |  6 +-
 drivers/net/dsa/b53/b53_common.c                   | 39 +++++++---
 drivers/net/dsa/b53/b53_priv.h                     |  8 ++
 drivers/net/dsa/b53/b53_regs.h                     |  1 +
 drivers/net/dsa/bcm_sf2.c                          | 18 +----
 drivers/net/dsa/sja1105/sja1105_static_config.c    |  2 +-
 drivers/net/ethernet/atheros/ag71xx.c              |  4 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |  3 +
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |  8 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 | 63 ++++++++++++++--
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     | 16 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 64 ++++++----------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        | 11 ++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  2 +-
 drivers/net/ethernet/intel/ice/ice.h               |  2 -
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c        |  6 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       | 34 +++++++--
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   | 35 ++++++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    | 25 ++++---
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  2 +-
 drivers/net/ethernet/marvell/sky2.c                |  5 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  1 +
 drivers/net/ethernet/realtek/r8169_main.c          |  4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-visconti.c   |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    | 30 +++++++-
 drivers/net/gtp.c                                  |  1 -
 drivers/net/phy/icplus.c                           |  9 ++-
 drivers/net/phy/micrel.c                           |  1 +
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/net/usb/r8152.c                            | 67 +++++++++++------
 drivers/net/vxlan.c                                | 11 ++-
 drivers/net/wireguard/device.c                     | 21 +++---
 drivers/net/wireguard/device.h                     | 15 ++--
 drivers/net/wireguard/peer.c                       | 28 +++----
 drivers/net/wireguard/peer.h                       |  8 +-
 drivers/net/wireguard/queueing.c                   | 86 +++++++++++++++++-----
 drivers/net/wireguard/queueing.h                   | 45 ++++++++---
 drivers/net/wireguard/receive.c                    | 16 ++--
 drivers/net/wireguard/send.c                       | 31 +++-----
 drivers/net/wireguard/socket.c                     |  8 +-
 include/linux/can/can-ml.h                         | 12 +++
 include/linux/icmpv6.h                             | 26 +++++--
 include/linux/ipv6.h                               |  1 -
 include/linux/netdevice.h                          | 34 ++++++++-
 include/net/icmp.h                                 |  6 +-
 net/can/af_can.c                                   | 34 +--------
 net/can/j1939/main.c                               | 22 ++----
 net/can/j1939/socket.c                             | 13 +---
 net/can/proc.c                                     | 19 +++--
 net/dsa/Kconfig                                    |  1 +
 net/hsr/hsr_framereg.c                             |  9 ++-
 net/hsr/hsr_framereg.h                             |  1 +
 net/hsr/hsr_main.h                                 |  1 +
 net/ipv4/icmp.c                                    |  5 +-
 net/ipv6/icmp.c                                    | 18 ++---
 net/ipv6/ip6_icmp.c                                | 12 +--
 net/mptcp/options.c                                | 23 +++---
 net/mptcp/protocol.c                               | 64 ++++++++++++++--
 net/mptcp/subflow.c                                |  6 ++
 net/psample/psample.c                              |  4 +-
 net/qrtr/tun.c                                     | 12 ++-
 net/sched/cls_flower.c                             | 15 ++++
 tools/testing/selftests/wireguard/netns.sh         | 15 +++-
 68 files changed, 734 insertions(+), 371 deletions(-)
