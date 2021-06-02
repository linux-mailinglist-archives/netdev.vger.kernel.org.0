Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA87398945
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFBMUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:20:23 -0400
Received: from mail-dm6nam08on2066.outbound.protection.outlook.com ([40.107.102.66]:49027
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229745AbhFBMUA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:20:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYtWy2MwGRc/Y16FLPMXuXcT37zlXw8d/AKjGGGfdYR6+u7aJ0RPzBXHr4agsMDC6odTmQPiYw29sKZ2CsbJeRFjtUa9xQLHPl3JEQf/CR87IBdwbz47TIV6eOA5Yr86quYX0ZanZ/IBvyeLyD/Wgc8DkZ+QL3qV8ctEOM1nCpPIgU/Tb6SnMnd06eHANU3M9bO8PLkLJ3rEC8zdXm6fPiL9yAZ1VPkcaHcKFDkGd5U2QYszqS/lyg20NIjuLxiyD/LhWn+lICxiNVkNAE9RAtN8iMfJqB7aW6GHToG2UBTa4bd7kTUghLFNarVrrxR/IimS+k/PhEQLQgziYM77zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLD8T4pxHK7ogEKokyiWUTLies05D6B56tHXfxSNF8c=;
 b=KIq0sfxsQblCvIaDjzg8FpPv6MRNPKlokQ6456Zp+swI2mvtFwyQnuruAGTbdL8aq/4IRz3phLp7U01RF+vcvs/jr/1Xkmrp3emeh4P7glSLfEo4oYaxo3m2Osejdpn9fySH5BmXf7EQEHXJpKIIG7HqBGXOMNEkuM/BWU2fKt7LFltam5l3dluOOfRDxSSABsLeNoYDE5kBX7GdN9ZsWw7YON6L4HPufoKSHny+cgVXY1JHQ6imgu1vD1zjb47t7lhDThM0KjSnKxdqZdhTsNkZ7kX3xaYDP0LtC3dcQTALMFfyClr0SvupCZ3vNL6sNC+QWiuRtZI/lRQH70R4sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLD8T4pxHK7ogEKokyiWUTLies05D6B56tHXfxSNF8c=;
 b=poyowfzP56bvtJ1uT04E7oR5IfsruPxu4mjDRgHCItr19D75SwP78C0wT4yAAdkmmqVdyBI3b2WdbN+8DkMMBfRzjH1yhIu77qZ8dRWWoFCPo/JX9x4vQs+FjaJqdrp/6QLvbwvI/hDgnZoVf9rU17dD8ulOXlGwux9Q7ZNcpJEA1J4M8BxUMQ1XpaO7kaiMO32WetFgMIKnZNoPkW+uI3HJLe5fRZ0SdjyUH7EZsXN4BIn25gj6q5OU/3tuJ1fTlyds9C8UuisecldMNkEHn/V1hnU0Jm+0N6Hw1H5hAnofqUqqAxmzTyDN4G5UByuKYrKur4zmXtzXUJZ0yAcyUw==
Received: from MWHPR02CA0001.namprd02.prod.outlook.com (2603:10b6:300:4b::11)
 by SN1PR12MB2479.namprd12.prod.outlook.com (2603:10b6:802:29::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 12:18:16 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:4b:cafe::3a) by MWHPR02CA0001.outlook.office365.com
 (2603:10b6:300:4b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Wed, 2 Jun 2021 12:18:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:18:16 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:18:15 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:18:12 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 14/18] selftest: netdevsim: Add devlink rate nodes test
Date:   Wed, 2 Jun 2021 15:17:27 +0300
Message-ID: <1622636251-29892-15-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aeec2335-f738-48ff-828e-08d925c08003
X-MS-TrafficTypeDiagnostic: SN1PR12MB2479:
X-Microsoft-Antispam-PRVS: <SN1PR12MB24796ED3E0F94F9445AA360CCB3D9@SN1PR12MB2479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TcfmgfkOt3BjOTc5nyLmPV4kyZmd5B0PMm3skMVhZm23jmp4Cr/bO1WtU0TfB/T8/nwaSudt1DQrI1ij78S8C8sUlw0nCvImxjNHk3CpgYhZfEKma7VHst6PKnzTzwaNF9XF1BYT3lJzCcyF8+V/btinUugGW4/GxKSUjxsRCDqaaqyY6SZJ6yAVLg5QTVLf8WIoeOe9gluaNx2uaxsEnO4ceP7yUa1oOO1QMeHKqpSi5qKfq1cY6RZqea3ErHfmrr839o6VsCaWSkP4YJII/bQa8H1kSVgBqcK+I+HG/rFPDxkBIZXKbKnErG7wDTXTRXzhtkjJuAOx5U3Saycb9CvpjR641YiAUbro4sKivfZ3CAnu1pAlzyC6yLZ4EsnWoXKv8QCIbr4Z6YNOrepubLVHgSoGM04kYqv5h4Y2BvyNkNtmbz+xrTZEDACUG/UIo6uj1aGAEfB0pVDa/INtSzrz1Ha5ZMcAfBHEmZBIfOtgjPInWua/fUupniszcvCnNHW+VxsA9E8vEinhqtfVwoSTv1aXN0g9h/eern/Xjdjh3x8ZhFRqVATi97NZwQdPsCWCY6pSZtcxOVna/mzsSWHwBPqKWlLSaPD/QuWyp2SH3PQBrfNGHZ9NNT5Z5Je1b3kLMgHEjhWUeuAzsdKELA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(46966006)(36840700001)(6916009)(70586007)(26005)(54906003)(2906002)(8676002)(82310400003)(70206006)(478600001)(36906005)(2876002)(8936002)(186003)(83380400001)(82740400003)(6666004)(356005)(86362001)(107886003)(36860700001)(7696005)(2616005)(47076005)(5660300002)(36756003)(4326008)(336012)(426003)(7636003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:18:16.0188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aeec2335-f738-48ff-828e-08d925c08003
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2479
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

