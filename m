Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B7A5F689D
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 15:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbiJFN4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 09:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiJFN4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 09:56:39 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271239D50E
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 06:56:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKsMo67ZL7H3Kcg6iVcmIpKKFjGJ5QobMloaxcqBWjjtwCBfSV52My9ZL8DQ2LbM8UI+2gdpDFzOLe94xZVnD26T/4Oujf6v4AiArZQo4+diLFihbJ62yKzp8ZClRI2XLwGxvK4AqWigPneEDs8X0410dEcaxq3deOZhiEWOxpCnk19NkXHUNJ3FznIQ/sYCh488sosnGfDsqngQ459Cc8BG/FUSXOp3A0gwrQbt1phL6h1lANyRuCGDsaMcGFRgrCAfu38jdO0Nh44Fls1iGqsPMgdFQRSkITt2NWScggapa1mxDnJMZn1uk/xISLo91C5NqWESAoGsKVRPTNCULg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vEKS6qlYdqBtALbsSV3/yAqZCdHs8i61rltlw5FIVtY=;
 b=VA8G+djhRpw54kh0T0JJ+odnNnstT1C/k7GFjVGkVQJhJ4+Xabm5ErG2WXnM3tZps+FTWfpg4DVy0fCF9lMMvREtru3tISuveysMoWTFQgovQyz8Cyi7ybzOKbhXsoK/SvNFcpWtFm+qMI9/9ucjLyPyRDWYOOfTkdCz1FNtAJmvM65U8gwUu9cv2HA7A9ylLV+eLtNaPfjKk0v/EbBd/dhi4d/0RB9zMMjl2x7E8X29txIEJ6XSQHNPAifN5PztvjKVirYhMVRoCiv3Z0WaZ2ke3ySMHHeicv0pNqGe/clZIXkD0S/lEWbCaWFh0fT47N+x+aJKp7okPlklokhs+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEKS6qlYdqBtALbsSV3/yAqZCdHs8i61rltlw5FIVtY=;
 b=HPrVR++c8KDB5IN3Al0aRbH/34KaQ470WZ/iF/Is8+Hi+E3+3WEAOjv8/BWO5xUlJbCU6Eztikx0uH1xQvrM2V5LNO+unswLwXXnBoK+AF//mgjtUE+obBNut1Xq8fjAPDaClJYNmnTbufH2HcQ1rj8T8Zz107jT4+z87ZBrMuU=
Received: from BL0PR02CA0017.namprd02.prod.outlook.com (2603:10b6:207:3c::30)
 by DM4PR12MB7622.namprd12.prod.outlook.com (2603:10b6:8:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 6 Oct
 2022 13:56:33 +0000
Received: from BL02EPF0000C403.namprd05.prod.outlook.com
 (2603:10b6:207:3c:cafe::87) by BL0PR02CA0017.outlook.office365.com
 (2603:10b6:207:3c::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25 via Frontend
 Transport; Thu, 6 Oct 2022 13:56:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000C403.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.13 via Frontend Transport; Thu, 6 Oct 2022 13:56:33 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 6 Oct
 2022 08:56:30 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <rrangoju@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH net 3/3] amd-xgbe: fix the SFP compliance codes check for DAC cables
Date:   Thu, 6 Oct 2022 19:24:40 +0530
Message-ID: <20221006135440.3680563-4-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
References: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000C403:EE_|DM4PR12MB7622:EE_
X-MS-Office365-Filtering-Correlation-Id: e872ddbe-0727-42a7-a795-08daa7a293c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RpTPGoeIQECn218nOI2HSSE46jL+KxIulShZm9EXshT1tfxMwBOTI7GXCMwNq4tdcX5OnrJ9ELN32V7YE7VbMF7vVdx4N0N3tRD0S7dEtgKMcXU5dTzeY8VBnKOkflEgeWNPIdeixPja1QL7MDEuUu2P/Vwguw5W6RBCEAPaFhIPt+J3XDDg0z13Aa/mudrt2ubW2YwFaaVYIJAZk/oMijLHrMfQWZx5UDbPIuScfXelfmUTk/D+t2QdAoH74LpTZyorWxc/dwdRAy9vEy+WyvZcF7ekmSPr3VYIT/oakeX1nIw2kVgtFRUkVY3ndiq8m6KXfht0AXosa+5rNCmM8EJCbqasZT9Oj5MHp9CQbsaD4x02D8hbJ/Sr7BQLSbCF5b3r+bdqxK84DNAhyFo7Nu4zRiw+9AYhS7SRJIPfIlD4WPVT2UjJjWg5VgGzyJXkRDmKJWw+Jf5z3+fQ/RpB/EcM6EZDmbmDfSGJylDwELlnmLoYej05HZVGUuUhd/jyyMX3BPz5MrfB2IDGGLZNEWRl9kw2PhZ/kasfA+RVcp0u7yqBJMTXJM1Qfji6sSPag0cLGQrbQXdXqx8FVYb5DHEjpD4GWI3T39bYicTU5EPZOgwuvD+0YR+XYcmCLmPr11PPLK9ocrVvU/iszPA022NSI/YVFtA0EwDlfPnL02hG+xLhCixeen02VD3nVBnowSBf/jQwRIbmqyvU1qC95+qus3tPUaSdwJBq6V4TDQ7XzoCxXApEjA14oXdFZ8liNBma5op9GepoWOP9v+5T2GTm3X8Z0pssmU16M+BO11M=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199015)(46966006)(40470700004)(36840700001)(83380400001)(186003)(426003)(1076003)(336012)(16526019)(47076005)(2616005)(82740400003)(81166007)(36860700001)(356005)(2906002)(5660300002)(40460700003)(8936002)(110136005)(41300700001)(86362001)(40480700001)(70206006)(7696005)(316002)(26005)(478600001)(8676002)(4326008)(70586007)(54906003)(82310400005)(6666004)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 13:56:33.1047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e872ddbe-0727-42a7-a795-08daa7a293c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000C403.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7622
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current XGBE code assumes that offset 3 and 6 of EEPROM SFP DAC
(passive) cables are NULL. It also assumes the offset 12 is in the
range 0x64 to 0x68. However, some of the cables (the 5 meter and 7 meter
molex passive cables have non-zero data at offset 3 and 6, also a value
0x78 at offset 12. So, fix the sfp compliance codes check to ignore
those offsets. Also extend the macro XGBE_SFP_BASE_BR_10GBE range to 0x78.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 23fbd89a29df..0387e691be68 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -238,7 +238,7 @@ enum xgbe_sfp_speed {
 #define XGBE_SFP_BASE_BR_1GBE_MIN		0x0a
 #define XGBE_SFP_BASE_BR_1GBE_MAX		0x0d
 #define XGBE_SFP_BASE_BR_10GBE_MIN		0x64
-#define XGBE_SFP_BASE_BR_10GBE_MAX		0x68
+#define XGBE_SFP_BASE_BR_10GBE_MAX		0x78
 
 #define XGBE_SFP_BASE_CU_CABLE_LEN		18
 
@@ -1151,7 +1151,10 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 	}
 
 	/* Determine the type of SFP */
-	if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
+	if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
+	    xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
+		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
+	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
 	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_LR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_LR;
@@ -1167,9 +1170,6 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_CX;
 	else if (sfp_base[XGBE_SFP_BASE_1GBE_CC] & XGBE_SFP_BASE_1GBE_CC_T)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_T;
-	else if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE) &&
-		 xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
-		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
 
 	switch (phy_data->sfp_base) {
 	case XGBE_SFP_BASE_1000_T:
-- 
2.25.1

