Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D050F8199
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 21:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKKUzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 15:55:41 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45534 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfKKUzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 15:55:41 -0500
Received: by mail-qk1-f196.google.com with SMTP id q70so12415189qke.12
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 12:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ZODYsip/MiqnGHvlDMkiLndk6ZiUFwvnyvhIsvzWzFs=;
        b=xBDM+MJ8wzAle9eVk6U3y8tux6ioPz3hUSsjx0lyGLSSEIwIY1T9rZaB09YJbP3J8y
         4276NA1ivVvyPDIiqjY8nog91lxuQJSBiv1bBXZkNcQsBFT+O8cFJjCg2uoqJHwrvxuy
         x7xYv0uFjkdHTkSO3pyN7BYSk0EYNQK+6JmR5Uo/+xrm7Zzh5siDXQaSluWrTlD/QzwS
         FPtpyu0Uc+mGlRxhXx1yj/N/dZ746Ex3icZ3uORzZtq+TnH0Dam4EsflbPrk9n6KLoZA
         y2KV7eRNHWYcNzcgrCsFB0eydf4/Q7HuL/TQZoZt0pd/x4QVMKaCjm5wAkmG39gxBI2h
         Pd1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZODYsip/MiqnGHvlDMkiLndk6ZiUFwvnyvhIsvzWzFs=;
        b=VwW6fDQHzuVE11bmRTmlF2bC4X8bHpZGKjB+6uNRFStCnFZIMAaPVgUJTG/I8hif2K
         GGBBeJyn7hVgS4SYd44i+7bP5jtUs+9pfzr/bfv2wOuaIYCsCIspA87Xb14GodmHeVif
         Xmij3EJ2Cc7d6gYJ1YR03u5+9VHo4Flk19gLWeJXFkJPLUd0gsjxo5J2tbqTYZGggS2Q
         GGSMZDwwC861f+9sFFNRF9kXxuSq9QgEQ+pR/LUG4pwSFBOvE8fIAiF9BxCW1jSF5K4j
         2UCvYyZvOwaCXIgrbbP2186I4DE2Jnykdoirl2yjB8xvMdnc+uJLyZuIFPKAT1/8W0h8
         RTgQ==
X-Gm-Message-State: APjAAAVx0lrwFIwD8jDrD+bFgxHSTRhFcMCM2oCtYHxxT3NSExt7Ukjm
        WAQI8JzrKeNrkBhC/yMuhZD12TeKywo=
X-Google-Smtp-Source: APXvYqy8VIeETKNFOKbGY+4yd+KnN6sHGQ9adILelGjZWNbudrQIRqhUqTUW6Cubvzx+rQQ0L7rBiw==
X-Received: by 2002:a05:620a:208d:: with SMTP id e13mr12255043qka.208.1573505738242;
        Mon, 11 Nov 2019 12:55:38 -0800 (PST)
Received: from mojatatu.com (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id f21sm8553825qte.36.2019.11.11.12.55.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 12:55:37 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: Introduced tdc tests for basic filter
Date:   Mon, 11 Nov 2019 15:55:30 -0500
Message-Id: <1573505730-2553-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added tests for 'cmp' extended match rules.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/filters/basic.json         | 325 +++++++++++++++++++++
 1 file changed, 325 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/basic.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
new file mode 100644
index 000000000000..76ae03a64506
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
@@ -0,0 +1,325 @@
+[
+    {
+        "id": "7a92",
+        "name": "Add basic filter with cmp ematch u8/link layer and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u8 at 0 layer link mask 0xff gt 10)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*cmp\\(u8 at 0 layer 0 mask 0xff gt 10\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2e8a",
+        "name": "Add basic filter with cmp ematch u8/link layer with trans flag and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u8 at 0 layer link mask 0xff trans gt 10)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*cmp\\(u8 at 0 layer 0 mask 0xff trans gt 10\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4d9f",
+        "name": "Add basic filter with cmp ematch u16/link layer and a single action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u16 at 0 layer 0 mask 0xff00 lt 3)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1.*cmp\\(u16 at 0 layer 0 mask 0xff00 lt 3\\).*action.*gact action pass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4943",
+        "name": "Add basic filter with cmp ematch u32/link layer and miltiple actions",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u32 at 4 layer link mask 0xff00ff00 eq 3)' action skbedit mark 7 pipe action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1.*cmp\\(u32 at 4 layer 0 mask 0xff00ff00 eq 3\\).*action.*skbedit.*mark 7 pipe.*action.*gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "7559",
+        "name": "Add basic filter with cmp ematch u8/network layer and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0xab protocol ip prio 11 basic match 'cmp(u8 at 0 layer 1 mask 0xff gt 10)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0xab prio 11 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 11 basic.*handle 0xab flowid 1:1.*cmp\\(u8 at 0 layer 1 mask 0xff gt 10\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "aff4",
+        "name": "Add basic filter with cmp ematch u8/network layer with trans flag and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0xab protocol ip prio 11 basic match 'cmp(u8 at 0 layer 1 mask 0xff trans gt 10)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0xab prio 11 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 11 basic.*handle 0xab flowid 1:1.*cmp\\(u8 at 0 layer 1 mask 0xff trans gt 10\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "c732",
+        "name": "Add basic filter with cmp ematch u16/network layer and a single action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x100 protocol ip prio 100 basic match 'cmp(u16 at 0 layer network mask 0xff00 lt 3)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0x100 prio 100 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 100 basic.*handle 0x100.*cmp\\(u16 at 0 layer 1 mask 0xff00 lt 3\\).*action.*gact action pass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "32d8",
+        "name": "Add basic filter with cmp ematch u32/network layer and miltiple actions",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x112233 protocol ip prio 7 basic match 'cmp(u32 at 4 layer network mask 0xff00ff00 eq 3)' action skbedit mark 7 pipe action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0x112233 prio 7 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 7 basic.*handle 0x112233.*cmp\\(u32 at 4 layer 1 mask 0xff00ff00 eq 3\\).*action.*skbedit.*mark 7 pipe.*action.*gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "6f5e",
+        "name": "Add basic filter with cmp ematch u8/transport layer and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u8 at 0 layer transport mask 0xff gt 10)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*cmp\\(u8 at 0 layer 2 mask 0xff gt 10\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "0752",
+        "name": "Add basic filter with cmp ematch u8/transport layer with trans flag and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u8 at 0 layer transport mask 0xff trans gt 10)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*cmp\\(u8 at 0 layer 2 mask 0xff trans gt 10\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "7e07",
+        "name": "Add basic filter with cmp ematch u16/transport layer and a single action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u16 at 0 layer 2 mask 0xff00 lt 3)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1.*cmp\\(u16 at 0 layer 2 mask 0xff00 lt 3\\).*action.*gact action pass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "62d7",
+        "name": "Add basic filter with cmp ematch u32/transport layer and miltiple actions",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u32 at 4 layer transport mask 0xff00ff00 eq 3)' action skbedit mark 7 pipe action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1.*cmp\\(u32 at 4 layer 2 mask 0xff00ff00 eq 3\\).*action.*skbedit.*mark 7 pipe.*action.*gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "304b",
+        "name": "Add basic filter with NOT cmp ematch rule and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'not cmp(u8 at 0 layer link mask 0xff eq 3)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*NOT cmp\\(u8 at 0 layer 0 mask 0xff eq 3\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "8ecb",
+        "name": "Add basic filter with two ANDed cmp ematch rules and single action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u8 at 0 layer link mask 0xff eq 3) and cmp(u16 at 8 layer link mask 0x00ff gt 7)' action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1.*cmp\\(u8 at 0 layer 0 mask 0xff eq 3\\).*AND cmp\\(u16 at 8 layer 0 mask 0xff gt 7\\).*action.*gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "b1ad",
+        "name": "Add basic filter with two ORed cmp ematch rules and single action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u8 at 0 layer link mask 0xff eq 3) or cmp(u16 at 8 layer link mask 0x00ff gt 7)' action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1.*cmp\\(u8 at 0 layer 0 mask 0xff eq 3\\).*OR cmp\\(u16 at 8 layer 0 mask 0xff gt 7\\).*action.*gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4600",
+        "name": "Add basic filter with two ANDed cmp ematch rules and one ORed ematch rule and single action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u8 at 0 layer link mask 0xff eq 3) and cmp(u16 at 8 layer link mask 0x00ff gt 7) or cmp(u32 at 4 layer network mask 0xa0a0 lt 3)' action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1.*cmp\\(u8 at 0 layer 0 mask 0xff eq 3\\).*AND cmp\\(u16 at 8 layer 0 mask 0xff gt 7\\).*OR cmp\\(u32 at 4 layer 1 mask 0xa0a0 lt 3\\).*action.*gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "bc59",
+        "name": "Add basic filter with two ANDed cmp ematch rules and one NOT ORed ematch rule and single action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u8 at 0 layer link mask 0xff eq 3) and cmp(u16 at 8 layer link mask 0x00ff gt 7) or not cmp(u32 at 4 layer network mask 0xa0a0 lt 3)' action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1.*cmp\\(u8 at 0 layer 0 mask 0xff eq 3\\).*AND cmp\\(u16 at 8 layer 0 mask 0xff gt 7\\).*OR NOT cmp\\(u32 at 4 layer 1 mask 0xa0a0 lt 3\\).*action.*gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    }
+]
-- 
2.7.4

