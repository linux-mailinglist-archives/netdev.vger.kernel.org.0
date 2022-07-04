Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFED564B90
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 04:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiGDCPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 22:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGDCPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 22:15:53 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80070.outbound.protection.outlook.com [40.107.8.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E0262F8;
        Sun,  3 Jul 2022 19:15:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4BA+nrcKCMKh1ib1by76p5E4y8pOhGj3JJxVuh2d+G+Ic8R/NkQdu19ceZtNLfRcez36UNNSgB7xjryXAfqz6c5Oy5BdflooB2wXGYGBkTqpYfqG65qZGyzARy2K0V4HnzsBFW0HyECHoG28rwieEWlBu1875oujNK8InOTtk8yOYsR3X9CRArS/bYN5TRz8uXDMhJI4fNTSsKle8ihSnSiDoSktFsNwcUAESvWEbpQuKtCBnip+rD+RbH734zbkPPkooS6KO+PPTaMSVlyYiBg2ml6D7Z+r5zxQFZjdanmOi2bd1qZXBhlTIy1BHluBX6QAkDNOCI2eeYTQtoYKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPMxwmbq0s7FNoq/KTQ+taIq+t3ms0p/fVbSqVr97yk=;
 b=hlZLXipgTguNfh/DZ3TVhRXKo15yS1vNSXMoFYNRcRQShgzI4gQ5osU9R78cLpVU5oDhlXR0rsm8rXU/iWiJfdStmGrmKUrgLTfbqxo36CPpfyTYss9QIzASbMyxi9ivGEsOTjwNiHCg26O+ZS88g/Mfs6X4FW1WmFwMFX9bNmLLFZlp06d1bwMyktRztkaSSxoUpIUgTSTibE9qZ3D/MK2zVHCDZoPWzzo6yCe1BjijzFXvodP+v/1CH5LitkblmwIxpm9dsI87lcqTn5xMJCYlUvNoNqC+lhgH58aX7pMpmXwfLYYwMqnjbBK8gjWksjhpxhfCNq+JyxtreIkvRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPMxwmbq0s7FNoq/KTQ+taIq+t3ms0p/fVbSqVr97yk=;
 b=mFcIwQW6ju+w+wN4aHZtU0R75exlVWl9xjkVBDZWM4b/r3chBDhTgYbsl9zU2xMm3r+LnBsMxgbjxE6JTB08mozKaIKN+CHDEn8vQxIzZOBpsRSr7Z8H6aqJ/LbZY0mKvU0296Af6I+Ea/RB6Z1Tdqe7hKg13tL9WBtIuln2w9U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AM0PR04MB6819.eurprd04.prod.outlook.com (2603:10a6:208:17f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Mon, 4 Jul
 2022 02:15:50 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654%8]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 02:15:50 +0000
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
Subject: [PATCH 2/3] arm64: dts: imx8ulp: Add the fec support
Date:   Mon,  4 Jul 2022 20:10:55 +1000
Message-Id: <20220704101056.24821-3-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220704101056.24821-1-wei.fang@nxp.com>
References: <20220704101056.24821-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0155.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::35) To AM9PR04MB9003.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9d4a125-c935-4cc7-e7a4-08da5d631d79
X-MS-TrafficTypeDiagnostic: AM0PR04MB6819:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qjW8mz5pWwwLwF4sJXVx0NvEIt4g9Rt5wbe9J9iu6XTYeXgMFiP1HzRf3tgnTcoZGtuxdCvvNxzTvPDsRerTc27PaBLoAoOXj8Na/ERlfbg8MtAyN8qPoVBSYIudLb2Zq5S/BZfSDiAi5L0uZyinsNF+PW9+X4nZD64DLzCMlia2e+BvE+VWG3tsD2d4pcsj4jDoz/xYqRJi9lHYkVIDFXVZvELcwr7JSE3C4ikR5aku9yLMb/Yv1vgJnUgIGpUlEobrUrJsuZYIx13ud0Eu2PycWylZ9tk2qsEcLJVo4bplHgpTMd1LI8TJ/Q/FH2zAFzoNleTDDq7egPDLe7rCiJsN7LylFfoy16wJ0yDjd+fbV1RrdYgL5WnXXAgdNPvcSJp4wUB/dsehRC2mNTcdacfPBuafEs0JyPVCNN6kt5M49XY96FAYnZo23C0u9K7DsGaFQ64bbwef2pp4kAKZH5GORGsxPbD20iGV/krpwfuuYASXFFZuC1GjSurDXHCyxuYLkNbHTzjk07yUHkm6ILO9EZPeGJVmjrJG93y50FKDzg53F1vEvbDtSTnmdX3+4dO6809XugQSKBiuYX4IJKP/NOCXVDXUB7MofA1nzmEJ+N+SCH1zcGbmzUYYMojzR12O08FABtxV5UZ0RoLXOMPd4HMcJDg04euADezNxcgG69d5DSR3SCM186MuqkCFLyV5SN9Gsj58E5AiJC6AlNKlgLQ7/Jp0QhEi4RWrYA1+tpNoAuMT8zZMQO679Jjsq9UA1Pi2SHMfirbgFyUKCZyiwIKuO49BxG33NQWmdRYj3nTGZQDEUDuRYpAvqQU564LXBukhROLsAvRC2bL3hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(6486002)(478600001)(6512007)(44832011)(2906002)(66476007)(52116002)(26005)(66946007)(316002)(6506007)(5660300002)(66556008)(7416002)(36756003)(86362001)(8936002)(2616005)(8676002)(4326008)(1076003)(186003)(83380400001)(38350700002)(38100700002)(41300700001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?elIMBGFuXGpkVsaYdorACJ7RYQne79sEjh2CJEq/9yJHoEpNRVzWWrHPPXtu?=
 =?us-ascii?Q?q9RdPZKgjb2+zrQgjfHii9cEbERF8OWd9sKcJ7ptCe5tFafct5KdEAL28Nkd?=
 =?us-ascii?Q?JTb7EAf+k1PS9BGwf47IudkQOMkTp2j9HzFQzLW9M7Gg8mh/1mK87cbBUzV4?=
 =?us-ascii?Q?DeB6PaUPGJ3vZAfqlFZXB9GqtQ3xB+5Ji3fwAIWnpFJJ1Bf8d6bvylKhZrbS?=
 =?us-ascii?Q?TfTBkKlfLgmZZGoWP+ZlBVePlIxOk3AsGf3H059t1SM6nzQWOV4GWCtPAWLW?=
 =?us-ascii?Q?buNM1v5HHe6jCE23q9lYN/O9lG7ISP/Cj7csCpX/TAoEsJHPZUKNFiysdKML?=
 =?us-ascii?Q?LKJhhTdF+Iw7I24jh5PX+iY9DsQkfW8fMsKlC/WNJ+6hDtZMdTXazre35trq?=
 =?us-ascii?Q?LI5g1mS6OSLnIuSTY4m+YMVG27b7pJDNlYN403jkyyzkATuhXl9zcC6J1Wcb?=
 =?us-ascii?Q?wdwc8TyvU+cIP+ZRWfHIlsgAn5rGnMJ5Mhvgg0GAJNF4mBCmZJFd/cTLpBqi?=
 =?us-ascii?Q?hgrve7/6gzdeGfotf69wIR0a38VgRMN2Ibr/VyvAO0cPlZBwX96WptjkyTL4?=
 =?us-ascii?Q?wrSSbMJNx6ZpiHGorjze4b0Q9iKMQOafOsOpKusnDV0kYv8Kz0100CTI/ovc?=
 =?us-ascii?Q?i7me592j+LOSiIoyG5EQsXFBLkqQnh/cRqtZaDdSF1BMgtca3nIxwK6lNJsg?=
 =?us-ascii?Q?tGh0Rkjxnx2qSuFbV1E6sy+kcfsEoJJ6gPh67XyUW/ZJ1FTJjDw3EuipgMx7?=
 =?us-ascii?Q?L6xbNk0l7gtmqEOB7Ep9UJ1BaouKsR+kubWZNE8bZsw28TnY5oQ9xfSJNY8x?=
 =?us-ascii?Q?N/CjINGcdcFKJapEvS6lrS5MwLH2X0uJ/KMl13Z9RfBFgof0pQvyN1SCcc1D?=
 =?us-ascii?Q?knfQLn1YLhpjhpbo+I6zjo3xprqXoWWCXyMAsk8Fxm4RYacXkPl/wZOxZ2ZD?=
 =?us-ascii?Q?CygwcTsZ0dvqfMiwszYlNOt1WhFT7jSstisN28Hw4jiW1BBKjc6nNdm0fMR2?=
 =?us-ascii?Q?mHOMEItkSfgTkuXwLzCrp/8aJTAUx4Vg3hLIjihonab0kNG3iY/83ukdhu7g?=
 =?us-ascii?Q?0ExXIPLqrAPPOQCjklEw2nGyPm/YutqQszb6gIR9ajKOSeRHx/lxPQ5pEHBT?=
 =?us-ascii?Q?dH99r3wOjiQHSi47oZ+ZgwohP2GQ27wUAMNbZ2fM2UitMv0+XmPD9daDYSSn?=
 =?us-ascii?Q?IfQpHLVGU8t3WIvR7EY2SYhQVQCMBHJbSW3SgGf5vkQnerAs426TB90D4Hlm?=
 =?us-ascii?Q?f/DnA/MWXMFojnqx2+I/iZYOZacSdf0ElsqMW6u5NOPIh0LbpwcxVbcZTQsH?=
 =?us-ascii?Q?zzbpDaCH/ZQc8GPHbhDeaiL4Gyt3HosPpM033clVZCy44y/OyVCUOfho5uD/?=
 =?us-ascii?Q?0Ov/jm2Y/1Nb/LNyc+wDdhzpxfP25F2nDtvJ2vhTJoQEVXwaaLIBF4AMUx2o?=
 =?us-ascii?Q?7v9MMKEkTYHreDytiKqb52XJZwh3kf/cAx19cVM3CkPlMiG71HbqYBaKprM1?=
 =?us-ascii?Q?me/I7vlQMlPdtWeEtqOxqok8KqILHzgNWIrdb17HifWT+ssrzZ7ynq0pI8Jq?=
 =?us-ascii?Q?2GHzMYXr7iaXLlHpi/H95xBv10aI4PiGFqBZFrv9?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d4a125-c935-4cc7-e7a4-08da5d631d79
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 02:15:50.6363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e3YcG7yGPhoH6/t6O0IHJpWqZlSB+m8P2q+36YBRxMgegotO1qA9mXbnmA/W7KB5YzGhxnhqQeUsM8DjQx0ofQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6819
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
 arch/arm64/boot/dts/freescale/imx8ulp.dtsi | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
index 60c1b018bf03..822f3aea46e1 100644
--- a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
@@ -16,6 +16,7 @@ / {
 	#size-cells = <2>;
 
 	aliases {
+		ethernet0 = &fec;
 		gpio0 = &gpiod;
 		gpio1 = &gpioe;
 		gpio2 = &gpiof;
@@ -137,6 +138,19 @@ scmi_sensor: protocol@15 {
 		};
 	};
 
+	clock_ext_rmii: clock-ext-rmii {
+		compatible = "fixed-clock";
+		clock-frequency = <50000000>;
+		#clock-cells = <0>;
+		clock-output-names = "ext_rmii_clk";
+	};
+
+	clock_ext_ts: clock-ext-ts {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-output-names = "ext_ts_clk";
+	};
+
 	soc: soc@0 {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -365,6 +379,21 @@ usdhc2: mmc@298f0000 {
 				bus-width = <4>;
 				status = "disabled";
 			};
+
+			fec: ethernet@29950000 {
+				compatible = "fsl,imx8ulp-fec", "fsl,imx6ul-fec";
+				reg = <0x29950000 0x10000>;
+				interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "int0";
+				clocks = <&cgc1 IMX8ULP_CLK_XBAR_DIVBUS>,
+					 <&pcc4 IMX8ULP_CLK_ENET>,
+					 <&cgc1 IMX8ULP_CLK_ENET_TS_SEL>,
+					 <&clock_ext_rmii>;
+				clock-names = "ipg", "ahb", "ptp", "enet_clk_ref";
+				fsl,num-tx-queues = <1>;
+				fsl,num-rx-queues = <1>;
+				status = "disabled";
+			};
 		};
 
 		gpioe: gpio@2d000080 {
-- 
2.25.1

