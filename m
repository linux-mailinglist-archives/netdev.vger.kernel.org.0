Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C023628112
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbiKNNRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237998AbiKNNQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:16:58 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8CB2BB1C
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:16:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uj4xHxxmyDMOEnpJCf6IygTbg7tuf+9pfPUSQXt9ODTkWGHyPPWP5Ujuf2j/hCNRmcFDpNSweXl3rJQX37tmh4rxEXVit9BRBDdN7q5oTt6THIM86/GnHr+SksyTAoaC6thCULr1PGtZYJq8nRlkv1WX93xTay2LCfUtPdwSKToh+04cUvvNZYMaw37p6Lb9z7XwFh33UjlP09dgnTBvPlnVHY01fRkCkUdsiBL2h3o8fjLy8DGluleVZWbrGXN4GgGaaTb1lUzy7DLIgkZh9Ugb0W9aPVVQR9+ikc1YLt4nvxlpRdR58bJ3yD0riPQTwt/rY7yTCo362eNPWBAWhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=otn9FCXXyxZkHyzx6LWrupE9D6NMNNjDbTcjs1N3ALw=;
 b=DmSl8lrxKHrhHMDz5NiGrEfd0Fivk+lj2cGFUpePa8NXd+Lx6ehEhJtY8VTzRz6ezdise0xM9ydUUUoaCpCj59TJkYuwY1W4hhPY4myCQqTE6VQjPv3vT363jgz8w46oMCt+dj/VJfjvnM++Hk2/Y8FZjgUsT7U/a6Uti7kHC6F8GZwnGaIc3lZaZcze7dweEHSSkuOH7w671wl9h/LKC9z+/wergZZJjGZ8WL4mz7IWyC4OGiSwTd0we1fSwtYrsGPB36b0zUiyyTivIBWDjAST7VCD4bsXyXl8MmPm8BQlWUJ4rx215lSq7Lov8I/NKlZ7eWzje/SKcC5Ge6x7hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otn9FCXXyxZkHyzx6LWrupE9D6NMNNjDbTcjs1N3ALw=;
 b=ir6S7iQx8bf9+usBQM1mnjJxDBgCbkBhO9Y1cO3G+A8OtTOrEHng0T3KGhmhvG7p4J6nDklMZjzxU5+6GJgH8jUwr7UfGfYuf5rRU5ze/+epdVFkPUjyAD0ElGVpQOeKNK8L5gDXclkhYYF8OyqZMrWM8H0T4NWiZnm/b6KxjLw=
Received: from BN9PR03CA0313.namprd03.prod.outlook.com (2603:10b6:408:112::18)
 by CH2PR12MB4874.namprd12.prod.outlook.com (2603:10b6:610:64::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 13:16:33 +0000
Received: from BN8NAM11FT100.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::a9) by BN9PR03CA0313.outlook.office365.com
 (2603:10b6:408:112::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Mon, 14 Nov 2022 13:16:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT100.mail.protection.outlook.com (10.13.177.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Mon, 14 Nov 2022 13:16:33 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 07:16:31 -0600
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 14 Nov 2022 07:16:30 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 12/12] sfc: implement counters readout to TC stats
Date:   Mon, 14 Nov 2022 13:16:01 +0000
Message-ID: <7ce0b524f5cda50e24e9702134dc869a9e7ca854.1668430870.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1668430870.git.ecree.xilinx@gmail.com>
References: <cover.1668430870.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT100:EE_|CH2PR12MB4874:EE_
X-MS-Office365-Filtering-Correlation-Id: 88c014b1-607c-4a27-7f72-08dac642735d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C0Qbma8AmkgK7Pz3ym+l8X8cYj2PiPF2UVIWO9JVSlQGzdOuAFHrYSA36F+O4+JdYjgdovf2kmVv5qEuMEafgaBpyu3kYhbZr7Ir4scLCzp0x0hpMrMDb8BqlPX0daDMEBBIB2f9ReBsKzfq6Ts7vidoiOMtI0OCgYzStt9bUdTlP8P8f+DFswPME6iT967xJ1+GHiZgm/rVpcVTO9sqHnskaq3wENckIUBjExqZsrtHMPSNoS1deu9bUucfDz/1pk+P4Qs5k9xXuMWddwDxkfGugROQHs5AuEGLxNlAHdRoqPJwRbkkl+S+tWFRPh2U1cnNMRoIUYF/ojI8IPeqM/YXKOgDmp6aMX7vSGHpZMncwn8c5T1oKVmooMJjlj4BDiJncQTgkVSqLlYjIUMlIMluEeAl5XP5GGoUijg4NFRCcvJ8dqSEKJQJTzC9JhIopcJnm0ltxitThGn/rc9g1KmGC+uRhstBseshGvkYofSQVFR61ik9DxqTVc7F/PQc0Z/MNkK4iGv3s0z9VW4Dju88JDV1VvTgNNYXmVtlaKj7Pp1QQ8PoAX04IBQnpooknnpi98/14uWp4Pg6JBzeekKrtBOR1zvpc2HBuivmdpjpIWf/uYRIAqdnvHZnsBrsY3g9YcWZVHXaCSS82Uif6jyAYJs2RbOLjobIAzOvfrcQ1iIfSXdHEACW+/CC07rcBaSUl1ka550vU+g9BiF6k3ymSkVdRFgf5NNi21JA4GmhEslmCLxfYrFgU70opK+sszDDVZWqxlP03Gem3R13E4w3+pN8AhxBgg28a0MlsJY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(55446002)(86362001)(36756003)(2906002)(2876002)(36860700001)(8936002)(83380400001)(47076005)(81166007)(356005)(82740400003)(336012)(426003)(186003)(110136005)(316002)(6636002)(54906003)(82310400005)(478600001)(40460700003)(40480700001)(8676002)(41300700001)(70586007)(70206006)(4326008)(5660300002)(26005)(6666004)(9686003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 13:16:33.1526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c014b1-607c-4a27-7f72-08dac642735d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT100.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4874
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

On FLOW_CLS_STATS, look up the MAE counter by TC cookie, and report the
 change in packet and byte count since the last time FLOW_CLS_STATS read
 them.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc.c          | 39 ++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc_counters.c | 10 +++++++
 drivers/net/ethernet/sfc/tc_counters.h |  3 ++
 3 files changed, 52 insertions(+)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index bf4979007f31..deeaab9ee761 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -595,6 +595,42 @@ static int efx_tc_flower_destroy(struct efx_nic *efx,
 	return 0;
 }
 
+static int efx_tc_flower_stats(struct efx_nic *efx, struct net_device *net_dev,
+			       struct flow_cls_offload *tc)
+{
+	struct netlink_ext_ack *extack = tc->common.extack;
+	struct efx_tc_counter_index *ctr;
+	struct efx_tc_counter *cnt;
+	u64 packets, bytes;
+
+	ctr = efx_tc_flower_find_counter_index(efx, tc->cookie);
+	if (!ctr) {
+		/* See comment in efx_tc_flower_destroy() */
+		if (!IS_ERR(efx_tc_flower_lookup_efv(efx, net_dev)))
+			if (net_ratelimit())
+				netif_warn(efx, drv, efx->net_dev,
+					   "Filter %lx not found for stats\n",
+					   tc->cookie);
+		NL_SET_ERR_MSG_MOD(extack, "Flow cookie not found in offloaded rules");
+		return -ENOENT;
+	}
+	if (WARN_ON(!ctr->cnt)) /* can't happen */
+		return -EIO;
+	cnt = ctr->cnt;
+
+	spin_lock_bh(&cnt->lock);
+	/* Report only new pkts/bytes since last time TC asked */
+	packets = cnt->packets;
+	bytes = cnt->bytes;
+	flow_stats_update(&tc->stats, bytes - cnt->old_bytes,
+			  packets - cnt->old_packets, 0, cnt->touched,
+			  FLOW_ACTION_HW_STATS_DELAYED);
+	cnt->old_packets = packets;
+	cnt->old_bytes = bytes;
+	spin_unlock_bh(&cnt->lock);
+	return 0;
+}
+
 int efx_tc_flower(struct efx_nic *efx, struct net_device *net_dev,
 		  struct flow_cls_offload *tc, struct efx_rep *efv)
 {
@@ -611,6 +647,9 @@ int efx_tc_flower(struct efx_nic *efx, struct net_device *net_dev,
 	case FLOW_CLS_DESTROY:
 		rc = efx_tc_flower_destroy(efx, net_dev, tc);
 		break;
+	case FLOW_CLS_STATS:
+		rc = efx_tc_flower_stats(efx, net_dev, tc);
+		break;
 	default:
 		rc = -EOPNOTSUPP;
 		break;
diff --git a/drivers/net/ethernet/sfc/tc_counters.c b/drivers/net/ethernet/sfc/tc_counters.c
index 76a2e8ac517a..2bba5d3a2fdb 100644
--- a/drivers/net/ethernet/sfc/tc_counters.c
+++ b/drivers/net/ethernet/sfc/tc_counters.c
@@ -198,6 +198,16 @@ struct efx_tc_counter_index *efx_tc_flower_get_counter_index(
 	return ctr;
 }
 
+struct efx_tc_counter_index *efx_tc_flower_find_counter_index(
+				struct efx_nic *efx, unsigned long cookie)
+{
+	struct efx_tc_counter_index key = {};
+
+	key.cookie = cookie;
+	return rhashtable_lookup_fast(&efx->tc->counter_id_ht, &key,
+				      efx_tc_counter_id_ht_params);
+}
+
 /* TC Channel.  Counter updates are delivered on this channel's RXQ. */
 
 static void efx_tc_handle_no_channel(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/tc_counters.h b/drivers/net/ethernet/sfc/tc_counters.h
index a5a6d8cb1365..8fc7c4bbb29c 100644
--- a/drivers/net/ethernet/sfc/tc_counters.h
+++ b/drivers/net/ethernet/sfc/tc_counters.h
@@ -29,6 +29,7 @@ struct efx_tc_counter {
 	spinlock_t lock; /* Serialises updates to counter values */
 	u32 gen; /* Generation count at which this counter is current */
 	u64 packets, bytes;
+	u64 old_packets, old_bytes; /* Values last time passed to userspace */
 	/* jiffies of the last time we saw packets increase */
 	unsigned long touched;
 };
@@ -50,6 +51,8 @@ struct efx_tc_counter_index *efx_tc_flower_get_counter_index(
 				enum efx_tc_counter_type type);
 void efx_tc_flower_put_counter_index(struct efx_nic *efx,
 				     struct efx_tc_counter_index *ctr);
+struct efx_tc_counter_index *efx_tc_flower_find_counter_index(
+				struct efx_nic *efx, unsigned long cookie);
 
 extern const struct efx_channel_type efx_tc_channel_type;
 
