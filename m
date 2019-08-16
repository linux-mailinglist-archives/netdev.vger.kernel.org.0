Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31BA490291
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfHPNLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:11:17 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:11328 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727397AbfHPNK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:10:57 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7GD7fgw024761;
        Fri, 16 Aug 2019 09:10:49 -0400
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2052.outbound.protection.outlook.com [104.47.34.52])
        by mx0b-00128a01.pphosted.com with ESMTP id 2udnnugxup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 09:10:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzlKZZgyWbSNze4mWQRIUP1nuQeKUFn51uNthgnPrwoqUMXLpxPXlOH7HZqAuYL0/d7ycTex+P8H5X3b97oAd086sGYtjRxMV/DylDM/OLIx6IezEKxKa06zQPMSkXoIZnL76S6LP/DnVy9D/lG7E2DyFFtFA5p8T8o8UikUzg6dS+S9lsdzzwwgNk/Gbv0cuS6L/coTRHDwS6TNmxTzDZ6yOWYeabENhjBqybNw+WpQf+u+EgVn84tnPlIyQtHCdrmkrAudoc7UIvdLrZw23U3/fG3tHFZe03DS/GsV6wbl+nlddm81qACwxwjef0oSq3GF4kPrOM5pCBWwlPwSHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZJVMnQJrHXGL224uMIEquhM58DusloZ3X8ANgJz8iI=;
 b=OPTCBwLOMMHXS/YXWEZCWcZmMOYWGaFlkwDse1n19raQU6+sSNRqHjZxBMmnxQUUaumI9itQj+O/jYfNJZXKSelH3IUK0Nzom/RdWqjaeJtGo15ckGRDPURKdJm6m7hwv3N+dYvLxvYL+OC75AV/aDIWHo0pMzKTlfI3MVxOu+omH1eUAK3koLFSF86I9dJd9Am36rxWDCWRDWW0cxy6uAQoVOWq8y6ffPsWUVDB4YRrhi5yCESvs5uI2lKPx1zv2fdnPHr69Miu9QpfSS+bAF3gH2LXoE6g5ScWxVXO+leoLAmeAEGP02MRYKS8ZPxL4T3GWRxTTYNoLlHuqiyC2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZJVMnQJrHXGL224uMIEquhM58DusloZ3X8ANgJz8iI=;
 b=BXIfKt79bRp8OderbxUFiYBEvJgysmtBWbDvhmf725fkQeRE8iViF8FSs+ItZtlGp1JdVuM8r3LMjUAR+7Y3CbovBrRc52+PaHzgfXJNwPJU0vVolBuj2EqjACMpViS3G8z2aJ4e3uN4hC81rOs6I7agjs5ExwOrYZmAtZt8GTw=
Received: from BYAPR03CA0010.namprd03.prod.outlook.com (2603:10b6:a02:a8::23)
 by BL0PR03MB4258.namprd03.prod.outlook.com (2603:10b6:208:63::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Fri, 16 Aug
 2019 13:10:47 +0000
Received: from SN1NAM02FT027.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::204) by BYAPR03CA0010.outlook.office365.com
 (2603:10b6:a02:a8::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2178.16 via Frontend
 Transport; Fri, 16 Aug 2019 13:10:46 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT027.mail.protection.outlook.com (10.152.72.99) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 13:10:46 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7GDAj1P007936
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 16 Aug 2019 06:10:45 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 16 Aug 2019 09:10:45 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 11/13] net: phy: adin: implement downshift configuration via phy-tunable
Date:   Fri, 16 Aug 2019 16:10:09 +0300
Message-ID: <20190816131011.23264-12-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816131011.23264-1-alexandru.ardelean@analog.com>
References: <20190816131011.23264-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(376002)(39860400002)(2980300002)(199004)(189003)(50226002)(446003)(6666004)(51416003)(76176011)(2201001)(7696005)(186003)(26005)(70206006)(70586007)(305945005)(7636002)(8676002)(246002)(356004)(2870700001)(478600001)(86362001)(1076003)(110136005)(426003)(2906002)(8936002)(4326008)(50466002)(316002)(5660300002)(54906003)(486006)(106002)(11346002)(107886003)(126002)(336012)(48376002)(2616005)(44832011)(47776003)(36756003)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR03MB4258;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1561daf8-6085-4b1b-2110-08d7224b26f3
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BL0PR03MB4258;
X-MS-TrafficTypeDiagnostic: BL0PR03MB4258:
X-Microsoft-Antispam-PRVS: <BL0PR03MB4258FA8157745B235A2AA9A2F9AF0@BL0PR03MB4258.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 9ckVLQXviR2+nzexFgjYxB4tOtxy6NqRYqhJxpbM8bYaNCYdLB/knTyjI5sa/vj8VUMzfnOjfvv5Nvjy4WVcWy8IFbeMyJUcl5Eu5Q6Eb+YVHVDCBGtGs738nwAq73A2ofZHrhvjT+lJFGvC1FxZxvqf3uoisocydYwyLnFKfrYeI2KjkRlCGkJ18VlRd0/LQn/7anvj2buc+FAD/oGmZG78U9QgkThobV1q9rcMwHkB7eygf10xaahvfmbb88NBiiq6XWewJ4/5h9BKWKNr3KgsfklzZD38DVUNaxitiLiXXB+Q7oKUr/5dy/U6mFU9gIcwJpTZr1i+EniENuoLuRobyx3MqZkqoa1xDEIRPojw+Q40iJwU3tHX7LygnnMw9BWasZacaGbauDY6M9yCGlYBYKOeEXUholZf2vbYUbA=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 13:10:46.3270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1561daf8-6085-4b1b-2110-08d7224b26f3
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR03MB4258
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=922 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Down-speed auto-negotiation may not always be enabled, in which case the
PHY won't down-shift to 100 or 10 during auto-negotiation.

This change enables downshift and configures the number of retries to
default 4 (which is also in the datasheet

The downshift control mechanism can also be controlled via the phy-tunable
interface (ETHTOOL_PHY_DOWNSHIFT control).

The change has been adapted from the Aquantia PHY driver.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 86 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 5622a393e7cf..131b577a17e5 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -24,6 +24,17 @@
 #define   ADIN1300_AUTO_MDI_EN			BIT(10)
 #define   ADIN1300_MAN_MDIX_EN			BIT(9)
 
+#define ADIN1300_PHY_CTRL2			0x0016
+#define   ADIN1300_DOWNSPEED_AN_100_EN		BIT(11)
+#define   ADIN1300_DOWNSPEED_AN_10_EN		BIT(10)
+#define   ADIN1300_GROUP_MDIO_EN		BIT(6)
+#define   ADIN1300_DOWNSPEEDS_EN	\
+	(ADIN1300_DOWNSPEED_AN_100_EN | ADIN1300_DOWNSPEED_AN_10_EN)
+
+#define ADIN1300_PHY_CTRL3			0x0017
+#define   ADIN1300_LINKING_EN			BIT(13)
+#define   ADIN1300_DOWNSPEED_RETRIES_MSK	GENMASK(12, 10)
+
 #define ADIN1300_INT_MASK_REG			0x0018
 #define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
 #define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
@@ -243,6 +254,73 @@ static int adin_config_rmii_mode(struct phy_device *phydev)
 			     ADIN1300_GE_RMII_CFG_REG, reg);
 }
 
+static int adin_get_downshift(struct phy_device *phydev, u8 *data)
+{
+	int val, cnt, enable;
+
+	val = phy_read(phydev, ADIN1300_PHY_CTRL2);
+	if (val < 0)
+		return val;
+
+	cnt = phy_read(phydev, ADIN1300_PHY_CTRL3);
+	if (cnt < 0)
+		return cnt;
+
+	enable = FIELD_GET(ADIN1300_DOWNSPEEDS_EN, val);
+	cnt = FIELD_GET(ADIN1300_DOWNSPEED_RETRIES_MSK, cnt);
+
+	*data = (enable && cnt) ? cnt : DOWNSHIFT_DEV_DISABLE;
+
+	return 0;
+}
+
+static int adin_set_downshift(struct phy_device *phydev, u8 cnt)
+{
+	u16 val;
+	int rc;
+
+	if (cnt == DOWNSHIFT_DEV_DISABLE)
+		return phy_clear_bits(phydev, ADIN1300_PHY_CTRL2,
+				      ADIN1300_DOWNSPEEDS_EN);
+
+	if (cnt > 7)
+		return -E2BIG;
+
+	val = FIELD_PREP(ADIN1300_DOWNSPEED_RETRIES_MSK, cnt);
+	val |= ADIN1300_LINKING_EN;
+
+	rc = phy_modify(phydev, ADIN1300_PHY_CTRL3,
+			ADIN1300_LINKING_EN | ADIN1300_DOWNSPEED_RETRIES_MSK,
+			val);
+	if (rc < 0)
+		return rc;
+
+	return phy_set_bits(phydev, ADIN1300_PHY_CTRL2,
+			    ADIN1300_DOWNSPEEDS_EN);
+}
+
+static int adin_get_tunable(struct phy_device *phydev,
+			    struct ethtool_tunable *tuna, void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return adin_get_downshift(phydev, data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int adin_set_tunable(struct phy_device *phydev,
+			    struct ethtool_tunable *tuna, const void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return adin_set_downshift(phydev, *(const u8 *)data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int adin_config_init(struct phy_device *phydev)
 {
 	int rc;
@@ -261,6 +339,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_set_downshift(phydev, 4);
+	if (rc < 0)
+		return rc;
+
 	phydev_dbg(phydev, "PHY is using mode '%s'\n",
 		   phy_modes(phydev->interface));
 
@@ -474,6 +556,8 @@ static struct phy_driver adin_driver[] = {
 		.soft_reset	= adin_soft_reset,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
+		.get_tunable	= adin_get_tunable,
+		.set_tunable	= adin_set_tunable,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
@@ -488,6 +572,8 @@ static struct phy_driver adin_driver[] = {
 		.soft_reset	= adin_soft_reset,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
+		.get_tunable	= adin_get_tunable,
+		.set_tunable	= adin_set_tunable,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
-- 
2.20.1

