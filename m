Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7BE4CF30
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731974AbfFTNmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:42:37 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43627 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731825AbfFTNmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 09:42:35 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 20 Jun 2019 16:42:29 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5KDgSlP022418;
        Thu, 20 Jun 2019 16:42:29 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Jiri Pirko <jiri@mellanox.com>, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: [PATCH net-next v2 4/4] tc-tests: Add tc action ct tests
Date:   Thu, 20 Jun 2019 16:42:21 +0300
Message-Id: <1561038141-31370-5-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561038141-31370-1-git-send-email-paulb@mellanox.com>
References: <1561038141-31370-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 13 tests ensuring the command line is doing what is supposed to do.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
---
 .../selftests/tc-testing/tc-tests/actions/ct.json  | 314 +++++++++++++++++++++
 1 file changed, 314 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/ct.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json b/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
new file mode 100644
index 0000000..62b82fe
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
@@ -0,0 +1,314 @@
+[
+    {
+        "id": "696a",
+        "name": "Add simple ct action",
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
+        "cmdUnderTest": "$TC actions add action ct index 42",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct zone 0 pipe.*index 42 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
+        "id": "9f20",
+        "name": "Add ct clear action",
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
+        "cmdUnderTest": "$TC actions add action ct clear index 42",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct clear pipe.*index 42 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
+        "id": "5bea",
+        "name": "Try ct with zone",
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
+        "cmdUnderTest": "$TC actions add action ct zone 404 index 42",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct zone 404 pipe.*index 42 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
+        "id": "d5d6",
+        "name": "Try ct with zone, commit",
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
+        "cmdUnderTest": "$TC actions add action ct zone 404 commit index 42",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct commit zone 404 pipe.*index 42 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
+        "id": "029f",
+        "name": "Try ct with zone, commit, mark",
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
+        "cmdUnderTest": "$TC actions add action ct zone 404 commit mark 0x42 index 42",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct commit mark 66 zone 404 pipe.*index 42 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
+        "id": "a58d",
+        "name": "Try ct with zone, commit, mark, nat",
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
+        "cmdUnderTest": "$TC actions add action ct zone 404 commit mark 0x42 nat src addr 5.5.5.7 index 42",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct commit mark 66 zone 404 nat src addr 5.5.5.7 pipe.*index 42 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
+        "id": "901b",
+        "name": "Try ct with full nat ipv4 range syntax",
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
+        "cmdUnderTest": "$TC actions add action ct commit nat src addr 5.5.5.7-5.5.6.0 port 1000-2000 index 44",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct commit zone 0 nat src addr 5.5.5.7-5.5.6.0 port 1000-2000 pipe.*index 44 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
+        "id": "072b",
+        "name": "Try ct with full nat ipv6 syntax",
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
+        "cmdUnderTest": "$TC actions add action ct commit nat src addr 2001::1 port 1000-2000 index 44",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct commit zone 0 nat src addr 2001::1 port 1000-2000 pipe.*index 44 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
+        "id": "3420",
+        "name": "Try ct with full nat ipv6 range syntax",
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
+        "cmdUnderTest": "$TC actions add action ct commit nat src addr 2001::1-2001::10 port 1000-2000 index 44",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct commit zone 0 nat src addr 2001::1-2001::10 port 1000-2000 pipe.*index 44 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
+        "id": "4470",
+        "name": "Try ct with full nat ipv6 range syntax + force",
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
+        "cmdUnderTest": "$TC actions add action ct commit force nat src addr 2001::1-2001::10 port 1000-2000 index 44",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct commit force zone 0 nat src addr 2001::1-2001::10 port 1000-2000 pipe.*index 44 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
+        "id": "5d88",
+        "name": "Try ct with label",
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
+        "cmdUnderTest": "$TC actions add action ct label 123123 index 44",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct zone 0 label 12312300000000000000000000000000 pipe.*index 44 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
+        "id": "04d4",
+        "name": "Try ct with label with mask",
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
+        "cmdUnderTest": "$TC actions add action ct label 12312300000000000000000000000001/ffffffff000000000000000000000001 index 44",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct zone 0 label 12312300000000000000000000000001/ffffffff000000000000000000000001 pipe.*index 44 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
+        "id": "9751",
+        "name": "Try ct with mark + mask",
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
+        "cmdUnderTest": "$TC actions add action ct mark 0x42/0xf0 index 42",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct mark 66/0xf0 zone 0 pipe.*index 42 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    }
+]
-- 
1.8.3.1

