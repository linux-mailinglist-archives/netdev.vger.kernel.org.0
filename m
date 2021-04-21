Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE90366F79
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244146AbhDUPyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:08 -0400
Received: from mail-dm3nam07on2069.outbound.protection.outlook.com ([40.107.95.69]:54913
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244134AbhDUPyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:54:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxGqmakFfTAcbbBJvt6tZHVXYu9R3pNRqNUlcwBh2+EKGO6xR/02cAn3ukYCY/qgnRiaWwRBd/TEh1uXeI8hXtooaoCtA25gqnsVVHq+uf8rZWrlXiuMqwGRP5TlDWuRzcqYK6bx5ad2eJA7e77lt63Y6B7AUPAt/sUWS+fNZUQSQYnIUxJImlKg0wLbGKXDHxlpZZk1LjzKRUOYvF/ExikqBCiJSZ/dIb4lmQIRg7DH5IVyydmtlkZzaTF2jZew3xo97hrOQdKrV3BsrP7t5EwZYHITXjGhJnGhmQ4gz5oACVPaIVDd2KGvnAoYYImE7uzbZEv7wyOFA0/Nj7v9bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=866KIhVVVGAYUdDcI2Q2dthtOXmCKME3XEBqri+730Q=;
 b=FsHjQlKOykrwn+UnSC4VejNJpM4pH/YEod2v++lVw5beM3ZBhJMmnbH3dUwxJMNVHkYHLxvxd9jitXj9ffT0LpwqiEj7ETLBvMZnabw/ttARx0VA5B54OuY9icBh7E9HlbTd7ABo96S3UKiGMOLcc1MRgeyIi1JD2F2sTtw/bb4M6dg/ePKm8h2bGJ4DNgHCKFQkCARwY2hYFbyydgwqJf5U6sYJDH+QmPpF1ToNeffWcfhi83X4CJgF5GAwmzJThE83LAcL4FKrXISnAP+hpnWVWyCxg6FkoAV9hU5NbKnDgm0z1Lf6JFFWSR2LgSS/m9K+Wrxt9tl6tPt+Uh9OSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=866KIhVVVGAYUdDcI2Q2dthtOXmCKME3XEBqri+730Q=;
 b=li1OIifZP/Q9x0hEQckyESAPJvBQSfdHRug5FkRgYGWTWpD/3fkKcYfOp+BJL7zLptaylR/vLs0/Px3DrX3LL1QHKK9+MGFns/g7ayA9s3rHD0pq8Z7EjZzZsG470fTU+g2kjzrJ0p6cVlKH8PjY0xpYVdFTgw7SBEbOIUImd3yjRuNqRspN/zVm4iXzRuTilWDYks42a/b9yiSA47V3b+fLhRp//CFg00jTLlpv77jwvbn3ZOP5woSp0IpdVbjrBW6usNz0rbDHrzvAY3Bi6v/qEjOirF5nWMs/U5oxyPVTN/7kgzhMtt0ch05eA7udm8orNDUOXFKW4LkrO8cIIQ==
Received: from BN6PR2001CA0004.namprd20.prod.outlook.com
 (2603:10b6:404:b4::14) by MN2PR12MB3965.namprd12.prod.outlook.com
 (2603:10b6:208:168::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Wed, 21 Apr
 2021 15:53:29 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::7) by BN6PR2001CA0004.outlook.office365.com
 (2603:10b6:404:b4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:29 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:53:28 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:26 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 08/18] selftest: netdevsim: Add devlink rate test
Date:   Wed, 21 Apr 2021 18:52:55 +0300
Message-ID: <1619020385-20220-9-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be928286-1e2e-4d2d-0a54-08d904dd9b85
X-MS-TrafficTypeDiagnostic: MN2PR12MB3965:
X-Microsoft-Antispam-PRVS: <MN2PR12MB39654E66A24BA75C9DEDD247CB479@MN2PR12MB3965.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:612;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hJy2vYfzhjucYIke7fJHRrp/RyruM4ZIpr/fZgGAAvEcIPeRrPPB9t48eg7Ufmf92dXO60dsMC7qp2vm1h+pBEpSmJGjKcTIOeOIboYfxyqX/n2IuErMOH2y0ndGgL/cv3GhbwgrPkro+wt9ObNTd9LvW7YctCLMj5hamnh5wKHuWdDIqdmu0NvQx+k/FfmcwZr2Tx5kPlVIqTk//qmJlS9AWkZ6fUGByTOfrFdXhTKw6gLUQkqpCLuEUJLDgTdkjkFRcHcVrXwogOWl6V5FP10uEEPtyjFq3gC2tj3CD/bF0+JekVHfD2Ys7hQHg9pv4Wdeu5A7xmEILWhWipBEViSYxscblFn/bLX1BlvW0U0aaedleUAZ2uR9/2iPtjZTspZ9/9sWGVLniDk3NBFden1M0cNbkyizmpAhVeuUWIpewE0YJwj8cSOvr5JPwBXkqa0TvBulmCOuQVT4riUVT4ZFr34KETEYoNnlFQshZhV5K2DbKLlkozatS3Zpg1jLA2iWuEMiDg/u9fO/EOW9j7ETjCreZgaVXMV7qVyXtcZaqamFRjdt1QHNA6s7VEW4iODZWbvJu2wsD8JVeITKsUABdPdYiZLndDe1Tdmcqljw2VwDckx1w6+bUQ+D40h4dbvM9mXuIJNszQCFIq/+rg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(346002)(396003)(36840700001)(46966006)(8676002)(186003)(83380400001)(47076005)(336012)(7696005)(82310400003)(36756003)(356005)(36860700001)(70206006)(8936002)(107886003)(5660300002)(478600001)(6666004)(82740400003)(2906002)(86362001)(426003)(2876002)(70586007)(316002)(36906005)(6916009)(2616005)(54906003)(4326008)(7636003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:29.1247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be928286-1e2e-4d2d-0a54-08d904dd9b85
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3965
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Test verifies that all netdevsim VF ports have rate leaf object created
by default.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../selftests/drivers/net/netdevsim/devlink.sh     | 25 +++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 40909c2..b8b0990 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -5,12 +5,13 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="fw_flash_test params_test regions_test reload_test \
 	   netns_reload_test resource_test dev_info_test \
-	   empty_reporter_test dummy_reporter_test"
+	   empty_reporter_test dummy_reporter_test rate_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
 BUS_ADDR=10
 PORT_COUNT=4
+VF_COUNT=4
 DEV_NAME=netdevsim$BUS_ADDR
 SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV_NAME/net/
 DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV_NAME/
@@ -507,6 +508,28 @@ dummy_reporter_test()
 	log_test "dummy reporter test"
 }
 
+rate_leafs_get()
+{
+	local handle=$1
+
+	cmd_jq "devlink port func rate show -j" \
+	       '.[] | to_entries | .[] | select(.value.type == "leaf") | .key | select(contains("'$handle'"))'
+}
+
+rate_test()
+{
+	RET=0
+
+	echo $VF_COUNT > /sys/bus/netdevsim/devices/$DEV_NAME/sriov_numvfs
+	devlink dev eswitch set $DL_HANDLE mode switchdev
+	local leafs=`rate_leafs_get $DL_HANDLE`
+	local num_leafs=`echo $leafs | wc -w`
+	[ "$num_leafs" == "$VF_COUNT" ]
+	check_err $? "Expected $VF_COUNT rate leafs but got $num_leafs"
+
+	log_test "rate test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-- 
1.8.3.1

