Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF713107728
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 19:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfKVSRx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Nov 2019 13:17:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38608 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfKVSRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 13:17:53 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4446415285FEB;
        Fri, 22 Nov 2019 10:17:52 -0800 (PST)
Date:   Fri, 22 Nov 2019 10:17:51 -0800 (PST)
Message-Id: <20191122.101751.1677491851513930094.davem@davemloft.net>
To:     torvalds@linux-foundation.org
CC:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Nov 2019 10:17:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1) Validate tunnel options length in act_tunnel_key, from Xin Long.

2) Fix DMA sync bug in gve driver, from Adi Suresh.

3) TSO kills performance on some r8169 chips due to HW issues, disable
   by default in that case, from Corinna Vinschen.

4) Fix clock disable mismatch in fec driver, from Chubong Yuan.

5) Fix interrupt status bits define in hns3 driver, from Huazhong Tan.

6) Fix workqueue deadlocks in qeth driver, from Julian Wiedmann.

7) Don't napi_disable() twice in r8152 driver, from Hayes Wang.

8) Fix SKB extension memory leak, from Florian Westphal.

Please pull, thanks a lot!

The following changes since commit 1d4c79ed324ad780cfc3ad38364ba1fd585dd2a8:

  Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 (2019-11-16 18:14:32 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git 

for you to fetch changes up to 5b1d9c17a3e0c16e1c9adf9c8a89f2735cb6dff8:

  r8152: avoid to call napi_disable twice (2019-11-22 10:07:44 -0800)

----------------------------------------------------------------
Adi Suresh (1):
      gve: fix dma sync bug where not all pages synced

Aditya Pakki (1):
      net: atm: Reduce the severity of logging in unlink_clip_vcc

Alex Vesker (3):
      net/mlx5: DR, Fix invalid EQ vector number on CQ creation
      net/mlx5: DR, Skip rehash for tables with byte mask zero
      net/mlx5: DR, Limit STE hash table enlarge based on bytemask

Chuhong Yuan (2):
      phy: mdio-sun4i: add missed regulator_disable in remove
      net: fec: fix clock count mis-match

Corinna Vinschen (1):
      r8169: disable TSO on a single version of RTL8168c to fix performance

Dan Carpenter (2):
      bpf, offload: Unlock on error in bpf_offload_dev_create()
      net: rtnetlink: prevent underflows in do_setvfinfo()

David S. Miller (8):
      Merge git://git.kernel.org/.../bpf/bpf
      Revert "mdio_bus: fix mdio_register_device when RESET_CONTROLLER is disabled"
      Merge branch 's390-fixes'
      Merge branch 'ibmvnic-regression'
      Merge branch 'qca_spi-fixes'
      Merge tag 'mlx5-fixes-2019-11-20' of git://git.kernel.org/.../saeed/linux
      Merge branch 'hv_netvsc-Fix-send-indirection-table-offset'
      Merge tag 'linux-can-fixes-for-5.4-20191122' of git://git.kernel.org/.../mkl/linux-can

Davide Caratti (1):
      net/sched: act_pedit: fix WARN() in the traffic path

Eli Cohen (2):
      net/mlx5e: Fix error flow cleanup in mlx5e_tc_tun_create_header_ipv4/6
      net/mlx5e: Fix ingress rate configuration for representors

Eran Ben Elisha (2):
      net/mlx5e: Do not use non-EXT link modes in EXT mode
      net/mlxfw: Verify FSM error code translation doesn't exceed array size

Eric Dumazet (1):
      net-sysfs: fix netdev_queue_add_kobject() breakage

Florian Westphal (1):
      udp: drop skb extensions before marking skb stateless

Geert Uytterhoeven (1):
      mdio_bus: Fix init if CONFIG_RESET_CONTROLLER=n

Haiyang Zhang (2):
      hv_netvsc: Fix offset usage in netvsc_send_table()
      hv_netvsc: Fix send_table offset in case of a host bug

Hangbin Liu (1):
      ipv6/route: return if there is no fib_nh_gw_family

Hayes Wang (1):
      r8152: avoid to call napi_disable twice

Huazhong Tan (1):
      net: hns3: fix a wrong reset interrupt status mask

Ivan Khoronzhuk (1):
      taprio: don't reject same mqprio settings

Jouni Hogander (1):
      net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject

Julian Wiedmann (2):
      s390/qeth: fix potential deadlock on workqueue flush
      s390/qeth: return proper errno on IO error

Juliet Kim (2):
      Revert "net/ibmvnic: Fix EOI when running in XIVE mode"
      net/ibmvnic: Ignore H_FUNCTION return from H_EOI to tolerate XIVE mode

Luigi Rizzo (1):
      net/mlx4_en: fix mlx4 ethtool -N insertion

Maciej ¯enczykowski (1):
      net-ipv6: IPV6_TRANSPARENT - check NET_RAW prior to NET_ADMIN

Maor Gottlieb (1):
      net/mlx5: Fix auto group size calculation

Marcelo Ricardo Leitner (1):
      net/ipv4: fix sysctl max for fib_multipath_hash_policy

Marek Behún (1):
      mdio_bus: fix mdio_register_device when RESET_CONTROLLER is disabled

Marina Varshaver (1):
      net/mlx5e: Add missing capability bit check for IP-in-IP

Martin Habets (1):
      sfc: Only cancel the PPS workqueue if it exists

Michael Heimpold (1):
      net: qca_spi: fix receive buffer size check

Oliver Neukum (1):
      nfc: port100: handle command failure cleanly

Pankaj Sharma (2):
      can: m_can_platform: set net_device structure as driver data
      can: m_can_platform: remove unnecessary m_can_class_resume() call

Petr Machata (1):
      mlxsw: spectrum_router: Fix determining underlay for a GRE tunnel

Prashant Malani (1):
      r8152: Re-order napi_disable in rtl8152_close

Roi Dayan (1):
      net/mlx5e: Fix set vf link state error flow

Russell King (2):
      net: phylink: update documentation on create and destroy
      net: phylink: fix link mode modification in PHY mode

Shani Shapp (1):
      net/mlx5: Update the list of the PCI supported devices

Stefan Wahren (1):
      net: qca_spi: Move reset_count to struct qcaspi

Stefano Garzarella (1):
      MAINTAINERS: Add myself as maintainer of virtio-vsock

Tariq Toukan (1):
      net/mlx4_en: Fix wrong limitation for number of TX rings

Vlad Buslov (1):
      net/mlx5e: Reorder mirrer action parsing to check for encap first

Willem de Bruijn (1):
      net/tls: enable sk_msg redirect to tls socket egress

Xin Long (1):
      net: sched: ensure opts_len <= IP_TUNNEL_OPTS_MAX in act_tunnel_key

Zhu Yanjun (1):
      MAINTAINERS: forcedeth: Change Zhu Yanjun's email address

 MAINTAINERS                                                |  3 ++-
 drivers/net/can/m_can/m_can_platform.c                     |  4 +---
 drivers/net/ethernet/freescale/fec_main.c                  | 15 +++++++++++----
 drivers/net/ethernet/google/gve/gve_tx.c                   |  9 +++++----
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                         | 11 ++++++++---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c            |  9 +++++----
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c             |  9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c        | 18 ++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c       | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c          |  5 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 31 +++++++++++++++----------------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c          | 10 ++++++----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h          |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c             |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 15 +++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 22 +---------------------
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c            |  2 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c      | 19 +------------------
 drivers/net/ethernet/qualcomm/qca_spi.c                    | 11 +++++------
 drivers/net/ethernet/qualcomm/qca_spi.h                    |  1 +
 drivers/net/ethernet/realtek/r8169_main.c                  |  7 +++++--
 drivers/net/ethernet/sfc/ptp.c                             |  3 ++-
 drivers/net/hyperv/hyperv_net.h                            |  3 ++-
 drivers/net/hyperv/netvsc.c                                | 38 ++++++++++++++++++++++++++++++--------
 drivers/net/phy/mdio-sun4i.c                               |  3 +++
 drivers/net/phy/mdio_bus.c                                 |  2 +-
 drivers/net/phy/phylink.c                                  | 29 ++++++++++++++++++++---------
 drivers/net/usb/r8152.c                                    | 30 +++++++++++++++++++++---------
 drivers/nfc/port100.c                                      |  2 +-
 drivers/s390/net/qeth_core.h                               |  1 +
 drivers/s390/net/qeth_core_main.c                          | 10 +++++-----
 drivers/s390/net/qeth_l2_main.c                            | 21 ++++++++++++++-------
 drivers/s390/net/qeth_l2_sys.c                             | 14 +++++++++++++-
 include/linux/skbuff.h                                     |  6 ++++++
 include/net/tls.h                                          |  2 ++
 kernel/bpf/offload.c                                       |  4 +++-
 net/atm/clip.c                                             |  6 +++---
 net/core/net-sysfs.c                                       | 25 ++++++++++++++-----------
 net/core/rtnetlink.c                                       | 23 ++++++++++++++++++++++-
 net/ipv4/sysctl_net_ipv4.c                                 |  2 +-
 net/ipv4/udp.c                                             | 27 ++++++++++++++++++++++-----
 net/ipv6/ipv6_sockglue.c                                   |  4 ++--
 net/ipv6/route.c                                           |  2 +-
 net/sched/act_pedit.c                                      | 12 +++++-------
 net/sched/act_tunnel_key.c                                 |  4 ++++
 net/sched/sch_taprio.c                                     | 28 ++++++++++++++++++++++++++--
 net/tls/tls_main.c                                         |  1 +
 net/tls/tls_sw.c                                           | 11 +++++++++++
 51 files changed, 357 insertions(+), 179 deletions(-)
