Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B76E063E
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbfJVOTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:19:10 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33647 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727323AbfJVOTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:19:00 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 16:18:53 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MEIqb3023677;
        Tue, 22 Oct 2019 17:18:53 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next 13/13] tc-testing: implement tests for new fast_init action flag
Date:   Tue, 22 Oct 2019 17:18:04 +0300
Message-Id: <20191022141804.27639-14-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022141804.27639-1-vladbu@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic tests to verify action creation with new fast_init flag for all
actions that support the flag.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 .../tc-testing/tc-tests/actions/csum.json     | 24 +++++++++++++++++++
 .../tc-testing/tc-tests/actions/ct.json       | 24 +++++++++++++++++++
 .../tc-testing/tc-tests/actions/gact.json     | 24 +++++++++++++++++++
 .../tc-testing/tc-tests/actions/mirred.json   | 24 +++++++++++++++++++
 .../tc-tests/actions/tunnel_key.json          | 24 +++++++++++++++++++
 .../tc-testing/tc-tests/actions/vlan.json     | 24 +++++++++++++++++++
 6 files changed, 144 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/csum.json b/tools/testing/selftests/tc-testing/tc-tests/actions/csum.json
index ddabb2fbb7c7..1dbbd53b994f 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/csum.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/csum.json
@@ -525,5 +525,29 @@
         "teardown": [
             "$TC actions flush action csum"
         ]
+    },
+    {
+        "id": "eaf0",
+        "name": "Add csum iph action with fast_init flag",
+        "category": [
+            "actions",
+            "csum"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action csum",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action csum iph fast_init",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action csum",
+        "matchPattern": "action order [0-9]*: csum \\(iph\\) action pass.*fast_init",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action csum"
+        ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json b/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
index 62b82fe10c89..e6c798e840de 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
@@ -310,5 +310,29 @@
         "teardown": [
             "$TC actions flush action ct"
         ]
+    },
+    {
+        "id": "3991",
+        "name": "Add simple ct action with fast_init flag",
+        "category": [
+            "actions",
+            "ct"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action ct",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action ct fast_init",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct zone 0 pipe.*fast_init",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/gact.json b/tools/testing/selftests/tc-testing/tc-tests/actions/gact.json
index 814b7a8a478b..b7b03aff2328 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/gact.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/gact.json
@@ -585,5 +585,29 @@
         "teardown": [
             "$TC actions flush action gact"
         ]
+    },
+    {
+        "id": "95ad",
+        "name": "Add gact pass action with fast_init flag",
+        "category": [
+            "actions",
+            "gact"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pass fast_init",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action gact",
+        "matchPattern": "action order [0-9]*: gact action pass.*fast_init",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action gact"
+        ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json b/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json
index 2232b21e2510..87331a6ef45f 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json
@@ -553,5 +553,29 @@
         "matchPattern": "^[ \t]+index [0-9]+ ref",
         "matchCount": "0",
         "teardown": []
+    },
+    {
+        "id": "31e3",
+        "name": "Add mirred mirror to egress action with fast_init flag",
+        "category": [
+            "actions",
+            "mirred"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mirred",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mirred egress mirror fast_init dev lo",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mirred",
+        "matchPattern": "action order [0-9]*: mirred \\(Egress Mirror to device lo\\).*fast_init",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mirred"
+        ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
index 28453a445fdb..89097c28b6d1 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
@@ -909,5 +909,29 @@
         "teardown": [
             "$TC actions flush action tunnel_key"
         ]
+    },
+    {
+        "id": "0cd2",
+        "name": "Add tunnel_key set action with fast_init flag",
+        "category": [
+            "actions",
+            "tunnel_key"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action tunnel_key",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action tunnel_key set fast_init src_ip 10.10.10.1 dst_ip 20.20.20.2 id 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action tunnel_key",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 10.10.10.1.*dst_ip 20.20.20.2.*key_id 1.*fast_init",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action tunnel_key"
+        ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json b/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
index 6503b1ce091f..3ededaf18ad0 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
@@ -807,5 +807,29 @@
         "matchPattern": "^[ \t]+index [0-9]+ ref",
         "matchCount": "0",
         "teardown": []
+    },
+    {
+        "id": "1a3d",
+        "name": "Add vlan pop action with fast_init flag",
+        "category": [
+            "actions",
+            "vlan"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action vlan",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action vlan pop fast_init",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action vlan",
+        "matchPattern": "action order [0-9]+: vlan.*pop.*fast_init",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action vlan"
+        ]
     }
 ]
-- 
2.21.0

