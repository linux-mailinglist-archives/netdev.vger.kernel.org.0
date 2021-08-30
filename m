Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39143FB953
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237716AbhH3PyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 11:54:14 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:46753
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237691AbhH3PyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 11:54:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1RmcyVsNHMuAqppiYNzZtytT7rhp+4Z/9q/ZEqcl50XYLGxtBgN3U7BbEq9i2dc/8iXrcsjRaaFUqL5clwJ10v4owEvFbyXWJBuSKh+S3hdBukFq2loroePAXco9L9qYAEBWO+CGv+mEkYjcTnoLdTwCh2nvz+Du8a9I+85h76PsvlWrHqH0xhZEHRHS+QoTbMa5luCmdZllBHjyfEpxulRqNvXAUxLXXYWVuONHot/0Fswv0K3PLSBBnGWnbRwC3faaZBDzK3Q4Ltdto+eWRI37/xCFsvx421SLsTIzq4Hw0isp+UY0c3ANwupZsIxL0EjnoQUrnbZGSRwQhoQMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFwnuP72fDSu1A0m3Ja67ywLowhvFcDwBGDsS8yZ61A=;
 b=CF5OKwRq1fTqThTSLRKTcxqDV0wD4+tau+FtiCa/u20dUS5H795MVYwTIvomg4ONIwSLw+ZO+0rIg3Oi8lIbJyVTmd80v2SvEu4moeNFvqzKCSnsYqwdWxncu0oUzkFfY97IrxZ93/8uxn20cu17LFFOX9kT+Eg0Npkx/pf0e7hfikLu5QS8JIXa23ayDq7nzuLzEYsvd0x2Y/giYWI3v209OESWgBxUR2jx3Q/RQ4V0HeTuRMhAOEbFdUIq0oVRIB5TdORbphxgjZOU3xzGHKdszUB04lYdqN4stFijnEEs11scLo9pORze0KqZdHJ5ABv8HuFbmyUEt6q07HOEDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFwnuP72fDSu1A0m3Ja67ywLowhvFcDwBGDsS8yZ61A=;
 b=eUJRMNea9pgSSxVKLzoDTSmiGtvyodfutNM7ryFuWnIH23jaRq21oBI/stK3JEsgqwkxWoBITRpfwxYp3xQECwsDFF8GQXD8mE/SLdpUMTe5IHo7K+ajJl0mEWmDl50uRUPV5fG36y6B5Kc1lIcn+Lz8Tf1IWhr2YWm60Old5iw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Mon, 30 Aug
 2021 15:53:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 15:53:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC PATCH v2 net-next 4/5] net: phylink: explicitly configure in-band autoneg for PHYs that support it
Date:   Mon, 30 Aug 2021 18:52:49 +0300
Message-Id: <20210830155250.4029923-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
References: <20210830155250.4029923-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR1P264CA0024.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19f::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by PR1P264CA0024.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:19f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Mon, 30 Aug 2021 15:53:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99493d1a-0a10-4b97-ffd5-08d96bce4553
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4910251BA291B789C350E958E0CB9@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q+QpbCVNZMcduECHQXxVpqZSpMpxy/0CSV20GkjpVh8UD1WEREJ81sGJJImX4AiIU/D/xS0iryjme9alMMg1wWA3ClKVYF51ZkBgf7fywj/VG8glbZxmhyzxiXPZL5mytVmN0mJeqMKSAjClkuK9XVq8d6t1qoB13+00rg86GURqfFADnaFF55mSTbgjYm/Udy/rc60hH6QUCWnYQ4UEqQfCRiqnZ3wD5pQs54PkA0jFEdyxI84+Djy8293trpt+dzw0BvKlgSj4Mccm8HC+uGo8zZcjD8jFZMm64PqdP3ZpISytzu/mkio/1o9RiuxuG7HxkEy7KPWjnSDoP1okNBiTEHxppjcmuYQTFQLc06aN3CIzbAgy/wOrHE/yOdFUBaVNu3tWv37Zsh4Dmtr624kA3LcA2z0Q2ciFt/N5FCnAb1TZRPV2TQrYPrHjQ2rbLs6e4g4Q+icl8GJXfJDMW/Ln2rDGEjI3kJJUD73RegIrxm5+fHj5/x0bFILTbpnbCz0wyeW8BMp+b131XQW74gBHkwPtATvDZfYmSnOwDKnZl2PaV9/IRSOcmtf4ewj5CTVwr8CmS6Czj/ed8DNU9mJswEa9RL/SVQ7MpkkFjgM0iUjkJp0D+eevTUrS3HDFMBa5kVdi35Dc4YtT4BgmG1TIboZeilHv5VR3CsBVSYVcTKaatq6quFMHPXa4hiXKYPGYZPgK0csXMGDfJxxoFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(5660300002)(186003)(6512007)(86362001)(36756003)(7416002)(2616005)(956004)(1076003)(6916009)(66946007)(8936002)(6506007)(2906002)(6486002)(8676002)(66476007)(66556008)(6666004)(38100700002)(54906003)(38350700002)(4326008)(83380400001)(26005)(44832011)(316002)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tvaZgzK+yjqmQNXLxfk5W0z7ajNI/ZlilxylOL3iFut4XNcJjNRtWQI1P95F?=
 =?us-ascii?Q?qAWoX+BsjwLsEfumMnfTym/h1qoBZGjpm0TtzFu+NwIJnMf4IXsl3abACj23?=
 =?us-ascii?Q?v3uRfcQGpzcsojXPC9sbaVvZ5AcD+diZzRDjKUGQ3DNXMJDnDX48GYFYZTpM?=
 =?us-ascii?Q?ZaMlpAMb6QFc/qDgXuUeCNzMoY2xFWprHL4vz5I/HwS94jG71zjDWZw+J5AL?=
 =?us-ascii?Q?kmN5iM4hZm0F6MqpL1sC+zHO/9RPL+X439wZmBP3V7w2yDBjnsFTj8wSp76t?=
 =?us-ascii?Q?3hmpUWgJaRrGiuUZqSbVlI6ChTEZ1tTC17TQyqnpEY0y0bUxAgJkElfQ+m3L?=
 =?us-ascii?Q?1jHUISssWdVy0hZsKrU2SP6KAK+T/6glqjIWMm9MlZBtlBgAuloyPCuYic2V?=
 =?us-ascii?Q?+OQOAMbHsfbgnXZK358jFdje4tbbhBB0C6a/UsSYXHSXLDZPJzO/mkST3/Xl?=
 =?us-ascii?Q?VyyREl2mvKNKK2f5taGwG6q8CZQVNm+SI6rXNd7m+hxsIZu0tNbJoHUFxlMt?=
 =?us-ascii?Q?xapcjyxD6vSImx++HJFPzrJgfMIhVBy01q0V4dYvqplN3+CWUAwRmGkfNANX?=
 =?us-ascii?Q?F2d6lNMbhfPDinFRV2psnVAH09PvEjhhXORQOVAR1ER12OSjCs4zRBnvwrGO?=
 =?us-ascii?Q?FjEViUUaqXNIOg9cFh23DZsGFc1HyrrrCBd/0yUS0DKTUDGzFV+v3p/0cu9T?=
 =?us-ascii?Q?zTjALj3aePx8kdcsGk35I2SjyTDoZ8jrsH2zjhlqgHhQro8mhXqn6hTIpf3W?=
 =?us-ascii?Q?BF/9juM8O/O9CGlLw7CMFgtG5wsIfPwsYkIoCYIJHVkJ3FBvnbZ5xPMC5NMG?=
 =?us-ascii?Q?gZQdz2XIza3cXEFq/20wUZb0lb798qniwwm0YAnBLKdOqoes+OscWGUnzw8j?=
 =?us-ascii?Q?9FBAUr/KB1lcf9s1mTjSeEvH0v+hRQV5gHVI0QipAxebdrkaWATX/fKUzhlq?=
 =?us-ascii?Q?b6cWY3R0e3qoQZdtF64viQflhzLVys9YEfYwBZyt2h6HwLgUqbNcfXB4dr35?=
 =?us-ascii?Q?C+nPxT8fTKds8llbLFphO7nDISvaIx5U3P9nm2ugWK00jvnrfN7awGwjUSI/?=
 =?us-ascii?Q?GdE5hjc1lWSBl1J8qenF2L0W0qhJ5h6jhtA4rBaE9+sSXGDQfsWxVy41Q20H?=
 =?us-ascii?Q?JElr7GUIyvSERGTppUWxXmaBuAO6QbWdz6IVZzUvq7ArLm7h9FYFMgkuxVB0?=
 =?us-ascii?Q?OlcgBbdw/Vamr/Hs/nYYglyFvnM6bBdp2EUxM1vuPWiJ9ShAv0D9DLOgBFIl?=
 =?us-ascii?Q?a3zrfhktuyKlxKOn476qfWKUj+uXt7Zh2XmaH3SqvFuC0D9/0WfNDiuLTBlE?=
 =?us-ascii?Q?gRkDOKTKYSnXPPZHfzD2X3MU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99493d1a-0a10-4b97-ffd5-08d96bce4553
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2021 15:53:12.1572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iellzB6f9NVCmOE0/uCcO3uJFwJt9t723SO7rebujnYZAwJL7wSTsRE4WBXrPj8+DeQxNXnFe0T12CPSLT/dsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently Linux has no control over whether a MAC-to-PHY interface uses
in-band signaling or not, even though phylink has the
	managed = "in-band-status";
property which denotes that the MAC expects in-band signaling to be used.

The problem is really that if the in-band signaling is configurable in
both the PHY and the MAC, there is a risk that they are out of sync
unless phylink manages them both. Most if not all in-band autoneg state
machines follow IEEE 802.3 clause 37, which means that they will not
change the operating mode of the SERDES lane from control to data mode
unless in-band AN completed successfully. Therefore traffic will not
work.

It is particularly unpleasant that currently, we assume that PHYs which
have configurable in-band AN come pre-configured from a prior boot stage
such as U-Boot, because once the bootloader changes, all bets are off.

Let's introduce a new PHY driver method for configuring in-band autoneg,
and make phylink be its first user. The main PHY library does not call
phy_config_inband_autoneg, because it does not know what to configure it
to. Presumably, non-phylink drivers can also call phy_config_inband_autoneg
individually.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/phy.c     | 12 ++++++++++++
 drivers/net/phy/phylink.c | 10 ++++++++++
 include/linux/phy.h       |  8 ++++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 975ae3595f8f..3adc818db30d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -763,6 +763,18 @@ int phy_validate_inband_aneg(struct phy_device *phydev,
 }
 EXPORT_SYMBOL_GPL(phy_validate_inband_aneg);
 
+int phy_config_inband_aneg(struct phy_device *phydev, bool enabled)
+{
+	if (!phydev->drv)
+		return -EIO;
+
+	if (!phydev->drv->config_inband_aneg)
+		return -EOPNOTSUPP;
+
+	return phydev->drv->config_inband_aneg(phydev, enabled);
+}
+EXPORT_SYMBOL_GPL(phy_config_inband_aneg);
+
 /**
  * phy_start_aneg - start auto-negotiation for this PHY device
  * @phydev: the phy_device struct
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7f4455b74569..167f91c59e0d 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -954,6 +954,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 {
 	struct phylink_link_state config;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
+	bool use_inband;
 	char *irq_str;
 	int ret;
 
@@ -993,6 +994,15 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 		return ret;
 	}
 
+	use_inband = phylink_autoneg_inband(pl->cur_link_an_mode);
+
+	ret = phy_config_inband_aneg(phy, use_inband);
+	if (ret && ret != -EOPNOTSUPP) {
+		phylink_warn(pl, "failed to configure PHY in-band autoneg: %pe\n",
+			     ERR_PTR(ret));
+		return ret;
+	}
+
 	phy->phylink = pl;
 	phy->phy_link_change = phylink_phy_change;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 4ac876f988ca..c81c6554d564 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -781,6 +781,13 @@ struct phy_driver {
 	int (*validate_inband_aneg)(struct phy_device *phydev,
 				    phy_interface_t interface);
 
+	/**
+	 * @config_inband_aneg: Enable or disable in-band auto-negotiation for
+	 * the system-side interface if the PHY operates in a mode that
+	 * requires it: (Q)SGMII, USXGMII, 1000Base-X, etc.
+	 */
+	int (*config_inband_aneg)(struct phy_device *phydev, bool enabled);
+
 	/** @aneg_done: Determines the auto negotiation result */
 	int (*aneg_done)(struct phy_device *phydev);
 
@@ -1474,6 +1481,7 @@ int phy_config_aneg(struct phy_device *phydev);
 int phy_start_aneg(struct phy_device *phydev);
 int phy_validate_inband_aneg(struct phy_device *phydev,
 			     phy_interface_t interface);
+int phy_config_inband_aneg(struct phy_device *phydev, bool enabled);
 int phy_aneg_done(struct phy_device *phydev);
 int phy_speed_down(struct phy_device *phydev, bool sync);
 int phy_speed_up(struct phy_device *phydev);
-- 
2.25.1

