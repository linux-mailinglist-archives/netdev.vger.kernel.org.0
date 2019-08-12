Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75D9E89CAB
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbfHLLZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:25:15 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:55902 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728305AbfHLLYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:24 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNQUs018364;
        Mon, 12 Aug 2019 07:24:16 -0400
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2054.outbound.protection.outlook.com [104.47.37.54])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u9qs7w662-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VT+tC/8QTm5Ct4Ib2anx/NNlJGyir8e6kEW0fN9iGPDs7QQ3maneMtKfpYEb3htH1a6Npr0aDA5FB26Xg/+ef8Yu9FV32IiUnE2uD2DxqL0hv4RxyyPDdQbguoZyqc0eeKujKaddyQZHB8JdwponmwLVmCByGqql/G9meZqGAeN2cnAQBCaxST6CQThZkZBPjGXMakfB1/nTdPtxpU1g71YPT4VQFNQPeyr7XojS8Uzx+MfNYgzagUSQIG/sTMPFZYFquDnuiWrumfAm3nutzoOtMTd8RA1sRKuNKfChsElihFEdlSr/OM2oI4Mpmzr6ErwhQxEGEi/UxjW++vsgXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4GXclNtPOXNPJ+I4/x5vKJjwp3d0C0cyqdKc9iWgm5A=;
 b=Ir5c9T6A+VIxPsCqm/B1Zhbt7K8dI2IDKKI3GEbGsJLjo5ni3YgFxbfJ6cORUETHdHaGhn/vy6MjHJhyWh5GgBel9bxD6BmsAwMqjLr8LrwlX7EUpIv6VndfBM14yn1StorLDhOxAtmZBQ5pR6EyvJAcEoimEX55y0tdvi6U/pTqYknuFvtqycbCEl/Vz4HfpjWhz0229nn12q2sAIwb9e1eoO63a8RN4vbebmj7Z3C3641d034LythgVZB//4SkPuCRM6KkOQ3ykzmI3SJiHsTZdUgVjiPWHvVcl6AWLsbfC2TgXbVjlmVbh7+OE7qRrq97rnPEcFwgCR+14vlyyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4GXclNtPOXNPJ+I4/x5vKJjwp3d0C0cyqdKc9iWgm5A=;
 b=9GR2xNJdFkOJyWRzlnRqoIVrfNW0EvHhD+2qJI6GWUe3RCqNZFmGFF06ftm+ftuVMp2MZ/ri57ErJOBenbXexFPohz+Q7opA3YDqgMcKKcwBsa3ZTq55peDpZkvZxWEq08m3SHG8bAgdxIn7IU0F6Qu3CHDMED7VFkXRJHVQtoE=
Received: from MWHPR03CA0010.namprd03.prod.outlook.com (2603:10b6:300:117::20)
 by BN7PR03MB4466.namprd03.prod.outlook.com (2603:10b6:408:3f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16; Mon, 12 Aug
 2019 11:24:14 +0000
Received: from BL2NAM02FT057.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::207) by MWHPR03CA0010.outlook.office365.com
 (2603:10b6:300:117::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Mon, 12 Aug 2019 11:24:13 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT057.mail.protection.outlook.com (10.152.77.36) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:24:13 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBOCQC004221
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:24:12 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:24:12 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 08/14] net: phy: adin: add support MDI/MDIX/Auto-MDI selection
Date:   Mon, 12 Aug 2019 14:23:44 +0300
Message-ID: <20190812112350.15242-9-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(39860400002)(136003)(376002)(346002)(2980300002)(189003)(199004)(50226002)(7696005)(47776003)(26005)(51416003)(76176011)(7636002)(246002)(336012)(2616005)(8936002)(2906002)(107886003)(36756003)(2870700001)(476003)(486006)(305945005)(126002)(11346002)(446003)(426003)(2201001)(44832011)(4326008)(14444005)(86362001)(356004)(6666004)(1076003)(70586007)(70206006)(50466002)(478600001)(48376002)(316002)(8676002)(106002)(186003)(110136005)(54906003)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR03MB4466;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23a45498-9805-4993-dd74-08d71f179a7c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BN7PR03MB4466;
X-MS-TrafficTypeDiagnostic: BN7PR03MB4466:
X-Microsoft-Antispam-PRVS: <BN7PR03MB44666A4492D8BCA2C4C25184F9D30@BN7PR03MB4466.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: slWX+HmzTipuRRXanDEgOZvUga+iZ60cHvLhyugdGFqzgBKPTFDG/wPMoHsD4PiOkB781D/5HoWFcDZR7A7GGhU/8ki16izjfrLIk8aUXTmtCs8RgBo3ykr9vffHoNzXxCcYI9kP/YC5TKKFAIcI1KLLcjQdhSWQ0mnPPF8cthwal1hFBU9nNca6R03H+S+50q4+Ypm2Djiat1+5yIFAOGKs7TdsnO0RieT5zU34iYgcmKzjcv35/ZcI3Hi+D6WI07IYlZIkuzikIXqv1X8R4tbEttUa1HEXPqRz4ULVUPkgZ2+L3WjBNuA7JPvJlLaBYYeW0FyBF9pSSyhdhhOozPRKcv4iyYw/yczfr8kP5QQZ2N08lpyTxajfB0fV7PIHBe4eEuKS9nEO270w+loFCqUhJK7LJFWAMgHVgmmdp/A=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:24:13.1817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a45498-9805-4993-dd74-08d71f179a7c
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB4466
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120128
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

