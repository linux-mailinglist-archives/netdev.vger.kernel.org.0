Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B653E5ED980
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbiI1JxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbiI1Jww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:52:52 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70088.outbound.protection.outlook.com [40.107.7.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAF1A9C34;
        Wed, 28 Sep 2022 02:52:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Co4yDtg+Q/UipV/E9cEtoQ1DARYeTPli1njAiOrXS94E593fDEnDFFV75ztoK+wbtK+qnv7EeyqzIpsy88twxoYLvgxatkKly3aisDe8oPjn+9Y1t408IC7/pVYRtl3Nm/1MpfMtlTgd+oA+KZtRG+L8TQIhrtYBi8rbPpoGNmzN6hIBBD3f94O3/zbHSvfI5NN4tXsfkm4b1o5VG0FWKNLGRApJc4BOZQePP1o5tCV28T4gt9TGpgBeteDTeLZmcb3mt9lFxRtbjX+DhGODVCcBDv7BhXjluKj3JINDtisYfag7qDfo3BuiGib0PnIwoZ5vNdRXoGTQQHcp8gSOkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEoDOH+vOOUDRMtYSVa0AR2Ke7DDI+qIDmHY0H1Mwug=;
 b=X1rJ/aJ4nDGbLq3dw4x9OyKVxlTfPU+Khgw4DN2zRKFzKXPXrRTEwpqjAbNf7RM5gYQ6sTbK1phU1YT6yhOZg2EAKHkmX4/V1pEo2Uiuhsojv77yad+RvsKF5FJNrKO8YikFGHGqEqgzTEp6qPi09AU8350yBxaWIQBPe0zZILkwyw7KJ8DaAUa4XULdueSu81gZoXNuFR0ViWGyCJykERFP89Rm+a+KYCcRUSWObVKU4esnFNM/MIjIPHaDY6hdjILQaxQRSVUXqu4gGybSrhAdd/Tt0rRwAzi6UjoxIPua+hn5EQQsdSDmRkgumXmsSRAOywyAslplJ2DbHe8JvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEoDOH+vOOUDRMtYSVa0AR2Ke7DDI+qIDmHY0H1Mwug=;
 b=FZKUmesKzKvGt7JC+GGMyz1z+ygBBfDGbbzf0JwXZW4WYUOSWRfRfpgtb89Atl1IMcXeWbhpjd8z/XewULA40mAucecfsM5BHTt2pUWSu9i7cRCUgni1odgwob7hsFOpn7ujg4B07i0hQ67SPrEYODrQiaFWUQZ/rArAUpS/ORs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7752.eurprd04.prod.outlook.com (2603:10a6:20b:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Wed, 28 Sep
 2022 09:52:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Wed, 28 Sep 2022
 09:52:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 2/8] net/sched: taprio: allow user input of per-tc max SDU
Date:   Wed, 28 Sep 2022 12:51:58 +0300
Message-Id: <20220928095204.2093716-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
References: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0006.eurprd05.prod.outlook.com
 (2603:10a6:800:92::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7752:EE_
X-MS-Office365-Filtering-Correlation-Id: fac97b3e-bb07-4729-66bb-08daa1372353
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hcF3H77FtZpzBLLLMr3ahJaq6Wb3ZuBAH5AgwZA8ZGa6iz6C6Se7hSfqVLLnOVHiwDiaPqF8qRN1xZKh3kUJH/MGfcQVMQbKIeCcM/cM6A9DxRGR7n4v0ajqCxzu4jSNdgf08hqwYdDpqIRQcOme+WZ6rcjnWWruVFiRz0jZNYIkNPbYQgphD9WDd8K+/5AOEXdDDP+0gybze37g8tyUPlGr6ACYXZAOtNivI7/fuzESvQ7SoQGxMOOJdwA399ov5Dv/wFpTeuyDdINLIBIEy13tntwywmez7pllxMyUpr+Y0qAgb/Ul7uGyhjWBNF71kssNkPQM9ZWsrQzQoOZD+BlDkqWAq2gccMLVMONXtZUxfr9FWHGxvmtHSSIAfMoEaZyPJs+Hb5uVKKTYzQK9QdguON1BfDq6PWRZL6+YzpReKyphqizVg6xmL34VHQYs7Y4IKNj1Ps40zB6/BblhPOTzuGMbqYXJ53ZEIkEQDRxs48QWEY2vgancAHLDPUQD3qc9A4MH/eJyIwOPz5NgpRj5mVfRkCvhN8ca1HX7HpM/boxKuvh26TL+rHJSVcUKOOpRMSuECOJLK4HqLenCMu6uzXrChVWaTKkKebrEYvyeoVMKOA1DYLSNeA28LgYd37umO+Ix/AFzc08n/mQHsDjypoOKRTRr/jlmeLLpZ/cOWVVdSuJ+PIoDhNPcOQKIgUxpg5xWM/k0Rp4JXuO5EshoKBQ7eSrRxV9GPPx8lx4HIlIgQyUCymO+m5zP1wBhMdxLzYBJYJO7W2Cs5rXodw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199015)(38350700002)(38100700002)(5660300002)(6506007)(52116002)(6666004)(6512007)(8936002)(7416002)(2906002)(41300700001)(44832011)(36756003)(6486002)(478600001)(86362001)(54906003)(6916009)(26005)(4326008)(83380400001)(1076003)(186003)(8676002)(66476007)(66946007)(66556008)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LuTW6l9jRfq2lh4mPEXt1XcHABbSEST0/pP+WKki9vr0vJWeEnhkqHp08UiK?=
 =?us-ascii?Q?O8pn13IZIo9vOIEe41fnz7VV8boBxJbG9OPEDN5e/SiLV3Hv3mGWGzAt6hIh?=
 =?us-ascii?Q?GC+EphXFZdvCOgrS0xVJHxZ1CyMdM8dWj2rjEfgpO7UPoPLhNyEEX5BqlS+z?=
 =?us-ascii?Q?G80JtYiB/ZjK9jheFw9wOvN+9rD7ofXnBcM8ZZXViLB0Ynzi23j5NQscMeb0?=
 =?us-ascii?Q?LxwA/c2heZCPCU/BoPvX7ZJAhC7icdQSEhDR9Twq7cyA7MXRjXK73PDqZjnT?=
 =?us-ascii?Q?6cpXvOIjW016hYhX4ZQGg82XV/eRGG4MsiNPbjtqQCIcDJVlmYPOeqzvtqBZ?=
 =?us-ascii?Q?rbXYU8ErguIfiqS5nSVeqG64OjmNbX8u6wvE8Y2rLKRe0n8P1uujI5p+ZIZ+?=
 =?us-ascii?Q?CNx3lKO5A5iMS+Dk5YvgQXt80GL/oBkvS+9vF/2vzdap4QzIrdwN6ALfwWh/?=
 =?us-ascii?Q?cV9Poa4i9WtlGUNGHO3ZpucM4DpsJrgZRExuz0KWy7WCafOX8PfEGF09WqvJ?=
 =?us-ascii?Q?AEeDkVvZfGLf75UAzvu6Q2Fw6Blo2IsQDTtRYfSBT96eNEaB4B97dyRTJd1A?=
 =?us-ascii?Q?peqShP8mkGrcYRRLiSDt/n6DIqhzCPLc4p7RGsFO/6zThM7YPLZnKq6uOdHL?=
 =?us-ascii?Q?UeVAErCsJt+GcbFbr/wmuvs4V4Tij+Z8WLvXZXfVm2CtHigWBojg2Udk9ErT?=
 =?us-ascii?Q?KkpfSna/MXccKaM20BFL9l746H+Dw7WOqeFUgVNzEhiPn7DOJzf4KVhDbyiz?=
 =?us-ascii?Q?tpwBFysiFhwBCaheZx2pTfUx20qLdyNnEEIRmVHvx0MNC3igzRZMzSIFiQ8C?=
 =?us-ascii?Q?p8x0ddVvym75A1EHr2T198RIXifRUqLnJ/Vbb5VXhrNhQmIy3yMnS2jyN8Cj?=
 =?us-ascii?Q?AUWChX8ObEifLCvwRhdHPNjhyW6OyTAqelOQn3tt5+TvSReY2VfpwFygRnxv?=
 =?us-ascii?Q?7EXkOZyF+ikzZoJYWqIoo3ZR+Buwb2RRFQwuXCbyg59Ynz9Vhs08xHodchfA?=
 =?us-ascii?Q?8ZwOgap7aDrPMzMpwp/d9BpejMtCkT4NWOoitkjdRDxcGjNF/9TMkVqBnaBH?=
 =?us-ascii?Q?/JwvsgedFMjv9rBTp/v1ljTyQ4DbZbwOqxi4ktP8Cr4PRRyoW+kKXV7IzkZF?=
 =?us-ascii?Q?hrdDe+U5SuHoClNg9AENb5eDoF5FCFAAJdysSPJCoR+Kf9k1+Bx9LQt4qvJH?=
 =?us-ascii?Q?JayhM7junAOYzD5biQphQx3G8zrW8f1U5rqJ623wLQe10aKXsHz7AH7rdaRI?=
 =?us-ascii?Q?nS8rMdXbdvILwsd99Yvet+nMzUDAMeYYh2+U7lkeb/gCJd4w5Wtqh5j6NT0I?=
 =?us-ascii?Q?5lkT1EK/FlhuqFFZpn8p9ziOQc1E3ew5IlDCwSq21i0/Yy/OZZsNahgB429o?=
 =?us-ascii?Q?cCCr7TW349kM37QoERPjTMh3A0sLvB+FR29cP4QyXO7Y3yW1LsmnqrNtryhv?=
 =?us-ascii?Q?gfGGCDSrAqSdJ/jiyeh2HPoQqyAUjo4gJiOgz5C0VuQl2icOG0TdERRGz3ja?=
 =?us-ascii?Q?/8IwrlhDLz8PV3SxjJS+peMw9tPV8ishAmjxbIfbRw8NfYAoYf12/fPTURDZ?=
 =?us-ascii?Q?7Oq1sR2S2Giuh3p6ld9eCVImRALVIU/kHnHwbHooYMKjTFW/XZjHD1IbZxiE?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fac97b3e-bb07-4729-66bb-08daa1372353
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 09:52:21.6631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hP52wCMH+qUt5aLR8Gv2BJwdFGU+vdFfm5XUgL/DncyNrTuuymCEmUYuOKgkWo4MX1S8pINxOOGWQvYoKeokAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7752
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 802.1Q clause 12.29.1.1 "The queueMaxSDUTable structure and data
types" and 8.6.8.4 "Enhancements for scheduled traffic" talk about the
existence of a per traffic class limitation of maximum frame sizes, with
a fallback on the port-based MTU.

As far as I am able to understand, the 802.1Q Service Data Unit (SDU)
represents the MAC Service Data Unit (MSDU, i.e. L2 payload), excluding
any number of prepended VLAN headers which may be otherwise present in
the MSDU. Therefore, the queueMaxSDU is directly comparable to the
device MTU (1500 means L2 payload sizes are accepted, or frame sizes of
1518 octets, or 1522 plus one VLAN header). Drivers which offload this
are directly responsible of translating into other units of measurement.

To keep the fast path checks optimized, we keep 2 arrays in the qdisc,
one for max_sdu translated into frame length (so that it's comparable to
skb->len), and another for offloading and for dumping back to the user.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- precompute the max_frm_len using dev->hard_header_len, so that the
  fast path can directly check against skb->len
v2->v3:
- use qdisc_offload_query_caps(). This also gives an extack message to
  the user on lack of support for queueMaxSDU, which was not available
  before.
v3->v4:
- none

 include/net/pkt_sched.h        |   5 ++
 include/uapi/linux/pkt_sched.h |  11 +++
 net/sched/sch_taprio.c         | 152 ++++++++++++++++++++++++++++++++-
 3 files changed, 167 insertions(+), 1 deletion(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 34600292fdfb..38207873eda6 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -160,6 +160,10 @@ struct tc_etf_qopt_offload {
 	s32 queue;
 };
 
+struct tc_taprio_caps {
+	bool supports_queue_max_sdu:1;
+};
+
 struct tc_taprio_sched_entry {
 	u8 command; /* TC_TAPRIO_CMD_* */
 
@@ -173,6 +177,7 @@ struct tc_taprio_qopt_offload {
 	ktime_t base_time;
 	u64 cycle_time;
 	u64 cycle_time_extension;
+	u32 max_sdu[TC_MAX_QUEUE];
 
 	size_t num_entries;
 	struct tc_taprio_sched_entry entries[];
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index f292b467b27f..000eec106856 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1232,6 +1232,16 @@ enum {
 #define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST	_BITUL(0)
 #define TCA_TAPRIO_ATTR_FLAG_FULL_OFFLOAD	_BITUL(1)
 
+enum {
+	TCA_TAPRIO_TC_ENTRY_UNSPEC,
+	TCA_TAPRIO_TC_ENTRY_INDEX,		/* u32 */
+	TCA_TAPRIO_TC_ENTRY_MAX_SDU,		/* u32 */
+
+	/* add new constants above here */
+	__TCA_TAPRIO_TC_ENTRY_CNT,
+	TCA_TAPRIO_TC_ENTRY_MAX = (__TCA_TAPRIO_TC_ENTRY_CNT - 1)
+};
+
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,
 	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
@@ -1245,6 +1255,7 @@ enum {
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
 	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
 	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* u32 */
+	TCA_TAPRIO_ATTR_TC_ENTRY, /* nest */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 0bc6d90e1e51..435d866fcfa0 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -78,6 +78,8 @@ struct taprio_sched {
 	struct sched_gate_list __rcu *admin_sched;
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
+	u32 max_frm_len[TC_MAX_QUEUE]; /* for the fast path */
+	u32 max_sdu[TC_MAX_QUEUE]; /* for dump and offloading */
 	u32 txtime_delay;
 };
 
@@ -415,6 +417,9 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 			      struct Qdisc *child, struct sk_buff **to_free)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	int prio = skb->priority;
+	u8 tc;
 
 	/* sk_flags are only safe to use on full sockets. */
 	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
@@ -426,6 +431,11 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 			return qdisc_drop(skb, sch, to_free);
 	}
 
+	/* Devices with full offload are expected to honor this in hardware */
+	tc = netdev_get_prio_tc_map(dev, prio);
+	if (skb->len > q->max_frm_len[tc])
+		return qdisc_drop(skb, sch, to_free);
+
 	qdisc_qstats_backlog_inc(sch, skb);
 	sch->q.qlen++;
 
@@ -754,6 +764,11 @@ static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
 	[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]  = { .type = NLA_U32 },
 };
 
+static const struct nla_policy taprio_tc_policy[TCA_TAPRIO_TC_ENTRY_MAX + 1] = {
+	[TCA_TAPRIO_TC_ENTRY_INDEX]	   = { .type = NLA_U32 },
+	[TCA_TAPRIO_TC_ENTRY_MAX_SDU]	   = { .type = NLA_U32 },
+};
+
 static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_PRIOMAP]	       = {
 		.len = sizeof(struct tc_mqprio_qopt)
@@ -766,6 +781,7 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION] = { .type = NLA_S64 },
 	[TCA_TAPRIO_ATTR_FLAGS]                      = { .type = NLA_U32 },
 	[TCA_TAPRIO_ATTR_TXTIME_DELAY]		     = { .type = NLA_U32 },
+	[TCA_TAPRIO_ATTR_TC_ENTRY]		     = { .type = NLA_NESTED },
 };
 
 static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
@@ -1216,7 +1232,8 @@ static int taprio_enable_offload(struct net_device *dev,
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	struct tc_taprio_qopt_offload *offload;
-	int err = 0;
+	struct tc_taprio_caps caps;
+	int tc, err = 0;
 
 	if (!ops->ndo_setup_tc) {
 		NL_SET_ERR_MSG(extack,
@@ -1224,6 +1241,19 @@ static int taprio_enable_offload(struct net_device *dev,
 		return -EOPNOTSUPP;
 	}
 
+	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_TAPRIO,
+				 &caps, sizeof(caps));
+
+	if (!caps.supports_queue_max_sdu) {
+		for (tc = 0; tc < TC_MAX_QUEUE; tc++) {
+			if (q->max_sdu[tc]) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Device does not handle queueMaxSDU");
+				return -EOPNOTSUPP;
+			}
+		}
+	}
+
 	offload = taprio_offload_alloc(sched->num_entries);
 	if (!offload) {
 		NL_SET_ERR_MSG(extack,
@@ -1233,6 +1263,9 @@ static int taprio_enable_offload(struct net_device *dev,
 	offload->enable = 1;
 	taprio_sched_to_offload(dev, sched, offload);
 
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		offload->max_sdu[tc] = q->max_sdu[tc];
+
 	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack,
@@ -1367,6 +1400,89 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
 	return err;
 }
 
+static int taprio_parse_tc_entry(struct Qdisc *sch,
+				 struct nlattr *opt,
+				 u32 max_sdu[TC_QOPT_MAX_QUEUE],
+				 unsigned long *seen_tcs,
+				 struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_TAPRIO_TC_ENTRY_MAX + 1] = { };
+	struct net_device *dev = qdisc_dev(sch);
+	u32 val = 0;
+	int err, tc;
+
+	err = nla_parse_nested(tb, TCA_TAPRIO_TC_ENTRY_MAX, opt,
+			       taprio_tc_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_TAPRIO_TC_ENTRY_INDEX]) {
+		NL_SET_ERR_MSG_MOD(extack, "TC entry index missing");
+		return -EINVAL;
+	}
+
+	tc = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_INDEX]);
+	if (tc >= TC_QOPT_MAX_QUEUE) {
+		NL_SET_ERR_MSG_MOD(extack, "TC entry index out of range");
+		return -ERANGE;
+	}
+
+	if (*seen_tcs & BIT(tc)) {
+		NL_SET_ERR_MSG_MOD(extack, "Duplicate TC entry");
+		return -EINVAL;
+	}
+
+	*seen_tcs |= BIT(tc);
+
+	if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU])
+		val = nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]);
+
+	if (val > dev->max_mtu) {
+		NL_SET_ERR_MSG_MOD(extack, "TC max SDU exceeds device max MTU");
+		return -ERANGE;
+	}
+
+	max_sdu[tc] = val;
+
+	return 0;
+}
+
+static int taprio_parse_tc_entries(struct Qdisc *sch,
+				   struct nlattr *opt,
+				   struct netlink_ext_ack *extack)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	u32 max_sdu[TC_QOPT_MAX_QUEUE];
+	unsigned long seen_tcs = 0;
+	struct nlattr *n;
+	int tc, rem;
+	int err = 0;
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		max_sdu[tc] = q->max_sdu[tc];
+
+	nla_for_each_nested(n, opt, rem) {
+		if (nla_type(n) != TCA_TAPRIO_ATTR_TC_ENTRY)
+			continue;
+
+		err = taprio_parse_tc_entry(sch, n, max_sdu, &seen_tcs, extack);
+		if (err)
+			goto out;
+	}
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
+		q->max_sdu[tc] = max_sdu[tc];
+		if (max_sdu[tc])
+			q->max_frm_len[tc] = max_sdu[tc] + dev->hard_header_len;
+		else
+			q->max_frm_len[tc] = U32_MAX; /* never oversized */
+	}
+
+out:
+	return err;
+}
+
 static int taprio_mqprio_cmp(const struct net_device *dev,
 			     const struct tc_mqprio_qopt *mqprio)
 {
@@ -1445,6 +1561,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		return err;
 
+	err = taprio_parse_tc_entries(sch, opt, extack);
+	if (err)
+		return err;
+
 	new_admin = kzalloc(sizeof(*new_admin), GFP_KERNEL);
 	if (!new_admin) {
 		NL_SET_ERR_MSG(extack, "Not enough memory for a new schedule");
@@ -1825,6 +1945,33 @@ static int dump_schedule(struct sk_buff *msg,
 	return -1;
 }
 
+static int taprio_dump_tc_entries(struct taprio_sched *q, struct sk_buff *skb)
+{
+	struct nlattr *n;
+	int tc;
+
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++) {
+		n = nla_nest_start(skb, TCA_TAPRIO_ATTR_TC_ENTRY);
+		if (!n)
+			return -EMSGSIZE;
+
+		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_INDEX, tc))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_MAX_SDU,
+				q->max_sdu[tc]))
+			goto nla_put_failure;
+
+		nla_nest_end(skb, n);
+	}
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, n);
+	return -EMSGSIZE;
+}
+
 static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -1863,6 +2010,9 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
 		goto options_error;
 
+	if (taprio_dump_tc_entries(q, skb))
+		goto options_error;
+
 	if (oper && dump_schedule(skb, oper))
 		goto options_error;
 
-- 
2.34.1

