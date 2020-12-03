Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAD62CCDD7
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgLCEWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:22:02 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18345 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgLCEWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:22:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc867c20000>; Wed, 02 Dec 2020 20:21:22 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:21:21 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [pull request][net-next V2 00/15] mlx5 updates 2020-12-01
Date:   Wed, 2 Dec 2020 20:20:53 -0800
Message-ID: <20201203042108.232706-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606969282; bh=W1U7cLESkQltYljn6KL7BwXhK01Stmhspxiz6jMoTyM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=V/UWSRBRBjo14RTKDVf02w65ejFoLYYaWO0Nl9VUyHL03pbwFRBh83xb6+09Ofie0
         u56fYUa/NjkK6Vbgkvlab3oAZ6oO6627hc51eSWdUTz3xoTm/e5O0KqFnnU+EuvHeH
         fqpuBXBwdx5cuQHKzjE9xHdUA+shnsZbdscXV7FO6qyOzXKw40xg8Mr8W2v7uUbXnV
         xwMQoFGmEOnMZmZyExGd0CIAY1/5IzG6MqEFo3vIFqneVf5cz4Dxn3MEu+YQH2oaEt
         XKvedR/pHJwjC+3umqxRnY5cNoyenwJjYIT/49dUK5cXa1FkymCHTXD4dqS7dJCq6k
         2dCgWFGpECfdQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

v1->v2: Removed merge commit of mlx5-next.

This series adds port tx timestamping support and some misc updates.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---

The following changes since commit cec85994c6b4fa6beb5de61dcd03e23001b9deb5=
:

  bareudp: constify device_type declaration (2020-12-02 18:00:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2020-12-01

for you to fetch changes up to f5c3fd7ba638e4fa5908144b3995dcb6854fba60:

  net/mlx5e: Fill mlx5e_create_cq_param in a function (2020-12-02 20:14:42 =
-0800)

----------------------------------------------------------------
mlx5-updates-2020-12-01

mlx5e port TX timestamping support and MISC updates

1) Add support for port TX timestamping, for better PTP accuracy.

Currently in mlx5 HW TX timestamping is done on CQE (TX completion)
generation, which much earlier than when the packet actually goes out to
the wire, in this series Eran implements the option to do timestamping on
the port using a special SQ (Send Queue), such Send Queue will generate 2
CQEs (TX completions), the original one and a new one when the packet
leaves the port, due to the nature of this special handling, such mechanism
is an opt-in only and it is off by default to avoid any performance
degradation on normal traffic flows.

2) Misc updates and trivial improvements.

----------------------------------------------------------------
Aya Levin (3):
      net/mlx5e: Allow CQ outside of channel context
      net/mlx5e: Allow RQ outside of channel context
      net/mlx5e: Split between RX/TX tunnel FW support indication

Eran Ben Elisha (6):
      net/mlx5e: Allow SQ outside of channel context
      net/mlx5e: Change skb fifo push/pop API to be used without SQ
      net/mlx5e: Split SW group counters update function
      net/mlx5e: Move MLX5E_RX_ERR_CQE macro
      net/mlx5e: Add TX PTP port object support
      net/mlx5e: Add TX port timestamp support

Maxim Mikityanskiy (1):
      net/mlx5e: Fill mlx5e_create_cq_param in a function

Shay Drory (1):
      net/mlx5: Arm only EQs with EQEs

Tariq Toukan (1):
      net/mlx5e: Free drop RQ in a dedicated function

YueHaibing (2):
      net/mlx5e: Remove duplicated include
      net/mlx5: Fix passing zero to 'PTR_ERR'

Zhu Yanjun (1):
      net/mlx5e: remove unnecessary memset

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  63 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |  16 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   | 529 +++++++++++++++++=
++++
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |  63 +++
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  52 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 215 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  19 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   9 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  33 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 252 ++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  29 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 403 +++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  11 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  77 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   6 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |   2 +-
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       |   2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |   2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |   2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   1 -
 27 files changed, 1485 insertions(+), 350 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
