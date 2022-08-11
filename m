Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3919B590460
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbiHKQ36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238268AbiHKQ2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:28:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02E745046;
        Thu, 11 Aug 2022 09:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CC3FB821AC;
        Thu, 11 Aug 2022 16:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B83BC433D7;
        Thu, 11 Aug 2022 16:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234126;
        bh=w+/KY4vgCyqRiS6PUmLxZ/y/Ie+TtAymsWfEEdfKwz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gb40/fxAHqcGVFLQAqvSMSklzdrGLC6FArcZWXNJR3g9WaiCZ1g2/FOv391Sy9BsL
         9MBxUR4E5iTD32M0MvIZ4WCtfpKlbhceq39szp1cuCS2pGG6HZ2OIMr97KijOBRo98
         dN65vjLSnT9xD4Z9Jo3KtBl4CT7uNYaUalSwdkf+vLM5CmBP58Wap/lvvdpeDwoqd/
         Tm6vGmed42PWCZAJqBH55hf+m1K8Xf5Rev1hrlCiePLsTLGwQL4aBj+AAEmxxa4k75
         zGCGjbJowPKLlXrLWVUbFN3i3wR9qdCaDriWtuzL6vKmKvypO2hjrO61eFkKwjmKZp
         NuHnwD7eVZ4Hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/25] net/mlx5: Add HW definitions of vport debug counters
Date:   Thu, 11 Aug 2022 12:08:05 -0400
Message-Id: <20220811160826.1541971-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160826.1541971-1-sashal@kernel.org>
References: <20220811160826.1541971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit 3e94e61bd44d90070dcda53b647fdc826097ef26 ]

total_q_under_processor_handle - number of queues in error state due to an
async error or errored command.

send_queue_priority_update_flow - number of QP/SQ priority/SL update
events.

cq_overrun - number of times CQ entered an error state due to an
overflow.

async_eq_overrun -number of time an EQ mapped to async events was
overrun.

comp_eq_overrun - number of time an EQ mapped to completion events was
overrun.

quota_exceeded_command - number of commands issued and failed due to quota
exceeded.

invalid_command - number of commands issued and failed dues to any reason
other than quota exceeded.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 031022e32635..e132609c3269 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1188,7 +1188,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_120[0xa];
 	u8         log_max_ra_req_dc[0x6];
-	u8         reserved_at_130[0xa];
+	u8         reserved_at_130[0x9];
+	u8         vnic_env_cq_overrun[0x1];
 	u8         log_max_ra_res_dc[0x6];
 
 	u8         reserved_at_140[0xa];
@@ -1367,7 +1368,11 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         nic_receive_steering_discard[0x1];
 	u8         receive_discard_vport_down[0x1];
 	u8         transmit_discard_vport_down[0x1];
-	u8         reserved_at_343[0x5];
+	u8         eq_overrun_count[0x1];
+	u8         reserved_at_344[0x1];
+	u8         invalid_command_count[0x1];
+	u8         quota_exceeded_count[0x1];
+	u8         reserved_at_347[0x1];
 	u8         log_max_flow_counter_bulk[0x8];
 	u8         max_flow_counter_15_0[0x10];
 
@@ -2890,11 +2895,21 @@ struct mlx5_ifc_vnic_diagnostic_statistics_bits {
 
 	u8         transmit_discard_vport_down[0x40];
 
-	u8         reserved_at_140[0xa0];
+	u8         async_eq_overrun[0x20];
+
+	u8         comp_eq_overrun[0x20];
+
+	u8         reserved_at_180[0x20];
+
+	u8         invalid_command[0x20];
+
+	u8         quota_exceeded_command[0x20];
 
 	u8         internal_rq_out_of_buffer[0x20];
 
-	u8         reserved_at_200[0xe00];
+	u8         cq_overrun[0x20];
+
+	u8         reserved_at_220[0xde0];
 };
 
 struct mlx5_ifc_traffic_counter_bits {
-- 
2.35.1

