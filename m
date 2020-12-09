Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207A62D464D
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 17:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgLIQEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:04:48 -0500
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:36676
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728392AbgLIQEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 11:04:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSsU+59XmI+mOR4ibZserrq74hShDwWISRP1m8Ygv21+YdfcSSvovnDWV25ugoVgDAaJRid88BFhcOYyYYJ0TJJRWMX2RzrhFqO3N5to0P/P5eVG5LnHXOh6oFzQRCCGCtQ7je49K4bcfM+o+5mJ39uQitW/xNi6ijSlXXAl46aMYVHMBAGW8QGcMBmm/0sQ+4qAcMK9iCtEYx6bPe1fe5yDIY29jlK4wBonbjpiMCV727rFJanE/bJ2/+rGtb/gQfkbzLLovqpoPYViuvw8zpsFso7oN04AEyEGVJ8zxo+wq7lm9toXkl11wPI37AF8MxW7TxDDHUh/Aag5XswLMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cY5SSxJcE/uGT+EfhKaXrSu263O2sEMbUzZdWlb+H2E=;
 b=a2kmVw2XRa0agZudnAhG5qMXv1JhgQXSlX7ckYdr+UBM4KSOSVZ3Z/NKGzwvz/TA6mU6zzOnHVSkBc15DsUrzLfS93p9Es67UelRCcolPY7d4pyIvRUgAxuJIE1+MEN9tY38Jr0o2oucS1K+aQ3J4u6iD1iiVNBFx0S1K/4mQpa/T5LbKnnDo1Zfr4KmtpQ3X9Dt//hZ/7M2pA6DsdvF3G/7ku4vjqQzrdjv8DEiF70geAWvJnkvzE+Tz2PhVCeYemFVNKFTuEwbUbHuNLVEwf1o+Pj8sH54PU8l9fQseuC3DfDbj7UCIr2RqcnqRFtu2MMBOxxo0iyFOejltle0+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cY5SSxJcE/uGT+EfhKaXrSu263O2sEMbUzZdWlb+H2E=;
 b=XSHO6qPl2/0i9oDkaV9QXkzzCKA+CPLcFd0x48g+i9uENICERQNHnjL/i/SNsGezrbsW3EvGuoWxCzc9IPcaFQ31ILLoMkUGW5s+s/KeiNVOFq5i9WwMQj5JXyG1nKxGadR1wmKbRz9t1S0AvgbMn3BB8SYhLRnI1CmECWcxzZk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB4149.eurprd05.prod.outlook.com (2603:10a6:209:50::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Wed, 9 Dec
 2020 16:03:05 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::642a:6259:153:ab88]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::642a:6259:153:ab88%3]) with mapi id 15.20.3632.024; Wed, 9 Dec 2020
 16:03:05 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 3/4] sch_htb: Stats for offloaded HTB
Date:   Wed,  9 Dec 2020 18:02:50 +0200
Message-Id: <20201209160251.19054-4-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201209160251.19054-1-maximmi@mellanox.com>
References: <20201209160251.19054-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [94.188.199.18]
X-ClientProxiedBy: AM0PR04CA0098.eurprd04.prod.outlook.com
 (2603:10a6:208:be::39) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0098.eurprd04.prod.outlook.com (2603:10a6:208:be::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 9 Dec 2020 16:03:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9a1589d3-f2ca-4207-8b7b-08d89c5bea46
X-MS-TrafficTypeDiagnostic: AM6PR05MB4149:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB41498A24184F55D9B12878C7D1CC0@AM6PR05MB4149.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:12;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TOAs5P13GhuwtEPztUrrXYdp/0jZCGgfZfCx9+R3uoKuuj0Svt9dtsmCp0qLKILyl+EVGa/YoId+7QAQ31RkZplGTD5is2XomZ3BjB9/nPVe5j/zlYz3RvmCgprznrP1LdVPmqusGmO8krqydVmhpprfizXvGMrGdSpJhRW0M4r96zxYar4Ou0iy5l7AyCCdufpOtSfUi89uhQ9TaxCMMmmW951MN1PC03l2e94EGtIM554Y9Xi7/I2z1Hzrifkb6tTzg72+hosTVnVzGCsKkaplZQPdSjk2XhrLRGhoeCz7507Yj/9Ivi1WM6JJAdjUYkSz0PQG8wDjfUr8p6DgnrjPvdkTTG7chc5nKEz8Taekou1tUiYxX2V2xxl65wbd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(5660300002)(16526019)(186003)(26005)(86362001)(110136005)(956004)(2616005)(54906003)(52116002)(8936002)(1076003)(6506007)(6512007)(508600001)(66556008)(34490700003)(66946007)(7416002)(2906002)(66476007)(83380400001)(4326008)(6666004)(6486002)(8676002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ym3V0DBS9dsHjq3rZPAeNT74rHX+zxGfbiJWXEnmMikSKTx7j/R+l6L7MZjs?=
 =?us-ascii?Q?sfHE8zvlRy3Vvvt2Qi3BmFoHN1N1GWrmEURDLDr5w2VFhbMdvnZzw89XyhA6?=
 =?us-ascii?Q?zzf+DSVsxLYNAbTHNatgN4Fi8IvipZ8ooQS2dv0J/gsWV7bdxmAs73csMpRj?=
 =?us-ascii?Q?+XCMC0FyT5vpi3vViZsupgzxeERGqXyWH9W5BbP9z+lK8hNcNSQkZcRPJhk3?=
 =?us-ascii?Q?bjhQTguXlvmF3HXwdXNL2zOQqbFVS67nk7bqSIzU8lz7ihtq5SDE8C7haE25?=
 =?us-ascii?Q?NKOQMASYzQIjHVd+o/1KzmSkdejzJwBW8uSV19GE8TKtJsDW9ACs84Dk1ty2?=
 =?us-ascii?Q?vbTOy/cPkgpAdKwNlWHvXjE3sTQjQz9siRVEkYI7gnu3AQQy7gR+Uek5S17E?=
 =?us-ascii?Q?nOEiRICV00gvd73Lm/LlQUPBDav8dt6nAdAEIzVp8B1JInIzkleEjcyEsCjc?=
 =?us-ascii?Q?fUYoSXsd0nK6HKz7Yh9tS9fdoAyNvev/pF3GgLNYpySyXlNv1OVEfKVbgLF/?=
 =?us-ascii?Q?d4zoJnq7DATVjaTAk3b9cigxQgO0ZcxgZfkQImIxN3WdVwmXZ7/W+0PzdqaN?=
 =?us-ascii?Q?JsxxCjefk41+CfdfT7tSZNNivFeakbvv53ynpWGkNhtLjD8k5kr5+9nwPtBP?=
 =?us-ascii?Q?vbqtvMsDLW07HYVk78QItfNABUlPUQnFkY29GlK2zDGbY9WGgiuTA8JAt6KM?=
 =?us-ascii?Q?x0VZRbRw6Qq/0Vxd0kvOONdBrb/e6/IKUuOfsk+aSnZu9i+KK6k/ZCfohTZX?=
 =?us-ascii?Q?cAz8PiwuHNsWscWSVvRIcXTijpsbNqUNgQv5+eQE5pcvAnZL2IsQmK1gprZE?=
 =?us-ascii?Q?hnCO8DZ78gqxAaQmW7QYUqser4opWH8m9LYNK2GzVRjCtAN/Q3n6gPrzS23z?=
 =?us-ascii?Q?vPWBYPw0tf8Q2Rp3vm/CxdjowL1/6WwTUi+EkBpZKRZRGriOoTs+aXL30KF4?=
 =?us-ascii?Q?1WaeN72mMjBpiCahl2KD4Jqnb9HeqF7O6TUXQCkvr3zobzw+AhUz9oAX318J?=
 =?us-ascii?Q?7Ci6?=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2020 16:03:05.6775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1589d3-f2ca-4207-8b7b-08d89c5bea46
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LKD2joWX1MVfraeCE6JLhbznXv+CQ7MBuAmFEsiZmvm5MqiIdBB1QksE8phj67S9z+GP20IWihUjFPV6XsJkDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support for statistics of offloaded HTB. Bytes and
packets counters for leaf and inner nodes are supported, the values are
taken from per-queue qdiscs, and the numbers that the user sees should
have the same behavior as the software (non-offloaded) HTB.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/sched/sch_htb.c | 49 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 7aa56a5e1e94..c2e7efc2af88 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -114,6 +114,7 @@ struct htb_class {
 	 * Written often fields
 	 */
 	struct gnet_stats_basic_packed bstats;
+	struct gnet_stats_basic_packed bstats_bias;
 	struct tc_htb_xstats	xstats;	/* our special stats */
 
 	/* token bucket parameters */
@@ -1213,6 +1214,7 @@ static int htb_dump_class(struct Qdisc *sch, unsigned long arg,
 			  struct sk_buff *skb, struct tcmsg *tcm)
 {
 	struct htb_class *cl = (struct htb_class *)arg;
+	struct htb_sched *q = qdisc_priv(sch);
 	struct nlattr *nest;
 	struct tc_htb_opt opt;
 
@@ -1239,6 +1241,8 @@ static int htb_dump_class(struct Qdisc *sch, unsigned long arg,
 	opt.level = cl->level;
 	if (nla_put(skb, TCA_HTB_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
+	if (q->offload && nla_put_flag(skb, TCA_HTB_OFFLOAD))
+		goto nla_put_failure;
 	if ((cl->rate.rate_bytes_ps >= (1ULL << 32)) &&
 	    nla_put_u64_64bit(skb, TCA_HTB_RATE64, cl->rate.rate_bytes_ps,
 			      TCA_HTB_PAD))
@@ -1255,10 +1259,38 @@ static int htb_dump_class(struct Qdisc *sch, unsigned long arg,
 	return -1;
 }
 
+static void htb_offload_aggregate_stats(struct htb_sched *q, struct htb_class *cl)
+{
+	struct htb_class *c;
+	unsigned int i;
+
+	memset(&cl->bstats, 0, sizeof(cl->bstats));
+
+	for (i = 0; i < q->clhash.hashsize; i++) {
+		hlist_for_each_entry(c, &q->clhash.hash[i], common.hnode) {
+			struct htb_class *p = c;
+
+			while (p && p->level < cl->level)
+				p = p->parent;
+
+			if (p != cl)
+				continue;
+
+			cl->bstats.bytes += c->bstats_bias.bytes;
+			cl->bstats.packets += c->bstats_bias.packets;
+			if (c->level == 0) {
+				cl->bstats.bytes += c->leaf.q->bstats.bytes;
+				cl->bstats.packets += c->leaf.q->bstats.packets;
+			}
+		}
+	}
+}
+
 static int
 htb_dump_class_stats(struct Qdisc *sch, unsigned long arg, struct gnet_dump *d)
 {
 	struct htb_class *cl = (struct htb_class *)arg;
+	struct htb_sched *q = qdisc_priv(sch);
 	struct gnet_stats_queue qs = {
 		.drops = cl->drops,
 		.overlimits = cl->overlimits,
@@ -1273,6 +1305,16 @@ htb_dump_class_stats(struct Qdisc *sch, unsigned long arg, struct gnet_dump *d)
 	cl->xstats.ctokens = clamp_t(s64, PSCHED_NS2TICKS(cl->ctokens),
 				     INT_MIN, INT_MAX);
 
+	if (q->offload) {
+		if (!cl->level) {
+			cl->bstats = cl->leaf.q->bstats;
+			cl->bstats.bytes += cl->bstats_bias.bytes;
+			cl->bstats.packets += cl->bstats_bias.packets;
+		} else {
+			htb_offload_aggregate_stats(q, cl);
+		}
+	}
+
 	if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
 				  d, NULL, &cl->bstats) < 0 ||
 	    gnet_stats_copy_rate_est(d, &cl->rate_est) < 0 ||
@@ -1452,6 +1494,11 @@ static void htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 		WARN_ON(old != q);
 	}
 
+	if (cl->parent) {
+		cl->parent->bstats_bias.bytes += q->bstats.bytes;
+		cl->parent->bstats_bias.packets += q->bstats.packets;
+	}
+
 	offload_opt = (struct tc_htb_qopt_offload) {
 		.command = last_child ? TC_HTB_LEAF_DEL_LAST : TC_HTB_LEAF_DEL,
 		.classid = cl->common.classid,
@@ -1766,6 +1813,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 				htb_graft_helper(dev_queue, old_q);
 				goto err_kill_estimator;
 			}
+			parent->bstats_bias.bytes += old_q->bstats.bytes;
+			parent->bstats_bias.packets += old_q->bstats.packets;
 			qdisc_put(old_q);
 		}
 		new_q = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
-- 
2.20.1

