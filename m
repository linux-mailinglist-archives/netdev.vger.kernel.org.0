Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0061068AA67
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbjBDNyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbjBDNxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:55 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC60137F29
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlB8LWUSdk4BNBEsb2D1D/hzJnmbOdxY6qcBdTOBXffPb7ngLnXWAgYtN52ZHN+1wMrZ9OIxTo0rRcsDcVsZlsKsRaQgMyGmouJnwEJY1LaX7ZKQYBnfnHXv9pjew2D4+JHOq2G6GpuwWC3VSKH9wtDRZ0tgnq5e/H6W//jvAJIDiuI0d5BAXHhPgS6xI4Fu1gl7irZaUN55Ve36LH28HjGtSt+0EwAEUi/iuxnsfnP86Xujz5KvmQu07dHkWMDsFV2oP6RIKr0Elh9in6pTGc8Rpi0HDGjYC9JCF3init10VaK21tPGjSY7mBvSzlgEgioN8PisqL6MemnCZ5wACw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j7ph2qvn6Ax/zsgcJ+oe4RoqAv0RrsS8vh/MaNU93YY=;
 b=cF6RE2i/B9dxnSywwrhtYpuIcLjAOgE5kK+IprdkSSQsUxjPBF6TV4Ym7s/eJjIPa4aTCHxpoFKu3Un9ONASDG/4eIMRZJB2ikf2TN7SpFd6kT+eS0EbUiiGgGQvuiRXj3ODlwATp4hvHB6c/32Dxs8JYpTtBcjgvg05OiCOJ6qeu4SRfsgvSAqjMlQcG9CwaXNr+HoFUwBdG7l69xyQPa3haZ/8s9/QC4y9nf/0qdObWX1wQtu+otmZr6NiQcGcOhkGlyEKu0ho37PApI+oztrHqH2V3sn6/v4Ek+fVaosvSip3jCxNE6qF8/AOgUTDfXze/TihwyWjwrXcg5h1UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7ph2qvn6Ax/zsgcJ+oe4RoqAv0RrsS8vh/MaNU93YY=;
 b=KIRfrJccTxR4T/wSSsBpi3rb0NiOyBDrV0SSe0Fdzk7xX1WcpxLCY2nePhSvkhEm6PtaOD2ymX+rnfuR9NuIzzOPeVniayNGSasVzL4XpLvqvD1EtgEUSLZlndJYiKicBSn2OxO7FnLsxTfU63mM2dSs2eoBEP3KjUxitJClVC4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8783.eurprd04.prod.outlook.com (2603:10a6:102:20e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:35 +0000
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
Subject: [PATCH v6 net-next 08/13] net/sched: refactor mqprio qopt reconstruction to a library function
Date:   Sat,  4 Feb 2023 15:53:02 +0200
Message-Id: <20230204135307.1036988-9-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 59eb8fb9-d710-47ca-2419-08db06b735d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RxVdekRGOjzyecvWxY4lC6XeCovTh8K6MIaE3rt4Dcz4lOPgttAcK3ZdWpXqXpqaRfhbqxrvZVrO0uLHG5mP+oE56yCbfHJGu+DnoqDz0xwcF43xnBoSmUAfyPEHJcM9eC1aEfV9nEzIWZHQzvYJfIvAOijipFtWCl++nswC29IVVWYV+bgRCGvO7XLG2v7exP993fHRVnShlKRTsNN0zELG9Nr5+ZEqgw9mekm8jPHJtrnbtTm/bgAcs4yoP0fDAFv1Hh/XJ3vYg8b2ebvGOB6TOjwlrAT0LgfvhVoGvqIO3c0jCiAQPm/8fAn8KNWRmNRVqiSlQvQTyUb5j9UerL2hjtxS55E/+PuDBsW16uVVtjYS+VsYjQqooPyVhIoO2Qh3aH5jXttkjm+bnq6+M8MSHdWfbI2dnYFp24GkKH9X5bfx8RaejO5K0d/SlXMXqkw6/4vWquxYmi2BlqEfV2MlqTL/Kv0kEGtt2ifqzCskZiAq4TREQ3LGomEtmw7YiOfb46ZeMomrje4CQ6RFIW7U3VTfeFHvte/FW4OkUrxttReplQ4kf3ixTfFWef8d+k2C+NYPHRc9ZeMXbUPVCKdiBV8b1hiOIHZGiToZhVNRobvElyTZotlZgPm1c9IGL6gVtenM6C/4Qi2WDsP1swq+DE+4miaAF527OpC60ly8yALdtR43UAnpF6SXmk+bRa0cwE1IvASh+ePDnhvxRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(478600001)(6486002)(2906002)(52116002)(26005)(6512007)(186003)(66476007)(66946007)(6666004)(6506007)(1076003)(41300700001)(8676002)(8936002)(6916009)(66556008)(4326008)(44832011)(7416002)(316002)(5660300002)(54906003)(38100700002)(38350700002)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cp+uBUwM141r1mB2mDhiupqRNkg57rMOcqtllOGM2KYgKKghe2lHhQnH+FeD?=
 =?us-ascii?Q?HM/nN87Uq/sbQXI+HTQZeIU2xBvpCom6VSlMKshLSWzkQUyF7PjcA1d47MwT?=
 =?us-ascii?Q?Db9uDSlz0RFRG2M1bTimJaZOjoTq9cb+484q1gr5HOP7cKcD+2K8VXOhyZYH?=
 =?us-ascii?Q?1ukpjnVVkRt5PqQR0NFaDHphe4u3+vigg7O+Nt6XBcxTXpo4Wp9DUaIGclRL?=
 =?us-ascii?Q?D96sf2/sxpo7ZXAIVlCoGtZei6OdsTI7GRXF0maoXcbhmv54/hHuTqOkuLgW?=
 =?us-ascii?Q?OjxsELNWogQCxkRYxY3hV2mWXfXtmqp9Qf6hSrlrCJx97p+DvoEtUgpvt8uy?=
 =?us-ascii?Q?wfBOXBqsVAEkxl/qkmJ80XIKfGGiR236BBFU/FOmq8kMQ2DnY69ELedDE2LT?=
 =?us-ascii?Q?XfYyjJ2TwUn2TJ6nyFuVvlvMPNk5Fgs5AvP1TSAcZduw7At4APp7Qe2fzRO3?=
 =?us-ascii?Q?3tvEkBXbq8yfBRSxpUcUH4pXpCkkKUNDNwifVoD6SOfkOOLZ+6dkpQTiGDUx?=
 =?us-ascii?Q?c1EeeuKkifRjtFLFfcUz1M2qbBKgHD40e9+IJsnI24VeDJo7rk5Pgpy2uCwN?=
 =?us-ascii?Q?2M0/VpNqiE16j76yUpHXW70kkyaDdPp5skrbgdMhUCZQOMiQZyQkWGwhgSOO?=
 =?us-ascii?Q?mddYaOX86gpkHg7wXiohnuhY7419OfP/5fq8teqZSbUfGxImE8mWbqjJLYP9?=
 =?us-ascii?Q?zVB6NFyvUCYwJJBYEDjSwOokchDzuqx8DS95BIYlsNlgRd2EX8deB2CaKZS9?=
 =?us-ascii?Q?eRNLrHORBFMyw9CDKdz0ibGj0ohePp1hgk/gYQH30DCxZ2jS5zRIU5bMqeIx?=
 =?us-ascii?Q?OthMdEfhu7oMl5Ukxxk3HBORjslzTmFUNhDDI9tE9xQe4sYtsvy0TTlw0duU?=
 =?us-ascii?Q?XoAlp0wNDg2BXRZcDKy0IeM8+Pddzgur2Z6nqw8r6eKZnOjbVBZWfug2/Frc?=
 =?us-ascii?Q?IJT4e/pqgwE26ZZbpLiDlVVlxekMw4o1b7LoSDbbJxZCYdZ8pc9S0924BnRy?=
 =?us-ascii?Q?m/KxSJt9xn7VGMUvsY0jtgnEl29p7BrmXjvGzhZHaS0ZjO4gj+M5RiPR/hiH?=
 =?us-ascii?Q?nGOBIbnocuDt5kJgKzG5TTJcBZYnrUcXlIFXVNw9CCiuGWX/c/Ntq9ccjjog?=
 =?us-ascii?Q?djOG5/ge6+nTL4zZg0NJtUtbXSw5AwQYT4BBW1i9HXaxZIMjZWbMfIRH1MRN?=
 =?us-ascii?Q?4HYfYUpAiXqrx47o8Nyjb/wUalZxmB4F1sDDIdj/xRc1iUx3Y8MBsGIpviA1?=
 =?us-ascii?Q?Cc7WbzN8z4bjY+IAW0Jiu10dWT34u8sFVYFEKWuYGIJeYL+xT4pGBHOBciou?=
 =?us-ascii?Q?z1DExs1/WMeywgZLr2APV2fbhEy2iBStP9q9zfI0vngbLYgcpSxNk7734JFk?=
 =?us-ascii?Q?3GC/BDRhg8ShpBenDXVywFFHuGRRzOaMEokB1gF7pq8eQL8TvMOeibRl4s/p?=
 =?us-ascii?Q?O6wweqqNKtRcGZGeVO52ViAXuzuqDZN44EcFdeRZSfELx5A2iVh3qa2Tu4F1?=
 =?us-ascii?Q?lwTqvWju0KjGykPhpsFOkxCKa9ZoSaVFZo0bsgt/HR0ydpAmSnC6NEws5z7p?=
 =?us-ascii?Q?dtSOrMr6d8jgbJzsPGX4EFgjcKh8uRpuKCiyHVhz4udgCOHDDVO3ELqQHLf+?=
 =?us-ascii?Q?Rg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59eb8fb9-d710-47ca-2419-08db06b735d7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:35.7474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9FAjR6Q0M+6pCqWo5WNRK37bteMIJloLDG9irVnTQJ1vQYd5jvb2mAz6vTrkhcVriNFKlfx9HK5yOG57OtMHcQ==
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

The taprio qdisc will need to reconstruct a struct tc_mqprio_qopt from
netdev settings once more in a future patch, but this code was already
written twice, once in taprio and once in mqprio.

Refactor the code to a helper in the common mqprio library.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v5->v6: none
v4->v5: patch is new

 net/sched/sch_mqprio.c     | 10 ++--------
 net/sched/sch_mqprio_lib.c | 14 ++++++++++++++
 net/sched/sch_mqprio_lib.h |  2 ++
 net/sched/sch_taprio.c     |  9 +--------
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 9303d2a1e840..48ed87b91086 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -406,7 +406,7 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct nlattr *nla = (struct nlattr *)skb_tail_pointer(skb);
 	struct tc_mqprio_qopt opt = { 0 };
 	struct Qdisc *qdisc;
-	unsigned int ntx, tc;
+	unsigned int ntx;
 
 	sch->q.qlen = 0;
 	gnet_stats_basic_sync_init(&sch->bstats);
@@ -430,15 +430,9 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 		spin_unlock_bh(qdisc_lock(qdisc));
 	}
 
-	opt.num_tc = netdev_get_num_tc(dev);
-	memcpy(opt.prio_tc_map, dev->prio_tc_map, sizeof(opt.prio_tc_map));
+	mqprio_qopt_reconstruct(dev, &opt);
 	opt.hw = priv->hw_offload;
 
-	for (tc = 0; tc < netdev_get_num_tc(dev); tc++) {
-		opt.count[tc] = dev->tc_to_txq[tc].count;
-		opt.offset[tc] = dev->tc_to_txq[tc].offset;
-	}
-
 	if (nla_put(skb, TCA_OPTIONS, sizeof(opt), &opt))
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_mqprio_lib.c b/net/sched/sch_mqprio_lib.c
index e782b412a000..c58a533b8ec5 100644
--- a/net/sched/sch_mqprio_lib.c
+++ b/net/sched/sch_mqprio_lib.c
@@ -100,4 +100,18 @@ int mqprio_validate_qopt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 }
 EXPORT_SYMBOL_GPL(mqprio_validate_qopt);
 
+void mqprio_qopt_reconstruct(struct net_device *dev, struct tc_mqprio_qopt *qopt)
+{
+	int tc, num_tc = netdev_get_num_tc(dev);
+
+	qopt->num_tc = num_tc;
+	memcpy(qopt->prio_tc_map, dev->prio_tc_map, sizeof(qopt->prio_tc_map));
+
+	for (tc = 0; tc < num_tc; tc++) {
+		qopt->count[tc] = dev->tc_to_txq[tc].count;
+		qopt->offset[tc] = dev->tc_to_txq[tc].offset;
+	}
+}
+EXPORT_SYMBOL_GPL(mqprio_qopt_reconstruct);
+
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_mqprio_lib.h b/net/sched/sch_mqprio_lib.h
index 353787a25648..63f725ab8761 100644
--- a/net/sched/sch_mqprio_lib.h
+++ b/net/sched/sch_mqprio_lib.h
@@ -12,5 +12,7 @@ int mqprio_validate_qopt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 			 bool validate_queue_counts,
 			 bool allow_overlapping_txqs,
 			 struct netlink_ext_ack *extack);
+void mqprio_qopt_reconstruct(struct net_device *dev,
+			     struct tc_mqprio_qopt *qopt);
 
 #endif
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 888a29ee1da6..6b3cecbe9f1f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1948,18 +1948,11 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct sched_gate_list *oper, *admin;
 	struct tc_mqprio_qopt opt = { 0 };
 	struct nlattr *nest, *sched_nest;
-	unsigned int i;
 
 	oper = rtnl_dereference(q->oper_sched);
 	admin = rtnl_dereference(q->admin_sched);
 
-	opt.num_tc = netdev_get_num_tc(dev);
-	memcpy(opt.prio_tc_map, dev->prio_tc_map, sizeof(opt.prio_tc_map));
-
-	for (i = 0; i < netdev_get_num_tc(dev); i++) {
-		opt.count[i] = dev->tc_to_txq[i].count;
-		opt.offset[i] = dev->tc_to_txq[i].offset;
-	}
+	mqprio_qopt_reconstruct(dev, &opt);
 
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (!nest)
-- 
2.34.1

