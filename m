Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18F60902AE
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfHPNMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:12:00 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:52496 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727258AbfHPNKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:10:41 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7GD7kwL020744;
        Fri, 16 Aug 2019 09:10:33 -0400
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2054.outbound.protection.outlook.com [104.47.42.54])
        by mx0b-00128a01.pphosted.com with ESMTP id 2udu300axx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 09:10:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cyHc/U5lqkV6WRaGbgrv1p7gEamNGwYk7CpJAyk/5696OZ2hvlBR9bnSrXog4Q7vf8pC/U4e5ZAL2XaRXAHD5q5bGEt3oSsN8qpRRJwT8oOhHVPr8ija7B4zagYEIS1IJeqpAjsszqh+gjJS5QLoM26AR9GprzaHsQtI8uqzQnoACug7jdzbNtMpKzBl8FbwoUu17DjOgV+PfL1SB8MzxtbJkaSqgS35427v44LRotBc4nmLSyHsD4pXE07Nk1cMhfR5WShfMqShcNWPEFbVEYahgyN3zJ5K5fnvuLGin30htu8tZXH0TrIYiX7QNtFM4jRUfx2uahpZShcRboF1nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eT8Q/4emc70nb8mCPK0R0Vk1wdC6Hj1KLljR+UB/2/U=;
 b=MDGpdwrJ3jB0OpzQ9ZcyuWLZoisMiLR/eEY/1C8wxA6HiEV6RnqH8e/REQWbyTwKBxJorox6Dpf1qFTD2aLwZaDY1sZMVx0MF0/r0xEASvZjgWqKN7uu9jGRh65CFwIHpeYvQWMXJXOnO9UtxQHONuwbzSxJ6+z9lXRTAci+mGOSJqDmfGyFvm3FWiIFP5YtZBxSTa2l/dIRY8UcN0nRV0opm+etbuftZpjzzTAkP79GtwsFVjPvC7hGkRFZ+G9HZLmyO+5fgMQcLhdi+DFNBRMPtYywdtm0EjwfVnL45GcZZWWTTJh7b87D1IkS+K/cGSpL51No2y0kmjmQodxY1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eT8Q/4emc70nb8mCPK0R0Vk1wdC6Hj1KLljR+UB/2/U=;
 b=qSsXaYupEFehm2PmGPcm/mYJC7wZaUC01lxhQLUwFAE5kbqBBf08Irmqgz3p4fVeKCfJjR43WYbjc4XBIPLIy3ubBeNsRJbuPzSNpXKzztdDhNOOM6HGiorO4LLm4eQpePjETKIHdAwzS4KD12Hv08KpbLa4wXU1gWUuCOtqVVM=
Received: from BY5PR03CA0024.namprd03.prod.outlook.com (2603:10b6:a03:1e0::34)
 by BN6PR03MB2882.namprd03.prod.outlook.com (2603:10b6:404:10f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.16; Fri, 16 Aug
 2019 13:10:30 +0000
Received: from SN1NAM02FT005.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::209) by BY5PR03CA0024.outlook.office365.com
 (2603:10b6:a03:1e0::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2178.16 via Frontend
 Transport; Fri, 16 Aug 2019 13:10:30 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT005.mail.protection.outlook.com (10.152.72.117) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 13:10:29 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7GDATv9007864
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 16 Aug 2019 06:10:29 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 16 Aug 2019 09:10:28 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 03/13] net: phy: adin: add support for interrupts
Date:   Fri, 16 Aug 2019 16:10:01 +0300
Message-ID: <20190816131011.23264-4-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816131011.23264-1-alexandru.ardelean@analog.com>
References: <20190816131011.23264-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(376002)(136003)(39860400002)(346002)(396003)(2980300002)(199004)(189003)(246002)(7636002)(305945005)(47776003)(50466002)(6666004)(5660300002)(2870700001)(48376002)(2906002)(107886003)(2201001)(86362001)(1076003)(4326008)(11346002)(446003)(476003)(106002)(2616005)(126002)(426003)(336012)(8936002)(36756003)(14444005)(50226002)(70206006)(8676002)(186003)(70586007)(26005)(478600001)(316002)(44832011)(110136005)(54906003)(486006)(51416003)(76176011)(356004)(7696005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR03MB2882;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 613533b8-8636-4ecd-0486-08d7224b1d2c
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BN6PR03MB2882;
X-MS-TrafficTypeDiagnostic: BN6PR03MB2882:
X-Microsoft-Antispam-PRVS: <BN6PR03MB288289DE9D7E450464AC3B22F9AF0@BN6PR03MB2882.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ahEhN6PFP0FhinkdNyVvaTbw8igIeSg4TsCBpWfiaR6vwDiBI56DrKot4qUxQnnAFzDgRIbrJVNvzCI6a7SZZ/Lida/DnxvJaIStw057kwV43la/51FJIsVVDBL5+g1zwu6pqK77MhRsxfQ1hI7G8B/J0+MfGPqa53EA6t3q9+3UlGxTzlLvKGKa0d4gOfL/wlgUSsOwEUSQoMkE8ytpTSFrhnHglLFnKQqwWIiQxdQRHxwr1LvhXrN0AW31JgRquGpHSfSjqPURb16ybvp7Ga7ErNBT3IAlX1WTh0KC33OCbC1E3jozJG+Ys+67P0aiWZiDSNj7jY1++4MVqCg7YnyKn1AC720+vqbsIVVeAXEENPH7VwwVfeCrM60hxTHmFirP0YVIXVES4ke5TXZ1+VJN04C/vHMP8X8NY0aL3dI=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 13:10:29.9126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 613533b8-8636-4ecd-0486-08d7224b1d2c
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB2882
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change hooks link-status-change interrupts to phylib.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index fc0148ba4b94..f4ee611e33df 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -14,11 +14,43 @@
 #define PHY_ID_ADIN1200				0x0283bc20
 #define PHY_ID_ADIN1300				0x0283bc30
 
+#define ADIN1300_INT_MASK_REG			0x0018
+#define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
+#define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
+#define   ADIN1300_INT_ANEG_PAGE_RX_EN		BIT(6)
+#define   ADIN1300_INT_IDLE_ERR_CNT_EN		BIT(5)
+#define   ADIN1300_INT_MAC_FIFO_OU_EN		BIT(4)
+#define   ADIN1300_INT_RX_STAT_CHNG_EN		BIT(3)
+#define   ADIN1300_INT_LINK_STAT_CHNG_EN	BIT(2)
+#define   ADIN1300_INT_SPEED_CHNG_EN		BIT(1)
+#define   ADIN1300_INT_HW_IRQ_EN		BIT(0)
+#define ADIN1300_INT_MASK_EN	\
+	(ADIN1300_INT_LINK_STAT_CHNG_EN | ADIN1300_INT_HW_IRQ_EN)
+#define ADIN1300_INT_STATUS_REG			0x0019
+
 static int adin_config_init(struct phy_device *phydev)
 {
 	return genphy_config_init(phydev);
 }
 
+static int adin_phy_ack_intr(struct phy_device *phydev)
+{
+	/* Clear pending interrupts */
+	int rc = phy_read(phydev, ADIN1300_INT_STATUS_REG);
+
+	return rc < 0 ? rc : 0;
+}
+
+static int adin_phy_config_intr(struct phy_device *phydev)
+{
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		return phy_set_bits(phydev, ADIN1300_INT_MASK_REG,
+				    ADIN1300_INT_MASK_EN);
+
+	return phy_clear_bits(phydev, ADIN1300_INT_MASK_REG,
+			      ADIN1300_INT_MASK_EN);
+}
+
 static struct phy_driver adin_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
@@ -26,6 +58,8 @@ static struct phy_driver adin_driver[] = {
 		.config_init	= adin_config_init,
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
+		.ack_interrupt	= adin_phy_ack_intr,
+		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 	},
@@ -35,6 +69,8 @@ static struct phy_driver adin_driver[] = {
 		.config_init	= adin_config_init,
 		.config_aneg	= genphy_config_aneg,
 		.read_status	= genphy_read_status,
+		.ack_interrupt	= adin_phy_ack_intr,
+		.config_intr	= adin_phy_config_intr,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 	},
-- 
2.20.1

