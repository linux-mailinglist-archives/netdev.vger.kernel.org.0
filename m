Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72906817A8
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237877AbjA3Rcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237864AbjA3Rch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:37 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2079.outbound.protection.outlook.com [40.107.241.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BAB29406
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOLrOEutI5JNJ22OBKsDjMLBiufrf9uuakSFsTUBxGbUyy99wzynVZOLu83gnhJ/JrXEzTaK2rVP62dKi/MtIukf+1L7PJNFaOthyrG3Ocmtwwd2xaqu+uP2oZc9x4rK4m4/wFgSzD7DLs+SnZW6MJEnR52Adbvu/chCJwDqaY/OwWDhB2XgelcvydmkvygXpvcPU1rV0A6ffopxNaqDmVh3AKHAP7EaXK7hivrKefqJ/Jz3wL8iHwGNxlYkH/Nl0eVRPwJ5a+8chLXFVzJOBMHJRfamIzp2ujqJvrjwkIRnW/zauKPDvs562r8BFjyCNbQBsBic5zSW6ksbzAnpdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PkwuqXekqJ2iVtdo9HSRdtY6W2nt52O8JEJzoXU4xgg=;
 b=D5NBCerKm+Aizsx1RUWG16pY0MJaU2Sn+tB2BbMCeetyRJmWflK6aTDbNqoM8UGPGUTpgtUxzR4ie5whIPd/S8c2A+w7CG+g257BL4qz5NXSEmh8fRk5QLrIpH1VBxSHroG8ceVYGP7cNPLM7iGo1oK/iX3UlPHHSojA+kfQypKYBcsy5u9yTBQHbKDufiL7dc1NQHo9bf5j617iZ61Cm7sBqYT4pdYOVpmtrHHAEYNhspSuNnoqYJsuocKU5opZA7QKi0vOhWHpPOI3XmhdFGxNMLy3CkIJWSqQOPyTh4bAk1ZbV8tdstMVi9v3iBVXgSb6LsBJ2A6ksgK4r8uQaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkwuqXekqJ2iVtdo9HSRdtY6W2nt52O8JEJzoXU4xgg=;
 b=cLHJAJix4e7rYe0v8uf0oz1n1MCYzOvQl71Le/s5k91vnjYoqNgvgxx72JEX6dg7dJt5k6JoO3I3PdDZGqZSusEEFBMGYm0uvTSc8Zjvheahoq806ZRMasQnebwIv5G5SuGGhiNIa9lZ+fGeFTRaiq2f7NLyQxOgXsbY4JcnZ+Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS8PR04MB8547.eurprd04.prod.outlook.com (2603:10a6:20b:422::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:14 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:14 +0000
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
Subject: [PATCH v4 net-next 06/15] net/sched: mqprio: refactor offloading and unoffloading to dedicated functions
Date:   Mon, 30 Jan 2023 19:31:36 +0200
Message-Id: <20230130173145.475943-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130173145.475943-1-vladimir.oltean@nxp.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|AS8PR04MB8547:EE_
X-MS-Office365-Filtering-Correlation-Id: 97fb41db-70f9-4d09-5c69-08db02e7ecff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bB9go/Kn3CKV2XvdxMddOA0Iu/RH8elqhvUkafSGBcNpVU3O9FiwllFPU8qateHjzbure2isSfBF7t64YXB9+zozFiRroi3nAu+pCEfHCcnw2mzaC+AnzDS3GZZeXUPrediFDSMS3XFqwCHpWQXF9nBdDpYYKZOmH4C40fQpeUhQgXuWVDlupZIC6RDMMqbmnGrXiiZLAApIkUUEA4Md8qfK8bZU36d/fv3nhm6tbQQtfE84n4Fq2cacSBPgrQgKiPIYXFXaQuxRKxSOCNLY+Nqk8mg51nGs5EsoUSkvHoC8ZAqCaVrcaQMfZ+COcwIkoKZJZo5GkplGFq7Q/Ug5WcB2J3NPCWjR0q17EYmxbx0Py4+Nxb9+x8ChtiTyWOpn2VEEOSgS7rFmaUU4p2bjmtgc6RtpBCzbkLBJyuyzROPkO/AXx/4N6lk/EDvONrQgw/m7mKTwFyNc3vfc0fU7yEhZDRK2jAABTJmLON0vECeNeaRslcCMIRMpNdyOhUNANkWOWJ0AiVsIz+S8AekCPQj0KueSu4/enPwTCQQrCH6ZU1poUQ0+Ndk6tzpWc4rhYnoZgWDTqOhe2Q3YRbzCvQIIxldL79SnGZuKcZi3c3UmPy7CVplxT0q6xv70Cm/3DRuOWKQ7KmNPOnu9kmbBnbGbMxx/m3xEjTDs9TVGVRR3NOM3QVSR9ZOCa8k0hss6DS3KUvmjw38z52fiEodh7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199018)(44832011)(5660300002)(7416002)(36756003)(38100700002)(38350700002)(2906002)(86362001)(478600001)(52116002)(6486002)(2616005)(6512007)(6506007)(26005)(186003)(54906003)(83380400001)(66476007)(6916009)(66946007)(6666004)(1076003)(4326008)(66556008)(316002)(8676002)(41300700001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fhQI+s1DkBLbLofbcUjgSxNPFJG3dvgmyCWxborYkZBGUCv0qS6tpJ0/XcxT?=
 =?us-ascii?Q?LUgd0CgTjMjz9916/jEVuY2i4TPudTrn68s6577tpJA+NjE/6hznM9xI8m5h?=
 =?us-ascii?Q?D5qYJuP7Zv7fQLlsQ7XqbOH3DPcVOfaWBkMgJ43PW5D6v0cmoExTOyJ61dsm?=
 =?us-ascii?Q?iRuuHm1dwKlmV8QN7Nz6UEeERprdiW6t7k2J6ACtPi9TfbvJJWxH9e6his8O?=
 =?us-ascii?Q?DcQgzmip74D9p3ejtZR20fRh+kGpdQpjTITsmuPv0csEfVmDxOQ0gXYtjMzw?=
 =?us-ascii?Q?+EMAaokUr6jsXr6GlhQUJYiatUQ/Ly/V2zU+McxrMFlxmipKvOTN+0ok1Pl/?=
 =?us-ascii?Q?plw4Ee0HmmuUKe13BgyxUXOScBfoD2PYXgjjOpHGMWbkwam782avHhI52VUq?=
 =?us-ascii?Q?SJxEfp/uO/xOQHO/iB6nnPYS5GXrLWGl/my6UpjGoba4J8T3CRzQe49eXDWI?=
 =?us-ascii?Q?LBTkpom3pFRXH6Gm4RCUrZbpTCqKzzjV1EU+Oby9+Jr1jXsBpzVTr21VQDAY?=
 =?us-ascii?Q?mkaFIVAO0kbORkdk4+eDyZbMmSM0INFvmirEnZrAXxN1YYeCwQndGZ5dsUPe?=
 =?us-ascii?Q?UFymczlB+1N5Umj+mLXIc0WiSWSFfbDGVXpFtVcBvOSwVL4Nr3SfZ6prNGlv?=
 =?us-ascii?Q?+rh07sKqfg1QMQHfpMPj6VhUF4KGZePC+8nGxNraECGCSMmMNJdqhdcSG7fc?=
 =?us-ascii?Q?Yk5wq3XhnKTwnfT6StT9Is8EzUHlM9msYOwhIJ42lYdL7/f/5N7aU7EVNI7V?=
 =?us-ascii?Q?CBdbTWdCnVnd4ROaFXO3XubmlEk97wQFg+C0aE05ErcF385/t/RUHOHANQFn?=
 =?us-ascii?Q?ffW0WQtBUFmOBfYM9B+t/gn6mIGG9werluLowpzeA/ipxZqSX2Y+YKvD/hLi?=
 =?us-ascii?Q?Eln3/0d8/XA1gKNj6VPG35/sZnFyTiFNuBUIypsICUiwFVk06arfUNFLjtoh?=
 =?us-ascii?Q?XqYz7LRYgdrvWpIoipUEdJcSUhiCzmHD4+51FxFDg4cnRRc6Ptg0Qu3DP0hH?=
 =?us-ascii?Q?IWdYRmpkdnsNBAiVuaxf9+gVDWe1pHOy+VsoFoM8YbYQBsXfNpfUt1zrwerx?=
 =?us-ascii?Q?TCumdHthydBrGsMG3fA1CsFnnYMl4TtIg0DFGA0sZr9U4EhL8mbaNEd5Ra69?=
 =?us-ascii?Q?2k0GR4j8BNEM6wBVTMpDepNhB+61faT52HUV/M6+Sfme94dodYM2vaxvJ5No?=
 =?us-ascii?Q?onNlpdWQl58HqpRnWSrgeHEQS7tEbOxSS+5o4GIhmoJxqyOZkn/1/UxWCA7u?=
 =?us-ascii?Q?viy6rWa/W7En4YHcrV9k9QI6q1NvmL2Q1gWd8kUcyJposrpu3ooDAjXVn9s6?=
 =?us-ascii?Q?Mm2Zt93pprBV5HJRkaT5EVI5UZLdhjHeuLdbVzxR76hUPG4HnIxx0LhwygOk?=
 =?us-ascii?Q?rkTmOCO3h4iGFNEVdMuDueRnTdh2BdF/GOUfzJiQrhRpHNqugjvoUa9f0I5W?=
 =?us-ascii?Q?LDiHPO7PQR0y1BcyVZ87wbopQQKGONhUIJliiIG6YOIlsM43y9u1tREtBF7M?=
 =?us-ascii?Q?Z6f/KU9vqamDTJT91WiPqgVV+15nqtAl+n76uaj4osSTRBpeVjxDcFlgoZdK?=
 =?us-ascii?Q?bZizAfAx4u3EDHFbEHyHMXWiuKv7fJZwJ9lJ1KZ2neKCL+w6GI5bD7eUfPVD?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97fb41db-70f9-4d09-5c69-08db02e7ecff
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:14.2728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBM7sxpOHQ8XjYnbPt4oMCC5B6/OOH/wIO4MXOrZGUww+CXNSIy8mW1kTtwPFBvBO1nymUaee6rXxZ3jUCJMGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8547
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
v1->v4: none

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

