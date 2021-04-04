Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B90353667
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhDDEUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229490AbhDDEUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9422F6135C;
        Sun,  4 Apr 2021 04:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510006;
        bh=r43crAQli+Dn3sdUh/WPpn9Y8FHUdUJdw/IRp+rpUbo=;
        h=From:To:Cc:Subject:Date:From;
        b=aMUkQ8eu3xoICleVcYI1g4dw2+l2J64TuycP48FzjzrNAhT2VI8S/xlIhmJ6tk0Pq
         YQB6OHiNBGuIlLIBW4CNuIuIHPWd2tbGaeRAWXbWOepF8ZIR/M6eCn3JXUEPg1eZKF
         tmVjTmOaDBc3sDCvL301KEyhGdmsU7AOPYiYIW0LxGHvzytwqyiSIvsYBL5yq9hwUJ
         QGQ+f/tRvRZ2TQIzUJ8pg0H/k9uGxuzZzrrIMA155kNPb/wGU391Sivh/H/xEnVB9E
         6PCU/Ln8sjCVBhzNoza9SQ7aIB9YAyFeu0TQbKelOJg7tKOGrSAFSPG/H+3Gk99yFw
         ZaaY4bLkeci2Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/16] mlx5 updates 2021-04-02
Date:   Sat,  3 Apr 2021 21:19:38 -0700
Message-Id: <20210404041954.146958-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series provfides misc updates to mlx5.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit bd78980be1a68d14524c51c4b4170782fada622b:

  net: usb: ax88179_178a: initialize local variables before use (2021-04-01 16:09:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-04-02

for you to fetch changes up to 6783f0a21a3ce60e2ac9e56814afcbb01f98cc2e:

  net/mlx5e: Dynamic alloc vlan table for netdev when needed (2021-04-02 16:13:08 -0700)

----------------------------------------------------------------
mlx5-updates-2021-04-02

This series provides trivial updates and cleanup to mlx5 driver

1) Support for matching on ct_state inv and rel flag in connection tracking
2) Reject TC rules that redirect from a VF to itself
3) Parav provided some E-Switch cleanups that could be summarized to:
  3.1) Packing and Reduce structure sizes
  3.2) Dynamic allocation of rate limit tables and structures
4) Vu Makes the netdev arfs and vlan tables allocation dynamic.

----------------------------------------------------------------
Ariel Levkovich (2):
      net/mlx5: CT: Add support for matching on ct_state inv and rel flags
      net/mlx5e: Reject tc rules which redirect from a VF to itself

Parav Pandit (11):
      net/mlx5: E-Switch, cut down mlx5_vport_info structure size by 8 bytes
      net/mlx5: E-Switch, move QoS specific fields to existing qos struct
      net/mlx5: Use unsigned int for free_count
      net/mlx5: Pack mlx5_rl_entry structure
      net/mlx5: Do not hold mutex while reading table constants
      net/mlx5: Use helpers to allocate and free rl table entries
      net/mlx5: Use helper to increment, decrement rate entry refcount
      net/mlx5: Allocate rate limit table when rate is configured
      net/mlx5: Pair mutex_destory with mutex_init for rate limit table
      net/mlx5: E-Switch, cut down mlx5_vport_info structure size by 8 bytes
      net/mlx5: E-Switch, move QoS specific fields to existing qos struct

Roi Dayan (1):
      net/mlx5: Use ida_alloc_range() instead of ida_simple_alloc()

Vu Pham (2):
      net/mlx5e: Dynamic alloc arfs table for netdev when needed
      net/mlx5e: Dynamic alloc vlan table for netdev when needed

 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  46 ++-----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  26 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |  95 +++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    | 132 +++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  17 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  26 ++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  10 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c  |  10 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/rl.c       | 139 ++++++++++++++-------
 include/linux/mlx5/driver.h                        |   3 +-
 14 files changed, 323 insertions(+), 198 deletions(-)
