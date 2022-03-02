Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73974CAA4F
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242864AbiCBQeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242798AbiCBQd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:33:56 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2082.outbound.protection.outlook.com [40.107.212.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F104DF77
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:33:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgKkrSV7CPpfJHA92Z7/ZGAVvsTY//IQouD6kMoYGGYvDMZpEaHH/B4Y5GbQj/lYPnjCaoFI4RMD5XTbKvpxLIcI9h2tvRHtT+VfA2EN4TQXQVhkWDxROkgFBdtxT+ZKlvp278LZth0FKUoL/2kl0xxcpYkJdBe1wjXLZyWrAf5mlCcxRoHuWmzOpa1dPJUx0jQCUUceDsKS0I3aYQKqlgjVlM7PHfB6a4EToSf5nREC6ZuZQLtbDfr8aRoIBO5rVgXlO9cOHdPrdbrfn5eBu+kfitmEwRyR2EJV4sOixjiHAT1HUHhnnF5Q3wMPMbF7iCko9JpUhwPBY7pSOA4Scg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gc78/ds/Dz1icWPRVPiybRT/Ox7juhxiIjIzctKkwc0=;
 b=bVTEUr0S/H/+A3+cCiI533frPOt15NwstBCwjGo67O+2k0E3hGKjUkMvx7YwpodAyVKrsSl6055fUKX0zyvm1krrYJpFMu81M3YbNAfOlG3/CAvTjC6YJlXQzFd0DkExBgrKMwhf3QL8xIgXPIkjhFK+6FfbetBgiSdql0YyjyH3XRc7hY12exd55yMoRfthPCcoVfsxugFBXKuEsUMk0TI4+mu4oLq7uZtf8BzqO8cdWbdWrSr4Eybu0hcvz1O66z+w/QWsiTaocgolCGDmvCu/gBeOTbT7WRkoyKtc8/+59NRsmFBk7uF/h4tHNrhFaYdEM0fdrMAOvBV1K4A58A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gc78/ds/Dz1icWPRVPiybRT/Ox7juhxiIjIzctKkwc0=;
 b=Oh7ltvrKVJsuSImaGEvmxZXcWvYyd4TDUQFWQlwmlPwyv0GPPiubMO0Ln1hJseQ74CPo8xfDjYnfM5YeS26gbVXNhxofFEKNhcG8j61dMWs/nSsuTWlo1nB+JcKPw36lcoxVSd38vVhdO0o3BpboCeDYI/NwjtQ3+YgYP5079ZT0a8iEH4LVzgXo9Ikds1DQKBFH7lWQZW25ei1Ja7frvceF51L4yFjcJEn8zi4MiZdHORsRju87geJ5RiTTGYPxkaDs5+x0etqAKJK39+COfYgllSW8yDuuF8qMQg1mwODTyGpbdEDln/MVLg5eG1arq35YwFRLO9+fdabaLaQ3fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BYAPR12MB3208.namprd12.prod.outlook.com (2603:10b6:a03:13b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Wed, 2 Mar
 2022 16:33:05 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:33:04 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 11/14] mlxsw: spectrum_router: Drop mlxsw_sp arg from counter alloc/free functions
Date:   Wed,  2 Mar 2022 18:31:25 +0200
Message-Id: <20220302163128.218798-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0109.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::38) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9487123e-4d65-490b-f4a2-08d9fc6a5378
X-MS-TrafficTypeDiagnostic: BYAPR12MB3208:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3208CFB17C1D55F65AB209A3B2039@BYAPR12MB3208.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86n/rUP80jvDaBog7XrPTndh0p5Un7f/yL08i4xOY1DWjiEGxe/pU796+SFfpr1Tyu60Zw0Ki8+Qwnc4BWeFTfOerQTbg9zbyb3EEnv1M1cbnzXHx4LY3TgigLJJZJzLaNoK6c4BzuQ0VtbNNkCyxviuxtVsZWhiu1opaTsbrjpqemU8rLXAiqhQP1ggNBRMLVVt1FFE4b2WpmKrhXZhYtPpfYxMhf27IeESrcRDnpAeq4bdzGiqJKcYVpokrT8QuhboyCs8eDubXUUIRNB3QWh9BI8nDcaFa+tmHH323dT0l+yk2luQW4TtfNG7+1JGWW+G0MHSy8VCZrskqudKEU1mX5ZNiaNQWZ16uAQdsbKXciJmtNynrTXkBCn3TRSI9bdTBJEiL7KZhYF7W6fT1zFRy0OZG0aN2MV3vC+nX8Ja3psTCMYKd3FVNsORuZpfUC2kp6nZVWgSBLYtUpWpl9s4wjjDW0VUwpTP7URunOGu1MBKRCNQIhIECXvVyfPBjb18CpbYmLh+sTHyZz3rUkkXMdzd2h7HqGUteBbmmmK6/OH5YUqkB3C2ijLxld9QC3VN0mTAqONhkDo3WrGDn9UjLzVBur4ZkSfyMYeQe3k9298wwh/W0TmiL1OHjIJ8QOrp1kbWD7NPk2dd2q8vCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(66574015)(6512007)(107886003)(4326008)(66946007)(66476007)(38100700002)(66556008)(2616005)(2906002)(86362001)(5660300002)(8676002)(26005)(83380400001)(186003)(6666004)(36756003)(6486002)(508600001)(316002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EEyyoNnBFj3QDHwAalu5vb8mfj5TF1+tKUPdaxwKdHFXrk8BAgeilKFjyAvm?=
 =?us-ascii?Q?UXAsJcyWIU5z+kcAVbfRw/9x+hZoe8Idb9DOK8P8lrB6uJwcZlofAyVZV1BM?=
 =?us-ascii?Q?SyevyMgZxx1MVmlvu0Ph51byPfivrYi5wyInF9mjtlUOKMAI8fC2M/pBk6R9?=
 =?us-ascii?Q?HgzgeMuCspQwaqggru21AmUDT8l9WljYmpJDl9w17y79c6oAUd7NIQLKnWYz?=
 =?us-ascii?Q?LoLq1HChQ/zel6v5fvFJ6PMBFGhe8FV5XJG8MPxmi4OrKTeXraEsoXa2fVAo?=
 =?us-ascii?Q?m9T4t7q3XYnP5A+6bpTHWcViWF7CMDx1mXJry26ADrApX53a4LpO7pIbYVUJ?=
 =?us-ascii?Q?gxqfRNlYKzv/HTe+SNA8OuQtK2+gmDJmeL4o/+kudgIF9IBi6VGRHtUxFYlG?=
 =?us-ascii?Q?62EKCykg3Z4YOZso0aceaBiSPAkpryzCVqZ7ZMkYLylQU5Ughyb6dXilmlWH?=
 =?us-ascii?Q?nmll6TZ0oerGn/RHPE0flvRcpsm/Qh9iQXuaTcjUcNxtf68RH2akXSLxO/AT?=
 =?us-ascii?Q?ZBppq71otwfsxjGOGAee4qsPwIr8avI+MJE/ZrPgNkNTR3bhUDWrgRJnzX+l?=
 =?us-ascii?Q?gIAZhhrZ3shptKivrInu8hA645LRAJBUIgcRFAgElsREOK+PnvXBaLTcAqWF?=
 =?us-ascii?Q?V3bn578QsycEamYFCwsxjX5id/0kZFI8CawTJidwEfLkZEdXNz3jB/9LFuuf?=
 =?us-ascii?Q?sJqUg/zATEq2ikQXkI/yqU6QoY68KU7lobCYOyxsTF0owizNw6LNxqQrSqgP?=
 =?us-ascii?Q?4ZEBcIjRJKV157lJdH7D6VGOqY/07H541d+NUplPGFhFz8EA7eJ+uZvTDSV1?=
 =?us-ascii?Q?/B8uaHiIVO2pqmBPjhXiTKM1rAjHduL2xrewpwLrv+iLjnrFn4rwc2I5Vpbb?=
 =?us-ascii?Q?pU6psL1WV+auMD+igWDQ4MRjK27gKQu1Gdkw3NmpLIOp2DCehBt6lkXcV52H?=
 =?us-ascii?Q?A1mdy8h4h7T42KYahI8rr4vNpawodDIhMV4vlDfxzOWLRrc1YdM1Owg2QwyW?=
 =?us-ascii?Q?l33A2YbFjQKpSBl8B8SWvpMVlIQujRgClmLfr1CQadcE5nLxFy3ZvOVzHOM/?=
 =?us-ascii?Q?k5vqg0DsNd0brtwLiOz0oDQqbEDvvyXDgRZXRwygcmq3GsfbjPQN3l3BFb0V?=
 =?us-ascii?Q?TxV/1PZxaggure5iLHpkLWQuZnVs0PxcygJFXNfLErFKKMBc5cbniOxQMbny?=
 =?us-ascii?Q?DV+IGMV/SR6lpKdC28joISgQ3lIkrzv0l9pVEX/iXd5dlP2oIrxeh1kbsk2A?=
 =?us-ascii?Q?eHBp1ptLFKen5UxRS1nWAPHeRJCwZJCM4Lanblo1ekshKzyP5ib0V0ROiv3n?=
 =?us-ascii?Q?I8Ty/P0niBuKCL/Pumj724HlAyKm38avCqUMiMZ5dnd/P6JH5l00QStR4Xm6?=
 =?us-ascii?Q?MLoxbDpayrC7iH0aRWSmq4zGYlaFlY9rvBbYloDthaZlJFVr2tNqqU4CWVhT?=
 =?us-ascii?Q?dWb/4OcFZFTJF5VSZHq6kx9kWzOQtgmHVChBGPhbOoBk8Xu284qnYzvAU9r0?=
 =?us-ascii?Q?wq14zEK5cdy8qkDmg4yODxRcaLOrY9wYeKDO1v21W+cO/5sgmk5zrGDayVuX?=
 =?us-ascii?Q?VPbbCarVg6Yox+AjlYFqghS3cyQmr4LJ9ZFsHgC20DWgmosE8iRjMQGKPUj2?=
 =?us-ascii?Q?9fPXVk3+d5oogyuaikK9fmk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9487123e-4d65-490b-f4a2-08d9fc6a5378
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:33:04.7741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MNadQejofePOVTiZf16Hqaj8BVge4SXB6csVPMLPgEh2qC0wwTjk0SF2DomzL6pqQuWLQ5ugICnNd8XfpglEOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3208
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The mlxsw_sp reference is carried by the mlxsw_sp_rif object that is passed
to these functions as well. Just deduce the former from the latter,
and drop the explicit mlxsw_sp parameter. Adapt callers.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c   |  4 ++--
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 ++++++--------
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h  |  6 ++----
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index 1a2fef2a5379..5d494fabf93d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -266,10 +266,10 @@ static int mlxsw_sp_dpipe_table_erif_counters_update(void *priv, bool enable)
 		if (!rif)
 			continue;
 		if (enable)
-			mlxsw_sp_rif_counter_alloc(mlxsw_sp, rif,
+			mlxsw_sp_rif_counter_alloc(rif,
 						   MLXSW_SP_RIF_COUNTER_EGRESS);
 		else
-			mlxsw_sp_rif_counter_free(mlxsw_sp, rif,
+			mlxsw_sp_rif_counter_free(rif,
 						  MLXSW_SP_RIF_COUNTER_EGRESS);
 	}
 	mutex_unlock(&mlxsw_sp->router->lock);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index d40762cfc453..2b21fea3b37d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -235,10 +235,10 @@ static int mlxsw_sp_rif_counter_clear(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ricnt), ricnt_pl);
 }
 
-int mlxsw_sp_rif_counter_alloc(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_rif *rif,
+int mlxsw_sp_rif_counter_alloc(struct mlxsw_sp_rif *rif,
 			       enum mlxsw_sp_rif_counter_dir dir)
 {
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	unsigned int *p_counter_index;
 	int err;
 
@@ -268,10 +268,10 @@ int mlxsw_sp_rif_counter_alloc(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-void mlxsw_sp_rif_counter_free(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_rif *rif,
+void mlxsw_sp_rif_counter_free(struct mlxsw_sp_rif *rif,
 			       enum mlxsw_sp_rif_counter_dir dir)
 {
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	unsigned int *p_counter_index;
 
 	if (!mlxsw_sp_rif_counter_valid_get(rif, dir))
@@ -296,14 +296,12 @@ static void mlxsw_sp_rif_counters_alloc(struct mlxsw_sp_rif *rif)
 	if (!devlink_dpipe_table_counter_enabled(devlink,
 						 MLXSW_SP_DPIPE_TABLE_NAME_ERIF))
 		return;
-	mlxsw_sp_rif_counter_alloc(mlxsw_sp, rif, MLXSW_SP_RIF_COUNTER_EGRESS);
+	mlxsw_sp_rif_counter_alloc(rif, MLXSW_SP_RIF_COUNTER_EGRESS);
 }
 
 static void mlxsw_sp_rif_counters_free(struct mlxsw_sp_rif *rif)
 {
-	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
-
-	mlxsw_sp_rif_counter_free(mlxsw_sp, rif, MLXSW_SP_RIF_COUNTER_EGRESS);
+	mlxsw_sp_rif_counter_free(rif, MLXSW_SP_RIF_COUNTER_EGRESS);
 }
 
 #define MLXSW_SP_PREFIX_COUNT (sizeof(struct in6_addr) * BITS_PER_BYTE + 1)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 99e8371a82a5..fa829658a11b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -159,11 +159,9 @@ int mlxsw_sp_rif_counter_value_get(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_rif *rif,
 				   enum mlxsw_sp_rif_counter_dir dir,
 				   u64 *cnt);
-void mlxsw_sp_rif_counter_free(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_rif *rif,
+void mlxsw_sp_rif_counter_free(struct mlxsw_sp_rif *rif,
 			       enum mlxsw_sp_rif_counter_dir dir);
-int mlxsw_sp_rif_counter_alloc(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_rif *rif,
+int mlxsw_sp_rif_counter_alloc(struct mlxsw_sp_rif *rif,
 			       enum mlxsw_sp_rif_counter_dir dir);
 struct mlxsw_sp_neigh_entry *
 mlxsw_sp_rif_neigh_next(struct mlxsw_sp_rif *rif,
-- 
2.33.1

