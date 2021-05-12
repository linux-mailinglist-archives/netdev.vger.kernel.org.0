Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB42A37C0AF
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhELOvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:51:44 -0400
Received: from mail-co1nam11on2066.outbound.protection.outlook.com ([40.107.220.66]:44257
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230429AbhELOuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJA3LxGcb5wyXpE4iwLGWdPWFJvdmepMAY0Mq/aAy6hUSOj58MDDhy8S63ZVUa5OPimw6H6RcjtUQb5JjEaTi6GD41ETTUHNY+T/+0fqLosX46RWHOTeV9DwAA5Ye+ifiaPSuHb16NwyAvvK/dNy7iIVvEwQ27hfN05Elt8p8e5J5T8PCQNIEzDBqE7inm4yDx+2Py+9XfMPL2bkNpvTUP62veRVVRQ4nMe/ZLrbBgk8MWKZkJALs//abEYutBRy5ml16/hcQGkSZVT0LvM08Lbj4R0xNnKHuwsVACf1b9tWMyYQjqguv85cPJvp/3pkhJ1q42KJu/2OC8DhXid57g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2LzdaZnx3savQDZ5ujq1YZvvNiCMxv3ZqPMRzXpoCs=;
 b=kNSv1Yq9zF2EGHga588fX9CiyM6sWPr5dGg9SV0MIazAfJcdP2kStAQQNeILdsp/EHUxGdHIqszvFAUXakTyPk6/GnO+eXmHrG+3F+YkWJF8TKMVyr+NYQO0spOoS3dmw4H1bPBhtr/11XfvKHCI6QeIGT0B110VZ2OMd0DFFNff9ELUImS/8fOg8Hg0ZBq20H0vDbJurRGUHNqbXnga9EuOD4ZcFVVBVEYOk4h3760H/vvX9G3EGwonjRXuELBlmqFswU7Khn7seUKhnjlk1wg2SYgou7wnn27rrgzoEBK3iJPpy3HeHem4nyNt2pMS7a8sVmc4SOnCKg+xAv7DiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2LzdaZnx3savQDZ5ujq1YZvvNiCMxv3ZqPMRzXpoCs=;
 b=HSniGcu2pL1veTcXWhkIWhHOF1czYyBSXnzuK2ZUJ+4Rg/0GYlNy6rvIYq6Fc2TZ5nQevtL89ySaPtJslbIaECuoaI19w2ADtmyYqlzlgL1kCE+alWUGxpd24ja3Mk6nKKAkQ8+N0ulwxYWSd1u7B6Ekk1zEiKmOL4kI/fABSnmUT01/rNJAoatriBe4vVdj4NE2cYCoCn8Jtwl0w5qwd7YzV1/f4biFCTDxoa50/5ePWH347BqePF/zjPr4Wmb8K7mN7Qnxso4UhiuDz7xjWbH5k3GUenhAVGj/ovhylqXDMxH0n7Io8uXq6YOHqb+whFLIp9DtEZycAn15AhBSmQ==
Received: from BN8PR12CA0009.namprd12.prod.outlook.com (2603:10b6:408:60::22)
 by MW2PR12MB2411.namprd12.prod.outlook.com (2603:10b6:907:10::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 14:49:41 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::b) by BN8PR12CA0009.outlook.office365.com
 (2603:10b6:408:60::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Wed, 12 May 2021 14:49:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:41 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 07:49:40 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:37 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 17/18] selftest: netdevsim: Add devlink rate grouping test
Date:   Wed, 12 May 2021 17:48:46 +0300
Message-ID: <1620830927-11828-18-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3096839b-0a34-45a7-4639-08d915552ca6
X-MS-TrafficTypeDiagnostic: MW2PR12MB2411:
X-Microsoft-Antispam-PRVS: <MW2PR12MB24119A124C4869A3C2CF0AF1CB529@MW2PR12MB2411.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fOYfFmuh2XQ3wT3qPiA+dyE856UZmThwReAdwlG6URYX6hJr5LubUrjWQyxojD4KMF/W8R9IamB/SAKMfWC8rjINt1+BCo5XQWoVXJWWKGR/d/VMB1epoWICxd71McMEBJPYutfKu5WTgE6Qn2P0aI8K70CeuUmiDeyQpOifSIa3hZ0Dp3M2gXrSV1C5pGvly0ZXP7uWEAoqoufF8aKJup17zvJH7E6n3RTj/2bzEcy/upBIZWjfy8GV73xwaf03d2yihR92qBKDik3Yrapt4hmN1DO66fte6FzjGE9mu406sMb5BP4ApsDdHj9LGrh3E+shsHOHRE7dDAbhjZfxMF2sfUJiv9pytKF/l8ePf95XOPVXLTVAEBUN7YYsDjiqvOn6PEOuh2LDGeL3hG9KtoaFhVC6DDeLtaR0gXkfi9g4BDnwyiA51LkdubTp7vnwEydaB4Xj7f+Ql6FG0skZxsPcVnNFSMtpZjWeqhsVM7g3Sbnw8nHM+cObP5rIY005jl7GUPvPmHmbT5UNCjHbZ1Fty797WICTLJHvvE3RkySzp9YvExTCEajRLmszbZscj12I9WjujHEV/0yJM2mjUjPAS3saBZB/E8PMxJs7nAX6K/9hRKoPtVGeEIGuKbsxQk3bDW1VOqUv5Bjmhm+tsA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(498600001)(6916009)(356005)(83380400001)(6666004)(107886003)(4326008)(2906002)(8936002)(8676002)(2876002)(7636003)(336012)(82310400003)(36860700001)(26005)(2616005)(36756003)(54906003)(70206006)(86362001)(5660300002)(426003)(186003)(47076005)(70586007)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:41.3404
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3096839b-0a34-45a7-4639-08d915552ca6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2411
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
index 301d920..9de1d12 100755
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

