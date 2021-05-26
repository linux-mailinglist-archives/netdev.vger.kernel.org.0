Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C6839143D
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 11:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbhEZJ75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 05:59:57 -0400
Received: from mail-dm3nam07on2085.outbound.protection.outlook.com ([40.107.95.85]:15681
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233728AbhEZJ7w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 05:59:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZVtrdeEECGNOdSRYwpOACRgqXPpTt+Qt8HzyzLWWbpOyNcU7luwBG8iAb2ESl71/VKdtUbgp3zIARQGvTxQjoaD8CPoRoX4JBuaLheqxd6mV76u2mA8p3qG9t1PAPNuQxfiS7V9FTOpkUOSdVvAG1aWzmWeNHIbl1cX1tegTU0yehycy/FoMPGnCe7oW3rg6AufnFT5F5aw6R4lt7Ir5uFyJbmF8fJcgCqiNeAOI1gVPJ+BkiMB/XLCu0k1IOW6PjxtbqDv4vBMpzEYirQTi/OJ3mvn6ZcfRNPatikMXgdjPPnt41wyJBWpoMVMztD+ZJApRQy6PYZd3WmTP/YxPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNEYMTET4h6qVJGdOKEDu34EgxOiY+OE0xnvGsiF9KA=;
 b=El5piIhN0Y7iTVDVvF7UKSlXRRMdmG5VKEfac/EGeYfim6yWXR+1q01kXuBUgn7WjK9eovDFW71Sd8rT/sV+Y63ruNyGTL/X2sJGnfQI2VDLQdxKBUOVDRto8bdOjVheKOnxxFewD3uvlLtNaIE9WH0BbqeRuP+UtXvOVG+it1sySjrDJT8GMz016hhiiEvKWE7LLTsB3duKIKeRqPs+/orO3atBcLVr7KjgJ8YFQSO5dcFZS2zR16TQu/vlPxLkda9e/FTJffHKyjEwKM0uyvVnnL1Jf1fMJMBi3iiYYNtFhd8VphzopzWtugmhSFaLNMHH754w+Wglzl/W02iItA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNEYMTET4h6qVJGdOKEDu34EgxOiY+OE0xnvGsiF9KA=;
 b=FPMl7vuq9AO2oI7ULiCGMnCQ2njkgmHHcNi4Fra1kJ6Y03T0ypUFiYf7jSz5Bw0zChxm1fh1mESrVMlob16mCcbZlggXjrmN4R3OFU9RTA9d+halgLk2KD5CEh0N5xkGS4yn/UwVRh5W5DFZs2r2V+d+T5sXlYdXht5o6OKJY4BXJPAlQh4qlgq7rBLKKsblLKpqNubLFpEb724MlkHbUucjtVF5TP462gS4K05u+NeYvszU+frAdXMRzuhB1JrMTmTwRDDyzEpwu7r/db3bq37lYCtesaOOkxUikyZ/hBtk+cEwWPDEdSRMGPpjPHDkR05/L1LfBagwNGyR/AzDjg==
Received: from DM5PR08CA0031.namprd08.prod.outlook.com (2603:10b6:4:60::20) by
 CH0PR12MB5154.namprd12.prod.outlook.com (2603:10b6:610:b9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.23; Wed, 26 May 2021 09:58:20 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::ad) by DM5PR08CA0031.outlook.office365.com
 (2603:10b6:4:60::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 09:58:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 09:58:20 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 09:58:19 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 09:58:17 +0000
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [RFC PATCH 5/6] net/bond: Allow explicit control of the TLS device offload features
Date:   Wed, 26 May 2021 12:57:46 +0300
Message-ID: <20210526095747.22446-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210526095747.22446-1-tariqt@nvidia.com>
References: <20210526095747.22446-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eff23524-b9fd-42d2-46af-08d9202ccabb
X-MS-TrafficTypeDiagnostic: CH0PR12MB5154:
X-Microsoft-Antispam-PRVS: <CH0PR12MB51546CA8C6D465D16C94BC9CA3249@CH0PR12MB5154.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xlMJrungE/bOAlWhnBkZkxwUwKxO5sUXo1PQ3QJdJIaNk/ePxomhKVYIyNck0qAePYOnPczxL7F2j5WAOio7L+XWGwlRInhShDkO/qD4MC/ocbizNH65oGT4L11AUYFA/jfQQNrfc6l5gkdVlmyDQm0+RKz96C/Ls40d1Jjg0wnJX8VC5KO5f90V9iLt6nlYoIyHpWvUirm7S0D5Me05NZ4suH5I5+jZxpXYR6+0Svhbqief5Izkdmees3LuU9Fe5PS/j79FWLHvvPTyLyRK21nWZbLuTlhB4Cpn6smgZiz0xDdc3mbMDUpBaadiq0Sq9OdVfhgv/j76DQwbUrqzR8bfeE6aAXwbOWYW0MUJzD48TtgTLqLeajo3sIcd76eqm3naPlhK608yns2rip4VptbIaJbCFgEwN0jPD993UQ03NWu/eSIbYAzpon6QbqY39iAyYQoamblmudrIYev7o3NOppB0m9Toa2pLCZf/1MBwx8fb1ZNTeA0R6rwyA5DNlK3j0vHl7Tl8ffLnT0BdfhFTQ/wlC/7zOfaj/AVAPePmYlDin+kZNo9YOTij76mhLr5Q1JWlcK6BclC8iXem8PURjqBFH/u8hzbj986GltO02H8XOR01tfONPjieh/phAb+VS2tSGfmsMY071j6CtP7F6WRBGtqV63SEYeJvu/0=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(46966006)(36840700001)(8676002)(2616005)(7696005)(426003)(70586007)(54906003)(4744005)(6666004)(7636003)(356005)(26005)(8936002)(82310400003)(86362001)(336012)(478600001)(107886003)(36756003)(70206006)(316002)(186003)(36860700001)(110136005)(5660300002)(1076003)(82740400003)(47076005)(2906002)(4326008)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 09:58:20.0517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eff23524-b9fd-42d2-46af-08d9202ccabb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5154
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow direct control of the TLS device offload features on the bond.
Disabling a TLS offload feature is propagated to all lower devices.

This solves an issue in which the bond interface had no means of enforcing
disablement of a TLS offload, as it is bypassed by direct communication
with the lower device.

Fixes: 89df6a810470 ("net/bonding: Implement TLS TX device offload")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/bonding/bond_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 9091db0d1540..34a72981df38 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4913,6 +4913,7 @@ void bond_setup(struct net_device *bond_dev)
 		bond_dev->features |= BOND_XFRM_FEATURES;
 #endif /* CONFIG_XFRM_OFFLOAD */
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
+	bond_dev->hw_features |= BOND_TLS_FEATURES;
 	if (bond_sk_check(bond))
 		bond_dev->features |= BOND_TLS_FEATURES;
 #endif
-- 
2.21.0

