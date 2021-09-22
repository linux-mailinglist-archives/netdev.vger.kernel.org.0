Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23BA414FAB
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbhIVSQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:16:56 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:48961
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237037AbhIVSQx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 14:16:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIFaGCldwQfGdIxEsCzy1PvVBj8/g4oDifckAvd8GCt8lLXR7vJKeu4ogCQrMNT0Sfc7E53Rd+3uFiF75aVI7RhpmAuwvvnBoW2M+9mIs1NUtfdT/jPzC+E5DdUZn3hGKOPdgEjDcCAAjB0Z8GscToPZc9wx2CZTHorrapZbLlmSlgMdyeTSNCYnrVwrxLz4DnzG2KKztWNUZucAHHpmzhB0Ij0B+7QF8fFzekMRalkLfNhmeKSZOD8ToHWt//zG9JpQsHI2mN1skYlGjvGgwdQ461bp0yTW0bhpOoaOSxva4/zHMYFzDz0MsxW59vVdBjmeVZLfEq9qz00q9ZjPtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rTeDVutLuNedtXPyNVHwEwSvonWNPYXFEIiGZnKW2a4=;
 b=mAKaKNPv1j0WXU8bAEPabJV4QUoRE+OzQlFywAQkMlPYK9Gr9vbrZQ9vlPtd3W2w6WkD73BmE3t0xsgZnzKAjYetS3sxWYQ2DTHmhMVYCHC4mAz0Y5tvbFDGrBpR9h/o/SOn/SCgPp+deY2FAeNnyuidGy87/8Da908v3Gp74tA/2Hx8Yh6M9/kmQlewgnzSd/MafPpwIlkoAtXShrSUKUgF25OvVQY08S97VmRfKmqkwCvWSlAaemIXhA9rCVt4Ft6BSqrdoS+q/xsNP+qtyiYyV3A3qnKef21KTx4DuGOLTGHr2gYMhN80uLg6guJ5oBkjT56obCF4rcEmXzCWlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTeDVutLuNedtXPyNVHwEwSvonWNPYXFEIiGZnKW2a4=;
 b=qkpWkde/6BVr5ASeRqLohvsM7OGJXv3SW7dBxadtoAp0ED7uvR8jY0FtIXNvnxnhwEHc8rYrSFQdgHCE6Z+40VeKCAwN4aHspPflbImZ2fww7+BZfkE1n6Ow6dDiuLTdOd0c0H/ZdSPwR+5dvYfbL3SyQSN/ufqHXcsDYXeyBPg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7471.eurprd04.prod.outlook.com (2603:10a6:800:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 18:15:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 18:15:19 +0000
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
Subject: [RFC PATCH v3 net-next 3/6] net: phy: bcm84881: move the in-band capability check where it belongs
Date:   Wed, 22 Sep 2021 21:14:43 +0300
Message-Id: <20210922181446.2677089-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.53.217) by PR2PR09CA0001.eurprd09.prod.outlook.com (2603:10a6:101:16::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 18:15:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5c2c6b9-d205-4d91-630f-08d97df4ef1b
X-MS-TrafficTypeDiagnostic: VE1PR04MB7471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7471207DEC6216EFCFFD22C7E0A29@VE1PR04MB7471.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hoRXwS50sem3vjdgN+szLAAF0oyGPWUrG0WsmWStpc3/44NycoPMTwwNd0L/6+DAUqgTYbLbQ4snuIawQJ3dQkGQweWYVa/RH3ogxqu7UgFJRQnWIMmO0w1DjjN5pjylNGm2D9GGfYiKkui+sJ2hGP9D3rPubDQ7c5i8K6kmqIO0VwszZ/TQFYCG87ILHFLCkl6+VwazB6xSvqRgA7PHWEYILuxtPAni8QASIO6vVeP3wisO51L9v37Nn86U/0b+XQS6/MJj+/Z7L5ABuCEaPkPXqWT0NVF2HzQcRBNisUMDMuBrVT5zaR+Q7S8l+Faw6SayDfiKpQvl6cFMXR8XXpLpSNKQYa5C3eUplte+gubfjloAOawTB2mnadB6soMda3Mrw3ceKUzxBUzck4EHpVqFs0ARhbH7YtsjbAcnSOKfEdsdzMhWdCm7RrsIdLmp0wRnoQyFff8meujgxVHpHxc4OTZy8Vk/DjZM8L5yn0kqNWlAh98D12B1GEeQSQoQhl+v1ncKflR8mG3SKolYctfD892EmKGGiBK9Bo/yMp4M2cVc+ywwNNnrS9xzREn8veswTGlJFYlZbt2PEJHbwW+QuHj3z3LY4o+U5L64NOYSwOr+tusrn0qBaA4KCGEigMne0DAYXErFNo5V99Q6zOnOeL7YVP6GT5eB3iNPnsPlhgKlaC05mHPho/NuWBpVRrFVBvStEeoxkHEDse4w+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(4326008)(66946007)(66556008)(26005)(38100700002)(2616005)(6512007)(2906002)(508600001)(83380400001)(66476007)(38350700002)(8936002)(6666004)(7416002)(8676002)(1076003)(54906003)(6486002)(52116002)(6916009)(44832011)(6506007)(316002)(86362001)(36756003)(956004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IY/aqpkEaTUXHGCmYsBGROlcTsRiRecKQSIiFLnGMJVdshK1POXDN6LP7GKT?=
 =?us-ascii?Q?jyxu7cU+q1CXZPAKLp46l7pfGXUwmC0iAlPfLvLc1UxdcY95INHKj/ETdqIk?=
 =?us-ascii?Q?6yHb12MjT8RHWdSdsVBIXjkXvvCes0IN/VCLUbkYCnbu57GOwnkvf1Xu4Ar6?=
 =?us-ascii?Q?jYA2Vv9hFJMKAFIFkFIdR0e5rGhIrT3ceE1Gnsh6wiciZWVd3d/5o9nEQMSo?=
 =?us-ascii?Q?P6IvwNpY3RZotky7i8fa+AapX5eCfTrZUknzjBCe4oGaoWCDeWREyaPYCv2s?=
 =?us-ascii?Q?Gg5wdKLxR+5h1FGjgquWOKbrRLwaxpXzRM4CE2Pqg5FOMUyVRBAOZ6hoa9xE?=
 =?us-ascii?Q?sIx9rTaLw26P5mtAeJhfBJwjyq3QV3LdSoafOFSaZBFReOJr4FLe9jFe+ddv?=
 =?us-ascii?Q?NfBv8W4hYHEKE1WgxY0ppaL8zinJ0nBhVU0hvUfxi0amr7k1zYsLejAqp5EM?=
 =?us-ascii?Q?n9AiAvVt+ziaY8Sn/ZbCyyyB7WKkY5yWtig9diuYtEaDsSq5Coh4JtoFXVoS?=
 =?us-ascii?Q?soRMtYH72t6zkgP2oyV4atsvBZ2a/HTGbQzBkFOJqcV38xjW0BGVc3IMJ50S?=
 =?us-ascii?Q?4l5DV0/oOoMraRUgxyAQL1ZJDhukg9xRW44k/FAxTKtT1hvHG8zpRv5OA66I?=
 =?us-ascii?Q?YKgv0UqgdLSSBHs5Kz9dmCxGQUYWNfZn45LW/oetHf7v0lkX4mXXKf9r973Y?=
 =?us-ascii?Q?hq1LXNAyap7008OE/nCr1lP9wg5yeDzAw9Lh1PYw7MuB5SDz4MIWNynxBhjL?=
 =?us-ascii?Q?64QEGkI3+O39OgyGInmR/11gbb3FLoZkRvJpQIoDsdBPtnHM9p4GUjzZHYrz?=
 =?us-ascii?Q?OlTtDfRLxUTmHlBmjzwn/ku2kaPFBaX4PDmx5szBMJGjsB+VK7zl2ufuBKhk?=
 =?us-ascii?Q?29bko0lXLSYgFqsk7gsaWcZV8MKXKnepyY3DxNVmgRgCd6y9XIDEWJ/7SeLp?=
 =?us-ascii?Q?S/0W7C0O2d0wvxzSe81XFnQ9yW2ookJDp/fxqKxktxc7gM78uEpUyqKk1Rra?=
 =?us-ascii?Q?13HngEyPYYblBtuMYrzogzlEboHn4Ty1jWIfokrEXrT7Acm+wym5N7+A9UdY?=
 =?us-ascii?Q?ry+/C1ya1kjBqdg1KivrB/E6YO9Yeg/BA4Ohiikol8rKXei6KCIs20W/3xDu?=
 =?us-ascii?Q?Yo7eiESeM2f/hkVEiD+hgRFkzW9mEurZit9m/GS9PL0Gf92kk0ApWhLGoj2C?=
 =?us-ascii?Q?rUIKb9w69o77El0g4/7WU1lPxRLOjr+g1KuzmSCj3wasbj7n3mKhCz7tHM8j?=
 =?us-ascii?Q?l2m4DU3Q8CtSIasGX2A/xJB8zv0k02k7VdGlD8fgSzoxRhhH0SeAhrZNZ8K9?=
 =?us-ascii?Q?Vm6t4lk9gO0cF4jas2YjBhUT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c2c6b9-d205-4d91-630f-08d97df4ef1b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 18:15:18.8776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z9jHujOEXslzoko7y0ztN76trOR5/WjgdJ4yKabUL+af5XDQ9CEkyLNpVzrOBvjVf+HfHPRRRec82dqjwaBkkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that there is a generic interface through which phylink can query
PHY drivers whether they support various forms of in-band autoneg, use
that and delete the special case from phylink.c.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/bcm84881.c | 10 ++++++++++
 drivers/net/phy/phylink.c  | 17 ++---------------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
index 9717a1626f3f..5c0e4f85fc4e 100644
--- a/drivers/net/phy/bcm84881.c
+++ b/drivers/net/phy/bcm84881.c
@@ -223,6 +223,15 @@ static int bcm84881_read_status(struct phy_device *phydev)
 	return genphy_c45_read_mdix(phydev);
 }
 
+/* The Broadcom BCM84881 in the Methode DM7052 is unable to provide a SGMII
+ * or 802.3z control word, so inband will not work.
+ */
+static int bcm84881_validate_inband_aneg(struct phy_device *phydev,
+					 phy_interface_t interface)
+{
+	return PHY_INBAND_ANEG_OFF;
+}
+
 static struct phy_driver bcm84881_drivers[] = {
 	{
 		.phy_id		= 0xae025150,
@@ -234,6 +243,7 @@ static struct phy_driver bcm84881_drivers[] = {
 		.config_aneg	= bcm84881_config_aneg,
 		.aneg_done	= bcm84881_aneg_done,
 		.read_status	= bcm84881_read_status,
+		.validate_inband_aneg = bcm84881_validate_inband_aneg,
 	},
 };
 
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f9a7c999821b..358246775ad1 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2185,15 +2185,6 @@ int phylink_speed_up(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_speed_up);
 
-/* The Broadcom BCM84881 in the Methode DM7052 is unable to provide a SGMII
- * or 802.3z control word, so inband will not work.
- */
-static bool phylink_phy_no_inband(struct phy_device *phy)
-{
-	return phy->is_c45 &&
-		(phy->c45_ids.device_ids[1] & 0xfffffff0) == 0xae025150;
-}
-
 static void phylink_sfp_attach(void *upstream, struct sfp_bus *bus)
 {
 	struct phylink *pl = upstream;
@@ -2252,14 +2243,10 @@ static int phylink_sfp_config(struct phylink *pl, struct phy_device *phy,
 	if (phy) {
 		ret = phy_validate_inband_aneg(phy, iface);
 		if (ret == PHY_INBAND_ANEG_UNKNOWN) {
-			if (phylink_phy_no_inband(phy))
-				mode = MLO_AN_PHY;
-			else
-				mode = MLO_AN_INBAND;
+			mode = MLO_AN_INBAND;
 
 			phylink_dbg(pl,
-				    "PHY driver does not report in-band autoneg capability, assuming %s\n",
-				    phylink_autoneg_inband(mode) ? "true" : "false");
+				    "PHY driver does not report in-band autoneg capability, assuming true\n");
 		} else if (ret & PHY_INBAND_ANEG_ON) {
 			mode = MLO_AN_INBAND;
 		} else {
-- 
2.25.1

