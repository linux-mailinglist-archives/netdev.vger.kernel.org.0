Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D4C414FAD
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237055AbhIVSRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:17:05 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:48961
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237033AbhIVSQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 14:16:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwZHxddTb04d8rtz3YZsHwduonSrJsgSthrPbVrbHC7T87dA8qjPZYmbnZOyd/UzLBMUxI7U1sW5ayD0WXA+zj4Fq2n/NyFvXtQL1K5/5O824SEKSNpGEoQOndAS+ewDBpeLV2Hsezz4hbHpJ4mTCaHD0HTWdwqry79VsMSTS0cSihsiaSWRiZTMHqmXpEsQMSj1fyYUfZzS13EcWdroMcDKOjNBEuTkBfLBJhjgFV7vWThkovEBK7XE26lyFlX1Q+NEk23xu3ZyztB8TycTqTWxwo92fzyy/aAd6TIqbIOy+D6QKfO/KsCxJ0gIgojq99IeNw5XiaF9jDrh7uS1UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3lONAFphLHHBrplFu5N65nd/wGEIs2fQbXwaq2Oy6BM=;
 b=EPsLc9App5vKjv6WcwMO0OvCvnQpvr+MnOzGcTPsxrojTPhsVc1iwtuS4NweMf+b4pjnFWz9FBQVbmOtOx/WJTUk0KgZb0l+5+zn2HIsSsuTrCzeLFINp4oSRxLr/SGh0NvL0T+y9yXjKft7A/dCjkLbL017r+3c2eUoU3SdUuwri9w7BGkwxpvqJPBvhH6np/fA4kZdVWXG1a8vjADO1t3KQIvX9UMAot7ZsbSIC76cLgbqjF+orJmdedX0TOiQSBYn9UkMAr0jAjjmY+bUxH5n6EDlNWylHwRmjwq2g2KHhJPadM/xbVMP95LTc0LK6r7Y9dzIGYfSOIf6ANmZXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lONAFphLHHBrplFu5N65nd/wGEIs2fQbXwaq2Oy6BM=;
 b=AoqUi64mLtDCrStWr6wztL1YWizcZ6fEGGQXdj8VTn8H2WcZcMu4eAb828/XwnAB5qrgCIyidKv7fE0SGxO//I3TBo+8tBqNgJ1OArife36DbTzDInN14K+iLjW/C/fpt3+Y6qFETX76EHdjbn8+NZDPwvJmWLb/yfaMX+iFwyc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 18:15:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 18:15:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [RFC PATCH v3 net-next 5/6] net: phy: mscc: configure in-band auto-negotiation for VSC8514
Date:   Wed, 22 Sep 2021 21:14:45 +0300
Message-Id: <20210922181446.2677089-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922181446.2677089-1-vladimir.oltean@nxp.com>
References: <20210922181446.2677089-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2PR09CA0001.eurprd09.prod.outlook.com
 (2603:10a6:101:16::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.53.217) by PR2PR09CA0001.eurprd09.prod.outlook.com (2603:10a6:101:16::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 18:15:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74a6e1c0-2152-4a68-8d56-08d97df4f0d6
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7471AE5671F59EB2ECF031C6E0A29@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uuL03uSdlNenGG8vEPLWpEBu1qnsYX0y0985X9WKVTc/zHnfFO3KS6RVpQFPLtNVdj7IDB5hxQnQLVFAL41FomBNucHzxogghHONpNUtHGP1RdAGQWd3MkfdqshKrvqvc0RzVw1cYeN5ocrQd5CY7U+2Q3Obik3pMKJz6KiMYH/GbFWEFpXQg2aR1t20gBxxlE1qsi3LivBvYgbWiCwGy3o+yngnKE0fwpKThrta6KOW21uzimMW4y4+t4XwfcB6OFb0D7o9DZ8+4YF26r00la+Jrg5JQPpzZBWMvrgrTertrFduOxFxbb2BjEiCJOu65kHM1l0t3IrBPEQNF/6lZRziXLI4NyqBQMhZrJe/1SfdIKLg51LCo6jWPAX0JB98r0cvuC3YzpRZXSKtNOpJ2Gj45JzsK2nFo7klyh3CqC/3FKWEjFWatFabkaNGqF8+/whXfSWKd2g6p0FlWWAUtNuQEcY/RllRRGILL5FFlJ3sikq7Qj+BIkgJPkRpYooN4JoGgjWOKu9YRXVUp/Y+aOJP4uy9GpO1Bulb04uH0NUhDtHpAtvsxVSELK4XHbYaPXzLCG0nWE9ZeF5doFgnD3x0QqAHhAbUo+w5cT2naV1//+xkC/TA29TiYl0XJE79AQDldmjtgPA3vQueHFxbHYrAk24QXKggxl1QzI1H+JcL9bcQTtC/uR9W4857bvbZFSE+7JEmPLHHDxWDA2Mz3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(4326008)(66946007)(66556008)(26005)(38100700002)(2616005)(6512007)(2906002)(508600001)(83380400001)(66476007)(38350700002)(8936002)(6666004)(7416002)(8676002)(1076003)(54906003)(6486002)(52116002)(6916009)(44832011)(6506007)(316002)(86362001)(36756003)(956004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CWIs9Up5ZxKsl41y1CSNPkvDoaZVMTTBhIgiwmisXjulm2IQWBR+Xdk5BhW6?=
 =?us-ascii?Q?bZu3Pl/xF7VpB+J43FU0yXxkBY2Gxzt2oZPDiyuD0CGAl/33GZCPfDrM0CuR?=
 =?us-ascii?Q?zCP7NR9Tdu4n4P7LtO4YLJPLalqQIcOqW/hmFwenPgh2hw3oVOjg74zGAv1C?=
 =?us-ascii?Q?MHvVVxqEx8Nfh8qKHWmSMUuk9wFNnwScpa5eeNdQkTEeTxYJMi4lNa+qji/f?=
 =?us-ascii?Q?XjPbpfc8BKb7j7gN7S57ealRxMZssAo1Jgo1KceDDEdppHPqfT8zOaHiXao9?=
 =?us-ascii?Q?Dzg0UNdHWJZSb9G/4x4II0xkBgqSBRJPXQIPe6lrxAHvQLAzwNMRTOQYoEnR?=
 =?us-ascii?Q?b/ZEcwXfGuQK0lgtzbriheamgdKFfGftWbZKSDV8KHWFA2Qe/kBLwq9zbcUE?=
 =?us-ascii?Q?yWOVLIdnTQ8hWZTVThPhYiUnLZI2PFnlPXkvNL5tEmNRwC6kXo8SzwcWBe0X?=
 =?us-ascii?Q?td1ZgZAJqh7/sR+tI0KQBHz2cGTi8cEad7pfw4P7sFBK1ASlO7Fms7EWW++o?=
 =?us-ascii?Q?E1xm0kl2FZsTTq6tJ6Uh95JIFmpt1tgvGPt2yf+IWNweKoqE5foCOwZr9gOS?=
 =?us-ascii?Q?JbBDoNZVtnVPLGnrYi6VxFhTAtOR//4Suc2XjxmDTumD+pp5hO3dFeWo6iln?=
 =?us-ascii?Q?kPiwPhYNQxp8f8flDRzMjwDxaC82qpm4Xw/kr6XaWoiAZxJFgSdlbhJ+wZRu?=
 =?us-ascii?Q?DCXRidMOAfNHMD7B2fPNUChy8oTjWWOtquIJqlPQadVrubUt2xvRhuprPWra?=
 =?us-ascii?Q?tAb04o8jXV0RTDjqpz9bvwxFp48ZlqKCD345HleSNBo3ifMNKl97IKZkIxxD?=
 =?us-ascii?Q?OX1G4E9+TeYbR/9q9o6TWjUlFdI1pE3FKrE88K+rBLANzgc03/W8zThgjZsw?=
 =?us-ascii?Q?hQsZfo+qXUcEQlhJWCPFd+z1rQBRrjbw8gXeFSi9VgfP0TYao4leH9vjNhHY?=
 =?us-ascii?Q?s/CETxA0d9zT+iHDH7DKz+66sktJCPnUYb1efnvfL2oF56SJctTdtRUw8qeo?=
 =?us-ascii?Q?7pEBzxNOt433U/bWYLxuTgu/wXqpPB8J1mFJOTpq2MHvX+PWUoXinO+ZzSDK?=
 =?us-ascii?Q?uxbZEQJv8DF6o1tfY3LwMrPGkI5u5727mifL+t22Ac5mtpQFciPVkpjyEZwg?=
 =?us-ascii?Q?xlsdG9T1n+b2Z1OuhA1M9Dn8fotXQBFu+/fC3j+aPejqBI2SAyLf1E21zaqg?=
 =?us-ascii?Q?7/dz93crgkQ8BxGldsyS8cgONG1BncZpfL/YXT708vSRjWogk4nHi7pZAQI4?=
 =?us-ascii?Q?FYz51qExEg3dOvlA1Wz8F7dKXBTS1r1vHicFeTg81fIlJPhto6sNenbm+aqg?=
 =?us-ascii?Q?WttNWMk2a69qD/cmjFSV68It?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74a6e1c0-2152-4a68-8d56-08d97df4f0d6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 18:15:21.7399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: whIGTs/9X5nP5CzvW86haecb5SDS5BmyOQJr5IW9fFp1Mz8lskXGtuCxXFgEaE28Lb/x3148Lsbr6mSDPn60UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the in-band configuration knob for the VSC8514 quad PHY. Tested with
QSGMII in-band AN both on and off on NXP LS1028A-RDB and T1040-RDB.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/mscc/mscc.h      |  2 ++
 drivers/net/phy/mscc/mscc_main.c | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index a50235fdf7d9..366db1425561 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -195,6 +195,8 @@ enum rgmii_clock_delay {
 #define MSCC_PHY_EXTENDED_INT_MS_EGR	  BIT(9)
 
 /* Extended Page 3 Registers */
+#define MSCC_PHY_SERDES_PCS_CTRL	  16
+#define MSCC_PHY_SERDES_ANEG		  BIT(7)
 #define MSCC_PHY_SERDES_TX_VALID_CNT	  21
 #define MSCC_PHY_SERDES_TX_CRC_ERR_CNT	  22
 #define MSCC_PHY_SERDES_RX_VALID_CNT	  28
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 6e32da28e138..ca537204bc27 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2189,6 +2189,24 @@ static int vsc85xx_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
+static int vsc8514_validate_inband_aneg(struct phy_device *phydev,
+					phy_interface_t interface)
+{
+	return PHY_INBAND_ANEG_OFF | PHY_INBAND_ANEG_ON;
+}
+
+static int vsc8514_config_inband_aneg(struct phy_device *phydev, bool enabled)
+{
+	int reg_val = 0;
+
+	if (enabled)
+		reg_val = MSCC_PHY_SERDES_ANEG;
+
+	return phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
+				MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
+				reg_val);
+}
+
 static int vsc8514_probe(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531;
@@ -2395,6 +2413,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.validate_inband_aneg = vsc8514_validate_inband_aneg,
+	.config_inband_aneg = vsc8514_config_inband_aneg,
 },
 {
 	.phy_id		= PHY_ID_VSC8530,
-- 
2.25.1

