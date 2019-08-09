Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB3287B67
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406677AbfHINgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:36:25 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:28638 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406643AbfHINgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:23 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DNFu7011289;
        Fri, 9 Aug 2019 09:36:15 -0400
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2054.outbound.protection.outlook.com [104.47.40.54])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u8tcbtf82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RE+hbca9UmHNaHbvOF1eWzDNT32ROMzKx3AogztlPFpFaPPxr29PoTRZYoF5yp1a+ivR3jnwDDVl+LGQ/WAbfbbsBpjRiRr67+tP3ftZDe+DwWnHrI63DMv4E5DNtAL00FcLQ4NeIPXWawmQXvYLzQYxtEzuZLU9N4ojxCSRoTMniL9S56TyYfk5RqpXmqI5+AZkl0nDRihNdAzbM1cmYF9L4KVRrsXiGKeJ3GDn58Zm35sLFD55ti0BZz+2z/hRcNgvti00VRUA7qUyxHQ+R9Lukfn6egplw9WL0kJV5bNttQ1KA8zvWdoWJk0L8fZoBjj8Hhv/CgWdrogG1qvJzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBxvKF2+C06nQ1uQ8Hbs8aNfnfqNRns+IMReaYARIxQ=;
 b=Or9fySI5I5NaPmaFFnQxCc7ib8VGfiNk26qK5iUkuNXvT22Pd80jQ9lkVxZrnRrFI1xYDBvMjMunfxy/s8jQxJAcnWwu1csyzgQ7RmxyhpGMi6OarxdiL+w39CgtLdEygFzDKoPN++QvhR86WP9ep+oSKUOHfDKBF9zGVOj3/PcUUD9PKWER3ATEBc0XmLzs4CqrfNQ9I5hCKmzCPzLSS562PCBh6mb478zjLAIJ1Wu1fdBlkFMG2IpWa6aupoAED9iZB0itoL20nmGAmCZgEpO1qOYs/fotN74Xj13kb2wUqhdnBOE7NhG+hilIrtExX0k5CbnADR3OOB39HMEaRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBxvKF2+C06nQ1uQ8Hbs8aNfnfqNRns+IMReaYARIxQ=;
 b=p+IMZffy874tgsEbkUy8C5Ez1TBspGPN2gprMuNugyE7eadCuto/wcj7U30TPDj7JBHXtdjo2HaU7Gj6tLBeO+oOdemk0pKfSGbWJFRAM9X/bN3TmgnAviyFbN3AU08mRSYdMxrIVud75/UAvDN6oIwcHJGS6LMxYrXrA735vVQ=
Received: from BN3PR03CA0055.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::15) by SN2PR03MB2414.namprd03.prod.outlook.com
 (2603:10b6:804:15::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.20; Fri, 9 Aug
 2019 13:36:13 +0000
Received: from BL2NAM02FT064.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::203) by BN3PR03CA0055.outlook.office365.com
 (2a01:111:e400:7a4d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.15 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:13 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT064.mail.protection.outlook.com (10.152.77.119) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:36:13 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79DaDmp025713
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:36:13 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:36:12 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 08/14] net: phy: adin: add support MDI/MDIX/Auto-MDI selection
Date:   Fri, 9 Aug 2019 16:35:46 +0300
Message-ID: <20190809133552.21597-9-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(396003)(136003)(39850400004)(376002)(2980300002)(199004)(189003)(246002)(6666004)(36756003)(54906003)(110136005)(106002)(14444005)(5660300002)(356004)(478600001)(8676002)(107886003)(4326008)(305945005)(7636002)(316002)(2201001)(86362001)(50466002)(76176011)(7696005)(51416003)(70206006)(70586007)(8936002)(486006)(50226002)(26005)(48376002)(336012)(186003)(11346002)(2906002)(2870700001)(1076003)(426003)(126002)(2616005)(476003)(44832011)(47776003)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR03MB2414;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6037f2af-5d95-439c-b4fa-08d71cce8c13
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:SN2PR03MB2414;
X-MS-TrafficTypeDiagnostic: SN2PR03MB2414:
X-Microsoft-Antispam-PRVS: <SN2PR03MB24146074C980C9E124824D7FF9D60@SN2PR03MB2414.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: gwFNO065mEP4E3EZl/imxHwCEq2ANfOlXywk1T6I4csrexeAhfUMP0ETa9Rb0nrPf8eGtMlszraiSeKa/ME1/qZLLH7TqCsWUHOMefTdXP4lkIe1oBhoRVEKw35dZ8NJmWpl5F3nRjSYf3oGAdR6YYote/N29+CXAnHqkLAWX+IFGHkSDsn6hIOJtaHRNsdzW+5qmIt2c/OT1G36Yqt/FW8gBCzophF819HPHVvmfuhxbT9Bk0+hkWB04KWvqv8sO3I9Y+g0W74uQeTCco7DxjiZKiAyftkh8Q7JODMCLMxMJfWuk8JBIFFwb4puedfoVlcmW0EmXKYDRV4uojc/lEDAZlKnVMEauXaCXFjFJPwarL/5IhgSXTP/r/6uKQoKC/fFhP7E1dQYYpMhnUdriacGXtaVhVF6ZLGlZ2a0cmo=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:36:13.4196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6037f2af-5d95-439c-b4fa-08d71cce8c13
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR03MB2414
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090138
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
index a076887bf165..45ab89ec1b59 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -19,6 +19,10 @@
 #define ADIN1300_MII_EXT_REG_PTR		0x0010
 #define ADIN1300_MII_EXT_REG_DATA		0x0011
 
+#define ADIN1300_PHY_CTRL1			0x0012
+#define   ADIN1300_AUTO_MDI_EN			BIT(10)
+#define   ADIN1300_MAN_MDIX_EN			BIT(9)
+
 #define ADIN1300_INT_MASK_REG			0x0018
 #define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
 #define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
@@ -35,6 +39,9 @@
 	 ADIN1300_INT_HW_IRQ_EN)
 #define ADIN1300_INT_STATUS_REG			0x0019
 
+#define ADIN1300_PHY_STATUS1			0x001a
+#define   ADIN1300_PAIR_01_SWAP			BIT(11)
+
 #define ADIN1300_GE_RGMII_CFG_REG		0xff23
 #define   ADIN1300_GE_RGMII_RX_MSK		GENMASK(8, 6)
 #define   ADIN1300_GE_RGMII_RX_SEL(x)		\
@@ -208,6 +215,8 @@ static int adin_config_init(struct phy_device *phydev)
 {
 	int rc;
 
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+
 	rc = genphy_config_init(phydev);
 	if (rc < 0)
 		return rc;
@@ -283,13 +292,113 @@ static int adin_write_mmd(struct phy_device *phydev, int devad, u16 regnum,
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
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
 		.name		= "ADIN1200",
 		.config_init	= adin_config_init,
-		.config_aneg	= genphy_config_aneg,
-		.read_status	= genphy_read_status,
+		.config_aneg	= adin_config_aneg,
+		.read_status	= adin_read_status,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
@@ -301,8 +410,8 @@ static struct phy_driver adin_driver[] = {
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
 		.name		= "ADIN1300",
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

