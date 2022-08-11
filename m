Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46195903BA
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbiHKQYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237860AbiHKQXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:23:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1ED1144E;
        Thu, 11 Aug 2022 09:05:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19F8CB82123;
        Thu, 11 Aug 2022 16:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC07C433C1;
        Thu, 11 Aug 2022 16:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233916;
        bh=oxr8ZUJO9aysC9EUSeeMWhFCCQ44WU/CjI3XHIhaM7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNrNLNsdlYfHkwUiSFXOEvhgtvPEsY7AkFRX0e1bfEEhEpT2xMLfNzDAcP3mZn8iP
         w5VBu7Af/6ddPrdoH80G0Ng0whR6tCS6DKHcQ1HPmJPO+SdbXCQSYwv+4SsydpcY5E
         vjgRscwNuiDYgKJCMoZNnaJmm/rpGPDaeLxILKdONfsCzJNwE98d4OjO5LE/lcyNNF
         JhMYw7rqJWBYubZG9kR86JDO/Qn/BmFDoWD+5CPn9n+ldF7dTZh/dtWt38COIPkio9
         susVvD/JFS51fy/NJYaTVgzC/A7+ic5P2mmQcyM0gQuaoAz+KVkYHGGGkzwG2HYg5T
         WyiIRJGPxSwBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/46] net/mlx5: Add HW definitions of vport debug counters
Date:   Thu, 11 Aug 2022 12:03:37 -0400
Message-Id: <20220811160421.1539956-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
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
index 6ca97729b54a..4276677ecdb5 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1282,7 +1282,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_120[0xa];
 	u8         log_max_ra_req_dc[0x6];
-	u8         reserved_at_130[0xa];
+	u8         reserved_at_130[0x9];
+	u8         vnic_env_cq_overrun[0x1];
 	u8         log_max_ra_res_dc[0x6];
 
 	u8         reserved_at_140[0x6];
@@ -1472,7 +1473,11 @@ struct mlx5_ifc_cmd_hca_cap_bits {
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
 
@@ -3128,11 +3133,21 @@ struct mlx5_ifc_vnic_diagnostic_statistics_bits {
 
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

