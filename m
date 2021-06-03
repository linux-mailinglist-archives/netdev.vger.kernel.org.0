Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE8039A17F
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 14:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhFCMxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 08:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229876AbhFCMxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 08:53:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41B386124B;
        Thu,  3 Jun 2021 12:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622724715;
        bh=C8HPP5sd9YlhX8e04OtjxshaooCjbWpRclLtzli8xMs=;
        h=From:To:Cc:Subject:Date:From;
        b=E0R7YiyxmLeOb7Bvejn965eCL3+0UbxbrJx53hgPYQE/8X2g1mZOOCOARxr1XCSvb
         5uqzoR9JCbSPCFUgzpdpM1EmOk5lhusbklEDZA1T/ewSdANG3n2yyd+ZWI565Gli+J
         BqwFH7m73O+hLeuvmTrHtIHDZ0Yq5+lrGIINFdKBZUJFMGRrLx4r0gUO/InOS/o63o
         p4GFXyxJNKVCk3XEhYK5n2Glt92Nkb+lbSbBHZ+1lgI9m3npI71k+PjoHusnYzdZQO
         udUggSyiqGAHGWM1lc26jxIt7iIl4hbaIN3I/FLXR7HP5JeVuQ/VlSmlNQzewTsues
         VRrVv1vJpIaPA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        Lior Nahmanson <liorna@nvidia.com>,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 0/3] Add ConnectX DCS offload support
Date:   Thu,  3 Jun 2021 15:51:47 +0300
Message-Id: <cover.1622723815.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This patchset from Lior adds support of DCI stream channel (DCS) support.

DCS is an offload to SW load balancing of DC initiator work requests.

A single DC QP initiator (DCI) can be connected to only one target at the time 
and can't start new connection until the previous work request is completed.

This limitation causes to delays when the initiator process needs to
transfer data to multiple targets at the same time.

Thanks

Lior Nahmanson (3):
  net/mlx5: Add DCS caps & fields support
  RDMA/mlx5: Move DCI QP creation to separate function
  RDMA/mlx5: Add DCS offload support

 drivers/infiniband/hw/mlx5/main.c |  10 ++
 drivers/infiniband/hw/mlx5/qp.c   | 168 ++++++++++++++++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h     |  14 ++-
 include/uapi/rdma/mlx5-abi.h      |  17 ++-
 4 files changed, 204 insertions(+), 5 deletions(-)

-- 
2.31.1

