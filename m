Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86AA55F134
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbiF1WTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiF1WTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:19:09 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50053.outbound.protection.outlook.com [40.107.5.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3F93CA51;
        Tue, 28 Jun 2022 15:16:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZmuwjGfQb5d6RY9sVwT5oD6jZSnbxUbmjH+wYL8A+vSxcw836Jb/YIBIUYb6IcRZeejMG9KfTzJR3TEkXFV5I8wOesAGf+bXWmpaznuiNXbGH6i9e+dhN0hFcu0eWq6m9ySaw4BKQoYpKBONa7M7mww1qwRCMv2ZE0j1A9wPe9SSscPcINYfUithSdr0I2i+kshBz/6/dlH8Nf1U2zl4c3FvGttu3pfOa4qBpD4UVIIXwTpCdmhg9Bq9UnG+vGRquxvt/0JZEv4YptuIPzMZRXs6MxIsP6R3Jjpq48HvF5YKFjgWt7tgnIZLS/sk+OdfL3HMltDklfgFgYUNa5TlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LWMYi4jHuSKoL0PhVCtVd/LenVBaQ7RzU7jnwoLBJQ8=;
 b=MsBavzD7gFD0kw9t1bQYILG8VRlGJ8i4ZhWxkZS36q+rCG6oMo2Q36IVS3NPT8my8NTg725A24/P3oorQxnHxW21/ikVNkK0E05YZEM63jnX0DBSUrL+eAVsJSt7rTwyudrzufyMm4vPAWywX7lXJRhMuC3PvtnbA8Q33XNTPjc4O2q+4GKZ/EuCmj0URV2YOHs9sTK/SnziT16nHkC/hA8/6B2d1DFSFjwmhsH7XaRgu9TcBknfY0X4wHy6nf8cly2IUeVDOqsWC1MOTF9FjtQ2Faxl9avN8Nz+x2O7jfJlTfzbLp/8bwxD4maW4DGYcOdUDa3gKabUf1EX0yYTZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWMYi4jHuSKoL0PhVCtVd/LenVBaQ7RzU7jnwoLBJQ8=;
 b=Vex1goZz6+iOVaBWoKE4J/cUinlqxdKDYhAF7XKicEQREQmIfVCw76Vv0lp2O1kZa4/h5iNpKJIFgxR3bIRueB9w05rwxJrRU7rhYhze4i0KCFgKsAfeJle+pSbXaS4p2Nzu4IEKlXXzL9byON3er6HkifZI9gJtLF6OohcSeu2rD2cmXMiV6P1CoXEcuU84BdlisAFREwfn5Mf1EOpgO9XwQNdL7CzUrCTnDpOibspXu/lVhbBRp5KDF6aJZCKoxGhQhG53/aIRDQfmk5BI+CGK635du1ff2zTxHinPurt2rt90A4JVjHSWDPBRw90Apl4h6SsRDevVyNWiPA4FCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3883.eurprd03.prod.outlook.com (2603:10a6:5:34::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:15:37 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:15:37 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v2 34/35] arm64: dts: ls1046a: Add serdes bindings
Date:   Tue, 28 Jun 2022 18:14:03 -0400
Message-Id: <20220628221404.1444200-35-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63540b8d-0bf8-4d59-59e6-08da5953ac51
X-MS-TrafficTypeDiagnostic: DB7PR03MB3883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RNJZMQGfewhIasCgD9M2TMJLLh+QgBwxWOOk5/vMCsdDOO19uV57mvkDkv3ebGOwXWHXBdojbfKcbfU/Pyg7YOVTrDD6KWFkLJGT/pT4gtgHka+C68+NCilZV7l16/N+mHQA4NDvgtZ2+EOkNWeJ7LWXVmNfe2NttYZ4uuC+B/521dnvEs1s4GeDuzja740xeNW7EJ8BRJMwKVmdSVrjog3+ag1HQCBbgKqkmV7hdMZE+Sls3aKE4zLa1n2jcEam06Q1Bz1pMQgxejRnPqEozEJdmAcQ6T3NQDxoSbudzPhE0chQO4NihlZQqE5ry1Gw8AYPTUiqUVbfbFvAVwpr1pCxmw53NzcZhmYI4O/udfXNENG/8fJoG3/aqz/R/NgJYPgOE0Jt/XP6Hzcqjg9dv7jb4afMPS7vNLnKrO7LuOsDPvnCkSn0YjaWw3oRRE64rg2bh9eqMypg8JB6HOD8U2KImN1r9hatYZ2uXeCCu3TZB1dYilNpPcPe9g/X3b2AGKmYwTiY6zjLV1PWCbi4BcrimACR0AT6u6dWT2YarSXzkPPZlPqOZdaKkLc8oaKJIdCs1v5R5iYTqx4QZ+bYuvtTKOBCK+UmTQL3awsRfY0s1sucEXFeD+gdriA7TgogjWOGtZGenkJ4kbWLHKz2VRXXODm0HZIQHznKxHqARaMPHKN2V093G1VMqO9GnRteC+D1IE9L4kcQjK0ksB0REimHxQEYJJn0WFdbLMjAkjpIC4ixu8BX9O8WZIEb6yV291aDtAo69ZT4UDSofPfhcy7CuhQY5t/EJcegBvZYIxY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(366004)(39850400004)(136003)(376002)(52116002)(6512007)(6506007)(8676002)(38100700002)(36756003)(66556008)(66946007)(38350700002)(66476007)(2906002)(26005)(1076003)(7416002)(86362001)(54906003)(41300700001)(83380400001)(2616005)(6486002)(110136005)(316002)(6666004)(186003)(4326008)(44832011)(5660300002)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eFt0s94lkOzGzOnsF7+3nVF/8ugleZlcfA9IcVajftCRcQwD0XjWz7UnyaRB?=
 =?us-ascii?Q?nJEo0Oaik1gAhn+BORDxROUNa8b6SaFM8UIkBeirE/EOLFUqfL0H0r9EY113?=
 =?us-ascii?Q?n1gLdVq/g8URIxIgR/EIZaRp5l7H2JlUSzVlEUpYrT1HOmCTur8KgX9v0l+7?=
 =?us-ascii?Q?UhT34gdyl38bNv2wdxFXY+GCPiNa4lkJ7Lj7n3rvn9UvxWBQPeK8LbIxDIYA?=
 =?us-ascii?Q?+IUtWbFqZBGNyrfXDoXHFv/fx7VfWUB2CJJUrcllEyJfslIh8a294V+ZUHvy?=
 =?us-ascii?Q?SZDu5exJSGDn4i2wXw1fFt9vHWrwnJXGVLDlLm/5POGA2minGyBFeWAJY+yQ?=
 =?us-ascii?Q?OPZfW8aK+e1IrFpcqZXSfFH2spYGFZ4GfdKCAVLV4g9UpSauNKupfWtPamdd?=
 =?us-ascii?Q?dnaZ6AJF4tz3nKmqw2U6POv5YZ7NpEmaev7f2K+WbJRMpaOOS6ChP27qPqOR?=
 =?us-ascii?Q?w4N2gb1gpwYJqo+Up8xlBVO6WzuDqCzFmEOHFM0VrHB4SuHYNuQ1F7RFud31?=
 =?us-ascii?Q?PNH1q8Gdb0/2z8DCL20Z1raIVEmwwDHTQzEOQcKVERXEMIhSO1rKeS+AugeW?=
 =?us-ascii?Q?CYM12+FavIA0DI11j0Csi9E6mWiJy6VtgepyYIJy7s34ew676tDeTDdMLQBH?=
 =?us-ascii?Q?l0OHz6vuWTfTl/pkHXjf+rNeZDhroKFRBM8e42PLXyf8n4e4Yf4Kd1+KU0sk?=
 =?us-ascii?Q?M6goEX/3r5SpcezLQeWP4AnfYkK27BSynfRJpv8r7aZzb01BVvNkiqXeMb7D?=
 =?us-ascii?Q?8hBmS3yeq3Zkg8m90Bgc43odyYGfH/UIEiz0jYWKQF+p9yGBmyknHlaow6/N?=
 =?us-ascii?Q?ODrBrqZDVn+/LfmUq+NEE8UciV+LxvW+jFgE1JbujEi7sPi2QojaaQpDcZXc?=
 =?us-ascii?Q?pcUPVJ4tuzLKSfldQLcjTWRr+A5yUi75w0tn0hkthioLo2diXYEaG/+7xMt+?=
 =?us-ascii?Q?FDMv1fQQzAom1E/HbJcAtaUds1V9xDRQRJcfoxtfBAnd92ZW78HK21jj2BLk?=
 =?us-ascii?Q?dwMvOiwygtLazKL/KlVsmt2VL7vUYNgKqzZDst4vzW4V1QErmxmoXBUZaRcG?=
 =?us-ascii?Q?YN3HOevGCF+5Icd3AlRoaPvPc203rQdbZojKdzduK1wU0USZlY8WOlDtAg1Z?=
 =?us-ascii?Q?dGD9M8gMayp31dGAm/4AvAHCIqUQQhE+z/L02/BYct4dL3R9lrnwzXhPV1pM?=
 =?us-ascii?Q?Tfa33+56/2c9SfACTQwZ5svIVQuRnRkBFNFsXIvNXVWo5CaozWVX1BSswGEX?=
 =?us-ascii?Q?wxBck1NLgOCvNVRlwLfQ+kS6GTnj684RiGUIMqJ42ulq0GlKD25J1BHd9wmY?=
 =?us-ascii?Q?jg7yQWBeWtWe07d62u3Tg2h1Ves1+89AtC8HaAZ6y4uPAdtMFfsrP59Txulj?=
 =?us-ascii?Q?Y1rljr4d5ePIo1T8yaoDOVM9JZrX2DWQ3gZ10B17PPfqwNe3s6piASlVeyWK?=
 =?us-ascii?Q?2yHvihX3Ix6jL1IT0HUBJSKiAXQpcgfRHlZ6ObTYp0I3qcvj2o2KudHyEejM?=
 =?us-ascii?Q?nsGwCAYBXpA/RPRMAnP1rnWB/jQ0aKAJss9dDqVj3Yco5wyX409svtEL9zIu?=
 =?us-ascii?Q?NOWXr1bWdC8E6hezPVKvxSOIM6z4HJu/3hDh9DCSwL/6aDcIVNKVUhgbXpBg?=
 =?us-ascii?Q?3A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63540b8d-0bf8-4d59-59e6-08da5953ac51
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:15:13.6547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wH6TR91AfCtcesfRSvfWYBf3EmHCBR/BD/qGO1BMGAKtxsECLSH+vrxukfjMcB0POFmaBlKwYc0LxRaaUIGiBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3883
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds bindings for the SerDes devices. They are disabled by default
to prevent any breakage on existing boards.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Disable SerDes by default to prevent breaking boards inadvertently.
- Use one phy cell for SerDes1, since no lanes can be grouped

 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
index 0085e83adf65..8b15653607c9 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
@@ -413,6 +413,22 @@ bportals: bman-portals@508000000 {
 			ranges = <0x0 0x5 0x08000000 0x8000000>;
 		};
 
+		serdes1: phy@1ea0000 {
+			#clock-cells = <1>;
+			#phy-cells = <1>;
+			compatible = "fsl,ls1046a-serdes-1";
+			reg = <0x0 0x1ea0000 0x0 0x2000>;
+			status = "disabled";
+		};
+
+		serdes2: phy@1eb0000 {
+			#clock-cells = <1>;
+			#phy-cells = <2>;
+			compatible = "fsl,ls1046a-serdes-2";
+			reg = <0x0 0x1eb0000 0x0 0x2000>;
+			status = "disabled";
+		};
+
 		dcfg: dcfg@1ee0000 {
 			compatible = "fsl,ls1046a-dcfg", "syscon";
 			reg = <0x0 0x1ee0000 0x0 0x1000>;
-- 
2.35.1.1320.gc452695387.dirty

