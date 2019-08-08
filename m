Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4980D861D3
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403864AbfHHMbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:31:51 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:25972 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727649AbfHHMa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:30:58 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CSGhT002639;
        Thu, 8 Aug 2019 08:30:52 -0400
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2050.outbound.protection.outlook.com [104.47.44.50])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfkv4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:30:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H137CVY5jHaVMSm+iaXStYawCqcpmpq7BVgIdIVW8iGyVAuYAUIFy9f2MYzNt5HJPe8HRZbdW69m45t1btF/K+jyd3sjZmfiHiO7uPjcVWJb8feppkuSNoI+OGTclkXkzKkaZJJzAqzqbj81pZASVQSki7PE88BucYiTNdZIxzmOQb5DDsW4Wk7wuLXWVbrcYFGLWfokX08hNeNCCGkVs89VCsAehBHcx11EnIP53J9eVs+B4COw0Ehi47SpSD9ATBhfrjnIhRutyknjCXc0iFeYa9CXSHWm6p7txD1BcKTncLKeph9TAbgE7R9tDPGC3suelkWEOcomtsTKE5BcrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lo87MbwsScP4O3fIARcBRherYlw2H1yF42su7ZJiLy0=;
 b=OFac1LWMfbXZFpvZkZzrkNw8Vm7HJDaNHRhm3IVFMHj5e1E/CQSngoVVfQaNdqUkS9Ux6tunYXaC3I6fMzPzIkoXAlTTwjiUnaR0IyfpLw0CfhHvPm3yXhHnLQ50ZawqsB91+73qacheIrOCTUWuGjCue9A3RZV9aBL25UfNQNBUUpKY5ICS48ZZWf4XIZXh5RiGp++u2cuo0oBMXazROW5wJzBbkQwVZby0sq0pfJcw+tmolnaoyJnIOhcpqZtCUGdLELMozgh6hW7JSZ+bq2YRoCOdpBxZP7qqkOFf6rDe9pSAj+/CzYoncB+/Owo6BerkeOkeCKWxXJnxXhbWcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lo87MbwsScP4O3fIARcBRherYlw2H1yF42su7ZJiLy0=;
 b=GT+f0L0QF4RuQwCkxA5LhCw62Us0QCXB2MEU854QytLzrufDhCGfgv5jyIMhsVp2iDzcQunjLAYPgPkRORnYcKbeNRA0cr0yj/g8IF6TdoTD1Cr1cSfaJZS5twp9XSaHoZ6CKVI9SmnSYHQcO4vctyUH9TMezo1lWo0/wttPK5M=
Received: from BN3PR03CA0055.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::15) by SN6PR03MB3775.namprd03.prod.outlook.com
 (2603:10b6:805:6a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2115.10; Thu, 8 Aug
 2019 12:30:49 +0000
Received: from SN1NAM02FT051.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::203) by BN3PR03CA0055.outlook.office365.com
 (2a01:111:e400:7a4d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.15 via Frontend
 Transport; Thu, 8 Aug 2019 12:30:49 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT051.mail.protection.outlook.com (10.152.73.103) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:30:48 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CUm0K021246
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:30:48 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:30:47 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 08/15] net: phy: adin: make RMII fifo depth configurable
Date:   Thu, 8 Aug 2019 15:30:19 +0300
Message-ID: <20190808123026.17382-9-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(376002)(39860400002)(2980300002)(189003)(199004)(446003)(426003)(11346002)(70206006)(2616005)(186003)(126002)(1076003)(5660300002)(476003)(336012)(2870700001)(86362001)(7636002)(356004)(70586007)(6666004)(486006)(246002)(2906002)(36756003)(2201001)(305945005)(54906003)(47776003)(50466002)(26005)(48376002)(8936002)(44832011)(478600001)(76176011)(50226002)(8676002)(51416003)(316002)(106002)(110136005)(7696005)(4326008)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR03MB3775;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d20b014f-3978-4bb3-d86b-08d71bfc3eb0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:SN6PR03MB3775;
X-MS-TrafficTypeDiagnostic: SN6PR03MB3775:
X-Microsoft-Antispam-PRVS: <SN6PR03MB3775E451D5170F2572ECDFAAF9D70@SN6PR03MB3775.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 2FEzn/lrj/vih2/nwuoPDgL51zb84ubGJ0il4pciiVBC3X8ZCaDF7duQ0ZzKcOBVpBG1yR7H3bX2TBKCfp6Hlif5Lz60jnj305PvdO6elxiOX2/HcB+IzyFnzpTPVheLTi/1DQ3zs5IgoFUdQFKwSygbk2tZuPOCC6pGrUStfwGELVJMSRPW8Emade+ZYu/lfhibaQgtzJXpKkxkAS9aJgqEeiD6O5TGRC5y6ty/r5C8/GByxKs1D24dNrMhoRl6uazPXz9p7RLu6L0DxEWByS9Fwn3DWtWfF/PgGcI7yScHGEWQM58Jyg84V0SvPQhVffDd2F0MVSewtwAirZfwcDXWz7rP/T8mt32G55fbL/S6qQehFOC0hyyqwcC+uOeD4dCAWc/tg4aWTLczFqAzQffDAbjmeXB/0+CvZupnqAM=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:30:48.8986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d20b014f-3978-4bb3-d86b-08d71bfc3eb0
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB3775
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=724 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FIFO depth can be configured for the RMII mode. This change adds
support for doing this via device-tree (or ACPI).

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 62c1268e55f7..26b2f2b21596 100644
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

