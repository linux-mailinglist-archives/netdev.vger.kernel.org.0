Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73AE2F28BB
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391880AbhALHOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:14:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbhALHOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:14:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00D8122AAF;
        Tue, 12 Jan 2021 07:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610435623;
        bh=5Oa7WCJ6dUUjPTnFfSDfHWEPV7R/QzPmSefzMNlD+rI=;
        h=From:To:Cc:Subject:Date:From;
        b=pPZA25MScOP74Kgwn37+3pgGjWV6Jnq5cI8P1EmkIluxb9yE4vwETQMs7OAoY0q8d
         Dw8lMGfhMO6S004gU36263iHflNbTrzktbJOV2BVqKLV5xIWIdp74NwY7F5e9ltXk2
         EZmay42/STOteizJpAnicxW9tUVgdBWHv54HRcpC8tJa0H+mYTY3XLCJYaRAOLxa+Y
         ufXY5GizpuXMF8Qg5uqyzKcnf1k5aYGieMufvqtOl86Pu0/41lHpccboMMZfrE9UU6
         P9sKosHQYp4SNVlctfUtVJbXFDcmIk1xMzRRa7BsiOwxlhdoD/orjcoVPxT2ooeR0x
         I2UOmfuZ4jR4w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next V2 00/11] mlx5 updates 2021-01-07
Date:   Mon, 11 Jan 2021 23:05:23 -0800
Message-Id: <20210112070534.136841-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub

This series provides misc updates for mlx5 driver. 
v1->v2:
  - Drop the +trk+new TC feature for now until we handle the module
    dependency issue.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit c73a45965dd54a10c368191804b9de661eee1007:

  net: mvpp2: prs: improve ipv4 parse flow (2021-01-11 17:46:21 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-01-07

for you to fetch changes up to 85d1f989d2ed1462a21364e3b8f685e513dab645:

  net/mlx5e: IPsec, Remove unnecessary config flag usage (2021-01-11 23:02:28 -0800)

----------------------------------------------------------------
mlx5-updates-2021-01-07

Misc updates series for mlx5 driver:

1) From Eli and Jianbo, E-Switch cleanups and usage of new
   FW capability for mpls over udp

2) Paul Blakey, Adds support for mirroring with Connection tracking
by splitting rules to pre and post Connection tracking to perform the
mirroring.

3) Roi Dayan, cleanups for connection tracking

4) From Tariq, Cleanups and improvements to IPSec

----------------------------------------------------------------
Eli Cohen (2):
      net/mlx5e: Simplify condition on esw_vport_enable_qos()
      net/mlx5: E-Switch, use new cap as condition for mpls over udp

Jianbo Liu (1):
      net/mlx5e: E-Switch, Offload all chain 0 priorities when modify header and forward action is not supported

Paul Blakey (1):
      net/mlx5: Add HW definition of reg_c_preserve

Roi Dayan (3):
      net/mlx5e: CT: Pass null instead of zero spec
      net/mlx5e: Remove redundant initialization to null
      net/mlx5e: CT: Remove redundant usage of zone mask

Tariq Toukan (4):
      net/mlx5e: IPsec, Enclose csum logic under ipsec config
      net/mlx5e: IPsec, Avoid unreachable return
      net/mlx5e: IPsec, Inline feature_check fast-path function
      net/mlx5e: IPsec, Remove unnecessary config flag usage

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  7 ++----
 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c        |  4 +--
 .../mellanox/mlx5/core/en_accel/en_accel.h         |  4 +--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       | 14 -----------
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       | 29 ++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  4 ---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  2 --
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  6 -----
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  3 +--
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |  7 ++----
 include/linux/mlx5/mlx5_ifc.h                      |  4 ++-
 12 files changed, 40 insertions(+), 47 deletions(-)
