Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DBB437BEA
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbhJVRcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:32:39 -0400
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:23297
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231453AbhJVRcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:32:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llsccoPKABfZrKKVzYzn0CyJKvHVRZy0laPG9CHshrsdHQF3dzuyhdxk/ourCVDjemLbNzkwQwYoWUA58iG3eGaLc2A5TxnNNQOcmjbb8SbZQjRVi9PNmaRNlSeI5zznO43d1OILHZeAHrjDfTbxkL7tjzEOo6Uf3m+20XnldkuQiNrmum5qdI6kVt+uPcmYS8Zc27HdvLcioaiXBuDOSrbpN7PxFnM7i2pzQT+nAkKozJveAmDkPGTkGM1WH7AQX9mpwxGj89tMvQmnCzRWtp/ehHBROJCEwffBJAl7778QQp1o56ts2pmqkZe6LwR8k3lGn61xVZ0Rx3MEDclSbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5VQQCy61s7r6FeamGwTay6bwpoD011Vx8m2f3GX3gE=;
 b=ETb94En5pn+OGNeMdoq3T8R3jkYIjzAQYs8NyotrYngqJyN8yFB/UkIG9l2qGGA50BenQqqEPnDojALFNHeuu12Yuz5GoKaSdMWVMMOFVUXO92IrySjc3SfgoCmN1FONR5sDmOYsWrHS/ph3/mq0agvLj7+UyLXycR+7DynxSMYTWfOwEdTKHArj1FcqwVpcldD6bRaZ2VJYUEzYFBxsWoAG/yslOigOGpa8IM/LwJhmaiieLTAMdhKs2/PDbqiW40P51PDPCqFGGZaZgSErWyMwMQvbNtIhipXz1TfIq7hq+UaWXYfROwRHTxqvY+98uUq51RkwOLkgUu8MZygvgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5VQQCy61s7r6FeamGwTay6bwpoD011Vx8m2f3GX3gE=;
 b=EYowhAdwQAjjrj6OGG00Y0nb8S8TMt9qcfh/BCptJ4mV84CRJcKmMcTmTfuHdmJx5RJn5/48njHYneRYW7rMQMfD9FBXNcC5x+ygrjxenMkZvNeDnPZdH+rZ3FQf3vLkN0e5snH6z+xnULDGOyq6qLC61egzE7ePe6bKUDaVb9w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 17:30:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 17:30:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v3 net-next 5/9] net: dsa: lantiq_gswip: serialize access to the PCE table
Date:   Fri, 22 Oct 2021 20:27:24 +0300
Message-Id: <20211022172728.2379321-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0003.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0003.eurprd08.prod.outlook.com (2603:10a6:208:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 17:30:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05ad6115-b5c3-4d8c-4386-08d995819c94
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-Microsoft-Antispam-PRVS: <VI1PR04MB550460385A1498BE45D5CEA6E0809@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qflGNkPLhGkoJ2P6amv+l7/Xv/TO7OPucZn0wTpJU1bDqhpMscLWa+gnnbv0fwQKQtAMOpREjw0HuJ4oClrYHRzcd+arV+98B/H6vNtQMX69N1M2YZCsmMoDM+8mOZFBRzOtpBraZG1Rc3UrhCHbTqsycp5INHMM5yDRN0cjXHZHSRuBt71AwX/dDSV5aTmFvFC8SwguYn0Bp/+RINqcADuBFV4E1GgVK2o2Oc9gU4UrqAGy7fvJMlxu8nVQO+wwLj8AelpRmJz+tpQWZfhRDg2bwgdsliZjUtA3RuJHma8R1eVmNv5z9aJ+HSyq5pUutxijyoxbXkPEulWgohsTEIKpP7/gIBYBi4F5YGMMpQAB360OXeGXve1VrYuaSdhaUY2FlVxaWEM5P1KjucQgm5b7QU8qulgA+XEW1/8jK7rwG5QVH0VIhjzOIEUjfjqq7oum2MPYuRgfyYl1lBLJT9uVGbXsxxD29Xloacy5u1XPf+LjSh5apeDvn1se3Na1C6Xnxe94EfNwZxPDIi2CNbPOphro8J/q4yWJHjNdrTArljsIdBsbiaihADaYwLTdPNbwUV7yWo93THqVrZseAxFDPrAfyEGDjdiTH3qk/jMc7zXWLZSLavu1etQPaNPF163tDXypQUuxz/HPAkQQXVso7ynJZ2P7dPQ8CFZoKNXNk6QeDok+MeuBrn0Gr3539tJMZKz4CHvB4sDMhQIRvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(6506007)(83380400001)(4326008)(6916009)(52116002)(66556008)(38350700002)(38100700002)(66946007)(44832011)(6486002)(956004)(8676002)(2616005)(86362001)(36756003)(8936002)(6512007)(26005)(2906002)(66476007)(5660300002)(186003)(7416002)(316002)(54906003)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rteVHMZqk9TQgti+aLjxdB3JD80jRvuCbJKTE46BKtGyFNIrDnMgkIaz8sm1?=
 =?us-ascii?Q?6ghCgyua/SlUbnrQ0c/Vgj8r60vguTMKj80Rt87+NohST/ckP5P8cI4AstF5?=
 =?us-ascii?Q?b3PqjZG5dJI/K3bXP+nmPtffqD37JmGdjQLl49kmGFmwAPNq1pjoXUOlb9dQ?=
 =?us-ascii?Q?L85TblidXy4Xvfp+J35ujJHaP8ksC4eIord/IznxlBD2ckRL0UV3L0CgOlEO?=
 =?us-ascii?Q?wBS5bUKf5ig/d1LPnW23L14g/69/GaBIaIhnHYJoh0RTtJczOxcCPgkRdVX/?=
 =?us-ascii?Q?u458x4loZQMTGlU2Wi89dEAu/MErSXEakX5lYbJ3puWvBoDuFwx9eqBQF1NP?=
 =?us-ascii?Q?WkHHS1ld4xfID1YHd2oMeq7lMB87wHO7BwhkcZhmDQbJvq7eyfvXdIhD9v5w?=
 =?us-ascii?Q?k5UPt420FR7QN12StUH83PhJXahTh/wRZDiMOHOOWFz61UA63uP5gb8xhycX?=
 =?us-ascii?Q?Qzs52xE78OE452Z74hTA9wS5JEz38ZLw5YGZwPgVOCkkUoniN81tsKWO7ZzH?=
 =?us-ascii?Q?9TvE4W7YAajFlnI1wX0anttW030tAq1B6LIu5UowSqQqt6NPON0YGOMLJe9I?=
 =?us-ascii?Q?Yo87MEYmYAV5E9Oil2czwdDcpOkq+9r8fbBJ+RdeK/4fnf7HxSf50AiIxgIa?=
 =?us-ascii?Q?JG3FjmM6ZJmleLVJNGR/nH6FPjhHZWM9z5pkhL+5l82Rx6kvP2SFiz1ZDRs5?=
 =?us-ascii?Q?U8g3Fn9RIR30BRoKKf1xfD6xrgVTiEtQkSH/0O0Ubv2csQhop7BEJm4S8C8R?=
 =?us-ascii?Q?vnrVql/2sOzriB+7/OA/nhKVdz1Xa0QllCNxBxDiFXYkwvqcDApeHj8LoaNC?=
 =?us-ascii?Q?CLM8jMKgZxJyuWpuDCHoAJ0gpjeY7IdmKX5P/ltAK3CpM7mDIGNfxX/0kJyY?=
 =?us-ascii?Q?9PAIH/VQ5ehb4F/eWfaW3kC+1nAJBTdqxRDEJSEhfHzZHgn2YBh3VSfqffNX?=
 =?us-ascii?Q?AG35dhXzNumm7StVU5sYP9iqeH0Yi40OlRvf1ZW4KX98wFrIcfK5abJOdQnr?=
 =?us-ascii?Q?iD3x13BBxpiVxCzJUuF7NUrMowFqeWYZz9hTM+E2j0Ktu7kUjsCkFJNaATea?=
 =?us-ascii?Q?gUOs6SC3YLc14cZjS/kqiPU5QHm5v/ySVSiiQh/ZtTOzOz6PdmXg75QLXHGV?=
 =?us-ascii?Q?Usahk3BHPG/qMrP9n6+T7EKP2Pj55T2waDgM01l0t38tUtBrNSDK7L10xCJx?=
 =?us-ascii?Q?8RNT3HleAtPadKR5sEz/YKYRVMqv+F/EGxVOJeLStXfjMzmjc0pgKOJBTdFJ?=
 =?us-ascii?Q?E9ex/qjxX/jCFw/BZg5LfxNc7+i7t9L5h2W7n5MC8eMqKDJaSpXArdZYXFZx?=
 =?us-ascii?Q?/4AlXkWm+CSkuw48KxxjA0hmLjB4RBh35vL2j4ASGfHEkcUGIsmBPDwFZ57f?=
 =?us-ascii?Q?FMApcPbrrk3cAkcGyX+yWtxeHHtO/AkgMXPMWN/4+4BclBnPtWxFAkOcl/Ao?=
 =?us-ascii?Q?kr84Me+GwTil5G53JHg8qDYVhS48igMh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ad6115-b5c3-4d8c-4386-08d995819c94
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:30:16.1776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looking at the code, the GSWIP switch appears to hold bridging service
structures (VLANs, FDBs, forwarding rules) in PCE table entries.
Hardware access to the PCE table is non-atomic, and is comprised of
several register reads and writes.

These accesses are currently serialized by the rtnl_lock, but DSA is
changing its driver API and that lock will no longer be held when
calling ->port_fdb_add() and ->port_fdb_del().

So this driver needs to serialize the access to the PCE table using its
own locking scheme. This patch adds that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/lantiq_gswip.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index dbd4486a173f..27710f2c0753 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -276,6 +276,7 @@ struct gswip_priv {
 	int num_gphy_fw;
 	struct gswip_gphy_fw *gphy_fw;
 	u32 port_vlan_filter;
+	struct mutex pce_table_lock;
 };
 
 struct gswip_pce_table_entry {
@@ -523,10 +524,14 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSRD :
 					GSWIP_PCE_TBL_CTRL_OPMOD_ADRD;
 
+	mutex_lock(&priv->pce_table_lock);
+
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
 	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
@@ -536,8 +541,10 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(tbl->key); i++)
 		tbl->key[i] = gswip_switch_r(priv, GSWIP_PCE_TBL_KEY(i));
@@ -553,6 +560,8 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 	tbl->valid = !!(crtl & GSWIP_PCE_TBL_CTRL_VLD);
 	tbl->gmap = (crtl & GSWIP_PCE_TBL_CTRL_GMAP_MASK) >> 7;
 
+	mutex_unlock(&priv->pce_table_lock);
+
 	return 0;
 }
 
@@ -565,10 +574,14 @@ static int gswip_pce_table_entry_write(struct gswip_priv *priv,
 	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSWR :
 					GSWIP_PCE_TBL_CTRL_OPMOD_ADWR;
 
+	mutex_lock(&priv->pce_table_lock);
+
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
 	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
@@ -600,8 +613,12 @@ static int gswip_pce_table_entry_write(struct gswip_priv *priv,
 	crtl |= GSWIP_PCE_TBL_CTRL_BAS;
 	gswip_switch_w(priv, crtl, GSWIP_PCE_TBL_CTRL);
 
-	return gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
-				      GSWIP_PCE_TBL_CTRL_BAS);
+	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
+				     GSWIP_PCE_TBL_CTRL_BAS);
+
+	mutex_unlock(&priv->pce_table_lock);
+
+	return err;
 }
 
 /* Add the LAN port into a bridge with the CPU port by
-- 
2.25.1

