Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680BA87B5D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436521AbfHINgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:36:37 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:13016 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406778AbfHINgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:36:36 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79DMxha000763;
        Fri, 9 Aug 2019 09:36:27 -0400
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2054.outbound.protection.outlook.com [104.47.40.54])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u8bmpn4jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 09:36:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hg/gyqrukG0x64JJY0BSEVHxyDZAX5WwQOA7yjFWIZY/LJuPUi3FvcRHYKD1kKK6B/7qpbQe4vAUjrX8BWaOY9VgzLSe0OgUBEhIrohjwR2QEoR18ToU2hBqZ3v/b91KqxZpaHN3Sw7AuoIZMDbil5Sc8ZLYJ6FCkxdPNqJn8Jiqw64uSGoRDltVPKT26nZ/kIclikgaFmaaoBOHeSTK216RS58Pg2iQ8MkEb42/1wPzucq1e/1EIwBi44NFPezrotDCg3WMu05A86f7IhmMPAwPV3eqnkgk2ko1j0RlInEQ5FFkhPtGqZx/1KlxoF3BWpLNwArmW7yLIi4jrxEg0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANvlr3vejcShypTXFEinxx3AorcjS6oJvkMWvL01SLQ=;
 b=b3ZZNEPm+3N7u/MHh36TWOI7w/wz4Rtf8cwhMRMKrJQgF1I3X99U5iSgjiBLqNacruA1Kol2L99LCbAgHNVpNADJRwpmdbtMXYBcWG6H0TTFmoxtzSSgFuILiCYVaB/6b+6iKgXWOEME+H32989TizHIk4qegvO2lWzCchj7toAhmTz0fg7p53mWt9wbC59hOav7XKl9t7qRlY7jPmyt7+TWnQlt9LgO6Xyoc97j4LkkJ/iE2U6HpmUfrt4nETw3VZvpOFebs4m7vB1oAoSBPteK7hlkCfeXjV9LNuN+h469VXuFazCZkOQDJQDNnpbtLySJyjRbymKRpmuviiBAgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANvlr3vejcShypTXFEinxx3AorcjS6oJvkMWvL01SLQ=;
 b=4QWSOwneMZlZwn9zGybIK25VikzCjI87MXd0qmC0XRV1SU6DdL16EIsliKMt6EkpnYYq+GS+YYwf9iNb9oy0jdASIARpyP07lS278eLcS6Ab9HCVmoc0+TrvR/DMTRN8RwzLJnU62GcB3iQwe0KFqIsDWujonyX3YHM97q3hbUI=
Received: from BN6PR03CA0079.namprd03.prod.outlook.com (2603:10b6:405:6f::17)
 by DM6PR03MB3626.namprd03.prod.outlook.com (2603:10b6:5:ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14; Fri, 9 Aug
 2019 13:36:24 +0000
Received: from CY1NAM02FT053.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::200) by BN6PR03CA0079.outlook.office365.com
 (2603:10b6:405:6f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.15 via Frontend
 Transport; Fri, 9 Aug 2019 13:36:24 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT053.mail.protection.outlook.com (10.152.74.165) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 13:36:23 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x79DaNcq025773
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 06:36:23 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 9 Aug 2019 09:36:22 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v3 13/14] net: phy: adin: add ethtool get_stats support
Date:   Fri, 9 Aug 2019 16:35:51 +0300
Message-ID: <20190809133552.21597-14-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133552.21597-1-alexandru.ardelean@analog.com>
References: <20190809133552.21597-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39850400004)(346002)(136003)(396003)(376002)(2980300002)(189003)(199004)(47776003)(36756003)(8676002)(316002)(110136005)(11346002)(44832011)(26005)(7696005)(51416003)(76176011)(186003)(446003)(14444005)(2870700001)(6666004)(486006)(2906002)(54906003)(126002)(476003)(2616005)(356004)(107886003)(426003)(2201001)(48376002)(50226002)(8936002)(336012)(305945005)(50466002)(5660300002)(4326008)(86362001)(106002)(1076003)(246002)(7636002)(70206006)(70586007)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB3626;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4459bddc-139c-4a61-bd46-08d71cce928a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:DM6PR03MB3626;
X-MS-TrafficTypeDiagnostic: DM6PR03MB3626:
X-Microsoft-Antispam-PRVS: <DM6PR03MB3626E561A7CF890940DD6B5CF9D60@DM6PR03MB3626.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: GNieAwBsCX4ka2F6qEPL6vIKRO8/zqgkKcoagr95W0FE9b9gDWrQy5SnepNCsdacAbt97CKfqCyZUg3KUrNDS9P6w6x0m+mKpEPFl3M9kAY/zEiKCT4OyqR00ElIxWWGWEA5M73lfTZk5K6Rl3QeX1RfIWzoAqiOvVXGgWKSvNIpp61YRbdLHUxL+eCqPkXd4LuOdSbcUwFNjGLK2vkEc5zdiQIcAmOCjWN0M/r5e1UJodUafbxOP8cWbUoI6d7pFjwqHgatdqP37MnVOpXjktG/uid/oBRrpmvCLHVQTeanadbcYfqeGAd8m7cuXN3QXwlsNOBOo9yH/uGjG3mLDpBB94o6nlkaRTwqK+5JyU2DdaEw9MvZWder11G8+SbOy/bLYeRD+lYm3Ce7FgXnYCTZbKc2VQfVrWfxD+oOIs4=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 13:36:23.8116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4459bddc-139c-4a61-bd46-08d71cce928a
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3626
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change implements retrieving all the error counters from the PHY.
The PHY supports several error counters/stats. The `Mean Square Errors`
status values are only valie when a link is established, and shouldn't be
accumulated. These values characterize the quality of a signal.

The rest of the error counters are self-clearing on read.
Most of them are reports from the Frame Checker engine that the PHY has.

Not retrieving the `LPI Wake Error Count Register` here, since that is used
by the PHY framework to check for any EEE errors. And that register is
self-clearing when read (as per IEEE spec).

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 109 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index fb39104508ff..28424209d9c3 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -154,12 +154,40 @@ static struct adin_clause45_mmd_map adin_clause45_mmd_map[] = {
 	{ MDIO_MMD_PCS, MDIO_PCS_EEE_WK_ERR,	ADIN1300_LPI_WAKE_ERR_CNT_REG },
 };
 
+struct adin_hw_stat {
+	const char *string;
+	u16 reg1;
+	u16 reg2;
+	bool do_not_accumulate;
+};
+
+/* Named just like in the datasheet */
+static struct adin_hw_stat adin_hw_stats[] = {
+	{ "RxErrCnt",		0x0014,	},
+	{ "MseA",		0x8402,	0,	true },
+	{ "MseB",		0x8403,	0,	true },
+	{ "MseC",		0x8404,	0,	true },
+	{ "MseD",		0x8405,	0,	true },
+	{ "FcFrmCnt",		0x940A, 0x940B }, /* FcFrmCntH + FcFrmCntL */
+	{ "FcLenErrCnt",	0x940C },
+	{ "FcAlgnErrCnt",	0x940D },
+	{ "FcSymbErrCnt",	0x940E },
+	{ "FcOszCnt",		0x940F },
+	{ "FcUszCnt",		0x9410 },
+	{ "FcOddCnt",		0x9411 },
+	{ "FcOddPreCnt",	0x9412 },
+	{ "FcDribbleBitsCnt",	0x9413 },
+	{ "FcFalseCarrierCnt",	0x9414 },
+};
+
 /**
  * struct adin_priv - ADIN PHY driver private data
  * edpd_enabled		true if Energy Detect Powerdown mode is enabled
+ * stats		statistic counters for the PHY
  */
 struct adin_priv {
 	bool			edpd_enabled;
+	u64			stats[ARRAY_SIZE(adin_hw_stats)];
 };
 
 static int adin_lookup_reg_value(const struct adin_cfg_reg_map *tbl, int cfg)
@@ -604,6 +632,81 @@ static int adin_reset(struct phy_device *phydev)
 	return adin_subsytem_soft_reset(phydev);
 }
 
+static int adin_get_sset_count(struct phy_device *phydev)
+{
+	return ARRAY_SIZE(adin_hw_stats);
+}
+
+static void adin_get_strings(struct phy_device *phydev, u8 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(adin_hw_stats); i++) {
+		strlcpy(&data[i * ETH_GSTRING_LEN],
+			adin_hw_stats[i].string, ETH_GSTRING_LEN);
+	}
+}
+
+static int adin_read_mmd_stat_regs(struct phy_device *phydev,
+				   struct adin_hw_stat *stat,
+				   u32 *val)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, stat->reg1);
+	if (ret < 0)
+		return ret;
+
+	*val = (ret & 0xffff);
+
+	if (stat->reg2 == 0)
+		return 0;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, stat->reg2);
+	if (ret < 0)
+		return ret;
+
+	*val <<= 16;
+	*val |= (ret & 0xffff);
+
+	return 0;
+}
+
+static u64 adin_get_stat(struct phy_device *phydev, int i)
+{
+	struct adin_hw_stat *stat = &adin_hw_stats[i];
+	struct adin_priv *priv = phydev->priv;
+	u32 val;
+	int ret;
+
+	if (stat->reg1 > 0x1f) {
+		ret = adin_read_mmd_stat_regs(phydev, stat, &val);
+		if (ret < 0)
+			return (u64)(~0);
+	} else {
+		ret = phy_read(phydev, stat->reg1);
+		if (ret < 0)
+			return (u64)(~0);
+		val = (ret & 0xffff);
+	}
+
+	if (stat->do_not_accumulate)
+		priv->stats[i] = val;
+	else
+		priv->stats[i] += val;
+
+	return priv->stats[i];
+}
+
+static void adin_get_stats(struct phy_device *phydev,
+			   struct ethtool_stats *stats, u64 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(adin_hw_stats); i++)
+		data[i] = adin_get_stat(phydev, i);
+}
+
 static int adin_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -632,6 +735,9 @@ static struct phy_driver adin_driver[] = {
 		.set_tunable	= adin_set_tunable,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
+		.get_sset_count	= adin_get_sset_count,
+		.get_strings	= adin_get_strings,
+		.get_stats	= adin_get_stats,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 		.read_mmd	= adin_read_mmd,
@@ -648,6 +754,9 @@ static struct phy_driver adin_driver[] = {
 		.set_tunable	= adin_set_tunable,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
+		.get_sset_count	= adin_get_sset_count,
+		.get_strings	= adin_get_strings,
+		.get_stats	= adin_get_stats,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 		.read_mmd	= adin_read_mmd,
-- 
2.20.1

