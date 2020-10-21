Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A602945EA
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 02:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393566AbgJUASi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 20:18:38 -0400
Received: from mail-eopbgr660057.outbound.protection.outlook.com ([40.107.66.57]:38274
        "EHLO CAN01-QB1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393433AbgJUASi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 20:18:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Du3YtAQdVF4SsQVCBsBYhi3q/Xb6F4AkNDBtFexnhD9w4kOFKvzG0ra/Ed6hL9iJR0ZEydydkGGIcjQHoe3aeksfj8Rj/yoRfTj8qDYZaGXMJ8uaHMUvZJP8ZdgjRFVNEJP0ANG4dOtH6EMP5/yr5OefyIFx3sH42VpRirSF46z7MXGoUrs7p3uiMM283kQhS2w+mkq+gxxSaiAeq9zPksr6Yv4NKsUnil963QTHzVJ74mf4zO2fhRP9xv3LqqLzdTWWm/dCfhs1vGX6HpxBn6+WWprKI1FS7hvQsaqu6oVyVeqjG4rxmcRzEnF/OzAc83XLDaPV3IW5M9Igz/curQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iidhGDKRqvNMJxY1t0kek/MbhrkF3ugYgAgbNDOpFVc=;
 b=nlM/O6x8TX39D7pg6YBbe4V36HY2mM55Ni85UyPvpyymfQ8B3nByqOSa+29+0OKqnpoW3TTT0k3S5RUsd2VQ4BVlaUDeNAtnnjI5ohGlFx4UmFE00bU4ANp1kZSd2/eHx/jGeOZKOSLpQg+ffuruzdBU58baE/XPJ1D2GCztOp7N3EMWJtPu7Hg9ewQwS4FxNLXpyhwg4jjoRi08Fnwwoc9pHYpDIXWeE7kblDNnlR9t8WlpWDIfbExBkU9HTZ4+K9z61u0sdqNSMQ3ifMpNobFSbcbKkx7E3n90oF1hvyMtaYk1gBLTAKNbeoMaKffO6Trr1PNOfdlb2FhV0TVbBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iidhGDKRqvNMJxY1t0kek/MbhrkF3ugYgAgbNDOpFVc=;
 b=ayrr/GcoRLHS9QECJIlDxJhHlIKjmaWUQYhANOQoiBzlOURZH7ZUiP6wbf2djHPxkrd1yqGA733RHt2HvjJ6XLH4Dzh67pIBO1dB6yyHpUwrPz7XG/0cqlIa1q/mh+vPsxUZSHrrLNrwTNYpL/5tLMl089lzvNuEd2Noz4lpQ3o=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB3039.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:22::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Wed, 21 Oct
 2020 00:18:34 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 00:18:34 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH v3] net: phy: marvell: add special handling of Finisar modules with 88E1111
Date:   Tue, 20 Oct 2020 18:18:21 -0600
Message-Id: <20201021001821.783249-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.18.4
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: MWHPR18CA0058.namprd18.prod.outlook.com
 (2603:10b6:300:39::20) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by MWHPR18CA0058.namprd18.prod.outlook.com (2603:10b6:300:39::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25 via Frontend Transport; Wed, 21 Oct 2020 00:18:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b86ff30-132b-4f5a-43d2-08d87556d8e8
X-MS-TrafficTypeDiagnostic: YTBPR01MB3039:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB3039BDD1DF90F911A9F40B72EC1C0@YTBPR01MB3039.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oi4OCvgIk0E1triBbaDXQJl7N5ZIkExVCQZPPbeD1Rhfg/6o3jyGJiFEzS15qwLlFsBzC5J7e+JzHyemwiQY7dWJKE+c9SZYTUno1DG0OVPcv1juAhgrGPeSLe3hT3f98C01b2SdHLBmvHFbsGuyGvsPPLMFfCwlm9zkaMcYlpJbtaK/L2Eqg8nFyzpnXxK7kIxLyj6e1iQlMKx3T0O+H+WtagCC+2QSkWI0z1eTxyetB1E/39uQf0npN5KfXsRzodKdnVgVfkcUEZHh8X59qC5tlMC1uoR+jAdYRKgSX5pr7rJj7Gfbir1i77xRWRmSabE+jkR8JeUriFTi3q6kRPMBI/rn+500YZWpp/yn0PXDP+nohISdmrYFrZaNebR+DdiK+7A19T+Iw2ZHCFm/w1EN/ypRHpEHHcdgNKQ8FFRZ20dcmQS9lWa5xb9YG6oDloLsrPShRyNDl1EW8211ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39850400004)(396003)(136003)(2906002)(1076003)(69590400008)(6486002)(6666004)(66946007)(66476007)(66556008)(5660300002)(316002)(83380400001)(8936002)(6512007)(8676002)(36756003)(44832011)(478600001)(86362001)(966005)(4326008)(26005)(186003)(16526019)(107886003)(956004)(2616005)(52116002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fD+8/f9ZCxOErn1FTOsLR5smQWSCR+ggQtgx5Yc/ZJoEvOrxB80SWSBz3NncMEPeoqNErM/dNaunNxlneZFA9OSb4be/l8+wHgXm6yq789zjIrXzLbhVTRkz4P7L/t0Xpfz89+U5D9MidsFSfx2fweD55AKms9CnYMQbSB4hhbnr9wMGyEOeNcmN9d2U2kNXIujxcuCjlpjM2vfSY5CMf+kCQO/DhUTl8aOcEb84kxEFnzQfx482rW8N6UDbbyBQbEDtnMFEXFNySFciuGENNhMJII24uXBGOjCncI7alTSVASS9MOH332p+bryil9UiNpYTvv81aOylOkOACRNw6PPnDS2s9P9VqOtscO2UW87cpEMXLXWI0z0555WFDGpQH3jqz1sk4WlqrUdQ9/3AVTGrCxwfoVttSmlfWVdidjjCY6UiVFavMeZBt6ax7nD9lxrG0nGWw39JBnthqfqbf4AaKl9bsovGqVPPTddhfwugyaU8Y0PZJiaXFdDSiZf5TwoMQtJ2EsMqcaJ/Vz9qS/mvlaCElp5YTfTL0QACn1To5PqOm08n+bGw0H/NO485YFgKBNj4qVP+TK/zXntZ0b3zJzoi1V2p058vWxKlF9pYYiX1lESds+39LDDnwLcZOPXIRkCMRS80D5/MIwo+3g==
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b86ff30-132b-4f5a-43d2-08d87556d8e8
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2020 00:18:34.1391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8wl+H6+TxHAFlqhXYNErLx2YuokCl/IIe3UDGSip5AgGK2tDQOYhYb7kP3SVe+exAQpnAkiDM/t2sHqKozZX3X0MZjcWcziU5cTsJ6t1oWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3039
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Finisar FCLF8520P2BTL 1000BaseT SFP module uses a Marvel 88E1111 PHY
with a modified PHY ID. Add support for this ID using the 88E1111
methods.

By default these modules do not have 1000BaseX auto-negotiation enabled,
which is not generally desirable with Linux networking drivers. Add
handling to enable 1000BaseX auto-negotiation when these modules are
used in 1000BaseX mode. Also, some special handling is required to ensure
that 1000BaseT auto-negotiation is enabled properly when desired.

Based on existing handling in the AMD xgbe driver and the information in
the Finisar FAQ:
https://www.finisar.com/sites/default/files/resources/an-2036_1000base-t_sfp_faqreve1.pdf

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---

Changed since v2: Renamed 1000BX -> 1000X to avoid confusion with 1000Base-BX

 drivers/net/phy/marvell.c   | 99 ++++++++++++++++++++++++++++++++++++-
 include/linux/marvell_phy.h |  3 ++
 2 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 5aec673a0120..f9cef5ef6f5e 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -80,8 +80,11 @@
 #define MII_M1111_HWCFG_MODE_FIBER_RGMII	0x3
 #define MII_M1111_HWCFG_MODE_SGMII_NO_CLK	0x4
 #define MII_M1111_HWCFG_MODE_RTBI		0x7
+#define MII_M1111_HWCFG_MODE_COPPER_1000X_AN	0x8
 #define MII_M1111_HWCFG_MODE_COPPER_RTBI	0x9
 #define MII_M1111_HWCFG_MODE_COPPER_RGMII	0xb
+#define MII_M1111_HWCFG_MODE_COPPER_1000X_NOAN	0xc
+#define MII_M1111_HWCFG_SERIAL_AN_BYPASS	BIT(12)
 #define MII_M1111_HWCFG_FIBER_COPPER_RES	BIT(13)
 #define MII_M1111_HWCFG_FIBER_COPPER_AUTO	BIT(15)
 
@@ -629,6 +632,51 @@ static int marvell_config_aneg_fiber(struct phy_device *phydev)
 	return genphy_check_and_restart_aneg(phydev, changed);
 }
 
+static int m88e1111_config_aneg(struct phy_device *phydev)
+{
+	int err;
+	int extsr = phy_read(phydev, MII_M1111_PHY_EXT_SR);
+
+	if (extsr < 0)
+		return extsr;
+
+	/* If not using SGMII or copper 1000BaseX modes, use normal process.
+	 * Steps below are only required for these modes.
+	 */
+	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
+	    (extsr & MII_M1111_HWCFG_MODE_MASK) !=
+	    MII_M1111_HWCFG_MODE_COPPER_1000X_AN)
+		return marvell_config_aneg(phydev);
+
+	err = marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
+	if (err < 0)
+		goto error;
+
+	/* Configure the copper link first */
+	err = marvell_config_aneg(phydev);
+	if (err < 0)
+		goto error;
+
+	/* Do not touch the fiber page if we're in copper->sgmii mode */
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII)
+		return 0;
+
+	/* Then the fiber link */
+	err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
+	if (err < 0)
+		goto error;
+
+	err = marvell_config_aneg_fiber(phydev);
+	if (err < 0)
+		goto error;
+
+	return marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
+
+error:
+	marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
+	return err;
+}
+
 static int m88e1510_config_aneg(struct phy_device *phydev)
 {
 	int err;
@@ -814,6 +862,27 @@ static int m88e1111_config_init_rtbi(struct phy_device *phydev)
 		MII_M1111_HWCFG_FIBER_COPPER_AUTO);
 }
 
+static int m88e1111_config_init_1000basex(struct phy_device *phydev)
+{
+	int extsr = phy_read(phydev, MII_M1111_PHY_EXT_SR);
+
+	if (extsr < 0)
+		return extsr;
+
+	/* If using copper mode, ensure 1000BaseX auto-negotiation is enabled */
+	if ((extsr & MII_M1111_HWCFG_MODE_MASK) ==
+	    MII_M1111_HWCFG_MODE_COPPER_1000X_NOAN) {
+		int err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
+			  MII_M1111_HWCFG_MODE_MASK |
+			  MII_M1111_HWCFG_SERIAL_AN_BYPASS,
+			  MII_M1111_HWCFG_MODE_COPPER_1000X_AN |
+			  MII_M1111_HWCFG_SERIAL_AN_BYPASS);
+		if (err < 0)
+			return err;
+	}
+	return 0;
+}
+
 static int m88e1111_config_init(struct phy_device *phydev)
 {
 	int err;
@@ -836,6 +905,12 @@ static int m88e1111_config_init(struct phy_device *phydev)
 			return err;
 	}
 
+	if (phydev->interface == PHY_INTERFACE_MODE_1000BASEX) {
+		err = m88e1111_config_init_1000basex(phydev);
+		if (err < 0)
+			return err;
+	}
+
 	err = marvell_of_reg_init(phydev);
 	if (err < 0)
 		return err;
@@ -2658,7 +2733,28 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
 		.config_init = m88e1111_config_init,
-		.config_aneg = marvell_config_aneg,
+		.config_aneg = m88e1111_config_aneg,
+		.read_status = marvell_read_status,
+		.ack_interrupt = marvell_ack_interrupt,
+		.config_intr = marvell_config_intr,
+		.resume = genphy_resume,
+		.suspend = genphy_suspend,
+		.read_page = marvell_read_page,
+		.write_page = marvell_write_page,
+		.get_sset_count = marvell_get_sset_count,
+		.get_strings = marvell_get_strings,
+		.get_stats = marvell_get_stats,
+		.get_tunable = m88e1111_get_tunable,
+		.set_tunable = m88e1111_set_tunable,
+	},
+	{
+		.phy_id = MARVELL_PHY_ID_88E1111_FINISAR,
+		.phy_id_mask = MARVELL_PHY_ID_MASK,
+		.name = "Marvell 88E1111 (Finisar)",
+		/* PHY_GBIT_FEATURES */
+		.probe = marvell_probe,
+		.config_init = m88e1111_config_init,
+		.config_aneg = m88e1111_config_aneg,
 		.read_status = marvell_read_status,
 		.ack_interrupt = marvell_ack_interrupt,
 		.config_intr = marvell_config_intr,
@@ -2989,6 +3085,7 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
 	{ MARVELL_PHY_ID_88E1101, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1112, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1111, MARVELL_PHY_ID_MASK },
+	{ MARVELL_PHY_ID_88E1111_FINISAR, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1118, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1121R, MARVELL_PHY_ID_MASK },
 	{ MARVELL_PHY_ID_88E1145, MARVELL_PHY_ID_MASK },
diff --git a/include/linux/marvell_phy.h b/include/linux/marvell_phy.h
index ff7b7607c8cf..52b1610eae68 100644
--- a/include/linux/marvell_phy.h
+++ b/include/linux/marvell_phy.h
@@ -25,6 +25,9 @@
 #define MARVELL_PHY_ID_88X3310		0x002b09a0
 #define MARVELL_PHY_ID_88E2110		0x002b09b0
 
+/* Marvel 88E1111 in Finisar SFP module with modified PHY ID */
+#define MARVELL_PHY_ID_88E1111_FINISAR	0x01ff0cc0
+
 /* The MV88e6390 Ethernet switch contains embedded PHYs. These PHYs do
  * not have a model ID. So the switch driver traps reads to the ID2
  * register and returns the switch family ID
-- 
2.18.4

