Return-Path: <netdev+bounces-9064-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE9472701C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 547601C20E97
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE1B3AE46;
	Wed,  7 Jun 2023 21:04:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12573735B
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 21:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0293CC433D2;
	Wed,  7 Jun 2023 21:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686171866;
	bh=K/1/pgrjREkyBoi/9yOP76KFu1M5VW85KwdlJCXueq8=;
	h=From:To:Cc:Subject:Date:From;
	b=N5WJd8BAaq8uOBLkswWxUvd9ncwXJIjs1OWrcPw9Vy2fY1wLKKa9aRPopVN3w2nuT
	 xCC4wqZ93jedqFQdTjR/g0MYn54UiLDZWbe2i3Z1qEosMDd9onvKLAxjqWl/luhwak
	 FWX80kdeW6UgOSwY+brPD6cHxAmdjiXMd1mh+RUR6Gp8lV2KRVZ/YlfuhXK8wQxCA3
	 LHJbVhLmwCAVtpYOxKCPsgy348XfOWKFyH68FdYdGXfhT7FeuF+uLfSvcapSEyc40f
	 afGKaY0ldYWsahGzXuJ5ZsIpFUmuBZf1NDUqyqhQAscMHpYaQ1Xvk0RRRptGfsPwvK
	 +ON5zCCOWiDIA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org
Subject: [pull request][net-next V2 00/14] mlx5 updates 2023-06-06
Date: Wed,  7 Jun 2023 14:03:56 -0700
Message-Id: <20230607210410.88209-1-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

v1->v2:
 - Remove "Fixes:" tags from net-next patches
 - Drop mlx5 rx page pool warning patch, Dragos will send another
   version to modify the page pool pring itself.

This series contains the following patches:

1) Support 4 ports VF LAG, part 2/2
2) Few extra trivial cleanup patches

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

The following changes since commit e06bd5e3adae14a4c0c50d74e36b064ab77601ba:

  Merge branch 'followup-fixes-for-the-dwmac-and-altera-lynx-conversion' (2023-06-07 13:30:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-06-06

for you to fetch changes up to 803ea346bd3ff1ac80fc65cf5899c0ad045d1788:

  net/mlx5e: simplify condition after napi budget handling change (2023-06-07 14:00:45 -0700)

----------------------------------------------------------------
mlx5-updates-2023-06-06

1) Support 4 ports VF LAG, part 2/2
2) Few extra trivial cleanup patches

Shay Drory Says:
================

Support 4 ports VF LAG, part 2/2

This series continues the series[1] "Support 4 ports VF LAG, part1/2".
This series adds support for 4 ports VF LAG (single FDB E-Switch).

This series of patches refactoring LAG code that make assumptions
about VF LAG supporting only two ports and then enable 4 ports VF LAG.

Patch 1:
- Fix for ib rep code
Patches 2-5:
- Refactors LAG layer.
Patches 6-7:
- Block LAG types which doesn't support 4 ports.
Patch 8:
- Enable 4 ports VF LAG.

This series specifically allows HCAs with 4 ports to create a VF LAG
with only 4 ports. It is not possible to create a VF LAG with 2 or 3
ports using HCAs that have 4 ports.

Currently, the Merged E-Switch feature only supports HCAs with 2 ports.
However, upcoming patches will introduce support for HCAs with 4 ports.

In order to activate VF LAG a user can execute:

devlink dev eswitch set pci/0000:08:00.0 mode switchdev
devlink dev eswitch set pci/0000:08:00.1 mode switchdev
devlink dev eswitch set pci/0000:08:00.2 mode switchdev
devlink dev eswitch set pci/0000:08:00.3 mode switchdev
ip link add name bond0 type bond
ip link set dev bond0 type bond mode 802.3ad
ip link set dev eth2 master bond0
ip link set dev eth3 master bond0
ip link set dev eth4 master bond0
ip link set dev eth5 master bond0

Where eth2, eth3, eth4 and eth5 are net-interfaces of pci/0000:08:00.0
pci/0000:08:00.1 pci/0000:08:00.2 pci/0000:08:00.3 respectively.

User can verify LAG state and type via debugfs:
/sys/kernel/debug/mlx5/0000\:08\:00.0/lag/state
/sys/kernel/debug/mlx5/0000\:08\:00.0/lag/type

[1]
https://lore.kernel.org/netdev/20230601060118.154015-1-saeed@kernel.org/T/#mf1d2083780970ba277bfe721554d4925f03f36d1

================

----------------------------------------------------------------
Bodong Wang (1):
      mlx5/core: E-Switch, Allocate ECPF vport if it's an eswitch manager

Jakub Kicinski (1):
      net/mlx5e: simplify condition after napi budget handling change

Jiri Pirko (1):
      net/mlx5: Skip inline mode check after mlx5_eswitch_enable_locked() failure

Lama Kayal (1):
      net/mlx5e: Expose catastrophic steering error counters

Oz Shlomo (1):
      net/mlx5e: TC, refactor access to hash key

Shay Drory (8):
      RDMA/mlx5: Free second uplink ib port
      {net/RDMA}/mlx5: introduce lag_for_each_peer
      net/mlx5: LAG, check if all eswitches are paired for shared FDB
      net/mlx5: LAG, generalize handling of shared FDB
      net/mlx5: LAG, change mlx5_shared_fdb_supported() to static
      net/mlx5: LAG, block multipath LAG in case ldev have more than 2 ports
      net/mlx5: LAG, block multiport eswitch LAG in case ldev have more than 2 ports
      net/mlx5: Enable 4 ports VF LAG

Tariq Toukan (1):
      net/mlx5e: Remove RX page cache leftovers

 .../ethernet/mellanox/mlx5/devlink.rst             |   7 ++
 drivers/infiniband/hw/mlx5/ib_rep.c                | 103 +++++++++++++--------
 .../mellanox/mlx5/core/diag/reporter_vnic.c        |  10 ++
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   7 --
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.c  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   9 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  24 +++--
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  91 +++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |   4 +
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |   4 +
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.c   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.h   |   2 +-
 include/linux/mlx5/driver.h                        |   8 +-
 include/linux/mlx5/mlx5_ifc.h                      |  12 ++-
 18 files changed, 201 insertions(+), 103 deletions(-)

