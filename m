Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76B268726D
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbjBBAhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjBBAhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:37:23 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B36073756
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:37:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q15eBr1Fr3BHdrIs6lYjbGI5M4QRlIRbAwPKS8DEVtBYjIxd4ax2087ghkv6BLbJdrS7R6vz+CbcpbxplBnhuaOrIVt5k6zWqspbSq+a3yWZ4uhkSEEDWVPe3HCj7oIM2cGJ17+SfN63GSd0guDjyg4EkMU2ADwkYbdetthrU4fL2aHn3u1sxxCvhnzqcufC51Olouekdna73yPiWW+A3QVtBwtBJzX6WICfWQVqfMbrFe37/6aTOhcJIzXSdIVc2gyjYOZH53RbsFNUjh1R35Dlc99854Nsd5yIszbz0MyTWWgGvb/s62fHJDU1FnJToiCUnfOU6JEfLoZedjWHFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2FBEq4ybasGW5G6VJAGtDMnppERIivx9WnZY0z0Xb4Y=;
 b=BUYP1o/ZlqLBsxlPp+yi0Si4b5otMA1mLab3to6fPmEfHMqAJJ7hp/v9Hyx65Cg2zDFpRPDwoQIEbytcXpr1EvHVpvWeg/agJ/z6PWRF5Uwp7VJxr7SZHxZafWylS+YATPHGosAkIz9PRrboiA+vlMUtLLzZ8YNPRPAyetJ9K2ZzVDpjdv3AtAprZofOlscxmc8YuBrsFDulM0PWz28+z50jfcV7xOpEQZB1zQQnDOnBMu5oEnmBmQ0DfeAMQ0An26JymMLkvyJ8PpuEPA7g5LLUlswISn4fkQIY9ijW9vYlMtY+LxYphk7lLg1WJkGk/Fs7NMg9M6zMXcx/MWxx1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2FBEq4ybasGW5G6VJAGtDMnppERIivx9WnZY0z0Xb4Y=;
 b=APcGGcviGCqrSPlQexb/6hiL1Sy/9GP8ipwzQvabomiBqPVQ0Lfsmomb6OWZ99xMyqQHqcy5qvbsFqGeOmaflfkbcuJ0RBevth9hEBKBCY9aquauDH32JPYVu2fV3HW1/olMLxJl0GBBKB+RNWS+918HDfbDs0BlnKl+8yA8msE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:37:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:37:02 +0000
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
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 15/17] net: enetc: request mqprio to validate the queue counts
Date:   Thu,  2 Feb 2023 02:36:19 +0200
Message-Id: <20230202003621.2679603-16-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: 87458429-4b9e-4709-c799-08db04b59a44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L8ZlJgEqRB+zlxqVP4dXI/VcSUNM9vKEKsTxUEDoTxfIhqXK65o3AJLpgcHENPGrVgzvX5gopcb3jC1QwqPgYFcM1rqOb6phdmuVAtKgcSDPz733MuiKJmEYgZW0B8sLr8Sz0ZbIrU+Eb6F8Ge5cu9hbNtzY/GA4D8j1OpLYoOfMiH9EOAYlLq+2b1UC1zBIdVN4nHcYlO7uD4oWdl3zYtQGpRghpa13U0elP62uknUEscQyh7ZlHw6B4pwd0d0W8hXzkwffjyid0x9qbqdWMg9yR8ETPcMAt8pHINMC4KOhA3+FA80/tAwKeklxirVwIdKm+OHvY0YnA6nFQ76vNeXWMOFfE74obmFU4yKKA7IAWqe9e1J7YTUd0V/wkcZ/C+0bNEM27sHpJYl2CXq4WAHVtlnJ9NmpKPk67yiPY4L1i9ps3TKpGAyDxnM9ZGlC6XIjSio2j+EtjiMn9LCic6rtZBerseG3k3kBhCH7pBjHiKSOACexwLC/G9Jkh98US3rqhOFw/zpa21LHA+XnCa57p7DgC4kT5xla+yR4tZVpEI3a/iPuZaZqtQErqclaDWUp2Q/TKRrYis1sbgSmKti64bacSj8efHvzt9Tp+YTTQTKpxG9dwVfZLw3wcr67fSpqjFetnZnOL2yHf5UAgBsUs5dqLzqgMp5tidcJUygT+tx3DWgb3qi4kslYxwMvL7NrkiyiArgEkQVlKJGo2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(15650500001)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UHxs4GB5E51LCIFKVAhUC6N+ms5UH6KZhaIwXjQQgqxa0JWfbmSzwAqDoAjc?=
 =?us-ascii?Q?eTuF0ESzFViDXDoHMhB+svYDGW7Q78nrAu6CBBokVGQInxsvSahi8C5jlWn1?=
 =?us-ascii?Q?+iz1WTLCYsuOUWvNnGx3hvaOleBwdV3EzA+ZTzzErDOR6hMqm5Z7+tDj2s/R?=
 =?us-ascii?Q?Lcoz7OJhe2azQMzyqQbMzuQzoiuAnQwuiPP9Ca0tsicmlI9BFqGPJF3eoYo9?=
 =?us-ascii?Q?1is6tZLgg2Fxel34+EcjfNqgfoqicYxw6ONyvE1hW3iogHH4zSUMXgeTLXlp?=
 =?us-ascii?Q?Wtyfc9jTbooFBWTYp/btD6S1qRdWNFX93vsfMjNN+5Pv0NXqXb4J3fr27dhz?=
 =?us-ascii?Q?CuszMr3CBgOn99z835aux7zV5ikTX2e1CU939TwbZDaaQamI5alwjFSqoNk6?=
 =?us-ascii?Q?lJqiNPFsnl+3RjTv9WT55mlm073CBfPrcszY54IyQWPNKxLCnRhqbUPGzUJ2?=
 =?us-ascii?Q?TrC1rdAssh91KIwhAPg4tA2KNPeE8Ow5siyCK2CLS8O2+03/WJMmAA1zNBBE?=
 =?us-ascii?Q?1hb4QTqkwxQzgDx5mJQCwceDHS9PXuJhULmBVW7+G2O7oSkGXxQfXSKFqBuj?=
 =?us-ascii?Q?lawpR7sMYCVh/p1J4fhhOAnVwni9Pv1tzkQnFMeBZUu9c91Y9wgt8ZoeS8Su?=
 =?us-ascii?Q?6RmOIOrSDBKs3rMG7M5mn6fm/h42PvXRTgJM03EhYuCJzmKUWeZGdEhjQYXn?=
 =?us-ascii?Q?/hoQPZG8M/u4g+yMOf/eQoQqnit9j7BAVf2baFb7ymsutvGkrnXmcYCutCTK?=
 =?us-ascii?Q?XzBeyVKLmOFgQMPTMKVjBTQC+ZifJxmk0Sk4MX0tJDzk7GATjRRLyeInEzsC?=
 =?us-ascii?Q?Jt+hlrXgn8Ocgr60gdA60mPfmlarRicwaQpha6nttA8Ujpk38w7CBSwrQZxt?=
 =?us-ascii?Q?w0/WZ1FZUKeEsolyXGBB7Cyty5hadT4CiwdZgfg51QHZLsY/vf0eWlQ1Gym5?=
 =?us-ascii?Q?JHVVKqTkkoXKxVHs+UET6eQZwRclauPNybhQ0qGwNauJ3wX5Uh+1hFVXxiJs?=
 =?us-ascii?Q?da2U+KsRMASiGXVdkSlfc3CLGnIEY2LigVyFkGznlk0J+h6mBlQCJ/D7T/Vy?=
 =?us-ascii?Q?NlIYHXMqfpoopFeCD+p/LLTn9AzLwoGGOVBqSri9zPTcI91ZGvP71HDYnKtz?=
 =?us-ascii?Q?hsUSQEYfOrwl2a06xuX4sgHfzy3NIdWVMvPfdUseY6uBo/tYOOZtjWOkd6La?=
 =?us-ascii?Q?uxYAMMgFgSOYSGcoL/4gCjs8ec17eSEC2JSr1nAGw7M0fmxnmHbT2n9WJmxT?=
 =?us-ascii?Q?goysymLii8U8nEZJG+nduar/vpJ3JdTKv9uZOohFhzn5ASyoWWoaiuubAuzO?=
 =?us-ascii?Q?pIfJljHGTOdfDfLSY23o+65inrweqnmpBsSJnoSiqBspmIIC++dLVrKfsK67?=
 =?us-ascii?Q?qOodcMqjC0y4WJiBUQpXE7oAAZieciiz9E8TH9vVpc4qWuM2CNVScx/1jpoK?=
 =?us-ascii?Q?gICKhVHiXSxtAy5+O2nOHVM3iTpe3vEOs5pLQFcQVYc6+ZBM5cPwg4BdtpUd?=
 =?us-ascii?Q?i3Zq8hwWusllJJ8I3unQDxasp+KTyO6PgBsOoZPspB1ccinPE+pZQhFqnWl4?=
 =?us-ascii?Q?7mGkETXNszhapS7KNpBAwEawTkY44OTHN7aJ2K0+E5LcY62DiZVm46KFCNTz?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87458429-4b9e-4709-c799-08db04b59a44
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:37:02.8878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j1J4TqcgMnf794MWDRkPXv3SPvhXw53IrAz6HDNOa6dqZFknNok7RCXL+rKTPUmiYaFaW/YUIgTvK1Wd0v5VKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8789
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

But also things like this, completely omitting the queue configuration:

$ tc qdisc add dev eno0 root handle 1: mqprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 hw 1

By requesting validation via the mqprio capability structure, this is no
longer allowed, and we bring what is accepted by hardware in line with
what is accepted by software.

The check that num_tc <= real_num_tx_queues also becomes superfluous and
can be dropped, because mqprio_validate_queue_counts() validates that no
TXQ range exceeds real_num_tx_queues. That is a stronger check, because
there is at least 1 TXQ per TC, so there are at least as many TXQs as TCs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v4->v5: slightly reword commit message
v2->v4: none
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

