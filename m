Return-Path: <netdev+bounces-5151-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 492BA70FD2E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:51:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76762281332
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7272A200D6;
	Wed, 24 May 2023 17:50:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5B81D2C1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:50:57 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B049B6
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:50:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjhJfyNNPKhNnfSUX0ALCp3PLwrf+khIPpN7SgSCZEsCtQ0RbubSj68ueTs/6zBLL/wOzptkaH5VinQaQ1W5vXx6XL+zHwhmqUSGOju6AGXVq8rj+UYgre5pbxG6d2xIuIxlwXVXPXCxG70pFd/ct4Ja2Tzl60TgOm14MSekhXkD5Yh236IGdOFe/gDtfsNhrxbysW4QxdCbqPQWXeMuBZ8CL+YlwvK4s+ucvTS7gijG7ll7vIpPY1cCpA3qTMeqomzABQMe5jucFugbm+BYVmhqmH7rA6pC0H/c46juKZRO1uJlUqlABbd3IOLH4RIb45ZWROSK8Z+bGq9DnPRo5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+A1124QEmo/blOo5RQo+4YTNxxbxR7iOvKiRPL3+wn8=;
 b=HsKjT/Jd3uXHqGVNudNS1LPxrh+000lNwygMg+0lD03gbtNvXgNyuzy4CkJnQAx/hrxIUCwWX4kZh3TZkB+Ds7sWiui8Ap0WBLk99jdsrc0uuO3ISeE9SzHVtv17G/iDDJb3K1OXV/dpdiULqD9czTKiZ856ojCLRgjYx7kD89kMuPRTularpihf0Qp4Kxr1eufDYGQn9hPCSs9sT7Gyc600jFjdzPZlcwIwGE9nxjVQ3IXWnYCHPecsWoslkUDMFgBQERSVmwEP3bZXNp+xlymon8yyQvYbPhQaOkk1EdOwUUAlUXUgLMmfslsZfAJO0aX0AE8b3C1mnowvtGskaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+A1124QEmo/blOo5RQo+4YTNxxbxR7iOvKiRPL3+wn8=;
 b=p1UKgSKWbdHAwcLq6d8xg7ye2mp7oFc7Fs9xHT4Qt5f4hxeVTdGjomKne628dcBNB4uEEnf3wALPdeACu2VkNcXnBTy2ONOqozMXPJDGJ/vEHLTEf9KUyjeLugwRO/s2LnYsa+0awsAOamZA6cc2dTb4/A/nkOydbtcJ/0V0K9c=
Received: from BN9PR03CA0499.namprd03.prod.outlook.com (2603:10b6:408:130::24)
 by CH0PR12MB5092.namprd12.prod.outlook.com (2603:10b6:610:bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Wed, 24 May
 2023 17:50:53 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::e0) by BN9PR03CA0499.outlook.office365.com
 (2603:10b6:408:130::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29 via Frontend
 Transport; Wed, 24 May 2023 17:50:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6433.16 via Frontend Transport; Wed, 24 May 2023 17:50:53 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 24 May
 2023 12:50:50 -0500
From: Raju Rangoju <Raju.Rangoju@amd.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <Shyam-sundar.S-k@amd.com>, Raju Rangoju
	<Raju.Rangoju@amd.com>, Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [PATCH net] amd-xgbe: fix the false linkup in xgbe_phy_status
Date: Wed, 24 May 2023 23:19:02 +0530
Message-ID: <20230524174902.369921-1-Raju.Rangoju@amd.com>
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
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT064:EE_|CH0PR12MB5092:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bcbfadb-8706-4032-cd77-08db5c7f6b26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	536Oprq4YBt14quoj0FwdEgZyAMjgOZw1wNnpfdCM7KwGnIJU4XO2jBpiRpxNoJ0oZNw+6A1glqMviq4gdGhDNPZPrlGOQ0fB6rAJkpaSTCulMxSSkZvqiA9WrJY4LiyofuYR3cp1wSmTxbGs7qJ68Xl02O7NLVZTYlcwiFUVSPzMvvvCYabmi2iOY9Ac0R72tm9fKwAFO6uP2BKOlvcU0Io3u7XPaZuA7KAA+r9b2W7CDQ2Wtmw1ZEQHKWROJ8c/aAE+jwDmDKJkILMAvlpSdu9H6itxuemLEGvOpzDBOyeaafCPAu8aP7x0xmXsf7169aedBsCjP8x54UyhFU4QeEd0jQt+FowrMKyctlfP+D38QzmoKWiU++leZa38q+FgVX4RBa6dPsG+VQgxDQ+9ZqxlfebO1HrbBlJ1ShEcnDZaTWjk/X/I6bA8PaAoqa9SCk602mVRmDUtzm0qbgaC5b8tghgAgmph8IFyRPprATW/H5w97gRGs3iRXgvaLtbOT7I26YChnIVn5SDeSq0QQksg1NQod1w8yIh7DgF2EB+W2NmfdqU1/WPIgLRj9PqKeL7MWkYDjAZQBt5oU7lTx765bhbKgUzCcdTWRJ5v3f8vNg+TaoUDedEshLtn6OSuzpmeJkWnun6EtnbmL2L1skDH1AJqq5pDHQW0LX9PKfNbLTkdlSoJbMNgwlEqh/mvUGwXQkFDuMCUYqicLoySxK2E8iDYs9B64l8dqmz5IoArzUJn4synd1kfdwKfWvU82ELu6Ozve7tHLA5j6LPGQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(82310400005)(82740400003)(86362001)(70206006)(70586007)(356005)(54906003)(478600001)(81166007)(36860700001)(83380400001)(47076005)(2906002)(36756003)(6666004)(7696005)(2616005)(336012)(426003)(316002)(4326008)(6916009)(1076003)(8676002)(40480700001)(8936002)(186003)(26005)(40460700003)(41300700001)(16526019)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 17:50:53.1051
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bcbfadb-8706-4032-cd77-08db5c7f6b26
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5092
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In the event of a change in XGBE mode, the current auto-negotiation
needs to be reset and the AN cycle needs to be re-triggerred. However,
the current code ignores the return value of xgbe_set_mode(), leading to
false information as the link is declared without checking the status
register.

Fix this by propogating the mode switch status information to
xgbe_phy_status().

Fixes: e57f7a3feaef ("amd-xgbe: Prepare for working with more than one type of phy")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
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


