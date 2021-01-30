Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6603092FB
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhA3EV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 23:21:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233646AbhA3DtD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:49:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1344564E06;
        Sat, 30 Jan 2021 02:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973588;
        bh=kCCwPK8iN8tmNo/+x76rXjiNaPvgT4je+uh7bZxFD4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c85mj9LMPVCHr8AoIINpbPDACm0oA/xgJjq7oHpuaeLX0TWPKHnjwY4NQ4ARIvfoE
         0FbAr9SnHFTbrlBeOHVJhjxpdhHtuxiuUuXsPY9clLUOb3PBaY+tTrdU9TWN4Z5oZS
         k6T9/1Ju1ruOZj+mv+IVXfuOmL+JNcqvOF1N6DjnnJXuTdV8k4t2GkhmDrUW6JQgRY
         nsuueha3bUm6dU4P/ipYUa2Ly2hqtTowQz4UiyD7zxj2ysxWu1ZilCKJrvg/wQ9mB3
         WnyHXUgt9VOpmxX3bFSgQmhCGZfkP1ih/mbrMkl+MOg2I5h6CluKKFYKfnLckPujbS
         WbRWblWbrsgYw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/11] net/mlx5: DR, Add match STEv1 structs to ifc
Date:   Fri, 29 Jan 2021 18:26:09 -0800
Message-Id: <20210130022618.317351-3-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210130022618.317351-1-saeed@kernel.org>
References: <20210130022618.317351-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add mlx5_ifc_dr_ste_v1.h - a new header with HW specific
STE structs for version 1.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mlx5/core/steering/mlx5_ifc_dr_ste_v1.h   | 273 ++++++++++++++++++
 1 file changed, 273 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
new file mode 100644
index 000000000000..6db7b8493fd9
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
@@ -0,0 +1,273 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 NVIDIA CORPORATION. All rights reserved. */
+
+#ifndef MLX5_IFC_DR_STE_V1_H
+#define MLX5_IFC_DR_STE_V1_H
+
+struct mlx5_ifc_ste_eth_l2_src_v1_bits {
+	u8         reserved_at_0[0x1];
+	u8         sx_sniffer[0x1];
+	u8         functional_loopback[0x1];
+	u8         ip_fragmented[0x1];
+	u8         qp_type[0x2];
+	u8         encapsulation_type[0x2];
+	u8         port[0x2];
+	u8         l3_type[0x2];
+	u8         l4_type[0x2];
+	u8         first_vlan_qualifier[0x2];
+	u8         first_priority[0x3];
+	u8         first_cfi[0x1];
+	u8         first_vlan_id[0xc];
+
+	u8         smac_47_16[0x20];
+
+	u8         smac_15_0[0x10];
+	u8         l3_ethertype[0x10];
+
+	u8         reserved_at_60[0x6];
+	u8         tcp_syn[0x1];
+	u8         reserved_at_67[0x3];
+	u8         force_loopback[0x1];
+	u8         l2_ok[0x1];
+	u8         l3_ok[0x1];
+	u8         l4_ok[0x1];
+	u8         second_vlan_qualifier[0x2];
+
+	u8         second_priority[0x3];
+	u8         second_cfi[0x1];
+	u8         second_vlan_id[0xc];
+};
+
+struct mlx5_ifc_ste_eth_l2_dst_v1_bits {
+	u8         reserved_at_0[0x1];
+	u8         sx_sniffer[0x1];
+	u8         functional_lb[0x1];
+	u8         ip_fragmented[0x1];
+	u8         qp_type[0x2];
+	u8         encapsulation_type[0x2];
+	u8         port[0x2];
+	u8         l3_type[0x2];
+	u8         l4_type[0x2];
+	u8         first_vlan_qualifier[0x2];
+	u8         first_priority[0x3];
+	u8         first_cfi[0x1];
+	u8         first_vlan_id[0xc];
+
+	u8         dmac_47_16[0x20];
+
+	u8         dmac_15_0[0x10];
+	u8         l3_ethertype[0x10];
+
+	u8         reserved_at_60[0x6];
+	u8         tcp_syn[0x1];
+	u8         reserved_at_67[0x3];
+	u8         force_lb[0x1];
+	u8         l2_ok[0x1];
+	u8         l3_ok[0x1];
+	u8         l4_ok[0x1];
+	u8         second_vlan_qualifier[0x2];
+	u8         second_priority[0x3];
+	u8         second_cfi[0x1];
+	u8         second_vlan_id[0xc];
+};
+
+struct mlx5_ifc_ste_eth_l2_src_dst_v1_bits {
+	u8         dmac_47_16[0x20];
+
+	u8         smac_47_16[0x20];
+
+	u8         dmac_15_0[0x10];
+	u8         reserved_at_50[0x2];
+	u8         functional_lb[0x1];
+	u8         reserved_at_53[0x5];
+	u8         port[0x2];
+	u8         l3_type[0x2];
+	u8         reserved_at_5c[0x2];
+	u8         first_vlan_qualifier[0x2];
+
+	u8         first_priority[0x3];
+	u8         first_cfi[0x1];
+	u8         first_vlan_id[0xc];
+	u8         smac_15_0[0x10];
+};
+
+struct mlx5_ifc_ste_eth_l3_ipv4_5_tuple_v1_bits {
+	u8         source_address[0x20];
+
+	u8         destination_address[0x20];
+
+	u8         source_port[0x10];
+	u8         destination_port[0x10];
+
+	u8         reserved_at_60[0x4];
+	u8         l4_ok[0x1];
+	u8         l3_ok[0x1];
+	u8         fragmented[0x1];
+	u8         tcp_ns[0x1];
+	u8         tcp_cwr[0x1];
+	u8         tcp_ece[0x1];
+	u8         tcp_urg[0x1];
+	u8         tcp_ack[0x1];
+	u8         tcp_psh[0x1];
+	u8         tcp_rst[0x1];
+	u8         tcp_syn[0x1];
+	u8         tcp_fin[0x1];
+	u8         dscp[0x6];
+	u8         ecn[0x2];
+	u8         protocol[0x8];
+};
+
+struct mlx5_ifc_ste_eth_l2_tnl_v1_bits {
+	u8         l2_tunneling_network_id[0x20];
+
+	u8         dmac_47_16[0x20];
+
+	u8         dmac_15_0[0x10];
+	u8         l3_ethertype[0x10];
+
+	u8         reserved_at_60[0x3];
+	u8         ip_fragmented[0x1];
+	u8         reserved_at_64[0x2];
+	u8         encp_type[0x2];
+	u8         reserved_at_68[0x2];
+	u8         l3_type[0x2];
+	u8         l4_type[0x2];
+	u8         first_vlan_qualifier[0x2];
+	u8         first_priority[0x3];
+	u8         first_cfi[0x1];
+	u8         first_vlan_id[0xc];
+};
+
+struct mlx5_ifc_ste_eth_l3_ipv4_misc_v1_bits {
+	u8         identification[0x10];
+	u8         flags[0x3];
+	u8         fragment_offset[0xd];
+
+	u8         total_length[0x10];
+	u8         checksum[0x10];
+
+	u8         version[0x4];
+	u8         ihl[0x4];
+	u8         time_to_live[0x8];
+	u8         reserved_at_50[0x10];
+
+	u8         reserved_at_60[0x1c];
+	u8         voq_internal_prio[0x4];
+};
+
+struct mlx5_ifc_ste_eth_l4_v1_bits {
+	u8         ipv6_version[0x4];
+	u8         reserved_at_4[0x4];
+	u8         dscp[0x6];
+	u8         ecn[0x2];
+	u8         ipv6_hop_limit[0x8];
+	u8         protocol[0x8];
+
+	u8         src_port[0x10];
+	u8         dst_port[0x10];
+
+	u8         first_fragment[0x1];
+	u8         reserved_at_41[0xb];
+	u8         flow_label[0x14];
+
+	u8         tcp_data_offset[0x4];
+	u8         l4_ok[0x1];
+	u8         l3_ok[0x1];
+	u8         fragmented[0x1];
+	u8         tcp_ns[0x1];
+	u8         tcp_cwr[0x1];
+	u8         tcp_ece[0x1];
+	u8         tcp_urg[0x1];
+	u8         tcp_ack[0x1];
+	u8         tcp_psh[0x1];
+	u8         tcp_rst[0x1];
+	u8         tcp_syn[0x1];
+	u8         tcp_fin[0x1];
+	u8         ipv6_paylen[0x10];
+};
+
+struct mlx5_ifc_ste_eth_l4_misc_v1_bits {
+	u8         window_size[0x10];
+	u8         urgent_pointer[0x10];
+
+	u8         ack_num[0x20];
+
+	u8         seq_num[0x20];
+
+	u8         length[0x10];
+	u8         checksum[0x10];
+};
+
+struct mlx5_ifc_ste_mpls_v1_bits {
+	u8         reserved_at_0[0x15];
+	u8         mpls_ok[0x1];
+	u8         mpls4_s_bit[0x1];
+	u8         mpls4_qualifier[0x1];
+	u8         mpls3_s_bit[0x1];
+	u8         mpls3_qualifier[0x1];
+	u8         mpls2_s_bit[0x1];
+	u8         mpls2_qualifier[0x1];
+	u8         mpls1_s_bit[0x1];
+	u8         mpls1_qualifier[0x1];
+	u8         mpls0_s_bit[0x1];
+	u8         mpls0_qualifier[0x1];
+
+	u8         mpls0_label[0x14];
+	u8         mpls0_exp[0x3];
+	u8         mpls0_s_bos[0x1];
+	u8         mpls0_ttl[0x8];
+
+	u8         mpls1_label[0x20];
+
+	u8         mpls2_label[0x20];
+};
+
+struct mlx5_ifc_ste_gre_v1_bits {
+	u8         gre_c_present[0x1];
+	u8         reserved_at_1[0x1];
+	u8         gre_k_present[0x1];
+	u8         gre_s_present[0x1];
+	u8         strict_src_route[0x1];
+	u8         recur[0x3];
+	u8         flags[0x5];
+	u8         version[0x3];
+	u8         gre_protocol[0x10];
+
+	u8         reserved_at_20[0x20];
+
+	u8         gre_key_h[0x18];
+	u8         gre_key_l[0x8];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_ste_src_gvmi_qp_v1_bits {
+	u8         loopback_synd[0x8];
+	u8         reserved_at_8[0x7];
+	u8         functional_lb[0x1];
+	u8         source_gvmi[0x10];
+
+	u8         force_lb[0x1];
+	u8         reserved_at_21[0x1];
+	u8         source_is_requestor[0x1];
+	u8         reserved_at_23[0x5];
+	u8         source_qp[0x18];
+
+	u8         reserved_at_40[0x20];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_ste_icmp_v1_bits {
+	u8         icmp_payload_data[0x20];
+
+	u8         icmp_header_data[0x20];
+
+	u8         icmp_type[0x8];
+	u8         icmp_code[0x8];
+	u8         reserved_at_50[0x10];
+
+	u8         reserved_at_60[0x20];
+};
+
+#endif /* MLX5_IFC_DR_STE_V1_H */
-- 
2.29.2

