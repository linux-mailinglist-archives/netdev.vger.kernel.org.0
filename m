Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C588C520115
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238308AbiEIP23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238272AbiEIP22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:28:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE572C96DA
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 08:24:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpAHLnn/51vw3URSRf6W7ifo7QzanQLWhHpVAY/P6qP00WcVgIeFs66sluunJUbL3DYYqChzgbGKv6IZc8lXKhRjRPaLjV+Oof67dR0UlxzM/qi7RatFVyhpbCfLf/H5ZXB/ruo4jwPHc2xl4EVtXS9qfdQl7F6O8dsllsiwtM5jRVi8GHLqGZtuiJtmGA4eh8P31xARtv5hxHCo0Ayk41+5ooETdpysDKAv3IRxvpu0jFtv2bMhpZTFpfvMvucFh/1rAtL/ILYsZZm5CG+HZpqHDDeIhTF1lKok7Nrro/6O5k97OrAtJbmoaehbY+I6EN/VEnIes3ETAi/eXnFyYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3gaIAApk6m5ZFQbjBoMbQPSQxz1jkDswpuxF8V0P8/Q=;
 b=Hk4a/P90L/01OkEEcndc8pyBfHd1me8/I5RPX5tb354dvOd9KSMjwcb89N0IqQnjW51MJkgqEI9XylsTe0z0yfYDYXpgANI6/rInrtJPprJbPnDTo7SUaxn5JCWckpcxBc8JrgV6msWi3x8rGs8q0//9jckWxZHLQs2y9Or4G1qkfcDpGDx7bHzYi9HatfL2Q4eHVnDg6k7zc76Fq7ufkzaUIeYmJcO4J8HXCQLTiGLl2kyQIY6QRjfqtvNBFEd4j9/BzAIs5KKqsM0E0rC6bC4DfkxtR1fICmmV3S+6bgSljJERDmIAiAI4jScC8NR9U3iTh/BKZ/ScDRlX5c1hCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gaIAApk6m5ZFQbjBoMbQPSQxz1jkDswpuxF8V0P8/Q=;
 b=VB+EC6QwkYTpLJXesnstF5FgKKk4eCrT6awuxLNyjWZALU1u7/QfuTN6M6qWbtnecCphviy1zaVEoheu3ZosL1o3kzLU5TLDWPMj8yWbD2rHStd0dTWMXZhzM4dmDaVAcopdp2bSYgO6RVS37AdMzdx74ljqiBE8aKXgVZM0WRMr5nBxsFZWVEzOF/ctXjssosJr20Vf1iGF474xyjEYVV6avLv5oy/ziBJSh/WOl4JjJy+sHlQEz5pv8FxXslHDPq9+ETg6HlE4W3FsYQbJmahK4bwmlXowp5jqmf5PIU6X68ye4RjcJvTTPuzht6G19fgnJrEng5rj+Sv+mIN0fA==
Received: from DS7PR03CA0187.namprd03.prod.outlook.com (2603:10b6:5:3b6::12)
 by BY5PR12MB4131.namprd12.prod.outlook.com (2603:10b6:a03:212::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Mon, 9 May
 2022 15:24:32 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::3c) by DS7PR03CA0187.outlook.office365.com
 (2603:10b6:5:3b6::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Mon, 9 May 2022 15:24:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 15:24:32 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 9 May
 2022 15:24:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 08:24:30 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Mon, 9 May
 2022 08:24:29 -0700
From:   David Thompson <davthompson@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>
CC:     <netdev@vger.kernel.org>, <limings@nvidia.com>,
        <cai.huoqing@linux.dev>, David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: [PATCH net-next v1] mlxbf_gige: remove driver-managed interrupt counts
Date:   Mon, 9 May 2022 11:24:26 -0400
Message-ID: <20220509152426.28800-1-davthompson@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48aaf0ad-dafb-4699-a5c3-08da31d0045a
X-MS-TrafficTypeDiagnostic: BY5PR12MB4131:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4131D95C6D262F661B261A79C7C69@BY5PR12MB4131.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aXDMxG/rPRyhd5uxSjdW7TlYB65d7XQhmpDrM8NbIj7oaJwgEdlZBWJCpY0aSRC2mAPooExYbW9YoF1SqopeDWAj2S8ZUQsGfu7WZ86JD6Oc7n5DyttuUUJyC2WWK7AqPFGhROuTk3wvnXcmvgfTa148R59C69p3PK8WgiemzXEVIvtfrfGbjLb2R0xxalGzb/8aZIa2CzRIysvZkI440/vmYcz7yvgS/EfeJ0i8Fogjz3wdSr+RuUd48Gpetk3cp6U+j0MYdurVcJNXieqszMLQfWKzROKk5b7SCTL2H11+g0Kn77T0nOeBM8iJQN6Zi9SQiDgB6Wxfb/hek+Xa//klc3Oxw4m6co3+8naNd2+si/jEoBmPhXDERUXOZcSfT3iM1NPr38/SBvBTcz1k42PVK8m6d+wfFOMXQjJwMXjS6F3MTQhR9Z5rCCqfiUfLW8i0gRZ1T6NOzY2M4liC8C4aaBJKhzSgh6ScUIY6vC9sJISjWH79zCO6jTEtHHtZS14nX7sAc9eo74QsjsQ6DV5g7goIkogjovyXqpCqcXgVfzJfdcZUhyI/3/Q9I+6D1N50svECPavyL+AmIHhwFbf+PB7Hm41t+ZkQ0dicg/WrIhsGsT4O9V77fMFrUrk6JYg+cGdVQoOBUJnTTPQXCuizFdqbWhw6ZRns66j896nsv2y0g7wrIOtnz9nxH5+vz4xFKCyB96k37zjP1y1ZCQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(1076003)(107886003)(508600001)(36860700001)(83380400001)(47076005)(54906003)(336012)(426003)(356005)(110136005)(316002)(186003)(36756003)(8676002)(7696005)(4326008)(6666004)(82310400005)(2906002)(81166007)(26005)(70206006)(2616005)(70586007)(5660300002)(86362001)(40460700003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 15:24:32.1104
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48aaf0ad-dafb-4699-a5c3-08da31d0045a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4131
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
This patch removes the driver-managed counters, and thus
removes them from "ethtool -S" output as well.

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

