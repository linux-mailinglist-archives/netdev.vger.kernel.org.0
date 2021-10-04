Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2E8421736
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238986AbhJDTSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:18:33 -0400
Received: from mail-eopbgr50077.outbound.protection.outlook.com ([40.107.5.77]:3542
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236730AbhJDTSE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:18:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KW1mQMutyecBfbs2YAgmUKK/ok8mQuDjE9yKHC53L2NAo1WugWEPIIoKhca5Jt0VYJwQ8z4hNWjRDN6sn2UY1zNY5KXVjRF/4rK3VqhKYabxNWKDUjDmYqQOoSfUQAntImgI/AlxyYuG4tmoHOWmqkGAPy3wfYWw06yVVzJqBibvlAiv7r1aZj9Azn/La4uj2kcUw7+jHdjAuL0cNxcjkBX1pHv5Yy3RRFCU/JRk47+YjGs/vqjBfVYLx5ErIrh7dlfkVkm/2muD2+mU9tuW4YlXFC1i2Z3pg9Dp8tuqLyNhWknc83oUe7wT0+jpM5yekPCQ268hQ48oLgCq+6nPRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L66uG51At974MAUQSnBjVhCL/2RhbvnkweDp9b/ye1g=;
 b=amC/fW1fEbvw8gy4AExChP1acEdkvmpFSVxLQrhZRt5ZTwCMZNuE3dymBezR5MdLq2CrxEjBJ4+2I6TSyYBynb3bLW0fcjTGgvxxmzfeN78rhY2VaXr0oyYos+pY6xYb+aC2P4h5pz5mizVm/HHx0fiGiB8Y9z57LvkKx7O7sFbe4YRVg6xTXVF6KNiEMJa0XeTs/BoquO9NaJGrmMVbLmWwILFpJyFdSEiyg+ThpnyfsuxFGb0ACC4TEQ+CxrP6ZkYo91VomQ63I26qRlY/I5Quh9tmz4O0brSsJqYuaoh/YxDppPegXqFRV71Gi9fsYE63Re4Qo9Tgmwg+MZ2otg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L66uG51At974MAUQSnBjVhCL/2RhbvnkweDp9b/ye1g=;
 b=RVbzzhmqM11/oFP+c60bsRi5j1IAfxlgVM7fI4Z/tDvJatiAuYUU4CxE7NA8fwR56GefvbCoVrUfZQCVtFj3gXmL+HeiqDDZnjcrZ/deKNVCbLv0O2RsZo8T3QeLP4H6XxFWc9Lz61JyUizwWhB+GNqVrRbEZxM2b6ofweqB3Qc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7434.eurprd03.prod.outlook.com (2603:10a6:10:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 19:16:01 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:16:01 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [RFC net-next PATCH 09/16] net: macb: Move most of mac_prepare to mac_config
Date:   Mon,  4 Oct 2021 15:15:20 -0400
Message-Id: <20211004191527.1610759-10-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:15:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01029646-a41a-48a7-4a82-08d9876b672f
X-MS-TrafficTypeDiagnostic: DB9PR03MB7434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB74344C852EF9B6CD72C5E82896AE9@DB9PR03MB7434.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xCvjDAkTFys3OaTaLOQ98sELCekV40yQVH2RVOs6fighGfJq0W+cgmaRxufuOtkVg5L6pOkvQnX8Iv0FhegISChwxGjRvu9NVTy3b9c2+4C8IfFwCXZFOJvssraxnngR0It8Lru1UaeSoJ9kgTki7focL/qK3tS7lKuR/hDHe8+OINHqnF6FhvmmPuKYPB4VswVvlHHw5rak7m6zrZdIiSTDXQPF48/536CuNULlr92lQOOkeJqp1kXgknVX9xbTE4A8AnW2qe40sLApVH6PkrKdQD6hNXzdvT6U9xXvETBSJ4uqx2EFgISEDN4jQW2Ua2+x5giKBIxm2EXXKh5OwuymNcuolbZ1TAcmRxi90rvq8zL+4fb8vPYM/Ix1DV3dMmGOW26QYRPhtsRHbFO+KbzancK4SKZXhMBtEnluSBaLA+4A7kjxmEQ+pSO8yor5NbMsiqCb1+1YxZWipy/CdnHR8LgOa5srVbMOIPweJK6HmfadBHxT56h9fBDOHHOMZHQVP80S1mXexYfbfrbjN8sQFln8J6FpvkCBCMQA+ewYoDIS/JfSxrzub3u8es3EqAOVE/+K9GyPkoaT/RdoxnndldfL9T6SQtGP1gZ8K3B/Q0ROqUd5Tpy1jGf+64CwYypPb/V3A/z4Y6v55D2yDIYz555544TUDKpAKKQgW8EguEnlqHHiSEczEwEhI78JUfdw7+fsew3rspo1lkONdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(86362001)(4326008)(44832011)(6486002)(5660300002)(66946007)(508600001)(38350700002)(83380400001)(52116002)(956004)(66556008)(66476007)(38100700002)(110136005)(6506007)(2906002)(186003)(8936002)(316002)(8676002)(2616005)(54906003)(26005)(6666004)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VoyvYH+dilqBF9kihCWdHvLtwBIIwfevLdGtL4uI9d5U7pNYOXSGcjVixGgP?=
 =?us-ascii?Q?FC9XAKxhjFk3Ssxtw1GcvRBWNGjKdMLWfFlF0tIE4MIYEPevdHefv+S7lief?=
 =?us-ascii?Q?6ar86AVRv9kIsscrbJjibD+gYv4AwIObH+k0jJ2IsI7TrfRRh2giDScG7VCX?=
 =?us-ascii?Q?zk1Qc8rOidTWuoXS7L2MjacHTzYEAlP5tcF74FSqi1OUqCS3IvchredJlyzf?=
 =?us-ascii?Q?w2J8VU3qGevSjWgC8/FKVElb9LnPLOMYUTCbpalgG1vVKGWlvjyG8xcCh/oN?=
 =?us-ascii?Q?3IhRZsJjRhdocm0CIg+LPeDr/SxtoOFpNCkcuavtaVDHldTuC78X/RZpOf6N?=
 =?us-ascii?Q?AyGpt4oieLzySQe4t/qt5YDhbmhqHlXOBzk3y3IC28icxo2uQiPo6YcTPKFy?=
 =?us-ascii?Q?/QfHuoNNfP8qvc3Gn4OW0gP422kDCERIhlVxxuFnRI0hf1WArYoyU4xyNMG3?=
 =?us-ascii?Q?t/Dh0DNPwgtyz2WKtSj0/GYDED/tU7RLxX+zvTcYAOd7FTdYJM4g0OEcGWJf?=
 =?us-ascii?Q?GWkf1y+2v+0sv499pKJ909c8tDYEnuUvGpYHN5omKKBmai/zxC2D1DhcpryI?=
 =?us-ascii?Q?oAfLTHS+8nTTjC3X9IfAVZLBqeBg1goJzAlkDjonyDJAAWGqpg+8XuLVSL6q?=
 =?us-ascii?Q?T4tHkK17gdJ2uOHFlGRR6GsLE6LYRipw/PfWLozWzGcsfxo/GR1WUjYlN0q2?=
 =?us-ascii?Q?PJfkg29/9rA1XrEkweOmJgdR9tnbQpKlRjK5R69NHZCSZrPopx3Lu0XqZFXp?=
 =?us-ascii?Q?YbXeaP7W0Iv0WfEFaIjZpeQfFBonQAPPHL7wgrTj4tcFZ9rT+y5H3TvJLU9T?=
 =?us-ascii?Q?miAMpLgQKFqWHACIanPrWQj+TvqbuSskbFUpMYlQhZhqAIvcikuUQ9zLPKo1?=
 =?us-ascii?Q?BWqt0OUET3+5zu71nY4S1bkSnEm9joyMgxjNA6o4+3clrGKH2kp3c1C/bVuf?=
 =?us-ascii?Q?1EQ52nKCuHtdaW3xlo5P0JN/MMIdcgoypi2AqxqNb/QvONCDhURpHxFQoXHC?=
 =?us-ascii?Q?Y3Kz15cVZo8zwVwMu0oxO3f5oaE7bKKUzsYcUKF9U4ixZ+7McXMw2jKJ12vK?=
 =?us-ascii?Q?e4fA1AKir5lASqsKpjDfDpn2O7o7XX9KI/ujEc5YRI4yTFTWtszGsqlpzugy?=
 =?us-ascii?Q?HpP+aXrjSAUX25038o8fOrQ+OG7DPIfNr8+OzxsB06XFoUrDkJ9MYt32jVhO?=
 =?us-ascii?Q?fq0uQ4GOZnwcnX3glfPFHz9LL2Ntzzdni2QKRP3ObiyX81WUjvBR2wcay/+/?=
 =?us-ascii?Q?rjFjzfs0JMibsVkyyoNk/Mo8cn/ib2TiggDzT5ytZa3iEI6AaTfLx9YvFGNt?=
 =?us-ascii?Q?m9l2WrR7rPcsHVy3V6aQga1r?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01029646-a41a-48a7-4a82-08d9876b672f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:16:01.2732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7AWGk8Lztci63Bd2QFV9Iie6C9ter5WT/e5WqjiasnZjtUVMlrSNnViQlImD6AtCpzuaPc40gouPB6IWULnczQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mac_prepare is called every time the interface is changed, so we can do
all of our configuration there, instead of in mac_config. This will be
useful for the next patch where we will set the PCS bit based on whether
we are using our internal PCS. No functional change intended.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/cadence/macb_main.c | 67 +++++++++++++-----------
 1 file changed, 35 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 18afa544b623..db7acce42a27 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -652,42 +652,10 @@ static const struct phylink_pcs_ops macb_phylink_pcs_ops = {
 static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 			    const struct phylink_link_state *state)
 {
-	struct net_device *ndev = to_net_dev(config->dev);
-	struct macb *bp = netdev_priv(ndev);
 	unsigned long flags;
-	u32 old_ctrl, ctrl;
-	u32 old_ncr, ncr;
 
 	spin_lock_irqsave(&bp->lock, flags);
 
-	old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
-	old_ncr = ncr = macb_or_gem_readl(bp, NCR);
-
-	if (bp->caps & MACB_CAPS_MACB_IS_EMAC) {
-		if (state->interface == PHY_INTERFACE_MODE_RMII)
-			ctrl |= MACB_BIT(RM9200_RMII);
-	} else if (macb_is_gem(bp)) {
-		ctrl &= ~(GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
-		ncr &= ~GEM_BIT(ENABLE_HS_MAC);
-
-		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
-			ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
-		} else if (state->interface == PHY_INTERFACE_MODE_10GBASER) {
-			ctrl |= GEM_BIT(PCSSEL);
-			ncr |= GEM_BIT(ENABLE_HS_MAC);
-		} else if (bp->caps & MACB_CAPS_MIIONRGMII &&
-			   bp->phy_interface == PHY_INTERFACE_MODE_MII) {
-			ncr |= MACB_BIT(MIIONRGMII);
-		}
-	}
-
-	/* Apply the new configuration, if any */
-	if (old_ctrl ^ ctrl)
-		macb_or_gem_writel(bp, NCFGR, ctrl);
-
-	if (old_ncr ^ ncr)
-		macb_or_gem_writel(bp, NCR, ncr);
-
 	/* Disable AN for SGMII fixed link configuration, enable otherwise.
 	 * Must be written after PCSSEL is set in NCFGR,
 	 * otherwise writes will not take effect.
@@ -797,6 +765,9 @@ static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
 {
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct macb *bp = netdev_priv(ndev);
+	unsigned long flags;
+	u32 old_ctrl, ctrl;
+	u32 old_ncr, ncr;
 
 	if (interface == PHY_INTERFACE_MODE_10GBASER)
 		bp->phylink_pcs.ops = &macb_phylink_usx_pcs_ops;
@@ -808,6 +779,38 @@ static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
 	if (bp->phylink_pcs.ops)
 		phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
 
+	spin_lock_irqsave(&bp->lock, flags);
+
+	old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
+	old_ncr = ncr = macb_or_gem_readl(bp, NCR);
+
+	if (bp->caps & MACB_CAPS_MACB_IS_EMAC) {
+		if (interface == PHY_INTERFACE_MODE_RMII)
+			ctrl |= MACB_BIT(RM9200_RMII);
+	} else if (macb_is_gem(bp)) {
+		ctrl &= ~(GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
+		ncr &= ~GEM_BIT(ENABLE_HS_MAC);
+
+		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
+			ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
+		} else if (state->interface == PHY_INTERFACE_MODE_10GBASER) {
+			ctrl |= GEM_BIT(PCSSEL);
+			ncr |= GEM_BIT(ENABLE_HS_MAC);
+		} else if (bp->caps & MACB_CAPS_MIIONRGMII &&
+			   bp->phy_interface == PHY_INTERFACE_MODE_MII) {
+			ncr |= MACB_BIT(MIIONRGMII);
+		}
+	}
+
+	/* Apply the new configuration, if any */
+	if (old_ctrl ^ ctrl)
+		macb_or_gem_writel(bp, NCFGR, ctrl);
+
+	if (old_ncr ^ ncr)
+		macb_or_gem_writel(bp, NCR, ncr);
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+
 	return 0;
 }
 
-- 
2.25.1

