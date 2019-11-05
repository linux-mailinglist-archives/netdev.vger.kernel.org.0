Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0754F089B
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbfKEVni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:43:38 -0500
Received: from mail-qk1-f174.google.com ([209.85.222.174]:45610 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729680AbfKEVni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:43:38 -0500
Received: by mail-qk1-f174.google.com with SMTP id q70so22640128qke.12
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=dyii/wnH+9cDnVvfHVx3zz7Me2EkFrDpRjPcdgP2RzE=;
        b=sHg3/oqnS9FepJP/5MbeLPWV12zJJIDIOrdb39E/yazHoBJ4KOX2PXh2K0IpZvkbca
         ysGOeRKhXVbBORYPfPQ9FXP/l24IydBvOxzHExHxGCXdRBaq5b12RkghNvR8AkxboZlg
         rfgaFKQj4giYanzpfxtX/Mipg/OdqVisf/sPQIjM1erh6QuFRijBfFEPW4SLEtTrrqVz
         /G6kteAVrRTRYve2JQPfyp929ep6gbs6yA7ASI/UvLICi0wFDyZpI9qtJswU+/kSKtEW
         O8+B7ZVvop0IUEmRI5okU+UVIKzu+8INFsSbkiPXNN2x3b6iItmUEEedw2jGJdoHHNfU
         SMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dyii/wnH+9cDnVvfHVx3zz7Me2EkFrDpRjPcdgP2RzE=;
        b=MkvjX9hCJhl1rVF3N5oUbb7AjRASI251ZSirnqcKswWZmcPqcnofRDSiBAsvwVaZvg
         eK8ydRX2Bz0b+/fuqt6xxm3OHlGAciFP6jEIi0poNCsttCYkMXBhaOJIxV6EQ4gHRDk+
         SNsdkrWN5SKMR67onzQLMQMDm9GzPZTQdN+CH0etZsIDcfYoRaFngQdNjB2oJb8HnlRM
         txMn+YBXTgK3ckVnsblV0cBCFnl1X2gGVbZQTf6dn9iqiUN7drahUJNu4Us3YUkZvGz9
         xq8XR42KqWAKEZODS5d2s6P4p3PHdj+ppITn5mr8l51NKV4e8krhoPfD/dr0+5jyICpI
         Sg9A==
X-Gm-Message-State: APjAAAU01mJj5hzL9Ss0yTdWahSTFYo/QbOexv7JWi0opRdJvPeYK8x2
        dpTVvYLFSzYU1JPmdiQ3a1K7mQ==
X-Google-Smtp-Source: APXvYqyK5+h9aStiCRP1ON7aXz7S/6P5UHCK7hAhbl7CTsVXIla94ktmwg9Q9GqrV0bQ9cAIFVZ8+w==
X-Received: by 2002:a37:a083:: with SMTP id j125mr1112273qke.55.1572990217107;
        Tue, 05 Nov 2019 13:43:37 -0800 (PST)
Received: from mojatatu.com (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id x194sm7137902qkb.66.2019.11.05.13.43.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 05 Nov 2019 13:43:36 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: updated pedit TDC tests
Date:   Tue,  5 Nov 2019 16:43:28 -0500
Message-Id: <1572990208-30003-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added tests for u8/u32 clear value, u8/16 retain value, u16/32 invert value,
u8/u16/u32 preserve value and test for negative offsets.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/actions/pedit.json         | 250 +++++++++++++++++++++
 1 file changed, 250 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json b/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
index 6035956a1a73..f8ea6f5fa8e9 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
@@ -349,6 +349,256 @@
         ]
     },
     {
+        "id": "1762",
+        "name": "Add pedit action with RAW_OP offset u8 clear value",
+        "category": [
+            "actions",
+            "pedit",
+            "raw_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit munge offset 0 u8 clear",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:.*pedit.*keys 1.*key #0.*at 0: val 00000000 mask 00ffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "bcee",
+        "name": "Add pedit action with RAW_OP offset u8 retain value",
+        "category": [
+            "actions",
+            "pedit",
+            "raw_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit munge offset 0 u8 set 0x11 retain 0x0f",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:.*pedit.*keys 1.*key #0.*at 0: val 01000000 mask f0ffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "e89f",
+        "name": "Add pedit action with RAW_OP offset u16 retain value",
+        "category": [
+            "actions",
+            "pedit",
+            "raw_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit munge offset 0 u16 set 0x1122 retain 0xff00",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:.*pedit.*keys 1.*key #0.*at 0: val 11000000 mask 00ffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "c282",
+        "name": "Add pedit action with RAW_OP offset u32 clear value",
+        "category": [
+            "actions",
+            "pedit",
+            "raw_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit munge offset 0 u32 clear",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:.*pedit.*keys 1.*key #0.*at 0: val 00000000 mask 00000000",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "c422",
+        "name": "Add pedit action with RAW_OP offset u16 invert value",
+        "category": [
+            "actions",
+            "pedit",
+            "raw_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit munge offset 12 u16 invert",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:.*pedit.*keys 1.*key #0.*at 12: val ffff0000 mask ffffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "d3d3",
+        "name": "Add pedit action with RAW_OP offset u32 invert value",
+        "category": [
+            "actions",
+            "pedit",
+            "raw_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit munge offset 12 u32 invert",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:.*pedit.*keys 1.*key #0.*at 12: val ffffffff mask ffffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "57e5",
+        "name": "Add pedit action with RAW_OP offset u8 preserve value",
+        "category": [
+            "actions",
+            "pedit",
+            "raw_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit munge offset 0 u8 preserve",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:.*pedit.*keys 1.*key #0.*at 0: val 00000000 mask ffffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "99e0",
+        "name": "Add pedit action with RAW_OP offset u16 preserve value",
+        "category": [
+            "actions",
+            "pedit",
+            "raw_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit munge offset 0 u16 preserve",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:.*pedit.*keys 1.*key #0.*at 0: val 00000000 mask ffffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "1892",
+        "name": "Add pedit action with RAW_OP offset u32 preserve value",
+        "category": [
+            "actions",
+            "pedit",
+            "raw_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit munge offset 0 u32 preserve",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:.*pedit.*keys 1.*key #0.*at 0: val 00000000 mask ffffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "4b60",
+        "name": "Add pedit action with RAW_OP negative offset u16/u32 set value",
+        "category": [
+            "actions",
+            "pedit",
+            "raw_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit munge offset -14 u16 set 0x0000 munge offset -12 u32 set 0x00000100 munge offset -8 u32 set 0x0aaf0100 munge offset -4 u32 set 0x0008eb06 pipe",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:.*pedit.*keys 4.*key #0.*at -16: val 00000000 mask ffff0000.*key #1.*at -12: val 00000100 mask 00000000.*key #2.*at -8: val 0aaf0100 mask 00000000.*key #3.*at -4: val 0008eb06 mask 00000000",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
         "id": "a5a7",
         "name": "Add pedit action with LAYERED_OP eth set src",
         "category": [
-- 
2.7.4

