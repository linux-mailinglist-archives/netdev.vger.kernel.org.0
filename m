Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE786E5C13
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 10:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjDRIcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 04:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjDRIcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 04:32:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A547EFB
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 01:31:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzdbMtj0XxfEEyx/YTJlncv8v1My5Msk3d7BXYvm7UKjMn1eAn4fH+qwtDeejEF7kFpqyI4fUIFKbRPoj4iB2/1N7WPFCZ5DFqRXagN5nsyVNGEud+aZjqDlVqbGkvW2Ii0HpQaJJYU0ybKiPsthUdTsenae4hxviyawrD4GAzGlp+38qLcRwhgRJIMAqPUOD3e7wu8nugtC8oN6+uUXdbq/bBrzLmDfzPy4OSRSy2lOy5UFgk0gkrSbTjUIAZ4TPcsUhwfmmn74qZMMVr9zrHx6KcMvGs0GU1TWRbQdcHm40BIi5MwndEdy6sDBaT6Nsd+KZvB1oH/dNHxYjziVhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1aXGJly5yeb7XS2e0C6szyYA6EBz9YZWuvcQF11RE0=;
 b=erEcNJ8zbMud9Ui1hKWhksmSRtmf4qIYCGeDTbJfmElPANVh2MndMKL4PcLmeCUqfLLL//op/ysB7npekYR6GmKzyiCIiBmNNNrFGdwk3oDnYwVBHcNm4xEHEBEituMEpFOH8a9vvuonaUD5Dx4uLshQ9Iuc7ZPeYTqGJDkWITrNHZByh4jb8cyVMKNoQwbdRnmXp3/nXuFBCJuVfFwYnm6icOZ02v1PLzLaYt+HqO+rLRsHK97i+qf2TlPr9G87bNbJjTKtndZYprHeQE5TDeTsmrlBBj0/HLFjhRmaQtHVtf2pURd3lKQn5aDiPYamCUmRR3cpwUuIKr5sY7fJQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1aXGJly5yeb7XS2e0C6szyYA6EBz9YZWuvcQF11RE0=;
 b=SJe15fuaYxX8e6ybPNYVV3inMNJciGjxJvVlKfGF7Oy2JPdmlVDqe5Mc5LrFCsCX1+UmXY+WhCrlhC1q9ScB6x/mXS0IpwuMyAhE0deVVrNN1Df9N7GV9NIkS3auErkM8/A5QPdXcrLso5T7JYtTQFYvQdZ8B8pUKAW65XopV9L4K0ALGOz8oASXhdxFFAeGz+6/CR6K0iUr8k9fxfFedUXY2PPs52iPFKL4E/iDssw3hvqUzMpXW1Wpeu3qT2dtmYGweNyvV9cSXn8LLNY3pZ39JCZXWfBv+UB+MnG3UAuq+18jy4azPfYUrA1BcqhOz65qkLnDBMPrQrkWGFC1KQ==
Received: from BN9PR03CA0276.namprd03.prod.outlook.com (2603:10b6:408:f5::11)
 by DM6PR12MB4895.namprd12.prod.outlook.com (2603:10b6:5:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 08:31:34 +0000
Received: from BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::3c) by BN9PR03CA0276.outlook.office365.com
 (2603:10b6:408:f5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Tue, 18 Apr 2023 08:31:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT110.mail.protection.outlook.com (10.13.176.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 08:31:34 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 18 Apr 2023
 01:31:19 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 18 Apr
 2023 01:31:19 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Tue, 18 Apr
 2023 01:31:17 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v6 4/5] net/mlx5: Consider VLAN interface in MACsec TX steering rules
Date:   Tue, 18 Apr 2023 11:31:01 +0300
Message-ID: <20230418083102.14326-5-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230418083102.14326-1-ehakim@nvidia.com>
References: <20230418083102.14326-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT110:EE_|DM6PR12MB4895:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ae32a75-ac2a-4b8a-f250-08db3fe751bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cBKh/bbbNbeiCsKpP7bjF92oXHamcLtjpIGYWD9CTzVdiJmC+5PcWM0C+1kFuKUrap0g+NhZWaE7wJkS/5IohNRJjeFEUXewnuh+iu56Sp7ea3aS1fbYv9CPteHDM5CLkahuPR3dsJxoS/kSMjq06oAcTEX7CN9d4Xkl5yPS31ZdXcPCNProGKRNZHwznWqe4Ccf4l4P3jF4LSYhr6h8F0itFEvXzNlOjnmoyZo9w9MhsJP5vWwjFCC49YBoRx0h4n1vz1S3txyF9g2bEpaH6cNT+FyQKegMkbBQBVe36aT8m42uVTvVcFI/Ep2hRD9Un/37Z0fMGSZAPO5Q2Nm7vjkDAr2RKTh/B5mqflik7f5Pj4ewwey0hLm1Z6JnzFeiEtUtJG2IlUCar/y2C1jwguxxSs+pfATtK0c4DRvea75EYEnx8kVbfYx3iOPg1Jo2Ynbmkw2369N+IOfcZ/bO9TJz8Ve29hSDqKA6/4Nsx/01mH5bEpAc+NkJg7e+G7s68M+brwlQYZKAn7bw8DkKRD3rt98IzW5PDRWeGHL5gBfNHgISRxSq4D8Edy5mZIigXif7lpkRlsnZ1oJLLePL3yEn3fmg1Z/Fk6KvGMMR9lwfqCovlWoRWdBQ8mzI0vvHU9EZU9wXd2xW/gWN3T0hKbrqYfoAFbUTuirYOcj3quWaPTaQaDD1vuHRi6F9hHaYJbpKXbVtRO61IxO7ykPQDbqdOwiDM8U8FcVBtfPd8A9QxDioTWuW+qnHl/xqDVrNs9sFoynqJLKXsrkgw3a7zCxUC+oJGvoPepHCmpRZWx8=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199021)(36840700001)(40470700004)(46966006)(36756003)(8936002)(8676002)(40460700003)(5660300002)(2906002)(82310400005)(86362001)(40480700001)(34020700004)(478600001)(7696005)(6666004)(54906003)(110136005)(186003)(107886003)(2616005)(36860700001)(1076003)(70586007)(70206006)(26005)(41300700001)(356005)(82740400003)(316002)(7636003)(83380400001)(4326008)(47076005)(426003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 08:31:34.2358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae32a75-ac2a-4b8a-f250-08db3fe751bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4895
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading MACsec when its configured over VLAN with current MACsec
TX steering rules will wrongly insert MACsec sec tag after inserting
the VLAN header leading to a ETHERNET | SECTAG | VLAN packet when
ETHERNET | VLAN | SECTAG is configured.

The above issue is due to adding the SECTAG by HW which is a later
stage compared to the VLAN header insertion stage.

Detect such a case and adjust TX steering rules to insert the
SECTAG in the correct place by using reformat_param_0 field in
the packet reformat to indicate the offset of SECTAG from end of
the MAC header to account for VLANs in granularity of 4Bytes.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c   | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index 9173b67becef..7fc901a6ec5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -4,6 +4,7 @@
 #include <net/macsec.h>
 #include <linux/netdevice.h>
 #include <linux/mlx5/qp.h>
+#include <linux/if_vlan.h>
 #include "fs_core.h"
 #include "en/fs.h"
 #include "en_accel/macsec_fs.h"
@@ -508,6 +509,8 @@ static void macsec_fs_tx_del_rule(struct mlx5e_macsec_fs *macsec_fs,
 	macsec_fs_tx_ft_put(macsec_fs);
 }
 
+#define MLX5_REFORMAT_PARAM_ADD_MACSEC_OFFSET_4_BYTES 1
+
 static union mlx5e_macsec_rule *
 macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 		      const struct macsec_context *macsec_ctx,
@@ -553,6 +556,10 @@ macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 	reformat_params.type = MLX5_REFORMAT_TYPE_ADD_MACSEC;
 	reformat_params.size = reformat_size;
 	reformat_params.data = reformatbf;
+
+	if (is_vlan_dev(macsec_ctx->netdev))
+		reformat_params.param_0 = MLX5_REFORMAT_PARAM_ADD_MACSEC_OFFSET_4_BYTES;
+
 	flow_act.pkt_reformat = mlx5_packet_reformat_alloc(macsec_fs->mdev,
 							   &reformat_params,
 							   MLX5_FLOW_NAMESPACE_EGRESS_MACSEC);
-- 
2.21.3

