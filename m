Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A9481E38
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbfHEN42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:56:28 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:12936 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729576AbfHENzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:36 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75DqrI6019294;
        Mon, 5 Aug 2019 09:55:29 -0400
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2053.outbound.protection.outlook.com [104.47.41.53])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u56w5svgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZ1cmyY/M6qc7SZ/JoCOMKuYgjq6e+io/TenVBPJF6E1WT5NQWHclmWRdhG2Mc68vnNA1XohmOP7T0skjQcJy6myFrbkbFuGkrl5DlEl8fBprjVvQMMNXcsy+rFbvcoJJGjCl8EmKGCb4N3YRm8/bBnOgSc1vRX+rKOSC027E/jWypLinkSxiHSqBbpspC8Ox5HX5/YLHCD24sw5igd0tQkpENV6AtxkFcS7NHMvCQemA9TyueX2g8jRKiIaykbAwVmeLyv4XV3ycpkECV5W1s038ZBePOqGwXcHniRxewL3fY5VUej8Hr66hQVsDIxkeK0Pv4JJB3CKZrAch5R9uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=su7P9xjLG+pd1xCYjk0NJdGpVaEIk2Hoje2en79KDDg=;
 b=KcYRYg5bKXthrLn547XRAYfhMw4l9QFhmUXPTXJ//WG0G4nm0ZZG9hd/ZP5XysO6EObMrR9AsVhzB7TbuilgoYP3Z5LNAljtnwLjTsIqPzB0WIl5xXUUVEa6ZEQu4IqiruVQGksjns3ZhdWIE2X2KHJJMGrzFBObkkNo/lVhT+6ex6fvSoZW4KyfclQNKhebbTdwM0eAaXyyzETNe9pY5m+58xTYwftJWP6l4uxK45Y6tUKFLmk5uPyRqVRUyLu1d2ms+hi73rzMznJc8v9CkmTWAtGIRL+9m7QLgwOltYst2vqlQvHHMU5HRV/iHflIX8oS4c2ePMlrh7jRGK7FbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=su7P9xjLG+pd1xCYjk0NJdGpVaEIk2Hoje2en79KDDg=;
 b=Tgmkwc/+EfrtJSqFjV964t9yoiQP91UoSjsppPt7L17JDK8PDFRkOWSgc0I67VRee5AteEEFmgRsUC3T4bGb6dx2ELt7NQMZV159vz/gl+5hWp/wy/CiX7Sc5dwvkU7+ZUrx8BSy0FSl5/U/Fy8itPIxWNwiVlM9Ho1drs37UeA=
Received: from BN3PR03CA0056.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::16) by CH2PR03MB5240.namprd03.prod.outlook.com
 (2603:10b6:610:93::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.13; Mon, 5 Aug
 2019 13:55:27 +0000
Received: from BL2NAM02FT011.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::206) by BN3PR03CA0056.outlook.office365.com
 (2a01:111:e400:7a4d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.15 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:27 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT011.mail.protection.outlook.com (10.152.77.5) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:27 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75DtO2v016222
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:24 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:26 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 10/16] net: phy: adin: add EEE translation layer for Clause 22
Date:   Mon, 5 Aug 2019 19:54:47 +0300
Message-ID: <20190805165453.3989-11-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(39860400002)(346002)(2980300002)(199004)(189003)(50226002)(48376002)(50466002)(44832011)(356004)(336012)(486006)(11346002)(446003)(126002)(2201001)(2616005)(47776003)(478600001)(14444005)(426003)(70206006)(36756003)(106002)(5660300002)(2870700001)(6666004)(246002)(70586007)(8936002)(316002)(476003)(7636002)(107886003)(54906003)(110136005)(1076003)(76176011)(2906002)(305945005)(8676002)(4326008)(26005)(186003)(51416003)(7696005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5240;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f441de3-029c-4be7-7268-08d719ac9213
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:CH2PR03MB5240;
X-MS-TrafficTypeDiagnostic: CH2PR03MB5240:
X-Microsoft-Antispam-PRVS: <CH2PR03MB5240D97C28FFAF806EBEF083F9DA0@CH2PR03MB5240.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ZgUbvcYWorJ/DyTFgeR8r/fn4TI+4xbmE42ziO4yvKhmG8BuYSaIxkC5ay146mR/6mZ5S8j5JBbSYQRui6urNowqCztTrDtWoT9JW/QgfdLEAK8MjebcOx4iStdeKTVT2OHmJrxTI97QfAesY5qIq1PrUiQ/EzKdJgJgMGSj9rRr9vmQ7ORoMc5illlCxaRTWUC3YKtWi4eLIW/rlmtUMC34O4Z0R4vDkeGZid2mCJo/Leuz4qLGKjJ4vz/IWSG4CHF/zl/IQZyeye9oPXQ+gcITaqDtL0h7/mDaCi4OkoOj3BQYiCUw7r9rUMweJnkXJ/pjjw09EQAKduHM1PLjhnd3vzY1K1hMKTDnQLIXXmPgbg43SMkZHwBIKJ+gY+dlXyvW4RdlnCbhHqjv+9FWW2Nn8PIPW+qU3kXarYUoZ+w=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:27.1001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f441de3-029c-4be7-7268-08d719ac9213
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5240
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=846 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050154
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
 drivers/net/phy/adin.c | 61 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 31c600b7ec66..3c559a3ba487 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -44,6 +44,17 @@
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
@@ -61,6 +72,20 @@
 		FIELD_PREP(ADIN1300_GE_RMII_FIFO_DEPTH_MSK, x)
 #define   ADIN1300_GE_RMII_EN			BIT(0)
 
+struct clause22_mmd_map {
+	int devad;
+	u16 cl22_regnum;
+	u16 adin_regnum;
+};
+
+static struct clause22_mmd_map clause22_mmd_map[] = {
+	{ MDIO_MMD_PCS,	MDIO_PCS_EEE_ABLE,	ADIN1300_EEE_CAP_REG },
+	{ MDIO_MMD_AN,	MDIO_AN_EEE_LPABLE,	ADIN1300_EEE_LPABLE_REG },
+	{ MDIO_MMD_AN,	MDIO_AN_EEE_ADV,	ADIN1300_EEE_ADV_REG },
+	{ MDIO_MMD_PCS,	MDIO_CTRL1,		ADIN1300_CLOCK_STOP_REG },
+	{ MDIO_MMD_PCS, MDIO_PCS_EEE_WK_ERR,	ADIN1300_LPI_WAKE_ERR_CNT_REG },
+};
+
 static int adin_get_phy_internal_mode(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -233,10 +258,31 @@ static int adin_phy_config_intr(struct phy_device *phydev)
 			      ADIN1300_INT_MASK_EN);
 }
 
+static int adin_cl22_to_adin_reg(int devad, u16 cl22_regnum)
+{
+	struct clause22_mmd_map *m;
+	int i;
+
+	if (devad == MDIO_MMD_VEND1)
+		return cl22_regnum;
+
+	for (i = 0; i < ARRAY_SIZE(clause22_mmd_map); i++) {
+		m = &clause22_mmd_map[i];
+		if (m->devad == devad && m->cl22_regnum == cl22_regnum)
+			return m->adin_regnum;
+	}
+
+	pr_err("No translation available for devad: %d reg: %04x\n",
+	       devad, cl22_regnum);
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
@@ -245,7 +291,12 @@ static int adin_read_mmd(struct phy_device *phydev, int devad, u16 regnum)
 		return __mdiobus_read(bus, phy_addr, addr);
 	}
 
-	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR, regnum);
+	adin_regnum = adin_cl22_to_adin_reg(devad, regnum);
+	if (adin_regnum < 0)
+		return adin_regnum;
+
+	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR,
+			      adin_regnum);
 	if (err)
 		return err;
 
@@ -257,6 +308,7 @@ static int adin_write_mmd(struct phy_device *phydev, int devad, u16 regnum,
 {
 	struct mii_bus *bus = phydev->mdio.bus;
 	int phy_addr = phydev->mdio.addr;
+	int adin_regnum;
 	int err;
 
 	if (phydev->is_c45) {
@@ -265,7 +317,12 @@ static int adin_write_mmd(struct phy_device *phydev, int devad, u16 regnum,
 		return __mdiobus_write(bus, phy_addr, addr, val);
 	}
 
-	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR, regnum);
+	adin_regnum = adin_cl22_to_adin_reg(devad, regnum);
+	if (adin_regnum < 0)
+		return adin_regnum;
+
+	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR,
+			      adin_regnum);
 	if (err)
 		return err;
 
-- 
2.20.1

