Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B817918988A
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgCRJxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgCRJxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 05:53:06 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDEEF2076F;
        Wed, 18 Mar 2020 09:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584525185;
        bh=8gg3tjIhkt2FJ8A0Bi3bOqZB1iaXQRhtVf8ExTCF3mo=;
        h=From:To:Cc:Subject:Date:From;
        b=GULeZ9sVKOoRFqUYShCmm7PrYsvTqv1IdWGpLslE3Btn3NYvT9i2Ax5VmOlflI50J
         mfBkDaShnZ2oaFjftPVbBImntHMeTgiNa4psdGgb+OqpeVw5z9ZZn6VSC3vVPWCOxb
         wub0yA4/+yANMq9qOui9wZ3aWD00wQcsF7QHscjM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-next 0/6] Set flow_label and RoCEv2 UDP source port for datagram QP
Date:   Wed, 18 Mar 2020 11:52:54 +0200
Message-Id: <20200318095300.45574-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

From Mark:

This series provide flow label and UDP source port definition in RoCE v2.
Those fields are used to create entropy for network routes (ECMP), load
balancers and 802.3ad link aggregation switching that are not aware of
RoCE headers.

Thanks.

Mark Zhang (6):
  net/mlx5: Enable SW-defined RoCEv2 UDP source port
  RDMA/core: Add hash functions to calculate RoCEv2 flowlabel and UDP
    source port
  RDMA/mlx5: Define RoCEv2 udp source port when set path
  RDMA/cma: Initialize the flow label of CM's route path record
  RDMA/cm: Set flow label of recv_wc based on primary flow label
  RDMA/mlx5: Set UDP source port based on the grh.flow_label

 drivers/infiniband/core/cm.c                  |  7 +++
 drivers/infiniband/core/cma.c                 | 23 ++++++++++
 drivers/infiniband/hw/mlx5/ah.c               | 21 ++++++++-
 drivers/infiniband/hw/mlx5/main.c             |  4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  4 +-
 drivers/infiniband/hw/mlx5/qp.c               | 30 ++++++++++---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 39 ++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h                 |  5 ++-
 include/rdma/ib_verbs.h                       | 44 +++++++++++++++++++
 9 files changed, 164 insertions(+), 13 deletions(-)

--
2.24.1

