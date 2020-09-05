Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A05725E5B1
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 08:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgIEGNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 02:13:50 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10818 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726596AbgIEGNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 02:13:49 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C86D6B3233B13E01E560;
        Sat,  5 Sep 2020 14:13:44 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Sat, 5 Sep 2020 14:13:37 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 0/2] net: two updates related to UDP GSO
Date:   Sat, 5 Sep 2020 14:11:11 +0800
Message-ID: <1599286273-26553-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two updates relates to UDP GSO.
#1 adds a new GSO type for UDPv6
#2 adds check for UDP GSO when csum is disable in netdev_fix_features().

Changes since RFC V2:
- modifies the timing of setting UDP GSO type when doing UDP GRO in #1.

Changes since RFC V1:
- updates NETIF_F_GSO_LAST suggested by Willem de Bruijn.
  and add NETIF_F_GSO_UDPV6_L4 feature for each driver who support UDP GSO in #1.
  - add #2 who needs #1.

previous version:
RFC V2: https://lore.kernel.org/netdev/1599143659-62176-1-git-send-email-tanhuazhong@huawei.com/
RFC V1: https://lore.kernel.org/netdev/1599048911-7923-1-git-send-email-tanhuazhong@huawei.com/

Huazhong Tan (2):
  udp: add a GSO type for UDPv6
  net: disable UDP GSO features when CSUM is disable

 drivers/net/bonding/bond_main.c                         |  4 +++-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c         |  3 ++-
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c   |  1 +
 .../net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c    |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c         |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c                | 17 ++++++++---------
 drivers/net/ethernet/intel/i40e/i40e_main.c             |  1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c             |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c               |  3 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.c               |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c               |  9 ++++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c           |  9 ++++++---
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c    |  2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c    |  2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c  |  2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c       |  9 ++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c         |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       | 11 +++++++----
 drivers/net/team/team.c                                 |  5 +++--
 include/linux/netdev_features.h                         |  4 +++-
 include/linux/netdevice.h                               |  1 +
 include/linux/skbuff.h                                  |  8 ++++++++
 include/linux/udp.h                                     |  4 ++--
 net/core/dev.c                                          | 12 ++++++++++++
 net/core/filter.c                                       |  6 ++----
 net/core/skbuff.c                                       |  2 +-
 net/ethtool/common.c                                    |  1 +
 net/ipv6/udp.c                                          |  2 +-
 net/ipv6/udp_offload.c                                  |  6 +++---
 31 files changed, 89 insertions(+), 48 deletions(-)

-- 
2.7.4

