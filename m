Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3943785D21
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 10:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbfHHIoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 04:44:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730678AbfHHIoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 04:44:13 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BD80217D7;
        Thu,  8 Aug 2019 08:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565253852;
        bh=SIfM/mRJMEXLrkcEjwtTVleq8Ukx+/D0BVY1fGIEz7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBoNYV4D9Dm1KvBCbIPdGTJ/zF5nd2hLM9mC49KqudeUkMdJXyTvhwgYubATdOOJg
         b8RjEIPExwdw6zSyZMfJ0zBjUsAONvXy8BnMnrEnHYZO9y0st0Z/boK8T4hYCY7MdC
         cmT1lnR/C0AlYC0v9EJzoDeSdNPAntyFC7X3Kn3s=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Edward Srouji <edwards@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 4/4] IB/mlx5: Expose XRQ legacy commands over the DEVX interface
Date:   Thu,  8 Aug 2019 11:43:58 +0300
Message-Id: <20190808084358.29517-5-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808084358.29517-1-leon@kernel.org>
References: <20190808084358.29517-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Expose missing XRQ legacy commands over the DEVX interface.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 3dbdfe0eb5e4..04b4e937c198 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -546,6 +546,8 @@ static u64 devx_get_obj_id(const void *in)
 		break;
 	case MLX5_CMD_OP_ARM_XRQ:
 	case MLX5_CMD_OP_SET_XRQ_DC_PARAMS_ENTRY:
+	case MLX5_CMD_OP_RELEASE_XRQ_ERROR:
+	case MLX5_CMD_OP_MODIFY_XRQ:
 		obj_id = get_enc_obj_id(MLX5_CMD_OP_CREATE_XRQ,
 					MLX5_GET(arm_xrq_in, in, xrqn));
 		break;
@@ -822,6 +824,8 @@ static bool devx_is_obj_modify_cmd(const void *in)
 	case MLX5_CMD_OP_ARM_DCT_FOR_KEY_VIOLATION:
 	case MLX5_CMD_OP_ARM_XRQ:
 	case MLX5_CMD_OP_SET_XRQ_DC_PARAMS_ENTRY:
+	case MLX5_CMD_OP_RELEASE_XRQ_ERROR:
+	case MLX5_CMD_OP_MODIFY_XRQ:
 		return true;
 	case MLX5_CMD_OP_SET_FLOW_TABLE_ENTRY:
 	{
-- 
2.20.1

