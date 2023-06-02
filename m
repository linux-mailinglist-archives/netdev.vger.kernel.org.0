Return-Path: <netdev+bounces-7382-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A65271FF85
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:39:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B9D8281778
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D0C101F3;
	Fri,  2 Jun 2023 10:39:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DAF7468
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:39:28 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2046.outbound.protection.outlook.com [40.107.20.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78CBE4D;
	Fri,  2 Jun 2023 03:39:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xx+d93cth1epYzcbFiNXZlbnnDMUoz1CI3GuJdsEqwte9ChcPiL3/ciSguDXbwjyyr/eu7SiVF9NOjAZDIrrDAu0JTL11auMHn+bHgyhs2pZKgOnjK7RJoHSmJ6WP7G1rNvUVSgGB+YfCmFXvv73yc1RqfZK3mnrb5IJTqmTY9btiMIlK48pLQpVSymonL0t9rcSv31q8TShc2BkMwSI7C05b4ECkSSq16vwk688+bU09qGTIPBzM39qU10kZwyTqcV12vcpr89gn0S99XKwY2CG89HaXGJYT/T7kr9CnIYcAGehsYyHuYtWlNy37IqVuAqYVgyeVrWfWNW7k6sNbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ndLEqeL2b89Eb7F6s0vTT7jejVC7IkiJnJ7M56MCyXo=;
 b=Sg6szO4MdNur83tq4yy7hEscOsv7Ecnp77m2Mnt8asLuff1/OduUm7xeS7oGsp+EC1OahZWI6NZ/BxcbduVpEoGBpQA3GrmWsFr3b/WKPM7WEbQEyaBNtqaLl20iEyULtphdbUmMErQrIc20bld2/zWO+8hHvV90OIYRsAOGwlyCaCo0FsfcKcrnTIgFXCKov0rSJswBeXeQgmEmcCwCpv+jc7fZQeUaUFwY4/7au1Fxemhp64yxH+XZ+yZ3WCWmQZdl7eYq5aRuyfIV8nCxz3Hp0USrieTtJyflLajypAAHC9tPf5mceq76QlnPuhir5JKGGsDY+uGyvNUcRRA31Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndLEqeL2b89Eb7F6s0vTT7jejVC7IkiJnJ7M56MCyXo=;
 b=GyBeqJQhBVofsEodDT60PO+xCK64hy2KwoJ7Ty4V5CKnUjUvwz43kwQY6ptlzHyOsyjUwOwF+r/9KvzytO55LhvSobjICBlfVCsz/10B1hU/yqhZuasIl/qVvOX6tIZuWF0Y4Lp2+F4dNOk0DlhLHOaKyUnf3HN7TsO1hsDylAI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8926.eurprd04.prod.outlook.com (2603:10a6:102:20d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 10:38:18 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 10:38:18 +0000
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
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH RESEND net-next 1/5] net/sched: taprio: don't access q->qdiscs[] in unoffloaded mode during attach()
Date: Fri,  2 Jun 2023 13:37:46 +0300
Message-Id: <20230602103750.2290132-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
References: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0095.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::10) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8926:EE_
X-MS-Office365-Filtering-Correlation-Id: 376f037a-d8a0-4f3c-ea4f-08db63557a5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6TJFWKx7dYWE8pvZKv5TyYjyK8uKB9MvRaxQdlde2L1w3BZ7l8LUAR7j9wfeRsvO6N9QVOdsv7VDwl67gVhfBRjY1m+J0T2S/wcRfs4u49qTcK0wCQ2ylsQa+yzJJmkLDnYZGtJw8dsdUOi4ovUFKUiLrpCQa5eNOn9AHD5y6vLsRN/VHvTJyTAKqkDdux6J/V8nVMSk+xyDZtZlIKYnI6Vr+agiNUTGMltEEtjIna+Wz/NO5EGIkxlY2jA8j402ZQnDsEebUnzyugysCRxC/PvuHrskSapwP7my+kCpmedf/XsMwRhCZPgv+11dpvYDlEcv/VIYe5cHDyaeD3liiJrW34lyJg1bimTSPCSjdDpcbhwDbsKddUBqBFtkjHMNkXc3yyQ21axRmoYUc3pzYQDLCVsrZdsUNGuw32CnnmTe4y+8IjyHK5WbXrTaViXI+l+d5b9bx9c1eYygKU/LDlnHym4ZVSfz69wptqNoP6XNZnLskc8+F05bOF+wIQnklFKhlzoU62cKC5STK0onNFJWRaheyG90xNnOTqN6juNPGDJwtXayDNipWz+X5O2GSSzxFhRUfrZqgahvXmHedr611boz4G16gT6hBnixzqAtS6A+cA7F4XRbOooCpm7L
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199021)(8676002)(478600001)(6506007)(1076003)(26005)(186003)(6512007)(6666004)(52116002)(6486002)(2616005)(41300700001)(83380400001)(316002)(2906002)(44832011)(8936002)(5660300002)(7416002)(66476007)(66556008)(66946007)(6916009)(54906003)(86362001)(36756003)(4326008)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h+t4RU+yDSo9cNmd+rQcb3F+GYjZzRw4j0T3eoW7HbRWEqurZ0cJqV24g9N+?=
 =?us-ascii?Q?NcTgQt627K94q6QsJ6rOcevYHmRNxCbMlIyOciOq3FYl5RkNCp7gSgsODrPz?=
 =?us-ascii?Q?uS4pcn1wsxiS9a0rYAiJR3B9wdB0742XIJYuyAtA8gK847wAmvT2Hn9DT/pv?=
 =?us-ascii?Q?8epAthe1V/JsIZGoRkg6XrIOS4Zx2N6fVa0hAtE637GyucxnV9dfGp0YVtT+?=
 =?us-ascii?Q?RVLXyqR+PDbgLasP2SAytCylorfZ6bWKDcLsenp7L1PIp+fr9Tn5Ck71PJAX?=
 =?us-ascii?Q?OVb7OJF9rhjjOSXGl+pGwVBHuOYD8uVcgkTb4atFsqA0vLAdMnRzyGnEUiPf?=
 =?us-ascii?Q?4yqnK9zA37mth4+on6keSkhTG36gpNBDw04OUXYax6YiCox1s4e4Jn/mc+lG?=
 =?us-ascii?Q?RDCpSCKHPQwIWjjVVn+riNnTcLwwPANGt0DsYKzeyedghQc9525B5x3ketn+?=
 =?us-ascii?Q?wYLiUz6qATIgd8LEq0noJ6BylkM44RtO/mObTtNMn5eCkM6CEfIoWtZi/RUa?=
 =?us-ascii?Q?haKQWVhuCepS+AG0NgubatuoWu1WoZt/Y/NNX/JPkl+P+8V45jeNZPNqQqs6?=
 =?us-ascii?Q?dE7qaEfeCvLzh/7UV9LsIUVq2qw6mRjqeRGfsm407GuzhyfK3UrHfBVGXiLB?=
 =?us-ascii?Q?x6S5xcri+Uxp5Cpif+ELrypz7EIZ3eX+p8fp8vcOCBkd4WEW6C7b97FtQYQQ?=
 =?us-ascii?Q?hsvMgOZ0buhdFwoPAwuWHW9f80bJ4tLUBaNyd0xNvana+mfazgKomKdLMn4M?=
 =?us-ascii?Q?YSMJiroby/eA+0AXB/r94uCMeG32GrctD3ROJDFMh1rf6DJ+cr0Lo1Ab/5Ae?=
 =?us-ascii?Q?3YvoOvB+jV6kfYZKUNTivTzbHawtEXsFwy+hSnAIf/ZfxPs7jVUswqOzVESv?=
 =?us-ascii?Q?fP0dgJt0Qp1NERghN6sWBZw4n/2FLpTKW3aLW3daYjOHk9bawp+DblhUM/Dv?=
 =?us-ascii?Q?OsTAehPXEOnOgKQgvdY66BijaA6hpIf3ZElBw9acR6aLWL2S6CBcf4KuEtTJ?=
 =?us-ascii?Q?7IeJCXkqHENYaL8PVArjIw2ijI9dWH1iwo4IZMpjMOZGsseWmVvc+hPZmRxy?=
 =?us-ascii?Q?5SXWxa3+HyLP7AJwpLofBFECaMRWth5Q25cHkUcp6AwJofKX+C8/a9c5mhIV?=
 =?us-ascii?Q?1XNMAAI0vYi2vjwFKNe1KEmuuGGAzkF8fUeN9RYjOFL0AfOYA77U7r96ppJL?=
 =?us-ascii?Q?G3OC0HEIsBhkM22CL52Ju3tdaOOhv63vOrUvLQH0zYGtibPcPkWs2EMmxR5i?=
 =?us-ascii?Q?tvU/VpbYMCwo/YuPwIXd5BFP926ejfIkm79Fi6+tMHhkzS0nrAfEIrXhdCXS?=
 =?us-ascii?Q?yzBtmtPpPQer4g1GzXjLk07yKJMz61gTSgvRz38lPCVaDCz2IGUgvoCv7SXP?=
 =?us-ascii?Q?/CgdcV8fkF++B0lDHWw9YS/uFxvWc5NbKo6YXJGNCNtbL3limAHaH1FaMGIV?=
 =?us-ascii?Q?0O6U/HvzOl1uRV5i7bSQGPEKhCOqWh9dCF4PnhKo+/Gupanek63aLse5AeTo?=
 =?us-ascii?Q?XIy+J0akL98fAb/X7dyaIfvQY3+mkVGUbi5rjd1F5k649HoRyiITcx5vk268?=
 =?us-ascii?Q?S7lq88bh5xEm5aPF17RH46kaSQsa14xyaqvUFpXXE19H4cHo22J5PJQjPKHc?=
 =?us-ascii?Q?fw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 376f037a-d8a0-4f3c-ea4f-08db63557a5d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 10:38:18.1021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynfzbte0jiI4t1W918rTeoIDhjD2KxNeSz0GpxokvdkaeGGM9izeKVkcRMVVScUd8TTApIFmtcD+L9eJzBJJFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8926
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is a simple code transformation with no intended behavior change,
just to make it absolutely clear that q->qdiscs[] is only attached to
the child taprio classes in full offload mode.

Right now we use the q->qdiscs[] variable in taprio_attach() for
software mode too, but that is quite confusing and avoidable. We use
it only to reach the netdev TX queue, but we could as well just use
netdev_get_tx_queue() for that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 3c4c2c334878..b1c611c72aa4 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -2130,14 +2130,20 @@ static void taprio_attach(struct Qdisc *sch)
 
 	/* Attach underlying qdisc */
 	for (ntx = 0; ntx < dev->num_tx_queues; ntx++) {
-		struct Qdisc *qdisc = q->qdiscs[ntx];
+		struct netdev_queue *dev_queue = netdev_get_tx_queue(dev, ntx);
 		struct Qdisc *old;
 
 		if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+			struct Qdisc *qdisc = q->qdiscs[ntx];
+
 			qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
-			old = dev_graft_qdisc(qdisc->dev_queue, qdisc);
+			old = dev_graft_qdisc(dev_queue, qdisc);
 		} else {
-			old = dev_graft_qdisc(qdisc->dev_queue, sch);
+			/* In software mode, attach the root taprio qdisc
+			 * to all netdev TX queues, so that dev_qdisc_enqueue()
+			 * goes through taprio_enqueue().
+			 */
+			old = dev_graft_qdisc(dev_queue, sch);
 			qdisc_refcount_inc(sch);
 		}
 		if (old)
-- 
2.34.1


