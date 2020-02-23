Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5E216998F
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 20:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgBWTNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 14:13:00 -0500
Received: from mail-yb1-f171.google.com ([209.85.219.171]:43499 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWTNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 14:13:00 -0500
Received: by mail-yb1-f171.google.com with SMTP id b141so3608739ybg.10
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 11:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=JmRBi0LF69B3AyfgTYzA2KEqvs+1Tru9G53MWZLQoF8=;
        b=ETAaKu9jCDRdVyidMlIqWjYUmQSu9KaGW4YbrHnxq4iSCfhNAgep1pzbDw+q3apmxD
         v+2B3FMyzpp//0J8Uq5zBmYKQ/ipkw9rXkn2yX5f3qdF+oz/GlJZFqKJg77+cxl7cKqZ
         0GzDGBAOrWAbA2e/4zbwhx9QT6FRfGUhBX6qo2O47pKeyIeoVBSdaqwoR/0c71lB/JYK
         Gdg/ueEui0EY1DWVqmRYBQD++Xt6v7So+VfIorvVpU8sv01DqFOuGoH3EvnY4dFNkg+L
         z45+C3NvJ5oCc4W+2bvLEZ5nmjb560hPjNOitRBTaSTW221TciCo3oxj5N2vcnKlRWb+
         n7ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JmRBi0LF69B3AyfgTYzA2KEqvs+1Tru9G53MWZLQoF8=;
        b=PRrPif5f+uHQ9BIGr3CFttaV4B+wCxfDMIEMzhSXJ5oblhWtMdEIxVq9/u0+0iUXD1
         Ux2PaZdviac+AJLz/Z1WwIiDHK23YWrXdrkU9AIw3hquRchgHY3rP/6EFhNNhC/RuIQX
         45pAHjGnMm1RAUkd3LBv3frjeODRFQf67Jb9YhEnyWzHWpxSaXmZt9o6NakQOcGlGD8c
         9c9vlKjBmmlhZj6mYL1ipfJbTtvvXmnrehGhLOw1TgGH7RDPPXrpFADbawMdK3eVmiQj
         SIz+0Pgny0EGzKO0EuPPd/p5kDrV8PxjgK3kgtuFRwh3cn8/E4lziZFFJqkHjdnUHkbq
         qfSA==
X-Gm-Message-State: APjAAAXQOJE0wOHj3R6aCykYNznLiIN12V+u2oUzG/EwrBIDBjnObf7U
        J+tBhE3fNAvpftPLLHbXcJTWBv185Ms=
X-Google-Smtp-Source: APXvYqwzh7lu/PU3uTvZYisgYI0BHfI5eXV5Zx4/duaEqqKo7fCNKmuedXYrZStKePcZ2jvw+/eTHQ==
X-Received: by 2002:a5b:10b:: with SMTP id 11mr14956339ybx.49.1582485177682;
        Sun, 23 Feb 2020 11:12:57 -0800 (PST)
Received: from mojatatu.com ([74.127.203.195])
        by smtp.gmail.com with ESMTPSA id 124sm4211559ywm.25.2020.02.23.11.12.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 23 Feb 2020 11:12:57 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: updated tdc tests for basic filter with u32 extended match rules
Date:   Sun, 23 Feb 2020 14:12:36 -0500
Message-Id: <1582485156-5632-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/filters/basic.json         | 198 +++++++++++++++++++++
 1 file changed, 198 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
index 222174a2de01..afb9187b46a7 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
@@ -856,5 +856,203 @@
         "teardown": [
             "$TC qdisc del dev $DEV1 ingress"
         ]
+    },
+    {
+        "id": "47a0",
+        "name": "Add basic filter with u32 ematch u32/zero offset and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u32 0xaabbccdd 0xffffffff at 0)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(aabbccdd/ffffffff at 0\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "849f",
+        "name": "Add basic filter with u32 ematch u32/positive offset and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u32 0x11227788 0x1ffff0f0 at 12)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(11227080/1ffff0f0 at 12\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "d288",
+        "name": "Add basic filter with u32 ematch u32/missing offset",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u32 0x11227788 0xffffffff at)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(11227788/ffffffff at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4998",
+        "name": "Add basic filter with u32 ematch u32/missing AT keyword",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u32 0x77889900 0xfffff0f0 0)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(77889900/fffff0f0 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "1f0a",
+        "name": "Add basic filter with u32 ematch u32/missing value",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u32 at 12)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "848e",
+        "name": "Add basic filter with u32 ematch u32/non-numeric value",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u32 zero 0xffff at 0)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(00000000/ffff0000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "f748",
+        "name": "Add basic filter with u32 ematch u32/non-numeric mask",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u32 0x11223344 mask at 0)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(11223344/00000000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "55a6",
+        "name": "Add basic filter with u32 ematch u32/negative offset and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u32 0xaabbccdd 0xff00ff00 at -12)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(aa00cc00/ff00ff00 at -12\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "7282",
+        "name": "Add basic filter with u32 ematch u32/nexthdr+ offset and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u32 0xaabbccdd 0xffffffff at nexthdr+0)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(aabbccdd/ffffffff at nexthdr\\+0\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
     }
 ]
-- 
2.7.4

