Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68C1632EED
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbiKUVho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiKUVhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:37:43 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739A643AC2
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 13:37:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTq8BAkCwjQftv1SNNJv5k0zTjPUqneab1YlScyNDv2nngr+mW6eyaMaR8ydF1MB0ErxMDnnphoz4mJDvhNf+lZLPh0D/oZiFMMeQxj7dhNjg9ryXH86SPC2LQ7QKWjciE1wvTWjrTQTlHcIHJgixBPGlbgv6sd7ICIh1E97X/UXFEMf/8XaH4+owsvejxBJGckyg/rdXS+O2ZsMUnaxPcTyBbs6YGB4ttl22lJKsb4SXRtz4e7zoC9E7R40fyhkjJC+6BDxNFX49vBXRzP+URruURv53yeoXWNYPPvltwlzrJYUS5H7DwCzJEUpA4qplR2uM18zUnMlBpb0NsznGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=goO05cRMQ3Tyy40BUm/VMLLHCbzNnaDef3ZReC+/5Lw=;
 b=Zw5CWaWO/KqukAPAP4Vci2xeK3HTwLFEJq6w2kTAN9bbsvjktD6D4NRhoF1rh0mWiHtlIXUlAEFLR5ECDIe/SA70f0dV6XedzeSokQVMx3miqdM3Ee6l5SZJclOMDvDevLJF8j1xMVGeXhD0CYCitJlHWR1bfG90lQ2anIVxRmcHl1l1jjR9JYllvNzL0f2jWgmKQ3f8E8oXUF+qfA5uAyF/zjG/ARtKGf/ULSX33yosjzdQZM3FjINoQHyRnKFKLkGSWnn1Da1y3sDo4FfOhkbWAHP8n4HUhzdM625OVZp/7G/fiicuuKVgxawsKW+TcyD2hrtBM8WXK82A3s+UgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=goO05cRMQ3Tyy40BUm/VMLLHCbzNnaDef3ZReC+/5Lw=;
 b=puTCIwI2oX2Adq+87vV1omtGsLO+r63dGjketu73kTWPhr0kmkefDCxqe2aIkB9ylC9JTpBbK56LWh29qhnH8Ct5hNY3q1TUTFAqznpX01qSIlJNPRJLFEByajFllNu1slzUdsKSwJnh2pICqSsaxozfZqrtn0/3hKPrornXPKQ=
Received: from MW4PR04CA0126.namprd04.prod.outlook.com (2603:10b6:303:84::11)
 by PH0PR12MB8149.namprd12.prod.outlook.com (2603:10b6:510:297::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 21:37:39 +0000
Received: from CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::7a) by MW4PR04CA0126.outlook.office365.com
 (2603:10b6:303:84::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15 via Frontend
 Transport; Mon, 21 Nov 2022 21:37:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT087.mail.protection.outlook.com (10.13.174.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Mon, 21 Nov 2022 21:37:39 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 21 Nov
 2022 15:37:38 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 21 Nov
 2022 13:37:37 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 21 Nov 2022 15:37:36 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        coverity-bot <keescook+coverity-bot@chromium.org>
Subject: [PATCH net-next] sfc: ensure type is valid before updating seen_gen
Date:   Mon, 21 Nov 2022 21:37:08 +0000
Message-ID: <20221121213708.13645-1-edward.cree@amd.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT087:EE_|PH0PR12MB8149:EE_
X-MS-Office365-Filtering-Correlation-Id: a32a4c4a-b780-4299-275f-08dacc089d1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fs9j6A5sqDw9f7QtNVB48NeMnLESco8fwVcaDFVmxA4z94RCjAbSe/+nzVA38OPJNwxY6VU1/ZOx7jR5/WO3ZS50HhEVtACnsFNKTSHcAd/1PJD9yPB5jVXPtg0P0KHwiiHNM3F0mufztbjKJE6EzW2VtAHANtl/QyU7u1uDzeHaAVFu7Qg/c8Eg60ejuhY+syYkjTmOpQBbWfDqfRlylH6RgRHKIKe8K0oPP5X2scP5PG3aG11I16JzxBXCc80DkDJJpsM4ysHvi4KHd+CDZwjeon2HImaKjJg5Dx9/YPVmLNbwFuK3O9LvFENIPJSBACW8GpBUTnKGf0R9EKl4iykPspYLaAQu2MW0aUXsHVyeGCBVOWRqt9NRAr0Jt9D9qkpEuH+TxT6ZfgAIPbSWrTHTT8cZquOlOlXxmRM6SXImrydnHLBe9nibol57VGpZ0O8KrNXFHvmXZbQojW7cDYaBUnzxShR9/eLeBH7b7PpZgHAd/mpHSq3LDX9aRdgCDDWSnt6F98HKdQX9qYL8v6MydLofw3vjr0HHVPuPiJ5/t6+se/Ty21TejBUUJcB5wBLkLTbkimoQ8vy5nE+MwUb8C7OKpJ690z3Wjtj1cuQ6t83XQyjBSUu0NDuudfl1S5UAVU/FVZC/gVsY+GrrmzdQnRa/pMfvw1gid1p9/usDfLoeWyg/IRdBWE7SyH+cvm3lWtzyP4F5aw/0MnIHC/bNPBGFTqCDf3qsFrQ2lCc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199015)(40470700004)(36840700001)(46966006)(36860700001)(8676002)(36756003)(336012)(83380400001)(1076003)(426003)(2616005)(47076005)(110136005)(186003)(4326008)(86362001)(40480700001)(478600001)(40460700003)(5660300002)(41300700001)(70206006)(70586007)(356005)(82740400003)(81166007)(8936002)(82310400005)(54906003)(6636002)(26005)(2906002)(2876002)(316002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 21:37:39.2169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a32a4c4a-b780-4299-275f-08dacc089d1a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8149
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

In the case of invalid or corrupted v2 counter update packets,
 efx_tc_rx_version_2() returns EFX_TC_COUNTER_TYPE_MAX.  In this case
 we should not attempt to update generation counts as this will write
 beyond the end of the seen_gen array.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527356 ("Memory - illegal accesses")
Fixes: 25730d8be5d8 ("sfc: add extra RX channel to receive MAE counter updates on ef100")
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc_counters.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tc_counters.c b/drivers/net/ethernet/sfc/tc_counters.c
index 2bba5d3a2fdb..d1a91d54c6bb 100644
--- a/drivers/net/ethernet/sfc/tc_counters.c
+++ b/drivers/net/ethernet/sfc/tc_counters.c
@@ -476,13 +476,15 @@ static bool efx_tc_rx(struct efx_rx_queue *rx_queue, u32 mark)
 		goto out;
 	}
 
-	/* Update seen_gen unconditionally, to avoid a missed wakeup if
-	 * we race with efx_mae_stop_counters().
-	 */
-	efx->tc->seen_gen[type] = mark;
-	if (efx->tc->flush_counters &&
-	    (s32)(efx->tc->flush_gen[type] - mark) <= 0)
-		wake_up(&efx->tc->flush_wq);
+	if (type < EFX_TC_COUNTER_TYPE_MAX) {
+		/* Update seen_gen unconditionally, to avoid a missed wakeup if
+		 * we race with efx_mae_stop_counters().
+		 */
+		efx->tc->seen_gen[type] = mark;
+		if (efx->tc->flush_counters &&
+		    (s32)(efx->tc->flush_gen[type] - mark) <= 0)
+			wake_up(&efx->tc->flush_wq);
+	}
 out:
 	efx_free_rx_buffers(rx_queue, rx_buf, 1);
 	channel->rx_pkt_n_frags = 0;
