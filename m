Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1976949DA69
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 07:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbiA0GC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 01:02:56 -0500
Received: from mail-bn7nam10on2077.outbound.protection.outlook.com ([40.107.92.77]:8224
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232585AbiA0GC4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 01:02:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMBxhhncNWkDCOv1zrFtdiYocoMuR+RvxypCpZJmkKRx2O8Y2J2GNIw8OAYICbKCO71yD5S47TO9jV2ezwx+f2+xGx7eC0LQmtNFzHaodLr5jgbe/xHQ9XS+65UUGUP39DZrqqW5Ui3A7rQuOnlLwJSAQVbvcCXBBr237xzNePJHSwecLIp6UTHxfjIFpvzz+CAUGOcycoEy8OmxYjdaNAhkPXJzS5Xh8hbgPrw9Yy3sOtfgmTYHqId/2LTsNdCplXJVlX9ckrVj4Ovkqi06VxUprlZgvOo1ndo+nVd2Z+GQGdqB6CwNdlG0+F4yWLNaU8/pZfZj+9Gy5nGovyEfZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pf6IcoG4qb3PooDhfPZHKjNjn2I4jO8iV39c7qLI5Lw=;
 b=OQrYhPl2yF0mZn4uFJjEqsx5zXPRG0Rhj0QCg88LSJlRuqpUR4yACVaWUPJa5Zg3FVDG4WOj8RuSxvFcAd0OYlMcpL/o8x4uZby4aQ+fr7ew3s07GQ7Qpdq4wLbyj/Fw5b9joVOBTTjGwtsdI2ReAv5T27Ga1zF2/f1BE9gaffbay9VWKVts05ardWsh+DglBXLFHifkRc6dhm6Q/IE4NQX4su9nU3Ek5uEul9s0vbHY+imgsLcPe64P8S76IoL/W08G9RQBNTk+//jZiCMx+QroDf0ty2tKmQut3loK01mwPg5N4wOd5CzMVzRUb8YowiQcYl4pWSHgj/t91Qxi0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pf6IcoG4qb3PooDhfPZHKjNjn2I4jO8iV39c7qLI5Lw=;
 b=FCwpTg4Y2n0G+rESxjaGaW+WkYjiYUcT41vWzOTrw0/W2OnRxiLJdXfar0QlmOOReMVsCR0rv26QuyLzIPMyjVBwgyk4YDKyGCMELDuUDkcM6+1uiTOYqlte7PU9nopn7+B3uvHXwyAuqZeVPIuby6hbaaoTsnvM5InnJMtMbn8=
Received: from MWHPR2001CA0014.namprd20.prod.outlook.com
 (2603:10b6:301:15::24) by BL1PR12MB5157.namprd12.prod.outlook.com
 (2603:10b6:208:308::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 06:02:54 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:15:cafe::3f) by MWHPR2001CA0014.outlook.office365.com
 (2603:10b6:301:15::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.19 via Frontend
 Transport; Thu, 27 Jan 2022 06:02:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4930.15 via Frontend Transport; Thu, 27 Jan 2022 06:02:53 +0000
Received: from fox2.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Thu, 27 Jan
 2022 00:02:50 -0600
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Shyam-sundar.S-k@amd.com>,
        <Sudheesh.Mavila@amd.com>, <Raju.Rangoju@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [PATCH net] net:amd-xgbe: ensure to reset the tx_timer_active flag
Date:   Thu, 27 Jan 2022 11:32:22 +0530
Message-ID: <20220127060222.453371-1-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b02ce552-7417-476b-45d8-08d9e15aa85c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5157:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB51572D464A9969389B709EF295219@BL1PR12MB5157.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y8MOZKaAfKF2ie5DJrFihT9sYuwvmlAbJxNXgRQFe0EwpA6BhhgYU1WAD/KbTW2+f23pThyvzo2yPJT5anJ2W+AM6KOdgPIvr6fm7zu8GmdB9yhSKwU1IUqsxiExhYygpXNZge3/y31Q9Z687Ol3kJlF2TpQwC6MPNtBcugUkFAAAWBKG7QQem3vR2h6shbOobGoTvqhpu9M9WZzh+KlFkl/aT+0EoccI0wyXJ8p7pow1xoQu5JVPNDmI7A0q3klL5PSDTUBx+O+bdwa3B4Twp5ZVUHkivKen1eKVoePkZdbu3GOSdiSO8TOcvU7WcPS90Tv/WDDb7l+ZG36U3yAAeigBYVcZf0a/MJBO2yJqZvhVrv0yAWgVX+BCYhG6SBepCtfaCUMnPPFJdFroMZgjfX4ugvCIjRxpCmkPzDK2o4gwTDTkbN729kc0Ghkkp+mEgyrVPlx+LlR9hGsLLmjv5wyAS1RiBCc9aA0p8RlZq181HRgS++tlC80I8/p11xG4MGPyIYRDBDIYt8feB8qr7Sewd5YU5EnWGzKaXqIowGmJLe/fQeIa3mZUGhe2r1AxvBPv5rzVELBH26afDVamo1dM2xq0tvhda5naADKH/10PewBrMnp/zlDhBNoUr6gRaP1yR2uaCeqEOMvLF15GyPYn42YklrJcX1DFL+HSwDk2nDP0iUipPEPS7ap3AfrhggcQkLgVt1SZ+vehZtlhw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(4744005)(356005)(6666004)(81166007)(7696005)(83380400001)(2906002)(4326008)(16526019)(82310400004)(26005)(36860700001)(70206006)(70586007)(2616005)(1076003)(186003)(336012)(426003)(5660300002)(8676002)(8936002)(47076005)(316002)(40460700003)(508600001)(36756003)(86362001)(110136005)(54906003)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 06:02:53.5530
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b02ce552-7417-476b-45d8-08d9e15aa85c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5157
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure to reset the tx_timer_active flag in xgbe_stop(),
otherwise a port restart may result in tx timeout due to
uncleared flag.

Fixes: c635eaacbf77 ("amd-xgbe: Remove Tx coalescing")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 492ac383f16d..4949ba69c097 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -721,7 +721,9 @@ static void xgbe_stop_timers(struct xgbe_prv_data *pdata)
 		if (!channel->tx_ring)
 			break;
 
+		/* Deactivate the Tx timer */
 		del_timer_sync(&channel->tx_timer);
+		channel->tx_timer_active = 0;
 	}
 }
 
-- 
2.25.1

