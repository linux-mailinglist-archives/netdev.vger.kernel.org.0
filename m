Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9FA582369
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiG0Jo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiG0JoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:44:20 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3A247B8B
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:44:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJFRuqVNOqFtLgUfChvC6iT97YwLkNUwZijXeDuHpK4PASaWuPA4LU9x+2rXLCmIfvyxhIDLGcRY6F2ClKD4TGgXH1WKgK/dIY/0LGx1giWJpP3c+Ujv1BkdBfBGcodngBa5Ms6vnN3X8mafh1mYx5THuh/8qJbPSYjjT37wj8npWJNfVmqBaBH19cNWt0uxvngbCXWiYhy/ck9IP5bb95I4VFEX8UD3SFbQGk/fo3a+LlBCd4rRm/RL9of0cbm9zaTXHFqpCb0TkjBh9JaHaivV1elBMysJTWxx+KAKP65FrK5mJsy04LqBNfygGCXZ4OLXVbvdDki8QkGGR20msw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9zJ6KAOGsBwvJBd1eMFKjhJYygxnpE4EaTBYLzmNLw=;
 b=DYMsx26qXsgMq2ZU+jTVphR77p4yZ6ijMlZlJn04VDsbLWLFvcHlq/BiCP72QKKRjsnD4iv2UbzMyf6pJ4JjIa0Oyr0zxDDLMb16gOKBoFqCP27MmuAsB1B1ETjN/hKS7hfWEEi5WHAJOwEhgUkb9hI+TVbtlLV1pI0KU/SDzzyrUX3iqPaLEylAfU+pY3StKI01nnIMXI33rdvvB7tBZebJEY1di4Alsz6q4tn+M6O9KrTGPyQaf/cDNwbZb+xo8qTGkrUhNpg546KTjuetq2Dwm5MTXlqZZ8Q9DDYMOJe1TgA4arX8V2onQGnfptyWyvzzwpMt0zEwfLDU9Bnt3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9zJ6KAOGsBwvJBd1eMFKjhJYygxnpE4EaTBYLzmNLw=;
 b=JTKsReAB1DFlsdBdjEygU0qKzg4ATdi/9sdgb0x6VN1zJQDhDImnQ39EVlOGoFnkGSSfraJikRR5v3tAkuoHVk2wypaArs0yA+GDa3axoFbmB/Kxgoecz9UsYEf4IjlzxeHKwdwR9OfEqHocSy/iNFfqqi85TGROF6pFgZ93CA5NPNIohvCVH1iLeCllzyW7V/g719vK2HpmoWjDvID3Uf92DL1qhWdNyMfOWUEpYSPlBRbPYAGojFOpipeCnZiqL7BOHswqF8r+tJTn6H4dk9qM5JkCoZcRImYHqJYor3S31MM68dPXHEj8Asbs+rjNP0ndb1HRs+eCZmTIP1P0lQ==
Received: from BN9PR03CA0930.namprd03.prod.outlook.com (2603:10b6:408:107::35)
 by MN2PR12MB3407.namprd12.prod.outlook.com (2603:10b6:208:c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 09:44:16 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::25) by BN9PR03CA0930.outlook.office365.com
 (2603:10b6:408:107::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24 via Frontend
 Transport; Wed, 27 Jul 2022 09:44:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 09:44:16 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 09:44:15 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 02:44:15 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 02:44:12 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V3 3/6] net/mlx5e: kTLS, Introduce TLS-specific create TIS
Date:   Wed, 27 Jul 2022 12:43:43 +0300
Message-ID: <20220727094346.10540-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220727094346.10540-1-tariqt@nvidia.com>
References: <20220727094346.10540-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 954c42cd-b9b7-4a52-5a66-08da6fb49231
X-MS-TrafficTypeDiagnostic: MN2PR12MB3407:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UcnEWfLR2bjRfj0pJ1OGPywAz0OBtGcHm/aokuwdxiIyY9wp2s7OjkACH4aiV7FfrVElgEw1Wx8+DSabRaNerly/8gGuGsAAvEeIaC08z3+F3Y/pJyxLJYz8k5lasDkjPiRnHSlrMYktIzX0i6ehvLeEU7msiveGPWj3H0YCY+dv3aLEWnez4AZRDq7wPUl81hVMsJWFX67+LQSE2/d+u4fd/I0CZTD+3ciDDhIeSSA+7wHq5GSV8wnwVinTHHuBWxSHlVXEcNRQmWHolBFwCdiLoLOTGid7Q7eIgVAghdpMdlhbiuL0xdGXe88bxC+UCimr8tvCiH6q5rVOwy5/HHqYPsNrHvgOUHMUzscQm8qHni50q5t9DFW0EEanbO2EKjYXSM63fegiMThBzGft0NHykb7UaLwvcVXJWckJAudPIH9mXQV1e2+9Zs2Qd99RrADgunQ97ApTJItVGKKFw4JzLE9g54OsIwBHBeiiPSitJHxlIL223tB7WOASnG/QV7xv0Y5dVcZqoxOoOcUC3NXf/M/NyRnxIvi9rxqehoCwVfxhi7qB4RouNU+OFMr531KnKXbOajUgE1Z8D3UgtpYkIu4g3DrTSizQJEBz4LqtO31+oRlMV5XOcGG2PaBAnVqo+z7FkUdB4OTGLzwOcwg9fgjfxx0GK724urce+razAr0exS9vYjMfW4Vrrnweb4EkgbHINlXEIN8+vHd2W2qEucu1I8TR6p4/n11ooOZJOoMvwOGZAoZ3YQqX6nXZGUOwmE0KWMZPs1PlOUMvO19phdvyC2kvaUW8JdBihXHGyyxF9rWS+AcfS2b4OP3iOGzky1ZZRVYsIaK3EGM/og==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39860400002)(396003)(46966006)(36840700001)(40470700004)(36756003)(110136005)(6666004)(41300700001)(186003)(2906002)(1076003)(7696005)(47076005)(4326008)(86362001)(316002)(107886003)(426003)(83380400001)(82310400005)(336012)(2616005)(40460700003)(356005)(5660300002)(26005)(40480700001)(8936002)(82740400003)(36860700001)(54906003)(81166007)(70586007)(8676002)(478600001)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 09:44:16.1975
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 954c42cd-b9b7-4a52-5a66-08da6fb49231
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3407
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index fba21edf88d8..73ba2501e441 100644
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

