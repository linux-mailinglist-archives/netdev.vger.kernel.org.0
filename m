Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494F3861B4
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389944AbfHHMbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:31:11 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:36608 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732344AbfHHMbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:31:09 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CRjCl030249;
        Thu, 8 Aug 2019 08:31:02 -0400
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2054.outbound.protection.outlook.com [104.47.44.54])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u8bmphapf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:31:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEQLk/J0pBOrwrZHBL3Ceq56xUSUtExzmOJkwEVWHwX12CxQK4J3hUZiVd/Y4s5vuSuELDTXLp5QES71w7Xc11C4mSSIAd7/XBSIumFUMqjZ4305hx3PVFyTR3uSPMUdBryEm4yNCZlNI4v7oKsK38dxIHsZv2ecX3X2PQ545wQRja+K4/x2MHvvMMEmi50mVIuHmG4zV1P+vAirzq8PMhqlY2SPXaHekO6v8jy+DUrct8eq9zCIs8ZeMaH8hPaN4g8lF6LhHTy9mM0I6U2hubJvIJufgjD9kFr2tt/xN1aTcC3aKjc+rEBmXKMGaz3rJJBpWg1faW19fs2W2QizXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGklS0X5NtIXondSTFhDwMJLNKtCkT2vazlDJJnHfrs=;
 b=YiCXu5IWJMgU0F+G58Z9lxtH2EPLF41cvTAX9YKvkWxeIsIDtB/H5cyaojB1/xG3b+HLS3V9Uzc/tkhfZg3oAZFgh1dVisTHaIqCks7z2MTBRKpUvPhA/p2PrdZbu2FByCJan93rI/IqyALWGddPSOv01ukw0/nOO8MjasJq/tHYEILkZa5jAiLAXPM9UqBjm0JUYFKpmkgs2lkhgsI91UVmbKVhRwCRYlPEzQKevEsRdCLIusyRVKscat+4IVI/e/a1//dD5Lpwa5BEjJwLxVQms17GSxqpECocpQPW6zorFx+K80OrEOnN8S7ZJSdesZ8dZR9B9zB3m9D7MKuzcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGklS0X5NtIXondSTFhDwMJLNKtCkT2vazlDJJnHfrs=;
 b=bJ9vLsmSLwBvXsgDx99ccqdncuwnN0b0afkW4wyTOAFa9pL6BnNpVyTSBWLX47LYHHWvvCnm6sVLq/oubyFEMWLUju0oIWD03GKTITzRXxibET7Z1CPOizTTWRGNfa4Rr6LlmTpfA/mluqpjUshB/DblxsDkGl0IbzomuWWLmDI=
Received: from BN6PR03CA0080.namprd03.prod.outlook.com (2603:10b6:405:6f::18)
 by BYAPR03MB3512.namprd03.prod.outlook.com (2603:10b6:a02:aa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.17; Thu, 8 Aug
 2019 12:30:59 +0000
Received: from SN1NAM02FT055.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::207) by BN6PR03CA0080.outlook.office365.com
 (2603:10b6:405:6f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.18 via Frontend
 Transport; Thu, 8 Aug 2019 12:30:59 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT055.mail.protection.outlook.com (10.152.72.174) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:30:59 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CUw7t021292
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:30:58 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:30:58 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 13/15] net: phy: adin: configure downshift on config_init
Date:   Thu, 8 Aug 2019 15:30:24 +0300
Message-ID: <20190808123026.17382-14-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(136003)(39860400002)(376002)(396003)(2980300002)(199004)(189003)(50226002)(54906003)(426003)(36756003)(316002)(2870700001)(110136005)(106002)(2906002)(47776003)(186003)(26005)(486006)(476003)(2616005)(11346002)(126002)(446003)(44832011)(356004)(6666004)(7696005)(51416003)(76176011)(336012)(4326008)(7636002)(1076003)(86362001)(246002)(5660300002)(478600001)(8676002)(2201001)(107886003)(8936002)(48376002)(50466002)(70206006)(70586007)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB3512;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abd72e0e-6680-4312-1753-08d71bfc44b2
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:BYAPR03MB3512;
X-MS-TrafficTypeDiagnostic: BYAPR03MB3512:
X-Microsoft-Antispam-PRVS: <BYAPR03MB3512C1A08C8626B82C066E4FF9D70@BYAPR03MB3512.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: yz1BjX3gFI6MEcbwbb0d/a2cSPXM8f5SSBy+WtyUAiOOB8fP2IPgLt/O5qIziKu/Us5npBxIKUHl4YfD//jV31egWKjyG/lhwIzsZVT/HuoYERILneP8ce6+QF4KAqdaHUG8BxnwktrqZmCgHyjt13j/70IHuBuk3oXrwCuolYMOebucmBMh+kFY8DCbzGYJRLLW/FWufp5Bn68P5OKVvjlEBz6lX48d9F08amyu9c8766R401qH3VDHQwH0yELhhw14I6pJxqBwPVWtnUN4BitgQ9bMS2hTCsSFjRI/A/9tOfvHnm1YwDC4IG3u3Baay5aM0lKeIEKuC0wlNiXjDWLNqJUyUCPaPiVhrLS41ow6EiFukSPeGUMfyJlTVcP6L1ckZTD1suOJ+W45DLHb9HZzN7YT/HzJQCdraKVVE/s=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:30:59.0081
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: abd72e0e-6680-4312-1753-08d71bfc44b2
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3512
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

Down-speed auto-negotiation may not always be enabled, in which case the
PHY won't down-shift to 100 or 10 during auto-negotiation.

This change enables downshift and configures the number of retries to
default 8 (maximum supported value).

The change has been adapted from the Marvell PHY driver.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index bc4393195de7..d6d1f5037eb7 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -29,6 +29,18 @@
 #define   ADIN1300_NRG_PD_TX_EN			BIT(2)
 #define   ADIN1300_NRG_PD_STATUS		BIT(1)
 
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
+#define   ADIN1300_DOWNSPEED_RETRIES_OFF	10
+
 #define ADIN1300_INT_MASK_REG			0x0018
 #define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
 #define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
@@ -259,6 +271,29 @@ static int adin_config_rmii_mode(struct phy_device *phydev)
 			     ADIN1300_GE_RMII_CFG_REG, reg);
 }
 
+static int adin_config_down_shift(struct phy_device *phydev, bool enable,
+				  u8 retries)
+{
+	u16 mask, set;
+	int rc;
+
+	if (!enable)
+		return phy_clear_bits(phydev, ADIN1300_PHY_CTRL2,
+				      ADIN1300_DOWNSPEEDS_EN);
+
+	mask = ADIN1300_LINKING_EN | ADIN1300_DOWNSPEED_RETRIES_MSK;
+	set = (retries << ADIN1300_DOWNSPEED_RETRIES_OFF);
+	set &= ADIN1300_DOWNSPEED_RETRIES_MSK;
+	set |= ADIN1300_LINKING_EN;
+
+	rc = phy_modify_changed(phydev, ADIN1300_PHY_CTRL3, mask, set);
+	if (rc < 0)
+		return rc;
+
+	return phy_set_bits(phydev, ADIN1300_PHY_CTRL2,
+			    ADIN1300_DOWNSPEEDS_EN);
+}
+
 static int adin_config_init_edpd(struct phy_device *phydev)
 {
 	struct adin_priv *priv = phydev->priv;
@@ -289,6 +324,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_config_down_shift(phydev, true, 8);
+	if (rc < 0)
+		return rc;
+
 	rc = adin_config_init_edpd(phydev);
 	if (rc < 0)
 		return rc;
-- 
2.20.1

