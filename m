Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8438C582003
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiG0GYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiG0GYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:24:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA31E402E0
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:24:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=makZDgz9Fm+XiIav3Q1hrktPtyuUxVqR5pmwpKOZNlyKmJt47N9y+BtRI94aUlQMKLqfhVhp24Os5IHEOD4tR0X7dhjzh0DxLSRaIY4cP3yZqSbQuDInk8sadGPxEjB3rFVOTYm50vkyCX0hmk8WaWJ9wVq789VxdTxQF4whRM/aGdqJkYwGGJBePtlECQbhKFZRGziro39R6nXw1UNOGx6lX+uRlV4NdAis+TJ8m0CUXylVkG8apD1Ta13LnbRm3ID5DxCCAhQGHHJtE73nSnZo7VtUEHT7Kl0OF7721ECfIJVOpF7k5miHVgQ7AnLzh21nboSnXKVMzayZJDb1YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEn8dlGAbeOzExDMZg3dy8i8ueh42ELCq5PiyWJhzn0=;
 b=Sl9X07nohZuYpQHcyjT2EYQFrsIFJXsXAaATvCZ4HwygobcgTR16C9A2LOi5cJhkrw8e5RdOUqiXIHL0VZ9FtBqSHqCvY9E7IueN1ZYj+PBgSX+wmj5YPgLjv0WrBWxBFPyx0TVyMUj9fIj1LZVbyebP26praAVkQ3ybKWCXYZmVy7dMHkzO9ihcBi9FHiobx2At78bQWGhdAtXwUAXGaluPVomUDAosOG64bQY/JWRwlv9BfoBYU6ctJp3B9d6cIKwXD09+lQikOI+rjIAZ3cDD5adh6iZeyFaTTXoDTQsQULg+VOMhlcKMax0WVYsyEKyEqm8BmqwhyJOKj5Y2Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEn8dlGAbeOzExDMZg3dy8i8ueh42ELCq5PiyWJhzn0=;
 b=XUOD+x0L/TosA4CGkiAwn1UWwkKaBBpy8DsdxWoCP6OtF83YHv5VKHL/XSjvqwtjp5jom2IPoLJye+AbUd08qv+c9i/YDBp9XtacVHplyBiKQn0lpNY7CplAkmi0ukXyY0lRIbZO8FouQEBffXnqVT6BDcHPmGHhf7fKzULeAFUuqgCRMMtvplyF72IuctMsPYzJMPaQizn9jPktKcEJsXYCxYxOW+bRJZoZra0tFlVnmCcm8KRyjot9iTWuUt4IpCRfM4JNahmNtWjJDv2UH2f4WNHQsrNSrnWVkWpE0/1Wml0QaVPjxfCV0sBdPW4L6tvRkmvmNcnnp9kXE/8N+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 27 Jul
 2022 06:24:05 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 06:24:04 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, richardcochran@gmail.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/9] mlxsw: spectrum_ptp: Add helper functions to configure PTP traps
Date:   Wed, 27 Jul 2022 09:23:20 +0300
Message-Id: <20220727062328.3134613-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727062328.3134613-1-idosch@nvidia.com>
References: <20220727062328.3134613-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0004.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 730f6ed0-2f0b-4040-348e-08da6f989ab7
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6243:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fh2Wh9s4DoV/dGJB8bORI2kEOMPWpZSbKADlBb9Qj3DXcRsdSNshpI0kvw+fv/9e0I6ahB9UVz+Fz2m2p9tOVgCRjQuG4XxBs4rl6UtKPyP5nZ4dwlDW9k2G/uXJ4UQEXpfYyX8hJGD5LQ9vBaTE03yJzbi1tg7jjfg/JkSQ5b96ZhB5SDgFkA70/1WI/GWNmkCqoOnsMkEmwfmPjRRSZrVExHWxPAcK+MBgvMIQHaqWYHDshMwRHlXXu0xq2tE+evI/RLKF28SpBiFS4ABklrY5O2U7tnYxHbzT+RobG1fhoUyzx0cBZcW8v7c1YR9RANDWkP5mqHnkbNsLrEQ/dkIfeZ6MRcWMYr5RctS6CeIQfC92ggYtHJGKEZfJ9NyZi0lugy/syufsrHJJOQMTqDMU65TYf4oQamZEaf8R1/SOGI9rLqXg0ut3f/oi2Xx3b7dOr/sNSTIzM74WLqX/T5ML9QSRpLyNdXrHO/HLXC+2qBWnHpM1sMLzMh7V4Q0dSauMgC+zZXBoK1gKt36KhyXoN1FC6boH0MsF3S+pbOAe+uEeNhG+2HGk0jOLcbbmR4ZqjZAKyLAMWkLbyIGUwoby9+TfTr0lhzd6OIsJW4ZE8wPXtLuDYwFNV5XpxGk7J10MrhsIQsEVVCpnwvsYYq2U5eN1IcnTFEw4sqvD3bf/mKTwdZDICZWeyWeLssjnq8q8Pa5rNDeEUEvJUB2+7ncXCtxlsDtkz+tBk8PCAZk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(41300700001)(66476007)(38100700002)(6486002)(2616005)(66946007)(1076003)(107886003)(478600001)(6506007)(186003)(6666004)(8676002)(83380400001)(26005)(6916009)(8936002)(2906002)(5660300002)(316002)(86362001)(4326008)(36756003)(6512007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LkWAkRtt57avxdPoBaghRlW5Lmn/YvtC4uZWLTJ1aYBY+EQPG40egaRKKudX?=
 =?us-ascii?Q?ou54fUll4mIUOg417PKfdwF6JDuDxkVB1jT8zMAjZOxBi1XQtW8LhmbOMM2n?=
 =?us-ascii?Q?AW6JT+uayhgYMSgxVwaZOfjw0DMsKGCvqvafEyaVlcPEDU4IdA/HMtzcvSmi?=
 =?us-ascii?Q?SSChCrRMTBGXRRZW3g+IEusV3XOnMSX1BJnmdG9hQdsK26VpYGRZ3FwZjLTU?=
 =?us-ascii?Q?G7hGGMAeAf0Jz6rIwT5W+ff4lQ3TbjK5mWGbjPRS8NM8OjXUx0QJ1nIjnAcv?=
 =?us-ascii?Q?K+udVs4zF8jGs8hpFCnV9ezyegFk5hNok/rark9xuk2VSpa27vdK3EVx10RE?=
 =?us-ascii?Q?s8Tfwebnz2gkQ1vdRyzp5EiQ8sScS8llsjvngj1BcgMWGIQul622bBelXHjL?=
 =?us-ascii?Q?04kTZw/D1fg+jiJAyA9Mozrg9EUOvm93K+pd6gQ+/7QMS8KJsCSlVQHee635?=
 =?us-ascii?Q?QzIK9VGJugHs0dWL+2uW4pzvadXokoOqT4dx39jtoPrOk8LKL1tyNER7D19c?=
 =?us-ascii?Q?z/ACbf9KGQ40+IBhqn47A7XFgkCb6u7j6ICIlkDx7vHjpsHzvCqWoCLfjd01?=
 =?us-ascii?Q?y2F339OGjNum/jzUf/zmf4irnFbADWLcN8n3ybB07SBLWxoteeSWfdxXxDQX?=
 =?us-ascii?Q?sY6fRhIFZtLsfF8NWBpTthGvQik+ROAIml3qlzO7/xtXUKijltsGOopqaODG?=
 =?us-ascii?Q?0FNJjwKA9x0OapL5EUZjb5QHe6HR5c2qu2tz8dNC2Y667qzxXPffum6XIowy?=
 =?us-ascii?Q?PiF1rRp1D3O7llFNsjen+i7UkiqODcAbQNKI0L3fa5x+Y86SNOKDacovYC30?=
 =?us-ascii?Q?1XL/F9IMI2i64hMaDRW40fdCJ94CNsDd5vXteDiNgm2U7BjTDmC3ABQ87H+G?=
 =?us-ascii?Q?4fH8RkrqhvqGBfUpzvZkNbrCtQZpic84RupTMags8bEihnFHlLLqytZKLL9h?=
 =?us-ascii?Q?qxfO1+7CVgbr/SpI1suAK1dNXPgUkQCWVR+auVWHKJuPES4P/GQYsD4BidYQ?=
 =?us-ascii?Q?5voYRXvVP7QDRN8FJ7TUy2qATFJisNhupPnUX24gHVsfnRvGauFcjDaA+01R?=
 =?us-ascii?Q?Wemr8YnZeGuZFftRqLER2IkegzdanygUUD//3MJhRcJgNIefj+5ILfV3nPWJ?=
 =?us-ascii?Q?7KBG7F4qtRQPYb6h2rDy0A40IKcXh50PwYka+UJ8UDT+NMUntho3LiNvfAYd?=
 =?us-ascii?Q?x4adbHGkqw/nEq6Vi9da+D30bjY95JmRzac3Ss2ivDXlnPWqhlx8VcYWrWQz?=
 =?us-ascii?Q?SSe3De18Ahqzt1NJSIgizAVMAttUAO7bGgCdKJXcDpXlHiRnbXU+12PJsU37?=
 =?us-ascii?Q?jDkRFnOWd9M86a54utgWNEkiDKwz66wkj5E6zNRFjjD/kj/RV758oJtTpwyr?=
 =?us-ascii?Q?kxw9D2ePwm8yjcB4uLxA3EihdI4aouOSCEQvkFk5H0HdeLn+ex+uXMEf1Oie?=
 =?us-ascii?Q?g0fPnKdxgMVhMqKWX3Ne1ABCNiVou5qBCxXUVtAMFtiiXoEqfOMH+j37a/C3?=
 =?us-ascii?Q?T/qmOVX0eX63i4SMPZEToeFSMmgQxjXBYn4TQOeEe7GkwIpwGfcM20sg/Xnf?=
 =?us-ascii?Q?zQ7r2GpBpfGYDBW+joqnJ15wDx+cMUL1rH92KO5L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 730f6ed0-2f0b-4040-348e-08da6f989ab7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 06:24:04.8538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4e4Is+rsjPbyRvvsBvfuaYINnd7qAibcq6Fzsvt6kLmSySOk24M05R5NAFufJWhY2QER0jSI+IRmL1LFe/RyVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

MTPTPT register is used to set which message types should arrive under
which PTP trap. Currently, PTP0 is used for event message types, which
means that the packets require time stamp. PTP1 is used for other packets.

This configuration will be same for Spectrum-2 and newer ASICs. In
preparation for Spectrum-2 PTP support, add helper functions to
configure PTP traps and use them for Spectrum-1. These functions will be
used later also for Spectrum-2.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 62 ++++++++++++-------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 5116d7ebe258..ec6d046a1f2b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -835,10 +835,44 @@ static int mlxsw_sp1_ptp_shaper_params_set(struct mlxsw_sp *mlxsw_sp)
 	return 0;
 }
 
+static int mlxsw_sp_ptp_traps_set(struct mlxsw_sp *mlxsw_sp)
+{
+	u16 event_message_type;
+	int err;
+
+	/* Deliver these message types as PTP0. */
+	event_message_type = BIT(PTP_MSGTYPE_SYNC) |
+			     BIT(PTP_MSGTYPE_DELAY_REQ) |
+			     BIT(PTP_MSGTYPE_PDELAY_REQ) |
+			     BIT(PTP_MSGTYPE_PDELAY_RESP);
+
+	err = mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0,
+				      event_message_type);
+	if (err)
+		return err;
+
+	/* Everything else is PTP1. */
+	err = mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP1,
+				      ~event_message_type);
+	if (err)
+		goto err_mtptpt1_set;
+
+	return 0;
+
+err_mtptpt1_set:
+	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0, 0);
+	return err;
+}
+
+static void mlxsw_sp_ptp_traps_unset(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP1, 0);
+	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0, 0);
+}
+
 struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp1_ptp_state *ptp_state;
-	u16 message_type;
 	int err;
 
 	err = mlxsw_sp1_ptp_shaper_params_set(mlxsw_sp);
@@ -857,22 +891,9 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		goto err_hashtable_init;
 
-	/* Delive these message types as PTP0. */
-	message_type = BIT(PTP_MSGTYPE_SYNC) |
-		       BIT(PTP_MSGTYPE_DELAY_REQ) |
-		       BIT(PTP_MSGTYPE_PDELAY_REQ) |
-		       BIT(PTP_MSGTYPE_PDELAY_RESP);
-	err = mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0,
-				      message_type);
-	if (err)
-		goto err_mtptpt_set;
-
-	/* Everything else is PTP1. */
-	message_type = ~message_type;
-	err = mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP1,
-				      message_type);
+	err = mlxsw_sp_ptp_traps_set(mlxsw_sp);
 	if (err)
-		goto err_mtptpt1_set;
+		goto err_ptp_traps_set;
 
 	err = mlxsw_sp1_ptp_set_fifo_clr_on_trap(mlxsw_sp, true);
 	if (err)
@@ -884,10 +905,8 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 	return &ptp_state->common;
 
 err_fifo_clr:
-	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP1, 0);
-err_mtptpt1_set:
-	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0, 0);
-err_mtptpt_set:
+	mlxsw_sp_ptp_traps_unset(mlxsw_sp);
+err_ptp_traps_set:
 	rhltable_destroy(&ptp_state->unmatched_ht);
 err_hashtable_init:
 	kfree(ptp_state);
@@ -904,8 +923,7 @@ void mlxsw_sp1_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state_common)
 	cancel_delayed_work_sync(&ptp_state->ht_gc_dw);
 	mlxsw_sp1_ptp_mtpppc_set(mlxsw_sp, 0, 0);
 	mlxsw_sp1_ptp_set_fifo_clr_on_trap(mlxsw_sp, false);
-	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP1, 0);
-	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0, 0);
+	mlxsw_sp_ptp_traps_unset(mlxsw_sp);
 	rhltable_free_and_destroy(&ptp_state->unmatched_ht,
 				  &mlxsw_sp1_ptp_unmatched_free_fn, NULL);
 	kfree(ptp_state);
-- 
2.36.1

