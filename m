Return-Path: <netdev+bounces-10536-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52F3672EE66
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:56:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 836F01C208EC
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 450983ED8A;
	Tue, 13 Jun 2023 21:55:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3238017FE6
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 21:55:23 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2076.outbound.protection.outlook.com [40.107.22.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB44D1FFF;
	Tue, 13 Jun 2023 14:55:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4orWfmbKD/99sp/B+qWfo7//cl0MMiMnEGicrwlw4fG8L2Ri0TlToz97yhUjE5PcjdfxQh+aMFerweD3MV7smsdCubcjA0j+9jXGprdPULuL7jixZMe7eWF95D7qYa0/ykXQxvqVDhX+M0xZtP+ocxtGPn5ITU1x2+WfH1tqBmwb4ZJlaOW2Lemx7Ubb3LbBJM2OHD7h7MdbaIEYo+8WE41Oes70jK2XzOK87/an5BjyETY/PIz1pRXDXxZRG9DlQA6bgHarzGULafhh6DelT42Y7L1tAxmlSlOA9aYZH/RVY3r5HaHtAO7VeNR5PysKuoJ6TTfdYIGj20KIqC8FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gXqsxyTcNdi0rJ3gF6pbv2TOSMGV5sZGMFTjQSS/6+s=;
 b=eimiNss3pfyn78wVZZvHexGQyc1ihklh0c2jkTHug5+jkYs5FZLRKZisPU2OcTmd9/JNngloLRzHtVXn3/fPiDFHNzfNXEV7UbhqRXL5Pz85rzqQroIYWM4FYMf8nOcA8S/yzcvq0xop/pfLG1FNNEOYFCXrXJuGvoTH/7ODkog8yMX6UyLyfyjNtXiguKQw4nSqTz8RtzEi6EQGw1ycXE10aiDw3CngQLTZF/qAe69A7/Q4o81DfMSTIGzS6nIKWhfNf4v3WYz+59SWAfAgk/tDt+fzZyFKIk5jWzG9ToqX3ub6OYxH2CwovjqN+7kZl+3pEjTiyayWKDiX1yAstg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXqsxyTcNdi0rJ3gF6pbv2TOSMGV5sZGMFTjQSS/6+s=;
 b=EYU5zvnezGCbgKDy4nxmfswzHDNJeSG182E6wh119nI5uqri2/9ilP9CwJEUAeNzqzwTvdUDpi8V3m+4+1VZMQZ1Df4t+vCIsT54dHGx6AeieU5sR6SkwGKmylyipuAV2IbRwouOpju1Pw4osMXeMBSbq+KFguAD0SngzTlDKEc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8081.eurprd04.prod.outlook.com (2603:10a6:20b:3e2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 21:54:55 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 21:54:55 +0000
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
	Pedro Tammela <pctammela@mojatatu.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Maxim Georgiev <glipus@gmail.com>
Subject: [PATCH v2 net-next 3/9] net/sched: taprio: try again to report q->qdiscs[] to qdisc_leaf()
Date: Wed, 14 Jun 2023 00:54:34 +0300
Message-Id: <20230613215440.2465708-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
References: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0044.eurprd04.prod.outlook.com
 (2603:10a6:208:1::21) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8081:EE_
X-MS-Office365-Filtering-Correlation-Id: 402fba01-dace-4e23-7666-08db6c58d2a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SUexz1rET30jwIYCf5nr0iCVDDX05Ov92ybz4pllw1OchIIMOBfuWpNp+C4B69N5eLuZQw+VDH/yWivBwqAO1zPBxJSaQphzZLmEBh91AbVtio2fhtcBeo9BUWODkxsIY8pfRDP1bNbcYD97rz1yf3HCo5CPcyxGn5NGT6PH36neQQIsdWpHV6EKSriPZd4z/tVKg3BkiD4KhJgxEegT4eTabGrCtk+VcbVJsWCmfHh1HRevuN9seA0Up1sDqzngqZrLUL/8LJkMbxvx+Z6Qh2GvEseaajxSTdInvf9tf+eqpPJA0QUjKX4Or2SiMBtMrd7pIvLI6iG4ARBdUDcFLQxWEUZQcCFCBeIS3HQqjtTiNDDG/Xw1UjRCbz1kQnWPDKD8/IRKU1OySrTjDwFfor8DcqC9JHUO829FWO9pM55RiXumB1G6KuVaNXqjmFvqbpkLsThFbiQgATNbzZzlhiQMx+1tJJ9YVu1q/1rKSM/Ii28D5t8L+R6CLEmx9hVfPCCzkHTj+TUSyrAFLF48b0ujsOYLRLlFy1X0nyETbERtqTbHkOQR6Nc6c0OeSCPqTOOmpypKUxTIwnZOObfChiOaJDCvra8Dd/EuF/wGGgdfdG8g4etNpM15N84CDSO1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(6916009)(66946007)(4326008)(66556008)(36756003)(186003)(54906003)(478600001)(2616005)(2906002)(66476007)(8676002)(6666004)(316002)(41300700001)(86362001)(6486002)(7416002)(6506007)(1076003)(8936002)(44832011)(83380400001)(26005)(5660300002)(38100700002)(52116002)(38350700002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HdfRJboseWcgx/8M/zLytk9HdfK1gfoDgu0B1SHDOxfjQT0ABl0j7N7MHPkN?=
 =?us-ascii?Q?F1+pQvLoNh7o1y5D2WcDJldy1pwh71GdAmJLisJujzbUTvmgUYM1e5kLdWwY?=
 =?us-ascii?Q?AqyxIO4sTleXl6ESORSgDCkBqN8hH4/E2HBw1NuIFfKy3YV3Ekl6RO/67IPi?=
 =?us-ascii?Q?4/V0vtw/1jJMO53i7ideSysayrI6L4Tng7YQnEjTLuIL59sIIwAFQXCuSm5f?=
 =?us-ascii?Q?ejKQch2g8eNc7xv9eWHJQ//b11Z3oCC8eEChIvtNQ4XuW5XgiIVddlHQll9S?=
 =?us-ascii?Q?9Tx25PFtAaJo2ianquIkwNJPyyljyxdl9vBCwhirU+HopAwdS64wqUHOrR4C?=
 =?us-ascii?Q?m/K/GENqWVssNhIRi/8df1Jmz0y8sbC6/Y9OpNCg2S7hmUh6vCcmhj6iMH99?=
 =?us-ascii?Q?cmRTci2irUxVMAeRcYWy8r34P5QrYIIv8W/3e2cW1W85daHoDnYcFYPY0wH2?=
 =?us-ascii?Q?pdonES/VuWsZKTONq3A/TJzNii5s7QlYI7wutyzz6uwNHvL2ng4/7mCyOgUI?=
 =?us-ascii?Q?6PrPWP8FFdSr6wXCMCIw8K1grCYu+N8BGIa5wKVyezg7uzSxLmlbFNWVEw9O?=
 =?us-ascii?Q?648RdGTL8QEeeirN3dA6+vgrz83pxAhmCBFa+CdKNgyimKAnOy0q41+XDV8u?=
 =?us-ascii?Q?8NCfhYAKNwluva3Z3e0q0pWabwOd7xgMiyp0r+HHBqXB7D+p+797PjHtmSil?=
 =?us-ascii?Q?5vxb6SCcm/0hEDhXnS1j5Iyc88q9KH/r9pqgV3Y5QwOoZ6XebFjkjbqVksLt?=
 =?us-ascii?Q?NKG+y2+/gkWECMRZgDksgfVbsfe2awNyPVILXiXbbLlHl8jXiTZZOh8PtrYP?=
 =?us-ascii?Q?73SfoAGgsUs2kaR/FMrQoFhzr6UH3AZhEvWLxZs0Ju7+Tk52DcPggv4qH/Hp?=
 =?us-ascii?Q?iIPePEvR/SP7j/ADVLjKXlZL0HljhW+EmG+pN5tGiBZqpLpyb74pZbu7QJbh?=
 =?us-ascii?Q?sOvi34SmVv+0FEWLgT2vC6bd7f8yOF2pK3yKzyy/P6yaNpOj/5EIEGErx0Ah?=
 =?us-ascii?Q?zcEmWWafSUFhbACdpoOIqKNoRjfxdGhJQDVhD+T8I1gVIXxgn2BPzgRgBzGe?=
 =?us-ascii?Q?QETk7DjXn2RKfsKMA/dNNb1lAS/zhUskCoE6G873gJkBPNzHrlXucZqSk6Nr?=
 =?us-ascii?Q?KDSMxPOgfUjjN9UCCIak13hPzOkORkPG9ge4AtkLn4XMwlP1xX3iBoSD92Jr?=
 =?us-ascii?Q?alZTHMjebWe0O+yA4buJ5/Sz35RImXHtxXhHfEOIu/L+J58ApifcxURi8SM0?=
 =?us-ascii?Q?dv4SMuwQGVmX54BmWID82twahyd+srHMsubsThAL8tdsgEOqL9wtct3Yh+Xt?=
 =?us-ascii?Q?yTx1AZsqjL7F700z45jKqKc49NMW4UCXMu/POZIfuXqqpqLPg+fTqKKk/VSq?=
 =?us-ascii?Q?4X+5d5qrprNKtHo9z0/+Fvv7NCpFlDMGsOWKROx5J0qMyoaq9N/y/Jwvd0O/?=
 =?us-ascii?Q?YNUJdQ6MSnQlQoF9OUxZPvr6QhXSPWgOIM74Ji6iQWmnub3zm7sNX1sR6Dqf?=
 =?us-ascii?Q?W7l3icn1eN0jKRpz0f1EQOSA3ns6jb/SKszZIlqkXV9x+LLuCtUtAqGn/tq4?=
 =?us-ascii?Q?WI0agOVEaK+VjAqzN+YkJpDxqEIMO312KaXmhkjzp6dQ9iG/5sIKP+LyU/pe?=
 =?us-ascii?Q?Pg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 402fba01-dace-4e23-7666-08db6c58d2a0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 21:54:55.1497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J2+rR5t3sbS26AfIpoRB+C+5skYqmtQnfZOzsQTJ9b+mtK7svSyd20buyKZucd6SvL4SUWv/7ip20AXGFDtgAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is another stab at commit 1461d212ab27 ("net/sched: taprio: make
qdisc_leaf() see the per-netdev-queue pfifo child qdiscs"), later
reverted in commit af7b29b1deaa ("Revert "net/sched: taprio: make
qdisc_leaf() see the per-netdev-queue pfifo child qdiscs"").

I believe that the problems that caused the revert were fixed, and thus,
this change is identical to the original patch.

Its purpose is to properly reject attaching a software taprio child
qdisc to a software taprio parent. Because unoffloaded taprio currently
reports itself (the root Qdisc) as the return value from qdisc_leaf(),
then the process of attaching another taprio as child to a Qdisc class
of the root will just result in a Qdisc_ops :: change() call for the
root. Whereas that's not we want. We want Qdisc_ops :: init() to be
called for the taprio child, in order to give the taprio child a chance
to check whether its sch->parent is TC_H_ROOT or not (and reject this
configuration).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: rebase on top of rtnl_dereference() change for txq->qdisc_sleeping

 net/sched/sch_taprio.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index b5f533914415..14d628926d61 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -2439,12 +2439,14 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 
 static struct Qdisc *taprio_leaf(struct Qdisc *sch, unsigned long cl)
 {
-	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	unsigned int ntx = cl - 1;
 
-	if (!dev_queue)
+	if (ntx >= dev->num_tx_queues)
 		return NULL;
 
-	return rtnl_dereference(dev_queue->qdisc_sleeping);
+	return q->qdiscs[ntx];
 }
 
 static unsigned long taprio_find(struct Qdisc *sch, u32 classid)
-- 
2.34.1


