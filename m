Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42865B00FD
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiIGJ5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiIGJ5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:57:18 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70059.outbound.protection.outlook.com [40.107.7.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8F6AE9C0;
        Wed,  7 Sep 2022 02:57:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/9qAqV6iXZP4WFbHPR/rjFTWvo4S85FqMmW5VCme8D5Bmrryore+JT33/arCT/+tGxZEGFai3iwIohBhZr1wZvjG7sjmhr2b6JoMYAniAh7S+RRw58Opkv82XTNrGy8pP1eDifkJl5xgy63vjsdRfWsA7/ITBKu4huTGlWIUJ6UVLb05h2TYFneY9NCdTgAnoSivvZHjnlk7JGNtjGc7dEvIAjUHEOnlDpeiOSKBpNQKEQXjZdR7NtVR6jZbfkxLJH9W5BKVmXrF/4VubVoWn4wGFvOFpi2kK2LS/CIBkKtWqGHnM6wJZjlvDsi26FDbzLCTE/8huvfCiJiyjw3Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+LZgbFq+Z4ATQkTVF1AJvCVrGGdjFyMJPJQdNv0Wlk=;
 b=XNz+h5rw9Kb+p1rL8vaV/mXsnVbPqkS7+Eysz3sluAprN4cvQNfK4jGrVn/Z7ebJTiDDBDvZl+GcuO8UW9gfEEwtvm8UggkjXoZhDpjZ6dFn8jf6IyvYrZdlIvY1Lu4U9WP8zQjr7JQXP/5KohkTW2oSvczCdFnq1dbxyl12C4FtiS+CTaz8JOBoQk6aJlCNrNTVpbRjNuZKA+lVyXxg4xtCh8eDzVtiBSk7pync1DpKvSCD+9hwWjB+6Jm+ky279VHKOIJdf6XZrZOkuH894I54Q58kcuGYbA1axFyA9rYmhW8zgpPtkzae1Ei+cAR2nISLfK6FE54VBupkN1ZFNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+LZgbFq+Z4ATQkTVF1AJvCVrGGdjFyMJPJQdNv0Wlk=;
 b=sRv2TEdU26HCm4P2TjXfP92MJTa9mcft5sF4kMf0ggnAXX/prKawdtoEZEbaCpMfuTy/p6AkJ5owf6C7DHVUSHEKUPq7TUAXMOHRku7YN6hlC5+FrjgeFUp1hlPwg3dPnJHF1w1slWNrbj5dDqSgLnluZcMhGSUNoRT0OeVqWIQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM8PR04MB7428.eurprd04.prod.outlook.com (2603:10a6:20b:1d5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Wed, 7 Sep
 2022 09:57:14 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::4ba:5b1c:4830:113d]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::4ba:5b1c:4830:113d%6]) with mapi id 15.20.5612.012; Wed, 7 Sep 2022
 09:57:14 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] Add FEC support on s32v234 platform
Date:   Wed,  7 Sep 2022 17:56:47 +0800
Message-Id: <20220907095649.3101484-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0017.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::10) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB8106:EE_|AM8PR04MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bb14fb1-2cf9-4c8a-41b7-08da90b75720
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P1ouMU1qFU04J6xEnrul0OVQggUJ54Mke76P14eZlKzDdvkF1zZsMPpF3HVzLP+fslUTk9IJmJKtsjPAfYZtXkVBRQOlopLIX0Uiwc4xOtt7M8dYqZ5CWXpaZyHShBPEMqX56kS2VSxEqdgihMp93Uvo/SoH5VlACfmmp6Q4LBWxUsxCTveJ/h4H5pJuRD+r4oRJ4G9uqa0D8nulmG6MZ3tqL91uNBnwXUhG9ZZlZKY21EyB99xEN+c7i9VmNKQchgrtyA89G4P1BZ4pqasbF+RAlIzzidYW2Mu6HozHgyYM900icPq6Xle7LjqnP1mHpyz0FyiT5ZEpWRA2wU68Bxi2vJTSlRZ60dTZ9wcRiKAgom7cLO/t5I5aCvIYnfHwqixKyV50zOgxpFXM3frlFa/FURl/mUpVcc3aTae4jjVBpGRABwNW1gxib3iirY5DSanmAx3LE+sIHJ+MaKW9qPb2GM+90LmcgAFwVZyIiZTaNcqLDZ3gocJ0XlVMP5+WKQV7dR9hwj6ejtUzdKzCbOWdbDBaNuCrMo8p5BJuMVOcGoN9v3ou1TnwXzEeM5uuP51i2UeFU8j0oFUNQGSMlFhuFpadZxOie0ColKwgdSLsCGwviIvvI1LWBI8zctWieXjLkCnwrORVVwp4Mnd1B3E/kNDrbh4Egr1k68XiilwmeTcWbe2QYRozi/sdAWXwRxbWv5txVu50skQAxfGCM+jso+jWMZ7KQiTetR/16dgA4K2qRLzjQxYbHJ7DG62OUiqyWzqvGZ6jyT0sOBm2WQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(1076003)(38100700002)(86362001)(38350700002)(36756003)(8676002)(66556008)(66476007)(66946007)(316002)(9686003)(6666004)(83380400001)(478600001)(26005)(6506007)(52116002)(41300700001)(186003)(6486002)(2906002)(2616005)(5660300002)(6512007)(4744005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EJN2Wsp5Id8qV8iyWvzMpaqY4gh3ZVkPaCHOzn0RnNuBikRsPJGPSagEu20H?=
 =?us-ascii?Q?fKeM/6M/EeZh5iayei7n2XefxTq4bGoU9mDOKMkfSyx3FP1fiwZLX3Vot6YK?=
 =?us-ascii?Q?eiTB4PJSGaRBW//Zi5xO1ueTaSwsYNx44kmZc5tsg+WnAytOcUcvuFuv4zza?=
 =?us-ascii?Q?tw1H8toIBDT36jA0y2TKf/HTXzDpNQsG439KZmNoXfdSrc1yxgvq7hCv0M/i?=
 =?us-ascii?Q?1Mj5ybtwiXXtJn+MywmnV/bnfEJhmaak96XNbKE2wlLSsMfDI1Qg1bFmOySg?=
 =?us-ascii?Q?m6f/QoBv6CeEEoY7tIzOipIHTw02XjG+GlD/7Fu8hdRHqs3jzPitMmDGJyi2?=
 =?us-ascii?Q?l1Hw6bJuD61p78xTuWcvkYamltuAYqt5n3irVbANL8L3IfVkJ+r3lupoaSnr?=
 =?us-ascii?Q?FK8D02hK4GNz0VtR35ANXEH3aO5K7lFeRFOuqOXsA6ubkbE5BQHZfOyelLtD?=
 =?us-ascii?Q?QCC2uNUe/mfA4EyFkSe9nslhMUPDWndKKJR+8qskLcc7OOSdImTL1NdazCyL?=
 =?us-ascii?Q?KVO21V4+fh+6FvudyL9iU+V8IwVbkuCMzux67iJTaClYYIGHZuQkvw7mChe8?=
 =?us-ascii?Q?c+pmqTu6LKVicQ8ZOTvIzP+fi66DcGhhtH8lWiSrp/j5OxbpU59G6ISAC9Ga?=
 =?us-ascii?Q?N7VfXbPx42EkfpqrbenClp7eO3ePvjrR4V3qmoXeBh1tG4E/W/M7VJuvL5UV?=
 =?us-ascii?Q?waOWJ+A28cr5yoWdyq+QGLRNbkuDD7GNyLX2l7u0mxk2VIMyuiWNB1psdb8s?=
 =?us-ascii?Q?Vzm4Pljl3uTP2blaQKwmagnHjotxUgttuIFL1cE6hsZ5IvZjXhuDaksTnlRA?=
 =?us-ascii?Q?ON1nVLT+xDlwlMr34Rh40BOi5lG9PMmBFAxOF7qvBPzjuaLF/VuJnguk14qz?=
 =?us-ascii?Q?SdSuOYi9PmnJp+3xUe+4RLRTJf2ZH5G1DdDfXcT2bnJtWjleE6ISpCo/fhOJ?=
 =?us-ascii?Q?iWYgi05LKvbuBOZC6DM4FxGlyyr9MQoaAA0at4LExmcZO+YijxoSbMgJewnO?=
 =?us-ascii?Q?YXO7PbP6k688zIzXwgd8rmVLLtkiuMKJtEr0bOy2Suocg/YTEzYe72FF4NAk?=
 =?us-ascii?Q?LRCOfZCmITrO4sBaJ5cIigFXkO1i9SWFj1wDtEsSILc4S3yPCdpsZ31CoHxv?=
 =?us-ascii?Q?ENX5MhmVyaifNkZWITk8FtLDCVeeHRBRMcM4Cw055MmDH+d0fkJ9Ewns0Xp6?=
 =?us-ascii?Q?MSzxn0Zikrl4tO4orDmToJ2PdxkuAMExTfPmikgXj+bqF0fO08eOws7o7mjo?=
 =?us-ascii?Q?/gnt6e+zknyiTLefP3jYenXxhEJ1+qMfgiE3zEI0Kbc1KsZo/0JaJ63aimAT?=
 =?us-ascii?Q?AkkwyEisFV4uCs4HIniFbB5e1Hhxibkm3rQXzorf3Bft9y5mcQTJ9x+6KYkk?=
 =?us-ascii?Q?IiZGYWT9Moz7JN1zMnTqlfLr2zZL8USlj55I7XLmy4zeUBSg4bFADDNZpoc7?=
 =?us-ascii?Q?6C4JQ028k2k+HFGVshj/qrUzttnzhZZSnGBkQIVAISJ0rG8dFqyuYQu8b4/M?=
 =?us-ascii?Q?ok+z3FBlJUnIclNllm1T3r1pgrMWoxzK8/McrBJj5Dgk5fjTmvdhxP7Al6yr?=
 =?us-ascii?Q?KN0iWMODQwj8aD+hWcjIBjLDcy3yLSBiJWQIrIj7?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb14fb1-2cf9-4c8a-41b7-08da90b75720
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 09:57:14.5867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cdm9HJl22TKGXOFj5V7ipaa66Y3Na5emXXgkkUu222bGoOAz6SeNwD+5fK3JvXlKDZugIHfifGt3WAuYbjcO4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7428
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

This series patches are to add FEC support on s32v234 platfom.
1. Add compatible string and quirks for fsl,s32v234
2. Update Kconfig to also check for ARCH_S32.

Wei Fang (2):
  dt-bindings: net: fec: add fsl,s32v234-fec to compatible property
  net: fec: Add initial s32v234 support

 Documentation/devicetree/bindings/net/fsl,fec.yaml |  1 +
 drivers/net/ethernet/freescale/Kconfig             |  6 +++---
 drivers/net/ethernet/freescale/fec_main.c          | 12 ++++++++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

-- 
2.25.1

