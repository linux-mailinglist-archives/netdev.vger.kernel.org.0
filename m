Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85D96756D9
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjATOT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjATOTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:19:11 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1883A743B5
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 06:18:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSIdcN4zmR39quRClKJgZ+kXAa7EBxPRiCtZO+qdLeUHGZbt5rIPcVaSE7Sg6LgS+lEfqxt5FnRYLhB1v7LDlXJNZpt0m2HF9nOb+Ivrx5el8la5Qkzfe7+da6dwkMPtXH/95dBA7Wkt3LPn5SlULDFxlgcziTk5p8gtlnQdCF9BBnH91BSBpb169rpWzA15Y8wK+ov2IvbmVLaffO7tTSOp/vIEQtW+hDq7pX2Q+QZA8Z0pKMpSGBKFw+H9dT68HVVAuJ/A1P+DB9wBH2P8ZVgOIJO+nQR2SRC+y99DefmMI95mYXJrBlKyvawHaD+a7PUW5n/azhk6/a+8v9+GoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuSN0E19WYhLk5bnVHQu2WkiY7ak4i/68A/o80YQcN0=;
 b=gj0cpAU1hR6PwV9mgFZOYqJ8o+caB4rZ4v4sOxmsT3SrCyTJa33vKga0NhFutodovNWWBGDoNGyVkuX/dch+rEVljtRoxyuQG/fuFK2Rj3Rd+NGAYcRF/aVQju6Lcl/td0cB5nVJkaX7L040KyZO1MsPwkprl0nwG6m1D3AKDaO32iEZRhFXHPs0KV3PGzFD5sHk1/3f7klmP2TB/Gwv9f4y8i7D1TOGYL57NL/moZmKC0EtwWjYqWoDE4pRjSJzCfXmWpx5MgorBxSVOtXnA86nh6jxOSqPFMNgPfYWfHHb2+GVAcEbeZ8TyjDj++2JIwhCLRzHXrhnBd25yGKj9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuSN0E19WYhLk5bnVHQu2WkiY7ak4i/68A/o80YQcN0=;
 b=RlLzy8sIYC+O51itcJc+5QdoWApuK0QsdSxTI8Qk8WCv1dkLWRQtD6B9al+bDauVsHnAzYzM42RSe0aDMYgwbwof6eEieDW1PTP9If8MHGO2rxzSaBCo1CkCkiPwhjOvhxjavayhvP301d6YMY6ACT/ssrL372fvxtfbT6+/M6o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8085.eurprd04.prod.outlook.com (2603:10a6:20b:3f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 14:16:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 14:16:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next 08/11] net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
Date:   Fri, 20 Jan 2023 16:15:34 +0200
Message-Id: <20230120141537.1350744-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8085:EE_
X-MS-Office365-Filtering-Correlation-Id: a1ccd751-1844-4560-b4ff-08dafaf0daf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SGrO2Ic6CEfH3A4hRPDd2Avb/N0AGS/by61oR3quTBFPwGyJRu279ldP8IFLch0q4BPYf9ZH4N9s8xRIo3Q3HYJp2lY+NzkF1ILnktvheR5ug5KdrhqUKC85vB98qg4RY3jY5wDP7TSwcNIUD5ZyPZK3vchgpyvl8lGR7qvAKMmGHCsgTkFi07Bh6TaIhsli2Sn+64fZ9M4FUWtYK0BXLmPutUfPASLGkf7Ey4JqHl/IRRfvp8DYcr4E3m0VPEoz+CITzGyB4p3FxjUoafn0hjVl9uAJeomnNwyvb68ULX/mxfQ5u60ssMUNmPZzgLSuY6of6uir53Og5NRETfZvCBPocwcGqUnIQlaO0/649wiVQwuSkSDthUuMsziHj7ENY0PplslZqQdCeGSLQS3gqZvnceGgUyfUwEhQrJfoUbLIwuQdJY6qL+n7GfXNRfF/cnGk87XXV7EXpsWBYOd5F8VHytKR0tEfLMnBaDteDeBEzwdinkn3sWXZMIVALCNSKqQaDsGhwSeb74BDLrJl1hwO2aVyOmtnCVWOhiaOx2AL0ToX/zipX1UtZWlWt295xCZ64qv0Ua3OremiJMSQU9WFD7qnEVzw8W3Mw9xeMtwOJojPxPBB5HjHwHUM7YWzYwKQwrfvqBBuzQKT0IcEqwXW6oO5QLyxphPphc7ErAu82gaEmchJ5zrZ9bSsYuR9LPn5tDUH5pxKeXFUUj5oGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199015)(52116002)(6486002)(26005)(6506007)(478600001)(66946007)(6916009)(8676002)(66476007)(4326008)(66556008)(5660300002)(6666004)(54906003)(41300700001)(38100700002)(6512007)(8936002)(186003)(38350700002)(316002)(7416002)(86362001)(1076003)(2616005)(83380400001)(2906002)(44832011)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4MYC8Onij8PlGIVxVpYTDOTgptp9lN8AD8gfK5n4nyD0r0ZnMD5QG46RSClW?=
 =?us-ascii?Q?9HvKgGvC6r8yZQjL4h1oONot5t0iIhpV6z2Cl8wA4b5TUTh0+im2sMe7cb9P?=
 =?us-ascii?Q?HU/11NrlmSAW5nfLIGyeexQfL4ZckzJnH1hMyUAhtOpgLpjgHn/hz7RZ6U5N?=
 =?us-ascii?Q?wzcTs4g7Sx1nlbIAKw1+sBQRE3csTPQBPqofTmvSmmttX0TxY1O1tVwun64A?=
 =?us-ascii?Q?pDC8gk9Wz8RrZG9MfbMfzgVKxULDeoPbXrsJ0mVPQjrXgYn99xPfFpwLZGB5?=
 =?us-ascii?Q?IhP4ybX+imhKC2qn6yBRspCDfwHR7673PV93zcKdykJ1nXc8Zbiaeaq42fn8?=
 =?us-ascii?Q?s31W8sawx73Opo1zPsjLfB/XG33cukiGy78bdnjZ4h4bp2eJ5MsAar3Bj4xj?=
 =?us-ascii?Q?S1FO2xGQWS908+n3Xf7GI7kJxEyDES7fz9UgRW6EHkagD0w1rz1Oyhp3HySr?=
 =?us-ascii?Q?PHdPEhbXcOuXqsgtLWeTwZHqk26s/Y55pg4tK1aUDolcHuIeFED7EmDD7r7f?=
 =?us-ascii?Q?QfW6z91lKiP7j0kVgl+6rluhv5VrQf5feZxsIdR3m/W0Kn865ov9zIp6foU/?=
 =?us-ascii?Q?6FOMwFqGLe3YBlCiSdbF6xFMiSxaSEQ/RPQt/8AinLag+mOhxs+re9UwaQn/?=
 =?us-ascii?Q?pzfH2PHZeoG4zeGurh6Z2hHFLFIn87BDmeim0LI+exClmEIaOBfETvmlMMeZ?=
 =?us-ascii?Q?VMp9i5hMnZDvctkN5KcmrEQ6bsHoID5/emmGlksrJRzHa9a6bbfdQbR0hHp1?=
 =?us-ascii?Q?C/uLcU52MP3DbLqQ9lrqUYdt/13lTZXc4wn+DyJr43hmKv5cv+BbPeEdIuRy?=
 =?us-ascii?Q?tGIFDaHQatSN3D4qbd/e78FG9oNnFu8NzJsFNQE9755tzpvWCEF0aDlBnjbA?=
 =?us-ascii?Q?jmnRFpt2yPlqmIaReUrzBaCCer2aDUdVWQ5uyjPNrWmuQcMXofM4SrCdst53?=
 =?us-ascii?Q?OCLpnK1wGmeZ2VeHtZCTQ9d3k5hhLNoLOqaAC/JISgh5ZJ2NNVfSL4L1hpKd?=
 =?us-ascii?Q?kTn0pxF9LU7Kd+ITS3Ha0MCXXvaUeHjxteWKbYuwtxgRVrU4+rgvBfMe924v?=
 =?us-ascii?Q?B2XybpCFz/jfGMtWe861NcobeP7XipvWy5H9NZdxk5LBviTvOXL8LQyi2ckf?=
 =?us-ascii?Q?eaJbfCOHeWe9BJrzoDsC5RDOPy1OLTtqns0aS70TTStkOYrHY+DixINmoPhv?=
 =?us-ascii?Q?LA+YU+h0SVddEsbFneRi2jp36I/T3Nmqv400raYekSZFq8gHIC+jtNAAu9cx?=
 =?us-ascii?Q?9i3M+X7uH+0oDsR/hwvE2XfF1ULXjbwA7TWQLPSumcHR7bWy9iMLAabNmmQw?=
 =?us-ascii?Q?0FjAaTDl4iodrP4/19Qy7rPIiUwWwwO83HR8ehXOvD4SbKHwgQ5qsSfzNMSy?=
 =?us-ascii?Q?3DzdaV12m5yCEv3kbEVO8xhLuc4Gi9YegJlLvjEX4bP88/fxUJzCGjKIix7M?=
 =?us-ascii?Q?/taAmIHfIj3m1ruNVF60jB3rdPQoN1ZoEVgPHADM+HeGdLRhbDYNE0roY0ao?=
 =?us-ascii?Q?EPvD4y/eYBsq6SyT/wrTx2cPq7lGkRJVtd9Vcr0GWQtLwwziP4O8ZnWk5K5M?=
 =?us-ascii?Q?xs1xfr9J2p6EsXPK3PxfBeaRJn2nkb93zk4/fYL34aqcq1AmDMFeFdXHc/bn?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ccd751-1844-4560-b4ff-08dafaf0daf6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 14:16:00.1073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pV5GRG2xmHJ03jzYH8pJqJg5aXHid2ZmIfN/Q/fodbgHTx9vuUlA1oE81aTHMzg2fuQj6srRZ2K7v44eWvYSNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8085
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some reason I cannot understand, the taprio offload does not pass
the mqprio queue configuration down to the offloading device driver.
So the driver cannot act upon the TX queue counts and prio->tc map.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/pkt_sched.h | 1 +
 net/sched/sch_taprio.c  | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 02e3ccfbc7d1..ace8be520fb0 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -187,6 +187,7 @@ struct tc_taprio_sched_entry {
 };
 
 struct tc_taprio_qopt_offload {
+	struct tc_mqprio_qopt_offload mqprio;
 	u8 enable;
 	ktime_t base_time;
 	u64 cycle_time;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 570389f6cdd7..8f832fa82745 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1228,6 +1228,7 @@ static void taprio_sched_to_offload(struct net_device *dev,
 static int taprio_enable_offload(struct net_device *dev,
 				 struct taprio_sched *q,
 				 struct sched_gate_list *sched,
+				 const struct tc_mqprio_qopt *mqprio,
 				 struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
@@ -1261,6 +1262,8 @@ static int taprio_enable_offload(struct net_device *dev,
 		return -ENOMEM;
 	}
 	offload->enable = 1;
+	if (mqprio)
+		offload->mqprio.qopt = *mqprio;
 	taprio_sched_to_offload(dev, sched, offload);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
@@ -1617,7 +1620,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	}
 
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
-		err = taprio_enable_offload(dev, q, new_admin, extack);
+		err = taprio_enable_offload(dev, q, new_admin, mqprio, extack);
 	else
 		err = taprio_disable_offload(dev, q, extack);
 	if (err)
-- 
2.34.1

