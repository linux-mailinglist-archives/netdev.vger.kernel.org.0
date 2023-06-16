Return-Path: <netdev+bounces-11599-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF6DF733A96
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A509280FDE
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B724C21094;
	Fri, 16 Jun 2023 20:11:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEFB1ED58
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76D9C43391;
	Fri, 16 Jun 2023 20:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946303;
	bh=JuZNFcnPdoXVS74ulj6g1WB49hzDZsU4venUd0KcTAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2TRydo456wiPVPVgp+1hf/NzyUESHI5WYoMT3qqMB9IWfELvr1Aod0mlHdypv42h
	 206rP9FPKUJCh+1NSLBp3x5+3ny/CwE0ymRmfNsyfz7IRkaLXZKDM9mrt2LSaI9J0m
	 CF8D19MlEqW1KYA5eKd0u235XLJZBxpVHY5nnH6Z0PiQ2pl8S4KpNa/6RIiVvx8a4X
	 NrUF6kPRDMilXjfdy/yRBHutLD0A16xwd29truTGzgyeaxRFZm84rpppHCKHPCsCPo
	 MAfUPKY7hHa4vfDA5Uu95722no0OZ6tpNZYvAy9lrHHv1tphqHU1/lduqjjYCvqECr
	 DWE/EChlAp8vw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Avihai Horon <avihaih@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [net-next 10/15] net/mlx5: Expose bits for local loopback counter
Date: Fri, 16 Jun 2023 13:11:08 -0700
Message-Id: <20230616201113.45510-11-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616201113.45510-1-saeed@kernel.org>
References: <20230616201113.45510-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Or Har-Toov <ohartoov@nvidia.com>

Add needed HW bits for querying local loopback counter and the
HCA capability for it.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index d61dcb5d7cd5..354c7e326eab 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1758,7 +1758,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_330[0x6];
 	u8         pci_sync_for_fw_update_with_driver_unload[0x1];
 	u8         vnic_env_cnt_steering_fail[0x1];
-	u8         reserved_at_338[0x1];
+	u8         vport_counter_local_loopback[0x1];
 	u8         q_counter_aggregation[0x1];
 	u8         q_counter_other_vport[0x1];
 	u8         log_max_xrcd[0x5];
@@ -5190,7 +5190,9 @@ struct mlx5_ifc_query_vport_counter_out_bits {
 
 	struct mlx5_ifc_traffic_counter_bits transmitted_eth_multicast;
 
-	u8         reserved_at_680[0xa00];
+	struct mlx5_ifc_traffic_counter_bits local_loopback;
+
+	u8         reserved_at_700[0x980];
 };
 
 enum {
-- 
2.40.1


