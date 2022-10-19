Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D89A604F8D
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJSSWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiJSSWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:22:21 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30311C73CC
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:22:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eCrtd0GXN98w/ASNIWreTsSC57r2C+EVTRbs47C0LvFXbtoHHdOiPbjKmpRtxhQYBeNmebs2xaS6R9Z8mi1L5iBDY0oxFTWvwLaVZnECWfk7X35ot9cuueghsVU8DYQFQPNFPO0ZyK1T4qp1yMXxH0UgJUnFHE+PQtqOR2GNBwqujvybKAfurHOfuzQZ1THg2k8eM0ZDtIOkxCKNVFExFC0DQpgtpvO5N2aUBt+lRTIQWG7MUPSagR6tuH0AIs+KdK9QKstTAFKMvs8qoGkBokSLUJe5ABymlBd4FLX7RNZ5ADhMCeb+QONPFasU8nVZYRUTZCRP7ZjFsH3RaP7xDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Fbh0Wp0xZU/4cIvHMaLUssSL7Zb/hyNx82Kl4jwkTU=;
 b=kov5qCSkJn92vwdCSptn75WpNuJIRbRseEp3OFdkGvStaxCuUbfsDBpHsd/pAv/lNVbzVXqHRi6JCNniSAlwiJndSJYX3V2xd97Wr6U6CoMhHbCOauqb5hWS+rrZK+qBBs/FstHZdUcW6gzBmzV1SNMDMtSqzFA2ZKk+yKk4dP1lCP7lstEnP9jpdP5ImcG3l5vNUdf/QsRlK5B08jc6q7tcdSgfDmxI82SuHpoox1ydo0sPcDOPb5dqSvbBMjHmtWW27TgyV+B49eIEDUF7bdfC4JUCclqLC+W2br7Wh7LFoNhzWBZDa0kNsXbAsGVEi6nwyY3X7pi9L97DT8U65w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Fbh0Wp0xZU/4cIvHMaLUssSL7Zb/hyNx82Kl4jwkTU=;
 b=b9AC6LaNz9i9DS5kUhGUKoN/fPl+H3VMEzxY+AenfjVk8ub+1WJ9Ss3cF+kaLibCsoG562CXsKts3TZRqMXaGd9ecy+GIm6B2pA1IzdQ7bkqexqUvHG1g8MGOv7u8puEXM5cLAyn5rZSe35aUVcsyjSC7K/V0xUGw0vqF2q8yEM=
Received: from MW4PR03CA0079.namprd03.prod.outlook.com (2603:10b6:303:b6::24)
 by BL0PR12MB4930.namprd12.prod.outlook.com (2603:10b6:208:1c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Wed, 19 Oct
 2022 18:22:17 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::52) by MW4PR03CA0079.outlook.office365.com
 (2603:10b6:303:b6::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32 via Frontend
 Transport; Wed, 19 Oct 2022 18:22:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT082.mail.protection.outlook.com (10.13.175.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Wed, 19 Oct 2022 18:22:16 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 19 Oct
 2022 13:21:46 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>
CC:     <netdev@vger.kernel.org>, <rajesh1.kumar@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH v2 net 4/5] amd-xgbe: fix the SFP compliance codes check for DAC cables
Date:   Wed, 19 Oct 2022 23:50:20 +0530
Message-ID: <20221019182021.2334783-5-Raju.Rangoju@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT082:EE_|BL0PR12MB4930:EE_
X-MS-Office365-Filtering-Correlation-Id: f52cccf5-41f7-4261-692b-08dab1feda6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kWuXyiEGf863jvtQloMMO2sOL+koir/k80Ldn73bmwL4UldNdoV8030CLgwLPILCFLso43yNMbky7oR7kTunkiB65zsVLd4ldg6yNA/+64HSN0/+65xD9yNsWSV//nGFJGYRRd3nfqVzpZgNHHYA3hX9SbQU7CM4ns9Kgt30iijMnLLYRGhANZfZgoiHRP0HD4RGx/QSqUmkfeke2eHnpWPya8t9P4CFGQ1FwfXQPJpM/+y/eHIboNLR+LCUddKqYvdCgwT9zfHckmb+DPhsapE8P3ENJO926MtgutEkCni5dgQjhyq4Xbcci7WKkuoKr8XPZNek/gDYecSbgm18Phf2g8kNfqCBYuicsf5Q8q7OSB8YlBtSR0VqJNzEl3NaXqk9zIgypKYi7DE/QNduSZpXOM/TqVyynvOPsY59FfYqcAF7kpX8w5RgMEZwB8b42aP/yEeF4LbidN4O9U5BWBp8v0deKvtZq0+nj3sfmeDZPeXU1PncGwQW4lYmdBMIC/J0yrNhBpdMfsyet4PsttXvZ4Vcq0P9u+vq56lEJn9bqKCR4zP16bA63t+F1efYn+4makxf1neEDJwi0wL4gAu8jGTSQuqeEuqlRTmC3GqFRvlRVXwl2TkaT1Mm8ds8YnzsPYq6KG9JI60KqWyHj1b5aCjRqprpATgaIeuWes8QcKooYhd55K6gH8taTKC890zA0xX3VKwhFXD5KQbiv1ETdiPlP+6Iks7F55+9QRVDSrzxyVPUt0Jl2F1Q91h9cVR4FsHWwGLU65bgsXi/cAZIudi5uxlNBpC1is/+kUE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199015)(46966006)(40470700004)(36840700001)(6636002)(110136005)(4326008)(70586007)(8676002)(54906003)(70206006)(6666004)(36860700001)(316002)(2616005)(16526019)(186003)(1076003)(5660300002)(40480700001)(86362001)(83380400001)(47076005)(2906002)(336012)(426003)(40460700003)(7696005)(26005)(41300700001)(36756003)(8936002)(81166007)(478600001)(356005)(82740400003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 18:22:16.9040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f52cccf5-41f7-4261-692b-08dab1feda6d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4930
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current XGBE code assumes that offset 6 of EEPROM SFP DAC (passive)
cables is NULL. However, some cables (the 5 meter and 7 meter Molex
passive cables) have non-zero data at offset 6. Fix the logic by moving
the passive cable check above the active so as not to be improperly
identified as an active cable. This will fix the issue for any passive
cable that advertises 1000Base-CX in offset 6.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
Changes since v1:
 - Split the changes into two patches. The next patch contains the
   Vendor specific quirk.
 - Add a vendor check for Molex cables before assigning bit rate ceiling

 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index b9c65322248a..bd67a2a71048 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
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

