Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3772BB9A4
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgKTXE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:04:28 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12665 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728155AbgKTXEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:04:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b690005>; Fri, 20 Nov 2020 15:04:09 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:03:58 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Alex Vesker <valex@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 04/16] net/mlx5: Add misc4 to mlx5_ifc_fte_match_param_bits
Date:   Fri, 20 Nov 2020 15:03:27 -0800
Message-ID: <20201120230339.651609-5-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120230339.651609-1-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605913449; bh=0ygG9xHlGbd94CUrhE8wDyvShO52PTPVkpF1sIdvU18=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=hhOLu8jTakbxhTcz+vt4/k/t7iDqeWEnv21qccYALdVZtpHCgOJ7lSU0uiXlXhyOw
         UCyomiSSAuxNMa+1GscBYqL0GY6hI1995SWzDyrW3I2KutGPMJPAcHWvmvj/nm5Djh
         xVk61sqV32vmIgAhAgBKu+CgpzctEQRhjAc7MoU8mDMFXucyxqB6sDHd+5pocRWGUx
         r+UY+ejDz8BgQmokZqRMF1bIDBr9MJwmPdtwRq4c/THq0N0W9NonT9Wl0Ih4vWLhtd
         bgOjfxHDWT2EtGVqzZFIogPi1zoYdd7IcItt5wIPMdH/7dsQc74/K9BOw2FTx8yEoN
         bvo47uttxK+NA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Sammar <muhammads@nvidia.com>

Add misc4 match params to enable matching on prog_sample_fields.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  2 +-
 include/linux/mlx5/device.h                   |  1 +
 include/linux/mlx5/mlx5_ifc.h                 | 25 ++++++++++++++++++-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h      |  2 +-
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.h
index afe7f0bffb93..b24a9849c45e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -194,7 +194,7 @@ struct mlx5_ft_underlay_qp {
 	u32 qpn;
 };
=20
-#define MLX5_FTE_MATCH_PARAM_RESERVED	reserved_at_a00
+#define MLX5_FTE_MATCH_PARAM_RESERVED	reserved_at_c00
 /* Calculate the fte_match_param length and without the reserved length.
  * Make sure the reserved field is the last.
  */
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index cf824366a7d1..e9639c4cf2ed 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1076,6 +1076,7 @@ enum {
 	MLX5_MATCH_INNER_HEADERS	=3D 1 << 2,
 	MLX5_MATCH_MISC_PARAMETERS_2	=3D 1 << 3,
 	MLX5_MATCH_MISC_PARAMETERS_3	=3D 1 << 4,
+	MLX5_MATCH_MISC_PARAMETERS_4	=3D 1 << 5,
 };
=20
 enum {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 2f2add4bd5e1..11c24fafd7f2 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -623,6 +623,26 @@ struct mlx5_ifc_fte_match_set_misc3_bits {
 	u8         reserved_at_140[0xc0];
 };
=20
+struct mlx5_ifc_fte_match_set_misc4_bits {
+	u8         prog_sample_field_value_0[0x20];
+
+	u8         prog_sample_field_id_0[0x20];
+
+	u8         prog_sample_field_value_1[0x20];
+
+	u8         prog_sample_field_id_1[0x20];
+
+	u8         prog_sample_field_value_2[0x20];
+
+	u8         prog_sample_field_id_2[0x20];
+
+	u8         prog_sample_field_value_3[0x20];
+
+	u8         prog_sample_field_id_3[0x20];
+
+	u8         reserved_at_100[0x100];
+};
+
 struct mlx5_ifc_cmd_pas_bits {
 	u8         pa_h[0x20];
=20
@@ -1669,7 +1689,9 @@ struct mlx5_ifc_fte_match_param_bits {
=20
 	struct mlx5_ifc_fte_match_set_misc3_bits misc_parameters_3;
=20
-	u8         reserved_at_a00[0x600];
+	struct mlx5_ifc_fte_match_set_misc4_bits misc_parameters_4;
+
+	u8         reserved_at_c00[0x400];
 };
=20
 enum {
@@ -5462,6 +5484,7 @@ enum {
 	MLX5_QUERY_FLOW_GROUP_OUT_MATCH_CRITERIA_ENABLE_INNER_HEADERS    =3D 0x2,
 	MLX5_QUERY_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS_2 =3D 0x3,
 	MLX5_QUERY_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS_3 =3D 0x4,
+	MLX5_QUERY_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS_4 =3D 0x5,
 };
=20
 struct mlx5_ifc_query_flow_group_out_bits {
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/m=
lx5_user_ioctl_cmds.h
index e24d66d278cf..3fd9b380a091 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -232,7 +232,7 @@ enum mlx5_ib_device_query_context_attrs {
 	MLX5_IB_ATTR_QUERY_CONTEXT_RESP_UCTX =3D (1U << UVERBS_ID_NS_SHIFT),
 };
=20
-#define MLX5_IB_DW_MATCH_PARAM 0x80
+#define MLX5_IB_DW_MATCH_PARAM 0x90
=20
 struct mlx5_ib_match_params {
 	__u32	match_params[MLX5_IB_DW_MATCH_PARAM];
--=20
2.26.2

