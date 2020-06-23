Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDB9204FE5
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 13:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732432AbgFWLBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 07:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732245AbgFWLBK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 07:01:10 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E03FA20738;
        Tue, 23 Jun 2020 11:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592910070;
        bh=6Dhmwh7zQ7SRyV8MNEqgK3WOTVbxQQK0u/oit61PGrA=;
        h=From:To:Cc:Subject:Date:From;
        b=p6cgvNYYoiTE/Cd7/f9UH/1lcx/0GKbtexPlA2yqh56w7QkrG31+gaFpJmbjph3st
         bA1qFgjP6PQl5RVxv4J+2EESkJJBqphu/dte2HVu4G0QCOxOtwR2dFq/4QTdxIhrhU
         e2ej38qYjhOu8e/Q3ZsfGz92OiRM4LiHrFE9cPQU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next 0/2] Create IPoIB QP with specific QP number
Date:   Tue, 23 Jun 2020 14:01:03 +0300
Message-Id: <20200623110105.1225750-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

From Michael,

This series handles IPoIB child interface creation with setting
interface's HW address.

In current implementation, lladdr requested by user is ignored and
overwritten. Child interface gets the same GID as the parent interface
and a QP number which is assigned by the underlying drivers.

In this series we fix this behavior so that user's requested address is
assigned to the newly created interface.

As specific QP number request is not supported for all vendors, QP
number requested by user will still be overwritten when this is not
supported.

Behavior of creation of child interfaces through the sysfs mechanism or
without specifying a requested address, stays the same.

Thanks

Michael Guralnik (2):
  net/mlx5: Enable QP number request when creating IPoIB underlay QP
  RDMA/ipoib: Handle user-supplied address when creating child

 drivers/infiniband/ulp/ipoib/ipoib_main.c             | 11 +++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  7 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c        |  3 +++
 include/linux/mlx5/mlx5_ifc.h                         |  9 +++++++--
 4 files changed, 26 insertions(+), 4 deletions(-)

--
2.26.2

