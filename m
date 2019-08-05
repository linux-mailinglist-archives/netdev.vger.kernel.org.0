Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986AD81E2C
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 15:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbfHEN4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 09:56:08 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:4614 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729911AbfHENzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 09:55:46 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x75Dqrwa026596;
        Mon, 5 Aug 2019 09:55:39 -0400
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2054.outbound.protection.outlook.com [104.47.40.54])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u576712xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 09:55:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsV0c7wSju5oXz3MrJNfwhlPXfzP+ZGGhdNT6YfnLC09Ehn7y8Udu9TAfgbrxKtJG33kM1UvRWWh4ZCFaRCLBERVJanSdxXPIQJ7+BKOIlycq99sd4sBle/Jvm3Q7uJ6h8mooeIL7XXzheV6AzDZkoL1LQ0lFj3t8ekkiK2ludnKO2PUPrhQFc9QKTIiGxR61V7tRo0+o2667TlgKYfPgmJdJc+5ANm8gK7BOctsNKZ5xVQRmQ64/s3tWjEI8nf9NfW/Ph7V0bF1Z09gvc1oNPeZRpo920GLgFeH/0xIRVvaMUcF/FjE6C0HFAnx6bnkJQJZJvaF1Gflntz48laBNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2fGJsVqpRU5Mzv698G1bhEg6K2VsudNEVIFPmka+b0k=;
 b=Ef7Y0QFD5/c5GfD8r/Nyzz1ochAj5v7nMLrimkIFLEuK9gSDJDgT8X4H61j7G2rGTxNr3ICgYqa1zbTyejqMVBWN6TlUkC4Bod7xFuR5wr6YJWpk/Q4JfhDA7Fo3z6gnxLO0jpV/GtqbL+U9CBbhQC1iZQts21g9wXsCwHQqaLB2cbPTO1/rRa2S5Frmq/kz6DPN8XvyeF+vCowAmSnVDPi2JL3Xfnm6rdgS6cFk+LeGh6upIxsPEj7RYo++pG4LpxaLzAgVpQKR0bxodSStHoeIUkM7l6iXP7R7cqQQ5PaqURMKM5yh6qBOzY1iIVsFpb2i89QtKwOuAIrcQW92ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2fGJsVqpRU5Mzv698G1bhEg6K2VsudNEVIFPmka+b0k=;
 b=7jRx/B+K+hkUQHQrT8VxS/IBN6PRs7C09cxLMTpn+ZYi9TKC62zpgqij4rI1DvQV418w1zT7fTObCheNKjo7VE924BrvauqMBqOn1hdMO7OcO+GAyxJvYod3/FCAcC0rUd/RpZtRMdDpgvgsmyI/xdx+BpIXROazKQZIZUIziVY=
Received: from DM5PR03CA0036.namprd03.prod.outlook.com (2603:10b6:4:3b::25) by
 CY1PR03MB2186.namprd03.prod.outlook.com (2a01:111:e400:c61a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Mon, 5 Aug
 2019 13:55:37 +0000
Received: from BL2NAM02FT012.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::204) by DM5PR03CA0036.outlook.office365.com
 (2603:10b6:4:3b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.13 via Frontend
 Transport; Mon, 5 Aug 2019 13:55:37 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 BL2NAM02FT012.mail.protection.outlook.com (10.152.77.27) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Mon, 5 Aug 2019 13:55:37 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x75DtYZ3016255
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 06:55:34 -0700
Received: from saturn.ad.analog.com (10.48.65.109) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 5 Aug 2019 09:55:36 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 15/16] net: phy: adin: add ethtool get_stats support
Date:   Mon, 5 Aug 2019 19:54:52 +0300
Message-ID: <20190805165453.3989-16-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805165453.3989-1-alexandru.ardelean@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(39860400002)(136003)(346002)(376002)(2980300002)(199004)(189003)(14444005)(2616005)(476003)(186003)(336012)(8676002)(426003)(106002)(7636002)(305945005)(316002)(11346002)(446003)(54906003)(51416003)(4326008)(7696005)(110136005)(76176011)(86362001)(356004)(44832011)(126002)(486006)(6666004)(2201001)(478600001)(36756003)(2906002)(26005)(1076003)(5660300002)(107886003)(70206006)(2870700001)(48376002)(50466002)(8936002)(70586007)(50226002)(47776003)(246002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR03MB2186;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dc05824-e906-4de7-a17f-08d719ac9815
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:CY1PR03MB2186;
X-MS-TrafficTypeDiagnostic: CY1PR03MB2186:
X-Microsoft-Antispam-PRVS: <CY1PR03MB2186D2581691944F91B87073F9DA0@CY1PR03MB2186.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 01208B1E18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: VYXhjVxAEAlAHvPXbf2Jv2XXGTRwvtvz0d43k+QUMduwPlbcZxI8wJ+VM++6bOiP4+D0TZ3txQhy3AvXqUUlU+/uU2F1qC6bWEdJJmb/hr9ykH6TQ5Fq4H+njCh03P1cV6KxLZcmwyxr5L1R/5+qnyGDyi7vMbvCXytGTDoAmyLPDsMosvJDqXlu/p2roNvGVvVqZnoDBtbnTtIbcIRpmP8NhzI4TYJ0iSldf8hCnjX7c6rX7AmblPUGsOmVeIytpTbb2tHwpQsbFlLFARYNHtcnJO52x+YRAitz5lJcKdo0tS8c1ACsLpKUoT7cpUtwPIoL/RbCExfxaRf8UPJYPTkjN0GuMRE/CXGPfsfaUM58V5VEfq9jmfk5VLg6NYwtI02SqBorXajN8BTDlY2AbI4KQ87OiCXlNqWWO0Z4Bok=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2019 13:55:37.1757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc05824-e906-4de7-a17f-08d719ac9815
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR03MB2186
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

This change implements retrieving all the error counters from the PHY.
The PHY supports several error counters/stats. The `Mean Square Errors`
status values are only valie when a link is established, and shouldn't be
incremented. These values characterize the quality of a signal.

The rest of the error counters are self-clearing on read.
Most of them are reports from the Frame Checker engine that the PHY has.

Not retrieving the `LPI Wake Error Count Register` here, since that is used
by the PHY framework to check for any EEE errors. And that register is
self-clearing when read (as per IEEE spec).

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 108 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index a1f3456a8504..04896547dac8 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -103,6 +103,32 @@ static struct clause22_mmd_map clause22_mmd_map[] = {
 	{ MDIO_MMD_PCS, MDIO_PCS_EEE_WK_ERR,	ADIN1300_LPI_WAKE_ERR_CNT_REG },
 };
 
+struct adin_hw_stat {
+	const char *string;
+	u16 reg1;
+	u16 reg2;
+	bool do_not_inc;
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
  * gpiod_reset		optional reset GPIO, to be used in soft_reset() cb
@@ -113,6 +139,7 @@ struct adin_priv {
 	struct gpio_desc	*gpiod_reset;
 	u8			eee_modes;
 	bool			edpd_enabled;
+	u64			stats[ARRAY_SIZE(adin_hw_stats)];
 };
 
 static int adin_get_phy_internal_mode(struct phy_device *phydev)
@@ -568,6 +595,81 @@ static int adin_reset(struct phy_device *phydev)
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
+		memcpy(data + i * ETH_GSTRING_LEN,
+		       adin_hw_stats[i].string, ETH_GSTRING_LEN);
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
+	if (stat->do_not_inc)
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
@@ -607,6 +709,9 @@ static struct phy_driver adin_driver[] = {
 		.read_status	= adin_read_status,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
+		.get_sset_count	= adin_get_sset_count,
+		.get_strings	= adin_get_strings,
+		.get_stats	= adin_get_stats,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 		.read_mmd	= adin_read_mmd,
@@ -624,6 +729,9 @@ static struct phy_driver adin_driver[] = {
 		.read_status	= adin_read_status,
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

