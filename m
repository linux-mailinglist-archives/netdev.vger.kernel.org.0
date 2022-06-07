Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8640A53FD4E
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242947AbiFGLSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242843AbiFGLRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:17:50 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2044.outbound.protection.outlook.com [40.107.104.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B946336;
        Tue,  7 Jun 2022 04:17:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAuppdBUtavHJSIeClIUsHyRS1g+lsjMJxN1IKJPTwneO6D7cGpt1yf7rxWs5+VFtGk3SPePukhsWeOTwN2Gs08cVVoIm/Gg/KSAD33rG8yDL+r9BcPPNQSLw4IC7Bm7ZEyyuFv4ZArYW8xL+5/KiOLhj7GIuiovKOFQCtuozxB/uzphhmPnoDBnUhfm37yNGkFYb270B9jXyjAZC1NBgWI90+qcbxFkdFyxAR8PPYaR8lA4yykv33pBBemxc+52ENU21YVNNVcFDvXUpH/I9OnhJE0G/fDPHdGqlAgl7R1nSmDQX7MnCufRCpYDXgL2Y28myw7zuSVMBq7a1KAO/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vI9xc+QEk78BU6rKlMPWCxwY01p2QlJwSOaecZIwcEk=;
 b=Z4fTtYk14oeRZV4M/gOaAGPCh93wlHR12QBnhfh4UUMa66VDbd2qsaTxR7WKab0ukQ099Xh0F2OqiLDcr91RBxV1fqUNDfTqFrqeqO4RCnOTiEPk9TW0JyQgDRIrVgswKNcGQZTWqktlUMaGq/4XF6wajYPKMM11aU9FaG9UzICdrMaY+r9sM9XK5TNsJEusWbejOHwSW9IYD4ddAvFy2B7PV64pjA5scCnEMZ55uqVW+BhN2weCweRy99s5c3nkzDSxvk2dWfvsDWD/LDH0QUB+qPdym3o9kcVSJpGJqY8g4ebvA0VhajIa1hB7omXnWhuZ1bLZMyuw+4k39STGqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vI9xc+QEk78BU6rKlMPWCxwY01p2QlJwSOaecZIwcEk=;
 b=PMaNH6tj7Wf3HuyUG3newDZpm5MqqdVvw/QM3/ZeVb45JDhHPB55dzP2B18DYyto+khFrI/NC6+uzQXGU3Hd7jcWlin1XcDtV5otwA6U+njjmOL0lRyERYGgGFtm6WhfD+sKbSakR58vNXiVqpQwZtxGaRSkHekgURHD6SQAlZ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB7PR04MB4890.eurprd04.prod.outlook.com (2603:10a6:10:1a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 11:17:14 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:17:14 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        <netdev@vger.kernel.org>, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH v9 08/12] dt-bindings: phy: mxs-usb-phy: Add i.MX8DXL compatible string
Date:   Tue,  7 Jun 2022 14:16:21 +0300
Message-Id: <20220607111625.1845393-9-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220607111625.1845393-1-abel.vesa@nxp.com>
References: <20220607111625.1845393-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0028.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::41) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c8b6fd6-aa7b-4654-cbe2-08da48774627
X-MS-TrafficTypeDiagnostic: DB7PR04MB4890:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4890582F4D5002D701B11F63F6A59@DB7PR04MB4890.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /9g3Armoz9ABIgnDKviQ9gqKfuGncW90s9iYtU7HL+YHFb1lvmqca6rRtz6lGC3s4E+25W1pULD/Dgz0gFLyeL2dABN+k0bL1i0zIF+L8g4zH9Q/rj07/2Elp/lVzTjDfwDuCA0xaWqTLnXKC9LyWJYbbDNrrlnbuSLya39t/qlzs7Wis06Qouc1/wxxwKlWEl7QDXZOAgjp7D8WCFUbfoGdf9a+GVdCEPWnqVgXKcEsN8p6OnpteW8QKlSJh5oBtRtUcFpwww4ffWxZ4YihtbhceNUOmZ92UvTzzI4E/DJd8d2YOBHeu78/f/LKeLD8d57jYNfWN2A7+DixurNXPGUZ9+rTSr66cvMIFEi0pGMrd9w5oCuybW13Km536CLniT+8mkHMtaUX4rx5gliTSM3WEzq7PQ6ItJ3ZvTdFzoRHop05gepwa0udALfyzlTniZoQRXGEzYYtOhLcNLu1G5GDjO25gQRjsDkRR47cws65o7YQFIxaqrde445ksuUEmRVMIHFo8NSLKSOtNQkotM8Mlm+do0VcBVb/YJRglaTLsCL11YQCEIAtQquRB6OpPVlBMEsbIbQ4+IdsRt1JbPYJ5ogm7Gf9M/xiad5YYn4Ge1x4C6ppOVybvlxLQHgSQhFe75yIzUis5Qp4sf4b9FQnM0FLiq51dOX43Zsg3iJAjK36FKO9Nkw2fem26H1gur6YLi2k6HbFaSyiygbryRFsZRu25pQv66QLKgON4nY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(4744005)(44832011)(8936002)(5660300002)(921005)(508600001)(6512007)(186003)(1076003)(7416002)(2906002)(6666004)(86362001)(26005)(2616005)(52116002)(6506007)(66476007)(4326008)(66556008)(66946007)(8676002)(38100700002)(6636002)(54906003)(110136005)(316002)(36756003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OPbFlQAy8MAbaV4OzDimUsOtKG+SWN9g+Nn415sqQ22c7cjPgCipgsx+nr6t?=
 =?us-ascii?Q?qSo/XUvwgEqBe5wKgspinzJgr+16PgAQlgzGKqYjbS10jZJwFQ58Zpf7NF4a?=
 =?us-ascii?Q?p64vivSgElIX3vMCFNn06JMtVh1Urfis+YQtfq0fG3lG9iF9keOv8/8YlmiQ?=
 =?us-ascii?Q?h+3k170rxCg3FMAGoDJIUGB/1M89yAVxVZ7sxdmjplIufqpdePn4kETadnbC?=
 =?us-ascii?Q?IZ0WfbAyo6IJA3Haprs9fxm7bh72ZdRZL7ZqB9Ga23NuLtE7AbI34VAdPG3y?=
 =?us-ascii?Q?5ONsf7oZ0BkANDey1dp4KyDBlmrqBR/UkWXLTAK1fOv7adA1nCl7jDN+XKJN?=
 =?us-ascii?Q?eWl3V1Wmc0L2J6CReQdRforFrBVkCk+veVZll25A7OOlADMqdcsaSK2sAV9O?=
 =?us-ascii?Q?cZ5GpAsm2BFrDBLmfC9uaAsiXfEohCviuyJYe+WGU/P1KXw0trhc5KOytvnU?=
 =?us-ascii?Q?eMiWpir1VfiFp9/7kirqodKRIhJmJ2P6PHnvC9qEn8mzViOUvV8MI24zYjRY?=
 =?us-ascii?Q?g5cpY4uOxwUPikGSeuiZox5XOnPrPuyxqjB1nbreQKEl7JmAS5o0OR05MtxD?=
 =?us-ascii?Q?UxRed9SjggcNDIG/PPs5lO6eNqn9dy5tVFO+Z5gZ0yeFVAIu7MvK07OS5RIy?=
 =?us-ascii?Q?JIAmeNEDYxDaoQXk1mD56usptfK0KS1gfzNoV+rzcZO4e69l6lDTKjHamsrE?=
 =?us-ascii?Q?DvVuIQ0E4EXcjjrs0csYbdbKgULCeEPnHBzqc0o6WuR/YewIjaiBZgf856mF?=
 =?us-ascii?Q?vnEKeVLXLv6Eln6GpCopCbGRmry+4N8xCRAMoAGTT7h8BsNBEUt3HHdMSwkN?=
 =?us-ascii?Q?WgETz0U6nV77qjr29pHE7AYbgB+Z3OwqUD0NAvNjUFzK8nrF5nEF+b754PYm?=
 =?us-ascii?Q?5IUFLUWygFYm9dSUYmgI8XfEM417wVxod2Xg8rPUoYr9oQuEWoUKZ4xqACpw?=
 =?us-ascii?Q?e2bw7DEZIyt8Cc2+QVSFYfxFM1QcXbJkc4m9v0OaQQZdL2qE7oR6/XxLnFjq?=
 =?us-ascii?Q?MM9UVZ6bjZgPFFfTscqgG3P5wDIftv9fJwjBZlTKdWj8tZTAxkQOZPo1OxwZ?=
 =?us-ascii?Q?6QanKUa30gIy0fIyD/bVlx31aLgQo30CvloBOWQGGaEmKbebqtnE4XvFP4nx?=
 =?us-ascii?Q?glT8NjA2XHhm9AQjISNHhQuA6wZPBvgEg2hXmz0TkkdIkGhVca0ZpRBBGCTx?=
 =?us-ascii?Q?ITrB32fgECdrrxR/lJfTJpt9vH7fZgicoHAkkI7CwhpfvRu9lWP8eEkCawUU?=
 =?us-ascii?Q?XsS6ct6y7DzwsBtDcESSKwpzBhsGhS3Zty3xRgNbo+FXyQHnvZe0WipKKYoP?=
 =?us-ascii?Q?h9aEkAGZp9WSlm6dxH00iIEu2TYjqyn9MdQfmtgxXPnYLQlTgIqw6CUp2dHm?=
 =?us-ascii?Q?4z7d0e0rJIvT0EOWbA6DAzYUOrUO/FstTvFm+p6qUytkUcBuNXNyLlIe7Mme?=
 =?us-ascii?Q?XwkWTnealXgd4soLpA5AjLYMEREuF762vr6bj/w4xcnTsr2+H0hv9ZU4F7QU?=
 =?us-ascii?Q?KitWwbJaIQxZarR5KrdGnw/xfVVeAbfmUEQguYwJH2sLX0tkFpywjCUhCHXv?=
 =?us-ascii?Q?IrIBvWMuELxGOniex62r+QNJfldulTL1MixKpWjw6Fvh7+gS4RI2WJvNV9KG?=
 =?us-ascii?Q?BYpGAdAqI5Kd+E90aPxMEwcL2cB+f6SeRYywW1jekTh78le+UAb+2oCgFZMH?=
 =?us-ascii?Q?v1LK4O+rDF0xSEIBPf7Dt6kKgZKvc8bnqjKLNlwQtMGslmhfSCo8vG03xJAE?=
 =?us-ascii?Q?nWpzXJKPrg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c8b6fd6-aa7b-4654-cbe2-08da48774627
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:17:14.3698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3cGPcXRk2FCUadY1AZb+PZekfnBGoCEzzJJn8bzYfZ+hSPyOETxhkU5v5vG8rxO6MvUgsflWWhh17we6Wy0XPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4890
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible for i.MX8DXL USB PHY.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/phy/mxs-usb-phy.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt b/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt
index c9f5c0caf8a9..c9e392c64a7c 100644
--- a/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt
+++ b/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt
@@ -8,6 +8,7 @@ Required properties:
 	* "fsl,vf610-usbphy" for Vybrid vf610
 	* "fsl,imx6sx-usbphy" for imx6sx
 	* "fsl,imx7ulp-usbphy" for imx7ulp
+	* "fsl,imx8dxl-usbphy" for imx8dxl
   "fsl,imx23-usbphy" is still a fallback for other strings
 - reg: Should contain registers location and length
 - interrupts: Should contain phy interrupt
-- 
2.34.3

