Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D110348796A
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347981AbiAGPBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:01:18 -0500
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:26369
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347969AbiAGPBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 10:01:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMSElkhWBJ27e193MZ+Czk8eXBAkT5PFB1vviyyQKfkrrsiyVcGtPPQyOlwDvyiTq2hkMeUBuePKUHv+7zHrL0cK2fbJE/MZzXkkt41C4ZyyKgQVpRvfgO5RdYIfI9BcH+7S2Y3SleuIm0963r2r9/XKtCONisLCKTgoIxC/zA0VtK/vOfeHQ7Q1bIKuv0vBJCptJim/6dcVhOjLn6jbCaIcYaAMBn9kIafAgvjkq6SbzKBfq3PWj3nN6mPZu046Ze/CK2dQA/Nfi8Ybp2c/XeyWEQIOrz90wrb9x5s26UzfJkLaOkvtTSaUgZ8i2rFMzxI+fJOR0GctsouYELg6XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tw5C5IE/T/W16DhYSMgAtVU10O9XHHQr265v1Qc7d3U=;
 b=lCkdYA8bUKp48bBFcZuIJ1r5HnvcxIOezaC80ZsAHI70j6C0VvEG+gNK8ln6pyHXsC319pY0JWJ1JldPGwKupAxYMiSR4PKQ9k8OtQqz44e7Zxl8g1KaKzN5jhRrbfOZk49s2RtBIgaCff6q1Rf9ANzKay2JyRxQ3bZOROxSpQvCZc1p7RIC33xdv/4sIML77NQhhLRtD0LSwrUd0ixP2d+8jk45aqZV2bJUl5hKtH/ox2h2f+m9A4Iiu++fQBB1K3VDXQBmWFd9GB8u3QX0XYzYHw+rK9rWwxWdEEKoz0nIZKiaJ3uorRWRM4C4buLPpG2yNnOl0Hl+XUMQOXmctw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tw5C5IE/T/W16DhYSMgAtVU10O9XHHQr265v1Qc7d3U=;
 b=BPh5crVYf9zM/F0pO1Rk8C5ZKonruaNHgLQHtLH4uBvCjNMNLwNyndU+KVnjr8KWeWz8x43xIfwZ162gVIKY+TSKPtw1Gn4SgY8RT/leEyHXTjcG3t8HhbFeOeYxo/qeE97ZTBAJyfW6sOSOAypScad/nCyDINTCIS7fSJ7ivHE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 15:01:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 15:01:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next 02/12] net: dsa: mv88e6xxx: rename references to "lag" as "lag_dev"
Date:   Fri,  7 Jan 2022 17:00:46 +0200
Message-Id: <20220107150056.250437-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107150056.250437-1-vladimir.oltean@nxp.com>
References: <20220107150056.250437-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d685891a-b635-4750-d4f8-08d9d1ee8971
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34089F6FB000449EAFFC0EEEE04D9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qyiGPHIxgbnQwQhjXE9RJI5RvXvrt4jxroG25Wy6VY2RJOoAEf++dTC3uFzH6kAYkA87H2z0xn2KwX520eo8fnLNj8Gfil8rxq6/qBVCv2XrMn2BIqktEyJf8bw9hvkDnGxs63nP83UcFAG+MZs/0FBeLmpd2O7TxjCykmbcDmITa1j09RMHv0hoXxc6yDU/nXzJ3Hu0npo8NMZWHU+Jkh2jbmUIs9ey/8VsHDZ5eIQRyv+mVpZEIWmVUdQDoju3rxwx3yxdilMl1Sjf6iDA0bZClDplFspFmNXgLdVW1+sjJkv7uSl0zAc4pA7rVFjeBm2actuViVK0WR3dPiWRJbTYVcY9YKg02C4IgiH5cTcfT/lWWkSkmBYsk5QwMFw/xy6VYAvJosA8OU2+QYvSfwFpqLcqHbwRvMQeSA1N8IGzQjCPiPEIVdODZE43JMfX2T2+lL7nEcNyjqNcLF3ewd1BziID4tmAc/v+LI3WWsjfO/3DhSroShOD7plZRtrPg2CsxtTLx+9NPIH6elctSK4x7YYGBTobrk4ZxgjjMuPpK1D9/n6z0LdjFqU/ejc/qxQGsTvGrVUZ68hlqGWq/IODCv7WR17SkeVp1v3bU1tRRq3KzqB+2Hh7vQo+b+0w7bc8eBKY+i003x8Rs1bKBdsyrPTcp2JK3coCjyIkR7lAmO4jtVY4kieN33e1E0NSolFDA0hZzmpqVaQf0eamnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(1076003)(8936002)(6512007)(8676002)(2906002)(44832011)(4326008)(86362001)(38100700002)(316002)(2616005)(36756003)(6916009)(6666004)(83380400001)(54906003)(508600001)(6486002)(186003)(6506007)(52116002)(66556008)(66476007)(66946007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DuAAvjNlFxzMwSP8EKYnACrClJDlhsDEwlnd4YNNdIVm1WjdvrQB8RHjP3pX?=
 =?us-ascii?Q?Gfex2ymJJg50wwM5xkOMQb9ZAOCJTCjRnBQa+brR/G65Y0+/iKvVfSfKeXWn?=
 =?us-ascii?Q?UwsojDphrD/0F+gVNdeQCK5vL+lXMZUhZXWI//i5NSqibTvn+GP+rtiqmIWx?=
 =?us-ascii?Q?wi+j1kbnEastJnHHYwPx1OJKpJuw6opuMxA7uqa055ikRRwSC4qMqmkKy2bi?=
 =?us-ascii?Q?BQtaKTMICIGvd2Qco02XGBQdvuQfZyuGxQJe4e0fbaCNYnAaTG+Qs6bMlWD/?=
 =?us-ascii?Q?tSrxPfcYusQ0LNY828gdiPuAPVm8Bi2DKggxPvb0QIMQtPVRZ2ZjIZBve+eQ?=
 =?us-ascii?Q?jlyrok7KbGym9f8y/Yi82LIeD1LeAlzTQBzCtMWfXbHBD5MGokywV/EKP4Rk?=
 =?us-ascii?Q?MR8kY0CH9h9PUTxHPsUSqFd+mK163eQMDDqFHCgChd6P331nm0MAJllyk/jy?=
 =?us-ascii?Q?9D9lTsvkR0KiMESvv4D7MaVgVMYDYMMzSJ6ro49SOjSgP/ZYstoH3muZVsMx?=
 =?us-ascii?Q?IlUAqvZzptJBTeaIcWPJEX3MVIaHlpPm+UMmjEJ9GEojwgkZxleGw+P5D35F?=
 =?us-ascii?Q?VIz27VKkN5BKC5dKVasebN9Tj7NTTlpIQw9FRjiSuiXOAWNOfJq08ve7/YF0?=
 =?us-ascii?Q?VfdnavFjzotbwRPvrW0K0+jacQ7RHVj7C6g/6nVl9uzRJto7aa1ljBPT/dFV?=
 =?us-ascii?Q?J3ZqxnQbuBpp791Mlcn0fbuHVNQhY9BzsI6gYR0wSxC8nyMTqJjxGndL+0sb?=
 =?us-ascii?Q?MLrfW6fxl2maLxSNIF1TY+siUWRBpy9YKXULtCnu4JAXSmFjRr8Q8Y6yYYNZ?=
 =?us-ascii?Q?Vbo/CsSo526lJqtqRW7Aqfs1CYI+zYj6wpgos2Tak0ckZjPRlI2QZaqjyXVO?=
 =?us-ascii?Q?YsbZ4M8OvMbJaxSqJDH92FmydlfuIO3HL1EA9G4jx1k7SgHo0X9KG1ZmVXAx?=
 =?us-ascii?Q?GewCR/NYGDgx4fID++lMI/pgAuz9fJbsYzIup2Ydr5xY/2gi8yvyyDrTNpI0?=
 =?us-ascii?Q?08foArMVER34OEYV+aDgN/YlrM/v6xnnDZiH0gogf8gDquiHih2KWhSYLarp?=
 =?us-ascii?Q?98AB+44ZF+f16VfFz0gARBHOTum4H8QTn3aZX2MGdJGp+D2ZZtEisnKwfKnk?=
 =?us-ascii?Q?Syco9VoYwtkEKutRjRq8bm1XHIIob/wLqc+KUx3Sl/jE/5tL4kfCYAMe7jI5?=
 =?us-ascii?Q?/LdpeYoWb6ifzmr8sPU6XlTXLlcKKUfY6vRykhn77nw8nZNd8GC+Y9PfOpI1?=
 =?us-ascii?Q?cmH9abqzpCTOQkZ639Sh0t2i8lOVNwRsHSWplsIAzcByPfN8LKQM0X+N9Vw5?=
 =?us-ascii?Q?RruuLDkDKph2Szcg1QoJ6cm/RTx9/Unb6I5k6DXBXTMKgkGATGjvq5WZGyKu?=
 =?us-ascii?Q?K+8f2uzYVTlglxhDDgHLo1kequie9VZQ8IQOhVVtccvFLCUYmCTB1Yvr3KLp?=
 =?us-ascii?Q?zRHke+1R4Ynej9pb6XtmaSDdVi7gnGBP0EqufRUb/2B0aTkMGh/eu5Z5pE5Z?=
 =?us-ascii?Q?ngLD0q00J9QJP+niys3yFkphLEgEGvdrHHY/2Zo7Y82GTHI79C/uQf8TELd6?=
 =?us-ascii?Q?LNHIkvJSpVckqAoD2sgwXY5ndPCNhFPOAf+So/Ej70XShpB0sTrTipY+t+aS?=
 =?us-ascii?Q?0HHW+oYQOwksi8wUpFG4gJ0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d685891a-b635-4750-d4f8-08d9d1ee8971
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:01:08.9402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxVur/69veLWaI1BMWn/HDICseT/m1M+ToFIhM9h2lvfSGJ3sCpRqg5M+GIrcoNuWa+0uTxSsZlIdjO2NKvTXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of converting struct net_device *dp->lag_dev into a
struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
all occurrences of the "lag" variable in mv88e6xxx to "lag_dev".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 49 ++++++++++++++++----------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 58ca684d73f7..ba56c79b43d6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5946,7 +5946,7 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
-				      struct net_device *lag,
+				      struct net_device *lag_dev,
 				      struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
@@ -5956,11 +5956,11 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 	if (!mv88e6xxx_has_lag(chip))
 		return false;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 	if (id < 0 || id >= ds->num_lag_ids)
 		return false;
 
-	dsa_lag_foreach_port(dp, ds->dst, lag)
+	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
 		/* Includes the port joining the LAG */
 		members++;
 
@@ -5980,20 +5980,21 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 	return true;
 }
 
-static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds, struct net_device *lag)
+static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
+				  struct net_device *lag_dev)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct dsa_port *dp;
 	u16 map = 0;
 	int id;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	/* Build the map of all ports to distribute flows destined for
 	 * this LAG. This can be either a local user port, or a DSA
 	 * port if the LAG port is on a remote chip.
 	 */
-	dsa_lag_foreach_port(dp, ds->dst, lag)
+	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
 		map |= BIT(dsa_towards_port(ds, dp->ds->index, dp->index));
 
 	return mv88e6xxx_g2_trunk_mapping_write(chip, id, map);
@@ -6037,8 +6038,8 @@ static void mv88e6xxx_lag_set_port_mask(u16 *mask, int port,
 static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	struct net_device *lag_dev;
 	unsigned int id, num_tx;
-	struct net_device *lag;
 	struct dsa_port *dp;
 	int i, err, nth;
 	u16 mask[8];
@@ -6062,12 +6063,12 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 	 * are in the Tx set.
 	 */
 	dsa_lags_foreach_id(id, ds->dst) {
-		lag = dsa_lag_dev(ds->dst, id);
-		if (!lag)
+		lag_dev = dsa_lag_dev(ds->dst, id);
+		if (!lag_dev)
 			continue;
 
 		num_tx = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag) {
+		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
 			if (dp->lag_tx_enabled)
 				num_tx++;
 		}
@@ -6076,7 +6077,7 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 			continue;
 
 		nth = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag) {
+		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
 			if (!dp->lag_tx_enabled)
 				continue;
 
@@ -6098,14 +6099,14 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 }
 
 static int mv88e6xxx_lag_sync_masks_map(struct dsa_switch *ds,
-					struct net_device *lag)
+					struct net_device *lag_dev)
 {
 	int err;
 
 	err = mv88e6xxx_lag_sync_masks(ds);
 
 	if (!err)
-		err = mv88e6xxx_lag_sync_map(ds, lag);
+		err = mv88e6xxx_lag_sync_map(ds, lag_dev);
 
 	return err;
 }
@@ -6122,16 +6123,16 @@ static int mv88e6xxx_port_lag_change(struct dsa_switch *ds, int port)
 }
 
 static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
-				   struct net_device *lag,
+				   struct net_device *lag_dev,
 				   struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err, id;
 
-	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
+	if (!mv88e6xxx_lag_can_offload(ds, lag_dev, info))
 		return -EOPNOTSUPP;
 
-	id = dsa_lag_id(ds->dst, lag);
+	id = dsa_lag_id(ds->dst, lag_dev);
 
 	mv88e6xxx_reg_lock(chip);
 
@@ -6139,7 +6140,7 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 	if (err)
 		goto err_unlock;
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	if (err)
 		goto err_clear_trunk;
 
@@ -6154,13 +6155,13 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_lag_leave(struct dsa_switch *ds, int port,
-				    struct net_device *lag)
+				    struct net_device *lag_dev)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err_sync, err_trunk;
 
 	mv88e6xxx_reg_lock(chip);
-	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	err_trunk = mv88e6xxx_port_set_trunk(chip, port, false, 0);
 	mv88e6xxx_reg_unlock(chip);
 	return err_sync ? : err_trunk;
@@ -6179,18 +6180,18 @@ static int mv88e6xxx_crosschip_lag_change(struct dsa_switch *ds, int sw_index,
 }
 
 static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
-					int port, struct net_device *lag,
+					int port, struct net_device *lag_dev,
 					struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
+	if (!mv88e6xxx_lag_can_offload(ds, lag_dev, info))
 		return -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	if (err)
 		goto unlock;
 
@@ -6202,13 +6203,13 @@ static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
 }
 
 static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
-					 int port, struct net_device *lag)
+					 int port, struct net_device *lag_dev)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err_sync, err_pvt;
 
 	mv88e6xxx_reg_lock(chip);
-	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
 	err_pvt = mv88e6xxx_pvt_map(chip, sw_index, port);
 	mv88e6xxx_reg_unlock(chip);
 	return err_sync ? : err_pvt;
-- 
2.25.1

