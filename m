Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D09A846F
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 15:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730289AbfIDNYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:24:00 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:8852 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727675AbfIDNX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:23:59 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x84DNOWC027885;
        Wed, 4 Sep 2019 09:23:55 -0400
Received: from nam05-by2-obe.outbound.protection.outlook.com (mail-by2nam05lp2057.outbound.protection.outlook.com [104.47.50.57])
        by mx0b-00128a01.pphosted.com with ESMTP id 2uqnh5fpj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 09:23:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Az0F+JLxJODL3eUPBe67Msjkzeor1WD2jGWofgvyUw8wulZBXy49gg52q2f3uaGnNLOvQ5WDva+1HQ7c4haSJin91kk9heKg+LIvBBL65I0MIcUzQ1eg3HUOa29zxhjJ9br8mTC0ZDL4SgEYvsnaaEEqXpYNHg7Y2x0WN2IDN+QuScFGk4sZXiLeE/NRoef+CFqFqy/OPl0a+cUJcbH1aYyXTi11Dy/fOTfqDiPeCFf4h0Fu0Rh3GpZJi6Q7Layk4GvU1xKCIwSwBqu5+1SBRY+laqvpiR7Bzd1KwLVMiFVztYFbPJOVgLy42ZlmB4LU7eeA4PjixJVKYz9qXLdJnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RvpRXjaK49Pl+OJZXrl2LvhnlYwDN+zG08M/5anhrLo=;
 b=Hm81OiD6MOwJg9KHCcDwK0l3ETTKGV6NzFW8M5Uccddvmd528O0i58PJ+0O1a1//GNh6uTHDelg7Ob5aeQ19LGUNlOg8G4c0jnLQf8W5RP+IfWXrf4WrpSkK6RjcHop9nxgDO9aq8tvUe5WG+PmxwroISuNAgHVWaz295iYqj+Y8yLpbvAER+VwDbvyQRM4RQahUjiFCurISl99laa+bc56BVK+tT7tJLG5n19y/ZnG9Bnq11f4c3odnqQJr0R41N5wphYWvIuAgnNL2gGemK1h8LCfHksC0uK1J+dKJ/Y2G3UjztclFOhe58vTnpwkRGv0J9ysFHcyCcHrNhav0Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=lunn.ch smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RvpRXjaK49Pl+OJZXrl2LvhnlYwDN+zG08M/5anhrLo=;
 b=fFGQJJvUKPbMgn6Be6B8CfYdesLPO0KjD46Sx8hUh5ep/ra3/5hTXB65IvVfgTnpjpjVuxxuDUtPsXgSr6YjNbiDsVMjwvih1Pl/Z3b8v+mmEj9DD/wQpV3cy1utNCkwWzOqxWRbI4BdG3qjkGxJ2RMDM/PMWRrn4zUZ7BwunLk=
Received: from BN6PR03CA0019.namprd03.prod.outlook.com (2603:10b6:404:23::29)
 by BN8PR03MB4627.namprd03.prod.outlook.com (2603:10b6:408:9b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.15; Wed, 4 Sep
 2019 13:23:47 +0000
Received: from CY1NAM02FT058.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::203) by BN6PR03CA0019.outlook.office365.com
 (2603:10b6:404:23::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2241.13 via Frontend
 Transport; Wed, 4 Sep 2019 13:23:46 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT058.mail.protection.outlook.com (10.152.74.149) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Wed, 4 Sep 2019 13:23:45 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x84DNhVw019836
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 4 Sep 2019 06:23:43 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Wed, 4 Sep 2019 09:23:43 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 2/2] net: phy: adin: implement Energy Detect Powerdown mode via phy-tunable
Date:   Wed, 4 Sep 2019 19:23:22 +0300
Message-ID: <20190904162322.17542-3-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904162322.17542-1-alexandru.ardelean@analog.com>
References: <20190904162322.17542-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(346002)(396003)(2980300002)(199004)(189003)(86362001)(36756003)(1076003)(478600001)(50226002)(47776003)(8676002)(2870700001)(8936002)(246002)(76176011)(51416003)(5660300002)(186003)(486006)(4326008)(476003)(2906002)(126002)(50466002)(14444005)(44832011)(2616005)(336012)(426003)(446003)(107886003)(11346002)(26005)(7696005)(356004)(6666004)(305945005)(316002)(7636002)(106002)(54906003)(110136005)(48376002)(70206006)(70586007);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR03MB4627;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84bc8dbc-26c5-4d59-a8b1-08d7313b1d9d
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:BN8PR03MB4627;
X-MS-TrafficTypeDiagnostic: BN8PR03MB4627:
X-Microsoft-Antispam-PRVS: <BN8PR03MB46273BF11ED6522AD0D596DBF9B80@BN8PR03MB4627.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0150F3F97D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 92s0w7aEMfTsGGPjG1ykRSzHC4altAiL5CG77lZwtgOD2EizKSS9eAMptFPIQtaW37R+oM8fJZcJXQtATT7tHlPhG9P7fcLmX6ALYx9zZdKimDwJhNKUa4b1OFQahbi+hngutH1rLmIo+Csp1U/qyi0ez3o6mH63bhjZasmMRDiPWcFsCjPLJG3pGJDHt19kg8NH4mFloN0KaGGJgD+U9JHNcXyAKgk60vSj/zsZ20NH9B1iGNaJ8SgtKl2e+QAEQVMBEBYks7miY1psAJY6lkD2gs78a/0GCxxXxEaaVafTw0CiO5Bp7bwoeFiVo7cqyZY4keuXuVcMvDSBsWsK2My9VP8Yk3k/9jzrfuxi5Um1QTPWos0eyBfOIxrJfcl/ojzmlc8JGrjslgs1+iZVw/ACC+5JYyYOU4UidsrFUD4=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2019 13:23:45.2086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84bc8dbc-26c5-4d59-a8b1-08d7313b1d9d
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR03MB4627
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-04_04:2019-09-03,2019-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1909040135
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

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 50 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 4dec83df048d..742728ab2a5d 100644
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
@@ -328,12 +333,51 @@ static int adin_set_downshift(struct phy_device *phydev, u8 cnt)
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
+			*tx_interval = 1;
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
+	if (tx_interval != ETHTOOL_PHY_EDPD_NO_TX)
+		val |= ADIN1300_NRG_PD_TX_EN;
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
@@ -345,6 +389,8 @@ static int adin_set_tunable(struct phy_device *phydev,
 	switch (tuna->id) {
 	case ETHTOOL_PHY_DOWNSHIFT:
 		return adin_set_downshift(phydev, *(const u8 *)data);
+	case ETHTOOL_PHY_EDPD:
+		return adin_set_edpd(phydev, *(const u16 *)data);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -368,6 +414,10 @@ static int adin_config_init(struct phy_device *phydev)
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

