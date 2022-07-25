Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E93580158
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbiGYPNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236095AbiGYPMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:12:49 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130075.outbound.protection.outlook.com [40.107.13.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198321ADB2;
        Mon, 25 Jul 2022 08:11:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FA42Kjjx2jwEVZ/EpXcIaE4+e2oGjPiZ+Xpq4ayo9wtC5m+nt+4DQ40AY7UGNq+OtuSPv2U1jflVUsLUfekNgLOPEBtCsqoPSVzybGwu6P7+Cs2piWDQS9mLTIJ1lHtc3wEEIrR+W7tSDOFbQHYIeGzn2XKig+hkkA3bGQVffze0svTMzReYYO98yvRCcy8Un7+tnwUEYF6UOvFOBrCKX1Sw6JjFlYdFhuI83OnchcHPnucDjLKpoXxlaOoq1E2WZGoyEy6nd9gC1zSjAEgPZEX1XhbiT7XQze0vyCbQp/V78wp2ujGKPD1ApVx7dJVoIfrtbQ7Lw+9YCfOZhn5fTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BrjFhE6GcDc3NyqacZut6e2mzgJ8sem49dgtwHT5lEE=;
 b=HsKNr9Uu6Ew9iU3ItD5cKHrYxFwAx8UvDj29ulZKPw3egz3IZIE41F4a50LUd+L798kI2txrswYalwCRmDRpazcl70w9hmfwBdl7mLg0FvTNoTSNE1Yi9Vpa9wvAZCpqnEpOYxPNKStYOfQpxDbe9/h29+DBFbr+gxA8Z3KTVXjiiAsBM1Kmv01j1aopNLTZoqncva6MDJaRB15+ERfpRDYBOqldb7/uHEe1YPvLxcaHnAxVYiqQT705YZLI6vd5HJo/pUk9vvcsBKbjXyR0LghM3rQmZuOKd/ZaZ0IOCEG9yoi/pokSz4QlvhEwtmfY5yu79PngVBM4MeR2AkaK0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BrjFhE6GcDc3NyqacZut6e2mzgJ8sem49dgtwHT5lEE=;
 b=d4DaOvRgBfYEqup8k3JG70F/2WdYScySx0jjriba/IakZxXd0UwsEFiKx4W7uxl0OU+rgx/5GmuSunF1zRhI3I4of9NNYAMIcqjdfAfc4nVA6hieR/cyaiARiIZUR3yyTXYaZRO2qwhgC/9s5/L88Re9Cdu0iAmoq++67xKgrqXjIW2zyB8Yv1GqMw0amMR74eK9CWfNZXpKDeetpQsYv1sjA0ddyxoNRJk1oUhoBgoMOZIlVlyjcFLeGWHKAndyVjDBFGD3qifug3NOvoCz2Mioryc7GebUUlPLqYqNd0p2EfoZY1qhlQ+J9Q1yaca4BjSlN6l9uEd84HRMd2ulxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:29 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:29 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4 17/25] net: fman: Pass params directly to mac init
Date:   Mon, 25 Jul 2022 11:10:31 -0400
Message-Id: <20220725151039.2581576-18-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8466f958-a855-4c35-198e-08da6e4ff386
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n9jLQ9yBBXWpGn5Huy+qwzL/xJ3DyMv9o1tCAkrDuNtgBEwgOxpkmQeSbLqNyOgi799H6+eKhZkdV3qUhdeOWv+p3EgdXOV/O7m8qmSRsKyhZN6/SNjutGAsjFM3SGvCNcAqcETc75pnbiY36aEuZivULB/sCJQ0yMXjwZCuglSws023nboBXziJvs7XFUJelI4Bp2c8qjK4FdTWf3Ka7wgxNS7Zdb1ZnZgDNfojFnRw6p5Z/xr/r9UXDjK/nBoQ4ZC9LB+KDhkxpvS2Pf6/j+LQkKADJwx12TUtDsKFcOuYaca6e44SAGATkvzesI8dw0SPCYxGPGIsih6kpYuK/dLUqRINtxSBIuerfgGOLG1P/hSpvFt15uoQzZcr3RL1XvaomrhbNVcZHkpl7P6C9EqE4dat1G86tvrgw9dwUZsrmlqw8Cy6WvXyk+r3Gyb7lFtgWB6C9ny7bqy6+g0dhxMpstMp6L2tbNUZByvw8DlKRUjFhk9bc/X7NAfFhV+wtJmHhaTXg+rrUDKMC6zY5N/eIJLp9O+V7dFy7+63Eehpc4fwGtnJCRhbRXNl3bca1kiGz3hnNqBUdzSjCHMq0ZCq45qENrP1L9Ubs+FcOc2CYjPUVX1Q5P0Q78NiKytgWqO6EaNhUY9uq8MT5yRN7aXfyR2GOWC/QzYZSvnrgftB93tbjYDuYvipt4sGVSe6xsAE/++8cZ93JdoB8yVPjwnbHt8hhXiZ0XFCdpSQEPv7e8DdSLZDBImmujwg/CMk0OoWzzcFfhMbTbGaKEtE010V+Q9aQfjOSYWOULzVhvw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(107886003)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(6666004)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KpavI02b7RF33XGNgLOUuYPXrPevmFx0vqRRqRc/EyQZkhPQeBFwrbrD6kiR?=
 =?us-ascii?Q?e5CQtcCxgsc72OF3lGlDwpPFAL+f5YrW/1l7fknSOdGNna+cYNQdOOaJ2Cm1?=
 =?us-ascii?Q?B8LRKK7oBA1D8s0si25Mzldax2uzvGj++KEvz+cJyFJCpjXs78bm9bi0zB6v?=
 =?us-ascii?Q?CF6SuLg1XwoWD5SmqGlW2UXH/OnOldEpbwB75Ev+8BqpGKzmi5dj8D7dYFTS?=
 =?us-ascii?Q?FFxPxICeGIcbIO9VNEKzKXzEGYB1YmK00kGlsT5Gx/122y9+Itxak6qIfaW3?=
 =?us-ascii?Q?KBlXFSrWBy7Jxr/tgloVMWzHM+IQMEYKLd4Vk7n/LGTtZxxzEQJKehm3FnhN?=
 =?us-ascii?Q?5PIoiHdaNwWmqGpkctqzMusoePftjrmNk8hbclAvwG6K1wY9vrgHI6eGL/ad?=
 =?us-ascii?Q?dHFl00G+g6D+aN4tBHWkgsh8BswX7IF+UJ1lGoxSzN6znOV8D2Dlruoopdmk?=
 =?us-ascii?Q?Nu29b9CfmVHURwOwEj3CDuKEoxakOi0ZLcXQmW5fpcL7bvLAH+SyOcauhoiH?=
 =?us-ascii?Q?EeYILise2IK48nb8UtD45RXhp4TXrwViurZpEf2rHdLcNoBcgpt40z0YWcuv?=
 =?us-ascii?Q?hOaFlq3nr56b0kN2V0tBzvMaK8teclvRdw0Wvx3YEzQzEH6zuhsLH2R701Ed?=
 =?us-ascii?Q?YiWPlYdSljDvMmBcxicK0+la1rlL/N/tUvrI5Xfs0cyDL6bi7f/25SDd/lK6?=
 =?us-ascii?Q?y3/6746KOgQJe0KqA4fQpQf49bM2DY07GWy+CyzI8bA3qGg+0/ifnNl4jeqA?=
 =?us-ascii?Q?6nHcafQETTBv2epjsPXB7ZeAhw3cZpUQBEIsAiBv3ovdw1VHTXn3e1HjkkQn?=
 =?us-ascii?Q?neurchjLNrMia+Qdtu5pvFkZbamz9FE2PG0vMzasBo504Nzow3s4kzHbWYOv?=
 =?us-ascii?Q?xwHMGyzvsiX+s8PAnapfxbeKAmRHiAUDnA1pThsCCO/pkvnvxe7/uH1IKlvf?=
 =?us-ascii?Q?VYKS5W2jTa1/2ZduOBIolXP/D4ql7g0idC0aMMLPlA/NeffC7FDNQNqjnPIc?=
 =?us-ascii?Q?NfZ4GrQ23X7xrsa+he03q7oSnjWSxzdHIZxV3I6fCx1u1P5ez4oBmNjIxzDZ?=
 =?us-ascii?Q?OUlVvH+3f7VTTlvQ51t40hDLfbgc14+A7EGCVZsITOCY74GEmnShn/ANWWtC?=
 =?us-ascii?Q?8hvY0dotLNX6dmm/XfBbQiCdk3P6/+e1SSZ7/CEB6WsgvRFj2go+sVbHW6k2?=
 =?us-ascii?Q?f/fyyHCuSqjqzaIXP8xzOoDDmPc3ceQBdZgrYwaSXrYxRLTxDnYn0E4jvzlz?=
 =?us-ascii?Q?Sul9cQAPfd+gT+lP5UJMeNVGlayfKlC2w1K0jrGRs4cYtk2R1PXnrBoW4m48?=
 =?us-ascii?Q?so/qWMhdQGw6B1ngrMWEy24mkSmCvT3yzbni63BchlD/Q3oheJVieVOHKxUX?=
 =?us-ascii?Q?EZp/Ubefbly9RS6si3AIWQumR1yMK8Khqn4hmh7ox10ErxjmGUit5IoHd91r?=
 =?us-ascii?Q?qYfwp4Rm/FVNEJ++NzQHmoVieyzN7l/XmNp8s2Dlsk1VW/7dMNAuDEnSSzKC?=
 =?us-ascii?Q?2TIILpiagZl0wRn/WKrV+TToOZUeiH6NAeEs0eIXdJC7N8Gi04BFUvZlYKYb?=
 =?us-ascii?Q?ff5Z/zgAgXpzxGmgO+iuE/ObTbJ21OZXp74LNbO11xvjW3il8PhM2NYFaTM9?=
 =?us-ascii?Q?qg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8466f958-a855-4c35-198e-08da6e4ff386
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:29.4563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5yGqgK1Ar2Cl6TsffZyJg/tXmlsM/mN19oYbWrPDHrXEqx84qYHQKdHSdjW1Bpm75IjUOrfclACOgoir2oUA2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3723
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of having the mac init functions call back into the fman core to
get their params, just pass them directly to the init functions.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 10 ++----
 .../net/ethernet/freescale/fman/fman_dtsec.h  |  3 +-
 .../net/ethernet/freescale/fman/fman_memac.c  | 14 +++-----
 .../net/ethernet/freescale/fman/fman_memac.h  |  3 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   | 10 ++----
 .../net/ethernet/freescale/fman/fman_tgec.h   |  3 +-
 drivers/net/ethernet/freescale/fman/mac.c     | 36 ++++++++-----------
 drivers/net/ethernet/freescale/fman/mac.h     |  2 --
 8 files changed, 32 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index c2c4677451a9..9fabb2dfc972 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1474,10 +1474,10 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 }
 
 int dtsec_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node)
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params)
 {
 	int			err;
-	struct fman_mac_params	params;
 	struct fman_mac		*dtsec;
 	struct device_node	*phy_node;
 
@@ -1495,11 +1495,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= dtsec_enable;
 	mac_dev->disable		= dtsec_disable;
 
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-
-	mac_dev->fman_mac = dtsec_config(&params);
+	mac_dev->fman_mac = dtsec_config(params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.h b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
index cf3e683c089c..8c72d280c51a 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
@@ -11,6 +11,7 @@
 struct mac_device;
 
 int dtsec_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node);
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params);
 
 #endif /* __DTSEC_H */
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 5c0b837ebcbc..7121be0f958b 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1154,11 +1154,11 @@ static struct fman_mac *memac_config(struct fman_mac_params *params)
 }
 
 int memac_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node)
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params)
 {
 	int			 err;
 	struct device_node	*phy_node;
-	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
 	struct fman_mac		*memac;
 
@@ -1176,14 +1176,10 @@ int memac_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= memac_enable;
 	mac_dev->disable		= memac_disable;
 
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
+	if (params->max_speed == SPEED_10000)
+		params->phy_if = PHY_INTERFACE_MODE_XGMII;
 
-	if (params.max_speed == SPEED_10000)
-		params.phy_if = PHY_INTERFACE_MODE_XGMII;
-
-	mac_dev->fman_mac = memac_config(&params);
+	mac_dev->fman_mac = memac_config(params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.h b/drivers/net/ethernet/freescale/fman/fman_memac.h
index a58215a3b1d9..5a3a14f9684f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.h
@@ -14,6 +14,7 @@
 struct mac_device;
 
 int memac_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node);
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params);
 
 #endif /* __MEMAC_H */
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 32ee1674ff2f..f34f89e46a6f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -783,10 +783,10 @@ static struct fman_mac *tgec_config(struct fman_mac_params *params)
 }
 
 int tgec_initialization(struct mac_device *mac_dev,
-			struct device_node *mac_node)
+			struct device_node *mac_node,
+			struct fman_mac_params *params)
 {
 	int err;
-	struct fman_mac_params	params;
 	struct fman_mac		*tgec;
 
 	mac_dev->set_promisc		= tgec_set_promiscuous;
@@ -803,11 +803,7 @@ int tgec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
 
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-
-	mac_dev->fman_mac = tgec_config(&params);
+	mac_dev->fman_mac = tgec_config(params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.h b/drivers/net/ethernet/freescale/fman/fman_tgec.h
index 2e45b9fea352..768b8d165e05 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.h
@@ -11,6 +11,7 @@
 struct mac_device;
 
 int tgec_initialization(struct mac_device *mac_dev,
-			struct device_node *mac_node);
+			struct device_node *mac_node,
+			struct fman_mac_params *params);
 
 #endif /* __TGEC_H */
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 62af81c0c942..fb04c1f9cd3e 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -57,25 +57,6 @@ static void mac_exception(void *handle, enum fman_mac_exceptions ex)
 		__func__, ex);
 }
 
-int set_fman_mac_params(struct mac_device *mac_dev,
-			struct fman_mac_params *params)
-{
-	struct mac_priv_s *priv = mac_dev->priv;
-
-	params->base_addr = mac_dev->vaddr;
-	memcpy(&params->addr, mac_dev->addr, sizeof(mac_dev->addr));
-	params->max_speed	= priv->max_speed;
-	params->phy_if		= mac_dev->phy_if;
-	params->basex_if	= false;
-	params->mac_id		= priv->cell_index;
-	params->fm		= (void *)priv->fman;
-	params->exception_cb	= mac_exception;
-	params->event_cb	= mac_exception;
-	params->dev_id		= mac_dev;
-
-	return 0;
-}
-
 int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
 {
 	struct mac_priv_s	*priv;
@@ -294,13 +275,15 @@ MODULE_DEVICE_TABLE(of, mac_match);
 static int mac_probe(struct platform_device *_of_dev)
 {
 	int			 err, i, nph;
-	int (*init)(struct mac_device *mac_dev, struct device_node *mac_node);
+	int (*init)(struct mac_device *mac_dev, struct device_node *mac_node,
+		    struct fman_mac_params *params);
 	struct device		*dev;
 	struct device_node	*mac_node, *dev_node;
 	struct mac_device	*mac_dev;
 	struct platform_device	*of_dev;
 	struct resource		*res;
 	struct mac_priv_s	*priv;
+	struct fman_mac_params	 params;
 	u32			 val;
 	u8			fman_id;
 	phy_interface_t          phy_if;
@@ -474,7 +457,18 @@ static int mac_probe(struct platform_device *_of_dev)
 	/* Get the rest of the PHY information */
 	mac_dev->phy_node = of_parse_phandle(mac_node, "phy-handle", 0);
 
-	err = init(mac_dev, mac_node);
+	params.base_addr = mac_dev->vaddr;
+	memcpy(&params.addr, mac_dev->addr, sizeof(mac_dev->addr));
+	params.max_speed	= priv->max_speed;
+	params.phy_if		= mac_dev->phy_if;
+	params.basex_if		= false;
+	params.mac_id		= priv->cell_index;
+	params.fm		= (void *)priv->fman;
+	params.exception_cb	= mac_exception;
+	params.event_cb		= mac_exception;
+	params.dev_id		= mac_dev;
+
+	err = init(mac_dev, mac_node, &params);
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() = %d\n", err);
 		of_node_put(mac_dev->phy_node);
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 7aa71b05bd3e..c5fb4d46210f 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -72,8 +72,6 @@ int fman_set_mac_active_pause(struct mac_device *mac_dev, bool rx, bool tx);
 
 void fman_get_pause_cfg(struct mac_device *mac_dev, bool *rx_pause,
 			bool *tx_pause);
-int set_fman_mac_params(struct mac_device *mac_dev,
-			struct fman_mac_params *params);
 int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev);
 
 #endif	/* __MAC_H */
-- 
2.35.1.1320.gc452695387.dirty

