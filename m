Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087BA5069ED
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351241AbiDSLYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351195AbiDSLYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:24:12 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B99BF5A;
        Tue, 19 Apr 2022 04:21:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iO7QdToT5taU9gJugeYxtJF4t3qzX2U+ChTspI1u89fZ+UGJ2pCys8nB8gQ/kwaLG8DdfT3Vdn+vaFtiTtDXhgE6YGLg/HFrS9I/+8VKqD01vkqFNRwvM63ulIvAhs/6jKCGoi6B+WKfxdHlBBtqSb7uC+c6fn1c386fOps30BRWcL/tRzFs5MqARuodvZKv/R5Snu++KsIzffk0wOlWL3OIL2cTnjdylvHuMo8RRtxtNDjj/GBTiFpVpnWSw8gQGt2e0VG8gQRRmw7FBA6xZCXDDItr/uUm6MCcyhKN8gAvISGgXXpZU282kNo/hHnkuSWdAL7ocIVLdSygn1xlQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85UFeRB/zGVi6eE47DWbgwvrQqugErgznrE2LXvLdKw=;
 b=LXJ8D1GS6Qx92+9jQh9KhXHJ10K5vKDcyZn7OVHChPYUFRlYb5kG2h+ToaGxK6bjr4ERe5ZgSvehQJZwxaP92NZ8tSfa/NVJh5bxxyyzbC7Y6GB2cjmWBUcy7KfK7CsszA+JZV87yOfDxYSt0GyNpJ6PwVtBnJEujUlSi4FzNHNW4TTqruEeYLfbvjKTZU/xyKzRmVZ0hfKUdQlgGni1SwcEZeUUEYfl5HsDTDCEapQb8WyuR/DQFwwLHgLvEcl/9cTbVu1S7FTTvvH2puUJVwrrzpqyl/F+a7QkGKllLozuw+dwVlf29iOCxWOZVQWngPoKQvgOGem45f9Gs+LJ4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85UFeRB/zGVi6eE47DWbgwvrQqugErgznrE2LXvLdKw=;
 b=rvAM6/OmvVPOb0N981tpyXpNzL8GeUAzj8Bk7If8lJpY/hNox2DJZcZ7EKVt0wFYI9zuWA1V0UXD6AYkb8XKw731WkVI6d7Vs3NB8NdlK6fSm8Vnd9kyU91yUvrP3wb5fRZ2mobbHs77a9sDpAgWP14wRqePLDRtQDNzvpkZOIs=
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
Subject: [PATCH v7 07/13] dt-bindings: fsl: scu: Add i.MX8DXL ocotp and scu-pd binding
Date:   Tue, 19 Apr 2022 14:20:50 +0300
Message-Id: <20220419112056.1808009-8-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 02633037-f39a-42fa-e4ed-08da21f6bcb9
X-MS-TrafficTypeDiagnostic: AM9PR04MB7538:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB75389169A91567E85C9C1233F6F29@AM9PR04MB7538.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cppXVirwHAU8BlNkimlxOb6IQj4/2S2VJRNjr8F+M6nwcTgnl0nen7orDe2BRK7FLsqdwOlAJSVKI3I81sqLjEcPPVsYitLZg2Oq3FX3d13YycXBv/BDTrkqsHjAG3qETaG7GblfS5rsFL7gO/6MRqT7QV5aWDqcqZSbreYpQ5xlrL/W7dIzF3xJKCWuUvJuVm71Hs2erLNP5DWzBe3SFtXGx5fy6FNMvAMmHLGbA2df8PSCq39sOa3c1QPCYtdI2xWfp7UMHTm7aYs25o/7mIjHfZPU1iei7tCw5fea3i38ciOKdM2OOI2MqIgwWqu/YbI2zRMGAOBGpY2LhZjEb7p0bVRWeQPZcMFszsg+Zewv+IaEs/2nOKtmwHCirg7LO8zORFPnqHLCkcY2eDzDCtVcAoFsTDu25MmoUgH+9SMlqf8FgQBFp6OmUjjp5gbExeA6YErBUmpgL8CiShvufdnjL6rsTpq8wlmzSPduj7TWdsYOR2b4dqfFqAkIwwmA5jPLDIjxFe4kKKagqhIo4Z9rFAa8lT/PmhyquLwKkeh+b4JlTJFKIy0+jvRhssxIkqVQbuyZI2oXC+jkg9TIIwHdqKp9kuNhqKJr03ZC2J8K3gUk4cpWaUmMiOZLHs0JzqF7/QdYNxj9zBX3O0a43Z3f2d7V6BN3ej4ZiOFYF5ySaY/0Yx7NHaKHlhgSBelb00A7lYF5E83EXPOJVvpP8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(66556008)(4326008)(8676002)(66476007)(66946007)(6486002)(1076003)(186003)(110136005)(8936002)(7416002)(86362001)(38100700002)(54906003)(5660300002)(44832011)(83380400001)(38350700002)(2616005)(26005)(6506007)(6666004)(52116002)(6512007)(2906002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vHiyeAF3VWs7FZ/B/1sT/jnEF84vvm+UOWXxRSbk/XWGdKrcNqZQi4WVgD7E?=
 =?us-ascii?Q?LwUBkLPC9G0WodBTNw8/+lscKQOTa6mXkgR5i0C8xo0PY58CYqc4zKuUIo7S?=
 =?us-ascii?Q?XQFof3f8/yitgA3ZMAVmQouSESdfdQsoT2igypWD2ZmfGHIyPL5RBXO822vi?=
 =?us-ascii?Q?lIhWxwWLiahc4bZULs6Xg2qzVrMX9O6UIRI9CNoCtdEV7q9L7Z98nBUVXM7f?=
 =?us-ascii?Q?gtAe0yhg6hgtMmZdEJjcbSP8/VC3Cg02P/YsoKuWVuNLkFQwImNXZdmCKyum?=
 =?us-ascii?Q?dNMw3DwRsAyk6d75yDH0qaCcmaaUnzJu7rXzkGfso5bchjUv3NQTAFasIHIK?=
 =?us-ascii?Q?v4ew0kJSLqx+uU3DAePYsKrmnffLXmh2sDKeAuXlvI/T/8Xo5AH0k7NZLIAm?=
 =?us-ascii?Q?xtChKQwXgNpeS3aynp7r2Eh+cLKpXl8Ig5TM8JP+36xEf5MIb1IzlyQo2QN2?=
 =?us-ascii?Q?yxS2Ko5MFToMUO0g3Id4XtoE4y38pAXJ6Tusz3Z26fr0xS3W3LXjIYgfeqbB?=
 =?us-ascii?Q?M/whSADChd3hhJR8JwgXfSwN9QXEGVIq9+2+ycX0a0Cyo+GP5t7hhh/gtNQx?=
 =?us-ascii?Q?b99p4zX9yHOxZRuK9W3425pLtgtguxp0aLiy6/bNO2ijy+JyS4X8NqXWJDGq?=
 =?us-ascii?Q?2LKoDP9vpkByh5fq+7+SdgMP1kap8zgyNbe1zpDndTwcgllggY+fbPZSaWqj?=
 =?us-ascii?Q?Zd5p7JPwQfeITZJZ/lLM8ejRnB1jDBo7xVb04049hY8MUW8pJUejcfIk9LM0?=
 =?us-ascii?Q?OpKj/neZCE9ULNGLfCQ/UkVPU0yKDn+rmb9aAOa2U2/YElWerUL6IMSuPmxD?=
 =?us-ascii?Q?f9+zCVs4M0Mv8fq9U8CBc16E95ODS8zwu6cLbTtz44zfs6YTQr2fs3gnA/Uz?=
 =?us-ascii?Q?81UnyHv34vWvFmAVFc/f780rfjef4z6VEMe+SukcSFkyCT/ABEjPiKNjqGvp?=
 =?us-ascii?Q?sFR77wC2jEOm/pQ16HUjGcpJlXqzgZjlsl6n8RT3suOCEPNBFw3AsducDW/C?=
 =?us-ascii?Q?upgIdsfDZXBUKAI5Xoiydkg9G49+wXtNYrYvVL1oDszDWjMwSIGFLOjcJQ3l?=
 =?us-ascii?Q?s22KAYHBCNKfLA5AsoHoP8Wz5tifrzRSpR1y6XfgXQy8MYa3dyTlZPs/GxHR?=
 =?us-ascii?Q?vaaGPHQaN8S1ZKFXq7dpVVsvvXYYsGMKNZfW3gULltZd9tfBO8ah2/cYpuTC?=
 =?us-ascii?Q?d55mllGUEZjLSyiUjbIn8UmMkGQulf9dFMrh6+THHXoLH+EK6qOPH0UkWi4d?=
 =?us-ascii?Q?pcMrMENc8sNVZpaePNNF7P9/9ryuQfCLQX5Z5HEnrD0i68Fg8F6YRxkQ1+AI?=
 =?us-ascii?Q?xUqSn7VvKh9HWCRQUiJduNKb3fS32AzdyMmvZQftUU0Tb+EVxKjCkLXCeLjR?=
 =?us-ascii?Q?KkTaFirKlLZjIvuQR17QlL6ar4yuoaIXeM/YgUBPap0Qh0W3o1u0wlrlpBuH?=
 =?us-ascii?Q?eXdcGdgNXq4mS3+YGAO9kbgCrvnd7QVQIT1tZBzIQ/Cpxl79X+9KoYKqIHKU?=
 =?us-ascii?Q?bCZycXnq4F8TSO2s7x4vICBKh7EwuN08ALnQB7Q3znJ8HY2Fw5luj3cJRMua?=
 =?us-ascii?Q?CRAmjxXvBdE7coJfWFC48M0KoLsMqMlOoJ3F8ur3gRD5EzxyBdRizZxCJzCB?=
 =?us-ascii?Q?edHVhES9tByy68EfRGwDJ8dcQoFeCsaCcNX/nMy37/PeScFbqSA1c1pLbq5I?=
 =?us-ascii?Q?DkgVCdKo9vbQy+zf9IVugdTf9OOrpvNV65NQHD6yif6+xo8InYKQtLwR0CyR?=
 =?us-ascii?Q?Fu5Q0cGi+A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02633037-f39a-42fa-e4ed-08da21f6bcb9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:24.0036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iMEOgUPsW3DU8Wd3Mwig/Ucfo8oWcb5XWdvF9P7wlSb50NcVqEL4ioEJ6TfE36CkivLJgQSACqFJx9y7u6kswg==
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

Add i.MX8DXL ocotp and scu-pd compatibles to the SCU bindings
documentation.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>

dt-bindings: fsl: scu: Add i.MX8DXL scu-pd binding

Add i.MX8DXL scu-pd compatible to the SCU bindings documentation.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt b/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt
index a87ec15e28d2..27a2d9c45b0b 100644
--- a/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt
+++ b/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt
@@ -70,6 +70,7 @@ domain binding[2].
 
 Required properties:
 - compatible:		Should be one of:
+			  "fsl,imx8dxl-scu-pd",
 			  "fsl,imx8qm-scu-pd",
 			  "fsl,imx8qxp-scu-pd"
 			followed by "fsl,scu-pd"
@@ -142,7 +143,8 @@ OCOTP bindings based on SCU Message Protocol
 Required properties:
 - compatible:		Should be one of:
 			"fsl,imx8qm-scu-ocotp",
-			"fsl,imx8qxp-scu-ocotp".
+			"fsl,imx8qxp-scu-ocotp",
+			"fsl,imx8dxl-scu-ocotp".
 - #address-cells:	Must be 1. Contains byte index
 - #size-cells:		Must be 1. Contains byte length
 
-- 
2.34.1

