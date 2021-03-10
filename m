Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09800334764
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhCJTET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233713AbhCJTDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:03:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0DA564F9F;
        Wed, 10 Mar 2021 19:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403033;
        bh=gXP8fqrwmuoJZ8StPMD/bAH+C87Nm40JGzAL18TqZew=;
        h=From:To:Cc:Subject:Date:From;
        b=PVknQUbUl0x4gRcTW6+EBJLSTOZdV0R1q+JHetnDZLSOuSg0PEQJg3itZifZizt3B
         vS1aoQGW7m5khoo1cZE+gY8Jz3JaG1Rb5XNAszinG/mgsFWbXZOOI20mJIfa3FrfZM
         ydAi1uTfWr0yfkCN7/cKUMtZtVOVt01IbUKvBbmbFS+bdsWycUbsBnc2m/Pawg+Afh
         qJjaZ9v33pUbV+Fsc796fR7A4umVhFiW2+kbsKfzwrFHJHXBq8sbEBClAiwkihvPK4
         1Lzy47Do6BE6RKrzOVthXXxp2RvfpnuIB9c3i5pBWfPnCcKrtweiK/dqDjxDgNiYmx
         2pYcfgI/8rg/A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/18] mlx5 fixes 2021-03-10
Date:   Wed, 10 Mar 2021 11:03:24 -0800
Message-Id: <20210310190342.238957-1-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub

This series introduces some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 05a59d79793d482f628a31753c671f2e92178a21:

  Merge git://git.kernel.org:/pub/scm/linux/kernel/git/netdev/net (2021-03-09 17:15:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-03-10

for you to fetch changes up to 84076c4c800d1be77199a139d65b8b136a61422e:

  net/mlx5: DR, Fix potential shift wrapping of 32-bit value in STEv1 getter (2021-03-10 11:01:59 -0800)

----------------------------------------------------------------
mlx5-fixes-2021-03-10

----------------------------------------------------------------
Aya Levin (3):
      net/mlx5e: Accumulate port PTP TX stats with other channels stats
      net/mlx5e: Set PTP channel pointer explicitly to NULL
      net/mlx5: Fix turn-off PPS command

Maor Dickman (2):
      net/mlx5e: Don't match on Geneve options in case option masks are all zero
      net/mlx5: Disable VF tunnel TX offload if ignore_flow_level isn't supported

Maor Gottlieb (2):
      net/mlx5: Set QP timestamp mode to default
      RDMA/mlx5: Fix timestamp default mode

Maxim Mikityanskiy (2):
      net/mlx5e: When changing XDP program without reset, take refs for XSK RQs
      net/mlx5e: Revert parameters on errors when changing PTP state without reset

Parav Pandit (2):
      net/mlx5e: E-switch, Fix rate calculation division
      net/mlx5: SF, Correct vhca context size

Roi Dayan (2):
      net/mlx5e: Check correct ip_version in decapsulation route resolution
      net/mlx5e: Fix error flow in change profile

Shay Drory (2):
      net/mlx5: SF: Fix memory leak of work item
      net/mlx5: SF: Fix error flow of SFs allocation flow

Tariq Toukan (2):
      net/mlx5e: Enforce minimum value check for ICOSQ size
      net/mlx5e: RX, Mind the MPWQE gaps when calculating offsets

Yevgeny Kliteynik (1):
      net/mlx5: DR, Fix potential shift wrapping of 32-bit value in STEv1 getter

 drivers/infiniband/hw/mlx5/qp.c                    | 18 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  7 ++-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  8 +--
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  3 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c |  4 ++
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 69 ++++++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  1 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  3 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |  1 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  8 +--
 .../net/ethernet/mellanox/mlx5/core/sf/hw_table.c  |  2 +-
 .../mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h    |  2 +-
 .../ethernet/mellanox/mlx5/core/sf/vhca_event.c    |  1 +
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  1 +
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |  4 +-
 include/linux/mlx5/qp.h                            |  7 +++
 20 files changed, 106 insertions(+), 49 deletions(-)
