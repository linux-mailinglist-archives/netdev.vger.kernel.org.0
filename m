Return-Path: <netdev+bounces-9988-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13D4072B971
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:59:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD2CE2810E4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B0C5DF4C;
	Mon, 12 Jun 2023 07:59:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DDEF9C0
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:59:34 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2041.outbound.protection.outlook.com [40.107.100.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EC135A3;
	Mon, 12 Jun 2023 00:59:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VemJk0gTP96jJJnVeuvXtNzJ3JpyltKw9tmfYwCaYVZG+8G0d7AFxJp9YVSaQtBm3IF+De9VoUwfryKSeMF41Dq0d13TcOsOI3D/M9V11TXZ0q+yvyCeYHpFCv5yAQQnqSbR8mZNfMrpFcO0oL1bpAW44Q3OQXXxkdy4sCA4j8RyceqElIZB2nCdqj45v917kkYB7Piw6+A3FZDeWK37cJHere1YP3npkk3SYBEEll6oQaRfIbJUUG7BDuu6DpzM0E01UetPmVU6gn59HIzpdIzId6X55S3zKVo08U2l55R4T6LtV2aR7btZypDPSmVV+FzLQcXVe3lFzjEag/9fDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/eFnYsmFXsJJtue8Xsv41zofs8NClzVj7xXwE906ibI=;
 b=TV9YlMneWnyWMbb+3hN4EUW8EBBfMebcvN2gK0mS0fWjm42LwUgyLdsxSVmOEUDHSbt1uhuqCUsPLfeM4m97TDyweECOWmBIqSrb5LwllDvcd0c32miwfKZcLxVFFO5aVifjC3KsDAIgLaBzviZhpNoC2IeTDFBiap3/8sTWlIvJx019jKu6wDdGLdOY/Lglxva6n4KeLYcs/qZZeaIh7c+kof5m8MoIZRlFDwbbsJydEQqQqKGhwjOy2wTRWZGBoEakYQ4dImY4RoDyauKGTb7/SM7DJa7u9kLAdHw4xq4+X9T3XZvkdJk9KM4++maXqEzscykl9m5TmEV7cBjtZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/eFnYsmFXsJJtue8Xsv41zofs8NClzVj7xXwE906ibI=;
 b=s7airmTqB1iwI3NwFokLGGuwqEHh5gIOX2UfuCv7x5emJalNnXrk7bBA/z3oI9WGcP4AqrWsx9K7QB7MGq3xcFmrZUI8b/2Wq0W7fyEGAzanGvCahqD+OGgRS/tSt7zpSt97hz8axem6h1qLzqyrY3Le7+7Hh4Ew5x55ZBTMBhC6vIVq4mKzNJeT8j6Az/HinHzig+ls6t73kFe4R3T3WC+Dm06Am9zgPjsaD8sgimsWpeH85BhZw08wirkQHOcy7oobVLV+qs8abTabxstbn29ueaIuC0Hr57RniSqCI+ivQ9g/qdhGqz6NqZOykUP3in7GCbYYUMWHOaS+gyihEg==
Received: from DS7PR03CA0100.namprd03.prod.outlook.com (2603:10b6:5:3b7::15)
 by DS0PR12MB7678.namprd12.prod.outlook.com (2603:10b6:8:135::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 07:57:52 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:5:3b7:cafe::34) by DS7PR03CA0100.outlook.office365.com
 (2603:10b6:5:3b7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 07:57:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 07:57:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 00:57:37 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 12 Jun
 2023 00:57:37 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 12 Jun
 2023 00:57:34 -0700
From: Vlad Buslov <vladbu@nvidia.com>
To: <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<shuah@kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>
CC: <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<marcelo.leitner@gmail.com>, <shaozhengchao@huawei.com>,
	<victor@mojatatu.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net 2/4] selftests/tc-testing: Fix Error: failed to find target LOG
Date: Mon, 12 Jun 2023 09:57:10 +0200
Message-ID: <20230612075712.2861848-3-vladbu@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|DS0PR12MB7678:EE_
X-MS-Office365-Filtering-Correlation-Id: c9d0eb98-d94a-4778-d0ed-08db6b1ab92c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RnorVFn7Sw+7fS2Djo4KrBxNUJ7iXZFTG41HOeGa34UZAv3B7WWtGE/aJJ3OkdcXgtXCMQVMJlAqs7nSDkRiGxuNXGu5HYDNtNpz/ODnNYX20tmZP5WdGXSYjWKzqmJuWQymQGvA2VWRdYKSdh9/kG+NjM9QahDjoluXAUhhKvB7SZyc7OQM9hfYZRJff/7PQN3Vjznf79IEh9MDd59G3UYmoXpm1zNFlvwP8uUR5Sx9bUQ7djw9T6YUw4WQtxg0Mx7qknIOLRy1RWiYhVJyH9df9/BtpdvHgoCahkhKh1bbs5skTn4sqzSZpodU2+b0/8e5NBmPf60Wz8lMLK4hqHGGCo0CMIYjnSngri+4VriaLT0BYMjdhGsQGkBW+KuEuQV3ahplZfMQ8P4DgB1k7W9SRwRaIgKze7O4HdjSOJ4it3PVzTLExVkpR05mAyQL354XP9nXLk+fIACHdAifzNSdPvOTQmvgrqXkQXfO1XmV5ca8emGJ0CxlNXtABhCZbZCbiGm+BZEe99Xi+DVYJ3tUXRCDqINeRFmC2UjT5KA45glcfEMS7PQnmvS/npDsY5xwaNu1XE4dqXSz59Bkj093IIuspnKI6jPXEq61q9ODmE2Es4Hu5FQcMkSELqlxdgYfw6uGQY7LjeNYg18t+awHc3DB+bl/kZirpshhUtdLkOGBERu02YrwWmJM0px1ShdGCggx0OVUSZDV6gNPGd5BqxouQso1Xu/8/kv9sZJXuU4h7MGuv29ZkmFm/uiOUQZekC1eMI21xBxswGzJmg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199021)(36840700001)(46966006)(40470700004)(426003)(336012)(2616005)(47076005)(83380400001)(36860700001)(82740400003)(356005)(7636003)(40480700001)(86362001)(82310400005)(36756003)(40460700003)(478600001)(110136005)(54906003)(4326008)(7696005)(6666004)(8936002)(8676002)(2906002)(5660300002)(7416002)(70206006)(70586007)(41300700001)(316002)(186003)(107886003)(1076003)(26005)(37363002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 07:57:52.1694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d0eb98-d94a-4778-d0ed-08db6b1ab92c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7678
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add missing netfilter config dependency.

Fixes following example error when running tests via tdc.sh for all XT
tests:

 # $ sudo ./tdc.py -d eth2 -e 2029
 # Test 2029: Add xt action with log-prefix
 # exit: 255
 # exit: 0
 #  failed to find target LOG
 #
 # bad action parsing
 # parse_action: bad value (7:xt)!
 # Illegal "action"
 #
 # -----> teardown stage *** Could not execute: "$TC actions flush action xt"
 #
 # -----> teardown stage *** Error message: "Error: Cannot flush unknown TC action.
 # We have an error flushing
 # "
 # returncode 1; expected [0]
 #
 # -----> teardown stage *** Aborting test run.
 #
 # <_io.BufferedReader name=3> *** stdout ***
 #
 # <_io.BufferedReader name=5> *** stderr ***
 # "-----> teardown stage" did not complete successfully
 # Exception <class '__main__.PluginMgrTestFail'> ('teardown', ' failed to find target LOG\n\nbad action parsing\nparse_action: bad value (7:xt)!\nIllegal "action"\n', '"-----> teardown stage" did not complete successfully') (caught in test_runner, running test 2 2029 Add xt action with log-prefix stage teardown)
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
 #  failed to find target LOG
 #
 # bad action parsing
 # parse_action: bad value (7:xt)!
 # Illegal "action"
 #
 # ---------------
 #
 # All test results:
 #
 # 1..1
 # ok 1 2029 - Add xt action with log-prefix # skipped - "-----> teardown stage" did not complete successfully

Fixes: 910d504bc187 ("selftests/tc-testings: add selftests for xt action")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 tools/testing/selftests/tc-testing/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index 4638c63a339f..aec4de8bea78 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -6,6 +6,7 @@ CONFIG_NF_CONNTRACK_MARK=y
 CONFIG_NF_CONNTRACK_ZONES=y
 CONFIG_NF_CONNTRACK_LABELS=y
 CONFIG_NF_NAT=m
+CONFIG_NETFILTER_XT_TARGET_LOG=m
 
 CONFIG_NET_SCHED=y
 
-- 
2.39.2


