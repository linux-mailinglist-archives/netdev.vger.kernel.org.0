Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEA9353BD9
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhDEFuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229727AbhDEFuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF4BA6138A;
        Mon,  5 Apr 2021 05:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617601805;
        bh=HL3XcxJnh+PpngLSQ1cW4W65/ax//mggo+MJmIHNZKE=;
        h=From:To:Cc:Subject:Date:From;
        b=JoWpvmHr8cbXC2wGqorO6A7gFrAKBNhaX6C0Z1rLW+CLElmWI4t7U6yocQMei8PzC
         sPyPYTw70ck102ou4VETIuVUfmzuXvHoBcF4zlXCLrJJUV5sfsRdmuKnObGq7tu5qW
         sNLVme//M7TPI8I85ht1jY1ADGuICcgA3JWoYQwnsBePYtiwkpnVtDp+XEdJ7TwmNx
         Nd2S0IaIhLaOwlzWT8HjN/UJO13YPDOfdIYEKH0JI2nIHJf0ark0zVO9BG8FXQQrpt
         /8OV+30NarBYePQino+ZNTl8eaAz3ASFhMo845QpNAN84+qtjUmrlev5KqEoOxOR8+
         L/0IkSvtF4paQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        rds-devel@oss.oracle.com,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: [PATCH rdma-next 0/8] Generalize if ULP supported check
Date:   Mon,  5 Apr 2021 08:49:52 +0300
Message-Id: <20210405055000.215792-1-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This series adds new callback to check if ib client is supported/not_supported.
Such general callback allows us to save memory footprint by not starting
on devices that not going to work on them anyway.

Thanks

Parav Pandit (8):
  RDMA/core: Check if client supports IB device or not
  RDMA/cma: Skip device which doesn't support CM
  IB/cm: Skip device which doesn't support IB CM
  IB/core: Skip device which doesn't have necessary capabilities
  IB/IPoIB: Skip device which doesn't have InfiniBand port
  IB/opa_vnic: Move to client_supported callback
  net/smc: Move to client_supported callback
  net/rds: Move to client_supported callback

 drivers/infiniband/core/cm.c                  | 15 +++++++++++++-
 drivers/infiniband/core/cma.c                 | 15 +++++++++++++-
 drivers/infiniband/core/device.c              |  3 +++
 drivers/infiniband/core/multicast.c           | 15 +++++++++++++-
 drivers/infiniband/core/sa_query.c            | 15 +++++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     | 13 ++++++++++++
 .../infiniband/ulp/opa_vnic/opa_vnic_vema.c   |  4 +---
 include/rdma/ib_verbs.h                       |  9 +++++++++
 net/rds/ib.c                                  | 20 ++++++++++++-------
 net/smc/smc_ib.c                              |  9 ++++++---
 10 files changed, 101 insertions(+), 17 deletions(-)

-- 
2.30.2

