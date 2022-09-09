Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA2E5B2B9F
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 03:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiIIB1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 21:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIIB1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 21:27:41 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9EC1177A2;
        Thu,  8 Sep 2022 18:27:40 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MNyt35VKRzZclr;
        Fri,  9 Sep 2022 09:23:07 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 9 Sep
 2022 09:27:38 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next 7/8] selftests/tc-testings: add sample action deleting test case
Date:   Fri, 9 Sep 2022 09:29:35 +0800
Message-ID: <20220909012936.268433-8-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220909012936.268433-1-shaozhengchao@huawei.com>
References: <20220909012936.268433-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test 3872: Delete sample action with valid index
Test a394: Delete sample action with invalid index

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/actions/sample.json   | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/sample.json b/tools/testing/selftests/tc-testing/tc-tests/actions/sample.json
index ddabb160a11b..148d8bcb8606 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/sample.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/sample.json
@@ -633,5 +633,55 @@
         "teardown": [
             "$TC actions flush action sample"
         ]
+    },
+    {
+        "id": "3872",
+        "name": "Delete sample action with valid index",
+        "category": [
+            "actions",
+            "sample"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action sample",
+                0,
+                1,
+                255
+            ],
+	    "$TC actions add action sample rate 10 group 1 index 20"
+        ],
+        "cmdUnderTest": "$TC actions del action sample index 20",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action sample index 20",
+        "matchPattern": "action order [0-9]+: sample rate 1/10 group 1.*index 20 ref",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action sample"
+        ]
+    },
+    {
+        "id": "a394",
+        "name": "Delete sample action with invalid index",
+        "category": [
+            "actions",
+            "sample"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action sample",
+                0,
+                1,
+                255
+            ],
+            "$TC actions add action sample rate 10 group 1 index 20"
+        ],
+        "cmdUnderTest": "$TC actions del action sample index 10",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions get action sample index 20",
+        "matchPattern": "action order [0-9]+: sample rate 1/10 group 1.*index 20 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action sample"
+        ]
     }
 ]
-- 
2.17.1

