Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA7759854C
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245656AbiHROGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245688AbiHROFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:05:43 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C9A6F542;
        Thu, 18 Aug 2022 07:05:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvWmsUwLP5P/+kvsYe2xq6fgy/IzLfG4TWzwYLOuMomM5vAxT+ihAqgdIXP7YBg8+U+wjD2D8LkEUiixIithetxZWW/NdqcPrB30QG+FPtTLW0VZywXXpxdpMOJ5w6JeHlc65Ocx/yZjZgXJabhykbItVo+1bulZG3xb6yvJ/Owhft0dk2a15i3cs4WJ10NSmWoRc8V3W4oGe4mBKwZFloNrNirnSiHr2q9QWONHJhspZRI3XqIv5bqbI6X7vosKbXGqZ8VFARCudsE5AcIWW8vVNiBaLAS92LAnroewuZj/NOpfYOSQ2yIU+vxqWl+kpytvQfjJNVXGZ7lmCwjkUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKa4Z2iyWUrrAKXbepNTqtqochQ+INajI4dRmE7VC8I=;
 b=BByz+f5nXNntMTiMUDMawXrUL1ZdW5x3MhoEOKCE9e2eueLp2xPSC5KHhohiSxyGhP/NE4ioLDMZqsLNyQVC1qO+PS3Ad16rRP9dpyQ1p+G1gK9lDETN1fxSknTm/yaLDXgTDvoC4o+nFvddYtLMQe6MDtb5srz6aEsk1+N+Ns8zi+QbdxkJ1mPxf5cNI713WiYmWvI74NW73p/8Dyvs08RMcKQry7mcy5zge8RlqedF1mWrHJ7ZR2/dsUI1FijiR7hU1AIzpVzEQjhjjiGFY8GxFMjjizxLqZyikZnN1kumhVl9vuFVFJtTYb9LD50t67M/t8oZdCgJQyxEpWgIeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKa4Z2iyWUrrAKXbepNTqtqochQ+INajI4dRmE7VC8I=;
 b=eOB1+6mdjcUy9JV1jzQPJZkueeeaZyqQecCjcXq8AZCx2VMe4Ig0WdNmJ1St5fZ6VEwHExR6sH47S610Ma+EVamXrWwApv65Wc5sonT4JpdLMWbuHMtzA2PBdST0L7QEEAPLMrfehZKwggvfjRLfHgaYkgNl3+F8vGzJWEWiCCM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB3PR0402MB3883.eurprd04.prod.outlook.com (2603:10a6:8:e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 14:05:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 14:05:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org
Cc:     netdev@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH devicetree 3/3] arm64: dts: ls1028a: enable swp5 and eno3 for all boards
Date:   Thu, 18 Aug 2022 17:05:19 +0300
Message-Id: <20220818140519.2767771-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
References: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: caafe0d1-24a8-400d-ed1e-08da8122bb52
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sukCfs49hZU198aTW9b4xu/ubLHSociGk712hEa1ZNdgxPF+qQa5qKIIJrHE/h4qtvCxsjhpwadoEoQrQbFjfUTEgeYDj+VJyZFTGYwTPBLHkuE800SCMpmFr7AblVmBPArVTQ1lvdeY4poHuEc4dzUYMr8r8VJhdAp7iMBLZo3dbedHdRfW8nTr0eIGB40Jxk9VNbTbPOa42tj8crv5TGOsNY0UHaLE/Qu5Sz+nQKY9GKTbInZT49e/MU0F1UvpRR7v1gjWWRZGBpZ2LZhViGpbRX3TIcgPb2QxzL13lRmX7OeHxEU6OknLdRi5b5TL4bh44U1pUGESrHBm4M/etrusVSccVBVCVrPBjvH1+QCMZAHGTzXPNFZ2rsshDDL8+ULh6INzyiKd+15JlSM6WSQgQyVIeukvSY5wp8oma5gRSv+e8f/2VJX4hU4w6l0cFDLDblKZSPiWOMmMEZsfyP5+isDr/4b0AaXLzLU++ayh8ihOcKsBNXYmz5+AVift4UkaRpJYH371YFzW5pKk4geI1HHxOwBkAf4noyAbim2taC40RSnDBgfqwYOpGlvYsznHq1P3U0tjLPNBpJKPC+J19L/FpQKPHdHphXEvk3j0jX1t13kdP/NfTcU/XrGg+ckJaTI0+uf/dnOPJM7vHqKIhf3GPSquyjVX/Q2d7LFByr3Q11cmnkWmqTS4s6Jo/Lej/3wJwoF0lT03XUOUXaQxz3oX+hmdKN81tYeLlO+sNTcCMjlOxg3T2SveVKQv0CLSubJJNg9YqT3BjRMkuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(66476007)(66946007)(5660300002)(44832011)(8936002)(4326008)(8676002)(6916009)(54906003)(86362001)(316002)(38100700002)(38350700002)(66556008)(2906002)(36756003)(478600001)(6666004)(6486002)(41300700001)(83380400001)(26005)(52116002)(6512007)(6506007)(1076003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xZLlPulnWhGCjgiB1rMx5hEtxoSuFDsfswF2YtkPHG3xr4q94PD56lw/t0CI?=
 =?us-ascii?Q?dqawLg5IruH9BudXqaOhz6g9IC0LFr4X74VKKGOvEbiNJ+Mu+rwZj3dYr+oT?=
 =?us-ascii?Q?9sesiNUDqiyLq14esjqi5lagcA4m5v/pQhP4GK1jporV2O1cfyVSzfpcQY6s?=
 =?us-ascii?Q?UCZkfF8aa8jJJSA3w7EVf0GfLnYIAaYybzKprXDyew1AkAvaAFYvaUpLIwfO?=
 =?us-ascii?Q?WRO3z/oyiafK/M3Yhpb0jtYbhuBLiO6s3ObBeA5n5umCuB2knKd0wROHGysA?=
 =?us-ascii?Q?hwE4fI5hVJETCxUG8TIsiS6xHX6cWQKjfvWNBKdje7fLcAZtbI0jM7Mfzu5K?=
 =?us-ascii?Q?IZnEKDJrV/NtVvJmC6hrH3IrX3Jq8AgT1bGa04EPSS9w30Vtbc6ZGfeIGlMk?=
 =?us-ascii?Q?xBSVrRuDTnIIm2d1tQrpiKxHttgdWFHx+7MCYrnfzlYdUubPrau4U6p9f9TO?=
 =?us-ascii?Q?zcNI8DtrshHiUd0twRduWCEqw7u5/3iX5WTyb403Olpf/t7qkdo96k0+3s/X?=
 =?us-ascii?Q?Id5XZMexF78DYF2REu2TKA8KLjFFYYwUMTZP/6s98gK6Ksnw8HA/LiEPIxva?=
 =?us-ascii?Q?KcdU74NEOMqxS1N7ixdmlTt9auOEDp3zh6gFgLayvFDJKaBjQnX1YhGtigTV?=
 =?us-ascii?Q?9NyOgIqRHOfhkGq8gPXhj0wI4DxpcRFpmZOG6xLFNLuTgZ7rtkK76mYaeZ7n?=
 =?us-ascii?Q?pkV33iO9ewdZwhOaORF7WUe0EQ0agvNag9hfEPk90zAg047BBN36RQOlg9Jj?=
 =?us-ascii?Q?QSSIGXcGA5lSpqmB0DXIX/Xy51H21F5f9u7GgiIHos4Kb0hO9PnQ+O5q+LCj?=
 =?us-ascii?Q?fQi9SRCWeNh4GvuZY5mIgUMAQxU4GuoA7ppDcrN1+mhmojllWxnOcQYtiHxZ?=
 =?us-ascii?Q?B0pCy9bRsFkbrMdIJI4YyjyGxGKkzYH4FUDofoA1dIq+lEbArk7oFBsy8V5w?=
 =?us-ascii?Q?vzJ/6M5yldmVGz+oUwdNPqbO/OBARnD2OZQIObNbG5I+XkpLMg9lUGNJqzNg?=
 =?us-ascii?Q?8bB2fFuNp8lK2QFJNj/PB+2HAhIQxiRrOokjXmm2SZcXnz0O3rSLyk5FC41u?=
 =?us-ascii?Q?x80WWZOdmzN/sN7vM2DhNglco9XxBMzcgJjaAWevQjx1b11r7uxNVyPMO3pN?=
 =?us-ascii?Q?2diErr5cQ8BvWmjfvJECDL56FcIRwTwb0nVWs6g2pvOewlKmdBg29Zei4fus?=
 =?us-ascii?Q?3qz7wMIIxI50TtY5pK4QlmdApnjOa7O2mRfiRKnaRx+dMOQ3UwpuVfgZ9W7v?=
 =?us-ascii?Q?UAmmt7zSu4YWknGKinZqYxs5hAV/R5tz8NT3yMEfSttL/fopczhkzMxC1ssg?=
 =?us-ascii?Q?hU9N51hY/020syjrsoejFE/3VIFB7ygWB4uLql5cvqMjuDphTDrat3s8HZzU?=
 =?us-ascii?Q?SK/dU2en9kwdaIxb37yCiaL6cHAUtBfjF8YvOTC3pIkHknCCvd7BlvIfpXsZ?=
 =?us-ascii?Q?bLDoWlXOM7bzWBcPcy5C2l9bWQjWg57grP/KB7AmabEcXDH/yKiI9mUBmX6Z?=
 =?us-ascii?Q?e5beHmN73fS24c2nJnVUr7A8DBa/uwScsyTR4EYigmwTI3dVU7MLdS2YGWsm?=
 =?us-ascii?Q?nPYiIA8lk3CUnnqcWxjucWq6aZJbaijYcXwb2ojaY/zj+3niXRSADxLRabS+?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caafe0d1-24a8-400d-ed1e-08da8122bb52
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 14:05:39.9554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FOoKjwwcwgHdo6LvNpGNsJtHz4QL4FknfOj6ZpNEo6Xd9b9RS94SIUgiT7GTT9xNp9Nvr3KNTomYrjdYfq7Yaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3883
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for the LS1028A based boards to benefit from support for
multiple CPU ports, the second DSA master and its associated CPU port
must be enabled in the device trees. This does not change the default
CPU port from the current port 4.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts   | 8 ++++++++
 .../boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts  | 8 ++++++++
 arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts         | 8 ++++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
index 52ef2e8e5492..73eb6061c73e 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
@@ -59,6 +59,10 @@ &enetc_port2 {
 	status = "okay";
 };
 
+&enetc_port3 {
+	status = "okay";
+};
+
 &i2c3 {
 	eeprom@57 {
 		compatible = "atmel,24c32";
@@ -107,6 +111,10 @@ &mscc_felix_port4 {
 	status = "okay";
 };
 
+&mscc_felix_port5 {
+	status = "okay";
+};
+
 &sata {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
index 37c20cb6c152..113b1df74bf8 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
@@ -39,6 +39,10 @@ &enetc_port2 {
 	status = "okay";
 };
 
+&enetc_port3 {
+	status = "okay";
+};
+
 &mscc_felix {
 	status = "okay";
 };
@@ -62,3 +66,7 @@ &mscc_felix_port1 {
 &mscc_felix_port4 {
 	status = "okay";
 };
+
+&mscc_felix_port5 {
+	status = "okay";
+};
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
index 7285bdcf2302..e33725c60169 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
@@ -151,6 +151,10 @@ &enetc_port2 {
 	status = "okay";
 };
 
+&enetc_port3 {
+	status = "okay";
+};
+
 &esdhc {
 	sd-uhs-sdr104;
 	sd-uhs-sdr50;
@@ -281,6 +285,10 @@ &mscc_felix_port4 {
 	status = "okay";
 };
 
+&mscc_felix_port5 {
+	status = "okay";
+};
+
 &optee {
 	status = "okay";
 };
-- 
2.34.1

