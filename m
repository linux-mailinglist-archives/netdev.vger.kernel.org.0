Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093243691FE
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242578AbhDWMXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:23:33 -0400
Received: from mail-mw2nam10on2061.outbound.protection.outlook.com ([40.107.94.61]:42129
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242249AbhDWMX0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:23:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I36eSxcfZwQ4n8UzjfLSt4ISOpAScOVSV8b3PyJHQjekDM5vGHOhuBwsnXeBJ2wfOHGsltjcF7Iey46RvdmfII1G+vdxwHQXfIvoiThZ1vaY1GKOptgF4C+z0sKfaFy9hlDOSwuA8Vzgobk9Yay56eB6TTi/AcDZy6OW6oVqm6LYvLw1wNe5inspheHWpjxMrIOnRLob56Sv23bU/ILj3RmYyczvfAqBnCEyCbBWA+i9yM96UGBMYWnzAL8T5U0dwtbkTJA6yreg0qIOslJP2ksEffJP2KnVQP8fbIvNTWMPSPWdam3VS4eAyEs+im45WLefjsBOrM263Ja7zR4LbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TdRSvPBSkHVMXjCD+qz3Kao9OEPiA+Ol4wrWnPsZNFE=;
 b=XbCJUUToa2xD+/m7JnzzJ4HJ3tPf+nZEp0UNMk2itps5CY7wEwby3rPlexp/iI17vt/1Q7nBnOCMU79/clcAax5QHUPdTjluFq/BvD78LhpZadUlim8eT8bSLRNVXPwN8huxom5BBxx3rG5JSIdZ/+FLA7ejVLj4FmL0WqGqZ188strlXpEqqcLCFoUMPW7aQtgSuVWaWB/hvbEsE6H4JpG37fEivbRrJ6TE9nq9tXaC2q48Fu+4qkksXw6SJbvHqXjYIk0K8Ke8lNR5pYsKuQtlbBMHDnfyodXlGSIvGThouNvKwCRVty1+Q/ezMGj6h6Wm1WPMg4wbiqLYjHC0SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TdRSvPBSkHVMXjCD+qz3Kao9OEPiA+Ol4wrWnPsZNFE=;
 b=gKyboEnTgzUmLgYQU++R8eRv+1PfDC8HoLODPH6mSlHmdWIisicUPTbASriQxRv4X3z9UqYVJIf213Lz9qALk6oYnUz2KsVsbKwpLROR9c1o//Zj79t3WKjmGQ9+pOipL5OJml0EDMX8EwmLfVnDkz7NMnK9CndNt8k/XJUEKUrrtQ2W8nn72oSRGOd5moe1DrXjVHoe26dgc+AL9A19MwlG7JkJ+j4bigbpo+yYMhWVztB0M0vfcOZF7OJ3p0vYUOuvLHHU1B77wkvKPTyN0dpbvx9hujgdVZWrQNFKVDHIlR2DRaZlxI7nKBDw7wmS1zss05dHTHRSNHfXjZLgIQ==
Received: from BN6PR12CA0043.namprd12.prod.outlook.com (2603:10b6:405:70::29)
 by CY4PR12MB1366.namprd12.prod.outlook.com (2603:10b6:903:40::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 12:22:49 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::2f) by BN6PR12CA0043.outlook.office365.com
 (2603:10b6:405:70::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Fri, 23 Apr 2021 12:22:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 12:22:48 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 12:22:46 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 3/6] selftests: mlxsw: Remove a redundant if statement in tc_flower_scale test
Date:   Fri, 23 Apr 2021 14:19:45 +0200
Message-ID: <898eb9e5bb2cc8ed82e7f5b5458befef96bb2ff4.1619179926.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1619179926.git.petrm@nvidia.com>
References: <cover.1619179926.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e16cc12b-f0ea-4c9d-fd1c-08d906528232
X-MS-TrafficTypeDiagnostic: CY4PR12MB1366:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1366614B90B3735B2FFEDB0FD6459@CY4PR12MB1366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6tVsaIz9as+m1WUhWFmsNqWdw4QpUD4+GrJ5LVYWp+8VUtJGgS2nxv/L617rydx5y21yboTvD7MjiCtOlI3K+KscPs0FDoV63m8+uXW8hiNwMCpnK5mFcCOQRJU5dpdhDIy2D/UK3J0W3iW2EDsxa67gUwqjxqQWt1RJyhJnQDDeeyTNDZ7bRkT9+nu5ZfyrGTSq673DRd+28xc6Q2wgSW5D7An57YB1uQZxCZHG/8F25oyO5zdg+WnDIBIlAVFCn01enV06O8j58mJ9qy55+sP1MU0N+2WgYW2EAPTygdZtu5lBpKA6GrA85XD9RiSFwTCtOU9g5CkW9EOVFv1qEN/EvHU2D3wfZBbF3pKUIoCVR+7byGH3tmS6EbMjE5vknnSnf2di0stCrFMb5aP3L7GIFDO/j+SX64wnBAqSmHxf3EW0FJaxFqx5OKtLtiy0j2dKtdllOljynToDN0839IWejnwafXLkRMxTzG+6xiSKIbBMCJsjZIqe2hcyvoikZh3m5V/oXKSRLBBJC+V2kIE3tL2BP31W/7OcVKnoj3vVoyfaRIN9AoAHGjkA6ZZWiuqAIUYVa6l+g0BqRPYBecdBA3+h9Y1lD8l4KC04AKPrXYT8clyfADg67BEO18xH6NiXgShHIP0ce/OfP381EKGlcjll5WLXBh1Yy5bsRjE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(46966006)(36840700001)(107886003)(26005)(186003)(6916009)(8936002)(7636003)(426003)(36756003)(16526019)(36906005)(8676002)(356005)(2906002)(336012)(316002)(70206006)(83380400001)(70586007)(47076005)(2616005)(36860700001)(82310400003)(86362001)(4326008)(5660300002)(82740400003)(478600001)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 12:22:48.9391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e16cc12b-f0ea-4c9d-fd1c-08d906528232
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, the error return code of the failure condition is lost after
using an if statement, so the test doesn't fail when it should.

Remove the if statement that separates the condition and the error code
check, so the test won't always pass.

Fixes: abfce9e062021 ("selftests: mlxsw: Reduce running time using offload indication")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh  | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh
index cc0f07e72cf2..aa74be9f47c8 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh
@@ -98,11 +98,7 @@ __tc_flower_test()
 			jq -r '[ .[] | select(.kind == "flower") |
 			.options | .in_hw ]' | jq .[] | wc -l)
 	[[ $((offload_count - 1)) -eq $count ]]
-	if [[ $should_fail -eq 0 ]]; then
-		check_err $? "Offload mismatch"
-	else
-		check_err_fail $should_fail $? "Offload more than expacted"
-	fi
+	check_err_fail $should_fail $? "Attempt to offload $count rules (actual result $((offload_count - 1)))"
 }
 
 tc_flower_test()
-- 
2.26.2

