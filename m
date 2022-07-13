Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFD1572CED
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 07:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiGMFQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 01:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiGMFQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 01:16:53 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2045.outbound.protection.outlook.com [40.107.95.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83715D5147
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:16:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJqm9OGhf+BOUI/j3jGLcfy0JUfmeu4s/agsZRmIix+NaAqT+giCDXcf+TXD46wuWBSncirracp30kw12l8PU7uOzkOzbDzS/mPNYn2vQgPTTa+ajosDfrsNlYugC9Ur4bI/PmgIhBsyXAFXl/MJ/++d9mRfaeIgP441Z1InLDEL8LzYs/2UIVputakXLNkSyYTsjRLVgNtutGeh9oLXVqges/CD/RcsJZ6UM8NS8Yv7dU7oGVahWBKB2gAc72KdjnbC7OFNyY77m1vpd64+k1aNiaOBp0mWU5lnODSC/bYacCvvYWtuIh5ZHA5h3pch53tcgSpmR6LKAT4UsAKp5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SYjvzCmGDUXODP2tJfaAfL94a8R6OVjYcWLj589rSl8=;
 b=IrmuURHvZ0MCzSAeDvZLb0H+NV2XTieZMSs0ZIhROko/z5N/vGjdQVAvWtX6Kq6KNMIGvvOrC07Wh1IAJjVpZcuwN3fLhO/Vw+45tVYCWJw2zUGKunUx2K6/RQsCxuwMq1o45bCkVr0mwC0gISHesNI1YyMpAN+dz7MTLU5TTUffj5Pf+S4UbWA4fO9ZX1SyaDLIBsey1OPCo3Wl9GsBnRAt+ln4ZCE+4SvpwxHlYWuQfupKt6gzLMSuus6ePoLUsKawjraO2rU99cCEVrrQbVkXZcFKM/qHaVOryYZgLJNRjYHlpebDxT+3ha1gG3s/C4p4ytl39Fj3yv4Wfu+uWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYjvzCmGDUXODP2tJfaAfL94a8R6OVjYcWLj589rSl8=;
 b=OM+PCmvhZFlrUkCv9wAntDyuq2M0/QaatGZMSrnbzfNKd2A2NJHJ7mipmVnV7RXooqxQ1PL2sKCeJs9s6zWNh8m51g6M+uYdHdDrD+X4Qb6gZFcu/yFYsIZ+n3B3Z7VmA3X4xceFV9AuMQhLewO6FsE/xHjal1sqvuD/PwcnllvR9SLB7GJFkZYiDvZY3zKJ2wl58Kw1rD1e/D2DBxdBfIWoszect+TGjbctDJ/gW74QVu8d9cFTqsrH5uvNjdadsMbTa1geqJ79iwBWStQEV2KuV+0aP+TPDG7hqCqD2QvGYvxsdw9hKlPbT/dAeaMp3fGR9nwCEyg8mIrDteG4bA==
Received: from BN7PR06CA0047.namprd06.prod.outlook.com (2603:10b6:408:34::24)
 by DM5PR12MB1915.namprd12.prod.outlook.com (2603:10b6:3:10c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Wed, 13 Jul
 2022 05:16:51 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::9) by BN7PR06CA0047.outlook.office365.com
 (2603:10b6:408:34::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Wed, 13 Jul 2022 05:16:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Wed, 13 Jul 2022 05:16:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Jul
 2022 05:16:49 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 12 Jul
 2022 22:16:48 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 12 Jul
 2022 22:16:45 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <galp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next V2 3/6] net/mlx5e: kTLS, Introduce TLS-specific create TIS
Date:   Wed, 13 Jul 2022 08:16:00 +0300
Message-ID: <20220713051603.14014-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220713051603.14014-1-tariqt@nvidia.com>
References: <20220713051603.14014-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e93d591d-1faf-43de-6a47-08da648ee440
X-MS-TrafficTypeDiagnostic: DM5PR12MB1915:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R7D8cPiXOExhgj38QKHnXlJOcMzFtc0pzXtA2zcq8IOLB5Z0dOPEN6+T0ySoFZi9Ty4pU1nWJU5MHD0FQru2DbDrbjJ0FY+a2VZXlT6Q7IgpN59UQeW0pT/br0HFaMiKJNXrazg1qLZINrbFUj6SD7Ec11XG/zj++nDw+gkhd9/qe6vd+FRJTLmEspZJnhxX6D1gG5wk2bBKoZ90g/INZ81shKgjSkj3D3G/+q1EusLscTqdu6BGDSR7Wveg9KrU7+FHcHUew0cevQh1KLv+hh/sLtQSzpb4IvYGrCPJQHy96jb4P/6eIEqoNbG1BD2El3GyS3AsvWCb7dRiIn9IU8kkNRgcB21DofFr2WUt16S1WSwLy16Igh9wBk6KiQgiA8i19Vj3fxU7sqDMvrxU8VqL0L+gGt8r4ILwdTpozU0Yg7dvRVUM2uUyiuASTTMGwcn4y3nCu8yFQSpTfsjQ2mE39kom47m4UvDVS1Fjv47aJtjJwup1uH/MyMKYwQPG/qeiKzj5qrTB0bltQcRd8qfhF7gfBDMP6vpkztDy696UJeXNtSG/sl1I+U7nP0yX0QKWAq8mRFN+2fjHAAr76AQFJT6MTh/XJVHU/UG45IYDqPeeuV0XiYl1eXSXsqXp+GaEk+H69nIMbdxZ/strZkI+HHnsmvDsTEO1JrwG95HxTJrjoIVJ67ifWQfYoQVzO8Cba5ygrKx5nlPMD2fWScN0H3np9q7UxitWP0ncPt9auH7dx6KTX6/Brhw9DrUNvM3jCxu6rdmXn5IEXzh9rgfQVZTQmBfG7aFxhgOdJCkBFhSshKna4nO4JF6Nw3q6e2rpg05BjHJA2zy28TFaNpbToDeszajH00LQp3UMysI=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(36840700001)(40470700004)(46966006)(82740400003)(356005)(478600001)(107886003)(2616005)(5660300002)(36756003)(26005)(8936002)(86362001)(6666004)(41300700001)(2906002)(82310400005)(7696005)(186003)(40460700003)(4326008)(36860700001)(426003)(83380400001)(1076003)(47076005)(54906003)(70586007)(110136005)(70206006)(316002)(40480700001)(8676002)(81166007)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 05:16:50.2032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e93d591d-1faf-43de-6a47-08da648ee440
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1915
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS TIS objects have a defined role in mapping and reaching the HW TLS
contexts.  Some standard TIS attributes (like LAG port affinity) are
not relevant for them.

Use a dedicated TLS TIS create function instead of the generic
mlx5e_create_tis.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index cc5cb3010e64..2cd0437666d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -39,16 +39,20 @@ u16 mlx5e_ktls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *pa
 	return stop_room;
 }
 
+static void mlx5e_ktls_set_tisc(struct mlx5_core_dev *mdev, void *tisc)
+{
+	MLX5_SET(tisc, tisc, tls_en, 1);
+	MLX5_SET(tisc, tisc, pd, mdev->mlx5e_res.hw_objs.pdn);
+	MLX5_SET(tisc, tisc, transport_domain, mdev->mlx5e_res.hw_objs.td.tdn);
+}
+
 static int mlx5e_ktls_create_tis(struct mlx5_core_dev *mdev, u32 *tisn)
 {
 	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {};
-	void *tisc;
-
-	tisc = MLX5_ADDR_OF(create_tis_in, in, ctx);
 
-	MLX5_SET(tisc, tisc, tls_en, 1);
+	mlx5e_ktls_set_tisc(mdev, MLX5_ADDR_OF(create_tis_in, in, ctx));
 
-	return mlx5e_create_tis(mdev, in, tisn);
+	return mlx5_core_create_tis(mdev, in, tisn);
 }
 
 struct mlx5e_ktls_offload_context_tx {
-- 
2.21.0

