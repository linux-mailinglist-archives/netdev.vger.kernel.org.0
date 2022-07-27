Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D0458236B
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiG0Jo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiG0JoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:44:22 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D0C47BB3
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:44:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M12vHw83/AGdjY0d/Rk9bbYgEoj3iWdbw1bN5cgbYNn71h+v6PfwzoKe5NlONJtwcjRK8pQ8f6ufEAVi9ljCmfRGuZoS7wc3eDa7CPXgx7+O01fRfwlc6tkIfqa4YVpB2kK9J3n0gTHiOhtJIHA3KqMjm0Jz5K6yZxSIP/xk3BCs+ZQfJYerdwIzU+7hdDhp0GkutIxRXSU1ouKHlBJkUpti7LqaOzuOPyfNDG9pgAsNnFsXkTN3WWz2BQ2ddLJijEaNrxvBCqLOYOu1QIwW7yOM3X6W+Jwv6HfISZgEaC4C82wInz74FzgFEi1qU2x0pOhyb+gfYz22Ere2G1tsyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UW3yLImHEDxQj807LUd3qS63/3DWM1RXr75b5qaYC+A=;
 b=V4VQQvkkySDa9dke6mrHTBZG7FbV4atIUX0ew+gRFTfdXj+po0jzhnEHNnmEoBNgoyqaxEjIvSnvd2mD/Hu/SDMC6RVZjlZjWIoctrH8YgpMeMLObMYYNA09EewJbqj617yvUTOZpjWcSUV70/3TAVAn07QfdGi0KGu90s0RvfTdRlmw091CgM/OZsJ5mHGRkpX6VYJyF1JZNprgLN7fkhlwQhGCcHzgKFKEzeTNnkyU1LVYZpeBDMDTO+IOIOnoAVQyq4j8THyO9lNdopS/PnDbdZa4y+2RUlcxFykAK7DxRS8S07HIgrQeamWCDzHIKu1VTJHwu3+J+0KKywYP0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UW3yLImHEDxQj807LUd3qS63/3DWM1RXr75b5qaYC+A=;
 b=ll7ph5gL5gCk6MgVSypf21oVHljow0BAaDe1bHMc71Wd2ciAlwWqChDEiUhrvHiZcVW7jaPHGe2PkZBT5cs5LYio2XWVSuXz1aDADYeqP8gd+fRtVs63CsHKATcunMTbe2Y3PaboHnoQwjT5E4AIz/1EMvaFHvgavJI8RD1YMbAzetbUD9S8y52SzCbcmb4mfhmByzl0GZabUnavfnS6lJbCB6damX6bHR7x8NJ8ofqw4KcoFFcBwfuYtuIwKhmsd8yMm0R4sI7qrd6ijKhWdkgEb/1HgLzn9MKqCJmsJ6oZ9/YHAb8md16WQn6XcxgckAnyTBiJCTM0HmUY/B0e1Q==
Received: from BN0PR04CA0064.namprd04.prod.outlook.com (2603:10b6:408:ea::9)
 by MN2PR12MB4469.namprd12.prod.outlook.com (2603:10b6:208:268::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 09:44:19 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::b8) by BN0PR04CA0064.outlook.office365.com
 (2603:10b6:408:ea::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Wed, 27 Jul 2022 09:44:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 09:44:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 09:44:18 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 02:44:17 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 02:44:15 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V3 4/6] net/mlx5e: kTLS, Take stats out of OOO handler
Date:   Wed, 27 Jul 2022 12:43:44 +0300
Message-ID: <20220727094346.10540-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220727094346.10540-1-tariqt@nvidia.com>
References: <20220727094346.10540-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f944a5b-71b0-4e4d-c6b0-08da6fb493e5
X-MS-TrafficTypeDiagnostic: MN2PR12MB4469:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DobcObyZO8axAB//VY3J6uxJcB5LIBajkU6NONszUjPUmaWwnmk8GT0Gki8BXePux9JYUgN93F/UZn7Vr5AoEHFhDnUg/I/cAO0JdkRc7djKWWuYyb0bmhAs4AIDq4g9OImf6GON4EP1Mw5hc0wFio+oUXs22dB+OhRy2D+JiI+avUtiNCiTbDsSooKNQRVHZKjjq1RIUHaOoaDVegKgX5f4KsutUQmrMKfcgZK4lzdNnrelBrCsCZpN13qXdvtadMdIoqnQnkcIsBOhcLNKpGrpcSzbyZ74W+VvIVcvTNQaqdP/uGNzonMup8FPdm28wf1xkxhynF6P5H81xt54A0Cb5wXk3T/DGuI5YZSzKdrwE0887wU3ITWSUnRTAcLShkhmHcVvGmLsx04DWHPrUqJEuN+vvCuiR31r7IpX+l4+YbHtB6/pvTWpJz7vRtUeaWjk3ykKKjMv4uZg2KgvctKHoF8P98VbfOpbKTQC3533w1P7LWH2uGsmzuoIN2JM8IzxAPSvu0ruhBNcutI8KbGsIhcbl2fZJZGeuMvymXpmG6pCtfVPx/ccynU3Ah7MyO+bXzhsdEu/unTWKm479GaG+3AcgDjkMJ3LJSL66VnKm8KldrhaTHgwkTbxxL43vu9Hc62jc2l+K1JKQiCUNzsnJODTnewtK63WF1lJj7DFx4RBNpNPLpGeCYaywhXHDRGiWCWdYZIKpuATyT5/3bEumuZb2aJUD5Dn8haUKrFkaVz7Xpp/7NPAjGKd+2Kle5pJ2pTwnYd0QnMm4S07r6b84/jKBg1kDCFQZBPDq/GtNiuQd01fw/zjnzUXRZiwWfE8gl1wEFU/vtNRIWHf6g==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(376002)(136003)(46966006)(36840700001)(40470700004)(356005)(5660300002)(186003)(82740400003)(82310400005)(4326008)(86362001)(336012)(8936002)(1076003)(81166007)(36756003)(426003)(70586007)(6666004)(7696005)(26005)(36860700001)(47076005)(41300700001)(316002)(107886003)(2616005)(110136005)(83380400001)(478600001)(70206006)(40460700003)(8676002)(2906002)(54906003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 09:44:19.0577
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f944a5b-71b0-4e4d-c6b0-08da6fb493e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4469
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the caller of mlx5e_ktls_tx_handle_ooo() take care of updating the
stats, according to the returned value.  As the switch/case blocks are
already there, this change saves unnecessary branches in the handler.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 27 ++++++++-----------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 73ba2501e441..82281b1d7555 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -381,26 +381,17 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 			 int datalen,
 			 u32 seq)
 {
-	struct mlx5e_sq_stats *stats = sq->stats;
 	enum mlx5e_ktls_sync_retval ret;
 	struct tx_sync_info info = {};
-	int i = 0;
+	int i;
 
 	ret = tx_sync_info_get(priv_tx, seq, datalen, &info);
-	if (unlikely(ret != MLX5E_KTLS_SYNC_DONE)) {
-		if (ret == MLX5E_KTLS_SYNC_SKIP_NO_DATA) {
-			stats->tls_skip_no_sync_data++;
-			return MLX5E_KTLS_SYNC_SKIP_NO_DATA;
-		}
-		/* We might get here if a retransmission reaches the driver
-		 * after the relevant record is acked.
+	if (unlikely(ret != MLX5E_KTLS_SYNC_DONE))
+		/* We might get here with ret == FAIL if a retransmission
+		 * reaches the driver after the relevant record is acked.
 		 * It should be safe to drop the packet in this case
 		 */
-		stats->tls_drop_no_sync_data++;
-		goto err_out;
-	}
-
-	stats->tls_ooo++;
+		return ret;
 
 	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
 
@@ -412,7 +403,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 		return MLX5E_KTLS_SYNC_DONE;
 	}
 
-	for (; i < info.nr_frags; i++) {
+	for (i = 0; i < info.nr_frags; i++) {
 		unsigned int orig_fsz, frag_offset = 0, n = 0;
 		skb_frag_t *f = &info.frags[i];
 
@@ -482,15 +473,19 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 		enum mlx5e_ktls_sync_retval ret =
 			mlx5e_ktls_tx_handle_ooo(priv_tx, sq, datalen, seq);
 
+		stats->tls_ooo++;
+
 		switch (ret) {
 		case MLX5E_KTLS_SYNC_DONE:
 			break;
 		case MLX5E_KTLS_SYNC_SKIP_NO_DATA:
+			stats->tls_skip_no_sync_data++;
 			if (likely(!skb->decrypted))
 				goto out;
 			WARN_ON_ONCE(1);
-			fallthrough;
+			goto err_out;
 		case MLX5E_KTLS_SYNC_FAIL:
+			stats->tls_drop_no_sync_data++;
 			goto err_out;
 		}
 	}
-- 
2.21.0

