Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8FC87B7A
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436576AbfHINhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:37:23 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:61594 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406523AbfHINgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:18 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DMxC0026381;
        Fri, 9 Aug 2019 09:36:11 -0400
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2055.outbound.protection.outlook.com [104.47.44.55])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfqjxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+TxhZanMozLU3cHPVKVesj6b/iIgeTsRfE8fN/6xWy00Ia6Aq3IPSRpM9B9/3F2vnmTigXv2ZCW/NMqjCoPzQGWZyHBmmGdbo1jL9be59Qzc+GPezF1PWL3D/X9jVDNjN1tfVaPGyq5tPFYVy6Vkg6E8nM43p1LaDhXiQX2DPPM/fNbTQttlm6pZzcUFCxI64g5/QkdGsOWtGYuGVMFAIJHvdzh87g+Ks50tQVSm9NaPEZ7vhv9j4/79IXCNjLuv52HtUN/MT0L402Po1PGRm9BCQ9EKYOcVM5fygggtkFFV4v0fOcbqIfrL9Cc+D3+/fkkXGNitBeIIzYHRI9EAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVP/odx0vlo55A5UGvuNjmxDLhD+S30d2I6YwYD50y4=;
 b=SufCFMbh3FcNCNNXCLchf4UCje8sr2xIQyHvvJE0e4XBcXvsq1RhsLlozO2jE2fHEMmrdT9AdzpgEM2ZQiYP9nF+TfWyxyyX4qGCVzLt/U86mZAF16EIUB4Ej2Tp3r3qLtknv4O8Z/JmrD3SscUtWGmDJu2r1V3/AcYGTKbRz1goND5K523AopL/3iH5DPVupvfHU9deiMkgfDu4w+jJT3T5XDobDYBh0Ex8MWSFRm5TT+GMVUdbD5VvYaZABhgxDs2XL4yg6ThKGQJkPQ90CoLW60NHIz42r+JbynJ8sAHpj9+5EVwbwqrV3UtGcPbudjTe8tEXw6UzTTxdpsYnEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVP/odx0vlo55A5UGvuNjmxDLhD+S30d2I6YwYD50y4=;
 b=k3ct53v9yMmp+U3iZcCSWY70+OxS8L00U3ZOwn1gOFDDyuMuSl9CntRLyE7fLl85WJydlfLkL1mSUmyOV2xGaoqk6/255ZQIcJilXd5oWGAIQtI2PZxCjJSJ30wTdQKprp4/64+SxIn7CQTYPpDqnD8Kg8gDKS96qPPlTerKHkc=
Received: from BN8PR03CA0028.namprd03.prod.outlook.com (2603:10b6:408:94::41)
 by BN3PR03MB2353.namprd03.prod.outlook.com (2a01:111:e400:7bbf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Fri, 9 Aug
 2019 13:36:09 +0000
Received: from BL2NAM02FT026.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::208) by BN8PR03CA0028.outlook.office365.com
 (2603:10b6:408:94::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.18 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:09 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT026.mail.protection.outlook.com (10.152.77.156) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:36:09 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79Da9QP025675
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:36:09 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:36:08 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 06/14] net: phy: adin: make RGMII internal delays configurable
Date:   Fri, 9 Aug 2019 16:35:44 +0300
Message-ID: <20190809133552.21597-7-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(39860400002)(136003)(396003)(2980300002)(189003)(199004)(50466002)(316002)(50226002)(54906003)(8676002)(106002)(486006)(2906002)(44832011)(126002)(2870700001)(76176011)(2616005)(36756003)(110136005)(478600001)(47776003)(246002)(446003)(51416003)(7696005)(11346002)(426003)(2201001)(4326008)(336012)(70206006)(476003)(5660300002)(70586007)(8936002)(48376002)(1076003)(356004)(86362001)(6666004)(305945005)(107886003)(7636002)(186003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR03MB2353;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75419bd3-b230-4494-39ff-08d71cce89a4
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:BN3PR03MB2353;
X-MS-TrafficTypeDiagnostic: BN3PR03MB2353:
X-Microsoft-Antispam-PRVS: <BN3PR03MB2353AE6632729DCD1D4B437AF9D60@BN3PR03MB2353.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: /4Bb+EltndsEBFyUne+/PyY96bPb270s6qeh1wI41HHYztZWcK3COGAKIvXYe3ZERi8OPihtoshLsUIND6bctDpGrjQSWTWgnMdv5FUTNlVbjPlSzMNjxWsXXKgaHnYYEcJcPcXKbAmbNVd1EgfQTYTmIkyTCjv1j0l5SxItsEqpCVlV5JcmKr7MzXepaoe7APMG5cNq9EWysDZZuK95hTIZoF4V4rH2pRiilPN7Qqck5bh/YK4tJfFYtE3/CfIC4GLjMK+ISqZ3IAsBGCvuFDV98RQS/kssfIvT98VXRPUoyjAhB9CgmuAruIs+uDVKipdZOTWJoEWjGGnRWx0nPXUK2kAvqhAriWK5zZ8Hbwh6G4dn+8tjSoPXlK9oL0zteuEfNMMR74gwT/g2UeNNhqogYdPxg6XhZKwMaJjncL8=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:36:09.3315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75419bd3-b230-4494-39ff-08d71cce89a4
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR03MB2353
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=872 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The internal delays for the RGMII are configurable for both RX & TX. This
change adds support for configuring them via device-tree (or ACPI).

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 82 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 6ea0d7bd76c5..06d3db75c3db 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -5,11 +5,13 @@
  * Copyright 2019 Analog Devices Inc.
  */
 #include <linux/kernel.h>
+#include <linux/bitfield.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mii.h>
 #include <linux/phy.h>
+#include <linux/property.h>
 
 #define PHY_ID_ADIN1200				0x0283bc20
 #define PHY_ID_ADIN1300				0x0283bc30
@@ -34,15 +36,83 @@
 #define ADIN1300_INT_STATUS_REG			0x0019
 
 #define ADIN1300_GE_RGMII_CFG_REG		0xff23
+#define   ADIN1300_GE_RGMII_RX_MSK		GENMASK(8, 6)
+#define   ADIN1300_GE_RGMII_RX_SEL(x)		\
+		FIELD_PREP(ADIN1300_GE_RGMII_RX_MSK, x)
+#define   ADIN1300_GE_RGMII_GTX_MSK		GENMASK(5, 3)
+#define   ADIN1300_GE_RGMII_GTX_SEL(x)		\
+		FIELD_PREP(ADIN1300_GE_RGMII_GTX_MSK, x)
 #define   ADIN1300_GE_RGMII_RXID_EN		BIT(2)
 #define   ADIN1300_GE_RGMII_TXID_EN		BIT(1)
 #define   ADIN1300_GE_RGMII_EN			BIT(0)
 
+/* RGMII internal delay settings for rx and tx for ADIN1300 */
+#define ADIN1300_RGMII_1_60_NS			0x0001
+#define ADIN1300_RGMII_1_80_NS			0x0002
+#define	ADIN1300_RGMII_2_00_NS			0x0000
+#define	ADIN1300_RGMII_2_20_NS			0x0006
+#define	ADIN1300_RGMII_2_40_NS			0x0007
+
 #define ADIN1300_GE_RMII_CFG_REG		0xff24
 #define   ADIN1300_GE_RMII_EN			BIT(0)
 
+/**
+ * struct adin_cfg_reg_map - map a config value to aregister value
+ * @cfg		value in device configuration
+ * @reg		value in the register
+ */
+struct adin_cfg_reg_map {
+	int cfg;
+	int reg;
+};
+
+static const struct adin_cfg_reg_map adin_rgmii_delays[] = {
+	{ 1600, ADIN1300_RGMII_1_60_NS },
+	{ 1800, ADIN1300_RGMII_1_80_NS },
+	{ 2000, ADIN1300_RGMII_2_00_NS },
+	{ 2200, ADIN1300_RGMII_2_20_NS },
+	{ 2400, ADIN1300_RGMII_2_40_NS },
+	{ },
+};
+
+static int adin_lookup_reg_value(const struct adin_cfg_reg_map *tbl, int cfg)
+{
+	size_t i;
+
+	for (i = 0; tbl[i].cfg; i++) {
+		if (tbl[i].cfg == cfg)
+			return tbl[i].reg;
+	}
+
+	return -EINVAL;
+}
+
+static u32 adin_get_reg_value(struct phy_device *phydev,
+			      const char *prop_name,
+			      const struct adin_cfg_reg_map *tbl,
+			      u32 dflt)
+{
+	struct device *dev = &phydev->mdio.dev;
+	u32 val;
+	int rc;
+
+	if (device_property_read_u32(dev, prop_name, &val))
+		return dflt;
+
+	rc = adin_lookup_reg_value(tbl, val);
+	if (rc < 0) {
+		phydev_warn(phydev,
+			    "Unsupported value %u for %s using default (%u)\n",
+			    val, prop_name, dflt);
+		return dflt;
+	}
+
+	return rc;
+}
+
 static int adin_config_rgmii_mode(struct phy_device *phydev)
 {
+	u32 val;
 	int reg;
 
 	if (!phy_interface_is_rgmii(phydev))
@@ -59,6 +129,12 @@ static int adin_config_rgmii_mode(struct phy_device *phydev)
 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
 	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
 		reg |= ADIN1300_GE_RGMII_RXID_EN;
+
+		val = adin_get_reg_value(phydev, "adi,rx-internal-delay-ps",
+					 adin_rgmii_delays,
+					 ADIN1300_RGMII_2_00_NS);
+		reg &= ~ADIN1300_GE_RGMII_RX_MSK;
+		reg |= ADIN1300_GE_RGMII_RX_SEL(val);
 	} else {
 		reg &= ~ADIN1300_GE_RGMII_RXID_EN;
 	}
@@ -66,6 +142,12 @@ static int adin_config_rgmii_mode(struct phy_device *phydev)
 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
 	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
 		reg |= ADIN1300_GE_RGMII_TXID_EN;
+
+		val = adin_get_reg_value(phydev, "adi,tx-internal-delay-ps",
+					 adin_rgmii_delays,
+					 ADIN1300_RGMII_2_00_NS);
+		reg &= ~ADIN1300_GE_RGMII_GTX_MSK;
+		reg |= ADIN1300_GE_RGMII_GTX_SEL(val);
 	} else {
 		reg &= ~ADIN1300_GE_RGMII_TXID_EN;
 	}
-- 
2.20.1

