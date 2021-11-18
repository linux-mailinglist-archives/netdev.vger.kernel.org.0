Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29E8455C58
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhKRNMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:12:01 -0500
Received: from mail-dm6nam10on2122.outbound.protection.outlook.com ([40.107.93.122]:47280
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230118AbhKRNLz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:11:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFRWVJAqHA238OkCXrBt21EyaKeNCWUIXyh7kEyFva9rEkeQT7uXxLAojyhNCbfLlAdfpliTf+FiqNbRdp39fowNb2+jpU8o+RwkSHkEZ6X2UptY0D+zg8PDhmX8fYPN4Qi0HiOj+hFFyO8zXQOEBNEAN7UQi7V2Jv+6wA3VttSG3YzkMzTSopKXb7dzLyziW6gX00jq+P8KvPXDRh1OcRQijTaJuOPdfcSvtEaNEt2adrdZlqPGmHo6SrUsBhlsDVyd2n+MibmPxuqzqVGCZzXtrq1mpB+GOsjcwWB8512XRdeh0Kl9QUj0DVDb2RUeIkSRth+N5ppzzDUuBIeODQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YF7Oo71/m9T9UVj9D8GyGXu/xxV35RQWMkAHxdXMAXM=;
 b=nNx4YLD0XaOYXSgxlE7MlYUFTOScA4uEFWib8/rD1mD3p2NldKI6a0OW4OC0oOeonqD9b7Ls3g0ynm9WBxjRkML5QtvoMJCzbMc12w0b2Be7NELbHXDD11Y1SGnLdLJULTtqJtNXk0Sz8HWm5h6pvp41Si1FX3vK/IXvaSYwoNGbbWO4Z3xyN0G1aUjp45VXScErc+A65fdkyjQWnPRdIMjgYhKmVNedx6eHxjLhubDKCmFZMaem+CRWjEwgumZx34F+iJ7PCksKRNOZvSe5OJYGwT4N2FObujb/5uOC3D2Tu27hsn6PKC4X7TgYU8VDogP+EWkW8I8KobIubdpZog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YF7Oo71/m9T9UVj9D8GyGXu/xxV35RQWMkAHxdXMAXM=;
 b=pIO7XqbawXhlXN70CjCRJJBeg611T7AwE2vCkNRAGQH08skUJzJzByF1gmiu6wlJjZ5rRaWTcD76p8NuhQB4Wi6/E3DzPxkDRJeMRmy7tIe3fiDKLgBzF8PgNg3ZiPYAUAI5pq1Kw+0IWWFl/Y6f9iNPWITawe6gG2WmKR8Ooho=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5780.namprd13.prod.outlook.com (2603:10b6:510:11b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.7; Thu, 18 Nov
 2021 13:08:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7%7]) with mapi id 15.20.4713.016; Thu, 18 Nov 2021
 13:08:40 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: [PATCH v4 10/10] selftests: tc-testing: add action offload selftest for action and filter
Date:   Thu, 18 Nov 2021 14:08:05 +0100
Message-Id: <20211118130805.23897-11-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211118130805.23897-1-simon.horman@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:200:89::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9) by AM4PR0202CA0021.eurprd02.prod.outlook.com (2603:10a6:200:89::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 13:08:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33ba0278-cd84-4e87-b016-08d9aa948a7a
X-MS-TrafficTypeDiagnostic: PH0PR13MB5780:
X-Microsoft-Antispam-PRVS: <PH0PR13MB578082D6C9682B1B5BABDC35E89B9@PH0PR13MB5780.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +D4kF+criaSzy5bw0glyc0owVDZkkrywP/VkDjhxOo6DBshS73D8RTUixczJkHamFQI1f1lYSkQl+qPAdXCxeYpIBS+XZRk0FN+XSCBoJdjAN90l2Gpc9upLT5m7MFq5ZG2N2+0Y5bQPGXnyph+nReqoUbZD4gnM4u1WLnUU9oEE/dTwuYOTGT0v0Mz6YC3L+wPruTj9EoO4a4fPJiKqvjd9eDOlsTS0Sh5z/sSnH2FlThnyvbS9g3x4VKWqSm/xFvxFKvTkAOdF+c6DhD71SBM0GkTgWqD7iCgbLjCgKPNOuv3psHKt8NHb6+C2t+01u6+6j15R+0Q5XDEvUmwyhXQl16oWBcrcg82/vICHgZKGzpaMAzTqXylWFOl+8OpQgc1Mi8axThzr5FVfB6HOfufzjvtdGK4Usdmk31F0O70Jns0DZ8CSD4BeqBR6QNbZk68akoxHM5L+gYYdOFFL0gTWSxfMSJ9ciu5LammnKIICXxQOWZr1MHCUmW/QTGnbAubyabY7pZY51F2DlesIJ9U7TVMjSOqL5W7t1RqFubGYejBINw67PWe8R+L1ovNUYnuHpTU+fMffZ1cPx6vFZF12NkMHrvaBFT7TqDinOc/GkUCWg6PgMEM9tcd2FfRbU59Ae/mKnkoSEr8PJ8GEWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(346002)(396003)(366004)(376002)(136003)(316002)(66476007)(6916009)(54906003)(66946007)(52116002)(6506007)(8676002)(6486002)(66556008)(186003)(86362001)(4326008)(6666004)(44832011)(6512007)(83380400001)(107886003)(38100700002)(8936002)(2616005)(508600001)(5660300002)(36756003)(1076003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K0Ab22rRLjAewiQx4sWQWTj4I8fvb9ngm5eFHcWHcOJRcxWrFj5EnxblhLFN?=
 =?us-ascii?Q?zF5ZFU0cKX+sUpkrb2V2EiGGPvwPkNdKT9u/Js8cLhasTlYmFiaN4/zOVUWO?=
 =?us-ascii?Q?MBCC1qDwr77RWIWl4HllvsbIOwEkAV3CYgtzLvnLPSq2Zd29+rUqkhgKPakL?=
 =?us-ascii?Q?qT4Pjzr4gRtXd60WNmanw3YtTWXKlbuvw2RK5OJIi9rBTRHvsaO/Pr2ew3IR?=
 =?us-ascii?Q?SRQs2K8vgVWcdv/bkmQtkrD7ZbgEqLGcStty5PKQwlER+IzLdv1pF+BJZuaT?=
 =?us-ascii?Q?DHWq19TtIerzu8wtyFJyjKUlRXv11vg6l/oyfgoa2VKqSPzsdbQF8EbO2j8O?=
 =?us-ascii?Q?Lq/PkdY1GNoe7J+Da+q0+0MOlrB+VN0cwcE1KGAE06HF6H7Su0DP0Wr+Q2rB?=
 =?us-ascii?Q?5KMDYesGOKCtwek9DjtJE016ksjFahNA5zuDCH2tia7hx+lkIYe1jSta0TAZ?=
 =?us-ascii?Q?e+ERypFrpnagpVKUilcHi+kdlvE1Ds4K4zalcLS/OhZowERhgS9xF0qV3Lfv?=
 =?us-ascii?Q?w13oG6WjsgmxB6cU27K+MCkBvQrouRRGgyy8rl1QQNgp0i1BQF4a5WVO232g?=
 =?us-ascii?Q?Yj1rKiFuEY+r1E45xlhthSHM3pC183FtYmUdx+n+uUB/hBS1NUjyYVzJYyEv?=
 =?us-ascii?Q?HmJhuHTkDjBkBtECiuqGo/QjwAkxybYsLDQj+1F9zwCfY0ocWsj3gTljM1HL?=
 =?us-ascii?Q?zBs1LxhXtU4m3ZNXaMto96VJdIK273psFIrATC9mby2C3MMkWNi/XzxOFubP?=
 =?us-ascii?Q?4BJQ8LarP0EVP9skIKxA1Xeu4GtA6Elec4BBNErLoLGIEdIGPdA7GovWLoJW?=
 =?us-ascii?Q?u21K9W0XxDLJFPEWieIkQnHAGtF1weVdIsHoRtRDITW+MPdlYuGcmTo+Dcp/?=
 =?us-ascii?Q?kBB2AMwH/fQm9nimvxKFmGRLDi9IlIQv0vsp18UttRVbaexiP9ulImxyjsA3?=
 =?us-ascii?Q?+eTxeIs4AYMir2eYbFiVIgM/PS/FVjSxYk5O1GphGO83PK0EyDyvXF6iYITu?=
 =?us-ascii?Q?5NAuWE5MFiL1QX90/+Du4EA/IkiCnTxirp/JcXiND/apne8Z8FqJhGWAVwUr?=
 =?us-ascii?Q?5B7MqSDKWj8qxhZUacx/sCJVfu/wY/CLryrXVNPXhgxsn8WYsmJcAOAxSyCE?=
 =?us-ascii?Q?gFk9EICKdx3KHH1F4LjTALVTCzRicxNRvCyI4dS+765v28okiAn6cF4HcDnl?=
 =?us-ascii?Q?JOyw6jalKP6Q2+CrrH/CIZhCuBPRwv7AoTkrp+Vd4Msx2Bwo2lYVmdQHHrjU?=
 =?us-ascii?Q?vUZKL0JSI/mv0D7Oto7Cq+WBLGcaBiwjDgQTaiv8Ozd7HlRLlMiF5exTfGDJ?=
 =?us-ascii?Q?xlXw7rfiX+nYl04UOpgR6yV7nuh38JpoAXK0bQlYZaCeCZg6Wa5uAXelEa4N?=
 =?us-ascii?Q?PxgtQb5gGfpmIzbJWzE2F1Eijjma4vOdv5pX9JtAGkEEPZscUJwJPNZeCnPB?=
 =?us-ascii?Q?Gqzu6J2JhxH3ZpLN237NY7CisHA7AKsYa++KHsIFvPsEK8gylBwv1XoY2uQM?=
 =?us-ascii?Q?KkC8oxeyjHagorekfj3uTQP7AZrLUruDX0IgLAtqdZrbIZkttUtf3k1iDYqS?=
 =?us-ascii?Q?Hg9CACZYLPJZoIiTQN6rAaT9kyyxUODuF9WtqTFSwRROdqetKWhR22yeaZkG?=
 =?us-ascii?Q?AlGoqruoDgcfJ3XWPXWAYavCW18Mb4GdDj6vOONv7xIROh5OlcNNZNq6yLzX?=
 =?us-ascii?Q?SVJFwjbbdcWwoJzHEuJJRvRx1Lzp4HUNjwsV8t3fyWtoKKJRZr/VMf8xs6uu?=
 =?us-ascii?Q?d2pnsi+c0wuffL1jyaJPSqt55TPTS1E=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ba0278-cd84-4e87-b016-08d9aa948a7a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 13:08:40.6227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MLMgb5QwdveeGYuj3U4PpcE7TzeCgVhkFQX1hANJzaAhFyw9rxcW6inGd5Y+0Fni3r7MZPEtk9eM0/ulFFXAoczYFVjnOGxWMgnvV5PEB6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5780
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
index 51799874a972..c17d277f0ab6 100644
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
+            "$TC actions add action police rate 1mbit burst 100k index 199 skip_sw"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 65535 protocol ipv4 matchall skip_hw action police index 199",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 65535 protocol ipv4 matchall",
+        "matchPattern": "^filter parent ffff: protocol ip pref 655355 matchall.*handle 0x1.",
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

