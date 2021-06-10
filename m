Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ADC3A214F
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhFJAYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229993AbhFJAYL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:24:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F4C76108E;
        Thu, 10 Jun 2021 00:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623284536;
        bh=NkJO/DNonbAokxHmEBD5NNuJEl8fmFJ3tjfv2QreE6Y=;
        h=From:To:Cc:Subject:Date:From;
        b=PJCB6O3fzLFi9Fw59V6il5sUML8gjtEsYraXg5+BQ9qUeLE7hSkWxMb5K+261hUvq
         1YuypOdHqrA32ruqvM2pjzznkVL4k1wibdIJSLO+9fYeTw3S4wsTCPPRy2dRJQP+x/
         VvRwaNIKxuJfa80W8BFR4EW0vSJ5bgtDxeaz3baON5jQhhAFVH6/p9sIvMv300mTkc
         bjtytQSz3ugy2zNvhwAit1ylCYpzFQ6APewTayVvSUURyOAPtanaNuU/lapjwyA4kf
         gi+xyQGejXZVW7mTnQ/Yb1CoUZ2YxC5X2nZiC/V2sURN5m7hosa9TboaahhmH7Vmez
         1aBws5s4FCbiA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/12] mlx5 fixes 2021-06-09
Date:   Wed,  9 Jun 2021 17:21:43 -0700
Message-Id: <20210610002155.196735-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub,

This series introduces some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 13c62f5371e3eb4fc3400cfa26e64ca75f888008:

  net/sched: act_ct: handle DNAT tuple collision (2021-06-09 15:34:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-06-09

for you to fetch changes up to 54e1217b90486c94b26f24dcee1ee5ef5372f832:

  net/mlx5e: Block offload of outer header csum for GRE tunnel (2021-06-09 17:20:06 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-06-09

----------------------------------------------------------------
Aya Levin (4):
      net/mlx5e: Don't update netdev RQs with PTP-RQ
      net/mlx5e: Fix select queue to consider SKBTX_HW_TSTAMP
      net/mlx5e: Block offload of outer header csum for UDP tunnels
      net/mlx5e: Block offload of outer header csum for GRE tunnel

Chris Mi (1):
      net/mlx5e: Verify dev is present in get devlink port ndo

Dima Chumak (1):
      net/mlx5e: Fix page reclaim for dead peer hairpin

Huy Nguyen (1):
      net/mlx5e: Remove dependency in IPsec initialization flows

Maor Gottlieb (2):
      net/mlx5: Consider RoCE cap before init RDMA resources
      net/mlx5: DR, Don't use SW steering when RoCE is not supported

Shay Drory (1):
      Revert "net/mlx5: Arm only EQs with EQEs"

Vlad Buslov (1):
      net/mlx5e: Fix use-after-free of encap entry in neigh update handler

Yang Li (1):
      net/mlx5e: Fix an error code in mlx5e_arfs_create_tables()

 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |  2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   | 22 +++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/rep/neigh.c | 15 ++++------
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  6 +---
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  | 33 ++++++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  3 --
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 21 ++++----------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  3 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    | 25 ++--------------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  6 ++--
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |  3 ++
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |  9 +++---
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c | 30 ++++++++++++++++----
 include/linux/mlx5/transobj.h                      |  1 +
 17 files changed, 112 insertions(+), 72 deletions(-)
