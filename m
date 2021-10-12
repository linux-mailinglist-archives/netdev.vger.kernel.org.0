Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4251B42AAE9
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 19:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhJLRjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 13:39:53 -0400
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:48850
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230268AbhJLRjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 13:39:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfRbXW2BFfD5cC4RMkxrUUC1bRj3Wc6NLmmf0aPs8F2TXLUFL5+OtFYpSvmgBCdogFrXa08hQXnGFPsTmlgJWOeRbeaGlB3HaGbrRxNllbCiCtKeyIMoY7vqpnEx+2ogiszZIa/39xOV8IhUu0pCgORk55TJTBUisitDm161RDux8TgwsdxaOGmsQ09la8uevOYJZHyeJTWDaiU0hq70jQ9sshzdvzRp/ibcdd+U9jO0KxXgNzr6nvMUYy7FLQ4e828Tgel5JP3UStAKTR/AZ1FXOQLOqTyFMKZa19CMW3pIsoTG198wrJMf2A0ZaS12dw1s0uKqaiJmYptR70aQ2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5g6A6o0iuDPSBEF9BP1/WJQMhgQlIqSxLdAU5+yoEg=;
 b=Cnw1aP0/pUMJ0ss9rN3MmP0PXWXP+loPBNALlfVQq99IzFYFYxlX9SpN6JE9qxm9PvyW6uuKUufztN4JaMiajGE6dphONWvOTDuRZakse+BTTPzqsvbvbOukP+jTV62A/5siCsUq7325wC+KbTNuekoXAUtsxR+VfRvVlIfkoGEAjb97tutdgKTWHOyTFJxjbiz0s7ZKxhOW6UrMCeFUZ+K2KTOtyPp2cS1XJZ6jJP7ZLmnDbqP6+C+M9km+ljh9QKDqGTDMjwayBHJ5FqCNUqf0wkmHOUaLQU0fQCALbYTODmC6ZHWJgGr34Z9iqOykIQRzoib/4Ky/rCgoqD5upw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5g6A6o0iuDPSBEF9BP1/WJQMhgQlIqSxLdAU5+yoEg=;
 b=IV4ufZYhOgKVfBNKRr/SD3QOt2G4fdZ90tfFpv0S4zflqcBpZ2Zlz9tbxwDVYp+fJvC4Uxl/M2yz35efPEwMZ/Sb4anNaA8v3zNrv64OEUfSWn5DbGDfkcPom2HNupIbugoxPSSjMbsp4KTtie64EJvNndEejJFSqMESlsmEalk=
Received: from MW4PR03CA0054.namprd03.prod.outlook.com (2603:10b6:303:8e::29)
 by CY4PR12MB1190.namprd12.prod.outlook.com (2603:10b6:903:39::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 17:37:45 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::ac) by MW4PR03CA0054.outlook.office365.com
 (2603:10b6:303:8e::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend
 Transport; Tue, 12 Oct 2021 17:37:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 17:37:44 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 12 Oct
 2021 12:37:41 -0500
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Raju.Rangoju@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [PATCH 2/2] net: amd-xgbe: Enable RRC when auto-negotiation is enabled
Date:   Tue, 12 Oct 2021 23:07:09 +0530
Message-ID: <20211012173709.3453585-2-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012173709.3453585-1-Shyam-sundar.S-k@amd.com>
References: <20211012173709.3453585-1-Shyam-sundar.S-k@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b991319-b802-4919-fb57-08d98da6ffef
X-MS-TrafficTypeDiagnostic: CY4PR12MB1190:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1190103A747BDA4FB306000C9AB69@CY4PR12MB1190.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TmdM9HsCcOMsxfjKqJotcTqC8hEdHXyhGP9CVqk2IMt42dWfA522zlFSEVgCYgKoVbDHrKGUwWn8QesemDvz06zEW+FZ/UeyMdSd/l7QwYR1+7C/Zl9m/Qa5aDsa4rbjxgB4141yESOsLpbBZkL6BZ4hKKKu9m7uDvDQ/F4n6yoKlzijLC31jovL1XgXSy53Jrwj43wx4Cf7xVDpnbg+lNMnK5R8oOjwRkaZH2iBTP3Ra6Z8SGBV6hgEbpwZathrJfMJ0HW3vqnuWNuIBkewJzxofkgJS6e8u7YOnRQ2QQzn1jxd8lwVyGdJ0nTjYi7ZZN5m47Q8JrhsLPZbhqiOA4zsfHdIaE9iWgU/A1R95UhcS7tdYguNu0UVQaOk7aM52AH8z0wsZTceWey0GDfBOZzhtiUHyrZ69sQg5qjWlyytXUR7mO4J93JHIBvI/GgSecjvrrFc+L7qrwUci71bUcuT4mQLiT3h8/VvyVzTwQw8Pzerbequ7w6V5+7YYflLuPwKHbws9Ux1Gd4eOcp+tTx8MDaTWhlThNdXpRo3B9Ut1W+8PePUMiHUKG52NzzgDtARTABoc8Cz8HGmj0/WoZx1IH4dTofLpCyxKV2CHn1F5acOZrS/skL/jJBgFBhOyIq4Foq7Q3U/SQLzT2SNRnsI19aW/iXsDapwa5VTbwQi7Y0KFvBF/XxhEo842j6f+T8rdnehNbd/Z2uK0eyT47f40MDu/q9t+T2DcnLgt6c=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(508600001)(86362001)(2906002)(2616005)(70586007)(36860700001)(7696005)(6666004)(70206006)(336012)(5660300002)(54906003)(4744005)(26005)(82310400003)(16526019)(81166007)(316002)(8676002)(4326008)(356005)(8936002)(426003)(186003)(47076005)(110136005)(83380400001)(1076003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 17:37:44.6041
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b991319-b802-4919-fb57-08d98da6ffef
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1190
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Receiver Reset Cycle (RRC) is only required when the
auto-negotiation is enabled.

Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 4465af9b72cf..1a11407e277c 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2642,7 +2642,9 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
 	/* No link, attempt a receiver reset cycle */
 	if (phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
 		phy_data->rrc_count = 0;
-		xgbe_phy_rrc(pdata);
+		/* RRC is required only if auto-negotiation is enabled */
+		if (pdata->phy.autoneg == AUTONEG_ENABLE)
+			xgbe_phy_rrc(pdata);
 	}
 
 	return 0;
-- 
2.25.1

