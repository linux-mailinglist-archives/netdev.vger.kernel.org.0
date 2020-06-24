Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B1220701B
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389574AbgFXJfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:35:21 -0400
Received: from mail-eopbgr10062.outbound.protection.outlook.com ([40.107.1.62]:21768
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387717AbgFXJfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 05:35:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oasWwH5u3ONWiudQrL1dFTemCEwwPwJ23TJg+A/c90B5RB5SZ/U1P6hyef4hL8bgNphT/Aassr+a08ea982Mra3VKP2AJ553lRhCa7CZ+hwie5usBYiuR7z2i/gAe/SMThOD6oD78Cg1SJIFbUuBf0TTAu4Vkr1rG2/P5CWItRI10dZJnafNPvExa5Tm1Vntn8mrbQWBX9OKu3s/kR3KABJIqiVcHNJyXPSiBOZaBBw09dXyHXm15Uf5AjV+ieMTcyTrOI6zJCgvYIgRquA2yltUqQMyS1tDtTD02EPCuJp8y3BSJAv/D54odvUlm8IVCy3W1TE+Y8RaqZC7Mc7F5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SO1BWO8vqltZk7YqESkFbr+AJt8Jmbaeu7PsnSBD8EM=;
 b=X+lOjfNfdCEp2fwHI2rO+94nIFEOFBmYKadnpx9GKllHLwYBPHTBQrIQtmG70xOD8pu+cEYAcWJt7TrcruZjT8lK3XjtZbr/XxMA+/QX0sd8R2tShmxRM3egmXFFOwnAk9h2bx6lqhna8Q2Q/Am10RQ7tRbzOQp7cAkcylYeSK4scSeibPzVJDuzhsD/AeBXmU6FiBZqbjeTxCgRODUQmlyo/Db+uahflleaKTXmWbFd/Ey4noFbv2vrReMXvfiheNxOOcAG9HwHVGa7+KLt6NLgz6qri5JEJjUWG89e0kxk/ZdWYmy+crg4nUqSe3WlWTv+He4iXjjCa86YBcuuiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SO1BWO8vqltZk7YqESkFbr+AJt8Jmbaeu7PsnSBD8EM=;
 b=Z8ITzSD0zTTGOB6k+g16jFFeZosguqNgbP0HPqm42pkCTO5bdg/AFzciU4CV6BEu83nZaxibRLcxkcQ4dqAfyeIDwXXfRH95Nr8hTTt1Uj47+3tx1jhzoNL2rJJimtaegBinxFQKVnnkkorUjCDwoYP2kcsGkGu7KeYVZlxKDQU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6431.eurprd04.prod.outlook.com (2603:10a6:803:12a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Wed, 24 Jun
 2020 09:35:16 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 09:35:16 +0000
From:   Po Liu <po.liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, idosch@idosch.org
Cc:     jiri@resnulli.us, vinicius.gomes@intel.com, vlad@buslov.dev,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org,
        Po Liu <Po.Liu@nxp.com>
Subject: [v2,net-next 2/4] net: enetc: add support max frame size for tc flower offload
Date:   Wed, 24 Jun 2020 17:36:29 +0800
Message-Id: <20200624093631.13719-2-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200624093631.13719-1-po.liu@nxp.com>
References: <20200623063412.19180-4-po.liu@nxp.com>
 <20200624093631.13719-1-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0119.apcprd06.prod.outlook.com
 (2603:1096:1:1d::21) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tsn.ap.freescale.net (119.31.174.73) by SG2PR06CA0119.apcprd06.prod.outlook.com (2603:1096:1:1d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 09:35:08 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c2cbba2c-f063-4051-e7d3-08d81821e6be
X-MS-TrafficTypeDiagnostic: VE1PR04MB6431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB64317DA5BA3CAEC0D7F7F61092950@VE1PR04MB6431.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cr8f5n7JoJD906s229aOCsxA5U6Luesqh+ggQOhW92tGZE+CpXgpCuMZizZ13VKwDxxvg65xdHofnpEq7e3NexRDiDjHtJP/ua+ODsRUHNBQKyxnPCVRKor1JvE6tRLIFdPiYR7eO1me5DnXdxJXr9k+Y5GYS8Eb/qIKTGHZvkC3DRSej3Ng2XrZ54GW8Us75fHTek+OTZDm20Ll+Oqlz/OnphYhntBXaELpj2UtkP2AFrcpA0QgLhHNND+mWYSkwgg/HuyA8xIIh+mTktwqXthyUkrOj18/QtTd/Udd+Wap26RnsoWpDfYohtgOFbDJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(6486002)(956004)(44832011)(2616005)(316002)(86362001)(83380400001)(1076003)(478600001)(66556008)(6666004)(36756003)(66476007)(66946007)(8676002)(4326008)(8936002)(186003)(16526019)(6512007)(7416002)(6506007)(52116002)(5660300002)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sA2YftiAGxvVPskfPZkkTntU5jZfIQUENxnRtpRhBF3YkJQW/eyDbVMRJVo7kdzKL6nWYV+Wwj3mx/ewPAX5QDmNnEqZUHlyQncFQzCOo1gGbqNHLpYRiny2sdIbDn3VWVdujsKQ7Q7QmnPPHqBm2tnYkbnZr44Iod4IDBCeDW7KQH2Cb1lhS+LfeKLeWz3nhlCqyctTH73BdSd0amuFCOmQnjuo6TZALmodVdwcyfEfJ3ywzoF53VDJk30QunWHWZvIai2P3lM2nVGJGOc7Y+kqHAI+x4wYOq3T6BQw00NSBRKkoTrii3gpKMCbYjmjdll+zw9C/FYYFJF2+4lBOHSyIMhklkp15HblA4epkfBpm48HYDVy2dMPTN4z0nVkhdD0j8+Xi2Lyo8W+gh8soLFv+sFHYIZVMti4ih97L+e0YCYYT7IHIDc58Q5zy24fJEdf8utsIn23BcSB36V1FssI7cpXcokKPLtKHNQ9nsc=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2cbba2c-f063-4051-e7d3-08d81821e6be
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 09:35:16.0271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HN0cMMjVJEVuxa8xd+mAR88sx69lZHplvOeAMuB4BeaAyZSe9pSSIP/r4zf1LLTa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6431
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <Po.Liu@nxp.com>

Base on the tc flower offload police action add max frame size by the
parameter 'mtu'. Tc flower device driver working by the IEEE 802.1Qci
stream filter can implement the max frame size filtering. Add it to the
current hardware tc flower stearm filter driver.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
v2:
- No update.

 .../net/ethernet/freescale/enetc/enetc_qos.c  | 52 +++++++++++++------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index fb76903eca90..07f98bf7a06b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -389,6 +389,7 @@ struct enetc_psfp_filter {
 	u32 index;
 	s32 handle;
 	s8 prio;
+	u32 maxsdu;
 	u32 gate_id;
 	s32 meter_id;
 	refcount_t refcount;
@@ -430,6 +431,12 @@ static struct actions_fwd enetc_act_fwd[] = {
 		BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS),
 		FILTER_ACTION_TYPE_PSFP
 	},
+	{
+		BIT(FLOW_ACTION_POLICE) |
+		BIT(FLOW_ACTION_GATE),
+		BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS),
+		FILTER_ACTION_TYPE_PSFP
+	},
 	/* example for ACL actions */
 	{
 		BIT(FLOW_ACTION_DROP),
@@ -594,8 +601,12 @@ static int enetc_streamfilter_hw_set(struct enetc_ndev_priv *priv,
 	/* Filter Type. Identifies the contents of the MSDU/FM_INST_INDEX
 	 * field as being either an MSDU value or an index into the Flow
 	 * Meter Instance table.
-	 * TODO: no limit max sdu
 	 */
+	if (sfi->maxsdu) {
+		sfi_config->msdu =
+		cpu_to_le16(sfi->maxsdu);
+		sfi_config->multi |= 0x40;
+	}
 
 	if (sfi->meter_id >= 0) {
 		sfi_config->fm_inst_table_index = cpu_to_le16(sfi->meter_id);
@@ -872,6 +883,7 @@ static struct enetc_psfp_filter
 	hlist_for_each_entry(s, &epsfp.psfp_filter_list, node)
 		if (s->gate_id == sfi->gate_id &&
 		    s->prio == sfi->prio &&
+		    s->maxsdu == sfi->maxsdu &&
 		    s->meter_id == sfi->meter_id)
 			return s;
 
@@ -979,6 +991,7 @@ static struct actions_fwd *enetc_check_flow_actions(u64 acts,
 static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 				      struct flow_cls_offload *f)
 {
+	struct flow_action_entry *entryg = NULL, *entryp = NULL;
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct enetc_stream_filter *filter, *old_filter;
@@ -997,9 +1010,12 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 
 	flow_action_for_each(i, entry, &rule->action)
 		if (entry->id == FLOW_ACTION_GATE)
-			break;
+			entryg = entry;
+		else if (entry->id == FLOW_ACTION_POLICE)
+			entryp = entry;
 
-	if (entry->id != FLOW_ACTION_GATE)
+	/* Not support without gate action */
+	if (!entryg)
 		return -EINVAL;
 
 	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
@@ -1079,19 +1095,19 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 	}
 
 	/* parsing gate action */
-	if (entry->gate.index >= priv->psfp_cap.max_psfp_gate) {
+	if (entryg->gate.index >= priv->psfp_cap.max_psfp_gate) {
 		NL_SET_ERR_MSG_MOD(extack, "No Stream Gate resource!");
 		err = -ENOSPC;
 		goto free_filter;
 	}
 
-	if (entry->gate.num_entries >= priv->psfp_cap.max_psfp_gatelist) {
+	if (entryg->gate.num_entries >= priv->psfp_cap.max_psfp_gatelist) {
 		NL_SET_ERR_MSG_MOD(extack, "No Stream Gate resource!");
 		err = -ENOSPC;
 		goto free_filter;
 	}
 
-	entries_size = struct_size(sgi, entries, entry->gate.num_entries);
+	entries_size = struct_size(sgi, entries, entryg->gate.num_entries);
 	sgi = kzalloc(entries_size, GFP_KERNEL);
 	if (!sgi) {
 		err = -ENOMEM;
@@ -1099,18 +1115,18 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 	}
 
 	refcount_set(&sgi->refcount, 1);
-	sgi->index = entry->gate.index;
-	sgi->init_ipv = entry->gate.prio;
-	sgi->basetime = entry->gate.basetime;
-	sgi->cycletime = entry->gate.cycletime;
-	sgi->num_entries = entry->gate.num_entries;
+	sgi->index = entryg->gate.index;
+	sgi->init_ipv = entryg->gate.prio;
+	sgi->basetime = entryg->gate.basetime;
+	sgi->cycletime = entryg->gate.cycletime;
+	sgi->num_entries = entryg->gate.num_entries;
 
 	e = sgi->entries;
-	for (i = 0; i < entry->gate.num_entries; i++) {
-		e[i].gate_state = entry->gate.entries[i].gate_state;
-		e[i].interval = entry->gate.entries[i].interval;
-		e[i].ipv = entry->gate.entries[i].ipv;
-		e[i].maxoctets = entry->gate.entries[i].maxoctets;
+	for (i = 0; i < entryg->gate.num_entries; i++) {
+		e[i].gate_state = entryg->gate.entries[i].gate_state;
+		e[i].interval = entryg->gate.entries[i].interval;
+		e[i].ipv = entryg->gate.entries[i].ipv;
+		e[i].maxoctets = entryg->gate.entries[i].maxoctets;
 	}
 
 	filter->sgi_index = sgi->index;
@@ -1127,6 +1143,10 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 	/* flow meter not support yet */
 	sfi->meter_id = ENETC_PSFP_WILDCARD;
 
+	/* Max frame size */
+	if (entryp)
+		sfi->maxsdu = entryp->police.mtu;
+
 	/* prio ref the filter prio */
 	if (f->common.prio && f->common.prio <= BIT(3))
 		sfi->prio = f->common.prio - 1;
-- 
2.17.1

