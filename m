Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA82B9230F
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 14:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfHSMIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 08:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbfHSMIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 08:08:21 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09D1720851;
        Mon, 19 Aug 2019 12:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566216500;
        bh=xgP6u7EKmbvXoQiZdBQ/XQSX0pQsaI0LTFNgKhAEAdU=;
        h=From:To:Cc:Subject:Date:From;
        b=ZVNsCCshqzZxBwDUP2cdh/2dVHp/z0VPfsAMwVRNlMyvlQLfFi/LEO/9UkcSCfvw/
         VIP4S01mEKs1+e9wpqxZenoNHJK6KA1mw8N+vJmPIBb1SnpMSpEMluKQZ8WF866DAO
         5YlUlS/HVxZ40fD7kBCej00LzWO9yz1v7j7L4amU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v3 0/3] ODP support for mlx5 DC QPs
Date:   Mon, 19 Aug 2019 15:08:12 +0300
Message-Id: <20190819120815.21225-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog
 v3:
 * Rewrote patches to expose through DEVX without need to change mlx5-abi.h at all.
 v2: https://lore.kernel.org/linux-rdma/20190806074807.9111-1-leon@kernel.org
 * Fixed reserved_* field wrong name (Saeed M.)
 * Split first patch to two patches, one for mlx5-next and one for  rdma-next. (Saeed M.)
 v1: https://lore.kernel.org/linux-rdma/20190804100048.32671-1-leon@kernel.org
 * Fixed alignment to u64 in mlx5-abi.h (Gal P.)
 v0: https://lore.kernel.org/linux-rdma/20190801122139.25224-1-leon@kernel.org

---------------------------------------------------------------------------------
From Michael,

The series adds support for on-demand paging for DC transport.

As DC is mlx-only transport, the capabilities are exposed
to the user using DEVX objects and later on through mlx5dv_query_device.

Thanks

Michael Guralnik (3):
  net/mlx5: Set ODP capabilities for DC transport to max
  IB/mlx5: Remove check of FW capabilities in ODP page fault handling
  IB/mlx5: Add page fault handler for DC initiator WQE

 drivers/infiniband/hw/mlx5/odp.c              | 51 ++-----------------
 .../net/ethernet/mellanox/mlx5/core/main.c    |  6 +++
 include/linux/mlx5/mlx5_ifc.h                 |  4 +-
 3 files changed, 12 insertions(+), 49 deletions(-)

--
2.20.1

