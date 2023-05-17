Return-Path: <netdev+bounces-3307-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FF2470663F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 097601C20F72
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528C51C76D;
	Wed, 17 May 2023 11:05:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378D91DDC6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:05:30 +0000 (UTC)
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA051BE3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:05:14 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id af79cd13be357-75788255892so34917085a.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321513; x=1686913513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=adIFye+pIPwd8yz03ApDYM1/ixCRHXi7tQYaKa8oWj8=;
        b=YCP1MwKlpHcSzW9GivtF1gqzs2Ar5ApXRFbMAQnW2zRwL1wnyq0N1gjXYxJS5j8uYm
         9YuMfbucbKd9V2ZRF8k2qA860PaZa8t6EsYExyUBpxQUPGvuT6VoNC4wq4Ocmc1poCMr
         UQhQ7/QCdMPRud1gsGGktiujDEAYzpicyU9DPDI7Fjf1p16ScPFrOyWqUtwbfdB0wLmV
         FPJpdJsxy4xCWEmJ7Y08QKt39xo/zfp5t1q/wbPuIQ86oEBaqFiLEqLv7txezg2a7W1I
         seEMpEd5qv/oS2xCINuT/S02unchuN+BaRvGKp1E2LThVDlVxfDLfyJ0lJPfqg0EDHFx
         U95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321513; x=1686913513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=adIFye+pIPwd8yz03ApDYM1/ixCRHXi7tQYaKa8oWj8=;
        b=iFcHBlqg9TusKpZEPBNXivlWLKA1ETsR/IK+vljf88D9egLNOHGfE6EZ+PW8wQmhce
         kzPusJ0ls4U28Gw+5Wj+D8RBDSWMVHh2DgP8GmzRJ1vX4CGXQSjaRPoiTeuQQD6zJnDT
         6kQ35k25T/Jn8vyJsdaT3nL3/ThkgSPjBLgM5w20jZ2r7Mzehq8KA79/qywj6FSpm0Xr
         rVbhPzMm22kJ8syYsI+VjM2QcVTS95ruYScbWw6KF4x2EPltYTXT9YN7bGChEv3kayAW
         BOUXaaHj/QV903zvYXysR11EEbz86jfQOYVnoJJQ2iGInhmV7pGFAHuv61j6fLqRukZH
         ETyg==
X-Gm-Message-State: AC+VfDyJA8hCTL1Uwy16gcw/09rgsrYhuw5V1qKoHPK9x+yLqByMQtRw
	Zgs2QZHb6FPu7qf6U7zn13s8Cd56Dvk7he8auWs=
X-Google-Smtp-Source: ACHHUZ4LVswMQihqM8tC266S3bhkPt3BhFBWYGFnGG+AcY0bW4rCC1oJbY65UOAScpIiM1QrE/hlvQ==
X-Received: by 2002:ac8:5b86:0:b0:3f3:a0c0:cd6f with SMTP id a6-20020ac85b86000000b003f3a0c0cd6fmr44408133qta.9.1684321511810;
        Wed, 17 May 2023 04:05:11 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id bb13-20020a05622a1b0d00b003f521882bc1sm2773442qtb.7.2023.05.17.04.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:05:11 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 22/28] selftests: tc-testing: add P4TC metadata control path tdc tests
Date: Wed, 17 May 2023 07:02:26 -0400
Message-Id: <20230517110232.29349-22-jhs@mojatatu.com>
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

Introduce first tdc tests for P4TC metadata, which are focused on the
control path. We test metadata create, update, delete, flush and dump.

Here is a basic description of what we test for each operation:

Create:
    - Create valid metadatum
    - Try to create metadatum without specifying mandatory arguments
    - Try to create metadatum passing invalid values for size
    - Try to create metadatum without specifying pipeline name or id
    - Try to create metadatum with same name twice
    - Try to create metadatum with same id twice
    - Create metadatum without assigning id
    - Create metadatum with metadatum id == INX_MAX (2147483647) and check
      for overflow warning when traversing metadata IDR
    - Try to create metadatum with name length > METANENAMSIZ
    - Try to exceed max metadata offset on create

Update:
    - Update metadatum with valid values for size
    - Try to update metadatum with invalid values for size
    - Try to update metadatum without specifying pipeline name or id
    - Try to update metadatum without specifying metadatum name or id
    - Try to exceed max metadata offset on update

Delete:
    - Delete metadatum by name
    - Delete metadatum by id
    - Delete inexistent metadatum by name
    - Delete inexistent metadatum by id
    - Try to delete specific metadatum without supplying pipeline name or
      id

Flush:
    - Flush metadata
    - Flush empty metadata IDR
    - Try to flush metadata without specifying pipeline name or id
    - Flush empty metadata list

Dump:
    - Dump metadata IDR using pname to find pipeline
    - Dump metadata IDR using pipeid to find pipeline
    - Try to dump metadata IDR without supplying pipeline name or id
    - Dump metadatum IDR when amount of metadata > P4TC_MAXMSG_COUNT (16)

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 .../tc-testing/tc-tests/p4tc/metadata.json    | 2652 +++++++++++++++++
 1 file changed, 2652 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/metadata.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/p4tc/metadata.json b/tools/testing/selftests/tc-testing/tc-tests/p4tc/metadata.json
new file mode 100644
index 000000000000..ceb65a9668e6
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/p4tc/metadata.json
@@ -0,0 +1,2652 @@
+[
+    {
+        "id": "62e5",
+        "name": "Create valid metadatum",
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
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname mid 42 type bit8",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 42,
+                        "mname": "cb/mname",
+                        "mtype": "bit",
+                        "msize": 8
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
+        "id": "40e3",
+        "name": "Try to create metadatum without specifying pipeline name or id",
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
+        "cmdUnderTest": "$TC p4template create metadata/ mid 42 type bit8",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchPattern": "Error: Metadatum name not found.*",
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
+        "id": "b2e7",
+        "name": "Try to create metadata without name",
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
+        "cmdUnderTest": "$TC p4template create metadata/ptables/ mid 42 type bit8",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchPattern": "Error: Metadatum name not found.*",
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
+        "id": "7dbc",
+        "name": "Try to create metadata without size",
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
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname mid 42",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchPattern": "Error: Metadatum name not found.*",
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
+        "id": "4c52",
+        "name": "Try to create metadata with size 0",
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
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname mid 42 type bit0",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchPattern": "Error: Metadatum name not found.*",
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
+        "id": "4999",
+        "name": "Try to create metadata with size > 128",
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
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname mid 42 type bit129",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchPattern": "Error: Metadatum name not found.*",
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
+        "id": "b738",
+        "name": "Create metadata with size = 128",
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
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/mname mid 42 type bit128",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ pipeid 22 mid 42",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 42,
+                        "mname": "mname",
+                        "mtype": "bit",
+                        "msize": 128
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
+        "id": "2deb",
+        "name": "Create metadata of signed type",
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
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname mid 42 type int33",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ pipeid 22 mid 42",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 42,
+                        "mname": "cb/mname",
+                        "mtype": "int",
+                        "msize": 33
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
+        "id": "0ddc",
+        "name": "Create metadata of type int128",
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
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname mid 42 type int128",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ pipeid 22 mid 42",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 42,
+                        "mname": "cb/mname",
+                        "mtype": "int",
+                        "msize": 128
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
+        "id": "be48",
+        "name": "Try to create metadata of type int129",
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
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname mid 42 type int129",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ pipeid 22 mid 42",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find metadatum by id.*",
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
+        "id": "054c",
+        "name": "Try to create metadatum with same name twice",
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
+                "$TC p4template create metadata/ptables/mname mid 42 type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/mname type bit13",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/mname",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 42,
+                        "mname": "mname",
+                        "mtype": "bit",
+                        "msize": 8
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
+        "id": "3088",
+        "name": "Try to create metadatum with same id twice",
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
+                "$TC p4template create metadata/ptables/cb/mname mid 42 type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname2 mid 42 type bit13",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/ mid 42",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 42,
+                        "mname": "cb/mname",
+                        "mtype": "bit",
+                        "msize": 8
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
+        "id": "ad42",
+        "name": "Create metadatum without assigning mid",
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
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname type bit27",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 1,
+                        "mname": "cb/mname",
+                        "mtype": "bit",
+                        "msize": 27
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
+        "id": "1805",
+        "name": "Update metadatum's size specifying metadatum name",
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
+                "$TC p4template create metadata/ptables/cb/mname mid 42 type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update metadata/ptables/cb/mname type bit13",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 42,
+                        "mname": "cb/mname",
+                        "mtype": "bit",
+                        "msize": 13
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
+        "id": "51a3",
+        "name": "Update metadatum's size specifying metadatum id",
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
+                "$TC p4template create metadata/ptables/cb/mname mid 42 type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update metadata/ptables/ mid 42 type bit13",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/ mid 42",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 42,
+                        "mname": "cb/mname",
+                        "mtype": "bit",
+                        "msize": 13
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
+        "id": "db7d",
+        "name": "Try to update metadatum without specifying pipeline name or id",
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
+                "$TC p4template create metadata/ptables/cb/mname mid 42 type bit4",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update metadata/ type bit8",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 42,
+                        "mname": "cb/mname",
+                        "mtype": "bit",
+                        "msize": 4
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
+        "id": "d525",
+        "name": "Try to update metadatum without specifying metadatum name or id",
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
+                "$TC p4template create metadata/ptables/cb/mname mid 42 type bit4",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update metadata/ptables/ type bit8",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 42,
+                        "mname": "cb/mname",
+                        "mtype": "bit",
+                        "msize": 4
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
+        "id": "6853",
+        "name": "Try to update metadatum's size with zero",
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
+                "$TC p4template create metadata/ptables/cb/mname mid 42 type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update metadata/ptables/cb/mname mid 42 type bit0",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 42,
+                        "mname": "cb/mname",
+                        "mtype": "bit",
+                        "msize": 8
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
+        "id": "514f",
+        "name": "Try to update metadatum's size with 129",
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
+                "$TC p4template create metadata/ptables/cb/mname mid 42 type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update metadata/ptables/cb/mname mid 42 type bit129",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 42,
+                        "mname": "cb/mname",
+                        "mtype": "bit",
+                        "msize": 8
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
+        "id": "c9d4",
+        "name": "Update metadata with size = 128",
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
+                "$TC p4template create metadata/ptables/cb/mname mid 42 type bit64",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update metadata/ pipeid 22 mid 42 type bit128",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 42,
+                        "mname": "cb/mname",
+                        "mtype": "bit",
+                        "msize": 128
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
+        "id": "0a2d",
+        "name": "Dump metadata using pname to find pipeline",
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
+                "$TC p4template create metadata/ptables/cb/mname type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname2 type bit27",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mname": "cb/mname"
+                    },
+                    {
+                        "mname": "cb/mname2"
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
+        "id": "380d",
+        "name": "Dump metadata using pipeid to find pipeline",
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
+                "$TC p4template create metadata/ptables/cb/mname type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname2 type bit27",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ pipeid 22",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mname": "cb/mname"
+                    },
+                    {
+                        "mname": "cb/mname2"
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
+        "id": "c0ee",
+        "name": "Try to dump metadata without supplying pipeline name or id",
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
+                "$TC p4template create metadata/ptables/cb/mname type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname2 type bit27",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/",
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
+        "id": "a45b",
+        "name": "Delete specific metadatum by name",
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
+                "$TC p4template create metadata/ptables/cb/mname type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template del metadata/ptables/cb/mname",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchPattern": "Error: Metadatum name not found.*",
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
+        "id": "fe8d",
+        "name": "Delete specific metadatum by id",
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
+                "$TC p4template create metadata/ptables/cb/mname mid 1 type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template del metadata/ptables/ mid 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/ mid 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find metadatum by id.*",
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
+        "id": "bf02",
+        "name": "Try to delete inexistent metadatum by name",
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
+        "cmdUnderTest": "$TC p4template del metadata/ptables/cb/mname",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchPattern": "Error: Metadatum name not found.*",
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
+        "id": "253c",
+        "name": "Try to delete inexistent metadatum by id",
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
+        "cmdUnderTest": "$TC p4template del metadata/ptables/ mid 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/ mid 1",
+        "matchCount": "1",
+        "matchPattern": "Unable to find metadatum by id.*",
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
+        "id": "deca",
+        "name": "Try to delete specific metadatum without supplying pipeline name or id",
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
+                "$TC p4template create metadata/ptables/cb/mname type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template del metadata/",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 1,
+                        "mname": "cb/mname",
+                        "mtype": "bit",
+                        "msize": 8
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
+        "id": "b331",
+        "name": "Flush metadata",
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
+                "$TC p4template create metadata/ptables/cb/mname type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template del metadata/ptables/",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/",
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
+        "id": "1456",
+        "name": "Try to flush metadata without specifying pipeline name or id",
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
+                "$TC p4template create metadata/ptables/cb/mname type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template del metadata/",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 1,
+                        "mname": "cb/mname",
+                        "mtype": "bit",
+                        "msize": 8
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
+        "id": "3a84",
+        "name": "Try to exceed max metadata offset on create",
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
+                "$TC p4template create metadata/ptables/cb/mname type bit64",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname2 type bit64",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname3 type bit128",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname4 type bit128",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname5 type bit128",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname6 type bit1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname6",
+        "matchCount": "1",
+        "matchPattern": "Error: Metadatum name not found.*",
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
+        "id": "2f62",
+        "name": "Try to exceed max metadata offset on update",
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
+                "$TC p4template create metadata/ptables/cb/mname type bit64",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname2 mid 22 type bit32",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname3 type bit64",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname4 type bit64",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname5 type bit128",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname6 type bit128",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update metadata/ptables/cb/mname2 type bit128",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname2",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 22,
+                        "mname": "cb/mname2",
+                        "mtype": "bit",
+                        "msize": 32
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
+        "id": "8624",
+        "name": "Create metadatum with mid of 4 bytes",
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
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname mid 2147483647 type bit128",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/cb/mname",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mid": 2147483647,
+                        "mname": "cb/mname",
+                        "mtype": "bit",
+                        "msize": 128
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
+        "id": "e8ae",
+        "name": "Dump pipeline with amount of metadata > P4TC_MSGBATCH_SIZE",
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
+                "$TC p4template create metadata/ptables/cb/mname type bit8",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname2 type bit4",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname3 type bit4",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname4 type bit8",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname5 type bit4",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname6 type bit4",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname7 type bit8",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname8 type bit4",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname9 type bit4",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname10 type bit8",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname11 type bit4",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname12 type bit4",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname13 type bit3",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname14 type bit8",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname15 type bit1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname16 mid 2147483647 type bit5",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "metadata"
+            },
+            {
+                "templates": [
+                    {
+                        "mname": "cb/mname"
+                    },
+                    {
+                        "mname": "cb/mname2"
+                    },
+                    {
+                        "mname": "cb/mname3"
+                    },
+                    {
+                        "mname": "cb/mname4"
+                    },
+                    {
+                        "mname": "cb/mname5"
+                    },
+                    {
+                        "mname": "cb/mname6"
+                    },
+                    {
+                        "mname": "cb/mname7"
+                    },
+                    {
+                        "mname": "cb/mname8"
+                    },
+                    {
+                        "mname": "cb/mname9"
+                    },
+                    {
+                        "mname": "cb/mname10"
+                    },
+                    {
+                        "mname": "cb/mname11"
+                    },
+                    {
+                        "mname": "cb/mname12"
+                    },
+                    {
+                        "mname": "cb/mname13"
+                    },
+                    {
+                        "mname": "cb/mname14"
+                    },
+                    {
+                        "mname": "cb/mname15"
+                    },
+                    {
+                        "mname": "cb/mname16"
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
+        "id": "56ef",
+        "name": "Flush metadata where one metadatum has mid of 4 bytes",
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
+                "$TC p4template create metadata/ptables/cb/mname type bit8",
+                0
+            ],
+            [
+                "$TC p4template create metadata/ptables/cb/mname2 mid 2147483647 type bit128",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template del metadata/ptables/ ",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/",
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
+        "id": "1a02",
+        "name": "Flush empty metadata list",
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
+        "cmdUnderTest": "$TC p4template del metadata/ptables/",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/",
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
+        "id": "3a0e",
+        "name": "Delete specific metadatum by pipelne id and metadatum by id",
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
+                "$TC p4template create metadata/ptables/cb/mname mid 1 type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template del metadata/ pipeid 22 mid 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/ pipeid 22 mid 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find metadatum by id.*",
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
+        "id": "b69c",
+        "name": "Try to create metadatum without name or id",
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
+        "cmdUnderTest": "$TC p4template create metadata/ptables/ mid 1 type bit8",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ pipeid 22 mid 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find metadatum by id.*",
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
+        "id": "287c",
+        "name": "Try to get metadata without supplying pipeline name or id",
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
+                "$TC p4template create metadata/ptables/cb/mname type bit8",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template create metadata/ptables/cb/mname2 type bit8",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get metadata/",
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
+        "id": "528d",
+        "name": "Try to create metadatum with name length > METANAMSIZ",
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
+        "cmdUnderTest": "$TC p4template create metadata/ptables/7eozFYyaqVCD7H0xS3M5sMnluUqPgZewfSLnYPf4s3k0lbx8lKoR32zSqiGsh84qJ32vnLPdl7f2XcUh5yIdEP7uJy2C3iPtyU7159s9CMB0EtTAlWTVz4U1jkQ5h2advwp3KCVsZ1jlGgStoJL2op5ZxoThTSUQLR61a5RNDovoSFcq86Brh6oW9DSmTbN6SYygbG3JLnEHzRC5hh0jGmJKHq5ivBK9Y9FlNZQXC9wVwX4qTFAd8ITUTj2Au2Jg1 mid 42 type bit8",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4template get metadata/ptables/ mid 42",
+        "matchCount": "1",
+        "matchPattern": "Unable to find metadatum by id.*",
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


