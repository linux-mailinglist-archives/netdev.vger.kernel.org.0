Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E6489CA0
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbfHLLYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:24:53 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:60058 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728302AbfHLLYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:31 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNORQ018336;
        Mon, 12 Aug 2019 07:24:25 -0400
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2059.outbound.protection.outlook.com [104.47.40.59])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u9qs7w66a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7hKdoIfT0D9bYa+3O36khdvyw7H5E1DKPuKG1IAPz1tTYkFCgHa0Zx7DL1Bf2af+sB2jz71/C63Onx5e8XwIUYsiZO74Oo+PbrYtT6cxn1pHbff0Xgq1ynIsDrkxmOBnn+oCQZys9n7S+ET8AVsJTJTzlQMq/WSCJ+pLA3X6uBful1FPViIrFVOrUas/LGqRkbEUboeKc9HM3ctNADS/9AvvbzxLjAiWXKtkEDXL0Ett2xcQTDqz6rlhe5E9NBArWilOEvwVPBFUQ68iiIw5ZD9zySsvxvJULtnhTdAsQEUi4ToHmq2rx9tmZbG28g/kzhpIql0laRrB265aB0OIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22AmPCW69ZtjUcEXxfRRASfjGWwUxtDfRfcuwD/WHRs=;
 b=TkdwPwzyPuJvanFgwXiMYqX01OYFIBdEQJ1erDSuW2AlZgljeVsmMZ3PdnVJZPFdocKPj2ZaGzi9t0DcHN801ADXkUzb8FaRCM5T8KCK/0yqWzZK+e2cYR+0F0vy9gBAMndbjusVc1AEv9AeYMruTJa8aVlb5XkpuDuev2iMU2fmudbHQfVHjsKLISb6BoTdEFA3Pe6rwclCZVhwqrSNYFsMEorV5jkrFL42OnXlwStqlLo1NTj7HowiGPddmFhzTU6kmij5NpfG93A9vq2IHXY/r1NXJ4XKcs1C588CEF6tgkGdKKJhITFWOxAkHgH6OpLY3V++YF8tVQzboNA0Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22AmPCW69ZtjUcEXxfRRASfjGWwUxtDfRfcuwD/WHRs=;
 b=VULJv5wDLQVPApxZI6fHCXC13anub4fFBXR3xHjRZ8sMQJLRZj7sigLi1xhy4RQrczzU4e26bAyWAbYtYAZwYCMjmW3LHY9SsubrPi09Td7s/U6yCiqTAs3XkPBIjRyNzeXTByx+pnj8aNQvWYvJUCv67GNBHVuwW4IbYHSk8Aw=
Received: from BN6PR03CA0069.namprd03.prod.outlook.com (2603:10b6:404:4c::31)
 by SN2PR03MB2415.namprd03.prod.outlook.com (2603:10b6:804:9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.20; Mon, 12 Aug
 2019 11:24:22 +0000
Received: from CY1NAM02FT039.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::204) by BN6PR03CA0069.outlook.office365.com
 (2603:10b6:404:4c::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.13 via Frontend
 Transport; Mon, 12 Aug 2019 11:24:22 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT039.mail.protection.outlook.com (10.152.75.140) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:24:21 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBOLir004264
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:24:21 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:24:20 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 12/14] net: phy: adin: implement downshift configuration via phy-tunable
Date:   Mon, 12 Aug 2019 14:23:48 +0300
Message-ID: <20190812112350.15242-13-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(136003)(376002)(2980300002)(189003)(199004)(50466002)(76176011)(2870700001)(4326008)(26005)(2906002)(186003)(86362001)(70206006)(70586007)(47776003)(478600001)(48376002)(2201001)(107886003)(5660300002)(44832011)(356004)(486006)(246002)(36756003)(6666004)(50226002)(8936002)(1076003)(336012)(305945005)(8676002)(426003)(110136005)(316002)(7696005)(51416003)(54906003)(11346002)(106002)(446003)(7636002)(476003)(2616005)(126002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR03MB2415;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f17b838a-94fb-4f58-feaf-08d71f179fdf
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:SN2PR03MB2415;
X-MS-TrafficTypeDiagnostic: SN2PR03MB2415:
X-Microsoft-Antispam-PRVS: <SN2PR03MB2415B84D2E09EEBB3B1433E3F9D30@SN2PR03MB2415.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ial0t8gwZR4EixppbIdyZKxhC3ExJifHEyuJHTTXB95ghwxElrMhD19lTzxK1ysuqDV8fKbUbWrrh6Dg0IoHQYHhWx1T+BOxn8wtEsm+ZRYheGzem2+NCxe0Q/f0hZIh69eu3MvnlJTZZd6eaY/DQfKzroB4VcE4VTWCMsIcBxYhgMZ6NomLviIdSNJAZYtUB/nWD1gRN971QQgkcl3DFAdWmhCyL9QeA0V3guoOa1UXq1MB+hetWgQZmwV80e6cm3gunWxl50T5NHxGrHtJX+5EBOOZx+i6gCluYZH3FO6rNhHoPglEWgTCo7WEqiTa9BE6Qn6NbEE8PoSAU8DaDyoDTZjyS3GZX6boHASy7ym5nd0Nlj0XjaFSUZ0sZe3TP7M3qAu78/ozdNdsc/N8JD6FY2jIqtvRYeMFj+u8R78=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:24:21.7816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f17b838a-94fb-4f58-feaf-08d71f179fdf
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR03MB2415
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=821 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120128
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
index 131a72567f25..e4afa8c2bec7 100644
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
@@ -257,6 +268,73 @@ static int adin_config_rmii_mode(struct phy_device *phydev)
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
@@ -287,6 +365,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_set_downshift(phydev, 4);
+	if (rc < 0)
+		return rc;
+
 	rc = adin_config_init_edpd(phydev);
 	if (rc < 0)
 		return rc;
@@ -532,6 +614,8 @@ static struct phy_driver adin_driver[] = {
 		.probe		= adin_probe,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
+		.get_tunable	= adin_get_tunable,
+		.set_tunable	= adin_set_tunable,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
@@ -546,6 +630,8 @@ static struct phy_driver adin_driver[] = {
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

