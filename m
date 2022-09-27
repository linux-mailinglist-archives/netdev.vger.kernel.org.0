Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C93E5ED132
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 01:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiI0XsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 19:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiI0XsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 19:48:05 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B051B2D1B;
        Tue, 27 Sep 2022 16:48:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nC42S6doZkL84lRYt0xNgGVUoCA/aDcAq/1oFGOGCviCjlS7EmPmMAG7e1s07ROs7bTpG951umCcHnsKGshkj43dTJgEL9WduDnb6KqIYg6/gBtlUB8zLxPDQ51SXNWTODGT9U7d6gFsUamgvQjPoBo0Ir5XF48EqrfDhEANRe0CD+/C2j0KNhzjixIJ28ZZR4MQcXcfRQS5HjZUW3tp8y9QMw5fGssMP3vodQOzprAdaZnzwmFVIuK23GXH2m/0Zrwn+C6JkxQeLXXfE5QlsAaHuzc0a961UY7atlk1ZE4W4BiO6BCZJeHUqlUQhWdpS7gUWMO/xhjfdYdBIacAdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ZTbCbtrXUjwvvDefLKyJMI3M8s4YhJ3F33nF8oLNZg=;
 b=gTAKLHN5xnyteHkLWg/TFtjyCx3jCJb80WS20vPYK9QLOSLpEttvFlezNgNaFxEQHNzUci2HYJcByFs4cGnzih7TR/4z+kc2KbgfbAIBNF5D6t8SrgXy2SFQZJBXx9Vw7VefV+os18iuxB0nuJ11NwPHa1BQeHvQ4YqSOxZzRg9h2/uHW9bjddDu5kejV6uU5JN6Uj5AnQpOvY5+TEThZ/tFvUv9SXD1Zqx5XdvEzpiAyYbJR9oVymlARb1qQC6VlBE2VblI84L+fa1xI94FgpGLfJe747T1rrcUjCyd7OIrsyw3EitUUTuhLb8mOtIACO5UkBchVHqkzcEtuM0FHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ZTbCbtrXUjwvvDefLKyJMI3M8s4YhJ3F33nF8oLNZg=;
 b=JVhErDlDXdhzGDkNILMA7r+EmwVMEt6XDFY873Mh++nr9+E030g1EAHoiL9P5xQFCiuOte14CLQNsLpLdqFvbO4gVdsYUQyH/9kDS6vAqhcafT4RzfVJCQKcsC+pAZhpUW7ANCOZyGkihORreihkYed3uI+styyK2nAmfZ6BF34=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9444.eurprd04.prod.outlook.com (2603:10a6:10:35c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Tue, 27 Sep
 2022 23:48:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 23:48:01 +0000
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
Subject: [PATCH v3 net-next 1/8] net/sched: query offload capabilities through ndo_setup_tc()
Date:   Wed, 28 Sep 2022 02:47:39 +0300
Message-Id: <20220927234746.1823648-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
References: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0025.eurprd05.prod.outlook.com
 (2603:10a6:800:60::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU0PR04MB9444:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e415989-f57a-4cb0-cb7b-08daa0e2b658
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m9ZA3P+7UFjKUrH4sApRVcdIVhK/R9JHdAEUBpcZfNccOrzdz0XuKsb4dL/OZKvYSwxRhhJ+ba1CUAGE624OWEOaUbOl0dMd56SHK+GnqZu3HKBBd/1EGPmO1TQFLO1p7dgSryRtXds8N7BNXmkofDzSwmiGcA+f+omsRRuOb6a4pwj4vKqkpR2LRoLhxTmQSTVmLMs/Zk2ZTts4ppijsMYPVsANTDCAOymEwBXRR1P81nT9qlZQd+kz7ZY9lJe9xRvzC9+uw6i4/i6M+5wC1AZSl0xKe3Z//F4dxbWag2IVtk+zpVxJAYbiLdApy/sPdB8tEbjiHuTMkRK7U41v5TQo9vIOEouk9IAk5L2a/XsOOVTRBkPvh1BbjZSP3fBFrP4ooibBO7b8ZEnFmDlwu3Lil246aIFgfOzGPsJQBUnKvsZE0Kdpu9SEBdr7E1Qp2qWaPTGxN/OYj93Ou3Q7iWePUQjlx+C5/4M7G8YD3zEMzlq6ylA2HogRT8y3WzM+6rxcGGRZtZMrntvK0UNl+Ppi5kUFA4SjftR9ZewikuqN70AFlFCfmTw4DEePCBEG7DUqjMAFGi00+9zbGAPRzJt1qnIljEbTZvgJVUqW4QTpY2sSzt8221BYvLw0dlyppX972ci1LQmMsS4yR0AOslrCwRD4ulb6T2L7XWzo8NrY0l8uh2suEs/RExTJehTADkZvGMXuFONcvc5f04TpoTiMCJ3HQF5zG1EhdQzH3iHEjs1FGYaDbh1GnWb06C3ObHbrups+UIPXC4+ImOtQ0WbdQAddHZ1Qms2/5LNQJAY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199015)(7416002)(6512007)(966005)(41300700001)(6666004)(36756003)(6486002)(38350700002)(6506007)(6916009)(8676002)(86362001)(66476007)(4326008)(26005)(52116002)(8936002)(66946007)(83380400001)(38100700002)(316002)(54906003)(186003)(1076003)(2906002)(5660300002)(66556008)(478600001)(44832011)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oeiSJXhyWQRUWnxI64SPGxNW1R+7a3PIP0Rk7UBtx0+nNLl0cvd6jLM1SfQn?=
 =?us-ascii?Q?uYIDKcnGA/hqXyCrAZ1sWq3Q1RHg497zdbEfuIOUm28jrtTETNBllKZ56yef?=
 =?us-ascii?Q?5+NZV72QBBCViH4Q9JITAoSXW1cdVRmy4LAYFIW3G+WD/Kb62HhA1LRFUd6d?=
 =?us-ascii?Q?2gA4W3FwIuke0zD3axA3KxTN+DRUmXuz+w/H8A+lGF3vBIbmtUZxMeneewME?=
 =?us-ascii?Q?cwlWr6ceBzwUZur7uHdJFUS3S9VjpXl4CP64EFm7bkATlH8n5eWsjg3eB2aj?=
 =?us-ascii?Q?haYn+g1SuypLqFf4CIc3T9GQwZ//EY1QoLhlT958F3Vgq2X47WYv3JQz8K2f?=
 =?us-ascii?Q?ury+sEuWSyPRdZieEaIfclQ4HVtDXU4i6aRJN+wCz3pCgeDFVQvsMFtYRjx6?=
 =?us-ascii?Q?y9zHwpSsJpDhIROd82Ld1/Z94K4VT8B3Aubx+vBE9iu50rX0VZvyo371nvhm?=
 =?us-ascii?Q?YJfrbpBwJJolcHnUcPqyTBGra3AcrMfMCjARzLsDPUAwsm+48qMMBTy27wiM?=
 =?us-ascii?Q?qZRK3fL+aYOOZHkoC+o1JIUA9GTeSJJWHn+MYOcufK0slyv3192DPnvdj25j?=
 =?us-ascii?Q?UHTAm0fdyPTq2wX3KeeBzxW+wX5kHo5fhet63haBqdqDeaxb/YDrRwI38bUe?=
 =?us-ascii?Q?2XCuDMA4ti3mhMxc76Ng6t3Ke5SRAw0i+xKh5iMwiewm4BGnQFJjMPJlkU4x?=
 =?us-ascii?Q?Hq3oqJgv2H/CseIVurazccAJvfkT8nbTdALBbqItiX8JECt77xYPFIO3TCBV?=
 =?us-ascii?Q?Ei1xg8EQh7aoX1vOUNp7wbikFl2ZjZxQ4gg5kHmHmnMpsrilabp52mdoEw2a?=
 =?us-ascii?Q?0NZlDnqR5LzwrFkPsR0xytFw1CvM6Tli4fAHh0IC7ipyPVS7qTRQhoIlQehD?=
 =?us-ascii?Q?EDkeApPFLOTN7S5+MwYX9djZkJPF+LvL3CgzJ75S2hu9LTt1hKd4JZdAHU0g?=
 =?us-ascii?Q?CSkxHSzh4qbGB7MD1mtL61uD8VbwFlVvG5aPM/YdHc2Fm4qLkNDGhb4FZ37B?=
 =?us-ascii?Q?ZybqhEve5uu+tPcn7DQsOuq0XebgnVw6Fr2GT1JbP7QSG6kQ5U0eWJV49wgK?=
 =?us-ascii?Q?iWbJRgb1zphtKn7jqJIdkteYm2gx8AWzRf1qZJIo+uujmupEUWPT+oTDUX9O?=
 =?us-ascii?Q?JCi76jiribHTI0MO5cxUIlkACqozIEg4Ddok2RDV0QPJ/8QmIrLZc0BxNTbT?=
 =?us-ascii?Q?lt9gJL5e5mkacIrZiVA6TWrg25PBqpXRdYnsvpOBDLgDLOaXgIIEBwO8FXQs?=
 =?us-ascii?Q?+Mapm0XJ076WDUBB20Eyancyf5daS+RyCIMJz1TwDfOWAw9oXB6e7mWhJhMK?=
 =?us-ascii?Q?e9eDcXeHL/CMTatTxCYaqg2t6XtaGGIJyesVi0MVopZDMOID29JO/R1jEy1g?=
 =?us-ascii?Q?AwwUJ/xZbtNxhD7kbp6iSda3+/W6U1kmNqiszqy9XYYfftBeKtOKn3pOQgW7?=
 =?us-ascii?Q?vz5VL97ZAD/H2dO/ZUH2oyZz1LdaPPO5xOOiRW+AmvfFYyUtDdV7GWwoB5O+?=
 =?us-ascii?Q?vyH8I2VLbR4vqTUo/TpS6y7XryL6PrUQSRpzinRP3inwBVHtw60NXxnfvCw+?=
 =?us-ascii?Q?KDC9pOiFhBSpYD+jvtVoqcSFOyhkPmX18yH7WKBGiowZfuupKZ+IVKRTtXhD?=
 =?us-ascii?Q?hg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e415989-f57a-4cb0-cb7b-08daa0e2b658
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 23:48:01.0546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aAqoyUNjls/YlB8PYoXXf1KLBI2Y14D2spJ5gDgJRvyCJXqsYyU6gE9on9yGbwCJbHMpHfPi0r4Fr+yomuxzDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9444
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding optional new features to Qdisc offloads, existing drivers
must reject the new configuration until they are coded up to act on it.

Since modifying all drivers in lockstep with the changes in the Qdisc
can create problems of its own, it would be nice if there existed an
automatic opt-in mechanism for offloading optional features.

Jakub proposes that we multiplex one more kind of call through
ndo_setup_tc(): one where the driver populates a Qdisc-specific
capability structure.

First user will be taprio in further changes. Here we are introducing
the definitions for the base functionality.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220923163310.3192733-3-vladimir.oltean@nxp.com/
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Co-developed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new

 include/linux/netdevice.h |  1 +
 include/net/pkt_sched.h   |  5 +++++
 include/net/sch_generic.h |  3 +++
 net/sched/sch_api.c       | 17 +++++++++++++++++
 4 files changed, 26 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9f42fc871c3b..b175d6769f72 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -940,6 +940,7 @@ struct net_device_path_ctx {
 };
 
 enum tc_setup_type {
+	TC_QUERY_CAPS,
 	TC_SETUP_QDISC_MQPRIO,
 	TC_SETUP_CLSU32,
 	TC_SETUP_CLSFLOWER,
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 2ff80cd04c5c..34600292fdfb 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -141,6 +141,11 @@ static inline struct net *qdisc_net(struct Qdisc *q)
 	return dev_net(q->dev_queue->dev);
 }
 
+struct tc_query_caps_base {
+	enum tc_setup_type type;
+	void *caps;
+};
+
 struct tc_cbs_qopt_offload {
 	u8 enable;
 	s32 queue;
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 32819299937d..d5517719af4e 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -677,6 +677,9 @@ qdisc_offload_graft_helper(struct net_device *dev, struct Qdisc *sch,
 {
 }
 #endif
+void qdisc_offload_query_caps(struct net_device *dev,
+			      enum tc_setup_type type,
+			      void *caps, size_t caps_len);
 struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 			  const struct Qdisc_ops *ops,
 			  struct netlink_ext_ack *extack);
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index db1569fac57c..7c15f1f3da17 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -868,6 +868,23 @@ void qdisc_offload_graft_helper(struct net_device *dev, struct Qdisc *sch,
 }
 EXPORT_SYMBOL(qdisc_offload_graft_helper);
 
+void qdisc_offload_query_caps(struct net_device *dev,
+			      enum tc_setup_type type,
+			      void *caps, size_t caps_len)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct tc_query_caps_base base = {
+		.type = type,
+		.caps = caps,
+	};
+
+	memset(caps, 0, caps_len);
+
+	if (ops->ndo_setup_tc)
+		ops->ndo_setup_tc(dev, TC_QUERY_CAPS, &base);
+}
+EXPORT_SYMBOL(qdisc_offload_query_caps);
+
 static void qdisc_offload_graft_root(struct net_device *dev,
 				     struct Qdisc *new, struct Qdisc *old,
 				     struct netlink_ext_ack *extack)
-- 
2.34.1

