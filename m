Return-Path: <netdev+bounces-11970-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08A5C735891
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A66632810BA
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC2411181;
	Mon, 19 Jun 2023 13:30:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774E7AD3C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 13:30:18 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2089.outbound.protection.outlook.com [40.107.105.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE7A101;
	Mon, 19 Jun 2023 06:30:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTBkfBNizI+cn4lKauu03NceYxqCL64xh9vJ7lnA1li2OYmaPGmcaH2QxsGlT6vgRg9pLqdL8BO+7cjGMC1u5jnxi2W1w8ZFilsEkdjF/nPLFskYoAA4PKnFhWbujJJ36V6IbxLKLHGoQvmD8ls77zA8VUfez/6LESXmjafSntEx8W/7l4Jbyszs7Xxe3ev2Wio0CjxYE7tHyyPw9MZaWBg/R+TyPwjtbJhgAPesrSDdXTSfPRwSmhGfr2iTffE0+Nv6pLcsxM5xEOAOvKptkDvPsHFA9XAZj15l1e9R/vnQuQPYqt70D5wwZBpJUYTglCbFAAtGQU427TpuXCSywg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+RIuHTtlFGIWs268JjlMQMTzhH6CEFEaQktnPCA2DfE=;
 b=eBzrnqJHciLeW4AVGnWwWXjkgj8EpjbYYipagfWa1uqA7x34aFIc0Vz2RXbez+kykT3BVA6nTqrRcaDcQrHdYg0OAqhDrsOUgmMeV7BjdeAk05yIuCTgJ1+6uScg+5iQz8BM8AOoW3fSuBnKUpntJ8+vUIH7Z50YxtbCkBirSoEkvYNq2gT0+0z8STrrUBYYLNcBwJEWvZF690nZelnv5IVfsZ96lR1TIvoyzT7+LHkQuthU1y+TNV6PM0hZ/GkcfGiVLkdKzx+ZRPazRdgBGC68ShC0sL1LDFvViUg+c696LFpf6yCgeg1PZ92vR7/sw/2zLlj/vIG1yfsarXJi3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RIuHTtlFGIWs268JjlMQMTzhH6CEFEaQktnPCA2DfE=;
 b=Muriv0bqL/ibQ9t/tyImpHJ3AvdseSi9y6yWkvHI/ihoS4ztIkcdF+cZhZvBRsUB0opSN3DyQHprTcm3UMdjNu75pBEhc7+4lKb8CZhlZPRFQPPzfxClT7bACXkgctOGbH8i9C9l32NZqylhARBhKplLKTA7j4wVIVp69IxhvvY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AS8PR04MB9077.eurprd04.prod.outlook.com (2603:10a6:20b:444::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 13:30:12 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 13:30:12 +0000
From: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	richardcochran@gmail.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sebastian.tobuschat@nxp.com,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>,
	stable@vger.kernel.org
Subject: [PATCH net v3 1/1] net: phy: nxp-c45-tja11xx: fix the PTP interrupt enablig/disabling
Date: Mon, 19 Jun 2023 16:28:51 +0300
Message-Id: <20230619132851.233976-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0007.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::11) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|AS8PR04MB9077:EE_
X-MS-Office365-Filtering-Correlation-Id: bc18d987-850d-432d-51d0-08db70c94f2a
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2Oz7j0IM2XAjyoZZSM/Jdlu9pluCayfZ9AEZBF/+odHZS1qmiIUMXuzc+aCyCd50zlnzBHtg60tGdFEaguUFjUckae6jEwu6lO8LHnkIQ2dPyllBF26CMzv4/Sb6NCJu8Wfd3v2QeFMSHDiUldbYmPPXopXTrh4a60aaFGxRGMZR1hm4eBhSrp+kSkPJeP2H76+oW4920V4Yl2Hh56LddmkTlNc6oY0SqOdJAsgC2G1WSRLqsy9rzmqLawORfdbqmQfwUiawRiWUvEp/XK4FE7XnAhidRXu1266cuguHZ6EE3jaXpfhNVVvA6dgaPLqj1aqBFDIgFRndHxQVogEOBV1Z4p7xIGywQiNdkro21JrYu1ug3r3H4KuC8WVLt4scj8o+Me5H3q0xrLl6G5oXgBTIcFx9sHEW7UeVOoQx5DcfZFjlgKcBusmCJ9N25OP7/emoLban13DoTs4mbnoEkFhRKFIhZ1MILFv/7CYzhcN6Nvv/TKmjLf7HpSTve7V85MP10yszoj2wDXxQfxgeh50v/bz/aVw/FEJqgeZTD/YldwemjyzmDUAjvC0bVKv1KytqNyrVjSriZL7mKLJiAZJjU9IRTjTYmTEuoqrUTyI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(451199021)(186003)(52116002)(478600001)(966005)(6666004)(6486002)(86362001)(1076003)(6506007)(6512007)(26005)(2616005)(38100700002)(316002)(38350700002)(83380400001)(66946007)(66556008)(66476007)(4326008)(8676002)(8936002)(7416002)(5660300002)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DMcrvLHmtU552jKqhsED6+XH28AYQY/9nHXFy3HMOXCWN2S0qJ1Fwf+vO//N?=
 =?us-ascii?Q?hae/GydaPJpoFBvFc/p/ooc12VYCWCaOoC+LCVbPH1kXJpteXl8dyzkiRdkL?=
 =?us-ascii?Q?vQXbtQFMZ9jfBuiUFZWKRl3U+LY71smaS4bCCNvjUbAEV8wQCIdo1RP7WCCd?=
 =?us-ascii?Q?ArG3vaA5yfSXll7bnmEjH1QW846TXdzb2f2A88z55EYiQZww0r/ltwLWMA/c?=
 =?us-ascii?Q?9TaU8ZUVuz/b7cjf/Y+dQy3k+hJKRDA+gDQum3LqbWNZ71ST1EJ5PNPRoXQS?=
 =?us-ascii?Q?wuLE5MLB/JFis3eWmvXnbCK0A/bEyArO9Vt+1sSIkim0CXGGdhZnARyhT1zy?=
 =?us-ascii?Q?ghGeUmkbn//pdFJ8hBtGfOzsPfZcv7VFNGqDv5o7/wxpvWUz3y9m7mm8BUge?=
 =?us-ascii?Q?zAo6UQU066fVarXWL03Bx+ieykWcTnj5hmc1D6gzpllnkgQIA4y3q4iTmmEc?=
 =?us-ascii?Q?Ci9y2gr1EGGTzrLsUH8L9vKj48CQq0G2SqvHPdtpibljilferebMWxFgBAPY?=
 =?us-ascii?Q?BWuskAaokKUDiQp7k0WSHlf2ZV5lLk2ilLkH22cNDqpXjLhQUtoXYIRHBL8r?=
 =?us-ascii?Q?7gG5LFeWdZ/qlc7++gkbPX2kNhIJth33IOE+JSXLGPPmapxSsDvIStvEaF/5?=
 =?us-ascii?Q?LPRUmrsVKiiemJ6Jrcz51ZPCu45u8/a1bdrW39afecOh0HbbQ/33nmZAaaoK?=
 =?us-ascii?Q?HGFjnAhWMJDu7uyysMa8bqAMY7P0+472u/+PmpYTYiQQMSUJTAHi54KANFOX?=
 =?us-ascii?Q?Gz/CzYnl6P3FyfZOYPGp/onrZC6XBTYzKxordj1UBgXVpUlerSSjmZ4JgP62?=
 =?us-ascii?Q?2mxx5RAzLDKNB0p/PlRNSHFpRDGG+cGy9E7Y2bVhXgL2GZ7GxZjIAj7HM8BW?=
 =?us-ascii?Q?If6+QOUABMljS5iQz50TkI7qUXsasi/Do7zUgWMNGcHDd7ZUV6/wny0eR4hh?=
 =?us-ascii?Q?pldGkzWqi3cvwZiWNxwUT0ye/WwNW8R7UGQ6HWhQCQtTBBEspfC33j5p0g5+?=
 =?us-ascii?Q?LVQyd2AHMhUdvxbXiZuCd9oKGZ4cfP3fZV6gZauQNrDMGmIPVEI+FDbDfHvI?=
 =?us-ascii?Q?+l4zoFw2x97xsWIz+YN9cHzHk8EOlDTJw/rStnz3Rjpr6+yTvw8AuSy/Gxda?=
 =?us-ascii?Q?YHdVtbFknxc4IYIVFudMH1DkSHA/C6nC6Id0xbeTgPzJvTPeJHvVzGLvjyDX?=
 =?us-ascii?Q?yHoKwo3/k8mM5RRV0IjgpJec73ldSR+g1c1uS+VfLJOSHBIuEzNEowTQljsy?=
 =?us-ascii?Q?Z73Lz6RD5EbqTdRfMgbQkzF1oun0xfvqBbI49fKRU7rzw2A8pTE0Hcn3C0To?=
 =?us-ascii?Q?HjLkiMiLx8lBup2sfCiRWqY61g0IPQHsV5I3G4Ss0eLrDZppGwqi2y6u73p4?=
 =?us-ascii?Q?4A0RBFBzgsDERjGByHEFg7ogElzJ69yLu6neHRwp6G3pvW5wLiMJXXOPtupS?=
 =?us-ascii?Q?dCcT+9r3WHURVTuTRCp2EBp/VPfJhbHi+zKG3x7FyTQePPDgP85E2jU93Z53?=
 =?us-ascii?Q?sMyPsjRepWkPEtvKocjnKXXgGPyUnt7MluHJ9zg2RN70HZ6iRkimfGfhGKr0?=
 =?us-ascii?Q?8VAL/cO0wOOZYH6Jmd8PKgyi7Xv0tk9P4cW5d/IjRG2nP4tIivs3ogwKclEL?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc18d987-850d-432d-51d0-08db70c94f2a
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 13:30:12.3843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4BV97CH+Cc6hAXWZ2q8tqRT4GMz0zldZhhfMK0fU6VeA4c0cO5iUNSZC0Q8ivmpjDD8BltX1XKpmk558sP5qTkzsXwWDrLh0ZvwiLItwiEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9077
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

.config_intr() handles only the link event interrupt and should
disable/enable the PTP interrupt also.

It's safe to disable/enable the PTP irq even if the egress ts irq
is disabled. This interrupt, the PTP one, acts as a global switch for all
PTP irqs.

Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---

Where is V1?
https://patchwork.kernel.org/project/netdevbpf/patch/20230410124856.287753-1-radu-nicolae.pirea@oss.nxp.com/

Where is V2?
https://patchwork.kernel.org/project/netdevbpf/patch/20230616135323

 drivers/net/phy/nxp-c45-tja11xx.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 029875a59ff8..f0d047019f33 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -63,6 +63,9 @@
 #define VEND1_PORT_ABILITIES		0x8046
 #define PTP_ABILITY			BIT(3)
 
+#define VEND1_PORT_FUNC_IRQ_EN		0x807A
+#define PTP_IRQS			BIT(3)
+
 #define VEND1_PORT_INFRA_CONTROL	0xAC00
 #define PORT_INFRA_CONTROL_EN		BIT(14)
 
@@ -890,12 +893,26 @@ static int nxp_c45_start_op(struct phy_device *phydev)
 
 static int nxp_c45_config_intr(struct phy_device *phydev)
 {
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	int ret;
+
+	/* 0x807A register is not present on SJA1110 PHYs. */
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+				       VEND1_PORT_FUNC_IRQ_EN, PTP_IRQS);
+		if (ret)
+			return ret;
+
 		return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
 					VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
-	else
+	} else {
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+					 VEND1_PORT_FUNC_IRQ_EN, PTP_IRQS);
+		if (ret)
+			return ret;
+
 		return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
 					  VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
+	}
 }
 
 static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
-- 
2.34.1


