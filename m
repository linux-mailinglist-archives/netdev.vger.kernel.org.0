Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA93CE102
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbfJGL6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbfJGL6Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 07:58:24 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EE71206C0;
        Mon,  7 Oct 2019 11:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570449503;
        bh=h5PdoRx5540011kN/7+z08gjBFOMzx/MQk7yc+ikkoI=;
        h=From:To:Cc:Subject:Date:From;
        b=foemdufbFgereOuX5ewrZZWDB5zfbVENaBK2rvjMSeckLhSmx4858xMwAOPI54cb1
         LmOzkaw8Z4Lad/6qOwmiqZg7Ioml4qSuifemhZGMD1LXZACSkW/bDX+2NEo9CxAuBx
         zLsOHaqderC+9p95+EzniysscXr3JQzxPrvIH9gQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v1 0/3] Optimize SGL registration
Date:   Mon,  7 Oct 2019 14:58:16 +0300
Message-Id: <20191007115819.9211-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog v0->v1: https://lore.kernel.org/linux-rdma/20191006155955.31445-1-leon@kernel.org
 * Reorganized patches to have IB/core changes separated from mlx5
 * Moved SGL check before rdma_rw_force_mr
 * Added and rephrased original comment.

-----------------------------------------------------------------------------
Hi,

This series from Yamin implements long standing "TODO" existed in rw.c.

Thanks

Yamin Friedman (3):
  net/mlx5: Expose optimal performance scatter entries capability
  RDMA/rw: Support threshold for registration vs scattering to local
    pages
  RDMA/mlx5: Add capability for max sge to get optimized performance

 drivers/infiniband/core/rw.c      | 14 ++++++++------
 drivers/infiniband/hw/mlx5/main.c |  2 ++
 include/linux/mlx5/mlx5_ifc.h     |  2 +-
 include/rdma/ib_verbs.h           |  2 ++
 4 files changed, 13 insertions(+), 7 deletions(-)

--
2.20.1

