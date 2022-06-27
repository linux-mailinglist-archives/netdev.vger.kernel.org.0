Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551CF55DCB9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiF0HIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbiF0HH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:07:26 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC525F5A
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:07:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KI7VXJyPr5DczFVsBieUL3QXHTJfAVY2dkIuXP1xMO8BWPiK/BMdq5fjoQNAxJuKYak2Bty6wapsIhPpQ2MwqMExfb7Zk4+wtPU9tRkq+DzPWwuhfrBAEdfYptymnW5bp94aAri2c8oqt8b4cIOZ7w6wqILJ2+LmGloYocbhFV3LA0chfzzelEOrMJG5544qVKchXxDpHHi657GGpX7G3HlyQ/U2CYzDi9CutwJa7jWwnqzibtFLzBAf4ILZdEKGnHZWkogNm3zMntbMMwfeSqCbTpu+/WQEr4jRdRXmQDulza0Pd3HtdIf5ofVo4JtJa8h6yh26+N/SFSxAJ/R+LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCjlcIaIpxmfhhm9aAwRtKu3id2I7R5kNQILjnwg+ug=;
 b=BbywjT13E7f3s2JkQJa3+sVPyDF4XMFkGxiiv4ENZBesiS/vQ8/1O0BA4WfIgCm5ABTt1HIXN8daqGZX/+hKTmRNcsGn6AYfMKwt5xy6SuktEz1GBsBrTPwKzvYv5layGIhH4NPViM2lDEhnVvODPb8t3cRhAwmUFESFzZeB/hMg5pD48vRx6gRV6CCiYyAoPxiQg7GOWSaHzGtQBeZKRTIQ+Tp6DKopEckVgaYa3MFGfCj8DcO23h5pxGzojUSaREbXaGzWUlfXSqO8ddXhoef0F95vuXBuf25ojm10dvDK8vp1oSwun1HOfGCT84MbB+nYPd+ixGaTXQJO2m2IBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCjlcIaIpxmfhhm9aAwRtKu3id2I7R5kNQILjnwg+ug=;
 b=rQEO4YGfKJaIQ1TBm3t+PqIwm0qmZA6vBmrNp1VfzzoxNn+0PgYH+iUNjyPh2lujBcWsEvdaS/lIUc3wZf1mevZdVrWwoMsZukWEA4Pf/CYyniagsrAaAlT8ZTRFY6fNTYbsHf632dDNz4Toe5NTq+rgMDk9Kj9SDYJnUe9QdR0aDO7i8xQIAUK0oNZIV5/YDV7ipIAvOsJlOHF57GXAhTe0n9kB2e0+ex+i17K0w7O1cSHcRv2q+g7oXoeCzaqug1D3JQ+WCv2phqUO3FjclE8g6x6JmYvPYK3cV/+zMHkSOAqcWqXTyWfz9MME0hJnMlWqAn3JPIsnAVJmGp4r5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 07:07:23 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:07:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/13] mlxsw: spectrum_fid: Store 'bridge_type' as part of FID family
Date:   Mon, 27 Jun 2022 10:06:12 +0300
Message-Id: <20220627070621.648499-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627070621.648499-1-idosch@nvidia.com>
References: <20220627070621.648499-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0377.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::22) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09adbfcc-cf48-4731-79c3-08da580baf10
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ri9vy+BPFmWS/31ukfttJySR69cb8emVbvcLa/Vy7Yg6psBw2gDz27wKw0T7EnnbjGA2BhrGglnVBOve2vhyLU67XRIJdfyYLtvq1sHB1SxREcLX2CT0JseoeQQz+/BS+X9ZGTmEMYKg/QCh4tPf6HVv/eDYf+s8yBNnqdhLO9wgSDfebkegWhrDa6EemKC+1L9r3yFW+MZc1hZyfGOtK03UpJRzIHQFXD1zwUY36pME/Y2+5eBj3xmG5flov40Q/e6UVGQJw0Ub36aYGvOEvkd5B+vpq8qE5ae/3xF7RE8IGuNViHlK0KtLS85h5zZ7jmQW3M4PQ8bYR1RSXWY2XVP8mPLwesUDbcXygWCPbi3SLyNT/NRn18ocAuIUa6tp3IabA1vBTR5HUt9dhntdE8y5nKPpbinFghlJU2RKElBgz8c5QpaMlTUoHyrZ+wZ8EXvjCYKrWjPP2OiDrTOVLsF52S7LN02qC/i121APhTMgPArKXhLErKdCKGQDBDnQPessCs1UGwt8px6aRGdOl+5XTMWGCHltGzSQo/XbgL17nGeBQKUNswkoGZrRFjAKzrdRm7iEGLNySLwR5pn+vm63uYDAkiCAy6yH8u4e1n9Hbxqr/eyIEiWKkJC2EK8LnLdkxxtrpzPTIOX7HcIbLC0afJT8WEPA8ELcdZ2dN92IZ5LyCTTB4Jzto0IC8OE/LurdmVYpU7xJY0x8sU7jK6EG4cZI01MFKZRZQOmpbHVX7sxu3t7mS/laNfL/MLb9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(6512007)(2616005)(36756003)(6666004)(6916009)(66556008)(316002)(107886003)(1076003)(186003)(66946007)(41300700001)(6506007)(2906002)(38100700002)(66476007)(6486002)(8936002)(478600001)(4326008)(86362001)(8676002)(83380400001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/hRFPOIzHAGcFgAcU9NdASQ3txg4aKpv9Qc7XNghMymOVWfZIxLHY3UemmyE?=
 =?us-ascii?Q?qLpJoCrukFl2QqY1nY4BgcPBoipJlqJ5fxN+nS3zr0/CEIRW3Epy2dJV+lsH?=
 =?us-ascii?Q?azL47yc9adI20YvSFg3ZpjQS0jSNFgTnH58wS59s3uUTgVmEcp2DqYAOkRkO?=
 =?us-ascii?Q?T5F5+NmYTNrazY6rFMF4kRlLRXVK2wO8m/MSMvxpj4eEEzoYR2zUir/1SSJA?=
 =?us-ascii?Q?LWSB2/6NsieSC+NUK4Lz1Bzb28HTvL99gNIBwAzIcujIQ3Kr4AMiOUnHjZv6?=
 =?us-ascii?Q?sVUGWFC62IB1hsyPHBMZiKB6cCQG5a/5Pk0mL9SZs9gdyU2LeArP0lYoMvfH?=
 =?us-ascii?Q?yUhZrX83ANtQLUa/ukQ5bGHqXP8s+3L/NZ7sC6b/NU/sOWlQLSnvNj/NuHw6?=
 =?us-ascii?Q?d1jX9grYAEKDCeJSezL7JU3Z7bq6RykSPyQp6OgxsYXo7u5GORz+GyeWCffn?=
 =?us-ascii?Q?ffQVcxy3hN5hpmWXendhZX6OyeXRcP3QHxroRUXUcqKBe7LQgmtep1ecSRiu?=
 =?us-ascii?Q?OUb3jZHqB3H13DJHipVEIo7B0Sxgti/6AwdlMRLVNm0L9Mqzhel+djKUvFMh?=
 =?us-ascii?Q?QSKJCg0ZHiLYJdDlftkKeOmJHnQ3UIn3zgUeanl4p/5uNExoQAIjTDL75K0C?=
 =?us-ascii?Q?1PbheN0ui6W32Jdi2bKWC0cNeXgNpPXR7yvidtGxrSSV65YCRsIY6cuZThd1?=
 =?us-ascii?Q?7b4VIQB/hHI3XyciyVg8dFVib59GgQHFlorZFIk45IG9/0e9fbF+0sC2jDGI?=
 =?us-ascii?Q?ZURhd01bzEM8ZHFN6aEToE1lFY3weWXUKMmLzKtz8smCRyfUe48GNaUttCXY?=
 =?us-ascii?Q?8lovdKnUNvij6nwCMakL4YylixWp/baGI276xkrksR+5f0GgpbvHjwSjxYIk?=
 =?us-ascii?Q?mXH9t7RXrroKMRNoerU0NnvKr6pULJAtwHTNqCpS2MEgBSOO0usthJybQFss?=
 =?us-ascii?Q?ApuHgW5B7gDqJmg18u9wMyElQc/51iP8yzQMRxUe84FqVhdKZT1FPjg81KiX?=
 =?us-ascii?Q?qbtUJ2onI0IN3tBCIePwA/+PvZwzRvEOeYUV61eCqc9qSjlAI2vsiRw2kvC0?=
 =?us-ascii?Q?2TDyJgJBdaUZtx95YCgJo2RR8T+ncFhv1jsclw9bwAw1jzMkML39LntTfofR?=
 =?us-ascii?Q?x/VBtz0IR5rMcspOgZgStYNPtFrmwYp2ypqwPc9jjhqbri8S/TvTubjpDNlt?=
 =?us-ascii?Q?s3F994Pjt6esVOOd5aPiuOnC2VcmPPG98E7RFV2Q9/axwFZ3SvCGEITO9++4?=
 =?us-ascii?Q?b/alXmMdzvbl5BfCJqJcogZFsL7hkA34qIZfrwyo6x/KooTbsksAocwPb0Pm?=
 =?us-ascii?Q?6IZ0sUHd4cztth9SqNPPlwrKraf/Yp23xbhlwt+DM21KfgVU/6aDSIveEJuR?=
 =?us-ascii?Q?wcFVT4Fx+mUzCGkTxI39GiIpOHQJXhJgW7SiPbeoYV/pJLaVE39StKRWo35S?=
 =?us-ascii?Q?nXooWpBuN1UmhmOdqggZ+XayGmDFXaa0Wqy7QDzQDjPsG7AOFAesyZ0vRsSP?=
 =?us-ascii?Q?nf+8i0PWLUxFVXaNw8JBUTECsUu02S8t/BRowWVk2Fe3QhWalZm8Q/MDC6HG?=
 =?us-ascii?Q?RSyLRGSkEs1cbGW4HwxSJjp7MzMq9XnE6nDCm2/W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09adbfcc-cf48-4731-79c3-08da580baf10
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:07:23.2260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4V2Pbn2ixqRiLSg1g8T/yM+3qiMN3QD67CnaadR0qPq+Z1tMY72TqNCA1anJkP+Dmt2+HWs5TsCz4po1kmEvlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, 'bridge_type' is an attribute of 'struct mlxsw_sp_flood_table',
which is defined per FID family. Instead, it can be an attribute of
'struct mlxsw_sp_fid_family' as all flood tables in the same family are of
the same type. This change will ease the configuration of
'SFMR.flood_bridge_type' which will be added in the next patch.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index ef4d8ddb2a12..279e65a5fad2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -71,7 +71,6 @@ static const struct rhashtable_params mlxsw_sp_fid_vni_ht_params = {
 
 struct mlxsw_sp_flood_table {
 	enum mlxsw_sp_flood_type packet_type;
-	enum mlxsw_reg_bridge_type bridge_type;
 	enum mlxsw_flood_table_type table_type;
 	int table_index;
 };
@@ -110,6 +109,7 @@ struct mlxsw_sp_fid_family {
 	const struct mlxsw_sp_fid_ops *ops;
 	struct mlxsw_sp *mlxsw_sp;
 	bool flood_rsp;
+	enum mlxsw_reg_bridge_type bridge_type;
 };
 
 static const int mlxsw_sp_sfgc_uc_packet_types[MLXSW_REG_SFGC_TYPE_MAX] = {
@@ -709,19 +709,16 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_flood_tables[] = {
 	{
 		.packet_type	= MLXSW_SP_FLOOD_TYPE_UC,
-		.bridge_type	= MLXSW_REG_BRIDGE_TYPE_1,
 		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID,
 		.table_index	= 0,
 	},
 	{
 		.packet_type	= MLXSW_SP_FLOOD_TYPE_MC,
-		.bridge_type	= MLXSW_REG_BRIDGE_TYPE_1,
 		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID,
 		.table_index	= 1,
 	},
 	{
 		.packet_type	= MLXSW_SP_FLOOD_TYPE_BC,
-		.bridge_type	= MLXSW_REG_BRIDGE_TYPE_1,
 		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID,
 		.table_index	= 2,
 	},
@@ -737,6 +734,7 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021d_family = {
 	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
 	.rif_type		= MLXSW_SP_RIF_TYPE_FID,
 	.ops			= &mlxsw_sp_fid_8021d_ops,
+	.bridge_type		= MLXSW_REG_BRIDGE_TYPE_1,
 };
 
 static bool
@@ -785,6 +783,7 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021q_emu_family = {
 	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
 	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN_EMU,
 	.ops			= &mlxsw_sp_fid_8021q_emu_ops,
+	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_1,
 };
 
 static void mlxsw_sp_fid_rfid_setup(struct mlxsw_sp_fid *fid, const void *arg)
@@ -1132,7 +1131,7 @@ mlxsw_sp_fid_flood_table_init(struct mlxsw_sp_fid_family *fid_family,
 
 		if (!sfgc_packet_types[i])
 			continue;
-		mlxsw_reg_sfgc_pack(sfgc_pl, i, flood_table->bridge_type,
+		mlxsw_reg_sfgc_pack(sfgc_pl, i, fid_family->bridge_type,
 				    flood_table->table_type,
 				    flood_table->table_index);
 		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfgc), sfgc_pl);
-- 
2.36.1

