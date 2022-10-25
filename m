Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B58C60CE58
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiJYOGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbiJYOFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:05:13 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41901911F7
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:01:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6bJnrBjjYnNBNFmkqA9L3OBec78bTTrLbLYG4EaXHIGYU9gZdnw7Zsv7oVovzW/fdF5t1TGN9whJrLn3KViPc2OSzN9GzViBM7+yTK9MsfdaMev9dwJ6HbQ+bb+FTwJnTO3UQrK5XyLp2QWzZMHf0qW1vZQtUp0ylQwX5LvSzLra5NeJxZ6LgyCICChQUXYPVgnA+KotAWWFxBe6h2gEeajBRWt7mfGBkrP8wiooUUvJGIjdwcm+J4n6cm2snj1kY2qOtpegc2g5k4UzO0v58PVtaffafRbdp0c6A+QvPqPZPLffi71PQ5A5UE4+QYu7M8oW1DPBMAX8HDRUG1Mhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lFzLVSOvDaYxRll3hPOsTDuGGbFMrRy6jGjwlj6/edw=;
 b=OZEc8f8+Ws/Z/ncrGEsBkkDyLy0i/2i3GSRhP2NbbUKz6HvJOwubCjxbN8LMcEjqYn0lsX1TssP16G+9yjCZJpF5QJSOCDM2kIGYYK6tx3ZKyvqagK83B27qQ+MlJSyfhmU73jc7tJd7Up8XmQxx631bd85Z1BKqFleWGUWUmJv1dWu5+wiKWuuQUJvCRAVuWGqHCEWM8eIAiwuOc/zLjKUsf0LfuRaI5F4ASuXlCCB03TvKj8CSAuEt6teu4LNax/OCPwVNDUBC+xtccv6EN/6DoLbI+MXe8z8iPsx+Bm3JuTo6ResrZo4PO4k6RsJk1fVMVpANTy6g53N4EBhBmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFzLVSOvDaYxRll3hPOsTDuGGbFMrRy6jGjwlj6/edw=;
 b=cbQn2C5rCLLCIjZzEAqHKg/PenbPThGd2WubWVO2SMBLTq+1Y+bsCSKVQuccbqRHr2bcSkGQdhDkia8SEd+F4zXuTAsrHLWTqQJiHIh3tqgHFwFqQu6IaNLSgRsrshjsWWMyxK11ep/yZe/pqn6wOw1xVNAvr8nI32aHW9Reiad/tf+BRkSUBgCSP3Aveg3PUgiN3ByiPHY4IRyTwme6gkME4rADoFwd7/XaxLuHXvPvQBoBmc7TBL8Px6PpqRoPGPfRNYouWuoOwMxWkaUuwdBVvmtT/9hgOCGZlCzDZgabAxnpv4xXabJLQbo69lrM0TVzV3Uf820cRINpbPZs3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5279.namprd12.prod.outlook.com (2603:10b6:5:39f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 14:01:48 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:01:46 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 17/23] net/mlx5e: TCP flow steering for nvme-tcp acceleration
Date:   Tue, 25 Oct 2022 16:59:52 +0300
Message-Id: <20221025135958.6242-18-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR0202CA0070.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::47) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5279:EE_
X-MS-Office365-Filtering-Correlation-Id: bd0e4c8f-9077-4f6e-feb4-08dab691743f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5BTLOt+Trjl86tPNUFalXWVW0eCMyRrxgNj0vhbF9W0qQmK1PxNEJzEo4QZE9xqd4IxRYnFmyqPZDY2yzqU3M8pBL+omkTYesRxy1rwNHpbjObLuwBh9k8Ivun2Ug53l1c2E8xWGIlxa1w3x17ACw1iqJW1k4W2NEs4dBOnNWqGfuUnjW1S9ObO7yUXxAOdHPmyOwHsTcwnxROiDVt1H85KL/QSIrXpV4Rq1jJkIa31lHeuV1OtcGZFy8zYEf/uHlNPxYBGaF44dknoS0LRhWJTrxDCs/G37nmzUIhKXG4iQjRxRTZMuqRFTI6ePvy4lltUFfeMbKxJJ/XAp2txiSMWjj3AP5vEm9ACzni9MJpeLqgT51Lym0h1hcU6X349VD2736xYLhius+34uQ0RCsP4Ob89C7xeCCvJMMq/q4bT1Oat+MlTrHOqtlaIoHlWdIWYfzOsFxsSErvm9YdqtN8GtEuaplobddQVqm66/ZWJGzAcD+aZMa1RqBJnAe4FpgOh6TSfCxm38IjlgezPUcHxxqKrABE3RQjkfPeNsF2fShSeFADMlRrEUTclBqLFhCb3O9JqXvDyW5cEMyjQEzeodD/766qA42krGgBRd4cG2t+0vXI7wwpxCutGjTR/me2Jh6WO35Z/1aLtZOdQT9uJlC7/69SqN915wXJDE6LffNJF4aBbYojIihIKXFYXbcqF7YdgNN9R+suZ8odmL854/mNq9ZeNOXXSO7Ihw0vf7wv9aVnWaJo3vO2Pn8GDc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199015)(478600001)(6636002)(921005)(6666004)(316002)(6486002)(6506007)(2906002)(36756003)(66556008)(4326008)(8676002)(66946007)(66476007)(6512007)(186003)(41300700001)(86362001)(26005)(38100700002)(1076003)(2616005)(83380400001)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8RMQWfi1HNEBR9sKvIV+zv+5UQ4XhkwPFRSFMMKvEz4U1uU6l4YhaKDsZOM3?=
 =?us-ascii?Q?P+jaNktkiIl3GqgjiceFoWz35TXycYBlRbkvDdlljNbJJ0nI1owZg6wrGejz?=
 =?us-ascii?Q?jePd9v52OlVOAXBBQ3GqxpBMGib/CdDxJDSg5tnlbqX5pG+9m0UeQVtcsQ/K?=
 =?us-ascii?Q?S7X4Bg2FwuHeocJrcM3Rhr6eyUCW4aC8+cHqrE5aJr1CCXFwf0XBRZfpPmba?=
 =?us-ascii?Q?yORy9yDVt08sobAqRVrOU3wqCPrAR9cyE/40tTgqSbuZAt/PuhrCQp2p6+FX?=
 =?us-ascii?Q?nCguujrgpU4Lqj++pG6j6r8kn/dWur71BfE24+eWWW/NeoGzDNciPqnZZcnt?=
 =?us-ascii?Q?wFVaqMF8vYPhljGqwT05FdOreG1z85wBm67dSmyvBEbNbWkCRAqOuy6Q2aYa?=
 =?us-ascii?Q?f1wqx7BW0ZUnKhqfGUlfemH6ve4edTVr54EOkqtON41RbkZRID+VCd8YJv+D?=
 =?us-ascii?Q?w+mBLNLOy1dkX1VO/7W0mM6VutSfyuI1yJX46iHOIj2SUrcX589J79n5gPOl?=
 =?us-ascii?Q?fcFAsaFZ/8IvVAuarPmZqtiYFP78mkpT4SQii+2iDZPf00yoekobDu3TNEg7?=
 =?us-ascii?Q?aNq8c2aBdoGhO1P4Me751ePADV59ZI9KEDfDa5Cv7cVG1hg4JFaaofzzNYCb?=
 =?us-ascii?Q?Tx10gBEsSKiWi7LgMxo1h+gassT8ycVdSh8I7V2TbO2Fjcrghno2qVvb4egm?=
 =?us-ascii?Q?FgeYmTMIkk6YCAuPYzy4GiYviVI6tAI4Mko2lXQBuGOnHBvn2yXSueZNGEGv?=
 =?us-ascii?Q?ou0LqX6otqI4KvRDACs8QMn5UpqrSayX5T7YxzgrxXuhLkJPvFIUNpAQF9e9?=
 =?us-ascii?Q?dDvAOYnU1196Aun3/GoExCliqW9Ay6vtMxVb69jgHfa8fg24Oaehagpe6z17?=
 =?us-ascii?Q?GxIGFbvd0zVZismcQQdm6MKBNGx1byZKKI+hA0fUmuLwka8Rr23bpRdIOl93?=
 =?us-ascii?Q?to4Ofv/ip9GxUnK+J6SL9VxXMpRf+xaW0p4911AaFqaPTxf2EKvjec3d/HS/?=
 =?us-ascii?Q?/Z8uoswUDfi2jxcD8fOy6V12P1nBXI5NYvso0/YQ2ZLhIJ3V7a/tLqPy1B7o?=
 =?us-ascii?Q?gVF6soUN/beTprqMmTkDxSvXMt5PBMnz8f7xqpSHbNs1s4SnqR+aojccd55M?=
 =?us-ascii?Q?UrBUMWsxxiw4jGMZbT6Y1ibHrN2GFHBAYQTHPsCks7CEfxUOU663/vayNaZ9?=
 =?us-ascii?Q?EobNQ5UimJSBU0QNnT9b34VlS7S74S7lEuURQd2XZ9+oFFxqOZAFSgapiWUe?=
 =?us-ascii?Q?0Qb6vRyUDBL1Rmw8mE4oHFSFjstuh4Rz8Fd6RC/1+ZwAqUYAoY99OtV/87b8?=
 =?us-ascii?Q?0q7Rf32QWnz0olABQNO5oNYTesLjyH33BSRdGgYfzgoP6CFZ7MP60zePhBXg?=
 =?us-ascii?Q?5zjYrHwjl7FU2/T5/iclfmRQZ82UPGjgvMJ4IOvDiKmGZ9JEEQcJFrSd7VzK?=
 =?us-ascii?Q?SDY1FuJuUukZ2EL0sDJFgQ826IBjK5jgeJMsfBvX6EDYJO6ogKonoX+9Tk13?=
 =?us-ascii?Q?7+Dt8X5yOzQ/fWjax5kPxM/5j0tWXSdKxnM0wo5X1bQlEAVCB9WKVoE53fSD?=
 =?us-ascii?Q?jfrZj1wDIO2df5mHJE+IyUYhmpaqwSE0oplLCua3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd0e4c8f-9077-4f6e-feb4-08dab691743f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:01:46.5241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQd2hT/yGSy+59F8dk2aYyDQJz8rnHjgcVdWm741GB4gwPFnjjxy8QIzFk1G9DPqGZBPmyWDrglYgx8c2VIyCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5279
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@nvidia.com>

Both nvme-tcp and tls acceleration require tcp flow steering.
Add reference counter to share TCP flow steering structure.

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c    | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 285d32d2fd08..d0d213902bc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -14,6 +14,7 @@ enum accel_fs_tcp_type {
 struct mlx5e_accel_fs_tcp {
 	struct mlx5e_flow_table tables[ACCEL_FS_TCP_NUM_TYPES];
 	struct mlx5_flow_handle *default_rules[ACCEL_FS_TCP_NUM_TYPES];
+	refcount_t user_count;
 };
 
 static enum mlx5_traffic_types fs_accel2tt(enum accel_fs_tcp_type i)
@@ -360,6 +361,9 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
 	if (!accel_tcp)
 		return;
 
+	if (!refcount_dec_and_test(&accel_tcp->user_count))
+		return;
+
 	accel_fs_tcp_disable(fs);
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
@@ -371,12 +375,17 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
 
 int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 {
-	struct mlx5e_accel_fs_tcp *accel_tcp;
+	struct mlx5e_accel_fs_tcp *accel_tcp = mlx5e_fs_get_accel_tcp(fs);
 	int i, err;
 
 	if (!MLX5_CAP_FLOWTABLE_NIC_RX(mlx5e_fs_get_mdev(fs), ft_field_support.outer_ip_version))
 		return -EOPNOTSUPP;
 
+	if (accel_tcp) {
+		refcount_inc(&accel_tcp->user_count);
+		return 0;
+	}
+
 	accel_tcp = kvzalloc(sizeof(*accel_tcp), GFP_KERNEL);
 	if (!accel_tcp)
 		return -ENOMEM;
@@ -392,6 +401,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 	if (err)
 		goto err_destroy_tables;
 
+	refcount_set(&accel_tcp->user_count, 1);
 	return 0;
 
 err_destroy_tables:
-- 
2.31.1

