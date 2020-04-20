Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9F41B079B
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgDTLln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTLlm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:41:42 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFFF821473;
        Mon, 20 Apr 2020 11:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382902;
        bh=zpoNYvrF7meha589K36Cq6061k4dj78hN3VOk7sTC+s=;
        h=From:To:Cc:Subject:Date:From;
        b=nVSj0St7hIG6JHRa9eqCSogmmgn/oWg7jl5bFFfJDnQTH6X/Hsu1Yd18HjqDvMjo/
         ny6esVyAj3iz4kUlK4mp011dt2juCPN0oEeeckxPXpi3FG2KGWn9y/we+57lqaAfD3
         vDa8Tb+x+8ghOPwTbe0Wxddq005Q6Ztl+2xpDv50=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 00/24] Mass conversion to light mlx5 command interface
Date:   Mon, 20 Apr 2020 14:41:12 +0300
Message-Id: <20200420114136.264924-1-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This is a followup to "net/mlx5: Provide simplified command interfaces" [1]
patch with conversion of everything in mlx5_core.

The patch separation is done by file to simplify bisection and they are
all similar, but of course, I can squash it to one mega patch if it is
necessary.

Thanks

[1] https://lore.kernel.org/linux-rdma/20200413142308.936946-2-leon@kernel.org

Leon Romanovsky (24):
  net/mlx5: Update vport.c to new cmd interface
  net/mlx5: Update cq.c to new cmd interface
  net/mlx5: Update debugfs.c to new cmd interface
  net/mlx5: Update ecpf.c to new cmd interface
  net/mlx5: Update eq.c to new cmd interface
  net/mlx5: Update statistics to new cmd interface
  net/mlx5: Update eswitch to new cmd interface
  net/mlx5: Update FPGA to new cmd interface
  net/mlx5: Update fs_core new cmd interface
  net/mlx5: Update fw.c new cmd interface
  net/mlx5: Update lag.c new cmd interface
  net/mlx5: Update gid.c new cmd interface
  net/mlx5: Update mpfs.c new cmd interface
  net/mlx5: Update vxlan.c new cmd interface
  net/mlx5: Update main.c new cmd interface
  net/mlx5: Update mcg.c new cmd interface
  net/mlx5: Update mr.c new cmd interface
  net/mlx5: Update pagealloc.c new cmd interface
  net/mlx5: Update pd.c new cmd interface
  net/mlx5: Update uar.c new cmd interface
  net/mlx5: Update rl.c new cmd interface
  net/mlx5: Update port.c new cmd interface
  net/mlx5: Update SW steering new cmd interface
  net/mlx5: Update transobj.c new cmd interface

 drivers/infiniband/hw/mlx5/ib_virt.c          |   2 +-
 drivers/infiniband/hw/mlx5/mad.c              |   4 +-
 drivers/infiniband/hw/mlx5/qp.c               |  32 ++--
 drivers/net/ethernet/mellanox/mlx5/core/cq.c  |  24 ++-
 .../net/ethernet/mellanox/mlx5/core/debugfs.c |  17 +--
 .../net/ethernet/mellanox/mlx5/core/ecpf.c    |  30 +---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   6 +-
 .../ethernet/mellanox/mlx5/core/en/health.c   |   2 +-
 .../mellanox/mlx5/core/en/monitor_stats.c     |  46 ++----
 .../ethernet/mellanox/mlx5/core/en_common.c   |   7 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   2 +-
 .../mellanox/mlx5/core/en_fs_ethtool.c        |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  29 ++--
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  17 +--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  38 ++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   6 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  18 +--
 .../ethernet/mellanox/mlx5/core/fpga/cmd.c    |  28 ++--
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  80 ++++------
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |  33 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lag.c |  52 +++----
 .../net/ethernet/mellanox/mlx5/core/lib/gid.c |   5 +-
 .../ethernet/mellanox/mlx5/core/lib/mpfs.c    |  10 +-
 .../ethernet/mellanox/mlx5/core/lib/vxlan.c   |  10 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  35 ++---
 drivers/net/ethernet/mellanox/mlx5/core/mcg.c |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  |  20 ++-
 .../ethernet/mellanox/mlx5/core/pagealloc.c   |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/pd.c  |  11 +-
 .../net/ethernet/mellanox/mlx5/core/port.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/rl.c  |  21 ++-
 .../mellanox/mlx5/core/steering/dr_cmd.c      |  33 ++--
 .../ethernet/mellanox/mlx5/core/transobj.c    | 113 +++++---------
 drivers/net/ethernet/mellanox/mlx5/core/uar.c |  11 +-
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 142 +++++++++---------
 include/linux/mlx5/cq.h                       |   2 +-
 include/linux/mlx5/transobj.h                 |  19 +--
 include/linux/mlx5/vport.h                    |   3 +-
 40 files changed, 373 insertions(+), 582 deletions(-)

--
2.25.2

