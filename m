Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35A53DE103
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhHBUvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbhHBUvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:51:08 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0F9C06175F;
        Mon,  2 Aug 2021 13:50:58 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id w10so12598004qtj.3;
        Mon, 02 Aug 2021 13:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cI3bAw8ypmiDHJdkJBXoE/YVWFtSuOmaJtoMVmodDns=;
        b=df+Nxs07hhZVldp5Si0NYQLfbLRt8i7Mw869Pdb/LIBoaZNpqGq8RZMVNst6CzxuXJ
         JPslwzdvx9RBZrHA8dcACcLvLu9/RpRXy2b+JIqBirQvw1vD2WWAZV4bDqyndC/qtLMK
         dCgPmROybIJ8/5fX5kT1JwdMdj4yXELSJbs1Kdv+TBw+3x8M5ZtFrYVLIuccrRTYzT6e
         wY3v0CTGnblF3pSsusQGAhXzqb2UwEatgSOY5S0q68UAf7nLoAFMXEW7RUTYA4GnW44F
         vcRcmp6ZX9ljfSSuFzcaNl+MR+eiS8vwyGUyD2z9QV+SLJChADH6sdl//hA81A1VNSu9
         kchA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cI3bAw8ypmiDHJdkJBXoE/YVWFtSuOmaJtoMVmodDns=;
        b=ISWqBeC8QDlGTSPpQXK5U5ie//fD9g4jfbAnoRUeESguXvAm6acI3Gfy25gqR6VpRy
         aG75DRFLSowMehE41TfX+wYiSdOnXXTBVbf+IF7dKns5q8u3bADkzDoQlpO+71bIgp4Y
         cK4uQMkdWC1ZWcUlNXIWgEtCIUCVLt7M3lHJQZmeZRZDnD+D9cqDHb4FbojuVy5nekbH
         QJbAxsyuww4yS+/2WcMqPkPBrj5Av7lVTojLR43KngsCiK869y1RcuSt5T822tVXfeND
         AlpBDhGM8zU6nNplHhwAEMz1QcH1AasClaIPm/PcFtdEr+aU9nLusIoeExmLlz9by8XH
         SYcg==
X-Gm-Message-State: AOAM531wz/KWBBb34ThsiMNn8ZbnQzQSt+j411AbnIgsJ+UMp2tct1xc
        h7bqDcHyaIai3j7wnfcfjg==
X-Google-Smtp-Source: ABdhPJzTB7qbhI8W9WNQjiD8aM6UxJAT1AHXEltCXm7G9PSLr8Y4uZ8p0UFPfAtH0h0pG4HpimknGg==
X-Received: by 2002:ac8:7e86:: with SMTP id w6mr16025808qtj.194.1627937457370;
        Mon, 02 Aug 2021 13:50:57 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id f12sm6570944qke.37.2021.08.02.13.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 13:50:56 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Shuah Khan <shuah@kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next 2/2] tc-testing/ingress: Add control-plane selftests for clsact egress mini-Qdisc option
Date:   Mon,  2 Aug 2021 13:50:36 -0700
Message-Id: <165f9fb53d04c62e11f87c98ee317fb9a5aaa277.1627936393.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <1931ca440b47344fe357d5438aeab4b439943d10.1627936393.git.peilin.ye@bytedance.com>
References: <1931ca440b47344fe357d5438aeab4b439943d10.1627936393.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Recently we added a new clsact egress mini-Qdisc option for sch_ingress.
Add a few control-plane tdc.py selftests for it.

Depends on kernel patch "net/sched: sch_ingress: Support clsact egress
mini-Qdisc option", as well as iproute2 patch "tc/ingress: Introduce
clsact egress mini-Qdisc option".

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 .../tc-testing/tc-tests/qdiscs/ingress.json   | 84 +++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ingress.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ingress.json
index d99dba6e2b1a..2cde11b2ea9b 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ingress.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ingress.json
@@ -98,5 +98,89 @@
         "teardown": [
             "$IP link del dev $DUMMY type dummy"
         ]
+    },
+    {
+        "id": "8e8c",
+        "name": "Enable clsact egress mini-qdisc for ingress",
+        "category": [
+            "qdisc",
+            "ingress"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress"
+        ],
+        "cmdUnderTest": "$TC qdisc change dev $DUMMY ingress clsact-on",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ingress ffff:.*clsact",
+        "matchCount": "1",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "3a76",
+        "name": "Disable clsact egress mini-qdisc for ingress",
+        "category": [
+            "qdisc",
+            "ingress"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC qdisc change dev $DUMMY ingress clsact-on"
+        ],
+        "cmdUnderTest": "$TC qdisc change dev $DUMMY ingress clsact-off",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ingress ffff:.*clsact",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "7b2b",
+        "name": "Enable clsact egress mini-qdisc for ingress twice",
+        "category": [
+            "qdisc",
+            "ingress"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC qdisc change dev $DUMMY ingress clsact-on"
+        ],
+        "cmdUnderTest": "$TC qdisc change dev $DUMMY ingress clsact-on",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ingress ffff:.*clsact",
+        "matchCount": "1",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "05ab",
+        "name": "Disable clsact egress mini-qdisc for ingress twice",
+        "category": [
+            "qdisc",
+            "ingress"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC qdisc change dev $DUMMY ingress clsact-on",
+            "$TC qdisc change dev $DUMMY ingress clsact-off"
+        ],
+        "cmdUnderTest": "$TC qdisc change dev $DUMMY ingress clsact-off",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc ingress ffff:.*clsact",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
     }
 ]
-- 
2.20.1

