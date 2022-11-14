Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E5A628106
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbiKNNQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237328AbiKNNQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:16:24 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EC82983C
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:16:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H52DAIqB2l2n0+Qc0u0tUvnbeiNUzFgHd6h8OEiehty0ktJBiLnWrEvmgBJT5g0tsBh9LoAynphW7s68uPUDKgpuUnC9BUhp4DCermSJCfUC1P5p+yTx5I8KJ6ig0MQg+ctz1vXIE7TsHRS8HSzbmvaCN4eHgLd+9Tokndq54Kqv0+5isaCNe0XbRrv3uBrErqBIVGKqy7mylntIr20Ls57zIVNpFe1ehVh0yOj6qv/c9PdCzQ/pxv0Pkvle4xzV2h/phjI+TBSnX3GYzjvEz9xGUIbkXB+HRE+xkD6WBPXMQzE+nDzFT1DUTkiI2whRk98CTwuPwHgATbV/AnHHPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBJlDY+k3sKao00jejxHN2YakEsp2xAEE2gzQkuU584=;
 b=fKJDgCR/DtWP+SnYrbim4VLWEqhKymPobB/PGSUFMwv8SCUC5vAM1MCsHfy+n+h+Cjd1JNG5Y+prE+R/aECHPZooeo08gGDez9WTyy40qcrMEyBcquHdSPLb5aGvMR42vWe8XiCjtBxRlQIMBvPqiYzm4vs48uMfYw63nbkuG+p2O3vpLrM5V/xNq0UFyn/bZ/wP3aRw8uzPUkysCvG31AU23tocuI12CJXLWmzR6oK6Gl7EUQBobu3QVDwc1sp+Q+LKMWfXyxnDEGj/5xpXhsagNyFdiTeCPQ9/LgmAJ9MTRO2jhkj7szFmCqqusrNC2uHGAcDVXB0mAJoZwzE8dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBJlDY+k3sKao00jejxHN2YakEsp2xAEE2gzQkuU584=;
 b=DjAF4likKEFbfMK16Z6d/Kz7ioDxYU2h4UDfw/90hGECwJ5OuRVdWQHzY+STuiBFheB082XfgCFgkVLgBYKhOgWYi8Q+KQHrvsgbU5+I4/zNTfJFL7ue+1cR57NCwiMTc7n2dSeV5DEq5X1vz6XdL09OPKlVpe5eXVf0H7H5KGY=
Received: from MW4PR04CA0208.namprd04.prod.outlook.com (2603:10b6:303:86::33)
 by MN0PR12MB6056.namprd12.prod.outlook.com (2603:10b6:208:3cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 13:16:18 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::41) by MW4PR04CA0208.outlook.office365.com
 (2603:10b6:303:86::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Mon, 14 Nov 2022 13:16:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Mon, 14 Nov 2022 13:16:18 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 07:16:16 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 05:16:15 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 14 Nov 2022 07:16:14 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 01/12] sfc: fix ef100 RX prefix macro
Date:   Mon, 14 Nov 2022 13:15:50 +0000
Message-ID: <45846238c1b9e1f8b8ddb81aabadb6fae67a301f.1668430870.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1668430870.git.ecree.xilinx@gmail.com>
References: <cover.1668430870.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT054:EE_|MN0PR12MB6056:EE_
X-MS-Office365-Filtering-Correlation-Id: 07ff0b44-7f9a-457b-cf8c-08dac6426ab6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e3fKCfQ8mh2a1byvVODnOYbC7Qd4pzCABWNUVTn+T+uL/WflOFTSrk3My3HPyRUhXQK574kklQc3f/CSBEZyP1M0bNOtqFEnxEi+61LWqXBlQ51p1wY6q/YGrk9FRAJMsleapgDPi0dq1uOPmLaAtDLnZ8xMu3It2xSn5QSUVV9iEK8osrlEMFjxwE8piPW+INoyseS8/MlU/WM1nNLktnivUbUXNgNuS8hYKL6v1L09T925UZ1qM/djoZijY+hqxI+Zz5lLxeXhez0qURuApYyxoGMdv6b48C7qHqrLh+8OD4cJ3pStk/mCOYvbjZxPnfnXeeCyIcbiu4Xoc7CPvGfHUHiIOQKvwkvlWYqsjTAYlFrTa1bWLgzYh6Kvq+bwiU+zzXOSpLsPCSKatPlI58p8s4S+vDwG7RlMBtPSPhmv5mze1HDsNEpZ81eBpTGNsmjbc7l4ESt3hWu+Sx2PkZr+ruGlH8UhJNZ196/9QJye8SQaJia9o0jHm25B0n12xrOb4UA9KaQyuD72JYdTgbyOUE/8v2OGX81VkGroqPBPYm7FQFqGo9TOfawHseAv9reb0y+NqlM7yi8mAmu3IJawba5Ua82bjremU8KeWXSimLhKZXVS8Y19Eg9OiFGM/cu7Goy+g4BUPAFTfrkHN5L+J3qLYNGnm/KzOQilCmKScjX2/I9WLRnt3XfROqsm+Mw2/czkOKZW7S3UFl97H1ZKhM2IiKKUUUMGc+Cz4EHl7rg726wuH3Thnj+PGkr7u66QBWXDwdQL5/V7McVGZncif17/TFgoxbyO6DelGl7wOFXix009jrHoeCIfyzyM
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199015)(36840700001)(46966006)(40470700004)(40480700001)(478600001)(426003)(40460700003)(36756003)(47076005)(83380400001)(82310400005)(2876002)(5660300002)(41300700001)(356005)(8936002)(6636002)(70586007)(70206006)(4326008)(8676002)(54906003)(316002)(81166007)(82740400003)(36860700001)(9686003)(6666004)(55446002)(110136005)(2906002)(186003)(86362001)(336012)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 13:16:18.5134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ff0b44-7f9a-457b-cf8c-08dac6426ab6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6056
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

Macro PREFIX_WIDTH_MASK uses unsigned long arithmetic for a shift of up
 to 32 bits, which breaks on 32-bit systems.  This did not previously
 show up as we weren't using any fields of width 32, but we now need to
 access ESF_GZ_RX_PREFIX_USER_MARK.
Change it to unsigned long long.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
index 65bbe37753e6..0721260cf2da 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.c
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -21,7 +21,7 @@
 /* Get the value of a field in the RX prefix */
 #define PREFIX_OFFSET_W(_f)	(ESF_GZ_RX_PREFIX_ ## _f ## _LBN / 32)
 #define PREFIX_OFFSET_B(_f)	(ESF_GZ_RX_PREFIX_ ## _f ## _LBN % 32)
-#define PREFIX_WIDTH_MASK(_f)	((1UL << ESF_GZ_RX_PREFIX_ ## _f ## _WIDTH) - 1)
+#define PREFIX_WIDTH_MASK(_f)	((1ULL << ESF_GZ_RX_PREFIX_ ## _f ## _WIDTH) - 1)
 #define PREFIX_WORD(_p, _f)	le32_to_cpu((__force __le32)(_p)[PREFIX_OFFSET_W(_f)])
 #define PREFIX_FIELD(_p, _f)	((PREFIX_WORD(_p, _f) >> PREFIX_OFFSET_B(_f)) & \
 				 PREFIX_WIDTH_MASK(_f))
