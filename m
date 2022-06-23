Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BF6557D8B
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 16:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbiFWOI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 10:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiFWOI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 10:08:59 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B38E3FBDB
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 07:08:58 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id be10so163377oib.7
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 07:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IG4oUKkrB4bYBI1MSMaIFP7r56qaPXw8VuAaT8en5sw=;
        b=ZF0u6ezcv2SRLZWdjBRUrgrIW7rMicXu6eo1PW/ctnF8MNi4XNQM8qKwHWFoBzGgc6
         K3fVKPnWWb94dQ/E4h/9iBatPqLr65bq5sT3a4MhtP9QJv8ao0kKvaM+DzQc09pEqVWh
         ePqPfHuNN5TZ1vUIYsEix2Wy4SP9Pg/9f3uMc/LpMEIFOy+k4qMtgdns3j7D4i9hGXGy
         B/bPXya7Jo+p2lioFA82IHbHbZRBhDbjM3SFJLEMVFUIZdDRSdSBX7whU4G8SNioPC+T
         t+S16e37Eyu/imosdaK7IKj7ch3kIVOcaRXYqBzei3rpzLalweFYURZBW9P85/Rg0L/c
         bOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IG4oUKkrB4bYBI1MSMaIFP7r56qaPXw8VuAaT8en5sw=;
        b=eFO2+R07p8r8PUC18BRa846P9RxEJ0KhltykxLaJeNLPON8zirXIk9SYu3aYu4gt++
         ojrE5sKCuC3PfCNXZHlPxxp4IarYfCW1uROAM2Qm1rfBabsPUdcHVvuMr2w2F91vBxAE
         GqNCIejw8dKyrK4JtLhM8ECIdHNguL5yPNwrM/EzBnjdXg5h6rBjTV19j9BZH41wjl63
         LsKFX2+BxDsH0C7Wifup4Z8ybFYaCvVjKFMkZ1eXqqhcfd7Am5YAFqnbq+jHf2gFbn9N
         eP1OADkv7o/WJXXGzr+dUHajv90yrU1y6/OEvCfJLYkoG0zP6WyiXiMsq9g+oad4zEQN
         mwmA==
X-Gm-Message-State: AJIora+oIg1liIzHzlc3I8TGzZbTdrDxFHp3TNREUHbO/+rf/UDiot9V
        SLpCxtHBcLs3K09ce79LpDxV+g==
X-Google-Smtp-Source: AGRyM1sHc9PZeNGthJkx8J/T9Jl6B+2gOZ53rwS9JzTtKwkOg/ICb7/vit4IK7DgoR0Mdww9IrvDvQ==
X-Received: by 2002:a05:6808:130d:b0:32f:4d01:c4c9 with SMTP id y13-20020a056808130d00b0032f4d01c4c9mr2397745oiv.52.1655993337864;
        Thu, 23 Jun 2022 07:08:57 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:7002:4b2f:1099:d9a9:ed70:bc8f])
        by smtp.gmail.com with ESMTPSA id c83-20020aca3556000000b0032b99637366sm12760903oia.25.2022.06.23.07.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 07:08:56 -0700 (PDT)
From:   Victor Nogueira <victor@mojatatu.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net 2/2] selftests: tc-testing: Add testcases to test new flush behaviour
Date:   Thu, 23 Jun 2022 11:07:42 -0300
Message-Id: <20220623140742.684043-3-victor@mojatatu.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623140742.684043-1-victor@mojatatu.com>
References: <20220623140742.684043-1-victor@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tdc test cases to verify new flush behaviour is correct, which do
the following:

- Try to flush only one action which is being referenced by a filter
- Try to flush three actions where the last one (index 3) is being
  referenced by a filter

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
---
 .../tc-testing/tc-tests/actions/gact.json     | 77 +++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/gact.json b/tools/testing/selftests/tc-testing/tc-tests/actions/gact.json
index b24494c6f546..c652e8c1157d 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/gact.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/gact.json
@@ -609,5 +609,82 @@
         "teardown": [
             "$TC actions flush action gact"
         ]
+    },
+    {
+        "id": "7f52",
+        "name": "Try to flush action which is referenced by filter",
+        "category": [
+            "actions",
+            "gact"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC actions add action pass index 1",
+            "$TC filter add dev $DEV1 protocol all ingress prio 1 handle 0x1234 matchall action gact index 1"
+        ],
+        "cmdUnderTest": "$TC actions flush action gact",
+        "expExitCode": "1",
+        "verifyCmd": "$TC actions ls action gact",
+        "matchPattern": "total acts 1.*action order [0-9]*: gact action pass.*index 1 ref 2 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            [
+                "sleep 1; $TC actions flush action gact",
+                0,
+                1
+            ]
+        ]
+    },
+    {
+        "id": "ae1e",
+        "name": "Try to flush actions when last one is referenced by filter",
+        "category": [
+            "actions",
+            "gact"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            "$TC qdisc add dev $DEV1 ingress",
+	    [
+                "$TC actions add action pass index 1",
+		0,
+		1,
+		255
+	    ],
+            "$TC actions add action reclassify index 2",
+            "$TC actions add action drop index 3",
+            "$TC filter add dev $DEV1 protocol all ingress prio 1 handle 0x1234 matchall action gact index 3"
+        ],
+        "cmdUnderTest": "$TC actions flush action gact",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions ls action gact",
+        "matchPattern": "total acts 1.*action order [0-9]*: gact action drop.*index 3 ref 2 bind 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress",
+            [
+                "sleep 1; $TC actions flush action gact",
+                0,
+                1
+            ]
+        ]
     }
 ]
-- 
2.36.1

