Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE102388743
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238905AbhESGHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232402AbhESGHY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C54D760E0B;
        Wed, 19 May 2021 06:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404365;
        bh=sIe0zz12Wt5VEbsT3srXd7PQRARn/igSEt8LHrIG2Pw=;
        h=From:To:Cc:Subject:Date:From;
        b=k2gJw4zJC+7pfRA88vTPN9X0299drhv0jc9nXGBvE38NmrY31oRb76ZWzhykF9KCd
         rSZRCBHPDRrr2CrEL76x6nh7LOWy4X58Gx7gihnAFKB8YUzy6BKlxG+Go3Hzdq2zWl
         wQUq3ZElffUVQws/O4F92QB8hLArR2SgouIL6VfUcI8Htx0ZGFa02j6/JFXq+THhTE
         s4kVnawH2kkTl3+hqg67p4Kbh4Vcai+DDTflxBuU8BMxdx02ToAbw9N+6JUbvw6A7Z
         6s14TrEM5RhwiEvQ6pF+nrhIeoJcdim7v9IHs6qYrCEwo2OgNE6rMN2WKGNcAc/Uxt
         vvywfCw27rQZQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/16] mlx5 fixes 2021-05-18
Date:   Tue, 18 May 2021 23:05:07 -0700
Message-Id: <20210519060523.17875-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit c9fd37a9450b23804868d7a5b0d038b32ba466be:

  Merge branch 'hns3-fixes' (2021-05-18 13:41:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-05-18

for you to fetch changes up to e63052a5dd3ce7979bff727a8f4bb6d6b3d1317b:

  mlx5e: add add missing BH locking around napi_schdule() (2021-05-18 23:01:55 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-05-18

----------------------------------------------------------------
Ariel Levkovich (1):
      net/mlx5: Set term table as an unmanaged flow table

Aya Levin (1):
      net/mlx5e: Fix error path of updating netdev queues

Dima Chumak (3):
      net/mlx5e: Fix nullptr in add_vlan_push_action()
      net/mlx5e: Fix nullptr in mlx5e_tc_add_fdb_flow()
      net/mlx5e: Fix multipath lag activation

Eli Cohen (1):
      {net,vdpa}/mlx5: Configure interface MAC into mpfs L2 table

Jakub Kicinski (1):
      mlx5e: add add missing BH locking around napi_schdule()

Jianbo Liu (1):
      net/mlx5: Set reformat action when needed for termination rules

Leon Romanovsky (1):
      net/mlx5: Don't overwrite HCA capabilities when setting MSI-X count

Maor Gottlieb (1):
      {net, RDMA}/mlx5: Fix override of log_max_qp by other device

Parav Pandit (1):
      net/mlx5: SF, Fix show state inactive when its inactivated

Roi Dayan (3):
      net/mlx5: Fix err prints and return when creating termination table
      net/mlx5e: Fix null deref accessing lag dev
      net/mlx5e: Make sure fib dev exists in fib event

Saeed Mahameed (1):
      net/mlx5e: reset XPS on error flow if netdev isn't registered yet

Vlad Buslov (1):
      net/mlx5e: Reject mirroring on source port change encap rules

 drivers/infiniband/hw/mlx5/mr.c                    |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  |  2 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 16 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 26 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  1 +
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 61 +++++++++-------------
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |  6 +++
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c |  3 ++
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.h |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 11 ++--
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  | 22 ++++++--
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   | 18 ++++---
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  | 19 ++++++-
 include/linux/mlx5/driver.h                        | 44 ++++++++--------
 include/linux/mlx5/mpfs.h                          | 18 +++++++
 17 files changed, 168 insertions(+), 91 deletions(-)
 create mode 100644 include/linux/mlx5/mpfs.h
