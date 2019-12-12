Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF4A11CBE3
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 12:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbfLLLJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 06:09:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728613AbfLLLJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 06:09:36 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 536AB2173E;
        Thu, 12 Dec 2019 11:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576148975;
        bh=MvisZKE3fQ9pCAz1fK6Id/ZEvkKfYo8rpMJV8XdDzG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11D6+dLlaU8ojcrOZ0mLr0KkmOou0RsJ+RQ2Va+xbgpcvTmiqdxVDkn+UF53eAASy
         /lPRTcKNcU0vUVFR8rU06Qo6kbVztNBU98YYusgmyEecQ/oQa3DJ6JW67CQ9B9iOb3
         U1wFzXJXS17ZYRjZJn/ntaYi2hSwTiaYkMZqKtMs=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Shahaf Shuler <shahafs@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 1/5] net/mlx5: Add Virtio Emulation related device capabilities
Date:   Thu, 12 Dec 2019 13:09:24 +0200
Message-Id: <20191212110928.334995-2-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191212110928.334995-1-leon@kernel.org>
References: <20191212110928.334995-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Add Virtio Emulation related fields to the device capabilities.

It includes a general bit to indicate whether Virtio Emulation is
supported and the capabilities structure itself.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Shahaf Shuler <shahafs@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5d54fccf87fc..c6abaf4f1c55 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -87,6 +87,7 @@ enum {
 enum {
 	MLX5_GENERAL_OBJ_TYPES_CAP_SW_ICM = (1ULL << MLX5_OBJ_TYPE_SW_ICM),
 	MLX5_GENERAL_OBJ_TYPES_CAP_GENEVE_TLV_OPT = (1ULL << 11),
+	MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q = (1ULL << 13),
 };
 
 enum {
@@ -953,6 +954,19 @@ struct mlx5_ifc_device_event_cap_bits {
 	u8         user_unaffiliated_events[4][0x40];
 };
 
+struct mlx5_ifc_device_virtio_emulation_cap_bits {
+	u8         reserved_at_0[0x20];
+
+	u8         reserved_at_20[0x13];
+	u8         log_doorbell_stride[0x5];
+	u8         reserved_at_38[0x3];
+	u8         log_doorbell_bar_size[0x5];
+
+	u8         doorbell_bar_offset[0x40];
+
+	u8         reserved_at_80[0x780];
+};
+
 enum {
 	MLX5_ATOMIC_CAPS_ATOMIC_SIZE_QP_1_BYTE     = 0x0,
 	MLX5_ATOMIC_CAPS_ATOMIC_SIZE_QP_2_BYTES    = 0x2,
@@ -2751,6 +2765,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_fpga_cap_bits fpga_cap;
 	struct mlx5_ifc_tls_cap_bits tls_cap;
 	struct mlx5_ifc_device_mem_cap_bits device_mem_cap;
+	struct mlx5_ifc_device_virtio_emulation_cap_bits virtio_emulation_cap;
 	u8         reserved_at_0[0x8000];
 };
 
-- 
2.20.1

