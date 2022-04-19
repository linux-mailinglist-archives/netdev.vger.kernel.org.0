Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83A6506B08
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350016AbiDSLjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351556AbiDSLjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:39:14 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50077.outbound.protection.outlook.com [40.107.5.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C21338BE;
        Tue, 19 Apr 2022 04:35:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YU3xwQQIJ9Q3QfyQlB0PJYHM8jqkbSvg1FfqnJAtx0mjdcmXa40hO1SgW+AAtHtb7JLHPBQu7+ryY2c90S6s7pxzLEcN6xrCwlyy9fF6hBA+B1Kq1Xb6dK+Yx6R9lzzJg5/qrfFnYvOmwGLIX79RaricWKVnxW6tVDUubVdKc+CMBouCmvF6zFUDJ8DhjKbFmNO3lGMDTYzFY7jIRnrfEDb8qB4gcp9fgJKN2GRO1vz5OZtOv9yc08V5Ky8V5vrUtbZy/O3nOlrThSWMS8RndGN84iZ3hp/bbzAEQPAW10+bLjyvo4Q37F//N9Ji+VRM16S5hnEO0ZACM1PC2bAjdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/eKBazDZxqvAHoOkIoEOsjjDaj5/VIGqt1Q7ZI9Rao=;
 b=i2yRwiS3r7Blz/uFfrAfk+f/pCi5t0nZ93eymvYOwkNbLy4g22pK8EOv/0Uytk1hLzTUOENSUllELxFKXMrcPgapZ4VzqLFclDPEIFylNNJPtCYGW/g2Laxc/Tn7SaSZHvemfNHNK//9InogBdc74ra1d0GRRkI1h3NuiTf/i6Q1FlNnaQwC4DIL5vYs/FNq1X9Szb3ibkvPlivOsA+jFhhkxmbxanYrT1FJbWyWdHG0e8lbCupa/PBtGtSTiXr3JZRi9jHtNrZWebrPHoM8eC4rxBhbDldrofYdNkqCLL72URKYejOPiHlsIrM36RCLfd8sqkrV958VvDyIYjtQ5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/eKBazDZxqvAHoOkIoEOsjjDaj5/VIGqt1Q7ZI9Rao=;
 b=eJgtU3FnEscx0Ci2xjaKMLtrFPaNRqvFEwkvKw5cWdFmjO35EGDc3c81ls8PemMVNd4zFnrou91IK70Rpi0OnvZ0Q0NMK/XRTMOc6NYfSona3nX7yspPXkNuDjMeVkciNPsVeLsriu3v/vyhjM8nyKQCe/AL/hatzEih3kRqM4Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS1PR04MB9631.eurprd04.prod.outlook.com (2603:10a6:20b:476::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Tue, 19 Apr
 2022 11:35:38 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:38 +0000
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
Subject: [PATCH v8 09/13] dt-bindings: mmc: imx-esdhc: Add i.MX8DXL compatible string
Date:   Tue, 19 Apr 2022 14:35:12 +0300
Message-Id: <20220419113516.1827863-10-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 36b33bce-b647-4d82-07be-08da21f8b9af
X-MS-TrafficTypeDiagnostic: AS1PR04MB9631:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB963156655424041FAD2B6EA5F6F29@AS1PR04MB9631.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PLDBsSAuQPGiuw2fQAkWA3KCNwfmb3oB817tTRGzYIVhmwbmV7WBwKoBKQRdduDWzpLLcr1CecoJhTiQjHfwdVKaIFxh234nLtXW6HhYJfKdygchu3ObNMUqEuJyDZwZ2v2HyXqlWexWIr4pxVX+MkpFRZs/Ri6nlkZXgFmtY1rCa70jS+6gNVZ0JGjOO6R5qQkhVmEohp9pyH0gglKOws86TB13MF4sVK5uoTTAuPINhh0mh7T4hMepcNg2TVzuHwd2hN62a5WMY4oCm7s1nHiBM1VP76aKDbZJEt2a04HpmmgG9++4O3GtuqqWnoCic/OBBnlAFQqr68/gWfSsSliBk57HC0Ev4BDt6kQurvhutLWH4mpGcIqtpsFjBHSvE3VxjnjzMFIZxCkH8UcB3kE9Ygt6a4VHFZnyZy0tukMHSoebQd0q4hiHbNzgjCxYI0crqgWqYRt+cItspk9HjSEEyPAwZOYqqf+6SUeMYmyYrs9V08kiJE3XAKXCuBCa+o43Zo1TcAbzoIfVr1qggdtGrbPq/DYGoo9PWySBJDmYwYbXh+SsrMHLqEKUne1EjwfOnls/MXlTMj16yIzFaE5LrE0YVjAOMwzXopqQU2lt7bAOHayhg4GzM0ajzhJ+E+u6LLGC1SAe3xOs0StAOAzEKilDYmQMkEb8DtXo20DTdesXZ5N2qd7dFbs/G8YR8Q4B6APGHbnhrXBw2h+tkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(66556008)(8676002)(66946007)(44832011)(5660300002)(4326008)(6506007)(52116002)(508600001)(36756003)(110136005)(2906002)(38350700002)(38100700002)(54906003)(8936002)(316002)(7416002)(86362001)(6512007)(66476007)(4744005)(6486002)(1076003)(2616005)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EGjFURAyWGwV/bfJ9An3gEGHmFw7qBwUXfnWYO61v8+S6JyEewo8n6YCCj3R?=
 =?us-ascii?Q?A+na4cJTzsl/G9j+2TXKtFHQMGvjprivCaSmrAjYkT9QWo22j2Hnp5Hx3uNe?=
 =?us-ascii?Q?7U1rJp+XhnUyuNkD1cGpGwD9a1Yoq6NboVvUIryemCOhlKYZO0XTTaBvsw14?=
 =?us-ascii?Q?0V/khHOwrGZN8ayny2KcqfAw+NTSFUnJ6YSGz3L0aJVYeorjqeGh4soJ5omH?=
 =?us-ascii?Q?7dOTnC9kET52UQmLoAFuoQm6uZe72ArMFBVGtIHRJJqwBrl9cNcoXxA1OrVJ?=
 =?us-ascii?Q?dyWlkQ8zla0IPcvqu8Y50AgN0v4IBd2whnYcxY2j3iu6aogRnXfbIy0H4oTz?=
 =?us-ascii?Q?r+6cYoLiTwdlayzkhosMb82LKbhHlf5XSypAN5c1QIJ9KUnKfcfwkpqrLYPB?=
 =?us-ascii?Q?vHaIsTzkuYi0kB18BIqg+14MEkcIxsZQ1vimgTzyVJBhoAeeqNA+Nj36MnNm?=
 =?us-ascii?Q?2KxkoAhlDrh2aO77yiobmuGthYuumJ5LcPM/2aGBdAXmbtcy2smel8687WxR?=
 =?us-ascii?Q?oEAXmPBcQH9SitY51Iep7qse//Udq1+DNapdADqDG0suuHQxq4jewZ4ZJt7j?=
 =?us-ascii?Q?CoEpR3nmaAu/0fcL7xuvEWRhLDkxfFxylneoK1WiTKxJZzwOYtaBnZEPHx2N?=
 =?us-ascii?Q?zobFU8ZTv+8v00qBhYLU9TPH2iCJUVpjrDXn3QAL+Gvc9tCiHuSFv4mqCHlm?=
 =?us-ascii?Q?XyCLz1UyzMB5e0HZht4dMgG4fFTN9vx0l4BcoeiEBjsFL9BgFlpV13fUVH7h?=
 =?us-ascii?Q?LWH/vp/oDyynWnBG0Kt1C0hQR6OCbRV3Hwt2gOOOXnGYNGHKPXVgV+MhfuyV?=
 =?us-ascii?Q?g7GOJGYa4vgHHGEsY4T3xTl9telAg9yUyo97foJ7qMZqkaDDVkOp9ZjMLvRN?=
 =?us-ascii?Q?18XDAxa/hTIYuCmpc9vkvZMy4Ol3lfhmoERKsUDX8Lipr1pkN8HG0NNXXCJH?=
 =?us-ascii?Q?pBHN7zQS7h8I7GJ3pAotFj48Mr5TREthy7Y2xVFY8GUBIrjqDvgvYhDET5UH?=
 =?us-ascii?Q?c8mGHH9kaZjGzO9a6yk8Px4e1k/QYuqUyTB0qX4ed1WpSYpAGz4PwH+NOlZw?=
 =?us-ascii?Q?rIrBuLR5CMCTO6/Ir3aiaC5pmwd53x1P8fkiSM6J7eQFbRdee7kVo7QmgSFJ?=
 =?us-ascii?Q?RmbkZFyEeuWmbeApooz+568oTChs7cIKPOENsG8asYK9/qL4Ml34gP6rRbP5?=
 =?us-ascii?Q?p5vvGhbS6vbuQvr0AC2YCq91Qb0c0ki4RBAZelxcmd43E7bK2WUPvJPOkyfZ?=
 =?us-ascii?Q?WVonyXbhxG9f8lqXB5bK12HAF7I4ysAVQMB5Ko6ujE5+85jne7ErpTYUvISj?=
 =?us-ascii?Q?1MLQa2xKYRs2/4VWUOK71mqi0P39PvGXnwAmBe/i6BY/yjnCQKl8pvDNza/9?=
 =?us-ascii?Q?OVkdjo6od1jhIC+J6uIk5eBmjeXvOGvTx8W5J54YdQ72+Qg0ffJ6wGi33To+?=
 =?us-ascii?Q?N7v/MlIU5vkNOkDbg65CWpAYjPe8sav7gQam1dIy/GK22RALcpI+/Dqq5NsQ?=
 =?us-ascii?Q?dPOJ/4l4LB2pBzy6QTXSArUCKpeYphFgpBWSSCh3qnsC0jvuGEE+EpR5kaPD?=
 =?us-ascii?Q?wCIWIjVF/bDACN1QBBSzAwMo2Xeq7/Z21FfHnkXHE7Y8wvdjywV6tI+mysL2?=
 =?us-ascii?Q?x5IToqfR/9C9kTNHI7maGlLKjZpHjdI0Pk8a8D1hMuDscRTzDcR7aAYhmiIt?=
 =?us-ascii?Q?bbXEv+s2mXus5n1MrNgNNorNKhjMYUB+EF6VYMoCKCVW5k+FW9SiqKBNrLg/?=
 =?us-ascii?Q?AWUMBSgybg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b33bce-b647-4d82-07be-08da21f8b9af
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:37.9395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2FdlTXGeCHOLzkRMDQb4EqJ36NqVJHElIg3VLTKooUvQH8eLKGrJA+FTTcHwsqR6zbRfJTDAWMg33+hMN3PUg==
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

Add i.MX8DXL compatible string. It also needs "fsl,imx8qm-fec" compatible.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
index 58447095f000..29339d0196ec 100644
--- a/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
+++ b/Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml
@@ -54,6 +54,7 @@ properties:
           - const: fsl,imx8qxp-usdhc
       - items:
           - enum:
+              - fsl,imx8dxl-usdhc
               - fsl,imx8mm-usdhc
               - fsl,imx8mn-usdhc
               - fsl,imx8mp-usdhc
-- 
2.34.1

