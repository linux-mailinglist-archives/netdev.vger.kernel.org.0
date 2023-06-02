Return-Path: <netdev+bounces-7386-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E43771FF8E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:40:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C81841C20AC9
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 220FB107B6;
	Fri,  2 Jun 2023 10:39:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10425C8C0
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:39:57 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2065.outbound.protection.outlook.com [40.107.20.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D68810FC;
	Fri,  2 Jun 2023 03:39:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgmH6u0uUjBokSHsByjs7y6pGjqPxRiXWssbEccsGjwZ1YZiV/QcNriDBvDCFpLkxYo6bdkaPITLSkwh2dNUJ7/+KEEezIW+e9lY/vNEHpFET8sFAxx+pgN4eR1K05XlPWwMCYXtFFOL5XS+YdPyZFWRapZrAzXPcb7z2KMzUDCiXBFME4iLkNsfylh/Qx4CbIDrnt19kzD3Z2/VKXmYCnAMZP0uxEFnk1H6vQ4AOWD9baiakpdcwoCS5DoBGnqBI89sRZnP31lTCfiVqyZPLpGQRvz/XthAiG2E+jMpNykAtaoI14b+SpExf+y4CW2IvZJItAvKbUDif5cSCo7UPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j2NIe3uM/y4O56qmrtdqLZ6MoKG1xfC+qdNDtgfdlP4=;
 b=ghMVejatq4rts8xpk6IBPQWKBdj8VMyZImeRxPqDX0LC8r6bSjOkvJsNDtywzYYjeVuupPnVk7kYLdvGs2vb7+buDKIgQxszAd8+nOpqvULhFS1dk8E+YYGytXbs+OIw2Cb4mY4osiRJvMF9W+eYhkXfILYaFrlfHS6ssAAsoS3zMY4O0mUdSnPIsLQSme47At1KGpXIQp8A/q6L2e4Fd0IY63ECQuYOi/V6YdSlzBBrmGPaUBL5yk9fmUZmk7Uw0nsmRIqRXB6dcrYypM0IWgwciMl7YyKw6p3R9ASH0hknCTMYNtOf33g1HU0dhKmaAz+8psqAa/HKS6m19O632A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2NIe3uM/y4O56qmrtdqLZ6MoKG1xfC+qdNDtgfdlP4=;
 b=afnN+efujdKY9hZky5jMDfRL2K99b4c+K9YbW+8cdWltu++DOwRo6SDW5DC17RkBcf/wUxaXQTQOpINPAAShIY2sbgwr1lWtFvFhVsM0+7ZOU5Db3P0SGVnFqXiqZFU6Jc0g5X95yaQO5jUXYS0fEV/PPQkNZgM+nEkhUQTUqY8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8926.eurprd04.prod.outlook.com (2603:10a6:102:20d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 10:38:19 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 10:38:19 +0000
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
Subject: [PATCH RESEND net-next 2/5] net/sched: taprio: keep child Qdisc refcount elevated at 2 in offload mode
Date: Fri,  2 Jun 2023 13:37:47 +0300
Message-Id: <20230602103750.2290132-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 87f51ae4-859a-40ef-2f3e-08db63557b07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3sY1wF1atYsj8VSPFiLvoVZtq5IZjsx+YiJ6JpHHLkd2tAYJnANQuEFhOz8cgGuAhKQ2sh2EOzzuEeoSm3rXTYk/JceAbRhOqDiI8gGoyEmDO6Axv8fD/3OxMBkD4rKIv1+1177Cy0snVqVhaWj22HvDwK8e7xO2Asqj03cE90+VIVUNXZqx/MWBiIzh3OckqT/D83GuLbmJab6vVZaeEMqXAjPFRW8zKR5A96fJ7Lj4KKEus7dvduuAQhHkcfVPEnZcnjkVYV0ynH8EPBcOQwSmWOPKgM54F/43vz1N0ZW67jNb7KqPFaAZK/AvsvMFkZ9RcOMPR4EULMTumB1xR2jrTI3GF/4+fb9PSV6qxY58hcPbq6YbcS4dh6Bvq5TTjOQa0CRpPSPu/ulrxBHXmu0ui2CYu1XYzSMmjlN8Hb4Tbm9YeLqN3jBonFQucoXbPRqJJVSXGK0TBTWFvkRWfBhAR2llKzFbeyqIrfg3H9LUHzEazpIR7VkuiGi2YDcvhqKl1FpE9KBTf/a57nSKCK+atNew3cSkDGELyFVTL/RWTiUGLDTSSnggy9fOFmACxV1nzE5FISr//cLfsl7df/cAxzzCNdnbWioLwdzP2FeyhH+lYJKNG9L1A6KZ//iC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199021)(8676002)(478600001)(6506007)(1076003)(26005)(186003)(6512007)(6666004)(52116002)(6486002)(2616005)(41300700001)(83380400001)(316002)(2906002)(44832011)(8936002)(5660300002)(7416002)(66476007)(66556008)(66946007)(6916009)(54906003)(86362001)(36756003)(4326008)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E2o07uJ3jjTcrO7aaXiAN2HKJMB81o4JFHM4fVjC9KYSdi8rCYue6I2Y8dcV?=
 =?us-ascii?Q?oKIF1b/AtAVJUSFx0EhUDaTY8eFXWXiWy7y7ThykVJOCQIVzGcVlzkfy5Stu?=
 =?us-ascii?Q?XxrxMp/tZbhpiw9zWSCuk39dnjHtEq6uNvNel9hLpHvM2cuR+KTfhKsuZEkR?=
 =?us-ascii?Q?ME/NNo24QI+wQXDFSoP81JnMxN2QqyrpkNkYrU+Wv2gFPJVHvV1n1y5KxPNq?=
 =?us-ascii?Q?aLpY5+9LsnzgrIhbjtTXr+pY0Vwl8gEwH4L18VsgwYyc+tlBj2M8GBpnE8gV?=
 =?us-ascii?Q?OQdxHiFQg9cRwwU+JMOnQZ+JnOq5wyL+AbD5/ZQ3inA5Dy+e72I768bvmajF?=
 =?us-ascii?Q?TcPef3wvF8gmxfiCi1qht9Amd6wsXLKXWUXfDYQOwKjKX5QQsCpZwLSgLopQ?=
 =?us-ascii?Q?uhAKnLCw6v1yD2KWEWvlEGBWLhBzZZjH+xZIA3HK/f2H8BtvSnACv1Fxtyjb?=
 =?us-ascii?Q?8EKhPgoxKmiCqtgQsjykJFHHS41VooNsXG5W1S9ke3r11BTqiVrc01XSfZ1n?=
 =?us-ascii?Q?uKDkI6lF/0qYMjmN5TcCU/E1eiiHOAB92gP1DoR0/eWTb0DCWi71kRop38I4?=
 =?us-ascii?Q?o7woSuouQDbjKXkgtas6a8Bha+809YW/Kw7POhherNU7ZlbFwJ4fGEQ0TT2J?=
 =?us-ascii?Q?u5PVALWtyH+yIISz09vy7KS9QVgXN1Z3oVqpvFJVzPtt/WmkkA8mLVXNvcPE?=
 =?us-ascii?Q?JLUAplrNVoLTSIcFiKYJezmRwrS4LgVRX6qTwc7UYpkwWoLSYIUvcLOeuJez?=
 =?us-ascii?Q?6Lfs8FUIJJbuICosoZMcfLINaILxKFjxg0fIKhiS6TjVhwJa5Qc0phe61O0g?=
 =?us-ascii?Q?SToWM4o8hUU6GtUcOoY40QQyxSpr0Ig0RU06LzwvmYWoFuOfnxd6MXZkiBZI?=
 =?us-ascii?Q?Q0N8Gw+GnCR7XGpTAFcNI9AGjmBGkEw0mEy8PFOrXqkQbznUR1dMLajDA1a9?=
 =?us-ascii?Q?VT6L90A+AXKLKYmEyZDJNqEK/awWBA6+75LdsPjrJ3mF5U92qTKPYf2ktSKh?=
 =?us-ascii?Q?mmdZPwpngKFmDXd8qI+H2V1xTTs1CqhC/ytihJVgo2nJKOGbiauLAXDBZ++r?=
 =?us-ascii?Q?3L5bRFaUnc0UAhTs48NS0JoXXd29n05xKy3kVuuR2uwOjjsTDinL3xhgCXIk?=
 =?us-ascii?Q?ZBDjbpyZ/e3GDvOyBsCDxQwMhn+u6C7nEL7tZr507uYyyPnU4+s9NqNv3YI+?=
 =?us-ascii?Q?74RjLh3AZ4F0iUVoQdiw6uNizroqhQ10FpLGGPWBjGBUjC+lOw1bY8Pnxt/2?=
 =?us-ascii?Q?yLFuRaZJxmjTOLUdkA0YowtHh3gGYlzmtBI3CoFgCwfEhlSioHWu05l/I8dO?=
 =?us-ascii?Q?A8zT8MO6Z9dHyaLWRdByjC5MUbMnJ4ree3GDaVa4Gny91T/KtWmoVNIA2CDI?=
 =?us-ascii?Q?vuxJ83Y9vNXRK9leiesmvcGNVYtwg4rPqLO54XkGro0zJiRO7/FtY92A96Dt?=
 =?us-ascii?Q?0PrL5mkK21+SHvA0ntbYbiYtSeHJZ8C3YmTQB7R46OCv48ZuWKr7QW87kVtF?=
 =?us-ascii?Q?SrUPsgLEuNYbgtqAyiXG4/JZhgcN+m1cdoDbQ37dqmawBWcBlLCgAOgXq8K5?=
 =?us-ascii?Q?2eirbWQLzqP+3cavtZiZowtr+UXpEMqxVOBdcl/qQSp+jdxBx0moB5hoOstQ?=
 =?us-ascii?Q?hg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f51ae4-859a-40ef-2f3e-08db63557b07
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 10:38:19.2286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j9mRJ/NR9Nv6PmNBzCCKyjIBucSDlEFK3ktygSgSf4A4ndf1Dq8IhjhuXfcI2o4nFf4K6j1HlAR+O8hT8Bwxkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8926
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The taprio qdisc currently lives in the following equilibrium.

In the software scheduling case, taprio attaches itself to all TXQs,
thus having a refcount of 1 + the number of TX queues. In this mode,
q->qdiscs[] is not visible directly to the Qdisc API. The lifetime of
the Qdiscs from this private array lasts until qdisc_destroy() ->
taprio_destroy().

In the fully offloaded case, the root taprio has a refcount of 1, and
all child q->qdiscs[] also have a refcount of 1. The child q->qdiscs[]
are visible to the Qdisc API (they are attached to the netdev TXQs
directly), however taprio loses a reference to them very early - during
qdisc_graft(parent==NULL) -> taprio_attach(). At that time, taprio frees
the q->qdiscs[] array to not leak memory, but interestingly, it does not
release a reference on these qdiscs because it doesn't effectively own
them - they are created by taprio but owned by the Qdisc core, and will
be freed by qdisc_graft(parent==NULL, new==NULL) -> qdisc_put(old) when
the Qdisc is deleted or when the child Qdisc is replaced with something
else.

My interest is to change this equilibrium such that taprio also owns a
reference on the q->qdiscs[] child Qdiscs for the lifetime of the root
Qdisc, including in full offload mode. I want this because I would like
taprio_leaf(), taprio_dump_class(), taprio_dump_class_stats() to have
insight into q->qdiscs[] for the software scheduling mode - currently
they look at dev_queue->qdisc_sleeping, which is, as mentioned, the same
as the root taprio.

The following set of changes is necessary:
- don't free q->qdiscs[] early in taprio_attach(), free it late in
  taprio_destroy() for consistency with software mode. But:
- currently that's not possible, because taprio doesn't own a reference
  on q->qdiscs[]. So hold that reference - once during the initial
  attach() and once during subsequent graft() calls when the child is
  changed.
- always keep track of the current child in q->qdiscs[], even for full
  offload mode, so that we free in taprio_destroy() what we should, and
  not something stale.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index b1c611c72aa4..8807fc915b79 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -2138,23 +2138,20 @@ static void taprio_attach(struct Qdisc *sch)
 
 			qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
 			old = dev_graft_qdisc(dev_queue, qdisc);
+			/* Keep refcount of q->qdiscs[ntx] at 2 */
+			qdisc_refcount_inc(qdisc);
 		} else {
 			/* In software mode, attach the root taprio qdisc
 			 * to all netdev TX queues, so that dev_qdisc_enqueue()
 			 * goes through taprio_enqueue().
 			 */
 			old = dev_graft_qdisc(dev_queue, sch);
+			/* Keep root refcount at 1 + num_tx_queues */
 			qdisc_refcount_inc(sch);
 		}
 		if (old)
 			qdisc_put(old);
 	}
-
-	/* access to the child qdiscs is not needed in offload mode */
-	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
-		kfree(q->qdiscs);
-		q->qdiscs = NULL;
-	}
 }
 
 static struct netdev_queue *taprio_queue_get(struct Qdisc *sch,
@@ -2183,15 +2180,24 @@ static int taprio_graft(struct Qdisc *sch, unsigned long cl,
 	if (dev->flags & IFF_UP)
 		dev_deactivate(dev);
 
-	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+	/* In software mode, the root taprio qdisc is still the one attached to
+	 * all netdev TX queues, and hence responsible for taprio_enqueue() to
+	 * forward the skbs to the child qdiscs from the private q->qdiscs[]
+	 * array. So only attach the new qdisc to the netdev queue in offload
+	 * mode, where the enqueue must bypass taprio. However, save the
+	 * reference to the new qdisc in the private array in both cases, to
+	 * have an up-to-date reference to our children.
+	 */
+	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 		*old = dev_graft_qdisc(dev_queue, new);
-	} else {
+	else
 		*old = q->qdiscs[cl - 1];
-		q->qdiscs[cl - 1] = new;
-	}
 
-	if (new)
+	q->qdiscs[cl - 1] = new;
+	if (new) {
+		qdisc_refcount_inc(new);
 		new->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
+	}
 
 	if (dev->flags & IFF_UP)
 		dev_activate(dev);
-- 
2.34.1


