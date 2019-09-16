Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56DB5B35BB
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfIPHgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:36:01 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:13568 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729231AbfIPHf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:35:58 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8G7XSkg022542;
        Mon, 16 Sep 2019 03:35:43 -0400
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2055.outbound.protection.outlook.com [104.47.34.55])
        by mx0b-00128a01.pphosted.com with ESMTP id 2v0vu6b7aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Sep 2019 03:35:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3bs1GwimYEKU6w9K/V2MUBq5UjlbKtSIZUtPzO03JJQr0iyL2oaxFW7Odrouty4GZLd3InYDgDEtGce1xFXjPpyyJ78UYr1wqt9/WSJe41rp14lic2tdEpBaJhkkSEses0Z8wtlFvW45HIW5h5qpAGNLpZx2SscOPoh/qUYSInZJlNWWqdGNL/HOGyWFRKEK4nhJ2ATPsqTPBF3gxCFFwj/D4LfAl5jNkaub7tZ08XyiKU/oiOhqM8ANOjM/GHnDCUqIH47J3SFlz1ddSptZUmLyfuxI2aAczcbkxR6O/LgzRNo+5jvI6cDjTWyZDtgdtKq1eHtV8mp4afH9Chndg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCHKJB9IECMs7tYFbhpj9+6o3jbLhgUZ5ox+8eS7Y1s=;
 b=ETWBA2NK9nrG3gMjPBBWVLFHrJAwaxgM0DGENtBz3BzVZQWZ03r01eyno+2Adlx2k+fygOanvIv2sVdX/tCuM1wOobXFc7SmfnQUnwgkejC6bHuS/JMQy5xXDO8ns0E9T7sYVGGwBfl8VVOYiZ40kLC5IX0XAjao936GIo3N8GDeStCxXBwJ/pkgE0pPVGon7rbo6sPcMO+/EPwLDgiVL1QURxeBknHwjDZ3UrbAcRevll5cOaN7YZ878ipcXSFNCNK+Hh2R0wcXohf3nD44q3+kfBTUrvjkQ0jUBpBo2/CgSs8hEPw8qfivYKo6QzISJ0btOBTClgQfW9WyqeDLdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=davemloft.net smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCHKJB9IECMs7tYFbhpj9+6o3jbLhgUZ5ox+8eS7Y1s=;
 b=nRTWHkqbB8RKwguuV8DkZYDnhBdq0hwxPA+mJtoCGFfNORigaN0fXoynjvNCtFCLUZzzdLI5IDoSNqyk2a72RC0MG5YbcWvG9F2AXRv4NOftTfpTbJXj2BN2VMb8iBULomqcPbSbvfjREK9uGfdu9XHFt/9/IDkANDBS1xMGLzM=
Received: from DM6PR03CA0052.namprd03.prod.outlook.com (2603:10b6:5:100::29)
 by CY4PR03MB2533.namprd03.prod.outlook.com (2603:10b6:903:43::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2263.17; Mon, 16 Sep
 2019 07:35:41 +0000
Received: from CY1NAM02FT008.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::200) by DM6PR03CA0052.outlook.office365.com
 (2603:10b6:5:100::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2199.19 via Frontend
 Transport; Mon, 16 Sep 2019 07:35:41 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT008.mail.protection.outlook.com (10.152.75.59) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2263.17
 via Frontend Transport; Mon, 16 Sep 2019 07:35:41 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x8G7ZZgX021683
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 16 Sep 2019 00:35:35 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 16 Sep 2019 03:35:40 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>, <mkubecek@suse.cz>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 2/2] net: phy: adin: implement Energy Detect Powerdown mode via phy-tunable
Date:   Mon, 16 Sep 2019 10:35:26 +0300
Message-ID: <20190916073526.24711-3-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190916073526.24711-1-alexandru.ardelean@analog.com>
References: <20190916073526.24711-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(396003)(376002)(136003)(346002)(199004)(189003)(50226002)(36756003)(426003)(486006)(11346002)(14444005)(110136005)(5660300002)(54906003)(50466002)(26005)(476003)(305945005)(107886003)(8936002)(126002)(86362001)(1076003)(7636002)(2616005)(7416002)(2201001)(186003)(446003)(2906002)(7696005)(51416003)(44832011)(76176011)(316002)(478600001)(356004)(2870700001)(48376002)(246002)(106002)(47776003)(6666004)(70586007)(336012)(4326008)(70206006)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR03MB2533;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0dd015f-2c95-4af1-91e4-08d73a7879ed
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(4709080)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:CY4PR03MB2533;
X-MS-TrafficTypeDiagnostic: CY4PR03MB2533:
X-Microsoft-Antispam-PRVS: <CY4PR03MB2533C3D45C7B38508466B205F98C0@CY4PR03MB2533.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0162ACCC24
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: pci7tPakBaHaKBR9/s8OvE2RYcHEYM6VQ+z9QA5igfPxVIF3+dFDG3+dl0DO81a6yw5/p5E5wutmXoLAgc63thUzT85Q9YwDbprMWHbPbAcTyyl2fvAFxcL3MI2nVTS4M8MW8LkGYmaA2xMmQa/B1FJhFSZIMyEzySfzGLo8Eb9GwL51XH+iTZTtpCrEKIpppGZt5AcbTNfNOJP0Gw1B3RksBOJXCTf5hAX7ULGHmYaviGonfrTrVvEo408aacx2OuTD+6gWDaNJ/jKZeEkc+AH+y5lakzHGGq8uk5QLKB1VSTzvaomcApIrYUFyFOU3IiVZdIh7WOsPukOLMXUKTyPSlt/VVTG+nF9uTYLALM5xdY01YlA8/BVls6/bITQOwfRcU3+GpX2xHKRzwAFqUCuId/SBfKRQyMj85zN1hdM=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2019 07:35:41.1052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0dd015f-2c95-4af1-91e4-08d73a7879ed
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR03MB2533
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-16_04:2019-09-11,2019-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909160082
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

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 61 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 4dec83df048d..cf5a391c93e6 100644
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
 
+	rc = adin_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
+	if (rc < 0)
+		return rc;
+
 	phydev_dbg(phydev, "PHY is using mode '%s'\n",
 		   phy_modes(phydev->interface));
 
-- 
2.20.1

