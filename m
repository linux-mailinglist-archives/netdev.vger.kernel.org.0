Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B074929D434
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgJ1VuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:50:24 -0400
Received: from mail-eopbgr660043.outbound.protection.outlook.com ([40.107.66.43]:59912
        "EHLO CAN01-QB1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728003AbgJ1VuW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 17:50:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GO26e4YPSNc/A+hRTewLFX95ALlWlh8HDfgEArMRSlaRUYVfqHpidr8KS/jLbBvDI6VsMscGRIpAqcJVaZsRPq6m4QSwOInhuwxggFVEcAEtjKgFFwlfilU+1PbwZFyIkKkfzyZcCspyJsJ62o2OBNsOo0+vdrtYj4Xdx8tkVL0WUeK1XD+Usz/mgXNX1wB44OsRdgMy7ykR9f0bC5g9n7rfuq263S2tx11WfcR89G92sRLOzGm3L0Na1Do991ce8sGuDVX4b2iuGQPV65ArqzsubFSiN09+pocp29+hLrjB2/vPi3JJ0rgXiZr7AQJNRM9Whby9BcDY/niqWbcPbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMsFwGw6RQ/aZa5KJj/CcmXXgJ1C/v8XQ6x1CMcF+kw=;
 b=EhEumAk3+W7oBbMnk66hwbhGLjX4ROo94zJibDra6RkqVQREaWM/BGmC1WGvysy/W4lBpZ9Qg/5A1Q+BoOlXQbzQJthCUl3kE6c5cekgqOa7Fc8h2+Q8qNKv1Xe+M3GAgVJJL74etI3A/SLHil5Es1z4ToKvFlqHx/Hb0J6BpDmPXIT+Z5a3VKOAlo4kieuSmGczK/QHDI4+ISzOMrpfj/mBD5wRvpQtVC9yyULuEnmdhwK23YHR9o7YCuxfzmA0VaDjhTXXafFX5W60fl8fSqhWUwV9x19srQrAm2a0vO0tuqJauuTgvKeUqe4GlWtJd8xNWz0I92HRhnrqD+afKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMsFwGw6RQ/aZa5KJj/CcmXXgJ1C/v8XQ6x1CMcF+kw=;
 b=YPmHAaW+nBX2nH2BrPUyy091hxfEAAzzP2dKyboCwxhToKURQVDsvtzi72olqd6JPsSM9sUbqCgg8Zmo9YOQxRUK1sPsFX424PTvmMCltMM7AxnUJPwPIlmUhmGdRt3pik5D0zCeRci823wBzBZJfadrzbkVeIPS4L7ThUb87C8=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTOPR0101MB1753.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:20::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 28 Oct
 2020 17:15:58 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::5c60:6462:fef4:793%3]) with mapi id 15.20.3477.028; Wed, 28 Oct 2020
 17:15:58 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v5] net: phy: marvell: add special handling of Finisar modules with 88E1111
Date:   Wed, 28 Oct 2020 11:15:40 -0600
Message-Id: <20201028171540.1700032-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.18.4
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YT1PR01CA0112.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::21) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YT1PR01CA0112.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 28 Oct 2020 17:15:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1f9d4a5-9bec-40ea-0766-08d87b6522e4
X-MS-TrafficTypeDiagnostic: YTOPR0101MB1753:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTOPR0101MB1753BC834DF66C66CAD080C5EC170@YTOPR0101MB1753.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N5EUdw9jBih9+uH/8GSCfxjlOZ5UFHMtiNRaDlO1KMQrACLJE/Bfs801UOoBtnnDVGHTdH9SgawQQjGt5SidD3q68vaNnZbOI11h4EpeFHilgplwnzbJphVI96SbSx37fayOTPXE0ANJZ/FDb5ue2XDtqmS5AlR1Q7nqNIg/m4+MCysFPGC3XhRgbFq1XowJUSvyLWwURMB/qILOXGxN/TERlXNrvM+rWDmCZ+4vjgSqJEbIXzh9D7Kpb6PkuIQDh/twSc8uqkcgpy1TkjMC2ZPS7RIbVmFho1zdDTFQQdZ0j/lKLYwZ+vsCbS7WsenpYqkXLPUFMbS7bbpNlwtjvHU/S4slFm2p4TYv8DDYckTa4AKoJqzTMUr1MsX4LuoL3Xrb+K66+GJYt5/ffjOypMflgMCNBcTBJvS9kwH8NKMSu0JLEbonZC5dmYFSJRH4eSGZsHvTdWKHJN+rPPqg2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39850400004)(366004)(346002)(66476007)(478600001)(6666004)(66556008)(36756003)(956004)(966005)(2616005)(6506007)(66946007)(1076003)(52116002)(4326008)(16526019)(186003)(86362001)(107886003)(6486002)(316002)(44832011)(8936002)(26005)(69590400008)(2906002)(5660300002)(8676002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: r7m55VVm/f3TH5K3nVuUhqBqhl1cXjOXiPJ4Oh7MPTBxBVuRZgajurq/HOiTI832Ygk9qiaMcsgW95xnIyjXxjRzax+ablYxsZjhoRJ3F8g6Cts/FSDBL2Z6exhCmi4CyMD+j4xHGfK8r5gtaBoUXFS+wFVByIZQfBLYD9XCOiX8h8ZVxGwV04paPZjX/FD42Lj5YaUHHLFjDQ9m19dl+6EIOZbMwWGsgyB/OlXq80Jaj2ZMGeMB+e8dlFZh5v6ezBqppPSOs5RqeXXxOBKZLZ36cqNnlOp4yVI+MRF27fec3b3JW7iaPQCDUKpDKD9q/QnQLnOZwmW/wzIkNgw8PKmxp+R0KPdoa9jqMlwnSX58rgLDHWN3cnnY6+GqYtrfuqs9tufW+Sqz/QCNhMslu6C1O/0dsg4YsIXILjFATdKpDiN3yIZTfJDWCSd8MT8w48UijQlA6p3qfNCtX9GflKStbW01m+/PnlvSuD+Mdh2qILNvg6U7JqGassk0YXM3ZGMCBdSBODJUYWsejCAwZ7ihPvJnaQRWWmFU1CaBGd53cRq78swxt01fJKkxeRjhcReUJu9e2wT1A6ZaQl3c6KFTeRn2LJNcQmslcFCs6Vf4TpEy56OmRpkdoo6dphbzt0QpKOxepP3gvOAELn0poQ==
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f9d4a5-9bec-40ea-0766-08d87b6522e4
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2020 17:15:58.1627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t0FXUKtA4CtK4bQpu2yvLAI4gpMQVxRp2Mt604cwvPU4ab6utRhso0ruO37ULtM016hsMSFJZzTZhsEtEEwKKp5zoZWn6jzIYXuj7dUS5zQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB1753
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
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
---

Changed since v4: Fixed coding style in m88e1111_config_init_1000basex.

 drivers/net/phy/marvell.c   | 100 +++++++++++++++++++++++++++++++++++-
 include/linux/marvell_phy.h |   3 ++
 2 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 5aec673a0120..1f062e6699c8 100644
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
+	int extsr = phy_read(phydev, MII_M1111_PHY_EXT_SR);
+	int err;
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
@@ -814,6 +862,28 @@ static int m88e1111_config_init_rtbi(struct phy_device *phydev)
 		MII_M1111_HWCFG_FIBER_COPPER_AUTO);
 }
 
+static int m88e1111_config_init_1000basex(struct phy_device *phydev)
+{
+	int extsr = phy_read(phydev, MII_M1111_PHY_EXT_SR);
+	int err, mode;
+
+	if (extsr < 0)
+		return extsr;
+
+	/* If using copper mode, ensure 1000BaseX auto-negotiation is enabled */
+	mode = extsr & MII_M1111_HWCFG_MODE_MASK;
+	if (mode == MII_M1111_HWCFG_MODE_COPPER_1000X_NOAN) {
+		err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
+				 MII_M1111_HWCFG_MODE_MASK |
+				 MII_M1111_HWCFG_SERIAL_AN_BYPASS,
+				 MII_M1111_HWCFG_MODE_COPPER_1000X_AN |
+				 MII_M1111_HWCFG_SERIAL_AN_BYPASS);
+		if (err < 0)
+			return err;
+	}
+	return 0;
+}
+
 static int m88e1111_config_init(struct phy_device *phydev)
 {
 	int err;
@@ -836,6 +906,12 @@ static int m88e1111_config_init(struct phy_device *phydev)
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
@@ -2658,7 +2734,28 @@ static struct phy_driver marvell_drivers[] = {
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
@@ -2989,6 +3086,7 @@ static struct mdio_device_id __maybe_unused marvell_tbl[] = {
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

