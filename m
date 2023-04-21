Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C416C6EB13D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbjDURyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbjDURyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:54:20 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237712109
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:54:19 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-6a5e905e15aso899610a34.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682099658; x=1684691658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/7fpClabt1h4pcpC7HxEyBgNGm9OTr9vYERAOjx5rc=;
        b=kKHEhvhi5X9v79lAnk62wuG3F2ZBKRJ/RIhY0ooY81x+TaF6RK/dkyaYjk6EerJrwT
         XLuvwFSba4p4GWS66a4F+SolJ2XGqQviDtRppZxtO49qnqyMcqYhc/UrInM6qrIzNcLR
         fWodLpFfuOeAUCS2lnMmXwzqto25w1gNIbnMTDTVfohrELiIXSg6XnEfb+PPuJhrvSEy
         eLwJ/g0gSYHXxxuICJupcspsh+8mp3yV+TPxuY6XRAkTTZKRTK56oEszSBmpxUWK934e
         WzSRRjlYBdsjjCRDw0DHr2rjrPB2yWgUiQTrawjprthqUzVLJ7bpuCQXuPtv+ltUXTwV
         dtAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682099658; x=1684691658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p/7fpClabt1h4pcpC7HxEyBgNGm9OTr9vYERAOjx5rc=;
        b=PfYbUgh2hoj8xSBjL+h6DPbMls33lGSlGy5N6mPqJ5JEh30emWst361fDh3OHU+tHq
         oHThKIbHE9oEKS4r5Pg/SQmfqSxN8oR/TMqIl+cP1O9jmEgXmUEouO5w5IU+uc48IzAZ
         c553qylSQEeVtVBB0YI516cqQh1y/WWlUQs86bp3aMnpfS09l6RgArkb0XgHSLWysRe9
         Pr+EwhlJBUO3bMOrv9JjfFay899EEFdkw/sOtMY4WYOL7pTSqavkNKTRMOYvkUFiOnrL
         zl2aTMH0hfzJtgeOjfA9Y2KK9K83RU76MbySIS8KRTQYJiDZKKw1rGQSu8mgFkktzTsB
         3+sw==
X-Gm-Message-State: AAQBX9dh75OY3cdLi33fC4OSVrcOVoa3FmOjeA7KqJs/fjyk9Qx1Kt/u
        cVT+FPZpJDVFwrFr5RXClUGnWZJ0rjfxg4Mt6p4=
X-Google-Smtp-Source: AKy350awwlT7B7pJ8pQQ6cbzYe5V0chAJKhg+s2YEkzJJimPXA1paZbyiLchYdbfxw0BFkOMLwR9lg==
X-Received: by 2002:a9d:77cb:0:b0:6a6:2d87:e2ec with SMTP id w11-20020a9d77cb000000b006a62d87e2ecmr2987735otl.14.1682099658302;
        Fri, 21 Apr 2023 10:54:18 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id e3-20020a9d5603000000b006a633d75310sm850426oti.16.2023.04.21.10.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 10:54:18 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 4/4] selftests: tc-testing: add more tests for sch_qfq
Date:   Fri, 21 Apr 2023 14:53:44 -0300
Message-Id: <20230421175344.299496-5-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421175344.299496-1-pctammela@mojatatu.com>
References: <20230421175344.299496-1-pctammela@mojatatu.com>
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

