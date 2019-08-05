Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E42F81E31
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbfHENzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:55:45 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:1472 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729805AbfHENzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:43 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75DqoCV015406;
        Mon, 5 Aug 2019 09:55:36 -0400
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2052.outbound.protection.outlook.com [104.47.34.52])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u5448sdbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebCyqM3nBEWumVF8fe9lKIbQGJVbFvVBsaPnuKAeOpQ7GRPc/OuPBLXy7OLGMA1ypJRGgxCbUXzoJKJXXLSP0AEu5YRC2uWaPwK0Zt4YyCkOPxGElPeFkjlH62kHV3dodCtPqBCWwOpVRQjBl2n0sJEjghrwmjuJsqOcMZoijxW9U/p+AsYiw0KQxGtf6pULlz+c96mmLDkbWMJxVenojeemjPNJ07ooYPa5SYO4VdkGKdF3Kv/vqBWWCaf/FSJDjTUskq2QxqfPip+soyWIseT8/HVA3kMu2KICBy8QfM7+VzH0XoWRUucSHmfRPL5WHqfcNf+oKrKH1GYM09GxXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSVlBXmLQrbrDr/1UrmkH0PUCXZvePdkxAdhdT5SR9o=;
 b=fWSOTNjDUdj9w1fyLbQFrhPy6LcfoU+i+kFl5/CsXlcvDOZVsTpH6oy6ACP7npiT9xYRGNCA6MDPlUtL893ywDp6eiBSfUKqDOthGwO56jDZYUnFeZDSOFhdC0Qyi3W33ocKf27NTc5pbAhCDRl9j3hxN5zlRH6ktiL7u7YsjL9HdNm5Igfk5AIQUG2KKTBHS4uOKgANEX6t4ofTCRk2Wa6hEBgCSzkJaJQ0n+n+bCuLR5lQ994tyyE3ddn+KPH3+0wzYOVrotrjMYbz7XmjHTgjWvKd/xU9VR8nPU9q6sUkG647rhWaDxW3u5cmBcguI/Cvr3YKhCYUfEz5qVKc1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSVlBXmLQrbrDr/1UrmkH0PUCXZvePdkxAdhdT5SR9o=;
 b=MnqE/VMaGHg4WHSGllkA6FZuYfqXVROXb6Qe0VtYh0MoZCX7p2jpR6fFkMmleuILia+bsI5ZJoHsJfulas8l7zfqLitW96NOKFE12Dv4VDAjFdvf/3bXvX0uWrs/rZgOZfsp42KGryi0Vl4L/EdyNALNnjXImDzcP5mV48gmWho=
Received: from MWHPR03CA0014.namprd03.prod.outlook.com (2603:10b6:300:117::24)
 by SN2PR03MB2192.namprd03.prod.outlook.com (2603:10b6:804:c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.16; Mon, 5 Aug
 2019 13:55:33 +0000
Received: from BL2NAM02FT022.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::209) by MWHPR03CA0014.outlook.office365.com
 (2603:10b6:300:117::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.14 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:33 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT022.mail.protection.outlook.com (10.152.77.153) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:33 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75DtUqo016246
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:30 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:32 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 13/16] net: phy: adin: implement Energy Detect Powerdown mode
Date:   Mon, 5 Aug 2019 19:54:50 +0300
Message-ID: <20190805165453.3989-14-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(376002)(346002)(2980300002)(199004)(189003)(1076003)(7636002)(486006)(2616005)(446003)(11346002)(36756003)(336012)(476003)(126002)(47776003)(356004)(50466002)(26005)(4326008)(186003)(54906003)(305945005)(86362001)(478600001)(6666004)(5660300002)(48376002)(50226002)(70586007)(8936002)(316002)(70206006)(8676002)(110136005)(246002)(44832011)(426003)(2906002)(14444005)(2201001)(76176011)(7696005)(106002)(107886003)(2870700001)(51416003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR03MB2192;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2456e675-b11a-4f92-b510-08d719ac9598
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:SN2PR03MB2192;
X-MS-TrafficTypeDiagnostic: SN2PR03MB2192:
X-Microsoft-Antispam-PRVS: <SN2PR03MB2192BE5DD50D2670D7F410F7F9DA0@SN2PR03MB2192.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Vk4O59ueEX1Wry/ndbEJAVHSIxrbjaHpBLkiHMCZIPjBoWHaSng9IJAe2PcI/xxl56ZO/4Q8nasWeHlRlslP908Tda+81uJK2cc05G5yAXqjLSn9ZD22dN5vE3k6J18sBnS8uBybvjFlZTJqIr6CH4oQ8Cvc1A5v026yENVPHxEQ/y6OItfF96xjyrc78/hlo7Rzb3q2bVuDxagSqwF6vOagMfL50lZA5lqwjCHeMeescry4IOHOcUGWXw3q2BarzX9/Dkpi2bYlOe0ypJyiAcoKrRs3CnPNTeFQMpyGqLiCkrbBM+rTjDQ5CJ5Tz8TSqY5jAgP4WeRxdjZigvhMBuI7sg++e3OxN/zp2qge96vCGFRz0O3oVQ3Y6GWsZDH86FSnx2YjNqkbeB7S4SL+JAAfyHCcjaoqGxMmlnPED5c=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:33.0126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2456e675-b11a-4f92-b510-08d719ac9598
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR03MB2192
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

The ADIN PHYs support Energy Detect Powerdown mode, which puts the PHY into
a low power mode when there is no signal on the wire (typically cable
unplugged).
This behavior is enabled by default, but can be disabled via device
property.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index cf99ccacfeeb..86848444bd98 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -27,6 +27,11 @@
 #define   ADIN1300_AUTO_MDI_EN			BIT(10)
 #define   ADIN1300_MAN_MDIX_EN			BIT(9)
 
+#define ADIN1300_PHY_CTRL_STATUS2		0x0015
+#define   ADIN1300_NRG_PD_EN			BIT(3)
+#define   ADIN1300_NRG_PD_TX_EN			BIT(2)
+#define   ADIN1300_NRG_PD_STATUS		BIT(1)
+
 #define ADIN1300_INT_MASK_REG			0x0018
 #define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
 #define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
@@ -95,10 +100,12 @@ static struct clause22_mmd_map clause22_mmd_map[] = {
  * struct adin_priv - ADIN PHY driver private data
  * gpiod_reset		optional reset GPIO, to be used in soft_reset() cb
  * eee_modes		EEE modes to advertise after reset
+ * edpd_enabled		true if Energy Detect Powerdown mode is enabled
  */
 struct adin_priv {
 	struct gpio_desc	*gpiod_reset;
 	u8			eee_modes;
+	bool			edpd_enabled;
 };
 
 static int adin_get_phy_internal_mode(struct phy_device *phydev)
@@ -235,6 +242,18 @@ static int adin_config_init_eee(struct phy_device *phydev)
 	return phy_write_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_EEE_ADV_REG, reg);
 }
 
+static int adin_config_init_edpd(struct phy_device *phydev)
+{
+	struct adin_priv *priv = phydev->priv;
+
+	if (priv->edpd_enabled)
+		return phy_set_bits(phydev, ADIN1300_PHY_CTRL_STATUS2,
+				(ADIN1300_NRG_PD_EN | ADIN1300_NRG_PD_TX_EN));
+
+	return phy_clear_bits(phydev, ADIN1300_PHY_CTRL_STATUS2,
+			(ADIN1300_NRG_PD_EN | ADIN1300_NRG_PD_TX_EN));
+}
+
 static int adin_config_init(struct phy_device *phydev)
 {
 	phy_interface_t interface, rc;
@@ -261,6 +280,10 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
+	rc = adin_config_init_edpd(phydev);
+	if (rc < 0)
+		return rc;
+
 	if (phydev->interface == interface)
 		dev_info(&phydev->mdio.dev, "PHY is using mode '%s'\n",
 			 phy_modes(phydev->interface));
@@ -535,6 +558,10 @@ static int adin_probe(struct phy_device *phydev)
 	priv->gpiod_reset = gpiod_reset;
 	if (device_property_read_bool(dev, "adi,eee-enabled"))
 		priv->eee_modes = (MDIO_EEE_100TX | MDIO_EEE_1000T);
+	if (device_property_read_bool(dev, "adi,disable-energy-detect"))
+		priv->edpd_enabled = false;
+	else
+		priv->edpd_enabled = true;
 	phydev->priv = priv;
 
 	return adin_reset(phydev);
-- 
2.20.1

