Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39C631A9A2
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 03:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhBMCT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 21:19:58 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:40394 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229679AbhBMCTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 21:19:55 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D2I1XD001480;
        Fri, 12 Feb 2021 21:19:06 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2052.outbound.protection.outlook.com [104.47.61.52])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hrw92swa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 21:19:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMGKG8vP1B7ruj+dTwWso9kC03qnE77UscsQ2eX3xCmgad5KFdiLz74BahoUZyMuD+B/Ws3/aq8IqMm3kmTbPwH7aoqHPukaWi173dHc6A+kaqSQxbZDIRGuK7BmvAxkEiaZNltigW2tc7d6kpV3HARpFecoI1+/JfAEPuCxE0RhLt/mclwgKEi/isdhO6tMw31fAUsR+acU2C6BqsWzcUGV4f1Y3orN38/n+s3CfrO987IALGLr+dduCtciKxhG5zyGAuILdLbgbYvoGALouKqyvkLKDXVrNRAl2q1sR100wTQPuLKZ/8xGxvKaoKOdAYCChTXrUNW+FTV+ciaAQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5zbdELIcJZF4bTXxQn3OF+G8u5Xj7swiCqFm1BrzRY=;
 b=AMkQqWu0lDI90D6ZzNoYrWhEC8bbLQuyTOwginrcRs2M32j9eO8j9OE596Foeiqu3nWMQNf8EyJuGJcyGw9YGDcUyfoO54NAiIwFrDv5+DfHHQ6TJr2J3emhbbUK6WEGXfEETT2fPcI5olGRYSZ0kkI1BhiRcchmOuGP8B04nfXIjZbLDxRfTorYOFrUTJZLE4QR/NjkMef0D6HJ5gCBpP1cbTvrbjTCsLwyMuJNVWFfKcypYOg5ezHCGUDixzbZtvwkMaYp3BEHTcw0mxuqs+yXx+ztWu0UhVmbvWGaUzNbK1jjPxkckXOh1Z81sR8RC7XU456+4tac+sJLGmhUUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5zbdELIcJZF4bTXxQn3OF+G8u5Xj7swiCqFm1BrzRY=;
 b=1fUnZJxn4fQoFfwGB1BaAHiJFlq6Ixq8hT/oy2iAALB81wGZ5wEDBkzZ7Qw7+P+9FglEYDNOuB5jvhnuxvnHHqhneqfMDn3Nd3jA2hj+HUgb3++h9SRcOT2elqwh4b18SFTG35wtT8//79WYsVuTkQYVIcs+Od3RhGRXqHO0MyE=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB2606.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Sat, 13 Feb
 2021 02:19:05 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.037; Sat, 13 Feb 2021
 02:19:05 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 1/2] net: phy: broadcom: Set proper 1000BaseX/SGMII interface mode for BCM54616S
Date:   Fri, 12 Feb 2021 20:18:39 -0600
Message-Id: <20210213021840.2646187-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210213021840.2646187-1-robert.hancock@calian.com>
References: <20210213021840.2646187-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YT1PR01CA0096.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::35) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YT1PR01CA0096.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Sat, 13 Feb 2021 02:19:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11ca1483-7b4f-48dc-f374-08d8cfc5bc86
X-MS-TrafficTypeDiagnostic: YTBPR01MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB26068AA7A5B1653008EEB6F0EC8A9@YTBPR01MB2606.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ps1gr7mnHi0DN2vd6XBSi1chPj1K5hpQUjFNYDyZwMGPEAQNYUSSTBZW4EPZVWOsxEO1qciHOZgWapF/TyHWebqckcKUddoeTI4Hj7+nzdfyumbjIiTbtvJQrZfAc6GQqvU1CVBuy2SdRMFBcZBxzCKZNgT6OQy+2cGQZjrb/w9ZAoetsOsTvG2pvpvNYNCwbdkrMUN6AmQysrs9rglqyZNRhAd1uvMSJOySSf6IFiKou464Zrzm7FuMym6+Yl/Mw9vLnLLxSq9ipZNGD6HoTS186GaLXbEY/NuB7hkp8UxNRFv+Q/1CnBtISZ63PNnxJ7XlBYlCbPzeJ6nvoOqTeYh6rA1oadTu4WJIUIUChUST0o/y4PXYKu0AJOOfyRnLaf+J5yXgQUs2ynZkDpduv5MRHZvMnHOi7h8SDLqSJ6GXzaO7ORsLsdF76/bC7JBzakqcdd5mk9fzGqizCqIkXOLqesyJOz2aY8YEDWY/yJxEqhoKGy3gUcLPT+dcgMVFlqCVeFBT8Ws9AQDlEyfzqC6meAtZolABkK6XTxWaaJt0Iewm86w+jcXHz2r0bK2jbankvCbGm9ykhmyzfHl3DldCWb3Q44Cw2efiLeHXJtxTBHNH+oBMktOW+SRgFQCFqONzZS5DO+tbXmcWECQI9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39850400004)(346002)(366004)(376002)(6512007)(107886003)(6486002)(4326008)(36756003)(5660300002)(52116002)(956004)(2906002)(478600001)(69590400012)(2616005)(44832011)(16526019)(186003)(26005)(966005)(1076003)(8676002)(316002)(6506007)(8936002)(86362001)(66476007)(66556008)(66946007)(6666004)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bA/du0jCZqVZEj0Chg0WVTkNj4XEd1y4s5OCnqSir3r5ydQqPzwiBtZpcYrv?=
 =?us-ascii?Q?eC+uFnusnmiRfKgnokQGEpPjF3Zu07ZRCQyI761yYBNuKm8jZ2gyMsajCb6B?=
 =?us-ascii?Q?Fkhsqga4kHf4aEwY0oNB+AirVLnBYrBndnuAU2cQRc1Dswe4RGjYiN1K9Veb?=
 =?us-ascii?Q?0vAyUHkBVVshmo3wte4x7lqz3x3U7RcWaR4RuEFA0FQQjhql89YrLzAh5Fj1?=
 =?us-ascii?Q?7/nlcddz9WvTWkUbjJiY/s4zWH6MmnJ80dJXS0e/3K1GrAl7Q+RF+ToWro2/?=
 =?us-ascii?Q?GmSOlqqg3uaTNei08NJEf2G3plOL5vIeOEkB92EUdCb1SGFtskG8O9xxVaxJ?=
 =?us-ascii?Q?tnexdhmGoLucXbDPn6U3zMAqSDxsab6iTK3UNoarLXwR1LibT6bht3TZqs+o?=
 =?us-ascii?Q?aoyd0koC5dK3G/lWb8jjoLmW02nG0AkGc8N9aZem9uHvEzbu6n72J4qRPven?=
 =?us-ascii?Q?gy5fndDIXftFCa09moxq8/Z1ZwbeEtXWtkvQ0gWh8wrRtKssruY4nVv+jm+2?=
 =?us-ascii?Q?CV0hQ383htGdkDHKRxCtGYVstkX8RVCQKysLL9sFHgN8A4SHxvYRXzHWShz9?=
 =?us-ascii?Q?dmAjEX8Wx+AAw604mErEgFyBNmXJLl1VEwy0jYqyzNoI9TS8+bGmMAdSp/fx?=
 =?us-ascii?Q?mBrSJa8RJkGsLh758c6kxu+z7f6nRw0s3+6nGOEVHOo8vYlNl+I9snWfkmI4?=
 =?us-ascii?Q?DXraKJvEOPwRjf9rQLq85OCuA8Kd1QD5yo/S2GXIyDN8GXtDECw0bx21meyX?=
 =?us-ascii?Q?21LvI5bnraypJeyYuXlxYAO+cQpyJoUb2JNJis1UzV5I++18NrHiHRHfllIY?=
 =?us-ascii?Q?eq9swSpG1+9F0cW9U5Jeqsxzn4IhDMLlKKmoaeYVhx5uZvo1YSvo4QeezpTn?=
 =?us-ascii?Q?Cy7srA8rrKn1vyMzPIAlb5jBGu0iQTHML0HBQk8ji+9lxL1e0JFw+x0H2Df5?=
 =?us-ascii?Q?47qOjDpGvuki/sIDzbzpN4LQ2H6qF6Hp5aDdXaffimF8+zW9Pi6BtUknLUOQ?=
 =?us-ascii?Q?/2Jl/jaDnNnPuU+RCp4jS0pgQT+x8XPOZrioXFzrtJzxILS6H7I6mn1ejgZ0?=
 =?us-ascii?Q?KisM6WiXmPoE7ldKDzaZHqaO+fkSLhQHYn899VruV1Zfo49rar3hTrt5JwfI?=
 =?us-ascii?Q?iHaf5oI0yyMgBeVEUxKnmPvQE+8Ij22uEvSu2/EssMvnrVNZNrGAH6njb+qr?=
 =?us-ascii?Q?6FsStRIms1iQFZ1/Vm+TDVHFDp6qO3+BGERtrW6XAFFbp35Baqy8aHM886C7?=
 =?us-ascii?Q?8JpC9M92uj19j3/ghpo31mr5TBi+ed93QPg0LmGg3wMiNoLd+DZuFLIZ4mlO?=
 =?us-ascii?Q?pi6c5T1Nluuke0nSG5i4Bi4w?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11ca1483-7b4f-48dc-f374-08d8cfc5bc86
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2021 02:19:05.2762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pj9tQinvP/fB3RVBnoIXUGlo5I0/sCmCFyzp0Q1Nb7LDS3zrTd0Avc95tLC50U3rTEomW1PQQMOaqMiBn8eRrovb4/pwcZ6pKLuyvae/ogY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB2606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102130019
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The default configuration for the BCM54616S PHY may not match the desired
mode when using 1000BaseX or SGMII interface modes, such as when it is on
an SFP module. Add code to explicitly set the correct mode using
programming sequences provided by Bel-Fuse:

https://www.belfuse.com/resources/datasheets/powersolutions/ds-bps-sfp-1gbt-05-series.pdf
https://www.belfuse.com/resources/datasheets/powersolutions/ds-bps-sfp-1gbt-06-series.pdf

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/broadcom.c | 84 ++++++++++++++++++++++++++++++++------
 include/linux/brcmphy.h    |  4 ++
 2 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 0472b3470c59..484791ac236b 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -64,6 +64,64 @@ static int bcm54612e_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int bcm54616s_config_init(struct phy_device *phydev)
+{
+	int rc, val;
+
+	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
+	    phydev->interface != PHY_INTERFACE_MODE_1000BASEX)
+		return 0;
+
+	/* Ensure proper interface mode is selected. */
+	/* Disable RGMII mode */
+	val = bcm54xx_auxctl_read(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_MISC);
+	if (val < 0)
+		return val;
+	val &= ~MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_EN;
+	val |= MII_BCM54XX_AUXCTL_MISC_WREN;
+	rc = bcm54xx_auxctl_write(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_MISC,
+				  val);
+	if (rc < 0)
+		return rc;
+
+	/* Select 1000BASE-X register set (primary SerDes) */
+	val = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
+	if (val < 0)
+		return val;
+	val |= BCM54XX_SHD_MODE_1000BX;
+	rc = bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE, val);
+	if (rc < 0)
+		return rc;
+
+	/* Power down SerDes interface */
+	rc = phy_set_bits(phydev, MII_BMCR, BMCR_PDOWN);
+	if (rc < 0)
+		return rc;
+
+	/* Select proper interface mode */
+	val &= ~BCM54XX_SHD_INTF_SEL_MASK;
+	val |= phydev->interface == PHY_INTERFACE_MODE_SGMII ?
+		BCM54XX_SHD_INTF_SEL_SGMII :
+		BCM54XX_SHD_INTF_SEL_GBIC;
+	rc = bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE, val);
+	if (rc < 0)
+		return rc;
+
+	/* Power up SerDes interface */
+	rc = phy_clear_bits(phydev, MII_BMCR, BMCR_PDOWN);
+	if (rc < 0)
+		return rc;
+
+	/* Select copper register set */
+	val &= ~BCM54XX_SHD_MODE_1000BX;
+	rc = bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE, val);
+	if (rc < 0)
+		return rc;
+
+	/* Power up copper interface */
+	return phy_clear_bits(phydev, MII_BMCR, BMCR_PDOWN);
+}
+
 static int bcm54xx_config_clock_delay(struct phy_device *phydev)
 {
 	int rc, val;
@@ -283,15 +341,17 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 
 	bcm54xx_adjust_rxrefclk(phydev);
 
-	if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E) {
+	switch (BRCM_PHY_MODEL(phydev)) {
+	case PHY_ID_BCM54210E:
 		err = bcm54210e_config_init(phydev);
-		if (err)
-			return err;
-	} else if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54612E) {
+		break;
+	case PHY_ID_BCM54612E:
 		err = bcm54612e_config_init(phydev);
-		if (err)
-			return err;
-	} else if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810) {
+		break;
+	case PHY_ID_BCM54616S:
+		err = bcm54616s_config_init(phydev);
+		break;
+	case PHY_ID_BCM54810:
 		/* For BCM54810, we need to disable BroadR-Reach function */
 		val = bcm_phy_read_exp(phydev,
 				       BCM54810_EXP_BROADREACH_LRE_MISC_CTL);
@@ -299,9 +359,10 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 		err = bcm_phy_write_exp(phydev,
 					BCM54810_EXP_BROADREACH_LRE_MISC_CTL,
 					val);
-		if (err < 0)
-			return err;
+		break;
 	}
+	if (err)
+		return err;
 
 	bcm54xx_phydsp_config(phydev);
 
@@ -385,7 +446,7 @@ static int bcm5481_config_aneg(struct phy_device *phydev)
 
 static int bcm54616s_probe(struct phy_device *phydev)
 {
-	int val, intf_sel;
+	int val;
 
 	val = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
 	if (val < 0)
@@ -397,8 +458,7 @@ static int bcm54616s_probe(struct phy_device *phydev)
 	 * RGMII-1000Base-X is properly supported, but RGMII-100Base-FX
 	 * support is still missing as of now.
 	 */
-	intf_sel = (val & BCM54XX_SHD_INTF_SEL_MASK) >> 1;
-	if (intf_sel == 1) {
+	if ((val & BCM54XX_SHD_INTF_SEL_MASK) == BCM54XX_SHD_INTF_SEL_RGMII) {
 		val = bcm_phy_read_shadow(phydev, BCM54616S_SHD_100FX_CTRL);
 		if (val < 0)
 			return val;
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index de9430d55c90..b0a73b91d5ba 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -137,6 +137,7 @@
 
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC			0x07
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_WIRESPEED_EN	0x0010
+#define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_EN	0x0080
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_SKEW_EN	0x0100
 #define MII_BCM54XX_AUXCTL_MISC_FORCE_AMDIX		0x0200
 #define MII_BCM54XX_AUXCTL_MISC_WREN			0x8000
@@ -223,6 +224,9 @@
 /* 11111: Mode Control Register */
 #define BCM54XX_SHD_MODE		0x1f
 #define BCM54XX_SHD_INTF_SEL_MASK	GENMASK(2, 1)	/* INTERF_SEL[1:0] */
+#define BCM54XX_SHD_INTF_SEL_RGMII	0x02
+#define BCM54XX_SHD_INTF_SEL_SGMII	0x04
+#define BCM54XX_SHD_INTF_SEL_GBIC	0x06
 #define BCM54XX_SHD_MODE_1000BX		BIT(0)	/* Enable 1000-X registers */
 
 /*
-- 
2.27.0

