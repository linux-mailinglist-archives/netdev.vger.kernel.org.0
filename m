Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D017587B76
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436564AbfHINhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:37:11 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:28390 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406638AbfHINgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:23 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DNF69031477;
        Fri, 9 Aug 2019 09:36:14 -0400
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2055.outbound.protection.outlook.com [104.47.37.55])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u7xkj783x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjrSDJc3GTU4L/5qlsgHtM++dAxLOA5jiBJmUewiEd6TCANTseDuPwl1RTxNSLOKEG+8TqaP2BwXhPy5JZKNymAlMndmr7Rg4r/5irfdfzVJs+sPVxGaLzqKWDLpiYW259DBUwkzdxNRthrV3BL0be3a7IJJZLEDEQOKcFfEQVoVIQYSUDUTfxdd8mkZCL3mj8mWNHo3si09LjsUiz7iUKvisEDsUQXxr/lBTdD997zwVqaueSXVpfbRM8G0uLYId0G3ms44PW78D05unhtl6KaaHdyJC/QyGYmpgDzqLdjjRCmtAstvqDbdJDesqtPhXkHbCV+R9k+wQh8mmVq4fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPHSFdWJgdglKAWSLuhbzzZ0TlQ6k7KIfnL06ksBk9c=;
 b=SFLewTLasOkNrkG0hzyiAa3m9l49a9qz8L/CpBsYonRvwdRAGR1i39SkkPM+MDC50+ROMfIsHhV1L3D8B1mn9aJVmEf5ZpGrp5t+mthBl36VnfOpd8hbf8Hf95DV2ZYCQ9fX3pDXVi1U3E2JW2IA8iEbQmJxQOgi00tjREulW+3I9lx4EXBtnr8GiB86pHplVikz5r459YTBLYW03g+QohQSFzVBVvcgguC7/egL8nO5ejc8KBdq5VTwxD238C1m1ZVTZ+txW3sxXnRSd6USriFLVN9C6WPsQeY2CcD9/LV+DjW4Mwtndj80NwjLKKX/nrxZ1R05ywnJ8PBqDtIHKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPHSFdWJgdglKAWSLuhbzzZ0TlQ6k7KIfnL06ksBk9c=;
 b=UgPMv3SfvRJHlcsCREQ/eEJnocpUfQAvAAeDEvHZ7qxAWFkErOZCaUdFcxppwoVQ0pjJN1/Yp/yB+CP0AabtiiPQZKU1C364sUxQIMEZbAJEBOJPLIKLtQ8lTo20xyanfM8BrBeltAWucDk8wbKr+cbFBpbYh2x/+qF35OXwnqI=
Received: from CY1PR03CA0024.namprd03.prod.outlook.com (2603:10b6:600::34) by
 BYAPR03MB4151.namprd03.prod.outlook.com (2603:10b6:a03:7c::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Fri, 9 Aug 2019 13:36:12 +0000
Received: from BL2NAM02FT052.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::201) by CY1PR03CA0024.outlook.office365.com
 (2603:10b6:600::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.16 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:11 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT052.mail.protection.outlook.com (10.152.77.0) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:36:11 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79DaBwm025696
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:36:11 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:36:10 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 07/14] net: phy: adin: make RMII fifo depth configurable
Date:   Fri, 9 Aug 2019 16:35:45 +0300
Message-ID: <20190809133552.21597-8-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(136003)(396003)(346002)(39860400002)(2980300002)(189003)(199004)(106002)(305945005)(7636002)(316002)(70206006)(54906003)(107886003)(110136005)(70586007)(8936002)(4326008)(50226002)(47776003)(48376002)(8676002)(246002)(36756003)(356004)(5660300002)(2870700001)(2906002)(1076003)(6666004)(446003)(11346002)(26005)(2616005)(476003)(426003)(51416003)(336012)(186003)(2201001)(76176011)(478600001)(7696005)(486006)(44832011)(86362001)(126002)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4151;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e4dce34-54ae-4d54-48bc-08d71cce8ae3
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:BYAPR03MB4151;
X-MS-TrafficTypeDiagnostic: BYAPR03MB4151:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4151DE517D3CAD294EBF8875F9D60@BYAPR03MB4151.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: j9ToRgV/0EDtPb/3xLb+w6u6dYzKBBEyUMGpEyvSoDsJ3J7Umiuu38xBKRe+2zv4ZqhMjGocJCPgVdXDlzkHEFcCl6fBPGI943/N8+/HChIMzKjCVojDeWRaL9DfIAYFGc29/SiH0/xP5x+9zRencoDVAm1t/edQcEOK0U433JFuoETGpYzTv6jEsIyGxEobWOZndZ+9ouo+MN3hODTleKkJ3rG5l3JkOMGJ30LcyXSrPpj1G2is/47Qm/l3pi3EUEgiDFmbV9yvwDfFOADkPB93rXrSG50IMfgZZNqaeFuyTTekJn+mP6DlPxVTY9Y6lFxOpgWs7JR4ydUqIDrwcfmyLkn0SN4vF9bspxEwOv1DHsWjDxyPruOToC3mdfDmdUcHhWhfIg6BS6189OXyou3W2plyIOLpFZnZnShiSEc=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:36:11.4225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e4dce34-54ae-4d54-48bc-08d71cce8ae3
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4151
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=714 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FIFO depth can be configured for the RMII mode. This change adds
support for doing this via device-tree (or ACPI).

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 06d3db75c3db..a076887bf165 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -54,8 +54,19 @@
 #define	ADIN1300_RGMII_2_40_NS			0x0007
 
 #define ADIN1300_GE_RMII_CFG_REG		0xff24
+#define   ADIN1300_GE_RMII_FIFO_DEPTH_MSK	GENMASK(6, 4)
+#define   ADIN1300_GE_RMII_FIFO_DEPTH_SEL(x)	\
+		FIELD_PREP(ADIN1300_GE_RMII_FIFO_DEPTH_MSK, x)
 #define   ADIN1300_GE_RMII_EN			BIT(0)
 
+/* RMII fifo depth values */
+#define ADIN1300_RMII_4_BITS			0x0000
+#define ADIN1300_RMII_8_BITS			0x0001
+#define ADIN1300_RMII_12_BITS			0x0002
+#define ADIN1300_RMII_16_BITS			0x0003
+#define ADIN1300_RMII_20_BITS			0x0004
+#define ADIN1300_RMII_24_BITS			0x0005
+
 /**
  * struct adin_cfg_reg_map - map a config value to aregister value
  * @cfg		value in device configuration
@@ -75,6 +86,16 @@ static const struct adin_cfg_reg_map adin_rgmii_delays[] = {
 	{ },
 };
 
+static const struct adin_cfg_reg_map adin_rmii_fifo_depths[] = {
+	{ 4,  ADIN1300_RMII_4_BITS },
+	{ 8,  ADIN1300_RMII_8_BITS },
+	{ 12, ADIN1300_RMII_12_BITS },
+	{ 16, ADIN1300_RMII_16_BITS },
+	{ 20, ADIN1300_RMII_20_BITS },
+	{ 24, ADIN1300_RMII_24_BITS },
+	{ },
+};
+
 static int adin_lookup_reg_value(const struct adin_cfg_reg_map *tbl, int cfg)
 {
 	size_t i;
@@ -158,6 +179,7 @@ static int adin_config_rgmii_mode(struct phy_device *phydev)
 
 static int adin_config_rmii_mode(struct phy_device *phydev)
 {
+	u32 val;
 	int reg;
 
 	if (phydev->interface != PHY_INTERFACE_MODE_RMII)
@@ -171,6 +193,13 @@ static int adin_config_rmii_mode(struct phy_device *phydev)
 
 	reg |= ADIN1300_GE_RMII_EN;
 
+	val = adin_get_reg_value(phydev, "adi,fifo-depth-bits",
+				 adin_rmii_fifo_depths,
+				 ADIN1300_RMII_8_BITS);
+
+	reg &= ~ADIN1300_GE_RMII_FIFO_DEPTH_MSK;
+	reg |= ADIN1300_GE_RMII_FIFO_DEPTH_SEL(val);
+
 	return phy_write_mmd(phydev, MDIO_MMD_VEND1,
 			     ADIN1300_GE_RMII_CFG_REG, reg);
 }
-- 
2.20.1

