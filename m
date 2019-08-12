Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199E789C90
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbfHLLYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:24:25 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:55278 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728302AbfHLLYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:23 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNMJI018069;
        Mon, 12 Aug 2019 07:24:14 -0400
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2052.outbound.protection.outlook.com [104.47.46.52])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u9tu6mxa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+pQpMGx4gvbt8IaHjNZRuBzvLW7xml55RWE+0W7tzhlYlJ6LbMeO6AkIJOk9KxLw838JBIHm53odKrnVQFFEBS7dX+nMhH6FAjf8YJvZ+ATVtqFBx/TiiQk/bD49DhJtopIJoPpJKcEe4RuJyNI4iJhQ64SCxfALB/YCPEA0D0MOERO63nlkqDSco0+tDUWZGKFYpIbAXTbrfHV3turz+fwrPDtudR6QHX9jfB/QbYcfbbv3zg9f6NCB0MZBYbYgudF+HJP6ubPJWAKMtZTg66aE/LgAXsr2VWTIgI1SNIiKsFfLV4XUIk5JoyjxXFB1ionNg64OVNV2KwFiBpkRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuQ0H06FQhvk2BHLTHkCSwh5py79jfk5vk2owuExBdM=;
 b=iOPHD+XgBRSk8c5dWXit02mrOMPFvKVDSEXZFCCmkFB75ytDy89VPBscqmE/K69M3KG7CjBVhQomwNv/OzyhBV4xaXUiwABukUUc4gc4PXUDdJNA98u3h/jr38TiSJ38ZvJHLcGudDrc/iDe35V1DUfWskPhukan+PzuAEEOnBQZ08uPgIzBLli6i848synh6p/rsqCRSy3aZOx8ggHuVhLeuvHnit5esiw0EQXda0htIGDaQSm6lEYtFdu36Gk7iqoHY4txtxDmshCWSnodQ62bUL8RaRsrncIAp+dgEt5UTcIZ0uIEPQXQs3FlyQ8j63KFoIXpOOHW/VSBDo5SIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuQ0H06FQhvk2BHLTHkCSwh5py79jfk5vk2owuExBdM=;
 b=kTxkC5Wq+402D6SaK2+5OKbxY5v97sLPhoq8BizfRGQ7kreKr4rMd6hCJeltLUaj8oRL68WqtCZzIxi7jp7ezkvYJn9gh2rBGkCaA3kPI75g41erikSreQr87dOTcg130avnUfK+9ECPU8VIqh4CXk4G8veXKSs0gbeaWiIbEYY=
Received: from BN6PR03CA0096.namprd03.prod.outlook.com (2603:10b6:405:6f::34)
 by BYAPR03MB4840.namprd03.prod.outlook.com (2603:10b6:a03:138::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.13; Mon, 12 Aug
 2019 11:24:11 +0000
Received: from BL2NAM02FT003.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::201) by BN6PR03CA0096.outlook.office365.com
 (2603:10b6:405:6f::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.18 via Frontend
 Transport; Mon, 12 Aug 2019 11:24:11 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT003.mail.protection.outlook.com (10.152.76.204) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:24:11 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBOAWX004216
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:24:10 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:24:10 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 07/14] net: phy: adin: make RMII fifo depth configurable
Date:   Mon, 12 Aug 2019 14:23:43 +0300
Message-ID: <20190812112350.15242-8-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(136003)(346002)(2980300002)(189003)(199004)(106002)(44832011)(5660300002)(26005)(316002)(47776003)(2616005)(476003)(126002)(54906003)(336012)(110136005)(70206006)(70586007)(4326008)(486006)(1076003)(7696005)(11346002)(446003)(356004)(6666004)(76176011)(51416003)(2201001)(305945005)(2906002)(50226002)(36756003)(86362001)(50466002)(8936002)(7636002)(186003)(48376002)(246002)(107886003)(8676002)(478600001)(2870700001)(426003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4840;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 839781c3-b137-49a9-8131-08d71f179949
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR03MB4840;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4840:
X-Microsoft-Antispam-PRVS: <BYAPR03MB484006AD9EE1F2EE78AC7B19F9D30@BYAPR03MB4840.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: GqEJxwFR4hTrTK3x2BQty52VzP4MvNVHlBwDsr0lLLz2W6eWSDeqW2ls+VKw7aYBvRZRzjZXVhISDxQRFhk6w8HrLsfvvfj8WbrHi2spK22TPR0uQita4SwAmTrXY+uaTASLjYm7zMRKN2mKFi8ka2sQKeyxrzt+njE6peWFdsknVgloEeqb6AZtSlM/MIe/v7YRBZwjWft72/2XQoxQMSJlyD4RYVw5t+aqUZrDWw3iKQrTlIM/z9nsZC5BRO7Itz2t8VmY3T1HXF4szHH/eBeD0L16jqcnBvG7ZlGBG++Ijklr9DtreyjiYPZVmIN10E3QGerhNeVFLaUI9zzFgS7Vw1Xgzy5DSFzVq/Ee4hKtoAnORO56Smyf+mw9+3wkjkZb97p+EJcoGyxpW/rwuFkoMGko5tgsIZ/HgR4FV8k=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:24:11.1687
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 839781c3-b137-49a9-8131-08d71f179949
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4840
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=711 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120128
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FIFO depth can be configured for the RMII mode. This change adds
support for doing this via device-tree (or ACPI).

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

