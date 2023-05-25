Return-Path: <netdev+bounces-5292-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1B87109F6
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0A871C20EA4
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0F7E566;
	Thu, 25 May 2023 10:20:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D69E561
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:20:58 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B4597
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:20:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6bgs0T6UnqMyKQMSUBC79qo5/rUZnYj5odnV4aDEGyk5D0fPTjyevmhvHJMN5nvg9Sw42xrkGnkcvt7JYXKWkwVtJE09WdYpg1DYvyQbWDP4GJwdbAmI50F4H+55025bxon7U3SHDwjNl9jWwaBmtxg3cj9vCnWIwIfkIXQpdOUnzsXPz47JgJz+9Tuze3GAeW4OVnZoPeI28MAtXjYzEIjeUfp/XrTiQSQ+eWdo3kV6Ksi6NtiPIKlvcg/S9G3RcjFVp+5Ve9ZbgHNWCNRTgJ/FkOCLp4iL+rh+YGm3wmgFXgGlKhKn1Q/tPVyRf+mubsE9YfL60G++MGonr9z9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjaT3C6ii77O8N3hpldU4fhCS+qq96qB06wReHgafZ8=;
 b=l6bQ7TdJ2UtnpIF+60iQf7QSratA1+cDcvZrlsefekh7Mi4/vRrtSNEPScPoUDvoLPuRcuVawl5mQZEwBYRUEYM8dydzMR9WwJC5teK3tAiffxGmCYXytnzFJ3CWWVy3j5vwRCZjiCdrua+SE6GnRk2V478PGtjNaH457xRkdqvjrDNM3m1v8GOulev8vKYS5n0hsmgN3wquAeh4P/wMYk4ieFGFOURtvcmynX4xTj+ondnEUla4o+prynwQjKircX81DIrxDnSzJ6MKikHRhg+qdmq+XmC8M3Ls56CBQQSHKOD3xLXO8vFeRIgTJWchc45hN/eID7spbvW4RccFnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjaT3C6ii77O8N3hpldU4fhCS+qq96qB06wReHgafZ8=;
 b=zArARZBt4sXBgprWNg0jmjLJN+VZmPFYVAqobg02fGjjew3voKsV5NXCnBDFzzqAS6zrg5JmUfXr2MnXPd3abvMqx343RJyvluppj8EPcZma41UDj95VnFfS1gttHCiJLsZ77D9wIf/E+Su+EY5/+NCw3jcrHaty7iP0ekTfvfg=
Received: from MW4PR04CA0197.namprd04.prod.outlook.com (2603:10b6:303:86::22)
 by CH3PR12MB8901.namprd12.prod.outlook.com (2603:10b6:610:180::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 25 May
 2023 10:18:53 +0000
Received: from CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::cb) by MW4PR04CA0197.outlook.office365.com
 (2603:10b6:303:86::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17 via Frontend
 Transport; Thu, 25 May 2023 10:18:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT098.mail.protection.outlook.com (10.13.174.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6433.16 via Frontend Transport; Thu, 25 May 2023 10:18:53 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 25 May
 2023 05:18:45 -0500
From: Raju Rangoju <Raju.Rangoju@amd.com>
To: <netdev@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, Raju Rangoju <Raju.Rangoju@amd.com>, "Sudheesh
 Mavila" <sudheesh.mavila@amd.com>, Simon Horman <simon.horman@corigine.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH v2 net] amd-xgbe: fix the false linkup in xgbe_phy_status
Date: Thu, 25 May 2023 15:47:28 +0530
Message-ID: <20230525101728.863971-1-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT098:EE_|CH3PR12MB8901:EE_
X-MS-Office365-Filtering-Correlation-Id: 963643c9-5e48-42cd-c7fd-08db5d0970ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YE+9uVrPRkuZYCe3E/eU3Mgj5A5vtxoTwIJv4NfWeWjKnqEej46AzWifwUF0F86bmloXpAfcwYi3B6IfIaMvsHIeoanNdMQOY147ct00HDbMjPF0U4cF5bmUFDAnrIzDzTRwbHf3LEqjyLmQTL7aXf5B2jWnrJjUm0epQPCzp1k/S1BUs8RtbESTB4WtZ7kbDl8sVwIT2bXlrSjDbxkOjPlVJbaBQY6drpnouXFGwn6+7zJ0fL+NHcBYY8hPM5zqI+D7qWiZ6KBzp14oB/W3MMjkmFMU+NUuwll04ML7gHPLIDV9BPVGQzJ1b0xz/6PzXW7iBT36PuMnYHm5cmenVlutwZTVd/r2KcKLmBjfjwR87A6J44VOMkJ5TE9tfZ01OIqP59I9mS69QpusKu3jehX8gSk2j8/E9Dg9A8h84+8MITlzoJp7Zk36HBQbmnujnm5ei9Lqu7aeiRENMLmUVxB6UTjV+cc4Y9yG+p2DazF1Binw7NMEwv1MBMgq2aw4MfBkDEHNXQ+J5dBV0zDIASQndYQrjOMkVJZHvENM3UZUf2KWFuzYzUwP9X6/Ju3B2feKjtg5yUZVjM/LyJZ09GNniGDhDNPUgwCsfGs2wC1yRKJU6V4AbTeiMzpkSA+0IYsBAOOVTjvblgkfh+9+iLiryxc2Cw6G88ih2v92yzHsjUjTttl9NExYYpDveEHvxjreUoL+Bkde+EESPecApJgfsGYQUFnO9m7z33aHCDmxI74zAeofvtWQmiTLXaEKrP2cLcECMXDhQKwJF2ndYg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199021)(46966006)(40470700004)(36840700001)(478600001)(16526019)(1076003)(186003)(82310400005)(54906003)(2616005)(26005)(7696005)(6666004)(426003)(336012)(356005)(81166007)(82740400003)(40460700003)(6916009)(4326008)(47076005)(83380400001)(36756003)(70586007)(2906002)(8676002)(316002)(41300700001)(70206006)(8936002)(36860700001)(5660300002)(40480700001)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 10:18:53.2305
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 963643c9-5e48-42cd-c7fd-08db5d0970ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8901
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In the event of a change in XGBE mode, the current auto-negotiation
needs to be reset and the AN cycle needs to be re-triggerred. However,
the current code ignores the return value of xgbe_set_mode(), leading to
false information as the link is declared without checking the status
register.

Fix this by propagating the mode switch status information to
xgbe_phy_status().

Fixes: e57f7a3feaef ("amd-xgbe: Prepare for working with more than one type of phy")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
Changes since v1:
- Fixed the warning "1 blamed authors not CCed"
- Fixed spelling mistake

 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 33a9574e9e04..9822648747b7 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1329,7 +1329,7 @@ static enum xgbe_mode xgbe_phy_status_aneg(struct xgbe_prv_data *pdata)
 	return pdata->phy_if.phy_impl.an_outcome(pdata);
 }
 
-static void xgbe_phy_status_result(struct xgbe_prv_data *pdata)
+static bool xgbe_phy_status_result(struct xgbe_prv_data *pdata)
 {
 	struct ethtool_link_ksettings *lks = &pdata->phy.lks;
 	enum xgbe_mode mode;
@@ -1367,8 +1367,13 @@ static void xgbe_phy_status_result(struct xgbe_prv_data *pdata)
 
 	pdata->phy.duplex = DUPLEX_FULL;
 
-	if (xgbe_set_mode(pdata, mode) && pdata->an_again)
-		xgbe_phy_reconfig_aneg(pdata);
+	if (xgbe_set_mode(pdata, mode)) {
+		if (pdata->an_again)
+			xgbe_phy_reconfig_aneg(pdata);
+		return true;
+	}
+
+	return false;
 }
 
 static void xgbe_phy_status(struct xgbe_prv_data *pdata)
@@ -1398,7 +1403,8 @@ static void xgbe_phy_status(struct xgbe_prv_data *pdata)
 			return;
 		}
 
-		xgbe_phy_status_result(pdata);
+		if (xgbe_phy_status_result(pdata))
+			return;
 
 		if (test_bit(XGBE_LINK_INIT, &pdata->dev_state))
 			clear_bit(XGBE_LINK_INIT, &pdata->dev_state);
-- 
2.25.1


