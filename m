Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F133587B74
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406625AbfHINgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:36:21 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:25870 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406551AbfHINgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:20 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DMx1l010840;
        Fri, 9 Aug 2019 09:36:12 -0400
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2053.outbound.protection.outlook.com [104.47.33.53])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u8tcbtf7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARAVQ3HqSublhy7nG+2WQzgUZcAa70+z2dh8CDWJya7GW55pmKUPkAXfqdGgjjL1Nqz6OFv7xHgLp21+T4ZbBaFzyQbCLoJXstDp07vcPnYiRb7SuLTr+nPSu6DtqUAxdpriIaJSKo7MoghrQ9W5Z3hV8GSnlcQAbJAORLKnrjL8ErmkT3L3gf5A8e/ITGXM6RxP06Q1slPholyxu9T0tzY7dEnfdTSVov1Ai9h5Yk+1jDsanNDtN1YUSIWaUYidvxSXUOs8p+JTAazWgHHU8SjhQ3xnGLc8yAmfUeYy2SbggpUU+AsZWnoGA0qB/YaEcudIZzkfy0jxLxlWtLUCWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10Ity9weZBw9wCy63WphiBG71H7iLxJI9iyO9Ul7vgY=;
 b=ZsU3v/LjEpJD3VeRWrnT82BORIkLSoWJABm/4Vstts0+YsorOeUwSfsXPqTcIQ3GkPZDv/Tj8I5lTIHVE8IGlqA+hjAH7k2OnE2Hu/YDXFT1VmsK3SQ10gqGXLtcWZ89QlcAoyz/XFYk2woR2v2LluvTddijgrTXZSTOBFGI4nrs/S6z7LsdJ00Cz4LeDEpOFG6Z4O/VMi2BdkRkl0Lto/EX580keqTryeZKXBvkyyMHpJp5Fffir4TZ3d5Q3ClCunyu78FntiCpRDdTSPi48C368gT/RnoFvAwF7mQpXa+wo0NXN/z2KzlQc/nejemAvYWSy4vGbOvaCdXEmRwX7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10Ity9weZBw9wCy63WphiBG71H7iLxJI9iyO9Ul7vgY=;
 b=QH/2L2b8eusD9jncFACBUKYEt4QaULkhIuMFFJg0rax4b5PaOoAlgBgX3LC14tqKw7rdd2m1o0dPW7JWRPYl5XTqNq66G4YIPycCto8xOoOdSrobcY3VT8a2ssPWDGP7OIB538xHKZSuy76AnPzVmLoI2Tv74ZJNXQzIIRPH9DA=
Received: from MWHPR03CA0044.namprd03.prod.outlook.com (2603:10b6:301:3b::33)
 by BYAPR03MB4647.namprd03.prod.outlook.com (2603:10b6:a03:12e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Fri, 9 Aug
 2019 13:36:08 +0000
Received: from CY1NAM02FT028.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::207) by MWHPR03CA0044.outlook.office365.com
 (2603:10b6:301:3b::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:08 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT028.mail.protection.outlook.com (10.152.75.132) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:36:07 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79Da7ge025663
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:36:07 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:36:06 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 05/14] net: phy: adin: configure RGMII/RMII/MII modes on config
Date:   Fri, 9 Aug 2019 16:35:43 +0300
Message-ID: <20190809133552.21597-6-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(376002)(136003)(346002)(39850400004)(2980300002)(189003)(199004)(36756003)(5660300002)(2870700001)(50466002)(14444005)(186003)(107886003)(7636002)(4326008)(2906002)(316002)(1076003)(86362001)(50226002)(47776003)(6666004)(54906003)(356004)(7696005)(51416003)(26005)(48376002)(110136005)(76176011)(70586007)(305945005)(246002)(446003)(476003)(126002)(106002)(478600001)(8936002)(486006)(70206006)(2616005)(8676002)(2201001)(11346002)(336012)(426003)(44832011);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4647;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fcdcb93-f822-4d10-7191-08d71cce88e2
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR03MB4647;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4647:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4647C299DF3CAD326CBF2276F9D60@BYAPR03MB4647.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 6JEgNMN9k4RT31i6PA24Y4kCkEoKviUy3JGYi41PybKSvqnQLdNwV9/urm6Zp/KShWZVyMd7oC6MLVqe2jWUplcLpn3DiG8kSJlD8Mgur1qTXCPfGCMMj2Cr8f3pmMG3t1o2iUzfFLnhZ/56vUyfwZUyb1cbAYUX65W8FIB7ngiDdvqaZk1VdX55+oDycUNgDGo7iYmXtMIR37do0kEZ0YEc2tPF0Tfd2ILQn/3SWpcgYY5NhOrtGT3f4Hi/xAbh6TuAiLuMywxpLuIVwr5BDmUdJhK0Kqdn5Bzg+t9C7XIVsPEBqL/MT0mR0lJtvwuP57IzX4o+QRtn0+a4ptC1I043OCbfww3V/xph2N1jnzlIwziNSg8dbJRTmJy6fkYumcmrW2GAIQJQu/bicksOAAcx+m1bH6sIw5x/oH4VPlg=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:36:07.6152
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fcdcb93-f822-4d10-7191-08d71cce88e2
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4647
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
index 8973ad819b93..6ea0d7bd76c5 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -33,9 +33,86 @@
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

