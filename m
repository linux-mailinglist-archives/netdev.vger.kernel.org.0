Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E99A7861AF
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389839AbfHHMbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:31:04 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:29630 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732452AbfHHMbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:31:02 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CRnfe002129;
        Thu, 8 Aug 2019 08:30:56 -0400
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2058.outbound.protection.outlook.com [104.47.45.58])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfkv4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:30:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDNUIJochJztbvY8u5X2p7Zft84B5DFFq9p98fCF0xtdGTfJRbctcT/WdvWMm+7PpJu+Daz5qbiYMbGXLGauAm7AR22c5ymCE4OAfa6YGE0tSNGXE5KgzyaRttiQ+SSzHVQbVELbTYfefvWBCIuoGnAAHHawSIcJr+a5mWDt1M+Xba1PXqiC6Bc6FIF/RtscbqfcD3aXaHjXiJq6mmNFxC1PeFFLKuX/lGL/7N8P5dRTvI2QiexbbUzrmfsDoOFyNeN5gWDLcjKy+O8Ez84Edqlr+kHVmN217BtWSQG6gtijoQXFwP35j07E9CDsMLLe1io9uhJ8V4P3SRad2NlU+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzVOdnpFSj+yyTp2i7ivfM+0PyqRHg1Pul/8BTF6W00=;
 b=RtbdA9/408ZJ8L34aK+KJ9lkOmQlAhBsyP5sd39KrGyhv7OsLa4eU5vOk/u70spKuS/vPNHadntshPSxqsTgzj/h7I+8x2GZz/ob5BCxy1zndqqcYfbqZusy+f3m7Hdxwsl7/h4vAFL6aPply9QmU787Utj7egggoI2bXi9sfyl8vRq9oPts7o7bVCPzVanMwa6+tRPBdbLI8KTb7LzAd5dNMfG24da0JKLft+l9t2wH3dPfY4h5xFAeCR9hmvEFzK3s4BRoX/Rb8Hn9gcwTd/u49UVy6PjtWakRUmZdjyrsuvbnGKjv6DRYsDZwSFgSKicUlQu3a/E7WKEG/brc2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzVOdnpFSj+yyTp2i7ivfM+0PyqRHg1Pul/8BTF6W00=;
 b=vVICqg4OTWzhI3YhAOx1GKY/PPCQVvlf/86JUWfd2L5ezjVWqhKeVl4jrzYXmnF365wPMHmIm08GkwR3qa/IAnq/qJgPwAnOGexJYJp3L4y5RXPuV6mjcKwYnwk35rIFNRh/2w3R+CaLMdmxzynJI0fORWSrIsJ76Syag8Ur97o=
Received: from DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) by
 DM6PR03MB5100.namprd03.prod.outlook.com (2603:10b6:5:1e9::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 8 Aug 2019 12:30:53 +0000
Received: from CY1NAM02FT031.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::207) by DM6PR03CA0033.outlook.office365.com
 (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.16 via Frontend
 Transport; Thu, 8 Aug 2019 12:30:53 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT031.mail.protection.outlook.com (10.152.75.180) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:30:52 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CUq95021261
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:30:52 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:30:51 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 10/15] net: phy: adin: add EEE translation layer from Clause 45 to Clause 22
Date:   Thu, 8 Aug 2019 15:30:21 +0300
Message-ID: <20190808123026.17382-11-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(136003)(376002)(396003)(346002)(2980300002)(199004)(189003)(336012)(14444005)(426003)(44832011)(486006)(186003)(446003)(126002)(476003)(26005)(2616005)(11346002)(50466002)(36756003)(50226002)(2870700001)(1076003)(478600001)(5660300002)(8936002)(2906002)(6666004)(70206006)(356004)(70586007)(48376002)(7636002)(107886003)(76176011)(316002)(51416003)(7696005)(4326008)(110136005)(246002)(47776003)(86362001)(54906003)(8676002)(2201001)(106002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB5100;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ad59d7e-5bdc-4c41-427a-08d71bfc4127
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:DM6PR03MB5100;
X-MS-TrafficTypeDiagnostic: DM6PR03MB5100:
X-Microsoft-Antispam-PRVS: <DM6PR03MB51000F0B746F9D55C3567D82F9D70@DM6PR03MB5100.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 49dRt+iyqi0RaEe1QbgmKY6GZatIgI0dDaWlnUylH2zOok7yqZFoBYwKV9uAnsf2Urhv03hH5f+D+sbh0xrRl/4E1jmNNahaUaRHKiNhec/W5uAziLPkjb5iFZLwfWTi9sl20SAZzONjZ55gXxs+9X3Lkv/647QpOHOip8hH2z/o2V3D61btlNuoW+dhFjNiC/SLY+lkrCI3S1t12OKoC8rXKJU+fgTgjaJkOyRn7Ci2kdL3cydApeN8vujxEm4z6kriIsGe+QwTOwC7JdcUH6s8s0Tb1X1v8mMyUUulDGSFYHZu19DL8WDYeJoHfGivLvyYylrpdojfryqaZcok2w5rAaPBdITmgRKEWUkQf69dprNnU3DH8NCr9UZb49r4u03qXMGrSzymLKoBW1ZP5hOOtXl6jG0BUeRQ+owDaLA=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:30:52.9600
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad59d7e-5bdc-4c41-427a-08d71bfc4127
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB5100
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=910 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN1200 & ADIN1300 PHYs support EEE by using standard Clause 45 access
to access MMD registers for EEE.

The EEE register addresses (when using Clause 22) are available at
different addresses (than Clause 45), and since accessing these regs (via
Clause 22) needs a special mechanism, a translation table is required to
convert these addresses.

For Clause 45, this is not needed; the addresses are available as specified
by IEEE.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 69 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 69ef53bbecc3..c1cea1b6bd75 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -42,6 +42,17 @@
 #define ADIN1300_PHY_STATUS1			0x001a
 #define   ADIN1300_PAIR_01_SWAP			BIT(11)
 
+/* EEE register addresses, accessible via Clause 22 access using
+ * ADIN1300_MII_EXT_REG_PTR & ADIN1300_MII_EXT_REG_DATA.
+ * The bit-fields are the same as specified by IEEE, and can be
+ * accessed via standard Clause 45 access.
+ */
+#define ADIN1300_EEE_CAP_REG			0x8000
+#define ADIN1300_EEE_ADV_REG			0x8001
+#define ADIN1300_EEE_LPABLE_REG			0x8002
+#define ADIN1300_CLOCK_STOP_REG			0x9400
+#define ADIN1300_LPI_WAKE_ERR_CNT_REG		0xa000
+
 #define ADIN1300_GE_RGMII_CFG_REG		0xff23
 #define   ADIN1300_GE_RGMII_RX_MSK		GENMASK(8, 6)
 #define   ADIN1300_GE_RGMII_RX_SEL(x)		\
@@ -103,6 +114,26 @@ static const struct adin_cfg_reg_map adin_rmii_fifo_depths[] = {
 	{ },
 };
 
+/**
+ * struct adin_clause45_mmd_map - map to convert Clause 45 regs to Clause 22
+ * @devad		device address used in Clause 45 access
+ * @cl45_regnum		register address defined by Clause 45
+ * @adin_regnum		equivalent register address accessible via Clause 22
+ */
+struct adin_clause45_mmd_map {
+	int devad;
+	u16 cl45_regnum;
+	u16 adin_regnum;
+};
+
+static struct adin_clause45_mmd_map adin_clause45_mmd_map[] = {
+	{ MDIO_MMD_PCS,	MDIO_PCS_EEE_ABLE,	ADIN1300_EEE_CAP_REG },
+	{ MDIO_MMD_AN,	MDIO_AN_EEE_LPABLE,	ADIN1300_EEE_LPABLE_REG },
+	{ MDIO_MMD_AN,	MDIO_AN_EEE_ADV,	ADIN1300_EEE_ADV_REG },
+	{ MDIO_MMD_PCS,	MDIO_CTRL1,		ADIN1300_CLOCK_STOP_REG },
+	{ MDIO_MMD_PCS, MDIO_PCS_EEE_WK_ERR,	ADIN1300_LPI_WAKE_ERR_CNT_REG },
+};
+
 static int adin_lookup_reg_value(const struct adin_cfg_reg_map *tbl, int cfg)
 {
 	size_t i;
@@ -253,10 +284,33 @@ static int adin_phy_config_intr(struct phy_device *phydev)
 			      ADIN1300_INT_MASK_EN);
 }
 
+static int adin_cl45_to_adin_reg(struct phy_device *phydev, int devad,
+				 u16 cl45_regnum)
+{
+	struct adin_clause45_mmd_map *m;
+	int i;
+
+	if (devad == MDIO_MMD_VEND1)
+		return cl45_regnum;
+
+	for (i = 0; i < ARRAY_SIZE(adin_clause45_mmd_map); i++) {
+		m = &adin_clause45_mmd_map[i];
+		if (m->devad == devad && m->cl45_regnum == cl45_regnum)
+			return m->adin_regnum;
+	}
+
+	phydev_err(phydev,
+		   "No translation available for devad: %d reg: %04x\n",
+		   devad, cl45_regnum);
+
+	return -EINVAL;
+}
+
 static int adin_read_mmd(struct phy_device *phydev, int devad, u16 regnum)
 {
 	struct mii_bus *bus = phydev->mdio.bus;
 	int phy_addr = phydev->mdio.addr;
+	int adin_regnum;
 	int err;
 
 	if (phydev->is_c45) {
@@ -265,7 +319,12 @@ static int adin_read_mmd(struct phy_device *phydev, int devad, u16 regnum)
 		return __mdiobus_read(bus, phy_addr, addr);
 	}
 
-	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR, regnum);
+	adin_regnum = adin_cl45_to_adin_reg(phydev, devad, regnum);
+	if (adin_regnum < 0)
+		return adin_regnum;
+
+	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR,
+			      adin_regnum);
 	if (err)
 		return err;
 
@@ -277,6 +336,7 @@ static int adin_write_mmd(struct phy_device *phydev, int devad, u16 regnum,
 {
 	struct mii_bus *bus = phydev->mdio.bus;
 	int phy_addr = phydev->mdio.addr;
+	int adin_regnum;
 	int err;
 
 	if (phydev->is_c45) {
@@ -285,7 +345,12 @@ static int adin_write_mmd(struct phy_device *phydev, int devad, u16 regnum,
 		return __mdiobus_write(bus, phy_addr, addr, val);
 	}
 
-	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR, regnum);
+	adin_regnum = adin_cl45_to_adin_reg(phydev, devad, regnum);
+	if (adin_regnum < 0)
+		return adin_regnum;
+
+	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR,
+			      adin_regnum);
 	if (err)
 		return err;
 
-- 
2.20.1

