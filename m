Return-Path: <netdev+bounces-9990-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D093C72B974
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:00:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9967C280982
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479BCF9CF;
	Mon, 12 Jun 2023 07:59:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BBCDF4C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:59:40 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20624.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::624])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A8C1FE9;
	Mon, 12 Jun 2023 00:59:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+GWg+uJS3GB95G+qKv36IoapCOa0hPnG34hbILj3ckaVRckL8K0PCTtK8zr9okLwvZIQs/n15miT7Xh/QAtW4570yDHP0TwcoiUJ/2LCQFJiI/SKJpsXcNbGILtgdaqmOA3hFendn2gsEW0vKHnene3Wuzqf3/0zxcJDkwHv9VVVqsUgvxwemZwmA+YCw5CIAlLODNyHrXp43NG6I+vsBql3dj3ygXTgj/ONpLkd76Ypikvwb7ZNii2WjN6NO/TGwHUtXhUSpatj5YwaTuQQ/uIf/6afsbz1M/E7Cm3iwWoZs7dAry9/cQRZODuKPvQSzD6eXZgGINtKT9PpYXsOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0XaMJrk6apzB0YG2p7ST23WWYbGfcX4RJv5qRBWnWFU=;
 b=exNSoMgiqFuscl6+xbw8zfU4gpCxoqgovC6OeSZi5S8biSjEXIsy87YZXl5xfoffZg6lu6iiRSU6htzrr1BEMKLFZ/C0RuXytN6ToYbeI1wmvWOXyAbfppgZklP1bsXcMkvDYEF9I6FZgrQyvJQ2P9p6EF1uQbtkmSntmqG8vOaMjLl2m3NyVE7VsfgcRYwY9WZLdQFKdhU0qUxQQ+lSHX8G+VKBy34SRsYdoEQlclByX5C0rUgxuc60dNCWgkSc3TodZwdNwL+UGiQ8mjkZQ/5S5s4zf8k4gBM2I7siI9LUjfjIbwt1gfiXyBHoVY88oRphLJaJDiOovkrLL9+rRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XaMJrk6apzB0YG2p7ST23WWYbGfcX4RJv5qRBWnWFU=;
 b=Hg7tDzaT57nzJAiCgCHOuM2Y5HqPek/0j9T4CKKHIHFBV1rHvHTPPSuPQ4nUwg9aBr9e8aYD7x+RjUMMUH5DtkRcAqWMw+fI28juwNqlP5wXcnarVy53HIz6RM79saLhwOBFN/Xeioc2YUHWJPLvtcfDQPpPu5WkNijuEMV4EhD7LVVGFabT7d3jKQ4I5JVO1M2pLzBDH7eA4XO9TauWSegE2y5ZJhAOLBsiL5NEtvGO4Z9gwZtNa7LerHlj85tm6C3u47q8s8m8EEYvx3fzEmOObqWB3wWtGNzbI6eHPg+W8tdRDIwBEzkIxCupdN96VAyZlDImbE6dOc6KKWwEIw==
Received: from MW4PR04CA0155.namprd04.prod.outlook.com (2603:10b6:303:85::10)
 by DM4PR12MB5915.namprd12.prod.outlook.com (2603:10b6:8:68::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 07:57:56 +0000
Received: from CO1PEPF000044F1.namprd05.prod.outlook.com
 (2603:10b6:303:85:cafe::3b) by MW4PR04CA0155.outlook.office365.com
 (2603:10b6:303:85::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 07:57:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F1.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 07:57:55 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 00:57:41 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 12 Jun
 2023 00:57:41 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 12 Jun
 2023 00:57:38 -0700
From: Vlad Buslov <vladbu@nvidia.com>
To: <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<shuah@kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>
CC: <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<marcelo.leitner@gmail.com>, <shaozhengchao@huawei.com>,
	<victor@mojatatu.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net 3/4] selftests/tc-testing: Fix SFB db test
Date: Mon, 12 Jun 2023 09:57:11 +0200
Message-ID: <20230612075712.2861848-4-vladbu@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F1:EE_|DM4PR12MB5915:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d0995ce-b83e-45cc-f7ad-08db6b1abb52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MQhhx6laALgDGBcmLYr8BFTCpBURe/LZ5HdKRIacZOHJCbRB1HYIDkL6BvRbyFd6jLe8gXmKPLa+IhxefkaHpZSdptUovyMcFnAD7/2h5c4/8ZTm9K4nbFoz9vxK2KAGjEGGKv7BdQRDDCD0duPzx8SzNLr48/lsRg3hJCEcj+WEhhIUP1zFrhnEvTPsL1apYUVs6bYkHpWJ8jQYrgr8aJ/3ISgY+RUjZTAzIiHE3Z7C2Yz+tlSSSZpT9E7bN0ItLohL0R0WXIRpphirYy4+vpziVi8Hvguc3KrlliPb/9FWuqomGImMix+jYzPPBhx8hLIjC7Higqyteo147lsJDR/aUsWdVgz84Ie+3XL3j7lNG1FaF+HcYyJnR/EQaajn/mBKgBqYINNxnlRTwhbhWAPA1FvxfWtENa0qW/fgu0wyy/LvFqlPEZk6axgGH7apxROJ2vs8cnvhuWI4jLfi0+PbEfFNp8zxBfcbatizxG5mIIbBHgavsXsoqv13Lk0A8HJd+togC6iNINMJ/arE1gI9QiDeYvA5KNmTaQFDGwQozegi7KOJMDY1m5cwBsAXhFr3Fsve50eRytTRovySO28Tbxpk6DzmqJMmDpEF5NN5v9HjYFX4eq0VCr/akmeduXjEwkIs2Mk3s03DMQu/LVeJM0rWdutY/SAp6lXhwW2RShJD5GzEL0ueGh/ZqLatECcguHi+SEvA6H2vegNkcvgseWEsZzq3bgJnvPZ7GQK+qcIfLZCjMogH7bQA4xWq
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(36756003)(86362001)(2906002)(82310400005)(7416002)(40480700001)(47076005)(7696005)(6666004)(426003)(336012)(186003)(36860700001)(83380400001)(107886003)(26005)(1076003)(7636003)(82740400003)(356005)(40460700003)(110136005)(54906003)(70206006)(4326008)(316002)(2616005)(478600001)(70586007)(41300700001)(5660300002)(8936002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 07:57:55.7593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d0995ce-b83e-45cc-f7ad-08db6b1abb52
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5915
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Setting very small value of db like 10ms introduces rounding errors when
converting to/from jiffies on some kernel configs. For example, on 250hz
the actual value will be set to 12ms which causes the test to fail:

 # $ sudo ./tdc.py  -d eth2 -e 3410
 #  -- ns/SubPlugin.__init__
 # Test 3410: Create SFB with db setting
 #
 # All test results:
 #
 # 1..1
 # not ok 1 3410 - Create SFB with db setting
 #         Could not match regex pattern. Verify command output:
 # qdisc sfb 1: root refcnt 2 rehash 600s db 12ms limit 1000p max 25p target 20p increment 0.000503548 decrement 4.57771e-05 penalty_rate 10pps penalty_burst 20p

Set the value to 100ms instead which currently seem to work on 100hz,
250hz, 300hz and 1000hz kernel configs.

Fixes: 6ad92dc56fca ("selftests/tc-testing: add selftests for sfb qdisc")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json
index ba2f5e79cdbf..e21c7f22c6d4 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json
@@ -58,10 +58,10 @@
         "setup": [
             "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root sfb db 10",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root sfb db 100",
         "expExitCode": "0",
         "verifyCmd": "$TC qdisc show dev $DUMMY",
-        "matchPattern": "qdisc sfb 1: root refcnt [0-9]+ rehash 600s db 10ms",
+        "matchPattern": "qdisc sfb 1: root refcnt [0-9]+ rehash 600s db 100ms",
         "matchCount": "1",
         "teardown": [
             "$TC qdisc del dev $DUMMY handle 1: root",
-- 
2.39.2


