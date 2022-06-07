Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E08E53FD53
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242956AbiFGLSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242849AbiFGLRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:17:51 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2044.outbound.protection.outlook.com [40.107.104.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9310DB4B0;
        Tue,  7 Jun 2022 04:17:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EG8fNIkTNv1LxH2ddwE2Vt00Uru0X7slHg4OSMERKlsHySSCWE9cyisATntcrw4sJHAYyvpWZ7G+TBHgmbO1XgacGYmOcb52uDKaz5CwY31tTRwPBFTJKt3wFs83zYNdYqhIK+XD4NWIk0MHMoorF9l2OURJmm8RJ6H4xtkjoGU+JpIg3OcTLpuhiqFHzvt1s/V4toGKd2PuyhCOUWcVmuJGzY/18Mzew9oT1B+wXAr6ifiMVkHptQM7Dx5c60tRlUZ2oJJeT1oq1oYIDyuakB4lsNocIagAIrdkWrHZg7V3bI+jNfRyvbj7VirraXx8gJ9HEthN+9vKGUOvca9wRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwQ8nTWOjJkUEMA2CUCcbMz8tN6czhEOleTX1vjeQsk=;
 b=IHHUE2W5srBKeBZh4fZNuFvxTExdTvRjlYhinbXqN9qsMQm1f5KyR1Fbvt43bur6hRJfkNbqYLLUk5/WKIxW4j6AKecRsS9neWyOimyAw9hesUfYXM7jzHj4yusw43HaIXhy6+lqTEc+T0tYkV8V0ZBNfdPBver7P7sKVugTyAjsHJgkh7jS0uNhCoCYJmf93Cv7f0w4gMTajickB6YVpDmCKZ54FHwdkZRfPN2+Xx+6YvsOFKZ4p1gLmU8gl3vlrZOBi3hWmIx9gL4Q2dv1p8yAJPi1B+hyySZAbp4T5ikXLDsr5JaCNy4xTjNCYdMCglx9HTNRU3msfguvuHqq+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwQ8nTWOjJkUEMA2CUCcbMz8tN6czhEOleTX1vjeQsk=;
 b=dBjUnG6Np2gBjusDGsdVbrxBnqs9C4a2uFI4+lI02pVN8ezbwpUDjbJwTcmJMyFFd2nswDTyC36hjhqjR55lif70x9lXUgTFAGG9j00FWpzbhGYkuf38zAQtvz9BvmIO+78McfFkLO2X7aeQ3rsR+HDpgXoYaFkfGJzDP0rzEwA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB7PR04MB4890.eurprd04.prod.outlook.com (2603:10a6:10:1a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 11:17:18 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:17:18 +0000
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
Subject: [PATCH v9 10/12] dt-bindings: usb: usbmisc-imx: Add i.MX8DXL compatible string
Date:   Tue,  7 Jun 2022 14:16:23 +0300
Message-Id: <20220607111625.1845393-11-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: d4c7ce1c-7331-4f18-e2e8-08da48774850
X-MS-TrafficTypeDiagnostic: DB7PR04MB4890:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB489076549D39D6E2C12922B6F6A59@DB7PR04MB4890.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mwT1Hcqnwa1nUYcdfMRoK5dks8iuLsviA4Qu5RyFnXj4lzUjGHzwCxJNDshjApFMgdbu81gc1QQpoWdBxRkvCHCzLRSDi8xF9LTmtbS2U89VVN76nYCZkVhySLNjKwl7aKaWcLyL9HO7OdQyoArcwSLNDm3D5VbcUe1wXX/4hGQ9zEBcp7R6ku2JQuriApo/WT0w5cQqeHWMpdCpWHoVViVB63osN17NLqOJOKlP7//6HKbkvFjmSgnBU5utsFCgLiYoWUlhZSpzhbFmjKfxm9IHa3N60G/isKXK5u/UWkFW27mqaDZY3eY4UXhe4/S/8rgs2DIZVCaIsNLUduBBLz7hymIOe4JLfY7McTIrOnA+hKOa7Afy7nzEdhQaD3x8yMs3JkIm/sE4xVyISU0h8zXOBhYANrEHPyPQr2nmHSVqDszKKTt5lL7aLdz+KOJEykFuS8mm/XkND2CannJ/LftTS3BO/UclfHdWCJ/q06xG7RS3D4iM5qK/AGynnWHcHeI/soZtoFAXqlK3kkOVLMV8R7DNYoqLhbLbS7h11CdypOupY3P6YfxyZlKWyLW+sbUk2HMb1YlGgDJ78gaiqbd26NpqVh5vAur+NTk9bs3kLpgzdGq5RFWwqxEiX8fXI/tRx+ne7hHsFEg9JZly6Ihtx3yl/NkgHbVxbIYIKYoxT7qZCHmUzEMp58OfKrFs37LbBRQ4K1j3nxKJvWhALRs842RgDSEOV8afrt5W80M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(4744005)(44832011)(8936002)(5660300002)(921005)(508600001)(6512007)(186003)(1076003)(7416002)(2906002)(6666004)(86362001)(26005)(2616005)(52116002)(6506007)(66476007)(4326008)(66556008)(66946007)(8676002)(38100700002)(6636002)(54906003)(110136005)(316002)(36756003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9zRxULwxOmcddH1Yb0luE9gGtzMwSNnbVViKmJnkQOVqlboMhMwJIWVZ50X0?=
 =?us-ascii?Q?8s6+U6atmVMbvrGRKxIQ6cBl8FrJg4f2y+nEToCBL0D9vioQhDZZRcU+7K3p?=
 =?us-ascii?Q?cxwEc0HqSIftw/9V5R1paV5T0ruZMmBsGevD5wIYUBS8CgRkFtPGup1yG1T8?=
 =?us-ascii?Q?DH03SnD+VFQYrMMTkANa1U+VV50kBC1v77TLpxWCWvAZslqhX9bgv5ty/qCf?=
 =?us-ascii?Q?EIPlIVNO+udI+AJeJMcW1svqvjAE8s4o49WM9W6/et5Qz0H4GPz4KNol1O/m?=
 =?us-ascii?Q?j3wnbQ8iPU2xVO+7Xoa0TGPqCeApyiw1X279ch1SK1skfhvfGq2PnxFSJ8Km?=
 =?us-ascii?Q?SOvl6HgFk7DTnm57nU3UblAdePl3x7RDeXm07+Xm55Tnzg0YRe2XghuEzYlz?=
 =?us-ascii?Q?f/KIkdAJovxCP3/5e35r1Fj0END32HMJOEWPqUZ8UbkTvpPAzAgTfJiUZCX0?=
 =?us-ascii?Q?bP8t2gKpVuqoczCE1At6sOF3dHExfepceqA4v/g6QmpvE8fjVRTlHpPJ5Uf4?=
 =?us-ascii?Q?9nmjgola2Y8RUz77S9nNZ/aho7+DVzszgXN1LAWgipROLPwPguIncoPh1owH?=
 =?us-ascii?Q?l9cJIAq++q/3OWeso+Ea8PnsbdOQEKjeRJzM+1UfA6zxvW3mTo8KZAglC3eJ?=
 =?us-ascii?Q?8VF3RPQPjA93zBur74aS9FwF/iscFhQFcRc+S4dBuwnplzH6pO4E57l+816A?=
 =?us-ascii?Q?MJDIB6Amq4fFeYnKDmt8YDzaxjGCrTDAIx0jrgVEoNkrNlVwjiFgH5ASTH5f?=
 =?us-ascii?Q?+KNbi+Erk0v1TfuDxZIzuF5q/q4EtduNbD4hEsDOhavIgvSJdx2/1UceWL2m?=
 =?us-ascii?Q?06a4+3B/ydSvRd7BZh5YQP0ydKOUv24PHFL1e+LOdFFQcBMocy2bGAded4dC?=
 =?us-ascii?Q?ktQ1FIeycWAKJX2jXv2kj4LL7K4Uu06vSeyRU+7mEmue8ZJ4c50b01wNm67O?=
 =?us-ascii?Q?9pMZjK/xcd/LBlyHz0M9tLD1sMu3Ji364QBbxSoJFYR9IJT8MibE+zakG1nl?=
 =?us-ascii?Q?54NBb5Uh8gTWkplUak1seZHjlpLp1jAPmz0KH5+2qDTG0r0VaEfcYpUQU3W4?=
 =?us-ascii?Q?7UDl9beNF0Qz4BneIJrOBytRpAe4UEm/8D+mgZUt5XoqHvEiMM+1f1Mzfx43?=
 =?us-ascii?Q?u4Go6iRSHevQFFgOqMW6gc9KR1x/pG5Lzf+6Asu4nq8R39RRX1nOnCJmM7lJ?=
 =?us-ascii?Q?W3uBEOz6sPqjM6MlFmUJs6T1jGosqkuf83Q7CPLhzLpoMgl6c3SbCXZ14cZ0?=
 =?us-ascii?Q?JzVpCWsp+oLxYxpmWfCuCysBIbLZvM8k+/dJ3/TotiFNVdtp8snIP+wLzzsD?=
 =?us-ascii?Q?wihx8nnpmU/DGgUH3CQJe5ytvmEpEhUd04R6+/IzyvEVK83p3hllFxkFo0Ph?=
 =?us-ascii?Q?tbZyPrt1+V9AsNpvitlK1zop5q86viU/nqF9Js5pnxjA0UEhkFy25Dw5CuwL?=
 =?us-ascii?Q?4Q3bRVc1NfYxP50BWXOHxp53I9IFKDExIPt+zh1uLTN3KIjXlUWKAoLr7Leh?=
 =?us-ascii?Q?mB6dvfDkG64MVXdcLLVChCTeodzRWikpjY/P/0Z7S9Ux8jkpW2jEdvV53PKz?=
 =?us-ascii?Q?aqqoXLNfkppNPMvF83lUkZIogL6agyNbxk55lR/HKsM7l9YZChv6UlOyV/jV?=
 =?us-ascii?Q?0gjtz0lC/BUMvmNoIkeKl2ykwO2gmFRIxN1PwwTCaXhCKSujTbHpNYFf0LD9?=
 =?us-ascii?Q?A0mGxzeoBcFkp60GaiXP5jhhevak4F4rjRQGACfARB7oPRJrXpBgYX5nXMxP?=
 =?us-ascii?Q?S3C739DADw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4c7ce1c-7331-4f18-e2e8-08da48774850
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:17:18.0102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 95PzvuaL9YUDAj4INoFSQOd1fJzuBJnOU+3kbOwqNhAcs2WPQE/wSn8BNBsxUiX+pzkcOVssi4PhL8NErgA3Gg==
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
2.34.3

