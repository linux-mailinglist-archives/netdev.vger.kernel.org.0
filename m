Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855426756E5
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjATOUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjATOTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:19:36 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2061f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::61f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADBCCE23C
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 06:19:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bw4RubUuncgcl33ZB4DTMQUVyQQK+4DkOcH2V7c0rUlQWXUQeFSacXQtrnOT3BrB+FH98J8d9Q0iWTgw8cnF9X2rU63AzqwHoUOctXeN/cqgDG/IaTbZxJzbbhfX4F8F58YQPv8adE84PbVatZEWuDz7POpOHpRVGHDRBtn0IloCGuHy7FKppIT47c+Rq3Jx6aqQj7LSn2XTkUqF9tj0grlKkbAEytRGEdIewGC0wNkhgj/ithsh9ir1HMJ+gFMDu8VAttDlkLrAWU47r+HxZGgrcA9Q/CpbGEvQSp7PJSkE/yWV32V2ayF6leFwHjaOseJnyD59++KujUDjoH3EZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9QxwvDF50OB9j1+DXLFn2y4gOmvPiODRDRYZFSP/nrs=;
 b=WhPzEcPrw6JNXEgEDhKiiq7JGkCbD+iIFwaNsTIQe4HYL/rLZVT2iTM7LzCz3D0CrihY4HNLQaZPKcrupRUGISNsN39cYj5daGjhzDZ6E6KmQcXZcTzYwtBlvcvgyDDpV+n3aeZhuvGhOTJNplMhmfyh21BY/gY3WKiNp7/gZNa+I40He1H9OJHIeD+JZ42yp1pPBz3qcmBHp0F3Wo2Y8IxLrIacrVeoC7jlfTbW4j5gVSvTP0XKyUJaaFn6l1v2C/IQYOKT6ukIYEaO9v9YEc99b7BROpAiGaBpYSgCr4L0zgf4G7xQ+K2WBcDU0Gy5EkvCq8nut9ECnLcJ+xWqdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QxwvDF50OB9j1+DXLFn2y4gOmvPiODRDRYZFSP/nrs=;
 b=kuVzZs8e6V/6Xaw7Xqp3NZ+FVym+rIwtw/R9QSZ1FfFNfAh8X2SaTwZtMYsjj4+Mer5ggdVi9K5J4w2B2dUfWzwssHBx/Vxei1SApb4/G19ctAHbfVb96ql6n+nUv8BU8UK1m9v57HuQjb3VUZzIijk9X1pyE2q2PA2labWCdQU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8085.eurprd04.prod.outlook.com (2603:10a6:20b:3f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 14:15:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 14:15:56 +0000
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
Subject: [RFC PATCH net-next 04/11] net/sched: mqprio: allow offloading drivers to request queue count validation
Date:   Fri, 20 Jan 2023 16:15:30 +0200
Message-Id: <20230120141537.1350744-5-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 59c579ee-cf69-4526-f135-08dafaf0d87e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4bQk799QqMPJNasiJw8c3ltaehAuoZEr0pxz0Cv3Nae1h1cfIj24KMdeAe5NA0EuVRe8fz4/d1ORZoXcXKfdjZBmvDxx5bvcPJP0pBLzDum9oyCheOLjcm4KPtw0CVAA7YH45wT/guvobbu/fRmxZonDMfIVtty4vcgC0P42ahlT1KtluabflEmWhrtM4lnupwIPXSgOk6F6MmoiphbO1rFYWmVGnH+jy/N71VFVQ1zO9Z8jlLOGhnv/W7AhrUKEtxCtbTlB7kbCaP0PzDBCilVAV2Kh6TtW+ww1E2TPRYixa3lf6ZzU2gy/09Bg8Jorun9TUhxm/OpdQ1FhW0YWK7gy8xMj8iFSn1HX3nfHLCv8tY5fMwuq3Phu2f2VoTc7f0flz5TTOURb5Yx4IboB7zUWpsG3fGLDmz/XX8mI1wDglYosCeLIKl7U4ml2vmNwVRaNLsCVkEevo3wMjax+q3XksdMgC2OWAYtVuF3WVK0W/KA71Np7CX6ZFUmzmB8fcF+C9BMMnWvG3RurhHVkNu6X0ZzXulFsjJRzGcaJWuNpM2Dj7AdikBiUJfAR3i+Izv37FTBsxqaIwcf3aamISx28eAEG5MZEyqJK0qkXyVxgyiPTrKDZJsx5N99F9uSwsEoLLJLUvAhXIYkgFmYXK4KQ76gFBhvCpeZZBp8YsqwCE8Nj9TVK5rBph0OmeXzilhNAhwJ4VdW+QvcQJPQ2xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199015)(52116002)(6486002)(26005)(6506007)(478600001)(66946007)(6916009)(8676002)(66476007)(4326008)(66556008)(5660300002)(6666004)(54906003)(41300700001)(38100700002)(6512007)(8936002)(186003)(38350700002)(316002)(7416002)(86362001)(1076003)(2616005)(83380400001)(2906002)(44832011)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GikWCibrzZWjrCjm/D7UoTy8Ss/H9chLS1gc7KM+7mjG3oPCRJnZDPdKZ0Ew?=
 =?us-ascii?Q?xJKTtnIPVztXdxrnY8MzSY62wQlXIs8YhiOPWDc0qvPatScsoHUXw+hdgAX2?=
 =?us-ascii?Q?2guUzANcI+RXyapmxaFv9mzFeDhjPTu/PP98HYLcTv7/bj/5IQOkNpZ1H3/H?=
 =?us-ascii?Q?oQg92Qfn0cBJwlK2ZU18O6ZxykLqXW6qhmQVcEcws/nYiV2NFfOE3SmUIDiH?=
 =?us-ascii?Q?JvIyS4g7IwI0sYH7JF/dehDOCRny8ji9Twc4KL5fyk1zFlgVhUXAFRw3fivX?=
 =?us-ascii?Q?6uAgtn1Y49EXJq0s3QrTBE6NgKxMpy7sQh9Xm3fXE67OOUY+D2J+NK6We0lP?=
 =?us-ascii?Q?5Vf8Ie1HevGBcLpa29sSxgJGfkG82bOl8Db/dbKAn249wmAdefxNrmtLOgGB?=
 =?us-ascii?Q?Z5eGQFbxtjX8RfAYqK722IQkVUjPYiqFlpkLXveplfGKuCbTEyxo8VyDO340?=
 =?us-ascii?Q?80UUNT2JR+B0mK+joLcHpriZrRIhl/E7NWDBQ62rxr7Rgmy/HKp/ysv9fQVU?=
 =?us-ascii?Q?fbbMgf5D6zrAok8a4u5IkeXRDUgRfyIJN3O/UCqcXUvsS0RVLVFnOrQ/vjq1?=
 =?us-ascii?Q?0LtNb6avvqPc5X1I5d2BSrsOBHSROhWvwVEOAvzL97zdGAcdf2U0y2yMeBcY?=
 =?us-ascii?Q?tuFStwLjZJmhoBl/nuyA5dHa2FMAw8N44SQfiXD8SJIfo8LXluxsCVBHrEVC?=
 =?us-ascii?Q?baRguUCU0MT9N8OZ25ZZxkdw0tsQ3xipbkx0kHHJL3xzXZ7jTiXV7D8ucMo2?=
 =?us-ascii?Q?NupO8jqHYV9ADL3mTZECWFd85dCORSC0k1BHfbd2cwwOwdPsyyor+vs8DVRD?=
 =?us-ascii?Q?Bb676ZNxcdegmL5KpyAXXjQOGiIA6eUcfqo8qsazM+z0YALRuUOiBF1da4Md?=
 =?us-ascii?Q?oXB0fPkEUBQG3KEYL1ynAJ28LMmjq1q2hc3zt/dy0sNA2QClIcBLnbsqiMSp?=
 =?us-ascii?Q?oQmDEWPldWGIRJzCVeivRYwuCUwfFqGjtTd8xZdos7IgzImsKWyfFGHu2KPv?=
 =?us-ascii?Q?NN5jg1YiCAQPKd6lN6h02+elPzphoDulG8PFju61AS51QSeIhMx8Nfh1CwgO?=
 =?us-ascii?Q?WTZjPsdSFU31BTVjvlDg+pRR0RiMPLg6F6UEy/mSsJ2IUQ+IkfiNzUvIPFT4?=
 =?us-ascii?Q?eWKCuEWy8IRnzYgGl4vstlNqPaM4xeCIUh3TsT0nB6As2U5P0bFizEPpYd+s?=
 =?us-ascii?Q?SISu4luwFOzBlKKXeP0nCw+kJl5NK9hjeDif6OAEYuy1tM2CRFj/pCSPtW5d?=
 =?us-ascii?Q?IySSUDw7AmWiCe55UM36Tf8xbNKlFO3JT0JGa1MqbBmnda4GgOtIY1Y/LS9f?=
 =?us-ascii?Q?VrGEbzmlAxj6SqMgC1mPYdj7yNGRap5uWn4EhC/p00OWa8kpjwnIIsvUTn9h?=
 =?us-ascii?Q?yl29J/MrFnYMX1ZelANy99gNvRn2rCpxeyDvz9J7w4EtHTTHM7AzIF7kLS+q?=
 =?us-ascii?Q?cX/8ccAEUqnUgrCa+iwx/LxN1t55fdtzBFB3REPXm5GB68P+CFjQr38/poEO?=
 =?us-ascii?Q?quGm5lqoORCNIwb3cKyjx9IqQWHAPELzFsG9dtkzLiOunbQwwgnaL8zsZ27B?=
 =?us-ascii?Q?IdIJj6/uZMSykFtbXJ7a83jxYT/vJbmwm9414f7BUO+CgOcOQr2NDA1WZW+i?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59c579ee-cf69-4526-f135-08dafaf0d87e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 14:15:55.9670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tcqTC+c5gnyTEDVqqLTbwa1p9oEINvimfvR0uFMfuqWfup6fNkeeOKRRjaNtgSsrtQ/+/6PI9rnk99L6Xi8Dhg==
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

mqprio_parse_opt() proudly has a comment:

	/* If hardware offload is requested we will leave it to the device
	 * to either populate the queue counts itself or to validate the
	 * provided queue counts.
	 */

Unfortunately some device drivers did not get this memo, and don't
validate the queue counts.

Introduce a tc capability, and make mqprio query it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/pkt_sched.h |  4 +++
 net/sched/sch_mqprio.c  | 58 +++++++++++++++++++++++++++--------------
 2 files changed, 42 insertions(+), 20 deletions(-)

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
index 3579a64da06e..5fdceab82ea1 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -27,14 +27,50 @@ struct mqprio_sched {
 	u64 max_rate[TC_QOPT_MAX_QUEUE];
 };
 
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
+			if (last > qopt->offset[j])
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
 	struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
 	struct mqprio_sched *priv = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct tc_mqprio_caps caps;
 	int err, i;
 
+	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_MQPRIO,
+				 &caps, sizeof(caps));
+
+	if (caps.validate_queue_counts) {
+		err = mqprio_validate_queue_counts(dev, qopt);
+		if (err)
+			return err;
+	}
+
 	switch (priv->mode) {
 	case TC_MQPRIO_MODE_DCB:
 		if (priv->shaper != TC_MQPRIO_SHAPER_DCB)
@@ -104,7 +140,7 @@ static void mqprio_destroy(struct Qdisc *sch)
 
 static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 {
-	int i, j;
+	int i;
 
 	/* Verify num_tc is not out of max range */
 	if (qopt->num_tc > TC_MAX_QUEUE)
@@ -131,25 +167,7 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 	if (qopt->hw)
 		return dev->netdev_ops->ndo_setup_tc ? 0 : -EINVAL;
 
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
-			if (last > qopt->offset[j])
-				return -EINVAL;
-		}
-	}
-
-	return 0;
+	return mqprio_validate_queue_counts(dev, qopt);
 }
 
 static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
-- 
2.34.1

