Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571E268725F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjBBAhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjBBAgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:36:52 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626EA7448D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:36:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTLWahfSHaoOkm5fUxoAASz12rI47OYpVy7Qo3Gq/7f6pHMlrBAoMvJC9jsjdLzFRc9igv7yHMaYkQuwA4q3YcABDjHEv3VOKDnUcH/DJ8RCok6qh40aa5vIt+7M0M/lC/GcXCxok9Qf9FKFMD9ddkDLkEI/jRrWvBaXZpqxvbP//6BXABWivnFn7HuVlSXLxZtH6tu4dF0lTwx4xqkFaSYpbxbrvI6UhlHvq3gr5e1RxrYLzL5sFThpma5K+sQ1weML5wNuY7l26TgsP6WzSqKfTS1V7fIuIXskzUljyEoNkVH4nzK7SGnCRizYljQ//XGY+ve/e3avbjNUxG1NcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phRpJmmvFQyOX+MBbEgtVUQHxKl7oEH5uBFN0twIGEQ=;
 b=F0090w6RI3MbQwD99LedRE0gnFDzYN+sV4emrhd38wAGbnE37cEugjiwtnpD8HxWa2AbmNNzFImpTsy9HGUTsbsoV0xJx9e/62g99oHNUyRaNO3pQPg6kKQot8vL4nnauxHbs5xW+kQuLQvkZ3sOHa5oUad9Joq6t+R+SFDsdLIllarY9jNwxQci5rhHM0qjGSEtsPF/Bbb02GhckFv4vWugjq4jnQrWEIgadx1bPSO3SXPMdzVNP5mm8i5anNy8w58lG/XfFPvsudU/aOJLtctTK38tK8jB92n8X27FO3EdBxP8Oi0Vg8c6OxYMYZhEtZEdX2IcXZI1PXRtqefTWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phRpJmmvFQyOX+MBbEgtVUQHxKl7oEH5uBFN0twIGEQ=;
 b=ZdTzfNjljontLslTwjbMV//FB6p94ABduW9r1v0OGW+7UdvELyp+LtvBH3RYxKpyTSrBtLgO1gYyKYTQ0fUZXIzQWTxPxdXE4W6KSLr2h5Z2zkmbAVrVx8Zw4aCnYvPZoJRlpE1OHKxmTTZUHh5cuPMWZSLBfpgvmTOFD+UZ1Bg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:36:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:36:48 +0000
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
Subject: [PATCH v5 net-next 04/17] net: enetc: ensure we always have a minimum number of TXQs for stack
Date:   Thu,  2 Feb 2023 02:36:08 +0200
Message-Id: <20230202003621.2679603-5-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7d65b114-8313-49a5-df23-08db04b59196
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5sytAdP901PLB+InVW5sBTq514DzH1ApJOWJaLrTuAIHcNWRVsnm7QFLlJA3SbAaqYU8o3dsJkl/fgZJ6Wt9up4C+VBTvmbMENok7Wcdk9ygos9ylAYXkbm+7ra/62epKRMyK47ERK6o5fyleoCVeXxiCduR4KYFqKuMXzgNVzy3yBuzRE1UzLbEpXgA+7RFoK2Byog+zngwaL4O7VARXy1Uv1K41R7R8fFZAIPtDWsZWe6MfV3rE/eHcoYSZXei0zToclF061ocejOKKYbHloYlFGc6Sl1/wIXGV643MVZncVuHJVVrKhiMNsghGaIjpUmt3UmxsIbv/55InM6u7RbU77Ig+NY3n1R1bK9erNjNKh4zEAkPs3VkCzDUbbQ7LpTxsMujv7Z4ORTzEKlE5H6bfJu40xklupsABud6oYJ3GWBr8d28QffZNu5EpYy/W74FLGzZV8WbjyxyqPH7JAC/k+0w9cbhKk/mSEiVfIIQR6/SQSDRg7V3opKKCD/hsNX71wLIT20acbV/Q/AWl6yENWNLB/Oov0G3hOUOCWvHe5vCODhI0pKwigwij/XoaTV+gvjGNnnakIdB6Iv3g79Ita5WCcR/20rIZWr2dGgQuWiXlJ/ddp2GlQOCN109+Y6QvJThmoOveN0slOqgO9Ghy+0dJuh5Ampmy1R6dpaOysrfL+2DGmlsme1e9s7PKSJccK8xJtSmoa6oQIXxzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hlckUfHkSs4jdXZYx7OsJjRLZQflEiYt9jPirz8/Pcbnuk6JfLJuJL9I+s/Y?=
 =?us-ascii?Q?d2U+o/7jY07OhxLqJugB0QW/rwVrWlmX3YYgZj470oB21QD1QSCrL8r7LuTu?=
 =?us-ascii?Q?zqp922oOUko9WLed19ZlU/PdX5k1Y9XsCSD/UDXq4V5qJJ3pvMA/Uzpc1Wlj?=
 =?us-ascii?Q?YK5nqWhJXJipi8/kph6ZWI7l8aRcRN/QS0u6lUVrMHIpNlOjov2uwsO8f1ek?=
 =?us-ascii?Q?k+qH7GkN5MS2Phyp1h/1driqR23J0geZk3VOpVVa2eb1Y4zhFRtGFW9Mq5p9?=
 =?us-ascii?Q?oqWyQqoC3A1L0ZMyZq0M6S5wrRvD0kj9wcQ60EN5YCRXwtqLwWlIaS3ALNuX?=
 =?us-ascii?Q?O6tjqkO4jTv4yFrKKaSHCr7dANpVIpagWr1cdBKjj73W78Xbxrbg3oCE3/Vz?=
 =?us-ascii?Q?AtQaKI38iGD/sNMbuzCTSRGfF2oeepkIZ46k/vJy7kMN+HZWwjxn/6zTftfC?=
 =?us-ascii?Q?a1S5z5dd3GohxjEOgVNsc1CtN3YlO+TZ1ouiobvlaI+23Q0W7H38IA2XuZfU?=
 =?us-ascii?Q?Y1Z39coce5rQ1gc1vu6QQYr5FTde2Yq/gfAJ+82ZVcZTXLwYc4KKA/jkApaR?=
 =?us-ascii?Q?pkwE/DPDo5uaFQNIyFJx/ziweB23isuUuuS7bk37sQ0ap+ojFXSiFCWIXs5T?=
 =?us-ascii?Q?H7rsC2goZQFxpong+RkBSShDCIVt5pMszctHYjy2hNsS3EGQX65QqUqioAC3?=
 =?us-ascii?Q?j/sV+rHPlKEl7SdU2oXNUV5e+52Xq7Lvfdp3npWBjBC9RRS6c8VV45dWpwSr?=
 =?us-ascii?Q?49q45TYkQjHahOPIn2GGPduZOTpE+pTHBJo7E+pR03B1MAUlX9Qg2otG8vgp?=
 =?us-ascii?Q?5q8Ye8gp6xMXXqSfZUrXFt7dKb2Oi5VhoEefUMQqj8wJgXamhMf9L2XWEzCz?=
 =?us-ascii?Q?ZCDdOv1v3/LCClQMpxY1xR0epGj1y1DZsWj3WgAK6IckH3RPybfSUP7xdi2a?=
 =?us-ascii?Q?CcrarJmJQr6G7JFnsceNryMaQLsLHBWtJ6/3965HxhSG5MqVedCZpM/7uSKp?=
 =?us-ascii?Q?rpuMCiGteO32kY6+c1SszJuvzH3Bf7bY2OlIJEibINptB8hDVYC/dhxi4m7m?=
 =?us-ascii?Q?5piIEgkyuwP57c88D1XkR83h/6ovsc48TmwLZ26abu43BXXZKDWS81HVo0R6?=
 =?us-ascii?Q?WgroPeWv49aXXCEvSz2TLSi6+Qij694gqhhSNsRGnIsGBJNRVNCFs41/QasW?=
 =?us-ascii?Q?1/900hLClkC7cCSqffdZptq/nQyIkrRncYMeP6RCEJiM0EKLZbIGOgLSMl5r?=
 =?us-ascii?Q?4RNowlbNTGwgLtlltUnUFkBVaDrysnoK0fth/USpwYzMY2fAH6xmENMA4Nt2?=
 =?us-ascii?Q?L9TibvI8LFrgzsEoNWGyUo5TBO/AZIvo/Y7j8ebETaVuD9mt51fwKAUbPTGF?=
 =?us-ascii?Q?zuTFxsxZZ4/a6eLz3g9Otq2SQWnX5ps+116I2AWc3FyW5rozInBJtD/B07BI?=
 =?us-ascii?Q?XpCH3vXjEMtMkQcp7t36nrsMrtsggkwFoFPUYMuDrCgh2Wd3IBHjuyGlB8Bz?=
 =?us-ascii?Q?D4JKkckNWyFdv3kytAgIf+LIXM530LYSupZbQ3/463BUUt5rl2W7DXbVgaBx?=
 =?us-ascii?Q?VT4gdovgn/oS50pw3NgqjeB4YpkEJ0ZO2c64b/jXxPbnp3znCmaV6c52GLp3?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d65b114-8313-49a5-df23-08db04b59196
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:36:48.7950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CV54FBhZt0Yjp5vHam/nFVOgne4HYK6leSmIV5iiXzev6pRxvrvY4KJih+q2nLbWeisKOSDv8G2wBHFrU/Kh6A==
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

Currently it can happen that an mqprio qdisc is installed with num_tc 8,
and this will reserve 8 (out of 8) TXQs for the network stack. Then we
can attach an XDP program, and this will crop 2 TXQs, leaving just 6 for
mqprio. That's not what the user requested, and we should fail it.

On the other hand, if mqprio isn't requested, we still give the 8 TXQs
to the network stack (with hashing among a single traffic class), but
then, cropping 2 TXQs for XDP is fine, because the user didn't
explicitly ask for any number of TXQs, so no expectations are violated.

Simply put, the logic that mqprio should impose a minimum number of TXQs
for the network never existed. Let's say (more or less arbitrarily) that
without mqprio, the driver expects a minimum number of TXQs equal to the
number of CPUs (on NXP LS1028A, that is either 1, or 2). And with mqprio,
mqprio gives the minimum required number of TXQs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v3->v5: none
v2->v3: move min_num_stack_tx_queues definition so it doesn't conflict
        with the ethtool mm patches I haven't submitted yet for enetc
        (and also to make use of a 4 byte hole)
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c | 14 ++++++++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e18a6c834eb4..1c0aeaa13cde 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2626,6 +2626,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	if (!num_tc) {
 		netdev_reset_tc(ndev);
 		netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
+		priv->min_num_stack_tx_queues = num_possible_cpus();
 
 		/* Reset all ring priorities to 0 */
 		for (i = 0; i < priv->num_tx_rings; i++) {
@@ -2656,6 +2657,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 
 	/* Reset the number of netdev queues based on the TC count */
 	netif_set_real_num_tx_queues(ndev, num_tc);
+	priv->min_num_stack_tx_queues = num_tc;
 
 	netdev_set_num_tc(ndev, num_tc);
 
@@ -2702,9 +2704,20 @@ static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
 				struct netlink_ext_ack *extack)
 {
+	int num_xdp_tx_queues = prog ? num_possible_cpus() : 0;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	bool extended;
 
+	if (priv->min_num_stack_tx_queues + num_xdp_tx_queues >
+	    priv->num_tx_rings) {
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "Reserving %d XDP TXQs does not leave a minimum of %d TXQs for network stack (total %d available)",
+				       num_xdp_tx_queues,
+				       priv->min_num_stack_tx_queues,
+				       priv->num_tx_rings);
+		return -EBUSY;
+	}
+
 	extended = !!(priv->active_offloads & ENETC_F_RX_TSTAMP);
 
 	/* The buffer layout is changing, so we need to drain the old
@@ -2989,6 +3002,7 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 	if (err)
 		goto fail;
 
+	priv->min_num_stack_tx_queues = num_possible_cpus();
 	first_xdp_tx_ring = priv->num_tx_rings - num_possible_cpus();
 	priv->xdp_tx_ring = &priv->tx_ring[first_xdp_tx_ring];
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 1fe8dfd6b6d4..e21d096c5a90 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -369,6 +369,9 @@ struct enetc_ndev_priv {
 
 	struct psfp_cap psfp_cap;
 
+	/* Minimum number of TX queues required by the network stack */
+	unsigned int min_num_stack_tx_queues;
+
 	struct phylink *phylink;
 	int ic_mode;
 	u32 tx_ictt;
-- 
2.34.1

