Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB42349FF5
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhCZCyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230415AbhCZCxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:53:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C4B761A01;
        Fri, 26 Mar 2021 02:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616727228;
        bh=dpdOJa7F1OjQcYPN0Jtc32hYOnB5SaihkNxghqJToYw=;
        h=From:To:Cc:Subject:Date:From;
        b=t/PVg7cYPTwpEkBOx25VRVtGbwYwcZ5zbEhAejpW4oQN52o02j8ywiNc2xstqW3zM
         dm5VmStI6w50QuPquASoO3r3ghKygpoKOiXTraSY0Gdbc3DWuYH27IXmBKeCHPQQ89
         T23wIz/WVZbn7v7PzfcfwLfcz8n5jyPi5dyrQyhXUPX/EosTORi3gOteZT3HjParSO
         U8y7iJC/j0pJcaUgL08glXHRIwOouh3hbYeyb7wiONLmR9ki83bB3u5WcDCOhx2fkz
         WprDcN3jQowwUzCxPcKYbgkLdihy14XHJ/M5JjkztddktOFcqJwv7ztVBCs2+brP1y
         X0zlkCf1p5Dfw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next V2 00/13] mlx5 updates 2021-03-24
Date:   Thu, 25 Mar 2021 19:53:32 -0700
Message-Id: <20210326025345.456475-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave/Jakub,

This series provides update to mlx5 netdev driver, mostly refactoring.

v1->v2:
    - Remove inline keyword from static function in c file
    - Rebase on latest net-next	


For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 6c996e19949b34d7edebed4f6b0511145c036404:

  net: change netdev_unregister_timeout_secs min value to 1 (2021-03-25 17:24:06 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-03-24

for you to fetch changes up to 31a91220a27d49b138af3b67d9252494ef810a18:

  net/mlx5: Fix spelling mistakes in mlx5_core_info message (2021-03-25 19:50:16 -0700)

----------------------------------------------------------------
mlx5-updates-2021-03-24

mlx5e netdev driver updates:

1) Some cleanups from Colin, Tariq and Saeed.

2) Aya made some trivial refactoring to cleanup and generalize
 PTP and RQ (Receive Queue) creation and management.
 Mostly code decoupling and reducing dependencies between the different
 RX objects in the netdev driver.

 This is a preparation series for upcoming PTP special RQ creation which
 will allow coexistence of CQE compression (important performance feature,
 especially in Multihost systems) and HW TS PTP.

----------------------------------------------------------------
Aya Levin (8):
      net/mlx5e: Allow creating mpwqe info without channel
      net/mlx5: Add helper to set time-stamp translator on a queue
      net/mlx5e: Generalize open RQ
      net/mlx5e: Generalize RQ activation
      net/mlx5e: Generalize close RQ
      net/mlx5e: Generalize direct-TIRs and direct-RQTs API
      net/mlx5e: Generalize PTP implementation
      net/mlx5e: Cleanup PTP

Colin Ian King (1):
      net/mlx5: Fix spelling mistakes in mlx5_core_info message

Saeed Mahameed (1):
      net/mlx5e: alloc the correct size for indirection_rqt

Tariq Toukan (3):
      net/mlx5e: Pass q_counter indentifier as parameter to rq_param builders
      net/mlx5e: Move params logic into its dedicated file
      net/mlx5e: Restrict usage of mlx5e_priv in params logic functions

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  36 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    | 488 ++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  44 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  69 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  | 199 ++----
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  56 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 681 ++++-----------------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  16 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.h    |  11 +
 18 files changed, 816 insertions(+), 862 deletions(-)
