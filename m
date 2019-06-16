Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27CA64737C
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 09:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfFPHFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 03:05:18 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:45460 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725860AbfFPHFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 03:05:18 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5G723km015343;
        Sun, 16 Jun 2019 00:05:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=2871iQuj6mhD0LeWxbihfTlXitwpwttJ3+TrYK5cMjw=;
 b=DI8QVidCozASU3rBKQnFWEQs3MamCt9D2WgBUCBq8FuvBwOXEllR67eeKrEyCD0SjjDt
 Br3sPkOtr/kg3zhIOvHcCXG+Ip6lRDhDud5amTx47CTgDO3AX6qT1uLsyU9W1D9z9q9C
 /IejymaDwUgrca1UADYYxV8n+g1CZ26I5oZdnDnTOMjmxjlIBcV29Lmo4PzRl6hPcWXC
 6Y7gySHOokUMEUqi31zHDcT7ymdyWMxzfngknik43W5HkWfrJI5bynqkHB6nIXUyfyrs
 8//9mRFyHbjATYuzo4+UlQXbmNoaxsHx1kGo9H5Jmv8hrboKi/sv0euoBnN+yp8bFHfD /g== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2051.outbound.protection.outlook.com [104.47.42.51])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t4w7v2gn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 16 Jun 2019 00:05:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2871iQuj6mhD0LeWxbihfTlXitwpwttJ3+TrYK5cMjw=;
 b=l86Y4sfsjLdAa9xZxQRQZvAzOuOJWc+vwoNutTzYkmxgZH3oxVqMTNhzSNosyRQcYY++hn98/Cq9Hp597Xyq0+m0ZN6Uuy4x+WXAhEXc0ycB7yfT0Gzet3Du80JIFqXOAvTaomXxD54p2vRJyDy6NNhCClhxEbIG7IjpHyOg2xs=
Received: from BYAPR07CA0094.namprd07.prod.outlook.com (2603:10b6:a03:12b::35)
 by BYAPR07MB6821.namprd07.prod.outlook.com (2603:10b6:a03:128::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1987.12; Sun, 16 Jun
 2019 07:05:09 +0000
Received: from DM3NAM05FT047.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::208) by BYAPR07CA0094.outlook.office365.com
 (2603:10b6:a03:12b::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1987.13 via Frontend
 Transport; Sun, 16 Jun 2019 07:05:09 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 DM3NAM05FT047.mail.protection.outlook.com (10.152.98.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2008.7 via Frontend Transport; Sun, 16 Jun 2019 07:05:08 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x5G756et022175
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sun, 16 Jun 2019 00:05:07 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sun, 16 Jun 2019 09:05:05 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 16 Jun 2019 09:05:04 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5G755q1022400;
        Sun, 16 Jun 2019 08:05:05 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <rafalc@cadence.com>,
        <aniljoy@cadence.com>, <piotrs@cadence.com>, <pthombar@cadence.com>
Subject: [PATCH 3/6] net: macb: add PHY configuration in MACB PCI wrapper
Date:   Sun, 16 Jun 2019 08:05:03 +0100
Message-ID: <1560668703-22357-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1560639680-19049-1-git-send-email-pthombar@cadence.com>
References: <1560639680-19049-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(346002)(376002)(2980300002)(189003)(199004)(36092001)(2906002)(7636002)(16586007)(26005)(316002)(26826003)(70206006)(70586007)(76130400001)(356004)(5660300002)(486006)(2201001)(478600001)(4326008)(107886003)(8676002)(7696005)(47776003)(11346002)(476003)(126002)(305945005)(51416003)(186003)(86362001)(336012)(446003)(54906003)(426003)(8936002)(7126003)(2616005)(50226002)(246002)(53416004)(76176011)(77096007)(50466002)(48376002)(110136005)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR07MB6821;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a710c3ce-3bd1-4114-b3ca-08d6f228f7d8
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:BYAPR07MB6821;
X-MS-TrafficTypeDiagnostic: BYAPR07MB6821:
X-Microsoft-Antispam-PRVS: <BYAPR07MB68219790F2ADD37D930C3FBBC1E80@BYAPR07MB6821.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-Forefront-PRVS: 0070A8666B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: oSHxJtYjOdi82COqV4v84feTNkrFyxPwPtYnU1H13RkAKjObNadJGAERR+/Hjhq5chJS0s6JCGshmGrc1ZjTjBESjCgIZet0HVm4v21tOlc/LClWI2kDZ6uPdQV+7fTxm8MrcbcGZwQjlYk2aumu+0VA9c0wQMocidRIzQTTTBNN9mfZ5IWvQ6xswyVnUpZD4qHR2pmME5sduy/E0WLxV/ULtWW8GbeLSaYhWeMBqg1gFuBptm68YIvcu1dwjZRT1MsP+GV8stla47pXzA2cL3XKjn9ouFOVSu1JtXHeGLub7Y6NfXKVdyPqA5sYsimTdZQdVQaFFfUXQv8R4+n3hu1+xyHk/MO0aDyL7JG0t3nzMcS17jjnaZqN1LHRn43ruWGR1XJudV6n2xDdK+jzjDHysWoHKdABdCgqDV7hnKA=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2019 07:05:08.5418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a710c3ce-3bd1-4114-b3ca-08d6f228f7d8
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB6821
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-16_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906160067
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

