Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 090BC90282
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfHPNKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:10:50 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:61428 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727289AbfHPNKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:10:48 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7GD7nfs020795;
        Fri, 16 Aug 2019 09:10:41 -0400
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2057.outbound.protection.outlook.com [104.47.37.57])
        by mx0b-00128a01.pphosted.com with ESMTP id 2udu300ay8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 09:10:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJxhm+SlXrfxhse+S84fuHJnx5VdUh1Gtk7HOivotpq7ZkM2gvamXzVCnrtzAOGsK9YTFdVySisz1Oj3Xt7FiEvVGmjNbW9E1aUI2/CHxoiVZwAbOzQ4k6d4YGEiN8LxA+rlCaFbUhqT3kfbjgqthWRvSkXTTOySJCZl12UzQqFgQtKRCfhS1/EanjMAu0iLNMnAjiJkjcDl1vQr6LL6SKAsu8x6NQkBVI7ufrZ3ybYfypELb6MP7QgbOFh0tNpr6bl3bYtdgibz/pTitRyZKxVHYEHVhOIXtCBM2glwPMX6plvYVho2kkp9OtKh6oZQzgsaEmXPyYwfcw6TufTfFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OI8CrJEgouP1A1JQL3YtGjCiLXI5NYSTvF/5MH0a704=;
 b=frCaiNVtPjcagD1o5OAgWP2RFbYmnhmy9D6GMz/Y28XIU2Gc4hSUIFLVlUO9p1XlzDvVGM5T8OrJkFv9xsTxbh0RtIOEZq6LyZVAz1Jwtje1Tkg9zW/Cb8njAOUu/Tg6QQ7OsiXTGWuXuSzUe1/sQgxaLULbXA8z1pAIu6oM0wgEnloRJhdsH1MU8CqjYHe3Qvs/1HlajJ7272bDz9Fi8CU2n8BpNsYoC+kEYReei/Lri0fNSLbBI0qeYZTd3A75DOPhmtfdyd+ZDYSg3UITWMx3aM7kvdWLp/F6QrX2g403h/Y3OFUvrvvf3ti6gzfuWGt8WbsIgGmpi7CZt9tSbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OI8CrJEgouP1A1JQL3YtGjCiLXI5NYSTvF/5MH0a704=;
 b=p7zfPeZSgOZc1NcT8Ec2/84t2MSqahWsiFpQvIPDHPYtGWGiasGywhe80LISgN2mWQNm/B0ktxGgnXNXl8nzIWcZZV/f0o8Dd8WLGOLoYAAygEOo7FjsloQvG9eTB8m4BiwVorPl5rBPt7PZbYLbh8h4dH3tvZdSZGDgvQ0l/cg=
Received: from BN3PR03CA0095.namprd03.prod.outlook.com (2603:10b6:400:4::13)
 by BYAPR03MB4662.namprd03.prod.outlook.com (2603:10b6:a03:12f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.16; Fri, 16 Aug
 2019 13:10:40 +0000
Received: from BL2NAM02FT029.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::209) by BN3PR03CA0095.outlook.office365.com
 (2603:10b6:400:4::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2178.16 via Frontend
 Transport; Fri, 16 Aug 2019 13:10:39 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT029.mail.protection.outlook.com (10.152.77.100) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 13:10:39 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7GDAdEK007911
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 16 Aug 2019 06:10:39 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 16 Aug 2019 09:10:39 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 08/13] net: phy: adin: add support MDI/MDIX/Auto-MDI selection
Date:   Fri, 16 Aug 2019 16:10:06 +0300
Message-ID: <20190816131011.23264-9-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816131011.23264-1-alexandru.ardelean@analog.com>
References: <20190816131011.23264-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(39860400002)(2980300002)(189003)(199004)(1076003)(14444005)(356004)(6666004)(107886003)(2201001)(4326008)(2906002)(86362001)(36756003)(2870700001)(50466002)(48376002)(8936002)(106002)(47776003)(50226002)(8676002)(51416003)(70206006)(44832011)(246002)(70586007)(305945005)(7636002)(7696005)(2616005)(486006)(126002)(5660300002)(478600001)(476003)(316002)(336012)(11346002)(26005)(110136005)(426003)(54906003)(446003)(76176011)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4662;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4069b8d1-28ed-42f7-6166-08d7224b22d0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR03MB4662;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4662:
X-Microsoft-Antispam-PRVS: <BYAPR03MB46623546BB7E9B6EBE6BFA52F9AF0@BYAPR03MB4662.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Q182EmokodbG5xAYVoFHWUWBDEaNnjFSjjWdymDhrHzdl0SNa7B3CnHJf0Te0DC9bnW/OtGqKeSzRmJGxKVp6alH7dKsTEGYnlk6GL9OSSwxmdjqDpMknUyDlmFXPflNlJs8j74mpLpoiB25tdvQUAmdZ/UQQI0f0mQVaDUwcjbsf4zbKGv9A5ojXPYnkxJkpMpiu7luIO9UE/t+i0P12UxVuuGhijtSMdO7diA1874mqH5MWrDW2oRWXJ3P/gWiH2ijhKxVgm1eLxtNzfNk2jzYr4iBWl4eQ7Hfl1qbycGlYTFA7w3NsYmsxQMLq6mFdRuoLQrD8Bec9k92R+GaTqCLn95Gf/7yifxQkv6/Gxuo3Qce4yWx3pPQsNskdxXU4H++tigVI/gaMP1E5UQ+LrKbkvZrtmjWbJd2c8+M0nw=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 13:10:39.7167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4069b8d1-28ed-42f7-6166-08d7224b22d0
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4662
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160136
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

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 117 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 113 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 4ca685780622..51c0d17577de 100644
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
@@ -33,6 +37,9 @@
 	(ADIN1300_INT_LINK_STAT_CHNG_EN | ADIN1300_INT_HW_IRQ_EN)
 #define ADIN1300_INT_STATUS_REG			0x0019
 
+#define ADIN1300_PHY_STATUS1			0x001a
+#define   ADIN1300_PAIR_01_SWAP			BIT(11)
+
 #define ADIN1300_GE_RGMII_CFG_REG		0xff23
 #define   ADIN1300_GE_RGMII_RX_MSK		GENMASK(8, 6)
 #define   ADIN1300_GE_RGMII_RX_SEL(x)		\
@@ -206,6 +213,8 @@ static int adin_config_init(struct phy_device *phydev)
 {
 	int rc;
 
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+
 	rc = genphy_config_init(phydev);
 	if (rc < 0)
 		return rc;
@@ -269,13 +278,113 @@ static int adin_write_mmd(struct phy_device *phydev, int devad, u16 regnum,
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
@@ -287,8 +396,8 @@ static struct phy_driver adin_driver[] = {
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

