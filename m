Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB38414FAE
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbhIVSRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:17:07 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:48961
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237043AbhIVSRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 14:17:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3OWlZyDIXGSRs+TQHi0EgD0YzDmahXBEaK3vqlg18pw0pNnmBlqQmKRL2ZuGcmaPxZXP66+LdvkDmDWYK9TCtZWf3jEI6zLeOy9eAHN8fw3jG4qybFSQw8HHBpbJ6EzzfdmZvhVoJ7PxRJDJm1EOvIKjN7yRpZgarPXQezvVrylZHXkiM1nm49mpA0Jt6sD9wnJrf4P6K+bc0ua0zonEPiAeDVMa9WgySDCSQk9KLYXsLNubAFnbifC9MJcfuNnja+i/5cR8zRvhJ968CqMFul41uFEdnVSgTzbs2NuqjArbrsb1flk6ZT6nwgv51/FNhld8FxJAkUH3UB4xTmFPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fGFYGPYFcONejG53ey5x3pcOZCKYzPQPMzEswBawJ8o=;
 b=BzibJSrKu7fRdWkfiuUfZwi8omiWSOgNwdatv8jvSHKDmUdA/LXTSKKcIMsI6iXR6IJSnmLl8HOMuh3h08zUzystie65TUSo+XQVbK45XI0QoCWL6LVcOu+Zp6km1BQTCDI76UMgYf8uHDCpNJciF+a0PWvEeyNsMcUPhNZ7FCXOQ4orNg9SwwvdwVPES3asckTpX47oQeJpGqm3RpQckXuoS4qZqZKQoswnNyybkU8uE5zhRgilwZdiZ7SOOSe+lHxE0VrQSdNEIfev9A8qUcrNu3vj2C0fXLL6afR9VbFIoCiuMHUYKCQUP5k+t9VdzXadf4moLeI6a+bKaAuawg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGFYGPYFcONejG53ey5x3pcOZCKYzPQPMzEswBawJ8o=;
 b=G+A7rXi9uGvjFPdzlzsJrl1g6xFbNGaxMLQDM6wJzFKwzoaqK+BYHjRaJu/SpK3lOCiNo7Qm2mUNPlchWFbhj22aI23uw/Yypu7+LyCf8IZw+LueYMddUPZ9D+QlQg0fibeJ8dZHxrdCwsmaMLBzUh5c4//cmi2e9PtVDZ+/C/0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 18:15:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 18:15:23 +0000
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
Subject: [RFC PATCH v3 net-next 6/6] net: phy: at803x: configure in-band auto-negotiation for AR8031/AR8033
Date:   Wed, 22 Sep 2021 21:14:46 +0300
Message-Id: <20210922181446.2677089-7-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.53.217) by PR2PR09CA0001.eurprd09.prod.outlook.com (2603:10a6:101:16::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 18:15:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc63ab6b-ced5-4cc4-308b-08d97df4f1a5
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7471876E1E1E19CAF8DD14FEE0A29@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tIl6O/fGD8VvXgY/EXoQOOuCx8edi0SvRvsAlLIwQ4Ssu467ZwD6rOKYxycpcbf0UfUYXgOT0ntMqcC8IrRqRNtJ19Y4HZiJMuGPc29diiM7xWpkFCVmLiQ1holqoaBJ+ELz5GXd2upl58lbqcMP4ww+QKd74MloWTm1mhvqsZBatZaNs//4BtLfKbOVZ0DUYE+kR0ep1Wb4scDdB68GMFsS4WFciTCDBRn5TV4lVW0bGeGi8lAbfvw4tth3Wfh/t1rZ1NegoJweTN/rT8r92CUCK5E71mcE/IRacJwcwjbBh38NbPQVmXD/FNgGpwrffafPpSNrxphUWm6p8bMIZubLDZIWhi4JLL3NjyMjd+QdAQt6Ql5gRwh7X5n+AGD/xAF89w+MWA6ef7XYinA0w7IZ/RsrRB3ePY8S/OCrwiJFcJdeRQMVP6XsTG3hPnQ9OYxrb0NtJ2NHc+IObjA08t7oqGns9Q5l2dCTZSufL9wBn2ea4oVuOii5UmA/COmREBZp8NM4b0DpWW22xoO8Wyisi9e7NlWEcOPxcsz5HbK/Ojp6dVFLCrs50rX4ITGP841SqNdJoA/KfwZF5Czho67rX1PKZuaKSzXhTr+HTsMHVDCJFOqjYFMMqvazp58W2QporY06U9TIahkIHYD20yMCH5JZ4QVt8FR+Nt8qRLcTMuCNro+ndaUTckKfyb/i8+CcfDKOEHVaO2+OvpxM6HL1dQUpHkGfdBgrrkcdk+SS+/uVh3ZU90EPoBrCjLevBkZBMqIFJgJRYV9W98Vm6Szgk86LPQjxLmESHGvJnPw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(4326008)(66946007)(66556008)(26005)(38100700002)(2616005)(6512007)(966005)(2906002)(508600001)(83380400001)(66476007)(38350700002)(8936002)(6666004)(7416002)(8676002)(1076003)(54906003)(6486002)(52116002)(6916009)(44832011)(6506007)(316002)(86362001)(36756003)(956004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yhQHu62y8OklvPpV81f7NooT8x+FFoaZMiC+T+9cJtmmq3ENTOfiDupIo8W+?=
 =?us-ascii?Q?L3y1wPbevl45pqBOVTcVcZBDSKxBw02TcrbBRGtKtkSvF+M1v0Oeryvr2WAF?=
 =?us-ascii?Q?QHBt8NO+gCGjICwMM69EvTweNIa4OlHVd7T8A9wkcOM3xlLGzdC891Hmnvy+?=
 =?us-ascii?Q?ggJrTj4nZNJ75u8yNC6h6w4BJtjJIbM3Ubpx5R3uPVPilqDi3OrPAOiT9RNR?=
 =?us-ascii?Q?GDHR5EpzEJ4iDbiv3KsTw2DfRTajIEe7Mm6jFYfDqQeMMVzXhq56YyIJYyt5?=
 =?us-ascii?Q?1FWdr7FNxdnCN39YcpE+U9qawJYmK9/06DWG9R4UHdfV58nDj8mMj9UlDmu7?=
 =?us-ascii?Q?oZCefu1gRbBKst4MEn8FrN4snOCWBctckmlQ3vVzRWMhSiO/cPclWrZct2ts?=
 =?us-ascii?Q?PeNcGMP1D6z1bmZ29f+N8epMvEwZWCVUZ2UdodanUaHHlf62mP1Fld687zBI?=
 =?us-ascii?Q?jVeCAT2FulgU5AGiTu1pSQQrmzRasIEtHYox1DVflJqhxGEwNqyfnLNnGDUY?=
 =?us-ascii?Q?JEWLMeYFVBWEbOUf0tL+B8GVDr97fe4UvVo+0xwA5KfLYUQfip+TMGgR3scf?=
 =?us-ascii?Q?X38XTpAoTtVy4MsswSmcis1HAsfy6xeol0IEXdMfhfWmKXpvFJgHRpF/3sL9?=
 =?us-ascii?Q?pb6anM689fmZroJ3bMa5WIz0lll1S409sUEk1pEF/daBykeAId/JrlsPxdP0?=
 =?us-ascii?Q?4TDALXxdjH3rakZgO8phdYMAY0vaR/ZQ1ELAg31K8V43nv3242kcRPKvqb4g?=
 =?us-ascii?Q?JS1/Ci2wUzd0WAQRyduo74MTFiymKFwUdlpA0nPfdIhl1x2mOxTVx5XC+d+s?=
 =?us-ascii?Q?1OW2bbLfmlTLMsLBv+5c3utV8TDCUUgPKgRKULBJIVyDkgHll3W0eEQ7Fdrx?=
 =?us-ascii?Q?HbGPz6dPLXoLrf0vnlNkKottOsEhz3ufq7YYXi59zusEkMCkXPOdFhKOEJC3?=
 =?us-ascii?Q?h2FHInCVk+0utRcBYlIfOcK8rcYcsfVW4LmKnYU95TMXQrCdfLAsY7+Z/fg7?=
 =?us-ascii?Q?6hFEi7YWdSusuvqgHKVANLu+ovtZsc8TIlVfpUgaUmPhmKuPR1zfS/yEJ+x1?=
 =?us-ascii?Q?WS80mKOyo0aLtZ2w+Pv6g3ARzFwlsUO2H6eHVANoFGRh5dPiXuVZ//GMSrxb?=
 =?us-ascii?Q?OB1rQYcvzgPXxKv+8lBFWyu0S2UD2j3emMw7KFjy0aG8yyCQTorE+vFcP8Zm?=
 =?us-ascii?Q?gGqb8EAq/PhohKiec1GyDMjxXryFRhFhrLdVuptM89S5YFoC/6GqCBgNY6qu?=
 =?us-ascii?Q?LM8BEtFjRBSUwYCGrkR1h1PqDKG5XR7vFqRR0OxtyqmJ0hX9UKf+Pys+jwAF?=
 =?us-ascii?Q?O9L3H4eH8fIqNkjWwAe9KoLf?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc63ab6b-ced5-4cc4-308b-08d97df4f1a5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 18:15:23.0872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0kmTRrUlMUmuVbuJME8M3/YyoheCSTN00a9Bo6d1yCfWMaexxg3L3FDTv9Z94Qo//Kaq6GZYID4/6+KxdaehPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Atheros PHY driver supports quite a wide variety of hardware, but
the validation function for the in-band autoneg setting was deliberately
made common to all revisions.

The reasoning went as follows:

- In-band autonegotiation is only of concern for protocols which use
  the IEEE 802.3 clause 37 state machines. In the case of Atheros PHYs,
  that is only SGMII. The only PHYs that support SGMII are AR8031 and
  AR8033.

- The other PHYs either use MII/RMII (AR8030/AR8032), RGMII (AR8035,
  AR8031/AR8033 in certain configurations), or are straight out internal
  to a switch, and in that case, in-band autoneg makes no sense.

- In any case it is buggy to request in-band autoneg for an
  MII/RMII/RGMII/internal PHY, so the common method also validates that.

In any case, for AR8031/AR8033, the original intention was to only
declare support for PHY_INBAND_ANEG_ON. The idea is that even that is
valuable in its own right. For example, this avoids future breakages
caused by conversions to phylink such as the one fixed by commit
df392aefe96b ("arm64: dts: fsl-ls1028a-kontron-sl28: specify in-band
mode for ENETC"), by pulling the MAC side of phylink into using
MLO_AN_INBAND.

Nonetheless, after playing around a bit, I managed to get my AR8033 to
work fine with all of 10/100/1000 link speeds even with in-band autoneg
disabled. The strategy to keep the fiber and copper page speeds in sync
was based on the comments made by Michael Walle here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210212172341.3489046-2-olteanv@gmail.com/

I wanted to see if it works at all, more than anything else, but now I'm
in a bit of a dilemma whether to make this PHY driver support both
cases, but risk regressions with MAC drivers that don't disable inband
autoneg in MLO_AN_PHY mode, or just force PHY_INBAND_ANEG_ON and hence
MLO_AN_INBAND, and continue to work with those. The thing is, I'm pretty
sure that there isn't any in-tree user of Atheros PHYs in SGMII mode
with inband autoneg off, because that requires manually keeping the
speeds in sync, and since the code did not do that, that would have been
a pretty broken link, working just at 1Gbps. So the risk is definitely
larger to actually do what the PHY has been requested, but it also
requires the MAC driver to put its money where its mouth is. I've
audited the tree and macb_mac_config() looks suspicious, but I don't
have all the details to understand whether there is any system that
would be affected by this change.

Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/at803x.c | 72 +++++++++++++++++++++++++++++++++++++++-
 include/linux/phy.h      |  1 +
 2 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 3feee4d59030..7262ce509762 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -196,6 +196,7 @@ struct at803x_priv {
 	struct regulator_dev *vddh_rdev;
 	struct regulator *vddio;
 	u64 stats[ARRAY_SIZE(at803x_hw_stats)];
+	bool inband_an;
 };
 
 struct at803x_context {
@@ -784,8 +785,17 @@ static int at8031_pll_config(struct phy_device *phydev)
 
 static int at803x_config_init(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int ret;
 
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		ret = phy_read_paged(phydev, AT803X_PAGE_FIBER, MII_BMCR);
+		if (ret < 0)
+			return ret;
+
+		priv->inband_an = !!(ret & BMCR_ANENABLE);
+	}
+
 	/* The RX and TX delay default is:
 	 *   after HW reset: RX delay enabled and TX delay disabled
 	 *   after SW reset: RX delay enabled, while TX delay retains the
@@ -922,8 +932,26 @@ static void at803x_link_change_notify(struct phy_device *phydev)
 	}
 }
 
+/* When in-band autoneg is turned off, this hardware has a split-brain problem,
+ * it requires the SGMII-side link speed needs to be kept in sync with the
+ * media-side link speed by the driver, so do that.
+ */
+static int at803x_sync_fiber_page_speed(struct phy_device *phydev)
+{
+	int mask = BMCR_SPEED1000 | BMCR_SPEED100;
+	int val = 0;
+
+	if (phydev->speed == SPEED_1000)
+		val = BMCR_SPEED1000;
+	else if (phydev->speed == SPEED_100)
+		val = BMCR_SPEED100;
+
+	return phy_modify_paged(phydev, AT803X_PAGE_FIBER, MII_BMCR, mask, val);
+}
+
 static int at803x_read_status(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int ss, err, old_link = phydev->link;
 
 	/* Update the link, but return if there was an error */
@@ -996,7 +1024,10 @@ static int at803x_read_status(struct phy_device *phydev)
 	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete)
 		phy_resolve_aneg_pause(phydev);
 
-	return 0;
+	if (priv->inband_an)
+		return 0;
+
+	return at803x_sync_fiber_page_speed(phydev);
 }
 
 static int at803x_config_mdix(struct phy_device *phydev, u8 ctrl)
@@ -1043,6 +1074,36 @@ static int at803x_config_aneg(struct phy_device *phydev)
 	return genphy_config_aneg(phydev);
 }
 
+static int at803x_config_inband_aneg(struct phy_device *phydev, bool enabled)
+{
+	struct at803x_priv *priv = phydev->priv;
+	int err, val = 0;
+
+	if (phydev->interface != PHY_INTERFACE_MODE_SGMII)
+		return 0;
+
+	if (enabled)
+		val = BMCR_ANENABLE;
+
+	err = phy_modify_paged(phydev, AT803X_PAGE_FIBER, MII_BMCR,
+			       BMCR_ANENABLE, val);
+	if (err)
+		return err;
+
+	priv->inband_an = enabled;
+
+	return at803x_sync_fiber_page_speed(phydev);
+}
+
+static int at803x_validate_inband_aneg(struct phy_device *phydev,
+				       phy_interface_t interface)
+{
+	if (interface == PHY_INTERFACE_MODE_SGMII)
+		return PHY_INBAND_ANEG_ON | PHY_INBAND_ANEG_OFF;
+
+	return PHY_INBAND_ANEG_OFF;
+}
+
 static int at803x_get_downshift(struct phy_device *phydev, u8 *d)
 {
 	int val;
@@ -1335,6 +1396,7 @@ static struct phy_driver at803x_driver[] = {
 	.set_tunable		= at803x_set_tunable,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
+	.validate_inband_aneg	= at803x_validate_inband_aneg,
 }, {
 	/* Qualcomm Atheros AR8030 */
 	.phy_id			= ATH8030_PHY_ID,
@@ -1351,6 +1413,7 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
+	.validate_inband_aneg	= at803x_validate_inband_aneg,
 }, {
 	/* Qualcomm Atheros AR8031/AR8033 */
 	PHY_ID_MATCH_EXACT(ATH8031_PHY_ID),
@@ -1375,6 +1438,8 @@ static struct phy_driver at803x_driver[] = {
 	.set_tunable		= at803x_set_tunable,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
+	.config_inband_aneg	= at803x_config_inband_aneg,
+	.validate_inband_aneg	= at803x_validate_inband_aneg,
 }, {
 	/* Qualcomm Atheros AR8032 */
 	PHY_ID_MATCH_EXACT(ATH8032_PHY_ID),
@@ -1393,6 +1458,7 @@ static struct phy_driver at803x_driver[] = {
 	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
+	.validate_inband_aneg	= at803x_validate_inband_aneg,
 }, {
 	/* ATHEROS AR9331 */
 	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
@@ -1408,6 +1474,7 @@ static struct phy_driver at803x_driver[] = {
 	.read_status		= at803x_read_status,
 	.soft_reset		= genphy_soft_reset,
 	.config_aneg		= at803x_config_aneg,
+	.validate_inband_aneg	= at803x_validate_inband_aneg,
 }, {
 	/* QCA8337 */
 	.phy_id			= QCA8337_PHY_ID,
@@ -1423,6 +1490,7 @@ static struct phy_driver at803x_driver[] = {
 	.get_stats		= at803x_get_stats,
 	.suspend		= genphy_suspend,
 	.resume			= genphy_resume,
+	.validate_inband_aneg	= at803x_validate_inband_aneg,
 }, {
 	/* QCA8327-A from switch QCA8327-AL1A */
 	.phy_id			= QCA8327_A_PHY_ID,
@@ -1438,6 +1506,7 @@ static struct phy_driver at803x_driver[] = {
 	.get_stats		= at803x_get_stats,
 	.suspend		= genphy_suspend,
 	.resume			= genphy_resume,
+	.validate_inband_aneg	= at803x_validate_inband_aneg,
 }, {
 	/* QCA8327-B from switch QCA8327-BL1A */
 	.phy_id			= QCA8327_B_PHY_ID,
@@ -1453,6 +1522,7 @@ static struct phy_driver at803x_driver[] = {
 	.get_stats		= at803x_get_stats,
 	.suspend		= genphy_suspend,
 	.resume			= genphy_resume,
+	.validate_inband_aneg	= at803x_validate_inband_aneg,
 }, };
 
 module_phy_driver(at803x_driver);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index c81c6554d564..de90b22f014d 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -584,6 +584,7 @@ struct phy_device {
 	unsigned mac_managed_pm:1;
 
 	unsigned autoneg:1;
+	unsigned inband_an:1;
 	/* The most recently read link state */
 	unsigned link:1;
 	unsigned autoneg_complete:1;
-- 
2.25.1

