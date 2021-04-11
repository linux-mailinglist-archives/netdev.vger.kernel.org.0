Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E00935B423
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 14:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhDKM3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 08:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhDKM3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 08:29:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D69A610C8;
        Sun, 11 Apr 2021 12:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618144170;
        bh=vvod46FFvsLIObM4UJY8ibXDvqx4jxtkFns9xCfqbas=;
        h=From:To:Cc:Subject:Date:From;
        b=Bmc5bC1feeq1T4WUz/K/WEhcyFVdMiwPpDCJ1hDnvDeUZn4Iribm/UVM7Oslvz7oS
         pptsB67joWQdYVQSzrvCiNBRS9ngrRisXaMNUb5BFlxFGgqgif8AjrisKMeAZ+Tnfy
         zNbSrU9NXzkoG/biQmweVK5ujnyzFKrXcmZSwMbyHNjnYENy2bkkMS5l173c4zFM9N
         SXyEsxN7E0vC+Fv3mb9zh8F8OarhImcv5IZDw7ajQVxrR3qYz3JdFcCFajYLJ5PzjR
         n20t63cc5YIXaoDTizCeqd7fE7ZU8BBEZioTFWnr0NT5JK995tiWj5e9Ncl5tfTabv
         BfbgVsDcrDfIg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-api@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next v1 0/7] Add MEMIC operations support
Date:   Sun, 11 Apr 2021 15:29:17 +0300
Message-Id: <20210411122924.60230-1-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v1: 
 * Changed logic of patch #6 per-Jason's request. 
v0: https://lore.kernel.org/linux-rdma/20210318111548.674749-1-leon@kernel.org

---------------------------------------------------------------------------

Hi,

This series from Maor extends MEMIC to support atomic operations from
the host in addition to already supported regular read/write.

Thanks

Maor Gottlieb (7):
  net/mlx5: Add MEMIC operations related bits
  RDMA/uverbs: Make UVERBS_OBJECT_METHODS to consider line number
  RDMA/mlx5: Move all DM logic to separate file
  RDMA/mlx5: Re-organize the DM code
  RDMA/mlx5: Add support to MODIFY_MEMIC command
  RDMA/mlx5: Add support in MEMIC operations
  RDMA/mlx5: Expose UAPI to query DM

 drivers/infiniband/hw/mlx5/Makefile      |   1 +
 drivers/infiniband/hw/mlx5/cmd.c         | 101 ----
 drivers/infiniband/hw/mlx5/cmd.h         |   3 -
 drivers/infiniband/hw/mlx5/dm.c          | 584 +++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/dm.h          |  68 +++
 drivers/infiniband/hw/mlx5/main.c        | 243 +---------
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  25 +-
 drivers/infiniband/hw/mlx5/mr.c          |   1 +
 include/linux/mlx5/mlx5_ifc.h            |  42 +-
 include/rdma/uverbs_named_ioctl.h        |   2 +-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  19 +
 11 files changed, 720 insertions(+), 369 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/dm.c
 create mode 100644 drivers/infiniband/hw/mlx5/dm.h

-- 
2.30.2

