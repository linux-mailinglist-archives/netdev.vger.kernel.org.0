Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA8B87B71
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406585AbfHINgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:36:19 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:23308 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406497AbfHINgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:17 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DNFu5011289;
        Fri, 9 Aug 2019 09:36:08 -0400
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2051.outbound.protection.outlook.com [104.47.32.51])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u8tcbtf7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHvUL0Cg5LctTqjDzeANRAf7ozlf5yYaWOxvGh1x7BqrvrVxN8L2BAlldHFXiQwtEizI0Tne6viSnNyUx7ENoQn3zd52tTEwYXCFO58iTcFg5LI6ZFHHCJu4KTpLF53hNkeW/P2CD5fDGwF7u63UcDse+NG9fWszjZUqtG2gwv+BsPeUjWYmnJ0VN0sIWBZgrcUfafXDNldLLIHOShcc7FinyUHdNqswOI3KMLWlwNOtPXSYf+LdRd6GikaqvwAxHlUsYlyRC+0IlrQMb/3PVR6Tl97lEgxxud3UTBde7j7Rw8fKOtetN8jdoUMqsxlkrT4dceO9rUYcjc2ebmrcMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kCQ7LqT49bpuRYzqun5ztIJvoI6Dydv1a6m9E9uK7h0=;
 b=KEAGz85ApilyqaMaW18MNCWr+Zx/HSupJlFhqIHhDqs069FmZ44u7kEjNCYD8hTbFcKU/99l5OKPeHof+xcSYo13kA4aXIFkXJh782AFUe1547w3TjalFqekt8wQjAn02UbeM12vnunLR/77q0tAclqjuqEqYzcZ92L/59tTNHX7HkvT1Vvz64ApmFuKn/leWlBvfoTf3ZJ6H+KXsw/9lZ8nrk9lsHAoLeUEm2SCZuMRMVSlGi8Fqsht9D2H/qfSg/kh/53xQiSXCURemDvlnPm0+TtV2+Fbp73tcMlqMvvpMQafJwXamth55goWHCxLWdVILLLtOc3nuRe8/B2diQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kCQ7LqT49bpuRYzqun5ztIJvoI6Dydv1a6m9E9uK7h0=;
 b=IcAUZSXSKwrhcUNPFjFAIPcwR+MgNXxlH/5cE09lEvglSthWZur3+2oTsrOi0xPDisgqAeyTbUFpi9aFzBZar9fvNJztx3KVDZ4mzdxjCdgXPG0Qc/CjMVc9ZdyysXDm9pap0EBgybqBZczp1jxegSs6N6jHmlDh3vgYo+pN4JE=
Received: from BN3PR03CA0105.namprd03.prod.outlook.com (2603:10b6:400:4::23)
 by DM6PR03MB4970.namprd03.prod.outlook.com (2603:10b6:5:1e5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.20; Fri, 9 Aug
 2019 13:36:06 +0000
Received: from CY1NAM02FT055.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::200) by BN3PR03CA0105.outlook.office365.com
 (2603:10b6:400:4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:06 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT055.mail.protection.outlook.com (10.152.74.80) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:36:05 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79Da5Lf025659
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:36:05 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:36:04 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 04/14] net: phy: adin: add {write,read}_mmd hooks
Date:   Fri, 9 Aug 2019 16:35:42 +0300
Message-ID: <20190809133552.21597-5-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(376002)(396003)(2980300002)(189003)(199004)(44832011)(486006)(14444005)(1076003)(50466002)(5660300002)(48376002)(106002)(86362001)(70586007)(70206006)(186003)(54906003)(6666004)(356004)(8936002)(110136005)(316002)(7696005)(7636002)(305945005)(76176011)(51416003)(2201001)(26005)(47776003)(50226002)(8676002)(246002)(476003)(478600001)(2906002)(426003)(2616005)(126002)(2870700001)(11346002)(36756003)(446003)(107886003)(336012)(4326008)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB4970;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2b69565-5311-4d6c-b6c5-08d71cce87b4
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM6PR03MB4970;
X-MS-TrafficTypeDiagnostic: DM6PR03MB4970:
X-Microsoft-Antispam-PRVS: <DM6PR03MB49700FE02CDD4EF43BE339D9F9D60@DM6PR03MB4970.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: odCjQMMwG0VDs+MgRWWh++VdDy9BmqTnaj5Ne7wVgcZBYeHFD8vmblMdcuzPDKcPAChedPZ5/gOOii2X7SNVrf2UlsKK+euaBYQVChviIeU0lhaI20sr8XHqLyYsP8IOaalra1nzJ7JvJjYtckITUP2S9ERqC63P/MAfvUnucwKWAYLjQ/6+DASGqpc8q0RUwmkisxWZ9xYcPIIvxfqPAMGHpRW4myGUSC9E9GOEYbDXCJgko5qsALxFzvghWXwgsot0ZQmGJUtTTOjA7JY4jS7bHwMvCzCt30sSIIaqBuPVZO5QQMV8/bDI9uhlYyH5d9kNfaoKHUr07gp3XULnEhdKDBgRP+Uy+Y5VJpGfXwp6SxQavNfceQAtRqC44NhYOKHKDRzSedvxu3i8xXex8ATmpDUwHfiaLa3KwKnLlfA=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:36:05.6588
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b69565-5311-4d6c-b6c5-08d71cce87b4
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB4970
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

Both ADIN1200 & ADIN1300 support Clause 45 access for some registers.
The Extended Management Interface (EMI) registers are accessible via both
Clause 45 (at register MDIO_MMD_VEND1) and using Clause 22.

However, the Clause 22 access for MMD regs differs from the standard one
defined by 802.3. The ADIN PHYs  use registers ExtRegPtr (0x0010) and
ExtRegData (0x0011) to access Clause 45 & EMI registers.

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
index 91ff26d08fd5..8973ad819b93 100644
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
@@ -64,6 +106,8 @@ static struct phy_driver adin_driver[] = {
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
+		.read_mmd	= adin_read_mmd,
+		.write_mmd	= adin_write_mmd,
 	},
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
@@ -75,6 +119,8 @@ static struct phy_driver adin_driver[] = {
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
+		.read_mmd	= adin_read_mmd,
+		.write_mmd	= adin_write_mmd,
 	},
 };
 
-- 
2.20.1

