Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B7431A8CA
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhBMA3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:29:46 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:35951 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229602AbhBMA3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:29:45 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D0QYSK028661;
        Fri, 12 Feb 2021 19:28:55 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2051.outbound.protection.outlook.com [104.47.61.51])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hq424anc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 19:28:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BsJe4B4XaOOLd/nO4qj5inrQ5pHItbvjyS8vJo0xrLsBew24+emywr9u3cE3zTglICBjvn++9sbgW/cTp2JcJJryh7o7O7qX6whv49uDbJfbg8D+hYDNGevGCeicre6UX/MpDhe/PE9luVZF4haezL7JOpemMJuI8c8B1t3VvvkVju++dSUVgxxtA2kP4uK+HS/H/lSRiZkq3XCovHKs3FZe9HojCD7DVRCa7XGqBhonc8Yqg+hGe5LNhNBptx30Gp2c8svsCqw5DVqpFX+hr+OCl5GFJNTkJub6TtB1zmLsNc6mnaS4TE9ccvhk5r6VzNb/7nOH+1YnSAhl6GJMuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THCDourCgtXkQwsrIBj4gZLd/pDckroFVKtCrxEszK0=;
 b=dAVw3HMHorerz+689LBdRgMRSWnS3JahIfHHbCXpIQ07k5yQp6Ny6LLwzWNi3GayS2pugFOgCfMoD6+PSIyBbGH2OB4KLzxKMzULC07fcSUg6+IiNoDwqnH1By/kyFR1EXc4JkGwKnzT1HV4bNab9ZBC0c41AJtC6SXdO3Z/XKr2c0S6k2X0kcXG489LkP9jr2G13Tx0bICINCMcCc3Tw1pLGEmovFB5FSq4tGjvtYow8OcwT3/d6qyJSxgPQzKoryTEx8hWDMOAM/QEGhm+/xdnpjTchMNXB3V3BTRJHKJiJb1xoCsR1wQ5RaOHgr8OxTWTeexUJ55UHRVEDynQ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THCDourCgtXkQwsrIBj4gZLd/pDckroFVKtCrxEszK0=;
 b=Yq4aqGyjUsuvuX7z23qUhdW3KcKBrnxbksWS3qTMjPK6iKDdIGA3Ujl/6N/4AVfSixaTk1le4NOU8SlUehTvAyFWrQ9ksozbDmPFzRMmsTnE3MhmJJAsk31QClfwhZuT/98N23qdG8sQJs6O3VV6Hl4Fp+2/0529ZYCPcn7Dl+8=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::17)
 by YTOPR0101MB2091.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:1d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sat, 13 Feb
 2021 00:28:53 +0000
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128]) by YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128%6]) with mapi id 15.20.3825.034; Sat, 13 Feb 2021
 00:28:53 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 1/2] net: phy: broadcom: Set proper 1000BaseX/SGMII interface mode for BCM54616S
Date:   Fri, 12 Feb 2021 18:28:24 -0600
Message-Id: <20210213002825.2557444-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210213002825.2557444-1-robert.hancock@calian.com>
References: <20210213002825.2557444-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM5PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:3:115::20) To YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM5PR11CA0010.namprd11.prod.outlook.com (2603:10b6:3:115::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Sat, 13 Feb 2021 00:28:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0969a72f-a47c-4a98-e492-08d8cfb65781
X-MS-TrafficTypeDiagnostic: YTOPR0101MB2091:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTOPR0101MB20916067A98092C92D118CC1EC8A9@YTOPR0101MB2091.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZvZpKQaK45VGw302cDhF9UC++mEqPG1K9zFaGdXKIZfQ5av/F3E4LiNMiZbu7OGbTrCq6IskBiqQPwjUi/vi1Rg9j0s7Cg0Vs9wJoiFGXlkp4P2q/+46xBQiE+9OniyFGtDfn/cXtpYhGMrEbL9hIMCAjYvwOCK4+LkssI8wzKPfhjJARbZYphcuti4uZ63OJCDxY2xsdFSNGscvhvSQ7afs4m0NbAKpnjgLfd3LKKCgVF/c6xCXLbTGA/FdTm60bel2RfwssqYEuTvSWXINrNs31JyVI4mQBPq4RlVww/luifTDElBMlJPffhoXDObSPSsBah8GDFAOSnTHWyFTl0t6o6tNOe10hIWtJSnPKeZp5UDUqC8tqRZZWjyW9/MGszO8HQDP4OKZvrDz9BCVphY0dk6j2b469tz2jFGOAumLGw4GYjPddh8i/MyQLHm8le3jFTJO41wjqIBwOwVmzsBCjvrIjxRiyiop+/i89I2oP2rzHFAaD3ENGubLYcOWXYqNpZV0aLBkpJllYo7ttMcwox/3rckjWXc4MhyvuEPEjmGg8R9EF+EldABks47hZxkJY8xUboFg9ifoonYUZBRYYciR2QlFhe/qK70ZA7dPlbcHNPL3O+5kTufd4VHZfl3NNmNc4h5gO+CIi1MRIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(478600001)(966005)(8936002)(36756003)(66476007)(16526019)(6666004)(4326008)(69590400012)(52116002)(6506007)(186003)(26005)(5660300002)(107886003)(66946007)(956004)(86362001)(2906002)(8676002)(6512007)(2616005)(6486002)(44832011)(316002)(83380400001)(66556008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?i47r6bBGog7gDJFoLX/xABV/hEUEY+4FXGl7YdPN0OzDlIFVoqbpbh7O4iqb?=
 =?us-ascii?Q?q0SG0CZWgxkd8nYkHfhZ4+uOrmmhsksLmaWAPtF8ACQwOWLi2q2g4dAGkMOj?=
 =?us-ascii?Q?vrjknKb+M5ccPGDr5ZjOJgbdsX1bhFdJ4+XZoHCR8UX7M2Ed6eaNdexBXNTt?=
 =?us-ascii?Q?4sL3DTaaDS9dBx5S1ot9TQ6pzv93fHRa8c6GGvx7opGFepoPXxqq0lj0PIPr?=
 =?us-ascii?Q?DZVXZNLUCsRU1CJoStsbuO/7C/lGdNerY2OkjmwnS92SCII+7mHFMRsbrOu1?=
 =?us-ascii?Q?ePEhEgs6bNYrApxP8nroGNOu2fF1+NU0553OlsLlgDRoVcdMhbi5o8BB/LPP?=
 =?us-ascii?Q?LHUZdbHlKrYa0GqpdIYFopghemHec/yFUE3Dn1d9qmfrQG89TzP+TehHhXwx?=
 =?us-ascii?Q?uFOUuutLmSICqHcjrP/t1nfQdr8palqOT4xE2rFlNm2f9r4TMe1GOAteaH3l?=
 =?us-ascii?Q?bokFgonmxBrFyJ/DzHH+fAR6BmJVGT4yeEsX5zBbpn6exoa+z+z8N+AOFnCz?=
 =?us-ascii?Q?VLNws62H0AWjyhOdFMBaALXWIVcoiKcYXZPU5DWseBFPTY2/UqKb4Z363pC+?=
 =?us-ascii?Q?9xJbn7BO+eYJSuJF6WyDfDLttSUPcfkzwIVYSDlWanxcNJi5AxTrVktCiFHY?=
 =?us-ascii?Q?X8KTd+X4tWPkJ/bUnMGtnB6uhboX9845oe1kgdXpBHhnKJ53yUPdm6+LslTo?=
 =?us-ascii?Q?vhuDkKq78/cTbBka2H8/hPLlYMoJWSFsBxDLjUTcRYy/9dYZAFGeTC71olCL?=
 =?us-ascii?Q?igQPLXK1yKlxeSW9TWHBsoNBgDI7l4FQJ8jKzSw0Lhgyu1zQHXLlCTwjdJsT?=
 =?us-ascii?Q?vFxgFBJ/UVomaLnJsEG1e2vjN+Aek/VNYxupCd3ejOKML1Zm9fDks9ya5qCL?=
 =?us-ascii?Q?KptCUFgyS7F2PKaXMXVy+ayfDGwlVPnXPmaJ3k4hJgml6k9LKwVn43Ga4jx8?=
 =?us-ascii?Q?xCh9RoFNk5buCaWoQ8aWxP477dKmZCHPnoz+4g7+szZba1ZdzLdVPRu9hpcw?=
 =?us-ascii?Q?FM6I24GKx2LElFkaxy6yGaWWd3h3a+PnkdOOdduGu9pbl/MPBEWEj6jQ3uze?=
 =?us-ascii?Q?eKjWrv9srOdml1xy8qnWkXvjsj2mRRyT0fqI8KLaZrpdlZUVvw91r6abT/RB?=
 =?us-ascii?Q?FBAxrgeNYt5KPsmB4yPaCqqjJQZrkCJeLVgM6wqNOnQNhDwQXHjRmzDm5IT4?=
 =?us-ascii?Q?/STSSWLIqBTbU+e347vqwOGl5G1u/BMsjeMPTYBwiiMc7SZCH6r+HO9liJtL?=
 =?us-ascii?Q?5L3zBtC9MWKpoeJoOZA+t+7UMt2tc4wD24P3yobEDIGaA4zrzLlGrvpkUzGz?=
 =?us-ascii?Q?07tUE8H8e1olpnk34U5w/aod?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0969a72f-a47c-4a98-e492-08d8cfb65781
X-MS-Exchange-CrossTenant-AuthSource: YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2021 00:28:53.3642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ucziP7Av6YAsIk8hbY3NP1PtTcsBQ/KwHtCE0wDLL6zbrV7SUubZaCFqZZ7cYnuVgIl8WNu9LBuGnd0JSXpBHqe9x38ct72H+GDfstOoyFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB2091
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 impostorscore=0 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102130002
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
 drivers/net/phy/broadcom.c | 83 ++++++++++++++++++++++++++++++++------
 include/linux/brcmphy.h    |  4 ++
 2 files changed, 75 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 0472b3470c59..78542580f2b2 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -64,6 +64,63 @@ static int bcm54612e_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int bcm54616s_config_init(struct phy_device *phydev)
+{
+	int rc, val;
+
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII ||
+	    phydev->interface == PHY_INTERFACE_MODE_1000BASEX) {
+		/* Ensure proper interface mode is selected. */
+		/* Disable RGMII mode */
+		val = bcm54xx_auxctl_read(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_MISC);
+		if (val < 0)
+			return val;
+		val &= ~MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_EN;
+		rc = bcm54xx_auxctl_write(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_MISC,
+					  val);
+		if (rc < 0)
+			return rc;
+
+		/* Select 1000BASE-X register set (primary SerDes) */
+		val = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
+		if (val < 0)
+			return val;
+		val |= BCM54XX_SHD_MODE_1000BX;
+		rc = bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE, val);
+		if (rc < 0)
+			return rc;
+
+		/* Power down SerDes interface */
+		rc = phy_set_bits(phydev, MII_BMCR, BMCR_PDOWN);
+		if (rc < 0)
+			return rc;
+
+		/* Select proper interface mode */
+		val &= ~BCM54XX_SHD_INTF_SEL_MASK;
+		val |= phydev->interface == PHY_INTERFACE_MODE_SGMII ?
+			BCM54XX_SHD_INTF_SEL_SGMII :
+			BCM54XX_SHD_INTF_SEL_GBIC;
+		rc = bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE, val);
+		if (rc < 0)
+			return rc;
+
+		/* Power up SerDes interface */
+		rc = phy_clear_bits(phydev, MII_BMCR, BMCR_PDOWN);
+		if (rc < 0)
+			return rc;
+
+		/* Select copper register set */
+		val &= ~BCM54XX_SHD_MODE_1000BX;
+		rc = bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE, val);
+		if (rc < 0)
+			return rc;
+
+		/* Power up copper interface */
+		return phy_clear_bits(phydev, MII_BMCR, BMCR_PDOWN);
+	}
+	return 0;
+}
+
 static int bcm54xx_config_clock_delay(struct phy_device *phydev)
 {
 	int rc, val;
@@ -283,15 +340,17 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 
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
@@ -299,9 +358,10 @@ static int bcm54xx_config_init(struct phy_device *phydev)
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
 
@@ -385,7 +445,7 @@ static int bcm5481_config_aneg(struct phy_device *phydev)
 
 static int bcm54616s_probe(struct phy_device *phydev)
 {
-	int val, intf_sel;
+	int val;
 
 	val = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
 	if (val < 0)
@@ -397,8 +457,7 @@ static int bcm54616s_probe(struct phy_device *phydev)
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

