Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652835ED98A
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiI1JyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiI1Jw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:52:56 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70088.outbound.protection.outlook.com [40.107.7.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809BCAB4D2;
        Wed, 28 Sep 2022 02:52:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mn5W/FGPuNa6KaSCfy4hYFfx+ytuylynkE0sVG14v2cUbFux6EbGLrAo41rZSkkeTGIIg1Qnz4GRrqqD2p/0fcH9vNuUDjWKfDHLtYRRb698RSsyrPfoFtzE32AiHmDcavCX16kbdAdtKX1vna/KueshjacL+XKXZBFBFUiirw4wsKocjLM5ytsdVi8chz6bl4fWtru/KHEsNBEIVSzVAuo2myLj8iPxO06l0GZ3GEOwyQdP5wUbDX18cpgyQj6sdzBpUb7/VdaKtZgWV9QfuaoEn7IGL53pe4P7jLl+74uR6N4lRzPLvswguiE/4x8mLitkEm7hN7+DOdkvT2JCDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4G8Xg7HrpbHpT28BOE2qnXrVFZfWmqxdtpcnAZYbLY=;
 b=TpcRQ5IqklKIq0YZdgTKXxHPlOL5ul6K3nJhl62RvPWw2pEcryF0id6vEckJeAtRTKI5AUYMAHSDQzOrYTH9Sm/h4t2wnRgITYzfdaiJZYEbRcqdWmPyLyL/Zt+rzjdnXYuxmYijFsGYWB/LRrfbHAhg6cwElQ4Dh6Xm8vaZO8mwDxbUDJquQbnCCiwgi6yOQPAkfbSfMik7lvvB1BKj+z1NMCS5uS3qmgBtqsh1fmunFe5jT+a4xlOsZDQCZ+kfA2dkpOYkVyHDEzZQx/1D9IUHTurV8THWY0dM+YYmD7IytDjpGZd1hbQ518jHL+RvMxVPOKXr3c/ylI+pbQ8/4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4G8Xg7HrpbHpT28BOE2qnXrVFZfWmqxdtpcnAZYbLY=;
 b=ppP3E0uvXHHHSl4hT8+cBmcwB22WG45PqJ6KVEIf4FMMO/IELIjCz4oEgMx/N6Y/8NoQGo2AiBYxCviz4w+UpYG19bPnSTpmAkpRqFXinC09mjXOzvUeEomPbc5372VkcM/FyeyA42MjauofZcq/kvFYeWdKRB5f1gk6orqlg30=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7752.eurprd04.prod.outlook.com (2603:10a6:20b:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Wed, 28 Sep
 2022 09:52:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Wed, 28 Sep 2022
 09:52:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 7/8] net: enetc: use common naming scheme for PTGCR and PTGCAPR registers
Date:   Wed, 28 Sep 2022 12:52:03 +0300
Message-Id: <20220928095204.2093716-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
References: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0006.eurprd05.prod.outlook.com
 (2603:10a6:800:92::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7752:EE_
X-MS-Office365-Filtering-Correlation-Id: 068d518b-c830-469f-0ec0-08daa137277d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DEdCDOZwjgF9Pm9UL15fFaMTbJCy7vGbbx0OYqHdEzMBSb/Xbh/v4vnGAIkReWFfPgWP0P5sXfmmYSQs5JAaxQMPCZZCXZP6eTp47lwWwTDAM5XRISy9wJBy5qEKl8SJgKFSb5he5geQS89iKFJjqV2c0HPvl68Osoxxcddg1SJWjQxWj5wdHDofDCSBb5+1urxiRv1U3CVzZzC47d3S19G1tD98yMP27O21h8AmH6z6nSAxvDfHhse10nUF+pBBAWYHSWoeCAAvt25U4Gi5Yb/otYSzNn5qVHSG7X0+TpUVrgSpWZJWrWfo/sqBe9it4I33Z0efIvRpFUciYM0UivhRw3EKhQSSH+H0sGfqChdzUwOAL1A9fLNMNvZ7SKf++5nwGwmkxzBzaul7fDkdeQZoU7+WByaHZK/c6ZUf0tHznwRqlbXY+l/hX86XTNch94TNAfF2/LYWnZWvVq00FBSqs4sLn7bE4IBM54Tq7QcwB2FVWtDm5WLWDwb2iQpC0kbxa2BkqLkke5SvckQjuaA2WVyuu2s3+xd50p924XINtWpIK6srTmMUD9AqL+uUQVJMXw/vRXMUH3qWhO81AYqq9/Ci4ZyhNNTEvKMORSb0StECQxmStQi0Ljb/PuGMXLoF+uSxXF1w04dJZuk0QvsBLHOFD6oJWNdws2NntRPtR3oQIrhJqLF+PG3kvZPTQBkaF0lIsZWA/SvXi0ms6tdLwnptFmcnGU9vvxw2GyR4uCE6ivPEEhLezOco0CgiG1IOdfPdsjTblTI8W6LfhUmNyrgVzuuFUZWy8LSMi/s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199015)(38350700002)(38100700002)(5660300002)(6506007)(52116002)(6666004)(6512007)(8936002)(7416002)(2906002)(41300700001)(44832011)(36756003)(6486002)(478600001)(966005)(86362001)(54906003)(6916009)(26005)(4326008)(83380400001)(1076003)(186003)(8676002)(66476007)(66946007)(66556008)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ForDRiZYNtKvFEAxXiCVzKgGMGyPov1yjlRh6Yfx905gOIoa4zDeWteuhd6f?=
 =?us-ascii?Q?+Aa8CynypR0AU2aqaw6mGu2FL1kqYo8Kf21hgcZJL4pJsNaq4AzxztNl20L5?=
 =?us-ascii?Q?ErBlLHWfl1Rl+kuFxwq+NHFcrsza7H3G7MoHnTN8mB0S5WFnZhlDDYjA2boM?=
 =?us-ascii?Q?Ks5y8w4poNTjOGUUg/CBCDmv8NK2zYX7epHIvs+ZmFj6w8E4YPJYAK1YuCmy?=
 =?us-ascii?Q?gw13Xu9qElYJKR8pMmY0qWvpz0RnlcBO4GvIDiZcSZssZWIMGw8VBm3+l9JV?=
 =?us-ascii?Q?KwYsS0qskfWR0t0Ujj4lUBMcAWioxgfRc2qZffOjlgAwFpzKd+z+UN88A6ht?=
 =?us-ascii?Q?GElxtbgcA2X6lTS3YAcLeAV75JbhzU6ArAinlaHtozUT11I3AMDmFZVircur?=
 =?us-ascii?Q?8VYwRxMAzp7Jp4bre/8SUcL9V6BJsUouVWTVa42kKGuHMqXrdiu7F3KnS0gL?=
 =?us-ascii?Q?hy6Y9g3NTkAyXvwzqo7eh78TO1jf9ejbO3HXDu8J5sLoDgR1vqm2PNa7p/5/?=
 =?us-ascii?Q?JFwRd8RhLRPcSeyvT8wiNjnvgLewLNZfY28iNEEyscmA2X3Nih8f04SuxmQC?=
 =?us-ascii?Q?FPNBpBpzypKhwZq2mV3hij0Lu3YQLsW2uGG22EQICjK58IU3jdamjAoOr3Oq?=
 =?us-ascii?Q?bv+rZEtslU3w1b7fd8J+Jau0n/MYY66bP6WGUrZUmtBaOhO1k6d2bRzeTfS0?=
 =?us-ascii?Q?fphn9UFk3CSRn5cvp0DFEk8cg87tX29UvZyZiMGqa1jzqdVnu+4jMM1VPHmV?=
 =?us-ascii?Q?+f9v8baBYB0oM3Ei1x+ZqQ2C/tl+Hec5xkOFCuLfFFuu478dlWFa43Ja1eWg?=
 =?us-ascii?Q?vcT1NGck9fRJ25KmRDnD9kjuxiArGQtlVGi3afudTbvVRRDgS0Y/K+0BoU4K?=
 =?us-ascii?Q?QTFxYY/uo/Zal5S36O5IL824mgQIqyEMnX0l2NCTsYKgCWNPncVrPc6cbPNs?=
 =?us-ascii?Q?Xj/RqtMB/Ixqv8QsZU+eh7eDykthudWK1q+Geb6ylGc0HLylUvG0QLoZlhv8?=
 =?us-ascii?Q?UY4undII8JmKJUI3vE0pG7wToKLSLUC/frruqWCDYMun6qWwOdtQvyNCM779?=
 =?us-ascii?Q?520c44daFGxzliMLw807y3zsKP4CEC3+Pj6/P1+tQ5/aS85PABdFFBa9alIY?=
 =?us-ascii?Q?rK8RKY8iO4+UcFrIhjJYjnLdn/EBujNWEE6NRDh/nBNZrutFohYBPFdfkPn+?=
 =?us-ascii?Q?RvfwNwM77EkfdAUZB9nR4Iyh0cc3hhASjlILe2XNOU6BFxhSCzWY+oM4hv/c?=
 =?us-ascii?Q?fcBBYL5xm8sl4oOh46jj5PKXVVePgLbC3XbRL/sXfl5R9BXQrRyHByiLMSx1?=
 =?us-ascii?Q?j1JtZDBtfYL89xhOt8EkPl1Utn7DV1WJgZzes1sdnVsUrmwvwUL2T9kv6GZ0?=
 =?us-ascii?Q?WcoanQ8LR+AagHVJzU6j2N19BnR7VQ6+Q6S5AR61hh9KhDdamtupDILs++DT?=
 =?us-ascii?Q?8f/SI9QKwaXHMQP0L40b0fkHBPe/euIhvs9fK6FxrMn/c9npRe9tog51ye2g?=
 =?us-ascii?Q?lqu1M9cAnQvHd8hlBJY4s3XTG8Y8NENg3MldYdVfx2P55sXu+YtWYma6RSdJ?=
 =?us-ascii?Q?3rTrGxJV3CmZtpbbOTbOUzFU6zsYobGpMf0WaK1pG3uH+w53vcJPU92icFVP?=
 =?us-ascii?Q?aw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068d518b-c830-469f-0ec0-08daa137277d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 09:52:28.6314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwE3FGVXZW1eV15SP2ogYL0Lrq4uJH9vvGDvFIN+nX048lcu8JSOysfnmrsB861HD5i4a63UnD9U0ifcXl1j1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7752
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Port Time Gating Control Register (PTGCR) and Port Time Gating
Capability Register (PTGCAPR) have definitions in the driver which
aren't in line with the other registers. Rename these.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- patch is new (actually taken from the separate preliminary series at
  https://patchwork.kernel.org/project/netdevbpf/patch/20220921144349.1529150-2-vladimir.oltean@nxp.com/)
v2->v4:
- none

 drivers/net/ethernet/freescale/enetc/enetc_hw.h  | 10 +++++-----
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 13 ++++++-------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 0b85e37a00eb..18ca1f42b1f7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -945,13 +945,13 @@ static inline u32 enetc_usecs_to_cycles(u32 usecs)
 }
 
 /* port time gating control register */
-#define ENETC_QBV_PTGCR_OFFSET		0x11a00
-#define ENETC_QBV_TGE			BIT(31)
-#define ENETC_QBV_TGPE			BIT(30)
+#define ENETC_PTGCR			0x11a00
+#define ENETC_PTGCR_TGE			BIT(31)
+#define ENETC_PTGCR_TGPE		BIT(30)
 
 /* Port time gating capability register */
-#define ENETC_QBV_PTGCAPR_OFFSET	0x11a08
-#define ENETC_QBV_MAX_GCL_LEN_MASK	GENMASK(15, 0)
+#define ENETC_PTGCAPR			0x11a08
+#define ENETC_PTGCAPR_MAX_GCL_LEN_MASK	GENMASK(15, 0)
 
 /* Port time specific departure */
 #define ENETC_PTCTSDR(n)	(0x1210 + 4 * (n))
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 2e783ef73690..ee28cb62afe8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -11,8 +11,7 @@
 
 static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
 {
-	return enetc_rd(hw, ENETC_QBV_PTGCAPR_OFFSET)
-		& ENETC_QBV_MAX_GCL_LEN_MASK;
+	return enetc_rd(hw, ENETC_PTGCAPR) & ENETC_PTGCAPR_MAX_GCL_LEN_MASK;
 }
 
 void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
@@ -65,9 +64,9 @@ static int enetc_setup_taprio(struct net_device *ndev,
 		return -EINVAL;
 	gcl_len = admin_conf->num_entries;
 
-	tge = enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET);
+	tge = enetc_rd(hw, ENETC_PTGCR);
 	if (!admin_conf->enable) {
-		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
+		enetc_wr(hw, ENETC_PTGCR, tge & ~ENETC_PTGCR_TGE);
 
 		priv->active_offloads &= ~ENETC_F_QBV;
 
@@ -115,11 +114,11 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	cbd.cls = BDCR_CMD_PORT_GCL;
 	cbd.status_flags = 0;
 
-	enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge | ENETC_QBV_TGE);
+	enetc_wr(hw, ENETC_PTGCR, tge | ENETC_PTGCR_TGE);
 
 	err = enetc_send_cmd(priv->si, &cbd);
 	if (err)
-		enetc_wr(hw, ENETC_QBV_PTGCR_OFFSET, tge & ~ENETC_QBV_TGE);
+		enetc_wr(hw, ENETC_PTGCR, tge & ~ENETC_PTGCR_TGE);
 
 	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
@@ -299,7 +298,7 @@ int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
 		return -EINVAL;
 
 	/* TSD and Qbv are mutually exclusive in hardware */
-	if (enetc_rd(hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
+	if (enetc_rd(hw, ENETC_PTGCR) & ENETC_PTGCR_TGE)
 		return -EBUSY;
 
 	priv->tx_ring[tc]->tsd_enable = qopt->enable;
-- 
2.34.1

