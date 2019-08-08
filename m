Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C142861BF
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389923AbfHHMbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:31:10 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:35574 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732327AbfHHMbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:31:07 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CRlYs002123;
        Thu, 8 Aug 2019 08:31:00 -0400
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2059.outbound.protection.outlook.com [104.47.45.59])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfkv52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:30:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UANfABmB6XWQ/RV462vDnsHAwdNJW3h5SELnWkvG3LG8AZIXYxiTzb5WUx8PZm0ppEAoaQzJpKka7qGErOyyL8viyQkRLL7S5qOfIZplgrBjIEwnQ/zvD9jrvOrLQku68vskTXhjxZNFBqqC0usuVaCwHXO54qP1escBgU9OHxXjPNd+C/aCFPy4kfcbndf3ODdrwKkHKPytFCeS4VA46I3voKctLnC2u/S9MNaUME6NntrmeivYKgktfDrtXhIn/CP70eN6MxEurhzg0LENwJxEegNWIuvsJc1hMCQ1Nh3AHop6v8DInpsXalLXLrGW1QVag79pi5GV1d5OVocTdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnTHv6Q7MqlOozcXUJPCFC2jyIGJGvFV43eNsz0BdEU=;
 b=A0cR5KG2yxgjlec9hAbsH1pUo4K1Zo0/3Kv7cit7MJ75piQ3s4c/W80xDnA6968ZuUxjpPjcTZFVGfPqz9Wc5IqRLT+s5d9ayeLuPFlO+Bqs6Py3Lsk991NDp0iE5DyoVSOPBDmlDbs1iyC2qjTJzWnGNdKBn6yyEVPvntWUgpt6MPu4lZaeC3KycPlAPCdlHbIGYDFqx29JogZ4TOpId+JCuCgLMeW4lBbtBEGIfeCA38X9+6PhJL4y1KmfgIXehWRhOoDZSX0oI8zAoZKRCNIDnLV1uong2Np4vn86Gz/yIWdAQfBcLMZ7hraXNFQ4eiRQX4gQWfyMvYwcUCp6fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnTHv6Q7MqlOozcXUJPCFC2jyIGJGvFV43eNsz0BdEU=;
 b=nb/KEmTpGho/MyolhoKVyq9ehansmOt+Rh0qOcRA67Yj+HnyyHocLtHBGW4LmjnaPrbOadgdp5sQ1Xt4nUfvhx301lzJKYIJMTTBgNG9A8nx25JxZLB1tir0shpIKYhA6Vm803yz6ZVQfGqkBJ1hqn0UXWBzPi64Tc5Ef6PAQDM=
Received: from DM3PR03CA0003.namprd03.prod.outlook.com (2603:10b6:0:50::13) by
 DM6PR03MB4714.namprd03.prod.outlook.com (2603:10b6:5:181::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 8 Aug 2019 12:30:58 +0000
Received: from CY1NAM02FT045.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by DM3PR03CA0003.outlook.office365.com
 (2603:10b6:0:50::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.16 via Frontend
 Transport; Thu, 8 Aug 2019 12:30:58 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT045.mail.protection.outlook.com (10.152.75.111) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:30:57 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CUuW4021277
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:30:56 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:30:55 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 12/15] net: phy: adin: implement Energy Detect Powerdown mode
Date:   Thu, 8 Aug 2019 15:30:23 +0300
Message-ID: <20190808123026.17382-13-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(346002)(136003)(2980300002)(199004)(189003)(1076003)(7636002)(76176011)(305945005)(356004)(4326008)(5660300002)(186003)(6666004)(2906002)(8676002)(26005)(478600001)(2870700001)(107886003)(126002)(476003)(54906003)(336012)(316002)(446003)(50226002)(14444005)(8936002)(70586007)(51416003)(110136005)(486006)(44832011)(106002)(48376002)(86362001)(47776003)(11346002)(36756003)(50466002)(426003)(2616005)(70206006)(2201001)(246002)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB4714;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78bc084e-bc94-4c60-9bb4-08d71bfc43d3
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM6PR03MB4714;
X-MS-TrafficTypeDiagnostic: DM6PR03MB4714:
X-Microsoft-Antispam-PRVS: <DM6PR03MB47142743EBFB60C40E933D82F9D70@DM6PR03MB4714.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: sroe9JKdotZJ4s34SqS8jtUGC7uHjMIfsAKzTKAInqrc3G4L3/ryVF2Jz3qVgfqTzV/trSfXfiFKQxqmHLpCy5DNWNfW33X94uHdlDG09OII/0iliFGTkyUbYidOdlO31I9sZPBVhdyMQIPaMAFGhRNWzvz0rS50iEncwDqbFD6oM+TQzcE913x79oVMpcitQyPtwTzfsn/g4qPy6JmVyH22+3jQBgBuTOKqeRzpKgShlz0RPm+QtpQvPOvBk5i3hVOZ0k5PehrUSg1yUBcgnvB7UuPlqS48JyAmA8+LK/fN/bbS7aQqyWxXZUSoRIUvLnwBCZu3CDteuSbHSoDruz3TyF3+KlqbNrQWhmecMMpef1Rre5PARjEG7tB5mXjkX6cnd6YfdyATi6VEWBcH4pnHuK9OscalfqW27FL9LQ8=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:30:57.4440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78bc084e-bc94-4c60-9bb4-08d71bfc43d3
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB4714
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080130
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
index f276d692bdee..bc4393195de7 100644
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
@@ -138,6 +143,14 @@ static struct adin_clause45_mmd_map adin_clause45_mmd_map[] = {
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
@@ -246,6 +259,18 @@ static int adin_config_rmii_mode(struct phy_device *phydev)
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
@@ -264,6 +289,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_config_init_edpd(phydev);
+	if (rc < 0)
+		return rc;
+
 	phydev_dbg(phydev, "PHY is using mode '%s'\n",
 		   phy_modes(phydev->interface));
 
@@ -495,6 +524,17 @@ static int adin_reset(struct phy_device *phydev)
 
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

