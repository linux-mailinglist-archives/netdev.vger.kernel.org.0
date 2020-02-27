Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C4F171748
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 13:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgB0MeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 07:34:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728964AbgB0MeJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 07:34:09 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DBD324697;
        Thu, 27 Feb 2020 12:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582806848;
        bh=NrUTIwnVOy1ogNwi+HK0bIcOkesiKOj7zu/rSVAbKC8=;
        h=From:To:Cc:Subject:Date:From;
        b=ID1LpEzzHMw29n6x79/trA41j7p349LS3KzRTSdVxWGnLUc23A4wp+dvgzGpJrxE5
         hIyd57QKcMEVBlSLALsF2/ZN6+wWEhsohpk3HnOCoe5b3IliV7dMlihQ3az5RSOkIK
         S3Z+SOrnzPFZ7B1BQ1VcHIIRbnc143Gbg/UtASWU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next 0/9] MR cache fixes and refactoring
Date:   Thu, 27 Feb 2020 14:33:51 +0200
Message-Id: <20200227123400.97758-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This series fixes various corner cases in the mlx5_ib MR
cache implementation, see specific commit messages for more
information.

Thanks

Jason Gunthorpe (8):
  RDMA/mlx5: Rename the tracking variables for the MR cache
  RDMA/mlx5: Simplify how the MR cache bucket is located
  RDMA/mlx5: Always remove MRs from the cache before destroying them
  RDMA/mlx5: Fix MR cache size and limit debugfs
  RDMA/mlx5: Lock access to ent->available_mrs/limit when doing
    queue_work
  RDMA/mlx5: Fix locking in MR cache work queue
  RDMA/mlx5: Revise how the hysteresis scheme works for cache filling
  RDMA/mlx5: Allow MRs to be created in the cache synchronously

Michael Guralnik (1):
  RDMA/mlx5: Move asynchronous mkey creation to mlx5_ib

 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  33 +-
 drivers/infiniband/hw/mlx5/mr.c              | 642 +++++++++++--------
 drivers/infiniband/hw/mlx5/odp.c             |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c |  22 +-
 include/linux/mlx5/driver.h                  |   6 -
 5 files changed, 404 insertions(+), 301 deletions(-)

--
2.24.1

