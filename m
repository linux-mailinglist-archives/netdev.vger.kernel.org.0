Return-Path: <netdev+bounces-9986-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E7D72B962
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:58:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 149FF280C91
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E45DF4A;
	Mon, 12 Jun 2023 07:58:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66226BE6A
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:58:42 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20616.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::616])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A12D1708;
	Mon, 12 Jun 2023 00:58:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOToqRxKhZ9VA6yevfrIz8Asujos22rWSpsyGIFVyXGzDJG3wIKDnLK+pzGBZqSFf+LJBvR4YQ4wyAbDbg3LFU4smcUgeIR1AFdFRfnklWos2Orkjd7T0eOGVPtQQIl5FOfJJzeQje9U6nw8bFeOz+WjVcSARpCNCLeH7n9QZm/4U/Ov/owZkMM5zTvhMrjH6VkZUrezBp1NT1AC/0H2ympmr4Oh445cWxkNrAC73EKn7zf03Ti8jFZPLvsXoUR0D9I5FpUS7NYYPtxhgjqXdb91FquYKCPRh7aJkXMrPnF5q3WUSLjBcelE1f/z4eyjxEWvvrYMWahb5c4dAxP3/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkFF8XacPy+XwzRG8rWFGWys4y0Z/lnLqYZzx1+FS4k=;
 b=H7EpM3jJd6Vt3/ZD1xeVg3aLqJpXAQK7BHlk0XDlQQ7S4YV/r/lj/85+0M/LXvkML40uAJvoj8p13UlIVkVg50YOM7+pCm+7wbrToTIQ3LUAsLxPwa+VQMx9cUF9kchWWUO+lyz8TfPhRbEhRuXasC7CPoGW2ua0Mf1BkloHRq6I2d0LfYCIaS13M0nM1KAxBJR+dmhekDaCX76DnuUtP2FI+OGH0J9W2P//XVsZLPaoYeJ7A5FoowNIxbu5aDtR8+RWWYfC4ltmUvgruXVV0GUNZN3vmnzBMkXfi2wPVKGvzxElyvjptMch6fdhuCsRRgFBCwDBVsm4KUw+ikhTyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qkFF8XacPy+XwzRG8rWFGWys4y0Z/lnLqYZzx1+FS4k=;
 b=eYdGmFIlK8kNXbZlWUpMY7wFuIZ5ztAyb2NG9HQSs9jzI/jDPSOPr4X5mlDv5kX7Ohzu+GYcoSrmp/QdubfMhLwsIReYRFsPD1NeBIQf6c5dH8jUUca0OTrabO8fYviFmfNkoVSpVHTIlnYku+p6B7iT/Wy2xSsSpGoJl4rZ5CqIUPuBwcVGBpRW55bX1lyVpZ5QAe7REnNrBv1mLstHob7lVGjKIVCotysY6SAubpaiohH3b8x2SCMUhsgSsy1OqVeFYbHndM7KbMG7Hag8thhj9or5Xh3TUQY5YzFb36PvlHkbC+PFYpntK4ZhObMGWH2/+EQZELXuSD+oZSIofQ==
Received: from DS7PR03CA0080.namprd03.prod.outlook.com (2603:10b6:5:3bb::25)
 by IA1PR12MB7734.namprd12.prod.outlook.com (2603:10b6:208:422::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 07:57:43 +0000
Received: from CY4PEPF0000EE3C.namprd03.prod.outlook.com
 (2603:10b6:5:3bb:cafe::bf) by DS7PR03CA0080.outlook.office365.com
 (2603:10b6:5:3bb::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 07:57:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE3C.mail.protection.outlook.com (10.167.242.16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 07:57:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 00:57:34 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 12 Jun
 2023 00:57:33 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 12 Jun
 2023 00:57:30 -0700
From: Vlad Buslov <vladbu@nvidia.com>
To: <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<shuah@kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>
CC: <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<marcelo.leitner@gmail.com>, <shaozhengchao@huawei.com>,
	<victor@mojatatu.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net 1/4] selftests/tc-testing: Fix Error: Specified qdisc kind is unknown.
Date: Mon, 12 Jun 2023 09:57:09 +0200
Message-ID: <20230612075712.2861848-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230612075712.2861848-1-vladbu@nvidia.com>
References: <20230612075712.2861848-1-vladbu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3C:EE_|IA1PR12MB7734:EE_
X-MS-Office365-Filtering-Correlation-Id: 80aca579-ba3a-43d8-aef5-08db6b1ab3ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	o0n7xq7sfCE2Hj2zd3JSeF5shl7xt8Z+cXPKfJV9TofRGM3r6UmDZd/8g0bF4muCCtApNpRsgh0mL3WdR68z3FH47bQ3DxOL+bVAxzr7dsokITKHtxyTJLU1x9NnUF2A8IpQFbllEC7uXNdwGVSG84IK/uIdFEN5MgzUGWtxxt5HanDZae8lCGO7tyI3x3eGw9AICEHtFRwhQMmT0e/vYSIzQmbHFWEJFK1gydzxMCd6xdwwkWrjqi4u4cPeR8rmv7ygbO7DWPOuKFkUZlz+4Rb5KVE0bQ6Zl3JczjUJytZpDjK8f72prmrxrR1bXCYEj4YWZBZl6UpuGHSrfe0Ns0QmqQmk/P20p7R6Dqttkgcyf4ltyvZOKC0wjJPL7mQw0tMD/jEEv8rZ4gEOpr2vJ4Zzh7dU5vZfriAMi6UiurbfiDwnOdCQt/ST41gtZXmj7sP3l8AawzbKFhEFm7yynWPOAZXXQSxoDkt6pnq6ktp6jmex4wztajHBQP4sS0zo4Mifggl+EhT/Ot3sYJ8XNUh2ayDLDBNYOFoe0VNuTywpFpZIPZPANdR5VuAsGDA71IbJEqAuO4fkS0A5WrUQintfr9yL8BqwEm1Bjw8cve2+Okrl3dmU4/21+QEjyNTSnLDgD42hoz76BY1XnTkq6zHHKox8777+uMpSX+BOharJM9G37VV530s0/TeKm0CYlUPjeq6XfL/HPLlg2+Yroc7jr/bCq1goWvNo16Ieq+MTZpOyAeBaMhcrH/zTwPgC
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(40460700003)(82310400005)(107886003)(1076003)(40480700001)(26005)(5660300002)(426003)(41300700001)(186003)(36756003)(36860700001)(7416002)(47076005)(336012)(316002)(70206006)(70586007)(8936002)(6666004)(478600001)(83380400001)(2616005)(54906003)(82740400003)(8676002)(110136005)(86362001)(2906002)(7636003)(7696005)(4326008)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 07:57:43.0328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80aca579-ba3a-43d8-aef5-08db6b1ab3ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7734
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

All TEQL tests assume that sch_teql module is loaded. Load module in tdc.sh
before running qdisc tests.

Fixes following example error when running tests via tdc.sh for all TEQL
tests:

 # $ sudo ./tdc.py -d eth2 -e 84a0
 #  -- ns/SubPlugin.__init__
 # Test 84a0: Create TEQL with default setting
 # exit: 2
 # exit: 0
 # Error: Specified qdisc kind is unknown.
 #
 # -----> teardown stage *** Could not execute: "$TC qdisc del dev $DUMMY handle 1: root"
 #
 # -----> teardown stage *** Error message: "Error: Invalid handle.
 # "
 # returncode 2; expected [0]
 #
 # -----> teardown stage *** Aborting test run.
 #
 # <_io.BufferedReader name=3> *** stdout ***
 #
 # <_io.BufferedReader name=5> *** stderr ***
 # "-----> teardown stage" did not complete successfully
 # Exception <class '__main__.PluginMgrTestFail'> ('teardown', 'Error: Specified qdisc kind is unknown.\n', '"-----> teardown stage" did not complete successfully') (caught in test_runner, running test 2 84a0 Create TEQL with default setting stage teardown)
 # ---------------
 # traceback
 #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", line 495, in test_runner
 #     res = run_one_test(pm, args, index, tidx)
 #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", line 434, in run_one_test
 #     prepare_env(args, pm, 'teardown', '-----> teardown stage', tidx['teardown'], procout)
 #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", line 245, in prepare_env
 #     raise PluginMgrTestFail(
 # ---------------
 # accumulated output for this test:
 # Error: Specified qdisc kind is unknown.
 #
 # ---------------
 #
 # All test results:
 #
 # 1..1
 # ok 1 84a0 - Create TEQL with default setting # skipped - "-----> teardown stage" did not complete successfully

Fixes: cc62fbe114c9 ("selftests/tc-testing: add selftests for teql qdisc")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 tools/testing/selftests/tc-testing/tdc.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/tc-testing/tdc.sh b/tools/testing/selftests/tc-testing/tdc.sh
index afb0cd86fa3d..eb357bd7923c 100755
--- a/tools/testing/selftests/tc-testing/tdc.sh
+++ b/tools/testing/selftests/tc-testing/tdc.sh
@@ -2,5 +2,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
 modprobe netdevsim
+modprobe sch_teql
 ./tdc.py -c actions --nobuildebpf
 ./tdc.py -c qdisc
-- 
2.39.2


