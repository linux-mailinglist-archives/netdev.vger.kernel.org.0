Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565B35234B8
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244182AbiEKNxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237191AbiEKNxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:53:03 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E42817A82
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 06:53:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYWk1krh6h7A9wNafxmXCt6/kdv4zDnft+/RanjoK7/h/2KsKwShHrooWDmZ9yXzwawxG8RUcPce8B11itb6Qz+CrqJfcH3SScRqyoT+qu8I/kY5OZzM3JxxXCWOSnbDm3ADLmCYV4dgvScKRP4TRHjdw/e8Iy5fIjQ0Mq5iI4DCBycKJUMGqxYN7sa4dx9H3GGzKTahkBJZlFtT30E+F/yd6wcFv825XH0yqRU53SxojsgmBP0Fx9cRFB6oR13Co69v9D0ZzKbALCEKluWk+A45lF5NULd6zY78/yqqvBSEqu4DukxZXpyGQJZq6xCNzu5vqylaS67JVp05LYmdHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l51YTbH+Yl9okTIYIoMA8Ar/5tUUYOqZCBcp8/DsByY=;
 b=Nhg5En8Htode1aGSGD7nsJsADQ65bUy/3qrcldeVoGKMACrz0OSurpruAqxaWBJ3cq+2Kk251HOHKodcTsUI0F520QXh9MHUoVchRIpeIttunjxOv0FzjT2M6+V3DC+evQ0/D2AYnP0u8ShDZ3LZrUh6RIOqDMiatfzEs78yrenR+XtwVYgZnRbgrUA64MuvnkIR3f/mkuIyUhzUtAXZF2nD7u28u5WGAIqi+iMFEf6VlULtww2orFtpivEN4gwmIpbv4hWoiHXKrL9KJOL4Ih1L/5Z51ePTydzAN90v9CkPb8I0p6O0gxC12s9UjHzXhf8HRYvJfUuue4ylmqNmwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=bgdev.pl smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l51YTbH+Yl9okTIYIoMA8Ar/5tUUYOqZCBcp8/DsByY=;
 b=UfKzXVGXL37flAjxuQpw3zM8bdUotxWmDdjN/fhidAK6Ior+1sQZv9MDF9toIdQnNGhkpfltTGUfwPam1Yzg1K68LgAvd+tPyDGmuO6KLFqRXJGMchoghVS6UPGvldgPClM/KVfDLw+cxDwAwaBLOyLBt2gWWCkhgVxhuGohRQeKgCGCXVYz7q//0e98KVEHFUpkdT4Agv4gnTAvH7/Xdlcha9yb1c69XnkvGtkldnc8lewrFJBFb9IPga5AxLWtZU548fNjc4l47i62DFTRx75qAc6/Kr82e4l82BcORraSzU0KEZ3ZgYUqD3AbkstKeBKjSBcrRD9hVeZrV++0bQ==
Received: from BN8PR04CA0048.namprd04.prod.outlook.com (2603:10b6:408:d4::22)
 by BYAPR12MB2647.namprd12.prod.outlook.com (2603:10b6:a03:6f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 13:53:01 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::20) by BN8PR04CA0048.outlook.office365.com
 (2603:10b6:408:d4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13 via Frontend
 Transport; Wed, 11 May 2022 13:53:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Wed, 11 May 2022 13:53:00 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 11 May
 2022 13:53:00 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 11 May
 2022 06:52:59 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 11 May
 2022 06:52:58 -0700
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>
CC:     <netdev@vger.kernel.org>, <limings@nvidia.com>, <brgl@bgdev.pl>,
        <chenhao288@hisilicon.com>, <cai.huoqing@linux.dev>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: [PATCH net-next v2] mlxbf_gige: remove driver-managed interrupt counts
Date:   Wed, 11 May 2022 09:52:51 -0400
Message-ID: <20220511135251.2989-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad259193-26c8-440b-cd15-08da3355901c
X-MS-TrafficTypeDiagnostic: BYAPR12MB2647:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB26470AAA2C5A063D7B85378CC7C89@BYAPR12MB2647.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NFoGyhmQJfXkvBLFM3FCEQbamZKHAMJNOoUwApZE2qoQ+9yqO7HEa1cq1cToqo2QrxIJF3JjySDMCNuZ0o/BTv13HsnAxOHJFJ+/LW+fppGDjh9G2nhEk0+4rrnMGDB5nTOWCE6CT+xt88t/s19eTwy3byUfD4zSLcQHoJGvsVXwN2X3YybR5aMTMyKvsZQHG2uND8gVJe4TWOBLkpItllN7w3TUnQSJMz8DsOVU+dV6IpJcjkJimegk7WLS32RYNNP5xZaOiHGN2UrFR3mhxG0ebKnTT+GSKJyz3bbgDDfHbqPlJLB++ieCw67kEWW2UGPMcrH6DiWz7PadNvH2vbDYQYCMSpcXIfFKV5K5ERjsJrwu1RueplIcaBiY0k5SjPZ9NjTukyhyRYwji+ZCcGIeUcrXT+svSQXcVmJPBetR+BnvK/PZMzRM9CtqUttatBRdq7ug7kIdSAUHn/Y0q7S//RmWGr7iG5ONeQmGU+hJUOHvsWzmFesaHKwHAuGapjUEYgayB/UxwEDOxO5dlqz0zJM+/aZot36MQgTnYDpMEqMrl2luojK75SDps+kganokiq0kmiP49Qo58UjzxDv61sRs107LtDeOuDmDNB/iFvpEtbNsPxQrTNR1t8OYqZPlGm+C/Psip/nhru2akMbHS/Hr2R8B8I62HyUMiI428SoQni11ejq8MqigDSGSlYCp0K85U+KezcIuWMWQ4Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(7696005)(2616005)(26005)(6666004)(70586007)(5660300002)(8936002)(40460700003)(336012)(2906002)(36756003)(82310400005)(70206006)(86362001)(508600001)(81166007)(54906003)(8676002)(4326008)(110136005)(316002)(356005)(1076003)(107886003)(36860700001)(83380400001)(186003)(47076005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 13:53:00.7671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad259193-26c8-440b-cd15-08da3355901c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2647
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver currently has three interrupt counters,
which are incremented every time each interrupt handler
executes.  These driver-managed counters are not
necessary as the kernel already has logic that manages
interrupt counts and exposes them via /proc/interrupts.
This patch removes the driver-managed counters.

Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h    | 3 ---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c    | 8 +++-----
 .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_intr.c   | 9 ---------
 3 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
index 86826a70f9dd..5fdf9b7179f5 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
@@ -90,9 +90,6 @@ struct mlxbf_gige {
 	dma_addr_t rx_cqe_base_dma;
 	u16 tx_pi;
 	u16 prev_tx_ci;
-	u64 error_intr_count;
-	u64 rx_intr_count;
-	u64 llu_plu_intr_count;
 	struct sk_buff *rx_skb[MLXBF_GIGE_MAX_RXQ_SZ];
 	struct sk_buff *tx_skb[MLXBF_GIGE_MAX_TXQ_SZ];
 	int error_irq;
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
index ceeb7f4c3f6c..41ebef25a930 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
@@ -24,11 +24,9 @@ static void mlxbf_gige_get_regs(struct net_device *netdev,
 	regs->version = MLXBF_GIGE_REGS_VERSION;
 
 	/* Read entire MMIO register space and store results
-	 * into the provided buffer. Each 64-bit word is converted
-	 * to big-endian to make the output more readable.
-	 *
-	 * NOTE: by design, a read to an offset without an existing
-	 *       register will be acknowledged and return zero.
+	 * into the provided buffer. By design, a read to an
+	 * offset without an existing register will be
+	 * acknowledged and return zero.
 	 */
 	memcpy_fromio(p, priv->base, MLXBF_GIGE_MMIO_REG_SZ);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_intr.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_intr.c
index c38795be04a2..5b3519f0cc46 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_intr.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_intr.c
@@ -17,8 +17,6 @@ static irqreturn_t mlxbf_gige_error_intr(int irq, void *dev_id)
 
 	priv = dev_id;
 
-	priv->error_intr_count++;
-
 	int_status = readq(priv->base + MLXBF_GIGE_INT_STATUS);
 
 	if (int_status & MLXBF_GIGE_INT_STATUS_HW_ACCESS_ERROR)
@@ -75,8 +73,6 @@ static irqreturn_t mlxbf_gige_rx_intr(int irq, void *dev_id)
 
 	priv = dev_id;
 
-	priv->rx_intr_count++;
-
 	/* NOTE: GigE silicon automatically disables "packet rx" interrupt by
 	 *       setting MLXBF_GIGE_INT_MASK bit0 upon triggering the interrupt
 	 *       to the ARM cores.  Software needs to re-enable "packet rx"
@@ -90,11 +86,6 @@ static irqreturn_t mlxbf_gige_rx_intr(int irq, void *dev_id)
 
 static irqreturn_t mlxbf_gige_llu_plu_intr(int irq, void *dev_id)
 {
-	struct mlxbf_gige *priv;
-
-	priv = dev_id;
-	priv->llu_plu_intr_count++;
-
 	return IRQ_HANDLED;
 }
 
-- 
2.30.1

