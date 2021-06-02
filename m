Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F41639894A
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFBMUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:20:38 -0400
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:51664
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229593AbhFBMUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:20:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cms1Zj+st1Lf8IBtCZIZlq4ZTTz0PaJ/oug2+YQUectOtQIqp7Vq8Wa2LYONLTBdbVOcxgD3Siba8+hvb8D9MCEDVNLMN7PmrZiO/PMTybsvuIfXcYIUKy4c4rSVkmWsD7Wr9JRgVO1n/IrE/iIR9/j0+MS4TjEm8JGfG24qfo8asUWXkHOg+8V2NliJeLO5gjHxHEjkHrGM45kdKhBcMfL/dwsa0Gdnir/A7Ovg91HGQ7dR9XQU7MsSan2/9XF2LsXR0b/TwY17DgVaFs0H4G/Pey/mH9WQhSUTWiDl5fEmGhDdGTlZGoDwnLvaFOh/SDjYWcY5HmVb3ymUSneV+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2LzdaZnx3savQDZ5ujq1YZvvNiCMxv3ZqPMRzXpoCs=;
 b=QJmznlxhCjeIyeJsfcY2kafShScOpMtrC2KprmRPsIXObeug6G1HVveyOz9/+4d3j1oNVF19gPek8YqEZaWU6XtTQnpbctcJGS8S1Y6p9vj9Ql9Bu/6Uin/9Jj/U8ILYM/6t+0g56kiWUrlGOEolDwXlxv6HwcKDXeuzbeMG4lcqB16AjTkYiQkI8BCUrydkN1Zt1Hac4u8bUJ+au7gIvLtO3DJp0015UhszJJHzvZSGxiCM2un9WWXqVv+iZhVpvcwvPqYE/BM1HgpRSmIy9FEkdb6ykXkfhHrPPjAM4IlNqK34UlAtYgvBu/GfbJSpjyXGPwpNYvFz2/iV9QGWuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2LzdaZnx3savQDZ5ujq1YZvvNiCMxv3ZqPMRzXpoCs=;
 b=gk62X+TWD/gi86BIvOzY2JschDPkiPvPcZAA4bOX/ZBdnV/w+WAgNgOhItRJvjIE1pB+TGhip+tHCHN18ODrwv+0fPnbLfzSVA+JLtEFpDlSFzUvjgHFS0reCmgMmUmxklfoEjHdn3N8co+cApyof+a1Nath/QOB/eYs9fiVG7d90a4KcBXG9x0dcWebGmBOamHQnpR4rLwwyvxRAxLeR3MbqdHVuM0j4xNWOFIVwx8dXx5MVlRDzs3p6j73kZgZDiTvNhc4SwwItmcu9YeocdUeft7i7R4VT4hCgAmCifeY1HJEn9lKNXKkiS8r153AGIHyGxjx7PBeMgkSq1/jsA==
Received: from MWHPR12CA0037.namprd12.prod.outlook.com (2603:10b6:301:2::23)
 by BL0PR12MB2353.namprd12.prod.outlook.com (2603:10b6:207:4c::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26; Wed, 2 Jun
 2021 12:18:25 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:2:cafe::ff) by MWHPR12CA0037.outlook.office365.com
 (2603:10b6:301:2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 2 Jun 2021 12:18:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:18:24 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:18:24 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:18:21 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 17/18] selftest: netdevsim: Add devlink rate grouping test
Date:   Wed, 2 Jun 2021 15:17:30 +0300
Message-ID: <1622636251-29892-18-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30bd918c-549f-48d0-df32-08d925c0852a
X-MS-TrafficTypeDiagnostic: BL0PR12MB2353:
X-Microsoft-Antispam-PRVS: <BL0PR12MB235304EFEE2921631D410CFBCB3D9@BL0PR12MB2353.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o1bA2Aq+xizA/Q6ghy7DG67WGQwrHinPpIeujGn5P+CfOH2nLb0b0Ni1w1x8L7zVNBUzYdaNR1So016A/HTHXGG3YvQPMD69fihqZwHbT++OzJ03wAzXv7Jla449JqxzXSIbP3cHEc6qiPpiIrES0qLADNZwOVejSNxjUPX3iRoxyfTkqlkFadXh1oRAzqseepjgB+QHZIWmRJDCvq8cu/AiQ3UeVnkd/4CFGKG+h6OSW1UsMAfxPZppfWaTdr1+k5nruVMKhaZD4OYJTSD2bJzND2Ny3bYjQFM5Qzcrr4UjO/479Tm6+qOlDUCawHaeIJx0aiap5Szrh3WFu04zuYuwXA33QrNsKIMKL5CJgBKQikhwb1Jmtk9TVfT25/y2Y7bo+mPu5B+udUU7AblJNRsYQLTxfsG9eCI3TWO5D1GD7FgXwTyxa+LSTsWW6/UzFMGZFkHlkaQftF/KD2ICz6egcP+ya9YeNQhrnP9Nx/2c+UfBgtIMtfHSIKI9CuOntF2IQITz2Jz4BlNvzEcyk+muSzCGBDjFhavl7wy4mg2RLMrPRkTu09tbkujM/7d4uFjJEEr5xNnF4I196uunaw0800h/bLmLU3Q0s6vVY830KP1rrrqV4Vkh37rxZuSk6ZBwkoc3TF9O0zEhm9rkmA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(46966006)(36840700001)(86362001)(6666004)(8936002)(107886003)(356005)(8676002)(316002)(36906005)(7636003)(82310400003)(54906003)(2876002)(2616005)(7696005)(36756003)(36860700001)(5660300002)(426003)(70206006)(186003)(82740400003)(47076005)(4326008)(70586007)(83380400001)(2906002)(6916009)(26005)(336012)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:18:24.6574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30bd918c-549f-48d0-df32-08d925c0852a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2353
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

