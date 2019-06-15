Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5468847299
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 01:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfFOXrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 19:47:39 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:46618 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726434AbfFOXrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 19:47:39 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5FNhZqw019380;
        Sat, 15 Jun 2019 16:47:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=2871iQuj6mhD0LeWxbihfTlXitwpwttJ3+TrYK5cMjw=;
 b=AR3rtNaECIQfXbpJI4MLKRztbRiPROceteTjIKxxhEGnZ/dEfHBAzlMJhiFdmt3hE4LV
 Vzd1MBOWIPu6YQbaQzl9rnLhEJxueSb8k3+8Y/PuGNqxDVtPL+ck4BmgtfqQ1VkmQXxY
 8qP6qzv3gqiYjVyFvSw/2T3Vo1DDCv97fcTGrvg2awLaKB40cBiTc2IjxWuS+wd2EXaO
 JqSIL9vLhcDWsZYoRvo7Tt4WpCjcoREjAzs2ER2IySUOgyDEO4gHmgw87Cw1luPJHGRp
 6DARyHZsuHATSrl7Kvsx+K5liffnOvQx0s3ILjaslIeFIVVAHT/8UirI3XZdSpUhS++e DA== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2058.outbound.protection.outlook.com [104.47.36.58])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2t4v8w212w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 15 Jun 2019 16:47:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2871iQuj6mhD0LeWxbihfTlXitwpwttJ3+TrYK5cMjw=;
 b=ri6swiJ6qmnyaLsis1+jKrTdGpX0xl3Mq0p8PZ29RHdbOmUkm/RkKensp/eZdEhZmEt3bGcF0mwNcGFigZ9xDQZATyavrFFg0eAPz4SJdqXwsDPBMQAgOX9YBiksFYEkgsDcLMDNE10M2m5fsSa5RCHMzbS00z6MIMCybbd//tY=
Received: from DM5PR07CA0065.namprd07.prod.outlook.com (2603:10b6:4:ad::30) by
 SN2PR07MB2494.namprd07.prod.outlook.com (2603:10b6:804:17::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Sat, 15 Jun 2019 23:47:30 +0000
Received: from BY2NAM05FT032.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e52::208) by DM5PR07CA0065.outlook.office365.com
 (2603:10b6:4:ad::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1965.17 via Frontend
 Transport; Sat, 15 Jun 2019 23:47:30 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 BY2NAM05FT032.mail.protection.outlook.com (10.152.100.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.7 via Frontend Transport; Sat, 15 Jun 2019 23:47:29 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNlRj3014291
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sat, 15 Jun 2019 16:47:28 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sun, 16 Jun 2019 01:47:26 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 16 Jun 2019 01:47:26 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5FNlQ1l027768;
        Sun, 16 Jun 2019 00:47:26 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <rafalc@cadence.com>,
        <aniljoy@cadence.com>, <piotrs@cadence.com>, <pthombar@cadence.com>
Subject: [PATCH 3/6] net: macb: add PHY configuration in MACB PCI wrapper
Date:   Sun, 16 Jun 2019 00:47:24 +0100
Message-ID: <1560642444-27704-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560642409-27074-1-git-send-email-pthombar@cadence.com>
References: <1560642409-27074-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(39850400004)(376002)(2980300002)(199004)(189003)(36092001)(51416003)(7696005)(70586007)(47776003)(316002)(76176011)(16586007)(8936002)(54906003)(110136005)(26005)(77096007)(186003)(50226002)(8676002)(53416004)(50466002)(48376002)(126002)(11346002)(476003)(7636002)(7126003)(2616005)(486006)(107886003)(2906002)(446003)(305945005)(86362001)(5660300002)(76130400001)(70206006)(426003)(356004)(246002)(478600001)(336012)(26826003)(36756003)(2201001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR07MB2494;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f3519cc-9704-43ad-8545-08d6f1ebd42c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:SN2PR07MB2494;
X-MS-TrafficTypeDiagnostic: SN2PR07MB2494:
X-Microsoft-Antispam-PRVS: <SN2PR07MB2494722A63ECD6DF58614C1DC1E90@SN2PR07MB2494.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-Forefront-PRVS: 0069246B74
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: PiegFhDn0J8ptxmUzY5/6jmw2hsiQHOUqH4e4WRQS3r87IcEOHr6RAOCa0POWnq6jGDWiH/g5OWI8TQ29fah5048ZKUurlf4KNOl7tAgKaMX+ZNObokye1IlTKz8IgBMrqj3LOwuTGm5kF0FTv1mm2hU/TKqjaKBFpd+jBwC20LLlj9TgAA5tPSqf3KGB6xAU3P+F15Hk+WA4J9sXbho1keHNAlmi5KKRAhOeRS5rq2VYU+B02IjUi4qgg+RTPzRj3EhaXEx8RSsIpaX8ckz+uRtPTWgrH8RqyZUVRME5/unFnoFAdCNNjP4dKZtyon9JiqcuBtEe4Km/BhFyiBj5jVwRBYMCuln6ZAw3jHnhxuTScREHpEvkJsr3jY/D+ni/F7k9bfPh7Wojm30uWLmnz12wDC1w9zZxynZ0qcwnso=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2019 23:47:29.8059
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f3519cc-9704-43ad-8545-08d6f1ebd42c
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR07MB2494
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-15_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906150226
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add TI PHY DP83867 configuration for SGMII link in
Cadence MACB PCI wrapper.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb_pci.c | 225 ++++++++++++++++++++++++
 1 file changed, 225 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 248a8fc45069..1001e03191a1 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -24,6 +24,7 @@
 #include <linux/etherdevice.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/iopoll.h>
 #include <linux/platform_data/macb.h>
 #include <linux/platform_device.h>
 #include "macb.h"
@@ -37,6 +38,224 @@
 #define GEM_PCLK_RATE 50000000
 #define GEM_HCLK_RATE 50000000
 
+#define TI_PHY_DP83867_ID	0x2000a231
+#define TI_PHY_DEVADDR		0x1f
+#define PHY_REGCR 0x0D
+#define PHY_ADDAR 0x0E
+
+#define MACB_MDIO_TIMEOUT	1000000 /* in usecs */
+
+#define MACB_REGCR_OP_OFFSET		14
+#define MACB_REGCR_OP_SIZE		2
+#define MACB_REGCR_DEVADDR_OFFSET	0
+#define MACB_REGCR_DEVADDR_SIZE		5
+
+#define MACB_REGCR_OP_ADDR	0
+#define MACB_REGCR_OP_DATA	1
+
+static int macb_mdio_wait_for_idle(void __iomem *macb_base_addr)
+{
+	u32 val;
+
+	return readx_poll_timeout(readl, macb_base_addr + MACB_NSR, val,
+				  val & MACB_BIT(IDLE), 1, MACB_MDIO_TIMEOUT);
+}
+
+static int macb_mdiobus_read(void __iomem *macb_base_addr,
+			     u32 phy_id,
+			     u32 regnum)
+{
+	u32 i;
+	int status;
+
+	if (regnum < 32) {
+		i = MACB_BF(SOF, MACB_MAN_SOF) |
+			MACB_BF(RW, MACB_MAN_READ) |
+			MACB_BF(PHYA, phy_id) |
+			MACB_BF(REGA, regnum) |
+			MACB_BF(CODE, MACB_MAN_CODE);
+
+		writel(i, macb_base_addr + MACB_MAN);
+		status = macb_mdio_wait_for_idle(macb_base_addr);
+		if (status < 0)
+			return status;
+	} else {
+		u16 reg;
+
+		reg = MACB_BF(REGCR_OP, MACB_REGCR_OP_ADDR) |
+				MACB_BF(REGCR_DEVADDR, TI_PHY_DEVADDR);
+		i = MACB_BF(SOF, MACB_MAN_SOF) |
+			MACB_BF(RW, MACB_MAN_WRITE) |
+			MACB_BF(PHYA, phy_id) |
+			MACB_BF(REGA, PHY_REGCR) |
+			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(DATA, reg);
+		writel(i, macb_base_addr + MACB_MAN);
+		status = macb_mdio_wait_for_idle(macb_base_addr);
+		if (status < 0)
+			return status;
+
+		i = MACB_BF(SOF, MACB_MAN_SOF) |
+			MACB_BF(RW, MACB_MAN_WRITE) |
+			MACB_BF(PHYA, phy_id) |
+			MACB_BF(REGA, PHY_ADDAR) |
+			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(DATA, regnum);
+		writel(i, macb_base_addr + MACB_MAN);
+		status = macb_mdio_wait_for_idle(macb_base_addr);
+		if (status < 0)
+			return status;
+
+		reg = MACB_BF(REGCR_OP, MACB_REGCR_OP_DATA) |
+				MACB_BF(REGCR_DEVADDR, TI_PHY_DEVADDR);
+		i = MACB_BF(SOF, MACB_MAN_SOF) |
+			MACB_BF(RW, MACB_MAN_WRITE) |
+			MACB_BF(PHYA, phy_id) |
+			MACB_BF(REGA, PHY_REGCR) |
+			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(DATA, reg);
+		writel(i, macb_base_addr + MACB_MAN);
+		status = macb_mdio_wait_for_idle(macb_base_addr);
+		if (status < 0)
+			return status;
+
+		i = MACB_BF(SOF, MACB_MAN_SOF) |
+			MACB_BF(RW, MACB_MAN_READ) |
+			MACB_BF(PHYA, phy_id) |
+			MACB_BF(REGA, PHY_ADDAR) |
+			MACB_BF(CODE, MACB_MAN_CODE);
+
+		writel(i, macb_base_addr + MACB_MAN);
+		status = macb_mdio_wait_for_idle(macb_base_addr);
+		if (status < 0)
+			return status;
+	}
+
+	return readl(macb_base_addr + MACB_MAN);
+}
+
+static int macb_mdiobus_write(void __iomem *macb_base_addr, u32 phy_id,
+			      u32 regnum, u16 value)
+{
+	u32 i;
+	int status;
+
+	if (regnum < 32) {
+		i = MACB_BF(SOF, MACB_MAN_SOF) |
+			MACB_BF(RW, MACB_MAN_WRITE) |
+			MACB_BF(PHYA, phy_id) |
+			MACB_BF(REGA, regnum) |
+			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(DATA, value);
+
+		writel(i, macb_base_addr + MACB_MAN);
+		status = macb_mdio_wait_for_idle(macb_base_addr);
+		if (status < 0)
+			return status;
+	} else {
+		u16 reg;
+
+		reg = MACB_BF(REGCR_OP, MACB_REGCR_OP_ADDR) |
+				MACB_BF(REGCR_DEVADDR, TI_PHY_DEVADDR);
+		i = MACB_BF(SOF, MACB_MAN_SOF) |
+			MACB_BF(RW, MACB_MAN_WRITE) |
+			MACB_BF(PHYA, phy_id) |
+			MACB_BF(REGA, PHY_REGCR) |
+			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(DATA, reg);
+		writel(i, macb_base_addr + MACB_MAN);
+		status = macb_mdio_wait_for_idle(macb_base_addr);
+		if (status < 0)
+			return status;
+
+		i = MACB_BF(SOF, MACB_MAN_SOF) |
+			MACB_BF(RW, MACB_MAN_WRITE) |
+			MACB_BF(PHYA, phy_id) |
+			MACB_BF(REGA, PHY_ADDAR) |
+			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(DATA, regnum);
+		writel(i, macb_base_addr + MACB_MAN);
+		status = macb_mdio_wait_for_idle(macb_base_addr);
+		if (status < 0)
+			return status;
+
+		reg = MACB_BF(REGCR_OP, MACB_REGCR_OP_DATA) |
+				MACB_BF(REGCR_DEVADDR, TI_PHY_DEVADDR);
+		i = MACB_BF(SOF, MACB_MAN_SOF) |
+			MACB_BF(RW, MACB_MAN_WRITE) |
+			MACB_BF(PHYA, phy_id) |
+			MACB_BF(REGA, PHY_REGCR) |
+			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(DATA, reg);
+		writel(i, macb_base_addr + MACB_MAN);
+		status = macb_mdio_wait_for_idle(macb_base_addr);
+		if (status < 0)
+			return status;
+
+		i = MACB_BF(SOF, MACB_MAN_SOF) |
+			MACB_BF(RW, MACB_MAN_WRITE) |
+			MACB_BF(PHYA, phy_id) |
+			MACB_BF(REGA, PHY_ADDAR) |
+			MACB_BF(CODE, MACB_MAN_CODE) |
+			MACB_BF(DATA, value);
+
+		writel(i, macb_base_addr + MACB_MAN);
+		status = macb_mdio_wait_for_idle(macb_base_addr);
+		if (status < 0)
+			return status;
+	}
+
+	return 0;
+}
+
+static int macb_scan_mdio(void __iomem *macb_base_addr)
+{
+	int i;
+	int phy_reg;
+	int phy_id;
+
+	for (i = 0; i < PHY_MAX_ADDR; i++) {
+		phy_reg = macb_mdiobus_read(macb_base_addr, i, MII_PHYSID1);
+		if (phy_reg < 0)
+			continue;
+
+		phy_id = (phy_reg & 0xffff) << 16;
+		phy_reg = macb_mdiobus_read(macb_base_addr, i, MII_PHYSID2);
+		if (phy_reg < 0)
+			continue;
+
+		phy_id |= (phy_reg & 0xffff);
+		if ((phy_id & 0x1fffffff) != 0x1fffffff &&
+		    phy_id == TI_PHY_DP83867_ID)
+			return i;
+	}
+
+	return -1;
+}
+
+static void macb_setup_phy(void __iomem *macb_base_addr)
+{
+	int phy_id;
+
+	// Enable MDIO
+	writel(readl(macb_base_addr + MACB_NCR) | MACB_BIT(MPE),
+	       macb_base_addr + MACB_NCR);
+
+	phy_id = macb_scan_mdio(macb_base_addr);
+	if (phy_id >= 0) {
+		if (macb_mdiobus_write(macb_base_addr, phy_id, 0xd3, 0x4000))
+			return;
+		if (macb_mdiobus_write(macb_base_addr, phy_id, 0x14, 0x29c7))
+			return;
+		if (macb_mdiobus_write(macb_base_addr, phy_id, 0x32, 0x0000))
+			return;
+		if (macb_mdiobus_write(macb_base_addr, phy_id, 0x10, 0x0800))
+			return;
+		if (macb_mdiobus_write(macb_base_addr, phy_id, 0x31, 0x1170))
+			return;
+	}
+}
+
 static int macb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int err;
@@ -44,6 +263,7 @@ static int macb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct platform_device_info plat_info;
 	struct macb_platform_data plat_data;
 	struct resource res[2];
+	void __iomem *addr;
 
 	/* enable pci device */
 	err = pcim_enable_device(pdev);
@@ -66,6 +286,11 @@ static int macb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	dev_info(&pdev->dev, "EMAC physical base addr: %pa\n",
 		 &res[0].start);
+	addr = ioremap(res[0].start, resource_size(&res[0]));
+	if (addr) {
+		macb_setup_phy(addr);
+		iounmap(addr);
+	}
 
 	/* set up macb platform data */
 	memset(&plat_data, 0, sizeof(plat_data));
-- 
2.17.1

