Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A2A6E4EE7
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjDQRMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjDQRMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:12:47 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E31F2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:12:45 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id w15-20020a056830410f00b006a386a0568dso19884108ott.4
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681751564; x=1684343564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/7fpClabt1h4pcpC7HxEyBgNGm9OTr9vYERAOjx5rc=;
        b=tzuHy+Q9wuaK2d5QCbPDSXitKZIB15wfbz/rUhHB6E7JCa2YtqgDsDycQl324QeqJm
         sMBaXnUEYqnwiCDR8DN/NgVXbtdUvKzM/U/vw9dR+CyBp57e03+Jhzoo6fsFWDH3iSS1
         wB1qc5/VcqNT/vEg7u5dN78WyWFlrgHMxMXWbLgB4JWZ0Mmf0muT0LAkf9JtKAzTb5PU
         izh/HHcM0Gz+Ftjp2OBdhRVaeX53bVz/MZfrekIL8SOIvzqtv4XvDx6w7uRSGSHbzvZY
         aJUxrqiLG3vwfok1qKgiuhgbR9Q55+PttGAN/4S4ZSNt9heWlUhPa4Dzi7ZajidmCRVv
         vZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681751564; x=1684343564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p/7fpClabt1h4pcpC7HxEyBgNGm9OTr9vYERAOjx5rc=;
        b=k2/dN6LJpj8JcMkOpsy09QcZCXRE6gJTjDW7ygOCm9hzM4PpJVLI7nf30dDlpV52E6
         nzV0BfRtbNsdxWU6Vcx7oNT3P/ytQJOUhPUv8uZVlSGfTRVgedPDA2tmjIRWy2PaD3SN
         vfDLMhdvLcPe2L4Bt7w3/f1VtnjTq1LExbrYhvegRzNjzxnWRrgDE84VuECpZO6xNhjy
         QMiVBSNuOkutT+InncJwAJ5HTqB/AGRyLtofBT9S/Qccff1QYqdOLueVsmZzKltPpsr/
         q1FxO+REtnX6MZwLAYdN0dAhiQLAS8llEId4GzoDoNawkWJvr6Tn/lCvyd0mIik/uqrg
         vBZA==
X-Gm-Message-State: AAQBX9fD2sbb7RQ7z9rvSQ4M+CNusQx/IPWx6MVeiCmfLUbDLQz7RLnN
        f7EwBLkz/3M6vJ8ZnAKzjBkMvmC8KxUT1LkvJOw=
X-Google-Smtp-Source: AKy350b1FTyNbmMo9Q4Dv5Py7ZRknTpiZ0oi+KkO+ontzSnCV7+21zGASB+4qRv1ULf7FdAgnoxGjw==
X-Received: by 2002:a9d:7ad1:0:b0:6a5:f62d:471d with SMTP id m17-20020a9d7ad1000000b006a5f62d471dmr250057otn.34.1681751564676;
        Mon, 17 Apr 2023 10:12:44 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:150:be5b:9489:90ac])
        by smtp.gmail.com with ESMTPSA id v17-20020a9d5a11000000b006a205a8d5bdsm4761248oth.45.2023.04.17.10.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 10:12:44 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 4/4] selftests: tc-testing: add more tests for sch_qfq
Date:   Mon, 17 Apr 2023 14:12:18 -0300
Message-Id: <20230417171218.333567-5-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417171218.333567-1-pctammela@mojatatu.com>
References: <20230417171218.333567-1-pctammela@mojatatu.com>
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

The QFQ qdisc class has parameter bounds that are not being
checked for correctness.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 .../tc-testing/tc-tests/qdiscs/qfq.json       | 72 +++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/qfq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/qfq.json
index 330f1a25e0ab..147899a868d3 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/qfq.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/qfq.json
@@ -46,6 +46,30 @@
             "$IP link del dev $DUMMY type dummy"
         ]
     },
+    {
+        "id": "d364",
+        "name": "Test QFQ with max class weight setting",
+        "category": [
+            "qdisc",
+            "qfq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root qfq"
+        ],
+        "cmdUnderTest": "$TC class add dev $DUMMY parent 1: classid 1:1 qfq weight 9999",
+        "expExitCode": "2",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class qfq 1:1 root weight 9999 maxpkt",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
     {
         "id": "8452",
         "name": "Create QFQ with class maxpkt setting",
@@ -70,6 +94,54 @@
             "$IP link del dev $DUMMY type dummy"
         ]
     },
+    {
+        "id": "22df",
+        "name": "Test QFQ class maxpkt setting lower bound",
+        "category": [
+            "qdisc",
+            "qfq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root qfq"
+        ],
+        "cmdUnderTest": "$TC class add dev $DUMMY parent 1: classid 1:1 qfq maxpkt 128",
+        "expExitCode": "2",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class qfq 1:1 root weight 1 maxpkt 128",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "92ee",
+        "name": "Test QFQ class maxpkt setting upper bound",
+        "category": [
+            "qdisc",
+            "qfq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root qfq"
+        ],
+        "cmdUnderTest": "$TC class add dev $DUMMY parent 1: classid 1:1 qfq maxpkt 99999",
+        "expExitCode": "2",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class qfq 1:1 root weight 1 maxpkt 99999",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
     {
         "id": "d920",
         "name": "Create QFQ with multiple class setting",
-- 
2.34.1

