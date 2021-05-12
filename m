Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5367A37C0A6
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhELOvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:51:07 -0400
Received: from mail-mw2nam10on2074.outbound.protection.outlook.com ([40.107.94.74]:21856
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231377AbhELOuZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1ic7/6GxzPLvtDrszUXcoF2yIgJvLUwbeI1vzsGHtYdi+RQhVCTPUIisMxD/5vU5bbFNxnCPMEBmYeOAPl9XEsOLUUOy8FiXSnzun/3YvVuYyZmhy4+ejbPFz89mz3EP9/9Vif+V/fue81OyxxWQyhiCk6lA3vzKzl8j4+O8zfHGu/IwIvkFaMne/c1OK1bWcJiECRNQzy/wVAoiTlD2X1i7+8rwcUeUvDfXiJoV2hI7hdZ3+ksPpWEt/P5FAqSlXRSKAOLYFULdW8/P8U8ZbQUwB/jFflUbZaqNY96pmGW/qAegudz6O+/6aq01ZtSl74vxSehh4gWTfZBCw32ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+WSe9UwMbwu8YqblmRLM0HskzdUFtBQWHklUr2ts/Q=;
 b=SyLkfEh2hed/moRS9DGW6+3qlU7Hr3dDLhKJcyYarc4wd2t3aiaTegMf2Xa4x6gL6nykNA3rpzOMGyCetD3eLoaJ6AL3breH6QtxqUA89MFj1TAKfXLvwYYJHuM+PlEhNQKE94jrt5IFJwg30aA9IeKrxBgIzu6FLR+8XrUYlRUqk5II6PTMIwHN//oqdKSpRDH/+ayM4xjqN694m/lEmkU0uqKXz+q/2WthJ+3AjxCUER/4LhVYTrmnB5DUnKOr1tl2YsDCOpEn4VURHP4c4kbLOvfo2n/AVTDm8uFl9PhDmp07J/sTNlGjHoTER78R5KdMz69hRXEsQVKxt5mOYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+WSe9UwMbwu8YqblmRLM0HskzdUFtBQWHklUr2ts/Q=;
 b=YnAhgxo6LqC9Ew+5zyNxbJQxS58dXSgHAyqmJjKB6pdPb0pbpiWCYZQ9GSW8JAruJR/OgS58yFVJXaUKR07sQUVR13Sqk4if0uJDjB/+65A8/M3KfInFf6KibeIkO84rYGdkgwwVEQsEjJR5tCqqCfWImBc2zvSwghA9Kz5yR4/tRTX0g6pv5shmB7pVWWqyjA/PvWrVdyJN6r9uGQJ27lLo8tjFR/2o5ErxG07Wq8InSgU4mwwmOjVG1N0P4Hw2GCzszf6nTeBZZ8/2kl/nyyOawFraihrVB28wJFZ4p5yh51I/uToro5+6wqE2CqGzRJc7CpdKY60epkPE6C6CJw==
Received: from BN6PR22CA0072.namprd22.prod.outlook.com (2603:10b6:404:ca::34)
 by DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 12 May
 2021 14:49:15 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:ca:cafe::f1) by BN6PR22CA0072.outlook.office365.com
 (2603:10b6:404:ca::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 14:49:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:15 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:14 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:12 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 08/18] selftest: netdevsim: Add devlink rate test
Date:   Wed, 12 May 2021 17:48:37 +0300
Message-ID: <1620830927-11828-9-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb76bf38-79fa-4489-3329-08d915551d3c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4337:
X-Microsoft-Antispam-PRVS: <DM6PR12MB433754F8ADF3BB4552034501CB529@DM6PR12MB4337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wqUg99Yr4Yeaz4aWC1FNbL3eIRmSrZqrEcJdboh0ji5W/uSayGX+2qjzcbV8kUKQMuFQL1xVK/rJCkRRr7JzDAiPxFvTcyT7munPH2S/pF7bSHbjiVWfXU06a+0M+284n/rerwh/KGbTinBwo1Y+nU47djBjCc36hYy+xbTUnkBYokZFGmR/UJvfSIzyH4rGguhS9mQc5o1MMJet1yOFP+pXsITbW9hBTAg5ISixngwILvz27bz5aTnqFQiP2XvRaLXJMbotq6IJLx9cav+beAN1gQwy42kB7w9rSEe7BSbRGh6UQqGahTqYWvG0dnbn0HfkY5ugRLFY0CDhIdnNvF73DkryKxj+gH0WZdM/DQYeV1XdWQPgH5EiG6w4+M327UOgVxIKKheZwjZ5W3MJamRT3FLNlFftzjoksad9CFDikWFjtcjNz5yjoCQG2rGWArQksZiPSe4168bFqSXZCbkItSexWjTww9AM+DsN+emvkc1sZ3VTXV7tqZnpue1eiV2GfyYTvb/bdJn2nWVQwxvVZq7tygcy7aFiZnPEFWlxwT05l+GHH3+aMMK/ME7soM04C8hJSkdsrH1YN3FrJO9wUwQEC4mBfgCZW+iDmd8+FIvOFA4WZtLLRBfDXUgZE8sDM+o8+DCMo2JGxzBnqQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(36840700001)(46966006)(36860700001)(478600001)(6666004)(356005)(5660300002)(336012)(26005)(86362001)(4326008)(83380400001)(36756003)(8676002)(6916009)(54906003)(2616005)(8936002)(186003)(2876002)(7636003)(107886003)(2906002)(82740400003)(36906005)(7696005)(70206006)(70586007)(47076005)(316002)(426003)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:15.4704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb76bf38-79fa-4489-3329-08d915551d3c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
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

Notes:
    v1->v2:
    - s/func/function in devlink command

 .../selftests/drivers/net/netdevsim/devlink.sh     | 25 +++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 40909c2..c654be0 100755
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
+	cmd_jq "devlink port function rate show -j" \
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

