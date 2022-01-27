Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E01249DD3C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238134AbiA0JD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:03:28 -0500
Received: from mail-bn7nam10on2083.outbound.protection.outlook.com ([40.107.92.83]:9601
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238164AbiA0JD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 04:03:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pt27uwc0uk5ewsbbof7pjnIPhhydrl4sYAQE05TCNIcIQ3LKOP9PHCBc8GhD1FRUS/e7vYQObqPJaWvzX7RmGBEunXzT6U9oFEfe9EZMJLav46dSjaRQB2VwC2gcxnDYQBM1ffJ0Gl/vdna9P7eufNIC7NlC/B8HIsw93DpYv6lw8nUpduTV/dE4vnpfCWukn/MfV5V9cIQDytV2CwnEuZAJfr4R7bxJVpYhYEEREwcCUZd7f0g8I/CuA9r+KT/Z+98/me8RGEER6O+uSB0QsKDULu62hhBG7W1sJecW7iipQ86w9XgIgQvdWgRE9hzYmo12BpbynFv/aEI09qHjAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dyIslcu4MyhucKFA8YbijSdiZPFSzMRGL9LSpC72x8M=;
 b=PW0H7m8H7BoB2n7UnCOsHZ0F23C4fMW694XtBm1EKjIqbAbbGUSb92hIZdXSTDdEPhsyQpOK0BAa5mlEbFjUwFV0v0LgcfLgOnAGsgosx4PDYHPoHW/49mQQ6k2PQaPwcTAxCOSNGpwaepvHwVdN2BRh7ime7DMiEDbuHNber0uZPlIcjjBjwgJzCVPkIwhCB7po479U30ygxj9uu5zADyWY4Y4I5lZ/snI1GGBHOmTyaICzst5zZfxlizzH7lvlClWVHLEk723eWdXdmYEjN+Vc5Ktlr0iSyOOBinmmBnnG6T3xgoy+5xG07aCOGdbiUCMpAuOfjpMNOTvL7mKW9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyIslcu4MyhucKFA8YbijSdiZPFSzMRGL9LSpC72x8M=;
 b=ari3eajix1B2l7w1Op223UyrggvtMa8axGew6t5/UEV+07aEDh2PCFUdOC1ufb/b8CU5AS17y87HC6Rfg4uHpdbod/e829ODMz6746XrOmQBz1FWu15RYeRDlT9fIj92X2MWC8jkOrfhM+HKDXm1Syc+cTxoS3rsarq3UCQ26kdIxPxFUPk2g4YmZw1foOlSv+4hP5Ab2V2CNYMhkvUEhM/2jYNtrRduwE+pKC6n4yJvhPEzU4nJhEMryylpPWxV8tCHm3CRJmAPC/YyOOo1KcGtzjdHlu+MIBGjPzfo9WNPa187Nu+zzcuEvNP+JPKk3NBefJW3nezg+3i2fvwwzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by BN9PR12MB5355.namprd12.prod.outlook.com (2603:10b6:408:104::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 09:03:25 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 09:03:25 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/7] mlxsw: core: Move functions to register/unregister array of traps to core.c
Date:   Thu, 27 Jan 2022 11:02:23 +0200
Message-Id: <20220127090226.283442-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220127090226.283442-1-idosch@nvidia.com>
References: <20220127090226.283442-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0261.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::28) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d049a45b-b15e-48aa-39b1-08d9e173e01c
X-MS-TrafficTypeDiagnostic: BN9PR12MB5355:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5355CB1C206AEF550A26FB65B2219@BN9PR12MB5355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HUMo1knjwfx4ETkW1OVOGRLgjM9Nj3w12y0tRp8oyWQMA58hxTXF0yKcSR4XQQfMbePZinzYeYkelmOs/IETurbdyDgy9OlnxrT2g9YAmFU9TCIfnMJHIsjpY+q3n0n1zlpWDkB4q6+bJYYMLuzbqgZti+z81IEh8n7+eGF5Xt6pVnkWqfd09AUQWysvH+vC+/QeeHFRJmmA9Y7xcC+ZNoTJym/vMUjm/Bkf/qulIZdVe7sINkclHHYdVg/8t1PFryTw1TFpfUqrEF6MeXvim6HRjF79EfkKQ8BrfQYxc9o8vgrZO/ATULeGvgtdLiPqQg/5V85bC9TbEGTArWUSaIlSVIdxdjhaoL1qyZKc1iiKwEz6+QV7OrhlftYLoT3Z8mqs3yPL01NK+QNT41QYKGanWTBpSK5hdrCu2B5rf/a7WurqEEopGVwT/3+2093yTiPLAtYqKlLdjz/zxWkObY9gphbIaKIFzKBX+3BOhYnWsQ3A9RSWQ/ga7xjx8iyYaHc9J4gJ7Ldjg4j3ggSlx1+EhpLBQUXktWipTS7653q2UAklCUw52fIl/u5bfEZFmRWal7roSs5SCGKuZODKMnYLrXfzOjK4Av14mKIX5eWoofSEXUoTV73WYtAxzmypv5BA7EOj8ymbofT+k9wMBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(2616005)(6916009)(4326008)(8676002)(316002)(6486002)(66946007)(26005)(186003)(86362001)(1076003)(66476007)(107886003)(508600001)(8936002)(66556008)(5660300002)(83380400001)(6506007)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nVTUlyebC0/7Z2PzAmz6M8QYJvCUgwbL+wOv30w+XTUGMGrhxgB1Nfw+xcUw?=
 =?us-ascii?Q?JbAVEzRqH99Kv0CdHhKZz2ixHYrWQUizoo5I7KB8ZWNCulJgV9q6KNC6BHD2?=
 =?us-ascii?Q?ti7e5+CaCaFTW6GvvWAFuzz1xVNSWfqqd4W5X4INPdifrzUROe1YGKhv+yjb?=
 =?us-ascii?Q?/y87kfoG2mDLmAF2ttkUnqGrYbjaje8VM29w3PrMAi9hiFhuU27niSdzzyPC?=
 =?us-ascii?Q?HzcYIyWnnU3kT+PO50sKAZEzvGfZ3NBKHxnQm+Whkdz7ag10eeCjqxzTk08U?=
 =?us-ascii?Q?4FSfH9bFjDUaKNgyvls/VQyXwVx8nf5iG2KrW1LjfHky/oKGi5R5l8BFBzcC?=
 =?us-ascii?Q?RglxeYuCULEFrZOyqPCvegz4gfTzgvdsonfE+oFIXfyqEfH/0u/xuK2T9a6J?=
 =?us-ascii?Q?N/BiJuvnKffGw/4rFqGXT2ZIQ7ck5ZLToN3cKlnUjU6yxrcvV3xoGACuSI0A?=
 =?us-ascii?Q?5HjGD7pct92z4cnKjN3aHjzWBHRHEjSUUtSzuTq1IIUxmlAUpofzvK7C14UJ?=
 =?us-ascii?Q?+wOqrJb/i4cNCPC1/vgDuHSPbFYDVIHq23AVpG+eQyEfuxiYx8yqnugkSwDt?=
 =?us-ascii?Q?8L0mCQDDFZstpY0684RVw4IyzWK1ZcnvWbRso6zDW7ErJrehRzFeRnRDHjIM?=
 =?us-ascii?Q?3L0pQIb50KwlgI4qXnyq4hB24QRrzb0KLWs31M2Kp/AKxZ9Tvxk/56HkCPkX?=
 =?us-ascii?Q?aJ/3HzMTj/6cMGJunPXZEcFV7Glq7doSMHvU3KolKu8NNlBcloox8zNNPvr9?=
 =?us-ascii?Q?aDhO8f/7IERt/URfC2HZ6VGBmxqnPeIFsFcZ4XdQVxTruLQlwf2pgJX0jvX9?=
 =?us-ascii?Q?8fbx4bm4N03y3I3jMI9L9iiFvx06vuAJCovzxngS5g34ODB1ZcYtUAklKfVq?=
 =?us-ascii?Q?zXr0YTJ39ODdl/kKMqitl26R2wlmf0AqKQRltvY3foPpVqsE/4W++XXQPeZv?=
 =?us-ascii?Q?HXyzGMJX4+DePk5CE4FeB+pjD67nXsK9+W4QmWTmGhXD8Y2frdfALuQokHoY?=
 =?us-ascii?Q?Bffy21df4EGkCYKGmsmEIlIwi5oECZgGHiD6S+5VmPfXxQXFAHJ4ueGexw9z?=
 =?us-ascii?Q?uAGRRFXd3m5qdjleHOah6PCtvbHIODiaG0szTBqUA0zJEPvdy9+nkTlJSA/6?=
 =?us-ascii?Q?Trve0InQ/qVDX2DolBTeTGMwFRs7JQfsovXm08Q+AiwzKg4rPscQfeNjZinI?=
 =?us-ascii?Q?VdwpitkJzRt0eISyI1i6nQAPjreRqsgScAgu8hC4UTAc8o6pQ1Uu+M19qiD1?=
 =?us-ascii?Q?jHbRlfVRE/WWTwqWDo7uEzvc6hJ4a+fqZXIGPPsdubiBI4LQtBmXhXqAPe4t?=
 =?us-ascii?Q?Fyd/brU557vbH2K+Xsmg9vvzxRFf3kFk4nGYER3Fiz/zBcGENfxIaUyRiH9u?=
 =?us-ascii?Q?9F4ASzEsksQLB6kJdiaroBfy6iZszWOE8YAbQYvGC158385eVlcnBidUVDkp?=
 =?us-ascii?Q?JRFsVlpc0jYjgs+8fD5PCj3Pezn5+uwncRcSajhCbmSMi6xSxFsKIAk5G7kA?=
 =?us-ascii?Q?wm92Qc3L2GtYC1QgeG/kh+gXtg2seu5BJm2FJBNpXyObFo6ORHuhL0v5n3jY?=
 =?us-ascii?Q?GB2zDvlBNWf9lFioPoBQZ4Li/y2NbMVPvbqAZHRXobHMG4ML45Mb9TnvcobM?=
 =?us-ascii?Q?VOuYNeIvaefBDXFofjz2ZT8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d049a45b-b15e-48aa-39b1-08d9e173e01c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 09:03:24.9882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NIY/kTve1bmIAN8b03hOL2R0BOBwGuOOKQUrXVkeuR/ut31+l97uHO+xmOaMZpRKYHzaa5Y8Y5wwhsHW5U7ZLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5355
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

These functions belong to core.c alongside the functions that
register/unregister a single trap. Move it there. Make the functions
possibly usable by other parts of mlxsw code.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 39 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  6 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 62 ++++---------------
 3 files changed, 58 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 20133daa54f5..0c2e0d42f894 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2564,6 +2564,45 @@ void mlxsw_core_trap_unregister(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_trap_unregister);
 
+int mlxsw_core_traps_register(struct mlxsw_core *mlxsw_core,
+			      const struct mlxsw_listener *listeners,
+			      size_t listeners_count, void *priv)
+{
+	int i, err;
+
+	for (i = 0; i < listeners_count; i++) {
+		err = mlxsw_core_trap_register(mlxsw_core,
+					       &listeners[i],
+					       priv);
+		if (err)
+			goto err_listener_register;
+	}
+	return 0;
+
+err_listener_register:
+	for (i--; i >= 0; i--) {
+		mlxsw_core_trap_unregister(mlxsw_core,
+					   &listeners[i],
+					   priv);
+	}
+	return err;
+}
+EXPORT_SYMBOL(mlxsw_core_traps_register);
+
+void mlxsw_core_traps_unregister(struct mlxsw_core *mlxsw_core,
+				 const struct mlxsw_listener *listeners,
+				 size_t listeners_count, void *priv)
+{
+	int i;
+
+	for (i = 0; i < listeners_count; i++) {
+		mlxsw_core_trap_unregister(mlxsw_core,
+					   &listeners[i],
+					   priv);
+	}
+}
+EXPORT_SYMBOL(mlxsw_core_traps_unregister);
+
 int mlxsw_core_trap_state_set(struct mlxsw_core *mlxsw_core,
 			      const struct mlxsw_listener *listener,
 			      bool enabled)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 42e8d669be0a..e6973a7236e1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -181,6 +181,12 @@ int mlxsw_core_trap_register(struct mlxsw_core *mlxsw_core,
 void mlxsw_core_trap_unregister(struct mlxsw_core *mlxsw_core,
 				const struct mlxsw_listener *listener,
 				void *priv);
+int mlxsw_core_traps_register(struct mlxsw_core *mlxsw_core,
+			      const struct mlxsw_listener *listeners,
+			      size_t listeners_count, void *priv);
+void mlxsw_core_traps_unregister(struct mlxsw_core *mlxsw_core,
+				 const struct mlxsw_listener *listeners,
+				 size_t listeners_count, void *priv);
 int mlxsw_core_trap_state_set(struct mlxsw_core *mlxsw_core,
 			      const struct mlxsw_listener *listener,
 			      bool enabled);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 0dc32c23394e..a3f95744118f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2393,45 +2393,6 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 	return 0;
 }
 
-static int mlxsw_sp_traps_register(struct mlxsw_sp *mlxsw_sp,
-				   const struct mlxsw_listener listeners[],
-				   size_t listeners_count)
-{
-	int i;
-	int err;
-
-	for (i = 0; i < listeners_count; i++) {
-		err = mlxsw_core_trap_register(mlxsw_sp->core,
-					       &listeners[i],
-					       mlxsw_sp);
-		if (err)
-			goto err_listener_register;
-
-	}
-	return 0;
-
-err_listener_register:
-	for (i--; i >= 0; i--) {
-		mlxsw_core_trap_unregister(mlxsw_sp->core,
-					   &listeners[i],
-					   mlxsw_sp);
-	}
-	return err;
-}
-
-static void mlxsw_sp_traps_unregister(struct mlxsw_sp *mlxsw_sp,
-				      const struct mlxsw_listener listeners[],
-				      size_t listeners_count)
-{
-	int i;
-
-	for (i = 0; i < listeners_count; i++) {
-		mlxsw_core_trap_unregister(mlxsw_sp->core,
-					   &listeners[i],
-					   mlxsw_sp);
-	}
-}
-
 static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_trap *trap;
@@ -2456,21 +2417,23 @@ static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		goto err_trap_groups_set;
 
-	err = mlxsw_sp_traps_register(mlxsw_sp, mlxsw_sp_listener,
-				      ARRAY_SIZE(mlxsw_sp_listener));
+	err = mlxsw_core_traps_register(mlxsw_sp->core, mlxsw_sp_listener,
+					ARRAY_SIZE(mlxsw_sp_listener),
+					mlxsw_sp);
 	if (err)
 		goto err_traps_register;
 
-	err = mlxsw_sp_traps_register(mlxsw_sp, mlxsw_sp->listeners,
-				      mlxsw_sp->listeners_count);
+	err = mlxsw_core_traps_register(mlxsw_sp->core, mlxsw_sp->listeners,
+					mlxsw_sp->listeners_count, mlxsw_sp);
 	if (err)
 		goto err_extra_traps_init;
 
 	return 0;
 
 err_extra_traps_init:
-	mlxsw_sp_traps_unregister(mlxsw_sp, mlxsw_sp_listener,
-				  ARRAY_SIZE(mlxsw_sp_listener));
+	mlxsw_core_traps_unregister(mlxsw_sp->core, mlxsw_sp_listener,
+				    ARRAY_SIZE(mlxsw_sp_listener),
+				    mlxsw_sp);
 err_traps_register:
 err_trap_groups_set:
 err_cpu_policers_set:
@@ -2480,10 +2443,11 @@ static int mlxsw_sp_traps_init(struct mlxsw_sp *mlxsw_sp)
 
 static void mlxsw_sp_traps_fini(struct mlxsw_sp *mlxsw_sp)
 {
-	mlxsw_sp_traps_unregister(mlxsw_sp, mlxsw_sp->listeners,
-				  mlxsw_sp->listeners_count);
-	mlxsw_sp_traps_unregister(mlxsw_sp, mlxsw_sp_listener,
-				  ARRAY_SIZE(mlxsw_sp_listener));
+	mlxsw_core_traps_unregister(mlxsw_sp->core, mlxsw_sp->listeners,
+				    mlxsw_sp->listeners_count,
+				    mlxsw_sp);
+	mlxsw_core_traps_unregister(mlxsw_sp->core, mlxsw_sp_listener,
+				    ARRAY_SIZE(mlxsw_sp_listener), mlxsw_sp);
 	kfree(mlxsw_sp->trap);
 }
 
-- 
2.33.1

