Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406B93DE459
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbhHCC3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233197AbhHCC3I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BA5F6056B;
        Tue,  3 Aug 2021 02:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957738;
        bh=f7M1ny3Ljiorm1cDs65yb6ckOMxL+TVmvhy0uMqLoxs=;
        h=From:To:Cc:Subject:Date:From;
        b=bekwURy8vRuI5YfmBur/tLNbZB/3jangRG8jbUPwQXQe2iB8Za4z9jijvH1gebcMj
         JdOWAPrSsP6jbotNknmELV06AvTfC5QPSSccuC3ZVR6XG9EJvFd6V6ehBVYNji9/sh
         WW6Ch2JkoNRGT0yHGTaSgBgQFxrESNxBB4abF+IFFcn8nL+4Ez2CnJ3AazrIP5AHIU
         UOw5WGnhl5ZIRqYlnwrGJ7oK/lTaWeVdTq6aT/b/jq6CwTNkZoFhP9grBemrvIfCA4
         NtI1OFRgidXIV1wkpCn8226S0eaU6mBAYhoWLFkkSZ2j3q0t0TXO3eYwGtdlH1sf/l
         7l9X/tpOs39tA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/16] mlx5 updates 2021-08-02
Date:   Mon,  2 Aug 2021 19:28:37 -0700
Message-Id: <20210803022853.106973-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave/Jakub,

This series adds misc cleanup and some refactroing to mlx5e driver,
needed for upcoming submissions.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 1187c8c4642d109037202b43a5054adaef78b760:

  net: phy: mscc: make some arrays static const, makes object smaller (2021-08-02 09:15:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-08-02

for you to fetch changes up to bcd68c04c7692416206414dc8971730aa140eba7:

  net/mlx5: Fix missing return value in mlx5_devlink_eswitch_inline_mode_set() (2021-08-02 19:26:29 -0700)

----------------------------------------------------------------
mlx5-updates-2021-08-02

This patch-set changes the TTC (Traffic Type Classification) logic
to be independent from the mlx5 ethernet driver by renaming the traffic
types enums and making the TTC API generic to the mlx5 core driver.

It allows to decouple TTC logic from mlx5e and reused by other parts
of mlx5 drivers, namely ADQ and lag TX steering hashing.

Patches overview:
1 - Rename traffic type enums to be mlx5 generic.
2 - Rename related TTC arguments and functions.
3 - Remove dependency in the mlx5e driver from the TTC implementation.
4 - Move TTC logic to fs_ttc.
5 - Embed struct mlx5_ttc_table in fs_ttc.

The refactoring series is followed by misc' cleanup patches.

----------------------------------------------------------------
Jiapeng Chong (1):
      net/mlx5: Fix missing return value in mlx5_devlink_eswitch_inline_mode_set()

Maor Gottlieb (5):
      net/mlx5e: Rename traffic type enums
      net/mlx5e: Rename some related TTC args and functions
      net/mlx5e: Decouple TTC logic from mlx5e
      net/mlx5: Move TTC logic to fs_ttc
      net/mlx5: Embed mlx5_ttc_table

Maxim Mikityanskiy (4):
      net/mlx5e: Use a new initializer to build uniform indir table
      net/mlx5e: Introduce mlx5e_channels API to get RQNs
      net/mlx5e: Hide all implementation details of mlx5e_rx_res
      net/mlx5e: Allocate the array of channels according to the real max_nch

Roi Dayan (6):
      net/mlx5e: Remove redundant tc act includes
      net/mlx5e: Remove redundant filter_dev arg from parse_tc_fdb_actions()
      net/mlx5e: Remove redundant cap check for flow counter
      net/mlx5e: Remove redundant parse_attr arg
      net/mlx5e: Remove redundant assignment of counter to null
      net/mlx5e: Return -EOPNOTSUPP if more relevant when parsing tc actions

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  20 +-
 .../net/ethernet/mellanox/mlx5/core/en/channels.c  |  46 ++
 .../net/ethernet/mellanox/mlx5/core/en/channels.h  |  16 +
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  84 +--
 .../mellanox/mlx5/core/en/fs_tt_redirect.c         |  30 +-
 .../mellanox/mlx5/core/en/fs_tt_redirect.h         |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.c   |   9 +
 drivers/net/ethernet/mellanox/mlx5/core/en/rqt.h   |   3 +
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    | 782 ++++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.h    |  76 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  56 --
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.h |   4 -
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |  12 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  13 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |  24 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  69 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    | 677 +++---------------
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |  55 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 507 +------------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  66 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  86 +--
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   5 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  55 +-
 .../net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c   | 602 ++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h   |  70 ++
 include/linux/mlx5/fs.h                            |   2 +
 30 files changed, 1852 insertions(+), 1535 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/channels.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/channels.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h
