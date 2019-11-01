Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817E4EC8D7
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 20:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfKATFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 15:05:50 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]:36170 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727372AbfKATFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 15:05:49 -0400
Received: by mail-qt1-f177.google.com with SMTP id y10so7469189qto.3
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 12:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=MwTfV999XGO593pktoRPOUJzu5Lxw3LUqz7Rw4v0H/I=;
        b=oZPqeG5WQOKlXKKrid4FJhBL1cGqa2hUr3IcwqlKfh3+3uNebmcLpa6uh0g833Bjxd
         KoTYTHpqEq6ZGUiaQdeY4ajgR/DAu6+hVF3FjnJCKxw5AmHLrtg4A+jkG0j0WV5+9MhP
         xU3SsBGYFBqIjfsuv/lwFHt3PAte2P6txAy/iLjDLNWbNpWl1OEJ8/EMmE+aPXoSDR94
         OPQzA+DkMDn42VVO0SBt4SJ2lrg0HIkegl7RQMzDK1NHcU00d4lSTCeELzHeIYiGJH6e
         thSHbP1s8TSHsK+P1GLiZmOAA4xdJaIwyVp1JEf4iM9w6kJUBIcNxXbJ7quxBIYPOMtm
         lxkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MwTfV999XGO593pktoRPOUJzu5Lxw3LUqz7Rw4v0H/I=;
        b=r6Nkz4CwkuevCzqVuoe/xuv5OOAEicnVXSpEvJp2nk7v0nBuK7Lf+OzVjr20ihQsFi
         giXwxqCC4bOB+eMrDqgvjEJPZP8V8Wi/Jf8IiLalZUY8PgRL2q+yLp1pav3kDzSMq912
         r3LK7dsViSeTnLWfs8TinUF/KG+AVmWUGdqmHKRAKgSRYpWJbasDh0Rt7hU93A/stqgA
         XuJt8Ks5txKtSXRCUIhwG61whVN5UkbiCRva7iUA8Fu6zL+beZigoveux8jxhi2GB6wb
         KLpvgXPxkmFasWhXFK7iGnz/SzQ2p8ZzvNYm+PlIqXrsuLgYDNcsvr+7KFdosQS+Ypnp
         vr4A==
X-Gm-Message-State: APjAAAUzoe32VCGO4KGFOAwKQv3k8k61Aj+gnvBShzxAFeBu6RO3QMKO
        aRF9ibb1UKu6TQnz26PfNwWbiA==
X-Google-Smtp-Source: APXvYqy1dsa7HwUFhtTe5EVl1lhi95r92t3VcVQxyH+nBTudz8js+wAhGJCJNgSF/Pgr+bbqo/32cQ==
X-Received: by 2002:ac8:7559:: with SMTP id b25mr150917qtr.79.1572635147393;
        Fri, 01 Nov 2019 12:05:47 -0700 (PDT)
Received: from mojatatu.com (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id b54sm6047951qta.38.2019.11.01.12.05.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 01 Nov 2019 12:05:46 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: added tests with cookie for conntrack TC action
Date:   Fri,  1 Nov 2019 15:05:40 -0400
Message-Id: <1572635140-23099-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../selftests/tc-testing/tc-tests/actions/ct.json  | 72 ++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json b/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
index 79e9bd3d0764..4202e95e27b9 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/ct.json
@@ -24,6 +24,30 @@
         ]
     },
     {
+        "id": "e38c",
+        "name": "Add simple ct action with cookie",
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
+        "cmdUnderTest": "$TC actions add action ct index 42 cookie deadbeef",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct zone 0 pipe.*index 42 ref.*cookie deadbeef",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
         "id": "9f20",
         "name": "Add ct clear action",
         "category": [
@@ -48,6 +72,30 @@
         ]
     },
     {
+        "id": "0bc1",
+        "name": "Add ct clear action with cookie of max length",
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
+        "cmdUnderTest": "$TC actions add action ct clear index 42 cookie aa11bb22cc33dd44ee55ff66aa11b1b2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct clear pipe.*index 42 ref.*cookie aa11bb22cc33dd44ee55ff66aa11b1b2",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
         "id": "5bea",
         "name": "Try ct with zone",
         "category": [
@@ -312,6 +360,30 @@
         ]
     },
     {
+        "id": "2faa",
+        "name": "Try ct with mark + mask and cookie",
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
+        "cmdUnderTest": "$TC actions add action ct mark 0x42/0xf0 index 42 cookie aa11bb22cc33dd44ee55ff66aa11b1b2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action ct",
+        "matchPattern": "action order [0-9]*: ct mark 66/0xf0 zone 0 pipe.*index 42 ref.*cookie aa11bb22cc33dd44ee55ff66aa11b1b2",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ct"
+        ]
+    },
+    {
         "id": "3991",
         "name": "Add simple ct action with no_percpu flag",
         "category": [
-- 
2.7.4

