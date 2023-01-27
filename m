Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF46867DA93
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjA0ARa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbjA0ARZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:17:25 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C162B60F
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:16:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JqLp0vVGHte/CtNQMB3faLPW5/mQQ2FwwAYPY1ltwdQfH/TrO6bkBNdcR+gcFPx6aLlyQLADlaSPohunF7/eQoaXQWlIaGKbmZ4eYKrc0ockFX/9UH1Los9qj1J//zzVOLTZcvYsmmisPczbn8uGBqwddvNawH9HENdtBrHE4lBsWRU9V8WY31v2VdaYaqdfxyLUSqVwOzEHDhcC199p4khTWikBSmsvMkJliOhY1pKtDW75xovXLoyyg9mKKojGj4yyAHLomvjfvxsf1uO8FaA5k+CaQQLBW0WLPKBpPOOtDpoK8jSLzKYuOzGyFzzssr7ehk9MqE2SS/dsEvRFDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bNUjHe/wVjTuOZyfANOx1JkaZGgp6gMxYJWDnIefvU=;
 b=F8KLc3fY+OV7Mu/9ZCG/0gdcLcQQ1duQR9voiR2MtUNM+g3TeoBvSgSMohc9814sf7BioTvYcZlakAH1qxdrtytocJTHafkgrObHFoDUVALLDl1RLBCq8oL52KG7CP8epFZn0NPQpwKiBuVq6gWL2WJ2+3XDO4tMfBzUc5N8SRyaZCPrnVpnRusMBthp0RXf2vazuOt50OLGVJESecZyC6wamPVwqErOGTvKPwXyLZZl8Zv0VVtjKbCOzgSxpCB8qVNDjm5pBL4srlTmC6+M1kXAs2rTAF6wLY7c+o2qMc/8jcBikYR1WbF4e7d9dB3mXxSZfhX7AwlmSphDuJeGvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bNUjHe/wVjTuOZyfANOx1JkaZGgp6gMxYJWDnIefvU=;
 b=S8GC+tG24stsdFRTNjXsM1nV5QoVt/S+7TAXuzK42i+NjgLLShCHV9h9zZ+X9la8ModvoO9YcPiE/3OcTmG0+zE4RI/tmGdSNPjhTGTV5AUJAsvWREaWixFeZolQvJp+XrjH6HX/MfK+ekQ+L6TQ+v1bScDSKcz4hEd8ZdHc5dI=
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
Subject: [PATCH v3 net-next 05/15] net/sched: mqprio: refactor nlattr parsing to a separate function
Date:   Fri, 27 Jan 2023 02:15:06 +0200
Message-Id: <20230127001516.592984-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 031ac6cd-5271-4faa-617b-08dafffbac3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YPKLCjmTTbzDfUpIKheDr4XimlhyPNYk6nIp2w3sVGqgArY5/iIfUGoaehEK6MDqk1E71A8DvLvrzy2xgZNABBctDSmiUO73Fy+ChryX2sspIVBCas5uagbdzopewnWselqapQTQC2FfDBhNEHYzSn/NV3h0Zb8Aq3OYAf05EjVlISD+vUEoou87AV1ZE2EJRPvNE41FxCaUEMiduobleM359tkkMNeQzza59Tst/2kcr2PvgL2/d6YoQs2qaHnvJ19yip+HsMnoom5+/XbeLeXcadizED6JvInCxXfP7BPCyW762nLzedSLewQJ70+BV387XpcP+lggIrAW7eVmn/ObK+S9cRexYFiEb79F2bTWyaHfdTIMuJNRXJ2jsmKUjVlCavGnO9m1YwnfAGEm2K0HPP1Qv/feiicEB307GwTRSnDG5YU6mQcHECnCrWWikAyp2XT4EfF0zkdKWSM68v+t110QsPmzFnuGxS+SOsmJLi2OtR6Bgii4SZM0ogdV6eG82OLBo2x/AuUH8uyYgk/XJwGVPcBvG1mP3wDfEjSyq2JiFpn6mbg7jBXTTcnRqi/w0kV3sntqY8B+u1QkPbFFVB6shASIajeNJVygfGaR/9g0zbzZfdq47KKKVJyeztdrRhmd5iOIbQEaXkQKVS+DzaR7+Uw0ybhW3WIuyCUKE2gQrJO5WvOYFqYT22uFM29jgZbFY8EtNfm+wka9Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wu0fb+ARVICRYlFgGC/swy2uj6BiRObUBtblgu0HP1Kt5ixeAGrRt75xIKXW?=
 =?us-ascii?Q?EqbM5lXGmYZgUqkkEHDHTZ3kmLSVcLtVk93BwH+TgbtFz3yIUYCBOYrkiclD?=
 =?us-ascii?Q?HoELvgyd+acP6GY/yAiNYBlO6hf50TZbXOR4oiHQRkynhxr8Jra+4MVKCSq5?=
 =?us-ascii?Q?gztw+3YyMa2CH+Sy0EBw5wTc0whp4n9UkcxxrnAq+VBGRDOWvjmYIWGkYvvX?=
 =?us-ascii?Q?ptik1mJkRFvp1+nlkoFl1rdAFJwlVcmV5kmu8bDJI6sFPj03s/0ai8FqC/mt?=
 =?us-ascii?Q?g19fx8X0m7XdEGNJhO5MfqRb558UFOvAZYolNzF2+8Ziot3QvRSDuUrxQnas?=
 =?us-ascii?Q?rUgbIEWbbVqH4lGEn2Vhoije/sPkLMoRkWU3eXulm0SmKe9GJJ5Z+EKD9nUI?=
 =?us-ascii?Q?yZTEtazxBa+W/SbyVG2dL58DCw84+nDXbNsA4uGnmCYq0o6KGe6W/b4vAQaI?=
 =?us-ascii?Q?Pt9Eqbu6HneaxuTSlcqHH6YMI/nv2AOPpyzvXkpluNo2PNRMIiTXKyqdtmFQ?=
 =?us-ascii?Q?IKPjQ4V9dPuRiypkbipDPA23++Kmh/nE4BNAP/KioXJVAFb1frFDd2TKNe/Z?=
 =?us-ascii?Q?IUfrnj3xokKFwzD4JrNWrdcdyH3DUZwUrwyiIqJ5ECmj9USzjL8TuwunPQbZ?=
 =?us-ascii?Q?DIjCefsDmw4+UrOKfCc4ln7P4C3nADt/m/k97j/45SslZUwGTYLpUtAyfqSS?=
 =?us-ascii?Q?chjmSCpTuoYTQEX4Gq3sdsB6lW3QVMv1CdKKWq5fKMCzUDFN6NVrHvRMwnLo?=
 =?us-ascii?Q?/z7Ro/f9qltcA+nyAz+/ZhzOLiqTOe15wFyHbbb+NmoC1PMQfmhXdDP7p9MQ?=
 =?us-ascii?Q?OWCVzcvIYeu9e5qq44ZPCCyozJPp+xa2TWgZPT14q8ckx7Eb2G9KrNQ4b5rx?=
 =?us-ascii?Q?RKstpCsROgXUu/Trz/B+No4OiFw3tUPr6xpubasAH0aCnvNRr/ls0KHi+Zr4?=
 =?us-ascii?Q?q6wIJ04SqzggyGjtj0D+RncuO6WtT8I4AbfCH8yK8WhvbA4oM9dxh/pOlYx/?=
 =?us-ascii?Q?QkRIG4bmx5/os1k5vlZpzZERxXgcF/kFJNofj2+OAMgtyTugMyKAC/fEfDa0?=
 =?us-ascii?Q?FUhOsuDEHnBXajkgfk1eC1/TI1IRfLnhc7dImzyIoMGf4pVGoR9YU6/6nV6z?=
 =?us-ascii?Q?Evsg5PyIANOgCw0auHWO3ylZJTAHPgxYHfMOAvDhGDQ+NHGBwyq3vnK+lxIC?=
 =?us-ascii?Q?G/TDAGi3pqDaWnJf0VdxbqyISPfhzVMVhI04GfKxfUeAJURiafjxDkWCZ2ol?=
 =?us-ascii?Q?ovupckyfESDrtlly9rCJU8ro4U+FcMvt3ZMqcnwoUucwQImtrjGt9G8Sbela?=
 =?us-ascii?Q?CeE/WpDBW1bh67Wnh9L4H8V+N40lVQ6TBsHlZy9GZiRKUxS4lrqKKBd2+EAY?=
 =?us-ascii?Q?ORaGp4VSnptWdGq7tZIcdDPTBYJNSAML3Ikavzx3Oea51P/4mFV4u8mXM3UJ?=
 =?us-ascii?Q?mD86P807evCXxYnbMrVxg4Ks07B2h6TcY5uJZ039g98pLU9q7sa8K/wcLzdK?=
 =?us-ascii?Q?L60N5FLneteJHLHBa8wQQSeps8SxgUSzQuXjT0oJH0I/DCouSpNEMAttZrh4?=
 =?us-ascii?Q?Nm4bTrKNjlJzaAyrL9abXi82pcZ9Xp6sDNODS4UkHL1ISB/JNgGvRqUWzasS?=
 =?us-ascii?Q?1g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 031ac6cd-5271-4faa-617b-08dafffbac3b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:16:01.9355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dKCfMiNvR6fmxtsyJGPMEoUHR9HHXx/pbWnOibg5l40A+pAzz/6safwTrDqEOMlDjt8vKWhBniYWr84MtD3XCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mqprio_init() is quite large and unwieldy to add more code to.
Split the netlink attribute parsing to a dedicated function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v3: none

 net/sched/sch_mqprio.c | 114 +++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 51 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 4c68abaa289b..d2d8a02ded05 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -130,6 +130,67 @@ static int parse_attr(struct nlattr *tb[], int maxtype, struct nlattr *nla,
 	return 0;
 }
 
+static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
+			       struct nlattr *opt)
+{
+	struct mqprio_sched *priv = qdisc_priv(sch);
+	struct nlattr *tb[TCA_MQPRIO_MAX + 1];
+	struct nlattr *attr;
+	int i, rem, err;
+
+	err = parse_attr(tb, TCA_MQPRIO_MAX, opt, mqprio_policy,
+			 sizeof(*qopt));
+	if (err < 0)
+		return err;
+
+	if (!qopt->hw)
+		return -EINVAL;
+
+	if (tb[TCA_MQPRIO_MODE]) {
+		priv->flags |= TC_MQPRIO_F_MODE;
+		priv->mode = *(u16 *)nla_data(tb[TCA_MQPRIO_MODE]);
+	}
+
+	if (tb[TCA_MQPRIO_SHAPER]) {
+		priv->flags |= TC_MQPRIO_F_SHAPER;
+		priv->shaper = *(u16 *)nla_data(tb[TCA_MQPRIO_SHAPER]);
+	}
+
+	if (tb[TCA_MQPRIO_MIN_RATE64]) {
+		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
+			return -EINVAL;
+		i = 0;
+		nla_for_each_nested(attr, tb[TCA_MQPRIO_MIN_RATE64],
+				    rem) {
+			if (nla_type(attr) != TCA_MQPRIO_MIN_RATE64)
+				return -EINVAL;
+			if (i >= qopt->num_tc)
+				break;
+			priv->min_rate[i] = *(u64 *)nla_data(attr);
+			i++;
+		}
+		priv->flags |= TC_MQPRIO_F_MIN_RATE;
+	}
+
+	if (tb[TCA_MQPRIO_MAX_RATE64]) {
+		if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
+			return -EINVAL;
+		i = 0;
+		nla_for_each_nested(attr, tb[TCA_MQPRIO_MAX_RATE64],
+				    rem) {
+			if (nla_type(attr) != TCA_MQPRIO_MAX_RATE64)
+				return -EINVAL;
+			if (i >= qopt->num_tc)
+				break;
+			priv->max_rate[i] = *(u64 *)nla_data(attr);
+			i++;
+		}
+		priv->flags |= TC_MQPRIO_F_MAX_RATE;
+	}
+
+	return 0;
+}
+
 static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 		       struct netlink_ext_ack *extack)
 {
@@ -139,9 +200,6 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	struct Qdisc *qdisc;
 	int i, err = -EOPNOTSUPP;
 	struct tc_mqprio_qopt *qopt = NULL;
-	struct nlattr *tb[TCA_MQPRIO_MAX + 1];
-	struct nlattr *attr;
-	int rem;
 	int len;
 
 	BUILD_BUG_ON(TC_MAX_QUEUE != TC_QOPT_MAX_QUEUE);
@@ -166,55 +224,9 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 
 	len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
 	if (len > 0) {
-		err = parse_attr(tb, TCA_MQPRIO_MAX, opt, mqprio_policy,
-				 sizeof(*qopt));
-		if (err < 0)
+		err = mqprio_parse_nlattr(sch, qopt, opt);
+		if (err)
 			return err;
-
-		if (!qopt->hw)
-			return -EINVAL;
-
-		if (tb[TCA_MQPRIO_MODE]) {
-			priv->flags |= TC_MQPRIO_F_MODE;
-			priv->mode = *(u16 *)nla_data(tb[TCA_MQPRIO_MODE]);
-		}
-
-		if (tb[TCA_MQPRIO_SHAPER]) {
-			priv->flags |= TC_MQPRIO_F_SHAPER;
-			priv->shaper = *(u16 *)nla_data(tb[TCA_MQPRIO_SHAPER]);
-		}
-
-		if (tb[TCA_MQPRIO_MIN_RATE64]) {
-			if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
-				return -EINVAL;
-			i = 0;
-			nla_for_each_nested(attr, tb[TCA_MQPRIO_MIN_RATE64],
-					    rem) {
-				if (nla_type(attr) != TCA_MQPRIO_MIN_RATE64)
-					return -EINVAL;
-				if (i >= qopt->num_tc)
-					break;
-				priv->min_rate[i] = *(u64 *)nla_data(attr);
-				i++;
-			}
-			priv->flags |= TC_MQPRIO_F_MIN_RATE;
-		}
-
-		if (tb[TCA_MQPRIO_MAX_RATE64]) {
-			if (priv->shaper != TC_MQPRIO_SHAPER_BW_RATE)
-				return -EINVAL;
-			i = 0;
-			nla_for_each_nested(attr, tb[TCA_MQPRIO_MAX_RATE64],
-					    rem) {
-				if (nla_type(attr) != TCA_MQPRIO_MAX_RATE64)
-					return -EINVAL;
-				if (i >= qopt->num_tc)
-					break;
-				priv->max_rate[i] = *(u64 *)nla_data(attr);
-				i++;
-			}
-			priv->flags |= TC_MQPRIO_F_MAX_RATE;
-		}
 	}
 
 	/* pre-allocate qdisc, attachment can't fail */
-- 
2.34.1

