Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8375181E42
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbfHEN4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:56:47 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:5464 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729220AbfHENz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:28 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75DqrI4019294;
        Mon, 5 Aug 2019 09:55:21 -0400
Received: from nam05-dm3-obe.outbound.protection.outlook.com (mail-dm3nam05lp2056.outbound.protection.outlook.com [104.47.49.56])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u56w5svg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ye1/2Jpf7JGIjXlETnW6QHZdEt58QmVTyju5ChGr8P1r8Hyj3SWGLn2McnCmCp4KL/pUP6Qk/hsgwyQD9uAyyjZDqfqI4uA12Nb+Ly6kek2caZroGm1p0Suq43k2NoC3NbjRWgTPXSnG03rhdcrWx3PMYwL53rgK1qrdwhRUWEwNT36Li7Cwnp4SvdQUgqM//Uv/EQJ6ZylhK2GNJiqAEsWRhSi9a9X1AB26VHEuQheS1fgCTbmzgOGXBuZL/v5M3lr80kaKSgBk7EhdYfKGfDsisv48Img14jtZ47d64/7dVwHGhtGdLRH2dy75cnT++7Z6+CXBH4a7+bclNen/Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2GEjSTs3oWUTj0qu/gj7m9Gbig3BqK+yio1fLZ0r6I=;
 b=OmU+sxfVyh2m18EFi8BNLeZLjW22PriaKeZnLkuzFnfukqja/SbIwv5WvTr6zDig5YZZXnf4ePDWAlu1b/ZPfknnjsGwOaG6YUgqRkKmDqfGjJImB90WjnyRkSaPZSbl+XDppIxhYKgXXdhiAaBB5mGHUUvm1NVkcL1orekeSo3TwhQq3OCCCHwGxGbaDvM3N/5HzEUpF2xesUMjx7EVinmxVEowAxZOConS/RLpS1qT2Ep9OvPZZdS2dpV/gezU+R64Z7Kjsd6QFk6p9H3qTvzJknDWJNG5is1kySDIpFVH+1jNEOg5XHF55XLBXOayWG95MbP5NUZQAzppNMcS4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2GEjSTs3oWUTj0qu/gj7m9Gbig3BqK+yio1fLZ0r6I=;
 b=4ZbfkGk+q6tpkNq9zsb+iOi6n70rmVDXhsQVwcUjYdocpl55vMJwdqi4pAxLqHJMdJKGe6CUM7VXRok80g54QkI4J6FcGlUE3kqq15dkwDlU8lK2JV1pD3mUfM5DoS16DrhUH+2oURywXKwne5/3/1IyYwrr/IzmDLWdLvQsuZw=
Received: from BN6PR03CA0097.namprd03.prod.outlook.com (2603:10b6:404:10::11)
 by MN2PR03MB4912.namprd03.prod.outlook.com (2603:10b6:208:100::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.14; Mon, 5 Aug
 2019 13:55:19 +0000
Received: from BL2NAM02FT027.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::201) by BN6PR03CA0097.outlook.office365.com
 (2603:10b6:404:10::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.13 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:19 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT027.mail.protection.outlook.com (10.152.77.160) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:18 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75DtF6w016204
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:15 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:18 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 06/16] net: phy: adin: support PHY mode converters
Date:   Mon, 5 Aug 2019 19:54:43 +0300
Message-ID: <20190805165453.3989-7-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(39860400002)(136003)(2980300002)(189003)(199004)(126002)(2616005)(7696005)(51416003)(446003)(305945005)(7636002)(4326008)(107886003)(2870700001)(70206006)(70586007)(86362001)(6666004)(356004)(36756003)(2201001)(110136005)(486006)(50226002)(76176011)(47776003)(26005)(186003)(5660300002)(478600001)(8676002)(8936002)(316002)(48376002)(44832011)(54906003)(50466002)(11346002)(106002)(2906002)(476003)(246002)(1076003)(336012)(426003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR03MB4912;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c43ca27-7b73-4898-0265-08d719ac8d1e
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:MN2PR03MB4912;
X-MS-TrafficTypeDiagnostic: MN2PR03MB4912:
X-Microsoft-Antispam-PRVS: <MN2PR03MB491296399C9C68EC4AC61142F9DA0@MN2PR03MB4912.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: QrnzBC0Gdx7dx4pgj8HFXOJLHwCGPrIIJwlHKFcOzkUTyKWMLdlTeYQrhahn5XvCDO+aHgHN+CjsEv+NSzGu/0n6ElRAlS4Lpfs7ofJ6bKIPPsVTnJRYoMT0zP502BRQEzE3TZeMeIe2XUpjJVidhJMVmKqylM3ylNRbDiV2nZK3QyWhTyijhdyujoydTx8ecTcPJeyFg/2OzJsE6tnVeqbEFbTRx3e34CkhTH80zWVhQUxo5wpAxMMHvoZrWXBUtIcc3s2kbFHD+yuz1I1+Is0oo+fcMVErJPwITS3rpkQavM5JvM5JCSsTxiLQjzExwY8+7l2kq2OdXsBXNQ0PtgQeNL0r1zpwNWC2xx8uFWjqFBxK3mPfL/53RpKsUtviTdKL6mMS77xd7jcheHT2kJVWU06QbYQJmCjfXNHKgMk=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:18.7717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c43ca27-7b73-4898-0265-08d719ac8d1e
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB4912
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

Sometimes, the connection between a MAC and PHY is done via a
mode/interface converter. An example is a GMII-to-RGMII converter, which
would mean that the MAC operates in GMII mode while the PHY operates in
RGMII. In this case there is a discrepancy between what the MAC expects &
what the PHY expects and both need to be configured in their respective
modes.

Sometimes, this converter is specified via a board/system configuration (in
the device-tree for example). But, other times it can be left unspecified.
The use of these converters is common in boards that have FPGA on them.

This patch also adds support for a `adi,phy-mode-internal` property that
can be used in these (implicit convert) cases. The internal PHY mode will
be used to specify the correct register settings for the PHY.

`fwnode_handle` is used, since this property may be specified via ACPI as
well in other setups, but testing has been done in DT context.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index dbdb8f60741c..e3d2ff8cc09c 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/mii.h>
 #include <linux/phy.h>
+#include <linux/property.h>
 
 #define PHY_ID_ADIN1200				0x0283bc20
 #define PHY_ID_ADIN1300				0x0283bc30
@@ -41,6 +42,31 @@
 #define ADIN1300_GE_RMII_CFG_REG		0xff24
 #define   ADIN1300_GE_RMII_EN			BIT(0)
 
+static int adin_get_phy_internal_mode(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	const char *pm;
+	int i;
+
+	if (device_property_read_string(dev, "adi,phy-mode-internal", &pm))
+		return phydev->interface;
+
+	/**
+	 * Getting here assumes that there is converter in-between the actual
+	 * PHY, for example a GMII-to-RGMII converter. In this case the MAC
+	 * talks GMII and PHY talks RGMII, so the PHY needs to be set in RGMII
+	 * while the MAC can work in GMII mode.
+	 */
+
+	for (i = 0; i < PHY_INTERFACE_MODE_MAX; i++)
+		if (!strcasecmp(pm, phy_modes(i)))
+			return i;
+
+	dev_err(dev, "Invalid value for 'phy-mode-internal': '%s'\n", pm);
+
+	return -EINVAL;
+}
+
 static int adin_config_rgmii_mode(struct phy_device *phydev,
 				  phy_interface_t intf)
 {
@@ -105,7 +131,9 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
-	interface = phydev->interface;
+	interface = adin_get_phy_internal_mode(phydev);
+	if (interface < 0)
+		return interface;
 
 	rc = adin_config_rgmii_mode(phydev, interface);
 	if (rc < 0)
@@ -115,8 +143,13 @@ static int adin_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		return rc;
 
-	dev_info(&phydev->mdio.dev, "PHY is using mode '%s'\n",
-		 phy_modes(phydev->interface));
+	if (phydev->interface == interface)
+		dev_info(&phydev->mdio.dev, "PHY is using mode '%s'\n",
+			 phy_modes(phydev->interface));
+	else
+		dev_info(&phydev->mdio.dev,
+			 "PHY is using mode '%s', MAC is using mode '%s'\n",
+			 phy_modes(interface), phy_modes(phydev->interface));
 
 	return 0;
 }
-- 
2.20.1

