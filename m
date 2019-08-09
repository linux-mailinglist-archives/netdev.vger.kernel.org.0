Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8186687B5B
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406798AbfHINgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:36:33 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:9574 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406779AbfHINgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:31 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DNAeg026401;
        Fri, 9 Aug 2019 09:36:23 -0400
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2059.outbound.protection.outlook.com [104.47.37.59])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfqjym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9a1LSCIvuQAbuQtUr8Xvl6ChLb4cTFOqfD9SAP3SqmsqqNzSg84VeX+mw+YqV9uyASqkw90L0UsyLpRgkEhN/nNFcJ1bmwP+Wrz7sRFbmz53nyev7piJR/WlyoPQ7gy9SdjQ0lWoUHL4BdcnF+3uXNR8bEi+M36W9iQLgfyveUHWfRCIXW25hFz7cwA5EIOcxTuAAZUTiN3dg3DzE1h27x/vHLh03WuAqGk0MmhekJyPyRmdmRMfzQ0K9MFm6TavMbAtfUjHtcdyNc23BjrQveTHz9znrSlTAQEx09nDDOT9BHCbdhSFXGDYZw4qo2TTOsG811+prbkrMo7d5UAAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oe0gxr6tSP9KYGO6x7Mrg7LnxKsrO2dmlgLYVx/d9lU=;
 b=YtWmv1TJDh3IcIRL9XNCkArm6hkBhaIOyxWGC4BbFajVUidTpG5pXBNPA+y6Hifdc01kAUZ2QaZ+0xDLTafhG7LKgrVSg5bPtlBlUpWqrDTN7HEoAKfFkyWI0VmdWwlSCmgEyK140jvQB5zRuK6UYXRCXCVmgR9/flGix1OuCtMrLOq13DKxP32QcdGS7wUvZBEkbtVbTUsperviONM1VIoEYEX+GuRFcni8maRjttouIEMUWCcc7Ql7tCF3xPPv0ixceq/1+3HUR4cEvkn9cPPFwMcSrXitxbZAqRjOhH+V+4u+iBOGSmsRdZyJ5H1+yexpxT1h3KSlGL340PMZnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oe0gxr6tSP9KYGO6x7Mrg7LnxKsrO2dmlgLYVx/d9lU=;
 b=4zD+9UFnnE53477EbeVfjaDwxNN35xtvpjCNCTNkerFS75Zh0zXfmde4QMwJLy6+Ueeofsa60STbVvR0+MvB9hHhUeWWUlIOjhwGPGIehNFoVmVQCr9ueRRotVQmEzZ8IinBJ98M5D4y5o45XPsXgLpcYXRXZYygBVTK9U7vGY8=
Received: from CY1PR03CA0040.namprd03.prod.outlook.com (2603:10b6:600::50) by
 DM5PR03MB3034.namprd03.prod.outlook.com (2603:10b6:3:11f::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 13:36:21 +0000
Received: from BL2NAM02FT052.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::200) by CY1PR03CA0040.outlook.office365.com
 (2603:10b6:600::50) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.15 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:21 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT052.mail.protection.outlook.com (10.152.77.0) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:36:21 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79DaLJD025758
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:36:21 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:36:20 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 12/14] net: phy: adin: implement downshift configuration via phy-tunable
Date:   Fri, 9 Aug 2019 16:35:50 +0300
Message-ID: <20190809133552.21597-13-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(396003)(376002)(136003)(39850400004)(2980300002)(189003)(199004)(110136005)(47776003)(5660300002)(336012)(126002)(486006)(1076003)(446003)(426003)(7696005)(76176011)(51416003)(186003)(4326008)(26005)(44832011)(356004)(6666004)(316002)(54906003)(2906002)(50226002)(305945005)(107886003)(86362001)(70586007)(50466002)(70206006)(2870700001)(48376002)(246002)(8936002)(11346002)(476003)(2616005)(106002)(478600001)(7636002)(8676002)(36756003)(2201001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR03MB3034;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fb1c4b9-d705-44a1-77f5-08d71cce90df
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:DM5PR03MB3034;
X-MS-TrafficTypeDiagnostic: DM5PR03MB3034:
X-Microsoft-Antispam-PRVS: <DM5PR03MB3034272AC3B9B309787F42A5F9D60@DM5PR03MB3034.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 0FFdEaY0ljttDWMGDL2lVDtPjxtcNJN0iVW0IS8SGHXiaYcnrn+iAZskl8PsWoAnD92/+/vDcnmXboIHOfmNvuyHdwsh+SWoC7/l7mG7t3ad+k5epkFCrjQNKf//ihUSoQjkNY6nWONK6lB6/HBxOoskuEux6g39l9F+9M57ePICa+MLhtVpRpBf8Y7vFZudZT+6qjql2B3zrsziS/m/3rC5Lk7TP+wICd/uR+b/IoGyoIxPfXe/uTndza9U3+KYdVaZ7AM9LurvLrJn5PETMZV7L5M6JD1XmvkG15XdfWC7UCt8h95hciPt5lqd8py11GkSk7xteYnvH29zPc214JMG8oBzZ3CWXdMcV3k2vxn+onckKx0j6+OaVnuTq8Std39yrIP3G+2UkFiurjjWjhrNuX9jKDlN4X/fXjbYffE=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:36:21.4298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb1c4b9-d705-44a1-77f5-08d71cce90df
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB3034
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=834 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Down-speed auto-negotiation may not always be enabled, in which case the
PHY won't down-shift to 100 or 10 during auto-negotiation.

This change enables downshift and configures the number of retries to
default 4 (which is also in the datasheet

The downshift control mechanism can also be controlled via the phy-tunable
interface (ETHTOOL_PHY_DOWNSHIFT control).

The change has been adapted from the Aquantia PHY driver.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 86 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index e086e2d989e0..fb39104508ff 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -29,6 +29,17 @@
 #define   ADIN1300_NRG_PD_TX_EN			BIT(2)
 #define   ADIN1300_NRG_PD_STATUS		BIT(1)
 
+#define ADIN1300_PHY_CTRL2			0x0016
+#define   ADIN1300_DOWNSPEED_AN_100_EN		BIT(11)
+#define   ADIN1300_DOWNSPEED_AN_10_EN		BIT(10)
+#define   ADIN1300_GROUP_MDIO_EN		BIT(6)
+#define   ADIN1300_DOWNSPEEDS_EN	\
+	(ADIN1300_DOWNSPEED_AN_100_EN | ADIN1300_DOWNSPEED_AN_10_EN)
+
+#define ADIN1300_PHY_CTRL3			0x0017
+#define   ADIN1300_LINKING_EN			BIT(13)
+#define   ADIN1300_DOWNSPEED_RETRIES_MSK	GENMASK(12, 10)
+
 #define ADIN1300_INT_MASK_REG			0x0018
 #define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
 #define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
@@ -259,6 +270,73 @@ static int adin_config_rmii_mode(struct phy_device *phydev)
 			     ADIN1300_GE_RMII_CFG_REG, reg);
 }
 
+static int adin_get_downshift(struct phy_device *phydev, u8 *data)
+{
+	int val, cnt, enable;
+
+	val = phy_read(phydev, ADIN1300_PHY_CTRL2);
+	if (val < 0)
+		return val;
+
+	cnt = phy_read(phydev, ADIN1300_PHY_CTRL3);
+	if (cnt < 0)
+		return cnt;
+
+	enable = FIELD_GET(ADIN1300_DOWNSPEEDS_EN, val);
+	cnt = FIELD_GET(ADIN1300_DOWNSPEED_RETRIES_MSK, cnt);
+
+	*data = enable & cnt ? cnt : DOWNSHIFT_DEV_DISABLE;
+
+	return 0;
+}
+
+static int adin_set_downshift(struct phy_device *phydev, u8 cnt)
+{
+	u16 val;
+	int rc;
+
+	if (cnt == DOWNSHIFT_DEV_DISABLE)
+		return phy_clear_bits(phydev, ADIN1300_PHY_CTRL2,
+				      ADIN1300_DOWNSPEEDS_EN);
+
+	if (cnt > 8)
+		return -E2BIG;
+
+	val = FIELD_PREP(ADIN1300_DOWNSPEED_RETRIES_MSK, cnt);
+	val |= ADIN1300_LINKING_EN;
+
+	rc = phy_modify(phydev, ADIN1300_PHY_CTRL3,
+			ADIN1300_LINKING_EN | ADIN1300_DOWNSPEED_RETRIES_MSK,
+			val);
+	if (rc < 0)
+		return rc;
+
+	return phy_set_bits(phydev, ADIN1300_PHY_CTRL2,
+			    ADIN1300_DOWNSPEEDS_EN);
+}
+
+static int adin_get_tunable(struct phy_device *phydev,
+			    struct ethtool_tunable *tuna, void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return adin_get_downshift(phydev, data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int adin_set_tunable(struct phy_device *phydev,
+			    struct ethtool_tunable *tuna, const void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return adin_set_downshift(phydev, *(const u8 *)data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int adin_config_init_edpd(struct phy_device *phydev)
 {
 	struct adin_priv *priv = phydev->priv;
@@ -289,6 +367,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_set_downshift(phydev, 4);
+	if (rc < 0)
+		return rc;
+
 	rc = adin_config_init_edpd(phydev);
 	if (rc < 0)
 		return rc;
@@ -546,6 +628,8 @@ static struct phy_driver adin_driver[] = {
 		.probe		= adin_probe,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
+		.get_tunable	= adin_get_tunable,
+		.set_tunable	= adin_set_tunable,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
@@ -560,6 +644,8 @@ static struct phy_driver adin_driver[] = {
 		.probe		= adin_probe,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
+		.get_tunable	= adin_get_tunable,
+		.set_tunable	= adin_set_tunable,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
-- 
2.20.1

