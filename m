Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1588844574
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404094AbfFMQoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:44:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730433AbfFMG1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 02:27:06 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 453E72133D;
        Thu, 13 Jun 2019 06:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560407225;
        bh=F7WdlI5IPO4ttozA3F09/h1RHesljw62tPxzYaVdIy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmwcbwmRETm+VpvhTf6RaDJ8DQV6wCvQalZ7qYpXciLVyVLUdqM6RdEALHrM5HRUD
         QhhlSPbx/7fNLyyXC+qNo7qsBVzWW851ZHHRJJ79aL0dJ0SwP/THzKxofJIE9TJw3V
         ncTthaXkNNxRI+CmlCMg9Cg05vx8AsfdvAz4uD2U=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 07/12] net/mlx5: Expose device definitions for object events
Date:   Thu, 13 Jun 2019 09:26:35 +0300
Message-Id: <20190613062640.28958-8-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613062640.28958-1-leon@kernel.org>
References: <20190613062640.28958-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Expose an extra device definitions for objects events.

It includes: object_type values for legacy objects and generic data
header for any other object.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 24a814b445bb..fe3103e8ca92 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -91,6 +91,20 @@ enum {
 
 enum {
 	MLX5_OBJ_TYPE_GENEVE_TLV_OPT = 0x000b,
+	MLX5_OBJ_TYPE_MKEY = 0xff01,
+	MLX5_OBJ_TYPE_QP = 0xff02,
+	MLX5_OBJ_TYPE_PSV = 0xff03,
+	MLX5_OBJ_TYPE_RMP = 0xff04,
+	MLX5_OBJ_TYPE_XRC_SRQ = 0xff05,
+	MLX5_OBJ_TYPE_RQ = 0xff06,
+	MLX5_OBJ_TYPE_SQ = 0xff07,
+	MLX5_OBJ_TYPE_TIR = 0xff08,
+	MLX5_OBJ_TYPE_TIS = 0xff09,
+	MLX5_OBJ_TYPE_DCT = 0xff0a,
+	MLX5_OBJ_TYPE_XRQ = 0xff0b,
+	MLX5_OBJ_TYPE_RQT = 0xff0e,
+	MLX5_OBJ_TYPE_FLOW_COUNTER = 0xff0f,
+	MLX5_OBJ_TYPE_CQ = 0xff10,
 };
 
 enum {
@@ -9736,4 +9750,11 @@ struct mlx5_ifc_query_host_params_out_bits {
 	u8         reserved_at_280[0x180];
 };
 
+struct mlx5_ifc_affiliated_event_header_bits {
+	u8         reserved_at_0[0x10];
+	u8         obj_type[0x10];
+
+	u8         obj_id[0x10];
+};
+
 #endif /* MLX5_IFC_H */
-- 
2.20.1

