Return-Path: <netdev+bounces-10542-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99C9972EE7B
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCD201C208EC
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 965723ED92;
	Tue, 13 Jun 2023 21:56:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821C117FE6
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 21:56:54 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2076.outbound.protection.outlook.com [40.107.22.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F06C26AB;
	Tue, 13 Jun 2023 14:56:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIuqSQ8f+1PYvrTpLUjUVv9IktO/rsLTYu3QPbQAEa4FV2MopKbmwsX5vmEhBxjSeT5hGl+xkcaqv9/78EqhLFkduVYfO1S2mCFr8gt6SmiLwjJivBZINYKMAMMVBJ3RCjiemNioF9pIILN3ZGokG9KotEx8W/dChqCYUmH/wpfVPZ8RTycqpK+dq4xJd7nwb4i1R/d5XflOE/1yP/slPhoIUlfLHgUibrLTEgpaB0x/TtkC+ZCgnmOdoOozwPYlbLo/5bNH2Csu0cI4NF6ZMWGKe9pkIxkxpqkmi2P+nMoUMB3/vZUmnoJykqRV00CLW+Yg15e4EjMyUmgFcOri/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hn3UpXO7Q00pu73vp9aNHjp4lHyawb9kYjNGwhFg1Go=;
 b=ljyQPAlN+weF/gLkA5IFNsOmcl9LNluBiCVHKKJbHOx/hPaCYscJYK8gPf/2yv1A6Ehf629TQ+HRmGKiuwonCy59s+AolTJsRY/+dNu+FeTKnBUhjP1SCJBTolqFxXnIQK2pyJLt3KMCaj+L9C8CJpjfF2njRN9uG7yYgysr9R6kAVtvnDOJVNB7i9MbreT3XWvolbjFfg93yWaikNOCVRwnkXM4LaXm5WPK5vb1IvuxIm3/JPHJxIsriFsdq3nXAAubWxPGiD+0rkTRqjYWDBL64Siblr+r1rdSiSGBGThRTGRH2YSiuXdAoW/kz+TTeBzwBO0TsSbF5guAZZiozA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hn3UpXO7Q00pu73vp9aNHjp4lHyawb9kYjNGwhFg1Go=;
 b=PApYOyTppmBbg7Axee/EN/5rLLspGJEjokgiZes6Qisbr1ozxLi5g6E3KZz/BjNPW5n5xZt4rEYGXnt6pjJeeQ7IVeAcfRER5FMIIdq5/etfcoyiF+zq/saj08m0Ha00DUfsnxvpFD6+aijUTE37ME2BcZHUQSyzj9Rx2+Yngv8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8081.eurprd04.prod.outlook.com (2603:10a6:20b:3e2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 21:55:02 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 21:55:02 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	linux-kernel@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Maxim Georgiev <glipus@gmail.com>
Subject: [PATCH v2 net-next 9/9] selftests/tc-testing: verify that a qdisc can be grafted onto a taprio class
Date: Wed, 14 Jun 2023 00:54:40 +0300
Message-Id: <20230613215440.2465708-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
References: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0044.eurprd04.prod.outlook.com
 (2603:10a6:208:1::21) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8081:EE_
X-MS-Office365-Filtering-Correlation-Id: a4a82d6d-17ed-4dc6-5a37-08db6c58d722
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nvUdjeURrhh5MeDOyFsQ1IeSQAq+T5BJjcNi6A66BARaz5bcvMYaucoxvML4qA1E3TPLHMXsMU7lDr7kXkcbFhmPNlaU2XMwRz49iAOIK6BXGf9C9FG4t62HN1WyE82PYBo2lQwSsOth+3NCtRrS4xyoTE3KTsFp5iypmhdYOxzN3x81iN3oNnHy18GYeLsVZ0vNxval6kyV2BKKEcPDQdRrDhh//gR6EJmyvCUKJqm+8xs7cZGlEWpwvCkl1djtKIdgFXcmPk9v00R6wgjQmyUMKYALKm2VJPYYiseMBDEMQj9by4HzPxJh6ovUsV+TuR5EXSIQSmCr5MPEotgHarPQjLuOhRJ9Onl9N/kl25pAufBp+EINo8XvNLLGPIy2f3Ep600WbqU6XKPegSxh1W68JmyuGwN7dL0TQrULsGXY3yLVtBx6gqPf2ZOsEX9YGwzDcopjsOhsOtkXwONX+nPlauzPQw3rwZGuhMJKFdDvVveRLqMP/v6hCi2RBUadnd++6/3utezNhTt6jgdXuvXFd2y2z0SGV+XrauBzrC8foM0kbHK6xQqzNu0INdBpE1OOFFHr+t9Yp4QDfOkpvEBjLRjU796/RUJrK4jH5SDi2+7j5kkLbh0Xvuq74ZX9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(15650500001)(6916009)(66946007)(4326008)(66556008)(36756003)(186003)(54906003)(478600001)(2616005)(2906002)(66476007)(8676002)(6666004)(316002)(41300700001)(86362001)(6486002)(7416002)(6506007)(1076003)(8936002)(44832011)(83380400001)(26005)(5660300002)(38100700002)(52116002)(38350700002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6APviM9EZjXSD7y90t+V+aXQjlPyzR5o8XkEpFk50NRRpg/QHI/SaFYO0WyL?=
 =?us-ascii?Q?Pt2YfVzL1ngxEKOazO6l5UXxqN1evCI1atSFBF92Q/yo9m8SB1Pm5mhEkHmP?=
 =?us-ascii?Q?qkLespf7edMsnoN146QnT30nsmfLuSHq/1tZls3ZOQ5vgNzlVnS9wZL+60Jw?=
 =?us-ascii?Q?2P7yABwj02o3Li6Smfobx77nSYDRdqT9zEsjliaiBQu1Q8/sLIEx9LEhydGm?=
 =?us-ascii?Q?/AiRnDFiJo67z8CDavsOfO68Snzbvoyb5gH1sW9Nm5v6gX37RMkp+N24Z+23?=
 =?us-ascii?Q?RDq+T/VUQsi28vR2N8BEQE4Bi/gMp+cNzwD5NT3Ykgjt5v0L08GR837csv9x?=
 =?us-ascii?Q?2SaRjJl8/jiylbsGllKvALQkQG0lQA4hjeZLDT61Mn+pXHMTYP0NvDzkCy/X?=
 =?us-ascii?Q?Fy73XJr2BqCAKmHZ+G+OhUpAduDJaaBfgUKF93l145Lyp6M6JbdwrE5jL2ow?=
 =?us-ascii?Q?2oQi2lirUp0MO3k8jzMDxL0dYdKw05gvB0svhbIihM3XdZxhQO1DrX/tPHtk?=
 =?us-ascii?Q?EBOU/8RWrESLU9EBZ4V3FIh8fnYMUY9+HNCpwOB3BU5HI7KaQVIpX1XmfyKP?=
 =?us-ascii?Q?MANdSOzk7Ju7LdKA/o3SaG+cDZ3GR13ved0vTCaJjeBSnJf2YxXe0bqXKbFW?=
 =?us-ascii?Q?YbGioUOZozlaDWth+vM03kLSGi0BoLdKtV6qm4EoAuzxfZY5K3iu5FKM9Dn4?=
 =?us-ascii?Q?hnQxwgVaQtOm65A8mzFcCTqRH5+rHDVpiZsqeAjniWPkUJdRyufXCXOWR5Gd?=
 =?us-ascii?Q?RHz6hCxsFAfNFK1ABNBUKNlNAqLo8SoJkhggNh1x5GBsWarDjBYEYhl4sifh?=
 =?us-ascii?Q?scJ4a+uoXKNB7Cmra3lbV6cXH70HKFd7QH7NkP/D+dRxO/JPM3DGm4yC4d9j?=
 =?us-ascii?Q?h6SxsYIbv5GrYtnqLg03NYrOdzL9z+xC7ahAbtPtNqBvgVQAKupH44k2G/XA?=
 =?us-ascii?Q?pOaSHHpcxesYIAPeW2+kUS35yiVkcV45ykI/O3+gSvWkTZstQdVnYDutjoBN?=
 =?us-ascii?Q?TvAuiGEpcqzmb7yi88lB6v5mc2fGB31q2TqrNk23ZahLsn/pHAn9qrnxmMic?=
 =?us-ascii?Q?voMc1gVLXZdY5T2AM75NaEOF9GSiGWc2Z19kEnZ/NCKOrX8rwWdx2yDFYFN/?=
 =?us-ascii?Q?LlcJiQfJ+THWv9B+PJcBw3BB9aP/BTE+Q1SED7ddMSI0DOb9HDG6eU2ncmU3?=
 =?us-ascii?Q?5QQ41IbrbVFodmyjoBKeHeWPanWgohL0mKO13ZBQgtoLJe+tMdF8O+3sj4Cp?=
 =?us-ascii?Q?/h9e1feulnGM+VL/WguRnRcN9+qvhhOxTonj+tm4muHWLRQE3Bzm+9lmz85+?=
 =?us-ascii?Q?qYMFKzS42aUeiUZfq6gKuS0PN25zXzTExWJtYSXG5UeWzvKQUBVzndrGe25T?=
 =?us-ascii?Q?oLNw3jB1vWa0/U74k/fzTJMvAPVbl3dvZpFzPjjRPnegoTWiiFK0eBmdlXr8?=
 =?us-ascii?Q?h3EwXZu6KSEfUktpn8u9ycfA9nzXf+/UrSvqIgBAQMfxnjbzA7/APweRVX/9?=
 =?us-ascii?Q?mKu5EmqjpzIKW9ZUfPIsqKVZBnXrDLxE2JSzjs+6Yrf42PhJGxOfytwBZA6O?=
 =?us-ascii?Q?WLDOKbYLRlxqmep7I2EG6fzW+hrl2BPbjX2LfWrIirIq3qMYsRZxxCfYHjjh?=
 =?us-ascii?Q?Nw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4a82d6d-17ed-4dc6-5a37-08db6c58d722
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 21:55:02.6724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8pVfWFRrPhUJ2bB/6gIXH+DMfTtRM4GIhAQulJ7paTHnU8KORpYzMXnRVWvEfWEECSGqkdZxyElZYS6FMRc+gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The reason behind commit af7b29b1deaa ("Revert "net/sched: taprio: make
qdisc_leaf() see the per-netdev-queue pfifo child qdiscs"") was that the
patch it reverted caused a crash when attaching a CBS shaper to one of
the taprio classes. Prevent that from happening again by adding a test
case for it, which now passes correctly in both offload and software
modes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 .../tc-testing/tc-tests/qdiscs/taprio.json    | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
index 58d4d97f4499..47692335bcf1 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
@@ -179,5 +179,55 @@
             "$TC qdisc del dev $ETH root",
             "echo \"1\" > /sys/bus/netdevsim/del_device"
         ]
+    },
+    {
+        "id": "a7bf",
+        "name": "Graft cbs as child of software taprio",
+        "category": [
+            "qdisc",
+            "taprio",
+            "cbs"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device",
+            "$TC qdisc replace dev $ETH handle 8001: parent root stab overhead 24 taprio num_tc 8 map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 0 sched-entry S ff 20000000 clockid CLOCK_TAI"
+        ],
+        "cmdUnderTest": "$TC qdisc replace dev $ETH handle 8002: parent 8001:8 cbs idleslope 20000 sendslope -980000 hicredit 30 locredit -1470",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -d qdisc show dev $ETH",
+        "matchPattern": "qdisc cbs 8002: parent 8001:8 hicredit 30 locredit -1470 sendslope -980000 idleslope 20000 offload 0",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $ETH root",
+            "echo \"1\" > /sys/bus/netdevsim/del_device"
+        ]
+    },
+    {
+        "id": "6a83",
+        "name": "Graft cbs as child of offloaded taprio",
+        "category": [
+            "qdisc",
+            "taprio",
+            "cbs"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device",
+            "$TC qdisc replace dev $ETH handle 8001: parent root stab overhead 24 taprio num_tc 8 map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 0 sched-entry S ff 20000000 flags 0x2"
+        ],
+        "cmdUnderTest": "$TC qdisc replace dev $ETH handle 8002: parent 8001:8 cbs idleslope 20000 sendslope -980000 hicredit 30 locredit -1470",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -d qdisc show dev $ETH",
+        "matchPattern": "qdisc cbs 8002: parent 8001:8 hicredit 30 locredit -1470 sendslope -980000 idleslope 20000 offload 0",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $ETH root",
+            "echo \"1\" > /sys/bus/netdevsim/del_device"
+        ]
     }
 ]
-- 
2.34.1


