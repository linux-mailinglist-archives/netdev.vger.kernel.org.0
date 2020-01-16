Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618A913D67C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 10:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730937AbgAPJNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 04:13:06 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:26782 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbgAPJNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 04:13:06 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00G9AQJ1010655;
        Thu, 16 Jan 2020 04:13:01 -0500
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-00128a01.pphosted.com with ESMTP id 2xf93b59ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jan 2020 04:13:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2Jk8hkuY9j3jvk5nhGvqCHNW3N7xz1xhDmFIXVDPXsjkrFxNpMON22/dZ+Ztea1euunx0rUNamoi288YjbbmHaUl6Tr1o5KKIkycxfW5jAx/dVqLCd0FgEdqk9/qYJVveTPCezWica3Qv+E7O86gqbHkA68DyJu0wL0EyJnYRX8lH+r4cSb3BRhTtAWSaNEM6yjLqJ/3kqHQiq4UEExZGwjI/qb7p0n4d8yr8rweQutD/+tOHxcDsvHHIQiCvb/tj9N37FObXThx0KVg/lRPCrYw+UORn1inglGJL4l6kygvKDaZeRCCZOnPpUXOTbf5n5x1qOKpqn8n4vtSkruhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FohmuAJX6VT66gp1J9VX7b0xOhw71H1YiiTqZMEKXhY=;
 b=JDkUzg6806w79eKBtcTegUfZ/zH4jcLhLZmuCNZfZOH2+XsLDIYh0QxGGbzQEe2/G8Zg3eaCVspBbRfQl/g342GmAdIl4hsi08LKzpNhIzsVZtABufQairh+XIysj0MqshAUoKQnJwZAkoMVuf/ZmgIzhSKNTHegyCqp+VJhcsni75+jC7nXAwLNaZtceJnolF0hZmVsXC+eJ1iWcOri1PAq+Br54yh7KWT58iij+dcJ40zYsZiolowxn7O8zcbgeT3HoREJ3iYTAGIc3telNPljLimO4E0XyvJtrcLSgGgvcqCkpXgES8l/vAJsBB8/qzhbjfhCdtBpDCXmPxD/MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FohmuAJX6VT66gp1J9VX7b0xOhw71H1YiiTqZMEKXhY=;
 b=mLGgTD339KrpHvmQw1OJc46CxTLvCwxDwHXtacsiANdFNsRp6Tmxa1dWxYTw5VIPbMk0vrlDc2gV19cbmtlOW2C6nrCDsJNzSqwoSyXHB0ajMf+uL6mKMirtQjiqhL7nFvQXFWG3J6hrqKk0gOtZf0Lh8bh3JvUSEnmzOmHaUjM=
Received: from MWHPR03CA0010.namprd03.prod.outlook.com (2603:10b6:300:117::20)
 by MN2PR03MB5133.namprd03.prod.outlook.com (2603:10b6:208:1a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20; Thu, 16 Jan
 2020 09:12:58 +0000
Received: from SN1NAM02FT008.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::206) by MWHPR03CA0010.outlook.office365.com
 (2603:10b6:300:117::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend
 Transport; Thu, 16 Jan 2020 09:12:58 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT008.mail.protection.outlook.com (10.152.72.119) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2623.9
 via Frontend Transport; Thu, 16 Jan 2020 09:12:57 +0000
Received: from ASHBMBX9.ad.analog.com (ashbmbx9.ad.analog.com [10.64.17.10])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id 00G9CiSw032330
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 Jan 2020 01:12:44 -0800
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1779.2; Thu, 16 Jan
 2020 04:12:55 -0500
Received: from zeus.spd.analog.com (10.64.82.11) by ASHBMBX9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.1.1779.2 via Frontend
 Transport; Thu, 16 Jan 2020 04:12:55 -0500
Received: from saturn.ad.analog.com ([10.48.65.124])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 00G9CkjX020088;
        Thu, 16 Jan 2020 04:12:52 -0500
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 2/4] net: phy: adin: rename struct adin_hw_stat -> adin_map
Date:   Thu, 16 Jan 2020 11:14:52 +0200
Message-ID: <20200116091454.16032-3-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116091454.16032-1-alexandru.ardelean@analog.com>
References: <20200116091454.16032-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(376002)(39860400002)(346002)(136003)(189003)(199004)(86362001)(1076003)(26005)(7696005)(186003)(70206006)(70586007)(7636002)(110136005)(54906003)(36756003)(316002)(44832011)(107886003)(8676002)(8936002)(5660300002)(336012)(426003)(478600001)(356004)(2616005)(246002)(2906002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR03MB5133;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35d3749f-1a22-423a-1ce0-08d79a64474e
X-MS-TrafficTypeDiagnostic: MN2PR03MB5133:
X-Microsoft-Antispam-PRVS: <MN2PR03MB5133ACF30E86E99CE36FD13DF9360@MN2PR03MB5133.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-Forefront-PRVS: 02843AA9E0
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rx2XI0nwItxkIuNSjRo0Ukc+DsjASQNezRWb6fh25WS5N0Z3/rr4wyDbW+Tc7PG3CxV0qvCPZNp2Nt/zj5Oi0RtPNkCJizO2sZupefyA1amifLV51+6KNVc1Uv8M1gTGJX7fQmzqbMXhM4UuTJtg6gS1UHjJBvTjm8jiSa2yBGjHA87BCJfMmONDAQJzr3f6QLLv/vL3OaS0V5FOkCgaHnRpFo0cFSd8bzRLLm1IyNG3bWKKAx29jCdX1KK/3vhfPdEZDYFrQ7iYmI91lt+WJYMrT3usUNIA9uKgZNtjaHSnLB5hGI8zZSSNZle1OKOBLlJQJZYvUFtTg0ohq8bQr5Bi2jHUCfSKYOQ2DpSt3mGzgFZpX44zQtpm1aHT6R/a0S1sFt44U+L7JIewhohBJwmSx0bYLi9mqokCkUWCliauXEoHIMp3iAMhz+aVAzw5
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2020 09:12:57.8732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d3749f-1a22-423a-1ce0-08d79a64474e
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB5133
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_02:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 clxscore=1011
 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001160078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The structure format will be re-used in an upcoming change. This change
renames to have a more generic name.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/net/phy/adin.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 1dca3e883df4..11ffeaa665a1 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -153,13 +153,13 @@ static const struct adin_clause45_mmd_map adin_clause45_mmd_map[] = {
 	{ MDIO_MMD_PCS, MDIO_PCS_EEE_WK_ERR,	ADIN1300_LPI_WAKE_ERR_CNT_REG },
 };
 
-struct adin_hw_stat {
+struct adin_map {
 	const char *string;
-	u16 reg1;
-	u16 reg2;
+	u16 val1;
+	u16 val2;
 };
 
-static const struct adin_hw_stat adin_hw_stats[] = {
+static const struct adin_map adin_hw_stats[] = {
 	{ "total_frames_checked_count",		0x940A, 0x940B }, /* hi + lo */
 	{ "length_error_frames_count",		0x940C },
 	{ "alignment_error_frames_count",	0x940D },
@@ -650,21 +650,21 @@ static void adin_get_strings(struct phy_device *phydev, u8 *data)
 }
 
 static int adin_read_mmd_stat_regs(struct phy_device *phydev,
-				   const struct adin_hw_stat *stat,
+				   const struct adin_map *stat,
 				   u32 *val)
 {
 	int ret;
 
-	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, stat->reg1);
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, stat->val1);
 	if (ret < 0)
 		return ret;
 
 	*val = (ret & 0xffff);
 
-	if (stat->reg2 == 0)
+	if (stat->val2 == 0)
 		return 0;
 
-	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, stat->reg2);
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, stat->val2);
 	if (ret < 0)
 		return ret;
 
@@ -676,17 +676,17 @@ static int adin_read_mmd_stat_regs(struct phy_device *phydev,
 
 static u64 adin_get_stat(struct phy_device *phydev, int i)
 {
-	const struct adin_hw_stat *stat = &adin_hw_stats[i];
+	const struct adin_map *stat = &adin_hw_stats[i];
 	struct adin_priv *priv = phydev->priv;
 	u32 val;
 	int ret;
 
-	if (stat->reg1 > 0x1f) {
+	if (stat->val1 > 0x1f) {
 		ret = adin_read_mmd_stat_regs(phydev, stat, &val);
 		if (ret < 0)
 			return (u64)(~0);
 	} else {
-		ret = phy_read(phydev, stat->reg1);
+		ret = phy_read(phydev, stat->val1);
 		if (ret < 0)
 			return (u64)(~0);
 		val = (ret & 0xffff);
-- 
2.20.1

