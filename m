Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFAE252F07
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 14:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbgHZMyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 08:54:33 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44437 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729386AbgHZMy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 08:54:29 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with SMTP; 26 Aug 2020 15:54:21 +0300
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07QCsLG2003731;
        Wed, 26 Aug 2020 15:54:21 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 0/3] net_prefetch API
Date:   Wed, 26 Aug 2020 15:54:15 +0300
Message-Id: <20200826125418.11379-1-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset adds a common net API for L1 cacheline size-aware prefetch.

Patch 1 introduces the common API in net and aligns the drivers to use it.
Patches 2 and 3 add usage in mlx4 and mlx5 Eth drivers.

Series generated against net-next commit:
079f921e9f4d Merge tag 'batadv-next-for-davem-20200824' of git://git.open-mesh.org/linux-merge

Thanks,
Tariq.


Tariq Toukan (3):
  net: Take common prefetch code structure into a function
  net/mlx5e: RX, Add a prefetch command for small L1_CACHE_BYTES
  net/mlx4_en: RX, Add a prefetch command for small L1_CACHE_BYTES

 drivers/net/ethernet/chelsio/cxgb3/sge.c         |  5 +----
 drivers/net/ethernet/hisilicon/hns/hns_enet.c    |  5 +----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c  |  5 +----
 drivers/net/ethernet/intel/fm10k/fm10k_main.c    |  5 +----
 drivers/net/ethernet/intel/i40e/i40e_txrx.c      | 12 ++++--------
 drivers/net/ethernet/intel/iavf/iavf_txrx.c      | 11 +++--------
 drivers/net/ethernet/intel/ice/ice_txrx.c        | 10 ++--------
 drivers/net/ethernet/intel/igb/igb_main.c        | 10 ++--------
 drivers/net/ethernet/intel/igc/igc_main.c        | 10 ++--------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    | 11 +++--------
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c    | 11 +++--------
 drivers/net/ethernet/mellanox/mlx4/en_rx.c       |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c  |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c  | 13 ++++++-------
 .../ethernet/mellanox/mlx5/core/en_selftest.c    |  3 +--
 include/linux/netdevice.h                        | 16 ++++++++++++++++
 17 files changed, 51 insertions(+), 86 deletions(-)

-- 
2.21.0

