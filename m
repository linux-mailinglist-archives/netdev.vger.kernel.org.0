Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F57668A3B
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 04:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbjAMDfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 22:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbjAMDeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 22:34:50 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2086.outbound.protection.outlook.com [40.107.6.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533AA63384;
        Thu, 12 Jan 2023 19:34:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJAg1xfA2DTd6pSMMSyzLXCVO55Vb+Nn6Nwd24DmQNwqOsHk+mk36bfD1roD5dx4/ZvHyOXY4pssOXiYy9y3Eu/ZECurhyUczYt88OxExOGs0XWQI7brVXHnzBQG2TXFHuAuVY9u1cllkuBVilDmMyq36sUT+gPs1U2C30wyAsSJPDR4XwIROPxgpp3++C4c2WvAm+h4vHSsVRpbgtnLH0MgpVxslKIVLMXr1fAXm7F5IfcAprXDJ5kBs4g6B/Z16TNEqfmC2xFDLGT9IiwxN0aI+zF8cVjGDCD9bT5/qFl6WUzPcHMecITNyYIjysewPPyD7nA3X+HfH0nW5DcKeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LWPRI+FCdMvbYDNzHaMASK8u+UbaJEbfJC8qyUl2utw=;
 b=Y9TQb/romd2QK18Frppwyxj28m5mW38ni6zAKTNlvaKlFDXZw5iReh2p7vv1DFiYi4/bQQlmoMb0nnVsdNSzh8mR5vGQPpo2d8XdSCTnArJWzFfavtpkdBvtJbd7gYw42FmgitJcv9wGqxA7q5PGJS0TPs049b0vYP4rbdWgj7MR/x8jzMyFzRkR06DZXO096biHLRQdAia6V1bbLM/613KZxqvzmEmx/yPtmk+rLSTuR+h4D6YeadiupXxn2HNSorhSOvJ8fUriSniOlhj0jPk4gTT8uDycrDqZ/nOQzkl8LwPYPV22WfJoU8VO6GV6xnePRCt1/fV1Y2YVCjT8iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWPRI+FCdMvbYDNzHaMASK8u+UbaJEbfJC8qyUl2utw=;
 b=AT+63c/AjZ1W35OTKYk/8OpeXIjfo/REBFk9VQGiabT5mlXhOvUiSa5DKPo+DqIq8N3B8j5CGlc+BGuvvBqXmPUaSr45BTvdG0+vcwmZv4/lx27KoZGw3Q5v6T+5Ij+Rnyhlhjl6nNT2ADOG3baFRFBPtMnn+j6KCkjCsOB7Udc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by AS8PR04MB8247.eurprd04.prod.outlook.com (2603:10a6:20b:3f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Fri, 13 Jan
 2023 03:34:44 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c%12]) with mapi id 15.20.5986.019; Fri, 13 Jan
 2023 03:34:44 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     wei.fang@nxp.com, shenwei.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com
Cc:     linux-imx@nxp.com, kernel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH V2 2/7] dt-bindings: add mx93 description
Date:   Fri, 13 Jan 2023 11:33:42 +0800
Message-Id: <20230113033347.264135-3-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230113033347.264135-1-xiaoning.wang@nxp.com>
References: <20230113033347.264135-1-xiaoning.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0029.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::8) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|AS8PR04MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e163986-2d93-433c-805a-08daf5171c6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BGvJQSv49rKoOO4aHpvROulIPlLGn0KIBLCKvXHqJIGtcMxYFGrf82+Kkq72HkaCaKX5R3BlMJ91z6o7ARNaICRvbauR/8SWl6jCyzQ+mBYRvD/rEPcSAfbJ/+E33iD9vQXTDR/hGu3qzFuPWSz5S39nsKk7kCZOYUOjmlygLisghSp0n2lMwzeKGlA/MOHME1Xmgzl0CyXefDXTNghGBEz3xpu2DqRA4JidONiDvD2mKuBWWw4sBr3yH6430M1Sgqqu74FkhTwTZ5ylLN7QosfrAm2HOYxJmdoUHhuyc6qR8QtwHuHD+i5KDWP8R242flK+uFYL0W1CeMboFcG3+mraazbW9a4Xvj+C9PCdTSWwp8bzXOxyA7tDoT6bZjcFf5UXonDL9r+aSCrKmiqfOlg67A3q+3/6caOy11M8d4vU+2nkWNu9KH1XCiKsuNOznTJnyOFKhYAQ5kfeWrWfXVCG8AoshbiuWovbPsmuh9F92RtWeYAuQ7+93jp4uP+Fv5VAOnnYIMI0mra2ICr4oEKd3JidNp8RBAVVgfExrCMtlbteUnSnQCB9m0Irdm63zU6zS8Y20tRtvqwiYS3tmXccEkDSJiEU5NxwzPtcDX8WMH/VxSleRU8DRz0tMDD4rUH+1obm/n9B522pTWyv4YCS0OhohIBUiLy25xQBNe5K1FBTiw8PlfgFf4pJFvQ9uOxyspc/LpDEPOPXKFSydV4TRMUIcwBoozcQRgi4b6PHm7l6uycoTCMYsijHe0yXH2i7qye8LFrfAoonfKxMSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(41300700001)(66556008)(8676002)(66476007)(66946007)(4326008)(5660300002)(7416002)(921005)(316002)(8936002)(2906002)(86362001)(38100700002)(966005)(478600001)(6486002)(36756003)(52116002)(38350700002)(186003)(26005)(6506007)(1076003)(2616005)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KdPkjwXXYM39vxe/jwMeLqIdKocbG0P5tJrpxCcLp4d8F3jo7vo7yVHUCGqH?=
 =?us-ascii?Q?1bQRzC8Q6VECc8+4dzL119j2z8J0YvVsGgxzNMgbQa1GEn44KeMq+UGJGZ7P?=
 =?us-ascii?Q?WDD8dhaLOLwyvTUiu2pcGv6yMSG0zDbKWSPMH9b6FHwFRTBPIWptLBPJ8x8O?=
 =?us-ascii?Q?G0Z+bmpzgqWfqmK9b3G1Dvtd/vypSVsUFKKj3dxgMsJOA51ThSunzUrfrcWk?=
 =?us-ascii?Q?oZt1ceQy+W8ZJGjQXK9yE8GAcy9n1hPC0S6pKaQeF5epacYkUQrdueVbRMKL?=
 =?us-ascii?Q?wNVOcJcfZKJvWdqIec8NQBkayXmxIYVI1Ox2ZCS5Z/FhnRv6SYCQLP/vEg9H?=
 =?us-ascii?Q?TiVteoM49qcg6Mml3xpnYMkCEtY/beF2wopSQvI6vAX3DVnhPFZM+nzdd8uh?=
 =?us-ascii?Q?dlLGPqygJIi4ZGQlX2MeQ5o22YCnGtJlp9Lcm3J3HN+mluT6liyRcyZoC9yz?=
 =?us-ascii?Q?AdLK7zpE1yr5ZXZf2pZS6CO2XjRWAXbFA1i653091tGF0Y/YM3majRENmhKI?=
 =?us-ascii?Q?4T3vgBfjL6ele5fFxciNn2lugx2Uo/FTEDG+yHPKZUSlalaOs0AfZ3FPQnJ1?=
 =?us-ascii?Q?rE8HTUGjIlKHrEjBdGq6AwzKeiCWpP/iQS10lYcZOgqvVM+agu0ZA30Gbx3r?=
 =?us-ascii?Q?MQUxqeXUfn5LssycWBjVZcDEjXncV+ZHjaxOR8pdsi0d2S3ReE8uhshWemH8?=
 =?us-ascii?Q?ShdoB6h/uunLjcsZc5cV8WPoiOKyHW00JQXfziDkrBXFSPQTDsAJ0leLG/um?=
 =?us-ascii?Q?9N2ORgmZ9JDniCR2UHRO7wm9rwaOQAmoY8NerL5deUrZlgLX/vX/ipUSfyih?=
 =?us-ascii?Q?d8zOGSojUveZI8vFnUzA2qk6M3/lvvQukREEYGjJXxr80AFyKaGfeUoMw9rn?=
 =?us-ascii?Q?MgJolCnntq855vIqXU+ezHKeeZ7RXd5+NFk2w89MU5NIBoA4vWX1S/SdU/OR?=
 =?us-ascii?Q?dlIJSyc3HoNZmyRzRWcS2h+B07L5jgSCCiXgdpnpI0uE84zziCgURdtvD2E4?=
 =?us-ascii?Q?zJ21WrujSBHORXjV91OVqTELvtB+G9OHCZAYIybhY+vNGI8pmAysfwE2G3D0?=
 =?us-ascii?Q?iwu0/j7XJy0XWUXWDmy6JGhsJnTIIcEC4IhwegZkTIUJnzuHnXaUQK1S2jfJ?=
 =?us-ascii?Q?EjlDtt6MQKiqNWr1Wx8xO8p8/xWi0tujiJOd532wDBAjR7nPSIyqR+qDkQTz?=
 =?us-ascii?Q?RvjSCWNpxPqRicb7q990z6DdoLF3ZhmiRPIS0BaS/h9vNUfTOI8aT5AlNslw?=
 =?us-ascii?Q?s4aUEACGu6NRk0GXPeKl888XEoijpDXgxJp8ZNmgoSSNVXA75QBh0ZqZOSDG?=
 =?us-ascii?Q?eqIO15/9+sJMJuUABM4tBaUHqKxU6RJxPt6yDSg1AFkerlVIIoxnwH5OcKde?=
 =?us-ascii?Q?85V4noL3NLaERnl62XO6NYizeo7FTgBtiZjT5s4iiliGh6gIxvPAX+EgSLIx?=
 =?us-ascii?Q?l4IWcDf+Wr11Pp169+MVWRgqyLzSLjcCAS3Rf2mqCUX+tWAcPRdtZ9TCzTAd?=
 =?us-ascii?Q?Ffv84YyAKMsjZD4WdM7CoFDvXfihfMmtHr5JPzCABDkD6g2TEFKDnLrsBvNv?=
 =?us-ascii?Q?HGHlIv/UfdteplgO4Dp40UzgLqBx5QCjhpNB5h9o?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e163986-2d93-433c-805a-08daf5171c6a
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 03:34:44.0515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGMJdDm5YbxyrVOGFNLAvHCJeaLVi+ECmPW7PsQ6PA4b488tVcZ9FF7jTvR6vk2/rGkEunDcqRwafDeWKfrUnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8247
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mx93 compatible string for eqos driver.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
V2 no change.
---
 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
index 04df496af7e6..63409cbff5ad 100644
--- a/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
+++ b/Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/nxp,dwmac-imx.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: NXP i.MX8 DWMAC glue layer
+title: NXP i.MX8/9 DWMAC glue layer
 
 maintainers:
   - Clark Wang <xiaoning.wang@nxp.com>
@@ -19,6 +19,7 @@ select:
         enum:
           - nxp,imx8mp-dwmac-eqos
           - nxp,imx8dxl-dwmac-eqos
+          - nxp,imx93-dwmac-eqos
   required:
     - compatible
 
@@ -32,6 +33,7 @@ properties:
           - enum:
               - nxp,imx8mp-dwmac-eqos
               - nxp,imx8dxl-dwmac-eqos
+              - nxp,imx93-dwmac-eqos
           - const: snps,dwmac-5.10a
 
   clocks:
-- 
2.34.1

