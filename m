Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEA0621A8C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiKHR1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbiKHR0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:26:35 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB0F1DF13
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:26:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPSt0joG0P3g9PPHd0qtWSdc8woKYurmG48XwqdKva4GZ9uIXOV49eUcaL+R04jSmFsI2g6snag7MdR2NuCScxTH4tNqfRwXwKQrH8hf1j7iQ2tpSkoBuPOVgSLUxsHeUFTXSiW4oPAvu1mIxt5pq2b1ZD28t+ZQTZRSa03v0/slYowpqjxc3vcnxAy98GyEpxMamTofAo7iVpMY/oRcEv20AZIT6nxVzlD0ZbPcmTLGZimvYRgtivrWHlzLfa3uXKpd3Ki7yp+I/msWx4Jj1Gq23kKeCyVqxZU9ZBBo4QAiOGdu7JAvykL91JqtuJPseyA+ni7uHnvNqlqa7GEpaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=otn9FCXXyxZkHyzx6LWrupE9D6NMNNjDbTcjs1N3ALw=;
 b=SG5nXJDA3Ax6/cxIm9FC7JUtvL9Ap/Py8Vn6j1MNbYCZq57xxCMh2SA6Xfn8XnwWeDr94SwlcU0m7DmHFndZnLQORLT9QJ9knNIbDbVETPXRrhgaZbEbS+wsLU10AynfcaVdzvJgboipVhaLKOh6ruJN8Pa6/fpzjrJrmcZ9tfTFk1W8JfGSSP8gti7ho3wq95o23E+28DaKz17x6TeUQiCL7dSJ57cCpfqUkCeDn6UUvdL3HOCQvUq/xmjFziAiluTc9A2/R4rIF5zFdkDq5oFpvPpsrGtSBJr/yfMnasp9lOnlQVsEuYgIPg5hOW2OkVO1WOF8gkOBETO4Nn5QYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otn9FCXXyxZkHyzx6LWrupE9D6NMNNjDbTcjs1N3ALw=;
 b=e1wwivXkB3a5TF//gROm5c+Ml+75zFhYoJNO9ECOyysnwri39RV/2W9MALN5oENuzG6f1PoaN7WUtQLW4VNfKt12BLdYJrXnkiojxyMIMUF+LZuh9bWhzXD4um/F5i/8TQSbSiYpeMvoAU1pxrT/U2e96PzVkEPAX0Co+My9H/o=
Received: from MW4PR03CA0039.namprd03.prod.outlook.com (2603:10b6:303:8e::14)
 by BY5PR12MB4290.namprd12.prod.outlook.com (2603:10b6:a03:20e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 17:26:29 +0000
Received: from CO1NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::12) by MW4PR03CA0039.outlook.office365.com
 (2603:10b6:303:8e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26 via Frontend
 Transport; Tue, 8 Nov 2022 17:26:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT088.mail.protection.outlook.com (10.13.175.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 17:26:29 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 11:26:26 -0600
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 8 Nov 2022 11:26:25 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 11/11] sfc: implement counters readout to TC stats
Date:   Tue, 8 Nov 2022 17:24:52 +0000
Message-ID: <7144a877c276bf5dc64a4a4325f35939ca75c262.1667923490.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667923490.git.ecree.xilinx@gmail.com>
References: <cover.1667923490.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT088:EE_|BY5PR12MB4290:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e9af9ec-62b2-4427-dae2-08dac1ae5f8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GKvn9TH6AqMjQlO91YW7p8/+EsgUvziJ2o7BrryabsjFAjYjwt+P8biDKeEfhQxU78srGEu2CsBzmpAO+u1DDQ5VLOcgTqYfxk3I3sbyLRONnkbu+vdEP9XQRKh+Z2E4YBhjPZJsNYcILaopU0yiMQbn+4heUIrL/oDSToAr4HOve/wsGfG5nwPmIm4sOZkh+wlTxpSUgkyFHH5FVSdeuFNDa+owtGMtboI5qxfvf6v4EjTpXaIkrsBKxoJnRxn4Ow3jBu/XVBfcdTMrd7ODkaWwLavXfAekI/j5/M1tdDPvMriyqhavpghkJ5d9MReVVPbCsVdgcp4Rc8CYr0ydAbDoioNoyB2Rc9tRkwIRVt+vHAXTCYcSPT8H9JyjdkKnfI350C0Fz9f7h01Gb/t2RhdNMkFv7tB7GVz9ECw8oDicSF6Lu1xl5Oii5rYFuQZX15pZjNPLM+kF9YPusxOroY71srt929zWaCOD9AcaFueKpBOBjlhSGiadViCAe5dhYJOvWex8x+lbyE7ZW4JSTHDCImSc00cKOekw39hTMK1v1qM2JRtpsqfBz4MRm2a7bSECnovnTynMVdCVNmvtNXwxTZkY2yacecpA1PDOiOW3rpw+42KIqirIe0WOEB0fQn5JYHVpdbR8TEqZ5uhRCEgJPapAOJM9s7bXRm/XtrzcXQFENTYLwguqL2uVkRLMhkUvfMFXoFqBxGQGneStQ/GAbDqeWxYP5SiO7ona5R/oCRP3PoY9hwAx5Os/BfTLR4Meg6kPV9Pv03xMDiSTa70FrfxrqVFXJdaspvVZACQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199015)(46966006)(40470700004)(36840700001)(186003)(82740400003)(9686003)(26005)(81166007)(336012)(36756003)(40480700001)(356005)(86362001)(426003)(83380400001)(40460700003)(55446002)(82310400005)(47076005)(8676002)(36860700001)(4326008)(70206006)(2906002)(2876002)(5660300002)(8936002)(70586007)(41300700001)(478600001)(6666004)(6636002)(110136005)(54906003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:26:29.6517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9af9ec-62b2-4427-dae2-08dac1ae5f8f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4290
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
 
