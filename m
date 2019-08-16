Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 374FE90297
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfHPNL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:11:28 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:8192 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727385AbfHPNKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:10:55 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7GD7nkS020798;
        Fri, 16 Aug 2019 09:10:48 -0400
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2050.outbound.protection.outlook.com [104.47.44.50])
        by mx0b-00128a01.pphosted.com with ESMTP id 2udu300ayc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 09:10:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=az254EpTD3HIJ9hHaRVVKnzVqZgWkglMIv1prLhasQz2PnVESBwKHoo5oYvH2c4MkJoE6aQojuF1VRMC0r9vKclzyTv5fP4i+hyuBwoHzQARlW+aD/S7iy6/ZVjExpWtegcQmzWJaVa1bldQeTFVfP9ucWZzY03BM2yjO93SAEu2NZcvomxCejgEgrfP/La1T7QbUdBb8dpNUTVRWL3LXKdWytAJ9SntJyvOs2/o5ADBGPCiMJwxoxc1xhCBfcAxO4jjeVOG5/TLrYRDv9PVpW6g0hdrqbQH7kHTClfzV69Jm/0xASY53v8pFxO8Jln47PMD4ffYa+D421OXLuIJNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aM5Q2sotsJUHLdu7k31JAMNFezsalGcRqYwosKKxImc=;
 b=jHaW4igrj8pMzcF528iS0m8M6Jger2Zw6r+xnJs8bOMBAV8qkZz/RmyI7Et+tu8t94v2s81udaykgnC4R1Qcr906MHNQh0xgZ3UTOK7uZ3+eBkFsTW/RoL6deYyMQhJ7RLKPM/TBgGEsk+IUO1rxWW+GLwo/JXNj758WtCE1GzyBxg9DQzRFx7Vot7xcL7LJYwpITe5JMCk2BUr/UlIJD5bqIwM3C1UV/NqLZXbMB77nO/b5pUBnqrCKewLKIrRuI9Gl5EFoMCE6XKqa2JaAeKS55iNwJRIwajDlGo02KgsyMEv45+29eduBpupX+XIjxy3YA5TECYBxw5HKrPFfTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aM5Q2sotsJUHLdu7k31JAMNFezsalGcRqYwosKKxImc=;
 b=6KLa+aNFgnsGjhJTLpwbhtiCXM1uDq0Q0al38LYjBbYMv4z6dDFaWDqfLrTiVsR0OHC9mTNP7X93utJ27mUBXYyvV8rP+/yqr7/F3BDHwO2+JAR3G5mXx4Y0WgrHKK+eKZoEyWku0YOxwou537s9ju5+9PtLHrxglP8nLoHb3PE=
Received: from DM6PR03CA0022.namprd03.prod.outlook.com (2603:10b6:5:40::35) by
 MWHPR03MB2845.namprd03.prod.outlook.com (2603:10b6:300:11d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.16; Fri, 16 Aug
 2019 13:10:45 +0000
Received: from SN1NAM02FT062.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::202) by DM6PR03CA0022.outlook.office365.com
 (2603:10b6:5:40::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.14 via Frontend
 Transport; Fri, 16 Aug 2019 13:10:44 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT062.mail.protection.outlook.com (10.152.72.208) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 13:10:44 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7GDAhO0007931
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 16 Aug 2019 06:10:43 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 16 Aug 2019 09:10:43 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 10/13] net: phy: adin: implement PHY subsystem software reset
Date:   Fri, 16 Aug 2019 16:10:08 +0300
Message-ID: <20190816131011.23264-11-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816131011.23264-1-alexandru.ardelean@analog.com>
References: <20190816131011.23264-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(346002)(376002)(2980300002)(189003)(199004)(107886003)(2870700001)(70586007)(5660300002)(70206006)(186003)(426003)(4326008)(356004)(2906002)(6666004)(126002)(478600001)(476003)(446003)(2616005)(486006)(1076003)(44832011)(11346002)(110136005)(316002)(26005)(106002)(54906003)(336012)(36756003)(305945005)(51416003)(7636002)(48376002)(50466002)(2201001)(76176011)(8676002)(8936002)(14444005)(246002)(47776003)(7696005)(50226002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR03MB2845;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4e1e8b2-38e4-4078-3645-08d7224b25b5
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:MWHPR03MB2845;
X-MS-TrafficTypeDiagnostic: MWHPR03MB2845:
X-Microsoft-Antispam-PRVS: <MWHPR03MB28450C2B10F85630E0FE0462F9AF0@MWHPR03MB2845.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: R1bJbjE98KhYQdYZBoQNcANmrhXLV5dk4ce5NYPr4PylJygAqXGzQJcCvtGv5x2j7PlC2hd/yWOVPMYqpdqS4bBl9hAqDZBys3Bq7IqKw5yeyeC6cqHAPVXNiR0qowYIc3eQvWD6pLokbPoRdjkN7Dm2er1PTj9d4k5Kt1tjny6Ca0kRQsdl23vgySVAxSNE9pL6m6zzjEmavw/s2mwzQ1ySq3voBJxdYq7Ag729BxdHW7xX02YghzzPOJ+ucdNWTGkdZ/CwQFMJkonlE/Px+8C3yQ9vCFp7XAhW29zORplUox2jMw+iIKj30Sjjl4RxFppn8Oxf8FRUiGRZhiNm4e9LIcQwC2kt4lRHf1YTI+k4y5jlvrP0yaJW7sr+lmn6o66q/h/GykzJ8X1BMpiWbUHaA+C35TrZu7MpU5KTABs=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 13:10:44.2175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e1e8b2-38e4-4078-3645-08d7224b25b5
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR03MB2845
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=725 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ADIN PHYs supports 4 types of reset:
1. The standard PHY reset via BMCR_RESET bit in MII_BMCR reg
2. Reset via GPIO
3. Reset via reg GeSftRst (0xff0c) & reload previous pin configs
4. Reset via reg GeSftRst (0xff0c) & request new pin configs

Resets 2, 3 & 4 are almost identical, with the exception that the crystal
oscillator is available during reset for 2.

This change implements subsystem software reset via the GeSftRst and
reloading the previous pin configuration (so reset number 3).
This will also reset the PHY core regs (similar to reset 1).

Since writing bit 1 to reg GeSftRst is self-clearing, the only thing that
can be done, is to write to that register, wait a specific amount of time
(10 milliseconds should be enough) and try to read back and check if there
are no errors on read. A busy-wait-read won't work well, and may sometimes
work or not work.

In case phylib is configured to also do a reset via GPIO, the ADIN PHY may
be reset twice when the PHY device registers, but that isn't a problem,
since it's being done on boot (or PHY device register).

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 131b7f85ae32..5622a393e7cf 100644
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
@@ -50,6 +51,9 @@
 #define ADIN1300_CLOCK_STOP_REG			0x9400
 #define ADIN1300_LPI_WAKE_ERR_CNT_REG		0xa000
 
+#define ADIN1300_GE_SOFT_RESET_REG		0xff0c
+#define   ADIN1300_GE_SOFT_RESET		BIT(0)
+
 #define ADIN1300_GE_RGMII_CFG_REG		0xff23
 #define   ADIN1300_GE_RGMII_RX_MSK		GENMASK(8, 6)
 #define   ADIN1300_GE_RGMII_RX_SEL(x)		\
@@ -442,11 +446,32 @@ static int adin_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
+static int adin_soft_reset(struct phy_device *phydev)
+{
+	int rc;
+
+	/* The reset bit is self-clearing, set it and wait */
+	rc = phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+			      ADIN1300_GE_SOFT_RESET_REG,
+			      ADIN1300_GE_SOFT_RESET);
+	if (rc < 0)
+		return rc;
+
+	msleep(10);
+
+	/* If we get a read error something may be wrong */
+	rc = phy_read_mmd(phydev, MDIO_MMD_VEND1,
+			  ADIN1300_GE_SOFT_RESET_REG);
+
+	return rc < 0 ? rc : 0;
+}
+
 static struct phy_driver adin_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
 		.name		= "ADIN1200",
 		.config_init	= adin_config_init,
+		.soft_reset	= adin_soft_reset,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
 		.ack_interrupt	= adin_phy_ack_intr,
@@ -460,6 +485,7 @@ static struct phy_driver adin_driver[] = {
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
 		.name		= "ADIN1300",
 		.config_init	= adin_config_init,
+		.soft_reset	= adin_soft_reset,
 		.config_aneg	= adin_config_aneg,
 		.read_status	= adin_read_status,
 		.ack_interrupt	= adin_phy_ack_intr,
-- 
2.20.1

