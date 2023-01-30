Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DBC6817B0
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237413AbjA3RdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbjA3Rcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:47 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2066.outbound.protection.outlook.com [40.107.21.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C16131E09
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2sAWG4/V4VJMUqXITe3ikMqq0D2CHq8lrwLN1i288V1at8EQ7Z/h2rO1pp5lwpOZL3r6237D76sYLAsxTWk3CAoJYho5vMkRGgL1KuLX4GQljbgSmPNPloNxZPmv8z9Ygyj1yS7EgdCdHf00iRo4frO+oX+2oC4xOiVkfKHGlQvCUM6YgauHcURil4kh0Ptxo+k6J3DCbRFmUq+4Wv/GafOujk0YA2YfUwGt5KEUOv8MOyGdWFPfUOcWhESIZMgWR/jFIUTPYBa/nUJ/jYWQ+eZoRWlFqyEQlHio/S+m/Fofwf3sQS+qJchN63IX3n4zwoXUGdPx/kZZsuLKrrZzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPe+l7r98DnSjHpU8T5dm6nweU/6lBtxg59TpCko0pk=;
 b=AcwvzSfFF+MlodKKWgCikc+0ZBrv8R3VGKZoxgvBVE+K12/r7WKT7tdhZC9yktmyqB1c659Y4fENRzfRja8lwA2d4dWDCI8+Y/iHuvwK/B90K16xbbEFT2zxhszY54xDvbEIxqfXeyprxJ0ZskPpHWtmiWGfCj6cMX9HomCXuuA/fUPkYxq1IzmxKMTNFiL9hYM3Q9Prm0C1lL99Pox6EOXiPzXXa7N4PPTHqSctmkhLKIrdLvLb7DypF+WZvgkHFD+GvSKGrdLkUfmgcJdg+qm8zQy+G7VCiOjsX/QbWiAaBTU6v9jR3Ak6H297o6Lxu/W9OB2M6ZU9insNhciqGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPe+l7r98DnSjHpU8T5dm6nweU/6lBtxg59TpCko0pk=;
 b=TNXekuAt+W3xzK41JL5tCyZcINvXEPd8Y7UF2M6EX7PbiNvts175/PoZ/AfeFceaF/nEmln8m/+fwivHLWG+ZSTFFDiIqGk3N63ZWImjhsheEjD/mhGPqTHjH5MO/12sbL8MHd/TuhkzqNqy6pYtod44wx4grR4DnjUI060yjWk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PA4PR04MB7677.eurprd04.prod.outlook.com (2603:10a6:102:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:25 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:25 +0000
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
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v4 net-next 14/15] net/sched: taprio: mask off bits in gate mask that exceed number of TCs
Date:   Mon, 30 Jan 2023 19:31:44 +0200
Message-Id: <20230130173145.475943-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130173145.475943-1-vladimir.oltean@nxp.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PA4PR04MB7677:EE_
X-MS-Office365-Filtering-Correlation-Id: e15a13d6-398c-4b4f-26e6-08db02e7f3c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DL3ws3O/cK+AB4WuDRdNhM9k6UBV+UK5aCKeEuLCO5bT+tmM3oCiPscNsA3hdgJHnMV/lO+NISORtq9IKzh4q8T7CWOy4I4Yk2gBcvx/NDUtww0lEJVb4IDNDZ29UXH64zsdxPYHuwpnapGtWN00lME4Mgy9CuwXiqkXXMCgX/9+S+eVCMAeZTS7HM2Q1jvUQahiRqipLJuL3CBhuvNmII1bGe3oyXpY6ff5z2VPmd2YRrkmF2tH6h0kAhCBIRIzu1jsyakHUyhfIXH1lazqU4ypX7ITTV/79HiZCgeyoDz+ONZBTacSnepliVe2k86wTAJyp1fRCRN4PXDer5e/vIt+2g5L/ifbcawgdZ+XCzfulrBeKNmIYvUjFLc/2k4WBptZCNsQyr+feJ1GCNLcLl+dUszjePKkF+hNek3LYiJoI7mzug97TjathsMF/RWkiinWUcliyho1QbbBhwOfwFKxxoVsUHFEYdoBxcdWujspd7/b6eQYRyMkY5//91i6iI2u4Y9XVt0QLPn+tBUjQFA6pGmxXVrVf0OlPWYnVHlK20Ieuxz+SEYb6ohZY7AVjUDMFanLuMmAh2RQp2pV1bcpd9oWCwa6SjPfSrNvISm2QErdjjv6c8ZCx73NQVDitdWBwQ8cUYAq5qOvGBBo93I47J24W8k8GgtOVe2PEPpoqeuuc3Qer2hqAQht1YuSO+GiuBOiGtdj6BrVenP5Cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(2906002)(5660300002)(86362001)(44832011)(7416002)(83380400001)(8936002)(41300700001)(36756003)(478600001)(6486002)(1076003)(26005)(6512007)(6666004)(186003)(52116002)(6506007)(2616005)(54906003)(4326008)(66476007)(38100700002)(66946007)(8676002)(66556008)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IkE2OkAnr80+2xmX4tZm9gSvp+FVZuDRpXzZTFKOTtKHGVzqD+FTFIzbFc9W?=
 =?us-ascii?Q?9mRepYJ1C2Q8mnviEzXyL6jOuGxbkQRzXhdgMFeE4lUoJdBI10bxa5CD50km?=
 =?us-ascii?Q?RScfn7PMWAjs/ErvLEld6bYxG3eksCEPSk7MtA28uZ4Ek7XEbsIY6eujGAM8?=
 =?us-ascii?Q?cicS9EsPNJqkVSIT5B+eOLoRp7xTycf+axwtzwNJq95N8G7p2ADG1BuQye6r?=
 =?us-ascii?Q?8baGANm4BZMDZNeWtGNCrurNnwupXIhGgTHIZB92F30aiu9B296e3dmQcYG2?=
 =?us-ascii?Q?OufXj7cSP2pamXIveoVE1GlKEBjdBkf7iuniiKbop9ObXBxpNbaZyp/wAT7q?=
 =?us-ascii?Q?47nh81TcpPHcHF8r1Pl1ZjCMXlXshCsBdC+CFPpjjsofc/99eA1KXxuQq4BR?=
 =?us-ascii?Q?8KDHVgDfVExQHoCn9KUcX4TjrNMC/nATmRLTIZpMpjUwTlxfbPG6Wf91dsid?=
 =?us-ascii?Q?QZxKJbEdqG4sgim921TdKS+DzAskQkLtFi7LiQl+u19eD7gG1XKZ6OvJamM2?=
 =?us-ascii?Q?Yop+gKHoDULVCv0hHQ11gnxaDeVg6KH0Pvt5+zOgECqTeWsYQlxbt7MaSC2Y?=
 =?us-ascii?Q?FqrhPnJi7Rk3PEaWJF+AEurHIFwUXbcD8Vf6C8wGoDaTkfJHettiXrFfiIFj?=
 =?us-ascii?Q?bB11Ws5ARNVDkaJyeiPp5z00MTweKx5ibDasfdbuqnzFOv0ZS4s396Wu244K?=
 =?us-ascii?Q?axN408dHnmjhuzi4aX1QjfkzUmPOJcROvMCJiiyaMxai1kAj29ypFpOH/fjN?=
 =?us-ascii?Q?xAUvvYZWRiD0WHC4+QIBX8lxrtcJxWLxjkYETnNXIq1rIYfM2BW+R81Is1gW?=
 =?us-ascii?Q?Iey3j9pzKjgOJ2jA7xTKCk946eEJMtnmChdbjt6d6CfVIpAGRMX6o6kdQYHk?=
 =?us-ascii?Q?yVoIM7oO4GlYk3j4EUFZL8In1jq8EVQ1c4QsHBVz6UFrXkqJg7vRZARqdGlZ?=
 =?us-ascii?Q?ELOZt1dznCv+GJ3Keyv3ySxgcsug6LD+j8wq2txciDiHhdFUKMwM9bmy3Ngu?=
 =?us-ascii?Q?MYRQleMQrexQag2Adw80B1dGbpjNOcyylNP14bFVZgY9qYPH4VQaCaDeSa+f?=
 =?us-ascii?Q?Ba6H0VPAIKpvQwA/UUNO7H9A3i+5JXmSPFH3TsTF9a0h4e5/oFj2hMeaVFEd?=
 =?us-ascii?Q?XbZCtlbHHDxPNEeQdumLAsqh2Ujx/kQaRC+l59Ls1m1FXWtMTEbgdidaIKuF?=
 =?us-ascii?Q?zbAy3JdigqX5E/snPo97DEzED7jIju7tpfstS+3+9A10YYKFZyw4/nqRk2lX?=
 =?us-ascii?Q?5MmvnAzoq4Fg/m/WmSp9wYQUp0aB9anMuv64i3Biu/Ah/pqkDAkKhlm/W+4v?=
 =?us-ascii?Q?sfscFDvX59oIwFZOLPqjJyG2oHXSvQONyu/tdknccjKnF5QiwZ0EPu6FQMa6?=
 =?us-ascii?Q?RtBBOLbF5LrELWLK2FDQ/7o7G2K//Q7gtScqApnV8vPjwm9/Mk6QkazKjG+b?=
 =?us-ascii?Q?GtUKuIQd5Z1oMxLYxLGbSO16T8rc9ivNTFDeIw4efKwBTFtW4Tz0mll9YMWH?=
 =?us-ascii?Q?nqHEA2waIpWPAFOCM6VgNWIssHaFXZYxG+4U3rn9BW+9k/scyvFGXvR1PNj4?=
 =?us-ascii?Q?0eGuICBIx5/wWb2cA9lezvgFlrk5ZRARJQNrQhTD5W2UhP/0Luij45/PKHga?=
 =?us-ascii?Q?9Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e15a13d6-398c-4b4f-26e6-08db02e7f3c2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:25.5689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WgBeYn+AdmZwemmIhHE9daH+LgbPbCi21yDW3AO1G8xO76O8+5LsxkCA4DEgO4ISJJWe3zvVODzCrd5Ve9UXsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7677
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"man tc-taprio" says:

| each gate state allows outgoing traffic for a subset (potentially
| empty) of traffic classes.

So it makes sense to not allow gate actions to have bits set for traffic
classes that exceed the number of TCs of the device (according to the
mqprio configuration).

Validating precisely that would risk introducing breakage in commands
that worked (because taprio ignores the upper bits). OTOH, the user may
not immediately realize that taprio ignores the upper bits (may confuse
the gate mask to be per TXQ rather than per TC). So at least warn to
dmesg, mask off the excess bits and continue.

For this patch to work, we need to move the assignment of the mqprio
queue configuration to the netdev above the parse_taprio_schedule()
call, because we make use of netdev_get_num_tc().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v3->v4: none
v2->v3: warn and mask off instead of failing
v1->v2: none

 net/sched/sch_taprio.c | 46 +++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index f40016275384..a9873056ea97 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -789,15 +789,29 @@ static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
 			    struct netlink_ext_ack *extack)
 {
 	int min_duration = length_to_duration(q, ETH_ZLEN);
+	struct net_device *dev = qdisc_dev(q->root);
+	int num_tc = netdev_get_num_tc(dev);
+	u32 max_gate_mask = 0;
 	u32 interval = 0;
 
+	if (num_tc)
+		max_gate_mask = GENMASK(num_tc - 1, 0);
+
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_CMD])
 		entry->command = nla_get_u8(
 			tb[TCA_TAPRIO_SCHED_ENTRY_CMD]);
 
-	if (tb[TCA_TAPRIO_SCHED_ENTRY_GATE_MASK])
+	if (tb[TCA_TAPRIO_SCHED_ENTRY_GATE_MASK]) {
 		entry->gate_mask = nla_get_u32(
 			tb[TCA_TAPRIO_SCHED_ENTRY_GATE_MASK]);
+		if (entry->gate_mask & ~max_gate_mask) {
+			netdev_warn(dev,
+				    "Gate mask 0x%x contains bits for non-existent TCs (device has %d), truncating to 0x%x",
+				    entry->gate_mask, num_tc,
+				    entry->gate_mask & max_gate_mask);
+			entry->gate_mask &= max_gate_mask;
+		}
+	}
 
 	if (tb[TCA_TAPRIO_SCHED_ENTRY_INTERVAL])
 		interval = nla_get_u32(
@@ -1605,6 +1619,21 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto free_sched;
 	}
 
+	if (mqprio) {
+		err = netdev_set_num_tc(dev, mqprio->num_tc);
+		if (err)
+			goto free_sched;
+		for (i = 0; i < mqprio->num_tc; i++)
+			netdev_set_tc_queue(dev, i,
+					    mqprio->count[i],
+					    mqprio->offset[i]);
+
+		/* Always use supplied priority mappings */
+		for (i = 0; i <= TC_BITMASK; i++)
+			netdev_set_prio_tc_map(dev, i,
+					       mqprio->prio_tc_map[i]);
+	}
+
 	err = parse_taprio_schedule(q, tb, new_admin, extack);
 	if (err < 0)
 		goto free_sched;
@@ -1621,21 +1650,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 	taprio_set_picos_per_byte(dev, q);
 
-	if (mqprio) {
-		err = netdev_set_num_tc(dev, mqprio->num_tc);
-		if (err)
-			goto free_sched;
-		for (i = 0; i < mqprio->num_tc; i++)
-			netdev_set_tc_queue(dev, i,
-					    mqprio->count[i],
-					    mqprio->offset[i]);
-
-		/* Always use supplied priority mappings */
-		for (i = 0; i <= TC_BITMASK; i++)
-			netdev_set_prio_tc_map(dev, i,
-					       mqprio->prio_tc_map[i]);
-	}
-
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 		err = taprio_enable_offload(dev, q, new_admin, extack);
 	else
-- 
2.34.1

