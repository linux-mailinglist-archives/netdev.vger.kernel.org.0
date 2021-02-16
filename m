Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF6231D2DE
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBPW4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:56:19 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:6344 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230448AbhBPW4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 17:56:09 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11GMqjWq028214;
        Tue, 16 Feb 2021 17:55:14 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2055.outbound.protection.outlook.com [104.47.60.55])
        by mx0c-0054df01.pphosted.com with ESMTP id 36pcj9h0yg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 17:55:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huTbXoN8s71lvYiWlIh2xAPUGCJcIBSb8Yxdq+RzaELL6LE98rvXafv6X4s6zTO3qh36Db64NOCuzt8+AiEtuRGk9g41MF3teWXvuZrLGLvfNJyLw6p4blPDIj+J+f/XtIZrfC1vHnR/xCM8k60bkXif7bFSjMZ6iiB25GWu4mUYsymTlqnGLyEjJQ8GFYaexZ9d1xUqEI+p8MEd8NvPt5ACGa89BsZVqIYvCN7zx9OKJ9DWYP/HnJ3tagTZiu7prSnswk9957kGAj6NZ91PcS2TtpSjwbLxQ3BuHsqbunaAexWqk9RNS2wFCbJ1Cwc3QwLUkRmKRMHHboix4zgAsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKLWfW3/XNrkPAuITM6iWU1g9lDmXgfGbslpwssiSwg=;
 b=mkK4J4WJWs5jT4PECyLG/vNLt5oeqJL0HFr2GxTpZmIzyBnMFBkQHS2VdSFfflIrwVtBBinBklbVgZiBBGZ5/5L4eGXpIMxYodleQMpzKdIlNX//S4e+P9N42wle8abLWAcKG24GqO0mGpry7+rRKFIwRJat81DZC/hDWLkLjU6v8JF2jlIL8BrRdBOVaJCfoYFvw/2sMV6mBQrS8btjfNBypkD35OZBRQmQbkY56NoHvbbBxeMkENNXsssWP+ezuv6rFMEluo7cQ6OFHEE+pPnSVG1jNa9pZvt1B6V7VAN+yuE4R63EjWHTMOK0L4p+Z+A9y5ZaaeLV3SW7Nk8PfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKLWfW3/XNrkPAuITM6iWU1g9lDmXgfGbslpwssiSwg=;
 b=5v0ChIA0+GTFHWHQygrvzBXdb/OwbWfP8BO5SXIYem5cVMazw2yUmb+raAZhr8Qk4OlamyhM5vRXxqp8N9fCwQEUcRY+2944KQcp3X01+4nolyf3yl6LaWEk1MkGGXRb51A+KfYeWTjsfJ6Sq8YHswik3xhXjR8zb57XBk5qSUM=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB3119.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Tue, 16 Feb
 2021 22:55:13 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 22:55:13 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 1/3] net: phy: broadcom: Set proper 1000BaseX/SGMII interface mode for BCM54616S
Date:   Tue, 16 Feb 2021 16:54:52 -0600
Message-Id: <20210216225454.2944373-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216225454.2944373-1-robert.hancock@calian.com>
References: <20210216225454.2944373-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YT1PR01CA0034.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::47)
 To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YT1PR01CA0034.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38 via Frontend Transport; Tue, 16 Feb 2021 22:55:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a436836a-6671-4b3c-f980-08d8d2cdeb71
X-MS-TrafficTypeDiagnostic: YTBPR01MB3119:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB3119C5C239E8A8531CFA802FEC879@YTBPR01MB3119.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aVwDTDcEv3OU0Rz5zTwynm+oq8CygAUvJccWv5EyCisOeCQqc5nn3wRi1MbILRzMDpah6BHJI3Q5W3Kbamiv6re5b36hfEvzftpTL+D1Kj4ISWQ3UHA1Fijs5Mw5sahoFLNOC23PEd1m4jAn95s8ZLNilYrj4QYRVBjWBhsA8gbgPDGN9TYSevJH2fiJyq/kRVd0dSRWslcilV2vGTLJwo1JzNx2RD2fDCUohwpveqXQNHRm+kZ0z5bRuMKA4iXZT0b6N/pm4uu5LGi1OjF0q+04yclxojVIHu/71XnUy4QNjBO6ZuOcnkI6aOu0j7FsGokuiaI/DgL4A91LrSmdZ68ZShjI86ekQozgZ3FDm5g66IbYi8qitko4FSrs592lEpAI2BH5glyG0hWH9hxdrbJyWdPJs1eU5QKAtKRQu8Z2a7GAiaBbfCjRuV7Zghgg8tbbtX2xRGB0fYMZr9E9PWkckd4ajt916pblmmWUvI2wwYogIn76RM37gq3n6ibnL/p1QQLO+Z2UZZANFd9zQoVxWO2G01CpzKU8LxY3IyXB9JhLKI+b2z9qb7M+nG7HEOHLlze8iCsvn7lf1OTez/1GSh5L4jedNuY1usQsxbYowuN2LWYZOhX4UrSy2+J6xwzXbXkeB+jNCqEP5Wz+Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(376002)(136003)(346002)(396003)(4326008)(8936002)(5660300002)(36756003)(966005)(66556008)(1076003)(66946007)(16526019)(2616005)(956004)(69590400012)(66476007)(6486002)(478600001)(107886003)(26005)(6506007)(86362001)(44832011)(6512007)(2906002)(52116002)(316002)(83380400001)(6666004)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7f7IfzrQ2ntYXJrKYveK6/Z2mDlSLoXThfRud8F4EEYYTyrAgE6RDockdPvx?=
 =?us-ascii?Q?S9DQ5YVFhEA9gtnpcSvR1wc2yNWXqr52m7fk49Eu6IxebfaG69SZYK6znsqH?=
 =?us-ascii?Q?/dAjebolsiWRdkNI2roP3wy+TYV/5DSOYyUux72TxzL2U1/D4ORbaGnLRKhT?=
 =?us-ascii?Q?JnryTOWOCkmxHNq7JnyReUPjUxW5Tk3kMrIc7a/lkDy1FDTEM9w9HGBFXqIp?=
 =?us-ascii?Q?TUbSF59DnjkH1EhZvHjt5fanO/r0U5qGUd5Y5ZvS5vZfY8yumwvY4ZVEI3LJ?=
 =?us-ascii?Q?X0SZnkX4STM67IjzXUG7T97x19wzbsIPR9hHyOzJMtbxdP9+h5fGCVpbsaA6?=
 =?us-ascii?Q?xMhyIccAqKNBN1yjfUsx3pefKukQ2rdPYktbvbuFHWRqmj2aq5tlIfuSoxbS?=
 =?us-ascii?Q?sgpS2AgappX8otILP25z0HmJ8T1o2rAAy0hhtvAmMXmP5mvQQUb6NiR2FZbM?=
 =?us-ascii?Q?AfywhbzerQeUtI9RLqQl4ZFRW9cip24TCdlXDQ9IOxMQc8fcNKkDDe0MmLps?=
 =?us-ascii?Q?LYzbG+2V7fv4bu6eOoyrOlV/lQxR+DbMpgYRY7wniFx4bh2ucxMUdXkECsA4?=
 =?us-ascii?Q?BYq9yeCT+CvLf0jStvAInpmLL2TkdUQnJXGY4KlctiqDhLouAWIScCDk2yj7?=
 =?us-ascii?Q?Mrhc/je0g8ZEvhxQIpjU73n72ApD2kGbx5JYYmr/AcJyNdqMl/80YgbMVJW1?=
 =?us-ascii?Q?CS5qwzfvYTwfbgd7lnMIVE2HX8gQCzYi9HHpOgsxDc9HLvw3h9AmIefW23fv?=
 =?us-ascii?Q?LdgLnqP2UH6Z9v2os/3BMUyrWie+LYtVL9mvD1qdyjc3cRDC8uYs3/s9nw/e?=
 =?us-ascii?Q?DIWYXka37C3IXvazMVbv9uCBmYTA+cN8EIEl+gVhyQFncLcxQ+AtaoFG/UVJ?=
 =?us-ascii?Q?6/wYAt13k0/HJFv6b0NJCPk28Q9BGsFf/gkD0tfm+C9Xek1pALfvSGVgmarZ?=
 =?us-ascii?Q?H4rE91RQf5sxokolofDA2CaVutxvt0A827zi/krHHDdSm9vwqt/pMwg/QF5j?=
 =?us-ascii?Q?rVNHQH1KKLhbdtifek/D4GV80FztA57eWs04qBIkjJ6uSjw1Sx2v5B5PW5Hb?=
 =?us-ascii?Q?5H7NaC73UPduR4Z9/wudY+BhDdjp5npAKViHl1xxx1hWKUOSDeoLWRCL0bPI?=
 =?us-ascii?Q?hvXS1MXeWDJVqtf8ejC3VKwpsZ/JI06fCZu9EJMEypgcR4rQMbwcQAydxDG9?=
 =?us-ascii?Q?gve6p4qd7atyWlXRsAOooId0pduXcHiA+BnFtQhNk9tjYl+x/nAfTfttqESA?=
 =?us-ascii?Q?p638dQ83MS3EbJEBvmrQvCyd8bJLeaPqayVsk9iVxQAj/nb6k0XOg2fu2IKu?=
 =?us-ascii?Q?4V4hQ6xvtGuZYTeXd5mJ9Im1?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a436836a-6671-4b3c-f980-08d8d2cdeb71
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 22:55:13.4708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ONzRNaNBO6hZhswv1iZZDZUs8bvauoACSVVua5OfvASCf+xgHFApDczinnRYkQmMVrVr/naerMXVFJJiUAOaD0KdGCQeH/bmgEZs6hbJqGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3119
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_14:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160183
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
index 8fe1d55371ac..c2c2147dfeb8 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -129,6 +129,7 @@
 
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC			0x07
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_WIRESPEED_EN	0x0010
+#define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_EN	0x0080
 #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_SKEW_EN	0x0100
 #define MII_BCM54XX_AUXCTL_MISC_FORCE_AMDIX		0x0200
 #define MII_BCM54XX_AUXCTL_MISC_WREN			0x8000
@@ -216,6 +217,9 @@
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

