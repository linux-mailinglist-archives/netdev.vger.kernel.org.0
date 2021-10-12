Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8126A42AB8B
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhJLSHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:07:10 -0400
Received: from mail-dm6nam12on2040.outbound.protection.outlook.com ([40.107.243.40]:2144
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231717AbhJLSHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 14:07:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l10LC5DdrX1CQ4GsWdxEm+9qCJ7q8+vqs4/Cb01BWkyFs4yomii/HPlhlQPMaxsxTqXElmKGo9iXZMT3QAybP9DdnVn61daT8DZ2IIpwdxNT4d77NSnoD5my+tfeaDCjM8Za+skV/JntELhYituSAr4jy/rcVIylMIcWFosskgVRS9DdSDzn+VZqxtORlVnETmzUP4TwJakWXjfeqqn1iMB8U0a3ABrGMYGMgmvd1620PQJqAmzH7HjHWlFWPd8OiHM9bT3MrctyAY4cLuR377+MpIH001THoo9ea+mdt4Xv7SBxpEAz3LWcydt5rNOdZG57oThk6/dduUrWubqNig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2PvId4TADbKNaXJvaQP7XnRUl1aoohCtMzQnaP11wdM=;
 b=nQRgc8hU66WMqXrOVhscJwXpTNOeLJ4DQhcTOJrIsc2Fh5jlIj2ZgEAEda0jCW7NDO3EBEeZbcSKtBOL6cdcV1tQXZkNbzQwcIy0uzkZaApe0IVGXcnl39rwKVXb/A2jQj5+5j0/fqd3B9d4G83o4aoSPKbfiOIj2ysnLuAGButJx6LR2/xnPh+d5AJnSFIbar2YBMuNPQDePNmkMUeq8Bt8I/DkXQFGXXvX6AonsBSBPmbu1E7eytFT7m7MnVRTdfbK0e4nRpsVNU/7UX1tQVwxK91FNEU0PJ1pf7R2UhvW9lpHXAJU7LRoe/8FdxUvwAVcCg4oVXb/Ej/9emjLtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PvId4TADbKNaXJvaQP7XnRUl1aoohCtMzQnaP11wdM=;
 b=pkBM7fYbX2zxgiOJkUyHmI0IbSOWZjr05cRDgARJ78yRZe/c0vvqsbO6pdYPvp82LqObVrlaYoGEgMliGkzEcPxEUgfKFqJC0ciqiYIfU+5GN6Pg4BQsr6tJH0F5YGtVnS1f8/+3BFGv4d1tMAH1Lw1LopMZGJYy/tv7tbyPiXA=
Received: from DM6PR08CA0041.namprd08.prod.outlook.com (2603:10b6:5:1e0::15)
 by DM5PR12MB2486.namprd12.prod.outlook.com (2603:10b6:4:b2::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Tue, 12 Oct
 2021 18:05:01 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::44) by DM6PR08CA0041.outlook.office365.com
 (2603:10b6:5:1e0::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Tue, 12 Oct 2021 18:05:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 18:05:00 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 12 Oct
 2021 13:04:57 -0500
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Raju.Rangoju@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [PATCH v2 2/2] net: amd-xgbe: Enable RRC when auto-negotiation is enabled
Date:   Tue, 12 Oct 2021 23:34:15 +0530
Message-ID: <20211012180415.3454346-2-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012180415.3454346-1-Shyam-sundar.S-k@amd.com>
References: <20211012180415.3454346-1-Shyam-sundar.S-k@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 116e0232-f4b6-4839-0665-08d98daacefd
X-MS-TrafficTypeDiagnostic: DM5PR12MB2486:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2486E265ADC10494F831A8569AB69@DM5PR12MB2486.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ykoayJgGD7+xoCWRJOAWEivagiOjqWiBPuBHfJeHz7lYFfOjKo2CNcurENbSfaYqUrlUCdXq1WCzHWH1OxKG/H8RZZbe8025pklStqf1BueWbKGnXnpuiOO1xSwn1SgfwNfOQ/qthjwaPi2xFQvO9S8IybMQwUGBa+yh+mirhlopTmLFB9V/0S0XwqsGEqzRxDWXvTz/paYU9As13z0d6uY9BmWW/x1C5MRGbVn3/J9QXe1bPnVWXxBCnMUK7TCT3FBmb6+xOtCgUGoOi+eS5dUPQ70sBpBqhyYmyE82+Ow0Cs+lpi6FDp9078n3cn1QLzywT1DC4SUdsv1w2O7dcQ/U68HGEeNRptRIb/MnO5yKnv/iuuhrp+pUYpsKdoBTKO/qwWexuTtfIn99OmjzmrwZGgmkNdXtn5qDr/rB1Ttl4j0RMSos54Ko5mPXxRGqCag+0SCfCDp7XFFMkAk5Qis/UyaCBB/rltd9fbmOfdYpuJTd7c7ZdSwPKHU1ZwgwbhHgcsM4FraauLTdADNmwmOibf1/0upcSn6ymJJS4ERRdeUKmibPYIoW2VnU+CcjfgfqW19LD8/Zg4L+KUxgSkAXjS60SUqkDoECsPMNz8QK2YCWYIGje6ZVbfyZFy1drjy882ogescSqAmXGnae2hjIZ7dCX57PG1J8zIfMUZBr4gEHzuk9Z9kdaB3Igbak1gRfC3mVWafJj9xNbjykgTdMTlvBYjOGq/v/0nfrPY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(86362001)(54906003)(508600001)(8936002)(81166007)(7696005)(356005)(1076003)(70206006)(70586007)(36860700001)(8676002)(110136005)(4326008)(26005)(2616005)(336012)(5660300002)(426003)(2906002)(82310400003)(47076005)(36756003)(316002)(186003)(16526019)(83380400001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 18:05:00.5461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 116e0232-f4b6-4839-0665-08d98daacefd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2486
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Receiver Reset Cycle (RRC) is only required when the
auto-negotiation is enabled.

Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
v2: no change

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

