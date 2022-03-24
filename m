Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139324E5DB1
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 04:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348099AbiCXDmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 23:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348071AbiCXDmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 23:42:15 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2046.outbound.protection.outlook.com [40.107.22.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E295995A3B;
        Wed, 23 Mar 2022 20:40:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbzwXLxHpHCdn42thmBwKU71ocI/fqKs7kKWYDFV1hJ42lZGYL/W+1LzkU5HLVkFw6iLkHmuPkvuJ01TFNyxYsM4EOjH3sx8Zw19wCCIb4ARHE/x8fJ6PBWpZAhuSKewTD3s/jfN2UTPvzWpTNOJdUkQ8jiM7xYTFl2293y7OJg/fj7XB1iMVVVNAvXmU+J1T/QfGWIBOEvho2ZOqb+KZH96x9ZTbHAN309Ia2Jqpwx9huN+R2wGxmgtQOvvruDTn/08G9k8vcoeGbdAnOnbQPgRZG7Mx2zrDZ/AWfuNR4eiBHL9xEmt8OQjnPg+wIqPF0kTjbGO7HDbGDCTUJ6ZvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2HwLDeIsovm8Y9Ib4Yu7Z7IkVCFfwqSO/Van1dJqeI=;
 b=WqaS61WJoCWatNLXWnv2y2R5MyhoISiF3tYIQGYTZkPyzcXCXV7hzYvHzUGUQCxRHYC7WHbPkWWw4Ly4e4r+NdaJ6FTNnoyNAIDe4dqlCCZ9hpjRZKxd/aeSdDXckQKIIbZvgTUKAJ2raKRzJnAr71x6abTy0JD+SHyciZXFACAXpLWj0gwx77Bjrm7lQTkcWL2uSmND72IonX9Lma3eYO1937vjyX0yP/zfg01Jsorc/BhbcEabi/4v+VgRWdtiovfo+0ckG+cG4/bG9KHoaXaJyhLQPEskT1OYA6+khorGe7fvPPEX6744NjOmFIi7r/bgqOYxr6HcV4xPSQHV0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2HwLDeIsovm8Y9Ib4Yu7Z7IkVCFfwqSO/Van1dJqeI=;
 b=iqOpL8yGW0pT9G1RRgQkxR6QNG2jsa8cSkezAqJ2VQakM6NZzZ8RQRef2rs5Te5xrqGeTuBbGVsniku1IieI9vnWJP11qtJTjq7CvKJLJWVBf/LlfMDmSwmRGkjKJZwYFxTsKHAqbCCfuYnFNgizLuVKlqh5Xs9f7tC71gyHwI4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DBAPR04MB7223.eurprd04.prod.outlook.com (2603:10a6:10:1a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Thu, 24 Mar
 2022 03:40:32 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1d8b:d8d8:ca2b:efff]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1d8b:d8d8:ca2b:efff%3]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 03:40:32 +0000
From:   "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To:     ulf.hansson@linaro.org, robh+dt@kernel.org, krzk+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, qiangqing.zhang@nxp.com
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 3/4] dt-bindings: mmc: imx-esdhc: introduce nvmem property
Date:   Thu, 24 Mar 2022 12:20:23 +0800
Message-Id: <20220324042024.26813-4-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324042024.26813-1-peng.fan@oss.nxp.com>
References: <20220324042024.26813-1-peng.fan@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0172.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::28) To DU0PR04MB9417.eurprd04.prod.outlook.com
 (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1e7176e-7faf-4789-9fd5-08da0d480c34
X-MS-TrafficTypeDiagnostic: DBAPR04MB7223:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7223CA4237D5372F43F058ADC9199@DBAPR04MB7223.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zR0Gf2DpOIePXAF5B2F3t3xvTfT28mnCjaugbUgNw/azWCthFFDGDNyOJ97MWSy45+OjJdStzgTbfYHAw1hfaXLPApcEFvN0/xxjLhV6VWtmoyF17mRdk0LVrfKSB3oYGoRt1dVU3fjDkkj0fyXcbMFSZ/dvvlt/ryqYOUH6DOPTveGGA1a/IzFIwGAIjNLAKdvjqkJ5W/betwBKYzjsA9lNY5YxL1MtjTd5ekoAl1Pt8WS83KvxMBhWpMQgClhFG9bLz9ksf4SNyI/B3u/9sdIBQ24h7dCenEOZG4kUiqJTtCv2qeyTHr3RTOjRaLjkg1woY1dW1pv7AeWqxqcIBzT21LIr+9d87BzAeWeAgTTJTbOE28SW9GExyWaTRERyNnovEYbH4g86IaPGhRREIlzVhq4fm7az79Q50YdETsvJQFj7o5J4sl92FZERcYonfI7676iIsJmNaEBMFO/QiGK6qPxsXy+fHFyy6Nm9/nK8xORUf1wkfzYaGRYvzoFhGoWsg9Z/8huubV+twPvhzpDRTHc+lUCKjWF+/Z2Af0Q+onXO+mW44PZ2W++bp+2lyQtmcCpgo3Qx/Zec+xu965FJT549sFHQiIou2zXkxwmJXJ+12z2fLWGT7v3P/lW5hKg3xa3ML8XA78XhVSx/r4DOo3WH+DAqEFHny4IEznhRUSPs9U4ypUnK4CT+nSuDz4Mr0bD4JzwjW8mBJ12kMduSBx9oXFvTQLd+CbX+ZvI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(1076003)(52116002)(6506007)(6512007)(26005)(2616005)(186003)(316002)(8676002)(4326008)(66946007)(6666004)(66556008)(66476007)(921005)(38350700002)(8936002)(2906002)(4744005)(7416002)(5660300002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r4BPFeZGDYRfuJ1LtCrJi168COe0LxHKH+CtcujrcUXLi2ZuLe5Djl/Dg2LN?=
 =?us-ascii?Q?S3MDTGeMmqFhGmAuJJTtReHCoZjcsza8G/EtbM+us0UpxIY3r1jGFZH7B493?=
 =?us-ascii?Q?AFSihLunQXnYakNjD1s3oSKZU7+RnKvLD5m8YOWcnpQV2bmBIrAdsaUVJHHd?=
 =?us-ascii?Q?Vq1NiS/+m1nTgxdjxuqbLuIO1zfBmz0Ll6yMIMbRTPv3dmfKDRWz7hTrYP1u?=
 =?us-ascii?Q?t1zxicjvb6osulB4GVh2/0UXu5gBlwtfbazeFzyjBHNwTiWuZN/XrOeuF3kh?=
 =?us-ascii?Q?csFaTRnWVqRcRERK5sj2LFGVg0wwTUNPjsSxVvx9K54n4VY8UlHi4pGPgbSP?=
 =?us-ascii?Q?BmqzqyakFoOJVm4tOeDPjdqlN5vZkXCbk8wJPu59LNn4tZhHJ98Gyu4j2Xew?=
 =?us-ascii?Q?0v8C6UbwmypvdtC4JTHxVH5wmlp+psrzaGyVwdobblUaeAbjIxIBPPPlwSkc?=
 =?us-ascii?Q?szK8QNPKSDqlqWUJTaIcQDNNF4nd659fH0+MsDLID/mR0CAJ3s07N9rqb+KK?=
 =?us-ascii?Q?bWEb+aMJ3bKu2hVtcNvy3loWmmSt+ukxTcva36MDXr6vyC7nDcVNZQ9y6r/9?=
 =?us-ascii?Q?AKZFBJc9rk2Y1y8ju/u75KTIMniKLdl475Apb6SG6kIEWFfjHcLap2KdaoMg?=
 =?us-ascii?Q?PpjXrLmfLRi4Y8RmC0grW12ORhsuODy4+ORQvw5BpBq0CLbsL8eJLw0mUhH2?=
 =?us-ascii?Q?jQjW7Tte1qBOQKXSomqp8HYyk+O4TriRxq1yKQrbabxiRNi7nSfSk+N8gM3/?=
 =?us-ascii?Q?KXRZF738mND1yXHC1j6glveGPAPUixZSS4DMfFnxpdArPiFHS84v3OilGdse?=
 =?us-ascii?Q?/2td8sYSrtKg/ONhXOphOAi4qNwHT6+oX33KOhQGBkaNHqXxCghVRhynaz9L?=
 =?us-ascii?Q?lVbMsLAmDYyG3M+rkwN2cO6xnbtA5kLKKF8ErLtZxoIDrW3faSjd6bYOE51r?=
 =?us-ascii?Q?3BbSWRp2eqOrt9365LpKDWOxrPPQgEQJNj7cOW3/ZFSRMWwDyJBZZX5/LFLc?=
 =?us-ascii?Q?kHpapGiGMefNQ6nbVXcHqntfVlvAVEOWVgiZdBY4e1gyIf1jquDCJVv0yIp5?=
 =?us-ascii?Q?sObdh365DTS9X0mNbesx/9H/qiC0PtkmFA4aGa0Vvj4otKcbH/Xhj14busSn?=
 =?us-ascii?Q?78sJO6sxZDnPDu58rIXMnwxqGzt43+2X/LAq5gUbEo49zRv1NTmZbvuRNS+1?=
 =?us-ascii?Q?tawWsonrcs/txUHzP3QURKE3K3jB2yMjbKuVwoj2AL1vmVu/W0ZFFpoqha3j?=
 =?us-ascii?Q?eLAAnMDaCzb+IZifwJjsGUD4ie4eGpHL7rZpHJIJiY0dhB3yBhjj/s1QrR4g?=
 =?us-ascii?Q?J867en0p2cEYYrVhW7/P9aMeeY0y5y6NuxLNUnFK6oHJ7yn3s+1BTRIVu79y?=
 =?us-ascii?Q?v0m7A/te7b6IHAVbl4c1VW06E0KoKBiAAK5mR0fDmssOpXB9m14Fj2VazW5p?=
 =?us-ascii?Q?6BJ3HuUWf+zyVdVREK3oc0Mj55er7CSkSz96srR1EW3YknQW0DMtD8NtXg2H?=
 =?us-ascii?Q?1Pus37GBTUTk+DkRWK6VOew0uWuiWRtfPH6s5ZTcvQU+qFdRBLlsLupFWgwR?=
 =?us-ascii?Q?OvO2RSXbbUMJM7ekMOKGkaN4K+nT6m3F2W5DrR0nsKa6M4n/A+DwCNVlXnqY?=
 =?us-ascii?Q?3limpICg2uqou3Ln+OnScYRg7h3fUvIk8KyxOnUqSbqnZpHniK7ACOHLqv2r?=
 =?us-ascii?Q?UY9VqJIp3kUAyrYbdROiSE7cbPkUdBKE4I6CWTgDMXLL2TFkOmL+nhRB3KHm?=
 =?us-ascii?Q?bQ9muvaESQ=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1e7176e-7faf-4789-9fd5-08da0d480c34
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 03:40:32.3208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NmJ0eN804H1lnJjtfsPOaZzsH/WWm1Doru8RpxNdSdKGU63DaKvQq9ly0qmevTjToYMQJLWxstPtmGIpsT/72Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7223
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

To i.MX8M Family variants, sdhc maybe fused out. Bootloader could use
this property to read out the fuse value and mark the node status
at runtime.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
index 7dbbcae9485c..67dfe6d168d0 100644
--- a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
+++ b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
@@ -57,6 +57,15 @@ properties:
   interrupts:
     maxItems: 1
 
+  nvmem-cells:
+    maxItems: 1
+    description:
+      Nvmem data cell that indicate whether this IP is fused or not.
+
+  nvmem-cell-names:
+    items:
+      - const: fused
+
   fsl,wp-controller:
     description: |
       boolean, if present, indicate to use controller internal write protection.
-- 
2.35.1

