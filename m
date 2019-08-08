Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD230861C9
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389684AbfHHMat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:30:49 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:45064 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728825AbfHHMat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:30:49 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CRm0q022426;
        Thu, 8 Aug 2019 08:30:38 -0400
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2057.outbound.protection.outlook.com [104.47.49.57])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u7xkj3gvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:30:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECDWJXXShblIFaqX2qEHXeEvpx7yBmv+vY11Q5jMYOKmiU3sWdynMRCA2cq8A01+LpbGhokHbALPIttthsGjG/95Gjsr8xRsda2QilgFO1s1QPrCKluKLVfD4Nmlk41Eh5bJR0sWsV2CUIKD0CXCMl7ahozL5/b1lzuwS+FA++1JpV3wthtFWH+Sf6STTC4peacsKLVP3LbikJnODKufiMTdw2YWzf5GG5rZfvDLRbbK2SpbblPtOwOn+uci66ukJElCGMCOyw+K6f8+KT5kUQefMBHL3gZ+2BhUlsKEk8KafQyv0Qt1fWi6mPxhD95yVqL8WfeeUPnnk6jymFQnGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HG1vGVMds4pKsnKaroZN0iMGz+tIIs+xl/fUtEsEAa0=;
 b=nPwAHxhuokgI/yTB8Ii+G+2wu9DSgLXuDDFq9BEbWEgObVkbbGG9w3qCqkSq6WhfAN1BknJRnk7jYvylcbUR2bFxoE+YCVPVqWQJ+SfNPgCIL6U1BH3mYo01YdU9V3X5D0hMgk4nHLbVaqD2mwsg/5APRsUn+g6E5+x82mmoLC4GR8WUO8gjau3yDKTruQ5VMTBL/3YZwo7TEexw2QKWrGOMdHnaZHj3pn0ym8EeGf0LwnopGFzY9Chcap/fnAQazUiQrVf6mgYDeKKVbLo2MdHpoipwNazCw2pEpLWb5H6eo+LnVamMqRKa+S9x0grgydJKznqF5jNsNzqZwox5OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HG1vGVMds4pKsnKaroZN0iMGz+tIIs+xl/fUtEsEAa0=;
 b=QaEasZzo4P7STLQ6Bu+hL/kpBtgd6np1TDHp8LjcTBYyQxl9j0Sfuo2+WJoHhbVgyhkV41CAmtKc07luSf/qvoT5WXe37uoWzTeVt1/3sqN7LzpdFRr4GDqYqwUr5zCvhhgpyeV/o4XN+XX7Kv7VbjUnvfC9oMkZwol9FaNAF/c=
Received: from MWHPR03CA0026.namprd03.prod.outlook.com (2603:10b6:301:3b::15)
 by BN6PR03MB3140.namprd03.prod.outlook.com (2603:10b6:405:47::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14; Thu, 8 Aug
 2019 12:30:35 +0000
Received: from CY1NAM02FT034.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::208) by MWHPR03CA0026.outlook.office365.com
 (2603:10b6:301:3b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.15 via Frontend
 Transport; Thu, 8 Aug 2019 12:30:35 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT034.mail.protection.outlook.com (10.152.75.190) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:30:34 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CUXBq021106
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:30:33 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:30:33 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 01/15] net: phy: adin: add support for Analog Devices PHYs
Date:   Thu, 8 Aug 2019 15:30:12 +0300
Message-ID: <20190808123026.17382-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(376002)(39860400002)(346002)(396003)(2980300002)(189003)(199004)(76176011)(356004)(50226002)(6666004)(7636002)(48376002)(478600001)(305945005)(966005)(316002)(2201001)(106002)(54906003)(110136005)(246002)(7696005)(51416003)(5660300002)(8936002)(8676002)(70206006)(86362001)(70586007)(336012)(446003)(4326008)(426003)(47776003)(6306002)(107886003)(126002)(486006)(2870700001)(11346002)(476003)(36756003)(2906002)(2616005)(50466002)(44832011)(1076003)(186003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR03MB3140;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79f022de-0cf0-4cb1-6938-08d71bfc3613
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BN6PR03MB3140;
X-MS-TrafficTypeDiagnostic: BN6PR03MB3140:
X-MS-Exchange-PUrlCount: 3
X-Microsoft-Antispam-PRVS: <BN6PR03MB31403A1C1AFA799D31434736F9D70@BN6PR03MB3140.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: fppj4IGllTd8ZZgZRYXQOhe3xAf/5VhuFmk1aeBvqZMM5mnwO1X3BgdjXKKbvkyKQhBISXSO0cMv3Q6gmcgjsRBzDmSyz6XElbcKUXZfgqz8Y09MTu4/y6ocnRJD0VShrNQeMy37C8+J32n5WIKTlXmCP7FJRA8kq9hBCEea8+iCq7CESsY7NlKcYOQ0JsQt9QU3sXQSfOfvB0/xd0CntqiIADf/A27cEzDmJfp/OWgy/8XHqk6E6r/aBamJj5DHHIyLn10cY1+fHFVh03DxJKecIuNP89hpFWYy3OZCsVJdE9fxaLG43az1hQD10N+gjywR5PNr/1CGpwJF98sA8A+w74bYHNo5cTFZu5z2GhFFAvd0bs6Rgjo5Hqb03Xub6fV/Jh0tMxTdb9K8v0TvCvAzaFvwUFfZ4cIUFvMvgGo=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:30:34.3510
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f022de-0cf0-4cb1-6938-08d71bfc3613
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB3140
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
completely in HW, according to spec.

Configuration can also be done via registers, which will be supported by
this driver.

Datasheets:
  https://www.analog.com/media/en/technical-documentation/data-sheets/ADIN1300.pdf
  https://www.analog.com/media/en/technical-documentation/data-sheets/ADIN1200.pdf

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 MAINTAINERS              |  7 ++++++
 drivers/net/phy/Kconfig  |  9 ++++++++
 drivers/net/phy/Makefile |  1 +
 drivers/net/phy/adin.c   | 49 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 66 insertions(+)
 create mode 100644 drivers/net/phy/adin.c

diff --git a/MAINTAINERS b/MAINTAINERS
index e352550a6895..e8aa8a667864 100644
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
index 48ca213c0ada..03be30cde552 100644
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
index 000000000000..6d7af4743957
--- /dev/null
+++ b/drivers/net/phy/adin.c
@@ -0,0 +1,49 @@
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
+	return genphy_config_init(phydev);
+}
+
+static struct phy_driver adin_driver[] = {
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
+		.name		= "ADIN1200",
+		.config_init	= adin_config_init,
+		.config_aneg	= genphy_config_aneg,
+		.read_status	= genphy_read_status,
+	},
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
+		.name		= "ADIN1300",
+		.config_init	= adin_config_init,
+		.config_aneg	= genphy_config_aneg,
+		.read_status	= genphy_read_status,
+	},
+};
+
+module_phy_driver(adin_driver);
+
+static struct mdio_device_id __maybe_unused adin_tbl[] = {
+	{ PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, adin_tbl);
+MODULE_DESCRIPTION("Analog Devices Industrial Ethernet PHY driver");
+MODULE_LICENSE("GPL");
-- 
2.20.1

