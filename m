Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B481739143E
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 11:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbhEZKAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:00:02 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:27616
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233778AbhEZJ7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 05:59:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NrdqL1Yk+EKoF6PcKXWUUmTlZuaAbDh55t90Ew8dUsPHy8KRZf1pZN5cS6rQEmzQZJRWuBTX4l9mCtxBws7OqR4zrJpcNC0Xy5anLNLhwe3zV6qPeUvPKxYsmw7QQQTmy/T9T95W+JbFdMUKdUwtH6ERNzanmBTphxjV4lMAi6kAZ2spSBw7WHcTZxuPiFFNAwKWxEecvkCk8i96tzQrmbRgNTi/ibxmDq3CU+0q2KAT0nO2dOBS/HUf0ggAh3R1PcO/HpjFn7ybTyU2jrJOwFG9hCBAjWP70c8QpEFUX6BTW0+iU+ZLDON4aL6WtcW79Ix10VXO7hI86A1fnssr8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P38DaO/PxflhvB8YeQCfqQgxTJalAi1/VMEKHgCTZC0=;
 b=I4ZAKctHdCmmTi86WOE3u+kIDSJIAO461v6h++MyPU4mnbWdXxRB0k0sMoq65MKGR8loOmW/dDg3uZHNAwqsJwLWyrx5J3HMZzyMFyZ6Bzgsfs/xXrYvU3Ss0Pj0ZjMtw72IXeH6V14kYlkXDClumM9ukEw9EyqtsoZgB4uce0SJPfHxkE2DDBJoZ0lgvW3meI/qh3lJDPP2SlzP7C2FcDJLkE6nFIglrzFUAw7FUb+pz7oyyk2Eo+Ze4CPI0qRvwGGr96nCk4cBo5BXch4W1AxrKxq1odpna3nM5ZxHBJaRSE7aaLTio5WrMeSLYPLOf1YuQk2R31XJZ3e2di9BwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P38DaO/PxflhvB8YeQCfqQgxTJalAi1/VMEKHgCTZC0=;
 b=tlVkrhL9YQx5SQVaMPKYJ2O0jXcaTfA6yynYGwwQGmrfTNBIk3zMvhBZhpoNiwLhJmHDON/Ld+N16nBAPpbPxPic3RKlK3yyTUJ1E2pgTsUQFubgGxcSpec8k7l4Ys1uiUv96SYizBvi1nlGu/FxKMl/hzU/TcM/uWio8c9L4ryqf1vmMwCNQcfm1ppWl38qg8EeQLQ3UMSQwfxSldXPZGOT871HkzQ5m/015/y+GGqWM5O45nMJ9Q92oTqMSDuJQKIWlxsi3+ENGm5ySVUV5Ke8AZ0qTj6spYS4zownSIck0rTeGHxBEmLpCmi6JZd7SQst1Kuz2jI9ushYCP8AMA==
Received: from BN7PR06CA0066.namprd06.prod.outlook.com (2603:10b6:408:34::43)
 by MWHPR12MB1405.namprd12.prod.outlook.com (2603:10b6:300:13::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Wed, 26 May
 2021 09:58:23 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::1b) by BN7PR06CA0066.outlook.office365.com
 (2603:10b6:408:34::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend
 Transport; Wed, 26 May 2021 09:58:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 09:58:22 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 09:58:22 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 09:58:19 +0000
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [RFC PATCH 6/6] net/bond: Do not turn on TLS features in bond_fix_features()
Date:   Wed, 26 May 2021 12:57:47 +0300
Message-ID: <20210526095747.22446-7-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210526095747.22446-1-tariqt@nvidia.com>
References: <20210526095747.22446-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f564cb2-c175-41bf-65cc-08d9202ccc4e
X-MS-TrafficTypeDiagnostic: MWHPR12MB1405:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1405BEAA665EBA5FD10EDB48A3249@MWHPR12MB1405.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WPkTNnHJJqM2t/Cyu8mGB9/sOBSolfYOPEW+4Tze8OB2JAHROGQz4GrUf228RmnwN1sLwszPFBPIA60qY57B+ivB1PwO6FN9oYmkKdzyxmAa+u4GIjl/pGry4060EsTaw+WUqZnivA1+mwz/NpkXYsuGWAriRbENy4eUr8G0meQieX5jJ/os9l0ZCH8F9jGqWGbby3NqWpKLdhpfCht59mIXa7gljJj5m5tFalJwh/3lq+OEJ/oKcZ52Ids2eFfQfzDqGlb3Tcak+MygFdI0UbqhVQkXo0046IQ+WF4cy+U0mXXfryj7qeYeAQYdHePxHlBPylrBdoenqUYMvSXbblMPFMH/k0e5ykKGTAqf0/FAWWcaoOqp/8IXiyh0oPYEtr5fyDhZvxUco7eBmDeJ9uLycJYFD3oJBxPCbiHIFVxjVxTQZxZUBcAEz/az38eo1I2PcL5JLjUKJutsKrdMaFBY57sU+H9v/rR2qNhD942vYovJB/70OVNXjDZl2193KME1WUFSSDf6A5dEijXyW2e3rwIybzhsquSns3T9DdSpTTE8E9qtYrn5zHhazhob2SaxCDdb93EM7cMLFMq1qK9lHnv/2G4sIbT79xx6CrBN//+JF/yVb4PlvJUNZcXhKRc4Fctl0Njr507/aHZOUA34aFisooebFDKPmLuRXJk=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(36840700001)(46966006)(6666004)(70206006)(7636003)(426003)(54906003)(8936002)(5660300002)(1076003)(83380400001)(316002)(478600001)(2616005)(107886003)(4326008)(8676002)(336012)(26005)(356005)(36906005)(70586007)(86362001)(36756003)(4744005)(82740400003)(110136005)(186003)(82310400003)(36860700001)(7696005)(47076005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 09:58:22.6096
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f564cb2-c175-41bf-65cc-08d9202ccc4e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1405
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no more need to enforce TLS features in bond_fix_features()
when supported, as they became explicitly controllable for a bond
interface.

Fixes: 89df6a810470 ("net/bonding: Implement TLS TX device offload")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/bonding/bond_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 34a72981df38..3c9466e6114a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1229,9 +1229,7 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	struct slave *slave;
 
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
-	if (bond_sk_check(bond))
-		features |= BOND_TLS_FEATURES;
-	else
+	if (!bond_sk_check(bond) && (features & BOND_TLS_FEATURES))
 		features &= ~BOND_TLS_FEATURES;
 #endif
 
-- 
2.21.0

