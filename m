Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AE22DA8C0
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 08:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgLOHpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 02:45:08 -0500
Received: from mail-eopbgr40069.outbound.protection.outlook.com ([40.107.4.69]:40665
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726512AbgLOHoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 02:44:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0rjfGdDBTz6prqaOxj8gN93szkKOqSN8iG7v/8ncFIJMuvQ4Pr86DmvmEkH5KijsavvUb95Cyu1JkxhNGjcWDi6/2qJPAAmA0NuaENB9HuaYRZr2dC6aEwd5XokLvVDeAJblRkG2NyWRj+DISJtykH1I2XBRo1LIJXY5DS2xxyP8XywxVUzMof0k10ek5DkhzmgHywBpMw8gb6KL4Ym+TCwLHU3SfIZzBfU5XElaVd1YNXdSA6CNvq6rx+vbE3An+foH+USCcnyAD/YZhf9R/QXC1Dyci53Xhem8PHM5KOH/9ntGptZqxJI4bXu9czd5zjd1kuu+lwyzf9gKvMY3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4q0q3of3N3oJhXlES/rGYeuLT7MOEjvFKRRwl+kHlLE=;
 b=B25NrEQ6Oahrn7gA/pAM0O3ELxjM8pij83V85GbQmQkkn59ZmDn0tuYVh+5HElTBvGq9FLSf9QBHQpJOZa0KEQJccjMQftqX8z0B6Uf5MPiQzly5agylFlGvOdoBtxsvctbQ7z+7BYZvhHEE+AjuvJdNJ64vvHRdRqUxOjCsPyxwuv1xN8EmELWQ41kgY2OJewUqqA0FB5r3zDPETvlvUdYhiZw1EAIni7IAIS0lizY7xPjp6Ws1u6VTN/kYqGMGCsfJgZkZIDmwc/hXU0ra5kh5qNs4JLR9VNMj53rvcfuyI3Y+yNTNQ8w91w1jUwgxs8qVO5xkNNwzHS6ujkPtaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4q0q3of3N3oJhXlES/rGYeuLT7MOEjvFKRRwl+kHlLE=;
 b=KA2bb3zRq2FWoLgfTLylysayWbHzeKxSxFfH7mN1Or4aWkYVfMTfLOXbrP6m8X0BMgYp0rrjvAOani9AVOleG7hINxoAu/F+XQRa7NH/slGRYQVH/YwvzY5GPKqZU7K1Ca74z9rc+wQCBhzKMpd+UlPKB7FRi5SqnHQujoGUYww=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5982.eurprd05.prod.outlook.com (2603:10a6:803:e4::28)
 by VI1PR0501MB2335.eurprd05.prod.outlook.com (2603:10a6:800:2e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Tue, 15 Dec
 2020 07:42:07 +0000
Received: from VI1PR05MB5982.eurprd05.prod.outlook.com
 ([fe80::ddc9:9ef:5ece:9fd2]) by VI1PR05MB5982.eurprd05.prod.outlook.com
 ([fe80::ddc9:9ef:5ece:9fd2%5]) with mapi id 15.20.3654.015; Tue, 15 Dec 2020
 07:42:07 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net-next v3 2/4] sch_htb: Hierarchical QoS hardware offload
Date:   Tue, 15 Dec 2020 09:42:11 +0200
Message-Id: <20201215074213.32652-4-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201215074213.32652-1-maximmi@mellanox.com>
References: <20201215074213.32652-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [94.188.199.18]
X-ClientProxiedBy: AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38)
 To VI1PR05MB5982.eurprd05.prod.outlook.com (2603:10a6:803:e4::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 07:42:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 023ee543-4769-4115-f024-08d8a0ccec94
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2335:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0501MB23355ABB18F59C12F3B5E33BD1C60@VI1PR0501MB2335.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/QLWzlYtVbXaQi/buLLal1+8nzydxIoAILXHirbp4o9JGf60LARFcyuyLfQ5uKqMUdWvja0SS+YYB+hMN04u0+1vce94mGHjl71BJ8XgHJ1bDFO2wIW/kE+5zuoJU9CT1CEsyidqk/7eRDxAKZbPwDn+CIEvyoiX3/VRflQgp+Gj7osYArPZ1KEAxG5QOCi/6nZOlwmQz7Is1IGm/a6hspNjqgc3uJ2gEvakfyDhNwMB5SWUiuu2jHu/+WZlEN6vPeJY8lgzLCInO0bG/alcfg18MtUQKytLt9a+Dk5S7slw29MFAI5NGLok/NMdPlFmAjOyvJdKo/t1CLcbO1gxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5982.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(8676002)(52116002)(186003)(6486002)(16526019)(2906002)(66476007)(7416002)(66946007)(110136005)(6506007)(316002)(36756003)(5660300002)(66556008)(8936002)(6666004)(54906003)(83380400001)(26005)(107886003)(30864003)(1076003)(2616005)(86362001)(478600001)(6512007)(4326008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?q9nKJZQcMntaM9RDW9IxkDIyCsabSO9evzVrBoKToBrkp0zWvhDmN/GirN5Z?=
 =?us-ascii?Q?+lwt68QlfSWUYSMRlIW5hBz2W4gLk4CnQwsFGFCFKSk2abJpAOKV4x75LKsC?=
 =?us-ascii?Q?T/QeF/auGT6iRlXlyKk2pkJ+IMgzlsG+PEEeR/5SL5IcxqNhQ4gGWPeYf7sL?=
 =?us-ascii?Q?YQu8jJgL5TFBI3173Df+x0o/GK4v8Vv9BnhSy0t/walM3mJCaprABYh3K8Gi?=
 =?us-ascii?Q?6F3O3GLZousB9r7ip4D+lHJGX55LHZ6AKRaxIpXo8CGrQb+66MkVDglCHP6w?=
 =?us-ascii?Q?8bw3j/s+2rNyBrou1Pc+eoUGqQzG9YnK5Ml/cCVurV5iZp2rZKULafZy8Oc3?=
 =?us-ascii?Q?Km/jnTz1h9brVoqq3wEUAEjgs5c7UNh9eXCqAoKtsEKQJlnUc3hU2+doDCBA?=
 =?us-ascii?Q?L4OvJPeYBhfRVUcENuqQJCKG24tQ5k3RYOHjc8b+nFUKIsCTkp7C/llOoexS?=
 =?us-ascii?Q?VdrtCSKTaDr3Zqrehg23Q/J3Q6PjNMWhYjCVyq78ZjsWY4NqFzyCR09U5Zr8?=
 =?us-ascii?Q?70qaXvT8gzi6A8NTr33y2waRuSoeaEEtOwQTuEXEba15Pl7CZ78dI8u7sX+h?=
 =?us-ascii?Q?zG21N0dqkCanaLqbMMYpDlGsq0KHjGAYO228qUWDtIeBZxunZ/dro8xgyPG+?=
 =?us-ascii?Q?TdFZn+n3G3Ptx8sRsfELDC0pcZ+dLQpbBzE3Hf3tvHVKFUtrx9MpU41dJ2Yy?=
 =?us-ascii?Q?KsAuL1Nx09GQS3tidMJZgzZzK1L58j4gWwME8kZdGTwrcSFOlzsurMG5shc8?=
 =?us-ascii?Q?/0RSz4zdg4z6yZczQErYx1oiNMPBGoHEfxZc7WjJLJlzwTIjUp1R94ywq54o?=
 =?us-ascii?Q?yXADjm3kJDEIQGsNwcW+oHMZkGgW/7o37G8lqxCJ2ljM2bimKFCTSIWC3sIG?=
 =?us-ascii?Q?60d0DhIVlVO0x35sxsjVyLqjy6BOCS61jgsD4PjhGv6TFKXMJ4E08TI74E9w?=
 =?us-ascii?Q?F15Zd2g+bdQnyulL5l2zltoQn2GLoaRzCawm4+LgqxZ84WP8+Qdi9aPrA2c+?=
 =?us-ascii?Q?Jgc6?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5982.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 07:42:07.5111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 023ee543-4769-4115-f024-08d8a0ccec94
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nSBWIE+rt/wMc+fEmRJyNOJDb41wNSOmzeGdOcJpwA3Mi7gwu/3B8kAQKZFS0k88F3M+wyDhnxJWyq80+ElWGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2335
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HTB doesn't scale well because of contention on a single lock, and it
also consumes CPU. This patch adds support for offloading HTB to
hardware that supports hierarchical rate limiting.

This solution addresses two main problems of scaling HTB:

1. Contention by flow classification. Currently the filters are attached
to the HTB instance as follows:

    # tc filter add dev eth0 parent 1:0 protocol ip flower dst_port 80
    classid 1:10

It's possible to move classification to clsact egress hook, which is
thread-safe and lock-free:

    # tc filter add dev eth0 egress protocol ip flower dst_port 80
    action skbedit priority 1:10

This way classification still happens in software, but the lock
contention is eliminated, and it happens before selecting the TX queue,
allowing the driver to translate the class to the corresponding hardware
queue.

Note that this is already compatible with non-offloaded HTB and doesn't
require changes to the kernel nor iproute2.

2. Contention by handling packets. HTB is not multi-queue, it attaches
to a whole net device, and handling of all packets takes the same lock.
When HTB is offloaded, its algorithm is done in hardware. HTB registers
itself as a multi-queue qdisc, similarly to mq: HTB is attached to the
netdev, and each queue has its own qdisc. The control flow is still done
by HTB: it calls the driver via ndo_setup_tc to replicate the hierarchy
of classes in the NIC. Leaf classes are presented by hardware queues.
The data path works as follows: a packet is classified by clsact, the
driver selects a hardware queue according to its class, and the packet
is enqueued into this queue's qdisc.

Some features of HTB may be not supported by some particular hardware,
for example, the maximum number of classes may be limited, the
granularity of rate and ceil parameters may be different, etc. - so, the
offload is not enabled by default, a new parameter is used to enable it:

    # tc qdisc replace dev eth0 root handle 1: htb offload

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/netdevice.h            |   1 +
 include/net/pkt_cls.h                |  33 ++
 include/uapi/linux/pkt_sched.h       |   1 +
 net/sched/sch_htb.c                  | 479 +++++++++++++++++++++++++--
 tools/include/uapi/linux/pkt_sched.h |   1 +
 5 files changed, 487 insertions(+), 28 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7bf167993c05..6830a8d2dbe9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -859,6 +859,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_ETS,
 	TC_SETUP_QDISC_TBF,
 	TC_SETUP_QDISC_FIFO,
+	TC_SETUP_QDISC_HTB,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 0f2a9c44171c..73ec1639365b 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -783,6 +783,39 @@ struct tc_mq_qopt_offload {
 	};
 };
 
+enum tc_htb_command {
+	/* Root */
+	TC_HTB_CREATE, /* Initialize HTB offload. */
+	TC_HTB_DESTROY, /* Destroy HTB offload. */
+
+	/* Classes */
+	/* Allocate qid and create leaf. */
+	TC_HTB_LEAF_ALLOC_QUEUE,
+	/* Convert leaf to inner, preserve and return qid, create new leaf. */
+	TC_HTB_LEAF_TO_INNER,
+	/* Delete leaf, while siblings remain. */
+	TC_HTB_LEAF_DEL,
+	/* Delete leaf, convert parent to leaf, preserving qid. */
+	TC_HTB_LEAF_DEL_LAST,
+	/* Modify parameters of a node. */
+	TC_HTB_NODE_MODIFY,
+
+	/* Class qdisc */
+	TC_HTB_LEAF_QUERY_QUEUE, /* Query qid by classid. */
+};
+
+struct tc_htb_qopt_offload {
+	enum tc_htb_command command;
+	u16 classid;
+	u32 parent_classid;
+	u16 qid;
+	u16 moved_qid;
+	u64 rate;
+	u64 ceil;
+};
+
+#define TC_HTB_CLASSID_ROOT U32_MAX
+
 enum tc_red_command {
 	TC_RED_REPLACE,
 	TC_RED_DESTROY,
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 9e7c2c607845..79a699f106b1 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -434,6 +434,7 @@ enum {
 	TCA_HTB_RATE64,
 	TCA_HTB_CEIL64,
 	TCA_HTB_PAD,
+	TCA_HTB_OFFLOAD,
 	__TCA_HTB_MAX,
 };
 
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index cd70dbcbd72f..fccdce591104 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -174,6 +174,11 @@ struct htb_sched {
 	int			row_mask[TC_HTB_MAXDEPTH];
 
 	struct htb_level	hlevel[TC_HTB_MAXDEPTH];
+
+	struct Qdisc		**direct_qdiscs;
+	unsigned int            num_direct_qdiscs;
+
+	bool			offload;
 };
 
 /* find class in global hash table using given handle */
@@ -957,7 +962,7 @@ static void htb_reset(struct Qdisc *sch)
 			if (cl->level)
 				memset(&cl->inner, 0, sizeof(cl->inner));
 			else {
-				if (cl->leaf.q)
+				if (cl->leaf.q && !q->offload)
 					qdisc_reset(cl->leaf.q);
 			}
 			cl->prio_activity = 0;
@@ -980,6 +985,7 @@ static const struct nla_policy htb_policy[TCA_HTB_MAX + 1] = {
 	[TCA_HTB_DIRECT_QLEN] = { .type = NLA_U32 },
 	[TCA_HTB_RATE64] = { .type = NLA_U64 },
 	[TCA_HTB_CEIL64] = { .type = NLA_U64 },
+	[TCA_HTB_OFFLOAD] = { .type = NLA_FLAG },
 };
 
 static void htb_work_func(struct work_struct *work)
@@ -992,12 +998,27 @@ static void htb_work_func(struct work_struct *work)
 	rcu_read_unlock();
 }
 
+static void htb_set_lockdep_class_child(struct Qdisc *q)
+{
+	static struct lock_class_key child_key;
+
+	lockdep_set_class(qdisc_lock(q), &child_key);
+}
+
+static int htb_offload(struct net_device *dev, struct tc_htb_qopt_offload *opt)
+{
+	return dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_HTB, opt);
+}
+
 static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 		    struct netlink_ext_ack *extack)
 {
+	struct net_device *dev = qdisc_dev(sch);
+	struct tc_htb_qopt_offload offload_opt;
 	struct htb_sched *q = qdisc_priv(sch);
 	struct nlattr *tb[TCA_HTB_MAX + 1];
 	struct tc_htb_glob *gopt;
+	unsigned int ntx;
 	int err;
 
 	qdisc_watchdog_init(&q->watchdog, sch);
@@ -1022,9 +1043,23 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	if (gopt->version != HTB_VER >> 16)
 		return -EINVAL;
 
+	q->offload = nla_get_flag(tb[TCA_HTB_OFFLOAD]);
+
+	if (q->offload) {
+		if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
+			return -EOPNOTSUPP;
+
+		q->num_direct_qdiscs = dev->real_num_tx_queues;
+		q->direct_qdiscs = kcalloc(q->num_direct_qdiscs,
+					   sizeof(*q->direct_qdiscs),
+					   GFP_KERNEL);
+		if (!q->direct_qdiscs)
+			return -ENOMEM;
+	}
+
 	err = qdisc_class_hash_init(&q->clhash);
 	if (err < 0)
-		return err;
+		goto err_free_direct_qdiscs;
 
 	qdisc_skb_head_init(&q->direct_queue);
 
@@ -1037,7 +1072,106 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 		q->rate2quantum = 1;
 	q->defcls = gopt->defcls;
 
+	if (!q->offload)
+		return 0;
+
+	for (ntx = 0; ntx < q->num_direct_qdiscs; ntx++) {
+		struct netdev_queue *dev_queue = netdev_get_tx_queue(dev, ntx);
+		struct Qdisc *qdisc;
+
+		qdisc = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
+					  TC_H_MAKE(sch->handle, 0), extack);
+		if (!qdisc) {
+			err = -ENOMEM;
+			goto err_free_qdiscs;
+		}
+
+		htb_set_lockdep_class_child(qdisc);
+		q->direct_qdiscs[ntx] = qdisc;
+		qdisc->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
+	}
+
+	sch->flags |= TCQ_F_MQROOT;
+
+	offload_opt = (struct tc_htb_qopt_offload) {
+		.command = TC_HTB_CREATE,
+		.parent_classid = TC_H_MAJ(sch->handle) >> 16,
+		.classid = TC_H_MIN(q->defcls),
+	};
+	err = htb_offload(dev, &offload_opt);
+	if (err)
+		goto err_free_qdiscs;
+
 	return 0;
+
+err_free_qdiscs:
+	/* TC_HTB_CREATE call failed, avoid any further calls to the driver. */
+	q->offload = false;
+
+	for (ntx = 0; ntx < q->num_direct_qdiscs && q->direct_qdiscs[ntx];
+	     ntx++)
+		qdisc_put(q->direct_qdiscs[ntx]);
+
+	qdisc_class_hash_destroy(&q->clhash);
+	/* Prevent use-after-free and double-free when htb_destroy gets called.
+	 */
+	q->clhash.hash = NULL;
+	q->clhash.hashsize = 0;
+
+err_free_direct_qdiscs:
+	kfree(q->direct_qdiscs);
+	q->direct_qdiscs = NULL;
+	return err;
+}
+
+static void htb_attach_offload(struct Qdisc *sch)
+{
+	struct net_device *dev = qdisc_dev(sch);
+	struct htb_sched *q = qdisc_priv(sch);
+	unsigned int ntx;
+
+	for (ntx = 0; ntx < q->num_direct_qdiscs; ntx++) {
+		struct Qdisc *old, *qdisc = q->direct_qdiscs[ntx];
+
+		old = dev_graft_qdisc(qdisc->dev_queue, qdisc);
+		qdisc_put(old);
+		qdisc_hash_add(qdisc, false);
+	}
+	for (ntx = q->num_direct_qdiscs; ntx < dev->num_tx_queues; ntx++) {
+		struct netdev_queue *dev_queue = netdev_get_tx_queue(dev, ntx);
+		struct Qdisc *old = dev_graft_qdisc(dev_queue, NULL);
+
+		qdisc_put(old);
+	}
+
+	kfree(q->direct_qdiscs);
+	q->direct_qdiscs = NULL;
+}
+
+static void htb_attach_software(struct Qdisc *sch)
+{
+	struct net_device *dev = qdisc_dev(sch);
+	unsigned int ntx;
+
+	/* Resemble qdisc_graft behavior. */
+	for (ntx = 0; ntx < dev->num_tx_queues; ntx++) {
+		struct netdev_queue *dev_queue = netdev_get_tx_queue(dev, ntx);
+		struct Qdisc *old = dev_graft_qdisc(dev_queue, sch);
+
+		qdisc_refcount_inc(sch);
+
+		qdisc_put(old);
+	}
+}
+
+static void htb_attach(struct Qdisc *sch)
+{
+	struct htb_sched *q = qdisc_priv(sch);
+
+	if (q->offload)
+		htb_attach_offload(sch);
+	else
+		htb_attach_software(sch);
 }
 
 static int htb_dump(struct Qdisc *sch, struct sk_buff *skb)
@@ -1046,6 +1180,11 @@ static int htb_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct nlattr *nest;
 	struct tc_htb_glob gopt;
 
+	if (q->offload)
+		sch->flags |= TCQ_F_OFFLOADED;
+	else
+		sch->flags &= ~TCQ_F_OFFLOADED;
+
 	sch->qstats.overlimits = q->overlimits;
 	/* Its safe to not acquire qdisc lock. As we hold RTNL,
 	 * no change can happen on the qdisc parameters.
@@ -1063,6 +1202,8 @@ static int htb_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (nla_put(skb, TCA_HTB_INIT, sizeof(gopt), &gopt) ||
 	    nla_put_u32(skb, TCA_HTB_DIRECT_QLEN, q->direct_qlen))
 		goto nla_put_failure;
+	if (q->offload && nla_put_flag(skb, TCA_HTB_OFFLOAD))
+		goto nla_put_failure;
 
 	return nla_nest_end(skb, nest);
 
@@ -1144,19 +1285,97 @@ htb_dump_class_stats(struct Qdisc *sch, unsigned long arg, struct gnet_dump *d)
 	return gnet_stats_copy_app(d, &cl->xstats, sizeof(cl->xstats));
 }
 
+static struct netdev_queue *
+htb_select_queue(struct Qdisc *sch, struct tcmsg *tcm)
+{
+	struct net_device *dev = qdisc_dev(sch);
+	struct tc_htb_qopt_offload offload_opt;
+	int err;
+
+	offload_opt = (struct tc_htb_qopt_offload) {
+		.command = TC_HTB_LEAF_QUERY_QUEUE,
+		.classid = TC_H_MIN(tcm->tcm_parent),
+	};
+	err = htb_offload(dev, &offload_opt);
+	if (err || offload_opt.qid >= dev->num_tx_queues)
+		return NULL;
+	return netdev_get_tx_queue(dev, offload_opt.qid);
+}
+
+static struct Qdisc *
+htb_graft_helper(struct netdev_queue *dev_queue, struct Qdisc *new_q)
+{
+	struct net_device *dev = dev_queue->dev;
+	struct Qdisc *old_q;
+
+	if (dev->flags & IFF_UP)
+		dev_deactivate(dev);
+	old_q = dev_graft_qdisc(dev_queue, new_q);
+	if (new_q)
+		new_q->flags |= TCQ_F_ONETXQUEUE | TCQ_F_NOPARENT;
+	if (dev->flags & IFF_UP)
+		dev_activate(dev);
+
+	return old_q;
+}
+
+static void htb_offload_move_qdisc(struct Qdisc *sch, u16 qid_old, u16 qid_new)
+{
+	struct netdev_queue *queue_old, *queue_new;
+	struct net_device *dev = qdisc_dev(sch);
+	struct Qdisc *qdisc;
+
+	queue_old = netdev_get_tx_queue(dev, qid_old);
+	queue_new = netdev_get_tx_queue(dev, qid_new);
+
+	if (dev->flags & IFF_UP)
+		dev_deactivate(dev);
+	qdisc = dev_graft_qdisc(queue_old, NULL);
+	qdisc->dev_queue = queue_new;
+	qdisc = dev_graft_qdisc(queue_new, qdisc);
+	if (dev->flags & IFF_UP)
+		dev_activate(dev);
+
+	WARN_ON(!(qdisc->flags & TCQ_F_BUILTIN));
+}
+
 static int htb_graft(struct Qdisc *sch, unsigned long arg, struct Qdisc *new,
 		     struct Qdisc **old, struct netlink_ext_ack *extack)
 {
+	struct netdev_queue *dev_queue = sch->dev_queue;
 	struct htb_class *cl = (struct htb_class *)arg;
+	struct htb_sched *q = qdisc_priv(sch);
+	struct Qdisc *old_q;
 
 	if (cl->level)
 		return -EINVAL;
-	if (new == NULL &&
-	    (new = qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
-				     cl->common.classid, extack)) == NULL)
-		return -ENOBUFS;
+
+	if (q->offload) {
+		dev_queue = new->dev_queue;
+		WARN_ON(dev_queue != cl->leaf.q->dev_queue);
+	}
+
+	if (!new) {
+		new = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
+					cl->common.classid, extack);
+		if (!new)
+			return -ENOBUFS;
+	}
+
+	if (q->offload) {
+		htb_set_lockdep_class_child(new);
+		/* One ref for cl->leaf.q, the other for dev_queue->qdisc. */
+		qdisc_refcount_inc(new);
+		old_q = htb_graft_helper(dev_queue, new);
+	}
 
 	*old = qdisc_replace(sch, new, &cl->leaf.q);
+
+	if (q->offload) {
+		WARN_ON(old_q != *old);
+		qdisc_put(old_q);
+	}
+
 	return 0;
 }
 
@@ -1184,9 +1403,10 @@ static inline int htb_parent_last_child(struct htb_class *cl)
 	return 1;
 }
 
-static void htb_parent_to_leaf(struct htb_sched *q, struct htb_class *cl,
+static void htb_parent_to_leaf(struct Qdisc *sch, struct htb_class *cl,
 			       struct Qdisc *new_q)
 {
+	struct htb_sched *q = qdisc_priv(sch);
 	struct htb_class *parent = cl->parent;
 
 	WARN_ON(cl->level || !cl->leaf.q || cl->prio_activity);
@@ -1204,6 +1424,61 @@ static void htb_parent_to_leaf(struct htb_sched *q, struct htb_class *cl,
 	parent->cmode = HTB_CAN_SEND;
 }
 
+static void htb_parent_to_leaf_offload(struct Qdisc *sch,
+				       struct netdev_queue *dev_queue,
+				       struct Qdisc *new_q)
+{
+	struct Qdisc *old_q;
+
+	/* One ref for cl->leaf.q, the other for dev_queue->qdisc. */
+	qdisc_refcount_inc(new_q);
+	old_q = htb_graft_helper(dev_queue, new_q);
+	WARN_ON(!(old_q->flags & TCQ_F_BUILTIN));
+}
+
+static void htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
+				      bool last_child, bool destroying)
+{
+	struct tc_htb_qopt_offload offload_opt;
+	struct Qdisc *q = cl->leaf.q;
+	struct Qdisc *old = NULL;
+
+	if (cl->level)
+		return;
+
+	WARN_ON(!q);
+	if (!destroying) {
+		/* On destroy of HTB, two cases are possible:
+		 * 1. q is a normal qdisc, but q->dev_queue has noop qdisc.
+		 * 2. q is a noop qdisc (for nodes that were inner),
+		 *    q->dev_queue is noop_netdev_queue.
+		 */
+		old = htb_graft_helper(q->dev_queue, NULL);
+		WARN_ON(!old);
+		WARN_ON(old != q);
+	}
+
+	offload_opt = (struct tc_htb_qopt_offload) {
+		.command = last_child ? TC_HTB_LEAF_DEL_LAST : TC_HTB_LEAF_DEL,
+		.classid = cl->common.classid,
+	};
+	htb_offload(qdisc_dev(sch), &offload_opt);
+
+	qdisc_put(old);
+
+	if (last_child)
+		return;
+
+	if (offload_opt.moved_qid != 0) {
+		if (destroying)
+			q->dev_queue = netdev_get_tx_queue(qdisc_dev(sch),
+							   offload_opt.qid);
+		else
+			htb_offload_move_qdisc(sch, offload_opt.moved_qid,
+					       offload_opt.qid);
+	}
+}
+
 static void htb_destroy_class(struct Qdisc *sch, struct htb_class *cl)
 {
 	if (!cl->level) {
@@ -1217,8 +1492,11 @@ static void htb_destroy_class(struct Qdisc *sch, struct htb_class *cl)
 
 static void htb_destroy(struct Qdisc *sch)
 {
+	struct net_device *dev = qdisc_dev(sch);
+	struct tc_htb_qopt_offload offload_opt;
 	struct htb_sched *q = qdisc_priv(sch);
 	struct hlist_node *next;
+	bool nonempty, changed;
 	struct htb_class *cl;
 	unsigned int i;
 
@@ -1237,13 +1515,58 @@ static void htb_destroy(struct Qdisc *sch)
 			cl->block = NULL;
 		}
 	}
-	for (i = 0; i < q->clhash.hashsize; i++) {
-		hlist_for_each_entry_safe(cl, next, &q->clhash.hash[i],
-					  common.hnode)
-			htb_destroy_class(sch, cl);
-	}
+
+	do {
+		nonempty = false;
+		changed = false;
+		for (i = 0; i < q->clhash.hashsize; i++) {
+			hlist_for_each_entry_safe(cl, next, &q->clhash.hash[i],
+						  common.hnode) {
+				bool last_child;
+
+				if (!q->offload) {
+					htb_destroy_class(sch, cl);
+					continue;
+				}
+
+				nonempty = true;
+
+				if (cl->level)
+					continue;
+
+				changed = true;
+
+				last_child = htb_parent_last_child(cl);
+				htb_destroy_class_offload(sch, cl, last_child,
+							  true);
+				qdisc_class_hash_remove(&q->clhash,
+							&cl->common);
+				if (cl->parent)
+					cl->parent->children--;
+				if (last_child)
+					htb_parent_to_leaf(sch, cl, NULL);
+				htb_destroy_class(sch, cl);
+			}
+		}
+	} while (changed);
+	WARN_ON(nonempty);
+
 	qdisc_class_hash_destroy(&q->clhash);
 	__qdisc_reset_queue(&q->direct_queue);
+
+	if (!q->offload)
+		return;
+
+	offload_opt = (struct tc_htb_qopt_offload) {
+		.command = TC_HTB_DESTROY,
+	};
+	htb_offload(dev, &offload_opt);
+
+	if (!q->direct_qdiscs)
+		return;
+	for (i = 0; i < q->num_direct_qdiscs && q->direct_qdiscs[i]; i++)
+		qdisc_put(q->direct_qdiscs[i]);
+	kfree(q->direct_qdiscs);
 }
 
 static int htb_delete(struct Qdisc *sch, unsigned long arg)
@@ -1260,11 +1583,24 @@ static int htb_delete(struct Qdisc *sch, unsigned long arg)
 	if (cl->children || cl->filter_cnt)
 		return -EBUSY;
 
-	if (!cl->level && htb_parent_last_child(cl)) {
-		new_q = qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
+	if (!cl->level && htb_parent_last_child(cl))
+		last_child = 1;
+
+	if (q->offload)
+		htb_destroy_class_offload(sch, cl, last_child, false);
+
+	if (last_child) {
+		struct netdev_queue *dev_queue;
+
+		dev_queue = q->offload ? cl->leaf.q->dev_queue : sch->dev_queue;
+		new_q = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
 					  cl->parent->common.classid,
 					  NULL);
-		last_child = 1;
+		if (q->offload) {
+			if (new_q)
+				htb_set_lockdep_class_child(new_q);
+			htb_parent_to_leaf_offload(sch, dev_queue, new_q);
+		}
 	}
 
 	sch_tree_lock(sch);
@@ -1285,7 +1621,7 @@ static int htb_delete(struct Qdisc *sch, unsigned long arg)
 				  &q->hlevel[cl->level].wait_pq);
 
 	if (last_child)
-		htb_parent_to_leaf(q, cl, new_q);
+		htb_parent_to_leaf(sch, cl, new_q);
 
 	sch_tree_unlock(sch);
 
@@ -1300,9 +1636,11 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 	int err = -EINVAL;
 	struct htb_sched *q = qdisc_priv(sch);
 	struct htb_class *cl = (struct htb_class *)*arg, *parent;
+	struct tc_htb_qopt_offload offload_opt;
 	struct nlattr *opt = tca[TCA_OPTIONS];
 	struct nlattr *tb[TCA_HTB_MAX + 1];
 	struct Qdisc *parent_qdisc = NULL;
+	struct netdev_queue *dev_queue;
 	struct tc_htb_opt *hopt;
 	u64 rate64, ceil64;
 	int warn = 0;
@@ -1335,8 +1673,12 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 		qdisc_put_rtab(qdisc_get_rtab(&hopt->ceil, tb[TCA_HTB_CTAB],
 					      NULL));
 
+	rate64 = tb[TCA_HTB_RATE64] ? nla_get_u64(tb[TCA_HTB_RATE64]) : 0;
+	ceil64 = tb[TCA_HTB_CEIL64] ? nla_get_u64(tb[TCA_HTB_CEIL64]) : 0;
+
 	if (!cl) {		/* new class */
-		struct Qdisc *new_q;
+		struct net_device *dev = qdisc_dev(sch);
+		struct Qdisc *new_q, *old_q;
 		int prio;
 		struct {
 			struct nlattr		nla;
@@ -1379,11 +1721,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 						NULL,
 						qdisc_root_sleeping_running(sch),
 						tca[TCA_RATE] ? : &est.nla);
-			if (err) {
-				tcf_block_put(cl->block);
-				kfree(cl);
-				goto failure;
-			}
+			if (err)
+				goto err_block_put;
 		}
 
 		cl->children = 0;
@@ -1392,12 +1731,72 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 		for (prio = 0; prio < TC_HTB_NUMPRIO; prio++)
 			RB_CLEAR_NODE(&cl->node[prio]);
 
+		cl->common.classid = classid;
+
+		/* Make sure nothing interrupts us in between of two
+		 * ndo_setup_tc calls.
+		 */
+		ASSERT_RTNL();
+
 		/* create leaf qdisc early because it uses kmalloc(GFP_KERNEL)
 		 * so that can't be used inside of sch_tree_lock
 		 * -- thanks to Karlis Peisenieks
 		 */
-		new_q = qdisc_create_dflt(sch->dev_queue, &pfifo_qdisc_ops,
+		if (!q->offload) {
+			dev_queue = sch->dev_queue;
+		} else if (!(parent && !parent->level)) {
+			/* Assign a dev_queue to this classid. */
+			offload_opt = (struct tc_htb_qopt_offload) {
+				.command = TC_HTB_LEAF_ALLOC_QUEUE,
+				.classid = cl->common.classid,
+				.parent_classid = parent ?
+					TC_H_MIN(parent->common.classid) :
+					TC_HTB_CLASSID_ROOT,
+				.rate = max_t(u64, hopt->rate.rate, rate64),
+				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
+			};
+			err = htb_offload(dev, &offload_opt);
+			if (err) {
+				pr_err("htb: TC_HTB_LEAF_ALLOC_QUEUE failed with err = %d\n",
+				       err);
+				goto err_kill_estimator;
+			}
+			dev_queue = netdev_get_tx_queue(dev, offload_opt.qid);
+		} else { /* First child. */
+			dev_queue = parent->leaf.q->dev_queue;
+			old_q = htb_graft_helper(dev_queue, NULL);
+			WARN_ON(old_q != parent->leaf.q);
+			offload_opt = (struct tc_htb_qopt_offload) {
+				.command = TC_HTB_LEAF_TO_INNER,
+				.classid = cl->common.classid,
+				.parent_classid =
+					TC_H_MIN(parent->common.classid),
+				.rate = max_t(u64, hopt->rate.rate, rate64),
+				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
+			};
+			err = htb_offload(dev, &offload_opt);
+			if (err) {
+				pr_err("htb: TC_HTB_LEAF_TO_INNER failed with err = %d\n",
+				       err);
+				htb_graft_helper(dev_queue, old_q);
+				goto err_kill_estimator;
+			}
+			qdisc_put(old_q);
+		}
+		new_q = qdisc_create_dflt(dev_queue, &pfifo_qdisc_ops,
 					  classid, NULL);
+		if (q->offload) {
+			if (new_q) {
+				htb_set_lockdep_class_child(new_q);
+				/* One ref for cl->leaf.q, the other for
+				 * dev_queue->qdisc.
+				 */
+				qdisc_refcount_inc(new_q);
+			}
+			old_q = htb_graft_helper(dev_queue, new_q);
+			/* No qdisc_put needed. */
+			WARN_ON(!(old_q->flags & TCQ_F_BUILTIN));
+		}
 		sch_tree_lock(sch);
 		if (parent && !parent->level) {
 			/* turn parent into inner node */
@@ -1415,10 +1814,10 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 					 : TC_HTB_MAXDEPTH) - 1;
 			memset(&parent->inner, 0, sizeof(parent->inner));
 		}
+
 		/* leaf (we) needs elementary qdisc */
 		cl->leaf.q = new_q ? new_q : &noop_qdisc;
 
-		cl->common.classid = classid;
 		cl->parent = parent;
 
 		/* set class to be in HTB_CAN_SEND state */
@@ -1444,12 +1843,29 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			if (err)
 				return err;
 		}
-		sch_tree_lock(sch);
-	}
 
-	rate64 = tb[TCA_HTB_RATE64] ? nla_get_u64(tb[TCA_HTB_RATE64]) : 0;
+		if (q->offload) {
+			struct net_device *dev = qdisc_dev(sch);
 
-	ceil64 = tb[TCA_HTB_CEIL64] ? nla_get_u64(tb[TCA_HTB_CEIL64]) : 0;
+			offload_opt = (struct tc_htb_qopt_offload) {
+				.command = TC_HTB_NODE_MODIFY,
+				.classid = cl->common.classid,
+				.rate = max_t(u64, hopt->rate.rate, rate64),
+				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
+			};
+			err = htb_offload(dev, &offload_opt);
+			if (err)
+				/* Estimator was replaced, and rollback may fail
+				 * as well, so we don't try to recover it, and
+				 * the estimator won't work property with the
+				 * offload anyway, because bstats are updated
+				 * only when the stats are queried.
+				 */
+				return err;
+		}
+
+		sch_tree_lock(sch);
+	}
 
 	psched_ratecfg_precompute(&cl->rate, &hopt->rate, rate64);
 	psched_ratecfg_precompute(&cl->ceil, &hopt->ceil, ceil64);
@@ -1492,6 +1908,11 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 	*arg = (unsigned long)cl;
 	return 0;
 
+err_kill_estimator:
+	gen_kill_estimator(&cl->rate_est);
+err_block_put:
+	tcf_block_put(cl->block);
+	kfree(cl);
 failure:
 	return err;
 }
@@ -1557,6 +1978,7 @@ static void htb_walk(struct Qdisc *sch, struct qdisc_walker *arg)
 }
 
 static const struct Qdisc_class_ops htb_class_ops = {
+	.select_queue	=	htb_select_queue,
 	.graft		=	htb_graft,
 	.leaf		=	htb_leaf,
 	.qlen_notify	=	htb_qlen_notify,
@@ -1579,6 +2001,7 @@ static struct Qdisc_ops htb_qdisc_ops __read_mostly = {
 	.dequeue	=	htb_dequeue,
 	.peek		=	qdisc_peek_dequeued,
 	.init		=	htb_init,
+	.attach		=	htb_attach,
 	.reset		=	htb_reset,
 	.destroy	=	htb_destroy,
 	.dump		=	htb_dump,
diff --git a/tools/include/uapi/linux/pkt_sched.h b/tools/include/uapi/linux/pkt_sched.h
index 0d18b1d1fbbc..5c903abc9fa5 100644
--- a/tools/include/uapi/linux/pkt_sched.h
+++ b/tools/include/uapi/linux/pkt_sched.h
@@ -414,6 +414,7 @@ enum {
 	TCA_HTB_RATE64,
 	TCA_HTB_CEIL64,
 	TCA_HTB_PAD,
+	TCA_HTB_OFFLOAD,
 	__TCA_HTB_MAX,
 };
 
-- 
2.20.1

