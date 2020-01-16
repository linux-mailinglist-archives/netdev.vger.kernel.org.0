Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA5E13D679
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 10:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731449AbgAPJNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 04:13:15 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:30186 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731068AbgAPJNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 04:13:10 -0500
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00G9CfLC024975;
        Thu, 16 Jan 2020 04:13:06 -0500
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0a-00128a01.pphosted.com with ESMTP id 2xfc59my6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jan 2020 04:13:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQxNQpfJCLsDHV6mc8ZCZBjxyYVHY110G7YT1A0i10hBRZi3fytRqhvKxcwXkke8uIhY41WOVr7T/QfU3/d7YvPo5moIdZb0Uqs+jt5dm0phkVDqLdtypHaSrHQgVT90mH5r7v1OBkzTdSm0zuXKuDoM/wIlChZP8t5xoUcuet5abM33DevLoQKETLrnkbOvmBMh3qR1tB+dxp/+q0+EZ0HT7Q8sKktfdRU85SWjoyhIUqUdrYwEVL5LeZ65UahJzUwDWZegXeSdnNMSugLloXj+IY/lxGjotC6qAcnrhERiXMSRkP6gXYzJqp4sMeVcDAKCy8sVWDU9UazRWP+P7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqRjMAqLhjMCq+raCq9B0z04Rf0sGZ6cjY4CFq2qVeA=;
 b=CJR4WFY18UOKTY+TrYEAnsYv2D5I3LvnY5tOSMtwz6T6fO1zjDVoeF0IBhFyGMnO6cbUk7kM55dAboyU4kKyyzgGWNGOmo9ahYXlZBJp7RHHrLbSBicVf3+eV+NcRPB6y3BXPiQjTIPzLNK7akNiU0Zc1QST0NzMn2xl/be+opE2MxJAJp95JkX1ZP56ahf1v7pHGGNFv3FdEStgkDe141FI02nb6pJfdJdnDNsBMl6psseFPgmBB4QiU+dgCpLb3PnzyMj06ZYOnjBUla44c8/4uq/4e4ND0eKy1PdbZ39Vx7MTMSj4jJYLkAxDkyiVJFuBet/noBW/yCRda/eJjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqRjMAqLhjMCq+raCq9B0z04Rf0sGZ6cjY4CFq2qVeA=;
 b=dUYVOyhdWFlx7qpGvx2KX5VqDT3wOfjpi1a3h3dXpJDj0fY/VvM8eJrOrbj5n54O1/PMj1KqiQQRoy+ALKayDRq8pD5fiEmWWLjOLW17st5WmpI3gU3fqUP4au/IVE+zcYW5PiJSMAD5RLF5XPXs3iEB9myMtlkMhiYUDpQADBI=
Received: from BN6PR03CA0066.namprd03.prod.outlook.com (2603:10b6:404:4c::28)
 by CO2PR03MB2168.namprd03.prod.outlook.com (2603:10b6:100:1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19; Thu, 16 Jan
 2020 09:13:03 +0000
Received: from SN1NAM02FT003.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::209) by BN6PR03CA0066.outlook.office365.com
 (2603:10b6:404:4c::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend
 Transport; Thu, 16 Jan 2020 09:13:03 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT003.mail.protection.outlook.com (10.152.73.29) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2623.9
 via Frontend Transport; Thu, 16 Jan 2020 09:13:02 +0000
Received: from SCSQMBX11.ad.analog.com (scsqmbx11.ad.analog.com [10.77.17.10])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id 00G9Cnww032341
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 Jan 2020 01:12:50 -0800
Received: from SCSQMBX10.ad.analog.com (10.77.17.5) by SCSQMBX11.ad.analog.com
 (10.77.17.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1779.2; Thu, 16 Jan
 2020 01:13:00 -0800
Received: from zeus.spd.analog.com (10.64.82.11) by SCSQMBX10.ad.analog.com
 (10.77.17.5) with Microsoft SMTP Server id 15.1.1779.2 via Frontend
 Transport; Thu, 16 Jan 2020 01:13:00 -0800
Received: from saturn.ad.analog.com ([10.48.65.124])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 00G9CkjW020088;
        Thu, 16 Jan 2020 04:12:50 -0500
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 1/4] net: phy: adin: const-ify static data
Date:   Thu, 16 Jan 2020 11:14:51 +0200
Message-ID: <20200116091454.16032-2-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116091454.16032-1-alexandru.ardelean@analog.com>
References: <20200116091454.16032-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(396003)(39860400002)(199004)(189003)(86362001)(70586007)(426003)(336012)(246002)(2906002)(2616005)(186003)(478600001)(44832011)(26005)(1076003)(70206006)(4326008)(7696005)(107886003)(8936002)(316002)(356004)(54906003)(36756003)(5660300002)(110136005)(8676002)(7636002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR03MB2168;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccbecbf9-1b44-445f-e36a-08d79a644a23
X-MS-TrafficTypeDiagnostic: CO2PR03MB2168:
X-Microsoft-Antispam-PRVS: <CO2PR03MB21681406FBBAC3B07A3A3514F9360@CO2PR03MB2168.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-Forefront-PRVS: 02843AA9E0
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gBztuCJmsLJO8kvJ4YvEBRQTOiyeJZ0WeL0VsoMa6FyoX2BZ4qENoI4kTUf0e0IcnJ7X8TrOsSp+FO2py1/T2IosgSh3XD+ol5SZqprDzq0niB8AFTD1LrGBAt39nWaB7cwYBl85ebxNgZWeBo8thvxweQuU29rLySylyI6S05v29LKlfV4GlreWN9shzRAYmdwrJGnlPNfgetEaqHL3PU8jqw4UQwtZAQ0BKQfz0UxjuGd8kbhF+owwju6auByTljS05qONwZ7E+W4jZZAOmCZSdXj/jHdjLKYBvAw52L9dMwp7FpVxH6VFL9g5aXA3LGVmpRT1PeMH1LStTh/GFbjzBd05ocZz9+rLFDaFJLdEs2CaK6HiSd0U0jh6rg+EKQhPOj3PEwzGJvMhYHriNVuN0S6rXNDXJLxvrxaMYBTlkmzmeePmcPFmzPKhbJU4
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2020 09:13:02.6306
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccbecbf9-1b44-445f-e36a-08d79a644a23
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR03MB2168
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_02:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001160078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some bits of static data should have been made const from the start.
This change adds the const qualifier where appropriate.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
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

