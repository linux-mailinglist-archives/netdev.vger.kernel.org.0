Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDFB605781
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 08:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiJTGn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 02:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiJTGnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 02:43:25 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01701C1150
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 23:43:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wmp9N5IF2nNvXr//LYZeEqiETzbVmzJU8mS6zpSwKMGOWZR97J0YL82khpleSyv0OFOT0XmweC8PE19TSpgn5l4QqKustRmE3dazyYz1JxQKxqZTBsat1nPDacR0DBrQqijPerSw1I6dkoJhp4XR+9t4xbrroop4OmE9Jj+bDJXpL4ThzkKDLqQWU/qIholBSRKXNtKnC7uKiNgoD6PZJCotyf3i/66GebRJbfl9luRSkYRIR3tGP2EOb2TvRhzxkgICocQe6LQAGOGOJx7+lVkYJd0KM5lk2RSP2ykbg957FcoQzlfKt4wLy2Yy/ITEI1+GBnqC23TF9dZnNiN7iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PnHJWPY7xGTNDCVhycsisRu28m3U7UJHQPj29QN5+9E=;
 b=OO6LHlDVqf2NTmAcl8o0fqzdD02h2Wwa4sodljy4kIs9R4Xd/oxR5PKa2bL0ELWn/IhQ6cViw90OOLmPfAeVGYX1aw8BOOvNDZcLWZrAKfxV4NSD7EEnCp4Ip/sm5Hg/R2a6RX1YGMeWfzH6SnZAa0VPCATyXRxI1W2Ezc4h6Xg7YrzMCO+1scV00lNMLlWH81WrJcRrgObbYYz3TFx6R+igeOv6Tk8NAcxIt6x/FUN+7lODohDQoEoE6TpNQkMRHRdJOlePgpa/pppv+6PMgLqH2acdvsiD1PfZf9WwL+Jwop3KKbE1Gk9WT+pSyKT/nhhJ/hIhUfkeGIrTHXtxEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnHJWPY7xGTNDCVhycsisRu28m3U7UJHQPj29QN5+9E=;
 b=bEOsXWEUlk2L7qSLUH+w6Fuj1+PguV25o6YriMgfOn0aMqtR543Vm0F4z/Wny/g3YZCwfayp5eJ8gNFdZ3gDdO59RwM3pwDLuHj4TpoBMOtAn8m76LkSVWc5lxUqXhK6Dx6DWihwMJWlbVQ/6UpR49YA0d7VSyViCEEAQOM0dG8=
Received: from DS7PR03CA0061.namprd03.prod.outlook.com (2603:10b6:5:3bb::6) by
 CH2PR12MB4117.namprd12.prod.outlook.com (2603:10b6:610:ae::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.34; Thu, 20 Oct 2022 06:43:21 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3bb:cafe::b8) by DS7PR03CA0061.outlook.office365.com
 (2603:10b6:5:3bb::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34 via Frontend
 Transport; Thu, 20 Oct 2022 06:43:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 06:43:21 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 20 Oct
 2022 01:43:18 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Rajesh1.Kumar@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH v3 net 5/5] amd-xgbe: add the bit rate quirk for Molex cables
Date:   Thu, 20 Oct 2022 12:12:15 +0530
Message-ID: <20221020064215.2341278-6-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
References: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT035:EE_|CH2PR12MB4117:EE_
X-MS-Office365-Filtering-Correlation-Id: be4b5364-6292-4fac-0d41-08dab2666121
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ri2LY8/REc6ZerVCNoz1WXFuTYA/CcrLqzWXcgvnx49LXX9rnjJkx+i76T6SL47rYKIQ3W+Nu9ukWsLv0i6M/nYUfzys1WhNbBJgu/a7zQr5sTtC9W2ol8ONYOn2H75IMGcgBw/Zli8RRb0yASf8GopO40h19X/ZKmxDtXzx31qHAP0V5OMB/q7xS5Hg9fos33YLIHxSsDTmPWi7ZEHU469kgU+UQ9d2ksDXejgtyA5pdI2M3TQIHNZ4T233o5Pr8Lj3DcewR5suTAMZuBgBChHPcni2aQCi3KnXbNA1Nz/7U67YcIwd2RSwNI0oeWjjfDz/78+3yEXpLcuHvZk7hM1bzIOMclTitaQHhkG04+XMR3nO03KNdLBCctC3tc2ylhvMy6JuoWMDRthlFv9ElYGmPO6ZpDLtrsm3uBB+PAB2rSn7F09Cms7TYGc+PiKJdTU5u0Wswk28Ww+KSVD2H2hjzfXGPvTH1qxEHd6CE5rj2K7fsM2bcVJYzo9yLG/JPRy1I4cxaUEiVokB5vEjoanucTlXYC3NJQF1IfVp4sR27VlVrRWdnx3fO4i8lrL/1+NjBqH5SdDLtOyZfl2thtBMbYoO/4ZH2X4XcYPtwUnqjZz7ht2vdXXQYGaax7EqpIPjmWRQ2Nu6BkHOF/y4NcudBB37MrHsOKdYM4xWu+pWiWTn/S2+nCB3BxXijBUgVg3SWeTMnIcmkGkxHfY7DPF/KBGT29yKhiWEc2DOgmuJrk9ya1AYfz4fVxMyid0ngepHk1w/Jcbjf7PUX9fv7ojzsSIm69673X+JJCGEKg8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199015)(46966006)(40470700004)(36840700001)(478600001)(83380400001)(86362001)(36756003)(5660300002)(70586007)(70206006)(6666004)(8676002)(7696005)(26005)(316002)(41300700001)(8936002)(110136005)(4326008)(54906003)(2616005)(186003)(82310400005)(47076005)(426003)(40460700003)(2906002)(40480700001)(1076003)(16526019)(336012)(356005)(82740400003)(36860700001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 06:43:21.1529
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be4b5364-6292-4fac-0d41-08dab2666121
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4117
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The offset 12 (bit-rate) of EEPROM SFP DAC (passive) cables is expected
to be in the range 0x64 to 0x68. However, the 5 meter and 7 meter Molex
passive cables have the rate ceiling 0x78 at offset 12.

Add a quirk for Molex passive cables to extend the rate ceiling to 0x78.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 8c41ac5676d6..4064c3e3dd49 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -239,6 +239,7 @@ enum xgbe_sfp_speed {
 #define XGBE_SFP_BASE_BR_1GBE_MAX		0x0d
 #define XGBE_SFP_BASE_BR_10GBE_MIN		0x64
 #define XGBE_SFP_BASE_BR_10GBE_MAX		0x68
+#define XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX	0x78
 
 #define XGBE_SFP_BASE_CU_CABLE_LEN		18
 
@@ -284,6 +285,8 @@ struct xgbe_sfp_eeprom {
 #define XGBE_BEL_FUSE_VENDOR	"BEL-FUSE        "
 #define XGBE_BEL_FUSE_PARTNO	"1GBT-SFP06      "
 
+#define XGBE_MOLEX_VENDOR	"Molex Inc.      "
+
 struct xgbe_sfp_ascii {
 	union {
 		char vendor[XGBE_SFP_BASE_VENDOR_NAME_LEN + 1];
@@ -834,7 +837,11 @@ static bool xgbe_phy_sfp_bit_rate(struct xgbe_sfp_eeprom *sfp_eeprom,
 		break;
 	case XGBE_SFP_SPEED_10000:
 		min = XGBE_SFP_BASE_BR_10GBE_MIN;
-		max = XGBE_SFP_BASE_BR_10GBE_MAX;
+		if (memcmp(&sfp_eeprom->base[XGBE_SFP_BASE_VENDOR_NAME],
+			   XGBE_MOLEX_VENDOR, XGBE_SFP_BASE_VENDOR_NAME_LEN) == 0)
+			max = XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX;
+		else
+			max = XGBE_SFP_BASE_BR_10GBE_MAX;
 		break;
 	default:
 		return false;
-- 
2.25.1

