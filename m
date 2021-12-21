Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952F447C1E7
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbhLUOvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:51:37 -0500
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:52833
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235660AbhLUOvg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:51:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3DM0GfjEJDOdFCaWjpAg2dhMZnZVipG8we9fCDp3nQrgHOuicAKclcv3y7sCKajmuHwONn99U/++vSk01ef6/Tkr/AK+gxxvACpIiMYwYb2U8TagfW3xJRUIjyCJWlJxfs+NXAc1w0HI60C98jVEQzLl7HyIpOPmcm/30RZJsuUl59s6j82ynXX6parn3ou1aegLrUI/lbOy/9qShbqDSAMUx4YrFonFsWWhrhOWvosszOVlzbpZ9JI0sy/w8auNIOOFGBGw3UOlaRa1L4GHwwXDIW4lqExN9rN9DnpLtFo0PgFb9hX9il/Piea/VA0nTC9/5gT1TaUoX8+ehK3fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1fEHPi5BMvAxcb6JTJ9wRk3s3rd2ahGvO0Hmd7y9vsg=;
 b=M0xsqRvZqbV451iF5/jT57w5UQsQfHFcr3S+p7bWf/UQyxRlF48QSwx0iU6sWk1pcydCtCYsSd3TnkzIJTacuzarWRc1S051ZXORDLn2XL+ups0dB+85bGKCtJGGJcgmqtkER9s72klITxL+BFnmo5Z1SJAlwq/aFa12+x+06vc4FqbZ4ut5gdEhnqDMOpTatbAFkNUrBaSkeN59xGmabfdF0GjDCRMVy43VfO9qbkobkMzMxaCqyNvwqsmIx0G/Hu0dUTiIDUwBWBXaTEuJ6ptGX9gO5XhOIO7/Mhb5IFDPTWmponqeQzgkKfVjpGCe/Mwc28M3jG1RsIiCDhxe3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1fEHPi5BMvAxcb6JTJ9wRk3s3rd2ahGvO0Hmd7y9vsg=;
 b=F2iQ7DxQVlYL+INY3HkVCzMgIg1WR8UOxP3US436wcLhdxOCHsMy7dz53Sa5JHVzkCV5HQcITRBzJcl2SLOBRdY0BAHG7bmx9gsNqo4978eJJ3GvNQ3p4kjI0RBQMJHHKwn78pNqKzJczvZGlVLjVhr09RZJBBInEqKMQJShnhZ2ex+guGoiFqtZbU/XEVGmBUDBsF/KFxG1FXHM6YNEVvQorIgEeM4y50H6a/YJxULRdw94rOwYAi+tX6ParhyYYolMoGLT9bQBcU5nzSt1PndAk1oHdLgGrjIAwKbhNR0020VMa7Uo6kr0liDrjSwWQCfmW/gBtZVBKMz9yfJXqA==
Received: from MW4P223CA0008.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::13)
 by MWHPR12MB1776.namprd12.prod.outlook.com (2603:10b6:300:113::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 14:51:33 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::c1) by MW4P223CA0008.outlook.office365.com
 (2603:10b6:303:80::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Tue, 21 Dec 2021 14:51:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 14:51:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 14:51:32 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 21 Dec 2021 06:51:30 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 5/8] selftests: forwarding: vxlan_bridge_1q: Remove unused function
Date:   Tue, 21 Dec 2021 16:49:46 +0200
Message-ID: <20211221144949.2527545-6-amcohen@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221144949.2527545-1-amcohen@nvidia.com>
References: <20211221144949.2527545-1-amcohen@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73815018-94ca-49c0-5eb0-08d9c4916161
X-MS-TrafficTypeDiagnostic: MWHPR12MB1776:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB177623B9617B6D6DC61C2D91CB7C9@MWHPR12MB1776.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BxsT7Nn2LNBNksEPLkv+gxcH7eeBUf/wcR6QbxSsGyaxrA2uOvz7zmiOV/DRKedP2n/jHkkgYjj8kXfdoXHntE0ZgEhkqWpyJFA0/wOGf8n7s4sEjMXldGGc/u/VKctemJbIFZv4XiAYtxb8RKQWTeZWh0UH9+HRVswQWA1WK41oLwCNhp41B/eOjIc/s8qD1jUTx8XPhEazliDu5eSo/6Leqm1d1gVv5wINIjKdO6I8Z5RwOjofzBEfTCUlhVQlkGhRQQXpwfxI28DXHlVBPuGsH3WjLzgHB3+fnOyV04ZAAMKQ1dMIf2/Ff6ISTc0zqKUbYP/Xl8rDnuRArDlkfjmu7AoXIQ5hgtAqfEzmpNk1ulmhDjNaT8OfclK4FEWvxcVmTy//wPu2/DNV8d3XdGsIy9FKgOQo+kVy4SyxLQo0bNGlHUiVyGHwqxfMj3PTAroHKBbAzcLAhURi8QgjCbv84+oo/BdFzRu1Ic0Dm4tVKb6QSVJg1XpgPRZnixbKh6Q32WlTq6GNQ+hxAkR6f9ES0SpVLPI+XRUJJyLnT4rthTaZOMIadXobQCmtsZSk0A6r2Sg/3COtcoPA+fcGgdPbqMzvUpzI1i21OqWbmBZSuQ8ACalqkpgWgwHzSChfi80JNNY9KnjVUrdshQ0vDfH9EZ2kju0fGD9UHUdbHCXV8gvYPryryaQ+t9zsyN/S9vaVL8XoibCOeeTQjGkfTLrkqqWtcWHg0pMvoebyuKW0rSqF+NqMXoeJ2+ZFQSuH4lY17UGFyosWYkJjcihv+THdxyVrEag9em+8qYF9llhBRvmJcF5ZivTvCW9sB8uANWGz1p6pUfXVovDKESZM6g==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(82310400004)(47076005)(34020700004)(16526019)(1076003)(86362001)(316002)(54906003)(8676002)(83380400001)(336012)(4326008)(186003)(36756003)(6666004)(426003)(40460700001)(2906002)(2616005)(26005)(8936002)(70586007)(70206006)(6916009)(356005)(508600001)(5660300002)(107886003)(81166007)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 14:51:33.1615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73815018-94ca-49c0-5eb0-08d9c4916161
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1776
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove `vxlan_ping_test()` which is not used and probably was copied
mistakenly from vxlan_bridge_1d.sh.

This was found while adding an equivalent test for IPv6.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../net/forwarding/vxlan_bridge_1q.sh         | 20 -------------------
 1 file changed, 20 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1q.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1q.sh
index a5789721ba92..a596bbf3ed6a 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_bridge_1q.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1q.sh
@@ -680,26 +680,6 @@ test_pvid()
 	log_test "VXLAN: flood after vlan re-add"
 }
 
-vxlan_ping_test()
-{
-	local ping_dev=$1; shift
-	local ping_dip=$1; shift
-	local ping_args=$1; shift
-	local capture_dev=$1; shift
-	local capture_dir=$1; shift
-	local capture_pref=$1; shift
-	local expect=$1; shift
-
-	local t0=$(tc_rule_stats_get $capture_dev $capture_pref $capture_dir)
-	ping_do $ping_dev $ping_dip "$ping_args"
-	local t1=$(tc_rule_stats_get $capture_dev $capture_pref $capture_dir)
-	local delta=$((t1 - t0))
-
-	# Tolerate a couple stray extra packets.
-	((expect <= delta && delta <= expect + 2))
-	check_err $? "$capture_dev: Expected to capture $expect packets, got $delta."
-}
-
 __test_learning()
 {
 	local -a expects=(0 0 0 0 0)
-- 
2.31.1

