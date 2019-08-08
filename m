Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9CAD861CB
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732403AbfHHMa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:30:57 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:53164 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727649AbfHHMa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:30:56 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CRm0s022426;
        Thu, 8 Aug 2019 08:30:49 -0400
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2057.outbound.protection.outlook.com [104.47.45.57])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u7xkj3gw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:30:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tn6+eP5FG+V+noKLoQL4qrKHDS/kODN3LVPCe815Iq80N1Bu+e9zGq1j8rmDNUA+v6P/ADCLfKwr5sHj/knhm7DsNawWJhLvt19oqWEQlkglSQegJ/Ydfj63ZCQ7W+F8ljal4XxTDk3kgdKRbejHLUyQsd6TptkdbO87orG0LW9NSxrXPzUaaIBhWu1MokH/vwVUA3la4kL8jfZT36dsl6U7hV78ZqzmnNoL2LbcuY8+xHLv74ErehRT6XkF9t8EMQg+nU73Vve0fYvFRLWe/7tQmx1VYvR1GBW8FDBMycU1Q8ktmHJuJSANsVLK17/uWFtKeHV9vOSCGLQ4TjvkSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PO5OkiX1WmTXvZvAt60yK0vtiIQQDEigJHhwCJ9cKmU=;
 b=E4AeALOmT272vbOVSTe/bA5qDu8we9YRyiK2XWXKr5DDDLS1jFgElT60jvKRwoB80+qugq4YDNULN9oMTBmaH8zkJzkgCgMv4Ftsv8Vwj7ppM/sXo6xeORGau4avS0x9ap57zdRwpSo3xO5bpjy3MkDRJW8fMATmTT/WncHl/hr2oCHEBanT5+uZt2+sqs8HsYr5QJUsQKK4Iy154ghWgFcGx7YezKiX1B8f9n39OYCTmTDhlM2d3YqbfuKtT/HV7yWM6veAvrQK0ftc2JoPfurQFTju39oS4UAhVavBmRNMHjWoo5h31hUG18I3Wkp2yeEiar/nKCs8kS2LwBuxTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PO5OkiX1WmTXvZvAt60yK0vtiIQQDEigJHhwCJ9cKmU=;
 b=M0MaN5Du/8ncQ7OTIq37mrvYgBpmBAoSKGxYaCI1XBZrdJoSea5ML0PkJQOw4H1sxgfIjrKMYhkn5pzSQT9b+kQTmNDTEdT6oSB154zWgijlwt9GopWXqOUK1BszPiKjBZ/Oz0Zf9JubHyRMmzg0kiqW4pzyUlFjdOhNDEnqvac=
Received: from BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27)
 by BY5PR03MB5249.namprd03.prod.outlook.com (2603:10b6:a03:21b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Thu, 8 Aug
 2019 12:30:47 +0000
Received: from SN1NAM02FT029.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::208) by BY5PR03CA0017.outlook.office365.com
 (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.15 via Frontend
 Transport; Thu, 8 Aug 2019 12:30:47 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT029.mail.protection.outlook.com (10.152.72.110) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:30:46 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CUknL021238
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:30:46 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:30:45 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 07/15] net: phy: adin: make RGMII internal delays configurable
Date:   Thu, 8 Aug 2019 15:30:18 +0300
Message-ID: <20190808123026.17382-8-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(136003)(396003)(39860400002)(346002)(2980300002)(199004)(189003)(44832011)(106002)(26005)(426003)(446003)(476003)(11346002)(2616005)(50226002)(8676002)(8936002)(186003)(51416003)(76176011)(478600001)(47776003)(7696005)(50466002)(4326008)(126002)(336012)(36756003)(316002)(110136005)(54906003)(486006)(1076003)(2201001)(305945005)(6666004)(86362001)(48376002)(107886003)(7636002)(356004)(70206006)(2870700001)(5660300002)(2906002)(246002)(70586007);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR03MB5249;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a47065ec-8517-4584-a2ce-08d71bfc3d8b
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BY5PR03MB5249;
X-MS-TrafficTypeDiagnostic: BY5PR03MB5249:
X-Microsoft-Antispam-PRVS: <BY5PR03MB5249757558B6457437A3CF92F9D70@BY5PR03MB5249.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 7rJeujk6zBPRcjltFCHBvf60uajW1h1y6aNBpfYwTNc3tJ8E4prHLpq7S38DyXOi5E0aca5nI2FQO6RiDpo6uLq8sqhOqfNClvdgw/p3jQ/3iiwtvvKi9GHSFWahEoUpMbDOEkQbQeR9/irnF1b5s3y2FEjvTPWcp2L0g8T74difCrnH+tYZcOg5hTTT0d2MtZKbIGywaMZyCH79JUDzp1ExKrKFqbVwZyQ/WaRj2lKei3mHYeOZoN/tebbQqyms9C8tyTRz656EEoP2Waia65jyB2raKVO5IukhptgBjQX0afxRU+9u9DcmlZ9SUBx7Y0zVkhF8ASAqsMTx3JwISGbOb4E8fmxufRoRaYDCh+EYcv37MiProdkQnrw/K8MKyZaC2LxVBCoq9m30toWoVeUvqZMZxe+j8BEIg2IcFMU=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:30:46.9820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a47065ec-8517-4584-a2ce-08d71bfc3d8b
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5249
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=912 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The internal delays for the RGMII are configurable for both RX & TX. This
change adds support for configuring them via device-tree (or ACPI).

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 82 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 9169d6c08383..62c1268e55f7 100644
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

