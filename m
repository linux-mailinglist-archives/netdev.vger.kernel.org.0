Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EA7391700
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbhEZMEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:04:33 -0400
Received: from mail-mw2nam12on2083.outbound.protection.outlook.com ([40.107.244.83]:51777
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234152AbhEZMDg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcWwx8R1ml8gaPIsiYMPviieG5zP8R7WrTfaDdpA4ibQqfmljcm/EXvvRjoBeFPwvW4u/lCx5fq2AlJWcMYz3t3XLALkS4IitLBWxIrKtLrBpQMkDRaeN8lwP0Kfk6bfmdUEEoKLSFFc0UKP1nMmAeHuiiXBrR7nzTRGUk2BwYMCwZZSsqnPEU9PgYzSD5Ab4B4gFuPlWr44iWtYTnlZCf8/eXHOLZV+G0wGy3UWAZq42RhOflEMLj9/YxhXU1o9j1xndcvgsx9i7NMozRMeRZQ6VXDmBh3137Th3T9Nf+ZKNG5D5LVG83Gk5oHhtvmXR3J7lMwrUO4AVFhJe01ErQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2LzdaZnx3savQDZ5ujq1YZvvNiCMxv3ZqPMRzXpoCs=;
 b=CPpapTX3L8cC107Ilue69/40+4de5DqFBtgCR1thQhRZV1xcE0hn7oYjBew+5BuKJkaJ/9g7jl2hCQQ2mqVb/2syQkvq+yOFYxL9A8u0RD3KPf+munNhRJbKpRdFb62ttLZKlcTWnBPtOyQVUZLY1IAi7YR2N9MV6GDvgkJFwhU9IOAev2Nsxd0IyGyM+J6M2j8aCPxgCBqyZzUVVdxUj38Utx7pqXGPlUmPaO5LHwmAggeV9PzMwJRPt/eeh54mE2pp5mqtNeJGkJbHKSDkENkdPQt78TCAdbR7Ul5l2PanWvxgJ8YX5hvZAx7NSXRPEM1jqTJiOZQz+Kk/3/xkDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2LzdaZnx3savQDZ5ujq1YZvvNiCMxv3ZqPMRzXpoCs=;
 b=pnDracNj1vgA7yua33jSHNJGo6kpceGqA9ZsNCv0Gt1FPp8lrSmqpmRdsfYroPmdXxB16rfabAK1HHTDZAgi2b4Bkv89zPD2hldQos/EBInGTe+mIYGwGssHg8YZuQ2/KTDt68bB2PfQjcZNhoqtYMinOnDKj/JnpYQYM99ylZRr503LcLV79aIxFIIJV4R0jtawK792MSg7bM31lPKQKCEkf/mXFflJ2vwQAflg8p27y9obEjpHLwNzq5ih+VuCIFU/1OWPGRpWDGAU6Z61WeDE00vmbw65KjUxpfLrHpFBkQLOon25RzefA5ek9iLWEB2dJuNwCZ6m2pNfwZxbzA==
Received: from DS7PR05CA0008.namprd05.prod.outlook.com (2603:10b6:5:3b9::13)
 by CY4PR12MB1190.namprd12.prod.outlook.com (2603:10b6:903:39::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Wed, 26 May
 2021 12:02:04 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::7b) by DS7PR05CA0008.outlook.office365.com
 (2603:10b6:5:3b9::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend
 Transport; Wed, 26 May 2021 12:02:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:02:04 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:02:03 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:02:01 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 17/18] selftest: netdevsim: Add devlink rate grouping test
Date:   Wed, 26 May 2021 15:01:09 +0300
Message-ID: <1622030470-21434-18-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 409888eb-1af7-4b9a-64eb-08d9203e13e4
X-MS-TrafficTypeDiagnostic: CY4PR12MB1190:
X-Microsoft-Antispam-PRVS: <CY4PR12MB119097227F7865F13708BA88CB249@CY4PR12MB1190.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQt5/wXW6nAhVKF0NyVCa85n6NL8mNoHnDW/igjqYpq092Y+xBacTDMbD74nbtB0cwPUU5RxDyrstOq/lU38SLymmFUWgplNrpTZ7MpbY52PMdLNSpQVMYZCgUnKobRKxBvGyqiy0XxPQzQIWxk+W6v4SXb9CYy4ECqxzRFovJ08vP16kxlspAxyZ1TpOgxvX3NE7SK3VIWSYCoBw+EW0MkrXm46MInx/PEQlD7L/VJ+5AtToCMwahwXHPGnZfKscBJIW/lWrJvqEeF3Z7zL0rCXOlg3uuPIbW+KK4EFrVRYgXqIQqOh9c2Od0JY86nm7C82f8nOioggEKBuUgIay/iEZEpl1ovoc9tFeAYgYWuQCSsvLDU63w8OK0q8mzTZMbHZ6DWTjAT/60PdX79vD/6YtRjknAwoYV2fhMr1V19YwZ1j6eUl5dtWiOfjalaN4hugsHpdrpOUVjfAFeDIAKVUs6XftO0Ui/1hvBuxe9cQFbLbxT7f5ajdNnvUHi0rs27zBXPckiMosvUR0dxv4P+7AhqvQTnkUqsmXQmljSiSm9tuttvWLYVe16K3TSwCD14RCr4JQ/1qtUmRL5evma2zPRlUdZJSdQ3DiIzOLOoUT6Rk5SZVlPVB0VZaPrS7elczwSS+ZfSpSb6LHahRkQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(46966006)(36840700001)(5660300002)(8936002)(54906003)(82310400003)(478600001)(4326008)(26005)(2616005)(2876002)(2906002)(6916009)(426003)(36906005)(107886003)(86362001)(336012)(316002)(36756003)(47076005)(83380400001)(7696005)(186003)(70586007)(70206006)(36860700001)(8676002)(356005)(82740400003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:02:04.2192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 409888eb-1af7-4b9a-64eb-08d9203e13e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1190
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

