Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAAC3D8D29
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 13:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhG1Lwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 07:52:30 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:39300
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236243AbhG1LwU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 07:52:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PB3rFHiqLlUqUTfK20+FyVWTWqoEOhwMAtAVXZEEoVvEzkn7FwKZGUQZjlmgpfs+YWT1AU73AjLZh9aAob251iqmYA4h4dAxMEXuC5BL/fPooiwIWvpVP113st06RUGPwshg5IHqI3qnumx4vcoEY18jY7CBM1YNPAaR0juWsXTiFPLrDlbOcu+M/WOy4MtPx5K65GHd70JlFUpI85Py1m7QG0objivhWGAQGXzwJDe7OBy0pvKiGNLr3iPvOXhdwHP+Vdw1M0muRY17q9JbR31Q/g1hB5F6ZnN7r7aOLXB9LXVxQdVOB7DLSjRHNIO+9uSjPEz2YeW5TRdhGJ1fbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lf/R8x7hzkSkb2oRvbe63Uq04r7VJEZvqwt3AxH4ECc=;
 b=h0uICqIQ5A2ClA8H4QtTkKhcZWdTaPPzv3HMF8F3SKF6hv0gjHmTNULMr7ZW3VbGRQqMeX4Ts0UwpPzpEqM+DUu5RyP0XxrPquVN39Ou3eXTyxVh55IVugZ2twTVELmLMp6LUEzYR5S2hSUjc8POFftf+kqk1FmkNB7hmvxLtVkg5tD8dAr+XfrFsAEKWk2wEoKF945BacaYDzmNTRWfsvH4PZAQucd44JL+HDGrIjBhzirMX4U8S17FtzR6vcTBeHtlSwBTQIcen7IKtsNQHOPGe9d7n3eInXBTXCS+uHic49OsINMZEcKU6PoTttZtDIDXNeNgiV3A/knG0smlKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lf/R8x7hzkSkb2oRvbe63Uq04r7VJEZvqwt3AxH4ECc=;
 b=luY1qUz6LH6bqJcWQuTC164g6li6X5xn/zSEBqBihndJcDkUOf0opF4GVGioRe6ltSY3hnN4cvQzfoiUyC2A6tvj2CDRQlWTyVNJ2nP2WGy19n7ub8tvIGtgO4qAl7uPz9Vrx5uQ5KwSxbbpL0oOVFv7nLAGAWUpIBWPfg8tgZU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7900.eurprd04.prod.outlook.com (2603:10a6:10:1e8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Wed, 28 Jul
 2021 11:52:16 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4352.032; Wed, 28 Jul 2021
 11:52:16 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 6/7] arm64: dts: imx8m: add "fsl,imx8mq-fec" compatible string for FEC
Date:   Wed, 28 Jul 2021 19:52:02 +0800
Message-Id: <20210728115203.16263-7-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
References: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 11:52:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 567e960d-f05b-48b4-e26e-08d951be2529
X-MS-TrafficTypeDiagnostic: DBBPR04MB7900:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB7900E9B7C6D3728AF2735F18E6EA9@DBBPR04MB7900.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S9utuweMHGCKc8vR6isFS6STLkuxtG7EXuBUVBkmHZ8lwF7Syw2hwXasneGzGebwDKXmhnU0molM8GMw31UC7NczFtatN1E50qq27f2eNbz22wWiI8DChXfcIVw00Ssp8qhmS0nUpdOkI650z0ogwTRpZZgst3Oxr4FSLvBg+PL+aXMNUq3utZbGZOQOeHks/mKFxgrgcDAxDyRhs9ocMkw7dY5Q3LeEeQ1W1nxhjKo+VYX1WKCVm0PKHer69rTXNBY2ztCTowd9hDtQNMejsLW9RA8OnXMev2xdTMv5mvGgDG3Arep53AZOCSijf1qFvitpjjhuNNc7CfWrYq9Zh6eZeqeXbezWdts8FuioaOr/J6WXJNtqk+OW2DxJhaouiYBmHdSPIdT1OLO74XdUGFFhE6ZXvqLI8Obssp4rB7AIuHT+8JWt7bIWVXkjRpddZ0kZDzIrxJaWAvO3SuZ/w0X2ddzBrtV/IO6mImvWKgWHEF5FL2Xwwud9cc8GJHYqJITt6BTn5ob/yX8ZHsS4tK6w6LdgWtigcf21jtl3/YGoIz39Ure2A8NrbIOOMTanW3DYAyuPRvC32ZYUTneGCnL5wydcJ1f0A1x7t5UDW6QZH0yQe69MB4nIrrPkrzHipV1UZUJ/1AjDleWrSJzvHmGA0D/VMtGbZEhn1dSLezMp+sNFMrVU8Cbtw45RTFCd+aupSVC6iBtyifovri4CLB+xM/wz7x4HaIdeDSlP8hk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39840400004)(366004)(376002)(346002)(52116002)(1076003)(8936002)(26005)(956004)(38100700002)(2616005)(7416002)(38350700002)(478600001)(6512007)(6486002)(316002)(2906002)(66556008)(86362001)(186003)(66946007)(6666004)(66476007)(6506007)(4326008)(5660300002)(36756003)(83380400001)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b8Q2cubSFGo0lG1SE/ovEbKmqrmX/H6lfzdKxS8FKog49CyvnyQGJkvjF+34?=
 =?us-ascii?Q?bCmIkuFWlO8+Gu3cM8FKAJd87kwBDzes9niC8OCzAatAyJOIIigNdGPm2qrw?=
 =?us-ascii?Q?1PcmEs/e5ngJlbmJWafTS+YqXGki1e9ZCiCYi98Gwi0Bpbdu7jFO+D+XtNbp?=
 =?us-ascii?Q?MkH+ECYjxi+2ojsBJHawdE2pHkAw7Fe9EWJulWFOQ5s//2ddpJhfAx9iIkyH?=
 =?us-ascii?Q?/6AeIROxxi28gancTlax5n52F8wDAFWSqS2SMk8CgkaYWWVfuOj9YxDo8hoa?=
 =?us-ascii?Q?+f65RScQ54wAhiMi2UMhtL1uJ6WWeZZkc4/y/LAxi4ZWilufdtwX1t+EyLlc?=
 =?us-ascii?Q?n2CJqjyT7GbA76Fghu5Pbyx+pmcqzaUuivc2wgr4xQCE2LhzpjKty14HkYQJ?=
 =?us-ascii?Q?ow8aua7C5To8noP2HSmFjUedyjdb9MLbUClzohjV20kaHf2nyMW0AHLImPwb?=
 =?us-ascii?Q?FfkenPzVEF0Qwaa+3Y6FUy78s7mjlATZHQzOLik9ddYJBHtaTjJ49cQhQ6Lz?=
 =?us-ascii?Q?zvu+cH/WWbvf4Q/XaQ5hlOdftw4xM1zKFzy1PlrLj4tn4FEcOR8WY34M19Vg?=
 =?us-ascii?Q?cQ3y1ktGwYaZXTdbuXQjAai3tXUG6U5GQn/rQJi9/YLcoT1f2RrX7o5ZF01J?=
 =?us-ascii?Q?6EWD5xAlunMnVfHILhE5bITKc47BV4EhC1kf8yJ3yWR44KvbiUi0LX58y/bk?=
 =?us-ascii?Q?Q1fk8duD1lj1n+bfBlSy2z8EZnWdpt5IuWntZ4W1O22vNS+okiB+1dbcy77z?=
 =?us-ascii?Q?BpIF6zZH37HxPMDLiugifpaX7inKrOw1RRoxI/6TXWNA0/vpXV3MANMWACtc?=
 =?us-ascii?Q?fpK0VLrGk2kUQ+jfRc8N9FvP+dcD+ghMLxXger6FLjEdHG10Z6vJiC6JaKxh?=
 =?us-ascii?Q?cdHib09VCPAXW1h3KwSkNByqIfdgmAmBVxmx+6WBF94YDOXlZZRzoscKkZQ1?=
 =?us-ascii?Q?nFf7BCgsRCsN37Eb2hDQE/Yrr7TqKK+jQJnIf9+LcVy0bh3+aqgnffon0kMd?=
 =?us-ascii?Q?DNarl4kryI5HDe8ZvNlmWLkkCFMLQpila1BTsHXVxK8zlUe1nNS9+PAzxyLj?=
 =?us-ascii?Q?H9jQqJqip/6/qwHWHV3DRv0hr5dLl8BkS4fqQoiYl0YSsM3kbLVvx+sF79aN?=
 =?us-ascii?Q?HxcguKap91EPcFYocjvxeGhsxZLzOxmLfkEMUrq18G9rKHyTOYQt1vB8ByQE?=
 =?us-ascii?Q?+CXWR3HB/Vz/DAXf8zE+3gEZ+c0aYRSXQYtQabbvNSdNtZ6hQ8fO6aQc0Kxg?=
 =?us-ascii?Q?IvXGFb//u2DqEJLMecC3Jai9vC17jXhP9FZLLv0SHvpDUfImdIAdAWsGKbcg?=
 =?us-ascii?Q?gOL1TfuXpXtbqRQDGtDuv9XK?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 567e960d-f05b-48b4-e26e-08d951be2529
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 11:52:16.0556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h/lbBftfnN53BIgtVAwDLCIgsVfQF4fUhY7vhYQk5eL3dnc5H69fV01F6/+ZtptDdEydCG/f/Zj0bPEUKhDyXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7900
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add "fsl,imx8mq-fec" compatible string for FEC to support new feature
(IEEE 802.3az EEE standard).

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi | 2 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index e7648c3b8390..1608a48495b6 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -920,7 +920,7 @@
 			};
 
 			fec1: ethernet@30be0000 {
-				compatible = "fsl,imx8mm-fec", "fsl,imx6sx-fec";
+				compatible = "fsl,imx8mm-fec", "fsl,imx8mq-fec", "fsl,imx6sx-fec";
 				reg = <0x30be0000 0x10000>;
 				interrupts = <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index d4231e061403..e6de293865b0 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -923,7 +923,7 @@
 			};
 
 			fec1: ethernet@30be0000 {
-				compatible = "fsl,imx8mn-fec", "fsl,imx6sx-fec";
+				compatible = "fsl,imx8mn-fec", "fsl,imx8mq-fec", "fsl,imx6sx-fec";
 				reg = <0x30be0000 0x10000>;
 				interrupts = <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.17.1

