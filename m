Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C8C80A45
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 12:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfHDKAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 06:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbfHDKAx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 06:00:53 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57B9B206C1;
        Sun,  4 Aug 2019 10:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564912852;
        bh=vGvbCnoLE5ou0ji27VgQajDtMCy/DEoXpMioluC9X18=;
        h=From:To:Cc:Subject:Date:From;
        b=Stw0eMOJ7soVonA6fNNZK/BhGFa8gxiwvOcnwwU5GHkNG9nrPMldKELrHJeQV3dO8
         p0K80s9TYNvAwPXAxlvRJN+woXCEEQwuHfg1W4i91WJyymx37n/d93auYwwI4K942R
         AMoRrNFjphrFgSXQqX4mgqlof8eR8ekXung2xk+M=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v1 0/3] ODP support for mlx5 DC QPs
Date:   Sun,  4 Aug 2019 13:00:45 +0300
Message-Id: <20190804100048.32671-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog
 v1:
 * Fixed alignment to u64 in mlx5-abi.h (Gal P.)
 v0:
 * https://lore.kernel.org/linux-rdma/20190801122139.25224-1-leon@kernel.org

---------------------------------------------------------------------------------
From Michael,

The series adds support for on-demand paging for DC transport.
Adding handling of DC WQE parsing upon page faults and exposing
capabilities.

As DC is mlx-only transport, the capabilities are exposed to the user
using the direct-verbs mechanism. Namely through the
mlx5dv_query_device.

Thanks

Thanks

Michael Guralnik (3):
  IB/mlx5: Query ODP capabilities for DC
  IB/mlx5: Expose ODP for DC capabilities to user
  IB/mlx5: Add page fault handler for DC initiator WQE

 drivers/infiniband/hw/mlx5/main.c             |  6 +++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  1 +
 drivers/infiniband/hw/mlx5/odp.c              | 27 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  6 +++++
 include/linux/mlx5/mlx5_ifc.h                 |  4 ++-
 include/uapi/rdma/mlx5-abi.h                  |  3 +++
 6 files changed, 45 insertions(+), 2 deletions(-)

--
2.20.1

