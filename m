Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACE13935AA
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbhE0S6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235582AbhE0S6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:58:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A24EC610C7;
        Thu, 27 May 2021 18:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141794;
        bh=93Yr6CurfsayUp+oC5x00g+gZQxepOV0N+QcNmLE6DM=;
        h=From:To:Cc:Subject:Date:From;
        b=C53Bf8mrxn9t5btYNG6qgdxqY/NpjwfMYLSaIus9aRNLSL8vl2gsdbMpD8bD6xgqR
         30j5HU4WwpRoXoejhsg5PvUD/kEGgjxmU4bwhJKDjOiyGxLmrn2VneW1ipYXrHj9yg
         ukKc7eQqncnnBLQb6JOoRGS7XLS+YtWvDHUe1TiIeaXDg4/stnDy6lBi+UpLCyOKkJ
         v2A9Q/0uCFlmdA/vPTgB4YR85yhzwpv50bAynewUZm6EYKKT51es/ntZLr4gOLZV7O
         gVaFwZmAI/8boiLl3SesfHnpKIr79t2gJZKvI9kSJlFoteiERBsUbNEUZZTy6jCot8
         5KcTrsShxTmdw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next V2 00/15] mlx5 misc updates 2021-05-26
Date:   Thu, 27 May 2021 11:56:09 -0700
Message-Id: <20210527185624.694304-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub,

This series provides misc updates.
v1->v2:
 - Drop SF related patches, Will handle Parav's comments internally and
   will repost in a later series.
 
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 59c56342459a483d5e563ed8b5fdb77ab7622a73:

  Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2021-05-26 18:33:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-05-26

for you to fetch changes up to 8613641063617c1dfc731b403b3ee4935ef15f87:

  net/mlx5: Fix lag port remapping logic (2021-05-27 11:54:39 -0700)

----------------------------------------------------------------
mlx5-updates-2021-05-26

Misc update for mlx5 driver,

1) Clean up patches for lag and SF

2) Reserve bit 31 in steering register C1 for IPSec offload usage

3) Move steering tables pool logic into the steering core and
  increase the maximum table size to 2G entries when software steering
  is enabled.

----------------------------------------------------------------
Eli Cohen (3):
      net/mlx5: Remove unnecessary spin lock protection
      net/mlx5: Use boolean arithmetic to evaluate roce_lag
      net/mlx5: Fix lag port remapping logic

Huy Nguyen (2):
      net/mlx5e: TC: Reserved bit 31 of REG_C1 for IPsec offload
      net/mlx5e: IPsec/rep_tc: Fix rep_tc_update_skb drops IPsec packet

Paul Blakey (7):
      net/mlx5: CT: Avoid reusing modify header context for natted entries
      net/mlx5e: TC: Use bit counts for register mapping
      net/mlx5: Add case for FS_FT_NIC_TX FT in MLX5_CAP_FLOWTABLE_TYPE
      net/mlx5: Move table size calculation to steering cmd layer
      net/mlx5: Move chains ft pool to be used by all firmware steering
      net/mlx5: DR, Set max table size to 2G entries
      net/mlx5: Cap the maximum flow group size to 16M entries

Roi Dayan (1):
      net/mlx5e: CT, Remove newline from ct_dbg call

Tariq Toukan (1):
      net/mlx5e: RX, Remove unnecessary check in RX CQE compression handling

Yevgeny Kliteynik (1):
      net/mlx5: DR, Remove unused field of send_ring struct

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 58 +++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h | 23 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 86 +++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  8 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   | 29 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 40 ++++++---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/fs_ft_pool.c   | 83 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/fs_ft_pool.h   | 21 +++++
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      | 28 ++++---
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    | 94 ++--------------------
 .../mellanox/mlx5/core/steering/dr_types.h         |  1 -
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  6 +-
 include/linux/mlx5/driver.h                        |  2 +
 include/linux/mlx5/eswitch.h                       | 17 ++--
 19 files changed, 318 insertions(+), 193 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.h
