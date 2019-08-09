Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0303B87B4E
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406273AbfHINgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:36:12 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:54962 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726216AbfHINgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:11 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DMxBt026381;
        Fri, 9 Aug 2019 09:36:03 -0400
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2053.outbound.protection.outlook.com [104.47.40.53])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfqjx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHoUtunsBJCs73u6dDee277cQtSV1mubZ1Y5zfquL6txwvadnC52zAYBX+da0piF0YLU2/0qKwrET7DkGSsw5GA/ufhhhpys9fGWj8wm24S5F/n5SmlSVaeWwa7T+J/gDDXbnMbKvnvvMZrMX4ysnc+EPUjFWbWsOE+f3iRETL7QY8t0/VKmdMpkQtX+1FBtYk134AQIp61sIFs+jMAnqyhoafs0ZRUOIoy++Nx+QnPKguftiOLKMGeERY2tkOrK2Xgmi7ZNUNrBOpZRoUC3otNLIomNaGEwS/qdqOIrNgsTzx4o5bYcbWVM1bVPfDY0zTIdenC4XKbCilxuiltIww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lul93YqqFHJPWEMN4aPK78z4EeAyrHeSp0PQXlgQMKk=;
 b=CAMkcUxHLN2u1JAPX5voxXQCc+H/Y8J4lcN/e/GMspUhRxTjW6sNDIPFINGtONfBNfszlERIkOaRAGepeDCM0hW4M57mc3Jk5uR8FiE5UGh5WVASUC+ghUpYLYZGgX/A9H5SC0IJjlq/dT1s03dwZJVaSnUv5uYY0tTSCvun0SV73Vwqdz7ZrKRrvfi7ThCjg9hWZDI7cq1HZeG5fslAzW0BjJd/zm0jDcBemorvfHEYBhf4pVFPmBrse3SqgWOohbiUoM3ZhNYJpz5DYjYY90AixJQnZNbLszVDvNUir9WfYxhpvO++lp6TPLHO9nBCmgfB9seGlpmjSt9nA9MT5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lul93YqqFHJPWEMN4aPK78z4EeAyrHeSp0PQXlgQMKk=;
 b=taYTWreZ2ZsmCNMy4KXXZKHb3j/LSatIuutaayuU+78ImUT3sfgzqXRVA6b/0GmFqaSdERtMGcfTRpKHGT1CDYHFGhA/nZrp8kpwb3CKQ8vQRVHFbS0lyR7NgHSZlj3nEwJ/LJp1VIwTufIpNklM0YFR6AamM9ZHqukAN3S/X9I=
Received: from BN8PR03CA0030.namprd03.prod.outlook.com (2603:10b6:408:94::43)
 by BY5PR03MB5155.namprd03.prod.outlook.com (2603:10b6:a03:218::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14; Fri, 9 Aug
 2019 13:36:00 +0000
Received: from CY1NAM02FT026.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::204) by BN8PR03CA0030.outlook.office365.com
 (2603:10b6:408:94::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.18 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:00 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT026.mail.protection.outlook.com (10.152.75.157) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:35:59 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79DZw3h025628
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:35:58 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:35:58 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 01/14] net: phy: adin: add support for Analog Devices PHYs
Date:   Fri, 9 Aug 2019 16:35:39 +0300
Message-ID: <20190809133552.21597-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(39860400002)(346002)(136003)(376002)(2980300002)(199004)(189003)(2870700001)(50226002)(36756003)(2906002)(8936002)(2616005)(476003)(126002)(486006)(446003)(44832011)(11346002)(426003)(356004)(107886003)(6666004)(47776003)(4326008)(110136005)(54906003)(106002)(2201001)(316002)(6306002)(8676002)(26005)(246002)(76176011)(186003)(966005)(48376002)(305945005)(7636002)(86362001)(336012)(5660300002)(70206006)(70586007)(7696005)(51416003)(50466002)(1076003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR03MB5155;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5a3759a-7d8a-48f3-0daf-08d71cce83f9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BY5PR03MB5155;
X-MS-TrafficTypeDiagnostic: BY5PR03MB5155:
X-MS-Exchange-PUrlCount: 3
X-Microsoft-Antispam-PRVS: <BY5PR03MB51558CBFD868271627634C76F9D60@BY5PR03MB5155.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: RflCIc3MWGSWkb7tAu5wAqALV6LBloF3WmrXL2aCoqf2ZrsRO89Ior+QFIcrEupq14rJUHLXuVerr3BpRAgoIYyB09Z0b1yy9B5UTVjw6cvVsRhiWY0ZXUBDqa/5ju7oOi7YUrn2Exqeoz4Y65kvYz6h1+4BTCfobCmgiA7ulJxa538oj1zJVRmBMxe1BD5aWkL+oOZj/c64AY/D3PtjzyhapjR36fCu6MHWKvwxRKVePOKGkBxi86dsCwLDrtLdMSBlEoeW5S1XUpT5Kle1pefiSQvK0ru3Qu0NLsp8jnlVO4kw9HbSYc91cbEWReX4qn1hIsOXA2VCC7/ut4Wt4ighu9diYlIRkbhavBk8ngskFyJByX07petzzEbi2t3N9dbu8T9+pjc/3mv7vv9qZ4RQTWZxCFbS5Z5chW0PeBo=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:35:59.3938
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a3759a-7d8a-48f3-0daf-08d71cce83f9
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5155
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

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

