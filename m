Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCDA6EBA13
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 17:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjDVP4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 11:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjDVP4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 11:56:38 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A352680
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 08:56:35 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6a5f6349ec3so1277431a34.0
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 08:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682178994; x=1684770994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/7fpClabt1h4pcpC7HxEyBgNGm9OTr9vYERAOjx5rc=;
        b=j1EgHZGzaBRiTpy1nhcjBtWw52HXceHCxhc5sGUfV0L2t9UiIYdkrCqNlCM+5xEk3C
         ixNbij7Z6oItoMEAJt2LtpmUVNdp/ziZ+8m42cjK3b2+Mbf8poTCZLWDACH+Nt2oy60i
         YkKptMeso8kG4rZARQdnyrIJsMRl0eni8b0GYc8NDnSXEPIK+5SUQVFHkf4+hg9aZu3h
         KHpHnwKRzfCaeMxZh79ULLV8kiel0acImhpZaG/Ru37teoAqgpHilTxhuJ/1ODFEgq1q
         OAKfojn2xXr/RkLNby4dlW0C+tvDG4ILhyXXQLHqU2uthK+XDlzPP7hoNngWAj9nS5qa
         754A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682178994; x=1684770994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p/7fpClabt1h4pcpC7HxEyBgNGm9OTr9vYERAOjx5rc=;
        b=Vj2oeSYUGsyZoZ03OFzPdGMnc16tl5w5poPOmp/eZpJIDjeWl1RRo2l1x8ouXHFWBN
         Z27YVR9sAkDT3LdGJhUzSgpijTwSudnXXfKdBbiez14wTeraWCCv0uqj50s44wQLrTsj
         JsGz54CZslZMNn5ISqcvProUWY+eav98Xr0hWHtVU0ikIFYASK9YnKFERVHERYZyT2B9
         NWCZE3C4kAxqq3pbgvgF4m33o5QepH527H5FE1KrQoMqlk9TOZSt1FX9pmxfH7WQyZR6
         Mb3N2k5iqDkRjnHtRH2N/rgObrbC9/lF7oP32saeipAKV0ufuN7F7h12PxUSzhgeo7Nm
         wEkw==
X-Gm-Message-State: AAQBX9duXCKpHgUKiyGmcuZGIW/MlfJ7Gs4PaA04+Of7b5harTyHkqTn
        AN/w2cvaMh0D4WDf9BDYDjheuv6ZA7YKBMtE7dQ=
X-Google-Smtp-Source: AKy350akYOZzLMJsxNVg/BCKYe1oJQt8YWQllbgL7KdzC2/1pHKi0sK2bta654U3Q9B4ceBo0oVQiw==
X-Received: by 2002:a9d:6d89:0:b0:6a5:e8da:a220 with SMTP id x9-20020a9d6d89000000b006a5e8daa220mr4803607otp.0.1682178994716;
        Sat, 22 Apr 2023 08:56:34 -0700 (PDT)
Received: from rogue-one.tail33bf8.ts.net ([2804:14d:5c5e:44fb:da55:60e0:8cc2:c48e])
        by smtp.gmail.com with ESMTPSA id v1-20020a05683018c100b006a32eb9e0dfsm2818255ote.67.2023.04.22.08.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 08:56:34 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 4/4] selftests: tc-testing: add more tests for sch_qfq
Date:   Sat, 22 Apr 2023 12:56:12 -0300
Message-Id: <20230422155612.432913-5-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230422155612.432913-1-pctammela@mojatatu.com>
References: <20230422155612.432913-1-pctammela@mojatatu.com>
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

