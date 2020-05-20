Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B981DAD6D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 10:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgETI30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 04:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETI3Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 04:29:25 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A843C206C3;
        Wed, 20 May 2020 08:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589963365;
        bh=B9Nyeo9U4bfj1TqSlXoRvg7ubDm+ZScLCp/I1MoL6h8=;
        h=From:To:Cc:Subject:Date:From;
        b=ZRVdSLItlk1OTQS3N5Tu7f7dCK0LsURby7kx+Et0E1AYuKozax1AuxzxICwSOOWYr
         uuoOodh7YV2Zk56r+T3ttLWbk/7yO2gCp+OYuYkKA3j5ZWj156hxoqMpn/PAhkt7CQ
         0SsqR1C2Y8+UGGSpIHl4VPy6kqAXX2QGFDfJBdq4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next 0/8] Driver part of the ECE
Date:   Wed, 20 May 2020 11:29:11 +0300
Message-Id: <20200520082919.440939-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This is driver part of the RDMA-CM ECE series [1].
According to the IBTA, ECE data is completely vendor specific, so this
series extends mlx5_ib create_qp and modify_qp structs with extra field
to pass ECE options to/from the application.

Thanks

[1] https://lore.kernel.org/linux-rdma/20200413141538.935574-1-leon@kernel.org

Leon Romanovsky (8):
  net/mlx5: Add ability to read and write ECE options
  RDMA/mlx5: Get ECE options from FW during create QP
  RDMA/mlx5: Set ECE options during QP create
  RDMA/mlx5: Use direct modify QP implementation
  RDMA/mlx5: Remove manually crafted QP context the query call
  RDMA/mlx5: Convert modify QP to use MLX5_SET macros
  RDMA/mlx5: Set ECE options during modify QP
  RDMA/mlx5: Return ECE data after modify QP

 drivers/infiniband/hw/mlx5/qp.c  | 498 ++++++++++++++++++-------------
 drivers/infiniband/hw/mlx5/qp.h  |   6 +-
 drivers/infiniband/hw/mlx5/qpc.c |  44 ++-
 include/linux/mlx5/mlx5_ifc.h    |  29 +-
 include/linux/mlx5/qp.h          |  66 ----
 include/uapi/rdma/mlx5-abi.h     |   8 +-
 6 files changed, 351 insertions(+), 300 deletions(-)

--
2.26.2

