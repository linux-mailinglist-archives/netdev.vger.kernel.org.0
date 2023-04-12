Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC816DEA2D
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjDLEIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjDLEIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BAC526F
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A711762DAF
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F170FC4339B;
        Wed, 12 Apr 2023 04:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272491;
        bh=ur2fieG9igI7SIYfbcenD6pQvds9yIlt5XkEZoVkq60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzTqGwMiGTyDL2xHTVtyWUlPnOdF+Xwr9xPAi63wwR4OhLaH7FJohYeh6kYL2kJ3V
         JPeFDFrHgCQMXbKxjTEBwxkqA/cDwCFnfCMc9oVZ0MKnEb9x60Eaay6y4YgxzNFDbp
         jUJ651nOJjzdDfO5fRxKzO4EVWOTJ8PTqn8LFk86G4HMG3R8fLbwR2M/jNMSugWMUM
         f7ZLNHqynP2T75nyWfGBw5rguM5YL3ophcB211brnGPZYRpTL1csC5XBSUBvwk6t+r
         MqmHNsSkUvzmq5Ge4bXu0nEU7aUWLW0ebODH/wZzQ/EC0U02HDr7VoSKs+RLX8lKxR
         XdY/bm6vZUUOw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 12/15] net/mlx5: Add mlx5_ifc bits for modify header argument
Date:   Tue, 11 Apr 2023 21:07:49 -0700
Message-Id: <20230412040752.14220-13-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add enum value for modify-header argument object and mlx5_bits
for the related capabilities.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 02c628f4fe26..6c84bf6eec85 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -78,12 +78,15 @@ enum {
 
 enum {
 	MLX5_OBJ_TYPE_SW_ICM = 0x0008,
+	MLX5_OBJ_TYPE_HEADER_MODIFY_ARGUMENT  = 0x23,
 };
 
 enum {
 	MLX5_GENERAL_OBJ_TYPES_CAP_SW_ICM = (1ULL << MLX5_OBJ_TYPE_SW_ICM),
 	MLX5_GENERAL_OBJ_TYPES_CAP_GENEVE_TLV_OPT = (1ULL << 11),
 	MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q = (1ULL << 13),
+	MLX5_GENERAL_OBJ_TYPES_CAP_HEADER_MODIFY_ARGUMENT =
+		(1ULL << MLX5_OBJ_TYPE_HEADER_MODIFY_ARGUMENT),
 	MLX5_GENERAL_OBJ_TYPES_CAP_MACSEC_OFFLOAD = (1ULL << 39),
 };
 
@@ -321,6 +324,10 @@ enum {
 	MLX5_FT_NIC_TX_RDMA_2_NIC_TX = BIT(1),
 };
 
+enum {
+	MLX5_CMD_OP_MOD_UPDATE_HEADER_MODIFY_ARGUMENT = 0x1,
+};
+
 struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         outer_dmac[0x1];
 	u8         outer_smac[0x1];
@@ -1927,7 +1934,14 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8	   reserved_at_750[0x4];
 	u8	   max_dynamic_vf_msix_table_size[0xc];
 
-	u8	   reserved_at_760[0x20];
+	u8         reserved_at_760[0x3];
+	u8         log_max_num_header_modify_argument[0x5];
+	u8         reserved_at_768[0x4];
+	u8         log_header_modify_argument_granularity[0x4];
+	u8         reserved_at_770[0x3];
+	u8         log_header_modify_argument_max_alloc[0x5];
+	u8         reserved_at_778[0x8];
+
 	u8	   vhca_tunnel_commands[0x40];
 	u8         match_definer_format_supported[0x40];
 };
@@ -6361,6 +6375,18 @@ struct mlx5_ifc_general_obj_out_cmd_hdr_bits {
 	u8         reserved_at_60[0x20];
 };
 
+struct mlx5_ifc_modify_header_arg_bits {
+	u8         reserved_at_0[0x80];
+
+	u8         reserved_at_80[0x8];
+	u8         access_pd[0x18];
+};
+
+struct mlx5_ifc_create_modify_header_arg_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits hdr;
+	struct mlx5_ifc_modify_header_arg_bits arg;
+};
+
 struct mlx5_ifc_create_match_definer_in_bits {
 	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
 
-- 
2.39.2

