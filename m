Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8981687B69
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436548AbfHINhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:37:04 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:30390 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406657AbfHINgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:25 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DMxgk010843;
        Fri, 9 Aug 2019 09:36:18 -0400
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2050.outbound.protection.outlook.com [104.47.49.50])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u8tcbtf86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/KLYnbpyk8aQKnGk1AJCS2fP98qipB2qzYQRxfx3aCcm1zm9GGzulGrbCEGALJSeiDoxNsIMJ2D8lySqToX7Vx2mey6SJL0rzJeHnaGOnHQJj1lS844PsJDJfxLiidGHKYQXhMeiCdbueqDCaLSliSZ9GYj6dwzQkwAKQISFU5WIwwqgzZYwlmRT2JcXl0d1iEOaX0/0FCGf9n7gOjtoLnRAKcW/0dDWlBgmNVjEv0G72pfwX7XGmo72UC32Vbf5zQx/onN5JYK9QEhoKRnyVny8VOqNEMGH1mBYrmt+YBbotNOR/AIRR67gh1TQTLBtO4/l/CG/01FkZU9Sbsu1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vS/R8tdbkY9bW0jTLKychmbqs/uxNCDG1Tt0Z1mV5zA=;
 b=VtUwStrGI4Z9h8GvHz3/sAjLJsO0/eFcYXvTr59OslljR6klro/hhTiuTL9NWqkF0aL0ZUWYI4mcrotv+MtsPsivZyP6XIfpUgqkkDWT8ua0b01swC+ERMU5SjhGEGbdAVCyqXsI61cQmU+kXHGFPLxvmyzd4yDlfMS9XA6fZg/74o0SSkHRHSycfO1IDvKL+jsSsRl4ZIzPGxSnTyCn92KTmz5kcT2hkezjTGXiQUNZbZPcZx/XkjDOpi+Qmv81sjLFQfZjco3GaStHBxLnRakmj9S1iiz7BOnUl0JGahuzOHUp8rMWz3QXoy4IpMVn4mLJnDM/fNgRhbs/RVEV5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vS/R8tdbkY9bW0jTLKychmbqs/uxNCDG1Tt0Z1mV5zA=;
 b=lyQ8ozn84GRDEWqZMoL1AWKLKDh/Ulrfod0XbtJfeqsXvrxj4TSqoSxb2BmoGczlmKYLKuqvZGahRkOOjzo8csZZa8ZBTQWCQlsaWpVYabDFsWG7L8DxO1cXToy5UeVn39DiNp8PcqzJBiZXckeu4YRUdn4NdLSABisTMJ3Cync=
Received: from CY4PR03CA0017.namprd03.prod.outlook.com (2603:10b6:903:33::27)
 by DM6PR03MB3834.namprd03.prod.outlook.com (2603:10b6:5:4f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Fri, 9 Aug
 2019 13:36:15 +0000
Received: from BL2NAM02FT039.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::200) by CY4PR03CA0017.outlook.office365.com
 (2603:10b6:903:33::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:15 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT039.mail.protection.outlook.com (10.152.77.152) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:36:15 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79DaFQI025721
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:36:15 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:36:14 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 09/14] net: phy: adin: add EEE translation layer from Clause 45 to Clause 22
Date:   Fri, 9 Aug 2019 16:35:47 +0300
Message-ID: <20190809133552.21597-10-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(39860400002)(396003)(2980300002)(199004)(189003)(486006)(107886003)(6666004)(2906002)(2870700001)(356004)(44832011)(1076003)(446003)(11346002)(2616005)(126002)(426003)(36756003)(476003)(5660300002)(14444005)(76176011)(7696005)(51416003)(70206006)(336012)(70586007)(47776003)(186003)(26005)(2201001)(246002)(50226002)(110136005)(305945005)(7636002)(54906003)(106002)(316002)(8936002)(8676002)(478600001)(86362001)(48376002)(50466002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB3834;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1000c8ae-854b-40e4-ffc2-08d71cce8d48
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM6PR03MB3834;
X-MS-TrafficTypeDiagnostic: DM6PR03MB3834:
X-Microsoft-Antispam-PRVS: <DM6PR03MB383439F636E33382817FE7EEF9D60@DM6PR03MB3834.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: FKViVHDlMgQVdJDzAMvU1n6S07skzWRQgLfKjPj5S88M1RoJLW1PvOfBOk8FI/i/2xImB1fuSkXEirMZaxEoJ3Cbr4Op3wmOSxWpMoBP7cQZ4cEIYxImeMKyhlO3XyX1ItgXjwBqTyRb/M3KR972fK2BL3ZHONu3XrTsSxGdkCtcRV1Ag1+ZnomBKmd8KAuA4QZIzdDkoxhrvj47lAULgFcJw+D0FKUEyqJouVAwMaUXi1WxHAV6Ix8G9Chz5H/IQsRn6QvxaZo8aZCc7NDNC61Z++E6orekcj1h1qWIB/nm1G8RIpWv750ybXTB+LmYHQZVVZfBSxTHWksbOikS+QdUZhNBUO9nper6YVpZIPB5Kv2bj2l40Sg4zBXKgwKo0wvGery560gFCk1i6dWOB6wsQ9Gw+aZ8NYKBzfS0fzQ=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:36:15.4225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1000c8ae-854b-40e4-ffc2-08d71cce8d48
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3834
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=911 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090138
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
index 45ab89ec1b59..bd002103f083 100644
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

