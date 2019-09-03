Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48052A6955
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbfICNHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:07:03 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:3756 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729408AbfICNGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:06:49 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83D37Bk010249;
        Tue, 3 Sep 2019 09:06:44 -0400
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2053.outbound.protection.outlook.com [104.47.38.53])
        by mx0a-00128a01.pphosted.com with ESMTP id 2uqjrad1ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 09:06:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9tvkM5bS0bVAsUM+PvqbE/HKABT8sP0+W/njMSGph2YsmLyx2LeC/2JSrUZJLBpAF4afznV0/7AX42KXU2qgEM30NauvNwL4kHiN73jpxCcClgY2cBd45ETW+ZjsxowExVhasqNJhPqIocsL5MORMm6XX35C9DhrJDE8UM0z9hEMvk0zzeHc8uY/ux3LozSjvXoxkHrRnKCxfptzP+cyfo4ot4p7N3DYqtxx9t8qu+ytvb0ybXTczBA4MBiZHFw/i2hc1lDeA1yzDW37dDCAP1C4tFu6W6rw2tH5c6NdcWI0mkfL3jW0PDjbTPeFkdBV28/7it33k/n87lYh8khBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RvpRXjaK49Pl+OJZXrl2LvhnlYwDN+zG08M/5anhrLo=;
 b=S6yYa9+meS5irk9FyLpOkTxbTeHvrIcLze1rvIQSl7rbC5Cb/gwfwBHpun5jz3saS0HCVPPnMzUSS4eBROaylkWAgI9vIskbiF9V5JLX2/o8Y67Mzj5ElhY64z30HZURUkcJQy4OI44okQTNgzEzViNtCOIY7gBEvIJG66MQwuXe10/ChonsxFWc6rFKIaczW06u7I3jZSX0hyPbF0VYZojjcvItLZhJJorCELePk63jZ7XQSCMR8eqO1iEzgn8QJxBB9ht4qj1wdWPN8nB7B8jYXitETwhrxqpqCzMGe172k6leNhQZMj6CpxHwMg1ScFkNQ/rTZZdVzm9jLNvVCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=lunn.ch smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RvpRXjaK49Pl+OJZXrl2LvhnlYwDN+zG08M/5anhrLo=;
 b=43bpidk9Ej9g0R9wYFOJ0WNXSSkJIERMs7YiDnVNjcS9HdVozdLghDjR3j0ts1fIjUxKDpfTL/o+vwRZhwA2mGS9ESHRUzzVtrsPutIqXu8hGDKjoKF2WIJ0+sdUAP3AEa34OfirUSjP5GjnAvYoec0y7gca4WZu05cJqy4HK0c=
Received: from BYAPR03CA0029.namprd03.prod.outlook.com (2603:10b6:a02:a8::42)
 by MWHPR03MB2479.namprd03.prod.outlook.com (2603:10b6:300:e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.18; Tue, 3 Sep
 2019 13:06:40 +0000
Received: from BL2NAM02FT031.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::205) by BYAPR03CA0029.outlook.office365.com
 (2603:10b6:a02:a8::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2199.21 via Frontend
 Transport; Tue, 3 Sep 2019 13:06:40 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT031.mail.protection.outlook.com (10.152.77.173) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Tue, 3 Sep 2019 13:06:40 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x83D6ZBi024853
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 3 Sep 2019 06:06:35 -0700
Received: from saturn.ad.analog.com (10.48.65.123) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Tue, 3 Sep 2019 09:06:39 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 2/4] net: phy: adin: implement Energy Detect Powerdown mode via phy-tunable
Date:   Tue, 3 Sep 2019 19:06:24 +0300
Message-ID: <20190903160626.7518-3-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903160626.7518-1-alexandru.ardelean@analog.com>
References: <20190903160626.7518-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(396003)(346002)(2980300002)(189003)(199004)(7696005)(50466002)(76176011)(50226002)(48376002)(478600001)(4326008)(316002)(47776003)(305945005)(11346002)(426003)(51416003)(106002)(110136005)(54906003)(107886003)(446003)(8936002)(70586007)(356004)(6666004)(70206006)(36756003)(486006)(5660300002)(2906002)(126002)(2870700001)(8676002)(186003)(14444005)(2616005)(476003)(7636002)(26005)(246002)(44832011)(86362001)(1076003)(336012);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR03MB2479;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6320045e-30f9-423b-05a7-08d7306f8f6f
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:MWHPR03MB2479;
X-MS-TrafficTypeDiagnostic: MWHPR03MB2479:
X-Microsoft-Antispam-PRVS: <MWHPR03MB24794A7695FAE0D8FD821ADDF9B90@MWHPR03MB2479.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 01494FA7F7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: yk1oo3LXnmhN+VJ7PmiAPu/CVSV025LKFf9h5No4TCJT6RFlLnVlU3W8pa7JYtPZpDHCaq+rl7JgcfA83K0Z0Wxg/DE2Q2k4Xl5nMXGkJmk9mVvZwwoYXgiXjPYV6IKxiYHPJ6fKtdLqRylhfArbDdIES/fk74HXgemB1KCP//nL0rSilTlAbqrXAk+/nYoaLSaQTaGqsJY/2bsqpOIOknoYNCynwl5+gdByInhSzuB1Xzc4EYpeNDPryAo7af7FCTyIs1orl5Eh3A4fcN8n5ReQKZSfMXeqkESM1R99eeY9f3FM0+Gxxvjh915Ivgo+bCyP4+kLtaiF3xETpHMDerKjKbZDLyHEXt0VUDKUafAtOYOPcKWpMpiSrkJrbkX/efjA5MtV/rmHhS00Rrsj936sX5CdNRGPx8gIsgaPycU=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2019 13:06:40.1154
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6320045e-30f9-423b-05a7-08d7306f8f6f
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR03MB2479
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-03_02:2019-09-03,2019-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909030137
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

