Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C0A3E4DC5
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbhHIUZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232730AbhHIUZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 16:25:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C05A60F25;
        Mon,  9 Aug 2021 20:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628540731;
        bh=2I41G0pH58F/mXPn0i8CVS7mNLrtnuqoU2jXg6qHdNg=;
        h=From:To:Cc:Subject:Date:From;
        b=I+PSbUveNqDrAJwhp1g9LFO32c4xwB7x4MiulYs4q9CpmjWuxbX+0H2JpvsSIWtdN
         oMCciEDw5EG80J5s0Oz5iXzCUa3TU+XFRB3XUVOj4vCKPDZWt99bk3Qm3KI20GwHxv
         DmF/F+8mCF1Mq2R1bzc/7YiyHVaCtlgjaChAgF6QUVsQUfmXcGAHPU7riIGBUexZ5f
         mSNngVzrMKl5klYqoNEe6ctnfrt77iIWJmTt5CpRFsUPsi8NsX2NKkKFAinGzXeO6e
         3Gk4Jy+nMyG7TdXu1b8Z/y7XVTLwx9Th+nO+ooHAPkCbKDOX2eJcqHTUeVTZnfRmH7
         o/K1xZ1aa2cug==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, dledford@redhat.com,
        jgg@ziepe.ca
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: pull-request: mlx5-next 2020-08-9
Date:   Mon,  9 Aug 2021 13:25:22 -0700
Message-Id: <20210809202522.316930-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub and Jason,

This pulls mlx5-next branch which includes patches already reviewed on
net-next and rdma mailing lists.

1) mlx5 single E-Switch FDB for lag

2) IB/mlx5: Rename is_apu_thread_cq function to is_apu_cq 

3) Add DCS caps & fields support

[1] https://patchwork.kernel.org/project/netdevbpf/cover/20210803231959.26513-1-saeed@kernel.org/

[2] https://patchwork.kernel.org/project/netdevbpf/patch/0e3364dab7e0e4eea5423878b01aa42470be8d36.1626609184.git.leonro@nvidia.com/

[3] https://patchwork.kernel.org/project/netdevbpf/patch/55e1d69bef1fbfa5cf195c0bfcbe35c8019de35e.1624258894.git.leonro@nvidia.com/

We need this in net-next as multiple features are dependent on the
single FDB feature.

Please pull and let me know if there's any problem.

Thanks,
Saeed.

---
The following changes since commit e73f0f0ee7541171d89f2e2491130c7771ba58d3:

  Linux 5.14-rc1 (2021-07-11 15:07:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to 598fe77df855feeeca9dfda2ffe622ac7724e5c3:

  net/mlx5: Lag, Create shared FDB when in switchdev mode (2021-08-05 13:50:52 -0700)

----------------------------------------------------------------
Ariel Levkovich (1):
      net/mlx5: E-Switch, set flow source for send to uplink rule

Lior Nahmanson (1):
      net/mlx5: Add DCS caps & fields support

Mark Bloch (11):
      net/mlx5: Return mdev from eswitch
      net/mlx5: Lag, add initial logic for shared FDB
      RDMA/mlx5: Fill port info based on the relevant eswitch
      {net, RDMA}/mlx5: Extend send to vport rules
      RDMA/mlx5: Add shared FDB support
      net/mlx5: E-Switch, Add event callback for representors
      net/mlx5: Add send to vport rules on paired device
      net/mlx5: Lag, properly lock eswitch if needed
      net/mlx5: Lag, move lag destruction to a workqueue
      net/mlx5: E-Switch, add logic to enable shared FDB
      net/mlx5: Lag, Create shared FDB when in switchdev mode

Roi Dayan (2):
      net/mlx5e: Add an option to create a shared mapping
      net/mlx5e: Use shared mappings for restoring from metadata

Tal Gilboa (1):
      IB/mlx5: Rename is_apu_thread_cq function to is_apu_cq

 drivers/infiniband/hw/mlx5/cq.c                    |   2 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   7 +-
 drivers/infiniband/hw/mlx5/ib_rep.c                |  77 ++++-
 drivers/infiniband/hw/mlx5/main.c                  |  44 ++-
 drivers/infiniband/hw/mlx5/std_types.c             |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en/mapping.c   |  45 +++
 .../net/ethernet/mellanox/mlx5/core/en/mapping.h   |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  88 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  21 +-
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       |  16 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  36 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  38 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 383 ++++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  58 +++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      | 267 ++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/lag.h      |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   5 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   2 +
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   2 +-
 include/linux/mlx5/driver.h                        |   3 +
 include/linux/mlx5/eswitch.h                       |  16 +
 include/linux/mlx5/mlx5_ifc.h                      |  19 +-
 31 files changed, 1066 insertions(+), 109 deletions(-)
