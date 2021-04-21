Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA44C366F7F
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244179AbhDUPyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:37 -0400
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:17462
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244206AbhDUPyU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:54:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IctnVNJVEJIUt9IBdmSum9Dq1wd+qrAsMKCKsd6auxBJR4StbdzX/2v7BPGXlXYNTqG/O7uF1BnKpriyg/+tnxshfZ/e7Fo/ee9S1w0OMcVR2gBBbl1pKKJw1PJRtM2Jfn+csw/A2iKsn4wLgOPjMkoJbZgGhKtNY1tDwmQx+5Ma2jLzTsXMzXa/JRIR6ZIrHQe8a0MasbLkuO8lb3qxSEEYtPrrJohln0MvHj3cTEw7SD8XStKjGiGNgpU0sFL5/RkhTMgANM9ox4CTHV1xE3k1a2WqgGWs22jx82cBJmqEPqY633HXinRB7M+GWzJshEWPCG+AYez+3WWa3UqVyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=838VzIoMdMnnBo6U2RbgamxAH1bw27AhKWkJWZtx57o=;
 b=g6o7HWcyK2B3xtzO0dr7EV3cHmuon3HvKo39vJ1ioDt2rvLSoBH7pYIK0meYqgjvDcVJTC+PQJiucpPjv/M8jhY9/3G9RDtf5YT8ZTMzgVRPYp7e4G3JAOm7CixDSFb7PkA4aymKIxldeSwuAO0Gw5CPJWtHLk9/jnGntk17ZNjHx3ZBwVUObvCD0rrzUyc5CGHQkY46il5r4/r+HaFB/L0uj/Tre0Vunbq3MEuHRgFgyeyk0COtLHhIHYa98k2hP06WtLjosIA9t6ohzmxFE+LqxFYfLcYXHD031FbnxBfM6xdkOyZCZGgrmKyZTcqM7pXWOMhjp90DhJ6ulERv1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=838VzIoMdMnnBo6U2RbgamxAH1bw27AhKWkJWZtx57o=;
 b=lDMoEVTIMnJre7WC813aMkAewDHaWPxuj30JyL2o4MsG0ERJyq2RT/LPNYrIAnIH5bWJXGf605A5HyI91++RthrH9Y4hrfXJJROP73Sa14hwqBRqDYFDTuv4yAtzsGyODMELMnu+4K8DsPy4Ehw2I9BpezVloh10hYXNwqDCb3KM6MLHTEL8QTUiyj66InT9xeGvQfvWNMNaI+j0gDeUeWLSTnggpj++z9OUyeQA6d2HDbf8ij9NmP9iU8FquJJ4vesCelvmeWTIXK4p6sZL8TQ5NU75QqB9IjszoS1gOCO/EjJTktNz2ocNocOa/Hm2A/kx204rluW1Qfr6tM4ZWA==
Received: from BN6PR14CA0025.namprd14.prod.outlook.com (2603:10b6:404:13f::11)
 by BN6PR1201MB0164.namprd12.prod.outlook.com (2603:10b6:405:4e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 15:53:44 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13f:cafe::a3) by BN6PR14CA0025.outlook.office365.com
 (2603:10b6:404:13f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:44 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:53:43 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:40 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 14/18] selftest: netdevsim: Add devlink rate nodes test
Date:   Wed, 21 Apr 2021 18:53:01 +0300
Message-ID: <1619020385-20220-15-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adcc37d7-0141-4304-007d-08d904dda4ad
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0164:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0164D38AE9465FF64730D3C5CB479@BN6PR1201MB0164.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: avoJJfJPY5e2ZvL/hsGodJDIvitJhNeelVom5ZdsNIiEeRo2ZHRO8DD/j8yOURVkelPM6lf7g6z/SCzFTHIWPqcgTXZDqHKDN1D8XeejUCPM1c5KGCGDhfTiSGJnRIKeOvHXykpfaO2hK+b61QOWeDgQZLI+TB/Ht4LBOIBhzwkbcn5bFzzU2c9CFLVvjCtCbCz7FpR6YY41XoIDUM3vUifVbz+6r7zvgDnkAWGd/PbDezseImgPJpc1ASUT935N6KF7mouVfoMFx43AGgqeTDRBi2rprHjGXL9WlXxSpj2eUMMmtmvrbE1JOPWhQXWLEpgxfnmh/VefPouLjIAszMyAh7E6Bat3jBjFqdU9dZPhaK89xeAGVo90X92cwFA0nBuE+LxPv3SjyS7j4727Uy2r0GOPx0d5kOryzpG12/z+/8QNroxS9q8jloOyLBrJSWo1C4ELf4EtAc+TGaTPeOtKRU83/RNsMZNFi6E0VTwH+chGECkjwzCFF975AfONkh7JwjM/LoYZulP5nSpHChnllBQkBEAl3LjTBm5V6sVWT4OuGMGwiLBnLl4PWW69IFAwaimj/GGp8j0twA7JKQSdzIvqzEiRs8x9kCziSIebs08ukKuJKaPDRMnmS6qJIZ3beD1O2p4L4tDP21Qvcw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(46966006)(36840700001)(54906003)(4326008)(6916009)(70206006)(70586007)(82740400003)(2906002)(8936002)(426003)(36860700001)(8676002)(47076005)(82310400003)(36756003)(478600001)(186003)(356005)(7696005)(26005)(86362001)(36906005)(336012)(2876002)(6666004)(5660300002)(2616005)(83380400001)(316002)(107886003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:44.4252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adcc37d7-0141-4304-007d-08d904dda4ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0164
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
 .../selftests/drivers/net/netdevsim/devlink.sh     | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index c4be343..7c6ecf2 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -516,6 +516,14 @@ rate_leafs_get()
 	       '.[] | to_entries | .[] | select(.value.type == "leaf") | .key | select(contains("'$handle'"))'
 }
 
+rate_nodes_get()
+{
+	local handle=$1
+
+	cmd_jq "devlink port func rate show -j" \
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
+	devlink port func rate add $handle
+}
+
+rate_node_del()
+{
+	local handle=$1
+
+	devlink port func rate del $handle
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

