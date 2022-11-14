Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E94A62810D
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237440AbiKNNRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237964AbiKNNQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:16:55 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2073.outbound.protection.outlook.com [40.107.102.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A592AC71
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:16:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sts4B7zWiWqBOXStGwxsi3xyQP1IOPnKBuWa7fXJmHTKldKnixjaER72+SHcBLAkvXT0p2dj38sH472f3C/mrv0ifgBdopcwZuRwk6c9ehtTHUk4lPLmfuKrQuv146Uu3KdEIVphaHtw5UxJn69tF5kGQD/6E9Bssxlk5NeZVmaGZBtwGu+8eYyWeX3JEMO+D7OUaEqH8ke7zpR7rsLHSIgImGVGktGNubE8rD9FlywZhiBckldjkxtxw/R8So0k2kb4fk3ZVUnUkQR5VAShc+P4+4Tvzo1wxCJkcs/0lgUk0S/0bqvnKAVWrpmbm7llf6NUsEQj4uDFJy8plT/iOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UkxebyFZ2MV5Vton5mGT73Yag+gyfrAJk+1Rs2+unkM=;
 b=Se7w8NG+oMvGLtpKZpK6Otnv3YF1LQ8vYAXsP0aQobSUylUHI/Ow74C+65D0NcI9kIWlYjeM5zYdl91aT4mTBBs5wvxIdT8b8Y9n2onfB+rjdTGiAgXiDFBk6wOwCGNMOfw8yO5kuKH4M1e8qYpcpfQfgHEUaDqndtzSEvuHKSXIx87fq0Bc9mX/NNs0ogMmyX7yEsTpuaKi4ohd6wqaY8dzEUQUsLNYphgfw2qu6HG7JhwYPOBlCFeninREJ547IL/li4+FBaFPVeDLlnSO2zxEgJMHzR4F6OvRGSX8hI6+X8yNsYc+QhAgzDB+KHHatp/Dmi16p5PSHwYDyFCIpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkxebyFZ2MV5Vton5mGT73Yag+gyfrAJk+1Rs2+unkM=;
 b=w3AGSf/ZaEc6LoW2bltn+Fj7pufs7N8ZYyN9WB+q2LTjJCEVMtt3dtMAeeAokLHY1LZJbL4wRGuOkKgB3q8v7IhaUMTC7nBbGm62y+ePj3sKECFqpBQ04IHGobyILMxwH0eieY4a5QXAv1kBcktelOKn3fXK8KCAJ3F9R9LMUvk=
Received: from MW4PR03CA0097.namprd03.prod.outlook.com (2603:10b6:303:b7::12)
 by PH0PR12MB5465.namprd12.prod.outlook.com (2603:10b6:510:ec::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 13:16:29 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::cc) by MW4PR03CA0097.outlook.office365.com
 (2603:10b6:303:b7::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Mon, 14 Nov 2022 13:16:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Mon, 14 Nov 2022 13:16:28 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 07:16:28 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 05:16:27 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 14 Nov 2022 07:16:26 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 09/12] sfc: accumulate MAE counter values from update packets
Date:   Mon, 14 Nov 2022 13:15:58 +0000
Message-ID: <686d52d5cadcfaec2ba69260b1f55c7ce55f23c7.1668430870.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1668430870.git.ecree.xilinx@gmail.com>
References: <cover.1668430870.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT003:EE_|PH0PR12MB5465:EE_
X-MS-Office365-Filtering-Correlation-Id: 58783da2-2b1f-4e18-7fda-08dac64270e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /CBwmtDxuokOMtZJmfrVQE+asdHrxT5wJ7biBVGmwTh/s6yABvs2ZRVwGMw9Eyhk8q8L+E4fIt+djmGOgbKSJh5Fne6ldBUR6uLoHgesHGCEDb7Ir6jjlz0uHJ/nsbqPd5/I7mzqw0EG+MziMxSptJVg8vekPBQNuk9D70WC5l4R93A1V9IOdVf6XwcRc6Zfcmi9Z/Y/1MdBHr6DXlruvB+TBLUsTmSjpN+z3GluFd4lwMS/gmIottuqdxNvttEjQpLWdcjxyBHwnUr5YRU6+k10ewH2+qWkHOOb3LgoCtUZbfmxtExxUqpIx6/lJzkPdTq1w4/RD0c61lPJLD7eU+fFh7jrifJ3tkkUivEY0tJuRTSytIVtsFh5bkrYlN8bvjoRx+JwyBEkoUmGkF/V+2sSD32J9cs3XG0qxk1Ae/L4WjyViZxnUumAqzEpdfU9aLbbG0WVsBKhEsZAGxjdjmpNaxm+tV9HXVOk3GRGanHE95lflXkV3c7UY2R6NnSE9+YOrvlaOZEmT/50adHLN1EmDQDny2u1tzRlyOdJw7tGqgz8qV/cRF0rwYbygn+P4HqB+omoeW54x7QQwRoVbrlE6OYc8p+W9P0f2LYWF6oSpUaW71tXgWb1wiUbPdG3GL67PkvmjNpi+9lnV61FRuZXIBXxQNIEl6bRXq+w29qvSK08k1CD3vhZutE2aNuHg3WqcRhh6+6OJ+58QyG1YKzN+A2y3EH0XdY0aF3ULKFktVSZrngiuPFB+8vOXMbogdbkH2VaeMtKp51rza2bxXtGk5E7U5+63qj109m7QWuwNQiaav5s0kfJtEvp6YOp
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(186003)(336012)(426003)(316002)(54906003)(110136005)(478600001)(36756003)(6636002)(26005)(9686003)(6666004)(40460700003)(82740400003)(70206006)(86362001)(81166007)(356005)(40480700001)(47076005)(55446002)(83380400001)(36860700001)(82310400005)(70586007)(2876002)(15650500001)(8936002)(5660300002)(8676002)(4326008)(2906002)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 13:16:28.8948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58783da2-2b1f-4e18-7fda-08dac64270e4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5465
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
