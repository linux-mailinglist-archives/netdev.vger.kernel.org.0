Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CA753E64F
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbiFFL6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 07:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236086AbiFFL6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 07:58:15 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E52FC9EE4
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 04:57:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6QcDq6G78cC1LKjAFd+vFT6GGCH+3iecKLCnmsc6t/3zJrOo+MU3KrwntrsVBiVlAHIleDQtkeJ6jHngsYJ4g1wghH6d8yYwn5IBLdYKbTXCpRH+LsQmrKUPhQeOoeHPujuLEBcDvWncjFytcoRkJ8oM+3+w2jkPm3fw8lTGFOFx/X6J8y6cuHgA6TWtaxd+bhhLfo1D/esTOkMT9mEYfFope6eyK0yXVHO96TsWWMo5UKg8MUzi8bb+T5SlZWKwMvgzYBNG32+2iy/apa0YJmlcZFOVB+uN/L7P0HhzQEmk/eNQim2nSKp8TSG1IHD5lvEKjVJlm42j9d5NKFHmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNcM3sLaK46WvNt7ryAAVMRuLTuHZA3pnGeCku06Hag=;
 b=XTYHgG633EKRjfJe1Wr10IbDtDLxfI2Kh0dMjFUSwRngEeutvqM2qUjrzYwqgNl7FJIWGs9oNPZA3q0OG/vaxhhbkJzDSKlRT8JgCUAKEzrm5GmDFrrTGsiu9gUMFmKKfzKkk8K+hO0mJhrO3QAiSLQV3XiEnjqVDwJAlQ6zWW/LVNQhjwGiqCSdNbcG1IbPqh6+oMuQ+vw6TqZWfGw0clouxA/w/Qe7M4JVYI+5zgpcZB6ked2hACysFW7X0uQ41W99RtaHf46by70T6kLsJYJa0bX2cZGcqXdwEkA9yZlKAqkejRn3CM+hCARd/OHw712TgRzAP6+ySep3ABqD6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNcM3sLaK46WvNt7ryAAVMRuLTuHZA3pnGeCku06Hag=;
 b=kCxNwr8yvmdHfqkXAvyjMJBke/paKgThXJ+6gjb/DP6pke7PZdBCEmX2LA7pRHyWJy+mZ22gCL05vh441z7JjIzzfmhGtWLGIH0dm1NPSGqRz5waESsinTxzYQpedZy6kib5aQzb+1br1t0iY5uqNByEJWWczukJshyMUdWxCR8GVrHsmFcYB/4y9WJg61Qosk/qepQwR5zEqYca3cdbixotkIYHHfd6Jr8PG+6Smdl016kcpDBmTEVI5WzLXbNwS/hTNtoXN81cL7r4o9WJ72iSMzOVLpcszud4jdI5AUA8XJgPZJOaJ3mkhcurz66HiR+Kv2w0lMQRdHQnnNE0aA==
Received: from BN6PR1701CA0012.namprd17.prod.outlook.com
 (2603:10b6:405:15::22) by BN8PR12MB3281.namprd12.prod.outlook.com
 (2603:10b6:408:6e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Mon, 6 Jun
 2022 11:57:56 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::f5) by BN6PR1701CA0012.outlook.office365.com
 (2603:10b6:405:15::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17 via Frontend
 Transport; Mon, 6 Jun 2022 11:57:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Mon, 6 Jun 2022 11:57:56 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 6 Jun
 2022 11:57:48 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 6 Jun 2022
 04:57:47 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Mon, 6 Jun
 2022 04:57:45 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx4_en: Fix wrong return value on ioctl EEPROM query failure
Date:   Mon, 6 Jun 2022 14:57:18 +0300
Message-ID: <20220606115718.14233-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7025c909-4751-409d-57be-08da47b3cba7
X-MS-TrafficTypeDiagnostic: BN8PR12MB3281:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3281B8FF4E51062C9B3B61B2A3A29@BN8PR12MB3281.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cs3+IzNY8rhV6TA7N2BuBB5AgSi8d/m0u1C+cZMBHwxbZSVy6VtpypoXMuQB6nSi8+LGHNiQfR3FG9VtYDywtWzug5dQh+B1kbjPOLnobLJJc+AHLcSD+jeqBI/N4I58qEnnnUi1upNfYNw7RjC8mB3ty3pAwswOvFnSctsZp00pu9WJ7oqHpwYl1oxRmvZ+suZXA1oIgv1QasopRF/d5CpVs0ZL+VXPL9bN47PgwFfvtIfjHCS5YedQckT9kMBX0mXJx/JYlVuDmJMLz5WOTKsRK/+hpbZkeZLKLcroM+LvxGJi8ajN3uKBmSN75crGEPfyD9S9fU0i9A0Vks6Z4cwvXIoYZgpRV4d1dBEatlH1Im2WQvAVD5p+57KMP33bnqsMLMUb7SqUBl09SOJbYGesk7DNnYKHRAa/3R/UsdmYBc1zazy+MbJ0lDsz3NZ3O+ef6OZNKkjmlPQfyOFbQ+EqsBbRJxZpwsZmPKY2sIckGii110WxrJinH96GbljXx+azfjc9wP/OfG71emvFzR7tXeTkCxwtTLwgJoMS+3Q2a7wG4nlhxwJvY2rz/NKlOMPfbtaIAzttAPNlT6aUYB1BiOgpNG69BZo+HCNU6n3NdiQrxNkuo/PV7Qprd7jPRXrfeENabHF+PEY+2nGpqRC9BECXCL4z166K1e4nxN5Ir+aG+91qiZY6Te+ieKgU5/MzUt81CipiBmRDvL457w==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(336012)(83380400001)(508600001)(36756003)(2616005)(356005)(81166007)(70586007)(8676002)(6666004)(2906002)(4326008)(5660300002)(70206006)(4744005)(8936002)(186003)(47076005)(426003)(40460700003)(107886003)(82310400005)(86362001)(110136005)(7696005)(54906003)(316002)(26005)(36860700001)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 11:57:56.6087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7025c909-4751-409d-57be-08da47b3cba7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3281
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

The ioctl EEPROM query wrongly returns success on read failures, fix
that by returning the appropriate error code.

Fixes: 7202da8b7f71 ("ethtool, net/mlx4_en: Cable info, get_module_info/eeprom ethtool support")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index ed5038d98ef6..6400a827173c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -2110,7 +2110,7 @@ static int mlx4_en_get_module_eeprom(struct net_device *dev,
 			en_err(priv,
 			       "mlx4_get_module_info i(%d) offset(%d) bytes_to_read(%d) - FAILED (0x%x)\n",
 			       i, offset, ee->len - i, ret);
-			return 0;
+			return ret;
 		}
 
 		i += ret;
-- 
2.21.0

