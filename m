Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C52C3D83CD
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhG0XUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhG0XUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:20:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74F8B60F57;
        Tue, 27 Jul 2021 23:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627428052;
        bh=5VRRgncMF6P5oTcT3OHSfMI60RoeGtynPBhktvm32zY=;
        h=From:To:Cc:Subject:Date:From;
        b=T4YTBmwLSoAqM/sFkepsAZFIGulZ/mDKn8lioMOcjUrQA5ZfTL0mICBLIR1HDX/zj
         VScXK7lPe2Jkh3cq2ttPghMeX9mFU8FwapjrrHnn6/c22BHom4b22eGI2tOl1/GgNF
         HNCCDDPhOsZg0oCMc0x8zIis0D6ULZmlF27kckI88fD8zwB7EoOlVU0RxMCi7AGi5v
         0pWzuX1p7mQPVw2KxWmn/Bc4s/6mqax9cO8xGNpyF1tYfOmsbX/gIx3uCoN9gxcJrG
         TsRD9NOZx8DeKdMHwKndQNvF2UcYUCCzmvHVD9PwWSQhtDpEEBdj6ekYC3VBZEeMtY
         N8mn2UhrBYe9Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/12] mlx5 fixes 2021-07-27
Date:   Tue, 27 Jul 2021 16:20:38 -0700
Message-Id: <20210727232050.606896-1-saeed@kernel.org>
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
The following changes since commit 8373cd38a8888549ace7c7617163a2e826970a92:

  net: hns3: change the method of obtaining default ptp cycle (2021-07-27 20:59:32 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-07-27

for you to fetch changes up to 740452e09cf5fc489ce60831cf11abef117b5d26:

  net/mlx5: Fix mlx5_vport_tbl_attr chain from u16 to u32 (2021-07-27 16:10:06 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-07-27

----------------------------------------------------------------
Aya Levin (4):
      net/mlx5e: Consider PTP-RQ when setting RX VLAN stripping
      net/mlx5e: Fix page allocation failure for trap-RQ over SF
      net/mlx5e: Fix page allocation failure for ptp-RQ over SF
      net/mlx5: Unload device upon firmware fatal error

Chris Mi (1):
      net/mlx5: Fix mlx5_vport_tbl_attr chain from u16 to u32

Dima Chumak (1):
      net/mlx5e: Fix nullptr in mlx5e_hairpin_get_mdev()

Maor Dickman (2):
      net/mlx5e: Disable Rx ntuple offload for uplink representor
      net/mlx5: E-Switch, Set destination vport vhca id only when merged eswitch is supported

Maor Gottlieb (1):
      net/mlx5: Fix flow table chaining

Maxim Mikityanskiy (1):
      net/mlx5e: Add NETIF_F_HW_TC to hw_features when HTB offload is available

Roi Dayan (1):
      net/mlx5: E-Switch, handle devcom events only for ports on the same device

Tariq Toukan (1):
      net/mlx5e: RX, Avoid possible data corruption when relaxed ordering and LRO combined

 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  5 +--
 .../net/ethernet/mellanox/mlx5/core/en/params.c    | 11 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  7 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 38 +++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 33 +++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 10 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 10 +++---
 drivers/net/ethernet/mellanox/mlx5/core/health.c   | 12 +++++--
 10 files changed, 98 insertions(+), 32 deletions(-)
