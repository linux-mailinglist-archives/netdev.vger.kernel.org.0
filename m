Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44EC213DD23
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgAPONs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:13:48 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:17254 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbgAPONs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 09:13:48 -0500
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00GECrnN021274;
        Thu, 16 Jan 2020 09:13:44 -0500
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0a-00128a01.pphosted.com with ESMTP id 2xfc59nkw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jan 2020 09:13:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvEICT1gxLbvL9unawgz7TZQnpa7lg2fJPFzr+D0kruEOZyB04wXgoe7Jgf32ivq3T7Bjr9IBTIaDhnkzt1eNiWm/dfUCfH/AxGnAbczUY7U72zpvt/YyvWPXAXe7bnvljOepLHA6ApCaNz13f/6AFu0UbmK6cSmrdW6oRcHBcdSAhcS6XIwr5CAPco9OiWEO5BAq2vtkFuiAr2y/PM0EHSjXVGKCOJa6tvEfiDj9TudOvq5RzePwVhFh2sqWyjf4toTKmZEeb+o6GgM2fXELJGRbDuFpND4I52ZEiimyUb/caT/3+5zzDI9yklI21xCUnXoCoPLg/1w4j24uumCZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6kLiyQVqkX+/PFHOKktSq1SPk1JCOkQyYI9B2MsQGY=;
 b=Vb0c0QysLqmeUwCc7AjIJIfDjvMFXJGlbQwN0+81dS9ylggXx1oREy+ZhgLrRyvWdcv/ROgtvpwb+j45KBRyqQpSf213T3NGGwWmWsZnipZbl+RYgg2JnQmkqo7WJjcWhLi1e4TPTrLaEKfGz5+bAV13tQwzKPmBL8J7TIMGbTIOzBTFGonbTSrInfqIoekW/aeDs3hkeHwNOSI2Qgu9bjavMNX7e+tDN2gboRdoZRR/yd8/IRAsiOLKRmHkQcDQ7zcyYpFlffcBjGEE9PBfKPRWNGTSNpVREbPotsKwk6VrOzKmrMoZ2RfJ3zHJok7yD/dbu4uUdQ9uIqZw8L23dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6kLiyQVqkX+/PFHOKktSq1SPk1JCOkQyYI9B2MsQGY=;
 b=Cxs0A+w7W53qJBqHWO+nzk00RaM7YiuUJ9OLfhje1TSyWrIb2dCEZiMwHPB83c8f71E2esWdYLXtI4KnLRB1uPeDdtvVqe6llXvPlnDz6sM6NgsPkSnwaDqNeesrVmOCP1svWaLZSTTTiA+M+0WAZmgT+51XgcINfl+ftwjaXis=
Received: from BN3PR03CA0101.namprd03.prod.outlook.com (2603:10b6:400:4::19)
 by MWHPR03MB3310.namprd03.prod.outlook.com (2603:10b6:301:44::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9; Thu, 16 Jan
 2020 14:13:40 +0000
Received: from CY1NAM02FT059.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::208) by BN3PR03CA0101.outlook.office365.com
 (2603:10b6:400:4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend
 Transport; Thu, 16 Jan 2020 14:13:40 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT059.mail.protection.outlook.com (10.152.74.211) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2644.19
 via Frontend Transport; Thu, 16 Jan 2020 14:13:39 +0000
Received: from SCSQMBX11.ad.analog.com (scsqmbx11.ad.analog.com [10.77.17.10])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id 00GEDQUW028079
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 Jan 2020 06:13:26 -0800
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by SCSQMBX11.ad.analog.com
 (10.77.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1779.2; Thu, 16 Jan
 2020 06:13:36 -0800
Received: from zeus.spd.analog.com (10.64.82.11) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.1.1779.2 via Frontend
 Transport; Thu, 16 Jan 2020 09:13:35 -0500
Received: from saturn.ad.analog.com ([10.48.65.124])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 00GEDTjW028414;
        Thu, 16 Jan 2020 09:13:30 -0500
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH v2] net: phy: adin: const-ify static data
Date:   Thu, 16 Jan 2020 16:15:35 +0200
Message-ID: <20200116141535.26561-1-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(396003)(39860400002)(189003)(199004)(107886003)(426003)(26005)(186003)(2906002)(4326008)(5660300002)(86362001)(2616005)(8676002)(7636002)(336012)(36756003)(70586007)(246002)(7696005)(1076003)(54906003)(316002)(356004)(110136005)(966005)(478600001)(70206006)(44832011)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR03MB3310;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c637c813-e853-439d-2b50-08d79a8e4912
X-MS-TrafficTypeDiagnostic: MWHPR03MB3310:
X-Microsoft-Antispam-PRVS: <MWHPR03MB3310F90119ACE8ECE4257470F9360@MWHPR03MB3310.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:556;
X-Forefront-PRVS: 02843AA9E0
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sbh/0kIyUpmExZrSJOVMwRN5D+6dEiiDQJH7jU1iXfqT/SNLtWJYkm8ByQeDn0BqpL4oKU3YM+gqLycXghr4KvFuU02ekLHZ5DZDUibmP1k78Juv+co3ygdL8+PEzJAye+bn/AVAlZRwTYv/njrp5mD67jR0D0WqyoL7Lp/SNz+kjkf3cVeCjJfViNediwlIuUJI/FNubwaWEKdK3WbgTarJ/E2EsUHlr4YhG8erCyVO1q+nRQQzJtEwE8spzMBq49RPjXLuOVHrMr+y8pQ22Z0aijctPpdC1iCULg5RUQ+lfBV1JUBUOX/3gkCagRQGFrplmxf+vVAOgIJD9w98PDRBvT8yJ2xY2Aj7POGLcQ826h1X97Qey1lsFdo9g6gKYlHBtP/TtqkFHd94adxhpcvMOZZQig8U+I/QFR08CWKXeS+Car8GQt+HuECghVk+AR1l94XYquwxmYv3O9dpiOGOSTY5C8PB9wEisHIqTwU=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2020 14:13:39.6734
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c637c813-e853-439d-2b50-08d79a8e4912
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR03MB3310
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_04:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001160119
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some bits of static data should have been made const from the start.
This change adds the const qualifier where appropriate.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---

Changelog v1 -> v2:
* split away from series
  https://lore.kernel.org/netdev/20200116091454.16032-1-alexandru.ardelean@analog.com/T/#t
  https://lore.kernel.org/netdev/20200116091454.16032-1-alexandru.ardelean@analog.com/T/#m70f932056403f3d32d483557276f1fe75dcab592
* add Andrew's Signed-off-by tag
  https://lore.kernel.org/netdev/20200116133026.GB19046@lunn.ch/T/#u

 drivers/net/phy/adin.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index cf5a391c93e6..1dca3e883df4 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -145,7 +145,7 @@ struct adin_clause45_mmd_map {
 	u16 adin_regnum;
 };
 
-static struct adin_clause45_mmd_map adin_clause45_mmd_map[] = {
+static const struct adin_clause45_mmd_map adin_clause45_mmd_map[] = {
 	{ MDIO_MMD_PCS,	MDIO_PCS_EEE_ABLE,	ADIN1300_EEE_CAP_REG },
 	{ MDIO_MMD_AN,	MDIO_AN_EEE_LPABLE,	ADIN1300_EEE_LPABLE_REG },
 	{ MDIO_MMD_AN,	MDIO_AN_EEE_ADV,	ADIN1300_EEE_ADV_REG },
@@ -159,7 +159,7 @@ struct adin_hw_stat {
 	u16 reg2;
 };
 
-static struct adin_hw_stat adin_hw_stats[] = {
+static const struct adin_hw_stat adin_hw_stats[] = {
 	{ "total_frames_checked_count",		0x940A, 0x940B }, /* hi + lo */
 	{ "length_error_frames_count",		0x940C },
 	{ "alignment_error_frames_count",	0x940D },
@@ -456,7 +456,7 @@ static int adin_phy_config_intr(struct phy_device *phydev)
 static int adin_cl45_to_adin_reg(struct phy_device *phydev, int devad,
 				 u16 cl45_regnum)
 {
-	struct adin_clause45_mmd_map *m;
+	const struct adin_clause45_mmd_map *m;
 	int i;
 
 	if (devad == MDIO_MMD_VEND1)
@@ -650,7 +650,7 @@ static void adin_get_strings(struct phy_device *phydev, u8 *data)
 }
 
 static int adin_read_mmd_stat_regs(struct phy_device *phydev,
-				   struct adin_hw_stat *stat,
+				   const struct adin_hw_stat *stat,
 				   u32 *val)
 {
 	int ret;
@@ -676,7 +676,7 @@ static int adin_read_mmd_stat_regs(struct phy_device *phydev,
 
 static u64 adin_get_stat(struct phy_device *phydev, int i)
 {
-	struct adin_hw_stat *stat = &adin_hw_stats[i];
+	const struct adin_hw_stat *stat = &adin_hw_stats[i];
 	struct adin_priv *priv = phydev->priv;
 	u32 val;
 	int ret;
-- 
2.20.1

