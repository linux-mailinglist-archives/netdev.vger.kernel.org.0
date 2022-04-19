Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CB95069EE
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351244AbiDSLYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351234AbiDSLYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:24:21 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDF8275C4;
        Tue, 19 Apr 2022 04:21:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SocJhu8J0YlWDnvAwnsvhM5VDfKe5GPxrFxSP/T97TylJbw4SDQOBAVri1SCpYJj29z6osZeHpQuPDs8F6aRxjwUo802WRTFx24VTSqBrH/bI3+/jvvpytzuB1i0ap3/VWQNStGWBvCB/l0MnbfpbPRNlXkfiGOvtpMk0thTuZIAZ9nBRxS2BpTKxkHkblmHyxISHcgb69kXg2vUYeidCDshhgW5JQqsbpRsR0ND83pY+8ojVwEEil7oUPpMi/AAiUenqlrFU+WZK/0uLtuDKV3Vwk7oZwvHYrEg7TC4vhRjd9ZXnU4ln7VKHz9n4hw2awYuxhz/bx1vnuDbzWCtpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EPRv474xsMFo2sxO3IZnpYcT/ehhFPoteTnA3S638Fg=;
 b=LBjvMUKKy23U9fv0jx3DvD1IyQvYNUFN/g7VSaG3zCAMKDYbfpB8w/d4YcLY8x6qqV8LVmWu3QD2fNMOox+ezasjMr6zuFy43j9/VVGiEABZhyc8HjBcwU9cQs9H2QeOF4fIOenp5w1XGRNWYa4Eadv/BkT5+zZ7IM9ep3Kp5DGj/oOzbeERlsJIvw+ts7yivpcAiARF3132Yna6xtqdge1BEvLf+yNkxcB9j/zOE7HxIbNE9qURn/YlTiaWliI8MfV7hPTVHPuJfAEikkZQPvkotEpqyFDqQwmOHrE0TmBmuotQ3FJ7FrDRi76UOI6XnAy2o3ijOPhaqFN+vhTcjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPRv474xsMFo2sxO3IZnpYcT/ehhFPoteTnA3S638Fg=;
 b=Xk6bP3yQEANnKKlj0pViJhkQiruXXrc8+eGefwjrDqdqMMOs3AzEk1NWNth+CQklGTULADAfHw6XYbVcwldBh0Z9w/6Man4pDItYEVzostzvpd8zbBxdwRAWpDQMHJUBODLNk4pJahdF0OAfD18e0m/0+1xFOK5YSrUqn52+2eo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM9PR04MB7538.eurprd04.prod.outlook.com (2603:10a6:20b:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:21:24 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:21:24 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 08/13] dt-bindings: arm: Document i.MX8DXL EVK board binding
Date:   Tue, 19 Apr 2022 14:20:51 +0300
Message-Id: <20220419112056.1808009-9-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419112056.1808009-1-abel.vesa@nxp.com>
References: <20220419112056.1808009-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0008.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::21) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46c39360-e110-43da-dcd5-08da21f6bd35
X-MS-TrafficTypeDiagnostic: AM9PR04MB7538:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB7538FC6F56E9FA00D85ACB57F6F29@AM9PR04MB7538.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GRubw7zuDCDv3/7cig8aoy6WXTswNkbDEuD6ftRSYq/2Fv2uvRyyA2ge44Z8cq0UwBYanDRh2Ns9PElNiyaxpPsWnl0hACWH9mr5HjK5Qz2Sp7SCW+wuQdzptqJ+I5vtKmeLtfrhmo1gypQB75PC0Epy9TZm7uRE5TzA0HeuxXpPqnSXdPpNng5ti4GcCjnrUqr4iVw90wgw0wLxb7ifj1GE5lyrfl3wtemxR+7SXDPDb5/mPEJctSZnWx5WnAQFaD+jb1WFWXswSpNaiIfPX0DDYlret10B/WEoAJFUr7fzXuoV1zo67UYrMjaulehpQO7i8qkpkZYX5VJEnBXb8lUGASyg4VEUjcE/DMDmY4TX4j2+diNaiat4FXjnYpLxQ9b8gL4U8vdbOx+NkV2PSNapPpuga5HMMrGpP2wkOUgottrhAfhPBQiXDg1yrwAZSRfdCNw8FAjAvqc8YW7f/wADMuFnO9TLvDSpNQkotbD53iQgV81V4+bHIs7OcO70Gulblh1tDtqBKp0KYnWBzsxDK10EkzybW00XzZuKmG8foMCxeIR53Rf3TzKz+5RFTZb0NjDZ3OGIj3RlURQ35yau4nq7fN2In7Sz7aJj4W3svPoO7M12NObVu+04iRaowvInMDWl0qW5GtwFq+e89ELsVBuLsjzWPW0tL0Mq3BqkrkCAlisghrzTU/nGrMo/eL7ValCIZxlE20mtUKFeNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(66556008)(4326008)(8676002)(66476007)(66946007)(6486002)(1076003)(186003)(110136005)(4744005)(8936002)(7416002)(86362001)(38100700002)(54906003)(5660300002)(44832011)(38350700002)(2616005)(26005)(6506007)(6666004)(52116002)(6512007)(2906002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BIrm2unJdaOvZHRVKGkcrWin2LJzShkgeIven3clLM95jYAwULbiX607gsQW?=
 =?us-ascii?Q?3gGHmUMuVGtz7dtp5xGnbF4BytgZJ+iuXD5MKWj2vbke1CdEFSZFvJUMjqS7?=
 =?us-ascii?Q?SbOu1S3khqVwhYXRaKOWfAJpCK+5z5KovMvoX7UPovhBStEgQX5uwzniZpwr?=
 =?us-ascii?Q?Tm4JU+pFIEZdYEzle7o0pBOx2MP4GeuFXYKPiFe1eB3L9YUGl19YPZ0ZtdRq?=
 =?us-ascii?Q?AUdP/WVu20PDUn/lrqz0CEEohdMr4i0GeU+gvjSUI1NGrOgXtlRqVCVfnvbt?=
 =?us-ascii?Q?krQ77lyQtVHffwSnJ0gHHiABYY2u2/geKyTxkQ9UMzdJOVh+dtdZeTozVhJi?=
 =?us-ascii?Q?6er/HnMSSDBkWrQHlmdDkUrLdKm8QgELG2PDMn4Emdi1Y9GpjcRof0qKJl7G?=
 =?us-ascii?Q?ZEyY+MyOhE9dHTV76JvMATgiPbLojonDupTV+Q44ihZRcauIMWV4e/qdRBzL?=
 =?us-ascii?Q?pepjlO13A1RIUCwyQjmkY7TumaPbMu7kpTV4d990qwmm4raepfXO35vfi3r1?=
 =?us-ascii?Q?EjJn9ooLaOHsutv+YS1xIeZ//mI2GH4Z0jkddX/MdAJQmRPUkuimVit/Cr2a?=
 =?us-ascii?Q?iB+Vz/q1GCsOJsGR91ZvhIa4cI21XprqItkvAovRijNJAVTnN+7LLIoFE4Hz?=
 =?us-ascii?Q?S41kznsALPtC0dI3yaMeDrEaT63ecVPsZd1TIu5NEmhsq0LMxfjknb/4lxM+?=
 =?us-ascii?Q?jWel/8Q56ds1qNOkDmXB1j2jvrJy/u8HuIw36e2fr6AKKD/pfsFa2oWscXxt?=
 =?us-ascii?Q?h+bRTLg87NQGAO12Bxjfo3ImzuV9ljUtPYJwBRVO2Gg2siZxwEvSAPJnZfbB?=
 =?us-ascii?Q?Av9aLNLhlab0oMDRJTcUN57YMAlpulCOMICurB4vqgKQ3tb9y54muKoCUh+z?=
 =?us-ascii?Q?P9iK2M408KxOs7K6HVnQG9Mc65oJar4uZUyhAQR56OOPEavtv9ls77vqJvLZ?=
 =?us-ascii?Q?XFIiRWZvapn9/TriAcwS1WhDM2g0M7K4oGeYD3FGfE+vhxq+kI9vclmH1vGc?=
 =?us-ascii?Q?n0br/DPaEgJg9XfZU0IzgmdeP7k+mges+Pw6tYPfzcEuFylDOnyKb7XgQSO3?=
 =?us-ascii?Q?kOhzptFZnnT2w8/P5zvUEBqs9b/ITEwc2rlVD88+bNU9OOhJMZ6PqVwIKFqd?=
 =?us-ascii?Q?0betfHUTCl+TpWdo8kAZoX55st4S4SXxfz2i+Psm1fgu14BZ46nj+cwuh0y+?=
 =?us-ascii?Q?hIOJaEdpk/+CwMacCywSDHX6qtYrr2C9EEZeX6sV7BpPKrpUuPA5faKJJb9l?=
 =?us-ascii?Q?d5KsxxM4EOlN8BiRWHrBLhaOyk5KzAjAEe7sR8LrFr7JNyrSNDnPUSx+2HAX?=
 =?us-ascii?Q?UqnCODTds+fTRJI/+uyoi8HCTlB66L3tiOIuBW3lumSNHcRI/kwOFmeaZfFk?=
 =?us-ascii?Q?17ZoUQeTygLZNonxCx0DXV9Euo/CyDgR/xOrGNH/WFXg3wvpAmrkh82GC7IP?=
 =?us-ascii?Q?0RfDerFLcKd7qQIB8ZvYQ0Kl648KnWeWpC+vIe6mpEdYd300IOPtw4w9WEnH?=
 =?us-ascii?Q?VI9co9aXZgBe2KcKavPd7CgGUa6ud/mTLxLwVICtQY2nslPsDZ3LdzfokC0y?=
 =?us-ascii?Q?U8I1T6Mpp8mUEKojSgsF5RUkslRKtptf29dlriHRkL28N0yrp7HMgNB1NIlj?=
 =?us-ascii?Q?f8x5BAum73s4/YVgj9kne7HCKiscHnJPLEFTTcszocxCc2e4c/7dsz7wynhI?=
 =?us-ascii?Q?fV7d/C15WaA6CNyAOPa1dBAL8DYm2Gan/PD5PvBiiqTFuv63UtVYmy9yjdZo?=
 =?us-ascii?Q?8NP2971A/w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46c39360-e110-43da-dcd5-08da21f6bd35
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:24.8472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0TyUBUT87dIdNtqCj8cd2OjrQIIi7dMumpSjorbHQ7zEZ4kUYgXf9aEgyIGnBuPVlsSXnSjpXuugnCaDAmiebw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7538
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document devicetree binding of i.XM8DXL EVK board.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 Documentation/devicetree/bindings/arm/fsl.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/fsl.yaml b/Documentation/devicetree/bindings/arm/fsl.yaml
index 13aee9fe115e..a43f3ba53ac7 100644
--- a/Documentation/devicetree/bindings/arm/fsl.yaml
+++ b/Documentation/devicetree/bindings/arm/fsl.yaml
@@ -798,6 +798,12 @@ properties:
               - fsl,imx7ulp-evk           # i.MX7ULP Evaluation Kit
           - const: fsl,imx7ulp
 
+      - description: i.MX8DXL based Boards
+        items:
+          - enum:
+              - fsl,imx8dxl-evk           # i.MX8DXL Evaluation Kit
+          - const: fsl,imx8dxl
+
       - description: i.MX8MM based Boards
         items:
           - enum:
-- 
2.34.1

