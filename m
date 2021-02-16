Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4171E31D292
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhBPWZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:25:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhBPWZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 17:25:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A66E064E10;
        Tue, 16 Feb 2021 22:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613514291;
        bh=aM2Lu3JCS27IS4ZKLN21SpJ7NH06z/YK6a+An3bOSZk=;
        h=From:To:Cc:Subject:Date:From;
        b=A1abk/tT7QxkJc/63EFDEkPT/KYs2v0SdUj8OI5Y2z0y8kHinkgzNJg0ivPmIebYJ
         9M0VNUl9xJuOG2ebpr4Pq+++kInBLb5x6bHIw98mPm2hj38uUEmPU2l0qoYpFiqE1+
         /tLtFekT3T8q3zMlDY5TesUihfm6NS9I+s7bMM8cGzFFu6yFHh6WticWx5pILVk6vE
         eRBei/hP9r27hhzrCdSRuJKWviEHnxGgo1obdNWaHw9EWydXg0SHzTDuu9JyeSXwE9
         ABh2bwpqpgJIcANCCml9mfLf6fYG/h05un9z/rXOL60BhNjiZC/DdC5GMb3z63kgVW
         gCAMPRVIJI4tA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: pull-request: mlx5-next 2021-02-16
Date:   Tue, 16 Feb 2021 14:24:38 -0800
Message-Id: <20210216222438.51678-1-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub, Jason

The patches in this pr are already submitted and reviewed through the
netdev and rdma mailing lists.

The series includes mlx5 HW bits and definitions for mlx5 real time clock
translation and handling in the mlx5 driver clock module to enable and
support such mode [1]

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20210212223042.449816-7-saeed@kernel.org/


The following changes since commit 19c329f6808995b142b3966301f217c831e7cf31:

  Linux 5.11-rc4 (2021-01-17 16:37:05 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to 432119de33d9013467371fc85238d623f64ff67e:

  net/mlx5: Add cyc2time HW translation mode support (2021-02-16 14:04:54 -0800)

----------------------------------------------------------------
Aharon Landau (1):
      net/mlx5: Add new timestamp mode bits

Aya Levin (1):
      net/mlx5: Add cyc2time HW translation mode support

Eran Ben Elisha (4):
      net/mlx5: Add register layout to support real-time time-stamp
      net/mlx5: Refactor init clock function
      net/mlx5: Move all internal timer metadata into a dedicated struct
      net/mlx5: Move some PPS logic into helper functions

Yishai Hadas (1):
      net/mlx5: Expose ifc bits for query modify header

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   7 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   3 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 431 ++++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/lib/clock.h    |  36 +-
 include/linux/mlx5/device.h                        |   5 +-
 include/linux/mlx5/driver.h                        |  13 +-
 include/linux/mlx5/mlx5_ifc.h                      |  96 ++++-
 11 files changed, 501 insertions(+), 129 deletions(-)
