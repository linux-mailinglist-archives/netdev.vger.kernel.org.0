Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 989FA81E28
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbfHENzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:55:46 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:20290 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729811AbfHENzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:43 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75Dr6eF015931;
        Mon, 5 Aug 2019 09:55:36 -0400
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2051.outbound.protection.outlook.com [104.47.46.51])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6kb20e1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKjcicxI2CK0H96FktbF9KtKJy9Cs9aKkJWtfzWni9E3HD8Sphvh6ec5ekr4Wd98aZIWYNpX41N9pqEJDH58uJFvHVX0CPYTyg2bQvcFZy9QQLr1NLeH9ykyTovi2fAQUvQ//cmFE77waVgejwdbl6Sem/fVaLBWq95oUYlb8dix+L4A44TmBSI/DSDuZyT3bICmZvMFqmqZGnwK5DJQbMVZN8Y16HcgrgimctZaLGREU8Owxf7CsWyOhUggyxYC/PxUPiF68AaWMRqra8Ad58e0J3fx8LPX1rNln0BuSPLGuBsVCGW1GFVnPa36cwbyr8Z1LxspE8tes33BUlvb1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZfnRuVYtokZjwc5ec/5sEejvtx4wWrHXKXoHjeWl4M=;
 b=MWFqSDa6PlQIi+8R6yew0JVjjq/z2U055HpqFjY/7zfYYowXkCgQL8enG33J0CPgnfMfyv4/yQiwtIFgirVBVnxZ2cF48JGs+JwPF4f/P6YsDGPhNhTpwU0n8BlA8k2waz/dfsuS5p4WbQe9B6SN/xupXnBr2Yl8Pt6HgESTionQyPkp54FzcZcB2msu6jX/cwBtTZqq1IjC5WImL5f/arIo6bZLmMdF0Fs3EEc2m7gc4awAQR/SJHWzNScUKAmUzTw3LButyam8iJni4ZQjB1Y5M8pGZ4X8OH8VnkmDMtRt9WQTG/xMPvqrjDYhfo/UqnOKYlJoa79KjF3KkqzaoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZfnRuVYtokZjwc5ec/5sEejvtx4wWrHXKXoHjeWl4M=;
 b=zx2g0Zkl9D9+44BIH6QkCCOMBdUoQY9RixFtUuaWs115T830wjWiz+e0cakP7YtRj0b2gowIRMBh22Bgj8BqpdpzPj/vdF44OztKzJEJth4wTkro1F5mW6BURFTGkLjryNKpJs9lORdgO6mmlHftNm/hlPSlWWSNh7z/sTxhJRY=
Received: from BL0PR03CA0025.namprd03.prod.outlook.com (2603:10b6:208:2d::38)
 by BL0PR03MB4260.namprd03.prod.outlook.com (2603:10b6:208:6b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Mon, 5 Aug
 2019 13:55:35 +0000
Received: from BL2NAM02FT040.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::208) by BL0PR03CA0025.outlook.office365.com
 (2603:10b6:208:2d::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.13 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:35 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT040.mail.protection.outlook.com (10.152.77.193) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:35 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75DtWMW016249
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:32 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:34 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 14/16] net: phy: adin: make sure down-speed auto-neg is enabled
Date:   Mon, 5 Aug 2019 19:54:51 +0300
Message-ID: <20190805165453.3989-15-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(376002)(396003)(2980300002)(189003)(199004)(7636002)(70586007)(305945005)(70206006)(50466002)(336012)(446003)(246002)(426003)(11346002)(8676002)(126002)(36756003)(476003)(2616005)(2870700001)(5660300002)(44832011)(1076003)(47776003)(186003)(26005)(48376002)(486006)(2906002)(8936002)(50226002)(86362001)(316002)(478600001)(2201001)(6666004)(356004)(51416003)(7696005)(76176011)(4326008)(106002)(107886003)(110136005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR03MB4260;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 765ccce4-5976-4598-9656-08d719ac96cd
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BL0PR03MB4260;
X-MS-TrafficTypeDiagnostic: BL0PR03MB4260:
X-Microsoft-Antispam-PRVS: <BL0PR03MB4260C657AED80062545A860DF9DA0@BL0PR03MB4260.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: mpw++cu8PMlM91yMCgiBAPnT+Fu/j5R3RjJDYOPxjgoQPjgn0JOMfL+YGTVHn9AW3dqNxWWe4x/drzylDBsJCCc59zRY7UxIOhrWZjomzN3wg+sA1cgnceBe4tEgTToBlGcji1uSKTDdZfVauP9zZoVLXfTTHo7Eq548IrncjVbFKIKpl8wQpX4z8AhqBqj2jQd+vbiI4ZQ2J7eeOygnrFMCDAF/iU5Bx3f58FhTHEn8ycFksbPQLt2xLjauWitYTc+j622C6Frs72UseX3xA7RlAzDbSpKBDPn1YFgVi0meMYOpqZhhFZPOrmJ0puMGjiacIIBTCgagleNUQKaMxgY0Xzn/OYZuyOO8DiHf0C5nHRrMBSzHHuMREs5v90wZu+PBqokRdNb/7FXWlkufbGA9uTnY4G08199yIlLLc2E=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:35.0368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 765ccce4-5976-4598-9656-08d719ac96cd
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR03MB4260
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Down-speed auto-negotiation may not always be enabled, in which case the
PHY won't down-shift to 100 or 10 during auto-negotiation.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 86848444bd98..a1f3456a8504 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -32,6 +32,13 @@
 #define   ADIN1300_NRG_PD_TX_EN			BIT(2)
 #define   ADIN1300_NRG_PD_STATUS		BIT(1)
 
+#define ADIN1300_PHY_CTRL2			0x0016
+#define   ADIN1300_DOWNSPEED_AN_100_EN		BIT(11)
+#define   ADIN1300_DOWNSPEED_AN_10_EN		BIT(10)
+#define   ADIN1300_GROUP_MDIO_EN		BIT(6)
+#define   ADIN1300_DOWNSPEEDS_EN	\
+	(ADIN1300_DOWNSPEED_AN_100_EN | ADIN1300_DOWNSPEED_AN_10_EN)
+
 #define ADIN1300_INT_MASK_REG			0x0018
 #define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
 #define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
@@ -425,6 +432,22 @@ static int adin_config_mdix(struct phy_device *phydev)
 	return phy_write(phydev, ADIN1300_PHY_CTRL1, reg);
 }
 
+static int adin_config_downspeeds(struct phy_device *phydev)
+{
+	int reg;
+
+	reg = phy_read(phydev, ADIN1300_PHY_CTRL2);
+	if (reg < 0)
+		return reg;
+
+	if ((reg & ADIN1300_DOWNSPEEDS_EN) == ADIN1300_DOWNSPEEDS_EN)
+		return 0;
+
+	reg |= ADIN1300_DOWNSPEEDS_EN;
+
+	return phy_write(phydev, ADIN1300_PHY_CTRL2, reg);
+}
+
 static int adin_config_aneg(struct phy_device *phydev)
 {
 	int ret;
@@ -433,6 +456,10 @@ static int adin_config_aneg(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	ret = adin_config_downspeeds(phydev);
+	if (ret < 0)
+		return ret;
+
 	return genphy_config_aneg(phydev);
 }
 
-- 
2.20.1

