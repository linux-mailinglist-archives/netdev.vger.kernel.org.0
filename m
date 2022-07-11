Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A542C56D2BE
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiGKBty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGKBtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:49:50 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130057.outbound.protection.outlook.com [40.107.13.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D2D17ABB;
        Sun, 10 Jul 2022 18:49:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDTvZ5c4J5QGSHavnCJ3HhjAoqYq+wNdBH0Ja/DZZ/8FcxQl+FYbodfIE8pfMX+4xDAGVa5ROf2bYr9ZTbIz4tOe4TPpP1KbtghsOaWqMuZyeJgcjhshBIe3xQHlv/LMWBym/P/1bCmgAZRXn/W0uCeOAvoaZwXqYSbulDu8E+6P0qTvuKEBmA4Lxuc4nlhtX7Xj3kEIS5n5PIIe0Dv3ONe3oxqXLL4Ravw1pHOVAqg/6ezTSFwNawyX2ciizbUw/7f+pwL8htup/SVYgQ6+jrmgopJPBMfEjHvqlDjt+9gBBsSX1doETRUiIegPLetEmbavgdYnmhpe0YW2ZkS3zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63A0vvHDwfSbJWG1zfk31bcXa+s64oQZz0YL2DOPVFY=;
 b=OuhIfCspoN3SxOKaKQ6Q8LtVNgJSB63UfzzwoH8qWiRMu2no+k6+TQnAOvAnnmzKudu8sDV9O3F130zLrvCyl+Vg0kFKUlFZUJcR2e9Lq46Nf0CAczQVsQidK/G5g50yurfJnhNKI5KE2v2tXN3M9NcBn9i/k6eSxcUYbSz33jk2AauTn/yZ+CtprAWZWG2d7QHvyHkVk+Y1vNSr1lE65LltMpS55dHsIQ2xBo6N4ucXts8vG0SYehDOBiAmzjUTqQSd/vyrodfUYBrxhsMjmanaa/fXaOG4WzUQI0oI1x7cON22mlyb5Fu/OmzDkXBSW4to4qHycFQoi8hAgMAG5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63A0vvHDwfSbJWG1zfk31bcXa+s64oQZz0YL2DOPVFY=;
 b=T1U9zt2UaLPli8lRGemaJbUvMRMjtQIDB+MTu4tkmxVWZ8ny67dHH1DXk4MHZOklKBBSV/zM+iIVd7TbTjjzFMC/2Z52YNXVSPSz3TSYXsKScR6E0jjgjeukkfUF/U2YEAVd5CuPHaP2Oxvvf7Lc6KF5k/BvUuakfnTHN6U/IOU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AM0PR04MB6673.eurprd04.prod.outlook.com (2603:10a6:208:16a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Mon, 11 Jul
 2022 01:49:47 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::a9e6:66bf:9b6f:1573]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::a9e6:66bf:9b6f:1573%8]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 01:49:47 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH V2 2/3] arm64: dts: imx8ulp: Add the fec support
Date:   Mon, 11 Jul 2022 19:44:33 +1000
Message-Id: <20220711094434.369377-3-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220711094434.369377-1-wei.fang@nxp.com>
References: <20220711094434.369377-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0169.apcprd04.prod.outlook.com (2603:1096:4::31)
 To AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb4fe27a-e04b-4687-8a3c-08da62dfa26e
X-MS-TrafficTypeDiagnostic: AM0PR04MB6673:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ImwoCQiI6MHVVUtnUrOlZeDhYj+1qtknSIpLL5vPzmQ44QLUXJqUvtiCpcIKq4TXTzYp9D3HuN+AiA65YSwkDpGk9151/TZ65TnK/KQUqYAUJgMdNco/ya9q/nEYPRyvDvrx+ALYCXmtJgEmkDO6S2hCMrErbD/H+g/lIIWkc5R5tdA6Lnoz9So+OYNdxz1qYbDJvhUJ9RPo5jvhlLhYzsVHSN192fuDFN5AjH8hP8IwefEXckXyJ2e0KZemh7iCdsHQCVg7v9tA40BklHzcay/LAUoRFkA8xM1sHCkVUwq7CkgTmKyqfnXVbyzy0KiT5rNFDeBegPRvxSDYeFqN5ZfRQotrYvl94eiYPDN53drsszwOL0lWixXhLbB/TXj0QmQ7cbKyHjWvCcojyjVUK8XAYA71PxNxcgLk16cLgSePYA2UW3N/i5EMgJ29LwZpUzFHmwjHUMNz3fYiWZfKuSSxVlYlMDZGWESpC+eJpe/4bqURHNF6adbwcqfmU9GxqL7JWLaDDE/A2GZq5PaEFrbLAMrVVoDndDUuqZQ1tyyT5GP1baNWka5OWRD5WlA8qQ8bsPH5qogit1UVmsWKic76ZxC6YD+i7zItsvqdtfKVoIYF6iWtxi1arPDT8c0dNv0AFia5WdoJ3NwhVdNFz9dFFNgbSE1R627i3rl8tNWahWYUZvv3Bv8rms1C0MxRPNGEuruYSpdoDCXn7jW/TsQkIg/psuGWk00rYm0pHEH72w9AU/Pp6hZPIZ1xVc2+F15bhyxL27FX29LXP2gb2CJFjjrXxZTLlb1C3D+H8LK0UnV1Q/jyulvcKGa9o5zMvWfh9RZix/pEEe8O2SqmTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(66946007)(66476007)(66556008)(6512007)(86362001)(8936002)(186003)(6666004)(8676002)(1076003)(4326008)(52116002)(6506007)(41300700001)(26005)(478600001)(6486002)(2616005)(38350700002)(316002)(38100700002)(2906002)(36756003)(44832011)(5660300002)(83380400001)(7416002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MruUGQ2M5LSDO6eeSswlCfTAnW8+GYK101e2Pc5tlmma9XT7vPwsDforcMZ7?=
 =?us-ascii?Q?CY282oYT24lMYm7dDUbslXOEAdC1GFQEuTygSCp5T5WFpu6kIpQGXY5ERMbq?=
 =?us-ascii?Q?NT7cjohMYu/opXO0Vezf9Sauoy006KuqFNTMRCATDCI8coxzYPY306Ro2+tl?=
 =?us-ascii?Q?A6INylhQoFKCMqYpKzvBvajwsMxkNnBPoB20qc6XgkGK8A6Ob1GezisskCXj?=
 =?us-ascii?Q?XpSc3NNuK/JdOnOU+p5Z7HAvpdWYoYFnsFCQMhqIsogf9aBTeigMAGPefiin?=
 =?us-ascii?Q?xYEN3/hqkAsh2936W2uth8YNnqIY7TnKCVgBbgHJg48SsW2wf9LxOAa0TEBc?=
 =?us-ascii?Q?ZST6nEZQmPmZbX9/3MvbRDq5pji1jUPxtXsZ2zq1ZRnWGXw0yATt//xAkw89?=
 =?us-ascii?Q?XVrLAaxiv7w/iyeMrRf2pwIUxr2iu9LVg6Rt73YMeN5bHoEQAT5i7y3SgJE8?=
 =?us-ascii?Q?o3TXDDdXa78lRtE9NPCQP0GSN5Hdk4h5bD3R2jo7hqdq9BCMIzilMwVBVYn3?=
 =?us-ascii?Q?emfTT0ftgzt8YvbRvhMM3MlxZgWrcwYNwokwgz9+3ZiCKeW2N6m5l2n4rgww?=
 =?us-ascii?Q?wavlTXQDUeypc0JIXuWh+QU/sVMqvQ0NKlouGbXQmpDgtNEuyq0D1KQUfaCd?=
 =?us-ascii?Q?2vTDOmwW8gk4yt8HLE+d5ABUagmKk993X8I2mWBDc9OvWefAJR9X5OukWs1N?=
 =?us-ascii?Q?ozPxnlCI2D7hGClauYSTBE+0bGhpmu2L0QgaS05w3vZ5VQZRXUfcDhqgepsc?=
 =?us-ascii?Q?ARbNyJVFW3My8KfoouWEZMF7NxhxoY5XjxY58xacYfF46YYnTn84wkKEa4Kp?=
 =?us-ascii?Q?nnI6JZYyylGgnokeCSrrA9OC8w3WVGx7mmOZkU6qpR73QU49cSHwd6bnOKwZ?=
 =?us-ascii?Q?fouXhYOA0v4FpDQetB7APuwd/NIFoUeFZ/us3vRL2FqSlo7z4TcoGYxJ/fRQ?=
 =?us-ascii?Q?blIOAZePc93pnmwtqDFpuL3gL0mc8tJmP26f2mwI8On6zNgO+oTw9FBpHolm?=
 =?us-ascii?Q?KWldtrZwMxHZPSCN63bk9jOPqDZpfVAgKq+z96slefx0NfpnYM392UtdBZKU?=
 =?us-ascii?Q?CBB/AENsGAfy0BFQwbntuyQdAccfyveYm3mUxgxgLiBQ8O0Xj49u+6u0hWz/?=
 =?us-ascii?Q?6+YsZHCoUlwzL2i0XRPDizgn0puBcU7nzViUM3yuzcz8nkOTt4z5AE6Ko/br?=
 =?us-ascii?Q?Ji82/T00oiOCtfCDokLaGOIfJp9fgwYY04GnOUPMscc2CgsX+A9baxaBZOXC?=
 =?us-ascii?Q?ogWeocBO+fnqfe+UTGMakcl7ZRSjTCopOKAbaDwwrB9mHlBcuhevh5f5aRBy?=
 =?us-ascii?Q?b+rP+WdoPkKPRt3QrHqWTJs8I3cpEjodx/Tw43dxx+r+dWL1UDBbR4WydCFc?=
 =?us-ascii?Q?RMbQ/SRckTOkEDnf4k9Ue+JNjCgiwYsFb22oVnWh1MR1UioOLb7A2uKaQCxR?=
 =?us-ascii?Q?eHPPso6duxFoEeFES7EFKTeezUL0nWDPtCFBy75FiI0WFcLRmKGFh67ZH9U/?=
 =?us-ascii?Q?9C854ifyth9VcuUfVxDk1z+LlsllZHvthYVTgmi/NmDojkGXrDwlDnkt9h1W?=
 =?us-ascii?Q?EqzbONoKKOKm5hi39Syc8h8U8fcUmCohhs2Ypjgq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb4fe27a-e04b-4687-8a3c-08da62dfa26e
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 01:49:47.1696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DZzl3pinqd7dKHWLEVzF/ZVtcahABobKr0K39iageFvyFXOQQZwULnOTmoLmmvFy+b4+J6BsfOIVpQ9Oo7cPoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6673
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the fec support on i.MX8ULP platforms.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
Remove the external clocks which is related to specific board.
---
 arch/arm64/boot/dts/freescale/imx8ulp.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
index 60c1b018bf03..3e8a1e4f0fc2 100644
--- a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
@@ -16,6 +16,7 @@ / {
 	#size-cells = <2>;
 
 	aliases {
+		ethernet0 = &fec;
 		gpio0 = &gpiod;
 		gpio1 = &gpioe;
 		gpio2 = &gpiof;
@@ -365,6 +366,16 @@ usdhc2: mmc@298f0000 {
 				bus-width = <4>;
 				status = "disabled";
 			};
+
+			fec: ethernet@29950000 {
+				compatible = "fsl,imx8ulp-fec", "fsl,imx6ul-fec", "fsl,imx6q-fec";
+				reg = <0x29950000 0x10000>;
+				interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "int0";
+				fsl,num-tx-queues = <1>;
+				fsl,num-rx-queues = <1>;
+				status = "disabled";
+			};
 		};
 
 		gpioe: gpio@2d000080 {
-- 
2.25.1

