Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB1F1D0D27
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 11:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387542AbgEMJuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 05:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732931AbgEMJuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 05:50:40 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4594723128;
        Wed, 13 May 2020 09:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363439;
        bh=6Kbr+u3ZpaS0c+vW2VIy+pExcklK1M4cFea8NXTd8Cw=;
        h=From:To:Cc:Subject:Date:From;
        b=BF9agn5890+DNO3IsSdc1YjYG79rf6c3fV0XTCWAq4vx/iRz4bhAYiGzyg53xEnEu
         jiPC/qX7ZXqQMb8GNwqKfWonlzHL+ePRgvaddmkyDUUc8ZmxElSdu/04amX/Olu+It
         75D9cnxPx4RryCv73PGix3EbtecJeUdmhi9t+AfY=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Lijun Ou <oulijun@huawei.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>
Subject: [PATCH rdma-next 00/14] RAW format dumps through RDMAtool
Date:   Wed, 13 May 2020 12:50:20 +0300
Message-Id: <20200513095034.208385-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

From Maor:

Hi,

The following series adds support to get the RDMA resource data in RAW
format. The main motivation for doing this is to enable vendors to return
the entire QP/CQ/MR data without a need from the vendor to set each field
separately.

Thanks

Maor Gottlieb (14):
  net/mlx5: Export resource dump interface
  net/mlx5: Add support in query QP, CQ and MKEY segments
  RDMA/core: Fix double put of resource
  RDMA/core: Allow to override device op
  RDMA/core: Don't call fill_res_entry for PD
  RDMA/core: Add restrack dummy ops
  RDMA: Add dedicated MR resource tracker function
  RDMA: Add a dedicated CQ resource tracker function
  RDMA: Add a dedicated QP resource tracker function
  RDMA: Add dedicated cm id resource tracker function
  RDMA: Add support to dump resource tracker in RAW format
  RDMA/mlx5: Add support to get QP resource in raw format
  RDMA/mlx5: Add support to get CQ resource in RAW format
  RDMA/mlx5: Add support to get MR resource in RAW format

 drivers/infiniband/core/device.c              |  16 ++-
 drivers/infiniband/core/nldev.c               | 136 ++++++++----------
 drivers/infiniband/core/restrack.c            |  32 +++++
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
 17 files changed, 258 insertions(+), 201 deletions(-)
 copy {drivers/net/ethernet/mellanox/mlx5/core/diag => include/linux/mlx5}/rsc_dump.h (68%)

--
2.26.2

