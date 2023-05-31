Return-Path: <netdev+bounces-6704-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F83E7177A6
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 449F328140E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E60CA929;
	Wed, 31 May 2023 07:17:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642D79460
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:17:36 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B472E129;
	Wed, 31 May 2023 00:17:29 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QWLDr1scKzTl07;
	Wed, 31 May 2023 15:17:16 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 31 May
 2023 15:17:25 +0800
From: Zhengchao Shao <shaozhengchao@huawei.com>
To: <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<shuah@kernel.org>
CC: <kuba@kernel.org>, <victor@mojatatu.com>, <peilin.ye@bytedance.com>,
	<weiyongjun1@huawei.com>, <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next] selftests/tc-testing: replace mq with invalid parent ID
Date: Wed, 31 May 2023 15:25:11 +0800
Message-ID: <20230531072511.6927-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The test case shown in [1] triggers the kernel to access the null pointer.
Therefore, add related test cases to mq.
The test results are as follows:

./tdc.py -e 0531
1..1
ok 1 0531 - Replace mq with invalid parent ID

./tdc.py -c mq
1..8
ok 1 ce7d - Add mq Qdisc to multi-queue device (4 queues)
ok 2 2f82 - Add mq Qdisc to multi-queue device (256 queues)
ok 3 c525 - Add duplicate mq Qdisc
ok 4 128a - Delete nonexistent mq Qdisc
ok 5 03a9 - Delete mq Qdisc twice
ok 6 be0f - Add mq Qdisc to single-queue device
ok 7 1023 - Show mq class
ok 8 0531 - Replace mq with invalid parent ID

[1] https://lore.kernel.org/all/20230527093747.3583502-1-shaozhengchao@huawei.com/
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/qdiscs/mq.json        | 25 ++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
index 44fbfc6caec7..ddd4a48bfe65 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
@@ -155,5 +155,28 @@
             "teardown": [
                 "echo \"1\" > /sys/bus/netdevsim/del_device"
             ]
-        }
+	},
+	{
+		"id": "0531",
+		"name": "Replace mq with invalid parent ID",
+		"category": [
+			"qdisc",
+			"mq"
+		],
+		"plugins": {
+			"requires": "nsPlugin"
+		},
+		"setup": [
+			"echo \"1 1 16\" > /sys/bus/netdevsim/new_device",
+			"$TC qdisc add dev $ETH root handle ffff: mq"
+		],
+		"cmdUnderTest": "$TC qdisc replace dev $ETH parent ffff:fff1 handle ffff: mq",
+		"expExitCode": "2",
+		"verifyCmd": "$TC qdisc show dev $ETH",
+		"matchPattern": "qdisc fq_codel 0: parent ffff",
+		"matchCount": "16",
+		"teardown": [
+			"echo \"1\" > /sys/bus/netdevsim/del_device"
+		]
+	}
 ]
-- 
2.34.1


