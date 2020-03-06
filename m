Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F214E17BDFA
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgCFNQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:16:24 -0500
Received: from mail-vi1eur05on2043.outbound.protection.outlook.com ([40.107.21.43]:32801
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726300AbgCFNQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:16:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNjIArPh1W2nzBRTFUjBNEGEll1jDDONWxcMicG4y04htgn1kIII2kUL1qpGZwx4cjbflRhSaSpFauBPqym/qyP3m4hhLMO5DysVJrIsklNUlyQWxK9FJzVwiDdh4jqp9xmCw1CfpgBXhTpAAVyErqM3QG1O7r1Av3BCL5FYVQMe1gfPv3Gvj71nXw69tXUsz2fAcsnCu4aScRpld+nRdBIrDuIwrYz3Qp2K+reZ8UmbLFJR96WUySt2RvCJgLw+2i4kRx01s3eTrREMDmkrTxVbrAtGwMcaRVFEnz1QGTdh2bUupoAhcXqpEDYemKgjGXXoeN/9R8gwRzRgFBDJjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXBk4ES+WGyBvWciufm7cKTGE3ju0nVQAoVICXGN6yE=;
 b=lhKHq7RZbs2JCkJ1f41+pHNVMUG1us1Ip1vLAXfg0SZqsfvMzzCWk9TxCf8tWvJOAbcK2wq9mNgwyaQ4z4NVXTuY33GStF7xxe2spgBipsCwbm8HItGyTkI2kPe6e+eMgqgbZGN4wsYQidaUBmNI6B9Fej2VLlCB1IKfIOmlVP/otlebtDHYxpc+O8J079MiCfMiEE+hJGEtvhtA4redEGW65sDtipY4qMkZpnhumrs0AqM1jGFaNXoTo2uVvYFF+tXrAAuThcawWVkZkIyd+2mI9GR/Sk8nK98E0qh3Q3mT8LMXDlTRNIckptVIf/O0TvhUcp55feqx7IXSP+1u9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXBk4ES+WGyBvWciufm7cKTGE3ju0nVQAoVICXGN6yE=;
 b=UhQ6OTgJOIsnQcYswGRr/wa5qxm08ok/8myMO0shmssppg3+LEZLy94j8b3NqcTJId6VPvj81q+TmfEoLmDCU4JfDiIgUNkCTlHui2YoNu9gwo2qBTeQwoEcf+RBUy1R21miAGIgc6WhEkMr7/fZ4J5xJigBGgrVUN+1yikmcQI=
Authentication-Results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6527.eurprd04.prod.outlook.com (20.179.233.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Fri, 6 Mar 2020 13:15:42 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 13:15:42 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        john.hurley@netronome.com, simon.horman@netronome.com,
        pieter.jansenvanvuuren@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, ivan.khoronzhuk@linaro.org,
        m-karicheri2@ti.com, andre.guedes@linux.intel.com,
        jakub.kicinski@netronome.com, Po Liu <Po.Liu@nxp.com>
Subject: [RFC,net-next  7/9] net: enetc: add support max frame size for tc flower offload
Date:   Fri,  6 Mar 2020 20:56:05 +0800
Message-Id: <20200306125608.11717-8-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200306125608.11717-1-Po.Liu@nxp.com>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0205.apcprd06.prod.outlook.com
 (2603:1096:4:68::13) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR06CA0205.apcprd06.prod.outlook.com (2603:1096:4:68::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Fri, 6 Mar 2020 13:15:32 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ecc8db5-beb0-43f7-28e5-08d7c1d0785c
X-MS-TrafficTypeDiagnostic: VE1PR04MB6527:|VE1PR04MB6527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB65275FCCFC44F26A357DB6AA92E30@VE1PR04MB6527.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(189003)(199004)(16526019)(186003)(26005)(66476007)(6512007)(4326008)(36756003)(66556008)(7416002)(6666004)(86362001)(478600001)(1076003)(81156014)(8936002)(6506007)(316002)(81166006)(956004)(5660300002)(8676002)(66946007)(2906002)(2616005)(6486002)(69590400007)(52116002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6527;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oqo/FwTmxAo07//3Ew6Q9pgdcdMhflxZYLoB/Kgp9M2VRH4mJawvRnKPOMuBXvpyC8jX5ZAwWrenB8Mwv0yAcDEtloFUIABqN5EBouR8irjGv24muO518ECOzFFzD8vRPwtM1bCHN6gFMH22s/bWaq13IsFldIjcUt60ElXb1rB/a8Y4/ZXDotAy1ro6BP3KMXyEtuGQ1mXo1lmb5fu+OOfN1xulaWUMzr8gXuxb8WQO198fSps1BGxDSPHG5RSEqBQ2mf4RffErj246TZMLW8xlpsue8g4T6bvsFEtnDbQ+7czwa8XAPJKNCYobFXHl0ETQA1tXxB6UChGp7Z1v4MCAF99K8X/c0vxtkthcPihzhlK/8ABD/pl5/CAqTS5lKr7Fboz5uTbksTXqyRLzLqg98QEi2P0VNMaCYJKQAkmVzUb3XZZml5Pbu1LqY50BKv0GBs3AgotNFdJAWaTScxIzP9a8MKT4JSG/0zONXonhKotDzJVEPjgLv/LrZIak7DJS+a5mR+cYdTMnZfsnbA==
X-MS-Exchange-AntiSpam-MessageData: XKDCtcDdHmOtKWDmfPs0/6MNKSxSaspzYsU4wMp4u1Eeno3zp7fcuzec8xVSVSvw8g2MeT60sLo7K2jqkf0YNimTA47U61f59eorY8J/UtqnVFkCqCyZblnHcm1+c1HapA5Eyu54N3qTbPMrwKVdYw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ecc8db5-beb0-43f7-28e5-08d7c1d0785c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 13:15:41.8965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5LTP5An832VM8YwCfY+ZoNDkZ9Mjqmc8/65OBSwmm9hilUF65qmTOgBVaCZIGWP+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6527
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Base on the tc flower offload police action add max frame size by the
parameter 'mtu'. Tc flower device driver working by the IEEE 802.1Qci
stream filter can implement the max frame size filtering. Add it to the
current hardware tc flower stearm filter driver.

The limitation is the police action must add burst size and rate per
second. Driver ignore the parameter 'burst' size and 'rate_bytes_ps'.
Next driver patch would make burst and rate  to the flow metering
function.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 52 +++++++++++++------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 3ef46190d71d..278f1603b00a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -388,6 +388,7 @@ struct enetc_psfp_filter {
 	u32 index;
 	s32 handle;
 	s8 prio;
+	u32 maxsdu;
 	u32 gate_id;
 	s32 meter_id;
 	u32 refcount;
@@ -429,6 +430,12 @@ struct actions_fwd enetc_act_fwd[] = {
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
@@ -593,8 +600,12 @@ static int enetc_streamfilter_hw_set(struct enetc_ndev_priv *priv,
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
@@ -860,6 +871,7 @@ static struct enetc_psfp_filter
 	hlist_for_each_entry(s, &epsfp.psfp_filter_list, node)
 		if (s->gate_id == sfi->gate_id &&
 		    s->prio == sfi->prio &&
+		    s->maxsdu == sfi->maxsdu &&
 		    s->meter_id == sfi->meter_id)
 			return s;
 
@@ -965,6 +977,7 @@ struct actions_fwd *enetc_check_flow_actions(u64 acts, unsigned int inputkeys)
 static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 				      struct flow_cls_offload *f)
 {
+	struct flow_action_entry *entryg = NULL, *entryp = NULL;
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct enetc_stream_filter *filter, *old_filter;
@@ -983,9 +996,12 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 
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
@@ -1044,37 +1060,37 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
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
 		goto free_filter;
 	}
 
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
@@ -1090,6 +1106,10 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
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

