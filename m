Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2A5C87B63
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406724AbfHINg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:36:29 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:32264 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406643AbfHINg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:27 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DMxgl010843;
        Fri, 9 Aug 2019 09:36:19 -0400
Received: from nam05-by2-obe.outbound.protection.outlook.com (mail-by2nam05lp2056.outbound.protection.outlook.com [104.47.50.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u8tcbtf89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bERwdLE/eUOlo/5x5QgyTcLlqwZ0eZBnw+JKS77JPsRN/9MzdIvT0OTRWDfSNW3FoF7R3JhriIH3iLahI6wqFuBBagkqINcJq4vQtyXnH1vMcHiZtwb1lQR1Kf1qXUgCFo2cPnMDjlF/fBXwtvHC873o3PQ8yKztgRdC440IMWy+wsgOil2CAh9WAqiFHJ31RzvUWXEd6HB3/QIjVFoSkjlPm7mcjhpzefS5GYGaKAIM5lTYkkL/oWH7np+6cY2uzvZ+meorU/rn98VGA7gqTPwlV2cwPFCR6d/YsHUCtlAzhtAEDr3DBtq4VhwkVMRVpuskN5F/FUL2O+FLAb+/3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MeH+Io8HFjMDUCb4aqGS1tQWa+Wj116isaCZmGl7B3s=;
 b=RKG4Qciw2c0Rpl5SeU5IFUzrEc7mFD5MxW0doddv+AuM5qtQBUiQPlRjD4aJuddApuyeKC3ljdlu9ZedRRQpjb7tzPi5a+LWR8/q3RYVUuv5cj3psIayLaXJsTC62JX7lB/kZ5Ol6O6sN5zwqwDIfqCQwP4BqfwURvUkze8wcRXsmlufjS9FQS6QaH5LhGY+hvBx+QvkG3GGkblKWJu+f/crtBTnMKOl5PlSOpEcNQp7FnRMUNN2sgYu2227+8NJTPRI1bKmJRaEwd3XyTRqGfYrmv7MEv5mx8gqtF99cjlH3MiDhclIGsuBEYykZsWGbasA8VnF++X2jyZDj9rbVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MeH+Io8HFjMDUCb4aqGS1tQWa+Wj116isaCZmGl7B3s=;
 b=Hdz815q4t3OAIgJYFyyCFzfzhH4L9zceA6UlzJ+Q10mxk615EF02oVU0pV1jDbCmY2OczDyOScWcSLhq4finKxpQKqIKpcy3cvApAzSIA39mF4FgmGvnLn/EKTFJ37jeWoemfB3NM1EXBa6bQFj96hTsaE4TEdzshkohYCboqRM=
Received: from CY1PR03CA0024.namprd03.prod.outlook.com (2603:10b6:600::34) by
 DM6PR03MB4153.namprd03.prod.outlook.com (2603:10b6:5:5c::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Fri, 9 Aug 2019 13:36:17 +0000
Received: from BL2NAM02FT052.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::201) by CY1PR03CA0024.outlook.office365.com
 (2603:10b6:600::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.16 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:17 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT052.mail.protection.outlook.com (10.152.77.0) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:36:17 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79DaHId025736
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:36:17 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:36:16 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 10/14] net: phy: adin: implement PHY subsystem software reset
Date:   Fri, 9 Aug 2019 16:35:48 +0300
Message-ID: <20190809133552.21597-11-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(346002)(396003)(2980300002)(189003)(199004)(305945005)(50226002)(5660300002)(8936002)(86362001)(2870700001)(106002)(2201001)(107886003)(47776003)(1076003)(14444005)(4326008)(126002)(2906002)(2616005)(476003)(336012)(44832011)(486006)(11346002)(7636002)(426003)(446003)(36756003)(48376002)(50466002)(316002)(110136005)(70206006)(186003)(70586007)(54906003)(76176011)(7696005)(51416003)(478600001)(26005)(246002)(356004)(8676002)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB4153;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d37c69da-2ee1-46a9-02e4-08d71cce8e72
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:DM6PR03MB4153;
X-MS-TrafficTypeDiagnostic: DM6PR03MB4153:
X-Microsoft-Antispam-PRVS: <DM6PR03MB4153BF1F31D902E21856D923F9D60@DM6PR03MB4153.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 5zuvhsRqE6ZBbu572qbDF9IZvjW0pgTd4I9qIJYT7xGIDkAsfUbWUqWW1V353ubF/V+K2aTS5Hk+TG3gGIK9mhebEz/2qOB92dMpfG6WGeMgiqRkKJK644qQqkPZa2vStEqGh14M3XVUGqiwaTqSAkZU0lVPADB3B5V/ckNnXqmb7rx9QZvDJ7P/S+jOgP82LYlkY43HQ6+Zgahf+UwXpSl0Wf9OYjREFUQeXwKKfG+nhnj5O8FnF6gqvNsJGpsMK8gjaCINnD4zFE3CIrhNP0rPLaR1xuSjfDTIt5FQHctRgKxQtAftYugMyeiLCf5O5AhdVyrIIojrm4K2nFxGcs25lCKMO9//9WYCWR03CZgZcer6SyacWR5wZRdRRqF6+lyaKGYj9eSKnxSSbB1EMvpVJz5lu/wL+fG152FQxYo=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:36:17.3920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d37c69da-2ee1-46a9-02e4-08d71cce8e72
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB4153
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=788 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN PHYs supports 4 types of reset:
1. The standard PHY reset via BMCR_RESET bit in MII_BMCR reg
2. Reset via GPIO
3. Reset via reg GeSftRst (0xff0c) & reload previous pin configs
4. Reset via reg GeSftRst (0xff0c) & request new pin configs

Resets 2 & 4 are almost identical, with the exception that the crystal
oscillator is available during reset for 2.

As it turns out, phylib already supports GPIO reset.
In case this is configured, the PHY driver won't do anything. In case it
isn't specified the subsystem software reset will kick in.

Resetting via GeSftRst or via GPIO is useful when doing a warm reboot,
because this will reset the subsystem registers to default values.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index bd002103f083..63b57c83de91 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -6,6 +6,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/bitfield.h>
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -53,6 +54,9 @@
 #define ADIN1300_CLOCK_STOP_REG			0x9400
 #define ADIN1300_LPI_WAKE_ERR_CNT_REG		0xa000
 
+#define ADIN1300_GE_SOFT_RESET_REG		0xff0c
+#define   ADIN1300_GE_SOFT_RESET		BIT(0)
+
 #define ADIN1300_GE_RGMII_CFG_REG		0xff23
 #define   ADIN1300_GE_RGMII_RX_MSK		GENMASK(8, 6)
 #define   ADIN1300_GE_RGMII_RX_SEL(x)		\
@@ -457,11 +461,49 @@ static int adin_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
+static int adin_subsytem_soft_reset(struct phy_device *phydev)
+{
+	int reg, rc, i;
+
+	rc = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+			      ADIN1300_GE_SOFT_RESET_REG,
+			      ADIN1300_GE_SOFT_RESET);
+	if (rc < 0)
+		return rc;
+
+	for (i = 0; i < 20; i++) {
+		usleep_range(500, 1000);
+		reg = phy_read_mmd(phydev, MDIO_MMD_VEND1,
+				   ADIN1300_GE_SOFT_RESET_REG);
+		if (reg < 0 || (reg & ADIN1300_GE_SOFT_RESET))
+			continue;
+		return 0;
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int adin_reset(struct phy_device *phydev)
+{
+	/* If there is a reset GPIO just exit */
+	if (!IS_ERR_OR_NULL(phydev->mdio.reset_gpio))
+		return 0;
+
+	/* Reset PHY core regs & subsystem regs */
+	return adin_subsytem_soft_reset(phydev);
+}
+
+static int adin_probe(struct phy_device *phydev)
+{
+	return adin_reset(phydev);
+}
+
 static struct phy_driver adin_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
 		.name		= "ADIN1200",
 		.config_init	= adin_config_init,
+		.probe		= adin_probe,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
 		.ack_interrupt	= adin_phy_ack_intr,
@@ -475,6 +517,7 @@ static struct phy_driver adin_driver[] = {
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
 		.name		= "ADIN1300",
 		.config_init	= adin_config_init,
+		.probe		= adin_probe,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
 		.ack_interrupt	= adin_phy_ack_intr,
-- 
2.20.1

