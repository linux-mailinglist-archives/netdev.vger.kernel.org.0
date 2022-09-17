Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179915BB675
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 07:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIQFER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 01:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiIQFEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 01:04:12 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1C6B9F99;
        Fri, 16 Sep 2022 22:04:11 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MTzM06nk6zBsPc;
        Sat, 17 Sep 2022 13:02:04 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 17 Sep
 2022 13:04:09 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <toke@toke.dk>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>, <shuah@kernel.org>,
        <victor@mojatatu.com>
CC:     <zhijianx.li@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2 16/18] selftests/tc-testings: add show class case for mq qdisc
Date:   Sat, 17 Sep 2022 13:05:53 +0800
Message-ID: <20220917050553.132771-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test 1023: Show mq class

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/qdiscs/mq.json        | 24 ++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
index c6046096d9db..44fbfc6caec7 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mq.json
@@ -133,5 +133,27 @@
 	    "teardown": [
 		    "echo \"1\" > /sys/bus/netdevsim/del_device"
 	    ]
-	}
+	},
+        {
+            "id": "1023",
+            "name": "Show mq class",
+            "category": [
+                "qdisc",
+                "mq"
+            ],
+            "plugins": {
+                "requires": "nsPlugin"
+            },
+            "setup": [
+                "echo \"1 1 4\" > /sys/bus/netdevsim/new_device"
+            ],
+            "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mq",
+            "expExitCode": "0",
+            "verifyCmd": "$TC class show dev $ETH",
+            "matchPattern": "class mq 1:[0-9]+ root",
+            "matchCount": "4",
+            "teardown": [
+                "echo \"1\" > /sys/bus/netdevsim/del_device"
+            ]
+        }
 ]
-- 
2.17.1

