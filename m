Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFFC44424BB
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 01:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhKBAbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 20:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhKBAbv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 20:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA21160FD9;
        Tue,  2 Nov 2021 00:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635812957;
        bh=SIlMqwbmvxY0QbnRASFkDKGPhfa0ClCHR/MIfUA/r8E=;
        h=From:To:Cc:Subject:Date:From;
        b=X9/UozQ08Ij9Sj081Lce2GVXeRIF8WI3FNGHVvF5kMLYPnUczQuXr5pQr0OWX2L6Y
         R2jbQ8mS2hcZfjRHIk4HY8JpSJbKn9g8WzcLjsfHE1FRSn+X4QovFOeF/e6LW67N/a
         PxvRqbLsGhVtTLoc6H3pHYF13ckl0F89XWOxy5sExWYlwDC/w+aJD0C/PjtRX9Pdro
         tho7WWou8l9K78pHXdnwy4KuvQX1JhZ//5UvRVu1W73LmymiKmibw9ebuLlXnNvAih
         uh9NLnHItIrJ2k4ZAuDPHPIcpil0Xrgg0DyJKLS73J89Uy3bWxhKdbY6ew7T3bSoie
         TYlizCIH/9g9A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 0/7] mlx5 updates 2021-11-01
Date:   Mon,  1 Nov 2021 17:29:07 -0700
Message-Id: <20211102002914.1052888-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This small pull request includes few updates to mlx5 driver,
Mainly:
1) Support ethtool cq mode
2) Static allocation of mod header object for the common case

Please pull and let me know if there is any problem.

Thanks,
Saeed.

The following changes since commit 047304d0bfa5be2ace106974f87eec51e0832cd0:

  netdevsim: fix uninit value in nsim_drv_configure_vfs() (2021-11-01 16:29:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-11-01

for you to fetch changes up to 3ba1deb30012c7f6eee3b2719bd7144230da10bd:

  net/mlx5e: TC, Remove redundant action stack var (2021-11-01 17:25:41 -0700)

----------------------------------------------------------------
mlx5-updates-2021-11-01

Small updates for mlx5 driver:

1) Support ethtool cq mode
2) Static allocation of mod header object for the common case
3) minor code improvements

----------------------------------------------------------------
Paul Blakey (2):
      net/mlx5e: Refactor mod header management API
      net/mlx5: CT: Allow static allocation of mod headers

Roi Dayan (3):
      net/mlx5e: TC, Destroy nic flow counter if exists
      net/mlx5e: TC, Move kfree() calls after destroying all resources
      net/mlx5e: TC, Remove redundant action stack var

Saeed Mahameed (2):
      net/mlx5e: Support ethtool cq mode
      net/mlx5: Print more info on pci error handlers

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en/mod_hdr.c   |  58 +++++++
 .../net/ethernet/mellanox/mlx5/core/en/mod_hdr.h   |  26 +++
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  34 ++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  49 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 183 +++++++--------------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   5 -
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  |   5 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  51 ++++--
 12 files changed, 255 insertions(+), 176 deletions(-)
