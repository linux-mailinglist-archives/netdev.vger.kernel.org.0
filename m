Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C775BF3BE
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 04:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiIUCm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 22:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiIUCmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 22:42:54 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4945E7D784;
        Tue, 20 Sep 2022 19:42:53 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MXMz62YXmzMn66;
        Wed, 21 Sep 2022 10:38:10 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 10:42:51 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <toke@toke.dk>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>, <shuah@kernel.org>,
        <victor@mojatatu.com>
CC:     <zhijianx.li@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v3 18/18] selftests/tc-testing: add show class case for red qdisc
Date:   Wed, 21 Sep 2022 10:44:25 +0800
Message-ID: <20220921024425.392748-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test 290a: Show RED class

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
---
 .../tc-testing/tc-tests/qdiscs/red.json       | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
index 0703a2a255eb..4b3e449857f2 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/red.json
@@ -181,5 +181,28 @@
             "$TC qdisc del dev $DUMMY handle 1: root",
             "$IP link del dev $DUMMY type dummy"
         ]
+    },
+    {
+        "id": "290a",
+        "name": "Show RED class",
+        "category": [
+            "qdisc",
+            "red"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root red limit 1M avpkt 1500 min 100K max 300K",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class red 1:[0-9]+ parent 1:",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
     }
 ]
-- 
2.17.1

