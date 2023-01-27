Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5EFE67DA98
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbjA0ASW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbjA0ASE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:18:04 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2089.outbound.protection.outlook.com [40.107.21.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE117518F
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:17:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+UsOoGSnm2ZpvRXdD2SSIIXGPeNdmagk5ElrYpdyCCMTPYviz7v8uIXxv/c7FOrh23F3WaRm8nnML3NGn9zCZ6Ugm2vsCnxMbUvNYZkv6Bz9sYMLLhlTV2LURNrwKok+9e/r+ks9NqWVBAKzi+0ePAfecgkAt/ekYvLjn/mr8CIe9jLJNwhSchXA5ZuaPOjic/0Mw2CMmCTNpwYhzD2fgesIi/3NYmzl6xzM0qsuknJe2a3iDUc7H9YGZ55hMOzQADdNzgMv9q4bSYpWaWJeIEUUGUY+lrYggm0Ew1zegxIMQ8vH8tLAIX0ZhVwxNKQDjIZyVsV/TbUoCiL5Gy+4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2gPRwMx0GR7RZf5gD2TIT1VlLSU4hYLcwrsfD/oiTPg=;
 b=Ye8LpZNZMXk5sheNXUYEzWQlO5vcjPkzTh9dIygB0382QplXwEi3miQe2D1xM3lCTSwkoqEnZpZp2gRE58qVzXYB6/HFoR7pkj4+LAOJhcOfV9II4v8AlNfBRuYIklxnsWBwamGQOzod6ApfX+BKFlbtmO59o1NKz8pHIHDJxxlG8hnAF3riYX0MitYnYr4l79KCtrNwYYH2YwstvxwXOox4IkWpUwhMuQCueZ/joCUgoCguRnJ9vUc8whEuMxyspphqpHwMg//vV0rAZPz/kYY1aica1bWMb6zoqbkpqsISbQTaiAtyNdmSLvV415ZLNww0s6t9lLXDhg4KQgmZCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gPRwMx0GR7RZf5gD2TIT1VlLSU4hYLcwrsfD/oiTPg=;
 b=k0iDT5z8myqFiVKiwSoS5KQJbryNGg3g5dxQHC8fQZVYRZuqQDgB5rNKKVPhe/qPxjI9pQk/y6PdXANFTBOyAAuSWz9tYa5VTn9tKkoMsQBpoNj01Q2xv6Urfc8RKiP7CzYM8Vc7FqRFFMapU4tDquj6FWuWAlR4JqGfEBSsvys=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:16:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:16:07 +0000
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
Subject: [PATCH v3 net-next 10/15] net: enetc: request mqprio to validate the queue counts
Date:   Fri, 27 Jan 2023 02:15:11 +0200
Message-Id: <20230127001516.592984-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127001516.592984-1-vladimir.oltean@nxp.com>
References: <20230127001516.592984-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 7410d0c3-1684-4818-8c15-08dafffbafa1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wx9MrC7HLViP1T5qQFoTDqr/nz+Tv+7/wjWxRkJpgsI6mM9ZNLNZZZsV9EoSsJokTZKgZODU/0iEHefq0QzbYK1GSezcb3VYjDmpan41t3wOY1qYV+72I0aEA8uMbXIq7JEPJKvm0acvfASir8kpZyU6fbap0rBbfvr6CWkw+N1RWKBSuDL9NWortLRHXRTUxcjkrQB/vd1Xi2d5WZuDNYy9H6EFp/8vadOSa/6ty25/VRIcJZ2Jy3bDwrDti7IX8UV0viysUBRFv74UQKldVTbMx/MdzKAtrZl1cnLptx++Z0hZcU14PVfhFj1pRT6D8gokPbaPGFTxVU/g4JVEN7DMyXkLpY1eakE0tINFniosYP9HSfuOcegB01/5eN8pb3J87QZbQgSNyXYnvDU65RhFvqU/bxTzoYVW6YtVAolABni8mZs6giFEDacOBx50VaRviAnHSGeDdyDgjzceR/78jtg+w3mmWQjGqsHLdMsI5Nj1un1PftHt6D0gSUKs8N89Y40Pl2hhjqu7aR5dVME9Yvrdwh7PzEy6UBLsJl5nOSMu2hIXuX+KAmCI4OfTCgwzWNu8O95uaMWdSeoP1x+6uGemPXmxl2vmHpPJYTKAa7jexFZFL/l0+oQ+nxooqWMcyK5iT+WGz79bQAgM/+uZcuo/Zbaw9iBLdVy1H9BiS6WLrzA1mLyABCdQFHUYWltNxtASfBtE/0xerpjLOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(15650500001)(83380400001)(52116002)(6506007)(6666004)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sz5dSu93SS/CFVXDORkVI/0dV/YjIQ7MDyAii2nsYd2KxRY9CWOHkxIIhgxX?=
 =?us-ascii?Q?ssb/G33XJHMXE3GutbnFb6l+LQftrcPQfH5Hek2WSfswIU6UjULq9Rt+9hWW?=
 =?us-ascii?Q?QrGJG5W6JZqyYFJBMBbcLiUQRuMKAh8CdY98ptQC3Z9ki1O1C1zzfKN3eRO6?=
 =?us-ascii?Q?68h5B9irTQfhoniUsfhreWo+OKTUduNfhlqkZ6uzK6mSmFX7OBCttnfav74a?=
 =?us-ascii?Q?gD64z3Be47sUEp0wcIdnHM3acDWS9hPEGOXM1WELB1VKyaKwx5z/x7+A1yAq?=
 =?us-ascii?Q?FWt6sIOuGAvawhedZeKM68Bi7OfjWPKJ4aEyrsoQ+LFY1FpETXBxB1dCI0R9?=
 =?us-ascii?Q?X6BEjYZInI3pVOB9YqDkGIxYEkW23JLhcc48LntYr6xpRpE3tUjYqAGJCWY0?=
 =?us-ascii?Q?bhY7pHkNHlgBEh2HAjSQbko8WoCl0BEe34A/vj72GnNBcBnCJy5auu+JmM7r?=
 =?us-ascii?Q?/FpBk0zFF4jv61GhRO2YgwiMMBPYO66oPBl4wix6sL0zrmf0H/HKFJQGuCGP?=
 =?us-ascii?Q?oNxEfDtq3N1P3EmeBnO7/iYuNvpTblSH3CPyovvBWbEsbslDIYj7UE8Wh61g?=
 =?us-ascii?Q?uB/t5XysEWSA797tE9Hah1pWUgoAmlTSfcHQMuhcb6c+Kcqd3zmMvDIaPj6k?=
 =?us-ascii?Q?GdNH/+3R/2dVKjqTLE7nw+TQ66fx0jWxngOeVIz6YPU3uxKnC5l00LJIDISq?=
 =?us-ascii?Q?9ioGuOVe0wAo+voVrBU08QCwd7/XM9E/cJzI/7d4z1BdIhGKOd90PDtf87v7?=
 =?us-ascii?Q?0kj5CLQxQQOdUqckSU4tLPJb4uwYrmZzy7jlz9gcLV+y18amnCakb5Cr7RcN?=
 =?us-ascii?Q?+chhfkKF0D5hfdu8EUTvjOekP64n5u7+dKNNKJztpAC6dXwl5UFZ38B8fJNg?=
 =?us-ascii?Q?seh3oqYQ0trzKiCYX30OQfiMDxC36+SO8v60m9f40Yh7kKbcjd9WYpSBjMP6?=
 =?us-ascii?Q?ZjXn+odDCxQG1a33Y09qHsdBWN5eVqLmmjM0BupWh/OB9DA8xzmXCL0ihlhG?=
 =?us-ascii?Q?MVD3vS83P8Y6UHhawjgPybsr1ATNbJMyQkyXrai/hE4DFgC3agZKbBI/e6CG?=
 =?us-ascii?Q?vkYWOmKvLjq6QUOk/Qc18PDCIpZnbdmaNQCaNO9XbqDORKyfw7pipOnePDho?=
 =?us-ascii?Q?3vaERGct5ACOLm8tuAB6cbQELbAJRk2CfmHWonXDidrpVnGK1DRPDKRF2CO/?=
 =?us-ascii?Q?TMVfa4HeBoAYUuLI/uZf4By8TkeOrb/8d0PDmC4ZFbIpValPBc5IwdgKtJjH?=
 =?us-ascii?Q?VmeWcSLPvncMQjRCGNXiQ9UTlKxjyPhVisZrKKiCYUK2fTfTB6A+58J+ZkjX?=
 =?us-ascii?Q?nzVMD+xDCWbD7RXCUR1lqFmiBDJlaVCUFOXeDxQ4OH1WaAs1HUm0VtpBEB2U?=
 =?us-ascii?Q?U1VURUG+QyvyT6LQFNXaRmv45t958ur0O4oc261xsoCcGx0Y0xtJodtMb7xl?=
 =?us-ascii?Q?lfaLyFYvdTZq8vs7BZgMbBIOVIYy/sWwF/IT8QZtyFxLbEdlFXXe/xy2Kq45?=
 =?us-ascii?Q?NaSs59UZ/YpSdAC2IR4+Oqh+I6n255WLRBb8huTVdqEdyRkbC0eqZ5IQs4b6?=
 =?us-ascii?Q?vbULYoGz8p/xWmGOf+gfatC0GnmwJ2iaPQRSG/kuiDIapQ1Y4qHQPqUm40Vh?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7410d0c3-1684-4818-8c15-08dafffbafa1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:16:07.6851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lBed3cIxbYWp20XVaBSF2gi9QpHzCSsiLq9UcW54V5px3/z11BxmsubiDU2O+XeyZk81Ztkyt5fKHZOLx2EPAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enetc driver does not validate the mqprio queue configuration, so it
currently allows things like this:

$ tc qdisc add dev swp0 root handle 1: mqprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 queues 3@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 1

By requesting validation via the mqprio capability structure, this is no
longer allowed, and needs no custom code in the driver.

The check that num_tc <= real_num_tx_queues also becomes superfluous and
can be dropped, because mqprio_validate_queue_counts() validates that no
TXQ range exceeds real_num_tx_queues. That is a stronger check, because
there is at least 1 TXQ per TC, so there are at least as many TXQs as TCs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v2->v3: none
v1->v2: move the deletion of the num_tc check to this patch, and add an
        explanation for it

 drivers/net/ethernet/freescale/enetc/enetc.c     | 7 -------
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 1c0aeaa13cde..e4718b50cf31 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2638,13 +2638,6 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 		return 0;
 	}
 
-	/* Check if we have enough BD rings available to accommodate all TCs */
-	if (num_tc > num_stack_tx_queues) {
-		netdev_err(ndev, "Max %d traffic classes supported\n",
-			   priv->num_tx_rings);
-		return -EINVAL;
-	}
-
 	/* For the moment, we use only one BD ring per TC.
 	 *
 	 * Configure num_tc BD rings with increasing priorities.
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index fcebb54224c0..6e0b4dd91509 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1611,6 +1611,13 @@ int enetc_qos_query_caps(struct net_device *ndev, void *type_data)
 	struct enetc_si *si = priv->si;
 
 	switch (base->type) {
+	case TC_SETUP_QDISC_MQPRIO: {
+		struct tc_mqprio_caps *caps = base->caps;
+
+		caps->validate_queue_counts = true;
+
+		return 0;
+	}
 	case TC_SETUP_QDISC_TAPRIO: {
 		struct tc_taprio_caps *caps = base->caps;
 
-- 
2.34.1

