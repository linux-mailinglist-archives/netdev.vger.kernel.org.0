Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECD06756CF
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjATOSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjATOS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:18:29 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357BFCA2A
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 06:17:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvJetuT1i9gkQsP/WW7YP1HDZlcTKRS4/uFWaO2gRsLitM2jDjfMKle+ePgvISe3stCAcbCB8P9MQAFc8Gslrpjd+ZYpFsG4TCaVrEeAWVjMrfQkLha4d7RKucFMgLHKYgBBPlUdv06ywKzByTtpT9yYIg84viCVAf4LRVJiJr5uwP8paZaD9Nycy3hv92tYrOxVmVFLf9eoi1qLM3/bbOHUN/j4cN9MsBvM8QGyjRx6jDnMPVKkpQdAmjw7Nr7lOz1ASqFjahIuwDO5hwjy+1mKXiBpXcn47BmrAqz43cLLI6FJ12J2LnVuFRkX5nALeqfBGymqoBgfjflF5eQK3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tx0nkv7+EeqUYuFAxWzjrvCXkJOnPqXU9Ap7mB0cnQ=;
 b=L0UPZBFvLissy3vKIWzi6+Z0slDY1tgL/vFTbJffOqg4UpiDjKMTGTk/VVOB4+p710403vEInxG0vyZfL0a5vOd2NEKWUJiKNuYxtofneZrJ4R8yLHLojcxNOCKrrr6jefoZgY55PswVOXrUYZGRZymJR1FzNbnfaM3q/8Gsbo/33FlOEOve4ZPXlLMID7zdiM0fy1UskLR3Yl5CRWFPFu2m70E1eeCxWLhDDaoEIw/w5Gm4G/JWgpgihdaj4yOKp3acKST5odkHnUdHvLh0hGCPdrZHUbWpVWK6xB55sg3mi1iBlaxUPw7P5BPJmM+1RAchtsWHiURPu9RSc3UkaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tx0nkv7+EeqUYuFAxWzjrvCXkJOnPqXU9Ap7mB0cnQ=;
 b=DQbW3Z5gNu7h38HILVm19xvXWYLfnkHlxuoyizde+tff69bZqCHly3hXqZly9mQ69qS/8UJvsAb9FPJB7oaPTvGgqlLT720c3Bgg6vzGM6CWEIvhliMu8UdfgrAG0pS79MvtKtFExJi+NPySkNFRu04l92k45m7hGYGWPBWlFxg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8085.eurprd04.prod.outlook.com (2603:10a6:20b:3f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 14:15:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 14:15:54 +0000
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
Subject: [RFC PATCH net-next 02/11] net/sched: mqprio: refactor offloading and unoffloading to dedicated functions
Date:   Fri, 20 Jan 2023 16:15:28 +0200
Message-Id: <20230120141537.1350744-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: a4a579b2-bb34-4c71-a2d6-08dafaf0d746
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: io5P3Og8eNB6x6l7UO5y9skA7YSnV3YeHjahXC7qFIQOo1VAGwubMcSkEmLEmwGstKqyX2/xyVIq2wNSxZ3d8SNv1tsqyP3IdPCrh7evS/Bl1M/E4iDVytZPEt1VfH1SLSgcKDq4e0ELQYD2XrlXQf5G8NALfahxqT4I+zuUOAUEzRAJCW+hxGAFwQopp5gpWgFE2p4eq3aEE7dISWyQFyLPpo1DGtPp0h9PHqCSNxS7grZ05TZmjLvi6OmA3BszSNMiXnmNLZFiEGTa1JsbfjRilrp8MeMVC8ZfdLznTLg9sVOrvFJ5oSzEBfpgL3HLoY8Bh0VExez+Svubs51DTd2CI5TxrepGmZt8vxxOMAVIuFsGI3/zbIKaxu7u93lqaxt5vl8smDagP44fJu6b4UJiEku4U7wE9TEywVHFHcmvXqCuxFjm4X7s4jDck7bnJwkFAi5W3NKEPItXQhaumpSEsn0iFtPz9zefugwArXH7YFYgnIGDPJJz9fN7d0KVyu58S+jLdotVS0hi2fJCHPW7D78a1awhSWl7RQ10HelFgSX4Ui9xJtaNdEujJZj1hqqG1y6ftp5qCSrHeNDIxb50AI15KwFhFxGTg8I7FjfSO2X92osCImm6iU2fD0z3fsI8ruplIJ6t+IegYOsSvBaBGs4BFSdQeaV7LRiy6cN00H1uDQPuqjaog2PeZLTokhdFvTXLxuuW8JHJLKtUmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199015)(52116002)(6486002)(26005)(6506007)(478600001)(66946007)(6916009)(8676002)(66476007)(4326008)(66556008)(5660300002)(6666004)(54906003)(41300700001)(38100700002)(6512007)(8936002)(186003)(38350700002)(316002)(7416002)(86362001)(1076003)(2616005)(83380400001)(2906002)(44832011)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JCPH8H2aCZdR/Ebg/WtdaW2ov5RLax1VlURkhMerje+ZU2c+bCyCG5Lts6jl?=
 =?us-ascii?Q?xK/VyvfkN1Y6GANGCjETWKSybgxddt+9eY6XdkYuucxvIE33LAuzDgyBqREz?=
 =?us-ascii?Q?4ou2wvb+6K8EIBQZ7hLUUQKvhdvLWh3ROBOZiHdkwxCbEwQ6dN5r7TpDgFFR?=
 =?us-ascii?Q?XvbFiF/Y1nuH/zSlmsjaRtQaeGAxl4C35V4HSM/VwLxosR0NNsKLOPccEJiX?=
 =?us-ascii?Q?UhfojaZgezqf3YocusngrmN9ChazWMidQyHoV26y+0UZwN62oIHRqREKQkzd?=
 =?us-ascii?Q?RP9KbD9HiFd9ztjmMmPtjIQZPUtatRkIf8zQoVY8SOU81hIceeSunqpLnhZh?=
 =?us-ascii?Q?ahIQWnmQtSTVNeIzqzY6gwH03rdYvBq/OumMZi0fS7oYGzissgfBSYpdAJ0Q?=
 =?us-ascii?Q?Clv76WqW8A0VQ+VgsJ/QqgARHbhnATe89SuTVJCNq6/xIvj1lrl22qrDd9jN?=
 =?us-ascii?Q?n21dKF9gzNhh9UM6jQctY0QpJgLRvjpwdbVG7qvw1hQ5PAYnsXr7WqqWA/8l?=
 =?us-ascii?Q?J3dETbc5v5omhTy9slYEgNmezVDiUp9pyrK/IeM11fG5ANSlHRrNWo1kSImk?=
 =?us-ascii?Q?cX5XEXopzf6KZT/77gsXoJgMRaa0dtQfp8sSCAftjgA81l5/hqIZIJmoV60d?=
 =?us-ascii?Q?KgdqvRcAWp8wRJWL0PlFv+eySVYCozN6EIHunU8bPMyQhtQLVqYYNJmoiEnU?=
 =?us-ascii?Q?Vg/RIYVGriaWS0LzsltLGGnHGBxfaR8fRVnW9e+Y2R7IEMYBrNTWNtgFwovr?=
 =?us-ascii?Q?hX8Ja2pq7ueaPpSUWbBVxIyPs+SHr2A5ETaS+OwLqt7oWDvrT8u5XOES/TAc?=
 =?us-ascii?Q?FjuxXFP9E5EhlrlexkWdQnA96XWVLEpBJNgQgoVMnXd7gGRKOPta99jV+rjT?=
 =?us-ascii?Q?ckyd4k5R0y7OdqlpKMfa1rriRojysiHv5PhmfkIrCbERzfAKl+9wF88Z6knc?=
 =?us-ascii?Q?z3mouv/dUhv5O2VivkEIc3cw1zEA59JzSTep7d+sa2bC6lWv0QJv4R26k7AC?=
 =?us-ascii?Q?13SCA5Wbb5GrmrpPMYOxq+53+p2Yfz6Te+A/xgahThU/jrUUWD+hzDPzJILH?=
 =?us-ascii?Q?WKGFOO77vbAkZbIuCpATCjdDQporH5wij1Xd2LU7h39iKOdRyBjgT9HN01rD?=
 =?us-ascii?Q?wTFu8MQuVNu4IC/PMyvWha/QNqaaXl1PwMZBBpbg/lQEi0kIDrvf/R/KEGkd?=
 =?us-ascii?Q?m+i+d+vWCeCBLmfFbgfQ0FH1lbko2IRSERRAehUTP2sXMkYzle2qWonfz02o?=
 =?us-ascii?Q?No6RIkZhgXy3oqdiIw6uukJVpLqSeU7TGfW9ruRaKYY8M0Su6Avbzut8fd38?=
 =?us-ascii?Q?BkNf95Jk9N4REh3ny+QpxNwEEQW0lsDpCvG7Pgnez5xalL1uzNGCg8YjXjzn?=
 =?us-ascii?Q?DmiNjVwuM+YGxKqpXIh9Z9IZk5F8AisGuDf+KM70eTvGx25KQqQtTKKv4KVv?=
 =?us-ascii?Q?ITZD+a025ChRlLkLDgRHEGcXDBObRmdm4bKHvayyP/zAqxHAE8b/AoEcDjza?=
 =?us-ascii?Q?zXeDoFWYB2rL0/NUr6fpsus9PA8noRirreDlp7Cd8rhLlg7t3CunosR4lFzx?=
 =?us-ascii?Q?9Eo3BdYstcJNg/TMoyX4fIC9MfbzoMlIWv3lbich+PYeO94e1DfGZWdBc5gj?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4a579b2-bb34-4c71-a2d6-08dafaf0d746
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 14:15:53.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dfQjng4Fy1tqcYzh2ifVdMn5pcznmcjBFn3yZsHIkRMiN4aD+gWvX0Ys+IJc/28oOG2nkoaUGehbA5pvbXapog==
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

Some more logic will be added to mqprio offloading, so split that code
up from mqprio_init(), which is already large, and create a new
function, mqprio_enable_offload(), similar to taprio_enable_offload().
Also create the opposite function mqprio_disable_offload().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_mqprio.c | 102 ++++++++++++++++++++++++-----------------
 1 file changed, 59 insertions(+), 43 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index d2d8a02ded05..3579a64da06e 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -27,6 +27,61 @@ struct mqprio_sched {
 	u64 max_rate[TC_QOPT_MAX_QUEUE];
 };
 
+static int mqprio_enable_offload(struct Qdisc *sch,
+				 const struct tc_mqprio_qopt *qopt)
+{
+	struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
+	struct mqprio_sched *priv = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	int err, i;
+
+	switch (priv->mode) {
+	case TC_MQPRIO_MODE_DCB:
+		if (priv->shaper != TC_MQPRIO_SHAPER_DCB)
+			return -EINVAL;
+		break;
+	case TC_MQPRIO_MODE_CHANNEL:
+		mqprio.flags = priv->flags;
+		if (priv->flags & TC_MQPRIO_F_MODE)
+			mqprio.mode = priv->mode;
+		if (priv->flags & TC_MQPRIO_F_SHAPER)
+			mqprio.shaper = priv->shaper;
+		if (priv->flags & TC_MQPRIO_F_MIN_RATE)
+			for (i = 0; i < mqprio.qopt.num_tc; i++)
+				mqprio.min_rate[i] = priv->min_rate[i];
+		if (priv->flags & TC_MQPRIO_F_MAX_RATE)
+			for (i = 0; i < mqprio.qopt.num_tc; i++)
+				mqprio.max_rate[i] = priv->max_rate[i];
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_MQPRIO,
+					    &mqprio);
+	if (err)
+		return err;
+
+	priv->hw_offload = mqprio.qopt.hw;
+
+	return 0;
+}
+
+static void mqprio_disable_offload(struct Qdisc *sch)
+{
+	struct tc_mqprio_qopt_offload mqprio = { { 0 } };
+	struct mqprio_sched *priv = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+
+	switch (priv->mode) {
+	case TC_MQPRIO_MODE_DCB:
+	case TC_MQPRIO_MODE_CHANNEL:
+		dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_MQPRIO,
+					      &mqprio);
+		break;
+	}
+}
+
 static void mqprio_destroy(struct Qdisc *sch)
 {
 	struct net_device *dev = qdisc_dev(sch);
@@ -41,22 +96,10 @@ static void mqprio_destroy(struct Qdisc *sch)
 		kfree(priv->qdiscs);
 	}
 
-	if (priv->hw_offload && dev->netdev_ops->ndo_setup_tc) {
-		struct tc_mqprio_qopt_offload mqprio = { { 0 } };
-
-		switch (priv->mode) {
-		case TC_MQPRIO_MODE_DCB:
-		case TC_MQPRIO_MODE_CHANNEL:
-			dev->netdev_ops->ndo_setup_tc(dev,
-						      TC_SETUP_QDISC_MQPRIO,
-						      &mqprio);
-			break;
-		default:
-			return;
-		}
-	} else {
+	if (priv->hw_offload && dev->netdev_ops->ndo_setup_tc)
+		mqprio_disable_offload(sch);
+	else
 		netdev_set_num_tc(dev, 0);
-	}
 }
 
 static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
@@ -253,36 +296,9 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	 * supplied and verified mapping
 	 */
 	if (qopt->hw) {
-		struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
-
-		switch (priv->mode) {
-		case TC_MQPRIO_MODE_DCB:
-			if (priv->shaper != TC_MQPRIO_SHAPER_DCB)
-				return -EINVAL;
-			break;
-		case TC_MQPRIO_MODE_CHANNEL:
-			mqprio.flags = priv->flags;
-			if (priv->flags & TC_MQPRIO_F_MODE)
-				mqprio.mode = priv->mode;
-			if (priv->flags & TC_MQPRIO_F_SHAPER)
-				mqprio.shaper = priv->shaper;
-			if (priv->flags & TC_MQPRIO_F_MIN_RATE)
-				for (i = 0; i < mqprio.qopt.num_tc; i++)
-					mqprio.min_rate[i] = priv->min_rate[i];
-			if (priv->flags & TC_MQPRIO_F_MAX_RATE)
-				for (i = 0; i < mqprio.qopt.num_tc; i++)
-					mqprio.max_rate[i] = priv->max_rate[i];
-			break;
-		default:
-			return -EINVAL;
-		}
-		err = dev->netdev_ops->ndo_setup_tc(dev,
-						    TC_SETUP_QDISC_MQPRIO,
-						    &mqprio);
+		err = mqprio_enable_offload(sch, qopt);
 		if (err)
 			return err;
-
-		priv->hw_offload = mqprio.qopt.hw;
 	} else {
 		netdev_set_num_tc(dev, qopt->num_tc);
 		for (i = 0; i < qopt->num_tc; i++)
-- 
2.34.1

