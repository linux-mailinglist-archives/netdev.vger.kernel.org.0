Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A36A2049FE
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731211AbgFWGdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:33:19 -0400
Received: from mail-eopbgr60071.outbound.protection.outlook.com ([40.107.6.71]:22662
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730635AbgFWGdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 02:33:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgRYkrwmidFCybGk6oAUyNUj+5kDP4xyY4ZCIqtoWkw7e07NEQLBmcxLM5R/pwtkb3LQAxDwzye08Bpd+6fil13RmlGEVgFE5cLkfsKT/DhOTVwax3ai4a6I5HNX85DGYFg32TxG3oN0Gx7kxh5YnRNdvZBUtU9WlBwLfdPEjqdpFIzyl5/XzNfswnsOen/dw7D9tJCyU8vOWQ+8HzyET6xeJj07vZMVyOI45nKo6vv1+poo4lPdwMbJGId6vpS2nhnCKSFm/TZJorHB20eNyTsti9GbNdcnwYrP/b2LKw6JpaxGJf7HiDbpaC6BgUMgml/UgmkHlUjZ8mcQeBSyqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9eKvn5VAuc87bXOoy+Czi6VGwdHVOnK9nP4mcsC8dY=;
 b=imNArRJVWWcGcE6hg0lmdvQTX5qZfibRa2BTGnk0QVrrfl5AfvG9LRWJQz2KXZEKyaGdV50jqdEndJcJXQ4o8E7ICEMom6K7M3cyYphlLlqR6zv1sVZdMk7SfHN+f+iv73XEeGO+N2ZSrN+MtBJ5i/2Bz8obqn6HLA6fNb+J+ItblG9b8lW0NkFWJfzD9ZX8RwJFKfKQv5c07A3wqk9BRwYf18cdstfdYeVXV7OYoayAs4YeVp9TqOT8b4sCNpION1z3IZflrCGnNQ5G9/iKRNUIRnyKpNLNCHggF+YVF+T8udixgcB65RcNnoPTk4maIHv4n3iuOcXrv2IHmvPizQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9eKvn5VAuc87bXOoy+Czi6VGwdHVOnK9nP4mcsC8dY=;
 b=V/GhyuD6y3XgcU/xj6mlfr7dR1b+rtci5LWMXmO9bnnDP30G08YYZDNua6HDvfOE0MrEnG7LgOyZCmLzVIOy7nqsX7jHyNoMCuHRxcHJh8cTdtJJZgNcgAkP6gPfEAF+NCYwcU5mxnpmNIxg6kv8Fd1Erg0/7LKUG3/lpCNjOpc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6688.eurprd04.prod.outlook.com (2603:10a6:803:127::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 06:33:14 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 06:33:14 +0000
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
Subject: [v1,net-next 4/4] net: enetc add tc flower offload flow metering policing action
Date:   Tue, 23 Jun 2020 14:34:12 +0800
Message-Id: <20200623063412.19180-4-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200623063412.19180-1-po.liu@nxp.com>
References: <20200306125608.11717-7-Po.Liu@nxp.com>
 <20200623063412.19180-1-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::15)
 To VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tsn.ap.freescale.net (119.31.174.73) by SGAP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 06:33:05 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 84bb74d2-cff2-4ae6-4d3d-08d8173f4e41
X-MS-TrafficTypeDiagnostic: VE1PR04MB6688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB66886E976D83921B84DEDBD992940@VE1PR04MB6688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ufyHrnkLvNBWFlFjf9dVeOt3ZHOEhjeW00S5dPEo1MO40Z4RxiVVDNxExIgfgT6UQo9g0Aw8XcXCUaOqgZTPTE9jkXNZQHEEWhZlSaBFxfqM3AM/19BVKamOy7g9r2INK4sgDVxoPI7kMdQU87K6OuzZj4RpeATIMC71Z1IDjqgtmdpbLMu98HMGMsAhmwtd5YpUR86lLEepBP10rQKgEUYNr0IuEerd8+3xH9PuxsvzoL+XEgDtXOyqP3EqWEFQTNnYMnz8VqcPgPCh+988OjNCFEdarhKm6EfUuYGgvMOHwI/ZcnFVC5IONGbIwUHs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(6506007)(5660300002)(6512007)(8936002)(26005)(8676002)(2906002)(86362001)(1076003)(66946007)(66556008)(16526019)(186003)(66476007)(36756003)(6666004)(956004)(4326008)(44832011)(7416002)(2616005)(83380400001)(478600001)(316002)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1PK5E273j8HetaaoDz4IM8iOOBOWWbcgjwFSvoyLxoNaKAlS5RrBpgqZ/8RkYQOXc4Uenr5NpOyMbDjOFJh8WxBBPR3cZYVkrA8U6USKhVJ8K3cbwcIwRQgVIBRyw6qSR5XE+i1sS1F1AhNpRqQzCLPdq0mPgQMjlo32WM7Aga7cTwL7vsmGzvJoKlr5qGmynhGuctolkY750SqkC0ltOU5zZznERqmgsODfRAY22Y56xuWrZII3QhRjbxQABXDUgN3132eXPG54XyMS7bXsV90H8fPB3FV0IZ72BGgNV52+hOJkq9402Ru+TJ7lU8L7p8B9mr0vfdNgRi1ZN0DeuWvt84S60RheBLXrq93wKGnUuqmhJFFNuVcrMZo0pMETyAbJvw4SAs/VlLXzNdwHWNwnY0Zm2TVrbb5AYg/LueRMwVJ0OCz+bFYoOXRNeudE60yVcBd+jh8TEwqFxiNnjh4k7Ut6VA5mh1CU+LfRHOY=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84bb74d2-cff2-4ae6-4d3d-08d8173f4e41
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 06:33:13.9274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGbbi5DcTL9qtnBdFq4j4kimUDwMVUFGzNe32t1xh/EWFJnkh+RBt3Hcc+SZbVQv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6688
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <Po.Liu@nxp.com>

Flow metering entries in IEEE 802.1Qci is an optional function for a
flow filtering module. Flow metering is two rates two buckets and three
color marker to policing the frames. This patch only enable one rate one
bucket and in color blind mode. Flow metering instance are as
specified in the algorithm in MEF 10.3 and in Bandwidth Profile
Parameters. They are:

a) Flow meter instance identifier. An integer value identifying the flow
meter instance. The patch use the police 'index' as thin value.
b) Committed Information Rate (CIR), in bits per second. This patch use
the 'rate_bytes_ps' represent this value.
c) Committed Burst Size (CBS), in octets. This patch use the 'burst'
represent this value.
d) Excess Information Rate (EIR), in bits per second.
e) Excess Burst Size per Bandwidth Profile Flow (EBS), in octets.
And plus some other parameters. This patch set EIR/EBS default disable
and color blind mode.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  24 +++
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 160 ++++++++++++++++--
 2 files changed, 172 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 6314051bc6c1..f00c4382423e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -570,6 +570,7 @@ enum bdcr_cmd_class {
 	BDCR_CMD_STREAM_IDENTIFY,
 	BDCR_CMD_STREAM_FILTER,
 	BDCR_CMD_STREAM_GCL,
+	BDCR_CMD_FLOW_METER,
 	__BDCR_CMD_MAX_LEN,
 	BDCR_CMD_MAX_LEN = __BDCR_CMD_MAX_LEN - 1,
 };
@@ -736,10 +737,33 @@ struct sgcl_data {
 	struct sgce	sgcl[0];
 };
 
+#define ENETC_CBDR_FMI_MR	BIT(0)
+#define ENETC_CBDR_FMI_MREN	BIT(1)
+#define ENETC_CBDR_FMI_DOY	BIT(2)
+#define	ENETC_CBDR_FMI_CM	BIT(3)
+#define ENETC_CBDR_FMI_CF	BIT(4)
+#define ENETC_CBDR_FMI_NDOR	BIT(5)
+#define ENETC_CBDR_FMI_OALEN	BIT(6)
+#define ENETC_CBDR_FMI_IRFPP_MASK GENMASK(4, 0)
+
+/* class 10: command 0/1, Flow Meter Instance Set, short Format */
+struct fmi_conf {
+	__le32	cir;
+	__le32	cbs;
+	__le32	eir;
+	__le32	ebs;
+		u8	conf;
+		u8	res1;
+		u8	ir_fpp;
+		u8	res2[4];
+		u8	en;
+};
+
 struct enetc_cbd {
 	union{
 		struct sfi_conf sfi_conf;
 		struct sgi_table sgi_table;
+		struct fmi_conf fmi_conf;
 		struct {
 			__le32	addr[2];
 			union {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 07f98bf7a06b..2d79962daf4a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -408,10 +408,26 @@ struct enetc_psfp_gate {
 	struct action_gate_entry entries[0];
 };
 
+/* Only enable the green color frame now
+ * Will add eir and ebs color blind, couple flag etc when
+ * policing action add more offloading parameters
+ */
+struct enetc_psfp_meter {
+	u32 index;
+	u32 cir;
+	u32 cbs;
+	refcount_t refcount;
+	struct hlist_node node;
+};
+
+#define ENETC_PSFP_FLAGS_FMI BIT(0)
+
 struct enetc_stream_filter {
 	struct enetc_streamid sid;
 	u32 sfi_index;
 	u32 sgi_index;
+	u32 flags;
+	u32 fmi_index;
 	struct flow_stats stats;
 	struct hlist_node node;
 };
@@ -422,6 +438,7 @@ struct enetc_psfp {
 	struct hlist_head stream_list;
 	struct hlist_head psfp_filter_list;
 	struct hlist_head psfp_gate_list;
+	struct hlist_head psfp_meter_list;
 	spinlock_t psfp_lock; /* spinlock for the struct enetc_psfp r/w */
 };
 
@@ -842,6 +859,47 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 	return err;
 }
 
+static int enetc_flowmeter_hw_set(struct enetc_ndev_priv *priv,
+				  struct enetc_psfp_meter *fmi,
+				  u8 enable)
+{
+	struct enetc_cbd cbd = { .cmd = 0 };
+	struct fmi_conf *fmi_config;
+	u64 temp = 0;
+
+	cbd.index = cpu_to_le16((u16)fmi->index);
+	cbd.cls = BDCR_CMD_FLOW_METER;
+	cbd.status_flags = 0x80;
+
+	if (!enable)
+		return enetc_send_cmd(priv->si, &cbd);
+
+	fmi_config = &cbd.fmi_conf;
+	fmi_config->en = 0x80;
+
+	if (fmi->cir) {
+		temp = (u64)8000 * fmi->cir;
+		temp = temp / 3725;
+	}
+
+	fmi_config->cir = cpu_to_le32((u32)temp);
+	fmi_config->cbs = cpu_to_le32(fmi->cbs);
+
+	/* Default for eir ebs disable */
+	fmi_config->eir = 0;
+	fmi_config->ebs = 0;
+
+	/* Default:
+	 * mark red disable
+	 * drop on yellow disable
+	 * color mode disable
+	 * couple flag disable
+	 */
+	fmi_config->conf = 0;
+
+	return enetc_send_cmd(priv->si, &cbd);
+}
+
 static struct enetc_stream_filter *enetc_get_stream_by_index(u32 index)
 {
 	struct enetc_stream_filter *f;
@@ -875,6 +933,17 @@ static struct enetc_psfp_filter *enetc_get_filter_by_index(u32 index)
 	return NULL;
 }
 
+static struct enetc_psfp_meter *enetc_get_meter_by_index(u32 index)
+{
+	struct enetc_psfp_meter *m;
+
+	hlist_for_each_entry(m, &epsfp.psfp_meter_list, node)
+		if (m->index == index)
+			return m;
+
+	return NULL;
+}
+
 static struct enetc_psfp_filter
 	*enetc_psfp_check_sfi(struct enetc_psfp_filter *sfi)
 {
@@ -934,9 +1003,27 @@ static void stream_gate_unref(struct enetc_ndev_priv *priv, u32 index)
 	}
 }
 
+static void flow_meter_unref(struct enetc_ndev_priv *priv, u32 index)
+{
+	struct enetc_psfp_meter *fmi;
+	u8 z;
+
+	fmi = enetc_get_meter_by_index(index);
+	WARN_ON(!fmi);
+	z = refcount_dec_and_test(&fmi->refcount);
+	if (z) {
+		enetc_flowmeter_hw_set(priv, fmi, false);
+		hlist_del(&fmi->node);
+		kfree(fmi);
+	}
+}
+
 static void remove_one_chain(struct enetc_ndev_priv *priv,
 			     struct enetc_stream_filter *filter)
 {
+	if (filter->flags & ENETC_PSFP_FLAGS_FMI)
+		flow_meter_unref(priv, filter->fmi_index);
+
 	stream_gate_unref(priv, filter->sgi_index);
 	stream_filter_unref(priv, filter->sfi_index);
 
@@ -947,7 +1034,8 @@ static void remove_one_chain(struct enetc_ndev_priv *priv,
 static int enetc_psfp_hw_set(struct enetc_ndev_priv *priv,
 			     struct enetc_streamid *sid,
 			     struct enetc_psfp_filter *sfi,
-			     struct enetc_psfp_gate *sgi)
+			     struct enetc_psfp_gate *sgi,
+			     struct enetc_psfp_meter *fmi)
 {
 	int err;
 
@@ -965,8 +1053,16 @@ static int enetc_psfp_hw_set(struct enetc_ndev_priv *priv,
 	if (err)
 		goto revert_sfi;
 
+	if (fmi) {
+		err = enetc_flowmeter_hw_set(priv, fmi, true);
+		if (err)
+			goto revert_sgi;
+	}
+
 	return 0;
 
+revert_sgi:
+	enetc_streamgate_hw_set(priv, sgi, false);
 revert_sfi:
 	if (sfi)
 		enetc_streamfilter_hw_set(priv, sfi, false);
@@ -995,6 +1091,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct netlink_ext_ack *extack = f->common.extack;
 	struct enetc_stream_filter *filter, *old_filter;
+	struct enetc_psfp_meter *fmi = NULL, *old_fmi;
 	struct enetc_psfp_filter *sfi, *old_sfi;
 	struct enetc_psfp_gate *sgi, *old_sgi;
 	struct flow_action_entry *entry;
@@ -1139,13 +1236,34 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 
 	refcount_set(&sfi->refcount, 1);
 	sfi->gate_id = sgi->index;
-
-	/* flow meter not support yet */
 	sfi->meter_id = ENETC_PSFP_WILDCARD;
 
-	/* Max frame size */
-	if (entryp)
-		sfi->maxsdu = entryp->police.mtu;
+	/* Flow meter and max frame size */
+	if (entryp) {
+		if (entryp->police.burst) {
+			u64 temp;
+
+			fmi = kzalloc(sizeof(*fmi), GFP_KERNEL);
+			if (!fmi) {
+				err = -ENOMEM;
+				goto free_sfi;
+			}
+			refcount_set(&fmi->refcount, 1);
+			fmi->cir = entryp->police.rate_bytes_ps;
+			/* Convert to original burst value */
+			temp = entryp->police.burst * fmi->cir;
+			temp = div_u64(temp, 1000000000ULL);
+
+			fmi->cbs = temp;
+			fmi->index = entryp->police.index;
+			filter->flags |= ENETC_PSFP_FLAGS_FMI;
+			filter->fmi_index = fmi->index;
+			sfi->meter_id = fmi->index;
+		}
+
+		if (entryp->police.mtu)
+			sfi->maxsdu = entryp->police.mtu;
+	}
 
 	/* prio ref the filter prio */
 	if (f->common.prio && f->common.prio <= BIT(3))
@@ -1161,7 +1279,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 		if (sfi->handle < 0) {
 			NL_SET_ERR_MSG_MOD(extack, "No Stream Filter resource!");
 			err = -ENOSPC;
-			goto free_sfi;
+			goto free_fmi;
 		}
 
 		sfi->index = index;
@@ -1177,11 +1295,23 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 	}
 
 	err = enetc_psfp_hw_set(priv, &filter->sid,
-				sfi_overwrite ? NULL : sfi, sgi);
+				sfi_overwrite ? NULL : sfi, sgi, fmi);
 	if (err)
-		goto free_sfi;
+		goto free_fmi;
 
 	spin_lock(&epsfp.psfp_lock);
+	if (filter->flags & ENETC_PSFP_FLAGS_FMI) {
+		old_fmi = enetc_get_meter_by_index(filter->fmi_index);
+		if (old_fmi) {
+			fmi->refcount = old_fmi->refcount;
+			refcount_set(&fmi->refcount,
+				     refcount_read(&old_fmi->refcount) + 1);
+			hlist_del(&old_fmi->node);
+			kfree(old_fmi);
+		}
+		hlist_add_head(&fmi->node, &epsfp.psfp_meter_list);
+	}
+
 	/* Remove the old node if exist and update with a new node */
 	old_sgi = enetc_get_gate_by_index(filter->sgi_index);
 	if (old_sgi) {
@@ -1212,6 +1342,8 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 
 	return 0;
 
+free_fmi:
+	kfree(fmi);
 free_sfi:
 	kfree(sfi);
 free_gate:
@@ -1310,9 +1442,13 @@ static int enetc_psfp_get_stats(struct enetc_ndev_priv *priv,
 		return -EINVAL;
 
 	spin_lock(&epsfp.psfp_lock);
-	stats.pkts = counters.matching_frames_count - filter->stats.pkts;
-	stats.drops = counters.not_passing_frames_count -
-					filter->stats.drops;
+	stats.pkts = counters.matching_frames_count +
+		     counters.not_passing_sdu_count -
+		     filter->stats.pkts;
+	stats.drops = counters.not_passing_frames_count +
+		      counters.not_passing_sdu_count +
+		      counters.red_frames_count -
+		      filter->stats.drops;
 	stats.lastused = filter->stats.lastused;
 	filter->stats.pkts += stats.pkts;
 	filter->stats.drops += stats.drops;
-- 
2.17.1

