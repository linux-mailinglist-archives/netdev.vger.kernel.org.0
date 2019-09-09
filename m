Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 446B4AD9C5
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 15:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404862AbfIINNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 09:13:33 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:22176 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727766AbfIINNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 09:13:33 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x89D7vS7013116;
        Mon, 9 Sep 2019 09:13:24 -0400
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2056.outbound.protection.outlook.com [104.47.37.56])
        by mx0a-00128a01.pphosted.com with ESMTP id 2uv6d98j8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Sep 2019 09:13:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UrMyfSawIEu+ipsVsCWF47j1F0Up0LNWEX9m+K7c3rmWKCxGYL+7DUwq1iM6PLz1s5wAxcoBc1JPJOq31z2kZRm763gbNe6Dr4vfmnC3F6D91YOGi2Rc61CbA2cFPRpsdRlbHslhN70h4rlZgso7OhBRDhV16Q2FOq8/60hc3FMZBEpYuqNbkhspiO9A6xG8Zgx3L97mJVw/I95lFH52uYoL28+67RpA4QOeJOLKq3kReMWIQVH7hl1wPPXw/F7M8Yy1SYsTka8G8Cl+Cxnc5hB0inTrQ2I1OXWb13FdFtcTWPsKSPtn0xgzQDlu7t98ivpA5gdHOmUvvvOuSHIPbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHTB8AQhYG6PQlWsQmddx0LxUN4WRl7uEG3CstqDVHg=;
 b=JQnjqguqQplwKR4QJ59CBIL/c1MUt7zOVrU+YFCtICP4GrBO/+tfgHorUqTtqEKXta63hPFWdxBlm/bjLzdp+n9sCRKsTM9jia3quACnIpPQtq1zQ8cM4o//fBmwLeIyZKCMcrpXaCpq4SPQf42SlLMDoSWPGTAJgdmZvXEspB8y2J9Pgcm7t+YY/f6cvIy4yP1VytSh7ItqbZTIf9OzC1NxoWRT+ava3boQqCqgU0pcXSe6oDP1XWJBq4Ucof9Zp2nh1wwwdMYdi3ZVOBu10g0EZ8PiXY/P/fo0t/weauUcm1Ne3v0nm7FODcvLNMWnRHCbDp/xynxnAZXedz/oSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHTB8AQhYG6PQlWsQmddx0LxUN4WRl7uEG3CstqDVHg=;
 b=BFbuv+rP2oGk5XE0ZGf0WB2jZPiPdx9iad8C7z61lYMmdSpe/+cnLWMpxIMp3+iuOeo+OFZ5uQTG6rpMwL9BvHi0wX+W3b0UaYpg2XrApjmADVv06/ZtWYOiBD1U1ARyE/yXXz5MzM7LbnSQJeld6rddJjrqJjmC0ssQi4TKEEQ=
Received: from MWHPR03CA0004.namprd03.prod.outlook.com (2603:10b6:300:117::14)
 by DM6PR03MB3818.namprd03.prod.outlook.com (2603:10b6:5:50::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.20; Mon, 9 Sep
 2019 13:13:22 +0000
Received: from CY1NAM02FT053.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::200) by MWHPR03CA0004.outlook.office365.com
 (2603:10b6:300:117::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.14 via Frontend
 Transport; Mon, 9 Sep 2019 13:13:22 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT053.mail.protection.outlook.com (10.152.74.165) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2241.14
 via Frontend Transport; Mon, 9 Sep 2019 13:13:20 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x89DDEm9028633
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 9 Sep 2019 06:13:14 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 9 Sep 2019 09:13:18 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 2/2] net: phy: adin: implement Energy Detect Powerdown mode via phy-tunable
Date:   Mon, 9 Sep 2019 16:12:51 +0300
Message-ID: <20190909131251.3634-3-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909131251.3634-1-alexandru.ardelean@analog.com>
References: <20190909131251.3634-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(346002)(396003)(136003)(2980300002)(199004)(189003)(2870700001)(2906002)(5660300002)(11346002)(70586007)(70206006)(2201001)(86362001)(126002)(26005)(336012)(36756003)(446003)(486006)(47776003)(4326008)(2616005)(476003)(426003)(107886003)(186003)(44832011)(51416003)(8936002)(7636002)(246002)(8676002)(305945005)(7696005)(14444005)(76176011)(50226002)(356004)(6666004)(1076003)(316002)(54906003)(110136005)(106002)(50466002)(48376002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB3818;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39b74aeb-abee-4ea8-4f5e-08d735277cec
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:DM6PR03MB3818;
X-MS-TrafficTypeDiagnostic: DM6PR03MB3818:
X-Microsoft-Antispam-PRVS: <DM6PR03MB3818ADB8E134F54321F2B784F9B70@DM6PR03MB3818.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 01559F388D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: tJsfzSyhxgniaIIPizEof8bO102O/FBspb/rmrPsi4ZwcMl1/tyhtGCU0t5yq73Osthiw/8lXORlKJB6bgATu2dMTsF5w6kqbM34uIQgZ/g/pXaOd9nEcBdBE+F61jJbWlZZO39PZXQs2pveQYgYM/nj+AOmyQy4nXhVL0++Mk2CAojFuT65N77wPULnML1aOgk2OsCxDn/3/5vj5l/ux15B58E1GS8pwUOWhDzohYuIDLYoIGdVNbMi24aAl/xykS+CTG/6ZR33hVZJZ2IvbjVVzmlh2XzRMitSb9ITTlfdcUPFLO0695eUnS6atOeJX8tBjukWgyu2QqhsVmYYqWcBRnvVO0S5tFVP23PKnwRnbnPTeVhFM8Dcv6Yp9+Cc0P3qZRdKjXuHGGTI427SyjJcSIf3ol1FrqMtosSgcAo=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2019 13:13:20.5687
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39b74aeb-abee-4ea8-4f5e-08d735277cec
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3818
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-09_05:2019-09-09,2019-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909090136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver becomes the first user of the kernel's `ETHTOOL_PHY_EDPD`
phy-tunable feature.
EDPD is also enabled by default on PHY config_init, but can be disabled via
the phy-tunable control.

When enabling EDPD, it's also a good idea (for the ADIN PHYs) to enable TX
periodic pulses, so that in case the other PHY is also on EDPD mode, there
is no lock-up situation where both sides are waiting for the other to
transmit.

Via the phy-tunable control, TX pulses can be disabled if specifying 0
`tx-interval` via ethtool.

The ADIN PHY supports only fixed 1 second intervals; they cannot be
configured. That is why the acceptable values are 1,
ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL and ETHTOOL_PHY_EDPD_NO_TX (which
disables TX pulses).

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 61 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 4dec83df048d..5f5f73a58122 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -26,6 +26,11 @@
 
 #define ADIN1300_RX_ERR_CNT			0x0014
 
+#define ADIN1300_PHY_CTRL_STATUS2		0x0015
+#define   ADIN1300_NRG_PD_EN			BIT(3)
+#define   ADIN1300_NRG_PD_TX_EN			BIT(2)
+#define   ADIN1300_NRG_PD_STATUS		BIT(1)
+
 #define ADIN1300_PHY_CTRL2			0x0016
 #define   ADIN1300_DOWNSPEED_AN_100_EN		BIT(11)
 #define   ADIN1300_DOWNSPEED_AN_10_EN		BIT(10)
@@ -328,12 +333,62 @@ static int adin_set_downshift(struct phy_device *phydev, u8 cnt)
 			    ADIN1300_DOWNSPEEDS_EN);
 }
 
+static int adin_get_edpd(struct phy_device *phydev, u16 *tx_interval)
+{
+	int val;
+
+	val = phy_read(phydev, ADIN1300_PHY_CTRL_STATUS2);
+	if (val < 0)
+		return val;
+
+	if (ADIN1300_NRG_PD_EN & val) {
+		if (val & ADIN1300_NRG_PD_TX_EN)
+			/* default is 1 second */
+			*tx_interval = ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL;
+		else
+			*tx_interval = ETHTOOL_PHY_EDPD_NO_TX;
+	} else {
+		*tx_interval = ETHTOOL_PHY_EDPD_DISABLE;
+	}
+
+	return 0;
+}
+
+static int adin_set_edpd(struct phy_device *phydev, u16 tx_interval)
+{
+	u16 val;
+
+	if (tx_interval == ETHTOOL_PHY_EDPD_DISABLE)
+		return phy_clear_bits(phydev, ADIN1300_PHY_CTRL_STATUS2,
+				(ADIN1300_NRG_PD_EN | ADIN1300_NRG_PD_TX_EN));
+
+	val = ADIN1300_NRG_PD_EN;
+
+	switch (tx_interval) {
+	case 1: /* second */
+		/* fallthrough */
+	case ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL:
+		val |= ADIN1300_NRG_PD_TX_EN;
+		/* fallthrough */
+	case ETHTOOL_PHY_EDPD_NO_TX:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return phy_modify(phydev, ADIN1300_PHY_CTRL_STATUS2,
+			  (ADIN1300_NRG_PD_EN | ADIN1300_NRG_PD_TX_EN),
+			  val);
+}
+
 static int adin_get_tunable(struct phy_device *phydev,
 			    struct ethtool_tunable *tuna, void *data)
 {
 	switch (tuna->id) {
 	case ETHTOOL_PHY_DOWNSHIFT:
 		return adin_get_downshift(phydev, data);
+	case ETHTOOL_PHY_EDPD:
+		return adin_get_edpd(phydev, data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -345,6 +400,8 @@ static int adin_set_tunable(struct phy_device *phydev,
 	switch (tuna->id) {
 	case ETHTOOL_PHY_DOWNSHIFT:
 		return adin_set_downshift(phydev, *(const u8 *)data);
+	case ETHTOOL_PHY_EDPD:
+		return adin_set_edpd(phydev, *(const u16 *)data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -368,6 +425,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_set_edpd(phydev, 1);
+	if (rc < 0)
+		return rc;
+
 	phydev_dbg(phydev, "PHY is using mode '%s'\n",
 		   phy_modes(phydev->interface));
 
-- 
2.20.1

