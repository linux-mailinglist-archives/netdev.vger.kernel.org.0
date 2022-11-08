Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04907621A80
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbiKHR0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiKHR01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:26:27 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30FF1DDF9
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:26:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bI10RYVmRl/foAg+Z26LxzvMyQzYNdMsvkosiXouM5Ta3BSzBWLKGusYYDrP0HRKoxXhCSaaH/b+2J8rsw2q4XuoSc3nBhX9sdeDYavXNWfCZ02OMGLUnyTdRSIufbqZZNeqmO0mNtCcokCQBEFf/MF/eXOGf6jJwVIgJsZO7VfEzGzpUE6gqS5+8Cp46kh0dwEX2R8HvOIxz1WPUGo4rvM7g1BswxMkE+Vq2VRjf+idxW9AfVLVySbfHTTfGmNjohWdEoUtBQ/XTUC2mGZ4hM5sffveNoVTIWKxIeQ1ytAQnFcUc0TssxsbyI0l61zAKM26AXmV6P4s+5D9Fj9CjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UkxebyFZ2MV5Vton5mGT73Yag+gyfrAJk+1Rs2+unkM=;
 b=lG72MsWoyJVzTdvP2JksrW2M509G594kwu1vJbtL5o7nG/G1O3Hy9l05f3A7my6iYwT7WOKnTZzLoNWs+s78JDd7rV5792YA9R3xvD2QeyvwaM0W4IOmnuKhgHZsy9DIN9p03gSb+B1k/3zzhLsg8wTpsU1ZDrEjWmHndrmi83FAW7HC2dYk9gGPY2fO1S8pEX9Bh6cC6B4cq0ZMXlaZxvuSL4Rok+twMQ2jq56ErNEq325AJ6exXI94FYfS7D3XrJUoCXCYe883qBh3T29a8Z5+EigTPQggDgdzmSKGheLc//r0+zgezHZRyKf4/DkzudBWMM3nxZbMCUDlPfP+2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkxebyFZ2MV5Vton5mGT73Yag+gyfrAJk+1Rs2+unkM=;
 b=za+qYRcHQ2LqUrz0XCIHxXKRFV0afV7Rv/OdDsGdhe0QYKK9QCG3tumpxcsspZW8ijf6Rxq8+V6Okcl0JhbTOSQIuglcCGocwTyZWyJf/D0K5FyTwyQsBy3ayVFS1tzbd7xqeOML+tpbnsCWAEYHBuj6sfb4S2J39O+3YrkzXlM=
Received: from MW4P223CA0009.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::14)
 by SA1PR12MB6946.namprd12.prod.outlook.com (2603:10b6:806:24d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Tue, 8 Nov
 2022 17:26:24 +0000
Received: from CO1NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::c0) by MW4P223CA0009.outlook.office365.com
 (2603:10b6:303:80::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Tue, 8 Nov 2022 17:26:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT097.mail.protection.outlook.com (10.13.175.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Tue, 8 Nov 2022 17:26:23 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 11:26:22 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 09:26:22 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 8 Nov 2022 11:26:21 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 08/11] sfc: accumulate MAE counter values from update packets
Date:   Tue, 8 Nov 2022 17:24:49 +0000
Message-ID: <caaa7d03cb960d5df60d00522d484de7c2e3fc90.1667923490.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667923490.git.ecree.xilinx@gmail.com>
References: <cover.1667923490.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT097:EE_|SA1PR12MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e4f42d7-a26a-4360-55d1-08dac1ae5c01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WdIQbiqi6MCF4ARIrTPGlZybNCUKTbLQqa6fBuOA4b+dQ87HY7122EtL/MFlrzaC3LtGhBmsxPOSM1or9pE7mNP2VdWRqKzakyqtJ1c7o05P7QyU3yd9VlmO9RfyWjVjZEIKaMluFjKG2ufZv/6GlvVLqDyqH+MV1s7r5JvaeQnC6e7mDJdOJLP0RrXAYQsftROHjoiC0wpBDMAPFLCTzfBUJJagAXCdpy5p2lB4R8fsSuK2JNAI1FEcNe+UAfi4U4oKOfKKo6cVI3hpQKEyEKRndzuxk2+lKCslpd9xtvPR48RHXe3VvmjD2F+UVkwkEjuv8wIXNhPPTYfBOLSLWFHJmd6h3dpdHpb3T+uDk4UiBA9Bw7Pyy+YeEuxyrqyZuWwW2vM8o5rIT99rrdjorjF9ulbX0eh+oEy/tXAzxV8A4hPwlMiThu2kfV7h5jbnhPCZVmYp9SNPWarrgkMH7/Sh6pVyUEd1m8I6FbCT77mTdqYunIPDAMtiL6mHuEBsrrIewbXkb2BocfUkpAiEc+B7bQlVaeIP5Jr4zVWa/P0MYkeihbP1GVaJ50JiCM3U2BPLpUebwxGPz475s47RlYbKC0/TlspemF1z7fKNw5RkNeWfNE68Ib2wFLNIFMCw/1n9lJyFVP0aFiQF5KvDBJh0IjPoLL16HAWxL4qeJqiXwthv5OLKGBf05Ty3j0KlOyxreCwiMWdSPSuVSOStci+K/GJPHQ0ZP+Rr5OvwmzmZgHsjp4Nc8MDv9XxtAgxa4AO7alclNU0jf4XFnYENtOqj5LlvIbMn3/tlAShxuIpFWOtCXpixZy+GFQVS9YXH
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199015)(40470700004)(36840700001)(46966006)(82310400005)(36756003)(8936002)(81166007)(40480700001)(83380400001)(356005)(110136005)(4326008)(8676002)(478600001)(2906002)(15650500001)(41300700001)(70206006)(70586007)(82740400003)(316002)(9686003)(54906003)(186003)(426003)(336012)(47076005)(26005)(36860700001)(40460700003)(2876002)(5660300002)(6636002)(86362001)(55446002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:26:23.6845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4f42d7-a26a-4360-55d1-08dac1ae5c01
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6946
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

Add the packet and byte counts to the software running total, and store
 the latest jiffies every time the counter is bumped.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc_counters.c | 54 +++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/tc_counters.h |  4 ++
 2 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/tc_counters.c b/drivers/net/ethernet/sfc/tc_counters.c
index 6fd07ce61eb7..76a2e8ac517a 100644
--- a/drivers/net/ethernet/sfc/tc_counters.c
+++ b/drivers/net/ethernet/sfc/tc_counters.c
@@ -86,6 +86,8 @@ static struct efx_tc_counter *efx_tc_flower_allocate_counter(struct efx_nic *efx
 	if (!cnt)
 		return ERR_PTR(-ENOMEM);
 
+	spin_lock_init(&cnt->lock);
+	cnt->touched = jiffies;
 	cnt->type = type;
 
 	rc = efx_mae_allocate_counter(efx, cnt);
@@ -131,9 +133,22 @@ static void efx_tc_flower_release_counter(struct efx_nic *efx,
 	 * is handled by the generation count.
 	 */
 	synchronize_rcu();
+	EFX_WARN_ON_PARANOID(spin_is_locked(&cnt->lock));
 	kfree(cnt);
 }
 
+static struct efx_tc_counter *efx_tc_flower_find_counter_by_fw_id(
+				struct efx_nic *efx, int type, u32 fw_id)
+{
+	struct efx_tc_counter key = {};
+
+	key.fw_id = fw_id;
+	key.type = type;
+
+	return rhashtable_lookup_fast(&efx->tc->counter_ht, &key,
+				      efx_tc_counter_ht_params);
+}
+
 /* TC cookie to counter mapping */
 
 void efx_tc_flower_put_counter_index(struct efx_nic *efx,
@@ -241,7 +256,44 @@ static void efx_tc_counter_update(struct efx_nic *efx,
 				  u32 counter_idx, u64 packets, u64 bytes,
 				  u32 mark)
 {
-	/* Software counter objects do not exist yet, for now we ignore this */
+	struct efx_tc_counter *cnt;
+
+	rcu_read_lock(); /* Protect against deletion of 'cnt' */
+	cnt = efx_tc_flower_find_counter_by_fw_id(efx, counter_type, counter_idx);
+	if (!cnt) {
+		/* This can legitimately happen when a counter is removed,
+		 * with updates for the counter still in-flight; however this
+		 * should be an infrequent occurrence.
+		 */
+		if (net_ratelimit())
+			netif_dbg(efx, drv, efx->net_dev,
+				  "Got update for unwanted MAE counter %u type %u\n",
+				  counter_idx, counter_type);
+		goto out;
+	}
+
+	spin_lock_bh(&cnt->lock);
+	if ((s32)mark - (s32)cnt->gen < 0) {
+		/* This counter update packet is from before the counter was
+		 * allocated; thus it must be for a previous counter with
+		 * the same ID that has since been freed, and it should be
+		 * ignored.
+		 */
+	} else {
+		/* Update latest seen generation count.  This ensures that
+		 * even a long-lived counter won't start getting ignored if
+		 * the generation count wraps around, unless it somehow
+		 * manages to go 1<<31 generations without an update.
+		 */
+		cnt->gen = mark;
+		/* update counter values */
+		cnt->packets += packets;
+		cnt->bytes += bytes;
+		cnt->touched = jiffies;
+	}
+	spin_unlock_bh(&cnt->lock);
+out:
+	rcu_read_unlock();
 }
 
 static void efx_tc_rx_version_1(struct efx_nic *efx, const u8 *data, u32 mark)
diff --git a/drivers/net/ethernet/sfc/tc_counters.h b/drivers/net/ethernet/sfc/tc_counters.h
index 85f4919271eb..a5a6d8cb1365 100644
--- a/drivers/net/ethernet/sfc/tc_counters.h
+++ b/drivers/net/ethernet/sfc/tc_counters.h
@@ -26,7 +26,11 @@ struct efx_tc_counter {
 	u32 fw_id; /* index in firmware counter table */
 	enum efx_tc_counter_type type;
 	struct rhash_head linkage; /* efx->tc->counter_ht */
+	spinlock_t lock; /* Serialises updates to counter values */
 	u32 gen; /* Generation count at which this counter is current */
+	u64 packets, bytes;
+	/* jiffies of the last time we saw packets increase */
+	unsigned long touched;
 };
 
 struct efx_tc_counter_index {
