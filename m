Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC4D89C96
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbfHLLYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:24:32 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:34732 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728348AbfHLLYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:31 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNG6v003849;
        Mon, 12 Aug 2019 07:24:22 -0400
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2055.outbound.protection.outlook.com [104.47.40.55])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u9tj5w613-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dEYDOdZVcoiAHoVsWLNljqCdLlMF56pejZr6dpas7Dw4+0cnbtHH3HjhFgs+9CSwvjrTgpNTdkfJx+yvOmE+J4yS2+lddlfgWcb5Er/JR0pcOZP5sOKQ6viH0cu/V7xxtTaRphyjmxMWAtUclsow0ZfJp+9tNRKmo9Mct68GEkQsSBR6Leaf9qTSB7R2t5jkjTeVvt7jmI/QMfu7NE6wsG6zllNcJwVDks5gzxxr4FXyGeAOQyfW3rjHFMYEj1l32Zxhwg/lmIP4XD4z1Mv378XoTjNINo2HuPnO/T9xPLySsj/KQrbUdJthnmSzKzgtfvCos+M7cGYgDH+HVT8mcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzh9+S35r0MSTQpWDiVMbPJ/0XtLVXAkv3zgwIstezI=;
 b=TRt9efEnTedFuJSZsrDp1WJrq6h9YVxHqmMoSpuUuZIXMLFuRvQ70XI/qNnEwgvtQJ42b5jKtqCd1YkmgdfoNtavjJyq9kLqiGzuZ6zI1t3b+wUaTNAhnYMRtKMxudAJPoNTiukBwnF/24OIBOVuB/YRUhBiiWwP4Fsex2AvaEkK3cK3WqX1dnY0lpc7S55pQkF4cnzF4Cvh2uuxEQgQzZqvl1eUu8QWuZNU1R0a0P2iZuhKxwYCyLp/Rf/Ydhh9D81brV8t27gYjIe0cdq+BXECLDRFqnvIa/yAXgSaKzNjkTfBjZglJ8VJNy+0NNexnAKqkMpTXZ5ow/T2oevnHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzh9+S35r0MSTQpWDiVMbPJ/0XtLVXAkv3zgwIstezI=;
 b=wzmC0F3FrhQdJgrNbKodS+4la6AkxfVQq9QvFmupala6XL88zin0hhzSQ0g7rDH3BXNmCLkNt4NMBzsFPw8bMoFD2RamqnE0f3YH+DKMRaedDiJt6bvLoqoimEoL7tYDFbXiXUqKElngjdf3CqRfoKAQrfprJfqjH0xTPmX+MSU=
Received: from MWHPR03CA0026.namprd03.prod.outlook.com (2603:10b6:301:3b::15)
 by BL0PR03MB4257.namprd03.prod.outlook.com (2603:10b6:208:65::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.13; Mon, 12 Aug
 2019 11:24:20 +0000
Received: from CY1NAM02FT019.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::206) by MWHPR03CA0026.outlook.office365.com
 (2603:10b6:301:3b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.15 via Frontend
 Transport; Mon, 12 Aug 2019 11:24:20 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT019.mail.protection.outlook.com (10.152.75.177) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:24:19 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBOJhN004260
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:24:19 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:24:18 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 11/14] net: phy: adin: implement Energy Detect Powerdown mode
Date:   Mon, 12 Aug 2019 14:23:47 +0300
Message-ID: <20190812112350.15242-12-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(346002)(376002)(2980300002)(189003)(199004)(107886003)(478600001)(7636002)(26005)(48376002)(50466002)(86362001)(50226002)(305945005)(8936002)(426003)(70586007)(2870700001)(336012)(2906002)(4326008)(356004)(6666004)(246002)(51416003)(44832011)(76176011)(70206006)(7696005)(2201001)(446003)(11346002)(476003)(186003)(126002)(2616005)(8676002)(316002)(486006)(54906003)(110136005)(47776003)(106002)(5660300002)(1076003)(36756003)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR03MB4257;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 613a0036-5822-49d3-07e4-08d71f179ea8
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BL0PR03MB4257;
X-MS-TrafficTypeDiagnostic: BL0PR03MB4257:
X-Microsoft-Antispam-PRVS: <BL0PR03MB4257E92ADC69FDC559E92864F9D30@BL0PR03MB4257.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: LYjakc6DolE2qPvXA9rOrdGmpWfZ6dAoPSe3N+4ClzTFX4h8eJa9luSn1eQ/64bceBzAGgtZv1VtAKVYDMbSzaxuqRfpoUvce09p4/3LzWZnwGEINGfsP+a7yPGi4naf2FzA7D61bp0KbMNfCGcrnObeZ7ScnyHKqUytGPjnR/Tbx01RWpKW6UgqVV72+THEtUvJ/Cxf5R6cZz6KK9HESXU6U2M+KgIqA/70kVIakVelFn1ZPjnicKrKGRGjcnP/3e0oX1Dve00T9s3IEh06bNmezvS1/WOl64sZqxOsfb83HIztuxRJ376V1jEdQeoLolkd0DHUCTWrdXXfFKyUKzXMxp0AlveuObacV5iQQ41oskUn2xfGw2olc2ZVIZ3t38DiB2hEkFsDgZ4V/8GNJoFK/VWafDX/VYeMgWDRGGc=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:24:19.7401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 613a0036-5822-49d3-07e4-08d71f179ea8
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR03MB4257
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120128
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN PHYs support Energy Detect Powerdown mode, which puts the PHY into
a low power mode when there is no signal on the wire (typically cable
unplugged).
This behavior is enabled by default, but can be disabled via device
property.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index ddf0512a9a4d..131a72567f25 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -24,6 +24,11 @@
 #define   ADIN1300_AUTO_MDI_EN			BIT(10)
 #define   ADIN1300_MAN_MDIX_EN			BIT(9)
 
+#define ADIN1300_PHY_CTRL_STATUS2		0x0015
+#define   ADIN1300_NRG_PD_EN			BIT(3)
+#define   ADIN1300_NRG_PD_TX_EN			BIT(2)
+#define   ADIN1300_NRG_PD_STATUS		BIT(1)
+
 #define ADIN1300_INT_MASK_REG			0x0018
 #define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
 #define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
@@ -136,6 +141,14 @@ static struct adin_clause45_mmd_map adin_clause45_mmd_map[] = {
 	{ MDIO_MMD_PCS, MDIO_PCS_EEE_WK_ERR,	ADIN1300_LPI_WAKE_ERR_CNT_REG },
 };
 
+/**
+ * struct adin_priv - ADIN PHY driver private data
+ * edpd_enabled		true if Energy Detect Powerdown mode is enabled
+ */
+struct adin_priv {
+	bool			edpd_enabled;
+};
+
 static int adin_lookup_reg_value(const struct adin_cfg_reg_map *tbl, int cfg)
 {
 	size_t i;
@@ -244,6 +257,18 @@ static int adin_config_rmii_mode(struct phy_device *phydev)
 			     ADIN1300_GE_RMII_CFG_REG, reg);
 }
 
+static int adin_config_init_edpd(struct phy_device *phydev)
+{
+	struct adin_priv *priv = phydev->priv;
+
+	if (priv->edpd_enabled)
+		return phy_set_bits(phydev, ADIN1300_PHY_CTRL_STATUS2,
+				(ADIN1300_NRG_PD_EN | ADIN1300_NRG_PD_TX_EN));
+
+	return phy_clear_bits(phydev, ADIN1300_PHY_CTRL_STATUS2,
+			(ADIN1300_NRG_PD_EN | ADIN1300_NRG_PD_TX_EN));
+}
+
 static int adin_config_init(struct phy_device *phydev)
 {
 	int rc;
@@ -262,6 +287,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_config_init_edpd(phydev);
+	if (rc < 0)
+		return rc;
+
 	phydev_dbg(phydev, "PHY is using mode '%s'\n",
 		   phy_modes(phydev->interface));
 
@@ -481,6 +510,17 @@ static int adin_reset(struct phy_device *phydev)
 
 static int adin_probe(struct phy_device *phydev)
 {
+	struct device *dev = &phydev->mdio.dev;
+	struct adin_priv *priv;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->edpd_enabled =
+		device_property_read_bool(dev, "adi,disable-energy-detect");
+	phydev->priv = priv;
+
 	return adin_reset(phydev);
 }
 
-- 
2.20.1

