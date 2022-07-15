Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947315769AF
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiGOWGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbiGOWEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:04:52 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10040.outbound.protection.outlook.com [40.107.1.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD118E6C6;
        Fri, 15 Jul 2022 15:02:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIJROKjCUiS/c/3AorIBnQzaNSjFhH7cstKxPPSiPh7dYLj/qODqO5vmoum0o50pQDmcRk3cVSTrnOD5yq9mWUPuNKhH0lQWDwS4eHQ/kRoaNZKo8o6+daUXH/J/6kTW7BPy++QuCIJuFRmZN/AR6VS91ox+GovdhOC1Up/d5tdVCdrU7dvaCvdDGozYNBF/n9x0dqFlbn6u0dJU8n45ttgG2noYSLqXYGN6lC1kU7ZRqqD/aZOxRazJACkRSHt4nu5uEyNBS4UaQQ9BZDHNjbo9MRLUAA5DiK+b9vwdheIlpZrktUlXC4lFpVK31+pg4TvrE3DQGuwucFErR2XuKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbLQV3q0/V8KQLr9WEwhbXr48x0fw4ztJcEoYQZ/QuA=;
 b=nttx73z3FGnW7tBwgekOvqcRPOsp+Mi4ACCw4SICr7f9+ZzmfIbBYdKrtW30RlwRYKCwzhJnUZBW+QWaKnrtnmcmznVPFE7A3maJfVFgz/MIBoZmPSMlT0DE8GEBV44Y13PDZMOHDVxLyihPy1UJnQ5mZzjR7w+iYXMvZI743nP3zptDhl+80qFf4da9wIG1Ck19U+L6k23eyYvz3zVOiBgxXP6B/Kwyu154toss5SuFS/7icBMmvkPfPboKfrc9uvtR3/CF+JvXp//soXR7CLZhvW+PSkXhdZqMQlYQDZ7EmAX7H8U8ZXECtHhFa8TAPBXN5GlD3kJ6sYYkuGdvIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbLQV3q0/V8KQLr9WEwhbXr48x0fw4ztJcEoYQZ/QuA=;
 b=olKOY2NBx9CrD4GOSYfphZ2YVwDpj86mF5PtiObHEeO0Ihre4ODJyBvunx34Z8AbR3oX7QAGPza/qDkWcd0C3JMPcCHdpWOloHLepNqxhEm+2v8Nq0B+ytW1dLZj+j7gtla8wg1+mNz1VZ5JNvVOqmYcMzvWPtgxT+UGXlhJ5X44Wzdu/ZbobCUSScjaHkjAwP7EIN1VzndvUqK2OrCoNl6yfdrlwDKcUb6bbOcfbE2H8qEcYr5398ZfgtMya35b3kcOaDtbyKxRYj8X5MaWWax8MM3Gznu8EbYIbm4jRe7lLfhkaNsCXG7mJiJu+c3d5bP1yptsKGs5cBW0Tftttw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DB8PR03MB6251.eurprd03.prod.outlook.com (2603:10a6:10:137::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 22:01:58 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:57 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v3 45/47] arm64: dts: ls1088a: Add serdes bindings
Date:   Fri, 15 Jul 2022 17:59:52 -0400
Message-Id: <20220715215954.1449214-46-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc3c6b1c-f260-4a32-e1a7-08da66ada2d2
X-MS-TrafficTypeDiagnostic: DB8PR03MB6251:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L03waVZcrdTHVCBsIDWiMP80S3YD8Yv3TZcXNSb9+iO+nTZ55aBB69OcO/riOQ7VIxU4De1ftUf5aZ7gcLUfPQmSNiEwXboxS9VESJzL2XecEytALT1kKNZX2w2Nlp6jxBS+9IH/8zYXi0q0zjG9V6Xe45XYclRCvOdKTQQOYVkICZh4Q3kZmzOJ2tLXdt8BeKq8i4+mOWMeRhFM98h9YvAEtw9DKL2PDiRdG6IcaKPlrnG1kqAnVbVZz1vnvoZkFEGmjJdgFka7DugdNEVBqo5FYq/gsQIncsW8Sd0Eg66Ys7xBrfb7Cneo4QhP4JDxuX4ASK7D4qTnrr5pjxUrXTboa5XK4WLJuacDUIl9vaEhHgtUIelj8qNZn7oS/zbptHq5wpAlNcJQOlGrBu9qPUZO9lwjX9tjDNo/TQCyCkAFvz+LtkRBsmfCUtDn44LE2HgiAlEeK9zPZpXmfsUTV3HzFmKFZH1G1disQK+pgH2CYRS1LaqzO4thuP2Yza3dWH7MkhTVU7ggiXoZS06Nfe3LSXEci74L211wz0zRiA5budvC9wAeRoLZsfBhx0wGp+iQ/lNTrSdLlnrGUcG7m6exdcJvwMH2xo5dmQuTdVdjAWD1sPtXzBuR82TvZzxKgkxoI9kfW00RliGu8a9okkSn1gPFCvYDIEyOng1+AjTTcizoc+vBD/gAav/EmQuVaAesGBk6DDUfYPS8MfyzbPsQ3d/AnHG2BRkXqb62F7EPsCZdFF1HZWzojcWVeVn0Dis9R/7IGbxvU20XbRB/36dqUsYd5HQJHfRR/9QfhYi3jWx6vCkTevX2b+8KS1Z3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(346002)(396003)(376002)(136003)(38100700002)(4326008)(38350700002)(2616005)(54906003)(66946007)(66556008)(83380400001)(5660300002)(7416002)(1076003)(8936002)(44832011)(8676002)(66476007)(186003)(2906002)(478600001)(6666004)(41300700001)(36756003)(6512007)(316002)(6506007)(52116002)(110136005)(6486002)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5pjFQ58BYICRHOPb8Q3C0Idxg7FjEJ+6U1VYA029AioV/BV+JpBtJozex0FV?=
 =?us-ascii?Q?LCwhZTlZ1AalQnqdW3HzWxIXrib5idaRRSquGxiJGb7QYJPdIE4cMvZlIyPN?=
 =?us-ascii?Q?6yLZA6DYDa9LPavFGJ9d07b5azEotsVXKQmEGQCUcalG9t+XQ/BdNAN4bVPH?=
 =?us-ascii?Q?/wvJOoXP7m4MtMnIHuTomubnIdgg6YFcFm7ojLbJS18Z3hiLYJOY5icZb5Jl?=
 =?us-ascii?Q?iwVzcZNg4+c6iYlVhRCfEPCT2kzhrRMb0L1qsB5ZhD43td77O44x3CF9aRK3?=
 =?us-ascii?Q?eLe2vccShznh1lhzj5fBqyYhASP/cS/SfhZCBaOodH1yG20LXfPteoE+yzwy?=
 =?us-ascii?Q?ThzozjjyN4WzVtsrS8+RvmL4H2TJA9aAe2RIVDcIFGqSTXA5Kj6ruEYHzGVn?=
 =?us-ascii?Q?ef+wOLVkdFVqn7Ux8EKNz5uBTIHT8ojGprvRCsCEu9PxiJeiY68cznzYmQzP?=
 =?us-ascii?Q?hlViL35zREeXVwDY3r2O4p2kuIF5eYXwX+4+PREi9AH7n5r/YhFRGj3xx5s6?=
 =?us-ascii?Q?HS76i+ufVHMGQ5elA3ycG17iYtcFzO7+W7vyuaFWyMTcy1x886ANOR1NyV21?=
 =?us-ascii?Q?zybCMOt7zI00HPxmrXDR8BJMCe3nHgY6F+3NZku8aVrQRuwPxC/S8zLkReuS?=
 =?us-ascii?Q?KucqWBcYX7QrSUoFuocLvcslG4xfql74DLVa+10/9d2hVhBg0DE5kivegC/Y?=
 =?us-ascii?Q?BwAFL5MU3OV0Dw9HvjFfRGh9uoho/Oz1eyLo62fQbg2CUjpSPxtMFEBp+0i/?=
 =?us-ascii?Q?B8meCrA86HWXx9R1gdmHX3d8M6+WZIpDb+MhNNMLEhGbLrDgsWCwbqCoLE1T?=
 =?us-ascii?Q?Wy/PtpxLPbDURhvqRZQhTQcDrYsEGBHhynN5i3LkRYcbjg8qmSl0Y3RhCYhD?=
 =?us-ascii?Q?jprmUxuNwhf5xsvzUXLTY1LuCZQTBOaJrUEiKmPTupBN39OP/OnZoNh0Nx1M?=
 =?us-ascii?Q?e2FYNiwa/s5V+9u1iADxMB01hZlSDn1udfyh60Q4KWYMThhCHaklbalW56E8?=
 =?us-ascii?Q?r8sTD9HSKpiNxuq1BvPUuNiat9cCK39IO25pNNw2X4iS0mbzzm6CC5q9CqDv?=
 =?us-ascii?Q?PYhLVV6PwSGh5Quh8mzh5H2RLCXCePzhqLBLSBMLdJEQX2YlKUisTr0VQRPs?=
 =?us-ascii?Q?H5SKVfWfyeUujPEHy4K1iB2j59+UWrZoLyAHpSlb0FxVcl1ZjrEHiQAXKFxc?=
 =?us-ascii?Q?KyeViWkDhPvS8UbS8krMxEn0Bk5I+JfefelrboIUqerdZS7+gdq4t9kMTsCc?=
 =?us-ascii?Q?C7wVA9jqXXDGPcv6oUxmWk00sokTC3oneyssdIS/ZURNtcdwWHIhGWOtczBL?=
 =?us-ascii?Q?1YlTEmZyBPsjJ8tunt/+n/Tjp5HTobOZMzKJ6FHizVbVtbnKrZi6RR5N6zFO?=
 =?us-ascii?Q?3Rqz8MpLyKmokolS5ZfDUEDmrMyk3Y567EbVq0UnmuXrUgxVChyGs6V7Jssv?=
 =?us-ascii?Q?o6I+m6osWWcZTkwRP5j04rfvlwdtGW3ZLZlzyxZKX8HqMTY51BGf7m2eerJ+?=
 =?us-ascii?Q?S2KtLwi85HHyKLTzKysBmdHrIkZHFsv7XGkwWHgqwLIT03B134GJHG/ZAfR3?=
 =?us-ascii?Q?W1WTx2yOrE+TT7vADJNOv51JT8WPXwg4ecNBMCVwQ0nspVY3K7SE7/PfBm4U?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc3c6b1c-f260-4a32-e1a7-08da66ada2d2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:57.4232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PzmJ+4/uKTz/QDGe9oCl+7ePiVxiJu3t2JAUCfIJtfK8cG9+ryDq+NgCFBA9WP5Ilae/RbrqwwTVhjlEnobBEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6251
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds bindings for the SerDes devices. They are disabled by default
to prevent any breakage on existing boards.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- New

 .../arm64/boot/dts/freescale/fsl-ls1088a.dtsi | 96 +++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
index f476b7d8b056..987892bc69d7 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
@@ -238,6 +238,102 @@ reset: syscon@1e60000 {
 			reg = <0x0 0x1e60000 0x0 0x10000>;
 		};
 
+		serdes1: phy@1ea0000 {
+			#clock-cells = <1>;
+			#phy-cells = <1>;
+			compatible = "fsl,ls1088a-serdes", "fsl,lynx-10g";
+			reg = <0x0 0x1ea0000 0x0 0x2000>;
+			status = "disabled";
+
+			pccr-8 {
+				fsl,pccr = <0x8>;
+
+				/* SG3 */
+				sgmii-0 {
+					fsl,index = <0>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <3>;
+					fsl,proto = "sgmii";
+				};
+
+				/* SG7 */
+				sgmii-1 {
+					fsl,index = <1>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <2>;
+					fsl,proto = "sgmii";
+				};
+
+				/* SG1 */
+				sgmii-2 {
+					fsl,index = <2>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <1>;
+					fsl,proto = "sgmii25";
+				};
+
+				/* SG2 */
+				sgmii-3 {
+					fsl,index = <3>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <0>;
+					fsl,proto = "sgmii25";
+				};
+			};
+
+			pccr-9 {
+				fsl,pccr = <0x9>;
+
+				/* QSGa */
+				qsgmii-0 {
+					fsl,index = <0>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <3>;
+					fsl,proto = "qsgmii";
+				};
+
+				/* QSGb */
+				qsgmii-1 {
+					fsl,index = <1>;
+					fsl,proto = "qsgmii";
+
+					cfg-1 {
+						fsl,cfg = <0x1>;
+						fsl,first-lane = <2>;
+					};
+
+					cfg-2 {
+						fsl,cfg = <0x2>;
+						fsl,first-lane = <0>;
+					};
+				};
+			};
+
+			pccr-b {
+				fsl,pccr = <0xb>;
+
+				/* XFI1 */
+				xfi-0 {
+					fsl,index = <0>;
+					fsl,cfg = <0x1>;
+					/*
+					 * Table 23-1 and section 23.5.16.4
+					 * disagree; this reflects the table
+					 */
+					fsl,first-lane = <1>;
+					fsl,proto = "xfi";
+				};
+
+				/* XFI2 */
+				xfi-1 {
+					fsl,index = <1>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <0>;
+					fsl,proto = "xfi";
+				};
+			};
+		};
+
 		isc: syscon@1f70000 {
 			compatible = "fsl,ls1088a-isc", "syscon";
 			reg = <0x0 0x1f70000 0x0 0x10000>;
-- 
2.35.1.1320.gc452695387.dirty

