Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0273604F8B
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiJSSWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiJSSWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:22:14 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2056.outbound.protection.outlook.com [40.107.101.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13431183D92
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:22:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Osibz9bDUJj7PpCSk0SKDj5lkxcehutba4OieI6m6kbQK+Gx8C8+6XXurOa2QJ/rlkheT5iFwrxUpw7z8yUQxcKJ2ppqPM/76hAOc1pCDGE9QPibUQ3hFs5qAPK/x/inrcKhgV032jziYrwiryMDpXc4GyXiRtOc1UVmvvhhgZcpo6a7VkSdDHU36OUyHL0YP/I91xuL0vMSrZuQsYJqOfI0GpwabsYiiUc+DGApNvoAy3EVPJSnQqwRySL2P5yiXThbm1CUhcISmUXVfnCQRd5rgilkmeaSjNS8pSwG91aOBQ5Y6eHcbNpr9kC0c0YVGwBGxUiY3So/Qpgi87o1pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmcoAN+AvWd7F5ynyTUMOjQjWTLt8+++vKix8oaSc5w=;
 b=L9U/dlHC2+k9rDaT2Vn48CitdASpaslWKTyeZs+VafylAQrCsm6VLvgUZBn8V2EEN447W3LfrNpsggM+wZ/iryXMzaii2cgg5xAmDUMSTh8OqpDoNGQE2we77+MJfWkj3esw1FXQrlU5AVNiREAtFU25Uky8Ku06vgkxCpp+gkMtn95cpAPKon/vUOzfJ/EQ1IZcQvcydBedymz9eo9Hoz1cRpToTCc/pmpSIEljjHmQdDiFuqyj8+MAMcpce911gQ/bYoc8nsAo8/gmqwyQN+yQZK3yCOaVObJV1b3f9hm9tcDleXhnjQ4nXeMuJx4mo0snkvAJyAtkNEnYwkhx5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmcoAN+AvWd7F5ynyTUMOjQjWTLt8+++vKix8oaSc5w=;
 b=xOfmV93TW42YgGxPQAYEQImXnJD0TQMVpM5qHpaTgdrkfPZ1U/r9EtYbGddWwXX8Xi0+PuLva/gAslpPpx7qVH2I/4E5Ap+Wd3/CsekgecYCj+n7AG13gurWbUGbYupGZcN7IWsYU3vHDPp0jWX7kDcfTTP/UHE1PZGDon3x4vM=
Received: from MW4PR03CA0077.namprd03.prod.outlook.com (2603:10b6:303:b6::22)
 by IA1PR12MB7685.namprd12.prod.outlook.com (2603:10b6:208:423::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 19 Oct
 2022 18:22:12 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::a0) by MW4PR03CA0077.outlook.office365.com
 (2603:10b6:303:b6::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34 via Frontend
 Transport; Wed, 19 Oct 2022 18:22:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT082.mail.protection.outlook.com (10.13.175.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Wed, 19 Oct 2022 18:21:46 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 19 Oct
 2022 13:21:43 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>
CC:     <netdev@vger.kernel.org>, <rajesh1.kumar@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH v2 net 3/5] amd-xgbe: enable PLL_CTL for fixed PHY modes only
Date:   Wed, 19 Oct 2022 23:50:19 +0530
Message-ID: <20221019182021.2334783-4-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221019182021.2334783-1-Raju.Rangoju@amd.com>
References: <20221019182021.2334783-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT082:EE_|IA1PR12MB7685:EE_
X-MS-Office365-Filtering-Correlation-Id: 794c4fe9-177e-4ed0-0b5b-08dab1fed71f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MVbN+zbXF7BODJxVQlck2OsmoIUsFTboHxCVCjptkV/uMfRWm5QrXah/IfVww5Mq4gX5sDIuiklwBj8wpdFaUByTqYsrnG6XWEkUayOA+DTAcSw/XFlEw1WD1wAW+mtqRBNMIyPAWCREt1ENtUFhZiabE29X5iMF0VZW0rHjmkfjqYFWwHLZ9YsYRVfETCOE3HSdjtNDVF5SZ1a2aAMrYsGOPuGHbhHpEd2xNgFq8hQThGqSCWAFfQ6NhR4Uruiuv/5t7V6Uj17bY6LRuHkEkKAhXe3hyemc6e24Lyq8dJpnSjpQrFHWdvUNwdwppALtkqTKCel+LsBfdZRNE4eyw0ySlUlAQ3IpgWDOYds6zFaLSnFFpKc8HBPImY7dsoRX/mkwDeM/zG5Sr9OnWMcMiNLdOGpCp+fgNYMneUx8kWfD+8ZqdY+PPwenJUpay+dVWM9Bq2tE0TctmF9/L1mBHpUjSuwVyUK0V2gmsPFVEhCP9y7/9M5O4AOPw+KBLLMcrjOW5jstQ9sG5ht9MZ230F1LVw3lXBWM5Inyai8cEFgj4MsT//0USZYnK1qabiztN9hk0w4fsKdoiNka/1NhTFuN4bKn9ewZSbG25HO6LDuy54hv7ZyXcmwaZHYdZFj8iwfdFjzdk+uCL+0v82oJ/aYDWfupgv69d8cN9VJIQgItPYk0MrSxafrG00nHOrOc8YYmonaEjB2NZp9tfPfGsZ9eC/OeRlvTO7b0AglTV3nimyynWonSnOAFnGqWLMJ2nVJb/anYebi1tJ9xqA96aG8jfT6AhYtK4ap293KGXS4Bp7gSQCdJ4OIwxNtuxsQZ
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199015)(36840700001)(40470700004)(46966006)(36756003)(40460700003)(7696005)(110136005)(26005)(356005)(82740400003)(86362001)(81166007)(4326008)(8676002)(5660300002)(2906002)(8936002)(41300700001)(70206006)(70586007)(83380400001)(47076005)(316002)(426003)(186003)(40480700001)(6636002)(54906003)(336012)(1076003)(2616005)(16526019)(478600001)(36860700001)(6666004)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 18:21:46.5460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 794c4fe9-177e-4ed0-0b5b-08dab1fed71f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7685
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PLL control setting(RRC) is needed only in fixed PHY configuration to
fix the peer-peer issues. Without the PLL control setting, the link up
takes longer time in a fixed phy configuration.

Driver implements SW RRC for Autoneg On configuration, hence PLL control
setting (RRC) is not needed for AN On configuration, and can be skipped.

Also, PLL re-initialization is not needed for PHY Power Off and RRCM
commands. Otherwise, they lead to mailbox errors. Added the changes
accordingly.

Fixes: daf182d360e5 ("net: amd-xgbe: Toggle PLL settings during rate change")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
Changes since v1:
- used enums for all mailxbox command and subcommands, pre-patch to this
contains the enum updates
- updated the comment section to include RRC command
- updated the commit message to use RRC instead of RRCM

 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 8cf5d81fca36..b9c65322248a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1979,6 +1979,10 @@ static void xgbe_phy_rx_reset(struct xgbe_prv_data *pdata)
 
 static void xgbe_phy_pll_ctrl(struct xgbe_prv_data *pdata, bool enable)
 {
+	/* PLL_CTRL feature needs to be enabled for fixed PHY modes (Non-Autoneg) only */
+	if (pdata->phy.autoneg != AUTONEG_DISABLE)
+		return;
+
 	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_VEND2_PMA_MISC_CTRL0,
 			 XGBE_PMA_PLL_CTRL_MASK,
 			 enable ? XGBE_PMA_PLL_CTRL_ENABLE
@@ -2029,8 +2033,10 @@ static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
 	xgbe_phy_rx_reset(pdata);
 
 reenable_pll:
-	/* Enable PLL re-initialization */
-	xgbe_phy_pll_ctrl(pdata, true);
+	/* Enable PLL re-initialization, not needed for PHY Power Off and RRC cmds */
+	if (cmd != XGBE_MAILBOX_CMD_POWER_OFF &&
+	    cmd != XGBE_MAILBOX_CMD_RRCM)
+		xgbe_phy_pll_ctrl(pdata, true);
 }
 
 static void xgbe_phy_rrc(struct xgbe_prv_data *pdata)
-- 
2.25.1

