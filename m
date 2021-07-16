Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08963CB61B
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 12:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239104AbhGPKcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 06:32:05 -0400
Received: from mail-eopbgr60057.outbound.protection.outlook.com ([40.107.6.57]:36628
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238984AbhGPKb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 06:31:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkWcj/U5QVegByUJ4/fc3r/qh/8shqS0VMQ8PgkGgskWGrU3NboSdNjIQNMSDWCNohLRvy3SMtl4Er3YB/VaY0qW0ZwlIo975o/ulhOTNA8ioORhI5jPahMteOAiQTWk3gjKmdZlmojKOIyNdjIAj6GBU02cJTCVfWY5DeN7pel1+ZwFppRNLlf4ETXrlttTIoJiKRrWV+uNzHg56mDoWunNVV7hKMUCm/CW1BsQNnxpWTDMAIrL0GyMj1T0ubEe5eTJSC6AuXGqrwbKNQC0MO0d3GBeo5QMEe/LP/flAM0g9Am2M+n3DR/JczYc2p26Q5d8utAZveEJ5aVhJxArvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FOFyjdgQdlVGL/juKGTn+jWd99f9j+/KwZCfqk8Y2Y4=;
 b=axBiBUCwBJmh/O4zqGTAEc4Wpj7/iPcOk55856PUPkRmRo5nCOqxeLcr0LXEAzqkVo11yEj+C3NwR1JLRKj/gzUxQky1Zqq6LJuA5jueMueIFq3fotz4F8Wnndxr4KEbhLo6zzLLKt5jq84jJSkJTAyfLDou8o5MbIbXmAG7svhldAgcZQq81qe+IZ2ziVhprSF7dU4VKCtOCyYzcYNxWSNAm1WwSwaemFiAvcuG5fpn0oev5jnhljVW3tLbn64Oyodz8yL+A7140kHPIe3RUU2VRpnRgEh2VfFlZ7CyJngga6bB92DouR1lkW+xvj/ZdXrwzl2xXI1mtLZ4Ks+YkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FOFyjdgQdlVGL/juKGTn+jWd99f9j+/KwZCfqk8Y2Y4=;
 b=rqwFnB/oSOWpXM0ZNNcnOVEjMcyf/jr+VyEsJl3sE9w8u18mgT5Gl2nS4TZYBzZBar0zUC1S1KToarY0zzIn9h35H4oz1OUuob7Sz8D9NEeCzELW3grPCMFWi68PAxgBVLcETh4En3ZjZvT1TKsGfdLIvpHCRZD4/tEp1B8GIXI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2725.eurprd04.prod.outlook.com (2603:10a6:4:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Fri, 16 Jul
 2021 10:29:02 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.021; Fri, 16 Jul 2021
 10:29:02 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, bruno.thomsen@gmail.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH V1 2/3] ARM: dts: imx35: correct node name for FEC
Date:   Fri, 16 Jul 2021 18:29:10 +0800
Message-Id: <20210716102911.23694-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716102911.23694-1-qiangqing.zhang@nxp.com>
References: <20210716102911.23694-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::20)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Fri, 16 Jul 2021 10:28:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0936b60-745e-4de2-be3a-08d9484487f4
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB27258D58B4E18C909F45FC95E6119@DB6PR0402MB2725.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OhGahZ7xQ5JXrZ6YQzMB9eVGMslnOHz9eHMP2ceEULfXahIGGsMrvEXPsGKT1GN379rU9EZV+fq5dpkipoPaHcV8CI0KQbf3NE4zbFGdkWRqJDS/CWsLmrrTZHLXd2ifIH7Fhsza4lhUe81gouUSjlJGL9bRMs3UE+gJfQ0lP7bjFwcUIDWb0QQULLDJTnXSVcU4Jawa1DWIYdyTMX3rQaQAsEd+LXR+pgYigKKQByisBNjZjxeCho42FIbfDhCAbqcVxcqAxInLt8Juhl1IswxZH6Q5jJ5QLF8ktk3S4u2TN7Y8DXLvbYPhGYCHwqK/6EVhsGf0K3t0Vh6kB/jw0myhpTgU9DU1yHpby0fEUNmyUAjNNPk1bIiU1yTbI1Q8/cC9rL44pBPVvCoWeYDFaXguM8jYPJYBdvI7f+Ot+bRwa2QSVXy6VzJNMStWxsBgg6mvCPbSUwwFjz6DdAM+2PlLyzTTkcOKtgbM19CdT7UB0s8bbJsbuJl4+QgInlRpqdIRBa/u6cxIIzMC1jvzjpUSyB5biGXQMl/JArE4bsJurva7bADvx2/bWjBR1wkPxDEoQ6mo+hwna4ZNYQghtB1/S8uLeMuAIIHtJ2dsWrOfhb6vCQ0joEc4/thQ0fJiu6OmSNm4OlnYG51G+WI88g1HVhi4s6C5HfNFVQU72gc18tqoOdR2zvOcmZJvcxxks0gyOmNsmu/UcdeXIZ4ETA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(316002)(83380400001)(478600001)(5660300002)(4744005)(86362001)(66476007)(1076003)(66556008)(52116002)(36756003)(66946007)(2906002)(4326008)(26005)(6506007)(956004)(2616005)(6486002)(8936002)(6666004)(7416002)(186003)(8676002)(38350700002)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2FxEUtn9IdOJ3meqg1YvesfsBK+PCVbjWQXqK85qBMRerUjwGF+ZATVx3103?=
 =?us-ascii?Q?o5dbJBcs4S4Xu/Rw1hbuD8EVsj4Lrts0oPJVmHPfwQl8uZP9dz7r1lawkpy1?=
 =?us-ascii?Q?9DkoF5iT4L+G5Mon5yOiAVNFZe5HlaPIC10ECCxYtaXMTgNUILXvsaO46Mxa?=
 =?us-ascii?Q?yDou7YwpYr1NChWvCnwmnOW9RKg514Baz29yPA5cWf/HADjdYM1WZinXSJp1?=
 =?us-ascii?Q?NWqIrlb9aWPUBV7xq8ZqrSnZPlKN7+1c4tNGD67It1oa+GaUFdMX3j43iEbG?=
 =?us-ascii?Q?UWcd04ceLL6g1hgs/BXeacl+6/ulzaDNrWuH0OiZApV64yBogpS7CNS81la0?=
 =?us-ascii?Q?+R9adMb8jOvfWYWPf367ywrKXGbjdyCp6onp8hxRerAIsqC5ivera8Welj6M?=
 =?us-ascii?Q?kShwKlugl4sfSIHhq5d9ItJcjR61G1AazZEz2JHfJbj43YpuEvcr1CEu9Sbt?=
 =?us-ascii?Q?459UuxYI5/TmUSoHXfyQpn3iXhhzI0ngt7EcHux3Xm4DHsySKY2FCpqx3H3D?=
 =?us-ascii?Q?sGxXGkHYvvjRkO8OHAGKK/ExzGMhf11TvEJ1DcCC3ySCR+/oeDHllVea8/2U?=
 =?us-ascii?Q?bWHNM7lfGq7xkdqP+dlcliCxkH9ilWJ/tBQt4xRtEUKmk5lUDjXJC9l44GeG?=
 =?us-ascii?Q?2W6wqd+i0cvcqFq51S2numl7WdHsgHV2qztkwz28q9n2P2dU7WFRVLidkEG3?=
 =?us-ascii?Q?ZvAnodxrUSN1mISaTby3ADWfI+3y++UQaes4GPT4BpMjRobSp3Ph4Kp8Gd8p?=
 =?us-ascii?Q?c+/X6Bki2PVD6kPA+wky7Qy4cdPBUb5+9WZ7ZLDQs9jcSJ3UBpIil+e9uMdl?=
 =?us-ascii?Q?W90ASUnlR1DRupZCBn5CVgfnURlmW+y3CZ7cNfUC8xOy92TI9kiLXpHlLE2y?=
 =?us-ascii?Q?1jsqKg+tNL9MlrqDiU2rMNQ9CKV0HAqKTEItQqTG3BsCHjkvY1Cm5wZsJ8IB?=
 =?us-ascii?Q?oo1gKaAxLeMxPN6pfb3e0EczEzb5AzjC9cw5QJeYulNf0TmTNy7YcN1NK4yf?=
 =?us-ascii?Q?gkMYGpZE/1STN4vhEobIB4Kb1BL3YqhHxuoduadiMCG+thSmcAX4BvrFuBiE?=
 =?us-ascii?Q?3GIeoRj5YfN4dX9vJr0tGszQUUAT2HgFhTwTTDZq0/jJBMF1s3ctugdkt8qI?=
 =?us-ascii?Q?7mAJPK+Vqe0OWmvpGs/hMdheLYsFIZXeCrOpwXvmk0U1fQeWJXwIe9PxUglL?=
 =?us-ascii?Q?Zb6HsvydzC6pey8MD32w9x0bnqhJsC2AO1bOJhz6BLYhGfOr7snRP2AiAgig?=
 =?us-ascii?Q?0pOc+XbGfL+h8C5WXmbHISoTr//XuuVAJX/dMGmVDiGgS9LEMPhN55yRqqzB?=
 =?us-ascii?Q?pi6s+4AnWM+MXzUcdm7BO8Wj?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0936b60-745e-4de2-be3a-08d9484487f4
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 10:29:02.8273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n/OOSeDCa3BrzfgTZIpmd2lza9+OF3eiEBORWiw2WvQTDYxPK+LMJ5S5/h5YqPpGXssMpjAh5PAN898Ky0gndw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct node name for FEC which found when do dtbs_check.

$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- dtbs_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/fsl,fec.yaml
arch/arm/boot/dts/imx35-eukrea-mbimxsd35-baseboard.dt.yaml: fec@50038000: $nodename:0: 'fec@50038000' does not match '^ethernet(@.*)?$'
arch/arm/boot/dts/imx35-pdk.dt.yaml: fec@50038000: $nodename:0: 'fec@50038000' does not match '^ethernet(@.*)?$'

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 arch/arm/boot/dts/imx35.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx35.dtsi b/arch/arm/boot/dts/imx35.dtsi
index 98ccc81ca6d9..8e41c8b7bd70 100644
--- a/arch/arm/boot/dts/imx35.dtsi
+++ b/arch/arm/boot/dts/imx35.dtsi
@@ -189,7 +189,7 @@
 				status = "disabled";
 			};
 
-			fec: fec@50038000 {
+			fec: ethernet@50038000 {
 				compatible = "fsl,imx35-fec", "fsl,imx27-fec";
 				reg = <0x50038000 0x4000>;
 				clocks = <&clks 46>, <&clks 8>;
-- 
2.17.1

