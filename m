Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4FA3B8849
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhF3SYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:24:11 -0400
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:14858 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232694AbhF3SYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 14:24:11 -0400
X-Greylist: delayed 1164 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jun 2021 14:24:11 EDT
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 15UASanm002486;
        Wed, 30 Jun 2021 14:02:14 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2056.outbound.protection.outlook.com [104.47.60.56])
        by mx0c-0054df01.pphosted.com with ESMTP id 39g3ve0s3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 14:02:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjTriUkXPHf9tzBHbmzR8yMixR4jdE58GctkohrQ/7DmywO2Rm91m6hqrp2bA3zvS0lN/K7hsbPOmicWdgra5Z6VZAsoPhDMBKLfdJ4VQ8hrb+6nz3J2aBejY71XxRTb4Ez7ASOAsCEup0dtWGKWQ71GBpiH+L5NkahN4QcD4+L8y4zUOLSQwwrRrsKz0MHx6Xwm0uRW/fUGfhLo0iP5VOmjZbhr6fkRE1Qz32srXpoPSmMaopktZbKP1EQNpzXCoW3NzN3KCjNERhPgUAXp48PGw9nFfgTlte/gCxPxrkbxh6nhOg6/9kO23g41gc/xvW3/bwcb1xpOWt+exZ2Qrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWc6V2+PPKBVDqY+32B1uelob0EbtcK0Kda7TYwKQaE=;
 b=J4ekhbTQOjfeiVrGE3vyvHfE57S8dhamZIPLkyfqrqi/wvLNVx1FgeHfJRgkV7tShW+XSSK4RkYQe1LO1qsx+ZT0r8vVYQnSP/8O5BaFKaE9xRzwDhSfPim6Rbt1RIe7C5PNLZkWJbmSn/9w+GdsAqPbC7iql9W09ZlNx2GcGEdguV3gPCmSr7yF3AviX/BferYtl0jXZdtyaKk2HbKrY3U+6lGIzu/ioAXKQlgwwqQxTfebo+3CMi/RKWbo4YkY/qJw2QZdhIoWzb4jnllBtYFJQkpV9toIZL4g6Li6aSgVJBybFb3iQnV6uJTR6NHeVg8V75fZrFmU1Dhva1jlNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWc6V2+PPKBVDqY+32B1uelob0EbtcK0Kda7TYwKQaE=;
 b=5kJeCfNdCojrC30iigMjA9lttHRffA6IpcoEiJ/PYBwQGrQSzlpnlWalmYdN21NiItJ9F+ql81Vsuik6/emzuxXpgkfu/WZjUTsu/s3RdY0TuFQiSAUfBLz6cGd7K0yuv+QhLDv77gxdj81U5IA9BjyOxou0yHXVOIUMkkBFj1g=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:27::23)
 by YQBPR0101MB4569.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:14::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Wed, 30 Jun
 2021 18:02:12 +0000
Received: from YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::88bb:860e:2f3a:e007]) by YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::88bb:860e:2f3a:e007%5]) with mapi id 15.20.4287.023; Wed, 30 Jun 2021
 18:02:12 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 1/2] net: phy: at803x: add fiber support
Date:   Wed, 30 Jun 2021 12:01:45 -0600
Message-Id: <20210630180146.1121925-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210630180146.1121925-1-robert.hancock@calian.com>
References: <20210630180146.1121925-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: MWHPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:300:c0::21) To YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:27::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from eng-hw-cstream8.sedsystems.ca (204.83.154.189) by MWHPR08CA0047.namprd08.prod.outlook.com (2603:10b6:300:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Wed, 30 Jun 2021 18:02:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40ffe92b-53f9-448d-11c5-08d93bf12f99
X-MS-TrafficTypeDiagnostic: YQBPR0101MB4569:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YQBPR0101MB4569C8B8A6859972E0076233EC019@YQBPR0101MB4569.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D/O9vmEhvV2S8E657kQMgI4IbYbdkP/LdY8WhSPbubcpCdgNrW/mAWJv9UWP0OxnjVSix+hlmce984dtY19xiKdV/GwtJzx7q/QdWBRRdauM1G472N2N/wJZ13lY7TWo9QJTyZPTEtJ4fUWjFZEaEXO68zBjRIWEbtR3LQKSsfOnEvZk4FY3ezrmmqqKZ0Lm87yGnT5fVVpAeE02j8WYX/rZ0zrcZysLXb6sle8NJoRFHwii/1SmtnrnAZ3Czf5wsHQh1iyh+IWujUllNKufqyA6qcPNEepVaB9NGG/utj4+O/pzMq/VGlnc6eLQ/ssRrDFELbLouOu+D+5OKQrNQA6O14V/tE2/j7giPilTFSFtqFP3fS6uvR5Q8/sxqSaxdXbqBhn3w1s7xNg6m2ppVX7KlOe1YwY65iTkjQBR60CsWqroyp2T+It4sWwi6NRjIWrXoBvC39gAYlRlKYoOsdjkizJ45G4x9Bi87Dza3DXjWOAthXfXA1v9AD1j4TSt40yjcvnqC9g3oZ3zbaG1TjeAiE9bVtNGYI1rlzEjdSxEp/j/tykybmngy+12rvLJh8QQcp2gCDMaSomHrenCi0oX3/6rr70VJIscDPFeGYP7BwfkOc4znZLAoQ9uTLWL888vPmFPqrJVksp/jCKoYoOdc+EcYQRRtZ3z4od8hS8VMGBphRKH93RwVGSLxWedigJeZ+I8HsfPBobbY0Gm2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(39850400004)(376002)(396003)(5660300002)(16526019)(86362001)(186003)(956004)(2616005)(1076003)(478600001)(6486002)(38100700002)(66476007)(44832011)(6666004)(83380400001)(36756003)(66946007)(66556008)(8676002)(38350700002)(4326008)(2906002)(52116002)(107886003)(6512007)(8936002)(26005)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ug2MqNGXS/805zvIE56PzXE4NJdqdkPuMjHOhlt0seWnpUjGe9/dzEt4P9tG?=
 =?us-ascii?Q?1k4b+mK+eDLicbPxzKxC6Fy+VanxYiJ+xzITa/GahzURJ04m343c/CWlaVAK?=
 =?us-ascii?Q?kKutfdpEUusuV7RfKuUTOvtx4i1HMpjoHgH6Rl/3XJr83eKFx1m7WEYJYZB7?=
 =?us-ascii?Q?FwyEp1jHJxdaAB5rwG4Zg3XA/WwK8V++trZoy5vd2I/7OnBDksNQyKsrIAtU?=
 =?us-ascii?Q?LIcw+nOJvwtorzM8NHdz7uUqSox2Ak/dlwVGsiForI6kmHaYfHLgEzbTdJ1c?=
 =?us-ascii?Q?lBmeStbpEy5G30mY5ubGHyxpEkkqQJ79BkwNjX2hVuXX0dRLkl5Vw8jotvVT?=
 =?us-ascii?Q?T+E3Zhyad5BLdCELvv1F6fwmmq2zGc2Is0c6aGG7LTfNHt2t0vWKN73W6lTN?=
 =?us-ascii?Q?Jo9PXduZbGJYNRRDmrFcXjG6XmIEa8HdMjvMQH3Q6B0mXewp5639s7+LIWjT?=
 =?us-ascii?Q?AsGONiJZkj1+SMl3Uao5JQLo5iLQACCoCJ2Rmyk9UtTEXPoq02yfxhoQoXvs?=
 =?us-ascii?Q?wAFk1VvqbejOgeUQM2/6t+2Jl1GParYwDUyYo9sqL1v6jW/tyvDSlKXm+b0f?=
 =?us-ascii?Q?/jeNStdOt1cqJ6hkTLkZ5VD0fqwK3hX3BKmdOw4vqiC/gpYiUxPAyTtaB/AE?=
 =?us-ascii?Q?h8lKdSdTLaqhRfxOnN4maTyqTqJBZrJ9D7O46XJQt+wtraOsvaMapk8JxiwW?=
 =?us-ascii?Q?al/0Xc39q7vgRX/N7QDep5HXND54402LkP7NPmP4aKiNAoLt/Btlsa2upnub?=
 =?us-ascii?Q?NeJOyNUNaPvo2UGKHTM/8OJPNSQQ1tW4fXfyadLcwGlMkkWvD26X5RMr1Rhc?=
 =?us-ascii?Q?zEpWRheseiQ4ZBbeGev7CcEe8fqcYHLBBwW6rfxLTsb4G8N6f0EFPeW4GX7R?=
 =?us-ascii?Q?Bk8Mw+mAaBwjM56atU9vTBbjspawQG8Jljy065dAmaMI+38WEk1DZ1CnEAQV?=
 =?us-ascii?Q?v/r5vatify2lHyXe2m4AQMda0G1XKQ0NMPVnUHwqyTy4SELwgnBXcqoKtCk7?=
 =?us-ascii?Q?PnuAZTUkH+kDRZLu3/JXMaFGlo4qOXcCxYjkyvhN/Diy5xy7hzNqY8+bwhkH?=
 =?us-ascii?Q?5psRM/Ga3FIIbdMloyEiHiU2Zx8O54TAivnP8GWtFNXzyvzKPPs23OXJvDCZ?=
 =?us-ascii?Q?WLL9+6sPehmDecA4ln50zRzNPpSPzebZIl6OXGJSWolNeovRciHtPVzcwvvR?=
 =?us-ascii?Q?PMWioMaINYL3eh8EGcKIOoWblX/mQvREUIldPFvbGx3v3UQZ9PU15uc5iBHY?=
 =?us-ascii?Q?8YH6LOOrXB3d0bK9w/ZiQan0kaTO3TO8RFvK9z4FYmeAmqRjxMFp/5humX4e?=
 =?us-ascii?Q?Q3b0Rs9J3ZxZFDubrEa3F4CP?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ffe92b-53f9-448d-11c5-08d93bf12f99
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2021 18:02:12.2827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dm3qWDxxfqBuDWU0wVdg+QN9Z5VONIrFusrihfexEEx/tyqzlJ/JEKmpEwVKxy82AvQ4VUNH3ReP0HoWJQbRD9A9lFK4+K5wXNSY+E9ez6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB4569
X-Proofpoint-ORIG-GUID: zFgCO-kJjYeK3Az4i1X0FyHYCHZa9-F5
X-Proofpoint-GUID: zFgCO-kJjYeK3Az4i1X0FyHYCHZa9-F5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-06-30_08,2021-06-30_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 phishscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously this driver always forced the copper page to be selected,
however for AR8031 in 100Base-FX or 1000Base-X modes, the fiber page
needs to be selected. Set the appropriate mode based on the hardware
mode_cfg strap selection.

Enable the appropriate interrupt bits to detect fiber-side link up
or down events.

Update config_aneg and read_status methods to use the appropriate
Clause 37 calls when fiber mode is in use.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/at803x.c | 69 ++++++++++++++++++++++++++++++++++------
 1 file changed, 59 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 5d62b85a4024..65f546eca5f4 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -48,6 +48,8 @@
 #define AT803X_INTR_ENABLE_PAGE_RECEIVED	BIT(12)
 #define AT803X_INTR_ENABLE_LINK_FAIL		BIT(11)
 #define AT803X_INTR_ENABLE_LINK_SUCCESS		BIT(10)
+#define AT803X_INTR_ENABLE_LINK_FAIL_BX		BIT(8)
+#define AT803X_INTR_ENABLE_LINK_SUCCESS_BX	BIT(7)
 #define AT803X_INTR_ENABLE_WIRESPEED_DOWNGRADE	BIT(5)
 #define AT803X_INTR_ENABLE_POLARITY_CHANGED	BIT(1)
 #define AT803X_INTR_ENABLE_WOL			BIT(0)
@@ -81,7 +83,17 @@
 #define AT803X_DEBUG_DATA			0x1E
 
 #define AT803X_MODE_CFG_MASK			0x0F
-#define AT803X_MODE_CFG_SGMII			0x01
+#define AT803X_MODE_CFG_BASET_RGMII		0x00
+#define AT803X_MODE_CFG_BASET_SGMII		0x01
+#define AT803X_MODE_CFG_BX1000_RGMII_50		0x02
+#define AT803X_MODE_CFG_BX1000_RGMII_75		0x03
+#define AT803X_MODE_CFG_BX1000_CONV_50		0x04
+#define AT803X_MODE_CFG_BX1000_CONV_75		0x05
+#define AT803X_MODE_CFG_FX100_RGMII_50		0x06
+#define AT803X_MODE_CFG_FX100_CONV_50		0x07
+#define AT803X_MODE_CFG_RGMII_AUTO_MDET		0x0B
+#define AT803X_MODE_CFG_FX100_RGMII_75		0x0E
+#define AT803X_MODE_CFG_FX100_CONV_75		0x0F
 
 #define AT803X_PSSR				0x11	/*PHY-Specific Status Register*/
 #define AT803X_PSSR_MR_AN_COMPLETE		0x0200
@@ -191,6 +203,8 @@ struct at803x_priv {
 	u16 clk_25m_mask;
 	u8 smarteee_lpi_tw_1g;
 	u8 smarteee_lpi_tw_100m;
+	bool is_fiber;
+	bool is_1000basex;
 	struct regulator_dev *vddio_rdev;
 	struct regulator_dev *vddh_rdev;
 	struct regulator *vddio;
@@ -673,12 +687,32 @@ static int at803x_probe(struct phy_device *phydev)
 	}
 
 	/* Some bootloaders leave the fiber page selected.
-	 * Switch to the copper page, as otherwise we read
-	 * the PHY capabilities from the fiber side.
+	 * Switch to the appropriate page (fiber or copper), as otherwise we
+	 * read the PHY capabilities from the wrong page.
 	 */
 	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
+		int mode_cfg;
+
+		ret = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
+		if (ret < 0)
+			goto err;
+		mode_cfg = ret & AT803X_MODE_CFG_MASK;
+
+		switch (mode_cfg) {
+		case AT803X_MODE_CFG_BX1000_RGMII_50:
+		case AT803X_MODE_CFG_BX1000_RGMII_75:
+			priv->is_1000basex = true;
+			fallthrough;
+		case AT803X_MODE_CFG_FX100_RGMII_50:
+		case AT803X_MODE_CFG_FX100_RGMII_75:
+			priv->is_fiber = true;
+			break;
+		}
+
 		phy_lock_mdio_bus(phydev);
-		ret = at803x_write_page(phydev, AT803X_PAGE_COPPER);
+		ret = at803x_write_page(phydev,
+					priv->is_fiber ? AT803X_PAGE_FIBER :
+							 AT803X_PAGE_COPPER);
 		phy_unlock_mdio_bus(phydev);
 		if (ret)
 			goto err;
@@ -703,6 +737,7 @@ static void at803x_remove(struct phy_device *phydev)
 
 static int at803x_get_features(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int err;
 
 	err = genphy_read_abilities(phydev);
@@ -720,12 +755,13 @@ static int at803x_get_features(struct phy_device *phydev)
 	 * As a result of that, ESTATUS_1000_XFULL is set
 	 * to 1 even when operating in copper TP mode.
 	 *
-	 * Remove this mode from the supported link modes,
-	 * as this driver currently only supports copper
-	 * operation.
+	 * Remove this mode from the supported link modes
+	 * when the device is configured for copper operation.
 	 */
-	linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
-			   phydev->supported);
+	if (!priv->is_1000basex)
+		linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+				   phydev->supported);
+
 	return 0;
 }
 
@@ -846,6 +882,7 @@ static int at803x_ack_interrupt(struct phy_device *phydev)
 
 static int at803x_config_intr(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int err;
 	int value;
 
@@ -862,6 +899,10 @@ static int at803x_config_intr(struct phy_device *phydev)
 		value |= AT803X_INTR_ENABLE_DUPLEX_CHANGED;
 		value |= AT803X_INTR_ENABLE_LINK_FAIL;
 		value |= AT803X_INTR_ENABLE_LINK_SUCCESS;
+		if (priv->is_fiber) {
+			value |= AT803X_INTR_ENABLE_LINK_FAIL_BX;
+			value |= AT803X_INTR_ENABLE_LINK_SUCCESS_BX;
+		}
 
 		err = phy_write(phydev, AT803X_INTR_ENABLE, value);
 	} else {
@@ -929,8 +970,12 @@ static void at803x_link_change_notify(struct phy_device *phydev)
 
 static int at803x_read_status(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int ss, err, old_link = phydev->link;
 
+	if (priv->is_1000basex)
+		return genphy_c37_read_status(phydev);
+
 	/* Update the link, but return if there was an error */
 	err = genphy_update_link(phydev);
 	if (err)
@@ -1029,6 +1074,7 @@ static int at803x_config_mdix(struct phy_device *phydev, u8 ctrl)
 
 static int at803x_config_aneg(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int ret;
 
 	ret = at803x_config_mdix(phydev, phydev->mdix_ctrl);
@@ -1045,7 +1091,10 @@ static int at803x_config_aneg(struct phy_device *phydev)
 			return ret;
 	}
 
-	return genphy_config_aneg(phydev);
+	if (priv->is_1000basex)
+		return genphy_c37_config_aneg(phydev);
+	else
+		return genphy_config_aneg(phydev);
 }
 
 static int at803x_get_downshift(struct phy_device *phydev, u8 *d)
-- 
2.27.0

