Return-Path: <netdev+bounces-3312-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C509B70664E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 770C4281177
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0961B1EA73;
	Wed, 17 May 2023 11:06:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60671DDDF
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:06:18 +0000 (UTC)
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F417330F8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:05:46 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-7576516c81fso67416885a.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321543; x=1686913543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BL35yyXNwClrPRFha7W8sjO2f0qLjYPdtmb6ayESYhM=;
        b=BX1DcrXoD4wahrdNMKV71S4WwZ02XHfKYZ1JXyxBP7jCbPeLApWoHCkZWDElJjcXAx
         SoQEfHXwL5D9f4ChG4gXllDXTqFyiHchat6Ud8ePumJ0vSn/MKsRytoadzESZ8RHICMS
         njUg3AKHQdglOm9Im+Pu7X4jrJEpUw2HbrMNw4Y3w9JEqHzVvYwqhIUM6eaK28VHB503
         zqiFvLi1k5T5Y6tNSwIPOyDJCN22X4jbp37jK3BwFbyvfJ0JlIT6uAm/tIz9xu2CQ8EL
         ncafof+/NmkQBsyE5I3i78THs/NP8tUDUmxIRdKAICvNMSaQ5cI0aqFepPepk+AJqLwx
         79/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321543; x=1686913543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BL35yyXNwClrPRFha7W8sjO2f0qLjYPdtmb6ayESYhM=;
        b=GkZdqt+pFcqojVrYXcC4NnQcurHLXhvg8Gne9iIZnsY8gO/JeHwCVtm+YKix9UV54Z
         zW8kXGyiMuGr/4hrpWrnMxGRXwZ61P5r5e9jai+5+81cRiahbEt+pJPj4hiWO6pK/MwV
         NmIlo7almFG9xuxPMb1tdntrWeU+Pq4vR1wXhAEJK5GzfBrG7ruOGAQgP7ZLNVK4cpyk
         WNQZXPfpR0jJ4YSQi+FGsRXSLBBx1XM5TGspDvgQFa5qd5bZILYrec5o997fj3LQaz1d
         k6wxhDcZSQ12gUa7fw0yDBRRS4MZ6oaEuUULGfINbmoqF5HXhJqn6goU+gyy8p/iUsfR
         55Sw==
X-Gm-Message-State: AC+VfDx6FipWGO+p3EoVliUV6QzgEUREJGU0WpZJXstzWT/el8w+P2an
	FVhowJaTAbvdpOMYTudoOZi8TmdhfLg72Oq+W1k=
X-Google-Smtp-Source: ACHHUZ5QlFiKdBUa+jQLksuL8zyIAGYJ8IMTtdVuaPncT8cClUD8PHe94ZYD6YorP4h6cKU+WU5uIQ==
X-Received: by 2002:a05:622a:1a21:b0:3ef:36d0:c06e with SMTP id f33-20020a05622a1a2100b003ef36d0c06emr75278258qtb.33.1684321542742;
        Wed, 17 May 2023 04:05:42 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id s16-20020a05622a1a9000b003ef573e24cfsm6945184qtc.12.2023.05.17.04.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:05:42 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: netdev@vger.kernel.org
Cc: deb.chatterjee@intel.com,
	anjali.singhai@intel.com,
	namrata.limaye@intel.com,
	tom@sipanda.io,
	p4tc-discussions@netdevconf.info,
	mleitner@redhat.com,
	Mahesh.Shirshyad@amd.com,
	Vipin.Jain@amd.com,
	tomasz.osinski@intel.com,
	jiri@resnulli.us,
	xiyou.wangcong@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	vladbu@nvidia.com,
	simon.horman@corigine.com,
	khalidm@nvidia.com,
	toke@redhat.com
Subject: [PATCH RFC v2 net-next 26/28] selftests: tc-testing: add P4TC register tdc tests
Date: Wed, 17 May 2023 07:02:30 -0400
Message-Id: <20230517110232.29349-26-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517110232.29349-1-jhs@mojatatu.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 .../tc-testing/tc-tests/p4tc/register.json    | 2752 +++++++++++++++++
 1 file changed, 2752 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/register.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/p4tc/register.json b/tools/testing/selftests/tc-testing/tc-tests/p4tc/register.json
new file mode 100644
index 000000000000..64c54a493277
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/p4tc/register.json
@@ -0,0 +1,2752 @@
+[
+    {
+        "id": "c312",
+        "name": "Create valid register",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/my_reg type bit32 numelems 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit32",
+                        "startbit": 0,
+                        "endbit": 31,
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "6240",
+        "name": "Create valid register with num_elems == P4TC_MAX_REGISTER_ELEMS",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/my_reg type bit32 numelems 128",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit32",
+                        "startbit": 0,
+                        "endbit": 31,
+                        "numelems": 128
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "849c",
+        "name": "Try to create register with num_elems > P4TC_MAX_REGISTER_ELEMS",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/my_reg type bit32 numelems 129",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchPattern": "Error: Register name not found",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "062d",
+        "name": "Try to create register with unknown type",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/my_reg type invalid123 numelems 128",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchPattern": "Error: Register name not found",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "b811",
+        "name": "Try to create register with num_elems = 0",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/my_reg type bit32 numelems 0",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchPattern": "Error: Register name not found",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "6428",
+        "name": "Try to create register without specifying type",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/my_reg numelems 2",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchPattern": "Error: Register name not found",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "a989",
+        "name": "Try to create register without specifying register name or id",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables type bit32 numelems 129",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchPattern": "Error: Register name not found",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "40a0",
+        "name": "Try to create register without specifying pipeline name or id",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ type bit32 numelems 129",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchPattern": "Error: Register name not found",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "004c",
+        "name": "Try to create register with name > REGISTERNAMSIZ",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/7eozFYyaqVCD7H0xS3M5sMnluUqPgZewfSLnYPf4s3k0lbx8lKoR32zSqiGsh84qJ32vnLPdl7f2XcUh5yIdEP7uJy2C3iPtyU7159s9CMB0EtTAlWTVz4U1jkQ5h2advwp3KCVsZ1jlGgStoJL2op5ZxoThTSUQLR61a5RNDovoSFcq86Brh6oW9DSmTbN6SYygbG3JLnEHzRC5hh0jGmJKHq5ivBK9Y9FlNZQXC9wVwX4qTFAd8ITUTj2Au2Jg1 type bit32 numelems 127",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchPattern": "Error: Register name not found",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "6d37",
+        "name": "Create valid register with type bit 37",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/my_reg type bit37 numelems 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit64",
+                        "startbit": 0,
+                        "endbit": 36,
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "ec58",
+        "name": "Create valid register with signed type",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/my_reg type int37 numelems 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "int64",
+                        "startbit": 0,
+                        "endbit": 36,
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "d2ee",
+        "name": "Try to create register with type int129",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/my_reg type int129 numelems 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchPattern": "Error: Register name not found",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "50d1",
+        "name": "Create valid register with type ipv4",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/my_reg type ipv4 numelems 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "ipv4",
+                        "startbit": 0,
+                        "endbit": 31,
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "418b",
+        "name": "Try to create register with same name twice",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit56 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/my_reg type ipv4 numelems 2",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit64",
+                        "startbit": 0,
+                        "endbit": 55,
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "095d",
+        "name": "Try to create register with same id twice",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit56 regid 1 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/my_reg2 regid 1 type ipv4 numelems 2",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit64",
+                        "startbit": 0,
+                        "endbit": 55,
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "4ecf",
+        "name": "Update register index 0 with value 256",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit56 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ptables/my_reg index 0 value constant.bit56.256",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit64",
+                        "startbit": 0,
+                        "endbit": 55,
+                        "values": [
+                            {
+                                "my_reg[0]": 256
+                            },
+                            {
+                                "my_reg[1]": 0
+                            }
+                        ],
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "1af9",
+        "name": "Update register index 1 with value 62",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit32 regid 1 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ptables/my_reg index 1 value constant.bit32.62",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/ regid 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit32",
+                        "startbit": 0,
+                        "endbit": 31,
+                        "values": [
+                            {
+                                "my_reg[0]": 0
+                            },
+                            {
+                                "my_reg[1]": 62
+                            }
+                        ],
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "9f4d",
+        "name": "Update register specifying pipeid",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit56 regid 1 numelems 2",
+                0
+            ],
+            [
+                "$TC p4template update register/ptables/my_reg index 0 value constant.bit56.123",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ pipeid 22 regid 1 index 1 value constant.bit56.0x123",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/ regid 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit64",
+                        "startbit": 0,
+                        "endbit": 55,
+                        "values": [
+                            {
+                                "my_reg[0]": 123
+                            },
+                            {
+                                "my_reg[1]": 291
+                            }
+                        ],
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "6181",
+        "name": "Update register index 0 and check only value of index 0",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit56 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ptables/my_reg index 0 value constant.bit56.256",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg index 0",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit64",
+                        "my_reg[0]": 256
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "3d3d",
+        "name": "Update register index 1 and check only value of index 1",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit56 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ptables/my_reg index 1 value constant.bit56.0x123",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg index 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit64",
+                        "my_reg[1]": 291
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "cd47",
+        "name": "Update register index 127 and check only value of index 127",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit44 numelems 128",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ptables/my_reg index 127 value constant.bit44.0x1234",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg index 127",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit64",
+                        "my_reg[127]": 4660
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "8966",
+        "name": "Try to update register with index out of range",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit44 numelems 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ptables/my_reg index 0 value constant.bit44.0x1234",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg index 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Register index out of bounds",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "77b3",
+        "name": "Try to update register index 1 and numelems",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit56 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ptables/my_reg index 1 value constant.bit56.25 numelems 22",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit64",
+                        "startbit": 0,
+                        "endbit": 55,
+                        "values": [
+                            {
+                                "my_reg[0]": 0
+                            },
+                            {
+                                "my_reg[1]": 0
+                            }
+                        ],
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "fd51",
+        "name": "Try to update register index out of bounds",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit56 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ptables/my_reg index 2 value constant.bit56.22",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit64",
+                        "startbit": 0,
+                        "endbit": 55,
+                        "values": [
+                            {
+                                "my_reg[0]": 0
+                            },
+                            {
+                                "my_reg[1]": 0
+                            }
+                        ],
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "7b36",
+        "name": "Try to update inexistent register",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ptables/my_reg index 0 value constant.int32.0x12",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchPattern": "Error: Register name not found",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "1079",
+        "name": "Try to update register without specifying pipeline name or id",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit56 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ index 0 value constant.bit56.2",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit64",
+                        "startbit": 0,
+                        "endbit": 55,
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "8199",
+        "name": "Try to update register without specifying register name or id",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit56 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ pipeid 22 index 0 value constant.bit56.2",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit64",
+                        "startbit": 0,
+                        "endbit": 55,
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "6520",
+        "name": "Try to update register with bitsz bigger than bit64",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg type bit56 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ pipeid 22 index 0 value constant.bit77.2",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit64",
+                        "startbit": 0,
+                        "endbit": 55,
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "d3b4",
+        "name": "Try to update register index with wrong type",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg regid 1 type bit24 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ regid 1 pipeid 22 index 0 value constant.bit33.2",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit32",
+                        "startbit": 0,
+                        "endbit": 23,
+                        "values": [
+                            {
+                                "my_reg[0]": 0
+                            },
+                            {
+                                "my_reg[1]": 0
+                            }
+                        ],
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "7154",
+        "name": "Try to update register index with bit32 when type is bit24",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg regid 1 type bit24 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ regid 1 pipeid 22 index 0 value constant.bit32.0xFFFFFFFF",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit32",
+                        "startbit": 0,
+                        "endbit": 23,
+                        "values": [
+                            {
+                                "my_reg[0]": 0
+                            },
+                            {
+                                "my_reg[1]": 0
+                            }
+                        ],
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "eeef",
+        "name": "Try to update register index with constant bit24 doesn't fix in bit24",
+        "category": [
+            "p4tc",
+            "template",
+            "register"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/my_reg regid 1 type bit24 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update register/ regid 1 pipeid 22 index 0 value constant.bit24.0xFFFFFFFF",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/my_reg",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "my_reg",
+                        "regid": 1,
+                        "containertype": "bit32",
+                        "startbit": 0,
+                        "endbit": 23,
+                        "values": [
+                            {
+                                "my_reg[0]": 0
+                            },
+                            {
+                                "my_reg[1]": 0
+                            }
+                        ],
+                        "numelems": 2
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "1f5e",
+        "name": "Dump registers using pname to find pipeline",
+        "category": [
+            "p4tc",
+            "template",
+            "metadata"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/reg1 type bit8 numelems 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/reg2 type bit27 numelems 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "register"
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "reg1"
+                    },
+                    {
+                        "regname": "reg2"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "08c9",
+        "name": "Dump registers using pipeid to find pipeline",
+        "category": [
+            "p4tc",
+            "template",
+            "metadata"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/reg1 type bit8 numelems 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/reg2 type bit27 numelems 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ pipeid 22",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "register"
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "reg1"
+                    },
+                    {
+                        "regname": "reg2"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "9782",
+        "name": "Try to dump registers without specifying pipeline name or id",
+        "category": [
+            "p4tc",
+            "template",
+            "metadata"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/reg1 type bit8 numelems 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create register/ptables/reg2 type bit27 numelems 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/",
+        "matchCount": "1",
+        "matchPattern": "Must specify pipeline name or id.*",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "2781",
+        "name": "Delete register by name",
+        "category": [
+            "p4tc",
+            "template",
+            "registers"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/register1 type bit8 numelems 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template del register/ptables/register1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/register1",
+        "matchCount": "1",
+        "matchPattern": "Error: Register name not found",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "50d2",
+        "name": "Delete register by id",
+        "category": [
+            "p4tc",
+            "template",
+            "registers"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/register1 regid 5 type bit8 numelems 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template del register/ptables/ regid 5",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/ regid 5",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find register by id",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "0b3c",
+        "name": "Delete register specifying pipeid",
+        "category": [
+            "p4tc",
+            "template",
+            "registers"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/register1 regid 5 type bit8 numelems 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template del register/ pipeid 22 regid 5",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/ regid 5",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find register by id",
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "cd7f",
+        "name": "Try to delete register without specifying pipeline name or id",
+        "category": [
+            "p4tc",
+            "template",
+            "registers"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/register1 regid 5 type bit8 numelems 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template del register/",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get register/ptables/register1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "obj": "register",
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "templates": [
+                    {
+                        "regname": "register1",
+                        "regid": 5,
+                        "containertype": "bit8",
+                        "startbit": 0,
+                        "endbit": 7,
+                        "numelems": 1
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "07cf",
+        "name": "Flush registers",
+        "category": [
+            "p4tc",
+            "template",
+            "registers"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/register1 type bit8 numelems 1",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/register2 type bit21 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template del register/ptables/",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ptables/",
+        "matchCount": "1",
+        "matchJSON": [],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    },
+    {
+        "id": "b69d",
+        "name": "Flush registers specifying pipeline id",
+        "category": [
+            "p4tc",
+            "template",
+            "registers"
+        ],
+        "setup": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions flush action gact",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action pass index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 2 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/register1 type bit8 numelems 1",
+                0
+            ],
+            [
+                "$TC p4template create register/ptables/register2 type bit21 numelems 2",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template del register/ pipeid 22",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get register/ pipeid 22",
+        "matchCount": "1",
+        "matchJSON": [],
+        "teardown": [
+            [
+                "$TC p4template del pipeline/ptables",
+                0
+            ],
+            [
+                "$TC actions flush action gact",
+                0
+            ]
+        ]
+    }
+]
-- 
2.25.1


