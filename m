Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13219506A56
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351293AbiDSLZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351214AbiDSLYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:24:43 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A6E2BB27;
        Tue, 19 Apr 2022 04:21:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cif/vhOXPeX8+DdKNcapbIdLepIQqyUIT29xN7apGn9nNBGCUSllBRsqD0NesxlRo1QPwzWiYPHKh9AvSayuTXp+Wi0BvFPfE30Q5LWFgQiuLav0x2ws7nE3QSPcNdlpdbhN6bucH4m++SHeyx+WHp4WpCCWsKSWx9xUdFxAqHQH4RI0aBTvpLsB90UYdZPwXNkvtUNk/H8BPvvLY8lBPj0CW8Bad8gEMWeGVQf390OJezBIWtko5nxe99JDPdOKgCEyL0njOESUBI+4qT0iTbOev63Ywy3KvbxT6k2xVYBHKP8vCFHzzU1Fb4HXN0nQYg+rHCLUGohU8srED4XwNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/eKBazDZxqvAHoOkIoEOsjjDaj5/VIGqt1Q7ZI9Rao=;
 b=ekuYjHTdiAYxmN3BpT6jztXN2+AFE4uhNFU3JyexSW5TXuJTE+/cJxNV02RBSMjvRymbrJqqIa/W9lR8FaNDwjxdOBs9ApwDOtQ7y2Olfyq/qZ4RLNEgDCQbbvaTnGEiO1xeIwel0zvudZZl5EqQG36WjYrinThLAXPCesCPmYi72k6+Wk1Z6jR3BcLUqLfOIgqepJajC78wr/pxJbzY31ID4FRf36Iv9hZvBAHHSGQsrCE/oxvRIXTUHO5KiT9KlaHlvmEyBDqAM/rjksZvxYpwluelinMMP3NyDcuE3KeR2WFbLMJlGPCC6N4DHV6c0Npw3Oz7QykKmKHE67L6Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/eKBazDZxqvAHoOkIoEOsjjDaj5/VIGqt1Q7ZI9Rao=;
 b=LDlpkuiLuBhoexkVUbhPKcEymIDtlU7tWIAEq+nI08EHEgAxlBw/+vcvfr89dN4SZL96IVT1IlWZcbgF7Fx0169YYlYhQJ4xbhU+RNH4l641eBaHQGxv59ZMuRxPsZiu2Ug+jpmNF0Y2MVhOls0BFSNCvHLJvFiUVXzkU62FoS4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM9PR04MB7538.eurprd04.prod.outlook.com (2603:10a6:20b:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:21:25 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:21:25 +0000
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
Subject: [PATCH v7 09/13] dt-bindings: mmc: imx-esdhc: Add i.MX8DXL compatible string
Date:   Tue, 19 Apr 2022 14:20:52 +0300
Message-Id: <20220419112056.1808009-10-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 856e816f-ba83-4070-9961-08da21f6bdb6
X-MS-TrafficTypeDiagnostic: AM9PR04MB7538:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB753879AE31C6DFB3F4C0ACD3F6F29@AM9PR04MB7538.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GxY3EejQsc6T+gnKquIFc3t32noI4oYdo8Rie2ggfC57XX9sivzSkmNh4AwGYMTu6Wep0AFcEUFOQJsx7m6Yt+hZPqNX1Dx7DEp5nbb0dnsNJ6/tGTBwCBeBATI0M/Su0oneMOiTgApFugnw16OwWgWtJJ7Fr+vCTH52e9CEHOlBgNfwLzAJ3m5uAT8hz/F7ICfBhb2JHyv97Yot6he7e0zb5V+65qhtNirqAffmmtkD02X4npsixcNplqM9q91MWttG9o4WuuhUnFxrgNq6bEtlkUOvC2UcemVABDr3oxJL77VgvxcdwutnnNy+XuIdkVmHLF/AmZfKFm3tMv5y1S0eVFCERTkUz76fSUef7DtoV0NBUMiVtdlCTINxoc7+rVUkHc5dK+5fRfYjnKu6r4OpPBVMQYa3coMgf8j+AQY+WAt+DdsrnVOoyntgI+bG7xSFirllCWwV99gajHrQpWV2vPFOITXIME6kfpyYUr7hCuYRQ6v62tICjvJ+4QubD2KaEU7vxcFa/4OqjP5OU117wyun27kLka/QeNMUJVuiIt9bB8Mn5lU+m+0dCj5k6z0clHhWP82gY5NClNkXNt9W3zlcKaXeJwInQn19lnUpkWofcdOtyaj+REfYtLPC19H3tIxvb1ZulFC6TrVv95hNMb0Tiqqa/P+SQpmfpATQJCyzfYJivaQcrjHFK9gSZ3RZhfRk2Tspp/77K1+kuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(66556008)(4326008)(8676002)(66476007)(66946007)(6486002)(1076003)(186003)(110136005)(4744005)(8936002)(7416002)(86362001)(38100700002)(54906003)(5660300002)(44832011)(38350700002)(2616005)(26005)(6506007)(6666004)(52116002)(6512007)(2906002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E4oZ7vId/QmzxXZg2qO2JDcOwOp7tqNzqFXxXuFlCO+eC4wmoQXbgNUm/0Cw?=
 =?us-ascii?Q?Ytp1Pujru7Hp/WQDA8N3BmkXvFwGriGHZ2TA1nhj3xsNZTPYu6Wykh1xgwGB?=
 =?us-ascii?Q?Chto8rIL48mTQw32M40te6P0VzcPXz0jHINLjZt71hgziSX6QY0TwCbR3A3a?=
 =?us-ascii?Q?Xg3OIEL8fVOyXBrGA+Px3QfqpCmgqvV4h1JumItqzEBN82AXaeR5as23mKGs?=
 =?us-ascii?Q?/OOdqmkAKN+leP4fGb/0uC9/o5LDogY/vlKe8mJfpO6rOT3YZGqiiL0LpiTk?=
 =?us-ascii?Q?ZZoDzXwr9LswfABkSWUVjkAcpVvEskab4pKcQtcTtXmtGxouQngSG+ecVCp6?=
 =?us-ascii?Q?mPShc/Z7SeRXtkfoukvlodpH4T+KnbFaMMjmr2fNn2kSkyIOL5M40/QUmHxB?=
 =?us-ascii?Q?bYGndwMyZcJHyNW1uOiQVnMq+IYMrhzrQ2CJTYZUm2/laNiGhbIrrGj9AmN1?=
 =?us-ascii?Q?g/TNINHGXOn/1mrANS7lle+T1ZQDWJaYBMHZ9e6rse+yapg+i2In8X1NNqMP?=
 =?us-ascii?Q?hHK/cZqHsTghFHFSV+Y6Qc3fukqJdKMUJy1KShdydLl/UBKQKjfdtdHRukkd?=
 =?us-ascii?Q?uHvPIop4LVRupJOIOFDeOXAx/4a/g4/7DMkojmF49uM9risVA8D1PLP9pQDM?=
 =?us-ascii?Q?ZBjpVSsiaPFEIpIRMY7Yabb1OwnvlUTWWThIsfukYt1tPFn8Bn/0QKNVPD/J?=
 =?us-ascii?Q?P57wqbRLLIMpyyDd3qlHzbjti0LCv5WccH1DxFgZSD3Je5dbszx9xHBJSM8e?=
 =?us-ascii?Q?7cQJET016i4czO2vgIa21CD3hmxMMufHvJtuLIWkpbQQMOHDye4mF/3Wx96S?=
 =?us-ascii?Q?qxJQdx1Y8uGxyJAM4ifhKZ6tpI/8ESUYBooa3bZckmwJrE/MM9qiotubRWXy?=
 =?us-ascii?Q?oEq0LfYqL8yvKkmNSwQBBLsCWC0Y09TY3jwqBaqtoCpTv/yr5/Nc6ywRcXX1?=
 =?us-ascii?Q?yo5f1RiGWU1f9L5lDpUxGFmarmwQuwISvwo2FwGtu40cx+WCMwHBwg+bCqPw?=
 =?us-ascii?Q?6TCkA8GrMaXfb9UHfoYVaakPnrX004cz1kUGhLCw+ir+BVmYUl/m6v4/SiSx?=
 =?us-ascii?Q?5/tZ25qZv14sSCAlXoSO0toi5T5YpICSBMvV9sZ2vauqbR4ja9pjGeCy0Bet?=
 =?us-ascii?Q?EHHAZcWac6u1g6CAzxBeVrGxQM5KistDJJX1nBQ3bQnOss2CvGxrq2uRpK9K?=
 =?us-ascii?Q?nRsOBzaF7Yo4RtsA0I6Z/tPSsHwdDgvyEAiBLbN5avNXB112rFCUkWTGfx86?=
 =?us-ascii?Q?Gg5Mti9fuJtX/UbZCk0S2fBLoc4sW5uaEM2nFH9CoK5y1aXz1p3K7c9Q/NLE?=
 =?us-ascii?Q?11Xlw0IMsbdIzEIfs2Lh2KNAZ0gsVYF6LycNB2VA7feSXBEj8H9lvkndIojt?=
 =?us-ascii?Q?aATZPD3wRvPNABxAXXqSNuO3+uDHOuAZ4R556HdIyyG4TvXARVXzTjzVycEA?=
 =?us-ascii?Q?A2jJsZXkIXIx8G7vW8l8T/wvVzAIvea7ts6eT3C1l4RUyEdALD/1ygVFd1xL?=
 =?us-ascii?Q?segIvBAQgP3qptyzG4MIwOMu4PpcqyJxI2/BMsk3DcA9z+Axhy10qMtktYkg?=
 =?us-ascii?Q?ykCDh3mM2RtIhXtOZ+kot2aLtaTzAWuaxCwC7SiNgGsRzX/bnm98wCIQJ9U4?=
 =?us-ascii?Q?V91xkSEdqb8abCtYV/L0UpNGpwsILl62TjiFLF+7VGE8Rm24S/dcJD8e8lw4?=
 =?us-ascii?Q?EBnZNcXm40Qgv2itao9UvXA4xNHn2Ywsxh8lUQmK7Sr8RpkFOxM39TwTcGgS?=
 =?us-ascii?Q?SXKcMfwgcQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856e816f-ba83-4070-9961-08da21f6bdb6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:25.6440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AFBUumvuWGfm8S4zE608N1pdf6TWhbAWpBKaL42l0bsqpsi85oTt27hIzaiEWZQb0AuX3Neqkhi0HEZSyH8kpg==
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

