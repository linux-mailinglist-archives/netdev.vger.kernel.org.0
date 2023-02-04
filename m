Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B899068AA6A
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbjBDNyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbjBDNx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:56 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2073.outbound.protection.outlook.com [40.107.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA5BAD06
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEvVJiVegXUhx7EJ4BPDnrO0JA00I0HRscbC+K/m/DO7qqc9ksPqKnbGFEigHFR7Z5jOp0W0NS8ezvJA7CgG0kk46YX8F11Gl6xdNYoylEm85OLhpBZKacottHwnohYrg1ZzTC1vDjrtkcaajBXfBKu208gsOfFSt4SqY7bmYEFGfkgbeCopZvB0lXzpqiFlrMKA90oLr2uVs8azZ+353nP4hhwc5umf+zaR/m2pop43mCutciJVpn1PYuyIthLtGn/dH2+OI8k04bMJfHoA8fVK92OxefWo6InvA/2kfLN9H8vs8u1vsnJeN9xa/km58WTMHOTQEnYTDXfDe8Vsqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/uH/sz4RyLoJMk6h9eDuJ6WW/JapGIDIidh4it4K8Q=;
 b=d/qtqnIaUKC5WAEasrALu6xCvf4hu70h6JCTEpf5GlT8BLnQs+Wx7lm4MbjD8RkSDEtn2OpVGi2Xp0PsCEGapPYBvXUAzYRP9R8yqr8RnAkVNED95RAHvXreKOmDS89y3fLHgYsYaShjxbKGBmLbzaZ+BY73CN/BiMThBwZFWmQK8VfKGYbq2hf588ig+0jY/7SPVMWsYfu3UKPOzaNVrGLDq9A1L+j2WGmx+jH9DPGLcfUGNWmWJvJBw2A2xYFZciSNN8UliaR0xsDX4TcyrbLz+S16tYw72C8WyxUb97Z3XA3ryAiuUw96jvFsYikftMECPNws7GRHKvaNYPf4tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/uH/sz4RyLoJMk6h9eDuJ6WW/JapGIDIidh4it4K8Q=;
 b=eFNmeTwTpJ60FfWa104LSxdCq9q97gWJQaAPP/4iv2wWtRSNRkwlx9n7ZLX7G6DpWoi6tTQ7N+aputEWSLY6t7sbXdoXR9j7ISmQEhxcg7YeFQ0MXfU5avbPd86vcWVzQkXGzYgsf+jPwlatXMvzLNk9jlzVtHCaQ5BWYHX4Kqw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9047.eurprd04.prod.outlook.com (2603:10a6:20b:442::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:39 +0000
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
Subject: [PATCH v6 net-next 11/13] net: enetc: request mqprio to validate the queue counts
Date:   Sat,  4 Feb 2023 15:53:05 +0200
Message-Id: <20230204135307.1036988-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB9047:EE_
X-MS-Office365-Filtering-Correlation-Id: 6da92379-edb5-4dda-3be6-08db06b73800
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P6qKR8mMGzASO9MmCF0WxFMpCUPRL7IQo++X46F+Fn6r+Beza1tpLW6xZ2JHZRwoWfr+COCdniYReCougl0UdtYojT5v7wSWfcbIjrk6mSjY8RsExG7Ivjy5eF+QOvmkMuoEsln4gO0tzZTRS/vPQitNx5RRzT2sFU48tT7D+/dURr7F/5g0FO8KSC1x7Q0fnqv899G6svQKKkoaDGhV478KDsMo35YGXfdm9tylMPiB1+Wp4ESiRaYD/PiIwp8rz7eHGwVJpA9qayCkpMx8Ewoa9jMUsU5/99XeIlcVyIuSA38F7/zGC8uJS3aauJVr1ekJ0XWy1bKouoC4uJwNrhkfBIV4YO0VECDb3hPToC8ir4ZZJ+aEJlbHUFha0ZHzRP7o3oUMTH0mQFPStoPNwPH8wPgaWYArD90DxQ6xwLJShHLL8Z2esDZQVglYWfQlE/CBzNPQRjHOovzliRBxOUJmrF/X984CcjtOi084SelErhZh9W/mhqVipG6VAKJecbwfQPLHe1LkKi//rhmBmDZlSjwyPFnuXGEcNTGa9gnbPaAXcsP92Y4zqJ0XTM1FGQheFPURT7/O/D6OH0eYcRQsQ0RqErE75iL5OAkgcNOX2ZP8ciBzmuo4nOFZ6GB9wZ7ZE5Y3RodTnE7jYKQkO6mOX2X3URbdS82/i3kX2K4IW/hqV4Du8ZdYfpExuvd/o5u7FOtKaY5DQQZD1XjqjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199018)(86362001)(36756003)(38100700002)(38350700002)(7416002)(41300700001)(4326008)(8676002)(5660300002)(8936002)(6916009)(66476007)(54906003)(316002)(66946007)(66556008)(15650500001)(2906002)(44832011)(2616005)(83380400001)(478600001)(6486002)(52116002)(186003)(26005)(6512007)(6666004)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/71OYuk3tony00NswhK10DbY2DCKkDGyPxWchFfetxVB3c7qMIabaZ2Bwsbq?=
 =?us-ascii?Q?+zNt3/WMcpVj0gcuHr1/66HWpU97pFaChR4F/gmUyIasYRY5bVe+uZwJOHOY?=
 =?us-ascii?Q?S4XrC5Ox1rteGLDySpmmDFy/tLcXt3Ktpb+RhPH3NVkXpLpWJoItwSigmc2Y?=
 =?us-ascii?Q?REG6lFgcvDGhkWEZ+m21w1NEf5v9Qj4347BkfQ9g6cv6d9DpbecKOgqkeXdT?=
 =?us-ascii?Q?iCXZWc3Y10AdOMtaPJrii2U285ehZkP9mg+vrPoxsIli+Mvg5VHiONM2nUwL?=
 =?us-ascii?Q?D/KMjTAqQ7ubzZjN7LhVaJ6dcyGmp7+5cr7povb8glEkyHCMvufTKsdTssQl?=
 =?us-ascii?Q?iqP3S1oJEgY/nfNJcV8SZ217bpktzWwR5r8GyBJ/1ehcxPsBQ5SJ3MSgg8Gx?=
 =?us-ascii?Q?wajPb5MTawnxUfkYmZLjfdQeCUkntvVB9s7h0Ir31BQlubpx9phBJN9Pr4Lg?=
 =?us-ascii?Q?ElkDw2RBMPqbccNwGKm9pHq7bFs5YRPHCLsKYOf5YYVhx50HG2VLdm9WPNUS?=
 =?us-ascii?Q?IumhrXzQgA/YGd9oGtrdiXmdP9CYs4dDhy+j0pPauKbumOd8t7eRAg53ZLuI?=
 =?us-ascii?Q?mRZir4VUea+cafDtzfAXO8bNzOk2Ibvro3gdJWuB5p/EQy6vrw8nus05URNL?=
 =?us-ascii?Q?OKQ19h4krupGrRMv1B/e2J+YzT7QgclGrqH6XerebSem3UjXCZ44K3qkhdDb?=
 =?us-ascii?Q?1P933uqTT88Sgp5C8uoW3uGC8wOSlvQAthdBNXAPZ6oLbvavJA450u9UF/RT?=
 =?us-ascii?Q?tJbhAqEjFINIMZQEfWeXmFY1SAL01yCfheKV6yKdl4sLk13ouNsqlghGBBWV?=
 =?us-ascii?Q?w0OwD9+gDTHa/ZSdrE+XE1Udaa5/zEDCNzk+ZPeKzrL35pJD8J8FK6c89G8a?=
 =?us-ascii?Q?2xF/lCiCdKWpHPcxxgF3DBCBdqQziSWBqf5e2ThUSXExni6APIWkcYGimB1g?=
 =?us-ascii?Q?O+lCOVPQqX3TPnpA3ch9H3Hh9/Tf9F117vM88OmYN7nj2hD1pJvYs4chfW/g?=
 =?us-ascii?Q?Mx+spS+J17CBszzMll8R45YrwnaFaMsSqjDsj1ZQW/XtrLGPinQSw9VcJ12n?=
 =?us-ascii?Q?JcyyxOC0PvdPRucGX9Y6j+dzWSY2qRbBhpx3yfeUtlWsnrd9jRCic8pEX2Mw?=
 =?us-ascii?Q?GmXLqGNrjgLFcFGnHIVGvx19PntH8WM8Yo3X46VOiSedvwWEgScfxZrm7sQu?=
 =?us-ascii?Q?JYoJjgpmA2AX33386iRLraj9lqQHSRwfMOw01xnyoguOn9Buayy8vPYnAj6+?=
 =?us-ascii?Q?IGuCZhKuWKwyRGPDLVUSUIubGWPdoC/DEdoqEcO3U7LuZ8O63N4To+j0PyeU?=
 =?us-ascii?Q?nPQXw1BWKBAzJHr48g9BLKkBioeqKaENOFbb6pDERokXXzoKqcmcmxe20xJY?=
 =?us-ascii?Q?LL52NR70o8p6UiDPAzJjVQJfWVKLKFsnOmi0QvJrQo5wTD2kJo4ZnpToWaIy?=
 =?us-ascii?Q?VcONLfj8DMqgTsp4eT2x2UFetMyA5oQ8tC5VR0f8+CZ/iIFqnK+aCieyPN15?=
 =?us-ascii?Q?ej6Ar0D3+CfL7IihBwn3RH6VSMujtcd7Ingi2sOCDglE2V2JntAP0vwpIw01?=
 =?us-ascii?Q?DyNKXR2v1DmgD/neKEYGilOREqgq+Hd/vBSkEVHycj/0/Gz6cTQH/c6x5Gud?=
 =?us-ascii?Q?Ew=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6da92379-edb5-4dda-3be6-08db06b73800
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:39.3253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wMLeHqU/0yZZ3P4W2hOvc/hiTE2wFcbU43m2cSP+edr8lVt88pOpi25ucxtdQrb2AueYRxUuKCgYiiMqNLsqAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9047
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
v5->v6: none
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

