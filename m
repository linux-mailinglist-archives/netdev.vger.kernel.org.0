Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B8F168074
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 15:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgBUOj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 09:39:27 -0500
Received: from mail-yb1-f173.google.com ([209.85.219.173]:40237 "EHLO
        mail-yb1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgBUOj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 09:39:27 -0500
Received: by mail-yb1-f173.google.com with SMTP id f130so1180390ybc.7
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 06:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=WAjVsvOo/U2RYKIAhVuI7KTfqCJ+ZK6Z1+NHHk4gnN4=;
        b=MJmOcEU9IWwkGUj7SPLYgLgtqKxcFGhXo9ovFr3nyTQkts+mXxTMAhzfdiKdVYu8Rz
         71F198pGz7wU1soYSPGJj7SJQuOXdM/vggqvH7cEvAtzy8iX42aYwIzjFqg48lkjMzL1
         CHhpAMN/3dW2EWn9oAgz1l3L+aWkdQ3Yv/J+IFrcSab+AieCyCOPslg89aXM7yyVbNZH
         ph18eHMlY8WGma8BRWz6Kk3HwrrmTo9Rce2rOOxkUpsqN5frneNnQeFII0YLxSDUeu9x
         TtgQ1/qcD4OmHxR/7b7ApxddHXEm3Gl2LcXnBov1DgX8/J9zqHTqKuooVuasD7efz6/w
         sUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WAjVsvOo/U2RYKIAhVuI7KTfqCJ+ZK6Z1+NHHk4gnN4=;
        b=bXPlku1ZAhfHnAYFoDRltWEF43qcJqwDmMf6YkZU5whxKE0orJcEL4/q/ATJktCgj7
         Ok/lNauyf/aSaYy8BP0GTAoSOJsfTLEZAoIAYrTlj3aqYFo1vVLpTzdVLMjNGf931YD8
         GjhJKgTmlQcM55z3GDkWqw206dz+ZcO0imN3DJUKZvsoVeqsTNaszxUfaaMd7pcH3luG
         rGEuThToc8L7bQrblSaXR7mTUasK8dNeFGDxO0rsM/6FprB4kbMcMLMTw8nZMxuVXuOf
         4h5UpsXRRq+kM3eSOJU7V9Awory1gjSyAihtkN4wtnFTSzD0CcD+jwceDdwZym1uMhdR
         Aojg==
X-Gm-Message-State: APjAAAVYPrRaM33sslDxh7rz4+B2oLmVhrEszfTiwjy9lpS39Yfhx+Vq
        WBYzhsun9Ci//QwmD24lBeQGGFcgUoI=
X-Google-Smtp-Source: APXvYqz70ktI+j8mxe8DwjlIrRhKfwmsDn+8S1DvthlpvYnBeBlNEGCjEzfqQMDbIUoGMOxsYC14RA==
X-Received: by 2002:a5b:b84:: with SMTP id l4mr35573712ybq.349.1582295964548;
        Fri, 21 Feb 2020 06:39:24 -0800 (PST)
Received: from mojatatu.com ([74.127.203.195])
        by smtp.gmail.com with ESMTPSA id d13sm1441151ywj.91.2020.02.21.06.39.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 21 Feb 2020 06:39:23 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: updated tdc tests for basic filter with u16 extended match rules
Date:   Fri, 21 Feb 2020 09:38:57 -0500
Message-Id: <1582295937-18602-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/filters/basic.json         | 242 +++++++++++++++++++++
 1 file changed, 242 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
index 75f547a5ee48..222174a2de01 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
@@ -614,5 +614,247 @@
         "teardown": [
             "$TC qdisc del dev $DEV1 ingress"
         ]
+    },
+    {
+        "id": "1d85",
+        "name": "Add basic filter with u32 ematch u16/zero offset and default action",
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
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u16 0x1122 0xffff at 0)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(11220000/ffff0000 at 0\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "3672",
+        "name": "Add basic filter with u32 ematch u16/zero offset and invalid value >0xFFFF",
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
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u16 0x112233 0xffff at 0)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(11223300/ffff0000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "7fb0",
+        "name": "Add basic filter with u32 ematch u16/positive offset and default action",
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
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u16 0x7788 0x1fff at 12)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(17880000/1fff0000 at 12\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "19af",
+        "name": "Add basic filter with u32 ematch u16/invalid mask >0xFFFF",
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
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u16 0x7788 0xffffffff at 12)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(77880000/ffffffff at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "446d",
+        "name": "Add basic filter with u32 ematch u16/missing offset",
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
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u16 0x7788 0xffff at)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(77880000 at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "151b",
+        "name": "Add basic filter with u32 ematch u16/missing AT keyword",
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
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u16 0x7788 0xffff 0)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(77880000/ffff0000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "bb23",
+        "name": "Add basic filter with u32 ematch u16/missing value",
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
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u16 at 12)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "decc",
+        "name": "Add basic filter with u32 ematch u16/non-numeric value",
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
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u16 zero 0xffff at 0)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(00000000/ffff0000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "e988",
+        "name": "Add basic filter with u32 ematch u16/non-numeric mask",
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
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u8 0x1122 mask at 0)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(11220000/00000000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "07d8",
+        "name": "Add basic filter with u32 ematch u16/negative offset and default action",
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
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u16 0xaabb 0xffff at -12)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(aabb0000/ffff0000 at -12\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "f474",
+        "name": "Add basic filter with u32 ematch u16/nexthdr+ offset and default action",
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
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u16 0xaabb 0xf0f0 at nexthdr+0)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(a0b00000/f0f00000 at nexthdr\\+0\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
     }
 ]
-- 
2.7.4

