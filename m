Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5703B5BA502
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 05:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiIPDFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 23:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiIPDEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 23:04:49 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64669DFB7;
        Thu, 15 Sep 2022 20:04:19 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MTJj94zmyzmVQ2;
        Fri, 16 Sep 2022 11:00:29 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 16 Sep
 2022 11:04:16 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <cake@lists.bufferbloat.net>,
        <linux-kselftest@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <toke@toke.dk>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>, <shuah@kernel.org>,
        <victor@mojatatu.com>
CC:     <zhijianx.li@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next 17/18] selftests/tc-testings: add show class case for prio qdisc
Date:   Fri, 16 Sep 2022 11:05:43 +0800
Message-ID: <20220916030544.228274-18-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220916030544.228274-1-shaozhengchao@huawei.com>
References: <20220916030544.228274-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test 2410: Show prio class

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/qdiscs/prio.json      | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/prio.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/prio.json
index 3076c02d08d6..8186de2f0dcf 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/prio.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/prio.json
@@ -272,5 +272,25 @@
         "teardown": [
             "$IP link del dev $DUMMY type dummy"
         ]
+    },
+    {
+        "id": "2410",
+        "name": "Show prio class",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root prio",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class prio 1:[0-9]+ parent 1:",
+        "matchCount": "3",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root prio",
+            "$IP link del dev $DUMMY type dummy"
+        ]
     }
 ]
-- 
2.17.1

