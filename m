Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12852494B34
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 10:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359713AbiATJ4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 04:56:19 -0500
Received: from mail-dm6nam11on2079.outbound.protection.outlook.com ([40.107.223.79]:48608
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1359677AbiATJ4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 04:56:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GN+5+ztnejWYZ79XNn9Dl1rE+U9IWDgFUSLutqTgcCH040ICZ10CMXOQKyXzVHe1bz69QYeNFIbsZqLazgIDLoJFa75kLbcqVTqIVjAeo6Wi7WHk2wuXF+IB3tmTPaXJc03/hAS5DxyGJ6YTljPVOsJIH15092vz1OYeMYPSnEYb82ALRb6gqXp6ECz3p78vjIWcBBW2eGu7e5JPT3DMeyLk1EFSVIWMKVX0YnGZl/CX54RvGODinUgKcr1ob3Evz0+jEB0o01iB9w528uZ7dAU+fQTr0Tpw108Z5hglrTuGE3jtwYFsIt05PQ6TCzlhGq/ahINlVAQhjNL5p7+ugg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CCSYBAvLazmkTxo1J9KCfnl7pZVDUg84zl7zBNHmf0=;
 b=KgcWp833NdUh3us2fTiwRCpGgGottgzxxdOnLQYWNtuYaRg5NadRj5poKVm7mwuaqVAz8T/Fmr9vAPnaDSjQ6dPYOHWZ5j1IkLaC0c8FoZaIAzuFsB9U66SsrXBPqvFwFlIidi14ywu6OhRmglsC44aLKhZZI9ZgAGJ63U/LhCzXARFMX4+Agr5WQKiy20yfNuiWyxgHupBeUl0wGAVcYY/Lu6P/7CUunupexuaMg9tDICOsngBouUCWaSafva3bOkCAjtXvu81/+HQCQDwle3bNOP2M3deogdEYhI1mwwYGk2QtzeMKiqg0SesyCspcG1MPsNSZk1Z79UBFblXf4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CCSYBAvLazmkTxo1J9KCfnl7pZVDUg84zl7zBNHmf0=;
 b=A/ReyOruGfsC04csK8aW8aIH2OKbmIJs5GTLyj5UTTjCo/dAe6gd4uteMTDSIKv0wNXjB8CfuCJE5Uh5ZdDo1YKWIgenXBm+DXxncnZr/UhiU3BneqzIitGsfvmleGcIPSKG7yofzhuQ9BJFSjkNGjPc4tfjxp/BAH8e4X+vch1+lsHDKn/OjoN6/1YBBFYFm3uVkfCUcDz2TsFi0GBOrzkraI5i7L59iIdCrT5TNEYWd+2bIBuzWSQgAoFgyUysZGL5c95z/nPrmemA8UJSlRqtUdX31JqnCwEBe1y6C/JBVqIpt85QnHp0BMzRO8C95M+EXgGt5Pf3n8Eg0C16yA==
Received: from BN1PR13CA0019.namprd13.prod.outlook.com (2603:10b6:408:e2::24)
 by DM4PR12MB5182.namprd12.prod.outlook.com (2603:10b6:5:395::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Thu, 20 Jan
 2022 09:56:09 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::ee) by BN1PR13CA0019.outlook.office365.com
 (2603:10b6:408:e2::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8 via Frontend
 Transport; Thu, 20 Jan 2022 09:56:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Thu, 20 Jan 2022 09:56:09 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 09:56:07 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 01:56:07 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Thu, 20
 Jan 2022 09:56:05 +0000
From:   Moshe Tal <moshet@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
CC:     <netdev@vger.kernel.org>, Amit Cohen <amcohen@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Moshe Tal <moshet@nvidia.com>
Subject: [PATCH net] ethtool: Fix link extended state for big endian
Date:   Thu, 20 Jan 2022 11:55:50 +0200
Message-ID: <20220120095550.5056-1-moshet@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc9211f6-c5e2-46d5-a424-08d9dbfb1596
X-MS-TrafficTypeDiagnostic: DM4PR12MB5182:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5182C869873314ACF8B3EE37A05A9@DM4PR12MB5182.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hLHHBsiFR61XKcpi7A1E2OVKEOA7F2YIa+d5AqCDtffuwyskM3pd5+J2dUgkH11G88SpT2A4wGZ1STl7ThPJou5SgbY4aaeEZcK3sxYIGE3aZAY52ez/xNmjA+zrp5icHVYR4hE6RSUbH2fO3faZ4+inGSoem7FCVz0zWfkUEzMk72CCSUuNkdK1Gid9GPYFLCtMMT5mNWc71SCphJ+vuoL8sWdOIZT2azxGNyRSQVSRVa1Eomp5XDawr8V7ILa01qP/qM4F/+IuZ/itHpc3KjNELJk1E6SK6fXQWnXQITJSiLsK1D4X+VIeBQN+MgGYdjDMgESSEt9UU4iw+XWE99UILDc7pzd18Lj3HWuBtSnbu+NRqQ6VIHfCSYvxM9jLj/6Ma99D+Md3sIbNAaq8nA+z8aT+hRHWprvAZ/FYzINcLr0x0FD7oapM2CwNCnmhLQNUIEsbFNuawjtK/KJZ5mMaHQ0uHNFGXLNuDBBim4MeqIF8jx8epTDLcEcIvA2L9GSQ2TM0WDGameMQIfpRzzrw3c4nmr9tYNBnR1e69UIBGy67gIK7kRRA9GJaMOFLUnJC3msyS1+/YuXUqWrBUB4cXK+9ildGHnQPyW42dqlPusrUSIzsB7XUUJCxbL23LQAsTl4XHmefr1hRebms7RAF2Heo+okg91kJfVYtJFBZPXEcngPnMhwm1bG/j7PPU0lnMBT2cCSplGrQ/RTCbg7mppw3FVjo0QZAtRaxwWkN39S5X2Hq48MrrIxZAEcgZLArlUmCpPyYMPyed10cI0X3laZFA/F9d5lKQUqp2M8=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(4326008)(508600001)(83380400001)(7696005)(2906002)(36756003)(426003)(316002)(107886003)(336012)(54906003)(40460700001)(1076003)(86362001)(356005)(26005)(8676002)(186003)(2616005)(8936002)(82310400004)(70586007)(70206006)(47076005)(6636002)(5660300002)(36860700001)(110136005)(81166007)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 09:56:09.3385
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc9211f6-c5e2-46d5-a424-08d9dbfb1596
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5182
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The link extended sub-states are assigned as enum that is an integer
size but read from a union as u8, this is working for small values on
little endian systems but for big endian this always give 0. Fix the
variable in the union to match the enum size.

Fixes: ecc31c60240b ("ethtool: Add link extended state")
Signed-off-by: Moshe Tal <moshet@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 include/linux/ethtool.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index a26f37a27167..11efc45de66a 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -111,7 +111,7 @@ struct ethtool_link_ext_state_info {
 		enum ethtool_link_ext_substate_bad_signal_integrity bad_signal_integrity;
 		enum ethtool_link_ext_substate_cable_issue cable_issue;
 		enum ethtool_link_ext_substate_module module;
-		u8 __link_ext_substate;
+		u32 __link_ext_substate;
 	};
 };
 
-- 
2.21.0

