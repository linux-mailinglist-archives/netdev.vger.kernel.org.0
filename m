Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89C103CDDA
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 16:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387778AbfFKOCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 10:02:32 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:51922 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387447AbfFKOCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 10:02:32 -0400
Received: by mail-it1-f195.google.com with SMTP id m3so5102614itl.1
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 07:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=NknRpMgspWqVfVE+Hi/wYW1AYWpKzLD3GLrvcNX3UkE=;
        b=vgUqroNH2Xa4SZBCwv8xzGnbFSM7sjaCtlZfuX5Ae658Lmm2D2PMiMnsZTjFqtY5XW
         caXJDY6yyt2LImuJ1GN4UUEkv35fniRmfGj1fGy6nZHeWNps+Qn3DMuZQJ2OwFGFXLYV
         AcGWcwGsbZrl3v2n37/7bedP3b5ZHpgIJIHmrDBDVQgbydK8zjChC+AhKf6jiKMXlDMc
         dotJJ8mBLPVwY+UOmgLnyI/t5rpx2KEDroMS2M03WrOw/eJO1/ZzuzPBjnMNJYGq8hoO
         mGVsRedun8N8QJvSfp37x6xolvbnUlNwT2TJKCAkYzxzOYy+vlegTOLf9VTQRjHqCgnB
         W8mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NknRpMgspWqVfVE+Hi/wYW1AYWpKzLD3GLrvcNX3UkE=;
        b=kcx74jmvfLSC0gNsy2LGnuFbgfVQXi/VBbT+Tx5j+OM9zfZnnd7Im+YP6SqPjDEY7r
         CObUI67OT5Z3xi6nferEfd6r8voFAYTTolGwxNDRsxHPvH+RjQBFHHnzfnQ5GarIuJ1+
         ITiiY0r1McxQk/laqPsacMSudqgMKRr9TCKnasO2BaBlaRVKn/3+8lsI0SlDww8IjEtR
         gjiLJ0mnjaOQOmni+a63lIzZrgQ7hws2PB28uYxZLpuCNpHswPcetY5pmieVt5W5zAQ/
         EuJUmrjVJ4Rq2EGiPRh26mWE0d/WWidcNh+81TSVf3yh7Zd9KvJ7cb2BWcpTv3Xc6Iup
         AtYQ==
X-Gm-Message-State: APjAAAXjXA68gHqtbC2jkxGSsxuffiZi+Bvc8+UymCRHZByWpXE3KaU0
        JnAVwN1FSn0Zcw/A24owSEhMEPh8H0M=
X-Google-Smtp-Source: APXvYqxA+C7CAhLBqM1v0SsZcoAS1tqV/lQy5m8xJpr0JRJX7SwMw9Vieux0fD8q4B8L0zhOblSQSg==
X-Received: by 2002:a24:b807:: with SMTP id m7mr16510106ite.156.1560261750754;
        Tue, 11 Jun 2019 07:02:30 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id t133sm5089765iof.21.2019.06.11.07.02.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 07:02:30 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-tests: updated fw with bind actions by reference use cases
Date:   Tue, 11 Jun 2019 10:02:22 -0400
Message-Id: <1560261742-20962-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extended fw TDC tests with use cases where actions are pre-created and
attached to a filter by reference, i.e. by action index.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../selftests/tc-testing/tc-tests/filters/fw.json  | 144 +++++++++++++++++++++
 1 file changed, 144 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/fw.json b/tools/testing/selftests/tc-testing/tc-tests/filters/fw.json
index 3b97cfd7e0f8..6944b90d4897 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/fw.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/fw.json
@@ -57,6 +57,30 @@
         ]
     },
     {
+        "id": "c591",
+        "name": "Add fw filter with action ok by reference",
+        "__comment": "We add sleep here because action might have not been deleted by workqueue just yet. Remove this when the behaviour is fixed.",
+        "category": [
+            "filter",
+            "fw"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "/bin/sleep 1",
+            "$TC actions add action gact ok index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 fw action gact index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol all fw",
+        "matchPattern": "handle 0x1.*gact action pass.*index 1 ref 2 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "/bin/sleep 1",
+            "$TC actions del action gact index 1"
+        ]
+    },
+    {
         "id": "affe",
         "name": "Add fw filter with action continue",
         "category": [
@@ -76,6 +100,30 @@
         ]
     },
     {
+        "id": "38b3",
+        "name": "Add fw filter with action continue by reference",
+        "__comment": "We add sleep here because action might have not been deleted by workqueue just yet. Remove this when the behaviour is fixed.",
+        "category": [
+            "filter",
+            "fw"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "/bin/sleep 1",
+            "$TC actions add action gact continue index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 fw action gact index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol all fw",
+        "matchPattern": "handle 0x1.*gact action continue.*index 1 ref 2 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "/bin/sleep 1",
+            "$TC actions del action gact index 1"
+        ]
+    },
+    {
         "id": "28bc",
         "name": "Add fw filter with action pipe",
         "category": [
@@ -95,6 +143,30 @@
         ]
     },
     {
+        "id": "6753",
+        "name": "Add fw filter with action pipe by reference",
+        "__comment": "We add sleep here because action might have not been deleted by workqueue just yet.",
+        "category": [
+            "filter",
+            "fw"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "/bin/sleep 1",
+            "$TC actions add action gact pipe index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 fw action gact index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol all fw",
+        "matchPattern": "handle 0x1.*gact action pipe.*index 1 ref 2 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "/bin/sleep 1",
+            "$TC actions del action gact index 1"
+        ]
+    },
+    {
         "id": "8da2",
         "name": "Add fw filter with action drop",
         "category": [
@@ -114,6 +186,30 @@
         ]
     },
     {
+        "id": "6dc6",
+        "name": "Add fw filter with action drop by reference",
+        "__comment": "We add sleep here because action might have not been deleted by workqueue just yet.",
+        "category": [
+            "filter",
+            "fw"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "/bin/sleep 1",
+            "$TC actions add action gact drop index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 fw action gact index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol all fw",
+        "matchPattern": "handle 0x1.*gact action drop.*index 1 ref 2 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "/bin/sleep 1",
+            "$TC actions del action gact index 1"
+        ]
+    },
+    {
         "id": "9436",
         "name": "Add fw filter with action reclassify",
         "category": [
@@ -133,6 +229,30 @@
         ]
     },
     {
+        "id": "3bc2",
+        "name": "Add fw filter with action reclassify by reference",
+        "__comment": "We add sleep here because action might have not been deleted by workqueue just yet.",
+        "category": [
+            "filter",
+            "fw"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "/bin/sleep 1",
+            "$TC actions add action gact reclassify index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 fw action gact index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol all fw",
+        "matchPattern": "handle 0x1.*gact action reclassify.*index 1 ref 2 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "/bin/sleep 1",
+            "$TC actions del action gact index 1"
+        ]
+    },
+    {
         "id": "95bb",
         "name": "Add fw filter with action jump 10",
         "category": [
@@ -152,6 +272,30 @@
         ]
     },
     {
+        "id": "36f7",
+        "name": "Add fw filter with action jump 10 by reference",
+        "__comment": "We add sleep here because action might have not been deleted by workqueue just yet.",
+        "category": [
+            "filter",
+            "fw"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "/bin/sleep 1",
+            "$TC actions add action gact jump 10 index 1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 fw action gact index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol all fw",
+        "matchPattern": "handle 0x1.*gact action jump 10.*index 1 ref 2 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "/bin/sleep 1",
+            "$TC actions del action gact index 1"
+        ]
+    },
+    {
         "id": "3d74",
         "name": "Add fw filter with action goto chain 5",
         "category": [
-- 
2.7.4

