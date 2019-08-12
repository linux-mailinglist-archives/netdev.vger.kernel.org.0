Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7504289C8A
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfHLLYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:24:17 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:51558 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728263AbfHLLYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:15 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNORN018336;
        Mon, 12 Aug 2019 07:24:09 -0400
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2055.outbound.protection.outlook.com [104.47.49.55])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u9qs7w65m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kl9CsEDGaftjhPmTy67+q3XW6xzGjjNJv8POVIKdFb+G+W6kLbsc7t+aU6NfN7wv8fp37I3OOmOpGSdsMxieN7uOuNUbsNlpkmGSyChfAbPjWW2DCj0buvgKszrZa+wjLH39UU9kjWNAClDwrGhZCOCjus0yJn/7G5hRcBeY4uvBC0thIXHnC+GgA7urZRzetHDERIuGBlKkLhwUBrhvN4/OQU8lUy1fH+H6JfXLJik3dIXXJvxxoquZDO0mdk7+FY1vMXffHotKTruUkhk8WxjtrJWIudGKleWKxV2n+oqIncbRaFpoyV8P8bbQ0viw4MtDl3pBYWIBiuCqs9+Evw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWYab7AxaeRlMb2S4+/9DNrUg3Gzca4OwwiPBdS56wc=;
 b=M4n+Y5ooQzOGz/R6Hshnn9ivwHEAdfbCF3I2CPQBwHQRMR0j3kOVBwU7xrdvPKhYuAQaHY/+fGFVmtvvNHirLDbejOU2uZQINSBJwY+jckYkF0Vs55u68qCIc0AOBsvz2WCy9W9Dwdfuf3Z2NHIkYu6EjUSS7+2h+P7FglkTnILagSsfnBlQ0RmnN6MmG1OXOEjghwRlA+F2ewWe89kpsTIsE/7WvOA/TOgIizK5BaNllnA2P26RFxcq0XajiNaCAqqWCnrlcIHU+7PkJxKXYGqpLCw5HWJa+pahYubY0KNsZLSPo8uz90w6kMKCz/a55kmws3mkKPaLAcahARMizg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWYab7AxaeRlMb2S4+/9DNrUg3Gzca4OwwiPBdS56wc=;
 b=I2Z+/ukHZIqG6SoJwm30yXFvrqlgikLe9k7aAIJjD0k0FtdpVHrLHWdusLye3W1CJL9QZ0c7SiPYj9Pt20Xx7G8VqsdA8RsYISPuNzW0qcmdUhk3DeD3+YltBwGhhlajz62HfXFNx7bQ36kbLOzi4qP8wcFzz5d5x9/dtKWa4dE=
Received: from BN6PR03CA0070.namprd03.prod.outlook.com (2603:10b6:404:4c::32)
 by SN6PR03MB3517.namprd03.prod.outlook.com (2603:10b6:805:41::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.20; Mon, 12 Aug
 2019 11:24:06 +0000
Received: from CY1NAM02FT022.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::202) by BN6PR03CA0070.outlook.office365.com
 (2603:10b6:404:4c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Mon, 12 Aug 2019 11:24:06 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT022.mail.protection.outlook.com (10.152.75.185) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:24:05 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBO4rB004163
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:24:04 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:24:04 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 04/14] net: phy: adin: add {write,read}_mmd hooks
Date:   Mon, 12 Aug 2019 14:23:40 +0300
Message-ID: <20190812112350.15242-5-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(136003)(39850400004)(376002)(346002)(2980300002)(199004)(189003)(4326008)(356004)(76176011)(51416003)(305945005)(7696005)(26005)(7636002)(2201001)(186003)(6666004)(316002)(110136005)(54906003)(446003)(11346002)(2870700001)(126002)(8936002)(336012)(36756003)(107886003)(50226002)(47776003)(8676002)(2616005)(476003)(426003)(2906002)(478600001)(246002)(14444005)(1076003)(5660300002)(50466002)(486006)(44832011)(106002)(70206006)(70586007)(86362001)(48376002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR03MB3517;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e77f7f14-3896-4e96-c43d-08d71f17962a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:SN6PR03MB3517;
X-MS-TrafficTypeDiagnostic: SN6PR03MB3517:
X-Microsoft-Antispam-PRVS: <SN6PR03MB35176A151E51E030A3DBD531F9D30@SN6PR03MB3517.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: t7657DqkMjmy0JHB130OT3ioLRP7O7uMbKTf9e0l87GGSMHSAiayPDhXfb/DWCsFPh+xNa3V44lM7TgqDiviefCu2NRQP7E7XDYx+RwPtoU74QonZ3S9JL/EFR8nxGGjp7H2gW4OOWsBD44EyGijIGsDXNP5IrS7NekI+Rb85Qp2w6mt96JsMExN4k3phD6Yj6aBB7Zw8gQLqJlpdrH/rXfTVVVkFG4yEvu/HtIiLjs6oIxQsBRPzp56uJ/yjDRutJNn5cM1LGN3Nn7G41vrN8n97vbr3rAhVdPPBWplQ8w/GEDXwdOA09g4zLHZxveWOwaSe5rvS1KMiCFajzdjSUTCPVhYW7KuPBezFKE0ic1kJT/Nd8C4W+H8wwu7kdBIReYkCmSBj4Rhb95bCy4Gec61KsMwsFRXRn0Hy74nwgg=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:24:05.4960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e77f7f14-3896-4e96-c43d-08d71f17962a
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB3517
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

