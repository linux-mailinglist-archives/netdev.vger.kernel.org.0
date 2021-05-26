Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D43A3916FF
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbhEZMEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:04:31 -0400
Received: from mail-dm6nam11on2079.outbound.protection.outlook.com ([40.107.223.79]:7136
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234597AbhEZMD2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGY33JsCFQCuYzkEo79+0yZ1TpvUiSxwRmeQn0zjJwciIMzpMIy8uR2L71QBgzNDX5OL4qxviZ57vhvd+Jb6QiSjXDC8WDWdtkm2csvipVyV+S5Rg7F+lPKDSV+9HQux3rDvcJkc7iJB9WO//GtS1Y/oEcdt8BDBKj2fqjX1ziqarFuq1cq7IVKNjtoIN3IrrFEeIfabgqMULMQDTOZt8FgY8TG1IdK9kFiZCI+lwl+r1/Zjkch/IlL/Uei09uXKabpQLxQ6AGet3iS0hlxp4MDTGQZ6jeu0A7HGw01q+PF+f4AZuQ0cJNiAbP2yp8kbsT6vFcM0Sb5etna7nDIPcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLD8T4pxHK7ogEKokyiWUTLies05D6B56tHXfxSNF8c=;
 b=eNxhgQf34152Qi0OHYe64HCAzXjzexkE0kAlEn5sdu0iGYlEZ5bXFDaAgOartM9iemn1MZXSXM4xvG70yfB9ePdHZ0kYxAqr6Ntu3P1KpqbGAZ/DvpNUGL+Wyim03Lmn9340y0Jmva2VwbtzJGfKoVe1wVUtNUZWdgBFs5rMXM1Flz+QfFnIg1jTkDycy6R6O9YUm2A4GfPeB22ufkknwSq4TwDrOnsMeYbD4PYmmba40+Y121dAH4RUoj1CsV7YIYCYQ67H7hU3Tm76gBFLlOzpVgi75HCdIN7BuEcogf+BBVgDLpCPjAj5JEUC4itV8Ce2KJwDxX4lZz/HBcEZ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLD8T4pxHK7ogEKokyiWUTLies05D6B56tHXfxSNF8c=;
 b=blG9SVnA5X4LDzzVo/OjawkPSVOLThlG1j7YnukFkbdl0zRCBLSO8tWPL1eOthtMYU87nZlT8sur+NlfwiTZHRLQRnFo6jD01nE6lwJwxiEG2Yur8Oo89GkE3IGMBMViXe8ze0UQy65Cg2+7SAV5gRuFm9+mwGkdqRmIYocmUcPjC5Ft6oetDUKq1YCH6pEwgWGRlaRIhPKV7p+PCG+PyomkSxTmU4AWRbOaddUHn54Gvp0YQIBYjqG1jwOalc4gMDBnRInta+wFqAra9vnYLzEp3Y9/n3kC39kyPACL31oLANkBHsLxWGi/hWZu5WAw/aORCfw6jRW3+gIBv6h29A==
Received: from BN6PR1401CA0001.namprd14.prod.outlook.com
 (2603:10b6:405:4b::11) by BN6PR12MB1426.namprd12.prod.outlook.com
 (2603:10b6:404:22::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 26 May
 2021 12:01:56 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::a8) by BN6PR1401CA0001.outlook.office365.com
 (2603:10b6:405:4b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 12:01:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:01:55 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:54 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:52 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 14/18] selftest: netdevsim: Add devlink rate nodes test
Date:   Wed, 26 May 2021 15:01:06 +0300
Message-ID: <1622030470-21434-15-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46620bc4-3fc9-4361-922c-08d9203e0edd
X-MS-TrafficTypeDiagnostic: BN6PR12MB1426:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1426DA38BE665654EE5592A2CB249@BN6PR12MB1426.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mKV/NNB2BhOIftkTnY46I1xbPMcZ+o7UO6XnV/QXy6uS/057gag2DW4fdvxvl0lIdqVy5YeqXvEqyB31QgYxdOA41y8GJe8OsAgwuLdS17VHncUEMNmYtuelk89XhvJ1+NkwfV3iXpJw0gO6VDWFV3oZZ+ZpVWNLP9uNKvzJV44yM7tSrq+bX1QbITceTWjStikhNUUka4uCvE8JbEM3eBu11Y3OzHTDo7MjYe6SEtUcJtAiIj498z5hwidp04ZX9CECmlPHYM4aH2d6cgBs4pp2NcL4jBA7FvCd25LWijYVWGA/udRD3iSNSNBt4hgn+p4kTcXqPBBd074cspySww4D0yZHxvgK1w7XuNXbRcg9UQt/wCEFUPX3dC8iehXrErTZqx6DC8yRu2bPNdyiikTH5Bv4N6MLASHfOOxZZlfvzilyGXc4CGE+PDimPpteNQnvQ+U9Ol4ubEAoqyGq8YvSfETHnm5ZY98rBTwPaEltAWqzduHfagJWM7dZhT06kWgce4+hfjz2LC/QsrrixeFCMMXP19+47BxiFba3aqhZWrHNo5S9UgFYY+VIYHwP3OfITYx1RM9RtrLehTY9p877sz9LT2O6dtzHarITPVsEPODhWIB56RH88o1NRXBOABqcoaTQvaRzx3kYc6ki2A==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(36840700001)(46966006)(336012)(186003)(26005)(2876002)(426003)(2616005)(2906002)(47076005)(36756003)(5660300002)(356005)(70586007)(70206006)(86362001)(82740400003)(82310400003)(83380400001)(54906003)(7636003)(7696005)(36860700001)(8676002)(6666004)(478600001)(6916009)(36906005)(316002)(4326008)(8936002)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:01:55.7349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46620bc4-3fc9-4361-922c-08d9203e0edd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1426
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Test verifies that it is possible to create, delete and set min/max tx
rate of devlink rate node on netdevsim VF.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---

Notes:
    v1->v2:
    - s/func/function/ in devlink commands

 .../selftests/drivers/net/netdevsim/devlink.sh     | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 05dcefc..301d920 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -516,6 +516,14 @@ rate_leafs_get()
 	       '.[] | to_entries | .[] | select(.value.type == "leaf") | .key | select(contains("'$handle'"))'
 }
 
+rate_nodes_get()
+{
+	local handle=$1
+
+	cmd_jq "devlink port function rate show -j" \
+		'.[] | to_entries | .[] | select(.value.type == "node") | .key | select(contains("'$handle'"))'
+}
+
 rate_attr_set()
 {
 	local handle=$1
@@ -555,6 +563,20 @@ rate_attr_tx_rate_check()
 	check_err $? "Unexpected $name attr value $api_value != $rate"
 }
 
+rate_node_add()
+{
+	local handle=$1
+
+	devlink port function rate add $handle
+}
+
+rate_node_del()
+{
+	local handle=$1
+
+	devlink port function rate del $handle
+}
+
 rate_test()
 {
 	RET=0
@@ -582,6 +604,29 @@ rate_test()
 		rate=$(($rate+100))
 	done
 
+	local node1_name='group1'
+	local node1="$DL_HANDLE/$node1_name"
+	rate_node_add "$node1"
+	check_err $? "Failed to add node $node1"
+
+	local num_nodes=`rate_nodes_get $DL_HANDLE | wc -w`
+	[ $num_nodes == 1 ]
+	check_err $? "Expected 1 rate node in output but got $num_nodes"
+
+	local node_tx_share=10
+	rate_attr_tx_rate_check $node1 tx_share $node_tx_share \
+		$DEBUGFS_DIR/rate_nodes/${node1##*/}/tx_share
+
+	local node_tx_max=100
+	rate_attr_tx_rate_check $node1 tx_max $node_tx_max \
+		$DEBUGFS_DIR/rate_nodes/${node1##*/}/tx_max
+
+	rate_node_del "$node1"
+	check_err $? "Failed to delete node $node1"
+	local num_nodes=`rate_nodes_get $DL_HANDLE | wc -w`
+	[ $num_nodes == 0 ]
+	check_err $? "Expected 0 rate node but got $num_nodes"
+
 	log_test "rate test"
 }
 
-- 
1.8.3.1

