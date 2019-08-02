Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9CD800D2
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392236AbfHBTRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:17:02 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38658 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392202AbfHBTRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:17:01 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so34670392ioa.5
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 12:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=784cGjjpR2QrDeK0wbIrfstKUKs0WdGLmdvZAWqxHbI=;
        b=i83FX+MJ/CWwmrgf7Y0QQoCTd2km8eIp0H+5asx/9xDmJRlol39ohvX+LuFZF+4vuE
         IJx1qNoNMfItA6ZzEZZFPuJQIMWIPwZNXuaYZQrIU8iJ4BRjMgfMHvObrXl8K0QAXx8v
         PXRvas6VB4h2NGIVx4afdKacMEQ7jxCzC3bCvidXQCVBOBQumaMmBfOY6WzR56EMs7O4
         87Wh7ookoPCmSNprehnSC8DwSPiF1a8uaGKqkD8LtCTjONMFQIDlHe2Lcxu0OaEmxkyn
         N6SyuIpvyZ95xVpCUyofNiQw4opfbRspwcVAAQxQ1XGYTPPIVxu5rXAF3WcgVobs2ipv
         EXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=784cGjjpR2QrDeK0wbIrfstKUKs0WdGLmdvZAWqxHbI=;
        b=fnHdGwABntx947sUtzzpATdvcszzrPam7l7Ysa79BqH4KGxVfadSxEqjit+Al1bdug
         oA4tYYkfbIOLYeorMWVOex9fyD4YWJuSoOEvuUdNM1QL5g5PBUTyUA3dFQJad7NrsBcb
         wLU/Vz87gXWIefqv211tnCnd710o5qtE6Y2zgFA5pnLaqz2wOqDkDHKpjs5lxKwmubMW
         IFEnpYi+GdU5KwoSimf7zdaiFa1BaV3acFsSX73PWPJBA5Lm2EebFAp+xtB1pfzvCvJO
         F4sLZW2CScoC7+PggxbxnJQ04xaVTXS8XC24pgnXbpQCMr4Qz80MKCYOyPdEXq05kwwj
         bJGQ==
X-Gm-Message-State: APjAAAVdZSJs/G6OKG2DPkYKaf+6OE7GUphF5amVZa4YyitsEgf96Ko6
        o9dFhDnJctjfl+JBehH4DAEgpRl2
X-Google-Smtp-Source: APXvYqz79dFeRO9CcXkWKtdEx/R75vZYX1Q1qjm03OTmIhbYBAW6HRUAfuOuQxe9sRJzJplOPfLU2w==
X-Received: by 2002:a02:c492:: with SMTP id t18mr140979789jam.67.1564773420232;
        Fri, 02 Aug 2019 12:17:00 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id n22sm117987934iob.37.2019.08.02.12.16.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 02 Aug 2019 12:16:59 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net 2/2] tc-testing: updated vlan action tests with batch create/delete
Date:   Fri,  2 Aug 2019 15:16:47 -0400
Message-Id: <1564773407-26209-3-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564773407-26209-1-git-send-email-mrv@mojatatu.com>
References: <1564773407-26209-1-git-send-email-mrv@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update TDC tests with cases varifying ability of TC to install or delete
batches of vlan actions.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/actions/vlan.json          | 94 ++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json b/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
index cc7c7d758008..6503b1ce091f 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/vlan.json
@@ -713,5 +713,99 @@
         "teardown": [
             "$TC actions flush action vlan"
         ]
+    },
+    {
+        "id": "294e",
+        "name": "Add batch of 32 vlan push actions with cookie",
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
+        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action vlan push protocol 802.1q id 4094 priority 7 pipe index \\$i cookie aabbccddeeff112233445566778800a1 \\\"; args=\"\\$args\\$cmd\"; done && $TC actions add \\$args\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action vlan",
+        "matchPattern": "^[ \t]+index [0-9]+ ref",
+        "matchCount": "32",
+        "teardown": [
+            "$TC actions flush action vlan"
+        ]
+    },
+    {
+        "id": "56f7",
+        "name": "Delete batch of 32 vlan push actions",
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
+            ],
+            "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action vlan push protocol 802.1q id 4094 priority 7 pipe index \\$i \\\"; args=\\\"\\$args\\$cmd\\\"; done && $TC actions add \\$args\""
+        ],
+        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action vlan index \\$i \\\"; args=\"\\$args\\$cmd\"; done && $TC actions del \\$args\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action vlan",
+        "matchPattern": "^[ \t]+index [0-9]+ ref",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "759f",
+        "name": "Add batch of 32 vlan pop actions with cookie",
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
+        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action vlan pop continue index \\$i cookie aabbccddeeff112233445566778800a1 \\\"; args=\"\\$args\\$cmd\"; done && $TC actions add \\$args\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action vlan",
+        "matchPattern": "^[ \t]+index [0-9]+ ref",
+        "matchCount": "32",
+        "teardown": [
+            "$TC actions flush action vlan"
+        ]
+    },
+    {
+        "id": "c84a",
+        "name": "Delete batch of 32 vlan pop actions",
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
+            ],
+            "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action vlan pop index \\$i \\\"; args=\\\"\\$args\\$cmd\\\"; done && $TC actions add \\$args\""
+        ],
+        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action vlan index \\$i \\\"; args=\"\\$args\\$cmd\"; done && $TC actions del \\$args\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action vlan",
+        "matchPattern": "^[ \t]+index [0-9]+ ref",
+        "matchCount": "0",
+        "teardown": []
     }
 ]
-- 
2.7.4

