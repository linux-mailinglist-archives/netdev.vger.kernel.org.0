Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F510861CE
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732443AbfHHMbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:31:00 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:24992 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732327AbfHHMa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:30:58 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CRlML030260;
        Thu, 8 Aug 2019 08:30:48 -0400
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2059.outbound.protection.outlook.com [104.47.45.59])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u8bmphap0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:30:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgDoRuhPfRYTZaUTRUEhwy4hynnIzNIdLoEY1H65c0cO8TJxWPNpm7xRIdJgiN+3rMG+kPpp//WQ0iRir9pRwnN8a7mNMCHaIqw0ExO3HvkHp+xOUjbBnQacTIDdAJJ5RD5pKMxOw5eyYvzafHdXGL3oiTadDqVTMrhf4MPXvOyduU+5tC8cHHgirbrH/ZlHHbee3I6uXnXjIAo+WYkPTysox1lbfIFLYAR+pxl29k9AL4cJhcg55372xTecr1UcoBNZC4jlC+veIXukqICR6qU8m/7oXNU1rYxxHvnlbaNZKkXueTY4svDdFIMo+JD5d7KwzZUCXogDbNo4HbH6Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPdhqdwHLnUBWmoSbZWb4yIMtk5VtPAUvwAtghdiS2o=;
 b=NyjH7RmrYec24zIPFGrnLW6Ca332IhjCbBPuxF62mHStTNs2ZwfoT/p7WUI7XiwLuwH4ViGvD7bxyOtZmQIfTGMkFi0/WY2v5zDw7jwq6bLpwBxu3jqb1w1egY9jBg9K3dAeL45IZgB7AptGy+tGtnkNIbe9R/9J1OiomkhP786k2/RAucT05GbwCXTzRCq4dVNLhjU+gihE6zmeketr6IRXIdSVdWQPAEWMy6ml4q1pTOp22lUYeEVjqKqSnWH8IY7b/PwUabRIl4cw+XeJM5jTfzKfLGaDbEd0ah59/izN0kunR9VPlllIxazPkZMAeD1X7FDk4RJPmpxibi41oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPdhqdwHLnUBWmoSbZWb4yIMtk5VtPAUvwAtghdiS2o=;
 b=legRj4HEF1T0Y3EzJwjiHT88i4KKzcnUBDeII3+Cihe5NzkGZxJT/n/k3xAObxzCcoOfKFpj2a40IiopHHoe3TuzSFQDkX92PZz0PriRXv/V/mcNKlzuqHop+0ONmw7Es8Po8ebBrvNbExDHL6wC5q6uIxjCfFegA5pMKHUA0gA=
Received: from CY1PR03CA0022.namprd03.prod.outlook.com (2603:10b6:600::32) by
 BN3PR03MB2404.namprd03.prod.outlook.com (2a01:111:e400:7bbe::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14; Thu, 8 Aug
 2019 12:30:45 +0000
Received: from SN1NAM02FT049.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::201) by CY1PR03CA0022.outlook.office365.com
 (2603:10b6:600::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16 via Frontend
 Transport; Thu, 8 Aug 2019 12:30:45 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT049.mail.protection.outlook.com (10.152.72.166) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:30:44 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CUiUE021225
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:30:44 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:30:43 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 06/15] net: phy: adin: configure RGMII/RMII/MII modes on config
Date:   Thu, 8 Aug 2019 15:30:17 +0300
Message-ID: <20190808123026.17382-7-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(376002)(346002)(136003)(39860400002)(2980300002)(199004)(189003)(2201001)(70586007)(86362001)(4326008)(7636002)(8676002)(36756003)(70206006)(305945005)(47776003)(336012)(476003)(26005)(44832011)(126002)(186003)(446003)(6666004)(14444005)(426003)(356004)(11346002)(2616005)(1076003)(54906003)(48376002)(7696005)(50466002)(478600001)(76176011)(51416003)(486006)(246002)(316002)(106002)(107886003)(5660300002)(2870700001)(2906002)(50226002)(8936002)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR03MB2404;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3411e22-88f9-4a02-6e0b-08d71bfc3c48
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BN3PR03MB2404;
X-MS-TrafficTypeDiagnostic: BN3PR03MB2404:
X-Microsoft-Antispam-PRVS: <BN3PR03MB2404FEE149D02D7B26E93CBFF9D70@BN3PR03MB2404.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 34/sBeJi4B4yKnJnNRr9QwORXCnC4lKI+/suNXc3zAVvFub1KlvifvdJyduyN+RUKIhxP81IBmN6rrRrv5RNzD0waJSqnB40114qY51PXFhNMK8zA6rIPGxOX+2GuBO9FOjGQSvElNdZraqXAX4TITY3R5DF7uJSPEyAKIqVFfcr0qEF7du71Wp9ni21IHlwXiPek+VtyCxXMIzQrcg0C7TugcMaipJhMqNAnYO+CG2Rx/GfDvFsOXxN4drictwuKFYOOi9UKLh/GgxAXSRoOOSfDSFcAM+1Dz3no46wd1THl1S0fpZxfPWRHqA/Vsdckip7MGwtAoJ68IeNF/HWRq103o8D2pmu5o4LBlnH1+koo3NJKStYEwN7oSzsz39UI+YM+4pmIzpafKgVgVCv91jQSzxedPHpdrvbPvuuuNw=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:30:44.8915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3411e22-88f9-4a02-6e0b-08d71bfc3c48
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR03MB2404
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
index a833e329be6f..9169d6c08383 100644
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

