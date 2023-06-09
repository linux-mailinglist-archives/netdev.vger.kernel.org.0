Return-Path: <netdev+bounces-9556-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F85729C16
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 683CD1C210E8
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 310C017ABE;
	Fri,  9 Jun 2023 13:59:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E85417ABA
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:59:39 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2074.outbound.protection.outlook.com [40.107.22.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAB530FE;
	Fri,  9 Jun 2023 06:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fauk8yp8EzHMG9NtZqMdDIDX/queT4wAVZHwyqe3UHlVOytHX8EE/xnxRwOpXqjvVEIxEYLmZJ+8bqIkCDthFzLvkOKZW7tjE1v1WWeZ89ZSTtrjk5gn9oeFTs+7V7lpwprJH9ZroTIFMa7FeAyTsVOnC4cxcbEnVzX0udsCpsT6BqZPJwFz7B8BQERcNZGLRj5zkfGdQJc/qK30uR4IMHkpDj8YrLIx4PaXxdH/Ge5Vk3/f0aaGX73mMMFaruOO56n80TP1M4DKeR4eH8gbg14nempiRYTvPw8JQC+ucUXNolNH7GhlM7awRg8uXmu0Uz8FX875FjcvR3+ICq6iBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+XsY/pxzJ3hK+6HEcOVvLyrXrI9dhimlwyin+AHipB4=;
 b=R3ipTnI/43or90X13XwPD6KAgnjSa2tYFrPkMVZm3w7ZcZHBzHwAC0+YZHpzZD7yfN6BTP82T9xIo5D+8WU5lB5R/BDn8I30QY4VZ814qa2F+k5EGY5rBujijUbRYeRca6ncSMx244wWsjml+yVw+d2TZFTMaTWXBI3fnxA29ltPUQx1QfNiBEIrQ4maFZVoPfpHox65k3S/jeNvjZLgp4dTQCOGfQaVYA1Gl1xKjeceYow4B1ZsqCXVXSofkii7GkDio1c7ghPrNEX0BWOYl5wnHN2OVUlkPhK4XHVg/f3v44AXBN0CfKjpejgHUk8Eget21Cg5ztVuNgfGhiSSDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+XsY/pxzJ3hK+6HEcOVvLyrXrI9dhimlwyin+AHipB4=;
 b=nZn02v1YLql0KInUbpuIvZekfKAba82Had7W3xDnVeWzAwfiO2WNsy+bekVP1xCG5JDLp0I4Phue82/7AHt7eMofYnwnUA2+0p2s+rMbKixm/HU2aYIGBYeSxRJ8PUmG688OcDXTu9ew84t6FO/oj0eW2Flf3poeh6aoRKNqheY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM0PR04MB7139.eurprd04.prod.outlook.com (2603:10a6:208:19d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Fri, 9 Jun
 2023 13:59:32 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 13:59:30 +0000
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
	Kurt Kanzenbach <kurt@linutronix.de>,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
	linux-kernel@vger.kernel.org,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: [PATCH net-next 1/2] net/sched: taprio: report class offload stats per TXQ, not per TC
Date: Fri,  9 Jun 2023 16:59:16 +0300
Message-Id: <20230609135917.1084327-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609135917.1084327-1-vladimir.oltean@nxp.com>
References: <20230609135917.1084327-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0091.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::11) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM0PR04MB7139:EE_
X-MS-Office365-Filtering-Correlation-Id: 48fd5983-bb72-4da3-2e2d-08db68f1bf2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6wSS6sQ2ElYPlNtSFbQuqDhk57vQYuKOysXbN4SVKURwjrIE41BxOeucOowuQuEOfJ8nvZn2C5lcJzsaCl0PzeiRoB9mkd8+Xi2xZW9umJtweR0F21nakG+7lJsXPdZsqKM511DMnmSw3XTp9uQYNtyiEzrfgC+Iv58/pJ9CjgLbTW5FqoXlhHLpLY0bPjNJ/siyzZufzS28K/9w14zViTCmlsGXlLRIsYXiR31qoq5eNXmDapwtRH9z9E/LPFrlGtYeqcYvAAgm110ritjgk+D1Qfx0FflQt4ATH4rGk06zFTKxUqW2CsZFkwo7q8v1jvLijnWIx4Q7nc3Nx3OTiWIXt0beQ6OsVWXGFonQ402dsMcRHsbPxQPO34sr/wC/DzwxVh+sydE2b4OTgYwfN23KIjZxGAph69G5D4JVRyWBjZm+RSJqpE/Kpy7ktIgJO8X7iY83qQf3Zd768LYAvodPloRYOuPw9qj+kg2q2a9QtqSkbn8eQMgbrVJ4QUd7QWzCGWEjXrDmKP7yuWRePs9FuY9nN2lKqHQeWQHxxxE+TsFUPvp8sYvcwFMV51UscqgAPoVCCCcWGjD0KrealkcFH7MPAfhnZQRfLuzSDXa61aUzr0dxk0jeenXAH0/x
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199021)(66946007)(66476007)(316002)(6666004)(66556008)(54906003)(6916009)(4326008)(478600001)(86362001)(36756003)(6506007)(1076003)(26005)(6512007)(186003)(83380400001)(41300700001)(8936002)(8676002)(7416002)(44832011)(2906002)(5660300002)(52116002)(6486002)(2616005)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MpXohYnWaz2HlHVy9jEftzSp1r1zj14hCa7BpNgsoFnz7aS6Ty9BkFmnq35T?=
 =?us-ascii?Q?mYnPBiVlcNb+EDYQf4qDExFk8l2gWyMbBGvVvRpsNq4XfFXHW0jXVm67mwQY?=
 =?us-ascii?Q?6vB81/p5caHrE0D2VH87Jd2+FAlDWFDXLqAe4N/vrKUHGuc/drA27CLbkE6O?=
 =?us-ascii?Q?2PIbwb6GYqPEIKSb9F0susuJxJg6t2Pp3dM4wKp0nCFBe0r1XqbU3CkdGUgw?=
 =?us-ascii?Q?TcsiTBydwVcg+bmOsgptMKDkst4qYRdYfkYSjWglvS6h9Sm8e+m1sVLV3guW?=
 =?us-ascii?Q?JzIBn0feONbd87TgpvIzxg6WzBYbtQW9q1HRv+t3Mr9WulnbA4OHGtMw3AQS?=
 =?us-ascii?Q?xg/7KBoNtc5V6khKPo2XokYVoRI31H3unJNKdHdzSEfaIbUanmzbOM/FA284?=
 =?us-ascii?Q?qxtuvtHluubfWu2d4x3S3iCCz67qihygImAbgdqWv4jUQuwb4Q5pO6d+pBx+?=
 =?us-ascii?Q?7B3aAGDwtAEDahXmkKdDJMJTwpNnAFRlJEW1EmVfKdGKy/IcEN86ALcuw9C8?=
 =?us-ascii?Q?vpXQ6W0a9xc16w2W1pbTmLlRJCNsG1WvNT66GpWyDWQvGJw6trPIFtDur7DX?=
 =?us-ascii?Q?A+VIdlijKBiVC41PHcdW24uUX4f3L1FOFrL1T9dm0uNcsrOtr1OkSkB95V0H?=
 =?us-ascii?Q?uENLCKVRefpL+lx5rQ4D9ZO9BCdRgC1oKhNxk71zx9i1FM6M+6c+LNphpKEe?=
 =?us-ascii?Q?UAlCLb/3tzCEh8Yqezgehlrq5SxPJBUZL8B62JPjGpQlqrgACrcxhmS8fhrh?=
 =?us-ascii?Q?VyerYa8k6YSK72Er3erBMQEPUDZAtZgTDgn7rKqWiovcPcnTCXaudtfrweve?=
 =?us-ascii?Q?YFlTjo10l8oyqmijH5QT7KMz7NKgGTklKOwMtzQnam0BkIiQkYa9kYzJB6sR?=
 =?us-ascii?Q?3TqcxjmwRAvJFT7d092ttyqlAdKF4eOyD/uwZW/ijlPE8l6ZvQHHiLC3Gu3X?=
 =?us-ascii?Q?z3FfpIa5zQjWWSuhFncv0nxyrZNlZYuNExl5aFz969SLfIDkedB736qxdSfP?=
 =?us-ascii?Q?vAaKDYqYggs0d4hzpF8LpJW82t1dAhvpu5NJqTwXZx2FrMaaVh+wjKVBDgdc?=
 =?us-ascii?Q?oNofYzIZdjb43pE3l1yHzxs95FiAJiXXrxDNDmYLjpf3ZGhhI63xM/3thQh6?=
 =?us-ascii?Q?oobzt+bpqSY08aI/qYH5KUsS8YGi8lko5J0QmNL7G2hyBhiYNGO25mogH5Xt?=
 =?us-ascii?Q?nto3M9ulXnMfzqYRhcAzlYjwCxCdeMHDQJXjzsoyKSnXazdYH++HuLf4Hqt+?=
 =?us-ascii?Q?0W+i9XeQVcMcV4zWE7phl2pcPhTrt+uvS7VkubhT2oh9oiIf8Se3IX6wGr8o?=
 =?us-ascii?Q?ZMn0BEKAnY7VETz6LBb1ZFsZIlY1N91GlHoYgYetQ4C0YtkcU8ZsdumwFBJA?=
 =?us-ascii?Q?haly5XvoxZ3JqTq2P0YPBt//KuUVYls3d1kw8+z23RyM0n23QMbzmQOZsCnK?=
 =?us-ascii?Q?/BA2/K6ToX0vCdtWgwqQVXYC/Aqk806DjKQvgU8NPjb0YnYx5vtFFKsgr09A?=
 =?us-ascii?Q?Qkm3Njqt3r0dEcI7iG/uKAmnDtDIfj0DueQtMkinb8g2juAhn1/dXPfU68+4?=
 =?us-ascii?Q?u9etUAklGgjW0lwg12kscREhunQOHq8cGkUFX9I1w/9+2Uia16Cf+iTcEvYZ?=
 =?us-ascii?Q?5A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48fd5983-bb72-4da3-2e2d-08db68f1bf2b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 13:59:30.8157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mzkL73o/FCn/boCeOQmOjvHzcqwAl8ten1W4EWmgcN6b54khmaXk3bWCGVqQB7EWfoD0Geqb3SDJDA/PXUlcuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7139
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The taprio Qdisc creates child classes per netdev TX queue, but
taprio_dump_class_stats() currently reports offload statistics per
traffic class. Traffic classes are groups of TXQs sharing the same
dequeue priority, so this is incorrect and we shouldn't be bundling up
the TXQ stats when reporting them, as we currently do in enetc.

Modify the API from taprio to drivers such that they report TXQ offload
stats and not TC offload stats.

There is no change in the UAPI or in the global Qdisc stats.

Fixes: 6c1adb650c8d ("net/sched: taprio: add netlink reporting for offload statistics counters")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 20 +++++++------------
 include/net/pkt_sched.h                       | 10 +++++-----
 net/sched/sch_taprio.c                        |  8 ++++----
 3 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 71157eba1fbe..58cdd67bb573 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -160,20 +160,14 @@ static void enetc_taprio_stats(struct net_device *ndev,
 	stats->window_drops = window_drops;
 }
 
-static void enetc_taprio_tc_stats(struct net_device *ndev,
-				  struct tc_taprio_qopt_tc_stats *tc_stats)
+static void enetc_taprio_queue_stats(struct net_device *ndev,
+				     struct tc_taprio_qopt_queue_stats *queue_stats)
 {
-	struct tc_taprio_qopt_stats *stats = &tc_stats->stats;
+	struct tc_taprio_qopt_stats *stats = &queue_stats->stats;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	int tc = tc_stats->tc;
-	u64 window_drops = 0;
-	int i;
+	int queue = queue_stats->queue;
 
-	for (i = 0; i < priv->num_tx_rings; i++)
-		if (priv->tx_ring[i]->prio == tc)
-			window_drops += priv->tx_ring[i]->stats.win_drop;
-
-	stats->window_drops = window_drops;
+	stats->window_drops = priv->tx_ring[queue]->stats.win_drop;
 }
 
 static int enetc_taprio_replace(struct net_device *ndev,
@@ -208,8 +202,8 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 	case TAPRIO_CMD_STATS:
 		enetc_taprio_stats(ndev, &offload->stats);
 		break;
-	case TAPRIO_CMD_TC_STATS:
-		enetc_taprio_tc_stats(ndev, &offload->tc_stats);
+	case TAPRIO_CMD_QUEUE_STATS:
+		enetc_taprio_queue_stats(ndev, &offload->queue_stats);
 		break;
 	default:
 		err = -EOPNOTSUPP;
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 518febb91c9f..e98aac9d5ad5 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -191,7 +191,7 @@ enum tc_taprio_qopt_cmd {
 	TAPRIO_CMD_REPLACE,
 	TAPRIO_CMD_DESTROY,
 	TAPRIO_CMD_STATS,
-	TAPRIO_CMD_TC_STATS,
+	TAPRIO_CMD_QUEUE_STATS,
 };
 
 /**
@@ -208,8 +208,8 @@ struct tc_taprio_qopt_stats {
 	u64 tx_overruns;
 };
 
-struct tc_taprio_qopt_tc_stats {
-	int tc;
+struct tc_taprio_qopt_queue_stats {
+	int queue;
 	struct tc_taprio_qopt_stats stats;
 };
 
@@ -227,8 +227,8 @@ struct tc_taprio_qopt_offload {
 	union {
 		/* TAPRIO_CMD_STATS */
 		struct tc_taprio_qopt_stats stats;
-		/* TAPRIO_CMD_TC_STATS */
-		struct tc_taprio_qopt_tc_stats tc_stats;
+		/* TAPRIO_CMD_QUEUE_STATS */
+		struct tc_taprio_qopt_queue_stats queue_stats;
 		/* TAPRIO_CMD_REPLACE */
 		struct {
 			struct tc_mqprio_qopt_offload mqprio;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 5076da103f63..20d2702f862e 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -2457,9 +2457,9 @@ static int taprio_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 {
 	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
 	struct tc_taprio_qopt_offload offload = {
-		.cmd = TAPRIO_CMD_TC_STATS,
-		.tc_stats = {
-			.tc = cl - 1,
+		.cmd = TAPRIO_CMD_QUEUE_STATS,
+		.queue_stats = {
+			.queue = cl - 1,
 		},
 	};
 	struct Qdisc *child;
@@ -2469,7 +2469,7 @@ static int taprio_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 	    qdisc_qstats_copy(d, child) < 0)
 		return -1;
 
-	return taprio_dump_xstats(sch, d, &offload, &offload.tc_stats.stats);
+	return taprio_dump_xstats(sch, d, &offload, &offload.queue_stats.stats);
 }
 
 static void taprio_walk(struct Qdisc *sch, struct qdisc_walker *arg)
-- 
2.34.1


