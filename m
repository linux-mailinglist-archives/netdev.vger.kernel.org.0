Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4C181E1D
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbfHENzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:55:36 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:12090 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729483AbfHENzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:35 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75Dqnb7015553;
        Mon, 5 Aug 2019 09:55:27 -0400
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2059.outbound.protection.outlook.com [104.47.40.59])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6kb20e1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xc7twsGfddK1lyLaCdVHXngZbW62joH/ZlnKM+ynliX0PuAtBEbV1taX5at2No8M5C4YTeOHqMdibQb7xrcbtS7vo9nCC+8f+uym3pLIEGuPd4NBb9OPEot2OclkJgl6ln00QkNyVntx3HBLLAuKmIJ1B9IMXjB9E4HkAaeTD3BVHT99X8j7G9yudXmMTzkmghuU5EIhbd9Ko1HaPz0YWDDW7zMWiSaGsix2mvdLKYeqGtJmBEQuzLbiyOZtbsgMNCwXeQLaJBpBsLv9HaBHnrKAMAZ48qlSRTz1v2KBm3XpqL0bPB2+jm9+FgyFbyRfTqDUyTd+0/ZEVq2xYsbMrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnsTKQ4A7d6vqt3RgY33uvBHqi8QxZMIKNq+w5u/PV4=;
 b=GQnRB8UeUG4IvlRod+hRoSnCvAW98Qu3G5zXwSaSbEhfBsE1LfA+AkN2qyX5vAKx1Sjun3kPyTt6Hz0CRqfBtsw2sKc7XLjkdbCXMdtxQXWCnXX5VtPxwEOx8X2Kw6+EJmlcx02Mg66UL3fcrFfdklss+sQrwdVNc4EB50hpgBV7S9LaCFpBgWYKwZ5TjDMX39heyZ325BtG1HlC6tKwUmYztX6KREJF+pWvk5SwRGXUPWqnzVmayCGzioOa2NbzrsLhtDWcYf3ouECoPADX63yvTn60zaKYVAd1mFpdyECrv7ds7u5JPccLsnWkeUY1B+voTszOSMF/IEqPTjWUbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnsTKQ4A7d6vqt3RgY33uvBHqi8QxZMIKNq+w5u/PV4=;
 b=l96ejlqGYGSGI5y2AH4L0pntmrpc+pX+LkkoAfeg4aKjUBmnkVBpJOkIkRfxUzLxJ58di0JkHgb6TPU2su45j1tBK/W4NlqtvxwXReX8aDN6Kqy25rKfQntkgDG/4+VQHeyR5alGrWSfWBHymx7kZAUeS5v6N1kogFYWJffFIG4=
Received: from BN3PR03CA0085.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::45) by CY4PR03MB2838.namprd03.prod.outlook.com
 (2603:10b6:903:12f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Mon, 5 Aug
 2019 13:55:25 +0000
Received: from BL2NAM02FT032.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::201) by BN3PR03CA0085.outlook.office365.com
 (2a01:111:e400:7a4d::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.20 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:25 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT032.mail.protection.outlook.com (10.152.77.169) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:25 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75DtMEN016216
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:22 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:24 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 09/16] net: phy: adin: add support MDI/MDIX/Auto-MDI selection
Date:   Mon, 5 Aug 2019 19:54:46 +0300
Message-ID: <20190805165453.3989-10-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(39860400002)(346002)(376002)(136003)(2980300002)(189003)(199004)(186003)(8676002)(48376002)(305945005)(50466002)(7636002)(107886003)(4326008)(5660300002)(1076003)(70206006)(70586007)(2870700001)(478600001)(246002)(8936002)(51416003)(7696005)(50226002)(2906002)(47776003)(86362001)(316002)(6666004)(106002)(76176011)(26005)(110136005)(36756003)(54906003)(356004)(426003)(476003)(126002)(446003)(2616005)(336012)(11346002)(14444005)(486006)(44832011)(2201001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR03MB2838;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 162e6474-8747-4e9c-0539-08d719ac90d7
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:CY4PR03MB2838;
X-MS-TrafficTypeDiagnostic: CY4PR03MB2838:
X-Microsoft-Antispam-PRVS: <CY4PR03MB2838BD4FE46C9576B326F89BF9DA0@CY4PR03MB2838.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: LWPWTWmR9twbYvtJm0EJaMWsTympF/VMD3Ce6Fes7aI0coxxSxqooc8FEY133Xixjk33+gPjzS8DsDQilvT1ER+BVKe9ocYDcINNGNmom2mVnKAISz7scGgPJ8nlXm85eDLRKDD7elYEOQ3JN3WbmI5RDymPg0J6HaRCjVfLdy4gNeqJJkULZjwg1NUZ2RgYt4gz3Irrp6HsgtXcDd6XDIA/AwJtbUzipt/yPLmjHp8ThvxW/cIwM+2ZV6lXwyh4Zl622E+kgb2Og3JS0alYFeyWVsV9GtZhxlJ7JA17TNm/t1eg29XP8HkqkWVRzEfxzI8HhbfgNfEFRdxfQ7cfHJ/CyB/JCZsr+ylwY9mILV4CPtxqEsL9+CvP4U5uNbmHyY4u8iu8JcOAwiU5CmEK+TUnfcw4jDIslQZlkHukETk=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:25.0233
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 162e6474-8747-4e9c-0539-08d719ac90d7
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR03MB2838
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN PHYs support automatic MDI/MDIX negotiation. By default this is
disabled, so this is enabled at `config_init`.

This is controlled via the PHY Control 1 register.
The supported modes are:
  1. Manual MDI
  2. Manual MDIX
  3. Auto MDIX - prefer MDIX
  4. Auto MDIX - prefer MDI

The phydev mdix & mdix_ctrl fields include modes 3 & 4 into a single
auto-mode. So, the default mode this driver enables is 4 when Auto-MDI mode
is used.

When detecting MDI/MDIX mode, a combination of the PHY Control 1 register
and PHY Status 1 register is used to determine the correct MDI/MDIX mode.

If Auto-MDI mode is not set, then the manual MDI/MDIX mode is returned.
If Auto-MDI mode is set, then MDIX mode is returned differs from the
preferred MDI/MDIX mode.
This covers all cases where:
  1. MDI preferred  & Pair01Swapped   == MDIX
  2. MDIX preferred & Pair01Swapped   == MDI
  3. MDI preferred  & ! Pair01Swapped == MDIX
  4. MDIX preferred & ! Pair01Swapped == MDI

The preferred MDI/MDIX mode is not configured via SW, but can be configured
via HW pins. Note that the `Pair01Swapped` is the Green-Yellow physical
pairs.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 117 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 113 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 2e27ffd403b4..31c600b7ec66 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -21,6 +21,10 @@
 #define ADIN1300_MII_EXT_REG_PTR		0x10
 #define ADIN1300_MII_EXT_REG_DATA		0x11
 
+#define ADIN1300_PHY_CTRL1			0x0012
+#define   ADIN1300_AUTO_MDI_EN			BIT(10)
+#define   ADIN1300_MAN_MDIX_EN			BIT(9)
+
 #define ADIN1300_INT_MASK_REG			0x0018
 #define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
 #define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
@@ -37,6 +41,9 @@
 	 ADIN1300_INT_HW_IRQ_EN)
 #define ADIN1300_INT_STATUS_REG			0x0019
 
+#define ADIN1300_PHY_STATUS1			0x001a
+#define   ADIN1300_PAIR_01_SWAP			BIT(11)
+
 #define ADIN1300_GE_RGMII_CFG_REG		0xff23
 #define   ADIN1300_GE_RGMII_RX_MSK		GENMASK(8, 6)
 #define   ADIN1300_GE_RGMII_RX_SEL(x)		\
@@ -175,6 +182,8 @@ static int adin_config_init(struct phy_device *phydev)
 {
 	phy_interface_t interface, rc;
 
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+
 	rc = genphy_config_init(phydev);
 	if (rc < 0)
 		return rc;
@@ -263,6 +272,106 @@ static int adin_write_mmd(struct phy_device *phydev, int devad, u16 regnum,
 	return __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_DATA, val);
 }
 
+static int adin_config_mdix(struct phy_device *phydev)
+{
+	bool auto_en, mdix_en;
+	int reg;
+
+	mdix_en = false;
+	auto_en = false;
+	switch (phydev->mdix_ctrl) {
+	case ETH_TP_MDI:
+		break;
+	case ETH_TP_MDI_X:
+		mdix_en = true;
+		break;
+	case ETH_TP_MDI_AUTO:
+		auto_en = true;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	reg = phy_read(phydev, ADIN1300_PHY_CTRL1);
+	if (reg < 0)
+		return reg;
+
+	if (mdix_en)
+		reg |= ADIN1300_MAN_MDIX_EN;
+	else
+		reg &= ~ADIN1300_MAN_MDIX_EN;
+
+	if (auto_en)
+		reg |= ADIN1300_AUTO_MDI_EN;
+	else
+		reg &= ~ADIN1300_AUTO_MDI_EN;
+
+	return phy_write(phydev, ADIN1300_PHY_CTRL1, reg);
+}
+
+static int adin_config_aneg(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = adin_config_mdix(phydev);
+	if (ret)
+		return ret;
+
+	return genphy_config_aneg(phydev);
+}
+
+static int adin_mdix_update(struct phy_device *phydev)
+{
+	bool auto_en, mdix_en;
+	bool swapped;
+	int reg;
+
+	reg = phy_read(phydev, ADIN1300_PHY_CTRL1);
+	if (reg < 0)
+		return reg;
+
+	auto_en = !!(reg & ADIN1300_AUTO_MDI_EN);
+	mdix_en = !!(reg & ADIN1300_MAN_MDIX_EN);
+
+	/* If MDI/MDIX is forced, just read it from the control reg */
+	if (!auto_en) {
+		if (mdix_en)
+			phydev->mdix = ETH_TP_MDI_X;
+		else
+			phydev->mdix = ETH_TP_MDI;
+		return 0;
+	}
+
+	/**
+	 * Otherwise, we need to deduce it from the PHY status2 reg.
+	 * When Auto-MDI is enabled, the ADIN1300_MAN_MDIX_EN bit implies
+	 * a preference for MDIX when it is set.
+	 */
+	reg = phy_read(phydev, ADIN1300_PHY_STATUS1);
+	if (reg < 0)
+		return reg;
+
+	swapped = !!(reg & ADIN1300_PAIR_01_SWAP);
+
+	if (mdix_en != swapped)
+		phydev->mdix = ETH_TP_MDI_X;
+	else
+		phydev->mdix = ETH_TP_MDI;
+
+	return 0;
+}
+
+static int adin_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = adin_mdix_update(phydev);
+	if (ret < 0)
+		return ret;
+
+	return genphy_read_status(phydev);
+}
+
 static struct phy_driver adin_driver[] = {
 	{
 		.phy_id		= PHY_ID_ADIN1200,
@@ -271,8 +380,8 @@ static struct phy_driver adin_driver[] = {
 		.features	= PHY_BASIC_FEATURES,
 		.flags		= PHY_HAS_INTERRUPT,
 		.config_init	= adin_config_init,
-		.config_aneg	= genphy_config_aneg,
-		.read_status	= genphy_read_status,
+		.config_aneg	= adin_config_aneg,
+		.read_status	= adin_read_status,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
@@ -287,8 +396,8 @@ static struct phy_driver adin_driver[] = {
 		.features	= PHY_GBIT_FEATURES,
 		.flags		= PHY_HAS_INTERRUPT,
 		.config_init	= adin_config_init,
-		.config_aneg	= genphy_config_aneg,
-		.read_status	= genphy_read_status,
+		.config_aneg	= adin_config_aneg,
+		.read_status	= adin_read_status,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
-- 
2.20.1

