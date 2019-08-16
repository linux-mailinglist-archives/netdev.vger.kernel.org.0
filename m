Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C899028F
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbfHPNK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:10:57 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:25094 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727377AbfHPNKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:10:54 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7GD7ocq030372;
        Fri, 16 Aug 2019 09:10:45 -0400
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2050.outbound.protection.outlook.com [104.47.45.50])
        by mx0a-00128a01.pphosted.com with ESMTP id 2ud8vhapm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 09:10:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKyc6xp5UxmQY//oJ2vOaO8WgknNUmzTtE7WO7dgvjzFBJfHF+a0dyC9cv5oP3qjVsJCgH7/LoP1t6V2yRbKKUm+U3C00F324TenQruFjvi8+cO4F5PzYshnOw8FpoYFpm9z7dQl4uQ8oGUSc6Jr/g4nkXhXu1vEAxvFzQi5WgbVM4yUJ1gcr78mxDmZKBe/qy/4JJqWsVml0fMO/vsvdCXR4VazJXc3UCTwIwUaab4QnX/O1y77UBoG8ReR4EjdorD0NMbggdXRMVsWuk1FiwrFRuNCzx0rEhPMYLeuNpKq1sCkWlhu/HpDcihzqbppto0bY9y2vZSdFbwU+k7cpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g87kDXsHbBQu6WJQMwq96CSMq+40xamfTGzlaat/FMA=;
 b=WZO4N+5SLH5aqOXLqHrf+c5WP4xdnccHiqVtU7FfctlW1vClsAP/ABadagitfB1VfFy+vgH8moip45W0eY4cfDqfdouCbm0SDBA5Wdw1bV/Ed+pXD1KnfTw2TS8rIkL2O24nMlM4TOcpAa606rZmLhRbdFaXjKp8JR8ZljrAuQzkEVlSUzAGYCPig5p3v2sz83zrPdxbb1YhEpM0G8nfU4dMFgGjp/HqsxgBJ0Ff98e1mAHqk9GAiwLQxTfxyhxEVUFUri9Y3m0I0LSprotOrH4LseAVDqIhnp5yH5Ozy/uxCyfCbA7j/aGHF0BW3Td7e+LDGBDu2uqRDhzV1HFBZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g87kDXsHbBQu6WJQMwq96CSMq+40xamfTGzlaat/FMA=;
 b=QRHr5n4JLBwuNuUXeaO4mHcoPBxKnLhBLf6nWH/ujjCBdQEe6bZm12Wvyd0rVNzqnRJk/D46sqb5JWq02lC/HHtAA4ldHmk0U3TrlkXwiHxfl87fTlM3HaZRxRzB06QfZHrI4c2aWHJaA2jy7+JRo0VZK5EflGWNqwLVFctGam4=
Received: from BY5PR03CA0013.namprd03.prod.outlook.com (2603:10b6:a03:1e0::23)
 by CY4PR03MB2726.namprd03.prod.outlook.com (2603:10b6:903:70::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.16; Fri, 16 Aug
 2019 13:10:43 +0000
Received: from SN1NAM02FT005.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::201) by BY5PR03CA0013.outlook.office365.com
 (2603:10b6:a03:1e0::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2178.16 via Frontend
 Transport; Fri, 16 Aug 2019 13:10:42 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT005.mail.protection.outlook.com (10.152.72.117) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 13:10:42 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7GDAfaB007922
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 16 Aug 2019 06:10:41 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 16 Aug 2019 09:10:40 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 09/13] net: phy: adin: add EEE translation layer from Clause 45 to Clause 22
Date:   Fri, 16 Aug 2019 16:10:07 +0300
Message-ID: <20190816131011.23264-10-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816131011.23264-1-alexandru.ardelean@analog.com>
References: <20190816131011.23264-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(346002)(396003)(2980300002)(199004)(189003)(8676002)(50226002)(5660300002)(70206006)(70586007)(8936002)(50466002)(2870700001)(1076003)(26005)(186003)(4326008)(110136005)(316002)(54906003)(106002)(426003)(44832011)(305945005)(2201001)(356004)(446003)(476003)(126002)(486006)(107886003)(2616005)(336012)(11346002)(7636002)(6666004)(86362001)(246002)(478600001)(76176011)(7696005)(47776003)(51416003)(48376002)(2906002)(36756003)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR03MB2726;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4315ade2-ca17-4bc8-3c0a-08d7224b247e
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:CY4PR03MB2726;
X-MS-TrafficTypeDiagnostic: CY4PR03MB2726:
X-Microsoft-Antispam-PRVS: <CY4PR03MB2726EBBB6EEB1B0571722026F9AF0@CY4PR03MB2726.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: LCt6/xdLRk/Vug2blEC9eMn3rp9rH9GYz5swBnpK66QB7opNvbxYIYh4Fe8+7ThePoBQMshDr09zZTGgIpodk0YNyboA7jV6PTSsOmyUOfvhoNa+bLgmj0uEuGHyKT26T0eGgChahPtRd/c+E8tIgkqDhMlP41BbKsNGaqSlghYtkABvNZpJ4+48E0EyEA9PwNTBrSWkSm3KhhEPpz56yDLLYt3xOnA/L/HJ3DvMqlFUSF9pJlhSreg+0drQTpbxtkqqvo38xdfhZybeKJtoVlpEJ6OQHQn3qkNAPbJ1eYy/gaqfSJaiND05STzYO9OS4lZcveFy52y/1OAhWXz5v/ra+LQdPXAJPK53KMlt67EYgJ3KIW21fzk1SQjk00sOl6hUVxQo7kUZq7inEK8tkkQEbErpz+NfCPyeztvR0OY=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 13:10:42.1064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4315ade2-ca17-4bc8-3c0a-08d7224b247e
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR03MB2726
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=854 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160136
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

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 68 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 51c0d17577de..131b7f85ae32 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -40,6 +40,16 @@
 #define ADIN1300_PHY_STATUS1			0x001a
 #define   ADIN1300_PAIR_01_SWAP			BIT(11)
 
+/* EEE register addresses, accessible via Clause 22 access using
+ * ADIN1300_MII_EXT_REG_PTR & ADIN1300_MII_EXT_REG_DATA.
+ * The bit-fields are the same as specified by IEEE for EEE.
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
@@ -101,6 +111,26 @@ static const struct adin_cfg_reg_map adin_rmii_fifo_depths[] = {
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
@@ -251,13 +281,41 @@ static int adin_phy_config_intr(struct phy_device *phydev)
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
 
@@ -269,9 +327,15 @@ static int adin_write_mmd(struct phy_device *phydev, int devad, u16 regnum,
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

