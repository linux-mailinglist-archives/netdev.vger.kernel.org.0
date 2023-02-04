Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0F968AA61
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbjBDNxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjBDNxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:38 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5201E14EBA
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0niH+tAHiTRks+qpC4CLNkyiLlUtRV+FwPbRVfO9kdGEeTRaJnn0eX8Wz/jejPEM6g5/1RAxZuJ++ILEQlx09Zhd8ZDdTm2mpMU5lMpTtzBPc4xMtRVdKuGCJfMqe2T9c9ADA4Us73baL8pwUmHAfwrhTFBhPClQ7EY2NkB5euPTOw2in6nlPS4lVAmzS44t/rPCrbqXCykxdPQETRqnWnaxD6j/iK7ll8z+SlnULaV9KscTFC3to/aZcX3AnGAXmubOGYuMewaMDIgFJVFTivISz2qXJ/tY/8ApI+XnpN4eQ0e3MMgm2DJGZQBnUPvAw/nhkpQb6i2ESYW8xrlMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xccDVn1n4vG8BCXayeiGASZGfI/DCNWiZh93zHxuSY4=;
 b=HNC2kn1Pk8i4HQrCnrH1QtjpQl2cFoOsNt31UaoYmGt/C4ocs9441OBILsnCphViR8dPyCM98d2P0kDGFGZT4uE92rN/C3KOZOlIRiaTI2VlAYD6L8uYTxvTSQK0aNNK8dBHGz/vZ3Kih99M/HwSeK1fNTtJ6C9GAJG4R4MXQJNBQnHZYBYTZPqBvRjQ9EjoQl6+R36OvS+exTw855r2VBuk+tjNuHU5v3p6KrqAhPmBetnQntqKcl1LesEgrVA6kJcXY+MBwUbvHdlzq2UMkgaO1O67MCWAWf9C2yXpl9SqfaNHmsoWAbw/Wnp/GSE3g4mHga1umkuwSdMGQA0xIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xccDVn1n4vG8BCXayeiGASZGfI/DCNWiZh93zHxuSY4=;
 b=iui9gxdWts0F6lxc/CxvWLkREu6pVkVnafh+U8p+kxsCU/lFGJ0/dq8nFSUTqv5PAPdKd24L/z2aUzZ+lVms0GolMO/eHJev2UI6Gbhed3/Vh8rspU1wOG4dfLipmQq7JiLlgR2u3WDKeE0QyJuJUZYS5HqcRUjMU/rXYRCrELw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8783.eurprd04.prod.outlook.com (2603:10a6:102:20e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 05/13] net/sched: mqprio: allow offloading drivers to request queue count validation
Date:   Sat,  4 Feb 2023 15:52:59 +0200
Message-Id: <20230204135307.1036988-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8783:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f32f874-7b95-4f5d-8329-08db06b733a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XZfmoGKEWwPQ3D7c1jxGiB7ytG9jGvLNjVkuNGrk+aFI5UuMlDInb8VThl3zV/Fv0IF0JfwmaxR8q6uiL8XrEMrtfcbKQ5qFmJUQdeJId2D6PIeyJJwd7Fd4pzdmMp+rRHmrPVdyy2iVG49wRSeWE+bZhDpuJJNIkTOQEaQg52azEFOWBAtHWi0thnNBl8M0pmoAiLPlRSjEaVrsXyMPE9t5DFist2cwOLDplOBqkAKKEFGkf7RaW/44DZHJBdjAZKiXc7q2qqy/ApsAvxF2bd0OrTGifgmOTpgz52uiiJfvXWjxUs1Iyj5clHOLPq7Jlgj78kVO+SMFYv3azNetUp71E6a/d+FdPXy0yKlDYKPLMYPoqpAQivn1F1wVYrn+LDhPvwoY4MOBrjh4twSpiZ8ZFmCfM/+ivOx5QpQKUSQ/UWhZzKxJDAExYhVt8Hj6otw7zg3VxaJjIRYtuLFhn7lr89fiZQdtwNzaNh58Y+J84IyYI9Bs4fdCjC4vbtAy0GjxQEIQXguFl4t0+sfrgMsB6a9pB2bbFtTLjyToABj3LdztctyG5q8lHIKhZ9ErD97Rt6VMqrIa7ALNANmmG7YhX59j0tEqwptiTO2g/9Z38tCqond3IbmftFSaZTgU9xeD0vIa4ZrDGh2RCHmgR02AUwaihjZ5ZO4V1mLIO+C/sUhwBqTCf2iE8K7pBsOcQDpKQMVXNxYSXiqM02twHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(478600001)(6486002)(2906002)(52116002)(26005)(6512007)(186003)(66476007)(66946007)(6666004)(6506007)(1076003)(41300700001)(8676002)(8936002)(6916009)(66556008)(4326008)(44832011)(7416002)(316002)(5660300002)(54906003)(38100700002)(38350700002)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WmIcwk2GKQR3DvmtQaiNIrYYO6UwVdh21TRY082doXP+tip7HAaTOWMl+YI4?=
 =?us-ascii?Q?OQiK5KwtHVZ3YkeDsWpgWqYq8GrU8m+3wWy3M0MkvuqUWnePiGIMX6lovLcm?=
 =?us-ascii?Q?3s+nMdk1yTsAsovIOraOwlg6TlU+IC5TS/mW/otultXYSX8gWZwkLmWs2Zai?=
 =?us-ascii?Q?JOkQ4dNCkptFoXNq2U7hspynBm86eY5gySt3HCDEiZqOqftlvqRgYDFJOkjE?=
 =?us-ascii?Q?qTLlBfrFXqFksAva4zzUSYX9OjuDZRdULoHARYaDv07VY9JSR65tWef9ShD5?=
 =?us-ascii?Q?WF7kGt7Ui5XwYK5qpuzQpUTLyzmBx4qd8OaLyI3UphvlKpIcexNNEYdih1bd?=
 =?us-ascii?Q?cUE86EAs1DORmrsyYFKUqba+sjYs4wrHj6h6vwLnG2L+zYLyT1y0vE4g8JNv?=
 =?us-ascii?Q?juwL8oNPIMwEd74aLl1Yiu5uMJtqI1qgl7ILqtWw3Evz4wRzseAEnnlRiBrE?=
 =?us-ascii?Q?NnPSfvb0ex+AdabuDtR5C+Fi2mHNM3vIVGucVgGDBeSlQZ2NrxCZNAiBoTd7?=
 =?us-ascii?Q?E6fD+PKoisviAdaV+Ewqr3zYGw8T7GY1tkhQsVxM10RZVK5rqz2olsJDfVlb?=
 =?us-ascii?Q?foIxGlGcIdTAn0y/UYDsdu3XteyQ945HeZV8yORjuDSrXyNsHIpdgZAKWF1i?=
 =?us-ascii?Q?LIBqe7jHKjuLJOaTFtXLLJ3ouyqFvm/RZtXgw1i04sg0mc0TKgN9X1r5uwGS?=
 =?us-ascii?Q?oms6Xl+8luanYTiXDRwSw8cUw1t9gfmNU/prUoMJqEmn+Q6TvOaR9VV/amiB?=
 =?us-ascii?Q?qxnAE9fRPYpoXtzPzr/BFeQG+SPskM5EdWCaINhhI+PPGITB1XxOkQ/DNf5k?=
 =?us-ascii?Q?EFDgYCKKzuixWQOSUaCJjLL0y6y62+GkrW9r6IGOzhtXgYCTt1F28uvEqhEj?=
 =?us-ascii?Q?2gebQqLPiAN5E2uEMf7K0RW1uL71jDJWn/e9lrtpEp+y3B38fuZtTcBFXhG2?=
 =?us-ascii?Q?BCp89SfgNBpJg5LuazbD2iItCEnkmjfBSGR+ICIP9banLRUJXfT1C6F2j01J?=
 =?us-ascii?Q?acYiYiHl8HPWOvGlVhQ1ZD4sLPnNn9E9r0UMOYdHsbZiqJaUY0Zi35WJ6+Q+?=
 =?us-ascii?Q?YklWMj3ou/GS8K4hmwdYq5v7LiDa+U9e1xsDteTOKK2ay3vnQGoGWkn7aeoG?=
 =?us-ascii?Q?Sh9z/T7vsd4mn1BHJ2tFWvakpqPs38BQRucw3sq4yWcPnMnnmPFLC9ySoEEo?=
 =?us-ascii?Q?xBQ+r8K0mh59XOvAKZvLF6/txqpP9i/Pue9FbcKcsdkI/PNQeLdEkt2FPlqs?=
 =?us-ascii?Q?FON4X/8UJIpSQ7BuzhF11/lQg+xq2dVfqlQ+PIdA0NyEQGFvL3/4iWPqvGLO?=
 =?us-ascii?Q?O2rkQOc8thuQ/vfSq/Z9lCljFbN8T87mgZW0LChmygXGu5sVcX8onsG4KILK?=
 =?us-ascii?Q?31YmjQKDDDqxg/FGUnWwZjaJZPAuCnr8OHW5BuUsIlD3IkYG96jqMIG6UPPU?=
 =?us-ascii?Q?ytCeLptCD883u1U6ifvX3OnOIQb0F/HORVmxXd1n7ty+afZz+QVTmxUybVMO?=
 =?us-ascii?Q?cgg1qiHYrBcquwCU3H7kjxsTVYx8Zw5qiqmgWRBHmwaqKoFf1YLhFMjgshff?=
 =?us-ascii?Q?0pAD+GaeHfcjEPIwKlOjJRXZO48evJa42JYI7HPw/C5HeCK23UbUljrJHYfo?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f32f874-7b95-4f5d-8329-08db06b733a4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:32.0602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxKIDhciLyFmBFetNZVQJR3GiGF8YudF8o0Egk2VahBK+iPg2vJxD4a2O6tavPmpRdqSc47PEj+uDpq/W3eAVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8783
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mqprio_parse_opt() proudly has a comment:

	/* If hardware offload is requested we will leave it to the device
	 * to either populate the queue counts itself or to validate the
	 * provided queue counts.
	 */

Unfortunately some device drivers did not get this memo, and don't
validate the queue counts, or populate them.

In case drivers don't want to populate the queue counts themselves, just
act upon the requested configuration, it makes sense to introduce a tc
capability, and make mqprio query it, so they don't have to do the
validation themselves.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v5->v6: slightly reword validation comment for clarification purposes
v4->v5:
- call qdisc_offload_query_caps() from mqprio_init()
- call mqprio_validate_queue_counts() only once, from mqprio_parse_opt()
v1->v4: none

 include/net/pkt_sched.h |  4 ++
 net/sched/sch_mqprio.c  | 81 ++++++++++++++++++++++++++---------------
 2 files changed, 56 insertions(+), 29 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 6c5e64e0a0bb..02e3ccfbc7d1 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -160,6 +160,10 @@ struct tc_etf_qopt_offload {
 	s32 queue;
 };
 
+struct tc_mqprio_caps {
+	bool validate_queue_counts:1;
+};
+
 struct tc_mqprio_qopt_offload {
 	/* struct tc_mqprio_qopt must always be the first element */
 	struct tc_mqprio_qopt qopt;
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 25ab215641a2..0f04b17588ca 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -35,6 +35,35 @@ static bool intervals_overlap(int a, int b, int c, int d)
 	return left < right;
 }
 
+static int mqprio_validate_queue_counts(struct net_device *dev,
+					const struct tc_mqprio_qopt *qopt)
+{
+	int i, j;
+
+	for (i = 0; i < qopt->num_tc; i++) {
+		unsigned int last = qopt->offset[i] + qopt->count[i];
+
+		/* Verify the queue count is in tx range being equal to the
+		 * real_num_tx_queues indicates the last queue is in use.
+		 */
+		if (qopt->offset[i] >= dev->real_num_tx_queues ||
+		    !qopt->count[i] ||
+		    last > dev->real_num_tx_queues)
+			return -EINVAL;
+
+		/* Verify that the offset and counts do not overlap */
+		for (j = i + 1; j < qopt->num_tc; j++) {
+			if (intervals_overlap(qopt->offset[i], last,
+					      qopt->offset[j],
+					      qopt->offset[j] +
+					      qopt->count[j]))
+				return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int mqprio_enable_offload(struct Qdisc *sch,
 				 const struct tc_mqprio_qopt *qopt)
 {
@@ -110,9 +139,10 @@ static void mqprio_destroy(struct Qdisc *sch)
 		netdev_set_num_tc(dev, 0);
 }
 
-static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
+static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
+			    const struct tc_mqprio_caps *caps)
 {
-	int i, j;
+	int i, err;
 
 	/* Verify num_tc is not out of max range */
 	if (qopt->num_tc > TC_MAX_QUEUE)
@@ -131,35 +161,24 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 	if (qopt->hw > TC_MQPRIO_HW_OFFLOAD_MAX)
 		qopt->hw = TC_MQPRIO_HW_OFFLOAD_MAX;
 
-	/* If hardware offload is requested we will leave it to the device
-	 * to either populate the queue counts itself or to validate the
-	 * provided queue counts.  If ndo_setup_tc is not present then
-	 * hardware doesn't support offload and we should return an error.
+	/* If hardware offload is requested, we will leave 3 options to the
+	 * device driver:
+	 * - populate the queue counts itself (and ignore what was requested)
+	 * - validate the provided queue counts by itself (and apply them)
+	 * - request queue count validation here (and apply them)
 	 */
-	if (qopt->hw)
-		return dev->netdev_ops->ndo_setup_tc ? 0 : -EINVAL;
-
-	for (i = 0; i < qopt->num_tc; i++) {
-		unsigned int last = qopt->offset[i] + qopt->count[i];
-
-		/* Verify the queue count is in tx range being equal to the
-		 * real_num_tx_queues indicates the last queue is in use.
-		 */
-		if (qopt->offset[i] >= dev->real_num_tx_queues ||
-		    !qopt->count[i] ||
-		    last > dev->real_num_tx_queues)
-			return -EINVAL;
-
-		/* Verify that the offset and counts do not overlap */
-		for (j = i + 1; j < qopt->num_tc; j++) {
-			if (intervals_overlap(qopt->offset[i], last,
-					      qopt->offset[j],
-					      qopt->offset[j] +
-					      qopt->count[j]))
-				return -EINVAL;
-		}
+	if (!qopt->hw || caps->validate_queue_counts) {
+		err = mqprio_validate_queue_counts(dev, qopt);
+		if (err)
+			return err;
 	}
 
+	/* If ndo_setup_tc is not present then hardware doesn't support offload
+	 * and we should return an error.
+	 */
+	if (qopt->hw && !dev->netdev_ops->ndo_setup_tc)
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -254,6 +273,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	struct Qdisc *qdisc;
 	int i, err = -EOPNOTSUPP;
 	struct tc_mqprio_qopt *qopt = NULL;
+	struct tc_mqprio_caps caps;
 	int len;
 
 	BUILD_BUG_ON(TC_MAX_QUEUE != TC_QOPT_MAX_QUEUE);
@@ -272,8 +292,11 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt || nla_len(opt) < sizeof(*qopt))
 		return -EINVAL;
 
+	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_MQPRIO,
+				 &caps, sizeof(caps));
+
 	qopt = nla_data(opt);
-	if (mqprio_parse_opt(dev, qopt))
+	if (mqprio_parse_opt(dev, qopt, &caps))
 		return -EINVAL;
 
 	len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
-- 
2.34.1

