Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5B4647420
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiLHQXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiLHQXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:23:16 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1FC45EF1;
        Thu,  8 Dec 2022 08:23:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFIt2AcBL6qUY/zqF6H2WRuXGBKLLATapmTvJswda5M4iakFPoxdI9YK6csdmRdQZdpb7VcIzWIg5h9KAGieeODzUg3dFW7sNqCaS943yHp6J5B3SooG9XTmO8LYM36Lr8w/GafbV/REptQBzaSWU1FV8CAiX3qqrVoIvxLjUucBHNKO+XVx1EGCYN8ZJz+IY8WfmGDs+o/i6LL0Wk3FMDtmLfql9CAnC6eEcVV0BEQkiaJ4kuhkgttIy9OY8hdHWvdJNrA7dQPcV2x4aRZE3CiTYDXS3pYkptoar7Amjsp2BwNerBusPlmi9pQ6bp5lfjutHN8aDfVmJZonlmJ6tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGv1bUKoON/7BDuP65fPZTgki1lAzvgeqvNzRq3dW7M=;
 b=VbAyM/UgQhLo3/3cd9gX1Xjq2Xpiw2Snqd/zp3l4FpcoNXhaU0mnbFPekSDgW1ZP4wkhBbNskph42VIBHs2jN0JyCmmknydVIc8X4Hoygn1JeLxtmopPD/bcxbLZfxteGhIJfBE5AEMClCAL/H/VKKmA+4k6q52Qyd/DcNiSr9mmBdLX0YIAaxr/o7RDlpkotQe1LXFDCtXtVAZF8+6yNIZU6TQaXmMydbGzzcJVYvvBIDJIYQgexVMZe2GElXW7+muQpFzkhRwgrYt6DeMOhWStHrXf4cLia1++0PudjnUsyFxIOTEizv78uVfQ9TqP6G1Ne1DhkFb8pch7PsW4wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGv1bUKoON/7BDuP65fPZTgki1lAzvgeqvNzRq3dW7M=;
 b=5Q2UZrUE7fU16Fz6PeQ0hY4g26k6dcsvokLdADLY+cQ45TxZwAAXHGrC70WW0IU7kHG1nZKwrzoYsvZiGGdVixxUIEC2xeChRJ735aVCLgMRH7ejtayO6z7NBYJuE7j9U4RIFpytDYrOKkwbEumRSg0CdHWakj6IQen0uzt7T3E=
Received: from BN9PR03CA0628.namprd03.prod.outlook.com (2603:10b6:408:106::33)
 by CH0PR12MB5331.namprd12.prod.outlook.com (2603:10b6:610:d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Thu, 8 Dec
 2022 16:23:09 +0000
Received: from BN8NAM11FT100.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::1d) by BN9PR03CA0628.outlook.office365.com
 (2603:10b6:408:106::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Thu, 8 Dec 2022 16:23:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT100.mail.protection.outlook.com (10.13.177.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.16 via Frontend Transport; Thu, 8 Dec 2022 16:23:08 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Dec
 2022 10:23:07 -0600
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH net 1/2] net: amd-xgbe: Fix logic around active and passive cables
Date:   Thu, 8 Dec 2022 10:22:24 -0600
Message-ID: <55a23ec3393c505d2420fc81190898f5e6a4ff93.1670516545.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670516545.git.thomas.lendacky@amd.com>
References: <cover.1670516545.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT100:EE_|CH0PR12MB5331:EE_
X-MS-Office365-Filtering-Correlation-Id: 36774a75-84ff-4e8e-420e-08dad9387e6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C9Q0uOSmNYyY5sFmFzckElzxgxw01ovtwyKlQ2O0pWQ7Xzmi0FgMOl0XbeZ2O6zhHdCzcE44oXWtfJ70WnEXwZXKOdviVkaFQZ7/co64PRQTzr3U8e4jJLuDlCp6Pgh7om4HT+AzQI2T+G+v9/0NdaV6Lfd9T6SbdF3MrAGlcDX7go6couUlm/cldw1JZ/KFs+/GnMQJmKqQdz6TaDvOvdAvQulHPI5XAuRZrhyNd6riM50pULpuHJ57kaKUT7uivb+xD5p6W/uOrun64IZ3UlYM8XPmdUOkqtjjYNlckgYMpOWhETtUdYKsis0Y3paoc4RzcAPmwU8wloGJIUsXSMnt9cOLADEL3r59SutZbMFQmAZ8xxImMtcUpgBg4/basDXZeco+odY4gOfDKbJthNwmPreaUlmxqtBJvqmQFvns6hxkKCuncxXuLRCqON0VaqFxHNEqU4tiC2IvMg6o+sHYfpwFd/rw7jOE8Y5I2fhPInNkY8VwQ3b6n3aQ5RljVLI20ak5PX8cMbwrugHk9WfK4TuavwCFULqtTDz+1JR3G0V2Td6IE8zh0cIeCVIChsur7ZOw54XaIoTWv0WPFl5ZPuCp6RrglXR8X7m1TgR+2T2PCc8Ye5WyZsJ07jDH/SkZoYKoZ7Mjft4y96IyvEUJOpQB3D6U4jmwqJ3XoxI5I38zSs3ueWhRJ4uJXQ9o3mVjGTVCbmnfIQ8XJPhIme2BIzUxGn6L8TGoo3JlqU8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199015)(40470700004)(46966006)(36840700001)(5660300002)(7696005)(36860700001)(47076005)(426003)(316002)(8936002)(4326008)(110136005)(40460700003)(2616005)(40480700001)(54906003)(70206006)(70586007)(186003)(16526019)(26005)(86362001)(8676002)(336012)(81166007)(356005)(36756003)(41300700001)(82740400003)(83380400001)(6666004)(2906002)(478600001)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 16:23:08.8428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36774a75-84ff-4e8e-420e-08dad9387e6e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT100.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5331
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SFP+ active and passive cables are copper cables with fixed SFP+ end
connectors. Due to a misinterpretation of this, SFP+ active cables could
end up not being recognized, causing the driver to fail to establish a
connection.

Introduce a new enum in SFP+ cable types, XGBE_SFP_CABLE_FIBER, that is
the default cable type, and handle active and passive cables when they are
specifically detected.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 4064c3e3dd49..868a768f424c 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -189,6 +189,7 @@ enum xgbe_sfp_cable {
 	XGBE_SFP_CABLE_UNKNOWN = 0,
 	XGBE_SFP_CABLE_ACTIVE,
 	XGBE_SFP_CABLE_PASSIVE,
+	XGBE_SFP_CABLE_FIBER,
 };
 
 enum xgbe_sfp_base {
@@ -1149,16 +1150,18 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 	phy_data->sfp_tx_fault = xgbe_phy_check_sfp_tx_fault(phy_data);
 	phy_data->sfp_rx_los = xgbe_phy_check_sfp_rx_los(phy_data);
 
-	/* Assume ACTIVE cable unless told it is PASSIVE */
+	/* Assume FIBER cable unless told otherwise */
 	if (sfp_base[XGBE_SFP_BASE_CABLE] & XGBE_SFP_BASE_CABLE_PASSIVE) {
 		phy_data->sfp_cable = XGBE_SFP_CABLE_PASSIVE;
 		phy_data->sfp_cable_len = sfp_base[XGBE_SFP_BASE_CU_CABLE_LEN];
-	} else {
+	} else if (sfp_base[XGBE_SFP_BASE_CABLE] & XGBE_SFP_BASE_CABLE_ACTIVE) {
 		phy_data->sfp_cable = XGBE_SFP_CABLE_ACTIVE;
+	} else {
+		phy_data->sfp_cable = XGBE_SFP_CABLE_FIBER;
 	}
 
 	/* Determine the type of SFP */
-	if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
+	if (phy_data->sfp_cable != XGBE_SFP_CABLE_FIBER &&
 	    xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
 	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
-- 
2.38.1

