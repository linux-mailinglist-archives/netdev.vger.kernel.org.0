Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2D739143C
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 11:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbhEZJ7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 05:59:55 -0400
Received: from mail-co1nam11on2077.outbound.protection.outlook.com ([40.107.220.77]:41312
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233759AbhEZJ7u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 05:59:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyKGn309qBuNRaJ/HiUj5gfARJbhJ4LQdb7qP3aTStnW78qqE3Q2Gupwkh9uHeUWuPKhDmHmXB/Lr2nbgHG9fRLbvg7/C8YlCc/nKA23GQTVtONFcqDNrKj/bl9K49INCkLrEmyyHVf0qH535YPR3Jl3QaE9k+KZ2CTJp4mWxzOsnfRxyzQqaPSsGVkOJvaLRwrhE0Db1I2JN3DXH+jBIF0aKkQtEYhoDonYOwn7zn+CmsVaFEzplOzp8XELu6DnLKXD9cFpYlAr5Y49EAeCpDZsr6UDJKDBZVTtpgabnnyxulcYQiBJknE212F3UZjPLQ4Uw5B57NXlPwipN0F/Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0kC97LWaWURHsYwhtkxh1vrLYNm7I/Q4iqxsO8K7MZs=;
 b=g9mnNt58u2JIapwQ87Tv49px4aEhxPehaLHjMeGBJOKQD9nyouOrEgQmU90JZ6zrM662rXHG+BVa+9XV508DyQUR9PvfJVNG83B1j6zEu4NJdmE/EYrkXC8OLTftxbfFnjIP9ypWw7vTQ1Y32dqJLJwxiQoiSymtJdgG/EfaKUS2aAbFP/sK3s3vKR99Yqd8740jqoZYFN+Mic/mEeyIs6bv+7n8/Cjdkut7T+bHExb3ahAmbVJOHJJwuoEewPG2pvfdfwdbOXIJPPZ4scEleuTm1xXTgOMcZzd8TRFhtmvefCgkgyp2Y67GcTstyQEvDFNd2KsH+ipeOCIqi4aoaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0kC97LWaWURHsYwhtkxh1vrLYNm7I/Q4iqxsO8K7MZs=;
 b=tzlzcxvGQ3YtfxYZm2SCArUkF26sGow6sk/SPeNY4nhr28h0qXieuQJMEMKwkFCJUViKc28VurKeGXGwSiqLxfhdxY6VwOuTmnOy7d/zhzjXYsTcMCIkgMw7PL3WTq6XxiSOxpgOMNzdjYM9X8JmWalVHJocrz4jGeJusM7/UO4rcgOCWyJcaejp7cXi3Bum0ogQ2xv5UiOYD1frrFkRhLqTSzwSDNC/UTzR6JnNQb6tZY1NDNKCYlsZkN7ejwGfSRJL/POb2OPAm6LBAitYFaJRMACg4zvOjPB5DhVJpFaV6wN8sA57SZl26DvqwqVW/Vyo3BPQWweplBQrQz09nA==
Received: from MW4PR04CA0115.namprd04.prod.outlook.com (2603:10b6:303:83::30)
 by BYAPR12MB2615.namprd12.prod.outlook.com (2603:10b6:a03:61::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Wed, 26 May
 2021 09:58:17 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::91) by MW4PR04CA0115.outlook.office365.com
 (2603:10b6:303:83::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 09:58:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 09:58:17 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 09:58:17 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 09:58:15 +0000
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [RFC PATCH 4/6] net/bond: Enable RXCSUM feature for bond
Date:   Wed, 26 May 2021 12:57:45 +0300
Message-ID: <20210526095747.22446-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210526095747.22446-1-tariqt@nvidia.com>
References: <20210526095747.22446-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d80a6e1-89b4-4896-de07-08d9202cc950
X-MS-TrafficTypeDiagnostic: BYAPR12MB2615:
X-Microsoft-Antispam-PRVS: <BYAPR12MB261567680115E5DF461261EEA3249@BYAPR12MB2615.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:913;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: slIKk5u02hisRKPjUgfYYwo6Js7iRpOvelzb/IV2HP1hFfobjW3SImbI1XbpVA6POmMM5VO5uBSLQ0J5x+3J/jFogvihmJRWuOBGY9Ej1Goz+6GKvaZdwDrZiWfbWRFWd7G2r8246fJT/KBx2xNIA6O3rAUUJbtDWPunli/AS5OyYFCzSCyaXa5WCHygNKcXbcGsmgIStgzDLFfgogUT8BRHvGse4n44qUHDu4hQ2Aj+Zba5kT3+19vJzrgJQPycf6xsfGq+TqW1A8u3pcZA89Hdm7sDRxTr+w4xIcGWD9uRNP4E53VYA+DOUVMFaNViilpsMHKL2itpZ/xSMT6fLZWonUowXIbd4H+Hf4OeD+vkEifrxa2x07MaWFgQYCXc5foPHleurMdfL0HBiRshG+OEft6Ja9XRv5pZzs3LkwKhPdt+C0FPlmuHS1cY7ScWVOUubNp2nhLHRDNcNMEcD6uqqPLAfpNnGF2klM5wC1QnuXnNQk0vgaeT149cjY7MYQgANoW8ervHUfbAHYT39fJVFcvNBir6AR3mSTISb0qVrIONaxk8ubx/Akib+2ugblHPD4WYZgLs4EQJnNWiM/gI0ahQsglGTqPppLALFNm/3pHr8cByGyzLb8RHqR5FiHnzVMNYyvW9/6vdpRVafhtCFpPYMKw0qp00Cdio5N8=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(136003)(36840700001)(46966006)(107886003)(7696005)(86362001)(4326008)(82740400003)(6666004)(83380400001)(8936002)(70206006)(336012)(316002)(26005)(186003)(7636003)(356005)(110136005)(70586007)(36860700001)(36906005)(5660300002)(478600001)(82310400003)(8676002)(1076003)(47076005)(4744005)(2906002)(36756003)(54906003)(426003)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 09:58:17.6766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d80a6e1-89b4-4896-de07-08d9202cc950
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2615
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable RXCSUM device offload on bond, otherwise the TLS RX device offload
will be blocked.

Fixes: dc5809f9e2b6 ("net/bonding: Declare TLS RX device offload support")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/bonding/bond_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c5a646d06102..9091db0d1540 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4903,6 +4903,7 @@ void bond_setup(struct net_device *bond_dev)
 				NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
+	bond_dev->hw_features |= NETIF_F_RXCSUM;
 	bond_dev->features |= bond_dev->hw_features;
 	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
 #ifdef CONFIG_XFRM_OFFLOAD
-- 
2.21.0

