Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F33F89CA8
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbfHLLZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:25:08 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:31598 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728265AbfHLLYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:24 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNLkE007526;
        Mon, 12 Aug 2019 07:24:17 -0400
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2052.outbound.protection.outlook.com [104.47.32.52])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u9qpawfjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXAxW5I9PE9+4DkjXAOVCDbjkPuodxIg81J2vmYneTMMbL6mM5rNhoXaSnybGXbFLnTIP7OjVthN8QUpvLq3QCJSGtvMmL/5NqChR/TX0ZcQRHt7wF+HtbdCIK+ncjx/fz6qiXzdrlGMYwL6tS6WsD39fRbUK0L93SHYF8Njkwvm6Q/DEQvQsVwRucR9b8Oqj6bCHzQHiKNhYfYXaZxnJ3YlQh1zI1+zoHUp2J7172Y18GRgl9FICUYHD0wfcg7mmZU33vKZiZR4OIKGmTVf/R9GpxypzI2SXcibq2KPpWpfNtlIQfVhLyJLk0uNp9d+xav0PRe4KrtVrtQF+CSRDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uib2icg3FMUnVDbxwlyUFVe272SSZqo1YU4fgcFDQiM=;
 b=h4p/yKZ45lzYxu/pG0b1EAYigg6tdWteynQ4d8yLlMbXTi+TMi7cWwDy78ZHyBBjraTDFge0p/uXlriv/3BtsfvAUTt39uv2pJK7uc09IF/uVe5XhZ5gCKKTJmvkcsp3hR3TU/zipAfATLV8W6cmheebvG5J7TcZuMU3MmQ3iRvT7GbIn51dvqHdF+PBaNfDk2bSX+dE9JUU12fjR9quDe2NWkyTgnfIetYRMxa+K8wJffO71d5ewxSvrM6PEvSaHFzSk/Lxe7s203GizeVzcS5jG5wdowqOV1esQEzmJokQoxl2TOWjbdzDplCcUvEptgHs+rtOOiWo8IoyaqiSow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uib2icg3FMUnVDbxwlyUFVe272SSZqo1YU4fgcFDQiM=;
 b=4RI//Lqs67O1OAlNeARY/oRnaG7EXPqIS8vXI5izAO7Z8Zlb2K6G8UAkziQ5bJMcm58w5nsVhVia+d8ZLoI81ugvx2o8gxnc10SGpd+2tF3fFZo2c+Svg6Gj8gzy4VAOndOIkJ1KgmdjF8F2oLU0GsIj943XFi1VV3UucAOl73o=
Received: from DM6PR03CA0026.namprd03.prod.outlook.com (2603:10b6:5:40::39) by
 BN8PR03MB4787.namprd03.prod.outlook.com (2603:10b6:408:9d::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Mon, 12 Aug 2019 11:24:15 +0000
Received: from BL2NAM02FT008.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::209) by DM6PR03CA0026.outlook.office365.com
 (2603:10b6:5:40::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.15 via Frontend
 Transport; Mon, 12 Aug 2019 11:24:15 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT008.mail.protection.outlook.com (10.152.76.162) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:24:15 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBOEXC004232
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:24:15 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:24:14 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 09/14] net: phy: adin: add EEE translation layer from Clause 45 to Clause 22
Date:   Mon, 12 Aug 2019 14:23:45 +0300
Message-ID: <20190812112350.15242-10-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(346002)(136003)(376002)(396003)(2980300002)(189003)(199004)(2870700001)(50466002)(2906002)(478600001)(7636002)(51416003)(6666004)(186003)(1076003)(356004)(4326008)(48376002)(36756003)(26005)(246002)(8676002)(50226002)(76176011)(7696005)(2201001)(5660300002)(86362001)(70206006)(8936002)(70586007)(54906003)(110136005)(305945005)(426003)(316002)(446003)(476003)(106002)(44832011)(107886003)(126002)(486006)(11346002)(2616005)(336012)(14444005)(47776003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR03MB4787;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05be12db-d679-492c-f7a2-08d71f179baf
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BN8PR03MB4787;
X-MS-TrafficTypeDiagnostic: BN8PR03MB4787:
X-Microsoft-Antispam-PRVS: <BN8PR03MB47878AF99E7EA47A9A703354F9D30@BN8PR03MB4787.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: JoxudUcrZBls8iAlpc60IClGubdMhmcOeN6xbwb1EzszkWRFC51RBym3RoatVJQrBjWGYvQgf4UT3rF8NsgaMjwOWZR8u6ftCTacmUH9LNIxYJoTz0EyhQvGg0ZmsMyJfbbOtzXR2DznpnGXHw7W/Ji5ic8hC8eNboUJgFBgOkmB2niEAMRzhN6HhNxH8Oa5WSDF9NjfqtShPeOSnwZ3KqhOva7OHu/SewiQ4x53M+Vv55J/a6bJkZL/sOHd4LM29uEWN6QsatqKiSTsmlnwEn7nZeXeXFuKXnI6qGbZm6g3tTIpKGYdliQTLOKLO1uvzpeq6mVYeCMU/Jcx0qUI5bLciwbqjPHw+8Z5ck7vJi2UEBVzGrIZpIxuWNluIL7C1Pbe02MfPRQMYPATZx/v1RnSYbpwAEFvNGbbMSUR9Wk=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:24:15.1953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05be12db-d679-492c-f7a2-08d71f179baf
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR03MB4787
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=840 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120128
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

For Clause 45, this is not needed since the driver will likely never use
this access mode.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 69 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 51c0d17577de..a0f8b616bcb7 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -40,6 +40,17 @@
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
@@ -101,6 +112,26 @@ static const struct adin_cfg_reg_map adin_rmii_fifo_depths[] = {
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
@@ -251,13 +282,41 @@ static int adin_phy_config_intr(struct phy_device *phydev)
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
 
-	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR, regnum);
+	adin_regnum = adin_cl45_to_adin_reg(phydev, devad, regnum);
+	if (adin_regnum < 0)
+		return adin_regnum;
+
+	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR,
+			      adin_regnum);
 	if (err)
 		return err;
 
@@ -269,9 +328,15 @@ static int adin_write_mmd(struct phy_device *phydev, int devad, u16 regnum,
 {
 	struct mii_bus *bus = phydev->mdio.bus;
 	int phy_addr = phydev->mdio.addr;
+	int adin_regnum;
 	int err;
 
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

