Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD1781E44
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbfHENz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:55:27 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:3670 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729154AbfHENz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:26 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75DqjLt018849;
        Mon, 5 Aug 2019 09:55:18 -0400
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2055.outbound.protection.outlook.com [104.47.46.55])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u56w5svfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqjSqvjK5SGBzGTKckthVNari8j1ey2aYb7pKeexMZ9jHbunO2uHJIs8gy9ukgleI3eoZNmRep8hVDJ+GdZMv4t6Q1P7PdS8IL/gTQEXB+Lmz7vkYnt7k46T6Ep/kaeWcxic6yCkUKMI9S0f8QgLvup5ok9UdALtFmyELvrxnBcYmqh2L048K/CSc7KnOMzQ0YxQ3ucyF1ZH9rvU2GcYoalQm2xoZeud+7YMwQ0Ff0s0skNhybPT6Znm2+1/p7bP4DsH838D0LG29j/BoFd/vRMXdpFHR/hzsy4olXofLU9USkeb2ypGtVV9FpA6W0bR0c+sAR9shTBRzIGPX/FFSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3S49Hc5L60M5JI7HLCZJFQ7hjx5+IAf0XRVJ9udfO0=;
 b=QmI6wixRu2XRIIH2x4RjLhnok6XFseqB6Q/haIaNjgfe9WLL4ilNX5pS2fRWQlX7TauT/c+nMCDWSwRmliAYs9WKL+Gx3pPBlZFG3ce+zVcsVSe4zwYl6lNtFgWk57rUsOJhaPB+k9f0TsfgZcmHZsbVU8kfKci651CumwKm5Yf4E1I4xb6H/rp0pkuuZeWoI6SkSkeXa/z2h6o4WHu978PZao/XNGGkLs4KSVcQgGMcfH+jUtn3VsPphjgp8iLPCQizl6choxnUONdc35859RRQU1zbgWT+XjpcXGrpIhAPSE4OP5+pY2pgir9P6fvwR9lWHAbF0qfiCIbMySZz3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3S49Hc5L60M5JI7HLCZJFQ7hjx5+IAf0XRVJ9udfO0=;
 b=jY9ntrAY33kUN+LK5TdFFf3DO0yGBmMktbH1UVcAKG/UHMgpn9Fgc+iqlYjZ58quivTx3hWSD3nNwaBw8A9nC5INTF/qUCk4PMr4J8F5YGvm5+XZEUCkMCp+YhoguvQSzRwJrchC7k+4oqYycMHIrLHaB5+WR/vpz96Odr+RpcA=
Received: from BL0PR03CA0026.namprd03.prod.outlook.com (2603:10b6:208:2d::39)
 by DM6PR03MB4588.namprd03.prod.outlook.com (2603:10b6:5:10d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2115.15; Mon, 5 Aug
 2019 13:55:16 +0000
Received: from CY1NAM02FT033.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::200) by BL0PR03CA0026.outlook.office365.com
 (2603:10b6:208:2d::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.13 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:15 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT033.mail.protection.outlook.com (10.152.75.179) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:15 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75DtBIN016196
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:11 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:13 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 04/16] net: phy: adin: add {write,read}_mmd hooks
Date:   Mon, 5 Aug 2019 19:54:41 +0300
Message-ID: <20190805165453.3989-5-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(376002)(39860400002)(2980300002)(189003)(199004)(305945005)(486006)(2870700001)(76176011)(1076003)(70206006)(7636002)(70586007)(336012)(44832011)(8676002)(478600001)(8936002)(426003)(47776003)(106002)(2201001)(246002)(54906003)(356004)(50466002)(6666004)(51416003)(26005)(110136005)(86362001)(316002)(48376002)(476003)(2616005)(4326008)(36756003)(2906002)(126002)(11346002)(446003)(107886003)(5660300002)(50226002)(186003)(7696005)(14444005)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB4588;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05930650-2a78-4c8c-3f31-08d719ac8b2d
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM6PR03MB4588;
X-MS-TrafficTypeDiagnostic: DM6PR03MB4588:
X-Microsoft-Antispam-PRVS: <DM6PR03MB45888EC533C9342506B87102F9DA0@DM6PR03MB4588.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: JvcuVesQb7DEtRH857quvm/xNBXuA9b2hUAi/afhPWWAjNV3j5lvmSScRaXW8kmlFATgB+ImoyvQSXL7awx0eJEhbo3lcN63srm4I+Z7AP7YciGC6trv9Ifr164K4dF8F1BzrMcv8uWVh9qFlP1YIzYeujsfqi/ZLAIgkEJ7DKCEEg5CLT43hMIS1IlYz+1PpiBwqjHa1rh0JZDf87yE3uWEINyGLoifo/ds+UgwEpwl3GPkP+FhZhy4FumdDC3MzjgfMBgtgtuhmXgib8eu4aWhihKllbwtnaonkxWzVUuNawwL5HdM5RiiSbfCyWdYyRpXZjl81/3SP8LzRSmtA/yzueqKbsSjSaakdXbpo8xr7DbMqvxPQUSnY0bwzkeSmcb+eOPVLDhTDsgWwwlqTghxMlH7H+I/27sMIfNMVCk=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:15.0857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05930650-2a78-4c8c-3f31-08d719ac8b2d
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB4588
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=910 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both ADIN1200 & ADIN1300 support Clause 45 access.
The Extended Management Interface (EMI) registers are accessible via both
Clause 45 (at register MDIO_MMD_VEND1) and using Clause 22.

However, the Clause 22 MMD access operations differ from the implementation
in the kernel, in the sense that it uses registers ExtRegPtr (0x10) &
ExtRegData (0x11) to access Clause 45 & EMI registers.

The indirect access is done via the following mechanism (for both R/W):
1. Write the address of the register in the ExtRegPtr
2. Read/write the value of the register (written at ExtRegPtr)

This mechanism is needed to manage configuration of chip settings and to
access EEE registers (via Clause 22).

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 46 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index b75c723bda79..3dd9fe50f4c8 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -14,6 +14,9 @@
 #define PHY_ID_ADIN1200				0x0283bc20
 #define PHY_ID_ADIN1300				0x0283bc30
 
+#define ADIN1300_MII_EXT_REG_PTR		0x10
+#define ADIN1300_MII_EXT_REG_DATA		0x11
+
 #define ADIN1300_INT_MASK_REG			0x0018
 #define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
 #define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
@@ -63,6 +66,45 @@ static int adin_phy_config_intr(struct phy_device *phydev)
 			      ADIN1300_INT_MASK_EN);
 }
 
+static int adin_read_mmd(struct phy_device *phydev, int devad, u16 regnum)
+{
+	struct mii_bus *bus = phydev->mdio.bus;
+	int phy_addr = phydev->mdio.addr;
+	int err;
+
+	if (phydev->is_c45) {
+		u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
+
+		return __mdiobus_read(bus, phy_addr, addr);
+	}
+
+	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR, regnum);
+	if (err)
+		return err;
+
+	return __mdiobus_read(bus, phy_addr, ADIN1300_MII_EXT_REG_DATA);
+}
+
+static int adin_write_mmd(struct phy_device *phydev, int devad, u16 regnum,
+			  u16 val)
+{
+	struct mii_bus *bus = phydev->mdio.bus;
+	int phy_addr = phydev->mdio.addr;
+	int err;
+
+	if (phydev->is_c45) {
+		u32 addr = MII_ADDR_C45 | (devad << 16) | (regnum & 0xffff);
+
+		return __mdiobus_write(bus, phy_addr, addr, val);
+	}
+
+	err = __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_PTR, regnum);
+	if (err)
+		return err;
+
+	return __mdiobus_write(bus, phy_addr, ADIN1300_MII_EXT_REG_DATA, val);
+}
+
 static struct phy_driver adin_driver[] = {
 	{
 		.phy_id		= PHY_ID_ADIN1200,
@@ -77,6 +119,8 @@ static struct phy_driver adin_driver[] = {
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
+		.read_mmd	= adin_read_mmd,
+		.write_mmd	= adin_write_mmd,
 	},
 	{
 		.phy_id		= PHY_ID_ADIN1300,
@@ -91,6 +135,8 @@ static struct phy_driver adin_driver[] = {
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
+		.read_mmd	= adin_read_mmd,
+		.write_mmd	= adin_write_mmd,
 	},
 };
 
-- 
2.20.1

