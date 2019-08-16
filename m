Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1689029E
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfHPNLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:11:39 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:11472 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727302AbfHPNKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:10:44 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7GD7hkd030341;
        Fri, 16 Aug 2019 09:10:36 -0400
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2055.outbound.protection.outlook.com [104.47.33.55])
        by mx0a-00128a01.pphosted.com with ESMTP id 2ud8vhapku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 09:10:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikb63t6YtIhr22l1seyp3LN9f1a2Gynym61iw2pyuQqct6xP1dVGvTMhVEYeuwheAqwJngFmct61OayRLM9XBjCXDB4ak0ypPL6SM/115JlaITEhGbIwQFbtEa3teNXfRNOS1t2GutS6PIqtELAF2s2FR+CIkrGf7vxOtR6sQBwFpzkJBEqW4t03GYhgdhblezdlQg2bpHgwlD9o14AHafylHdWrdeEgPXwghDFbBv1bylVXGc3UVPbYM4J6stPV9L8SOObAiWYg8lkFPZuWU3IkoiTqi03+9tx7OS/8BJo6vZ3X0N5E8cz7D42Vmt9FdZvMloZ5FIP6pcEpRBuKcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtKdBgHKP6fExxlpgtUYaTHzTtwwDppznxWrAM+u+6c=;
 b=F5hHye1ObrMdtSeCWzlvQjbQBtG6XxgLhBG40Q5w5Dh229y3+5rw7WmTNqI498mRwX8lLN3eGO3tdyx9qEvyq8wo3pc2OjtS5Xho/PdbiVfb2SYKfPjhsr6CYpPA6fcO1dfXCu4xvJWdTlW4lB511G5Iq15WfNcQ+A6OOUsAy3mjSpJ1uBgZMD7CPvW2pOe4MVE6UcS/rKCT8lXJu/gxs3MI0Hu4wqxmPLLCFEIJ5VexKdEdYAJ7SanMZsgzrFzxIwL6xX4jWT687O6O9WvMsGjWtNtnENRFpxnCzZAglm+WeJ8oertPkAiHvKOpVmNBPHKgXB5j8hHwFV45lK4UoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtKdBgHKP6fExxlpgtUYaTHzTtwwDppznxWrAM+u+6c=;
 b=uZ/5n3pFGddx4++bmODEcOFB2+Qex7L7ZnCsQPU9GZhS+4rfWPlRrppBZZQMxbUsF0OyI4CpnDQnFIzdUCuw5cbXDSJRxfirxy5hQn3tYxAdRaapmz0Bbn5rLAsgpabNQND+dVOrD1tENsropkWPQZqq+Jl1a8eX2jWqNqAGm/Q=
Received: from MWHPR03CA0050.namprd03.prod.outlook.com (2603:10b6:301:3b::39)
 by DM6PR03MB3450.namprd03.prod.outlook.com (2603:10b6:5:ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.21; Fri, 16 Aug
 2019 13:10:34 +0000
Received: from BL2NAM02FT028.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::200) by MWHPR03CA0050.outlook.office365.com
 (2603:10b6:301:3b::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2178.16 via Frontend
 Transport; Fri, 16 Aug 2019 13:10:34 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT028.mail.protection.outlook.com (10.152.77.165) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 13:10:33 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7GDAXRa007887
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 16 Aug 2019 06:10:33 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 16 Aug 2019 09:10:32 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 05/13] net: phy: adin: configure RGMII/RMII/MII modes on config
Date:   Fri, 16 Aug 2019 16:10:03 +0300
Message-ID: <20190816131011.23264-6-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816131011.23264-1-alexandru.ardelean@analog.com>
References: <20190816131011.23264-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(376002)(396003)(2980300002)(199004)(189003)(316002)(336012)(44832011)(70586007)(4326008)(54906003)(106002)(110136005)(70206006)(5660300002)(48376002)(47776003)(2201001)(86362001)(50466002)(426003)(26005)(186003)(486006)(7636002)(1076003)(356004)(478600001)(50226002)(6666004)(7696005)(446003)(246002)(76176011)(2616005)(51416003)(8936002)(476003)(107886003)(36756003)(305945005)(14444005)(11346002)(126002)(8676002)(2906002)(2870700001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB3450;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb9c9413-d602-4608-ee43-08d7224b1f3c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM6PR03MB3450;
X-MS-TrafficTypeDiagnostic: DM6PR03MB3450:
X-Microsoft-Antispam-PRVS: <DM6PR03MB34503EF62ECC2C228CF984F0F9AF0@DM6PR03MB3450.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: rJCCMj6Vs5IyJc2CxJTFfaQGc55rhretdrRw7Ee0j4iH4Dm1OBIq+xmLz1CzlzCf21jfnj4LMc6YVyIDzpy8cEacFOBGwR3NS95OTWN+5pSEUzcwjitJsG1bnMJeieK5xp0bi9fHoSaWbd8sSm6CTmDobh7XnKawMc2kNoE9qVT/lZjjoNddKQP2heH5v0dgAFPejnGWIJnfGe7YJLJ4/6jzD93RPsp5YPfK0E7jsqRZB/9JaaxdY/T58a0DY1vMZIlSndtotpHMHcdSXJhXVhWgPdLGaL7lNUI43Lyq/5clMHeIAz0OiXR90og//9rqwIyi0OuVXjvj1NtWtOpxw6F5GUDLYcguBvcNRGQqsyW4qrM/redfXxuVqqq803ddfRKJVdnvMHMTXlm7ucr7Dvncb6Spe68taXJi860jqc8=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 13:10:33.7052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb9c9413-d602-4608-ee43-08d7224b1f3c
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3450
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

The ADIN1300 chip supports RGMII, RMII & MII modes. Default (if
unconfigured) is RGMII.
This change adds support for configuring these modes via the device
registers.

For RGMII with internal delays (modes RGMII_ID,RGMII_TXID, RGMII_RXID),
the default delay is 2 ns. This can be configurable and will be done in
a subsequent change.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 79 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index efbb732f0398..badca6881c6c 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -31,9 +31,86 @@
 	(ADIN1300_INT_LINK_STAT_CHNG_EN | ADIN1300_INT_HW_IRQ_EN)
 #define ADIN1300_INT_STATUS_REG			0x0019
 
+#define ADIN1300_GE_RGMII_CFG_REG		0xff23
+#define   ADIN1300_GE_RGMII_RXID_EN		BIT(2)
+#define   ADIN1300_GE_RGMII_TXID_EN		BIT(1)
+#define   ADIN1300_GE_RGMII_EN			BIT(0)
+
+#define ADIN1300_GE_RMII_CFG_REG		0xff24
+#define   ADIN1300_GE_RMII_EN			BIT(0)
+
+static int adin_config_rgmii_mode(struct phy_device *phydev)
+{
+	int reg;
+
+	if (!phy_interface_is_rgmii(phydev))
+		return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+					  ADIN1300_GE_RGMII_CFG_REG,
+					  ADIN1300_GE_RGMII_EN);
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_RGMII_CFG_REG);
+	if (reg < 0)
+		return reg;
+
+	reg |= ADIN1300_GE_RGMII_EN;
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
+		reg |= ADIN1300_GE_RGMII_RXID_EN;
+	} else {
+		reg &= ~ADIN1300_GE_RGMII_RXID_EN;
+	}
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
+		reg |= ADIN1300_GE_RGMII_TXID_EN;
+	} else {
+		reg &= ~ADIN1300_GE_RGMII_TXID_EN;
+	}
+
+	return phy_write_mmd(phydev, MDIO_MMD_VEND1,
+			     ADIN1300_GE_RGMII_CFG_REG, reg);
+}
+
+static int adin_config_rmii_mode(struct phy_device *phydev)
+{
+	int reg;
+
+	if (phydev->interface != PHY_INTERFACE_MODE_RMII)
+		return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+					  ADIN1300_GE_RMII_CFG_REG,
+					  ADIN1300_GE_RMII_EN);
+
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_RMII_CFG_REG);
+	if (reg < 0)
+		return reg;
+
+	reg |= ADIN1300_GE_RMII_EN;
+
+	return phy_write_mmd(phydev, MDIO_MMD_VEND1,
+			     ADIN1300_GE_RMII_CFG_REG, reg);
+}
+
 static int adin_config_init(struct phy_device *phydev)
 {
-	return genphy_config_init(phydev);
+	int rc;
+
+	rc = genphy_config_init(phydev);
+	if (rc < 0)
+		return rc;
+
+	rc = adin_config_rgmii_mode(phydev);
+	if (rc < 0)
+		return rc;
+
+	rc = adin_config_rmii_mode(phydev);
+	if (rc < 0)
+		return rc;
+
+	phydev_dbg(phydev, "PHY is using mode '%s'\n",
+		   phy_modes(phydev->interface));
+
+	return 0;
 }
 
 static int adin_phy_ack_intr(struct phy_device *phydev)
-- 
2.20.1

