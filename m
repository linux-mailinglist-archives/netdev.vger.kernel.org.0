Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0989B366F82
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244196AbhDUPyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:43 -0400
Received: from mail-dm6nam11on2082.outbound.protection.outlook.com ([40.107.223.82]:49120
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244138AbhDUPy0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:54:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sjfey6lZ+N/MJoSUdJlM8xme9If/uVo6tEFtzvTs206Ebjbh+v8Qbm1h3ZBAHp3udBH/uWsXjjUwBI0o9uN46Q1pw8aIDJfZnDNvpbJFx+tuRz9pDRL23lqcqFa/xn2tyJmxKyJOcIayb26/0oznb7PnksihCfvFLMz8etpSL/USTV5RyL5RXwrf1yZ7p5bvTpfg4OCwz0BgmNDULfdwVFC32rNjWRX1c+obwh8FMXgNGPMNkKtMKjDlIf+n5fCHp3GMAUGrkmYf2AK0sxCJzxV7XNIfK9fUEYPHKm4nmBqxI0Yxan/Zyl/mEMsUr2fDvGOyJKq1sxXLTBvpvHWFPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgsofAtCVIN/N8YyRiA9k1puUi6SGuEWtoXtni/feLM=;
 b=UFKQ6sIy/gdD5ZYB3pHavvADiu8XAMs+7PJR6t3HIo1bHfDFIMMGggpmqIMzGGGFN6SNUKbKHnWD0Jdt2iIol8VC74xTU3Uh5IdaFQeLSSbq7bEMm2UYOo9vi+UPBq80b///Mqf0WubQsDyFRXmMujo92VkDBzUMpwUZythkn5IzOdrsFrMki6uEGFYnKDYUzWcAvpbIJRdevz/Xk0Ys6pv/sT/PSSBNeZdGEM2MtTpLis3t1w3HgYCX7evk31LM55Ey96D4EruU+iYXQCQVSeWmFRIPL054q591jfDRmf6SFg9lCGtQgqKcPmYBOxmF6Fc5uY9I9/7yoG6wwgZrDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgsofAtCVIN/N8YyRiA9k1puUi6SGuEWtoXtni/feLM=;
 b=Y7sjFRlTCXjYfE/rzHjQb5WNtiNrAHWmnvCnR828ELFAdXNuw8nXHc36yhQxtRrpv262RvhkxYGJWz3VaSc4MsJcBuwW1ac60u+5XjQUJepIJ3IlfDMV4dtomKHOBLAuuP1A2Sc8+sBBXTn+IxQGu3QOEBQPDrqMsGLh/FsUa+GdO+purLqc7h+DK7ftWiHgUrCNfb2yrJbL8WbBcFtz2TdJ+8grhkBUCSAK+H0bWPw5i2ZDn6YvPHRv0Mf/llpGkcDf+WBNbPWNsAyyZQf2q971lqeRvBcX9qUUxeerwf+0aEFNEUdGJXvtjOAD/sGPHZHqwV+lxqWRhaHv3Zd1bQ==
Received: from BN6PR12CA0042.namprd12.prod.outlook.com (2603:10b6:405:70::28)
 by BN6PR12MB1730.namprd12.prod.outlook.com (2603:10b6:404:ff::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Wed, 21 Apr
 2021 15:53:51 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::71) by BN6PR12CA0042.outlook.office365.com
 (2603:10b6:405:70::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:51 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:53:50 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:48 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 17/18] selftest: netdevsim: Add devlink rate grouping test
Date:   Wed, 21 Apr 2021 18:53:04 +0300
Message-ID: <1619020385-20220-18-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50fe73fc-082c-4ff0-804f-08d904dda8ae
X-MS-TrafficTypeDiagnostic: BN6PR12MB1730:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1730F20A1FF9CDF918014763CB479@BN6PR12MB1730.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9w4SSCTd6aC+AulviCi+Lh0ceArKI678mL1gjCCH6zPVpgq7Y0bIzmsQ5AI3h6w972ZQFjFpUnUV2RrIZNI+kPzjrleYQ1GSsuFoiypjHxZ5TUYtFzDlrme7NNABF+nbH79S7OFjhRg3EnRnDN6YVh8HRou9S/x8tx5HQWckuOGWcQ+lp3jH0i9r19F+BX5+J0D+67cuL6h/Dc2u2zlWIlFb4jpfEFozPPlKKicx1EhQz8lXpufF+tiTYW11+h0GAYhTGG3/oeh8ap8zHq0hX+0vmTZ6xSLfmsjvk0T/ymvphUg3mzAE9WlP6Vp6fhsd5VPSlaqq9adaGj2k0cRHi+a3brKuVtD/k6crYIWLcrPwlIXHoJt+UfJxjLBHZ3SG4UP3Z5a6JVyb4yH9nufcIhKQpGRUY69Af3jNr1+N9g0GLDNEJp1xv8O6tklj3SqorWAaRwnSblEguBEi57s64/UEGhcG/0yHfWjPuvWoy/oC1IPods22ap8k1ruh1bhRTJmLrtUfdHsx4WkMJcNxRVbijJI+QR2kWoxhNpUun5emthV0tXaJcAxSs05WYsubFlIBJi74biu6rHrHfKsnFFV6fsyu5sUsjzYEHQSnWNkiwtStWyUi2/yeVrA2mvO6dYIs5eKDYRqUtHOYN6woNA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(36840700001)(46966006)(5660300002)(83380400001)(7696005)(6666004)(8676002)(356005)(478600001)(336012)(86362001)(70206006)(36906005)(8936002)(426003)(82740400003)(2616005)(47076005)(4326008)(7636003)(316002)(186003)(36756003)(36860700001)(82310400003)(2906002)(6916009)(70586007)(26005)(54906003)(107886003)(2876002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:51.2108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50fe73fc-082c-4ff0-804f-08d904dda8ae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1730
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Test verifies that netdevsim correctly implements devlink ops callbacks
that set node as a parent of devlink leaf or node rate object.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../selftests/drivers/net/netdevsim/devlink.sh     | 42 ++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 7c6ecf2..0f4b163 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -563,6 +563,26 @@ rate_attr_tx_rate_check()
 	check_err $? "Unexpected $name attr value $api_value != $rate"
 }
 
+rate_attr_parent_check()
+{
+	local handle=$1
+	local parent=$2
+	local debug_file=$3
+
+	rate_attr_set $handle parent $parent
+	check_err $? "Failed to set parent"
+
+	debug_value=$(cat $debug_file)
+	check_err $? "Failed to get parent debugfs value"
+	[ "$debug_value" == "$parent" ]
+	check_err $? "Unexpected parent debug value $debug_value != $parent"
+
+	api_value=$(rate_attr_get $r_obj parent)
+	check_err $? "Failed to get parent attr value"
+	[ "$api_value" == "$parent" ]
+	check_err $? "Unexpected parent attr value $api_value != $parent"
+}
+
 rate_node_add()
 {
 	local handle=$1
@@ -627,6 +647,28 @@ rate_test()
 	[ $num_nodes == 0 ]
 	check_err $? "Expected 0 rate node but got $num_nodes"
 
+	local node1_name='group1'
+	local node1="$DL_HANDLE/$node1_name"
+	rate_node_add "$node1"
+	check_err $? "Failed to add node $node1"
+
+	rate_attr_parent_check $r_obj $node1_name \
+		$DEBUGFS_DIR/ports/${r_obj##*/}/rate_parent
+
+	local node2_name='group2'
+	local node2="$DL_HANDLE/$node2_name"
+	rate_node_add "$node2"
+	check_err $? "Failed to add node $node2"
+
+	rate_attr_parent_check $node2 $node1_name \
+		$DEBUGFS_DIR/rate_nodes/$node2_name/rate_parent
+	rate_node_del "$node2"
+	check_err $? "Failed to delete node $node2"
+	rate_attr_set "$r_obj" noparent
+	check_err $? "Failed to unset $r_obj parent node"
+	rate_node_del "$node1"
+	check_err $? "Failed to delete node $node1"
+
 	log_test "rate test"
 }
 
-- 
1.8.3.1

