Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F094DB9A1
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352919AbiCPUnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358003AbiCPUnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:43:13 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30072.outbound.protection.outlook.com [40.107.3.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7E46E4CE
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:41:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nm7labUeEOc8CTlkzy7s5TCVMPL3cRKjwluRUajQ58W+en6gi9+7hpx/GsgvkvortpVmqqksr+yQMRojYY3yB0hWe1UvtCEjId2Ma66BDgX8uJz6p47i+v/FRwRMWONVdaQpXfDecH2bIQcydxtQ4UhgwLESLMwW52d5BPMQLfsbUXsRKVQZS05N7ieZJppIHfMhDbYBUjzAW5rMKLsVZ0Wen4RQ3FYFRAHJsO+qvWPy76QoBojQIjI1L3NUFETSDAgJNMDioinE0bsHPHp4aWOfmQ8qWkdjD4lPcQQHp3NX15B7dBlcq4HThK3Zr/w+HrVZikqz6KmQ0t0zV17AIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zSK4qY/h5RLh3AKzFZSGlvOmJIcy3i0pOk/MiHU2x0Y=;
 b=OUqIDvoMQSNrFCFPXlEN3SP4kZPX0ZErIyhYj4ar3oS92/NjmLvbvmJXX7fLGiZqYUIbSExhQ0T4dNW3rXNifnGjHPqIsPp/dWvynMFhdzR8WcKmMKI8lNk1PQOEpQF9JCClY2RikRYZdaPcB8JZoYOuKjWsqcdpYv1mQIfRk9gj30ChLrXfdUn0e8TIdSaqiC6as6ugytQPmoAxABWDP98uRHfM8/NmDwNsLPJyyMAPHiuG3sq7q27BUC3i7QC2LZ8wxK8DalQQdRyRxeGAcWe6SpjUWu9doRNSGNz3KsPMu7/ZYNf8HAN+IfubxsXrkOMYjR5rZ+LdPWqPaVlrgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSK4qY/h5RLh3AKzFZSGlvOmJIcy3i0pOk/MiHU2x0Y=;
 b=CTdelRfVdYHa3Tpjh/p6FdmG4TwlNlt3s9yN8kH1mjZhrn+a9/RmEKFouVc7pGgKkaI0oRJh17Rw0Rl+nTuo4g2EWO2PLvBXtxS9HdDEVY8ONdOOQX3+Okigxyet9zmra6edLCmnn6Of1nfW/Ndhy5LG4rwiDwJQcw/czv2QJMw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM9PR04MB8398.eurprd04.prod.outlook.com (2603:10a6:20b:3b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Wed, 16 Mar
 2022 20:41:54 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f%6]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 20:41:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/6] net: mscc: ocelot: refactor policer work out of ocelot_setup_tc_cls_matchall
Date:   Wed, 16 Mar 2022 22:41:39 +0200
Message-Id: <20220316204144.2679277-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
References: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0037.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::25) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5948152-001b-499a-a803-08da078d6837
X-MS-TrafficTypeDiagnostic: AM9PR04MB8398:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB83980FDB5018EFDE7FE06B01E0119@AM9PR04MB8398.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Psn8WwAHKafLkKaflp26HR8HUGOr0WQH7uE1EoRwz1A1la8mps/1w8lHNMeq8wBESdlr+36xtyNJMG9wU+KeiKoQn4t3ZmwSzEh2/y9zXTzalDQRhpFvfh7IBOZqrtHWFP5VPCDtQbAnAxc7XI627/LXT45g2J0QYTDYMijruiNFr7JT74ZKJIDJtGjQOFS9QX8zn+risk2FIv9Ii3DUlOu1eA/l9bXrdw9byhtSYDuWVcyDZYzzd6KsxNugTGa0q3LJC43XCgv/mPQRvaVKnVBpzJxn4QN6jNZiSpQZbgh//gkDHs2/wjF4s41UKPrUmbu+1b6g7yRBeNPhiJQjI02X9cN2vHKWDPWKawV5Xi5tOfxKDRowhSbZCxcklXZdztWQcw19xnSg7E3zqCq7fI2bm+56x/fiC6R+LFI/vBh6xrq75WAHo/gMkgmHz7ZWOrEwZqwyc7LaaTVGXCrt4XIU2H8ix8zQ+6bkrbDQ1w01qugwTnLgcYWeuI5Vl0tdd3ABnj55SoHY+kfkRjXJ4mG343iRxLKtbpXCBviakkHX89WSCLa7KqrUSrP+qQV9jp+lm/oDaonwZBw+p1/K4BpwC9N8Pdfeg9cxmlrL5YdOgv4JWsBWx+nT2woUInYXBVgXjBR5uVJlrfWMZubVXJh9pkaxHDFRC22m1TZiBrZBwxgkgqdUw9nGOdGt6AHQOrGyN15w9iM23z49vk533A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(2906002)(6916009)(54906003)(4326008)(6666004)(8676002)(26005)(186003)(86362001)(316002)(44832011)(36756003)(6486002)(38350700002)(66556008)(5660300002)(83380400001)(66946007)(66476007)(2616005)(6512007)(1076003)(508600001)(52116002)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XMdHWdtwPzcTr5VACXKi/bg5iqRjMfwOaoifiy5UDaH8/JcjnFsEy0SErrcA?=
 =?us-ascii?Q?ACuwnIIMiftgNsYEDCVdXMXLT0GQoshDoE9/9UMWpjiAgUr5m3fOWXahwAHU?=
 =?us-ascii?Q?SeZTfwAaxLITQU7lCP9c/r/rSOIY/rMHhy+vx+zUxcYGsePIwsZc67c7sXbo?=
 =?us-ascii?Q?XpVnzKI62SE1u0yvk//Zm9oPi4rp4lFWPIZdAqIcVtYnWNhDmMGh7pnECgyC?=
 =?us-ascii?Q?u19or/+JJVNWOaWtD/jjlNosVQnRaOVfMTHym3olmDhRP+ggoAwjjZoxhXfG?=
 =?us-ascii?Q?hEYo5+i49S88Yl8Q1Kq09z9CUECPo9jkgVsLEOfDSE3sHq5VuRU2g+Z84ac4?=
 =?us-ascii?Q?qYmzinyy6s6XnaIxdNCwjDKGRo8B6QrUL5keHPEgzA9qvQ1UzVa8vDJPcVaI?=
 =?us-ascii?Q?cJkcuB4TQ2vSFU3SBWo57+RnVfjMg8oiaFffkjwWLP4hV5pHLU+zmzEyA+Xz?=
 =?us-ascii?Q?Nft2S+nduBX7JQSdykC3MPvyxrFX0meXLl3DpQhOVeQY7rhn1GrxXEXh4Ssu?=
 =?us-ascii?Q?G0z8K0cUQFQBjgungFkDwfgR/1Uw3Xq/no7QfBB47+jN6vingqbHlrzxvRUV?=
 =?us-ascii?Q?huM6NZsbYw8aUwsbYTkuBuRW9ho5ITmTHjWaC39HfVL5jQkl8GrzMAfAIFiL?=
 =?us-ascii?Q?NY4xHvCB6hrEVMSw/21Tyy5xKPetaM+/v5gi8ccAAXQv4WuX0ORSC6enOmNu?=
 =?us-ascii?Q?wmZXAn9K3y0s+WVa1SAJDnT46xuUHTBx2bLoVqAI6c5UQ5dQO5EfTU1/SFXI?=
 =?us-ascii?Q?bNtAel6tFun56gJ6q6ss/+VI0uh1g4Vwm18sIigUq7KNEii+ACUi/e3i/LKH?=
 =?us-ascii?Q?Ey4qNZYJiwDtEq7m1VEssOH1mjbUdHOa2REb/5y1vG5LRWJkizlh4bThzQlX?=
 =?us-ascii?Q?wqJteLR8j/+QQ+QLE0R+NxIfjHN6YhBLik4LvdMordKJhqZJ+Fsr8MzelJ96?=
 =?us-ascii?Q?DKahnY0XS8LFvhcxFbny+aby+TQKe1vJyFcYOE/EACw3inEtYCpWQ+s2BAPH?=
 =?us-ascii?Q?E0PKfO3Yecm1F/nhcg8lof+5eXYFu5qzpUa0aLjhypGlhIVD5SWDSArXBiRe?=
 =?us-ascii?Q?i6wqbNU8D3p/Xepx7UfJ2syO7cf3gvyoe+I4uObgklvKMOH9QGAF+QkYhieq?=
 =?us-ascii?Q?v9ESB3Pjxj4aY26MO6SylMOL1g3FSIJMaiwQ8t7btwnXYPxPimsYd6c8D2O2?=
 =?us-ascii?Q?YpVfVZH0acHbPB1U5vLnI9gGlkasvT0kdQ/v1AkektkzQJkJ6wcl7TM45pUI?=
 =?us-ascii?Q?UACsjBEJ7Zn1ip7w4jaqIfORARroOr5PCNYYVhvPhc66EIgEWrLn2S/Euwyb?=
 =?us-ascii?Q?vH2XNQa5NwvJC/+DOYCqTm2neY9AfYZcPZohxO6eVFz5ZdC0kl5zocupDBfY?=
 =?us-ascii?Q?aM8k+qyrj+iAs3RksTn49NKtJ06FTGxGpP9FMRxIam+9g4x6ZQgs6B3eQW5K?=
 =?us-ascii?Q?QaA7VJRbNNRNhR6pfV2qZy1IxBPNFp0IJQwqlA4HPAhHzTEkOzqfRw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5948152-001b-499a-a803-08da078d6837
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 20:41:54.8794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G1oqikxTx8KnlS3Sftbq0gayeyLmSAz1OQo2rbSdK/tuyJl73kYQysGmTTo7fuUKytxEtiuP0Gd7uZvJpI0bwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8398
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for adding port mirroring support to the ocelot driver,
the dispatching function ocelot_setup_tc_cls_matchall() must be free of
action-specific code. Move port policer creation and deletion to
separate functions.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 110 ++++++++++++++++---------
 1 file changed, 71 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 5767e38c0c5a..a95e2fbbb975 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -216,14 +216,14 @@ int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
 	}
 }
 
-static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
-					struct tc_cls_matchall_offload *f,
-					bool ingress)
+static int ocelot_setup_tc_cls_matchall_police(struct ocelot_port_private *priv,
+					       struct tc_cls_matchall_offload *f,
+					       bool ingress,
+					       struct netlink_ext_ack *extack)
 {
-	struct netlink_ext_ack *extack = f->common.extack;
+	struct flow_action_entry *action = &f->rule->action.entries[0];
 	struct ocelot *ocelot = priv->port.ocelot;
 	struct ocelot_policer pol = { 0 };
-	struct flow_action_entry *action;
 	int port = priv->chip_port;
 	int err;
 
@@ -232,6 +232,58 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 		return -EOPNOTSUPP;
 	}
 
+	if (priv->tc.police_id && priv->tc.police_id != f->cookie) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only one policer per port is supported");
+		return -EEXIST;
+	}
+
+	err = ocelot_policer_validate(&f->rule->action, action, extack);
+	if (err)
+		return err;
+
+	pol.rate = (u32)div_u64(action->police.rate_bytes_ps, 1000) * 8;
+	pol.burst = action->police.burst;
+
+	err = ocelot_port_policer_add(ocelot, port, &pol);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Could not add policer");
+		return err;
+	}
+
+	priv->tc.police_id = f->cookie;
+	priv->tc.offload_cnt++;
+
+	return 0;
+}
+
+static int ocelot_del_tc_cls_matchall_police(struct ocelot_port_private *priv,
+					     struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+	int err;
+
+	err = ocelot_port_policer_del(ocelot, port);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Could not delete policer");
+		return err;
+	}
+
+	priv->tc.police_id = 0;
+	priv->tc.offload_cnt--;
+
+	return 0;
+}
+
+static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
+					struct tc_cls_matchall_offload *f,
+					bool ingress)
+{
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct flow_action_entry *action;
+
 	switch (f->command) {
 	case TC_CLSMATCHALL_REPLACE:
 		if (!flow_offload_has_one_action(&f->rule->action)) {
@@ -248,47 +300,27 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 
 		action = &f->rule->action.entries[0];
 
-		if (action->id != FLOW_ACTION_POLICE) {
+		switch (action->id) {
+		case FLOW_ACTION_POLICE:
+			return ocelot_setup_tc_cls_matchall_police(priv, f,
+								   ingress,
+								   extack);
+			break;
+		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			return -EOPNOTSUPP;
 		}
 
-		if (priv->tc.police_id && priv->tc.police_id != f->cookie) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Only one policer per port is supported");
-			return -EEXIST;
-		}
-
-		err = ocelot_policer_validate(&f->rule->action, action,
-					      extack);
-		if (err)
-			return err;
-
-		pol.rate = (u32)div_u64(action->police.rate_bytes_ps, 1000) * 8;
-		pol.burst = action->police.burst;
-
-		err = ocelot_port_policer_add(ocelot, port, &pol);
-		if (err) {
-			NL_SET_ERR_MSG_MOD(extack, "Could not add policer");
-			return err;
-		}
-
-		priv->tc.police_id = f->cookie;
-		priv->tc.offload_cnt++;
-		return 0;
+		break;
 	case TC_CLSMATCHALL_DESTROY:
-		if (priv->tc.police_id != f->cookie)
+		action = &f->rule->action.entries[0];
+
+		if (f->cookie == priv->tc.police_id)
+			return ocelot_del_tc_cls_matchall_police(priv, extack);
+		else
 			return -ENOENT;
 
-		err = ocelot_port_policer_del(ocelot, port);
-		if (err) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Could not delete policer");
-			return err;
-		}
-		priv->tc.police_id = 0;
-		priv->tc.offload_cnt--;
-		return 0;
+		break;
 	case TC_CLSMATCHALL_STATS:
 	default:
 		return -EOPNOTSUPP;
-- 
2.25.1

