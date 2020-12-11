Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C121F2D793F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392647AbgLKP2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:28:46 -0500
Received: from mail-am6eur05on2047.outbound.protection.outlook.com ([40.107.22.47]:46078
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730725AbgLKP2Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 10:28:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oR1pGjht281xdfrgJCR6opKSgOuUNA+et3UN2I5N293vwg8ykLRI490HnCaC1MFIp46gi8Q/3FkgRLhghpD0f+V0Ff9MwHMQ4zvip/yjmML6KggsCXy4LpG2nZt/sbqmrdeP+27ln4ASDZdqt0bHLGcolEZv4pgEDENNCtnBvpSc20asgfKpaXTl2n4fhc2MO/wAx2okrmCZdYtwM5jK2Zg3FC8E4MNf3rYcAo2nUeTjISq3Cuypm7tScxjGb+8xUwVqTNoTSQcBx1yfGnsIdBiubwVvZL+YCSo+Xgim2FWnvE1SU5seJwO/d6nmf5/gRrojLM7r45rFS3Gnn9EY5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iwissr9LdJVxkoYfmVA6482G4/+TJ4JqjrPrPwHGJWc=;
 b=UNmb0rH4QXXAtNiE8WhbZDgp0r4AaolYdFvf2mKe/tNgcDdAVXQl70VmG+GXtSDG5ALD9i12EqDE4I5EKycDGjOcZCLv8rkaKMIpXpcNIa3RG906qFdq3cj42RZaSs9fGwAtnxQ6JaOlZAS2pW5MazZarhcrv4MzwE88V2TnRUgaNTC4p0DF41MrTEFTxWQOliAlPGJG40+Uckh9ul4v2LBlUUI4MkWWgoZ1mOTFzQkpzhaLjs4LSapMs7uBoY3ztIdGNJ4sYQo+2eP4Pm3FR14vWKpmOmqtHFFkTzPSYT+zfJz/50Dn2HRUZjzSkWVadKrppi5+9Jpob/zBRS9JMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iwissr9LdJVxkoYfmVA6482G4/+TJ4JqjrPrPwHGJWc=;
 b=sF3R1XhHQe0+fjijyfwDuQP9A1bXH3e64vFDlAbYKRUD4DlxW4BGSMoSgZ1adTlzZYCW38b2xRoHeNOM7V+QIoaI46+FJUsn57Es38KbiR/MHaAkq0/KcLzvrwATokzU4nqZ+NcNA9zJoJsi3upV0yWG0QHSCAa2U40Wm04OKN0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM7PR05MB6725.eurprd05.prod.outlook.com (2603:10a6:20b:136::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Fri, 11 Dec
 2020 15:26:47 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::642a:6259:153:ab88]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::642a:6259:153:ab88%3]) with mapi id 15.20.3632.024; Fri, 11 Dec 2020
 15:26:47 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next v2 3/4] sch_htb: Stats for offloaded HTB
Date:   Fri, 11 Dec 2020 17:26:48 +0200
Message-Id: <20201211152649.12123-4-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201211152649.12123-1-maximmi@mellanox.com>
References: <20201211152649.12123-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [94.188.199.18]
X-ClientProxiedBy: FRYP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::20)
 To AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by FRYP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.9 via Frontend Transport; Fri, 11 Dec 2020 15:26:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a2561a07-5f98-4172-af7f-08d89de92c83
X-MS-TrafficTypeDiagnostic: AM7PR05MB6725:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB672574EAC60618C0BFDA428AD1CA0@AM7PR05MB6725.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:12;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DH6/ZDJr0vB0GzAfXBhXMWf/SpXE813/bEy9Q64zDYfxksSHuNIPoAk7dgfXaVGNWuHxCKBNV/c5KuAKM5/0r/ZXio92UmkfGzVbQ1GoQxPaa4JdhEUiNKi9NnWELJO8ru+R92bqDEgAYGOCQb3MF9Z1bkqGXbRgygVZlGH1BFPOIOo9l+HOUVdffDTzVxJ6e3YrJ4kud5TJKBu4jgV+px5srhs9LtxvIupfbyWojVDG5cKFNj1SN8Ic78PInBSoAsOsBLc2zXfTxOXiaKUzYQfB8WQq6g/UK7zfpAwDF8SvqRF8yew4TOHCe/P6h9Rt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(66946007)(7416002)(186003)(6512007)(5660300002)(16526019)(4326008)(52116002)(2906002)(6506007)(8936002)(66476007)(478600001)(54906003)(316002)(26005)(2616005)(8676002)(83380400001)(36756003)(6486002)(956004)(110136005)(66556008)(86362001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?D7LVzh38JehIMGVNiw1niM6yX+x7iTKO5HO9VXyRM20O6itCsEaZp/6Vmahn?=
 =?us-ascii?Q?RsGMPY5jjfUvp6iy0Lr8rCGKIsvVzdIgr3Wew5z/FKzwqiNJIsRzrj7EW9mW?=
 =?us-ascii?Q?uDoOu2K3uEo4QWU3B6EpGreSIQ+ND7TRbEarp70km4QkzvWXd7u5EDEA/S7q?=
 =?us-ascii?Q?ZjFFwyNpAW7FzRh0/UzulsJOeDTlTwxzso+uR/Hv6xcNmwBFzSwPazZdcMXt?=
 =?us-ascii?Q?zRZyBzq+DtlLG4ZsG+wykGxqm4qWoCpGDahGqlyAbcMnrH+4M5qXLS27Fsjo?=
 =?us-ascii?Q?tQcrxeVdyHvTSQt/0DN9nc7IjNQsW6tCNa16UHocAFuAVnmsiLB23LbvwAap?=
 =?us-ascii?Q?6wWTA299Zbp7rylRKHzRoiuJcMvv/0Re6r9mLyA9KXq4R3OxYADCJa18CDlH?=
 =?us-ascii?Q?QnVW3os3NcjEKkTSYqQdH/XzQkbt47uUjhJpq+6WyNoeV/goylsQ5Taz+uw4?=
 =?us-ascii?Q?8vOkjyFzJtb+LKYNYryYauTuQkDH51fiZ084QVcjC1ozEv0uuZFcFGXX0wTg?=
 =?us-ascii?Q?1zSKCHglSkewwt30GOG9bz5ZMweu1dmfgCiNEORYsM6jOHMY3lhnhxHSAzYG?=
 =?us-ascii?Q?5DrSMr1pGoWTgA4Iyf08Vtp1/s5746+Ep+JY2z7KL2B6YyBsTlHeEix0OJDa?=
 =?us-ascii?Q?2rZm0iz+fH9KmdUbPzArmxc4xOwGKnuHtqs4NO8v8a7qkvR/dr8QPi9Vl0wL?=
 =?us-ascii?Q?aL4f6+GPeYOWMMAE8CZ16Kpfw/ORNBL5I/x+WgYgXH037GRBN4wgpQiM15lp?=
 =?us-ascii?Q?S1B0/lfXaV0j7rtK0BjMBIAk8u3a9YisiURWzCCGP1i1u86zbHWP20XFE86p?=
 =?us-ascii?Q?FJcIFBMLR0OhUogdTjrCzGxxomKLsIgtexr0Xylji+bDOVRHkzpDipp1vgS9?=
 =?us-ascii?Q?g8nqweypDxkWgjGYXB+8nOTr9nWjuHr6UYjT0pxnfSDR4UKsfCBqxb27bYKI?=
 =?us-ascii?Q?QYksfUu4vMwfGMH3+g9vvOlPSId/wm2fq5zimTLvcAdoORSn1HXtcMJAiY8/?=
 =?us-ascii?Q?wVVX?=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 15:26:47.1594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: a2561a07-5f98-4172-af7f-08d89de92c83
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vRlPBgV7aP7MzmPCUDCUMSHYRdCKIH5iGVgeDdO8P7Cu4NovmoEKU8ANEFTPF2hy7dOHNVsmfcfsf1WfTegKhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6725
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
 net/sched/sch_htb.c | 53 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index fccdce591104..8fbcfff625aa 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -114,6 +114,7 @@ struct htb_class {
 	 * Written often fields
 	 */
 	struct gnet_stats_basic_packed bstats;
+	struct gnet_stats_basic_packed bstats_bias;
 	struct tc_htb_xstats	xstats;	/* our special stats */
 
 	/* token bucket parameters */
@@ -1216,6 +1217,7 @@ static int htb_dump_class(struct Qdisc *sch, unsigned long arg,
 			  struct sk_buff *skb, struct tcmsg *tcm)
 {
 	struct htb_class *cl = (struct htb_class *)arg;
+	struct htb_sched *q = qdisc_priv(sch);
 	struct nlattr *nest;
 	struct tc_htb_opt opt;
 
@@ -1242,6 +1244,8 @@ static int htb_dump_class(struct Qdisc *sch, unsigned long arg,
 	opt.level = cl->level;
 	if (nla_put(skb, TCA_HTB_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
+	if (q->offload && nla_put_flag(skb, TCA_HTB_OFFLOAD))
+		goto nla_put_failure;
 	if ((cl->rate.rate_bytes_ps >= (1ULL << 32)) &&
 	    nla_put_u64_64bit(skb, TCA_HTB_RATE64, cl->rate.rate_bytes_ps,
 			      TCA_HTB_PAD))
@@ -1258,10 +1262,39 @@ static int htb_dump_class(struct Qdisc *sch, unsigned long arg,
 	return -1;
 }
 
+static void htb_offload_aggregate_stats(struct htb_sched *q,
+					struct htb_class *cl)
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
@@ -1276,6 +1309,19 @@ htb_dump_class_stats(struct Qdisc *sch, unsigned long arg, struct gnet_dump *d)
 	cl->xstats.ctokens = clamp_t(s64, PSCHED_NS2TICKS(cl->ctokens),
 				     INT_MIN, INT_MAX);
 
+	if (q->offload) {
+		if (!cl->level) {
+			if (cl->leaf.q)
+				cl->bstats = cl->leaf.q->bstats;
+			else
+				memset(&cl->bstats, 0, sizeof(cl->bstats));
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
@@ -1458,6 +1504,11 @@ static void htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
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
@@ -1781,6 +1832,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
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

