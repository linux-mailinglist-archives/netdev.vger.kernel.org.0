Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E95DC81E3E
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbfHENz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:55:29 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:3658 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728662AbfHENz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:26 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75Dqj1i018852;
        Mon, 5 Aug 2019 09:55:19 -0400
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2057.outbound.protection.outlook.com [104.47.32.57])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u56w5svfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KT8Tl89mDCwz85dkkJt/K2LfZDoZD2FQvuN+foPlRCmBI0QfE8gG0CnlFNRh4hD3VaXpHGxU9bcJCfddw8rVbEEFzuAXtO1QpkalVk8niM4LEmv9jZ4SeK8n6WsYnvm4DQJubjV3Fn1MJjJoLN65X4ofL0d3vhCv6pGH/PVJE0qNS1fYtpX9Gwaq/VgwbO2h/3DhAaEZbq4YelNrVrKlN2CXJHAoDbB6DAJI14q4kSw82tNleY2UDyzd4XJUx4i1zt5cmjm8aC64LDy4XrX7GOOf9E4ziXdd4ivDbbeGKNDf7q/Ed+d99TLM9OPNI9B1/FOZm/cUcjfsgPPDULAA/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jb5Hk6VPO8tClzLfJ4s0o5OnMEY+Hc6h+58zVFRGICQ=;
 b=hZTxX2cRjbuldXkJlvxNBSIM2sUjeW6FO2hEo76caRhv5l9X9Ka9PmencauWqyrJLI1M0+Wta0pjk4oy0hKdtHZRCF5FEs3tjct3hMiikxPrj39xCrW7dLeUqvwDC2YynK0F55ANjdjYT7zkOhexI0JOmtC8eHbq4IvQgmYBbokqBC6fE0jdnHhBtJib/O4CsUpu10+bsRbGl19UgkvKgRUXzdRJehDBJDV054mPNibRx0o+UDt845w1NfOGofLT2FB5HxluasRsq3iKzGYAfcovG5z3ffAM7piAsUFpdg0aupFOnPe2J/+XfA7JXIGA3sDQmysipzltEIUg+fp5NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jb5Hk6VPO8tClzLfJ4s0o5OnMEY+Hc6h+58zVFRGICQ=;
 b=S9cjGfw43K6hseIwnBf4uhIeWx8HYNBGeboX0eC1nr209ng6scjapIq8ezsyFB9Askx115i70iY1nrYpIrGTQleb7kbZawh4jZJpXX3xSnRTLM54monfd6fc6CHDCHXnEBfbe2yiKfYWMhCv61jveIxuK0cwovDAQ0UdHqjQzQM=
Received: from BN3PR03CA0085.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::45) by BN3PR03MB2289.namprd03.prod.outlook.com
 (2a01:111:e400:7bba::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Mon, 5 Aug
 2019 13:55:17 +0000
Received: from BL2NAM02FT060.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::201) by BN3PR03CA0085.outlook.office365.com
 (2a01:111:e400:7a4d::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.20 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:17 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT060.mail.protection.outlook.com (10.152.76.124) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:16 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75DtD5b016201
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:13 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:16 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 05/16] net: phy: adin: configure RGMII/RMII/MII modes on config
Date:   Mon, 5 Aug 2019 19:54:42 +0300
Message-ID: <20190805165453.3989-6-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(376002)(136003)(346002)(39860400002)(2980300002)(199004)(189003)(336012)(2906002)(246002)(36756003)(50226002)(70586007)(8676002)(70206006)(426003)(2616005)(5660300002)(26005)(11346002)(186003)(2870700001)(1076003)(446003)(14444005)(76176011)(126002)(2201001)(486006)(476003)(7696005)(51416003)(86362001)(44832011)(305945005)(7636002)(8936002)(47776003)(107886003)(110136005)(106002)(6666004)(48376002)(478600001)(54906003)(4326008)(356004)(316002)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR03MB2289;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5865b632-bac1-41b8-6875-08d719ac8c0f
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:BN3PR03MB2289;
X-MS-TrafficTypeDiagnostic: BN3PR03MB2289:
X-Microsoft-Antispam-PRVS: <BN3PR03MB228921E036D083C0EE051A69F9DA0@BN3PR03MB2289.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: vXA9jK+Er5vfYeia5CmESvPToUDJLT0uH2E4f7NRo6+LSfLZO96DmsBqxsfcC24eBN8Gc2ZgZQvdqusJvHmpB845pJMVRwDZE2UXROuNbX+JURzC6YMy4idU5X+Lafj0MKwiKjOxj2lBAlry7V0cy+ii3U+qgEkmvgojRY1YcgJl+uLDIp0C/VoxTcL+AACToRTAFFSvgkCEKCvJ+pcLC81MvyLfkFY1WcK7oApmI7LllAhNVvIZf6U9Xryn6GgKFmmLR8g74cuXrG4EaUzhqL/pLfMqpvp8dodKORQeopM4vflgTCAvRXvYXOTeCZdW3jn0ZmUeva87zxRlSLeQsJsg6FW8AkCqvkNONBvoxl5ORaAWUQ5E+Y29YzLTgAajSqMUTx8G0oXLMWKr5BIuqp1fXMJCctVOTscyQxCu8fo=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:16.9742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5865b632-bac1-41b8-6875-08d719ac8c0f
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR03MB2289
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=976 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050154
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

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 79 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 3dd9fe50f4c8..dbdb8f60741c 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -33,14 +33,91 @@
 	 ADIN1300_INT_HW_IRQ_EN)
 #define ADIN1300_INT_STATUS_REG			0x0019
 
+#define ADIN1300_GE_RGMII_CFG_REG		0xff23
+#define   ADIN1300_GE_RGMII_RXID_EN		BIT(2)
+#define   ADIN1300_GE_RGMII_TXID_EN		BIT(1)
+#define   ADIN1300_GE_RGMII_EN			BIT(0)
+
+#define ADIN1300_GE_RMII_CFG_REG		0xff24
+#define   ADIN1300_GE_RMII_EN			BIT(0)
+
+static int adin_config_rgmii_mode(struct phy_device *phydev,
+				  phy_interface_t intf)
+{
+	int reg;
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_RGMII_CFG_REG);
+	if (reg < 0)
+		return reg;
+
+	if (!phy_interface_mode_is_rgmii(intf)) {
+		reg &= ~ADIN1300_GE_RGMII_EN;
+		goto write;
+	}
+
+	reg |= ADIN1300_GE_RGMII_EN;
+
+	if (intf == PHY_INTERFACE_MODE_RGMII_ID ||
+	    intf == PHY_INTERFACE_MODE_RGMII_RXID) {
+		reg |= ADIN1300_GE_RGMII_RXID_EN;
+	} else {
+		reg &= ~ADIN1300_GE_RGMII_RXID_EN;
+	}
+
+	if (intf == PHY_INTERFACE_MODE_RGMII_ID ||
+	    intf == PHY_INTERFACE_MODE_RGMII_TXID) {
+		reg |= ADIN1300_GE_RGMII_TXID_EN;
+	} else {
+		reg &= ~ADIN1300_GE_RGMII_TXID_EN;
+	}
+
+write:
+	return phy_write_mmd(phydev, MDIO_MMD_VEND1,
+			     ADIN1300_GE_RGMII_CFG_REG, reg);
+}
+
+static int adin_config_rmii_mode(struct phy_device *phydev,
+				 phy_interface_t intf)
+{
+	int reg;
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_RMII_CFG_REG);
+	if (reg < 0)
+		return reg;
+
+	if (intf != PHY_INTERFACE_MODE_RMII) {
+		reg &= ~ADIN1300_GE_RMII_EN;
+		goto write;
+	}
+
+	reg |= ADIN1300_GE_RMII_EN;
+
+write:
+	return phy_write_mmd(phydev, MDIO_MMD_VEND1,
+			     ADIN1300_GE_RMII_CFG_REG, reg);
+}
+
 static int adin_config_init(struct phy_device *phydev)
 {
-	int rc;
+	phy_interface_t interface, rc;
 
 	rc = genphy_config_init(phydev);
 	if (rc < 0)
 		return rc;
 
+	interface = phydev->interface;
+
+	rc = adin_config_rgmii_mode(phydev, interface);
+	if (rc < 0)
+		return rc;
+
+	rc = adin_config_rmii_mode(phydev, interface);
+	if (rc < 0)
+		return rc;
+
+	dev_info(&phydev->mdio.dev, "PHY is using mode '%s'\n",
+		 phy_modes(phydev->interface));
+
 	return 0;
 }
 
-- 
2.20.1

