Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F3E31D1F9
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhBPVTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:19:03 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:29162 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230199AbhBPVSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:18:52 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11GL6cwL010488;
        Tue, 16 Feb 2021 16:18:01 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2053.outbound.protection.outlook.com [104.47.61.53])
        by mx0c-0054df01.pphosted.com with ESMTP id 36pcj9gyqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 16:18:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnekAv20qJiwhAyw+l8244GoEg8V47H1w6QbnKvLP5lqK5CpS5IjERUAr2weFtz8dVScEexjq+zei7tWGn6MkFjIPvUzMIKS9a5WIB8Nz8evoM8eBCt/4rfjunWklphI6E9dtuRY37WnBp+u1fDq0qTh/nrDBwaYN5KGacsutP0vtcngW55W4sCbdYNw6/kjYYR/0HxdzNaRG6MY9FPvLt9C9TL/T3zSwnSKsg0l1cWyClx1WMs3pGIhZ5fgS0dpTtv08TR7E6DbpqkUC2Oe34g9jr4Q/P7mW83mPeQ5ZwjtWMWoIdafCQtbyhW6JGpp87NixVnHGdcILkTXnujGIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=icEjO0IsopSKN8QUbaC3WVcRX1Z4IJrC6j2EPST1Kt4=;
 b=cAOsagd2Xv8WtfH/TA9jsSBG/n0g6vbq3hodZoyWETAZw/L9jdVPrKqnfX9Q1Lbc75e+61HqS+lc+j95NdNzd/iHgLPNRxaglzUUSh0RcmLINzt1+OT9e0OhkPoCQMolVw585y4hjMqNUH28wIidF0533fJw909KrabSrxLOhbfLav/zBzPIA//OQXdHeQBc4fmsBM6uCDBnBBKERE+2XODRNBF68DhKad/Dr/j+j4QHl7vaeg4BLOfiLEhM4tfWcMxlXUSZLysb+PZr3I4iBJdl7cnD+QCw0iASnQW49CKVbviyu5ANXtXaAH521HNMUqntt/lJYEnEkrw6JQ+eTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=icEjO0IsopSKN8QUbaC3WVcRX1Z4IJrC6j2EPST1Kt4=;
 b=FG9lyuVuLc0TbQoms5LgS/R4oes7Ra4n/E4XRbGH4Nj6yshA4SsaSX5SuXvjUmrtTDOMI9m6BP5tGXM7o7tRLmWPMPb7uu305Qu4PHdtaEoTonNeicleDHdC+cuDQV5p87+x71+nTvHzpsxokWX0zzTONVHR0m9Mh2S9UYbR5Tk=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTXPR0101MB0879.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.39; Tue, 16 Feb
 2021 21:17:57 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 21:17:57 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 1/3] net: phy: broadcom: Set proper 1000BaseX/SGMII interface mode for BCM54616S
Date:   Tue, 16 Feb 2021 15:17:19 -0600
Message-Id: <20210216211721.2884984-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216211721.2884984-1-robert.hancock@calian.com>
References: <20210216211721.2884984-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM3PR14CA0128.namprd14.prod.outlook.com
 (2603:10b6:0:53::12) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM3PR14CA0128.namprd14.prod.outlook.com (2603:10b6:0:53::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Tue, 16 Feb 2021 21:17:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc98e2ec-7925-4c0c-2871-08d8d2c054c8
X-MS-TrafficTypeDiagnostic: YTXPR0101MB0879:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTXPR0101MB0879B889E3966C977B15DA3AEC879@YTXPR0101MB0879.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /uBZXGqTcmX6Ze/C2aRcyjftgT5OuXDUXpyiFWNRliOgy5YsnEBwZVpeujGPxArBvzs/yxbGvT5dCElUCulLFC88QUbuKQvpyYhrrkR7HDi/hibZP7SxzkBNI4MRN2HIOPdJNERzbXqoZXy6xruX+qHmzfchM2ZF3MaPXa81rVXjm4+fDQtWgPIOd+Jh7XM8+UoNocpeo/0/B6Spgnkqy+UDLaeTolRNzEQIJMY+0JTvDstfP9fDQxT3jeOczVdyGxKbSDjARnhCi5PvJfjfKutlYSZfHjUCb9IIPsrcf0vvZhYprIcf2xJXSV3dmkW4d7Xp4ctTNxX3yQnkJwBJu15sPuXdX32awZR/jyw8Cqbk0JZNhu9NrX3DvlqQUAW+ajgSHuEeUYVw6KDgJIR6m7LFuw1pZrTv+xKFcMswgkziZnyXlDtdAF66gBKr/fDHXa4UsvZPuv5fpSoK2GtUUStoghqk0XdGD3uJYOarrM8bXwxYHQnNXbo/QbBESErYdCWZK9VJvcoucvj9ny/UycxytW2Ube6hfiVzQX+6YCotheAn0eh25A0hdm03rLQ7aAxxvonTNKKtLy6Avc3VPkCdLJ/rLkFhxa20ijKW0wFBLE/5Oygof6AwVhlaHj16HXCL5eOJQojq6XHh1Fw8Hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39850400004)(366004)(346002)(8936002)(8676002)(956004)(6486002)(66476007)(1076003)(66946007)(316002)(186003)(4326008)(6666004)(2616005)(6506007)(16526019)(36756003)(478600001)(966005)(5660300002)(69590400012)(52116002)(107886003)(83380400001)(66556008)(26005)(2906002)(44832011)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Cd4Kp0q7PQScR7ZQ9OqoFqc4TpY72MRGwwxUutCI252vZfakJRke34v/lr0r?=
 =?us-ascii?Q?N20h7NbfOkhdVzyiCpe03xzk5qRLx+B2GnPYghox1nF3qxuNuIyTTCrzS142?=
 =?us-ascii?Q?WiV9Uo6rsb3L0kU2wmedewcfXDPFGXeJHVt3AxwTYByqIx+BlZfUKCw08rJV?=
 =?us-ascii?Q?3R0ha7tz00roKxiJ4rapkf6/ia4ePzBJANd6By7t/SvvWPpiMqblxA0qIF5m?=
 =?us-ascii?Q?4pWoZqTbiKkIQIbStQe6sTHxBnKIK1LQdQV6C3PLLy6iIRqeWJ73/yBw2Q0v?=
 =?us-ascii?Q?SoSyrcydhp8eejxfxlXZmWdMI7yfK484dqiWZp4IkjTS22nFmulx0/MnR9zr?=
 =?us-ascii?Q?5iK/DEEU1YP7mxflH+8ruvllWxC0Fc3bFTSBxk91x7xqerVfNPHOhq7S2Us+?=
 =?us-ascii?Q?soFHZOqRtDm36b6HRTHM1FYsgg3k8nRmoyxDCEODhYl8STQiQd7keErmJjhX?=
 =?us-ascii?Q?uiXmjwSxi5Kev6paEGT0QAeySEjA7UWeyRDGI7xnTIxiIZnRW60vIfxghYMF?=
 =?us-ascii?Q?PxNJrQQEOPW02uWpI7OVfVd8eWbNJ6DRw7AeqRsR3JVgyaA4p0GZZZMXkgHS?=
 =?us-ascii?Q?PhNT6MZWJYZGRNT57Ib27H1772IFWgsgYnQRWDed5WRg25u1YJhFWJGtrVu+?=
 =?us-ascii?Q?z9r45gKuO09fiKwSGrzmImpWAU63RDC8qY4P5skbQwEJH/BJC4fxUrmlxVVE?=
 =?us-ascii?Q?RiBdIqoBxBKmGFi+7mpQJHT+ZUsFt6gUpMsxoSVPDlN3hY4vDE060ThHK6Vk?=
 =?us-ascii?Q?2J7okFgOn+mwxwKNcE48/TGTzfuX5Ke7n8WXE4CdpcvYLxooeWLL6klPLDOd?=
 =?us-ascii?Q?VtszqVbEJ/3ZAJJPjiMAWFbdgG1790tcwWC/xurbl+avNaawwsXV0poXntj+?=
 =?us-ascii?Q?XU0z853G3XZUurUHsivzEF+eg4ywMI3JexA+5C6iKjsA41igzbaJnvPntu26?=
 =?us-ascii?Q?7vyKbooSuE+0ToseIiLcQh7aHA0AAncaIHn+kwTkr5kWw6vhNUfD6vJjbgw/?=
 =?us-ascii?Q?TafC0dDOdJOKovlwRXy8yvjFG3+q7caNXZ+3RMZhCZmSp+akhNJDE10UQ6ln?=
 =?us-ascii?Q?vA+p1u57CX4Bp1pqDWmz8N4XLt/c6z2QjUbC1V8IHX6Gum6xz5sVgJFFzTso?=
 =?us-ascii?Q?UavS2WNvQY9xvBEE/UBAV7mkydif9TTm03tuLKVb9R/z+aifn/zMgyZp4b1V?=
 =?us-ascii?Q?dq50HuMjLWpWEUdTpbPpICxpNKah9/Es6yjVBeWTjAmycOqTD5Jmc+FhEZDb?=
 =?us-ascii?Q?U3engGrDy7nR/yspXzEe2hdEBDrHKvkqUDKICmZ6bulE4YZS0ZFtVpiv6o0F?=
 =?us-ascii?Q?zCezOpyowMNSv0GVelKoS3O4?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc98e2ec-7925-4c0c-2871-08d8d2c054c8
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 21:17:57.2611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bP/0AmcUl5+RX6/yYUS/m/TkKYsB585MfJuF+J9oB91NhTUF6OIS84HbLIm8yO5M2y3CUaa1gVc0y0JjDm2XAfbNkkAj64mHh1k4MrXmSRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB0879
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_12:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160172
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
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 84 ++++++++++++++++++++++++++++++++------
 include/linux/brcmphy.h    |  4 ++
 2 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 91fbd26c809e..8e7fc3368380 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -103,6 +103,64 @@ static int bcm54612e_config_init(struct phy_device *phydev)
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
 /* Needs SMDSP clock enabled via bcm54xx_phydsp_config() */
 static int bcm50610_a0_workaround(struct phy_device *phydev)
 {
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
 
@@ -390,7 +451,7 @@ struct bcm54616s_phy_priv {
 static int bcm54616s_probe(struct phy_device *phydev)
 {
 	struct bcm54616s_phy_priv *priv;
-	int val, intf_sel;
+	int val;
 
 	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -408,8 +469,7 @@ static int bcm54616s_probe(struct phy_device *phydev)
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
index 16597d3fa011..70303c94763f 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -132,6 +132,7 @@
 
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC			0x07
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_WIRESPEED_EN	0x0010
+#define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_EN	0x0080
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_SKEW_EN	0x0100
 #define MII_BCM54XX_AUXCTL_MISC_FORCE_AMDIX		0x0200
 #define MII_BCM54XX_AUXCTL_MISC_WREN			0x8000
@@ -219,6 +220,9 @@
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

