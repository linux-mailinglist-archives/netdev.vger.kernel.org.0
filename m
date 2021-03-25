Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7E6348827
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhCYFEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 01:04:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhCYFEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 01:04:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CC51619BA;
        Thu, 25 Mar 2021 05:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616648682;
        bh=23PIwYx3FMl1TDgyHrlpTtrWKe8d83BLojuMcYA44e8=;
        h=From:To:Cc:Subject:Date:From;
        b=o9HWaruJKOjdtLMJ26PfNiawlYoKtrMe+aUKtmj0hLMnTraD7fsVu1qtUapifRFYI
         bW313Y7j4flKMdbdLOgmZ2SPyQao20G5AhrWrmLjjhtYWT4yuYiYc2fV02DUFG/jXi
         44iMCsCjnTjaulfkKZ7KY+/kS2vzbmAEAbKXYOkhQtyY3J7Ir59yDFmJ0oKv5ghggo
         JpNfhaOSjY0+nsST3ZjSNDI5bYCCjAYMOkB5Vmw0Rr8m8VYGkxom+tm5DZVXCpbPmM
         uu4C8qateh3mrBgjTf4lfYoZ05NrIWNWSn8QPbCSnwH1hTzOC8ucmQiORRXtA4P1AU
         ZoQXzxinGzkHQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2021-03-24
Date:   Wed, 24 Mar 2021 22:04:23 -0700
Message-Id: <20210325050438.261511-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave/Jakub,

This series provides update to mlx5 netdev driver, mostly refactoring.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 9a255a0635fedda1499635f1c324347b9600ce70:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next (2021-03-22 17:07:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-03-24

for you to fetch changes up to f926b20c0cb5b800d1d4a300d5d4270079aefaa6:

  net/mlx5: Fix spelling mistakes in mlx5_core_info message (2021-03-24 22:02:55 -0700)

----------------------------------------------------------------
mlx5-updates-2021-03-24

mlx5e netdev driver updates:

1) Some cleanups from Colin, Tariq and Saeed.

2) Yevgeny Fixes a potential shift wrapping of 32-bit value

3) Aya made some trivial refactoring to cleanup and generalize
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

Tariq Toukan (4):
      net/mlx5e: Enforce minimum value check for ICOSQ size
      net/mlx5e: Pass q_counter indentifier as parameter to rq_param builders
      net/mlx5e: Move params logic into its dedicated file
      net/mlx5e: Restrict usage of mlx5e_priv in params logic functions

Yevgeny Kliteynik (1):
      net/mlx5: DR, Fix potential shift wrapping of 32-bit value in STEv1 getter

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  36 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    | 484 ++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  44 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  69 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  | 199 ++----
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  56 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 673 ++++-----------------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  16 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.h    |  11 +
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |   4 +-
 19 files changed, 813 insertions(+), 857 deletions(-)
