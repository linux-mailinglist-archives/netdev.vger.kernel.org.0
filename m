Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6341A41C3D4
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245285AbhI2LyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:54:25 -0400
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:57982
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244263AbhI2LyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 07:54:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OuCTGc1HOFF7BXGZOsrxk1gBu2W0Nb8RlzK4CgzFuN6glB3vCvIcsJnxEkd10DMY4DoL5/ziCj2rG7KJLedi6LdPLdxxOO/MKl70+zIjPAtPtdDJfdfNW8JKUQJMaQahlB5tjHnLD3/k2TFX9n6v5wTFg3suMkdBAkoShrhg27D0gsAsRgXD2XXrB0RB6JhP/ByCtb6Es6B/UTDNwWN0F4uREwy894oshGJ+vp5q3tkh9FFkyQbH0KALEivwBM1bTn2WGV5SrvEiSISrpTcZeOVYSfcE1hPuz8OTmlENj4N304kbui957gbNfjqTUw1jNDAHUBda/X3qv3V8ZucKrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=M9egcrLYnpF7pbDtUq5vY4F4SdyGMeUekO2F4Le1vHY=;
 b=dgKCNX0wwxTISv79eW1rdFBCOiVa01J7SHN4CIGn1NElbwwRv9cK62vmBgryUoOVew5tftwumRFeEkqaAiCdenGQMOqRqgkYZDG3GO3mpHkvZ0NpjA03YwBya2emGYUmjkOvvPP4A3I8urLaxabG1z7rclModZULqBlrLGQc7zVaABtXxcE3J3BfDaaY7eCe+ZdcDBJnXpnpd9/Tg7evweQl+8YpAHhk+b6aRc3ceGfOqDoooboHUQTWPJk/CmGAkmX+KFXpo6MOjWl4SDCKWvfDHbdCYwzstOVzsm2YQ9HywHc+8W1fo3iiR/IfrZcFql9/7yJcD5Xa5URFifZ2Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9egcrLYnpF7pbDtUq5vY4F4SdyGMeUekO2F4Le1vHY=;
 b=prnEB/yvHg7veQ6xfrUhRkxMjeZ/BQYKvlIdxSraGO1WPNYQktntYYbgXY4f6LWEcV+4MFvyuW5tNjN+cZPpbLsxnQkDc4QiJjlZ6vSEdR0DOh0WAzWquKZDGf3Xp9jKjv9buy1I9mVp1Xyrjs4Ic0Vmg4Vn7io9SYfarg0La88=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4221.eurprd04.prod.outlook.com (2603:10a6:803:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 11:52:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 11:52:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>
Subject: [PATCH devicetree] arm64: dts: ls1028a: mark internal links between Felix and ENETC as capable of flow control
Date:   Wed, 29 Sep 2021 14:52:26 +0300
Message-Id: <20210929115226.1383925-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0012.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM9P250CA0012.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 11:52:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45f5f8b7-7d98-45b4-5b63-08d9833fa368
X-MS-TrafficTypeDiagnostic: VI1PR04MB4221:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB42212350EA660A5240C81724E0A99@VI1PR04MB4221.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rTxcmmGJKNZJ18prMcOzXAUYktkt8Mc/sAmNEtBRLEN+dMA9KIuICJDulT0Gq47VqkC/aUqc6mbV3dUqO0i6x6T4CmsD+DVlPOYMqhP/El5LWVqTfXQ4aX/IMPDfoyHq28Y4OTxQGDRQLB9R06u/IqcF34GRA0amffXpKAfwSoIqC7/MnMnIKjXqALWX8XZZkkF03j8EVXeSuddEZMb0tEojdYOI+aSBxiSKHf7EqosERHfXumEuABFDh0efALJNlGaVGrCuBKyBvgaN8jVVxWq0Q7rLStTFuFjEJiGwBq73Y3txXame7NXl2SIPzlk+OT7MSgVZWTqjVPjr95TvW40yZ6LVWuL1w9fH3b50q47X0mqVyP8PU6J1+dpaIHBsX9KfsAv8FA4v7ehVxMsTFyCae0GDC/nIQAz2zMCj6BX97Ro6czHlZFjtLV0Evsfg98ocew5AnlmcLdcgf7NkMMlzsRFtG8wCxRiBnJBo8fhQOsyHEcTlTfsagAzcTSyQ9XctO5MxXrj7lL2B9UYdye3v1d6RGR9usEE6gikw4+2suhts27fc4cgY2gbLP1rKGOqvBy2dH8WMb2zTMke/1NCVvQzrJ9seXzthGiCrovbTbYOs32HofUFyVXFswEoc3v/FSGT1pEbAJN+oYX8ocNQMyatUYTbL886oo7L2oyfxZtt4M/Ibkzd2igSEtgi2+1+XBoHvYE7lDTCuDmAKGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6512007)(5660300002)(6506007)(44832011)(4326008)(6666004)(38100700002)(38350700002)(186003)(66946007)(2906002)(8676002)(2616005)(66476007)(66556008)(956004)(316002)(54906003)(1076003)(86362001)(508600001)(26005)(6486002)(8936002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X8qnMfuNXOn4bL/gM5HNz1d0+fqi2Kn+5y3krA7XYYkF1IpEUL0NFmVPVXat?=
 =?us-ascii?Q?n0oNPu+v0pc2cgBRrysxuIAWDPTSsGhbe7ljDO8kl46zayt64Ddhxo6Sc9cx?=
 =?us-ascii?Q?THsHfZlFs/ZWKB6aCWYZyxuTOSyBTef5glIrCd7fhZwWJIFGD4tUMs8KHpwB?=
 =?us-ascii?Q?IEXImEDnY5pIs888YPd3A43n+ZtTOPOMzNL5jbotPaiDkp+SGaO2/Wi0PqoJ?=
 =?us-ascii?Q?eR81sWmV9SHUDejYuWU2z+TBL0fgoGQxJzODITJSPY3sFdDAGrTvjLPekOQ5?=
 =?us-ascii?Q?6QUVDkh1c3lU/hiM8nv5giODsD6qbez1CjbvmsD3OZvkBJ6wjDiOrrxR6ao6?=
 =?us-ascii?Q?nRZkH3S4+2NopoSGeLP90xsfuhIaNLjqjxjD9SNfb6tMsLa55QTref0hZ8kr?=
 =?us-ascii?Q?kdjfzGA0L0pe7XrSQBym8e824mGr2KXqAQASLWAc5m/uiCWSiUg3ZR8ohAN3?=
 =?us-ascii?Q?4jO9mscIoXSzN0vVHWX6KzYV6hLjqfZvVlkUtaCAs1B6RBBn3czSTgcu9a/Y?=
 =?us-ascii?Q?ea2X5zNlxGEW/d2jzKXYTcTPijOT8X7mAoDxahJ8V9pQKXKDcSZmRVu8srNw?=
 =?us-ascii?Q?qIP+oWy1KngXWDjSvT5ZCJxaHxSL+iv+pKNx/7p9bDJ9RhvDnLOAjeHcuNce?=
 =?us-ascii?Q?tzza3h84qbjBXES8vwSMbHglvPRr2HwESTbpKteKYDkETY/TTpNy5SEYoJhp?=
 =?us-ascii?Q?IfH81GAFnf/EQuxrnoa8dh/XFMWK+oomowDPqr6vlwtixVGGzJX7Yhqtjczn?=
 =?us-ascii?Q?Ep7i2CRC0cW7eYaKQGCrrPyoWGUUYS6BnCvXUkJJ1WG7BxuKRQsKdOD65B6O?=
 =?us-ascii?Q?VL0h9TwOm0p9n4Dj2qc3W5BnkXdy4e/eWWXiZBNxklbSB1jOBpGYO662HrjR?=
 =?us-ascii?Q?EEIT16hCDgfmSaQF/279nxImvnWkGVkImTgmxlYTTGXMZkJJr7HGynbf/YBB?=
 =?us-ascii?Q?jp/e6YaGTWShTjloyN9v6N+yez3sdOak9jY4KSn79ULiG4xw89JTKuFWTAfU?=
 =?us-ascii?Q?mDQf1YmyXnP/e7wfsmbV7yubLb3MEeP5KZfCjz5pshTpNwEIvMONdHS7ULmz?=
 =?us-ascii?Q?A1vvZWO7NcBQfv3LLLqlIFDSHctNYtB8I3tOvNKcW7x/FejoCCAo8QESKWbR?=
 =?us-ascii?Q?prcxiRbLgpzF3tKgPr0toTaA6xepU1uXIGLqfpHCDuoKWFgd5DXVZaG9h3Oo?=
 =?us-ascii?Q?5sCB3K2I1sm5qnveKw6yqUo8WommmTqPwSMvomo2U4VwngdbTdaA+CU3gLM+?=
 =?us-ascii?Q?O88hdgbX4EK0FtSvvPN4kUBGyhpgnj0k6QHB8afXFj+0/lr5fPV7FBXJu5yg?=
 =?us-ascii?Q?GP5nmF00VsoqCqL/nrVLMbWl?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f5f8b7-7d98-45b4-5b63-08d9833fa368
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 11:52:39.9098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgC+fQHKPOsnj1yJOAyI4XWVx4hZDIDKclpsjrRInhROPVcCVQ1PpBGPedzVhHzZdRe3wMKWL55bBjV7f11hew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4221
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The internal Ethernet switch suffers from erratum A-050484 ("Ethernet
flow control not functional on L2 switch NPI port when XFH is used").
XFH stands for "Extraction Frame Header" - which basically means the
default "ocelot" DSA tagging protocol.

However, the switch supports one other tagging protocol - "ocelot-8021q",
and this is not subject to the erratum above. So describe the hardware
ability to pass PAUSE frames in the device tree, and let the driver
figure out whether it should use flow control on the CPU port or not,
depending on whether the "ocelot" or "ocelot-8021q" tagging protocol is
being used.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 343ecf0e8973..71e5cdd931ee 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -1025,6 +1025,7 @@ enetc_port2: ethernet@0,2 {
 				fixed-link {
 					speed = <2500>;
 					full-duplex;
+					pause;
 				};
 			};
 
@@ -1083,6 +1084,7 @@ mscc_felix_port4: port@4 {
 						fixed-link {
 							speed = <2500>;
 							full-duplex;
+							pause;
 						};
 					};
 
@@ -1094,6 +1096,7 @@ mscc_felix_port5: port@5 {
 						fixed-link {
 							speed = <1000>;
 							full-duplex;
+							pause;
 						};
 					};
 				};
@@ -1108,6 +1111,7 @@ enetc_port3: ethernet@0,6 {
 				fixed-link {
 					speed = <1000>;
 					full-duplex;
+					pause;
 				};
 			};
 
-- 
2.25.1

