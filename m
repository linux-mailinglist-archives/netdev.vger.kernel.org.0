Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231BA564D92
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbiGDGOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbiGDGOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:14:16 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2087.outbound.protection.outlook.com [40.107.101.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D990764C
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:14:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtMklhGbsflpmnyF57gD/LoJMxILzGPeCgNSqV7ggbtwYkIANQfZzgEuE2t6hemAAr0thBL+lwTNr4fj1+ZMsgLtpXJyJuYwNeqbaGzzPa1sxQ8fQ4uzUx/pacnKDRXhtUFLlyCu+xCUugsuB0qmefSZmcJIXY53hMJG0PfweGfTEYWaLX/r7icHcwgFrEo5d0DN96PX9aBO+yqPYnPpms2iuzZ+k2Z6G7A14U2KUrtMoCzrfUke7EwWZ2r+VRIPLPMf9hgH0/9jG652RYprpfht1TUQwgVXuoJIT9FqVrOGgwxwLNwcAyS+eUOP7tEJduoy3YW8aj6Scj0Ex08bAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCHPoWPLn1qzvU8wqWsXK/cUBrFzl0jSLOpNkKzk6Mo=;
 b=EG9zPq5peVdbLVV89/XUDwNTGCzJPONFao+Z4jz2hu+/kU7VByMVkc/efTl1jn+YzU5dEvFKhytwUdCeK0NjFDKFKXJllhIg6lOONxtei/bh+OiFDBkIi06NnvHEshgcZ1/AH0jzN3dGeXoXVw9p0TeqXfahjkj1jLnRlQzKFr/Kv5gKF721QW6Lm6tCjZHRXsLAFVx5d0IDUf6HArfxmgNHLdxzTV1RoS8/CBO/YHJhB1W9VpqXCE8PiPSqeefVFRoIa4BM3zS6EZCd1CjnTKa9Tnty1inp/guAHet/jOIKhoijmMbLYXW01C9XRS6Fbdn8YQCvh24ltJw8s+kIng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCHPoWPLn1qzvU8wqWsXK/cUBrFzl0jSLOpNkKzk6Mo=;
 b=oniCxHr6GdJ5JYOhXOxO1htsDU5kcDshEHGm5jt4gO5052qEl+EwmFXxSzr76CW8YTyoPSOCcp/qvnXrvUrSW9+YU/w/6WvJqoBepVeqRkfdIQS1xdEuCUC3VS1b2YQFbOsD1fTlk3XoPL7a4zQVwNfysvpEkKx3nUjGJ7+qYsuLKnrDnMLrq18Qal4EaGP1Qjp4aJwCHNAwmy3lblvQn8G5VihCrJeXaZyX3dSq93zeEAdn3sGWxsCmMenlqlGCHgKG7DUzEGyhxOuQr50M5QKAh18/EOKGVk6WpXj7+d0Z3uZv7ummzZnuQDOvQ9XDVLUrM8Ksh10yNBKrtH5Lrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY4PR12MB1862.namprd12.prod.outlook.com (2603:10b6:903:121::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Mon, 4 Jul
 2022 06:14:13 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:14:13 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 13/13] mlxsw: spectrum_fid: Remove '_ub_' indication from structures and defines
Date:   Mon,  4 Jul 2022 09:11:39 +0300
Message-Id: <20220704061139.1208770-14-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
References: <20220704061139.1208770-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0028.eurprd05.prod.outlook.com
 (2603:10a6:800:60::14) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d43eb05d-e7be-4249-0546-08da5d846a5a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1862:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QAF8YFIj/kBIFGMOXue/gR+vJa7kPUkT9ByVOmFNiRIwQpf2yXGRYnLWr1sNxZs0WpqMOmBsJtRvYvsVObzK2KdqofhJLI0d8kV5dBTJEZTYcRBI/S0GeTr47sx9sQHucqI+pkMOz1/WY5PWkY/NLOlphqUy3XlKdoz+ZNz6AMlpA3ZNxwq2uQoiZ/awLeHrFHA2oG+YkrDTdsCguz2LrN8Yc8K/T1zzYfWHdNwQVAw/vNpkVGrInIEk0ayxKZ/EbPSvBlbC2S38Tu3U7OZf1ax2eX5VEoeXEQfncWI3AR8xRfaAzaBJWVJ1I9CRj/Xef1GhilkicIF8LAOm0b5PuIFbMtZLb5cmptuYNzbIxd3sX8OBki0jDF7t7lHdEhxdAEznmwxJpjdVTKFlUxq0CQ5bfJyQyCMrS59KJSP4EV6TJGzpX7u+bzKc79jL3w2rDawFKbeVLqcmnv/PJjww4Rx1whS6hEYBckbD01or/G3n3Df2DP0m0t29EC5vne3W9QH/BycTau/O/rrNkJUgQLZRxgt3I6qdoVYihztfgl/j1jrbCxOQTLDFy4kuQRi0B+ZPvgoLTpbs8VlnFCO9NCTUXKN+9NDejLp7wOrcqQwL2SxGlLfBWmYUOzTiGqEN9SZJ4CIjS0HkqIgl99dXbbo3jv/ceti6wRnRqg9BVgLj8x3OUo5AYRB2zUYBDPo13TKg9comODzPeB//M6ujIlzDvKQwHLcDJmAwj5Mz9uvXv5bTkkWsIoOCvb4zV6yDM0DwunaaZNz0ggtW++3xoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(2616005)(38100700002)(66946007)(4326008)(8676002)(66476007)(66556008)(478600001)(6486002)(316002)(6916009)(26005)(6512007)(86362001)(41300700001)(6506007)(6666004)(8936002)(83380400001)(36756003)(2906002)(5660300002)(1076003)(107886003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rCMFuVwA6ipbGrnqypxd+/k3hBi6DeAFOa1HS++K/X28GjEixlbcfZvtbHrA?=
 =?us-ascii?Q?DdQHFT5qVbK7ULRFjLiZjGA/haC1ZMQf0dOPtM9oy5WEcdd873EQb/0vTVMp?=
 =?us-ascii?Q?KgU7wBO7TrVk/datiknH8yGxOz+uV5WlezoTShn9Pcoz07PbGDA1w1M355t7?=
 =?us-ascii?Q?hF0v3viqAiKymqCZpTGwvOq3rjlQoWyO/PprdgqeeB4LqD6HfPHWITd1XYPX?=
 =?us-ascii?Q?k6rVREkHceSPsgiQ8ztS/GhwxSIwE+IK5Cq5vsXG1ezoWktIEEACIgY7qKfG?=
 =?us-ascii?Q?i3VMVHoyS4Kdk02lcZmxqcq0tws6A2MplCxKdeWCed+zYk6iIpcqMs9s4R3s?=
 =?us-ascii?Q?9aM7ONqHp6IbjmMYgfDOzMghmTRUgvcbnpr0MCrKGQa1JBWVURkTuDIhLp+5?=
 =?us-ascii?Q?ypSt2GDVqemp9NXSc5tT+0PaagJkzU+ZuRzCIDQVIT8pYE/E5c4fFpMjvko0?=
 =?us-ascii?Q?amBFl420l9uLUWKp5vdL/eNfM9GB10gu16j/oGgj5OJG6TEPofqVEW0t5JCh?=
 =?us-ascii?Q?LpoPiFBt5HMDBz0nwB8lBKoEUVh9YgF1rvW5hPC7S1LI5j4XOUjsqjNQ+xCB?=
 =?us-ascii?Q?bRrjc4y3Z6Ao5g/D6JTnpGHrqC7GvTIm6rsufabpMrxWcrI5BvsXddL5woxa?=
 =?us-ascii?Q?x9K6Hi9tYu0Ly+iyy38JBzY+1FJ6Q57l4XUdC+ticEzh3ouKsTi6N+mwOlA3?=
 =?us-ascii?Q?kzOjkelEBVRK4upKuuZwA23LoGZGpn9ifbpPMHVNKANRf/0j1MgN1Y8qmMpX?=
 =?us-ascii?Q?AsNaa3jFqlDoGZGNvCVHAESLUZsILnDuzRp9cBwP/xmPwuNcOU6DKLgWdWc8?=
 =?us-ascii?Q?yxHykZFXpkFYVighBVGqlWWBnM2so+HP7sIjZJIrFX64poBHXWU2W71P4yfp?=
 =?us-ascii?Q?JHTdplGxz7YWJ8vXmBhWgv5GIGbBYCRsqBgzDdy7OsfbqLmBuSOOZD38EOmx?=
 =?us-ascii?Q?sXnnPv3q8LhcKNy0ogN4D8u4EClMV9JYmBcx3W1A2itQMC5NOlK1dw5LigN+?=
 =?us-ascii?Q?BKp6e0EQ1fJBdIwV656NtjK6qhRpdyaZ3VUnT+vy6/3Q9nrYieOatOQfdogn?=
 =?us-ascii?Q?MNnymL9Kco4sDs2mbKDBin+rHxM2+4TKQnYYNdJeB5kvzTL8QNsMB/PeyDIY?=
 =?us-ascii?Q?OnmJyLgT9xPFD80K6SD1eN93OPUiWuR5h5e1W3897RpMHamB9QdkZ+aw7IcL?=
 =?us-ascii?Q?khtuNQkY8c3GfCY/LQfG7l7hCYOb5uVM9uEIk1nhcUT3XdvqJcx2MzGDrkn9?=
 =?us-ascii?Q?Wgj1QpVbzpRYXf2QKbKBhhH6NQg41aHi1WYVbSL4l7r1O2HOimzGm9WiIavf?=
 =?us-ascii?Q?cR5DIRu0yl9HF93aezd9Xa9EXXa4lVpcu7Z/5WC0MWBXYFEtBtGK13rRE4Dk?=
 =?us-ascii?Q?fwjK3vM5D4oU2C/AfNc4xZD75xWSOqmLmUyzof8T8wzzyztnJGxjFHexvfP8?=
 =?us-ascii?Q?x7W2tzj0fwCBgcL76WFaviwg4of4t74po09pgP/weq+RhBVzK4ObgCi2Hi/Z?=
 =?us-ascii?Q?UcPtqAhgc1IOafJ1hOctkgULeGe6WQLLnnU/VxrUq/I+MhQVxAqBhMOdJxau?=
 =?us-ascii?Q?KdrrmuW6Dh9pTi0blU1ys9UIGeVDp8Miq2N7aABA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d43eb05d-e7be-4249-0546-08da5d846a5a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:14:12.9884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4KWudLq9oeknIaQ9+iJFUSQHyq2TYaLDNcYJcaXSALTuf14pOENdFIkktooW/hj3/n4pTA2NWIjp26Op5Iz00g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1862
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Some structures and defines were added with '_ub_' indication, as there
were equivalent objects for the legacy model.

Now when the legacy model is not used anymore, remove the '_ub_'
indication.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 94 +++++++++----------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index da581a792009..045a24cacfa5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -1077,11 +1077,11 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 };
 
 #define MLXSW_SP_FID_8021Q_MAX (VLAN_N_VID - 2)
-#define MLXSW_SP_FID_RFID_UB_MAX (11 * 1024)
+#define MLXSW_SP_FID_RFID_MAX (11 * 1024)
 #define MLXSW_SP_FID_8021Q_PGT_BASE 0
 #define MLXSW_SP_FID_8021D_PGT_BASE (3 * MLXSW_SP_FID_8021Q_MAX)
 
-static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_ub_flood_tables[] = {
+static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_flood_tables[] = {
 	{
 		.packet_type	= MLXSW_SP_FLOOD_TYPE_UC,
 		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID_OFFSET,
@@ -1416,30 +1416,30 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021q_ops = {
 };
 
 /* There are 4K-2 802.1Q FIDs */
-#define MLXSW_SP_FID_8021Q_UB_START	1 /* FID 0 is reserved. */
-#define MLXSW_SP_FID_8021Q_UB_END	(MLXSW_SP_FID_8021Q_UB_START + \
+#define MLXSW_SP_FID_8021Q_START	1 /* FID 0 is reserved. */
+#define MLXSW_SP_FID_8021Q_END		(MLXSW_SP_FID_8021Q_START + \
 					 MLXSW_SP_FID_8021Q_MAX - 1)
 
 /* There are 1K 802.1D FIDs */
-#define MLXSW_SP_FID_8021D_UB_START	(MLXSW_SP_FID_8021Q_UB_END + 1)
-#define MLXSW_SP_FID_8021D_UB_END	(MLXSW_SP_FID_8021D_UB_START + \
+#define MLXSW_SP_FID_8021D_START	(MLXSW_SP_FID_8021Q_END + 1)
+#define MLXSW_SP_FID_8021D_END		(MLXSW_SP_FID_8021D_START + \
 					 MLXSW_SP_FID_8021D_MAX - 1)
 
 /* There is one dummy FID */
-#define MLXSW_SP_FID_DUMMY_UB		(MLXSW_SP_FID_8021D_UB_END + 1)
+#define MLXSW_SP_FID_DUMMY		(MLXSW_SP_FID_8021D_END + 1)
 
 /* There are 11K rFIDs */
-#define MLXSW_SP_RFID_UB_START		(MLXSW_SP_FID_DUMMY_UB + 1)
-#define MLXSW_SP_RFID_UB_END		(MLXSW_SP_RFID_UB_START + \
-					 MLXSW_SP_FID_RFID_UB_MAX - 1)
+#define MLXSW_SP_RFID_START		(MLXSW_SP_FID_DUMMY + 1)
+#define MLXSW_SP_RFID_END		(MLXSW_SP_RFID_START + \
+					 MLXSW_SP_FID_RFID_MAX - 1)
 
-static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021q_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021q_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021Q,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021q),
-	.start_index		= MLXSW_SP_FID_8021Q_UB_START,
-	.end_index		= MLXSW_SP_FID_8021Q_UB_END,
-	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
-	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.start_index		= MLXSW_SP_FID_8021Q_START,
+	.end_index		= MLXSW_SP_FID_8021Q_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
 	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN,
 	.ops			= &mlxsw_sp_fid_8021q_ops,
 	.flood_rsp              = false,
@@ -1448,13 +1448,13 @@ static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021q_ub_family = {
 	.smpe_index_valid	= false,
 };
 
-static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021d_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021d_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021D,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
-	.start_index		= MLXSW_SP_FID_8021D_UB_START,
-	.end_index		= MLXSW_SP_FID_8021D_UB_END,
-	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
-	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.start_index		= MLXSW_SP_FID_8021D_START,
+	.end_index		= MLXSW_SP_FID_8021D_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
 	.rif_type		= MLXSW_SP_RIF_TYPE_FID,
 	.ops			= &mlxsw_sp_fid_8021d_ops,
 	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_1,
@@ -1462,20 +1462,20 @@ static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021d_ub_family = {
 	.smpe_index_valid       = false,
 };
 
-static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_dummy_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_dummy_family = {
 	.type			= MLXSW_SP_FID_TYPE_DUMMY,
 	.fid_size		= sizeof(struct mlxsw_sp_fid),
-	.start_index		= MLXSW_SP_FID_DUMMY_UB,
-	.end_index		= MLXSW_SP_FID_DUMMY_UB,
+	.start_index		= MLXSW_SP_FID_DUMMY,
+	.end_index		= MLXSW_SP_FID_DUMMY,
 	.ops			= &mlxsw_sp_fid_dummy_ops,
 	.smpe_index_valid       = false,
 };
 
-static const struct mlxsw_sp_fid_family mlxsw_sp_fid_rfid_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp_fid_rfid_family = {
 	.type			= MLXSW_SP_FID_TYPE_RFID,
 	.fid_size		= sizeof(struct mlxsw_sp_fid),
-	.start_index		= MLXSW_SP_RFID_UB_START,
-	.end_index		= MLXSW_SP_RFID_UB_END,
+	.start_index		= MLXSW_SP_RFID_START,
+	.end_index		= MLXSW_SP_RFID_END,
 	.rif_type		= MLXSW_SP_RIF_TYPE_SUBPORT,
 	.ops			= &mlxsw_sp_fid_rfid_ops,
 	.flood_rsp              = true,
@@ -1483,19 +1483,19 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_rfid_ub_family = {
 };
 
 const struct mlxsw_sp_fid_family *mlxsw_sp1_fid_family_arr[] = {
-	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp1_fid_8021q_ub_family,
-	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp1_fid_8021d_ub_family,
-	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp1_fid_dummy_ub_family,
-	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_ub_family,
+	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp1_fid_8021q_family,
+	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp1_fid_8021d_family,
+	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp1_fid_dummy_family,
+	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
 };
 
-static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021q_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021q_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021Q,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021q),
-	.start_index		= MLXSW_SP_FID_8021Q_UB_START,
-	.end_index		= MLXSW_SP_FID_8021Q_UB_END,
-	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
-	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.start_index		= MLXSW_SP_FID_8021Q_START,
+	.end_index		= MLXSW_SP_FID_8021Q_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
 	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN,
 	.ops			= &mlxsw_sp_fid_8021q_ops,
 	.flood_rsp              = false,
@@ -1504,13 +1504,13 @@ static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021q_ub_family = {
 	.smpe_index_valid	= true,
 };
 
-static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021d_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021d_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021D,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
-	.start_index		= MLXSW_SP_FID_8021D_UB_START,
-	.end_index		= MLXSW_SP_FID_8021D_UB_END,
-	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
-	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.start_index		= MLXSW_SP_FID_8021D_START,
+	.end_index		= MLXSW_SP_FID_8021D_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
 	.rif_type		= MLXSW_SP_RIF_TYPE_FID,
 	.ops			= &mlxsw_sp_fid_8021d_ops,
 	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_1,
@@ -1518,20 +1518,20 @@ static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021d_ub_family = {
 	.smpe_index_valid       = true,
 };
 
-static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_dummy_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_dummy_family = {
 	.type			= MLXSW_SP_FID_TYPE_DUMMY,
 	.fid_size		= sizeof(struct mlxsw_sp_fid),
-	.start_index		= MLXSW_SP_FID_DUMMY_UB,
-	.end_index		= MLXSW_SP_FID_DUMMY_UB,
+	.start_index		= MLXSW_SP_FID_DUMMY,
+	.end_index		= MLXSW_SP_FID_DUMMY,
 	.ops			= &mlxsw_sp_fid_dummy_ops,
 	.smpe_index_valid       = false,
 };
 
 const struct mlxsw_sp_fid_family *mlxsw_sp2_fid_family_arr[] = {
-	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp2_fid_8021q_ub_family,
-	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp2_fid_8021d_ub_family,
-	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp2_fid_dummy_ub_family,
-	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_ub_family,
+	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp2_fid_8021q_family,
+	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp2_fid_8021d_family,
+	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp2_fid_dummy_family,
+	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
 };
 
 static struct mlxsw_sp_fid *mlxsw_sp_fid_lookup(struct mlxsw_sp *mlxsw_sp,
-- 
2.36.1

