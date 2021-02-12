Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E1931A7C3
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhBLWdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:33:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232252AbhBLWb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:31:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2334A64E92;
        Fri, 12 Feb 2021 22:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613169047;
        bh=2ErxeG0gUpkl9E4MKVDgHsvxbVKhQAcIgeF/q4mo9ZU=;
        h=From:To:Cc:Subject:Date:From;
        b=KRM9TlyqQmAqnPDohmrvv2mbpEFhtnakeJFu/knwKn68ZKiVLjxfvc3NYlsZNAmCN
         qccxSbI/zrJl436EBVdahwd1OiVtvbYOK7WysA6jWgCL1jbIPG0SR2fXCM3BkX7/uV
         nT1sjC6yKwlr3Ngv2MeNSXEai9tbqgfXDnvKRotYkJvx8Qmm+bmUFV3mMKyptV6+RR
         FLfglaQqRw5zzPm6zM3Zft0Cyxq5XdVvCFzKp7NHlWPiy6RMTH0cgvBavYKXezGfmk
         rio73T+UktJI9oZtnZsWi2cBilco7+yM5/uvR1mNskIyLQlcpUkbyvakSvTb5NJqNY
         482cLflCwJQcw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH mlx5-next 0/6] mlx5 real time clock
Date:   Fri, 12 Feb 2021 14:30:36 -0800
Message-Id: <20210212223042.449816-1-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi, 

This series adds the support for mlx5 clock real time translation mode.
In case of no objection the series will be applied to mlx5-next branch.

Device timestamp can be in real time mode (cycles to time translation is
offloaded into the Hardware). With real time mode, HW provides timestamp
which is already translated into nanoseconds.

For more information about real time mode please see last patch in the
series.

Thanks,
Saeed.

---

Aharon Landau (1):
  net/mlx5: Add new timestamp mode bits

Aya Levin (1):
  net/mlx5: Add cyc2time HW translation mode support

Eran Ben Elisha (4):
  net/mlx5: Add register layout to support real-time time-stamp
  net/mlx5: Refactor init clock function
  net/mlx5: Move all internal timer metadata into a dedicated struct
  net/mlx5: Move some PPS logic into helper functions

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   3 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   7 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  18 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  11 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   3 +-
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 431 +++++++++++++-----
 .../ethernet/mellanox/mlx5/core/lib/clock.h   |  36 +-
 include/linux/mlx5/device.h                   |   5 +-
 include/linux/mlx5/driver.h                   |  13 +-
 include/linux/mlx5/mlx5_ifc.h                 |  84 +++-
 11 files changed, 489 insertions(+), 129 deletions(-)

-- 
2.29.2

