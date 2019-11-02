Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C81ED0DD
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 23:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfKBW0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 18:26:15 -0400
Received: from mail-yw1-f42.google.com ([209.85.161.42]:40510 "EHLO
        mail-yw1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfKBW0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 18:26:15 -0400
Received: by mail-yw1-f42.google.com with SMTP id a67so5538634ywg.7
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 15:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=I+caqxk8Wpgi7RKbBFS3CO8uROGKgOmydKIeJdGH4HU=;
        b=aZyyeDhQKmbIyJCUbPwVlJ6F2567Bryp1G2+Z6vPqUu5F2l8na5SajucZxtRbtdJt1
         TbTp7uBmVnEwmql3AUHo8F+98zJK/eNrRgA4zaQeI2K5jbfp/qpjFxnZc3XTApqE8n+j
         VlWBpa8+FsMppSlkl6nvkx5z3kRusIuG4tSjUb433cXbZOafl4azF/tpAuFhMdO8+ncG
         JZUsb3ESxTuWn8cvVCAB7aRCLO58pw3LRHveTrKnweVbqyftWfXrWQinyNpFgmk/Et6S
         jMQHN7gaqkqEsXJ+2migD4lfJA+sc5wPXbPnfW0am8QYnF8xNfbRqK2Ht8K2Cqt1k5Ik
         Wt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I+caqxk8Wpgi7RKbBFS3CO8uROGKgOmydKIeJdGH4HU=;
        b=kvr/bvXj5QuaVITRB0g4Z33OhRiyjTQ7SkZaBuApwQoHoUk5f1LhdTKcoMiF51wEg4
         R2HSlntwP0ZUb3XS+Kx5C3ZZDe61D8VpJJl/JJPadg6puf6dncdzmJn4Bnfrp7NmyY9F
         nWPASUxOM/lYSzEsDJ0C5o2BRBmn5JVnbp8eXNM9j6Fc9smaCd0F1LCDIYb8jQjfCgFv
         DVW0umpD4fmvO9FNaUK77BFWQiJN6jsZw+i1BrgFqmHb6xmjb2JcYu+10thsdxJeJuqy
         Ax2YxQxeR97uGiufzfyc1ITKbpMr/taTvAxDmywTWP1526DP8T8hPB4vOrjiaaj4mHO8
         zGiA==
X-Gm-Message-State: APjAAAU8v70TEA5YWN38wB4F3NiRB3CzFjGUjGSRv+J7voAWqn94XzyM
        YXIFFM3QSg1hrdwp5YKNWAaLTzOFOg4=
X-Google-Smtp-Source: APXvYqxsTs+wJhvnJMjGxeG3tc197jkE5DPFWo/BenEDyPc6J97bHSe9tZKQm4+S3r/IMo9ZxCwhlQ==
X-Received: by 2002:a81:7053:: with SMTP id l80mr13213789ywc.377.1572733572497;
        Sat, 02 Nov 2019 15:26:12 -0700 (PDT)
Received: from mojatatu.com ([74.127.203.93])
        by smtp.gmail.com with ESMTPSA id q198sm6763629ywg.18.2019.11.02.15.26.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 02 Nov 2019 15:26:12 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: added tests with cookie for mpls TC action
Date:   Sat,  2 Nov 2019 18:25:51 -0400
Message-Id: <1572733551-24772-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/actions/mpls.json          | 145 +++++++++++++++++++++
 1 file changed, 145 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json b/tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json
index e31a080edc49..866f0efd0859 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/mpls.json
@@ -168,6 +168,54 @@
         ]
     },
     {
+        "id": "09d2",
+        "name": "Add mpls dec_ttl action with opcode and cookie",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl pipe index 8 cookie aabbccddeeff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*dec_ttl pipe.*index 8 ref.*cookie aabbccddeeff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
+        "id": "c170",
+        "name": "Add mpls dec_ttl action with opcode and cookie of max length",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls dec_ttl continue index 8 cookie aa11bb22cc33dd44ee55ff66aa11b1b2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*dec_ttl continue.*index 8 ref.*cookie aa11bb22cc33dd44ee55ff66aa11b1b2",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
         "id": "9118",
         "name": "Add mpls dec_ttl action with invalid opcode",
         "category": [
@@ -302,6 +350,30 @@
         ]
     },
     {
+        "id": "91fb",
+        "name": "Add mpls pop action with ip proto and cookie",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls pop protocol ipv4 cookie 12345678",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*pop.*protocol.*ip.*pipe.*ref 1.*cookie 12345678",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
         "id": "92fe",
         "name": "Add mpls pop action with mpls proto",
         "category": [
@@ -508,6 +580,30 @@
         ]
     },
     {
+        "id": "7c34",
+        "name": "Add mpls push action with label, tc ttl and cookie of max length",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls push label 20 tc 3 ttl 128 cookie aa11bb22cc33dd44ee55ff66aa11b1b2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*push.*protocol.*mpls_uc.*label.*20.*tc.*3.*ttl.*128.*pipe.*ref 1.*cookie aa11bb22cc33dd44ee55ff66aa11b1b2",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
         "id": "16eb",
         "name": "Add mpls push action with label and bos",
         "category": [
@@ -828,6 +924,30 @@
         ]
     },
     {
+        "id": "77c1",
+        "name": "Add mpls mod action with mpls ttl and cookie",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action mpls mod ttl 128 cookie aa11bb22cc33dd44ee55ff66aa11b1b2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mpls",
+        "matchPattern": "action order [0-9]+: mpls.*modify.*ttl.*128.*pipe.*ref 1.*cookie aa11bb22cc33dd44ee55ff66aa11b1b2",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
         "id": "b80f",
         "name": "Add mpls mod action with mpls max ttl",
         "category": [
@@ -1037,6 +1157,31 @@
         ]
     },
     {
+        "id": "95a9",
+        "name": "Replace existing mpls push action with new label, tc, ttl and cookie",
+        "category": [
+            "actions",
+            "mpls"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mpls",
+                0,
+                1,
+                255
+            ],
+            "$TC actions add action mpls push label 20 tc 3 ttl 128 index 1 cookie aa11bb22cc33dd44ee55ff66aa11b1b2"
+        ],
+        "cmdUnderTest": "$TC actions replace action mpls push label 30 tc 2 ttl 125 pipe index 1 cookie aa11bb22cc33",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action mpls index 1",
+        "matchPattern": "action order [0-9]+: mpls.*push.*protocol.*mpls_uc.*label.*30 tc 2 ttl 125 pipe.*index 1.*cookie aa11bb22cc33",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action mpls"
+        ]
+    },
+    {
         "id": "6cce",
         "name": "Delete mpls pop action",
         "category": [
-- 
2.7.4

