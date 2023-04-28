Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DDC6F16D3
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 13:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjD1LeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 07:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjD1LeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 07:34:12 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9422D5B
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 04:34:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMlvxvKISmHnTbYwxtUb9afn7rj1dJAHyWXlnEwSRrxjuadoHxAc+PbncSMVnJFXPzCDqg9xeJZk2ff4VZ7AdqsLadm+c21uzhJ44wrpbIRbjg43/mkB4qZBem4Zfsn7aUQi/HG/rhfevyUcmHTW9wQt9HvsMmJQ+ZUglZMKrDeLOXxyTrB3VWHG/dbwZvguopPZ0/K9L0ICMAEE3rdDodR1vdLgHWvi+VkkMHW6XtVDwhHJ1SXWoi3TOWynfG4ry91/6PTfy08JVvBcZA+cVWxZXyNHDdG++iQtLLFKM23oRMywhlkbpAEOL6gfJw+9xNVqW056N+JvdE3Y+d0uJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZJoc2AycYc7h9mAX6NAQZ4Hcu1uCj6iT2WmFMEVCgo=;
 b=lqqW57UvdKJHNF6aC3gtqzlNZD1zk1lEuGM4sawFVImNbGqaab8QEjd8xNh4sVhL9wq3EsFFElQtcjdv68JsjEF2YYmkcOogc3fRveVIHzI7bDLYrAW+mt5oezVbvnEUiGhOsa52CZiSfoeOf6kVqfYFcalTMrU4Nzm/mFaiyGHmLI3IGlXnD+JR28bwb/GoY7XA3h9CXUgtfP7TNCuI5mExwdWZ0mGpZ7rqE3hytIg+wUpRMj6qikypR/2a8xTG7FVzo781PUBYTBeg1TEo34h0a3EWnMpr/eeXMGkYlIwakBARKbSBaNMjVvSUB5YEZI9FYE5ZhCdtscSQY4IHzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZJoc2AycYc7h9mAX6NAQZ4Hcu1uCj6iT2WmFMEVCgo=;
 b=01gfwiVRdueNChKg4Wa1T6Zw5jHe0DGrBoiHygYj7SqSZ+8RpjWFPc3uP2MnZiOn6DYxg2q24QqQrC62WFKT4aAySp499Xcz1lLTvP+y4kx+PL0B9Vh2lRIds7NKhBM3AU6Yam544LQrLjcz+yDmR+Gx6mJz5mJV//wY7IvbZsY=
Received: from MW4PR03CA0349.namprd03.prod.outlook.com (2603:10b6:303:dc::24)
 by MW4PR12MB7167.namprd12.prod.outlook.com (2603:10b6:303:225::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 11:34:09 +0000
Received: from CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::46) by MW4PR03CA0349.outlook.office365.com
 (2603:10b6:303:dc::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23 via Frontend
 Transport; Fri, 28 Apr 2023 11:34:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT110.mail.protection.outlook.com (10.13.175.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.25 via Frontend Transport; Fri, 28 Apr 2023 11:34:08 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 28 Apr
 2023 06:34:06 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 28 Apr
 2023 06:33:39 -0500
Received: from xcbamoreton41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Fri, 28 Apr 2023 06:33:39 -0500
From:   Andy Moreton <andy.moreton@amd.com>
To:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH net] sfc: Fix module EEPROM reporting for QSFP modules
Date:   Fri, 28 Apr 2023 12:33:33 +0100
Message-ID: <168268161289.12077.6557674540677231817.stgit@xcbamoreton41x.xlnx.xilinx.com>
X-Mailer: git-send-email 2.27.0
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT110:EE_|MW4PR12MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: c42280ff-c0c4-4776-3be3-08db47dc7b3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gx1UAuYi9N74ahzSArhlDYrnspAIfEKN7YuHTK5z70vW4r5SVAlfuIt1Sat/NhDUtyZ7+mzmVGsRIIpF0ifXkHIOfGq8u3Ghis4VcSXOTyq0ZVMM87JzGyeiSfjm8B5er/7s7Kzb208QrwornmlQBVL/ETWi4d5/Q12mTmXV7/LzzwsIcWaaIQGvHt+sIz3H9xK/PhvtgSyyLADgGBy4263Ykl8FdFfpjySN/oCKFbvGDxZTmqWK8KZk/zMc8NFQgTiOJ2Rg2A6oSEeA9J2j5Xqn90o2iSxUY+FQD5cfxB1Wfyp9gJezzcZnfxVRlzxnK0WaexGcrs3o912UAcICFBttPG6sKaF3ZxCwrm0KNHnrZ+oz+gnITjLGh0izr2q2NS8A/7lD2WETm1QhRTHmjF7qdGr/wFfIFqA+sXXBDxDg3Neqb1mYLZuXa5yS6+STLrGxeMU0de8f6EWGke+SNqbOTBYg47lkTeU7/Y+JCGOlRFts6lsXkW+uAvruHs6JJ/ydjTy977Y6HR4BRb8BGvblGWxXP1zznuTwyohbKuyB4CB65FKskxIitWJdEbq+f8A1lkqx/6JWKFTfefs9/ltz+FjTIAzFrZNvUudfDnxaCwQAY+SipXraf9vTZtcJ5c5BJFN86jH8jX+voxV3cxjtZpKemzz9blNXg3ePt1+7AFZRO8jg0Ei/M36BJRO7XWs0JLWqamdsGRGTo5py/hgJLkyhKJMbB2m5ZzdHOvM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199021)(40470700004)(46966006)(36840700001)(103116003)(83380400001)(82310400005)(336012)(426003)(36860700001)(86362001)(9686003)(26005)(6666004)(47076005)(478600001)(54906003)(316002)(70586007)(70206006)(4326008)(110136005)(8676002)(81166007)(356005)(41300700001)(8936002)(82740400003)(186003)(2906002)(40460700003)(5660300002)(44832011)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 11:34:08.7457
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c42280ff-c0c4-4776-3be3-08db47dc7b3f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7167
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sfc driver does not report QSFP module EEPROM contents correctly
as only the first page is fetched from hardware.

Commit 0e1a2a3e6e7d ("ethtool: Add SFF-8436 and SFF-8636 max EEPROM
length definitions") added ETH_MODULE_SFF_8436_MAX_LEN for the overall
size of the EEPROM info, so use that to report the full EEPROM contents.

Fixes: 9b17010da57a ("sfc: Add ethtool -m support for QSFP modules")
Signed-off-by: Andy Moreton <andy.moreton@amd.com>
---
 drivers/net/ethernet/sfc/mcdi_port_common.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 899cc1671004..0ab14f3d01d4 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -972,12 +972,15 @@ static u32 efx_mcdi_phy_module_type(struct efx_nic *efx)
 
 	/* A QSFP+ NIC may actually have an SFP+ module attached.
 	 * The ID is page 0, byte 0.
+	 * QSFP28 is of type SFF_8636, however, this is treated
+	 * the same by ethtool, so we can also treat them the same.
 	 */
 	switch (efx_mcdi_phy_get_module_eeprom_byte(efx, 0, 0)) {
-	case 0x3:
+	case 0x3: /* SFP */
 		return MC_CMD_MEDIA_SFP_PLUS;
-	case 0xc:
-	case 0xd:
+	case 0xc: /* QSFP */
+	case 0xd: /* QSFP+ */
+	case 0x11: /* QSFP28 */
 		return MC_CMD_MEDIA_QSFP_PLUS;
 	default:
 		return 0;
@@ -1075,7 +1078,7 @@ int efx_mcdi_phy_get_module_info(struct efx_nic *efx, struct ethtool_modinfo *mo
 
 	case MC_CMD_MEDIA_QSFP_PLUS:
 		modinfo->type = ETH_MODULE_SFF_8436;
-		modinfo->eeprom_len = ETH_MODULE_SFF_8436_LEN;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8436_MAX_LEN;
 		break;
 
 	default:

