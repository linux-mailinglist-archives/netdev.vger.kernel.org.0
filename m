Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C343F861E2
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390045AbfHHMcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:32:15 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:19964 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732254AbfHHMax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:30:53 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CSGhR002639;
        Thu, 8 Aug 2019 08:30:45 -0400
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2055.outbound.protection.outlook.com [104.47.49.55])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfkv4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:30:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LAL/Ln1xgBGTmDDm+EK6So737EW1IxFheTxyjoBZW36owY9ek0N8WCZLtt/S9J9+GmZNG4Ivt/NU0PbgAI0KPjH78sHFDDfDq9yBQ4bq4WOluhtuA3AsOmT5Gzu6nT7rFX8RGzhpiAAwUWARmIt9a5hrPh0SEJyv8PMdAdLjVCgqNcmUoeZjgVZ5lNEhi5/s4zQTiI49AWrw4FjUb3SICTAWrlGGGOrBy/8NvWqhr+nFWyCyaHABvnHkkeAktoFaDmtkqprxuPaqFEYN9japTYo7fqs6QqRcO9qPqwAEd2EJjj2PMD2BnEBRow9EN9VJ5p+H/4qU8289jXuYtr5ZKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvOl9aLNAIx4btKasL23JvR1dRgPmnqnr8INriFcIgA=;
 b=VCerY1bjEZMOXEaG6MxsYIx3Wbu3Ws6PPrl4+eL2RLvwoqAb8xuVRYTX7jpdfraqAUaoJ4uRbOF+GMpH7vOHsmLPvtnZMInF9EDxAlqHxi7/ybDtWqNVNSPxKftpDUxcHOFpphwxTm9j3NbGMa7geQBIAplxA34tZRk8qKe88GNNv68vZGlPYRbZAuCG0NeL8F+V8iIvV0uLiASxoKUoRDBz2fBvUYRwEHQdzzkonmeQaoi1kw2vVD1vsLOdSIGOfFtqW2HbiNVEO4gfgDUApkjlUnP/YT2WpxX/EtFazEfdb3a4AcLHd5Jia9fv12kL+h5+WMPFa72eg4jkxMEVtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vvOl9aLNAIx4btKasL23JvR1dRgPmnqnr8INriFcIgA=;
 b=0AXT48CTUwZR3WvAPcxLOZy5CLxqYxrXxAfdI8SeOWswUT0TZmMELbSZ912QN0Sr/hrnetShXG19fcEJ22dNVpz7RNRLSYjcTldVbW7hwu68Y6yPlb5bm5DbmsUf80gv6Je/gxlh5BhIFhLJKeFqr859A5uHlMydl/Pdyc0XYvk=
Received: from DM3PR03CA0017.namprd03.prod.outlook.com (2603:10b6:0:50::27) by
 DM5PR03MB3163.namprd03.prod.outlook.com (2603:10b6:4:3c::36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.12; Thu, 8 Aug 2019 12:30:43 +0000
Received: from SN1NAM02FT037.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::209) by DM3PR03CA0017.outlook.office365.com
 (2603:10b6:0:50::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Thu, 8 Aug 2019 12:30:43 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT037.mail.protection.outlook.com (10.152.72.89) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:30:42 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CUgpn021217
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:30:42 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:30:41 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 05/15] net: phy: adin: add {write,read}_mmd hooks
Date:   Thu, 8 Aug 2019 15:30:16 +0300
Message-ID: <20190808123026.17382-6-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(346002)(136003)(376002)(396003)(2980300002)(189003)(199004)(478600001)(2906002)(7696005)(1076003)(4326008)(107886003)(14444005)(48376002)(50466002)(446003)(54906003)(110136005)(336012)(486006)(2616005)(476003)(426003)(11346002)(76176011)(186003)(356004)(6666004)(106002)(26005)(36756003)(51416003)(126002)(316002)(44832011)(2201001)(2870700001)(70586007)(86362001)(50226002)(8936002)(305945005)(246002)(7636002)(47776003)(70206006)(5660300002)(8676002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR03MB3163;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acfa6ad3-e4b4-4b34-cec5-08d71bfc3b22
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM5PR03MB3163;
X-MS-TrafficTypeDiagnostic: DM5PR03MB3163:
X-Microsoft-Antispam-PRVS: <DM5PR03MB3163C9738E788F61711D184FF9D70@DM5PR03MB3163.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: FNn279NMDWvn+7gS8Gvl3R5fVDKb+IEfCklfb1LRRyzIS5YEXcfOb53iWlScx0cVp5eLEH8N4AlaItEhaN9MWm+ugvBLuamS9+PVhKr5kCxT1WyDlUyfAtDVl/L37xNpl3nndmsiwxXxLmYyDW5H+XDThldwG3N3A3LFD2SLkS9IRMYI1reqVD14EAe/xgThV8vlE8vYBezI3xFb2Ynf71mpas3CFuaa8NBdfLwqTgEgTvFT2oU/tbzFKn+0ECeKU/k2i5BglpzBkkl7VM4M7expnZAFW1mNLuXjAmkNqtylfqu3sWuJq2MMvgJ4mdvvWzFkayWg7BLfuAf0LlOpEi0awn8TGEZOOOFn7NWC5+ToEse50OwokbxL02NEUgMLp6IrNi/xkpR0eVLTB53TcZBGGVUC07qBJUvWaqOOz+A=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:30:42.8414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acfa6ad3-e4b4-4b34-cec5-08d71bfc3b22
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB3163
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=951 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080130
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
index 69000fb16704..a833e329be6f 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -14,6 +14,9 @@
 #define PHY_ID_ADIN1200				0x0283bc20
 #define PHY_ID_ADIN1300				0x0283bc30
 
+#define ADIN1300_MII_EXT_REG_PTR		0x0010
+#define ADIN1300_MII_EXT_REG_DATA		0x0011
+
 #define ADIN1300_INT_MASK_REG			0x0018
 #define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
 #define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
@@ -53,6 +56,45 @@ static int adin_phy_config_intr(struct phy_device *phydev)
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
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
@@ -65,6 +107,8 @@ static struct phy_driver adin_driver[] = {
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
+		.read_mmd	= adin_read_mmd,
+		.write_mmd	= adin_write_mmd,
 	},
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
@@ -77,6 +121,8 @@ static struct phy_driver adin_driver[] = {
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
+		.read_mmd	= adin_read_mmd,
+		.write_mmd	= adin_write_mmd,
 	},
 };
 
-- 
2.20.1

