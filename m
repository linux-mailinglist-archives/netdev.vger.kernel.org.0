Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7972049F9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbgFWGdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:33:02 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:61054
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730635AbgFWGdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 02:33:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqpnZ7oLku8Hy5e4vxcBjU5Q0m3aRS3rbYUC7dsiNcQjJtyjAmTFGYL8zHLNDQ59e/hx5ZTUsefHyzWi3HNc8xKNjYozlaCidlWzqVHAFZvgN3LGdOUftTP/GTvfeARZ3LveXL7hVppSJrHqXg4a8Zxd3XBkpTMQ9O24ad9IAYd5h6/f2rmkPVl+0KkPmuocAoW3VyetiAKMrh2tuC+qnfFOOukdDQhK35KIl4aIaKxqlQgOqL541lDfKaxbaK1JzOCU/g55WRgxyyHrCo3AlVFLZ18k4llJHR6+i8Bj9j2rpjkoDBcLnCdS9d5NP6AQUzrAQ/pDhCKtgDWTWj7R8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/2pQWPnyo6ZrK/SFWnPcjeiYriQtx3g8ATHZ9bdskWk=;
 b=NkAZOYGrrxKuc+TKy0bjcoU+VWR3n6kJ5Woio6BeeEdYSfZPmakw2ryEUCYcI9PYGy30Z2MCkBf7uOh1eQI9OmGBXs+f2zZeBoIAgiuboj8eBrx+IZDCfxfhRbkgk4LY+jhDWVE0iEffOt/7ohPztWRSugJh/cJUz6XNHuf6JdyJ6E8cd5sA5W9iw7jSUMUlwGZKl7mYjJcxHUu/QwU94z1O9xMUpKPwpznhA9g/QBw1Wn7ZTbTb9MqgQThOtQtbQPnRhV0sf/yOZnF3EW055/af51F/HpyXEqOWYMeFE1qavEFMpqncadrSkQFqkurXGizW6ftr9o13gE9reqnB4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/2pQWPnyo6ZrK/SFWnPcjeiYriQtx3g8ATHZ9bdskWk=;
 b=REfXESen+KyZroRQKBV/4vPzLS5YTB60OZ+ecAmefjXfhAYBrEvGp/Y6eEgR/kL5u1GFiaH/wbn5sj9wEOFU+5LUrgbM8Ub1VJeHBdy4fsMB0vALwk0SuHGeQXVo99x1OSU6ldIBYlI2Q/rJ2CWWMGnrkdtd4g0p1GrKs213sc0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6688.eurprd04.prod.outlook.com (2603:10a6:803:127::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 06:32:56 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 06:32:56 +0000
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
Subject: [v1,net-next 2/4] net: enetc: add support max frame size for tc flower offload
Date:   Tue, 23 Jun 2020 14:34:10 +0800
Message-Id: <20200623063412.19180-2-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200623063412.19180-1-po.liu@nxp.com>
References: <20200306125608.11717-7-Po.Liu@nxp.com>
 <20200623063412.19180-1-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::15)
 To VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tsn.ap.freescale.net (119.31.174.73) by SGAP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 06:32:48 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 522f5fb5-179c-4497-ae13-08d8173f43d6
X-MS-TrafficTypeDiagnostic: VE1PR04MB6688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6688ECF15C34A971BFB99EB492940@VE1PR04MB6688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MH/DDBpAMjZqo4JKDe27KS4i71xcl3RbnECb/nznD/Slr3LvKCPPJ0j+xdJ+ENwvuwFVOqBMKA5fdo3tp/qd49/uaW8nH72AQ6RH0m+ChL/hSePil3sIVMLcYDgQIGRyuYIyK50kr329kJJ1ewUcSMQnmoldvtm1ttlE1yQZLfDKwFTgNYj08wfJdUx2BdnDVr5kteKBGIvQVLFmWLW7tvL9tKYO+dDujKGbX6htQ55A0nWA2rvPfe7YR+LHiHJkr5CJxHblcM9RItcDzguF2S7ZAOH9AfvFGRLWT1iuetxymo/URRKPENmqXpnd29uf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(6506007)(5660300002)(6512007)(8936002)(26005)(8676002)(2906002)(86362001)(1076003)(66946007)(66556008)(16526019)(186003)(66476007)(36756003)(6666004)(956004)(4326008)(44832011)(7416002)(2616005)(83380400001)(478600001)(316002)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZKFetZzAhXrJ4BUaIcb0iTwGlNzqXX8GhzwX05QQO2bw030GpeZFngDikZQrMwhOrWHrB+B//Xj0zK7wzQ7QHoRDcTJ6HSmBBhze9UCJBMK9bUXx3u3e6ejS+KYjbKcgQQod1x7dCU9y5x+4JaS95mupqEPzsfDwEOylRbyU6pQflNwU5b4+N8K09xS+XZhA+CKSywi+cCt57QB+RUE4L2W1VU5Pl9Rq5Ro2SkY8rTz1RX5dff4ndSbJK7J/SRFK+Q5Yf8iZlnDIU14NipzcADsyKS9dT2ycN0uuPIA8Lt0Q4Fb7DVZmUF22KPI/WWfxyH13xjIe4PoUwTzWUGG2H0tm0uq+L2KvIT4OIbNHp1V4hTCSbf2d92c8iXtHpwmD2zxHQ6mwzJkcHXPCirQyf4jubC9DAt288yTdzNLUzXa3nSGJQnB5PcL/Z0wn7biTUUTq/NVZaz6q/x7LL4K7n3LrgCenNJTTynmdf6VoSVg=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 522f5fb5-179c-4497-ae13-08d8173f43d6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 06:32:56.4314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFvO0TniyXbfGmheZK+WsI8oVj9ykuSA3cHmP4fHvIc2Q/7J7dBorUelP44xtKrI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6688
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

