Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4C526AEA9
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgIOU1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbgIOU0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:00 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C280120756;
        Tue, 15 Sep 2020 20:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201554;
        bh=oz7gJT05qrnxcrkZCHSWoSt+/gbe50td2QgLTPDTRg0=;
        h=From:To:Cc:Subject:Date:From;
        b=BWpHFcaw4uDlPYd7sjSRT/c6Z8fIZB9fduZoiXNPPewQdl50PkUJ8PurAUxL8vb9T
         JU1bzj2fi6Q/soJ67vKySA/RKadIua589J/OOEJhD1DFx9STW9Pego9Jc2x4qHcc4D
         8ap7fL7/gIHbBkPnvHENkGmWA7K1m4ODYJEZ+5BI=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/16] mlx5 updates 2020-09-15
Date:   Tue, 15 Sep 2020 13:25:17 -0700
Message-Id: <20200915202533.64389-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave & Jakub,

This series adds some misc updates to mlx5 driver.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit ed6d9b0228132fee03314b276d946fc3f0cc9e4f:

  ionic: fix up debugfs after queue swap (2020-09-14 16:55:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-09-15

for you to fetch changes up to b7cf0806e8783e38f881cae3c56f0869e70b8da2:

  net/mlx5e: Add CQE compression support for multi-strides packets (2020-09-15 11:59:53 -0700)

----------------------------------------------------------------
mlx5-updates-2020-09-15

Various updates to mlx5 driver,

1) Eli adds support for TC trap action.
2) Eran, minor improvements to clock.c code structure
3) Better handling of error reporting in LAG from Jianbo
4) IPv6 traffic class (DSCP) header rewrite support from Maor
5) Ofer Levi adds support for CQE compression of multi-strides packets
6) Vu, Enables use of vport meta data by default.
7) Some minor code cleanup

----------------------------------------------------------------
Dan Carpenter (1):
      net/mlx5: remove erroneous fallthrough

Eli Cohen (1):
      net/mlx5e: Add support for tc trap

Eran Ben Elisha (4):
      net/mlx5: Always use container_of to find mdev pointer from clock struct
      net/mlx5: Rename ptp clock info
      net/mlx5: Release clock lock before scheduling a PPS work
      net/mlx5: Don't call timecounter cyc2time directly from 1PPS flow

Jianbo Liu (3):
      net/mlx5e: Return a valid errno if can't get lag device index
      net/mlx5e: Add LAG warning for unsupported tx type
      net/mlx5e: Add LAG warning if bond slave is not lag master

Maor Dickman (1):
      net/mlx5e: Add IPv6 traffic class (DSCP) header rewrite support

Moshe Tal (1):
      net/mlx5: Fix uninitialized variable warning

Ofer Levi (1):
      net/mlx5e: Add CQE compression support for multi-strides packets

Vu Pham (4):
      net/mlx5: E-Switch, Check and enable metadata support flag before using
      net/mlx5: E-Switch, Dedicated metadata for uplink vport
      net/mlx5: E-Switch, Setup all vports' metadata to support peer miss rule
      net/mlx5: E-Switch, Use vport metadata matching by default

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 12 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 11 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 11 +++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 85 +++++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      | 66 ++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/lag.h      |  7 ++
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |  9 ++-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 61 +++++++++-------
 include/linux/mlx5/device.h                        |  3 +-
 include/linux/mlx5/driver.h                        |  1 -
 13 files changed, 181 insertions(+), 89 deletions(-)
