Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54E687B57
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406747AbfHINg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:36:29 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:6182 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406700AbfHINg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:28 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DMxhW000763;
        Fri, 9 Aug 2019 09:36:21 -0400
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2052.outbound.protection.outlook.com [104.47.44.52])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u8bmpn4j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=En154iBr5ZsHOhhQ7++RBXMURvCZJPzSzcKwZUAvFXrtE10R5KG/7CuU4aS0HLeT++WG8aNOd9eGm6ZRjbG2FYP5n0kXdB8N/pWqxIAMr3c5XgwAV7fPPgaRPDUnogwcaNfZBsQZ9c/rEFMnscM9GuyMVRVu1kXcedxISC1nOI5KQ+xAKBe0JwJJRbhYV0/cwrVPAH+aOydftdJCefFXMPrK/MYNfCcUORgod59xwIbyljQ/3CyiB9kGxSs3ZcmfDJZTOecOa/XIiPGVqd54QNhnci6lcvB7ZXYNWTdYwAMrvTdjL+emd/cteIYTkKOhPC7d/pROGF6l+MhHHooZNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2h/ichLUEjJDDKQSwv8J6wrkOvoF+sr5bEzvHpvlaRU=;
 b=I3p/bPIzNBt2PtSZtHOvSPA50KcSMjYCm6ZB1eqBjKpfLKQaph2UTc6TyUYvKTCzE503zqRGDELH2f9Ws1wySXU0il8ITtnDdb3lEle5mR2fDFGz6Z64Lr76jb6SETeGK2V+BASq1wcg0R2TZW4jW1os0OWjAfC0aNfc9/zzxqAraz+vSaIwusmghDjtRIVK7lfXWsvNLJ45RIoxUAlAM+ENSphs1GN8FI20uWCh4u9pGxHDq3RtyHXacPjY+oTATGw+P5rgtsJxrx10G6FAr6eDZ96Bc/j6mUHH/bUUVSNOub7sVYBshfZ9Flu9U4YR7OLnfoiqNUWCotwgccZx1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2h/ichLUEjJDDKQSwv8J6wrkOvoF+sr5bEzvHpvlaRU=;
 b=ltfp375xEBtnXkq+REodgBYnMIPLPV294cb2oAXk8pSrCZ1ru21z48v47oHPsrnJ2mvCywqx5DzU1DhZYBe6lENPaPRrM470ZPrJLaQBi6BiOeJQLLlB+WvhFEruiFzJASWz5Pp4s9tH4U1rPBBlgQ6umQEDuWxMtvxi8fMLa+I=
Received: from CY4PR03CA0074.namprd03.prod.outlook.com (2603:10b6:910:4d::15)
 by DM6PR03MB5033.namprd03.prod.outlook.com (2603:10b6:5:1eb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16; Fri, 9 Aug
 2019 13:36:19 +0000
Received: from BL2NAM02FT043.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::202) by CY4PR03CA0074.outlook.office365.com
 (2603:10b6:910:4d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.15 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:19 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT043.mail.protection.outlook.com (10.152.77.95) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:36:19 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79DaJhU025749
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:36:19 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:36:18 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 11/14] net: phy: adin: implement Energy Detect Powerdown mode
Date:   Fri, 9 Aug 2019 16:35:49 +0300
Message-ID: <20190809133552.21597-12-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(396003)(346002)(376002)(136003)(2980300002)(199004)(189003)(2906002)(336012)(36756003)(2870700001)(47776003)(110136005)(76176011)(316002)(246002)(107886003)(7636002)(7696005)(51416003)(14444005)(426003)(2201001)(86362001)(1076003)(8936002)(70586007)(305945005)(486006)(126002)(48376002)(2616005)(476003)(6666004)(356004)(8676002)(11346002)(70206006)(186003)(446003)(4326008)(50226002)(106002)(44832011)(54906003)(478600001)(5660300002)(26005)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB5033;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f7ddcca-0d10-422a-024b-08d71cce8fa3
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:DM6PR03MB5033;
X-MS-TrafficTypeDiagnostic: DM6PR03MB5033:
X-Microsoft-Antispam-PRVS: <DM6PR03MB5033ABBA9CBFDECA861E1036F9D60@DM6PR03MB5033.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: oqtE5RHkGuxxG51bRuUxbwg01zj9axOAmVkqWeAn5QmncXpFQ8jDP1KE/bhuXsbrLlQs8h2aqOCOpJJiCvqVIZMUsJpzCtEdiEbE+ZQddD4Ose5uBA7ntxtLZb8qJvpKGPNKJpoM5S7xqGIUagh9ra+lIaYor/nh8EF22vHJLps3dKOCfZUcpjRpnJHVkv8KWIQVS81mspQ+FhWMuCgMLqs+xro7inugmTXb97h9z6/1XQOe8TCOCsiPz0ca2VtW9CQXjz5FWvESm/MO3JnCJV5rXDqosRnYe/agNGVx/BTbZiw3wM/cCPawcjvpiSz2BhF4rbgeJegHW78LJAx71GHd+iyQhwkwNi27I17EfWjmNM58DgWeQWshhyWG6aQR3ZAxXJgaowmFIO88Jt8ooFLdV1MHeTdgcOv9UwZoxNA=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:36:19.3869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7ddcca-0d10-422a-024b-08d71cce8fa3
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB5033
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090138
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
index 63b57c83de91..e086e2d989e0 100644
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

