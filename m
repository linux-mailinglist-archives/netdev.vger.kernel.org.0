Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D471089C9D
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfHLLYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:24:43 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:62468 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728382AbfHLLYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:24:35 -0400
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CBNORR018336;
        Mon, 12 Aug 2019 07:24:27 -0400
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2052.outbound.protection.outlook.com [104.47.34.52])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u9qs7w66g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 07:24:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9dRYJC/jTOlflGRa2bO29UWMaCVfDuxS6S+cVs2CG9yYBa6S9/u1RyJoYLSFuNq6BFfwDgg9s5TUl+IByA1/MCTx2KkNGWVTJOfT/3Ux0tzt/Vy+l+WiAWuf6bjiIXeo6qCki0g6DO8mvS2U1Hl2GeaAUz+u62CgeqfacC1HycP349KWuoheCYSne+ENhiEGtMuXyWJNAhhBGQ6N1LGq7dU36HsgShrzsn3KDo01CH0QDSTnuCIyc8GwIgqdeShYv5cIYaho4NbtwcFOKNfIeirb7WNgECCXglCKTGge2F89T6A3aF5+tHl7StE4Q006R14a1LwvIEHy+TlPEVhBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pwFU6NgH9WeTLeh8rhkny/f5jfB/gvJDJRy5c/ZMfs=;
 b=jdJXplzYg9qYa8lzWSymQz5g4+ceN7+BWqCWQTvwsp/CjPs1e+xSAmY7F6UDqEjTiYFvAYHfifZxxD/5fg827uPgYBC+6f4gXuc6J2k+lmmr13ctF/bU04SdkZg48POKdcY6FTCiMJSuG+/rFXpSZGdCt/GuRDzyHaeePK/fmnBNF25L22ey7TWp57eKu+LfnmmdQ+iA2f1BNa7e5d7ZOxyAQMhU15mmvku/nTB5f+lpCUVVlU5stKOMqbt3HjLucOthe+SioOdO6CdRXDBY9jtTj3BIUKSRNHrJDiYc/ipPWyenJzrY+ZymcElgm1jGjFvBOfeZSng2MQ+eK0esew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pwFU6NgH9WeTLeh8rhkny/f5jfB/gvJDJRy5c/ZMfs=;
 b=tJWOP8sYFLwA+0CF9TRAgxSTcPBVn6fD8jN5z3TwnSk9VmUCyXMw0x41tHt6ziwPLOyrj4uEDxVENZbVwJPArVR14qwPRWSOygtrMDKu8a9Za2ALf9jKJjizKocbZTxRWsewGmhb1nwJdKLpW8Gk8rxPiABsGfkS4fNelVY4sO0=
Received: from MWHPR03CA0014.namprd03.prod.outlook.com (2603:10b6:300:117::24)
 by CY1PR03MB2364.namprd03.prod.outlook.com (2a01:111:e400:c61a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.23; Mon, 12 Aug
 2019 11:24:24 +0000
Received: from CY1NAM02FT060.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::207) by MWHPR03CA0014.outlook.office365.com
 (2603:10b6:300:117::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.16 via Frontend
 Transport; Mon, 12 Aug 2019 11:24:24 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 CY1NAM02FT060.mail.protection.outlook.com (10.152.74.252) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Mon, 12 Aug 2019 11:24:23 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x7CBON13004269
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 12 Aug 2019 04:24:23 -0700
Received: from saturn.ad.analog.com (10.48.65.113) by
 NWD2HUBCAS7.ad.analog.com (10.64.69.107) with Microsoft SMTP Server id
 14.3.408.0; Mon, 12 Aug 2019 07:24:22 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v4 13/14] net: phy: adin: add ethtool get_stats support
Date:   Mon, 12 Aug 2019 14:23:49 +0300
Message-ID: <20190812112350.15242-14-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812112350.15242-1-alexandru.ardelean@analog.com>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(396003)(39860400002)(2980300002)(189003)(199004)(50466002)(246002)(7636002)(4326008)(48376002)(356004)(6666004)(1076003)(107886003)(305945005)(5660300002)(8676002)(8936002)(2906002)(2870700001)(50226002)(106002)(86362001)(14444005)(478600001)(476003)(486006)(70586007)(11346002)(2616005)(2201001)(126002)(44832011)(70206006)(316002)(426003)(110136005)(54906003)(47776003)(26005)(7696005)(51416003)(76176011)(186003)(36756003)(446003)(336012);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR03MB2364;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 560e64bc-bd50-438f-c290-08d71f17a103
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:CY1PR03MB2364;
X-MS-TrafficTypeDiagnostic: CY1PR03MB2364:
X-Microsoft-Antispam-PRVS: <CY1PR03MB2364508F9C650513C58FEAB8F9D30@CY1PR03MB2364.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 012792EC17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ZxIbzQmBHJeh6ZM3CHd5MAMPjwoLQuVImQzNF6XUw4ii0aIfDpT2G3UCDY3ZU+XN+RRAWYR65QzCclDM+u6hLjAqe+Hk+ZFpn/+4LcYHbYd2R390K816c1ki0H6/F6E42IJiS1F0LszPI9T68sdQ26q/6FhJ+PPMEwPC2vuk+BbD57JdXrhHIHxLrq5HyvXkEFl4AQqh3A/zGV1b2o7Ke9zFkIQ+7LcoH0uRzZ6yfyY/yjqSmEtSNcxy5UfnM8+6g8XFeIxKAymhuTRgaR6/GFKUjdjgeUz5oZUI+fBXGs0k0mvckuKnejr+vDqgpiPl1cJEx+YVoHLpnHAv2t/JGJREaFSRg0hS8nMH6CccNea6kXy3HA+Ha3agLRh1R1KugOBHaF/YmzZOszf5UgE7GoB3UxzVhFazRaSBuI2ghJ8=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2019 11:24:23.7011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 560e64bc-bd50-438f-c290-08d71f17a103
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR03MB2364
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120128
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
index e4afa8c2bec7..3ab15a585c1b 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -152,12 +152,40 @@ static struct adin_clause45_mmd_map adin_clause45_mmd_map[] = {
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
@@ -590,6 +618,81 @@ static int adin_reset(struct phy_device *phydev)
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
@@ -618,6 +721,9 @@ static struct phy_driver adin_driver[] = {
 		.set_tunable	= adin_set_tunable,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
+		.get_sset_count	= adin_get_sset_count,
+		.get_strings	= adin_get_strings,
+		.get_stats	= adin_get_stats,
 		.resume		= genphy_resume,
 		.suspend	= genphy_suspend,
 		.read_mmd	= adin_read_mmd,
@@ -634,6 +740,9 @@ static struct phy_driver adin_driver[] = {
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

