Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E9E2942C0
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 21:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390695AbgJTTLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 15:11:07 -0400
Received: from mail-eopbgr660076.outbound.protection.outlook.com ([40.107.66.76]:47360
        "EHLO CAN01-QB1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730430AbgJTTLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 15:11:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LaUMJl0BcprFkTxilYIB+Lwc+auoP6MSTtnO+y9GgUBQSIFvvOIDkW5jJVahjofspL4//BOqWfEpLz+UdjXRMnblIFit9VmyUMhpJ8kzOQDb+XTZRbDgCVIc1e6ch6lMkFaLrfG5njNzxb4CnYKkwVuaL/H+MbYyIRr+mV/9oswvKPvgOcDqsX4VGLbd7HBO7P3rTWh9J7vRE+i/pkW0wptHDnfSuNyatHtetVMyX1cmdg6AUaGU040thb5DIfTtZxxCVKb/qkZ5qA76XpPFsH847hVndPAoJb8epiFq1jDykaJ2qhL3DarXLY6NC9njD/rAA62lorAAvWdyf5dr4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tKw9Vk+m2zj0xTJHAJrF/10ErdvqTnJRLYjtHd0JPM=;
 b=J1XYguB8mMlS32EVfR3PIPneZt7x4zPW+AmC/NRRnJDGVx142HsalRtcj8Cfpv93HOEDA0qebtErSPa3Vv7/Som5+r2qSL3MJcIJsEbU+plK9c64k2aplgRc+TZMoxkKSEa7kzxXA5bAISM2JSKKZUd8Qx8B77EXilPrd4eX4g1fwFRAA+pc7kBFkFT5n/13PO70+odXv79Cg2m9bQAtxvcsvy4Fm8JO22y8E/gG4iS/z7r3tG9n7hr+hNAM7Rt0Doa8Dji39o7JP+egVIfLLBb9hmz505o6n3ihSTSFmra6HFz6fVmg9zY6rl0cZGS0uPzL/Esrr5S+4lRN/dmjRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tKw9Vk+m2zj0xTJHAJrF/10ErdvqTnJRLYjtHd0JPM=;
 b=XLqZ/SIK0kkLvPLzfJOlE9KUaXLStuwY5a4fywGcIYiu3T8vxVS9G6o1CbhhmVDOB51X+yFwkpU/UrNLz3Jh4AyvvH9r5jfamtwsNwIq4/3/i4yIaPHV6Rv9aiPOMBoo4tfPgKMotI93pX1M2oRz/BDXPCdjodQKdchOlbbUA9A=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB2558.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:15::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Tue, 20 Oct
 2020 19:11:03 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 19:11:03 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH v2] net: phy: marvell: add special handling of Finisar modules with 88E1111
Date:   Tue, 20 Oct 2020 13:10:48 -0600
Message-Id: <20201020191048.756652-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.18.4
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: MWHPR22CA0069.namprd22.prod.outlook.com
 (2603:10b6:300:12a::31) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by MWHPR22CA0069.namprd22.prod.outlook.com (2603:10b6:300:12a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 20 Oct 2020 19:11:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88bd34d4-4e20-42ce-506a-08d8752be32c
X-MS-TrafficTypeDiagnostic: YTBPR01MB2558:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB25580C2482C464E0C92A7AF4EC1F0@YTBPR01MB2558.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5xPpnA9c/WOqS2Mbhel9CamKCnFD+uzP/8/yR89Y0ViCewgLsxekIlVbdkVf7GAjZbCaE5xGWb5SE4gJre548sHnj2jeUUCCTiQ5Idz9tpUiBySli6AOcYWyKpadNIWmTFdXGsgZglnepjOig5ruFw/tRbLbovEKZdh+SIXg1wvW2hURYZqXPJyyVPVT24aOYnfBFtpK/geSngnlHs4FbSsDu2RyQki0xRHJv/EVBbty2jpgF4mJlm5AkiJkMSSQdeiO6kamNF7FqgKRK61KJh1t6LFL9wXe0KfKovQqbOFHganHqktMBS3ex6tgLJAksXEBw3jjEjAJkKXfYezJ0Tw9M6Gt+wLsRtFOLZp3T/2aaydxN7dV5YmjL6JhPCO8HHZt7ZwIkIIYlL6TGV0pIacUrv7bRESSXeSF/G5C9xfsXBRPtqn9my90v/wSvL395J+OgHzNMQ3DYTwRryg2qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(366004)(39850400004)(66946007)(6486002)(8936002)(4326008)(8676002)(26005)(186003)(16526019)(69590400008)(36756003)(83380400001)(107886003)(6512007)(478600001)(86362001)(2906002)(44832011)(66556008)(966005)(52116002)(66476007)(316002)(6506007)(1076003)(956004)(2616005)(5660300002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: g5eUFumI9SEWDAGp6U90WqzLlGhEXWOcpA51/X636ocGbbSlOBuF/d1F8yT9qWdQGub7mJqtiJmJvQwXKlhmiNnoqrD99Dl/r5peBRBQr+3JHsnMuWEIRi+2Ov5vEkVddg68xxYXrjb37QJAShLqOo+7nbe9nRhuJInPdqlAxvHRnVQ7Y/vytAeoWXiSDBsU4jCmomxaFs72JvI1F+h9yXYYLVjRMPa/5vcNbFrcDmS9TjhKSqIVwKafF8uEvm9bNbTuSVf0GE3C63it5yV+wFrOdtM+XcPLRyg2/SsFEpddsPTKJN1a/7gzczPhdN+pyq1QFTw+Wa/5q3dsVymlDnl0tzd56GicrICtCxtE3t34aUIkDaii3VLfRvEhLyBsqxw+dsLNE9qxKTo7Oaf4dXtzeOnueDUbDhGFYa5pDlkWpN9jtXkFPVoxUInYWjhwz40UM+ELRJ+dprsY79NJt7m1tlCSYPkgy7OTHuPb3k/HNS/AmmLQ9D0YiB8ZdUS3pkfj80MNqPeyv+gRM0I0sU/XjRjM3AfTuwHmJMEaX9QsLgz24wjS53LxW0e1ZyqxkXjfU9ZU6YfhUy91gBzYFKdXXZzjHLdvR8FgpMsY9GAdiXvCKIfKYjaeRne8nSQV+twG/VcQLDuSjhjdqK47Zw==
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88bd34d4-4e20-42ce-506a-08d8752be32c
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 19:11:02.9949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMtvG5LeYx7q7Bm3Stj62tSdDtg+HAPOppntkN1xH3+vcEfVQysLfkuWyrcgFDq8VstlJ3Q1sB5uQJVQnSnD6IFcRC9Yk4WIjQJZp9jGCP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB2558
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
 drivers/net/phy/marvell.c   | 99 ++++++++++++++++++++++++++++++++++++-
 include/linux/marvell_phy.h |  3 ++
 2 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 5aec673a0120..49392d15035c 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -80,8 +80,11 @@
 #define MII_M1111_HWCFG_MODE_FIBER_RGMII	0x3
 #define MII_M1111_HWCFG_MODE_SGMII_NO_CLK	0x4
 #define MII_M1111_HWCFG_MODE_RTBI		0x7
+#define MII_M1111_HWCFG_MODE_COPPER_1000BX_AN	0x8
 #define MII_M1111_HWCFG_MODE_COPPER_RTBI	0x9
 #define MII_M1111_HWCFG_MODE_COPPER_RGMII	0xb
+#define MII_M1111_HWCFG_MODE_COPPER_1000BX_NOAN 0xc
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
+	    MII_M1111_HWCFG_MODE_COPPER_1000BX_AN)
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
+	    MII_M1111_HWCFG_MODE_COPPER_1000BX_NOAN) {
+		int err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
+			  MII_M1111_HWCFG_MODE_MASK |
+			  MII_M1111_HWCFG_SERIAL_AN_BYPASS,
+			  MII_M1111_HWCFG_MODE_COPPER_1000BX_AN |
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

