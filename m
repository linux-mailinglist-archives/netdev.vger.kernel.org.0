Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0A11E4495
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388713AbgE0NyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387581AbgE0NyO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 09:54:14 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4496207D8;
        Wed, 27 May 2020 13:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590587654;
        bh=KNF1MfvZeNs28YKn0ZbgwmTVTyWpQUW/7KydDhpaqPc=;
        h=From:To:Cc:Subject:Date:From;
        b=rDhW+TTp92kWLUpYQ/dFN2veC2uvctixIATLUo4BF8twB0diqlNfuyV2j/BlStGx/
         cn5VXVj6+atmwCm3kkvcRL+Y7rMWrZw72mqxyIh9UOOkeaSxgw0jdBMHb7+AjWB0HO
         yVkJ1j+7ANiEMnG9q7yIP4kE3zmjmIMrL+RYJCMk=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lijun Ou <oulijun@huawei.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>
Subject: [PATCH rdma-next v1 00/11] RAW format dumps through RDMAtool
Date:   Wed, 27 May 2020 16:53:57 +0300
Message-Id: <20200527135408.480878-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Changelog:
v1:
 * Maor dropped controversial change to dummy interface.
v0: https://lore.kernel.org/linux-rdma/20200513095034.208385-1-leon@kernel.org

Hi,

The following series adds support to get the RDMA resource data in RAW
format. The main motivation for doing this is to enable vendors to return
the entire QP/CQ/MR data without a need from the vendor to set each field
separately.

Thanks

Maor Gottlieb (11):
  net/mlx5: Export resource dump interface
  net/mlx5: Add support in query QP, CQ and MKEY segments
  RDMA/core: Don't call fill_res_entry for PD
  RDMA: Add dedicated MR resource tracker function
  RDMA: Add dedicated CQ resource tracker function
  RDMA: Add dedicated QP resource tracker function
  RDMA: Add dedicated CM_ID resource tracker function
  RDMA: Add support to dump resource tracker in RAW format
  RDMA/mlx5: Add support to get QP resource in raw format
  RDMA/mlx5: Add support to get CQ resource in RAW format
  RDMA/mlx5: Add support to get MR resource in RAW format

 drivers/infiniband/core/device.c              |   7 +-
 drivers/infiniband/core/nldev.c               | 128 +++++++++---------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h        |   7 +-
 drivers/infiniband/hw/cxgb4/provider.c        |  11 +-
 drivers/infiniband/hw/cxgb4/restrack.c        |  33 ++---
 drivers/infiniband/hw/hns/hns_roce_device.h   |   4 +-
 drivers/infiniband/hw/hns/hns_roce_main.c     |   2 +-
 drivers/infiniband/hw/hns/hns_roce_restrack.c |  17 +--
 drivers/infiniband/hw/mlx5/main.c             |   6 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  11 +-
 drivers/infiniband/hw/mlx5/restrack.c         | 105 +++++++++++---
 .../mellanox/mlx5/core/diag/rsc_dump.c        |   6 +
 .../mellanox/mlx5/core/diag/rsc_dump.h        |  33 +----
 .../diag => include/linux/mlx5}/rsc_dump.h    |  25 ++--
 include/rdma/ib_verbs.h                       |  13 +-
 include/uapi/rdma/rdma_netlink.h              |   2 +
 16 files changed, 225 insertions(+), 185 deletions(-)
 copy {drivers/net/ethernet/mellanox/mlx5/core/diag => include/linux/mlx5}/rsc_dump.h (68%)

--
2.26.2

