Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483939029C
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfHPNKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:10:44 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:9950 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727289AbfHPNKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:10:42 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7GD7kd5030348;
        Fri, 16 Aug 2019 09:10:35 -0400
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2053.outbound.protection.outlook.com [104.47.46.53])
        by mx0a-00128a01.pphosted.com with ESMTP id 2ud8vhapks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 09:10:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAopQ/HEIEuXG5miqWNb11RzVFrk1b2OYsDw4cr+kXTi6Tz2UyVU0s9ckhL4lBXwRuqEjCG++llW1Ec9yEpCmzjYV3/I/SeDDU8TUoJAHY7EbYLprFbhq72LvkOOQLlxQoTl4ph/kN3gufcTnV36WhvMwKKBu7JgUNovYsug2zmnVtoz946lD+U7pr/U9SpJjHrdV+ifM/30v04f/QM1wfzaJsR4ZuMumU67NkQRTlmzQdCX9RCvHdJlBcY8qAh17lD2c6DnH2jN5IIU/fE/ELQV0H+y/2J8u0kWo7qwUmSior7w5zSQRAzOrLZagzcoyf5EinaXJVzPm+FZXtO4Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nSP/erc+rd+M3RYjPAqaKnPRZE80yEvVdp+D9YykUlI=;
 b=Qzi6YAeBFSvJEVBOzyYEgnrjqAvZTqjJN+dveG7/HTY+VMFp57q1oFCFeyzqY3LzRUvHMDdh2GDbAki25TKlbbNrklOFoSTNJeO+0qv5b9Wdw9rlbZ0c3W5uyvDZuBdXvNSGOCp+8gVloA0I+KTVpZw0Hvd5XHxDEZ5oMwa0yBtGRFG7KXcroUjlpnpvu/1lacaZzC3lnaTokAIWzh1kiCIQwE/Xoj1XPMoKlIKSPQ8XSX7OLMHYFfKIANtt2veenfyvxLw/0DD/0YqA4x2hsAvaPzaYHSnVQTEth4k/rkpD4HEbJKUUsoePsjWDH94a2OViC/FbRjS1eo4nEwLWGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nSP/erc+rd+M3RYjPAqaKnPRZE80yEvVdp+D9YykUlI=;
 b=dXPbaECxQdnWFmveT1vb7MFbV7yaACPU0pjbcUuPbKRq4F+6tmMcYJflQEoXIddmY7YSLQxVPDruCFaylRrErh4NmL0r5FLgQS+BTOiU7CNWYkSJ8kNWCZcZNPbqAwm10Bc3DApj+FhJSMWu/ctOJsQRCkdqxEE8UPg4uv83CeY=
Received: from CY4PR03CA0010.namprd03.prod.outlook.com (2603:10b6:903:33::20)
 by SN6PR03MB4384.namprd03.prod.outlook.com (2603:10b6:805:f6::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.16; Fri, 16 Aug
 2019 13:10:32 +0000
Received: from SN1NAM02FT020.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::202) by CY4PR03CA0010.outlook.office365.com
 (2603:10b6:903:33::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.18 via Frontend
 Transport; Fri, 16 Aug 2019 13:10:32 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT020.mail.protection.outlook.com (10.152.72.139) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 13:10:32 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7GDAVKD007882
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 16 Aug 2019 06:10:31 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 16 Aug 2019 09:10:30 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 04/13] net: phy: adin: add {write,read}_mmd hooks
Date:   Fri, 16 Aug 2019 16:10:02 +0300
Message-ID: <20190816131011.23264-5-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816131011.23264-1-alexandru.ardelean@analog.com>
References: <20190816131011.23264-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(39860400002)(376002)(2980300002)(199004)(189003)(14444005)(2201001)(2870700001)(4326008)(246002)(2906002)(305945005)(7636002)(36756003)(70586007)(70206006)(107886003)(6666004)(356004)(47776003)(1076003)(86362001)(478600001)(8676002)(5660300002)(8936002)(26005)(48376002)(44832011)(336012)(426003)(76176011)(7696005)(51416003)(316002)(11346002)(54906003)(2616005)(476003)(126002)(486006)(446003)(110136005)(186003)(50226002)(50466002)(106002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR03MB4384;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b32f3b2a-6474-4fae-a1e4-08d7224b1e75
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:SN6PR03MB4384;
X-MS-TrafficTypeDiagnostic: SN6PR03MB4384:
X-Microsoft-Antispam-PRVS: <SN6PR03MB4384E88B653FCD040C1DC36CF9AF0@SN6PR03MB4384.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Bz4IS58vbwRxjgOEcolNtu750TColIs9kJfJncxVYweTOlqjpCBZUckd8ngWPZvMY9UHPkZ9O1ujvVThf8EBeHXjN1zBumPcK9l2tHQ3vdtMryiUex88gorPiNz6bi5y4iH75XhgJXgqd2KNoo+vkPfuoUpzRgrGPNKACVHuRBoPmJC9wrrK/+0jMIyiaen296PGYxo98LqA482HrV7qErY6AmONdfrnPOhWgsILtPRW588CK+tx8sU+hqmCb6OQFL9FEWXl/kZir39qRbhD6m/5ZtZJ6FfwkLyZ/WNSJ0fUkZDm7A/m56PnpH4JTiCLyKUuBlysXdnJuLcuHEUgTvxglBc5K2uF1FJwv47r6yKNFLomStxU1+Cel6cMZQ+7kGi7LWURLTEsRLVUXd2WU3OcqwLnsVNBP4DDEEk2rsE=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 13:10:32.0698
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b32f3b2a-6474-4fae-a1e4-08d7224b1e75
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB4384
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both ADIN1200 & ADIN1300 support Clause 45 access for some registers.
The Extended Management Interface (EMI) registers are accessible via both
Clause 45 (at register MDIO_MMD_VEND1) and using Clause 22.

The Clause 22 access for MMD regs differs from the standard one defined by
802.3. The ADIN PHYs  use registers ExtRegPtr (0x0010) and ExtRegData
(0x0011) to access Clause 45 & EMI registers.

The indirect access is done via the following mechanism (for both R/W):
1. Write the address of the register in the ExtRegPtr
2. Read/write the value of the register via reg ExtRegData

This mechanism is needed to manage configuration of chip settings and to
access EEE registers via Clause 22.

Since Clause 45 access will likely never be used, it is not implemented via
this hook.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index f4ee611e33df..efbb732f0398 100644
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
@@ -51,6 +54,33 @@ static int adin_phy_config_intr(struct phy_device *phydev)
 			      ADIN1300_INT_MASK_EN);
 }
 
+static int adin_read_mmd(struct phy_device *phydev, int devad, u16 regnum)
+{
+	struct mii_bus *bus = phydev->mdio.bus;
+	int phy_addr = phydev->mdio.addr;
+	int err;
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
@@ -62,6 +92,8 @@ static struct phy_driver adin_driver[] = {
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
+		.read_mmd	= adin_read_mmd,
+		.write_mmd	= adin_write_mmd,
 	},
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
@@ -73,6 +105,8 @@ static struct phy_driver adin_driver[] = {
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
+		.read_mmd	= adin_read_mmd,
+		.write_mmd	= adin_write_mmd,
 	},
 };
 
-- 
2.20.1

