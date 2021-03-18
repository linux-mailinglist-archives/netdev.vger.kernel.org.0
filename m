Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAC1340465
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 12:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhCRLQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 07:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhCRLPy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 07:15:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D5A564F04;
        Thu, 18 Mar 2021 11:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616066153;
        bh=SpdXvt/IHN+ouT5vGlIbzinGudPspv45K2jqget9/1Y=;
        h=From:To:Cc:Subject:Date:From;
        b=EwjU7DsFLrM3Pixr3E+YF3BlGVbl01cI7J9YUvl95YRMWFK6DNEPAzSU0TPQRnFCt
         uLEBQB1j0IqQ4nHNcEtyhX2oSM5Z7gh6Lk7UTs94S/jJSuieaGHmlNtcLoVTByDz9m
         IjFxtwRGKU1wE0QvY03suYo7/Rjv+rUrxVtErK7HfMscXNa9NwRtMv+qAiQlCghdkL
         Kdrj4/Hj7SaSU+97OfF6ygAwq7pum19GSFtf/9wZpX50bWM/cv89qRpNOEE8BX2dQs
         uhUB4oiI/7+T4tFttWn9wcK+TLvar6EBwN1tPhe08YT22uX/EK8Ez1YGeWQk4wI6EC
         n0GZ7bNvqowvA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next 0/7] Add MEMIC operations support
Date:   Thu, 18 Mar 2021 13:15:41 +0200
Message-Id: <20210318111548.674749-1-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This series from Maor extends MEMIC to support atomic operations from
the host in addition to already supported regular read/write.

Thanks

Maor Gottlieb (7):
  net/mlx5: Add MEMIC operations related bits
  RDMA/uverbs: Make UVERBS_OBJECT_METHODS to consider line number
  RDMA/mlx5: Avoid use after free in allocate MEMIC bad flow
  RDMA/mlx5: Move all DM logic to separate file
  RDMA/mlx5: Add support to MODIFY_MEMIC command
  RDMA/mlx5: Add support in MEMIC operations
  RDMA/mlx5: Expose UAPI to query DM

 drivers/infiniband/hw/mlx5/Makefile      |   1 +
 drivers/infiniband/hw/mlx5/cmd.c         | 101 ----
 drivers/infiniband/hw/mlx5/cmd.h         |   3 -
 drivers/infiniband/hw/mlx5/dm.c          | 595 +++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/dm.h          |  18 +
 drivers/infiniband/hw/mlx5/main.c        | 243 +--------
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  20 +-
 include/linux/mlx5/mlx5_ifc.h            |  42 +-
 include/rdma/uverbs_named_ioctl.h        |   3 +-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  19 +
 10 files changed, 699 insertions(+), 346 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/dm.c
 create mode 100644 drivers/infiniband/hw/mlx5/dm.h

--
2.30.2

