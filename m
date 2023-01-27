Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2711767DA99
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbjA0ARw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbjA0ARb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:17:31 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2089.outbound.protection.outlook.com [40.107.21.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DB774A71
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:17:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUd5mqXBDagTXJOLHirNAaov91ECHT7MO5wam8hGooZhD/XIdxw5HxQOU12sLRv9rxxNtmtOEBg1evgu0GsH5Tg4PbTUt1LA3ll76PC1+AHJrmURTeBR0yAWxvyGuaUSvWLp/0fMlGzD5x9NTfIxI9yKVkUEAkRWzdZfksf2LFdm/pG3/5fbCZ40Fa9e7W22FbXBXiICOMcfbQIVofA6th3SGQ+GDekMHG1OESBo+iZoU2IImVy3dd/i3LHusCVwjGj3jqXoiFjNiLGiOU81Z/M0nCa2sm95SLNLK5egUk+Z3Xf2z0TvowMqLSY09qLERMM2Lh/sYEv1/yzArdUpiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LsRB3MuMlQ52lDxh8MZ3//T7GZtY2gsXEejNhlDJaLI=;
 b=UxZU5G2oNHEuttpPgzrfdEmj7ypfT3cD125XH5enAEIGNga/Nb00qL3M6LUUU4jzMbJdZ23NccXMKGxw14LcustQ6VTlyjTtmZZ/0JMVIV75MhPzjjgkXk8dDbb4UcQ/3cvZcqVywV4dlOwb+//MMWngsd6kMvsocThmueGX7NOn0v73kg2W7/4312zh6E1qXYpWGi+Ntp4dDTpzTQi0CPFweEouK/Q3oo7vnMWkdltNm0EP6kdx2Em5suw5b7R/HK8GD5D1GUrAuVwTGJQMpp7RnJj5KWuiX6u6qXkSxZOOc+wtEqacqBFN/F3dbaCPycMfh7uz1fNtsBtbtZvUBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LsRB3MuMlQ52lDxh8MZ3//T7GZtY2gsXEejNhlDJaLI=;
 b=iaS/mrJMB8uCh9vvOq6iWsFjYqgpZekeI5rzofuiW2IrOeHJLH/PqNMza5P7iKioMpFTkz71oHYRu7DZ+iikYJWu6zJVXDMUqTbQo5O/Qa1Z7Dk63vYr0w2iGw6kJVLmOYHSIamk5jmqW+fwXaNXpCrpRcifOlR+1PoX2eDVoBc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:16:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:16:03 +0000
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
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v3 net-next 06/15] net/sched: mqprio: refactor offloading and unoffloading to dedicated functions
Date:   Fri, 27 Jan 2023 02:15:07 +0200
Message-Id: <20230127001516.592984-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127001516.592984-1-vladimir.oltean@nxp.com>
References: <20230127001516.592984-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: d0cabe3d-74bd-4b3c-ce55-08dafffbaccc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UDvP6zNCQpeK4yJtxzF31dW6GBfD3LPLgXNk5ct9NO3v0PKxXnTyLEwnTxqLZwtDaHMX8/CAS9NOAX4S93Y1NsEx01I+ry45im08WC2ajUjS9Tnob4RDDh1ETNshkkb3uo3Y26Qn6fqB7Ob3Mabd6tUgD36eaBoerKpjXSiSoEY94v6wLTVXEbiJ+wGZypnu3aru3tWcYDQGBuWacYYgr9Xzw9q7tGmSYn+fXLuP1UfYQX4l+BXWPU1JUakEdYB1OtMHEGJ8D1F5R4WMajO7c6Ji3X0mw2y59eyV7BC8yINOV9Sp8m0Cb9t2f71N2VquWa+iSxnr6+IRzUEe1ICHuBBTG5UWHmHziShEHHDOPSjUZnaajWVOfr8D0LDo+Pwc+3yeuk0196cZWhvGEjgGbsEqEkFmvX9QaIlQI6rO5evIcL67BOHZuQZY2OSWe9RClPYAPvWdLz+LX+3//opVNIeEauS9m032ucYd7WfbuOwKqJl19J7/q6w+esgi4sRA+Qh5zexRTcK5quJrctkaj24zuIEw/9CmpzHKMSIFGecyAZL5rfKmaSRrEXIp7fb6D5q+Twj5SJmlqwzmKce7Bb0Oh+r6VfoVUD8YmP7xQ0hUfgyDYcGEet8NpowudtnwIaNXJZoX6vyxjzKaCiKv5VukyEEluDvTuMA7MaGQ30irOD2VBAg2cOPWmshywZ4Gy27l8oQTHu5AcUh0UDjJEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iGWTvRY5GU/v58ch7GMRa8PzjtLL+bCxknK1140InXYqCDbpXaTZESKbkxWd?=
 =?us-ascii?Q?TYncQTd+EbI/Or4xZ9MjmEqoDzg+Y+HzZTzjnL21JRqiIJoZbLLazLISa1yK?=
 =?us-ascii?Q?kcbZ5DiyVvb4aEiwUc7qEMqQUwVhGGY29GL2aKM9SxMb5+0jEI5NGQmrwuV2?=
 =?us-ascii?Q?QKn7eR1dloMV1d+wZi2B5wwzHa54lHaugX2a3L0zgqTp07u4dT1lkhMmfNeB?=
 =?us-ascii?Q?px+xI2CJHtBRS4zy/05YD6Mq/4xQmkCjP5qc43ZuoD6xe89aFMWl0e1YOLMC?=
 =?us-ascii?Q?BpotAie70W/SFzNhIp4g7cRIHZuS9x8AFWJEDEGhbA0czeLq7203hj004goQ?=
 =?us-ascii?Q?jWbRY8x6AFBGbk2wwzNaZCvzsR7a6KgSRSb9XmFgAK1ybK0awBjwvfr076pg?=
 =?us-ascii?Q?YcTTZrJdXXEPZ0GQgIuHnCZU24Hikm4DBH8252xPp1qaI0O5lzTD7yB9Uu8p?=
 =?us-ascii?Q?3syMGQbaIgcZugEpbancXM3GL0YGSJfyHLcvmyxbmFfkas0sKdu1oCsK7G4X?=
 =?us-ascii?Q?PyU2RDgh12h8CNMTMSlITQ9QvGCpPnRdvHPb/6iTJ/1aoWXNhFu7iir5VE11?=
 =?us-ascii?Q?ekrb78Fcb8GX7NvE3HdLRByefVLhRv73pM5DWK7HxkjCAjboxTfORMIOxW+l?=
 =?us-ascii?Q?7eFGbC525iC4J2oa33M6udqKlFJx5lQ/uGU4Dw4S8Seh4GF+KQQcoMloCQp5?=
 =?us-ascii?Q?DHsrC7AEk91RZVSFk/+hQWu8P/x2KjBsOY9V2IQ6LwblUiNpj6McPpLK35g1?=
 =?us-ascii?Q?gJ9vUm/c02WTdWiR06om/rYZbm28TO6J3UYMZ8ueYJXALxn9qL8lVelhxEZY?=
 =?us-ascii?Q?t86PBzhzpwVZwwv+GMm9k3sPWQWKfCjBa03NZUli2YbcO19QFoHgZqldGEAj?=
 =?us-ascii?Q?+BTrbChaMFlPTk7TKDHgmqalVSmlvGh2FOAiXJi+CanvccKMkCPY4uytYBJ3?=
 =?us-ascii?Q?Nsbun259j8Z8+c2EX0U75PRNZZwXft2eiuD/m23zo9xthpudu3v1O7mPWMyd?=
 =?us-ascii?Q?ntJbicVZ/nZHOU7Ju33EO4P39oEJfX2aUQWlIb0G95wIkhvidQMsaDPaLLI1?=
 =?us-ascii?Q?YI/37NA07F1VOz9bLlYrBRd3GeiDc7Gkc6VNUzfeg5ZgcVQGjsIDmiiiyWaU?=
 =?us-ascii?Q?EmC1X820m4B+jE1PGu8jmWvO64USeiyC0Fneceg76gKC3iSGcPhF/fC0B1p6?=
 =?us-ascii?Q?HlENIvTbeU19E4xeniQCnpOtxKtVGtJ3MjIHQjdSCePLJiVgk8M0uFPKjDvm?=
 =?us-ascii?Q?lfPTgcw9s0eNvmAFJmtgEIkJAeQsvVRQyehJ7sEJda2CvnmaMT6zA/E6EE2D?=
 =?us-ascii?Q?rKsYfMi/ZJZjl+/HNJZl6vD6i8ljQBd7d8yJTFS2ikQHup2X2hJH4zpDoyDq?=
 =?us-ascii?Q?zGU/fQo1NB7gWR3MBO4sOm+QlK62eMenJ+ertSMfWJagfbY7MbRbeDJgtAnv?=
 =?us-ascii?Q?LIrDAYreh5lFgYfE0i5e0H7Ss5tbjM7A45/xHvuoDDbCOyLqsemhsscssQau?=
 =?us-ascii?Q?on1YixFj7H+TvZhbUE4s5JK1SonQkCjrYo2rtHslVYKDrTzKmqmfpHd1r7ye?=
 =?us-ascii?Q?14QAj3PDdmN67iNjPinmm26HR+QzlDQfRU7bRRaMT3vDzqbO2PwQWeYrxa1n?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0cabe3d-74bd-4b3c-ce55-08dafffbaccc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:16:02.9198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SFZjhYy9l8vkjCRn3bKu4RBBqK/IvXiLaAvhhcvT77zqngd6na/pu83e16EVnqthyiQnOJBqYCX0Ce4MbixRwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v3: none

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

