Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD4D67F380
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjA1BIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjA1BIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:08:04 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2089.outbound.protection.outlook.com [40.107.8.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27845AA47
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:08:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ngprD0IzaZnj9qmz0eTnthS7CG6G0P44zQmQOq+DFoso2PM/HwDnSUQAE1ZthzuY41xv2MsidyVvUq2FWKNVG8b3Yvo2q5bzQiayzGNGSpewPxIBDKwc1OLcOwhLzoSL0kg/hfNwfnzD2WzJGJflYV3PegpR9kpFRy/dK96poHJTEZCZimu/igDryFOKtdUHsxjS8G/mXdQ2EiIbBH0IK05O/UkzIuDWAZm6mGLzbJs/W4E+VetkxGviHpHZO6fhNwY7X0rR8+y1MSpgRfupMBJ4eUW9MdGHFLM6hQneC75gk71N/TjxORSzp2FEBnHNgkE4Yfp/fglIkWs/FXFApA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gK3RVtK//Di0AJPvLpO7jExJbZ5NSINUc5/edoDpXH0=;
 b=nNOGaHaAdAg4eYqMqCWvSJOGmBhEeOJ16V3Syb/kgWLV9/yhwwteGj+jEM4D7cayvaI9sL/ZEM8E9fYJka+nt6RqNDdVfh/2IfiMzQn+qrigclVgDxdXl8mvvGuAtQ+WvmnJ7utoYvRZ5CxazL7agncKfELsOM6RbOFY+26ggHoUWtx1FJ2U6UpXQe7ZP8MAomMuDp8oqxL6aqcOlUVRun9uKgRvUUPtELfvoLTLecf1XsPw4SMGbuOPaCuI9lvXIMEaARSN3ZtnWtq/tM93L6Ljs/ZawyNIr5atD8j23r6K43rUhGU0Uay8SDWfyyrgGDWcmkMCDPsT1r8sofLk2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gK3RVtK//Di0AJPvLpO7jExJbZ5NSINUc5/edoDpXH0=;
 b=jZt7MFJS4DLEWg+/gKkTGnDhOZr+hrtQd3hC9v37PFlbP37XeHCpYur8gq5DZ4kHg2IgijNibZyFklKXwdS+8LzurpRZ9X2lFeRg++Q8hPZYvYOrUyMaApppaVELnBPOohlTdXdFn0fDs0FMiWR7toYuUqD3j1BFOPq3CEYpIGI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 12/15] net/sched: keep the max_frm_len information inside struct sched_gate_list
Date:   Sat, 28 Jan 2023 03:07:16 +0200
Message-Id: <20230128010719.2182346-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: c5e0090c-88fe-471b-2908-08db00cc16b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: larLwpjd4/n2tDlRgsUEYYgGsTYDdV5YIusARadv6VRyInqdQcj6T/7iUzfRUD2cRyupi9qmQBdc6O5RQhcQhItVy/QnclQyXmHpR3WnUNx2SeP+RJnv3pKjU61Bu9+ts6iS2Tq7tT/gFX24bSE9oqQo/aKX2+n2b0ET4PrpfuZfsVPL48qOkEFzn8fXFHpLZ8JD733C3ZW9Z/GY1BFGA7L3wK+TIiYhBSibM9BqI/qNIcFrMLB1f7CqG0j6Heg5hjJPWlwAQOnEuaDg6ihSQrD7LIFGSqp3uqXTJzTsVaWWM0NNYDV1n+g5Rkyd8xgNWD/g9AtR51jxUqZDKqGthwTj8Knz+i6Zybl8tDJBhdWYjNRxDHbUlvRTXsrJLDfbwWNKfdN1m6mcfvDoEqZRul5GmzuokNVR+3l/kk9gViMIzrm1U0HbSmzm0xzLra45qX9IdyL2gtL5dq0Ct45D2YbGMBQmpsSEu6QR5cNl3JQXvNiq2HiGtcPpmWJV1xovxKqM0h8IZacoAr5BbBKevGc0VByLwlwtjkACY/Xqf5JZzTCsJAyM9w9ECgQ4jc04Mt7D+1ULmZ+dvFJioWxnh48tGhw/DvIR/NrcWePD7RDXp+R/NNYbh63lwBRKhKGRKiLMm3u8YmkzMfPJZWKMafA0J0HV2clkEKJxqhYMNstljlU5sEztpbKkgNj6bbIDPqei+uwKGN8Q3prTMGX/Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d3O7PU2Q/WniLKufLbH+FO/8FB8A2fA19ewpHVsrM2pEj0lPPCBlWkoWpnYF?=
 =?us-ascii?Q?aUSujCyabMwSRsEkUAv4TRCMV+c8tkBcVk7lzK41gMCxOctSH96Oq2/vcheP?=
 =?us-ascii?Q?0Q193QFOAoN0JWL+w1iDBJ6+u6lOegLKUb8903gJUnYfFXoI3oKoooC2cJn4?=
 =?us-ascii?Q?rgwaLmNUBg+5geusFtPp+MoI3pCI/P+s/3BNW8lD1EMcpZDTHJCOBkjK9y04?=
 =?us-ascii?Q?sYhv12EMSmNRJ43gCXMgcTT+HRYhdBXzLtoBTt75oidycICDaoyK+H5Vw1WY?=
 =?us-ascii?Q?IyQ4QNe5+D5gfaaRQ+MHTbEG1ZzS/EZmEoezQZzo16/OjAk77dcw5Ij7ANkL?=
 =?us-ascii?Q?psdpxpCNC2WOaQQm3orCOq9n5CsYQaJq+UVp1zOOehxF5HJBwVKUQ9t4VvyM?=
 =?us-ascii?Q?yxkgkxrZzq7kUQ8AupMU9LeCzbvAhRKuYZEUZMN05S//2FVW7vqqhbP3c8lC?=
 =?us-ascii?Q?IV324FjrYBSUZmPqjAvozSuk3cRh3isasHTaGbaeZZM3QPRajnW9IniFYFMp?=
 =?us-ascii?Q?IrZgP6qUEFWBh3YPQ/HV0Qy90Uc4benw7XeDUpvGuXTZTxsFr4Zn1xFmSwHi?=
 =?us-ascii?Q?nRCg94GkDXsz/lheOpyUcK9AZ2xOkW+o8BdkHHueWU56FkKtnU50rHkXICce?=
 =?us-ascii?Q?vZXoWYPgM4zkKEhfVGJh67SkSl3umhxfKEQi98Tc7vWvXvNeJ57Ah9nApWVw?=
 =?us-ascii?Q?Ab/+20ScdY/wCmaA3/P2vJ/M7Q25/CgrI+L8HG7ERgUUpm2bcvMbrEK8BmV7?=
 =?us-ascii?Q?dDpWbuPcMdt/CeQOhltdh7cV4SKDo62ZCSqABFEuCU42x+L5p3UoGyRMO6We?=
 =?us-ascii?Q?YbQnqS0zH3pseMQhUElTpT+hpyqd0HEVzzEP1iBZUmvT2PShzMC9ZaM/gQuL?=
 =?us-ascii?Q?sbcVSQWWNPsUrjgv5s8IPPv0EfTEFZB6MeeAb7EyicTZju+lGrrXKXNZnQj/?=
 =?us-ascii?Q?jZpLLtIBk2D5HnhSP/8hJzyjpfYPn20ZPoWp7Kko678l4Vu+XkL1R+JPnL3F?=
 =?us-ascii?Q?hKZ9HBc83MatGsOmD/sjypZS+1UQiDnaxshDHrimObE4G2OBXDRRykmHfLjT?=
 =?us-ascii?Q?/PvwlmOn9q0ADYiCj1OsUSLEj9WbltayXySwPgX9jVF6PxYaqVgyW6vkkYLk?=
 =?us-ascii?Q?5CNLRtTYTksj0hLhZCfWSAqjy9+xg1378nvzKoyCmJQeqPPpk25e6H7lAah6?=
 =?us-ascii?Q?6a719lkz8++onOkFlFQ2K9FpgPLcPjpfAPRno6htAEdtixlBURKT7g6l8nt6?=
 =?us-ascii?Q?TMxUuxhHjOaKwRVIfFcMAZys1zd8Zj901Ukj762xMwvuKUFtC/vhvDWHVidq?=
 =?us-ascii?Q?tQClH9ig49AOuj82XTdLh1qZugpotd+xg13rNxzF/D3GUkFyP9YeKcySRLrj?=
 =?us-ascii?Q?t96goBUu8xUpRkOlUGG5IpQ6nkqKLVm5flQhwh2dZhM/0mfvSZHFiqWsGkH7?=
 =?us-ascii?Q?nkyxW5utlbqAJ5hyDCJQ467wTdjmG+0CNGLv5aF6atnMhnfANFdJl+qWiO63?=
 =?us-ascii?Q?PKyR4D4b4FApMCl6b7RgqEa/XZTTMljwxwTMFMVXIwGEuTgcz9PtNXZrBMq1?=
 =?us-ascii?Q?lsECQkp1xfrfKEoJ9J+BzO+UD9sudcIe7W0VqqYn1dCpGEjJ13cXZGbg8EPh?=
 =?us-ascii?Q?TQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e0090c-88fe-471b-2908-08db00cc16b4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:55.9009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JQUbKrhrvlCm8o9F23J5cT/bqfViMkjnxrtzYkBq2wsn3p/seeFEBe9RHunCYVCZ37mavPNPipdc1oAKe3LsYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have one practical reason for doing this and one concerning correctness.

The practical reason has to do with a follow-up patch, which aims to mix
2 sources of max_sdu (one coming from the user and the other automatically
calculated based on TC gate durations @current link speed). Among those
2 sources of input, we must always select the smaller max_sdu value, but
this can change at various link speeds. So the max_sdu coming from the
user must be kept separated from the value that is operationally used
(the minimum of the 2), because otherwise we overwrite it and forget
what the user asked us to do.

To solve that, this patch proposes that struct sched_gate_list contains
the operationally active max_frm_len, and q->max_sdu contains just what
was requested by the user.

The reason having to do with correctness lies on the following
observation: the admin sched_gate_list becomes operational at a given
base_time in the future. Until then, it is inactive and applies no
shaping, all gates are open, etc. So the queueMaxSDU dropping shouldn't
apply either (this is a mechanism to ensure that packets smaller than
the largest gate duration for that TC don't hang the port; clearly it
makes little sense if the gates are always open).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index d50b2ffe32f6..43a8fd92a5a0 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -59,6 +59,7 @@ struct sched_gate_list {
 	 * or 0 if a traffic class gate never opens during the schedule.
 	 */
 	u64 max_open_tc_gate_duration[TC_MAX_QUEUE];
+	u32 max_frm_len[TC_MAX_QUEUE]; /* for the fast path */
 	struct rcu_head rcu;
 	struct list_head entries;
 	size_t num_entries;
@@ -87,8 +88,7 @@ struct taprio_sched {
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
 	int cur_txq[TC_MAX_QUEUE];
-	u32 max_frm_len[TC_MAX_QUEUE]; /* for the fast path */
-	u32 max_sdu[TC_MAX_QUEUE]; /* for dump and offloading */
+	u32 max_sdu[TC_MAX_QUEUE]; /* save info from the user */
 	u32 txtime_delay;
 };
 
@@ -240,6 +240,21 @@ static int length_to_duration(struct taprio_sched *q, int len)
 	return div_u64(len * atomic64_read(&q->picos_per_byte), PSEC_PER_NSEC);
 }
 
+static void taprio_update_queue_max_sdu(struct taprio_sched *q,
+					struct sched_gate_list *sched)
+{
+	struct net_device *dev = qdisc_dev(q->root);
+	int num_tc = netdev_get_num_tc(dev);
+	int tc;
+
+	for (tc = 0; tc < num_tc; tc++) {
+		if (q->max_sdu[tc])
+			sched->max_frm_len[tc] = q->max_sdu[tc] + dev->hard_header_len;
+		else
+			sched->max_frm_len[tc] = U32_MAX; /* never oversized */
+	}
+}
+
 /* Returns the entry corresponding to next available interval. If
  * validate_interval is set, it only validates whether the timestamp occurs
  * when the gate corresponding to the skb's traffic class is open.
@@ -478,6 +493,7 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct sched_gate_list *sched;
 	int prio = skb->priority;
 	u8 tc;
 
@@ -493,8 +509,14 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 
 	/* Devices with full offload are expected to honor this in hardware */
 	tc = netdev_get_prio_tc_map(dev, prio);
-	if (skb->len > q->max_frm_len[tc])
+
+	rcu_read_lock();
+	sched = rcu_dereference(q->oper_sched);
+	if (sched && skb->len > sched->max_frm_len[tc]) {
+		rcu_read_unlock();
 		return qdisc_drop(skb, sch, to_free);
+	}
+	rcu_read_unlock();
 
 	qdisc_qstats_backlog_inc(sch, skb);
 	sch->q.qlen++;
@@ -1590,7 +1612,6 @@ static int taprio_parse_tc_entries(struct Qdisc *sch,
 				   struct netlink_ext_ack *extack)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
 	u32 max_sdu[TC_QOPT_MAX_QUEUE];
 	unsigned long seen_tcs = 0;
 	struct nlattr *n;
@@ -1609,13 +1630,8 @@ static int taprio_parse_tc_entries(struct Qdisc *sch,
 			goto out;
 	}
 
-	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
 		q->max_sdu[tc] = max_sdu[tc];
-		if (max_sdu[tc])
-			q->max_frm_len[tc] = max_sdu[tc] + dev->hard_header_len;
-		else
-			q->max_frm_len[tc] = U32_MAX; /* never oversized */
-	}
 
 out:
 	return err;
@@ -1756,6 +1772,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 
 	taprio_set_picos_per_byte(dev, q);
+	taprio_update_queue_max_sdu(q, new_admin);
 
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 		err = taprio_enable_offload(dev, q, new_admin, extack);
-- 
2.34.1

