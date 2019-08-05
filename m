Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824F381E2F
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbfHENzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:55:39 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:16086 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729720AbfHENzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:39 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75Dr6eE015931;
        Mon, 5 Aug 2019 09:55:24 -0400
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2053.outbound.protection.outlook.com [104.47.46.53])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6kb20e1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZZNabxH1YZrJmK5Od99rvWroOvb/VE+pL3NO9bBDZoHwXxZ58U9pZTYDLv370z6kep+/ohhJIxeblanCG8WZ1LAkBCRqpTtXT9M1FZOAIXRELtSnfxNqMCeDuRwvvhJ5XT7IllYeK3C6I07dm60QEJE3VUTgvOg3kobEF8vL01aqHzzcUQaYYkwh+vy0cZPXozqYJf9uUK9fRLA378XZLQKDM6w/nOLcRK7xgCXUPrOB6QB3SyYhtzkkyxD4KjxYi2bPfSLJtFzlOw3/GJVNL/d5rsnGpMnEfCBIZoxFUZFiBPUag2Rtn5if5conV8X2C+Viz25rOh4z/bFAVirqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bTXW9FbWsrk053yU3mRr/jjxL5i/KX0fA2tAKONyAU=;
 b=X7fDt/E2BlgrEwUzCmvKHosNubPnHTLlYqsAvR3xPkOx10pUmxJPuF/YPPnEClDZiQR2tHzO52UEe8xo21xHakfeEVWd26c/Y6nLkEUB/j3Nak3Bn5wtPLAmXbJaUypVb/9Svnchy9hHcqyQncJ9di/l+imWu0aGHKfreQe0kheFWnc3Vx6DIX6Fhq8U0+AOnkYaeLtEHqmm0Vf0u03U37tTVy3OTgciOtV+wIzAXCZD4lSaqpexT0oLEDKJir9tHkWN28i/CyoKhdN4K9fS1GuaGiRHwGYOpcT0QXwMkZ77KJZsg9Wq1ofcizXOy85rCPruh+831XyVBBPDczudCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bTXW9FbWsrk053yU3mRr/jjxL5i/KX0fA2tAKONyAU=;
 b=qlDE8qK6FEjsIAwLG0+t3sU0RLc6Q2lKzZ8WI3cYbVemUYMCv5yAztp8SNAuK7rmXORZxQchrKKLhTdMWsU+XMONmuLpAZaGYCMrz94m9cGzA/W7Bb7qvaMlUiqdkJnsqyalBzfKF5APGNyO9tS+5qN6VRpG39TNMjhy9AlQB54=
Received: from BN8PR03CA0022.namprd03.prod.outlook.com (2603:10b6:408:94::35)
 by CY4PR03MB2887.namprd03.prod.outlook.com (2603:10b6:903:132::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Mon, 5 Aug
 2019 13:55:21 +0000
Received: from BL2NAM02FT009.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::209) by BN8PR03CA0022.outlook.office365.com
 (2603:10b6:408:94::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:21 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT009.mail.protection.outlook.com (10.152.77.68) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:20 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75DtHQQ016208
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:17 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:20 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 07/16] net: phy: adin: make RGMII internal delays configurable
Date:   Mon, 5 Aug 2019 19:54:44 +0300
Message-ID: <20190805165453.3989-8-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(396003)(346002)(2980300002)(199004)(189003)(2906002)(316002)(76176011)(1076003)(2201001)(126002)(4326008)(47776003)(36756003)(11346002)(51416003)(426003)(486006)(336012)(246002)(26005)(2616005)(7696005)(476003)(44832011)(50466002)(446003)(186003)(6666004)(48376002)(50226002)(70586007)(8936002)(70206006)(54906003)(8676002)(107886003)(478600001)(86362001)(356004)(5660300002)(2870700001)(106002)(7636002)(110136005)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR03MB2887;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d816bca-a0c4-4da5-c325-08d719ac8e62
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:CY4PR03MB2887;
X-MS-TrafficTypeDiagnostic: CY4PR03MB2887:
X-Microsoft-Antispam-PRVS: <CY4PR03MB288740E45C29E176A541ADF7F9DA0@CY4PR03MB2887.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: i6T3Mdxl/uTvN+JHItFwBB4CWO9MMjQluXTIL4JJ+QG8st4ooTMFz6XIx2oBXHs8YPMB77SfLL5e71Hx4cBvnAL2sQIxLjVQ+VcuOP2pqAH/NovfGmPB9pm6L+c5c0/3OKD8MPZkhxgklizHaNlEbJf+pPn/ym5mSlsPIXJZUw16A/c46vwL1If3XpsJcvBf/RMnUpCbY5isOU91/XBU6ooAmNub3We2dJ9yb3Sni217fJYTsdrr4WPtYnwBoZTX4+BFfP//0NaDnnmI4wzMVjkfl9rQsAT7j9bYFBpYp7nVlLZGwy9CLT0LDm5pbALZ2x3s5aTYbDu3z7Fxg5dnsguU5bHYvoVLTQu3LbgDFofLmNwYnqOiuTIe/Z1v6TnmmFC1WoDqzkoKvu2uYXxi4xUPgbofMUjvSYnemj24jxo=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:20.9110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d816bca-a0c4-4da5-c325-08d719ac8e62
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR03MB2887
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

The internal delays for the RGMII are configurable for both RX & TX. This
change adds support for configuring them via device-tree (or ACPI).

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index e3d2ff8cc09c..cb96d47d457e 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -5,6 +5,7 @@
  * Copyright 2019 Analog Devices Inc.
  */
 #include <linux/kernel.h>
+#include <linux/bitfield.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -12,6 +13,8 @@
 #include <linux/phy.h>
 #include <linux/property.h>
 
+#include <dt-bindings/net/adin.h>
+
 #define PHY_ID_ADIN1200				0x0283bc20
 #define PHY_ID_ADIN1300				0x0283bc30
 
@@ -35,6 +38,12 @@
 #define ADIN1300_INT_STATUS_REG			0x0019
 
 #define ADIN1300_GE_RGMII_CFG_REG		0xff23
+#define   ADIN1300_GE_RGMII_RX_MSK		GENMASK(8, 6)
+#define   ADIN1300_GE_RGMII_RX_SEL(x)		\
+		FIELD_PREP(ADIN1300_GE_RGMII_RX_MSK, x)
+#define   ADIN1300_GE_RGMII_GTX_MSK		GENMASK(5, 3)
+#define   ADIN1300_GE_RGMII_GTX_SEL(x)		\
+		FIELD_PREP(ADIN1300_GE_RGMII_GTX_MSK, x)
 #define   ADIN1300_GE_RGMII_RXID_EN		BIT(2)
 #define   ADIN1300_GE_RGMII_TXID_EN		BIT(1)
 #define   ADIN1300_GE_RGMII_EN			BIT(0)
@@ -67,6 +76,32 @@ static int adin_get_phy_internal_mode(struct phy_device *phydev)
 	return -EINVAL;
 }
 
+static void adin_config_rgmii_rx_internal_delay(struct phy_device *phydev,
+						int *reg)
+{
+	struct device *dev = &phydev->mdio.dev;
+	u32 val;
+
+	if (device_property_read_u32(dev, "adi,rx-internal-delay", &val))
+		val = ADIN1300_RGMII_2_00_NS;
+
+	*reg &= ADIN1300_GE_RGMII_RX_MSK;
+	*reg |= ADIN1300_GE_RGMII_RX_SEL(val);
+}
+
+static void adin_config_rgmii_tx_internal_delay(struct phy_device *phydev,
+						int *reg)
+{
+	struct device *dev = &phydev->mdio.dev;
+	u32 val;
+
+	if (device_property_read_u32(dev, "adi,tx-internal-delay", &val))
+		val = ADIN1300_RGMII_2_00_NS;
+
+	*reg &= ADIN1300_GE_RGMII_GTX_MSK;
+	*reg |= ADIN1300_GE_RGMII_GTX_SEL(val);
+}
+
 static int adin_config_rgmii_mode(struct phy_device *phydev,
 				  phy_interface_t intf)
 {
@@ -86,6 +121,7 @@ static int adin_config_rgmii_mode(struct phy_device *phydev,
 	if (intf == PHY_INTERFACE_MODE_RGMII_ID ||
 	    intf == PHY_INTERFACE_MODE_RGMII_RXID) {
 		reg |= ADIN1300_GE_RGMII_RXID_EN;
+		adin_config_rgmii_rx_internal_delay(phydev, &reg);
 	} else {
 		reg &= ~ADIN1300_GE_RGMII_RXID_EN;
 	}
@@ -93,6 +129,7 @@ static int adin_config_rgmii_mode(struct phy_device *phydev,
 	if (intf == PHY_INTERFACE_MODE_RGMII_ID ||
 	    intf == PHY_INTERFACE_MODE_RGMII_TXID) {
 		reg |= ADIN1300_GE_RGMII_TXID_EN;
+		adin_config_rgmii_tx_internal_delay(phydev, &reg);
 	} else {
 		reg &= ~ADIN1300_GE_RGMII_TXID_EN;
 	}
-- 
2.20.1

