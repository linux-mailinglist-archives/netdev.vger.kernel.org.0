Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1716A861AB
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389789AbfHHMax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:30:53 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:47936 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727649AbfHHMav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:30:51 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CRsML012779;
        Thu, 8 Aug 2019 08:30:44 -0400
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2052.outbound.protection.outlook.com [104.47.41.52])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u820jjrux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:30:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/H6OhB8TbrSkt4WkRmO8oBdehhRxGNWSgZInrDa0ZlFnQfPoMZpIWPxtA+lz5nb2589/RsBI/B6omI/TGyJcuKlWzMHD9etJ/f0Yrrm5FTcmGjh2kJ5xYMOaOlzACtKdYCauQJVALzj0Q5p45Un8hb8L7V7O3Dh0527bizbH6GxOPjiHNzR2AM7iMC0pY55bKS//7a10weB8APX4daX96T8KxBc++VYZzEHO3PBrdudj43/QiqphtRKFuyLvg5Nh/mZx2TgEDl2h0jXdMAkRqYgSfKVSLq8w+6LtQE+eidLzx2m6YOsTDuQLndMJxIrHQEztpYrSXnNLnk1QZfUTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eawoPnmHxZ2cC65gIdnjOchv1f8C9Iv6KcLaVi2/2p8=;
 b=NJ2wuJHE1B6ZH7DcwM6hSFYpeF+ijr170zEhZ2P91keM2ciSvGC7yYKOAsaFQbhC+kk1hdbPdpWJxKd+N4ru1mIRei9mCIYvtfjxhzU3q+04zsXNzLLdo0nx00KabuF/Ydw6fzVbXiDtgZxxbnG3xAqdyiSIsFiN2ZoLmarx0L9DPnG3xXslA45FDHJsYngTeCX0toYEP9BQMOd8ifwp4UuAsEV1H+fd0OLVzEZBvtBzNx16jYMWUFXMqokmjUS0MLQUZFC9TSkCAaneaW/WlW1VjCYGBOC1xzUl9QQmlo9LjCH7Xyabl9/wazmaMe4w9d3BL4UeRZGH6ee5lBMXWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eawoPnmHxZ2cC65gIdnjOchv1f8C9Iv6KcLaVi2/2p8=;
 b=IpAUGYJnLcpJXvWK00eHI2cBMRaDiRW61KhaJuwZho+i5Cl3q1/EyFPgCwDdgnLARBmOzMonXWoa8jLTGajFYAG3+jl290IA1r12f9SV91p90SRKrrIzlLRD575u7Ap219ZnsWkjKq1JiBmqfQp4xXuiCLYbyyFVtb9Ixu39cX4=
Received: from DM6PR03CA0058.namprd03.prod.outlook.com (2603:10b6:5:100::35)
 by BYAPR03MB4213.namprd03.prod.outlook.com (2603:10b6:a03:7f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.16; Thu, 8 Aug
 2019 12:30:41 +0000
Received: from SN1NAM02FT025.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::202) by DM6PR03CA0058.outlook.office365.com
 (2603:10b6:5:100::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16 via Frontend
 Transport; Thu, 8 Aug 2019 12:30:41 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT025.mail.protection.outlook.com (10.152.72.87) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:30:40 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CUetZ021214
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:30:40 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:30:39 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 04/15] net: phy: adin: add support for interrupts
Date:   Thu, 8 Aug 2019 15:30:15 +0300
Message-ID: <20190808123026.17382-5-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(396003)(39860400002)(376002)(136003)(2980300002)(189003)(199004)(26005)(86362001)(44832011)(246002)(2616005)(186003)(50226002)(11346002)(126002)(4326008)(107886003)(486006)(446003)(7696005)(36756003)(51416003)(476003)(336012)(8676002)(8936002)(70586007)(70206006)(76176011)(305945005)(426003)(7636002)(2906002)(356004)(316002)(5660300002)(6666004)(106002)(2870700001)(54906003)(478600001)(48376002)(50466002)(47776003)(14444005)(1076003)(110136005)(2201001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4213;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 309aa98c-7017-4e0a-dba9-08d71bfc39d0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BYAPR03MB4213;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4213:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4213B23D48519D03FD788BFAF9D70@BYAPR03MB4213.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Hs7psfhTaecdqSDnmMJedxzXJ2zd3kgg7YePr1MQCCcH9P7dI5SfOLpASfFIHrvwZz2TTTIRqmwwTUUMfV9YSMDBmS7pzWRUwTcP+pApzVETnbJttk6Hlx760O49wC9NQAmQZ6K+Mb4xEUMZ40ffLKsEf6E7WxMKNYCN74FG+2AP8myViSLwbsLoBsMIl7pNfCGBc1hAskYM9StZ61x+O4orirL+nomirTkq9bvxkC64PkMhLF34yBpBi0bJYNodOhBhbAXCB1NKfIEpnGHGZWiUUqWvUL4VUMGR6wIB5ishdHhTYkMY/BpH5YgvzDwjrKkFz7i7zknRwrEl1CftDhjcORXGXil1YZJ1cp1rRlP0bGcytHQlqMyml8fNo7MGlvt4ylb3FM+4c+OMhlzqyPItfCNkKJEauJHatjNH9q4=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:30:40.7518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 309aa98c-7017-4e0a-dba9-08d71bfc39d0
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4213
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support for enabling PHY interrupts that can be used by
the PHY framework to get signal for link/speed/auto-negotiation changes.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 45490fbe273b..69000fb16704 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -14,11 +14,45 @@
 #define PHY_ID_ADIN1200				0x0283bc20
 #define PHY_ID_ADIN1300				0x0283bc30
 
+#define ADIN1300_INT_MASK_REG			0x0018
+#define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
+#define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
+#define   ADIN1300_INT_ANEG_PAGE_RX_EN		BIT(6)
+#define   ADIN1300_INT_IDLE_ERR_CNT_EN		BIT(5)
+#define   ADIN1300_INT_MAC_FIFO_OU_EN		BIT(4)
+#define   ADIN1300_INT_RX_STAT_CHNG_EN		BIT(3)
+#define   ADIN1300_INT_LINK_STAT_CHNG_EN	BIT(2)
+#define   ADIN1300_INT_SPEED_CHNG_EN		BIT(1)
+#define   ADIN1300_INT_HW_IRQ_EN		BIT(0)
+#define ADIN1300_INT_MASK_EN	\
+	(ADIN1300_INT_ANEG_STAT_CHNG_EN | ADIN1300_INT_ANEG_PAGE_RX_EN | \
+	 ADIN1300_INT_LINK_STAT_CHNG_EN | ADIN1300_INT_SPEED_CHNG_EN | \
+	 ADIN1300_INT_HW_IRQ_EN)
+#define ADIN1300_INT_STATUS_REG			0x0019
+
 static int adin_config_init(struct phy_device *phydev)
 {
 	return genphy_config_init(phydev);
 }
 
+static int adin_phy_ack_intr(struct phy_device *phydev)
+{
+	/* Clear pending interrupts */
+	int rc = phy_read(phydev, ADIN1300_INT_STATUS_REG);
+
+	return rc < 0 ? rc : 0;
+}
+
+static int adin_phy_config_intr(struct phy_device *phydev)
+{
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		return phy_set_bits(phydev, ADIN1300_INT_MASK_REG,
+				    ADIN1300_INT_MASK_EN);
+
+	return phy_clear_bits(phydev, ADIN1300_INT_MASK_REG,
+			      ADIN1300_INT_MASK_EN);
+}
+
 static struct phy_driver adin_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
@@ -27,6 +61,8 @@ static struct phy_driver adin_driver[] = {
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
 		.get_features	= genphy_read_abilities,
+		.ack_interrupt	= adin_phy_ack_intr,
+		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 	},
@@ -37,6 +73,8 @@ static struct phy_driver adin_driver[] = {
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
 		.get_features	= genphy_read_abilities,
+		.ack_interrupt	= adin_phy_ack_intr,
+		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 	},
-- 
2.20.1

