Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA16414FAC
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbhIVSQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:16:57 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:48961
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237036AbhIVSQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 14:16:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeQZlc60exTrvGYILn/bzoxTS724jJx7MviWq/VuiC/yGLeAXPkFx2/5kNmKmIWYQ0zL2w+xmXwXOIbU4QmIyRZoiASraeHHBc3nHDzCX/APedwunGlVxx30xI/8x1ChyM58T25JzLb27klpXleLlUViAVfe36X1SaeoXOASz1GtwbrFdlXFApMh2+DZvEy/iu5V5q8iZW3HqLK47zQzlegPZ+9uk1j/LDs3xKYNvCvS4Yg9KOKfBjGkpwAGmpWKXOShafoyB4PmtZiyoLX/x+K3Z768RrnixAED2WCjCV7GzjsMvKf0kgsFMNesmaFTG6odqKuhguZgXlRmYlF+PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fQX1DgHqQ4f8RmYEiEU11YGK9ontXp8XLXGE0GO1PsU=;
 b=k2B5VGkCCuvZuJtNcuHFB+3N8GtoUsZ44ihLz2S1gkafAKaLcMg8sLGlG7asC0z90SgnBD6hQnSgb8cMoeafB5/aEv6vhlY4Wmyc2JqsV1mOBRKIZf++iAQy+eEI6KUh76pgwp/kjcMrsM/Q138WrUA6/1Us0A9TRP8ad50eHVCn5F7+C3fAYhrjrByQuB8qYX7wQflV3gnUeTYL0lQxNk/KtQjSfTlFDEYpr5Zk01nkmqACmyAgInACjxIZ6LuZjeVu0r+TTmJ+d1VcKgi2+IKQaTHzfxYq0uTiwDWQWH/cI9oF01r6RyusAPi4brKuVYdgokRKpPY/qJTIoDboZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQX1DgHqQ4f8RmYEiEU11YGK9ontXp8XLXGE0GO1PsU=;
 b=QjUJJu5pJMbVB2umdfApSPs8b+v3oSXgBDm07u9SED9iOZS/QJPp3qgSc/qpULxwq5dW+Up8gVYAR6EkiKNUyXDDrTZwv1dotMg7h5qLxSpTbEZezyTunhdZQly+mAK74ftqGzg1HKPnNN6d/8kW3ATxKnM5LWbjkeAopRqgaCs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 18:15:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 18:15:20 +0000
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
Subject: [RFC PATCH v3 net-next 4/6] net: phylink: explicitly configure in-band autoneg for PHYs that support it
Date:   Wed, 22 Sep 2021 21:14:44 +0300
Message-Id: <20210922181446.2677089-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.53.217) by PR2PR09CA0001.eurprd09.prod.outlook.com (2603:10a6:101:16::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 18:15:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e3671f3-e873-4486-0835-08d97df4f00c
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB74714CAF344F42E3AABDFC26E0A29@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mO5QpZfodkhje+jRgkmo5aQuTOi3HAdX14sF5flvEDw582ZCkSubvHiBAYgy3vXwBuFc73LLQDS+4Ilw8XYgDFVuj1FxrAX/SCRyTH2EEwk/VUwJluL8Hwgj+t+lplSLTJAfP0VgLFpayY9W/amvq9oDBIKJr7GesFybtwuJznakXKRwTQ+rJI1Pt0vz/F/9N2pIgUYUgzvU6iI4c1GgIZNUGn1ZrvqP1nqjy6688T8hRSm7vc8c0c6RXlsnTQrJCFSxw7mN4hD+AgvceFUHpy06bnd8cE62Ho49qMxIw6hUjHMrCruv8lzqei8YwRFWEHByKBWDaoNkuX8mcGx2e8hrlf2FW2lgRwWSWGZNCAqIITkNyO/lguqDMm2j7XMq4R2PmuAddfdIImhkmK7zIkjPdD3Ve28jgymRW9/VMbgTbVsNkHqiNor7bMQHJxOW9xAm1n1FU1jHzczWEVHZB+dzxp/bZnBU4CxvBYoIL0tcvWcHboFCsequa0AWO9A2L5/VZSYdot4g+oB2Gw9mjxHmndEk/4eOJW9PTtVv3ZzrHZTZHzwo6aHhByMY7ZT6EsAAW627SJe8oYF4aSAYbb3cnL6uE/7Wv2S+5Oq8jbKCaNd7CaCohSSSqf4WIZYhQvP4QYApD9VTW+beQ0v4reMaB6DqBqNNp1dTojgPO+yI7cRQLe9wRpCK4MsX9NXuPHGC8pF+8FNA63TJ5Z/dGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(4326008)(66946007)(66556008)(26005)(38100700002)(2616005)(6512007)(2906002)(508600001)(83380400001)(66476007)(38350700002)(8936002)(6666004)(7416002)(8676002)(1076003)(54906003)(6486002)(52116002)(6916009)(44832011)(6506007)(316002)(86362001)(36756003)(956004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ehhmS/y5T7hjwwusraBH8swtsrDNoQGkVv8NTL0FqonIYgsed0ZqNpFsHrD8?=
 =?us-ascii?Q?qcVANsgVmjcacUKoHEl8i20YpNtppTlAegK9ibDRe+qojPIi+/KJ8uhfACvT?=
 =?us-ascii?Q?grEgDhsFTxNajVXIOi9pmGfOsvhVqw72GYR1sf6csE/qZWR0yfQ+8D8MCBXx?=
 =?us-ascii?Q?XTOrUO2HkZJisrMurfmRFHz/Gr0HQ0N/qJ4X1AeUf2cMPfeb036vM3FqZvdK?=
 =?us-ascii?Q?69MRCYXDsu1qYJe0k9POCV981L/EblgzFCc5civVDb7hVZe6Sxew5SC+f76s?=
 =?us-ascii?Q?rk0jlQNwnrec8AF2mjzdz9yNnx6/JXLeEtsF4Kj/GdQuTNx64ZEMFw48jSWa?=
 =?us-ascii?Q?qNhp4Em2a2D427M4QXyNQzFc4DFsl5qvOKCdE2LzDcjvLluZCaD4+cGrOfnx?=
 =?us-ascii?Q?HkbwgEyhCq25sUUP0LkpZGhIwib0pU0h5ZeFN2oKPuVmJKB8LaOJBhBMK8HP?=
 =?us-ascii?Q?fkwMVtobSF7NIZKE+s56qq92Xac+QEPJvMoESp6OW8R8oioc9q7jCmRAJ98O?=
 =?us-ascii?Q?Wh1jvzqCkOjulO7D2P6PJEPAtYhKfWH7YZaKFweRZZsd7TiDolEC2g+JqGXE?=
 =?us-ascii?Q?lwLp1qZKf9Mp2LqSjYILOfkPlRHDKunxWahblfq9sl0JNqbEEbviORC79b5+?=
 =?us-ascii?Q?a+GMf7xnY6Z0zAGxk2syP8hpjTdk2hKdoWVN7Zd97zu4WYee28o1UYEypmFA?=
 =?us-ascii?Q?PClSSm/TeqpT9j0CzrtBjoRkjXNy2nLtceltGdnY58T1vkWTimw2/0LUvqqg?=
 =?us-ascii?Q?3kx+en6QXFYZmIeuh115qO8mIuBYWeArAisGNtaytX3antiUEh12UhsmD89d?=
 =?us-ascii?Q?/Z6pf4noGDDwHKbbmVx+Hq0wa7OLJKH5tuL83W6Zjv+Mfwf10a7iiiyJMLIs?=
 =?us-ascii?Q?uEeRiSZ+9K0kSBqGSqnE8MqFS7x7tzHVn7ClGRTPwLOLvlxJE5wXwIlv6ENs?=
 =?us-ascii?Q?+iR9D5J744HbCaaUZAevW2C1vCeVugnLi6/FFGZ7REJBLwFI9B3RvM5uRV1v?=
 =?us-ascii?Q?kDLqpxhH2bQX6nU+A87NAL0h1DPHtmwdxByjyIMl4Euk0iS8x7RxXGv1RmLm?=
 =?us-ascii?Q?qakMvh2o8zFl5x4n0uTaSrB7Ql7dSug1bSGGoge7whwwp8igLOD1uuNjrAof?=
 =?us-ascii?Q?meMNUmvAls0DH58f6Ox+J2fTtIQBWBkQLjcCVDHDE3JLUIH0dCKK8DFlBkIu?=
 =?us-ascii?Q?oxxbbq1+x8E7MWbJeQEC9K5nl6GH/kA+lghKxbX7MjxAWRdzWYvlzUkTUTbx?=
 =?us-ascii?Q?GfjMsDcln81z0R8A37HVpiCys965pF9cKePxbsCX+m3omjSXrVeBMXbhld7M?=
 =?us-ascii?Q?AV3DWMt20cWJUuofPQA9XarZ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e3671f3-e873-4486-0835-08d97df4f00c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 18:15:20.3997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wB/2UJ3/2yuOmy0SblA2lllO3Rqzy/eEjKOfc9J7LCywCqUNyWFgS5TmytRCLB7+3tGFpFLVWnz/r65akyB3lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
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
index 358246775ad1..b86e8f7b6c40 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -955,6 +955,7 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 {
 	struct phylink_link_state config;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
+	bool use_inband;
 	char *irq_str;
 	int ret;
 
@@ -994,6 +995,15 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
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

