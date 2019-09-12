Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A94AB0FE7
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 15:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732162AbfILN2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 09:28:41 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:15658 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732133AbfILN2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 09:28:39 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CDREbx021063;
        Thu, 12 Sep 2019 09:28:27 -0400
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2055.outbound.protection.outlook.com [104.47.32.55])
        by mx0b-00128a01.pphosted.com with ESMTP id 2uv6a9rg65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 09:28:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sca0Ge8gnKWQr92V2QsjKpnzF1GaCdg9TjB9fYTKhhW+HX/yI+Sxr/DKvE34oF6fbQ33ZFJXb0OGhkJ7f9J9Lb4qfwhGuxUmq1zYFKrdqWFl3zZqMh7y54L1eIMMwph3Y5XpHVCVO+EP8UXANu2UOkoRSU8aBVLDcIVSDAxIkHw/Dpofa/TdYjIJPwIX5tNisbEw3XeEMn5okZmTswxFU9NrdxIeL2hbQI3epP1Wd5YI6BNhlZDVPmu68BvdTj/IEYe4KXEFsBsvxTa1m2mX1igR2lluUKP48V2nLgNwsIf5aXdSBwT0qd0Poev+fascy3zP0lQYw01YFRyhPEhUfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qDZVTLk58Fki2gL9rzhn7gUC/DlkGP5dgENplDsdks=;
 b=j2fAP5CDjnxmhfyFzr0R+Fxe/qJwQ+AL07x2qBXrXAlpFv1fynGXYQOvvrzFBqmcj2+2A9lFAGsNrrym9yujz9b5f6yL7At/eITvMZtZZodU9ofOPeGbDzOfmgJSKM+XdYUUMx3/0ZKvLqsZRprJDsrb6OIsFD3GVeZPVhlDrjzSKbuqMYSvZ9BO0A5oY/6hEFtoZOCp2FY27+EPkAiSBxyHkhgLzatwnuAf7iQdySOIE37q/blbBR+L2fjx+FVA5ey0TKbjq9dJgG/GK57Uk5ReIrIur4MY6mRw2ToUzzGStamM0OBKF7QfQx0kE0eXB7aakag9v5m5A9RsdAIIwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qDZVTLk58Fki2gL9rzhn7gUC/DlkGP5dgENplDsdks=;
 b=np2ucan8xiaxlLEHm9AM0DB6LuIMdzVTHYZKH3PwtSHR0zUqKTc7JAfGqZzrqKgY1xmXiNYhJAo3AAWa0Moto16nqtJ6Gmyue2De4fPf0DyZnrRMd3PH54bdA0S51ENRnHiT987iqsQJR7GxDYjPYTIovhzv7i1JeTXwDF+Sgf0=
Received: from BN6PR03CA0071.namprd03.prod.outlook.com (2603:10b6:404:4c::33)
 by MN2PR03MB4768.namprd03.prod.outlook.com (2603:10b6:208:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.17; Thu, 12 Sep
 2019 13:28:26 +0000
Received: from CY1NAM02FT035.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::206) by BN6PR03CA0071.outlook.office365.com
 (2603:10b6:404:4c::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.15 via Frontend
 Transport; Thu, 12 Sep 2019 13:28:26 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT035.mail.protection.outlook.com (10.152.75.186) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2241.14
 via Frontend Transport; Thu, 12 Sep 2019 13:28:25 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x8CDSJaJ027916
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 12 Sep 2019 06:28:19 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 12 Sep 2019 09:28:24 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>, <mkubecek@suse.cz>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 2/2] net: phy: adin: implement Energy Detect Powerdown mode via phy-tunable
Date:   Thu, 12 Sep 2019 19:28:12 +0300
Message-ID: <20190912162812.402-3-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190912162812.402-1-alexandru.ardelean@analog.com>
References: <20190912162812.402-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(39860400002)(396003)(199004)(189003)(7636002)(2201001)(186003)(336012)(7416002)(50466002)(36756003)(486006)(305945005)(44832011)(86362001)(4326008)(8936002)(50226002)(107886003)(478600001)(2870700001)(8676002)(2906002)(246002)(48376002)(70206006)(70586007)(476003)(126002)(26005)(2616005)(11346002)(446003)(426003)(54906003)(110136005)(356004)(6666004)(1076003)(5660300002)(316002)(47776003)(76176011)(106002)(14444005)(7696005)(51416003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR03MB4768;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a0beb17-269e-458d-a9c3-08d737851728
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:MN2PR03MB4768;
X-MS-TrafficTypeDiagnostic: MN2PR03MB4768:
X-Microsoft-Antispam-PRVS: <MN2PR03MB4768B652A95FBCCB30410268F9B00@MN2PR03MB4768.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 01583E185C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: aWNVhn3mWggLdkdReONsgutCnS3ZQ0eRJs37iA3JPwg7uytb2CZSJabfHGWuSYfZ4mVPYV6oJ2WJv+UuiCtaSL/0Qq9jQhYcexQzjtozbDHWp30sM/Feau6Jgfx1YyJPDI2DTfH3ZgAbE4f/HxirCb9TO0m02WJPlz4W+oeaBk44UZ1gXzVWwxuZBMGlipWoazdXxjOI7gs2V3Kk2RIhTKg1kPnbVE7yjJo1xjjdyiDmL7M/e8oTd8l4w5vaH6fLIlFC4R1MlQHBZR0dBa6YxVz2afLIddN+gPXaaXZmfu72zUe1NWHQf3xYxhSl9EOoVeJpNgUU9ouL3Xy8l78FCAy8dDxZK3VwqKrpUocNIFTJaEPnzn4bVXd1MvXd++iTIVVJoNrFsygo0MJJUeKYxadCtX/vAwEVxbZMiWq/9KU=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2019 13:28:25.3322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0beb17-269e-458d-a9c3-08d737851728
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB4768
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_06:2019-09-11,2019-09-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909120142
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
ETHTOOL_PHY_EDPD_DFLT_TX_MSECS and ETHTOOL_PHY_EDPD_NO_TX (which disables
TX pulses).

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 61 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 4dec83df048d..9afeee67675b 100644
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
+			*tx_interval = ETHTOOL_PHY_EDPD_DFLT_TX_MSECS;
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
+	case 1000: /* 1 second */
+		/* fallthrough */
+	case ETHTOOL_PHY_EDPD_DFLT_TX_MSECS:
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

