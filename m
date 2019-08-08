Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4939861C2
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389878AbfHHMbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:31:08 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:31676 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389798AbfHHMbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:31:04 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CRscB002141;
        Thu, 8 Aug 2019 08:30:57 -0400
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2054.outbound.protection.outlook.com [104.47.46.54])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfkv4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:30:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4A09v1LsdjI93nIrKJkR1R6dcwHcUbROCBdEiNEVhQWVTSDbHfDQ/Pe5VIoViU56wpVU3bx/rKxEK4q5LYdX1dHUyCfijc2Xd9HefV9valdkcx/1bZnZvT3tQuqWU9DmIU9HiiTwmiBeyiNocxD6+uBrEhk+YOcrAqhihQsfUTO2gWL27ku58y8qsFJVtH+z1ff14i/RZzBQkm29A69zX9MiQ8v2Lky/eU33pM33Z0X9oKoCzdEhNXROMy2sD2N17LArtJiP5qeGelNhcz2VXMNwT6+JqoCw47q1LrkmB6v/OAQ2cSCmxZvqhF6tJl0HMdl9x0tQkv0h1WmXTsOIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHPXD4spCXJ5uLs1jP2uoypa0o9tVtiQQM02OQbEPcU=;
 b=P/jAKc28cOsWOoMzGKIJqiWAwXghG2KXFIrXwwBfRzP49iPn+bT4FnFHICPgPJrIs8ZUz42t4+KTNR/ofoEBcJHHR+bANaJEpFBK9VfxbtCQMdaftoG+eE1CmTLG8XXYYy/RRnh+BghmG32JUNw9JZMlxiMlVfKntDw9lp53kdnKEeaeoHsk8Jjk4FjHc4kjguaYSyc5Cl5wlWRHscM674TTZm3jIubNoozOsF9B84FB8zql/q4eHGutLzOzJeTuaAB1w02Ml3jcZIAdnj8At8xN9dOMUriJwmfnqXiRfXRrzWSrwOIOM/geCuz0G9/CRvo1KKZ9AvALdjb6r6xnmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHPXD4spCXJ5uLs1jP2uoypa0o9tVtiQQM02OQbEPcU=;
 b=bz2bTKVsJWlbPSTw+i+kvjUtTns5Dnlr0wlENe8lSVhgPo/CPmVqPxJAetDViYEEdvzI+BEBIoPtZox5EmgrRXG7nOKXPnK3WXz98vCwTufYhXb7IxyrFVrX+zvWG0iAShmcUl9KTIzxH+MYnKp8nYxr5IhxNig5dF6dXA5qgZI=
Received: from BN6PR03CA0012.namprd03.prod.outlook.com (2603:10b6:404:23::22)
 by MN2PR03MB4895.namprd03.prod.outlook.com (2603:10b6:208:101::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Thu, 8 Aug
 2019 12:30:55 +0000
Received: from CY1NAM02FT038.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::202) by BN6PR03CA0012.outlook.office365.com
 (2603:10b6:404:23::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Thu, 8 Aug 2019 12:30:55 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT038.mail.protection.outlook.com (10.152.74.217) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:30:55 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CUsJW021273
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:30:54 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:30:53 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 11/15] net: phy: adin: implement PHY subsystem software reset
Date:   Thu, 8 Aug 2019 15:30:22 +0300
Message-ID: <20190808123026.17382-12-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(39860400002)(376002)(2980300002)(199004)(189003)(316002)(107886003)(47776003)(486006)(126002)(11346002)(476003)(44832011)(2616005)(426003)(446003)(336012)(2906002)(305945005)(7636002)(2870700001)(246002)(8676002)(50466002)(186003)(6666004)(356004)(86362001)(2201001)(5660300002)(48376002)(1076003)(76176011)(26005)(7696005)(51416003)(110136005)(106002)(54906003)(36756003)(70586007)(70206006)(4326008)(14444005)(8936002)(50226002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR03MB4895;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7df3606d-866a-48f7-479e-08d71bfc4262
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:MN2PR03MB4895;
X-MS-TrafficTypeDiagnostic: MN2PR03MB4895:
X-Microsoft-Antispam-PRVS: <MN2PR03MB489546F9866DCE43E910B667F9D70@MN2PR03MB4895.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: mNZAOPDz+abW2CBRHPa3g8V9ZypOt59wzbIu6tOC8/suzPZGjo8ZiHAm15ewDHHwMuqPW2NUACSBLjGrhgfDutum1ybugLGeP/UuRyjDfKfqxxMB5Hb8dHZ9T/YVV6HGLqmmfnaVrzQUV9LmEO49Lsg2spkaXciYFz7lBXp1nqvP09tG0gHT8jspRA54GPLWaXudZ+wasXkqbjy0p0J6SJGLL+htfNfEZyNdKQp96T46NylJ6RGn8fgAjQmU3j1SjksquoxI82jNe+ZrUkeKNA7kXeQ1Mz8tnwZ9fjbx8Q6yuPFfTiHfOhoRR8iWxCcIvGX/l7YTqnjuNv7aSLuoYIEU2TrchhtDVAbevrhNzm9MqMLPm4QvbfFAnCCGIxqh3zzlORc3za4+VwmCNz8PZMUjTTLrqMm0g8t34HBorA8=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:30:55.0215
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7df3606d-866a-48f7-479e-08d71bfc4262
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB4895
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=911 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080130
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
index c1cea1b6bd75..f276d692bdee 100644
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
 		.get_features	= genphy_read_abilities,
@@ -476,6 +518,7 @@ static struct phy_driver adin_driver[] = {
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
 		.name		= "ADIN1300",
 		.config_init	= adin_config_init,
+		.probe		= adin_probe,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
 		.get_features	= genphy_read_abilities,
-- 
2.20.1

