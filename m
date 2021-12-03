Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C5346775B
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244731AbhLCM3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:29:01 -0500
Received: from mail-mw2nam10on2095.outbound.protection.outlook.com ([40.107.94.95]:24832
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352069AbhLCM3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 07:29:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mv8dtA4bs0002SWuVqRU2wj4hHyKEa8IH7oIOtgJVAPQUnLVhqVC4F9MkxvZ0bDBZD2I8iFhtrdy2AFmU9bMWr26pFp2eWAKnbyjEnKS61hWdBz2ZQGZSvCk6nLM8WXzktIAYSwPBGWZxandLemrH/6UdQHakTS3bOX7+YgDmYY5c2xWV+M5nCzteM+1DsHEcrHt6J758jiTQLTTChYmCt4xJNBP/jsr0or/QjL7gLJW/nZ8fs23/bNUPKvkD81WE48H0Xbs7CNO6pF9jvS4oIWjNa//JcWfkH/OdqcwonxcUF4mOT96v0hGYfnt/T8wNSnOyAqsiYeLh9QyMj4eIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLD9VLRt+eoIXF9qZ6EZEbTy+gfLtdBLGZEzQQ6ouZ4=;
 b=chH0F+AT8fpjJgwh25kK4J+7hL/ORtE048gFN17+xUpVuvXsd0FD+hJQwiaQ0GKKlyg7xrooUH3YuSsCPGETl8MDKFcnwmAnZDRoz6GcF/y9XNyQdOhLojGdbvVkvQLOQ3uUNachNLYyQqANQTTPdCzndQDTSJrrGbMcDnTAgqXXsFZsKDO1w7mxBuBd6zC86ZnQsoPHZ3nSj+JQXVwE60XMupRoix1oXcBivccLX0XJsPUnDENrxxBO+jg5QO8H43TdyXmZQk0mGFTQDv4Opj8eqC/Ozo5qOAEathcndXh0+KKpvZkIWY6OAL78I1uJ0x6UKV/ftaxvlH7tHn+6sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLD9VLRt+eoIXF9qZ6EZEbTy+gfLtdBLGZEzQQ6ouZ4=;
 b=i+/wvOnFsrRLy8LwnVLtWTi9VOpNelMfMMmS3oRgsFfjO28u5itTZAB76TgJ91XojRys27m+wZuM9Iv1St1ac2bJeOgRhtSVb0k7Hnj2jGcM+MraDlxncaDqq0TPhNRigG4ijORmBLE4VNvzN6yOxAF9Y3ntYZeV73Ht07eaw8o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5423.namprd13.prod.outlook.com (2603:10b6:510:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.7; Fri, 3 Dec
 2021 12:25:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4755.015; Fri, 3 Dec 2021
 12:25:30 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 12/12] selftests: tc-testing: add action offload selftest for action and filter
Date:   Fri,  3 Dec 2021 13:24:44 +0100
Message-Id: <20211203122444.11756-13-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211203122444.11756-1-simon.horman@corigine.com>
References: <20211203122444.11756-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 12:25:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cd62442-c24c-4caf-645a-08d9b657fe94
X-MS-TrafficTypeDiagnostic: PH0PR13MB5423:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5423E2E052360162A7063D30E86A9@PH0PR13MB5423.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P1DXBD3DDQnJocCcoC2WEo6LF3D6k8uDe1TmOAi8J/iw4+W7Ae+lS4DBCN+SxhaTVBoskljl/EQ6D0gFe0A6Y4Ha9lP5G4QSbDyWb4l0xF0LiigpgP9P9EyFPD79ijoLdUKhulPNQJWzK/XIVCBXSzVBz1FbQxLUcynrSb7MIbJmd6vX3yr7qPfuSGSjhXwlGREY8wpSh7FG+RUvOLOOQ5Bht45Bb13G6ZYJRKceIusFZrKfTmuvSfknMd+YdwXY0Qb+Odg39qbJ3GPd59SPKKGu/RhYTaJRgpTxPRAaG0zeVVlpFA4O+d4nTLcP/mKHLkS4fu0YVsVNnkFHuF0f0dSeQM1wI0sFJzI8AuSGUiP4Xnuxxxt6zihZxhXHEZxRFA5fk5W1pUXcJU40MlfTWr4ANu7ViUoPTGygTRinpE7mAC58FTXY8suVatUrCpReWb7kgkEuoWaoB764Plj3MuGHFiljGBKeawQkSH6bn3djlbj3x2OMHGzQn1iuZzZWkksbALMma+1/C9zjh/q3D3sVxwWgUzmunmjGbCNhrhgrbVffcbX9KscrKeSQ1mMNmytW8c+Dds+UXlBct0dcRJIMw5yBa8eJofBM1FkwOam/5vgfS1ryXlTNg1X2/07m183mj2OZmv4pFsbyqE/4kA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(346002)(376002)(396003)(136003)(6666004)(8936002)(38100700002)(2616005)(6506007)(4326008)(66946007)(66556008)(8676002)(36756003)(186003)(316002)(1076003)(44832011)(6486002)(508600001)(66476007)(5660300002)(107886003)(54906003)(52116002)(86362001)(83380400001)(6916009)(6512007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UN3z1V7oAtZW6Pgt4nojW7J8r1nnRlG0KpWxyMHRcO6TNGA0qRmJ8BSDzezf?=
 =?us-ascii?Q?lL01+SfrA2eCtdlclaZp5ggoHVGfmKo/VPSsToKGHU9ZbixNye6Rah+Hsng6?=
 =?us-ascii?Q?ZjixBbRWi2OXO6wEy/kvcQGi/vAwj1Vs44S6mj5dNwo026o1cneGv3wbqBc4?=
 =?us-ascii?Q?N6Otkaxvmgdh04nr++NiBm2iXGtDjZZpfHjNUjr+5beAtyB0qMAimSrPZoi4?=
 =?us-ascii?Q?mtSIdjrC6jSe1wt24J52sYUzQrcCdFaK47ud2TTt96CQvjXyJv7DMWbDI52b?=
 =?us-ascii?Q?0CePTjF6Q+ipzaJv9uiB+qAybbWJKR5wxjWh75oZt02slGw2jlT05v4dwtYC?=
 =?us-ascii?Q?Xxk20bHl5X0TQD3ndBJChnGYiPfEG5XUfG1d1oDfG9TLcmPpprtL9nfHgo1q?=
 =?us-ascii?Q?/iNjpSrCawCxpRFyLBzzZRsvL8h9vPhK/Ksy4cLaSi6gIsPUGQoR9xGr9lGS?=
 =?us-ascii?Q?WniQW8NUMXCKzMMV8+EX7DmjNoHgS4y7WabQzc03rzxQ9GL2FYXnHaF0nf39?=
 =?us-ascii?Q?mTas0rlKklRcdpLcJG9UzX1Zr5/u3nGy1uKNl1+s0qVUE6K3YPRVmRBhb4qX?=
 =?us-ascii?Q?XgbD0zJBQaUAJNFjG8vkPK1ahHyjjf8wiblywOVI+yNaleex4yZQKBSTdycw?=
 =?us-ascii?Q?b4slrngDlxLN2wM6B4RtwH2gX5ZXyexmiqc/RN8nLFNmICbmVT8zq7WhoqtQ?=
 =?us-ascii?Q?yFXRAooUWt+kN/hnvUuy3gOl3mdyj6NXsx0Mlw/1G4VpPEgrMldlS7Z0sW0B?=
 =?us-ascii?Q?5/Rhg/+afcotHLz2NSW/fi6TsM+MsPMVRRwelS639LYcEXs96PvAJcaozN4q?=
 =?us-ascii?Q?KZsinEM9hVF4YXJWSoMn+jFepEUg5IrwDtUZAY2F7goXAY2qwJ7jhTQzmnfW?=
 =?us-ascii?Q?4SnfzrYp/TM5aP42JQjcrh8zeOmGl3mcdxw6v1RwXHUBs7dqZQIF6bML5CHk?=
 =?us-ascii?Q?2WvH4wksqZqwTnYTCZ+aglJGW4fEyiY9GVzT9cUHZkQ0zTGbJafRlcklbTIY?=
 =?us-ascii?Q?Nd2X+KUW71if1ea9LL5SA5JhiLriMklYRCCvALdWfgHzwfXnAGCpDpOcqidK?=
 =?us-ascii?Q?xcmH+L/eyY0ojbQTXKNMByOHWKhCutL8CF3SVnLZ8xWvQxVnDuGBYyDNfJBC?=
 =?us-ascii?Q?RtyPIUCVsUmvfCQwLcXq1oFqb6OGWp1LL1qAMFnnpmNTS9iu+2BjEo/vJYGQ?=
 =?us-ascii?Q?yYqfSaq8tr+XHG9tn2ddWi7NO7wyDRC/W1huqD/d86M/1zCaHx2+glUerIPb?=
 =?us-ascii?Q?94VXUkQUQnxA3kKajNKMuNnPvPmU/uMdFYIjA6zwYw+hgMOEurTEC/fXuJfn?=
 =?us-ascii?Q?R4mvwh05wTDwHtGkR4tsuH7mmbd22PPMRjaGEqTrjrQkn9zKEJxH6T2OJyn/?=
 =?us-ascii?Q?gfMaTeDmYa0njJ5y+kqf16zkPjx/tK+IJsrDjffvmres4PKv5FrsQXVZEh0T?=
 =?us-ascii?Q?D1pFOPADXJaxqYAJrKz7mb45SqUw3r0ogL/sIuizc9NoyI16eaBM7lrQ4jxa?=
 =?us-ascii?Q?FrAB25KJfKziqClh34MpYTa8aLmm+nNkeZc6VG7mIZctXjieH+TdZas12oRk?=
 =?us-ascii?Q?3Q1xzwFRSfEry4zmrbTtfAQHQe5v/itRckOT9RV1eXGyLdXE5ce73mIigqRr?=
 =?us-ascii?Q?voOuCJsxjdUa7Pc0RuY8CwuT5M1/wwiF0cahDrpiYWMtJ/QQXtV6BI/Tzv3D?=
 =?us-ascii?Q?O74u885QzIbQNmnZXmwOT+MjXWD9pWsgBOXLaYp2E2heOpeMlWitCUZsJUJZ?=
 =?us-ascii?Q?oN6Cv59wDnW8HRfbvjfAzuVhPtlJBU0=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd62442-c24c-4caf-645a-08d9b657fe94
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 12:25:30.0617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W/FrFwU6GhW89gpSyJzoCiHX0M1ztm5tFElKlwc+KfeIsbHdiX3hDn4JC6vT1rVzx73yV2Xlz+esI03c3fi8vRKPKCyc8QV92Xauw0+FC+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5423
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add selftest cases in action police with skip_hw.
Add selftest case to validate flags of filter and action.
These tests depend on corresponding iproute2 command support.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../tc-testing/tc-tests/actions/police.json   | 24 +++++++++++++++++++
 .../tc-testing/tc-tests/filters/matchall.json | 24 +++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
index 8e45792703ed..b7205a069534 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/police.json
@@ -812,5 +812,29 @@
         "teardown": [
             "$TC actions flush action police"
         ]
+    },
+    {
+        "id": "7d64",
+        "name": "Add police action with skip_hw option",
+        "category": [
+            "actions",
+            "police"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action police",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action police rate 1kbit burst 10k index 100 skip_hw",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions ls action police | grep skip_hw",
+        "matchPattern": "skip_hw",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action police"
+        ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json b/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
index 51799874a972..4a8d1c5fff29 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
@@ -387,5 +387,29 @@
             "$TC qdisc del dev $DUMMY ingress",
             "$IP link del dev $DUMMY type dummy"
         ]
+    },
+    {
+        "id": "3329",
+        "name": "Validate flags of the matchall filter and police action with skip_sw",
+        "category": [
+            "filter",
+            "matchall"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC actions flush action police",
+            "$TC actions add action police rate 1mbit burst 100k index 199 skip_hw"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv4 matchall skip_sw action police index 199",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ipv4 matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy",
+            "$TC actions del action police index 199"
+        ]
     }
 ]
-- 
2.20.1

