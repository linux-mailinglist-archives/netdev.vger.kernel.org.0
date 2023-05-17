Return-Path: <netdev+bounces-3311-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DBBC706649
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDD69281F5D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0BF91EA63;
	Wed, 17 May 2023 11:06:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC6C1DDDF
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:06:04 +0000 (UTC)
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000FE83F3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:05:37 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3f38e1142d0so4193441cf.2
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321537; x=1686913537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hlrz+owYXMH7aAgiJ5DKBA+7qsnsb77hrupC/4RFuO0=;
        b=zCXt+gCnqDckxiUSXP//MxM9H4SNSGUe8GPRe1THhPg3g2eLgJ1oL1hGOxzYkaat9w
         b+6ztR4t5keoC2YLIyQ99O3onwteTgLq6akaxlSFaUkU/xncSwhXdl9mRrf1nP+Q+vNY
         4JSZrbUEYRDsycNXRBHytch7KADLSCHickJglEMA29Dse9OzJt5EL7YbvE9nVy3J2owP
         QKlTOOOan/a7E4H+/X5RdWUEh1qwuc9lnK/6/zQ94S+Pu3FVlVwKVKkQZWp8qQLLgctk
         883nwreYzEUl5nXWtYxWpju1Y4l5ixPxWufS7QpNm40gcK8mGQt5mpljXuJnFSGSTwNn
         /S2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321537; x=1686913537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hlrz+owYXMH7aAgiJ5DKBA+7qsnsb77hrupC/4RFuO0=;
        b=dE2yt376pSJt3XlGMzs+S+FWZiVnB2fEvwzPBORv1NZxCLWEmxjBIc+g9/r0sHQqG0
         bhqqhDdo6vGfTMw1MiTfftkRDxlk3vT9CV2kfljeYHhn7TE1ckX+kl5VH5I46IHjkgwM
         rpQwu8o2r7OEac/nr95Ln3MduvCG1dPpFZCLaykvQRZnqrNZrjrhbKnZKxwBpFrTOn6v
         48xuJWbTUP5AlbC8xOIoZRGwqbhMxJBaCyUxEoThnkEOSmtwwucX9AlKsptSPtSqZEl5
         hzLgWgwMVrlcUKZ1cbB0sRhuBDKtvyGgJRdWgSES2nucInPBbJXx3xZpgAtQqOiN9Stv
         0HAg==
X-Gm-Message-State: AC+VfDyIkZrYhbQC4F8/OE4ZT8RySwZHGd/5aK3GNjhR0dPcIjJTD11j
	KSw87Eh7x8w0RKQebnbVT6t7cmUlCoUUQ6wDR/Q=
X-Google-Smtp-Source: ACHHUZ6onb8kCLItR0Suxz2fg/f7+SQpGai58fl+Jklmh3C4GUq93y0xIHMMGCjC5J515cGEPv/pnA==
X-Received: by 2002:a05:622a:d0:b0:3f4:fe39:f76e with SMTP id p16-20020a05622a00d000b003f4fe39f76emr33673659qtw.18.1684321535442;
        Wed, 17 May 2023 04:05:35 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id a13-20020aed278d000000b003ef1586721dsm6961276qtd.26.2023.05.17.04.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:05:34 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 25/28] selftests: tc-testing: add P4TC table entries control path tdc tests
Date: Wed, 17 May 2023 07:02:29 -0400
Message-Id: <20230517110232.29349-25-jhs@mojatatu.com>
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

Introduce tdc tests for P4TC table entries, which are focused on the
control path. We test table instance create, update, delete, flush and
dump.

Create:
    - Create valid table entry with all possible key types
    - Try to create table entry without specifying mandatory arguments
    - Try to create table entry passing invalid arguments
    - Try to create table entry with same key and prio twice
    - Try to create table entry without sealing the pipeline
    - Try to create table entry with action of unknown kind
    - Try to exceed max table entries count

Update:
    - Try to update table entry with action of inexistent kind
    - Try to update table entry with action of unknown kind
    - Update table entry with new action
    - Create table entry with action and then update table entry
      with another action
    - Create table entry with action, update table entry with another
      action and check action's refs and binds
    - Create table entry without action and then update table entry
      with another action
    - Try to update inexistent table entry

Delete:
    - Delete table entry
    - Try to delete inexistent table entry
    - Try to delete table entry without specifying mandatory arguments
    - Delete table entry specifying IDs for the pipeline and its
    components (table class and table instance)
    - Delete table entry specifying names for the pipeline and its
      components (table class and table instance)
    - Delete table entry with action and check action's refs and binds

Flush:
    - Flush table entries
    - Flush table entries specifying IDS for pipeline and its
    components (table class and table instance)
    - Flush table entries specifying names for pipeline and its
    components (table class and table instance)
    - Try to flush table entries without specifying mandatory arguments

Dump:
    - Dump table entries
    - Dump table entries specifying IDS for pipeline and its
    components (table class and table instance)
    - Dump table entries specifying names for pipeline and its
    components (table class and table instance)
    - Try to dump table entries without specifying mandatory arguments
    - Dump table instance with zero table entries
    - Dump table instance with more than P4TC_MAXMSG_COUNT entries

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 .../tc-tests/p4tc/table_entries.json          | 4183 +++++++++++++++++
 1 file changed, 4183 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/p4tc/table_entries.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/p4tc/table_entries.json b/tools/testing/selftests/tc-testing/tc-tests/p4tc/table_entries.json
new file mode 100644
index 000000000000..4be49d63f91f
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/p4tc/table_entries.json
@@ -0,0 +1,4183 @@
+[
+    {
+        "id": "4bfd",
+        "name": "Create valid table entry with args bit16",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname2 tblid 2 keysz 32 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname2 srcPort  80 dstPort  443 prio 16",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname2 srcPort  80 dstPort  443 prio 16",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 2,
+                        "prio": 16,
+                        "key": [
+                            {
+                              "keyfield": "srcPort",
+                              "id": 1,
+                              "width": 16,
+                              "type": "bit16",
+                              "match_type": "exact",
+                              "fieldval": 80
+                            },
+                            {
+                              "keyfield": "dstPort",
+                              "id": 2,
+                              "width": 16,
+                              "type": "bit16",
+                              "match_type": "exact",
+                              "fieldval": 443
+                            }
+                        ],
+                        "create_whodunnit": "tc",
+                        "permissions": "-RUD--R--X"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname2 srcPort  80 dstPort  443 prio 16",
+                0
+            ],
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
+        "id": "d574",
+        "name": "Create valid table entry with args  and check entries count",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname2 tblid 2 keysz 32 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname2 srcPort  80 dstPort  443 prio 16",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4template get table/ptables/cb/tname2",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22,
+                "obj": "table"
+            },
+            {
+                "templates": [
+                    {
+                        "tname": "cb/tname2",
+                        "keysz": 32,
+                        "max_entries": 256,
+                        "masks": 8,
+                        "entries": 1
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname2 srcPort  80 dstPort  443 prio 16",
+                0
+            ],
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
+        "id": "6c21",
+        "name": "Create valid table entry with args ipv4",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 17",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 17",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 1,
+                        "prio": 17,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 17",
+                0
+            ],
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
+        "id": "a486",
+        "name": "Create valid table entry with args bit8, bit32, bit64",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 3,
+                        "prio": 1,
+                        "key": [
+                            {
+                              "keyfield": "randomKey1",
+                              "id": 1,
+                              "width": 8,
+                              "type": "bit8",
+                              "match_type": "exact",
+                              "fieldval": 255
+                            },
+                            {
+                              "keyfield": "randomKey2",
+                              "id": 2,
+                              "width": 32,
+                              "type": "bit32",
+                              "match_type": "exact",
+                              "fieldval": 92
+                            },
+                            {
+                              "keyfield": "randomKey3",
+                              "id": 3,
+                              "width": 64,
+                              "type": "bit64",
+                              "match_type": "exact",
+                              "fieldval": 127
+                            }
+                        ]
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ],
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
+        "id": "13d9",
+        "name": "Try to create table entry without table name or id",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/ randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find entry.*",
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
+        "id": "0b7c",
+        "name": "Try to create table entry without specifying any keys",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname3 prio 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find entry.*",
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
+        "id": "c2e7",
+        "name": "Create table entry without specifying priority",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 3,
+                        "prio": 1,
+                        "key": [
+                            {
+                              "keyfield": "randomKey1",
+                              "id": 1,
+                              "width": 8,
+                              "type": "bit8",
+                              "match_type": "exact",
+                              "fieldval": 255
+                            },
+                            {
+                              "keyfield": "randomKey2",
+                              "id": 2,
+                              "width": 32,
+                              "type": "bit32",
+                              "match_type": "exact",
+                              "fieldval": 92
+                            },
+                            {
+                              "keyfield": "randomKey3",
+                              "id": 3,
+                              "width": 64,
+                              "type": "bit64",
+                              "match_type": "exact",
+                              "fieldval": 127
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC -j p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ],
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
+        "id": "dff1",
+        "name": "Try to get table entry without specifying priority",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC actions add action reclassify index 4",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+	    [
+                "$TC p4template create action/ptables/cb/reclassify actid 7 cmd act kernel.gact.4",
+		0
+	    ],
+	    [
+                "$TC p4template update action/ptables/cb/reclassify state active",
+		0
+	    ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4 table_acts act name ptables/cb/reclassify flags tableonly",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1 action ptables/cb/reclassify",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 2  action ptables/cb/reclassify",
+        "expExitCode": "0",
+        "verifyCmd": "$TC p4 get ptables/table/cb/tname3/ randomKey1  255 randomKey2  92 randomKey3  127",
+        "matchCount": "1",
+        "matchPattern": "Error: Must specify table entry priority.*",
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 2",
+                0
+            ],
+            [
+                "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ],
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
+        "id": "9a1e",
+        "name": "Try to create more table entries than allowed",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 tentries 1 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find entry.*",
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ],
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
+        "id": "2095",
+        "name": "Try to create more table entries than allowed after delete",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 tentries 3 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 17",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 18",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find entry.*",
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname",
+                0
+            ],
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
+        "id": "4e6a",
+        "name": "Try to create more table entries than allowed after flush",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 tentries 1 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ],
+            [
+                "$TC p4 del ptables/table/cb/tname",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find entry.*",
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ],
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
+        "id": "65a2",
+        "name": "Create two entries with same key and different priorities and check first one",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.1.0/16 prio 15",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 1,
+                        "prio": 16,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname",
+                0
+            ],
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
+        "id": "a49c",
+        "name": "Create two entries with same key and different priorities and check second one",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.1.0/16 prio 15",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.1.0/16 prio 15",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 1,
+                        "prio": 15,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.1.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname",
+                0
+            ],
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
+        "id": "2314",
+        "name": "Try to create same entry twice",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.1.0/16 prio 16",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 1,
+                        "prio": 16,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname",
+                0
+            ],
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
+        "id": "7d41",
+        "name": "Try to create table entry in unsealed pipeline",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 key action gact index 3 postactions gact index 4",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find entry.",
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
+        "id": "d732",
+        "name": "Try to create table entry with action of inexistent kind",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname2 tblid 2 keysz 32 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname2 srcPort  80 dstPort  443 prio 16 action noexist index 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname2 srcPort  80 dstPort  443 prio 16",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find entry.*",
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
+        "id": "525a",
+        "name": "Try to update table entry with action of inexistent kind",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname2 tblid 2 keysz 32 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname2 srcPort  80 dstPort  443 prio 16",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 update ptables/table/cb/tname2 srcPort  80 dstPort  443 prio 16 action noexist index 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname2 srcPort  80 dstPort  443 prio 16",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 2,
+                        "prio": 16,
+                        "key": [
+                            {
+                              "keyfield": "srcPort",
+                              "id": 1,
+                              "width": 16,
+                              "type": "bit16",
+                              "match_type": "exact",
+                              "fieldval": 80
+                            },
+                            {
+                              "keyfield": "dstPort",
+                              "id": 2,
+                              "width": 16,
+                              "type": "bit16",
+                              "match_type": "exact",
+                              "fieldval": 443
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname2",
+                0
+            ],
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
+        "id": "ee04",
+        "name": "Update table entry and add action",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC actions add action reclassify index 4",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+	    [
+                "$TC p4template create action/ptables/cb/reclassify actid 7 cmd act kernel.gact.4",
+		0
+	    ],
+	    [
+                "$TC p4template update action/ptables/cb/reclassify state active",
+		0
+	    ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4 table_acts act name ptables/cb/reclassify flags tableonly",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 update ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1 action ptables/cb/reclassify",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 3,
+                        "prio": 1,
+                        "key": [
+                            {
+                              "keyfield": "randomKey1",
+                              "id": 1,
+                              "width": 8,
+                              "type": "bit8",
+                              "match_type": "exact",
+                              "fieldval": 255
+                            },
+                            {
+                              "keyfield": "randomKey2",
+                              "id": 2,
+                              "width": 32,
+                              "type": "bit32",
+                              "match_type": "exact",
+                              "fieldval": 92
+                            },
+                            {
+                              "keyfield": "randomKey3",
+                              "id": 3,
+                              "width": 64,
+                              "type": "bit64",
+                              "match_type": "exact",
+                              "fieldval": 127
+                            }
+                        ],
+                        "create_whodunnit": "tc",
+                        "update_whodunnit": "tc",
+                        "actions": {
+                            "actions": [
+                                {
+                                    "order": 1,
+                                    "kind": "ptables/cb/reclassify",
+                                    "index": 1,
+                                    "ref": 1,
+                                    "bind": 1,
+                                    "params": []
+                                }
+                            ]
+                        }
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ],
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
+        "id": "10b5",
+        "name": "Update table entry and replace action",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC actions add action reclassify index 4",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+	    [
+                "$TC p4template create action/ptables/cb/reclassify actid 7 cmd act kernel.gact.4",
+		0
+	    ],
+	    [
+                "$TC p4template update action/ptables/cb/reclassify state active",
+		0
+	    ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4 table_acts act name ptables/cb/reclassify flags tableonly",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1 action ptables/cb/reclassify",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 update ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1 action ptables/cb/reclassify index 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 3,
+                        "prio": 1,
+                        "key": [
+                            {
+                              "keyfield": "randomKey1",
+                              "id": 1,
+                              "width": 8,
+                              "type": "bit8",
+                              "match_type": "exact",
+                              "fieldval": 255
+                            },
+                            {
+                              "keyfield": "randomKey2",
+                              "id": 2,
+                              "width": 32,
+                              "type": "bit32",
+                              "match_type": "exact",
+                              "fieldval": 92
+                            },
+                            {
+                              "keyfield": "randomKey3",
+                              "id": 3,
+                              "width": 64,
+                              "type": "bit64",
+                              "match_type": "exact",
+                              "fieldval": 127
+                            }
+                        ],
+                        "create_whodunnit": "tc",
+                        "update_whodunnit": "tc",
+                        "actions": {
+                            "actions": [
+                            {
+                                "order": 1,
+                                "kind": "ptables/cb/reclassify",
+                                "index": 2,
+                                "ref": 1,
+                                "bind": 1,
+                                "params": []
+                            }
+                            ]
+                        }
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ],
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
+        "id": "2d50",
+        "name": "Update table entry, replace action and check for action refs and binds",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC actions add action reclassify index 4",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+	    [
+                "$TC p4template create action/ptables/cb/reclassify actid 7 cmd act kernel.gact.4",
+		0
+	    ],
+	    [
+                "$TC p4template update action/ptables/cb/reclassify state active",
+		0
+	    ],
+            [
+                "$TC actions add action ptables/cb/reclassify index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4 table_acts act name ptables/cb/reclassify flags tableonly",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1 action ptables/cb/reclassify index 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 update ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1 action ptables/cb/reclassify index 2; sleep 1;",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j actions get action ptables/cb/reclassify index 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "ptables/cb/reclassify",
+                        "index": 1,
+                        "ref": 1,
+                        "bind": 0,
+                        "params": []
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ],
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
+        "id": "99ef",
+        "name": "Try to update inexistent table entry",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 update ptables/table/cb/tname3 randomKey1  255 randomKey2  1 randomKey3  127 prio 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 3,
+                        "prio": 1,
+                        "key": [
+                            {
+                              "keyfield": "randomKey1",
+                              "id": 1,
+                              "width": 8,
+                              "type": "bit8",
+                              "match_type": "exact",
+                              "fieldval": 255
+                            },
+                            {
+                              "keyfield": "randomKey2",
+                              "id": 2,
+                              "width": 32,
+                              "type": "bit32",
+                              "match_type": "exact",
+                              "fieldval": 92
+                            },
+                            {
+                              "keyfield": "randomKey3",
+                              "id": 3,
+                              "width": 64,
+                              "type": "bit64",
+                              "match_type": "exact",
+                              "fieldval": 127
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ],
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
+        "id": "8868",
+        "name": "Try to update table entry without specifying priority",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC actions add action reclassify index 4",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+	    [
+                "$TC p4template create action/ptables/cb/reclassify actid 7 cmd act kernel.gact.4",
+		0
+	    ],
+	    [
+                "$TC p4template update action/ptables/cb/reclassify state active",
+		0
+	    ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4 table_acts act name ptables/cb/reclassify flags tableonly",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 update ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 action ptables/cb/reclassify",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 3,
+                        "prio": 1,
+                        "key": [
+                            {
+                              "keyfield": "randomKey1",
+                              "id": 1,
+                              "width": 8,
+                              "type": "bit8",
+                              "match_type": "exact",
+                              "fieldval": 255
+                            },
+                            {
+                              "keyfield": "randomKey2",
+                              "id": 2,
+                              "width": 32,
+                              "type": "bit32",
+                              "match_type": "exact",
+                              "fieldval": 92
+                            },
+                            {
+                              "keyfield": "randomKey3",
+                              "id": 3,
+                              "width": 64,
+                              "type": "bit64",
+                              "match_type": "exact",
+                              "fieldval": 127
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ],
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
+        "id": "339a",
+        "name": "Try to update table entry without specifying table name or id",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 update ptables/table/ randomKey1  255 randomKey2  92 randomKey3  127 prio 1 action gact index 2",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 3,
+                        "prio": 1,
+                        "key": [
+                            {
+                              "keyfield": "randomKey1",
+                              "id": 1,
+                              "width": 8,
+                              "type": "bit8",
+                              "match_type": "exact",
+                              "fieldval": 255
+                            },
+                            {
+                              "keyfield": "randomKey2",
+                              "id": 2,
+                              "width": 32,
+                              "type": "bit32",
+                              "match_type": "exact",
+                              "fieldval": 92
+                            },
+                            {
+                              "keyfield": "randomKey3",
+                              "id": 3,
+                              "width": 64,
+                              "type": "bit64",
+                              "match_type": "exact",
+                              "fieldval": 127
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ],
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
+        "id": "3962",
+        "name": "Delete table entry",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find entry.*",
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
+        "id": "fcc7",
+        "name": "Try to delete table entry without specyfing tblid or table name",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 del ptables/table/ randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname3/ randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 3,
+                        "prio": 1,
+                        "key": [
+                            {
+                              "keyfield": "randomKey1",
+                              "id": 1,
+                              "width": 8,
+                              "type": "bit8",
+                              "match_type": "exact",
+                              "fieldval": 255
+                            },
+                            {
+                              "keyfield": "randomKey2",
+                              "id": 2,
+                              "width": 32,
+                              "type": "bit32",
+                              "match_type": "exact",
+                              "fieldval": 92
+                            },
+                            {
+                              "keyfield": "randomKey3",
+                              "id": 3,
+                              "width": 64,
+                              "type": "bit64",
+                              "match_type": "exact",
+                              "fieldval": 127
+                            }
+                        ]
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ],
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
+        "id": "e79d",
+        "name": "Try to delete table entry without specifying prio",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC p4 del ptables/table/cb/tname3/ randomKey1  255 randomKey2  92 randomKey3  127",
+        "matchCount": "1",
+        "matchPattern": "Error: Must specify table entry priority.*",
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 2",
+                0
+            ],
+            [
+                "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+                0
+            ],
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
+        "id": "c5be",
+        "name": "Delete table entry with action and check action's refs and binds",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC actions add action reclassify index 4",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+	    [
+                "$TC p4template create action/ptables/cb/reclassify actid 7 cmd act kernel.gact.4",
+		0
+	    ],
+	    [
+                "$TC p4template update action/ptables/cb/reclassify state active",
+		0
+	    ],
+            [
+                "$TC actions add action ptables/cb/reclassify index 1",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4 table_acts act name ptables/cb/reclassify flags tableonly",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1 action ptables/cb/reclassify",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1; sleep 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j actions get action ptables/cb/reclassify index 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "total acts": 0
+            },
+            {
+                "actions": [
+                    {
+                        "order": 1,
+                        "kind": "ptables/cb/reclassify",
+                        "index": 1,
+                        "ref": 1,
+                        "bind": 0,
+                        "params": []
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
+        "id": "4ac6",
+        "name": "Try to delete inexistent table entry",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname3 tblid 3 keysz 104 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 del ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname3 randomKey1  255 randomKey2  92 randomKey3  127 prio 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find entry.*",
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
+        "id": "24a1",
+        "name": "Flush table entries",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 del ptables/table/cb/tname",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find entry.*",
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
+        "id": "9770",
+        "name": "Flush table entries using table name",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 del ptables/table/cb/tname",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find entry.*",
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
+        "id": "c5b9",
+        "name": "Flush table entries without specifying table name or id",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 del ptables/table/",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 1,
+                        "prio": 1,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.56.0/24"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname",
+                0
+            ],
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
+        "id": "03f7",
+        "name": "Dump table entries",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 1,
+                        "prio": 1,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.56.0/24"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname",
+                0
+            ],
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
+        "id": "0caa",
+        "name": "Try to dump table entries without specifying table name or id",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.56.0/24 prio 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/",
+        "matchCount": "1",
+        "matchPattern": "Error: Must specify table name or id.*",
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname",
+                0
+            ],
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
+        "id": "6a9e",
+        "name": "Try to dump table entries when no entries were created",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 key action gact index 3 postactions gact index 4",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update pipeline/ptables state ready",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname",
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
+        "id": "1406",
+        "name": "Dump table with more than P4TC_MAXMSG_COUNT entries",
+        "category": [
+            "p4tc",
+            "entries"
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
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname tblid 1 keysz 64 key action gact index 3 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 1",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 2",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 3",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 4",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 5",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 6",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 7",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 8",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 9",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 10",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 11",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 12",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 13",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 14",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 15",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 16",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname srcAddr 10.10.10.0/24 dstAddr 192.168.0.0/16 prio 17",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname/",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 1,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 16,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 15,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 14,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 13,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 12,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 11,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 10,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 9,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 8,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 7,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 6,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 5,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 4,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 3,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    },
+                    {
+                        "tblid": 1,
+                        "prio": 2,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            },
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 1,
+                        "key": [
+                            {
+                              "keyfield": "srcAddr",
+                              "id": 1,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "10.10.10.0/24"
+                            },
+                            {
+                              "keyfield": "dstAddr",
+                              "id": 2,
+                              "width": 32,
+                              "type": "ipv4",
+                              "match_type": "exact",
+                              "fieldval": "192.168.0.0/16"
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname",
+                0
+            ],
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
+        "id": "2515",
+        "name": "Try to create table entry without permission",
+        "category": [
+            "p4tc",
+            "template",
+            "table"
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
+                "$TC actions add action drop index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action ok index 3",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action reclassify index 4",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname2 tblid 2 keysz 32 permissions 0x1FF key action gact index 3 preactions gact index 4 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname2 srcPort 80 dstPort 443 prio 16",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname2 srcPort 80 dstPort 443 prio 16",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find entry.*",
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
+        "id": "f803",
+        "name": "Try to create table entry without more permissions than allowed",
+        "category": [
+            "p4tc",
+            "template",
+            "table"
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
+                "$TC actions add action drop index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action ok index 3",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action reclassify index 4",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname2 tblid 2 keysz 32 permissions 0x3C9 key action gact index 3 preactions gact index 4 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname2 srcPort 80 dstPort 443 prio 16 permissions 0x1CF",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname2 srcPort 80 dstPort 443 prio 16",
+        "matchCount": "1",
+        "matchPattern": "Error: Unable to find entry.*",
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
+        "id": "0de2",
+        "name": "Try to update table entry without permission",
+        "category": [
+            "p4tc",
+            "template",
+            "table"
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
+                "$TC actions add action drop index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action ok index 3",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action reclassify index 4",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname2 tblid 2 keysz 32 permissions 0x3FF key action gact index 3 preactions gact index 4 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname2 srcPort 80 dstPort 443 prio 16 permissions 0x16F",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 update ptables/table/cb/tname2 srcPort 80 dstPort 443 prio 16",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname2 srcPort 80 dstPort 443 prio 16",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 2,
+                        "prio": 16,
+                        "key": [
+                            {
+                              "keyfield": "srcPort",
+                              "id": 1,
+                              "width": 16,
+                              "type": "bit16",
+                              "match_type": "exact",
+                              "fieldval": 80
+                            },
+                            {
+                              "keyfield": "dstPort",
+                              "id": 2,
+                              "width": 16,
+                              "type": "bit16",
+                              "match_type": "exact",
+                              "fieldval": 443
+                            }
+                        ],
+                        "create_whodunnit": "tc",
+                        "permissions": "-R-DX-RUDX"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname2",
+                0
+            ],
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
+        "id": "4540",
+        "name": "Try to delete table entry without permission",
+        "category": [
+            "p4tc",
+            "template",
+            "table"
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
+                "$TC actions add action drop index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action ok index 3",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action reclassify index 4",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname2 tblid 2 keysz 32 permissions 0x3FF key action gact index 3 preactions gact index 4 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname2 srcPort 80 dstPort 443 prio 16 permissions 0x1AF",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 del ptables/table/cb/tname2 srcPort 80 dstPort 443 prio 16",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname2 srcPort 80 dstPort 443 prio 16",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 2,
+                        "prio": 16,
+                        "key": [
+                            {
+                              "keyfield": "srcPort",
+                              "id": 1,
+                              "width": 16,
+                              "type": "bit16",
+                              "match_type": "exact",
+                              "fieldval": 80
+                            },
+                            {
+                              "keyfield": "dstPort",
+                              "id": 2,
+                              "width": 16,
+                              "type": "bit16",
+                              "match_type": "exact",
+                              "fieldval": 443
+                            }
+                        ],
+                        "create_whodunnit": "tc",
+                        "permissions": "-RU-X-RUDX"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 update ptables/table/cb/tname2 srcPort 80 dstPort 443 prio 16 permissions 0x1EF",
+                0
+            ],
+            [
+                "$TC p4 del ptables/table/cb/tname2/",
+                0
+            ],
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
+        "id": "51cb",
+        "name": "Simulate constant entries",
+        "category": [
+            "p4tc",
+            "template",
+            "table"
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
+                "$TC actions add action drop index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action ok index 3",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action reclassify index 4",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname2 tblid 2 keysz 32 permissions 0x3FF key action gact index 3 preactions gact index 4 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname2 srcPort 80 dstPort 443 prio 16",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4template update table/ptables/cb/tname2 permissions 0x1FF",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname2/",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 2,
+                        "prio": 16,
+                        "key": [
+                            {
+                              "keyfield": "srcPort",
+                              "id": 1,
+                              "width": 16,
+                              "type": "bit16",
+                              "match_type": "exact",
+                              "fieldval": 80
+                            },
+                            {
+                              "keyfield": "dstPort",
+                              "id": 2,
+                              "width": 16,
+                              "type": "bit16",
+                              "match_type": "exact",
+                              "fieldval": 443
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname2/",
+                0
+            ],
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
+        "id": "3ead",
+        "name": "Simulate constant entries and try to add additional entry",
+        "category": [
+            "p4tc",
+            "template",
+            "table"
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
+                "$TC actions add action drop index 2",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action ok index 3",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC actions add action reclassify index 4",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC p4template create pipeline/ptables pipeid 22 maxrules 1 numtables 1 preactions action gact index 1 postactions action gact index 2",
+                0
+            ],
+            [
+                "$TC p4template create table/ptables/cb/tname2 tblid 2 keysz 32 permissions 0x3FF key action gact index 3 preactions gact index 4 postactions gact index 4",
+                0
+            ],
+            [
+                "$TC p4template update pipeline/ptables state ready",
+                0
+            ],
+            [
+                "$TC p4 create ptables/table/cb/tname2 srcPort 80 dstPort 443 prio 16",
+                0
+            ],
+            [
+                "$TC p4template update table/ptables/cb/tname2 permissions 0x1FF",
+                0
+            ]
+        ],
+        "cmdUnderTest": "$TC p4 create ptables/table/cb/tname2 srcPort 53 dstPort 53 prio 17",
+        "expExitCode": "255",
+        "verifyCmd": "$TC -j p4 get ptables/table/cb/tname2/",
+        "matchCount": "1",
+        "matchJSON": [
+            {
+                "pname": "ptables",
+                "pipeid": 22
+            },
+            {
+                "entries": [
+                    {
+                        "tblid": 2,
+                        "prio": 16,
+                        "key": [
+                            {
+                              "keyfield": "srcPort",
+                              "id": 1,
+                              "width": 16,
+                              "type": "bit16",
+                              "match_type": "exact",
+                              "fieldval": 80
+                            },
+                            {
+                              "keyfield": "dstPort",
+                              "id": 2,
+                              "width": 16,
+                              "type": "bit16",
+                              "match_type": "exact",
+                              "fieldval": 443
+                            }
+                        ],
+                        "create_whodunnit": "tc"
+                    }
+                ]
+            }
+        ],
+        "teardown": [
+            [
+                "$TC p4 del ptables/table/cb/tname2/",
+                0
+            ],
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


