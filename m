Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68488D6B9E
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 00:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731744AbfJNWSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 18:18:53 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:34767 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730369AbfJNWSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 18:18:52 -0400
Received: by mail-io1-f41.google.com with SMTP id q1so41461166ion.1
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 15:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=vvkshSUSs4BzcxyHbR+YodLDNPDq7HtQHOkGUThgnuo=;
        b=D08GWDKMJVANNcjRUbuqlHo50jhuae5splNkuwvhciuglROQj+4NbgKDFuazNdhlUR
         QKHk0PqFR+YH0PWNVlGhZibBsRhMOK6iXl/0R44ItO7s0WzNwXozdtKBhuqivHEXJYkL
         qqYihP5XPyd0gcU5wQA2j5HouJ9Ya4xVekq/o8hVWPi2qABz7Lq3HZXnXzhfUtfmngnx
         hVXr3lBZ7cnXi9vbZXRv3JQe324SlcKsgJAavxiv2Gk1NKyZi8CGDp20dSGwtLacs6If
         QItRRqRarI29v/EHk6LBIAGNKPYSTbE/F4cpBSmKzV5ciEOwsrbkPRq8K6QkpMafppA/
         lSNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vvkshSUSs4BzcxyHbR+YodLDNPDq7HtQHOkGUThgnuo=;
        b=ALeXUY4okshNSjBYeZOHZoxC0EC4InhL4kYHT8Y7BmiqpwSOy/roDl3sduvhaMi0fA
         JFZxh9YvEcLvPS5SpfDwxiItU3JyT+dUci2z/SeQK7GS9VuRNZDg7K07K5BYpVrqf/n5
         N71tgwOg6T6IAcBWq8dO1bNIRf3IY3rxXLHKe4+SXYIclV9XTxMKv7YVrjfsKdFoQ9EY
         FrlJQGYow2YwyIq0VlAs8Z+9m+yM3vh+9iYfDMntLkQKq5H6mN39oBRuOvEoV4KVumGr
         MiGT5yZ2oOJ79sIuVePgmgIDmVkfy8nJsVYTfjm8QBAXNvlwqY6k2iNdUmhyKlpeHT4q
         PPpw==
X-Gm-Message-State: APjAAAWqXgfA7RkbhHsmOGi4pjbfsqG/ORyoEZyn4fEguysZAfTlKIXO
        xjIoAFBSE86hD/u0prKNsJZJZtxStJY=
X-Google-Smtp-Source: APXvYqxvIepcl3AsH9CQMIqIEunVhft+tyJ5Fjh0xkSz6CH38psbjzBi/FV9IPkmajnfhJSYZMEMvQ==
X-Received: by 2002:a92:c522:: with SMTP id m2mr2855499ili.127.1571091531668;
        Mon, 14 Oct 2019 15:18:51 -0700 (PDT)
Received: from mojatatu.com ([74.127.203.196])
        by smtp.gmail.com with ESMTPSA id e21sm19777589ioh.55.2019.10.14.15.18.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 14 Oct 2019 15:18:50 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: updated pedit test cases
Date:   Mon, 14 Oct 2019 18:18:29 -0400
Message-Id: <1571091509-9585-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added TDC test cases for Ethernet LAYERED_OP operations:
- set single source Ethernet MAC
- set single destination Ethernet MAC
- set single invalid destination Ethernet MAC
- set Ethernet type
- invert source/destination/type fields
- add operation on Ethernet type field

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/actions/pedit.json         | 198 +++++++++++++++++++++
 1 file changed, 198 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json b/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
index c30d37a0b9bc..54934203274c 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
@@ -349,6 +349,31 @@
         ]
     },
     {
+        "id": "a5a7",
+        "name": "Add pedit action with LAYERED_OP eth set src",
+        "category": [
+            "actions",
+            "pedit",
+            "layered_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit ex munge eth src set 11:22:33:44:55:66",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pass keys 2.*key #0  at eth\\+4: val 00001122 mask ffff0000.*key #1  at eth\\+8: val 33445566 mask 00000000",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
         "id": "86d4",
         "name": "Add pedit action with LAYERED_OP eth set src & dst",
         "category": [
@@ -374,6 +399,31 @@
         ]
     },
     {
+        "id": "f8a9",
+        "name": "Add pedit action with LAYERED_OP eth set dst",
+        "category": [
+            "actions",
+            "pedit",
+            "layered_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit ex munge eth dst set 11:22:33:44:55:66",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pass keys 2.*key #0  at eth\\+0: val 11223344 mask 00000000.*key #1  at eth\\+4: val 55660000 mask 0000ffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
         "id": "c715",
         "name": "Add pedit action with LAYERED_OP eth set src (INVALID)",
         "category": [
@@ -399,6 +449,31 @@
         ]
     },
     {
+        "id": "8131",
+        "name": "Add pedit action with LAYERED_OP eth set dst (INVALID)",
+        "category": [
+            "actions",
+            "pedit",
+            "layered_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit ex munge eth dst set %e:11:m2:33:x4:-5",
+        "expExitCode": "255",
+        "verifyCmd": "/bin/true",
+        "matchPattern": " ",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
         "id": "ba22",
         "name": "Add pedit action with LAYERED_OP eth type set/clear sequence",
         "category": [
@@ -424,6 +499,129 @@
         ]
     },
     {
+        "id": "dec4",
+        "name": "Add pedit action with LAYERED_OP eth set type (INVALID)",
+        "category": [
+            "actions",
+            "pedit",
+            "layered_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit ex munge eth type set 0xabcdef",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pass keys 1.*key #0  at eth+12: val ",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "ab06",
+        "name": "Add pedit action with LAYERED_OP eth add type",
+        "category": [
+            "actions",
+            "pedit",
+            "layered_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit ex munge eth type add 0x1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pass keys 1.*key #0  at eth\\+12: add 00010000 mask 0000ffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "918d",
+        "name": "Add pedit action with LAYERED_OP eth invert src",
+        "category": [
+            "actions",
+            "pedit",
+            "layered_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit ex munge eth src invert",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pass keys 2.*key #0  at eth\\+4: val 0000ff00 mask ffff0000.*key #1  at eth\\+8: val 00000000 mask 00000000",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "a8d4",
+        "name": "Add pedit action with LAYERED_OP eth invert dst",
+        "category": [
+            "actions",
+            "pedit",
+            "layered_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit ex munge eth dst invert",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pass keys 2.*key #0  at eth\\+0: val ff000000 mask 00000000.*key #1  at eth\\+4: val 00000000 mask 0000ffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "ee13",
+        "name": "Add pedit action with LAYERED_OP eth invert type",
+        "category": [
+            "actions",
+            "pedit",
+            "layered_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit ex munge eth type invert",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pass keys 1.*key #0  at eth\\+12: val ffff0000 mask ffffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
         "id": "7588",
         "name": "Add pedit action with LAYERED_OP ip set src",
         "category": [
-- 
2.7.4

