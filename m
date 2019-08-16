Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 316B390293
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfHPNK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:10:56 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:7626 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727379AbfHPNKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:10:54 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7GD7fXA020732;
        Fri, 16 Aug 2019 09:10:43 -0400
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2055.outbound.protection.outlook.com [104.47.36.55])
        by mx0b-00128a01.pphosted.com with ESMTP id 2udu300ay9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 09:10:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qd9LzGiWoaWcl3ujUuZN/9Cd2WHQB2t33wQI5LW4vLdnXjlFcRSm+v41Kyo4tC6zMk+MRwBI4Ow0UMZuzfCxlaKQkO6nyEdDTk2xLb9ByDcYwrqZh2KeDDj16fy22jBDlQyMyBPOKQOtKzIr7CnG4OHv0RqgGCpqlgbVmMZpXuOlk/XQxgbPEyMNqzaMY+2+ogAOR6L5usgmLTFHQvYIMILE/mMcpTyBtipWg/V+fjha3oEOkK1zrgMtLBHuF3v7xOKaJJULYhpPW0fQSv5xX/8WFsNR0KhTmNZo8KKnIv9nEjfeHGfso2SYdIPdlREgTjmLyoi612lx90Yvt+jSow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qups7uoej1GiNGg0XrwfmQvbEEU/TCT4v4Ekk7cjhzE=;
 b=N8EtLTs1q5c9z+7vjxY0inS4EG+kgkudiOVbwSNByBV92yB/0f88hbT2qVWSY8SrQCO7MSzMMd8CY9ltnUo4+XToZfQXbPMRUvvyL7jmgRyGnc2L1vXOsQNVxVew6BzEXSRwxZClXV/6e+OisAAXOpXmOPibf3fqKLvkXbKgBhWykN9TzMcHIlXMh91kwm6nFt29GI61EtdE65NU+6thjFuKVf5rKa3KSr7Nwhjbu8auzAyH/m3qoUmvciUMzYG6UoXUgl65SZXD6V36X7fz/NetAHQLDybNNKlhej6m/eXff3ri2I5H3t7U68QE518s7DCbseC/DiTDTOCrw5HS5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qups7uoej1GiNGg0XrwfmQvbEEU/TCT4v4Ekk7cjhzE=;
 b=Oqzl5208E3A/D8Uz1YijHQmYKSxfSgEy7HagvxTtweLVdVE6X+I9G6uBAtjft6wlROGPZlpWfpH2SFjcdVRUwla/YGt02DnT5sJehtodR/tSyLjn0NvZSOHHEkXXAtUyT7oyWgT5Z4bBzZLBFNiUVni7ClnvQtDQW70EvdaYIhs=
Received: from BN3PR03CA0105.namprd03.prod.outlook.com (2603:10b6:400:4::23)
 by DM5PR03MB3259.namprd03.prod.outlook.com (2603:10b6:4:42::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14; Fri, 16 Aug
 2019 13:10:38 +0000
Received: from BL2NAM02FT029.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::205) by BN3PR03CA0105.outlook.office365.com
 (2603:10b6:400:4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2178.16 via Frontend
 Transport; Fri, 16 Aug 2019 13:10:38 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT029.mail.protection.outlook.com (10.152.77.100) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 13:10:37 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7GDAbaS007900
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 16 Aug 2019 06:10:37 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 16 Aug 2019 09:10:36 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 07/13] net: phy: adin: make RMII fifo depth configurable
Date:   Fri, 16 Aug 2019 16:10:05 +0300
Message-ID: <20190816131011.23264-8-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816131011.23264-1-alexandru.ardelean@analog.com>
References: <20190816131011.23264-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(2980300002)(199004)(189003)(126002)(316002)(54906003)(2870700001)(50466002)(110136005)(70206006)(2201001)(356004)(6666004)(70586007)(106002)(8936002)(50226002)(86362001)(5660300002)(2906002)(36756003)(51416003)(478600001)(47776003)(1076003)(44832011)(48376002)(336012)(426003)(476003)(4326008)(26005)(11346002)(305945005)(8676002)(186003)(486006)(7636002)(7696005)(76176011)(2616005)(446003)(107886003)(246002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR03MB3259;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb4f84f6-e239-4ef3-68d2-08d7224b21a9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM5PR03MB3259;
X-MS-TrafficTypeDiagnostic: DM5PR03MB3259:
X-Microsoft-Antispam-PRVS: <DM5PR03MB325940E0D007F36408F295C9F9AF0@DM5PR03MB3259.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: zenr2iGeguXhJRjvZHf9CIFplqZdiq2e56Yu4DY/ZTDlhMMhFT4z1BN8WT+HbNcCCDWj1VzMhvgRnGR6wMPfs0fXeGTJDT1xnuVtO9pkT22BrU9vqTqnT/hIC/DF12CKBC2ITHPb/o7461SFosBIB/2Dt2AtcUPyc0vtemuJQa/M6jjt92M2IJbTMMzZ8j1Py7nTkvY6TMoA4PkR9EAq8PbeUZImFm4lGw4EfFgkn/GUX5kD8yrWh8q71IijW3AY+6YLKEQWJtIi/GqdFzn6IjKmHKEolcJvKFo+6L5OCTvECm10LRUFNBHRHE/RQiZFN4ImnO4u1SKXmTOjqcf0pI7FLxOuFYol7jB/Z7hn/hkh10udyrfXwNvVamAFn/U49BGF4cNkXc0NSkC9kCtEsZWJ7u+Az9tDgL5DSa0qABM=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 13:10:37.7265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb4f84f6-e239-4ef3-68d2-08d7224b21a9
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB3259
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=766 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FIFO depth can be configured for the RMII mode. This change adds
support for doing this via device-tree (or ACPI).

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index c882fcd9ada5..4ca685780622 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -52,8 +52,19 @@
 #define	ADIN1300_RGMII_2_40_NS			0x0007
 
 #define ADIN1300_GE_RMII_CFG_REG		0xff24
+#define   ADIN1300_GE_RMII_FIFO_DEPTH_MSK	GENMASK(6, 4)
+#define   ADIN1300_GE_RMII_FIFO_DEPTH_SEL(x)	\
+		FIELD_PREP(ADIN1300_GE_RMII_FIFO_DEPTH_MSK, x)
 #define   ADIN1300_GE_RMII_EN			BIT(0)
 
+/* RMII fifo depth values */
+#define ADIN1300_RMII_4_BITS			0x0000
+#define ADIN1300_RMII_8_BITS			0x0001
+#define ADIN1300_RMII_12_BITS			0x0002
+#define ADIN1300_RMII_16_BITS			0x0003
+#define ADIN1300_RMII_20_BITS			0x0004
+#define ADIN1300_RMII_24_BITS			0x0005
+
 /**
  * struct adin_cfg_reg_map - map a config value to aregister value
  * @cfg		value in device configuration
@@ -73,6 +84,16 @@ static const struct adin_cfg_reg_map adin_rgmii_delays[] = {
 	{ },
 };
 
+static const struct adin_cfg_reg_map adin_rmii_fifo_depths[] = {
+	{ 4,  ADIN1300_RMII_4_BITS },
+	{ 8,  ADIN1300_RMII_8_BITS },
+	{ 12, ADIN1300_RMII_12_BITS },
+	{ 16, ADIN1300_RMII_16_BITS },
+	{ 20, ADIN1300_RMII_20_BITS },
+	{ 24, ADIN1300_RMII_24_BITS },
+	{ },
+};
+
 static int adin_lookup_reg_value(const struct adin_cfg_reg_map *tbl, int cfg)
 {
 	size_t i;
@@ -156,6 +177,7 @@ static int adin_config_rgmii_mode(struct phy_device *phydev)
 
 static int adin_config_rmii_mode(struct phy_device *phydev)
 {
+	u32 val;
 	int reg;
 
 	if (phydev->interface != PHY_INTERFACE_MODE_RMII)
@@ -169,6 +191,13 @@ static int adin_config_rmii_mode(struct phy_device *phydev)
 
 	reg |= ADIN1300_GE_RMII_EN;
 
+	val = adin_get_reg_value(phydev, "adi,fifo-depth-bits",
+				 adin_rmii_fifo_depths,
+				 ADIN1300_RMII_8_BITS);
+
+	reg &= ~ADIN1300_GE_RMII_FIFO_DEPTH_MSK;
+	reg |= ADIN1300_GE_RMII_FIFO_DEPTH_SEL(val);
+
 	return phy_write_mmd(phydev, MDIO_MMD_VEND1,
 			     ADIN1300_GE_RMII_CFG_REG, reg);
 }
-- 
2.20.1

