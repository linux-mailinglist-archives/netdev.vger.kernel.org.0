Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D843E4FF4C6
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbiDMKhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbiDMKhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:21 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10066.outbound.protection.outlook.com [40.107.1.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7809FD14;
        Wed, 13 Apr 2022 03:34:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WnHb3TOpK6jx1DvCwnD8gvwkttNV5vh0CUlrPFO6oXK8TGpPWz1moIgbpFrJTNfr/5zpIr67Ajv1e2jn9I2PSy+z5cEuMBdKtnIAPORY43PHqQ18aykWDZSkXSTcPjG5MZIBTBMPD0fCV2tY9cy+iG/JM++oOIAI7j9oXZT2iC+tIUyV7pPdLkaOGKy1ctXLh2wx4I3BAbPkfEpVSdrjgzBAbgeuC7gn42xWTkVuM4sF0ir1u5PmyCAipbvwScdhB3gUI+VjdMpCtajohc5jKUcBo1I9ij0uD9X+wR3FFF+gNwP/RD1Ux1/bTY09gZ9G7xdVK+jqvJbVP2qpd3OkJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6o04XYuKeLCoe+wBkJaeHGzFt5ryXu2MwD08aNGT9+Y=;
 b=GvHmapNDzWiKDddmhn+WhUp/hzI8oXdaln8f4nqN27GsE7E2u4L5eCGJvk/yCUmVmklaKi+5YYuipyHNhAyAVrNpHiUQ01Shf7akf/cHCzPMdj7igp6wXFKqzO6cwP054plQGbbnf7TfUXEJYMyZ61vtzXYOHP3tN1rzgpVq3V8napg1lFm6hzp61glHe0awMNTsXFWXfEK/Q+99hfMRHntSaqXbpG+I8TTz2uQm9RO7yAvCmBP/mCBbBTblvsiZ+0hgqsZG+k1byRFR9SCZUD3TU8aujbeHOl7rS3EygEWYRHgNCau7qhieO25IXP17oNTHBicGybRsv+ZtvujFEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6o04XYuKeLCoe+wBkJaeHGzFt5ryXu2MwD08aNGT9+Y=;
 b=P4rzsZhqjtNcAS79iVGB6kAWKjWThSfNmAlr2b+u5MQSIspDhyB2PkmcRL5kaB442OXgnrocla7Sv9Z9Sdlksumk1LPlbpmO0TFQNtRYzD9lfEI+O/bicf8szSXI6Uq+YTFrF9qGGv/CTzoPOu16tsX2XTfBATIGRNAJOwiORew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM0PR04MB4082.eurprd04.prod.outlook.com (2603:10a6:208:59::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:52 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:52 +0000
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
Subject: [PATCH v6 11/13] dt-bindings: phy: mxs-usb-phy: Add i.MX8DXL compatible string
Date:   Wed, 13 Apr 2022 13:33:54 +0300
Message-Id: <20220413103356.3433637-12-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220413103356.3433637-1-abel.vesa@nxp.com>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::24) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1569e25c-8cd5-409a-7cad-08da1d393e75
X-MS-TrafficTypeDiagnostic: AM0PR04MB4082:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB40828B75FB7217D66820B407F6EC9@AM0PR04MB4082.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3LYxIMEbqlhun234Q08qUseD9RtMlurEUyfkTCdcP+Wi701s21tJ1/zz7rdvecEHswt2hIO8Ozu7K/ua+QMeEp15Tu3/Sm1+9fxBs3p4ejArfdJ/ehMj8rh/HHS6q5TTkoCe5BpqrcV5ORB3mxnl3b7uFXTIqzdzEm071KhkaIF8eJStONcH1J9gTyiSBIxJMqn66Zyuydm6I9PdQQR5vv8KWXWI/SaroRNGn9GMPYzjhT6uhnXsLj4Mdgal+87552VKaj0dKYH5fsXk3b9xxpbfdO4oIvx27uKXGzI5cR3LeQTJ1h8tpGqfUTy3FNagT5n6gZVGMs4PQX+mCyLnTiuvG4SgO6rbbpywryN/pNSsf5Fn30fsmyTfOO7o551SzGRy8J2ceAXBPVuZdrpzKcoAMRfHSOEN+bvAtFv0NIzoAjudh+CN4gCzE7Pd9gP/MmoGf3/vPvqgU7gbZRblB4iOKSwxcORNENcZdOmPeZxMvKm/y9BDYVbuCrfp49w+LH6jxmrYpfKVEK2Kdg75RyQwhMLq43WKGH4AANdRtkh+P2Fk4AQcqyUMu0Mooobx59n1Lo6b1vidr05S8hn3yAVJ49L4Da5fI/YIkRxTavMbT4YPSFuGTPhTp+2LfwCcFJG3WUJwbrjPC853P2bj91J+rvzSlV4OG5LKnBAXxV2HUF6aJnNrhb6e1aLXENDRIBGKCJ8EEJITkT7u8hR+Jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(110136005)(38100700002)(54906003)(38350700002)(4326008)(1076003)(2616005)(2906002)(44832011)(186003)(4744005)(26005)(316002)(86362001)(66476007)(8676002)(66556008)(7416002)(52116002)(6506007)(8936002)(6512007)(36756003)(6486002)(5660300002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LW9ow+gJHoRPIJHS5V5efFPzPKwVPrSGrO5p3tVbFmhXJIAxnFtTdjQxdGk7?=
 =?us-ascii?Q?FmIKjaE0X/dkVd5lYCtGqf2zgifkduSJ2v776ESl9LVAdb+hueB0jSHGnkYS?=
 =?us-ascii?Q?68aZjD8019S5y5WaOBtI/w8FEd4HEIOCXowPOham0kvBoj+h5aHubqI11RTj?=
 =?us-ascii?Q?GTj09tTNXIaPvRPkyw5MhpYZDBibdqZxmdjIpPoGRKsNmfm6v/4lcaWNDVJL?=
 =?us-ascii?Q?v9mEUaYVkBAhU4ZswgpEmvfjKdziM8wFZg7HTg/DeydL4zxL7/HeyGMNOdMN?=
 =?us-ascii?Q?ej4rtY2zdJXvS0Yz8ICAqCz08l3WNVYdsz+Uh2WJSSHJ+YIRQ01/IbVC3O6H?=
 =?us-ascii?Q?K347FnVbIm+8nmcbc9IFP793Paysxoi+gP8Dq3nDCJd+K1gh4LbAGoXqkwDd?=
 =?us-ascii?Q?cJbhyfqZD2ar2YKJjawqynZKUpHEgTXOl2IUlc9FVcUvrf3MeiFKXY8WXCRo?=
 =?us-ascii?Q?bv73rk8TwVHOEXjPyPD1cyd3ImsovOpzAOWvtVlGMWItinLWtw6OA8xl7m0/?=
 =?us-ascii?Q?2zkFFs7aFKleDitTGPjHsKTidAUzyTAvV0k/fq9T8oCjZC4Qx62cLWj/YC+J?=
 =?us-ascii?Q?XkcSj4iBgLx122Far50vIrgqLQC5zOozgkHbhIFiRVf4xwdJqToiTUXLEEyG?=
 =?us-ascii?Q?LwHl8FN7QXvuhWJOeOfvsxnZ/l8IxpdKvKRme1mahQz4KUV9a6MnpfVa6CuK?=
 =?us-ascii?Q?rR6TONZ3P91VrYivtOMDPsNP1ww1sx2uBineqjmnEBg2WaAtb79gOjrhsdFv?=
 =?us-ascii?Q?H6cKDct4oxqxzcUnDlXiDryZdFMPeRcSsc5iaJZln3EBBS/AhZfBVkwwIJQU?=
 =?us-ascii?Q?AjgmS+9/s0iNTFDtrRhQ0nA2nL4p2Khl51jtxPn8ufhBJrLcXYFJuytX5dmi?=
 =?us-ascii?Q?jdkSdUPqhX5kHNjV6xlqErebgfI28DHnRUjk/mpBHpZ8P0sbjP7IPlp5jGSg?=
 =?us-ascii?Q?T53vRkkXEGOzpusX1IlI01QTpk9HEGSpnwhzoH/mSas7x0xZOfuloYUE7vIr?=
 =?us-ascii?Q?99/uW7uVKpRTqBkCTR3hIqNy6QhE0MviOYPp3I7J2HAipFfN9L87PVsTkzL/?=
 =?us-ascii?Q?hFcqc/V7h5UqY7dwfJTus6lCD3yUBFj7T//8rhEkbv2rBH5/PFsrZfD8cnX/?=
 =?us-ascii?Q?8agxv6elyiSb7rCgVWliyP9kx4CLVopU4pnLCVhyGehtJYUUR2UEoAiByIm5?=
 =?us-ascii?Q?qmhN2DNprnwU+BPPNwid6fRRJyABTZhmSGhJMhHHNtDwzwQBBWkQH9kXYKEl?=
 =?us-ascii?Q?VWHBeew+wwXhsD7ADRuH8BuiaO0qdOtuwU11j8zdDotZ7gjqVxDEn9cTWyUc?=
 =?us-ascii?Q?gEYcWCDGfNBJW7U6VxWGOfpqKYDiyWR/GaD53hMfgrXjAeIvyMvXwiLhZEF7?=
 =?us-ascii?Q?y8AREkeC2sL2lpSS/sJIMBWWbCNpl5NNNBDbkc0LPImzE54hJIKDDV5jtX0M?=
 =?us-ascii?Q?nDXqowsY2k4Cuj6RmOv/Rba+RGMSlij/zshFEN15eGP+zoI4FpAS1W0iW+s6?=
 =?us-ascii?Q?fCxx9oM5jjDZGfnDrpu+SuuiuScV0/jARGpZ/1IeqOkngYW86TDPWDEyrstb?=
 =?us-ascii?Q?EyaoAlJwqWlc1cNXmUgj8hmntFp8/Tt2odajjCcRCkiQhehqPA3YkcXq6TaR?=
 =?us-ascii?Q?uN+ipftPqQBPN9CKCpYRKFd3v1KpJycpLb0Dlxb7CtmxUBki6plJF1m+dcAA?=
 =?us-ascii?Q?0YdieIj+Lc9k5yBe8f1OUAbykbd0Q7k5dMKBsHuy5O7ewxn8fmDPwfcYmm8V?=
 =?us-ascii?Q?MsSy8yNUXg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1569e25c-8cd5-409a-7cad-08da1d393e75
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:52.6293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1M+J/oPWSTjRNRVHHGngJv/iZSy/e4dXIG836eSjtnw+AotQzpd8Nx3byfvi6sNLBzza6jM6BM+kZQM0qr0OLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible for i.MX8DXL USB PHY.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
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
2.34.1

