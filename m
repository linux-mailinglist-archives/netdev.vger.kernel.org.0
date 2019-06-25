Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8027556FA
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732890AbfFYSTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:19:00 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:36669 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbfFYSS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:18:59 -0400
Received: by mail-io1-f52.google.com with SMTP id h6so3657823ioh.3
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=9mN0CNjPspvWdwS7V19zJcu+0i+HHyy4HV9R6mHSblY=;
        b=SQpADY0l3VPAnSV8/zKaLY4U8GPGGtw+4g+znP2mWD+C/6LohUe3FVxTdxKsVxbrzs
         2B25pGxyzYpIBDCTWuwYLKWQLnmfv0LVG7iY2DkcJFdJ0ks0fpitG79QsTBi5Rx0eqVF
         KIXnl09dboujW1F78aO1R5DxQP5CxaLIKwUzaSdaJoi404xXApvvRDV1BmqYHF8BU9aZ
         Q6ODARnmrbY/J5mNI0303ryxQu63rJTdaG/AIhcswGWT7/SC7X/LZBYxqdHzU6Rn37z7
         yLLzZMkQuFHu2M9qN9f63RxMzsIkFi5iU+DhZDgyt8/fobmg401nxAftZDvkJTIhogse
         a5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9mN0CNjPspvWdwS7V19zJcu+0i+HHyy4HV9R6mHSblY=;
        b=dXEeY4HEV/5G9ZY9VZ6bqJ62Vwmnh4tH4dxSwUbNMrYFwtzfmmgxBoZ6BJ/j86h8fp
         eEo67Eqb5GivCNW5KK5mfs3PPBr7F3tQHMbjcH0QBr/f1p7D5rzmzBW+qyZN9TOv2sbD
         oZWE241FCTxIMwBRWjA/KQcokOaSvpEYx0XygoLZndcAW0G216F1E8vSbbu/OYwaZ7g+
         jbFEXSBSreLGE66puKYQ8V+63krlbOawUR3aRbANYPCESoqRbcEnRELSBPmrKTkt+Nnk
         zJAQonDA64HwR0sPs/HVXl0SUQZh8kfRLSANFqNAQBNOzokZto/GLVJxBqruK8+28/aZ
         qOfA==
X-Gm-Message-State: APjAAAXZ3Dz3PmRIJu0lVTvveJiu0s+du20gDfzlw7WRhWw4VdWQS9J0
        JMzEigEzCGCgCcz4WhX21TP/2Gu0gvw=
X-Google-Smtp-Source: APXvYqzTdINQThJdNHBqYnDqfGGIWeQacIUf/0b8MP5MzV/gUMY0FbzSl1QnBi0pA7wxvH98bTXt4g==
X-Received: by 2002:a6b:7909:: with SMTP id i9mr6251447iop.8.1561486738918;
        Tue, 25 Jun 2019 11:18:58 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id m4sm14408626iok.68.2019.06.25.11.18.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 25 Jun 2019 11:18:58 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: add ingress qdisc tests
Date:   Tue, 25 Jun 2019 14:18:52 -0400
Message-Id: <1561486732-5070-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/qdiscs/ingress.json        | 102 +++++++++++++++++++++
 1 file changed, 102 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/ingress.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ingress.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ingress.json
new file mode 100644
index 000000000000..f518c55f468b
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ingress.json
@@ -0,0 +1,102 @@
+[
+    {
+        "id": "9872",
+        "name": "Add ingress qdisc",
+        "category": [
+            "qdisc",
+            "ingress"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 ingress",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc ingress ffff:",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "5c5e",
+        "name": "Add ingress qdisc with unsupported argument",
+        "category": [
+            "qdisc",
+            "ingress"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 ingress foorbar",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc ingress ffff:",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "74f6",
+        "name": "Add duplicate ingress qdisc",
+        "category": [
+            "qdisc",
+            "ingress"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 ingress",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc ingress ffff:",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "f769",
+        "name": "Delete nonexistent ingress qdisc",
+        "category": [
+            "qdisc",
+            "ingress"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DEV1 ingress",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc ingress ffff:",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "3b88",
+        "name": "Delete ingress qdisc twice",
+        "category": [
+            "qdisc",
+            "ingress"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC qdisc del dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DEV1 ingress",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc ingress ffff:",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    }
+]
-- 
2.7.4

