Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E478647430
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiLHQZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiLHQZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:25:50 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2064.outbound.protection.outlook.com [40.107.100.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAD66A76C;
        Thu,  8 Dec 2022 08:25:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCw7f8qGmrnB7saR6Q0O2pLHbJY2FSMtbEdOwxuQ/l9Kq84jYvIoqLaulIG8XZDKwCl1LzBINvHgHnbh8At1VetfThKl1+BzHsxEMMVvfT0OFjTQ4FAI7oA3ZfXLiTMFchA8ZOQPJtBMSdIpiYjHSPgvrA8hApt7LbjRIF7XQDJfIAxbIY927HMaXMvcww+02mbop66kBw5+CrLyX0mNeYfz1ynbnleQqHvVXZom5Fe/f554+xTqFjVDK8b3qvGieoYVDxLK00lrFG+8SMrf1XB6FqN1JKSSIJt1/ub2+8oRzia57tv95UDvGg1A2tC9SqYtmsFzQNPgt2LVDx6efg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbVzym4Jv78LRek8QcLM5pbOxGAzKmP7hVg17ZiAMZQ=;
 b=N6Bm2MZQzvFsUwQlg6Uey8EcR2hGbbMtl54UgRkUqFgmNNeeeHyL9u3Y63i2AiMiC8V5HPKITKYU4/TLaLuQcc2Jt/lRasdeIFeFCbHdSRMgzvPXFGKa8pgLLmUHnUod9w9hToHQqMzxT3QgRwynSw0RNGqWRdoxA54/bnXwoANdXLmL4TyQpauedOWj3LmO8ti3iaJ7Tp5NVzR6h35O94akIZeDhAbXj00Coj4ezfAe4mDK//k62XHoYy4GRjpcNMADCFP/J67nDUW6pJvwdxFogPjx4rboBga0RNgcYdjuVRuVoUt5H9+xtNGRMeTPEWE3fTTt64taIfVjKJFBkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbVzym4Jv78LRek8QcLM5pbOxGAzKmP7hVg17ZiAMZQ=;
 b=lBvhTxEUvH/J04ZRYI9D4WeUNw4h2TCu6TCHUtzzbw2+TsrqazN2hOqM0hew7fIYEaf0rGNxHatVy7dEtW64+Z76hyhBF0snxIIRf6t8b0Fm+kBKGKEHmalCOhv2L3tCYBL9DjWrEcXSoBu9PKMIT2YsP6oGyl9fGQOwhH3lPhU=
Received: from BN0PR03CA0013.namprd03.prod.outlook.com (2603:10b6:408:e6::18)
 by CH0PR12MB5283.namprd12.prod.outlook.com (2603:10b6:610:d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 16:25:47 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::9a) by BN0PR03CA0013.outlook.office365.com
 (2603:10b6:408:e6::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16 via Frontend
 Transport; Thu, 8 Dec 2022 16:25:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.17 via Frontend Transport; Thu, 8 Dec 2022 16:25:47 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Dec
 2022 10:23:23 -0600
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH net 2/2] net: amd-xgbe: Check only the minimum speed for active/passive cables
Date:   Thu, 8 Dec 2022 10:22:25 -0600
Message-ID: <852265b14d35ee1e508b71d814f7532d12d5cf14.1670516545.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT011:EE_|CH0PR12MB5283:EE_
X-MS-Office365-Filtering-Correlation-Id: 071a3503-8764-4bf2-b69b-08dad938dcc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gm9UI1VXUmMCUWJvKQy4Jwx2BCDoTYw6sBx5TeFhJidzDuI4P3TpvVqDZZa8/Ona8fc6LfXyNrJ/oyrIdohzWxvJD7Blhraz6aiCIgFZQmc5yiD1tmX3kWRFu3LS1Vm3OS+W4Tcc1WxFyx8QsDHJDchhi9ATSuD+9XjL9j+yspXUxbnsHLMTBBZ8D0ooXrOIre30cXM1+ZwleCgL9J9egv8P5V2PQ0rRFPirKnMfsErRspqZtHY25galE7y+Ds4+R0i+eWVy/FdP2Nn109+OIclnZlTDaz9BFt3Yvqtm+6F0mWIya0spVKFFqbCNWxN+q04f6DpmfzStWPMK3j+qq7LqJqt9NYrvBIqFDPAberNWJoa3Hgox3XJKY/ZGC2/moisB21uU/0p/3u1ZNSVaAZYkYU16UZ8TCuvd3BNUTlFm5aNBTqezzapVmPqtBIRVmPohNBT/k3xfWyQqADX7eKSd88THflgdW2TG9gzaDMZWNaP6+ia0YF+LonPnD2rNYqtwTzLnK0pslYPP+yNtpghsgsn7YbRO4NtUB9+T7Jtgq1MGgbTRNqpw0r1uByyrSeoltZYuomQzZ0WC2XJTFXFJPrKWC3OSqMAVVKtbch/PrpjTWuIMTxiBJv14bHU4cOGA/7gVVUg+dLrhRGqdO7ByKU9V0UgalgF+scfP4BwltOa5lSIU5s4NUuQiQUOdvH37hEeeLr/R3RpYdCJ4Ub44muSVEFJXHUXRHJq9x64=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199015)(36840700001)(40470700004)(46966006)(7696005)(478600001)(82310400005)(41300700001)(5660300002)(36756003)(8936002)(316002)(110136005)(54906003)(70206006)(70586007)(8676002)(86362001)(4326008)(36860700001)(356005)(40480700001)(81166007)(40460700003)(82740400003)(2616005)(336012)(186003)(16526019)(26005)(83380400001)(426003)(47076005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 16:25:47.1218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 071a3503-8764-4bf2-b69b-08dad938dcc5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5283
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are cables that exist that can support speeds in excess of 10GbE.
The driver, however, restricts the EEPROM advertised nominal bitrate to
a specific range, which can prevent usage of cables that can support,
for example, up to 25GbE.

Rather than checking that an active or passive cable supports a specific
range, only check for a minimum supported speed.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 868a768f424c..c731a04731f8 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -237,10 +237,7 @@ enum xgbe_sfp_speed {
 
 #define XGBE_SFP_BASE_BR			12
 #define XGBE_SFP_BASE_BR_1GBE_MIN		0x0a
-#define XGBE_SFP_BASE_BR_1GBE_MAX		0x0d
 #define XGBE_SFP_BASE_BR_10GBE_MIN		0x64
-#define XGBE_SFP_BASE_BR_10GBE_MAX		0x68
-#define XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX	0x78
 
 #define XGBE_SFP_BASE_CU_CABLE_LEN		18
 
@@ -827,29 +824,22 @@ static void xgbe_phy_sfp_phy_settings(struct xgbe_prv_data *pdata)
 static bool xgbe_phy_sfp_bit_rate(struct xgbe_sfp_eeprom *sfp_eeprom,
 				  enum xgbe_sfp_speed sfp_speed)
 {
-	u8 *sfp_base, min, max;
+	u8 *sfp_base, min;
 
 	sfp_base = sfp_eeprom->base;
 
 	switch (sfp_speed) {
 	case XGBE_SFP_SPEED_1000:
 		min = XGBE_SFP_BASE_BR_1GBE_MIN;
-		max = XGBE_SFP_BASE_BR_1GBE_MAX;
 		break;
 	case XGBE_SFP_SPEED_10000:
 		min = XGBE_SFP_BASE_BR_10GBE_MIN;
-		if (memcmp(&sfp_eeprom->base[XGBE_SFP_BASE_VENDOR_NAME],
-			   XGBE_MOLEX_VENDOR, XGBE_SFP_BASE_VENDOR_NAME_LEN) == 0)
-			max = XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX;
-		else
-			max = XGBE_SFP_BASE_BR_10GBE_MAX;
 		break;
 	default:
 		return false;
 	}
 
-	return ((sfp_base[XGBE_SFP_BASE_BR] >= min) &&
-		(sfp_base[XGBE_SFP_BASE_BR] <= max));
+	return sfp_base[XGBE_SFP_BASE_BR] >= min;
 }
 
 static void xgbe_phy_free_phy_device(struct xgbe_prv_data *pdata)
-- 
2.38.1

