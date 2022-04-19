Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD56E506AF7
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351769AbiDSLjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351665AbiDSLjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:39:14 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50046.outbound.protection.outlook.com [40.107.5.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA02D33894;
        Tue, 19 Apr 2022 04:35:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkA+X9fQtPWFZu3ahkcah2hiLAd8O7GG7d5/6f31VREG7PUPxstvQgxOknEUf+gGsyqJ9rk9Eic92GFCfHvgFSNePQ9pRl1FZYnYQCjzwGtp4P64VO+EzeBS1ZG1aOroLbJYSGUMOyrkZwsh6bqqo4rTvo1hSkDSR/hbcixxIlMx6nNbHOS0BmSQv5Z1k8YkumN0zDgepGN+huJ+mQyAsxpGY4GN1gj9Wk4rG2X+LEGLOKnQAIHhHjfZaxyFnURCFYKvG4YEljZun3gFUERlSK24OnLX52JC0rcIiD+zldihOtNZl6HCst4AL38WiGA/sOIwP5wqlMXksYqZNsKLOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFGtMjRUQBtzpYd3zm5u5zd1w5ZSXyOMsXkAbLpFGyg=;
 b=hVji7inV18/xRCGx0E0KZTSDhdYVxTAhP35Mn+94rP8yBBKqOdHxKZX0MIV5NqQzYMbcRBjigwJOTAKvjIhOpT4Zur6feQPadQAKi/a0UnidJakpMMWy6OQsa2vtj+d1or+n3GTt7bgYHNdGqP5ViXLBbQ9+FGrQlp5CphpFdCWlGkitrJ/vU44gZJfEnsEkLo6ROIKUZl1TRQaVF0PimxiIGZ+ItgHR7VXSl87UqIB5K7iQy6TOeUDL+BkCnjDK0KLaR/DvB0gTI0b30zOhh+ePNqo9IL/Fn+WwV+lSOrhhy9wAmvWQ8sn/V78zU3EMuL6OsrbOlZD0Hngc9/WtVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFGtMjRUQBtzpYd3zm5u5zd1w5ZSXyOMsXkAbLpFGyg=;
 b=GdzfUStng359k8R38RP1iGoQy/GykJh3rIAZ0yV23b8+3oNYHyDxvEzCay3Tr+AV5U76puLojvAxPuOV+gUO9FhgUw6HIYObz0CUzSg5jdYJZ80ok7LiJV/Z3qEmFm3D1VrsD9WDNWbQjNv/RlESJvE9imyUogXIsoxypqpeBu4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS1PR04MB9631.eurprd04.prod.outlook.com (2603:10a6:20b:476::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Tue, 19 Apr
 2022 11:35:41 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:41 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v8 13/13] dt-bindings: usb: usbmisc-imx: Add i.MX8DXL compatible string
Date:   Tue, 19 Apr 2022 14:35:16 +0300
Message-Id: <20220419113516.1827863-14-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419113516.1827863-1-abel.vesa@nxp.com>
References: <20220419113516.1827863-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0026.eurprd03.prod.outlook.com
 (2603:10a6:803:118::15) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48a90df7-1dba-4b80-1055-08da21f8bb87
X-MS-TrafficTypeDiagnostic: AS1PR04MB9631:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB9631566FC0638C42A4BB85B2F6F29@AS1PR04MB9631.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DEaOABAJSAOuByuga2v0WChzjvlRg0SAfz/IUtERyezQgYCIYebPow7pbZdEf901vQZ3i7DRtJ47ls6I38qfXaF3IjmqmC/SDetAk1ZYkhuLcjLWpKs0AmEWBlK9RdogpDLWyPwXgm4KZgh5Zgw4JkzT8V4TcbkeDD/6ZIYJUJTFf/aZJULrOrtftp6+mo94Qpo+nSb7x8PpBR0e/H6AXV38dnlj+AblYn3IpYNoJe+7ZjLx55mIAl4LuW78kj0HJEx2TVOlkv/YM/CBGMKbDv5xUgp+xMJ62N7E6tdjsAMRk/RetJJc8/g7pCI2Uk7ytkvqDoxSoOxXYlRHqaT9HhJYhSvsfhF258fW5b1TpEJNFAnUgrTmFLlesshC7r5NGLMcH6LuFPF4yw0ITdY+Z+RmwU0ojGy+W2KQEnguCsB4yyKHpuhyAz5FKWxJ9gURMmUfBm0d3z6yEPaUNiJ1DIy8qmRyzvP39+eim3Tj5CbffyI6FZGUpFAoF31OUIF43n4JoQ6SZSXzuKkh3JUyacuV1aXOyGUq/ioe6vMZK+Hs2ELGoQTJ1btP3vStvFKVGssNAMVDzefRXd1MgvWbtqq19tkwuviP/ac3vdDDBFOc1eC9hqJJjx4YRTcbE/ygm7xbj1pKUm7VonybHnj/wMZmgRAK0TLJJ9utkFVlaCRzO9qnXvrrwgUmdqKjXeCZsVrkREp/K840Fi4qLLDQBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(66556008)(8676002)(66946007)(44832011)(5660300002)(4326008)(6506007)(52116002)(508600001)(36756003)(110136005)(2906002)(38350700002)(38100700002)(54906003)(8936002)(316002)(7416002)(86362001)(6512007)(66476007)(4744005)(6486002)(1076003)(2616005)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sxngcES4QnVT0RoW3J8Hol9EMc1LilxsC7RWt3MXZTdZn5F5ZPXwEN3F4X12?=
 =?us-ascii?Q?txtT0gCSf+stT9b7GT+8m6Dd5rfquZ+oy5CPLuyeEoT8mbqNNte1NeLgS1zk?=
 =?us-ascii?Q?+AQ+gPS+5fg3HW35FH4U+gl+5P+fNCEiRrtuiqp1s6DuH1QeakHship+RdpV?=
 =?us-ascii?Q?ufuNtR2Ob+1I7yqhhKejbfu7G5D//2soa5Qf932e7lsSfdngGPytX1S6AR6k?=
 =?us-ascii?Q?HDdThF2u8JGwv9PGn/PoDet7bgIOqz2vdBSKSrRkTP2BZZX8TGMjiSqXNZBG?=
 =?us-ascii?Q?tu2pF7y/0IODIyyY/FqmUvECyN+rI9/wn909p1NvMflIlIOKbp57kKVo+6wV?=
 =?us-ascii?Q?FQaJakoffjHbNVAraiqQOCyrzggLxhaV5Eh6HNC8yHwP+Xfe31GkM11QqkhI?=
 =?us-ascii?Q?cEaJbEMNTeUtJXwRxsIyVTbh01aVBgP2eP5vpJvxi+oFdW6GwzJdp7kz2vg8?=
 =?us-ascii?Q?Wp/oxMRVcUg51FgIyfJj63QSNzAFHe7I5pwsPpZe9YsQCawYE+aJ84T3cOKj?=
 =?us-ascii?Q?JIHOOhoBQFsxJAe3tGmgUVmz5x1mxSWVaUEB8+UVKSAclnY7rXkrCnoJqbs+?=
 =?us-ascii?Q?k8IUA93a/Wd9UUGkPbiuuVCexnF5HngrJPrXaEK8Ze0XWC0PaXaRLJPVy690?=
 =?us-ascii?Q?6kh4Yn+T4N0Qrc3l+bqUNru87KB9kt2eRnu7tPxwxrjvYYOOEt3Fvg3KfrLz?=
 =?us-ascii?Q?7YRhTP81nU5QsTtV6b0p5npXYGBjzHwnShcfO8z0EiWg2kXZ5iEYbNQLyOZ8?=
 =?us-ascii?Q?Gmff6+NDvT2pG3A9jyf9FZTbjwrDIr+2lIGnG1l7mElUzHMfs6m8TLZKkdMj?=
 =?us-ascii?Q?XZn7hFO365MBWiVWXmt9me+zR+ryUIulpkKN9vX/ZjATjNBswU6dCqHKZ8a6?=
 =?us-ascii?Q?X6IQma4bpxzpy6vvh9+EgUnyYW354RWdEJmFyzHI2fadDyQgBPc2WJm9Misa?=
 =?us-ascii?Q?b3WwE4I3XUpmY3BT4L5fJiZDyyMTlZ0z0q5JkfR2Xk0FhwJ9wR13PBbP2sd0?=
 =?us-ascii?Q?thnisa/kOhZbnqO/Jg/PZr7Y0M6GjQWca9DQCKI2o/hiajH4HXs1KMBSN1KE?=
 =?us-ascii?Q?c1sbNBmNzEFmGeN089cm1/ER8u8edD9PM5DzA10a3Iap+J/G6Sb/+y1CsAMl?=
 =?us-ascii?Q?njMep+be+7nKJC4l+JioYWoDh9Lk9H1OJTS6zSvMrcd3Tkfh5yTdzSUx7K5+?=
 =?us-ascii?Q?l3uQGDi7VJYS7wR0f/NxtBLTB1sNg8ixk8RThynu3tUlCpCfo7ejfjqlCtC1?=
 =?us-ascii?Q?YgDYqyJzFsJkZCi8Z4J2mnYZTppieVJcnbpnUe2T8qZqhV/OOKOPLVB5oevF?=
 =?us-ascii?Q?+B9L3kI3a0CSgp1GkhNzvoSL0hAC8bk7qUHiEnuCeOCSe25WSW0jLLx9IYfz?=
 =?us-ascii?Q?zHt8goWeh/090bjbqjWjqY9LSohOlaSTKknwCvc0Oh1ZxVPmo7TCHsEcbdhx?=
 =?us-ascii?Q?QuS8D8pQ69xt2wHaVZljJqoPx6P9x3YT8U+jFG/9Ihz9aYTbtbbSLA4FYQMz?=
 =?us-ascii?Q?NRCP59Ym1HO1u0b5hGqCd5z4BiFHRTw+h5buqTJQwkr8A61mMMmOmx6O4Sy2?=
 =?us-ascii?Q?11vSJuVNuV6/0i4NtnHRjtgK9gx62mej5JTkvOrctEPduUg+0d6iOn2wIUK/?=
 =?us-ascii?Q?37KqJfu+/p+f5Luf450CK41UQQpB3Ca1bNNU0B0AHDSYX9Qdnvm/4I/aHmMC?=
 =?us-ascii?Q?Zbax77FX5PdajR8orsY/xZsevDBtev1Y3HiJ/7aMO1LZteFL+3haUE5TOpxh?=
 =?us-ascii?Q?Y+WvriZJ7w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a90df7-1dba-4b80-1055-08da21f8bb87
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:40.9549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I++yFLTUSwhLijraXJshgIXyzKRRM+pmtOY0XqOMehVEffic5lsvSj71KsD2v9EXkcXxPS/cVjXIAdUi0YPoDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9631
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add i.MX8DXL compatible string to the usbmisc-imx bindings.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/usb/usbmisc-imx.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/usb/usbmisc-imx.txt b/Documentation/devicetree/bindings/usb/usbmisc-imx.txt
index b796836d2ce7..6bebb7071c4f 100644
--- a/Documentation/devicetree/bindings/usb/usbmisc-imx.txt
+++ b/Documentation/devicetree/bindings/usb/usbmisc-imx.txt
@@ -8,6 +8,7 @@ Required properties:
 	"fsl,imx6sx-usbmisc" for imx6sx
 	"fsl,imx7d-usbmisc" for imx7d
 	"fsl,imx7ulp-usbmisc" for imx7ulp
+	"fsl,imx8dxl-usbmisc" for imx8dxl
 - reg: Should contain registers location and length
 
 Examples:
-- 
2.34.1

