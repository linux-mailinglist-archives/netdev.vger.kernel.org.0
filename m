Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAEF489C8D
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbfHLLYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:24:22 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:51984 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728265AbfHLLYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:17 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNQUp018364;
        Mon, 12 Aug 2019 07:24:09 -0400
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2051.outbound.protection.outlook.com [104.47.34.51])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u9qs7w65p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftuW+ZFB+NI4QftSW/MhS3PdAm5tLVKd4ZmIVL2TnL0kgyD7edxHNO3xeaZNiDApv1ZpR5I9wU0DmyRsofUOrBLrBhfpD9xSWjeDDpvtTNi+tRr6lfwDnCi+zXH9iHvalWUVtn+oJrUIWkJJys67DepYK7snhuhJZTZL8Ep4KPa7vi4xFNnld03XaSd9sDJUfJM5IL94TYSLZH/2c3ONqTpQjzFmAxzOS785wprJ7Tn3FxhmIyuSFpAqEvUsn/qUl+fQLM3GCYn43ipJ5Q+J2wNRdzWaHav9AsMxl5DV9qIQ6jkmbvoTiZ2tz5OErBZSeytfbxAcIVmae72es5PIqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HKG0Th+8f/MVnrtPfCufDXtjzS6l0PtEqUuUqulO3bs=;
 b=ADT9Vu+Rkp1QUNoZNHqb85I2e4my3Kjw11DwNXlJxIRMepatxa04gb6Ys9n8Af3Htreb9hVtAOk2H3KRSTNygIQluCZDy8az4sdxI4+k63CvkR29qt7gAO6BaXKbiW0POLDJ2vNCLhCOXcWx/Ls3YttYnP5lo8I7XBpPYH3Dqs8eza3gHvQWzyOZYk4ZpbMltajvvSY3v+xm+C39xeGF3KAkTSagDGKPgQ86ADwKketJe9SnS6YlsVAyRwvOWBiDPF5AIhv2QTiI17ravw+klWsTgFmZXDHgrIN1b47X1r151IbYeLwAnKRCEaf9eyIJJAOW/fmfvJh2H9F1onzttg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HKG0Th+8f/MVnrtPfCufDXtjzS6l0PtEqUuUqulO3bs=;
 b=qjRLWcD58NuNcBgHk3rUeqOF4JpkuCKifpLAaclouw1SZEI72sjHrRB3AjUoch38V2vXbbp9Alc4b+G7adEfu55mHdlvLNxKvA3aso16RFCYfKj3jFlH67DFU1aEAtRMQKmDFj2npntRcmYtD0Uz7MRjqqtTJDZH0qtx4RrZScc=
Received: from BL0PR03CA0025.namprd03.prod.outlook.com (2603:10b6:208:2d::38)
 by BYAPR03MB4502.namprd03.prod.outlook.com (2603:10b6:a03:c9::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Mon, 12 Aug
 2019 11:24:08 +0000
Received: from BL2NAM02FT037.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::200) by BL0PR03CA0025.outlook.office365.com
 (2603:10b6:208:2d::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.14 via Frontend
 Transport; Mon, 12 Aug 2019 11:24:07 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT037.mail.protection.outlook.com (10.152.77.11) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:24:07 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBO6Yc004174
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:24:06 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:24:06 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 05/14] net: phy: adin: configure RGMII/RMII/MII modes on config
Date:   Mon, 12 Aug 2019 14:23:41 +0300
Message-ID: <20190812112350.15242-6-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(39860400002)(376002)(2980300002)(189003)(199004)(356004)(36756003)(336012)(2201001)(1076003)(7636002)(86362001)(47776003)(426003)(5660300002)(246002)(476003)(305945005)(2906002)(186003)(2870700001)(11346002)(446003)(14444005)(6666004)(126002)(2616005)(44832011)(486006)(8676002)(106002)(26005)(7696005)(54906003)(76176011)(478600001)(70586007)(8936002)(107886003)(316002)(51416003)(48376002)(4326008)(50226002)(50466002)(110136005)(70206006);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4502;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3434d881-dcc9-4469-dfe8-08d71f1796ee
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR03MB4502;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4502:
X-Microsoft-Antispam-PRVS: <BYAPR03MB450231FD0A5691B671E05D66F9D30@BYAPR03MB4502.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: dRlaHn8y/e69jiOqRxQjs5zfWjAtBVfJuxOn2uCZRt3CuNy4lu8SUrs3QLJgRPtNzhKxw9/wvqFcthUAVw6eSEvRgarbH2qXWq8QFVmVNWPGgkTT5edBKyMSgnbAZo6oupzRW9Kv3FdKrx3q1p33NkVMfiRighzpyWG82Xw1g/BKbTtmHMNda4TkObPFmKj3gcD2O2afETMqWkn1lLw0KMqiDJnw+Oc4MJC8NPwrUT7NlIs0iCyG+txNGbNfgbl1Z6RDuJLg5DYCTZ0DhUXCTiCmBZhXg9+j6UCdv1MnWSRYTQc3DQIX0U7xDKf2i0csV4+6Z9w2W7T9CkmLQRqfDnBHelpRHeWGym7nmvNk9hZ/rf1A1as9DzHjS7I9sLfMvlsoSGYvbabcynzItTdSHoV+/rr8iIii954Dushx6Es=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:24:07.0608
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3434d881-dcc9-4469-dfe8-08d71f1796ee
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4502
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

The ADIN1300 chip supports RGMII, RMII & MII modes. Default (if
unconfigured) is RGMII.
This change adds support for configuring these modes via the device
registers.

For RGMII with internal delays (modes RGMII_ID,RGMII_TXID, RGMII_RXID),
the default delay is 2 ns. This can be configurable and will be done in
a subsequent change.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 79 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index efbb732f0398..badca6881c6c 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -31,9 +31,86 @@
 	(ADIN1300_INT_LINK_STAT_CHNG_EN | ADIN1300_INT_HW_IRQ_EN)
 #define ADIN1300_INT_STATUS_REG			0x0019
 
+#define ADIN1300_GE_RGMII_CFG_REG		0xff23
+#define   ADIN1300_GE_RGMII_RXID_EN		BIT(2)
+#define   ADIN1300_GE_RGMII_TXID_EN		BIT(1)
+#define   ADIN1300_GE_RGMII_EN			BIT(0)
+
+#define ADIN1300_GE_RMII_CFG_REG		0xff24
+#define   ADIN1300_GE_RMII_EN			BIT(0)
+
+static int adin_config_rgmii_mode(struct phy_device *phydev)
+{
+	int reg;
+
+	if (!phy_interface_is_rgmii(phydev))
+		return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+					  ADIN1300_GE_RGMII_CFG_REG,
+					  ADIN1300_GE_RGMII_EN);
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_RGMII_CFG_REG);
+	if (reg < 0)
+		return reg;
+
+	reg |= ADIN1300_GE_RGMII_EN;
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
+		reg |= ADIN1300_GE_RGMII_RXID_EN;
+	} else {
+		reg &= ~ADIN1300_GE_RGMII_RXID_EN;
+	}
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
+		reg |= ADIN1300_GE_RGMII_TXID_EN;
+	} else {
+		reg &= ~ADIN1300_GE_RGMII_TXID_EN;
+	}
+
+	return phy_write_mmd(phydev, MDIO_MMD_VEND1,
+			     ADIN1300_GE_RGMII_CFG_REG, reg);
+}
+
+static int adin_config_rmii_mode(struct phy_device *phydev)
+{
+	int reg;
+
+	if (phydev->interface != PHY_INTERFACE_MODE_RMII)
+		return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+					  ADIN1300_GE_RMII_CFG_REG,
+					  ADIN1300_GE_RMII_EN);
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_RMII_CFG_REG);
+	if (reg < 0)
+		return reg;
+
+	reg |= ADIN1300_GE_RMII_EN;
+
+	return phy_write_mmd(phydev, MDIO_MMD_VEND1,
+			     ADIN1300_GE_RMII_CFG_REG, reg);
+}
+
 static int adin_config_init(struct phy_device *phydev)
 {
-	return genphy_config_init(phydev);
+	int rc;
+
+	rc = genphy_config_init(phydev);
+	if (rc < 0)
+		return rc;
+
+	rc = adin_config_rgmii_mode(phydev);
+	if (rc < 0)
+		return rc;
+
+	rc = adin_config_rmii_mode(phydev);
+	if (rc < 0)
+		return rc;
+
+	phydev_dbg(phydev, "PHY is using mode '%s'\n",
+		   phy_modes(phydev->interface));
+
+	return 0;
 }
 
 static int adin_phy_ack_intr(struct phy_device *phydev)
-- 
2.20.1

