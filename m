Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EB95573CA
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiFWHUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiFWHUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:20:03 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2073.outbound.protection.outlook.com [40.107.96.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253A84615D
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:19:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mb2Cu2V5pscSgnxhZZ+sS1nEn7UfZVNSOdF6cB/wUyOGmtqqXHUWvDLI5wcY2dMtmxVj6BvQyOxWnx8jg2SraLAa5k/PTnMuC+Fyk8w0Ieatca4aHoYW6mFEdV20Iy6baPq5RL2ijeWXL3AQh9QQy7hvf5r8WWD3t6q/Kxvch4s1o7ZaztZTgprseDL45pj4qWB6QDTg3m1oaLFHmNbnHAU9Lk+H2I/uziRjaXx8bA9DUvvU5/+MaB5jnje50CVX4oWuD8sXJ0ktx3bNj//f2S04GdNmlimZrSXOuulhwgA0v9pql+L9ZKmjjHiktHLrKgRFxcUQYwNyTKTJFpd22g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJaT9uiAMSRNAK1htgwhU03+NK76TvrCgcMSAyQVapk=;
 b=h5YEfLmBRLR7T7Q1IrExyIPw+EbhsBeTqhH/ftt5UAbGO4W/vEUwD1pe1XqSl5dQ/AiAHaklBDMn3b11P3AknIKPulinHqsrZ4mZhH+kHkqCMtM8H3T3KQkJI+BlFFHyg4QicaAL1zekLDPAEzv0YST6azgRHHMpHz2mL1Uzp2rMt7ZssGvDPS2YeBrMR6c7850Q8Y3apuFcafhRvaX82JX0ne2AiCqZ/1W6B9UItPvAlFevJGzCKXW18V8f5Bg4pSqcLCmhhLMoimXXWbIub1vTt4hzvaC4O5pTHv0qdufl5w+jx76Vh72/+jJ5om+XOb/PmEl5G60aku/kWTTkhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJaT9uiAMSRNAK1htgwhU03+NK76TvrCgcMSAyQVapk=;
 b=ghIJe/DLIGGrFcN3U8ck21wlxe8MXBsp5InNfhk+ecmD1X2XJ17ItFNSHumGnIkLfKZgEn9JTKgMvokMtsb+C2r67cCIP5jz7IK3wXMR4Phq8fY8H0DuO9m6WUYSVQPasEssUEuFcDG/0d1xguZGh+cCrK8XwC7o98btLIcm9rkd/SvKMjmzkppE4O0sYJBCBwZgraBgOCE6ZPKTQ9h+AuTsGCT5pRsv0OvhaQRzWtdyPBvledjpFqxnlUa6t66kt0QMuIuECCocGb2xt0Zw96T/cTjbjHYDuOe01AAlmiGEKdCZs0GmbPy41lLeB03msXEGW/CvW6nfF9ZoJu/sHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by SA0PR12MB4414.namprd12.prod.outlook.com (2603:10b6:806:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 07:19:56 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf%7]) with mapi id 15.20.5353.018; Thu, 23 Jun 2022
 07:19:56 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/8] mlxsw: spectrum: Rename MLXSW_SP_RIF_TYPE_VLAN
Date:   Thu, 23 Jun 2022 10:17:36 +0300
Message-Id: <20220623071737.318238-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623071737.318238-1-idosch@nvidia.com>
References: <20220623071737.318238-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0060.eurprd09.prod.outlook.com
 (2603:10a6:802:28::28) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08aa95c8-bd7f-4749-a8a4-08da54e8c662
X-MS-TrafficTypeDiagnostic: SA0PR12MB4414:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4414F90D74A52475F11EAA3CB2B59@SA0PR12MB4414.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oB75JMZQG1aE7t3A9wZLlcRGD5f7zP3yCjVIW0grurRUr58T1CJoK1S5kPVeyWV0ApreRCV8oBeEGbl1zap9tVJaRclGQwi59IjJ6NFdhfwzXsS5Ne3MKfcQhi2niN3Gflm4ZUbnwTl/Ft9u590+8ZCRbgxMhmXvREYG2hJdXYmuvabQKdZ5b0d4/tUB0LNBNsLp06ukxn3dKvGdGkIMsAhDis2QgsaR0D1wZUUN4/QBdwk45xRwYlXGB5bbYOhG0Qxj6esAM2zRhqZuaxTiNhdOhzlgg2qy1aCKjEdHJHnXU0xVePpGNTM/0sYxvu7e0iu2PlVPGOnN8SU9gsR5IbGUrUTQsxIxcROF3ahG9sbBNVdu4aLyzLXRBL4mtNWAAxhnN9FTkwaWd8wGpxmoAAWAnnJgsmVm6+M9YbNBPOaVLODxxawggvzc34k4ja2HAhOxuWDPk4nZR6/2WMvgQP/mkkWeCGyv+FdtluuNDQsK/la82afbpoYTpWFsdvUhgDTTroSVC8lJ/zibFoTZEh7GSr8Kan82UhfnzdZJd0+Is+divb9HxebRcUBnhI3T+ITG2qcSgqPCJZd72vIgvaJyVDm9+4/8CuTwymNTkxCRKraDb3kE3k9HVJaCcpiMwkej/1ajJb09eRdq+/3TdsoaNa8rPW5d41vUAazCXIIxwWVWa1h9+/K1ycgh0mt/T2weqjxpKwSxhKisX5QiSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(66574015)(86362001)(83380400001)(2616005)(107886003)(8676002)(66556008)(4326008)(66476007)(66946007)(8936002)(1076003)(38100700002)(186003)(5660300002)(2906002)(26005)(6506007)(6512007)(316002)(6486002)(6916009)(478600001)(36756003)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dfRxegT8oJ//KUftkl8/9fs29zWOCELjf81VKns+CGLEaw7I+nAIlM0YhRbh?=
 =?us-ascii?Q?qdM0S1RTzLjtkj0tvdiRFnNUhn9ydR4nTL29g9Rl3gHY6ZST2+T0ZwpGfyBk?=
 =?us-ascii?Q?U5veR/hxGhDjvz/XSJUKiQAqz2C/ZMPcbc/dKbh4T73iWhNTpAHN7R6BQ9Z3?=
 =?us-ascii?Q?0KpHNOt4M17e+RdjZf8wIUT98bWtmu3sbMDe0pw033Cj+guEDAkVEmbd/9H3?=
 =?us-ascii?Q?0P2Y093OFzykjp5SZdaR8kvgUJ1OGYAAZHCqrfz8EByODQo5wKgJtytPN5BO?=
 =?us-ascii?Q?VfwoUIgnBxPcewo/y2QidfHWtibs8kLIref2696GkYMlqmhkDnAC7R+daVXm?=
 =?us-ascii?Q?i2bHaomof8ROVwzLF+AsSDEI4SfhepjrSyu6wtI92cL0QY6UIJp5DRoyGUlO?=
 =?us-ascii?Q?8PdbD9B2x3usnLCcED5w9yCX386tcHZqxh4fummuf5iwIpHatmsBpHijUeb4?=
 =?us-ascii?Q?DZVZJSr9eG1Jfa9m/yf2v6LwUbce01HGDPXvsPXMeE+7cG/xCjjw61sOX49x?=
 =?us-ascii?Q?EdLa23d7IT/xI7CS388jV45PmN1+4U8PtbVaB0N4LLy1zCMSHqWPGoGePQaj?=
 =?us-ascii?Q?h2oJY0wzLItSjquQNdSiUed7OXR9qWXISK38FVrhsIOn/ygl5jImDWGZCIJq?=
 =?us-ascii?Q?J4AAOWVuP/DdS7ByE7AVl7BSDa4fb4hBXMsclzowLGrideIrGkViicnGwvQn?=
 =?us-ascii?Q?UxDj9wvrarZyTUWhahTK/HSuZL/DTQkOUS/FzlHW3Tdc60n1srSWrmycpPRW?=
 =?us-ascii?Q?k9C3LS0x4UOXVKs+wdmfjjlj6iwSnwnniqJfN+BOdhRr0pKAC4MA7VvLKH67?=
 =?us-ascii?Q?5wYTUA17XGzjQUO/uXL7IjnD/m5C4XrJkAtLfQ8gfVvkCpboZreTQ85RKyWL?=
 =?us-ascii?Q?uFbEfG7VoJJDHnJ8MV3kcbXjyB2/wFJDh4ss7JvZKSA3QXCi9Xsev5jm+L5s?=
 =?us-ascii?Q?2ap0Z+/3Y7sP0hL2TLWtsxwIHA+ULakgihQ4x61MD4EagrxeffoK0AcXSQys?=
 =?us-ascii?Q?qQCaKJFmn11d1A01vNHM+XjQGgiueRN4vDW4AiK4c4qdBlVnSOyGGgbbMi8H?=
 =?us-ascii?Q?MkVkdPKUKy45SRC8HxUzeMosMFXltehp+RIv+SqbDF/SK3DNTzys0MKPmrwg?=
 =?us-ascii?Q?RuNKZF7lWJ1p2aWRK3RDEu7jKrhJ0Mu7L2bNdwXz9UaSx7NZhmzUe2z+TcQ9?=
 =?us-ascii?Q?8fcSLcK+UvoDUXhW0qZlGXuRORWRYhhMgKfj4pTCLgGDAbsR1MxLtVsOVrAT?=
 =?us-ascii?Q?rYefV5gdOBlkctCQkapOsPkNoaB7IpXOqvteHaS4VK/3B8Dis2/5RikDNmri?=
 =?us-ascii?Q?xpYhEev+Tr/33RiWHjFzEfQ6CMA/W2qEFEAnw73M5VqPYpnNRZcqyoftDH3J?=
 =?us-ascii?Q?jrDjnZq8hWV3+eykDPvUabBgLRlMh8RTVY9X7xfb/WTOYC1DUIVJ40WzL+9l?=
 =?us-ascii?Q?vi9gg0qDaFPgZ3Q+dI5CmApdd+oOS//HiJhfjK2x0VvUfEGprZCdBN3cYbhs?=
 =?us-ascii?Q?9G8qWtSpwMKlXXnzhfo/fWRIFNctnVDkTQ/do5iEQ2X2JtxOG4JePIlOs6Z8?=
 =?us-ascii?Q?5Z/b+ftsJlwZItKzJsgTirNoYYl1D+QKSLYMkdg/znv1UOnPUr1G64ktJiSZ?=
 =?us-ascii?Q?pFctkG/7aN3FsvyeFzbGDgPc/svM+g8bg2h42QnSKEqJwPos6My8V3u7xwMp?=
 =?us-ascii?Q?twlakRid+4PwjjRky4Opi7QWFqD6sRstVH+UNt9f5/QkwkNTP5543ts6x55Q?=
 =?us-ascii?Q?daPgbwiz2Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08aa95c8-bd7f-4749-a8a4-08da54e8c662
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:19:56.5721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kVgpUVX9b6Rmzoo7IsUJP8ttEWAuQL+KRlDUdw04DsaairkBuqRaatTTa6gvGgC4sojmZ/3UqXs8m4bPoad17A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4414
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, the driver emulates 802.1Q FIDs using 802.1D FIDs. As such,
the RIFs configured on top of these FIDs are FID RIFs and not VLAN RIFs.

As part of converting the driver to the unified bridge model, 802.1Q
FIDs and VLAN RIFs will be used.

As a preparation for this change, rename the emulated VLAN RIFs from
'MLXSW_SP_RIF_TYPE_VLAN' to 'MLXSW_SP_RIF_TYPE_VLAN_EMU'. After the
conversion the emulated VLAN RIFs will be removed.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h        | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c    | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index acb52f6aa97d..80006a631333 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -84,7 +84,7 @@ struct mlxsw_sp_upper {
 
 enum mlxsw_sp_rif_type {
 	MLXSW_SP_RIF_TYPE_SUBPORT,
-	MLXSW_SP_RIF_TYPE_VLAN,
+	MLXSW_SP_RIF_TYPE_VLAN_EMU,
 	MLXSW_SP_RIF_TYPE_FID,
 	MLXSW_SP_RIF_TYPE_IPIP_LB, /* IP-in-IP loopback. */
 	MLXSW_SP_RIF_TYPE_MAX,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 1f8832f86327..fb04fbec7c82 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -774,7 +774,7 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021q_emu_family = {
 	.end_index		= MLXSW_SP_FID_8021Q_EMU_END,
 	.flood_tables		= mlxsw_sp_fid_8021d_flood_tables,
 	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
-	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN,
+	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN_EMU,
 	.ops			= &mlxsw_sp_fid_8021q_emu_ops,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index e12e0929c7f5..c6d39c553d64 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7730,7 +7730,7 @@ u16 mlxsw_sp_rif_vid(struct mlxsw_sp *mlxsw_sp, const struct net_device *dev)
 	/* We only return the VID for VLAN RIFs. Otherwise we return an
 	 * invalid value (0).
 	 */
-	if (rif->ops->type != MLXSW_SP_RIF_TYPE_VLAN)
+	if (rif->ops->type != MLXSW_SP_RIF_TYPE_VLAN_EMU)
 		goto out;
 
 	vid = mlxsw_sp_fid_8021q_vid(rif->fid);
@@ -9552,7 +9552,7 @@ static void mlxsw_sp_rif_vlan_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 }
 
 static const struct mlxsw_sp_rif_ops mlxsw_sp_rif_vlan_emu_ops = {
-	.type			= MLXSW_SP_RIF_TYPE_VLAN,
+	.type			= MLXSW_SP_RIF_TYPE_VLAN_EMU,
 	.rif_size		= sizeof(struct mlxsw_sp_rif),
 	.configure		= mlxsw_sp_rif_fid_configure,
 	.deconfigure		= mlxsw_sp_rif_fid_deconfigure,
@@ -9630,7 +9630,7 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp1_rif_ipip_lb_ops = {
 
 static const struct mlxsw_sp_rif_ops *mlxsw_sp1_rif_ops_arr[] = {
 	[MLXSW_SP_RIF_TYPE_SUBPORT]	= &mlxsw_sp_rif_subport_ops,
-	[MLXSW_SP_RIF_TYPE_VLAN]	= &mlxsw_sp_rif_vlan_emu_ops,
+	[MLXSW_SP_RIF_TYPE_VLAN_EMU]	= &mlxsw_sp_rif_vlan_emu_ops,
 	[MLXSW_SP_RIF_TYPE_FID]		= &mlxsw_sp_rif_fid_ops,
 	[MLXSW_SP_RIF_TYPE_IPIP_LB]	= &mlxsw_sp1_rif_ipip_lb_ops,
 };
@@ -9818,7 +9818,7 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp2_rif_ipip_lb_ops = {
 
 static const struct mlxsw_sp_rif_ops *mlxsw_sp2_rif_ops_arr[] = {
 	[MLXSW_SP_RIF_TYPE_SUBPORT]	= &mlxsw_sp_rif_subport_ops,
-	[MLXSW_SP_RIF_TYPE_VLAN]	= &mlxsw_sp_rif_vlan_emu_ops,
+	[MLXSW_SP_RIF_TYPE_VLAN_EMU]	= &mlxsw_sp_rif_vlan_emu_ops,
 	[MLXSW_SP_RIF_TYPE_FID]		= &mlxsw_sp_rif_fid_ops,
 	[MLXSW_SP_RIF_TYPE_IPIP_LB]	= &mlxsw_sp2_rif_ipip_lb_ops,
 };
-- 
2.36.1

