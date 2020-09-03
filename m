Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF65025C303
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 16:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgICOmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 10:42:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45836 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729348AbgICOgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 10:36:55 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D363CB5BC2F009DC7935;
        Thu,  3 Sep 2020 22:36:44 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Sep 2020 22:36:37 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC V2 net-next 0/2] net: two updates related to UDP GSO
Date:   Thu, 3 Sep 2020 22:34:17 +0800
Message-ID: <1599143659-62176-1-git-send-email-tanhuazhong@huawei.com>
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

Changes since V1:
- updates NETIF_F_GSO_LAST suggested by Willem de Bruijn.
  and add NETIF_F_GSO_UDPV6_L4 feature for each driver who support UDP GSO in #1.
- add #2 who needs #1.

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
 30 files changed, 88 insertions(+), 47 deletions(-)

-- 
2.7.4

