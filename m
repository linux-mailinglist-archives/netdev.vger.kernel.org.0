Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7232A89CA3
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbfHLLY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:24:29 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:33096 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728302AbfHLLY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:27 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNGZQ007517;
        Mon, 12 Aug 2019 07:24:12 -0400
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2059.outbound.protection.outlook.com [104.47.42.59])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u9qpawfj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJ9uwQLQjQHYKkYLcPpT461ysvRaJ3vKCGAwpyQGPxI0aA1kiEhahKLfN0RZ2tVweZ1b1ZvkMk9KEtvxE6kfd2CnNNF2Y+Yfsew7+8TXQN0wjZC/20+AziaxELwZbZRkYkZPKH/BNIuMmwt8A9v/3mFr2/zJ9WYCCGE1FmAFsxgMaOFscyjPEUGsisaSVBzx2e6xVVP/UW6sxecHtrDt5ZL+dyopZxhPypZWNo3HO7nqbfpMEl204jQWvSQI2gFsytQvj3LmXncmGJBwCeHLxeyLa74RP9OcTnNr5GOVHwPkrQNeLQVpf+fjfTTHWv9J6vNsnCo/d0mQW+kIs+JRJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ag0vPI6T/qmLpXO2TReUESGGzxkGuNn3NnJIsKrLEug=;
 b=oNViUseczVG5wivgRx6vM7BrwPEzqvXJ1m3Hr1ZS3hRuMsNK31J7xnpwY+pRwn0uyr+5qAvRZ+NAAC3iTG2VLw83at1rQ+JLLDQmpG7CkOivpTlQF83lKrc19RnhsqcNQgqo8L3Fio2D6/+1DNV4IrqxZn/L7+O+UvJX2iMmXIzdyrgBD2hVC7GPHo8pF5gmlF1T3Y3Hg4BOFspk6bFNqdxxExB4VCWjSVUN53QSwyGTDGmnZN5OgCfOIc2FBCCG4Yo3YaPIz5gYcKepWg16oxd6j6JyKyNGUMlMippptNANyrBs3ncAeeK9oRhyA1OAPHAcywplanmyR/CuA1ZMNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ag0vPI6T/qmLpXO2TReUESGGzxkGuNn3NnJIsKrLEug=;
 b=WSgXjf3BkyAeecwxlTu27ER5s/K1QL2k2+YiDSuWUHUd4IQSdtV2XGmUlLzp9x6TATplutmdUhaRAJbxnjG5u+hOds2YbxQPe2/Z0vs53+5SO87ZWpQT4S/ygVvTc6RQmAXvvkN464NyMHdHz5MZEzbjLZD+hyygxt6GjncvYTA=
Received: from BN6PR03CA0022.namprd03.prod.outlook.com (2603:10b6:404:23::32)
 by BYAPR03MB3528.namprd03.prod.outlook.com (2603:10b6:a02:aa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.20; Mon, 12 Aug
 2019 11:24:09 +0000
Received: from BL2NAM02FT034.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::201) by BN6PR03CA0022.outlook.office365.com
 (2603:10b6:404:23::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.15 via Frontend
 Transport; Mon, 12 Aug 2019 11:24:09 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT034.mail.protection.outlook.com (10.152.77.161) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:24:09 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBO8Jq004192
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:24:08 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:24:08 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 06/14] net: phy: adin: make RGMII internal delays configurable
Date:   Mon, 12 Aug 2019 14:23:42 +0300
Message-ID: <20190812112350.15242-7-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(39860400002)(376002)(136003)(396003)(2980300002)(189003)(199004)(44832011)(486006)(50466002)(5660300002)(1076003)(86362001)(48376002)(106002)(70586007)(70206006)(186003)(7636002)(6666004)(54906003)(356004)(110136005)(316002)(76176011)(305945005)(26005)(51416003)(7696005)(2201001)(47776003)(8676002)(50226002)(246002)(2616005)(476003)(8936002)(478600001)(2906002)(426003)(126002)(36756003)(446003)(2870700001)(107886003)(4326008)(11346002)(336012);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB3528;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03de7031-064d-4050-cae3-08d71f17980a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR03MB3528;
X-MS-TrafficTypeDiagnostic: BYAPR03MB3528:
X-Microsoft-Antispam-PRVS: <BYAPR03MB3528B21D198778006BF2ECCAF9D30@BYAPR03MB3528.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: FrbLybKNX6n5P19rmvrCqldZ+/ffCBqPiRWS7uAv/8aCYd0Kc8i+ds4o0jh3q5wJduonmNlIMWMw0UtNRDYdgXr99OcMhXR5A6cLsGaI/iesjO8roR4HlVVxfwKuJAl5K0i4/Zz4dZCnZc2KMn9vdo1DgXCV6b5GFD3+I/aDpHOzsD1+blJ3MkqWjYOATwWAssRwxuZSkZAmrplKL9dSlyxheSQr3FGINFmCz79EWns01k9Bl6RdDcSa6dXikZZK49kpXWFDos0aZ9daY3wNmrOkJsHvVIJaJMMXZkm4er5oXN7RgBTob4PajS3xmGZn9owmBiiPiXpk7mBW/wZO8DgOJ52sSNVGMerYbb1XR9nhKOnuzxYnLDjwSvXkMhdA6YiXM46f0LPfyAbRs86TMB3/bErm2bDi3VxR4qYETCc=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:24:09.0676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03de7031-064d-4050-cae3-08d71f17980a
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3528
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=873 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120128
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
index badca6881c6c..c882fcd9ada5 100644
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
@@ -32,15 +34,83 @@
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
@@ -57,6 +127,12 @@ static int adin_config_rgmii_mode(struct phy_device *phydev)
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
@@ -64,6 +140,12 @@ static int adin_config_rgmii_mode(struct phy_device *phydev)
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

