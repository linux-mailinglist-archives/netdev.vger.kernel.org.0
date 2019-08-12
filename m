Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758A889C88
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbfHLLYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:24:13 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:49730 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728189AbfHLLYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:12 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNWV1018760;
        Mon, 12 Aug 2019 07:24:01 -0400
Received: from nam05-co1-obe.outbound.protection.outlook.com (mail-co1nam05lp2052.outbound.protection.outlook.com [104.47.48.52])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u9qs7w659-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Atm8fNg0SZ1AOq2gdTePt5poyxuXknnF2QUrEpnYxvj7Wk7Jw2XS4twsbhMxHGzHTlv17fayfuGHN90T+wrg9Osqo6Wo2YDJ95eOAQUpke7pGUbx4Ta65dtcLoPh5iK+UX5q2NcgEmd5z2LwWrHMAmgeU2IXPihj8v5yyMQFVEisMqwv7pGcSZ9UQMi6DGiFfmb1EGtdID2P+s+djkjz3eqM1UjjOo5a0fjb2kXZZBkbsiggN6sdWn7a81ldxIj5ZSWfCmrelTGoQ1IT2U8bVrBBBzPtaO44ZIcLmCX7F+DA/mQpnQU6Lm4oRzoVnq6jY6Ge4OoO7o0n3zUMcyAVPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAs0o955rSPYSaIhoG2OVYy3gyQ15DpmhPxE5uH7VuI=;
 b=XXRKk5j9en4TjpDc89txpDSWsoyDqKsGfvRJTlGDp+dXSRcAL/F2Ihs61nYUPwbplKAh/nLTCuE6RFEuk9vdaXDSTthFZbHuzLbC6bIx32yEhaTpGPKpwvPIKJEMiw4TGGAtlscC0coPkWdEHre5dcycdXDjiiQVaN07u85wQXfeu829UiiMC0YZV4JtX6+tUY0oQj7FotKxXpTs6F8v3YCKtuWIfl15BvrhtGyV5xwyqy7S6z9XSrRiIBFc2I4NRm+ErMCtRx+Qxpx87aFAKshCmvO31KWeJKkiq28NzrAWjIzpXBgKrtMzmdWqutowDCJbXcwUWm3flHo05BlnfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jAs0o955rSPYSaIhoG2OVYy3gyQ15DpmhPxE5uH7VuI=;
 b=kmriQkDz5na1Gn54FYXEmFiJ4+QuAjgEkZfetNLwY8EjE+v0jMQmxS5mVcizPRe0HOeSbRsp3tjJPkkGZNm4eSWhPFMHvAzoq2AtXBfXuPqWV2f5ErgQUktabsRTGZLqYtt7ROIy8g5PhNy/O25Igi6Z/iN8liJpn3JuneitM00=
Received: from MWHPR03CA0005.namprd03.prod.outlook.com (2603:10b6:300:117::15)
 by DM6PR03MB3500.namprd03.prod.outlook.com (2603:10b6:5:ac::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Mon, 12 Aug
 2019 11:23:59 +0000
Received: from BL2NAM02FT057.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::209) by MWHPR03CA0005.outlook.office365.com
 (2603:10b6:300:117::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Mon, 12 Aug 2019 11:23:59 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT057.mail.protection.outlook.com (10.152.77.36) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:23:58 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBNwjH004150
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:23:58 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:23:58 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 01/14] net: phy: adin: add support for Analog Devices PHYs
Date:   Mon, 12 Aug 2019 14:23:37 +0300
Message-ID: <20190812112350.15242-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(376002)(39860400002)(2980300002)(199004)(189003)(2201001)(70586007)(966005)(1076003)(70206006)(86362001)(50226002)(5660300002)(6306002)(50466002)(8936002)(48376002)(8676002)(4326008)(246002)(126002)(476003)(446003)(336012)(426003)(486006)(44832011)(2616005)(11346002)(107886003)(2870700001)(478600001)(316002)(7636002)(54906003)(106002)(110136005)(2906002)(305945005)(26005)(47776003)(186003)(76176011)(51416003)(7696005)(6666004)(356004)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB3500;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36f80977-85aa-430f-3ac5-08d71f1791f2
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM6PR03MB3500;
X-MS-TrafficTypeDiagnostic: DM6PR03MB3500:
X-MS-Exchange-PUrlCount: 3
X-Microsoft-Antispam-PRVS: <DM6PR03MB3500C0CD8BDADFD34C3F59EFF9D30@DM6PR03MB3500.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: W2jScVC9JhNqcLiiyO3FLBQVWYf+UD5u4AF3UDvDGaof0gmzTZLNTTirU9o/y0l4XAEucJSQF/juRa81OAnmP2fWnHJNp1lyHjEJYphLUoW7Wop+AgprQ7XU1teQvfsX09DCSsmTVntv9PbXG7R3hzBr35tO9L1M0wfeju09vd1iIj6G63Ez+GMPXxyst4BnYFt3pT7M1UN9ITkV5B4lqbqn4s+j7CmeV4bMRM5iYCrEbmf0rgtR0Hgxs8B4dJ8n5/PDbJsEO7QTPkjJ84Y/jgFjhW/brKZLXXyJSX9stcFkZ+ngIlppBaOzNS0iFHSZKLe80DUdKRF4jwOzOO2vigeUNyrIwUVmIzNp4cqQeMTwWlQNmauFvqfnCSMiDEp8DvJz0SqGAYEr8HAsMYWWqPbCyKy8XfMFSl9yw75UgIw=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:23:58.8403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36f80977-85aa-430f-3ac5-08d71f1791f2
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3500
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

This change adds support for Analog Devices Industrial Ethernet PHYs.
Particularly the PHYs this driver adds support for:
 * ADIN1200 - Robust, Industrial, Low Power 10/100 Ethernet PHY
 * ADIN1300 - Robust, Industrial, Low Latency 10/100/1000 Gigabit
   Ethernet PHY

The 2 chips are register compatible with one another. The main difference
being that ADIN1200 doesn't operate in gigabit mode.

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

