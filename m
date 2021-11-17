Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83964454D13
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239994AbhKQS3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:29:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235342AbhKQS32 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 13:29:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B58D61A62;
        Wed, 17 Nov 2021 18:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637173589;
        bh=aX7kR5mhhKUKPo/3xI2LEWmDxKJnOScXHCAboHytXl4=;
        h=From:To:Cc:Subject:Date:From;
        b=gMCay+Zg6c1ByKP22PhL3E+8cYanJkrIMvHTpPD5eRYdefeOg/XAVnIEXakYKH4KT
         REX9w4+8T4FyzV/zPC1gL+pGtYT6s/D4Ys8gA2UfCoKAKB/e0v8htOX5sONPAGY5ny
         cugK13ngC3k1R+mG5+BKHwxNCk72BJS0VJP6pJ4DxtJYXBxpbmZDlo8hhKANCzUzww
         YQVUbdlYL110olnJVWvoOep7xklaN+wime9vBv6KhcOjsB8gSOTFOVy+89PZfy4WsE
         K0IKEjPzmkPdQCPU8xpyWlEVKi2aaapuxHjfoQk7k/xDvXTEyOCN8RLbsQtu0ewpB7
         gDMj35Thxe5/Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Aya Levin <ayal@mellanox.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>, drivers@pensando.io,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 0/6] Devlink cleanups
Date:   Wed, 17 Nov 2021 20:26:16 +0200
Message-Id: <cover.1637173517.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This series is non-controversial subset of my RFC [1], where I proposed
a way to allow parallel devlink execution.

Thanks

[1] https://lore.kernel.org/all/cover.1636390483.git.leonro@nvidia.com

Leon Romanovsky (6):
  devlink: Remove misleading internal_flags from health reporter dump
  devlink: Delete useless checks of holding devlink lock
  devlink: Simplify devlink resources unregister call
  devlink: Clean registration of devlink port
  devlink: Reshuffle resource registration logic
  devlink: Inline sb related functions

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   7 +-
 .../freescale/dpaa2/dpaa2-eth-devlink.c       |   7 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  23 +-
 .../marvell/prestera/prestera_devlink.c       |   8 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     |   4 +-
 .../ethernet/mellanox/mlx5/core/en/devlink.c  |   5 +-
 .../ethernet/mellanox/mlx5/core/en/devlink.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   7 +-
 .../mellanox/mlx5/core/esw/devlink_port.c     |   9 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  15 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   4 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |   4 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |   4 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |   8 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  14 +-
 drivers/net/netdevsim/dev.c                   |  11 +-
 include/net/devlink.h                         |   9 +-
 net/core/devlink.c                            | 220 ++++++------------
 net/dsa/dsa.c                                 |   2 +-
 net/dsa/dsa2.c                                |   9 +-
 20 files changed, 115 insertions(+), 257 deletions(-)

-- 
2.33.1

