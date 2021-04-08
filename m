Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B5D3584F1
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhDHNkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:40:39 -0400
Received: from mail-bn8nam12on2081.outbound.protection.outlook.com ([40.107.237.81]:65025
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231801AbhDHNka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 09:40:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUjdxAx7yfg+8PSRd7HgmSFN0IlcL6QR1FCx9w3PsDGamDodaRuycSOP4cdo9cNyuIYZVbXas/iHHffPhpw5xK5FwWzSgjQeNsd+iRNEDLpt1MuzB6XQixypS6Gb8RWF/MeIcNyXv6Vl7V7cGyzUfU+8qS8zrlp74IAxD1NV0tj9JWkdUbfFL0O6JAAjHZmU8k3lTEgP96gCKN0IV4vSIhBiEgufjnOJOM6WoEr1Ohhd2YNkTDYBOZMpWdoR8AodoKZ7jRk/HYWFkqJYbMbH2+xQAZMBzzGNRDqbDLq1PpS8wrzb1s7J+cGygOCqVY6qf03swyXdbLKu3BtLsKBfvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWa2gCulQOfxI5FLqJx9L7x42e7BhwVM22eMRXQOZwA=;
 b=JKd/oB2hAG4koIjhKB7PJyHHDbrP8VF5YSbtadED2lFavuluis4kUYN1fC1kG8LU4ZEmkBjj1HV/TpwxcYS7H8W2W8fdEwbmygc9bZJloba4q+uj2OUFnYyUMG2LHGRHl8UyS0fWFS8etqDRZWd4bDwPq/DY1SmNW8SqBwQtcg+ocUlKrhOFhruAPJopuW+CsZqebJomSXVF+HoHaiVnQPORS/tZFc/wllGAF33G/C4VPK790b+2+7ZNgYOv/gAcat/a9hvef4Ln8V2DBjYopac7XESYUbLmerVKRwuqW/7bV2JVHAiCUpNisWo+FCsFABkAhpVATEnKsFNLnqDvlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWa2gCulQOfxI5FLqJx9L7x42e7BhwVM22eMRXQOZwA=;
 b=cQhtN6vPfzh61w9rX8dfzVUnrdjpBtepoduaPxPz05KaZDBfNePx1Ve68MrmioAZ4hNiWKEFZ1287XzFiB1iL71CBy/W8QyjcruNmk08mUzeUR0FFvOCl4lr7/BlteSGWKlvxNaK51vK1AS40dV9b+FZwxCyDBMOd7D7LIBAd14jzxm/DSUCtBuaw4OrCmuzVIy4NkkgChmd640/FD2YjSs/fx0skgLaDN5+D0NM3v+meG8UCs+SS7eRG7rWqfpKjgfjFPqOxfjhJybcWMQg9VaQKJLLT3SdNBNRtABLlJLufVmWB4hS9/sD3QfO0OEJ1Lc7C20AR0fc6ISixsdBFw==
Received: from BN0PR03CA0029.namprd03.prod.outlook.com (2603:10b6:408:e6::34)
 by MWHPR12MB1773.namprd12.prod.outlook.com (2603:10b6:300:10d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Thu, 8 Apr
 2021 13:40:17 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::c8) by BN0PR03CA0029.outlook.office365.com
 (2603:10b6:408:e6::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 13:40:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 13:40:17 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 13:40:13 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 7/7] selftests: mlxsw: Add a trap_fwd test to devlink_trap_control
Date:   Thu, 8 Apr 2021 15:38:29 +0200
Message-ID: <20210408133829.2135103-8-petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210408133829.2135103-1-petrm@nvidia.com>
References: <20210408133829.2135103-1-petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e610f09-aef9-41b2-643a-08d8fa93d8b1
X-MS-TrafficTypeDiagnostic: MWHPR12MB1773:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1773032036BF3F4A13B41C54D6749@MWHPR12MB1773.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mWqakO4vwfOsX73dHwyH/gScqjK5JVGidXtBmqbQGxrPsHMJEF1C+WHpAad2qjmWrCHxC9n8tSLtkqoXzg9sFf70j/Yp8mkK+iIIOy3ZE4GMP3GgozIcux1mHLdTtJ3FaL6NxKDXXkp6PTwOVjSeRm07pO/Vjoq3CqSRy/JxuVsa5JV9x3YjWMWu9S7rdO7R6r3lc2CcYqfnms08vCCge4q2yD717z7lrhv/iLxyVUqaFSLs0bW7SuXNTdwz5Kw3Cl2HdfGtH4L1mpvf4+T/1XHhVYXo1ArwA0FaNZnNCvvoSp01px3Xb+Bm7UVAfLuKxEu8Zts/HQoh3PTPFcnU6p38YtEEL8hZ7gWWnfs35Gbfoumxj9sV5InxKao2xQSvD6rvxri8+lKM/wIEbp9fT902jM11nEQXQRWRqJodfKqpecgy6dLimbnoD2jzfG2dcKA2i2E0dW/fwZ2EZzWqsY3BfUaRo6hyczVt70uuSC3YY1XAqI8WHJkPfY9QTQO6hRm8Q0pkE6AOUHcpbe4BzVjTDQoo+eT1Yn4ffecmS4F54WUOileIxXtcgLkz/B/bcfhdCEXXtEzj7wQAM2iLk7dKy50ics9NgFF/SXsbam2Du4jORbkNosHcGVhyizahhi9ynfo2zyNrhlGk2sP1hg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(36840700001)(46966006)(70206006)(186003)(7636003)(5660300002)(26005)(6666004)(356005)(70586007)(16526019)(82740400003)(36756003)(1076003)(36860700001)(316002)(54906003)(6916009)(36906005)(47076005)(426003)(4326008)(8676002)(83380400001)(478600001)(8936002)(2906002)(336012)(86362001)(82310400003)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 13:40:17.3816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e610f09-aef9-41b2-643a-08d8fa93d8b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1773
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that trap_fwd'd packets show up under the correct trap.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/devlink_trap_control.sh | 23 ++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_control.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_control.sh
index a37273473c1b..8bca4c58819b 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_control.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_control.sh
@@ -83,6 +83,7 @@ ALL_TESTS="
 	ptp_general_test
 	flow_action_sample_test
 	flow_action_trap_test
+	flow_action_trap_fwd_test
 "
 NUM_NETIFS=4
 source $lib_dir/lib.sh
@@ -663,14 +664,18 @@ flow_action_sample_test()
 	tc qdisc del dev $rp1 clsact
 }
 
-flow_action_trap_test()
+__flow_action_trap_test()
 {
+	local action=$1; shift
+	local trap=$1; shift
+	local description=$1; shift
+
 	# Install a filter that traps a specific flow.
 	tc qdisc add dev $rp1 clsact
 	tc filter add dev $rp1 ingress proto ip pref 1 handle 101 flower \
-		skip_sw ip_proto udp src_port 12345 dst_port 54321 action trap
+		skip_sw ip_proto udp src_port 12345 dst_port 54321 action $action
 
-	devlink_trap_stats_test "Flow Trapping (Logging)" "flow_action_trap" \
+	devlink_trap_stats_test "$description" $trap \
 		$MZ $h1 -c 1 -a own -b $(mac_get $rp1) \
 		-A 192.0.2.1 -B 198.51.100.1 -t udp sp=12345,dp=54321 -p 100 -q
 
@@ -678,6 +683,18 @@ flow_action_trap_test()
 	tc qdisc del dev $rp1 clsact
 }
 
+flow_action_trap_test()
+{
+	__flow_action_trap_test trap flow_action_trap \
+				"Flow Trapping (Logging)"
+}
+
+flow_action_trap_fwd_test()
+{
+	__flow_action_trap_test trap_fwd flow_action_trap_fwd \
+				"Flow Trap-and-forwarding (Logging)"
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.26.2

