Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B277861C1
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 14:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403825AbfHHMb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 08:31:29 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:4060 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389924AbfHHMbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 08:31:11 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78CRoBE022494;
        Thu, 8 Aug 2019 08:31:04 -0400
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2058.outbound.protection.outlook.com [104.47.46.58])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u7xkj3gwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 08:31:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AX7Yx/nA0MTpQfJA0AFmWdt5p1wDwwkZ/FwTlxAdWb6yv88zzrT+PxZozHjugYZhhMPGlSZSFhfwn0xcDN6rnQrmAvw2xZdzNyKGPChL648AzfHFMS8wkZXWRCjIcCA6LWmwLs5l55UFrTiFKJJyYAmdfkiFww4yxjdEomA4/YRMfDmQ5/MtN93+MVUbhMPvbdKcsiLIR5WOeNoB/woYkeCTMf8JaI5Zu0oPVNWGVmep66po1fzm+Y6HaAtZkwJP9qA+yjW9yBwjNsH1jzx1jNDoNIyIDS765cMSIQqrysEbm0RTSJEFlTAdo3LDeLmq29US1EaE/UPUifx4F/tS2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMV1Twb2t7GaH/tlSWpRt1C4iRpG1S/d3wJmfiVny88=;
 b=MwNO8ZaXv5gcJd6rZ9BpEK1IzSe3ciQQjU/Q2Vxo5Lh/fQvHMwvyPyQdj7cneE5lsrH4Q37y2umRRJIFJ86iPGxVy/CWgVQc4JiyOx7xWlXuRfZucnPS6BVPFs7j9TooFeW7atydx6ATnJYl0CL9SsnFymQ5KCfh5F/QFMqv6vs6IAYm93zIUlH16HT/0NgKFHwXEaMaxORDnNC8FsQsyweAWKgTtg7bCHmd0p8Lzdg+eBvRV1VUV4MfvRYCjITcKQyuWDs4R62DIWQue4l9aO7JOgDsAxDtOBHF6Q1sQPOc+4N/z7b0p269NXqrrT17ddoTiyQqWP3Bb7/iyQWngw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMV1Twb2t7GaH/tlSWpRt1C4iRpG1S/d3wJmfiVny88=;
 b=GTlLLx2bv+3HEu5fXtLcDFsrmifbXfUC76I7XPf+j1CSHUTiQU9QnQFiXbZWwAPdmHQYxVt1LUVr6smg+VQZEYwza+SfEXzRLbKqnwbmKhMcwOS93hjBlB1NHq+8P0rRND0Y5YzwSrq0izRD4NmErT//gcYkiWd6h1ZYmZjOBDc=
Received: from MWHPR03CA0044.namprd03.prod.outlook.com (2603:10b6:301:3b::33)
 by BY5PR03MB5046.namprd03.prod.outlook.com (2603:10b6:a03:1ec::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.18; Thu, 8 Aug
 2019 12:31:02 +0000
Received: from SN1NAM02FT048.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::201) by MWHPR03CA0044.outlook.office365.com
 (2603:10b6:301:3b::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Thu, 8 Aug 2019 12:31:01 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT048.mail.protection.outlook.com (10.152.72.202) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Thu, 8 Aug 2019 12:31:01 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x78CV0HV021300
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 8 Aug 2019 05:31:00 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Aug 2019 08:31:00 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2 14/15] net: phy: adin: add ethtool get_stats support
Date:   Thu, 8 Aug 2019 15:30:25 +0300
Message-ID: <20190808123026.17382-15-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808123026.17382-1-alexandru.ardelean@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(39860400002)(376002)(396003)(136003)(2980300002)(189003)(199004)(76176011)(5660300002)(50226002)(110136005)(47776003)(70206006)(106002)(54906003)(8676002)(1076003)(7696005)(2906002)(8936002)(2870700001)(26005)(51416003)(107886003)(336012)(246002)(305945005)(7636002)(4326008)(11346002)(446003)(186003)(70586007)(426003)(2201001)(486006)(476003)(2616005)(126002)(316002)(44832011)(48376002)(50466002)(6666004)(36756003)(14444005)(478600001)(86362001)(356004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR03MB5046;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ea90495-755f-4008-c538-08d71bfc45e7
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BY5PR03MB5046;
X-MS-TrafficTypeDiagnostic: BY5PR03MB5046:
X-Microsoft-Antispam-PRVS: <BY5PR03MB50466F3943949EC19A9EDF92F9D70@BY5PR03MB5046.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 012349AD1C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 2DXIDzVxUxN+U8hnkkxYkqtFJnh5MTShmC4VvymwIDZj7NI6Qi/CVD4k6kHPCEApG1NvyEJgt/LfPkbmG6y/VNvRfBmg4re1tfZOPaoKPELhofOOeKZX3ypO9xM4M7M2Y4yP+4FFf4pP708TBddS5jFnYl+LIkbhfc601xV4qMX7OkgmUiPMfFjE1uaAbi17QNxB4ld1+sTO9UyfHuDT8LaEx92TLe24+OeMQPcxiptevr2JpyD/L6W3YlvVlmRz3Vm57VGUE1H/QVrazGb5sXX73u/Dgyjm2fN9UivoN1BScRI1kSMSDyukitljsjm3p4BtY/p3sBev4+wU5v32/QBvyzx0ezvMQdsgSvLvt+tDHcUjlWHG470Kr5HbNp38tpUWvHKGAk5w5MZTb2J6XE3yB6Y2xCVN1Z7lrqphc4M=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2019 12:31:01.0266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ea90495-755f-4008-c538-08d71bfc45e7
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5046
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080130
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
index d6d1f5037eb7..d170d1e837b5 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -155,12 +155,40 @@ static struct adin_clause45_mmd_map adin_clause45_mmd_map[] = {
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
@@ -561,6 +589,81 @@ static int adin_reset(struct phy_device *phydev)
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
@@ -588,6 +691,9 @@ static struct phy_driver adin_driver[] = {
 		.get_features	= genphy_read_abilities,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
+		.get_sset_count	= adin_get_sset_count,
+		.get_strings	= adin_get_strings,
+		.get_stats	= adin_get_stats,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 		.read_mmd	= adin_read_mmd,
@@ -603,6 +709,9 @@ static struct phy_driver adin_driver[] = {
 		.get_features	= genphy_read_abilities,
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

