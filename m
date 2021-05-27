Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7E0392672
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhE0EiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229579AbhE0EiD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:38:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D5DF61157;
        Thu, 27 May 2021 04:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622090191;
        bh=t07EOt5zij5Iqdd9FrPv6tqpXOS4AxUW3zgO5BZH8a8=;
        h=From:To:Cc:Subject:Date:From;
        b=RpFXypirFlklWzEH06jQn4ES8JNPdEa0mNZIA5u003G3bkFJoEzLEY8ZCJR9p4wzJ
         N23WAszZi0/ec3AEcBUf9KPZ1S1IhkMLBMH0EdtzJDz0bqhG3sM1Gbhmpp8NScR9+P
         ofm4PgIEQ1NbWbdBQYpapsdegGhWvTVlULMnX8nYA15Fg8l/5mQ++nF1Vqqu40xuRq
         nnume75MmMxBOsHA+PPqht4j40BwdS+VgEspqTWhzpv/ZRvW+AplijDQqxZxlv5P82
         sIB+vnMpseuE6vDqWQLcDNDA72RCixv5StwBdkWGGLd87OwIFBjaTiRWi1SgKJbT0i
         qG0Nt0+m2QXug==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/17] mlx5 misc updates 2021-05-26
Date:   Wed, 26 May 2021 21:35:52 -0700
Message-Id: <20210527043609.654854-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series provides small misc updates.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 59c56342459a483d5e563ed8b5fdb77ab7622a73:

  Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2021-05-26 18:33:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-05-26

for you to fetch changes up to 3cccb9cb9982e20a3b74cc4e32a2e6fb6ebb93db:

  net/mlx5: Improve performance in SF allocation (2021-05-26 20:48:10 -0700)

----------------------------------------------------------------
mlx5-updates-2021-05-26

Misc update for mlx5 driver,

1) Clean up patches for lag and SF, ensure SF BAR size is at least PAGE_SIZE

2) Reserve bit 31 in steering register C1 for IPSec offload usage

3) Move steering tables pool logic into the steering core and
  increase the maximum table size to 2G entries when software steering
  is enabled.

----------------------------------------------------------------
Eli Cohen (5):
      net/mlx5: Remove unnecessary spin lock protection
      net/mlx5: Use boolean arithmetic to evaluate roce_lag
      net/mlx5: Fix lag port remapping logic
      net/mlx5: Ensure SF BAR size is at least PAGE_SIZE
      net/mlx5: Improve performance in SF allocation

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
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |  3 +-
 .../net/ethernet/mellanox/mlx5/core/sf/hw_table.c  | 23 +++---
 .../mellanox/mlx5/core/steering/dr_types.h         |  1 -
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  6 +-
 include/linux/mlx5/driver.h                        |  2 +
 include/linux/mlx5/eswitch.h                       | 17 ++--
 21 files changed, 333 insertions(+), 204 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.h
