Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F67506AFE
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbiDSLjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351657AbiDSLjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:39:14 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50077.outbound.protection.outlook.com [40.107.5.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCA633E16;
        Tue, 19 Apr 2022 04:35:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WyuKXtsvcwI9425vwBdVay9clGbpMXwNpMGan3Ayv36ERhfGPa2xa02Mavx8jcO66SFA4Z8Z5sYoqe7NcuSc3sdax9D0DyM6VJ9XDAPTSZeKk/sXlYFzJNA4m+3Diw52uTEzQsxPi+99J8RQQKqXxqvG9WkWaDMD9PkAD+jEOPu/z1ScbR7Vzy+3wZAvEG2ZA9nSElE71Rie3U5hPEIPE7f0VdJdGn9nnlaUhh0OgLWgHU3mpa5m4rv1b4e2IzLEfEBCN6W9fbt2nJvfg/rtjBKbm4ehIARqljHp3gXl+1HQvUOkygJOOLg+uJfzE+I9feE5EAHel8eTm3RE1CH29A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=flmSPf9D8ZH6MOsh6Oj8LJRInrPK//j7iSrj/5Sjp34=;
 b=JHV7zyhbnakYu8MmNHxwFmsq16bwixfGvsTIbAxO2DSN1FSNbzbLjXWE+91Qjqw9tx0LMR/j8rOth/DmVPOMMZaHydNLciQUsrK0e5ZQCBmfgITnk3CvuKZDvvBgZjfm335Od7i4KHgX061Jk+ujgKiVNziE7PnoHRepSx2pjKNHgZ56Jofuwl0KGCsbWU/nK1hieW8dMai3hHIjaEqYGosuftFocUXi6lljoJZ5l0ScosB7yK+3unCKAqKLvc5BKQJ0HAfpDqBTgNMgqdCcHqBePqHaoqFEyw02LFpoYdjbQLU8Q2lplCB47qtQfhL/NEyGqvNYf0H6+SYCTWt65w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=flmSPf9D8ZH6MOsh6Oj8LJRInrPK//j7iSrj/5Sjp34=;
 b=emhfl6E3NNYjA45D0W3Nhrz+jLU7YxG0GZ0NZOacUJUjXnPFIdlw0BAlItkkNaRIG4Jk0v1uhb5NvM4NS6UCFQw2gkx8ARKLceppJncv6z8P972kuX1HUGTv3uuIqohAJ+V5sac5AEyparL2NVTN+E+hZsa4nRQlrDkIdu8hIQ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS1PR04MB9631.eurprd04.prod.outlook.com (2603:10a6:20b:476::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Tue, 19 Apr
 2022 11:35:40 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:40 +0000
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
Subject: [PATCH v8 12/13] dt-bindings: usb: ci-hdrc-usb2: Add i.MX8DXL compatible string
Date:   Tue, 19 Apr 2022 14:35:15 +0300
Message-Id: <20220419113516.1827863-13-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: e0f357d9-9503-4bda-dd05-08da21f8bb0f
X-MS-TrafficTypeDiagnostic: AS1PR04MB9631:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB96315D65016FECF7541F5EB5F6F29@AS1PR04MB9631.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: POhcEdRwjirfsOwJQfPuHsjc7c4nwlDyL/cfF8+25DcXp8J5kBQhPKMmV3bl7pdPbB9aC7afe3mv6dFG7q4dZlxPGiXl7CPXpaD8E16e+1NEhOE8Ev+mzVzAWe3ZUpifQzEdnjzNO/xiawK3bJChnKhBdzbZWpuebF0fcFTNji7L98IoVBnMop2q2DRBi8NrAmF3gFKXzqysfkyhFASM14c/aSXtIVjnj/ga/C31DmAwFhWA91AOb+CV1gDZj6d9m8cni/WEorwqtXk0B4ezxip8Ny8AkY80im5h+RPHQ3covCciq/rtdSWqDUkDzJUGDOUzN+s3N1+KTntkKdgYN/+MW3JkhcXoXWaXlhccC2ERLgA3NEr3UixPW0YG7f9InOORK0AkzcB3/WFSYDWA2S/xRpLpubLt/J+eRryP/r+hkYwL4fg+bx4VfdRpA/j/s87hKk81IdIoR/ip39qhjhy3mgLDZkIoAtxOjinp3DAoHqHee8Ks+A7uTnd9dr0R+F/0V7dzQAxG8t7kiXRYAtgL6ZecId2VfZjgvEc4h6mB5mbsycXPF7nMAqK/nAyLu7RaJi8swIHM3wIkQWvpigV/duLEU0Do75AgJYKnuOdt0fTTh/xqJUvTj9J1TZPJE3NX8qXki66iMszyM+DHAI3AT5wGnuveJXBy6lO+JcECPIi7CEw7i9Ncp2eT42cL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(66556008)(8676002)(66946007)(44832011)(5660300002)(4326008)(6506007)(52116002)(508600001)(36756003)(110136005)(2906002)(38350700002)(38100700002)(54906003)(8936002)(316002)(7416002)(86362001)(6512007)(66476007)(4744005)(6486002)(1076003)(2616005)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9CqvJFxBhQbDWSV5I6g/EugPOXr+f14amF4Jb4boiu+LEa+GFjvTR4QzPZmv?=
 =?us-ascii?Q?f8ekyWMsR7gp9E6r0UArgikmXS/OiAvXBUveGy6e10qhVn+2w1G/vavqKTs7?=
 =?us-ascii?Q?cHTgp9dkiIqiepcljI9z7IBoRUIVjnPMD9C21P/7nOskvWhqa+S5HXaPScFw?=
 =?us-ascii?Q?OlMP4UlmRwVIG/wmltWQpEeX7R+zerK+tj6z0arn8alRjUVwD4eyIRUB8zYV?=
 =?us-ascii?Q?SJM2eruLvFkw5I8zucuw9p2CzCyQa5Na9XOAfTQfXXck2PtU9k9RH/HQE4fY?=
 =?us-ascii?Q?SVT2fldbFQFjAEuINFgDRCXs7fgHS7KpRPhzicK3BoS8GZaGjAFvAn3zCW1l?=
 =?us-ascii?Q?tcI3SK6ivOXA3m3noCCTSJT3Px2yjzKdeC8rrdQS1hKEjzyeXIsajtO263VL?=
 =?us-ascii?Q?GUSFRXWrJ7ubNd6RhoZZDFNxtipZVkJ3zR2PRcRmg9r5jWVtjdxzJJEfMfE1?=
 =?us-ascii?Q?9CF5mq/aEcLUAdFPxula1wMJy0BC4zFEFjd8kbaGhTPJnVf49CEwHpIIKew3?=
 =?us-ascii?Q?rsSr3jKvB2E80FJjg9ZHpdgqFrtBUUna0kYJQYhgg8yTryxh9t2AyhqHcDah?=
 =?us-ascii?Q?KoJy0bVlRVDgApdTaAiEWVdTxg8g03wAGgIL32iV4i6yT1REZJX9cgX3t8iY?=
 =?us-ascii?Q?D3p+GT/OyhRdI82t4xgMcbDyg9YCf2rLiReuBYbpF2Ne0RssCM86yur+zXM7?=
 =?us-ascii?Q?ConWtNA2HIBSkt0yj2x9K9BoLW7GSEvUbhE4e60LkKdVRPMkpiJZUw8Hn6gc?=
 =?us-ascii?Q?t9qYh5iqB0imIN3kOs1GnpXDFXQgvHXPcngIQztOi4dLvus9UghtwL6lJSd4?=
 =?us-ascii?Q?D6jOUnPcMCVE90BQaxZtA3Xh0qXaGvnm4XpGPqHLXNWZzWCu14EE288pJZms?=
 =?us-ascii?Q?Eul4vUrHdUegZTl82D/s7gbMmyPTuBTAJT8PQEzbpDRN7xSHpVWa3tf/zsps?=
 =?us-ascii?Q?sQVj3D4bf/X9mw0aVH9/8thN8NRK44lzLmZgguVpzonrxYjWm7yDwl6RW8YC?=
 =?us-ascii?Q?xGFoa1XSh79a7IE93kGSKCFgs/v6bq3LZCDd+rQTPWkhy+wcw/potNHwyJKL?=
 =?us-ascii?Q?YjpSKdydHTk+oiANSu819CLEg9APtYOb4m45XcJyHEjmGk3ovWqtcMFKMvJ4?=
 =?us-ascii?Q?nSN1+KNN2o02cymgOnUdD2h6+I5y8StrBQ3/MAESAKKGfTFkY39UVFYXpeiW?=
 =?us-ascii?Q?LEy/4gwt5d45aKR8LQ1q4QOiCdzUIyYVcu6cpqqfpS2Dyq2pFfyB5IYeNgxH?=
 =?us-ascii?Q?rONuC9+hBit1jG9vlYn+llVoQRyiggKwxZDzCPEmwZXArtMJZLvZbSSHFSVE?=
 =?us-ascii?Q?odtaxb1enDT1o5A5Ap9N2i9q7ilEYGTlGVQdMYWx8bMhykB4lpzSV1jl5BNr?=
 =?us-ascii?Q?QOTqGs45GatW6Fv0F5mgwUtqKd7x4+P/DAH5w1aM1f86zXMjnNOFy/Sv2SY2?=
 =?us-ascii?Q?jA8TJ2ENmgf/jvLn4tgH1+eyj4WB7xf92gCId2ep5c8c9Pn+TFBluF0csp5/?=
 =?us-ascii?Q?jEVMJ5rCzGBfqvOdvfH2vmxGjga0cGVN8sdFWwwCcs0SKZ+11oLUHecomGLR?=
 =?us-ascii?Q?H4ECoyfwUz27UmxgxZVYJBiV0bRozuCizhhBXxo2ajmefbLhsiJUwo0q1FYR?=
 =?us-ascii?Q?4P99E+xW1dQQjBVVH0OPTPWDuKck/5Zb3UYpZ824KaxM/02T+B9FLfeDEJO2?=
 =?us-ascii?Q?BJnx4pZdZ7dHn7oBoBmXMHfSQnZkaWsFsmJGSYV1Ojzc3qV8hTw79U1t3/Rl?=
 =?us-ascii?Q?HmkjQPY5nw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f357d9-9503-4bda-dd05-08da21f8bb0f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:40.2050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQYiTQ0w1OsPORc4u2Jukw3s6KWA78nL84wKGRCZxrhmUNmm4mh4wlRZUOuXBBVdYVAM4SjSpQoYNyhHsII2Xw==
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

Add i.MX8DXL compatible string to ci-hdrc-usb2 bindings
documentation.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
index a5c5db6a0b2d..c650efc47e92 100644
--- a/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
+++ b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
@@ -11,6 +11,7 @@ Required properties:
 	"fsl,imx6ul-usb"
 	"fsl,imx7d-usb"
 	"fsl,imx7ulp-usb"
+	"fsl,imx8dxl-usb"
 	"lsi,zevio-usb"
 	"qcom,ci-hdrc"
 	"chipidea,usb2"
-- 
2.34.1

