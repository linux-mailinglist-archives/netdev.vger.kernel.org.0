Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F086443A50A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhJYU45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230448AbhJYU44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:56:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 843F660EDF;
        Mon, 25 Oct 2021 20:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635195273;
        bh=0X7lXCWAW319rHEdcnRoYLKDAC5HbLND+R6QmkV9mg0=;
        h=From:To:Cc:Subject:Date:From;
        b=vKOgMuZuKTyY1kOO5PZ2vqxam1GqnTeK+Z9CnEuUwtNY+PTQJOEv6/DF44jxFRkmh
         /u5b4pzbKKw1iY5E+6xgoYyrIJjXReRvxybaos4jo8KRZ3zdY6OxIsub4MPoTMT/8/
         N0oZwiFV8snlYuOMUQ2JG7cv084UryiqOX459FbcrDGr698BxcoXQqIMr3xe7TZrBu
         wb+QXDxR/GIux4Nq4lXycGcwImEVQxfese9jF/eV0FvQ14iKEG8FQgqMtUCdrCeXP5
         2RqfxcnG4lf3SFNRN9BdJk+XoTPsTsEeDKfd4UmuOomnbXwWfASL/R0d/eRYFdpjUI
         WeEvz/6gDjR+g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/14] mlx5 updates 2021-10-25
Date:   Mon, 25 Oct 2021 13:54:17 -0700
Message-Id: <20211025205431.365080-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub,

This series provides some updates to mlx5.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit dcd63d4326802cec525de2a4775019849958125c:

  Merge branch 'bluetooth-don-t-write-directly-to-netdev-dev_addr' (2021-10-25 11:01:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-10-25

for you to fetch changes up to d67ab0a8c130be38b6dda8da3616a97f020ac424:

  net/mlx5: SF_DEV Add SF device trace points (2021-10-25 13:51:21 -0700)

----------------------------------------------------------------
mlx5-updates-2021-10-25

Misc updates for mlx5 driver:

1) Misc updates and cleanups:
 - Don't write directly to netdev->dev_addr, From Jakub Kicinski
 - Remove unnecessary checks for slow path flag in tc module
 - Fix unused function warning of mlx5i_flow_type_mask
 - Bridge, support replacing existing FDB entry

2) Sub Functions, Reduction in memory usage:
 - Reduce flow counters bulk query buffer size
 - Implement max_macs devlink parameter
 - Add devlink vendor params to control Event Queue sizes
 - Added SF life cycle trace points by Parav

3) From Aya, Firmware health buffer reporting improvements
 - Print health buffer by log level and more missing information
 - Periodic update of host time to firmware

----------------------------------------------------------------
Avihai Horon (1):
      net/mlx5: Reduce flow counters bulk query buffer size for SFs

Aya Levin (3):
      net/mlx5: Extend health buffer dump
      net/mlx5: Print health buffer by log level
      net/mlx5: Add periodic update of host time to firmware

Jakub Kicinski (1):
      net/mlx5e: don't write directly to netdev->dev_addr

Parav Pandit (2):
      net/mlx5: SF, Add SF trace points
      net/mlx5: SF_DEV Add SF device trace points

Paul Blakey (1):
      net/mlx5: Remove unnecessary checks for slow path flag

Shay Drory (4):
      net/mlx5: Fix unused function warning of mlx5i_flow_type_mask
      net/mlx5: Let user configure io_eq_size param
      net/mlx5: Let user configure event_eq_size param
      net/mlx5: Let user configure max_macs param

Vlad Buslov (2):
      net/mlx5: Bridge, extract code to lookup and del/notify entry
      net/mlx5: Bridge, support replacing existing FDB entry

 .../device_drivers/ethernet/mellanox/mlx5.rst      |  60 +++++++
 Documentation/networking/devlink/mlx5.rst          |  20 +++
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  69 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |  12 ++
 .../net/ethernet/mellanox/mlx5/core/devlink_res.c  |  80 ++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   5 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  62 ++++----
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   | 126 ++++++++++++---
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  21 +++
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  24 +++
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |  23 ++-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.h   |   1 +
 .../mlx5/core/sf/dev/diag/dev_tracepoint.h         |  58 +++++++
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |   8 +
 .../mellanox/mlx5/core/sf/diag/sf_tracepoint.h     | 173 +++++++++++++++++++++
 .../mellanox/mlx5/core/sf/diag/vhca_tracepoint.h   |  40 +++++
 .../net/ethernet/mellanox/mlx5/core/sf/hw_table.c  |   4 +
 .../ethernet/mellanox/mlx5/core/sf/vhca_event.c    |   3 +
 include/linux/mlx5/device.h                        |  14 +-
 include/linux/mlx5/driver.h                        |   6 +-
 include/linux/mlx5/eq.h                            |   1 -
 include/linux/mlx5/mlx5_ifc.h                      |  24 ++-
 27 files changed, 787 insertions(+), 93 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/devlink_res.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/diag/dev_tracepoint.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/diag/vhca_tracepoint.h
