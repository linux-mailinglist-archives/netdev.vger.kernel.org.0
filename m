Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F43604F8C
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiJSSWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiJSSWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:22:21 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BADA1C906B
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:22:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBdDNbYpFPI1y7cr2wO8hqL7AE5prnq3fgqcnd2CMaar5frE5u0Ra6O49xKDQkCFQHnhOUjDbFYGN3LxMwXEwf26Pzlq4HIetggIKOz9Z+lMpknnrLPjybiB4ePh0JQfH6xo9f85QF4m7qA7iwiVRUddVyQhEhoDx5H3OSaMIymUt2onAawT9hXwPZoUVgCNq4ahLjPM/F1JQaInhu8vm+JCHQUu3kqSkJlqToJsvoWna7mk/x0OBDa4nEsj4FOVanGUlqLHMaYN+B8NaQMtqePUUwfXAErmNdmFHIUar/lhMmjoS05Lgc0H601VW9LO/Jznn5aIaYgTTD+TjpUU2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bCkdroYUqIReXGY5YisInW6w9r3cj/e916G8RE0+J04=;
 b=jV/sRZx1alygj0KMryu8lM+1PdtmNU+zo+LagHnLDiKbJ7nuJhL+5lWeE+iBsMPiYKhnlE8JFLokzkAk192EByTr7IojeuoYZsra/lAsgrIrnBRUw7KLFNHHlyytjpC+B6F4YtBephVPs5Z/IpfXUwDSp0H+vMahNhHX9JlGv3KLcjg1ygBE1M9YRjf8f7ctLxL9IzCUYGSAUQBk2aDbMyjbecoiNqRfPp72BK+d1EbJLXsx9H6JSuqG4IOj3ZppMUP0DQhLyOXarkNEIaLauLou+kgNQv1qyXFnRIECO84SRcW4C+1V3wXuAuqKEgIo8hGH0SMUMy9HvnClXkUyzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCkdroYUqIReXGY5YisInW6w9r3cj/e916G8RE0+J04=;
 b=bXlusTIyFSrcG/pXYefYfTo1ehpE8c54HC9oV1eGv7sEjG8MaAkOtWuENW8/he4wvHaip6mmlc+LMU58CVxVRDWaJT2QzAPpIGk/V5bOn98j/MOxZ+uqiYrdd55LK5VfEkQCXqMi8MAzBs2zwwMgqGa/XNzLyNYtqWbGUFrtYOM=
Received: from MW4PR03CA0067.namprd03.prod.outlook.com (2603:10b6:303:b6::12)
 by IA0PR12MB7532.namprd12.prod.outlook.com (2603:10b6:208:43e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Wed, 19 Oct
 2022 18:22:18 +0000
Received: from CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::e8) by MW4PR03CA0067.outlook.office365.com
 (2603:10b6:303:b6::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34 via Frontend
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
 15.20.5746.16 via Frontend Transport; Wed, 19 Oct 2022 18:22:17 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 19 Oct
 2022 13:22:13 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>
CC:     <netdev@vger.kernel.org>, <rajesh1.kumar@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH v2 net 5/5] amd-xgbe: add the bit rate quirk for Molex cables
Date:   Wed, 19 Oct 2022 23:50:21 +0530
Message-ID: <20221019182021.2334783-6-Raju.Rangoju@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT082:EE_|IA0PR12MB7532:EE_
X-MS-Office365-Filtering-Correlation-Id: cb99ced6-7490-4fae-ece2-08dab1fedad3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KMp2aZqTcMDmcXz36M4+W7mC72oFU4sfai1sKGHSLY63xi0nOmSYJn/FuFPHqOW2iSyYDHf71OaKIA38k4ZjXHaanAVy+aJOvWwNesqQj1/QTEL7e2EByHaRGVznuRfk+5NA5xhb813L13v4Gn6l9ubeP0GhlN52YlcqSE7FhbWzREJ0QXgNw9x3vcY3KT3XgTOzsaRzYaoxYJ0n0wRNHGmO4O4irrDRiewyoF7GrVttWhX/+H21v2Sq6w5vPYQr4qyeEtf0/olcs4VkP0TyB23ht3/qmhxl/VgryLcAcVUUd/mreFvH/2w9HYNjsa2Hu5g1Szgncc7HBTjzhACzdfkpYkzXlLWp2eGx4+L18CgidZx6dxS5r5Tm2YoGjNDD3VKRJTuhVsjw3qTy+4JeCFlAT/ys0P2dSbQpZ9t4WxEJx55sv3aQji4xwUax0L9RhQw/EMHazHBM/GkHqrLQ4J+ynrxvBPaGz51lS9TPu1mVB/EWM8YHXcTnMjlIySEgfmJRLkfY7E3eDmcRRvzLa28HRcof7JhL+ZJmhV0Ns5pngqSvrtc0ZzqF8OibpAq3tbcC6R8pp7hEMVcqQS+7YyVHiwDGuDcWmW5nMIVM+jXD/swv7bGqNEIeMQ2KTjvbqBtGj0qUp32ImIW+bEegynN8W/QcqGueSK0t3+P+b+3tNYPmpbewuWrRFfMXGFEXSXGbM4M8senlw5lqzBWF1p2wnWG+XIs7nTZP270mQpsB52NTSOpxEH06K6BMaOGNOGo1OtWUd2x7kWDNXXeXoPyHtCDaIfS+AxeMJlW81Fo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199015)(40470700004)(46966006)(36840700001)(16526019)(186003)(1076003)(2616005)(336012)(83380400001)(2906002)(40460700003)(26005)(36860700001)(8676002)(7696005)(41300700001)(4326008)(82740400003)(426003)(47076005)(86362001)(40480700001)(81166007)(356005)(82310400005)(36756003)(54906003)(6636002)(8936002)(5660300002)(316002)(70586007)(110136005)(6666004)(478600001)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 18:22:17.5759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb99ced6-7490-4fae-ece2-08dab1fedad3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7532
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
index bd67a2a71048..70cad8b36fc7 100644
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

