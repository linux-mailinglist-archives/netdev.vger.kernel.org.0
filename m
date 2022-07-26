Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5371580BD0
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237914AbiGZGp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237971AbiGZGpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:45:53 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70080.outbound.protection.outlook.com [40.107.7.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4207822B0B;
        Mon, 25 Jul 2022 23:45:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XuoUOU/KhQUNT7McbMpciqRu1Ma0TDN5IRck3AojxJbaNbm7Ch6ix8YK+valPpLvJ03KyvdV7wgxNSJGhgp1TuPyzujNKMZ8ZYczX0JF9WF3Q2xKz+kGNjDdf3SpSuvvBEJ7Fgnw/Fq6NsVQUUxmyb4IaxfpMAxnyORb9BzGfUJdM4YuTsk356WXNmeZj94fkFjZjZZk4NehPH2EopjWI0QbT0vvkqo+QDwDxFXohxoPu6hW8H2rlhUEv3ct+dGAoU5UP9d+DbWTHt+0p5ZGxD2ArbjeTuXBpNmBXgPg2WlxCS0Xxwb0+WTpxWMwIdvGOasu/PE8DJWznVZMMfQkvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRAwVmY9wygknB+nG7zm5fnssP02DCuG6DgRhkld35A=;
 b=LaBfnNTiA54zWoJLZOzTtz6AtOd2jn42yV5XBzUVuourz7SfC/i8mXEVg6Oebj6T8uD8sYBW+ZKXkbuYd0DcGBoEcINGfdvSKBO6Tg9drJ8GuI+3O82wFXTxGNIkeP3QB1zLFzrB7ZavOH8v8EU90+DVvkn+STWaZjrCXYBY7U9zCZCS+3yrtryqiJfKZ5eUZ/apYJjOt/BaXeda94uqn/FwAGJ1NmXOCvAUdhe+TnxpuD11DMK5khku1KETpI6HJpO5MeYuz8KlO0b3F7IDWlYERgWLG8EIERr+QF5GbF6y7zHo6l91NhlQ0CTPINEG2UEcbZJAw2Gu4BpERjP+eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRAwVmY9wygknB+nG7zm5fnssP02DCuG6DgRhkld35A=;
 b=VflKyrUbm+Ool3M9/zCbsvsQU+khJ/az4f18nvtZv6aou+rrjVBfd+EqzcF/ceWDRyw+7YFx2aI/50iEUQK1VaLJ0MeyDXLwur5IYLWMFKerZAHOJ6Z9UOAk2wdcL+ppm6w9CRG1oHf6mo2BfcFlqJ1qxXHxKmTMy7opos8mx28=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by VI1PR04MB3247.eurprd04.prod.outlook.com (2603:10a6:802:8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Tue, 26 Jul
 2022 06:45:39 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1%8]) with mapi id 15.20.5458.024; Tue, 26 Jul 2022
 06:45:39 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH V4 2/3] arm64: dts: imx8ulp: Add the fec support
Date:   Wed, 27 Jul 2022 00:38:52 +1000
Message-Id: <20220726143853.23709-3-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220726143853.23709-1-wei.fang@nxp.com>
References: <20220726143853.23709-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0003.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::20) To AM9PR04MB9003.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0724a80c-c02f-4654-f48e-08da6ed273ee
X-MS-TrafficTypeDiagnostic: VI1PR04MB3247:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ftha6vmL/itk+QFeCiFH6JDXiD9PuJbAPAMKP8SmHns4C9ExBNQGhdL8SWFI7TbqYjEV1I0ApsjjuJ1HDzsQagqMp10OtO8TlUro85iNs8cHfLwlpjNWf1BFS9759iqCM1NqJ3MdZ4SkDgNzMNRa5SVFoeFwE1qeEKvSD4/6bIIth7XvGkhGGIA3EkZ/ntKcFbsTOKDkk16/pAYr+sSjinbl3WGi3OJtaXjIec1/dabp+DBXewdu3ttefed8MJhHSr8P334SXfdHWJ6IXV27DEUQT/kuWJW+QThki+T5mjCUtpvuoljKY5vkHWyTLJiw06lJYWcyIHeA9GnRQrn6dhnKEKsRiHaoOcyegUquDJBFff00Gxr+XuueSa1vOgRO+C+dBKOT/HJ+RUHCRmirEBHD3nUy0nEYjOG9vLbXcoDZDpUdPUTUDUF/qjRcEqdydMiaXiRAohd7RW5Oj0187TuVIHmol3/R1M9q1ISpm9uRSiOxBCso9JxP3HWv0FKSEFL0VudPOgviAorqqghvgM5efeKZhFTeT06Er+90TSAISpHwtyLlWI9ehqlr/3UnrbHTxELf6Jch35viqIpV4i1ps39K28WYuTNxOywdZHnWiqrf7MzEaYkzTS9jGOvZYtroJtQRG1QK1RefLSLBOOVbThDpXHK9IwG0KHS+vMB5q4YWNjGEKcs2jXFZ8mogpqEYhGUQ7/eelD7oh+q7JqWuTFsThYb9NOAxniOecRf4lyKXUuRkpriEHDKOZDmut+YB8OXYsguk3SdXR6xU7tYi/FqSjUEyxRDUY/WAst5WyBnekUhK78G7E1uSqdI6CT1IQqotNNRHH9y0ccxk9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(36756003)(1076003)(186003)(86362001)(2616005)(83380400001)(2906002)(5660300002)(7416002)(4326008)(38100700002)(8676002)(66946007)(66556008)(66476007)(38350700002)(8936002)(41300700001)(6666004)(316002)(6506007)(52116002)(9686003)(6512007)(26005)(6486002)(478600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2y5R7jvFFRLLSb5BBYhB9BauYOvhdnaUbcdapa30qfhkyf91bSpiuovOHmLr?=
 =?us-ascii?Q?hQRplATUX5gl8fYJQGg1okNg1dihUZUeLdip0w2laJBOgR913g9r1+/EwzTs?=
 =?us-ascii?Q?gGpe6SuWx1NSjJnr8whZTTmDCG6mI3Vp8OZW6QpZwfXRxz4+AfIg8FCsjeyQ?=
 =?us-ascii?Q?Y7p/jQx0fT5thEUu+YZNKl1qLc4tfGzaqsZJz0TGCS8Dqx5wchbqcjrFmDd/?=
 =?us-ascii?Q?adbDriBs/UfkiigFxtWLc3Gtj1puDhx9GXL6STbp/x7r884piBYXpR3/QXix?=
 =?us-ascii?Q?MtScYkNyqi6bbYlRfJzIzxxdejIKHPO105erCUtUuufhRNjz/5K+/dGRIKel?=
 =?us-ascii?Q?Tbj2KQkZTDICCGG/z6fKxLPqVu9T8cUSj5GgVRZsLqnhzU/KE+gXslWdVDJt?=
 =?us-ascii?Q?BEH5VWk57940GkwwJ9Jt8XAkZQ2/jtt1xkaENN1SeqGAMlQNiBHWO3DdNmE8?=
 =?us-ascii?Q?PEZCtgbY5Xj/yhy+iCdYCw0Psvlyy9coy82hPp7WXjbB24ZMpBeFJokf9rjG?=
 =?us-ascii?Q?CUSAM8za3VOM11tZ+txQ2oqlqaZo0Bvl5VzZFBsTsaCmER2+Uo8NSjdtojHq?=
 =?us-ascii?Q?jKkq9XDTq9k3XaU5PBSeS/XfnZXadUYQMWjCr+ZrvDqSRr2PV4sIDQsVC+5w?=
 =?us-ascii?Q?0WpxAie749IWlsVOjUvo1ibzZXs11Dft8+sQ9FweEOTH4rTtqGXarXemddTO?=
 =?us-ascii?Q?MxDVElZGIFTntlhpwCQQHDAkUhrEEGNXyq2DUmf0HaduqrPDT+6Kyw0lhjcj?=
 =?us-ascii?Q?9v1iAQXvUmQYzuNmi5uzD6CoyvrxZwJhUKeCR5a72hcpoIV11lI3hWy8aPYh?=
 =?us-ascii?Q?0bwTZv6Tpg/99DF3WHx5vmNksV/VIOGZqkeJkJI+l+OXiKwAjDzks9/eUMWC?=
 =?us-ascii?Q?VGM54nclMWA49HXabAkXPd7SDNo/auoPmwyXfbfu/3EY08RKBH/gSRBYA2rB?=
 =?us-ascii?Q?R+vN4P/FqC9mEBaRfEdJ65Ai7Tekfg6fAmbCpZtWG8FD3iA7BOy4ffktUsY4?=
 =?us-ascii?Q?wD1P7bdLCMxNnYuP5FRBeVOcHOd3Ma31Y5QK2OgslmIMiHD13InT/V9fGQuj?=
 =?us-ascii?Q?kinhkxm6SXAyuRLh5Er/2N3t16n0FhXMkGJL0bosAdfRqzW9/LBW0y3bk/Na?=
 =?us-ascii?Q?5txyjAc258h0NytBdfe8A+pYjQWWsoiivYU617CNvqx1nXQ0AwLUUB9lYN70?=
 =?us-ascii?Q?3qzJA+XE7FbWYfwAsF2OgNWaZy1+G0AeoojHOPl3BbRCLMJiGORPYw3XhSQF?=
 =?us-ascii?Q?Ve+7vRJZTRsezf6/M65CgWsZrlyslOZ2js/1QyyPrlZMlZ3WmnrUvqQ6ScZ2?=
 =?us-ascii?Q?8fPF+VUHE1qf6xAMQ4azH2fjwaQOWZiYPEOCmMmGvL6raz8/JdPmmsKEx4oh?=
 =?us-ascii?Q?VIxBmbTwDi43Syst+9uqpay2QRWImkWi2Rjkn9sCvep0kVw4/DzlNhd5Lyez?=
 =?us-ascii?Q?TLHdgvDP4VYreUG2LRqRN/IaWD4YtOvHNkA1DSxTH9T3GaeOVeRxtLorlU2t?=
 =?us-ascii?Q?hxOT3DjqS7pXxhEtfxI8wtMFeEz9KPO+8KFOhoEyhA+WtwMxJv8qxMU4dO9r?=
 =?us-ascii?Q?1H3qpBEEjSf3MiJPgwSQanmxT/JNf6utC8OAor5a?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0724a80c-c02f-4654-f48e-08da6ed273ee
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 06:45:39.8116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z7CcddovCXPRMGNytXKWKZEbdlzw313hwONr//3FI/0BRvgAOJu6T1n0zu6SttZ5YSQROkDgv4Rp3hfDybDLiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3247
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

Add the fec support on i.MX8ULP platforms.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
V2 change:
Remove the external clocks which is related to specific board.
V3 change:
No change.
V4 Change:
Add Reviewed-by tag.
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

