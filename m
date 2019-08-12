Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855EB89C93
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfHLLY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:24:29 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:58344 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728326AbfHLLY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:28 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNLCp018325;
        Mon, 12 Aug 2019 07:24:21 -0400
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2057.outbound.protection.outlook.com [104.47.37.57])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u9qs7w665-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ga4+6yJIfMevn1uTWtsMfdTip1rKWNRSzApmqt9ko1QkIz8DMf0RCmnyl+be6i/vsd3iO3pX4YRWDmcwzZMSxeEMnzdzl/jM575OQ4rNm/vpGXbVkhpH6OwR5t9LMgKlLBi0yeGn9F2ikvKjify5VCqVMRB39mtWkfNqEhomnoavnHraokyHBVWHm1HXYWgmL6yYNGUrhKA1/4+T12WrNdJgCD9TQ60SQ69YSzvrhgFauTAxJh6bzrWFgd2EYD4S57TKx7niBR8S2Ptldb/2JfwD16KBEtpkTdnc34l40BSGKd9156XCag7bTqPK+NmYneqBIvJkc4FAUtg9Hh9Ptw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nR9wWjQvRdqF+gMc5zJWoWCrySe0cQInvF1CUpNENKU=;
 b=CPGm0JL92RSK8bDPC432w7OrN667TG0/9bh07u5Mh7zBvqyKXyxjiwIm8dNY1PwLvU0CFIjD3IviZGg7sDA+Imd1138wfSnE8mRGj+Tpv9BGk+3yWEUXO+/ykDl765i3F/7/ORnY3HbSXxbsaW2ArXDPIdV2BambRBUaJvY5X1sfbpyML/VPi55Ogb50kRqL6jEqCBa6Q/F7+RcqAzbJTFeZmxMBxpPc1i+ytlv/XIWQ57+ElMaIQdR3U3OxpstGjz7lsTlhNSDpP3eMYUcnHSEMYOROivcaa29RZNfO2HunjqxkH4C85183gJRZevKXalt0DWtk+JipVLgen/S0Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nR9wWjQvRdqF+gMc5zJWoWCrySe0cQInvF1CUpNENKU=;
 b=tCQaHTaMKI7FcVKTlhD5DCQhOVyzSWLpay8vDExHcfnZLC8is2EjelxfyLN/APDZgo12n1sj9HX7lQFqjCAew9+q3VIF1QVHrTgBHWHBKoli+SGCtKyrxUDttkn1sKcmIlvjxfTnhAyCDawPXOJlmeGQbmOS07dzu7ICnNxMYpA=
Received: from BN6PR03CA0060.namprd03.prod.outlook.com (2603:10b6:404:4c::22)
 by MN2PR03MB4702.namprd03.prod.outlook.com (2603:10b6:208:ad::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.20; Mon, 12 Aug
 2019 11:24:18 +0000
Received: from CY1NAM02FT022.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::202) by BN6PR03CA0060.outlook.office365.com
 (2603:10b6:404:4c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16 via Frontend
 Transport; Mon, 12 Aug 2019 11:24:18 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT022.mail.protection.outlook.com (10.152.75.185) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:24:17 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBOGLr004239
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:24:17 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:24:16 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 10/14] net: phy: adin: implement PHY subsystem software reset
Date:   Mon, 12 Aug 2019 14:23:46 +0300
Message-ID: <20190812112350.15242-11-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(2980300002)(189003)(199004)(50466002)(246002)(305945005)(2201001)(86362001)(6666004)(7636002)(356004)(4326008)(54906003)(106002)(107886003)(1076003)(110136005)(316002)(8676002)(36756003)(5660300002)(7696005)(51416003)(48376002)(76176011)(2616005)(336012)(47776003)(446003)(26005)(14444005)(186003)(11346002)(70586007)(126002)(8936002)(2906002)(426003)(2870700001)(476003)(486006)(70206006)(478600001)(44832011)(50226002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR03MB4702;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d0f27e9-7451-4664-4796-08d71f179d60
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:MN2PR03MB4702;
X-MS-TrafficTypeDiagnostic: MN2PR03MB4702:
X-Microsoft-Antispam-PRVS: <MN2PR03MB4702E016EB4EE220259E06C6F9D30@MN2PR03MB4702.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: IyKb7ZFvfsMHKnqsr9esB8GAaUOlQMrO0697qkja4LEXLw3VA2/8bkM2d+RAFDHbCoffVbkBVK1Ckcl9L8jtnCvp04dyKaN7HowbD4n9VbnWZCO8B+ukMehnmVa8zX9HzYaIbac9Dca83e9soHgcIUpuM1zyNt1Dk4qsVwMhtYboJRHoMRS+rVQ66dsDlcBJm+qv3cRIsK5lwbQwSakPhnhaDc9/VUDJVwt+/nN6YU2njwgGQQcesoJQk6P/+GOaTIG39qdZY+cxXuu9/jOXHdTBZBGHnNZbqf70pXYBk7zKYw4gKcvqA2n27SUONcCIAXscl40kdwXmygT5BXzCj1E4pNx75lnhKSkuE7BhgfxlVU7vdarJUH7KQS1btdtGwCXd8I+bVbDBah3l+nfTNySX2bgT4lY0STwTOiNzd8c=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:24:17.5891
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d0f27e9-7451-4664-4796-08d71f179d60
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB4702
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=797 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120128
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN PHYs supports 4 types of reset:
1. The standard PHY reset via BMCR_RESET bit in MII_BMCR reg
2. Reset via GPIO
3. Reset via reg GeSftRst (0xff0c) & reload previous pin configs
4. Reset via reg GeSftRst (0xff0c) & request new pin configs

Resets 2 & 4 are almost identical, with the exception that the crystal
oscillator is available during reset for 2.

As it turns out, phylib already supports GPIO reset.
In case this is configured, the PHY driver won't do anything. In case it
isn't specified the subsystem software reset will kick in.

Resetting via GeSftRst or via GPIO is useful when doing a warm reboot,
because this will reset the subsystem registers to default values.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index a0f8b616bcb7..ddf0512a9a4d 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -6,6 +6,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/bitfield.h>
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -51,6 +52,9 @@
 #define ADIN1300_CLOCK_STOP_REG			0x9400
 #define ADIN1300_LPI_WAKE_ERR_CNT_REG		0xa000
 
+#define ADIN1300_GE_SOFT_RESET_REG		0xff0c
+#define   ADIN1300_GE_SOFT_RESET		BIT(0)
+
 #define ADIN1300_GE_RGMII_CFG_REG		0xff23
 #define   ADIN1300_GE_RGMII_RX_MSK		GENMASK(8, 6)
 #define   ADIN1300_GE_RGMII_RX_SEL(x)		\
@@ -443,11 +447,49 @@ static int adin_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
+static int adin_subsytem_soft_reset(struct phy_device *phydev)
+{
+	int reg, rc, i;
+
+	rc = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+			      ADIN1300_GE_SOFT_RESET_REG,
+			      ADIN1300_GE_SOFT_RESET);
+	if (rc < 0)
+		return rc;
+
+	for (i = 0; i < 20; i++) {
+		usleep_range(500, 1000);
+		reg = phy_read_mmd(phydev, MDIO_MMD_VEND1,
+				   ADIN1300_GE_SOFT_RESET_REG);
+		if (reg < 0 || (reg & ADIN1300_GE_SOFT_RESET))
+			continue;
+		return 0;
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int adin_reset(struct phy_device *phydev)
+{
+	/* If there is a reset GPIO just exit */
+	if (!IS_ERR_OR_NULL(phydev->mdio.reset_gpio))
+		return 0;
+
+	/* Reset PHY core regs & subsystem regs */
+	return adin_subsytem_soft_reset(phydev);
+}
+
+static int adin_probe(struct phy_device *phydev)
+{
+	return adin_reset(phydev);
+}
+
 static struct phy_driver adin_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
 		.name		= "ADIN1200",
 		.config_init	= adin_config_init,
+		.probe		= adin_probe,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
 		.ack_interrupt	= adin_phy_ack_intr,
@@ -461,6 +503,7 @@ static struct phy_driver adin_driver[] = {
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
 		.name		= "ADIN1300",
 		.config_init	= adin_config_init,
+		.probe		= adin_probe,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
 		.ack_interrupt	= adin_phy_ack_intr,
-- 
2.20.1

