Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4F2290288
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfHPNLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:11:04 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:31834 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727424AbfHPNK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:10:59 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7GD7mgn030041;
        Fri, 16 Aug 2019 09:10:51 -0400
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2051.outbound.protection.outlook.com [104.47.36.51])
        by mx0a-00128a01.pphosted.com with ESMTP id 2udk94974s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 09:10:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpCy9kLTj2DLMi3CT+dQeIluX/yWudeAulToJb3B+yRK3/cIt2tWq3wMYKyh5IKGqbWeUF0ZUTk7waXNojumfjAdNcFj4MQMXXvJYZLLH/nhXxPv+p175orTO7Lo7YAAk0XzvL7REqL8JNHXWRH0szazBqo5N64VzxU9N9Vh7iOPxpHcyH4eD6b6mYmLAst7WV5l22ZYV2ZrVI3OeIC1xByCm6JCZbMC8I3IrtPKg74yCIZ86gdtA7QyFJg3z94ZPQ5stHCPjqUmZ4Bkk9vXi6jwl9N70z35KEVOtb1MrGC2Ne461roCGu51UUQ0HVetpiozVqWmYZbgNJMqAXhlXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nH2ffxl08ZpxfsL8yOMDwFfzHw7mZsLWAD6V2dqcHW0=;
 b=ADakaEg64TVbOb9mtbpcYj+lOWHN47EJfbGEq2g776/3R0KqBhaR+ROu5xJdsGrAQJs4UCiXP+h/tRSIslxnpIcG7tWRXfUdT+mfkCschfb0SQ5FG3jkiMkR19BIIwN/IQwtukIaej3UTPDhRqmpwiRwTP0AkE9Smw3JTBMYH1lcnl94FG4lPbf+uU3//bdFPUyJzqj7/6hpuDRYx5C2Body3nmI6yu9eeOYuEbp78W7oiBzvW0j51MtO2lWbO++fbcu9QJkDjIzYmOb7e9ponuzmy2Hs8ApwRZGQ1Y+BkcJC9rc4kJZaqjy0L5r6G6/DCZP1FD975hCVCxT3gq1Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nH2ffxl08ZpxfsL8yOMDwFfzHw7mZsLWAD6V2dqcHW0=;
 b=0cOhf7pl+8F/QlII2wZnWvK7sVftYscvbQeBjaIZhSNxwXpPcimTwgV9yTXJqd5KGT9pa1bodLrEQ5VVHxCWA/7hEQ3yPkB4Le1VL5gRAonzV/AvZShhE8WWvArvSyazZ5xwlT2aJpoDOeF7BE5lMWrj/SazKzdE3vO8R7G0ZNQ=
Received: from BN3PR03CA0084.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::44) by SN2PR03MB2238.namprd03.prod.outlook.com
 (2603:10b6:804:d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.16; Fri, 16 Aug
 2019 13:10:49 +0000
Received: from SN1NAM02FT021.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::203) by BN3PR03CA0084.outlook.office365.com
 (2a01:111:e400:7a4d::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2178.16 via Frontend
 Transport; Fri, 16 Aug 2019 13:10:48 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT021.mail.protection.outlook.com (10.152.72.144) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2178.16
 via Frontend Transport; Fri, 16 Aug 2019 13:10:48 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7GDAli7007944
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 16 Aug 2019 06:10:47 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Fri, 16 Aug 2019 09:10:47 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v5 12/13] net: phy: adin: add ethtool get_stats support
Date:   Fri, 16 Aug 2019 16:10:10 +0300
Message-ID: <20190816131011.23264-13-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190816131011.23264-1-alexandru.ardelean@analog.com>
References: <20190816131011.23264-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(346002)(376002)(2980300002)(189003)(199004)(107886003)(2870700001)(70586007)(5660300002)(70206006)(186003)(426003)(4326008)(356004)(2906002)(6666004)(126002)(478600001)(476003)(446003)(2616005)(486006)(1076003)(44832011)(11346002)(110136005)(316002)(26005)(106002)(54906003)(336012)(36756003)(305945005)(51416003)(7636002)(48376002)(50466002)(2201001)(76176011)(8676002)(8936002)(14444005)(246002)(47776003)(7696005)(50226002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR03MB2238;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15ea2209-f9ff-4647-ecca-08d7224b2826
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:SN2PR03MB2238;
X-MS-TrafficTypeDiagnostic: SN2PR03MB2238:
X-Microsoft-Antispam-PRVS: <SN2PR03MB2238E64BDFB94D23F5EEAFABF9AF0@SN2PR03MB2238.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0131D22242
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: yl/eIWwqykQ58Ti2yKaBt19WiNCXnqpLZpgdtUSxNDANJyvAwIZvzr6LpFDLiq6S4dOZLOwpwOHqw9m5YrfJ5edXH4Q0Vkoee8qLfU04eShsp5n7l44J7YOJRbgT+Kq7ndpR5YmrElNkULN9TjT17U2meS9hujgcGt1xDCmtTcWlB6Z7hQcEJT8zgaaL7wfeevT/B02j9HRQpvFnrakL1OexZ9STxS/+iFzP651WdsfDkC40Vj4KHSB1yUMOZmcebp7K1nqyhLmH3I6+fOmBYml1vlKhXf/d/44GmlzrAFUytPfJMlwcj+g2jZV+akHerZO7rtv5kce0TKcDRAUgMQX1gVrepE1LOtAp2NZDrRCQjVpdhXOAzdBHpLBBmR0sA8pJHhiklpVl6xQZPCGWFuxB86edwqTc88e/gc24tk8=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2019 13:10:48.2771
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ea2209-f9ff-4647-ecca-08d7224b2826
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR03MB2238
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

This change implements retrieving all the error counters from the PHY.

The counters require that the RxErrCnt register (0x0014) be read first,
after which copies of the counters are latched into the registers. This
ensures that all registers read after RxErrCnt are synchronized at the
moment that they are read.

The counter values need to be accumulated by the driver, as each time that
RxErrCnt is read, the values that are latched are the ones that have
incremented from the last read.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 128 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 131b577a17e5..ac79e16cd7f1 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -24,6 +24,8 @@
 #define   ADIN1300_AUTO_MDI_EN			BIT(10)
 #define   ADIN1300_MAN_MDIX_EN			BIT(9)
 
+#define ADIN1300_RX_ERR_CNT			0x0014
+
 #define ADIN1300_PHY_CTRL2			0x0016
 #define   ADIN1300_DOWNSPEED_AN_100_EN		BIT(11)
 #define   ADIN1300_DOWNSPEED_AN_10_EN		BIT(10)
@@ -146,6 +148,33 @@ static struct adin_clause45_mmd_map adin_clause45_mmd_map[] = {
 	{ MDIO_MMD_PCS, MDIO_PCS_EEE_WK_ERR,	ADIN1300_LPI_WAKE_ERR_CNT_REG },
 };
 
+struct adin_hw_stat {
+	const char *string;
+	u16 reg1;
+	u16 reg2;
+};
+
+static struct adin_hw_stat adin_hw_stats[] = {
+	{ "total_frames_checked_count",		0x940A, 0x940B }, /* hi + lo */
+	{ "length_error_frames_count",		0x940C },
+	{ "alignment_error_frames_count",	0x940D },
+	{ "symbol_error_count",			0x940E },
+	{ "oversized_frames_count",		0x940F },
+	{ "undersized_frames_count",		0x9410 },
+	{ "odd_nibble_frames_count",		0x9411 },
+	{ "odd_preamble_packet_count",		0x9412 },
+	{ "dribble_bits_frames_count",		0x9413 },
+	{ "false_carrier_events_count",		0x9414 },
+};
+
+/**
+ * struct adin_priv - ADIN PHY driver private data
+ * stats		statistic counters for the PHY
+ */
+struct adin_priv {
+	u64			stats[ARRAY_SIZE(adin_hw_stats)];
+};
+
 static int adin_lookup_reg_value(const struct adin_cfg_reg_map *tbl, int cfg)
 {
 	size_t i;
@@ -548,10 +577,102 @@ static int adin_soft_reset(struct phy_device *phydev)
 	return rc < 0 ? rc : 0;
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
+	priv->stats[i] += val;
+
+	return priv->stats[i];
+}
+
+static void adin_get_stats(struct phy_device *phydev,
+			   struct ethtool_stats *stats, u64 *data)
+{
+	int i, rc;
+
+	/* latch copies of all the frame-checker counters */
+	rc = phy_read(phydev, ADIN1300_RX_ERR_CNT);
+	if (rc < 0)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(adin_hw_stats); i++)
+		data[i] = adin_get_stat(phydev, i);
+}
+
+static int adin_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct adin_priv *priv;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+
+	return 0;
+}
+
 static struct phy_driver adin_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
 		.name		= "ADIN1200",
+		.probe		= adin_probe,
 		.config_init	= adin_config_init,
 		.soft_reset	= adin_soft_reset,
 		.config_aneg	= adin_config_aneg,
@@ -560,6 +681,9 @@ static struct phy_driver adin_driver[] = {
 		.set_tunable	= adin_set_tunable,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
+		.get_sset_count	= adin_get_sset_count,
+		.get_strings	= adin_get_strings,
+		.get_stats	= adin_get_stats,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 		.read_mmd	= adin_read_mmd,
@@ -568,6 +692,7 @@ static struct phy_driver adin_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
 		.name		= "ADIN1300",
+		.probe		= adin_probe,
 		.config_init	= adin_config_init,
 		.soft_reset	= adin_soft_reset,
 		.config_aneg	= adin_config_aneg,
@@ -576,6 +701,9 @@ static struct phy_driver adin_driver[] = {
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

