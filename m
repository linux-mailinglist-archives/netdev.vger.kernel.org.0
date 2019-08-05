Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4BF81E46
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbfHENzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:55:22 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:45350 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728662AbfHENzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:22 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75DqoCR015406;
        Mon, 5 Aug 2019 09:55:12 -0400
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2050.outbound.protection.outlook.com [104.47.42.50])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u5448sdas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eaOAfe0aydCyPNl4a/oGmxrKfXJLyOiuLh864r0mDGgPOgrPIiscTP28GAJAgKpIKFejXr5IZaBtN0cyyczYPFucZZo7WZcIjNeq5NNCMsuZdSg6uxC/Tj8D6T2/F2727cjGV0Z682cPmVOE9fNrX+sXKfhfBMjLwUIcbVXJ/66sck1uXkTF7uJwzhETa/ufRO0eRfHioWStT1iXIhNrFDedmINF5bLiakFkNa+uA12X/fCxtdYr9C9aIPtAQvwF2qyyPRjyJ7EPpVXdHVQ78iUeCzfx1VSmh3UEPH2/A6BPyDUdnWYydBTf9MMtmILkzIf4rAJ/6W8pL7a/NoJ9KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tYzhIq47KzLaDL8gjaUuzT4Lnwho+jPLKxDTRkJszLw=;
 b=cAioFg/UgpZHw8/I2uzuhusluYF9x3VwnZ5ax5dQUnPtXEzJuCLctmIDOsOwmCgWoAe/pHlW4cHRTnnyiSFKE80u7XUv2sA1cgYJKmLLDtIHfILn6wGZtZVBINTZTzGROXRpsx0tE48fMmMeguhmh/oB+FGUpgeFy29H5lYxcXzRUtCmg/VEQhbhw1W4YXTVeSFWCAQ+C6RcRksGZh7RHv1wxz4ZXYLaA0qrAyEBRBDX8gff6wY9x/WfJNJOw77jLhr5Ue3iBy0m5vpCJkHi68EwGoVBqc+2tKy2Q0SVCljivAJ4E5i2uYoHpqFV9eysBViOer99xvZE85KJLu9IRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tYzhIq47KzLaDL8gjaUuzT4Lnwho+jPLKxDTRkJszLw=;
 b=24xHLl52esn2+0gNkVqRhOwkTXmu7YDsh9cfU9LJtW6WOuQjMJXq1qLKGeSQQdnLMAf4WN2jp8JXpzvKMmr9NvfnnOPa8Lk8kOhtfdy1FgedlWhQkBYfJ4lb1YP6hO7DH3SxQKbvi/qbPrkmkl/zs2HD5nVb83m82A6xQEkQV5E=
Received: from MWHPR03CA0016.namprd03.prod.outlook.com (2603:10b6:300:117::26)
 by BN6PR03MB2516.namprd03.prod.outlook.com (2603:10b6:404:1d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Mon, 5 Aug
 2019 13:55:08 +0000
Received: from CY1NAM02FT020.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::206) by MWHPR03CA0016.outlook.office365.com
 (2603:10b6:300:117::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.12 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:08 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT020.mail.protection.outlook.com (10.152.75.191) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:07 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75Dt4oQ016180
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:04 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:06 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 01/16] net: phy: adin: add support for Analog Devices PHYs
Date:   Mon, 5 Aug 2019 19:54:38 +0300
Message-ID: <20190805165453.3989-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(136003)(396003)(39860400002)(346002)(2980300002)(189003)(199004)(476003)(8676002)(2870700001)(50466002)(50226002)(48376002)(8936002)(1076003)(5660300002)(356004)(6666004)(107886003)(70206006)(186003)(26005)(110136005)(70586007)(316002)(106002)(6306002)(426003)(336012)(4326008)(44832011)(126002)(11346002)(2616005)(54906003)(86362001)(36756003)(966005)(2201001)(478600001)(486006)(446003)(51416003)(7696005)(76176011)(7636002)(47776003)(305945005)(246002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR03MB2516;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f776ffbe-d3b2-4a51-38c0-08d719ac86ed
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BN6PR03MB2516;
X-MS-TrafficTypeDiagnostic: BN6PR03MB2516:
X-MS-Exchange-PUrlCount: 3
X-Microsoft-Antispam-PRVS: <BN6PR03MB25162791C16EBA4C37D335A6F9DA0@BN6PR03MB2516.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: NoSg8vpHBEf1zNVW84Zvu8fASRKh5bE6hab6jOrIY0iawezaXutzqXHwXQbmzg2zX39qTNLqy1p7gEQh9js/vqLbulrXKMKyGbm9oQfL52Y9ZOo5LfiSdc8GbCAdkpOJh5yy8UA/7o6cpgyLwLAimw3b/YfLyUXpfbPex0Pzeb/pQn+U5OcSulwf4Sska9+POfelMQtb7Ji/1FYOHr65rRjhscpQAuXaQzTq7o7WeS98ffhRctf83i1dAJ1neo7LyWKL1hr90Vuy0zJ7Rt0yyXK0qgWSlslq+73ysSyP04P5KvesTsLulsHFW/lsqvmV5h+deam6XLGO74z4ERhpaTeyFJCMdgm7DOZiWodIyYKLTF0YRikCcmP3vzDuPRwqImpOYdbCKdmiwGbo+O2MioVKtHLJtKm+zJxTGaEH5Sk=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:07.9212
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f776ffbe-d3b2-4a51-38c0-08d719ac86ed
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB2516
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support for Analog Devices Industrial Ethernet PHYs.
Particularly the PHYs this driver adds support for:
 * ADIN1200 - Robust, Industrial, Low Power 10/100 Ethernet PHY
 * ADIN1300 - Robust, Industrial, Low Latency 10/100/1000 Gigabit
   Ethernet PHY

The 2 chips are pin & register compatible with one another. The main
difference being that ADIN1200 doesn't operate in gigabit mode.

The chips can be operated by the Generic PHY driver as well via the
standard IEEE PHY registers (0x0000 - 0x000F) which are supported by the
kernel as well. This assumes that configuration of the PHY has been done
required.

Configuration can also be done via registers, which will be implemented by
the driver in the next changes.

Datasheets:
  https://www.analog.com/media/en/technical-documentation/data-sheets/ADIN1300.pdf
  https://www.analog.com/media/en/technical-documentation/data-sheets/ADIN1200.pdf

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 MAINTAINERS              |  7 +++++
 drivers/net/phy/Kconfig  |  9 ++++++
 drivers/net/phy/Makefile |  1 +
 drivers/net/phy/adin.c   | 59 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 76 insertions(+)
 create mode 100644 drivers/net/phy/adin.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ee663e0e2f2e..faf5723610c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -938,6 +938,13 @@ S:	Supported
 F:	drivers/mux/adgs1408.c
 F:	Documentation/devicetree/bindings/mux/adi,adgs1408.txt
 
+ANALOG DEVICES INC ADIN DRIVER
+M:	Alexandru Ardelean <alexaundru.ardelean@analog.com>
+L:	netdev@vger.kernel.org
+W:	http://ez.analog.com/community/linux-device-drivers
+S:	Supported
+F:	drivers/net/phy/adin.c
+
 ANALOG DEVICES INC ADIS DRIVER LIBRARY
 M:	Alexandru Ardelean <alexandru.ardelean@analog.com>
 S:	Supported
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 206d8650ee7f..5966d3413676 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -257,6 +257,15 @@ config SFP
 	depends on HWMON || HWMON=n
 	select MDIO_I2C
 
+config ADIN_PHY
+	tristate "Analog Devices Industrial Ethernet PHYs"
+	help
+	  Adds support for the Analog Devices Industrial Ethernet PHYs.
+	  Currently supports the:
+	  - ADIN1200 - Robust,Industrial, Low Power 10/100 Ethernet PHY
+	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
+	    Ethernet PHY
+
 config AMD_PHY
 	tristate "AMD PHYs"
 	---help---
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index ba07c27e4208..a03437e091f3 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_SFP)		+= sfp.o
 sfp-obj-$(CONFIG_SFP)		+= sfp-bus.o
 obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
 
+obj-$(CONFIG_ADIN_PHY)		+= adin.o
 obj-$(CONFIG_AMD_PHY)		+= amd.o
 aquantia-objs			+= aquantia_main.o
 ifdef CONFIG_HWMON
diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
new file mode 100644
index 000000000000..6a610d4563c3
--- /dev/null
+++ b/drivers/net/phy/adin.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0+
+/**
+ *  Driver for Analog Devices Industrial Ethernet PHYs
+ *
+ * Copyright 2019 Analog Devices Inc.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mii.h>
+#include <linux/phy.h>
+
+#define PHY_ID_ADIN1200				0x0283bc20
+#define PHY_ID_ADIN1300				0x0283bc30
+
+static int adin_config_init(struct phy_device *phydev)
+{
+	int rc;
+
+	rc = genphy_config_init(phydev);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
+static struct phy_driver adin_driver[] = {
+	{
+		.phy_id		= PHY_ID_ADIN1200,
+		.name		= "ADIN1200",
+		.phy_id_mask	= 0xfffffff0,
+		.features	= PHY_BASIC_FEATURES,
+		.config_init	= adin_config_init,
+		.config_aneg	= genphy_config_aneg,
+		.read_status	= genphy_read_status,
+	},
+	{
+		.phy_id		= PHY_ID_ADIN1300,
+		.name		= "ADIN1300",
+		.phy_id_mask	= 0xfffffff0,
+		.features	= PHY_GBIT_FEATURES,
+		.config_init	= adin_config_init,
+		.config_aneg	= genphy_config_aneg,
+		.read_status	= genphy_read_status,
+	},
+};
+
+module_phy_driver(adin_driver);
+
+static struct mdio_device_id __maybe_unused adin_tbl[] = {
+	{ PHY_ID_ADIN1200, 0xfffffff0 },
+	{ PHY_ID_ADIN1300, 0xfffffff0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, adin_tbl);
+MODULE_DESCRIPTION("Analog Devices Industrial Ethernet PHY driver");
+MODULE_LICENSE("GPL");
-- 
2.20.1

