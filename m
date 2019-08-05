Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB31581E2A
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbfHEN4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:56:00 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:4958 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729930AbfHENzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:47 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75Dr6dN016024;
        Mon, 5 Aug 2019 09:55:32 -0400
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2054.outbound.protection.outlook.com [104.47.44.54])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u5448sdbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2NxV6cKp/CpuC9hh6wUSUP+THk3lEiXCUZEdpF3A5YiOkn6KdOO0XKIkelcOnI4ILQdAOMCJ4ikPFeOwZCteoxP1aLdCDvP6o0s3SQus2Wz8wI0DlXOpzzPQWHndUYOWECqnXFUR2I82Z6YtSIPzR+3GCsWkNdzyJ9E5EkoTHs5MxJdIYf/qUnRVGNTvOEaNO5hDLxSWrbbpzc9odCfk2/UCqyGqApFwKyloWN74DOKhbMtYusnoKSSurIJgmGHFSxEGl5onsAEqIZ1Cs4HpU+Ntz94abz9xVqZIQMWILKD9EQ9mqhP76ZbP63agNfw/afZ6whHFQHZGoWOafkBpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cv1A4RjPo1u4YNCnk4egqPxjPp4CETOVX/P4JquR1Fw=;
 b=EJXuIYvP+lbE65fT3sHKt0vlCalsMpbIG51xRVoouqidimOMi9zUMU9JBjXiR1a6JA71GME2WPRdVcq2lFvGdacGwrnNFCjKmfLN7/PcPUTsVdeFRKkF52z4ElradQnUdVQT6QMklQYjFLeRFifhe5KtnhHgNHokjAWQLn3TMZ6U1n86/tH0ealkYQM1i4wzLJXJedJCA1tnaegI676C9jxV/4QhAe2li44CqUiS6aDnUuDoVcRXooBYUThxKl31yxzq9bZflsRHKzfTBM9cey34utT9JoQ7RrZOuD/LikuzZE0uFqy2P8Er4YjPotfz+oOklrlCxxs8FHwJOLySGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cv1A4RjPo1u4YNCnk4egqPxjPp4CETOVX/P4JquR1Fw=;
 b=JWw+rYI4FDEyCLkvCbrwKp/8strA2/tDU9SSGXX/FkHQ6agcFkDixpejLovs6E06YlI/hwtO5i5DIrCi8PGr2m9E84/UXwUixlpU/Ao9hXmr2OOQ/nMKQFpnE6V6cR57nQAELZh2f6/Qet7t6iMiCA+Hd0NdiqQxyDw+plbiNp4=
Received: from BN6PR03CA0076.namprd03.prod.outlook.com (2603:10b6:405:6f::14)
 by SN6PR03MB4014.namprd03.prod.outlook.com (2603:10b6:805:c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.14; Mon, 5 Aug
 2019 13:55:29 +0000
Received: from BL2NAM02FT021.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::203) by BN6PR03CA0076.outlook.office365.com
 (2603:10b6:405:6f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.17 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:29 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT021.mail.protection.outlook.com (10.152.77.158) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:29 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75DtQxj016232
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:26 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:28 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 11/16] net: phy: adin: PHY reset mechanisms
Date:   Mon, 5 Aug 2019 19:54:48 +0300
Message-ID: <20190805165453.3989-12-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(346002)(136003)(396003)(376002)(2980300002)(199004)(189003)(336012)(6666004)(4326008)(50226002)(51416003)(7696005)(426003)(107886003)(44832011)(26005)(70206006)(70586007)(2906002)(86362001)(446003)(316002)(47776003)(486006)(14444005)(126002)(476003)(186003)(2616005)(246002)(11346002)(2201001)(356004)(7636002)(48376002)(2870700001)(36756003)(106002)(50466002)(5660300002)(1076003)(110136005)(478600001)(54906003)(76176011)(305945005)(8936002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR03MB4014;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68137548-9f4b-41e9-c47e-08d719ac9340
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:SN6PR03MB4014;
X-MS-TrafficTypeDiagnostic: SN6PR03MB4014:
X-Microsoft-Antispam-PRVS: <SN6PR03MB40148AEF049F3504AA6581BCF9DA0@SN6PR03MB4014.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ZB/InwBgWTokm58Us0wOwW7pLQLUwUc/P6HwDgbioP20tWYWfUvZvw+XbPd4KEpjg+mT/LhYEzpC1RzXqYk3o4RHwAOFXg51+t0NPXBSw6jZ5NGU63r8MbiAF4ah4xC2xISlayuXVMkMTD77kzv2YXep7cKGm2RUQng0UlVzEl0X0tIsh+syWRiD0g7QpzCgGdnjXKk6Y2hNsLDzsnzZD9r+7gb4jB9eq1qC5NDcgf4zxK3uFd3iednTG/lwteT9BNlE5IW8bmVXpZxX5sozwkuqX+xgK4qf8n9cK5/o9Z60z5LXDz29gjsLSqywqUJlgjLVayYPEQA9PDbZacdkw0hx0bgr3FRvX2PHKmmEojpynIilvkFgzDxxTP8LU7SoLNuWKnOSaxov6aCntnXsf15bORxpcVewGKXFri220EU=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:29.0698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68137548-9f4b-41e9-c47e-08d719ac9340
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB4014
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=647 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN PHYs supports 4 types of reset:
1. The standard PHY reset via BMCR_RESET bit in MII_BMCR reg
2. Reset via GPIO
3. Reset via reg GeSftRst (0xff0c) & reload previous pin configs
4. Reset via reg GeSftRst (0xff0c) & request new pin configs

Resets 2 & 4 are almost identical, with the exception that the crystal
oscillator is available during reset for 2.

Resetting via GeSftRst or via GPIO is useful when doing a warm reboot. If
doing various settings via phytool or ethtool, the sub-system registers
don't reset just via BMCR_RESET.

This change implements resetting the entire PHY subsystem during probe.
During PHY HW init (phy_hw_init() logic) the PHY core regs will be reset
again via BMCR_RESET. This will also need to happen during a PM resume.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 82 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 3c559a3ba487..476a81ce9341 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -6,12 +6,14 @@
  */
 #include <linux/kernel.h>
 #include <linux/bitfield.h>
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mii.h>
 #include <linux/phy.h>
 #include <linux/property.h>
+#include <linux/gpio/consumer.h>
 
 #include <dt-bindings/net/adin.h>
 
@@ -55,6 +57,9 @@
 #define ADIN1300_CLOCK_STOP_REG			0x9400
 #define ADIN1300_LPI_WAKE_ERR_CNT_REG		0xa000
 
+#define ADIN1300_GE_SOFT_RESET_REG		0xff0c
+#define   ADIN1300_GE_SOFT_RESET		BIT(0)
+
 #define ADIN1300_GE_RGMII_CFG_REG		0xff23
 #define   ADIN1300_GE_RGMII_RX_MSK		GENMASK(8, 6)
 #define   ADIN1300_GE_RGMII_RX_SEL(x)		\
@@ -86,6 +91,14 @@ static struct clause22_mmd_map clause22_mmd_map[] = {
 	{ MDIO_MMD_PCS, MDIO_PCS_EEE_WK_ERR,	ADIN1300_LPI_WAKE_ERR_CNT_REG },
 };
 
+/**
+ * struct adin_priv - ADIN PHY driver private data
+ * gpiod_reset		optional reset GPIO, to be used in soft_reset() cb
+ */
+struct adin_priv {
+	struct gpio_desc	*gpiod_reset;
+};
+
 static int adin_get_phy_internal_mode(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -429,6 +442,73 @@ static int adin_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
+static int adin_subsytem_soft_reset(struct phy_device *phydev)
+{
+	int reg, rc, i;
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_SOFT_RESET_REG);
+	if (reg < 0)
+		return reg;
+
+	reg |= ADIN1300_GE_SOFT_RESET;
+	rc = phy_write_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_SOFT_RESET_REG,
+			   reg);
+	if (rc < 0)
+		return rc;
+
+	for (i = 0; i < 20; i++) {
+		usleep_range(500, 1000);
+		reg = phy_read_mmd(phydev, MDIO_MMD_VEND1,
+				   ADIN1300_GE_SOFT_RESET_REG);
+		if (reg < 0 || (reg & ADIN1300_GE_SOFT_RESET))
+			continue;
+		return 0;
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int adin_reset(struct phy_device *phydev)
+{
+	struct adin_priv *priv = phydev->priv;
+	int ret;
+
+	if (priv->gpiod_reset) {
+		/* GPIO reset requires min 10 uS low,
+		 * 5 msecs max before we know that the interface is up again
+		 */
+		gpiod_set_value(priv->gpiod_reset, 0);
+		usleep_range(10, 15);
+		gpiod_set_value(priv->gpiod_reset, 1);
+		mdelay(5);
+
+		return 0;
+	}
+
+	/* Reset PHY core regs & subsystem regs */
+	return adin_subsytem_soft_reset(phydev);
+}
+
+static int adin_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct gpio_desc *gpiod_reset;
+	struct adin_priv *priv;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	gpiod_reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
+	if (IS_ERR(gpiod_reset))
+		gpiod_reset = NULL;
+
+	priv->gpiod_reset = gpiod_reset;
+	phydev->priv = priv;
+
+	return adin_reset(phydev);
+}
+
 static struct phy_driver adin_driver[] = {
 	{
 		.phy_id		= PHY_ID_ADIN1200,
@@ -437,6 +517,7 @@ static struct phy_driver adin_driver[] = {
 		.features	= PHY_BASIC_FEATURES,
 		.flags		= PHY_HAS_INTERRUPT,
 		.config_init	= adin_config_init,
+		.probe		= adin_probe,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
 		.ack_interrupt	= adin_phy_ack_intr,
@@ -453,6 +534,7 @@ static struct phy_driver adin_driver[] = {
 		.features	= PHY_GBIT_FEATURES,
 		.flags		= PHY_HAS_INTERRUPT,
 		.config_init	= adin_config_init,
+		.probe		= adin_probe,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
 		.ack_interrupt	= adin_phy_ack_intr,
-- 
2.20.1

