Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E520C58325E
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbiG0SvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238575AbiG0Suu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:50:50 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F024ABE6B
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:47:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIYP8mEf+Adi2I8UXMshX5sscnl/2IdRNMscMqc553Pi0ZichTGL+R905PYgdDBze+Xg8W2wLyxjWHyu4UXgaeCpCTCUo/LG6Nal47Uav5DkH2t1zhvJh0NYmAf2UI0t0KmqjZlKB2u4ahXERtFE7KpTg0tTq2T/gV09QACo6NwmnXzIk71q9/spV9PCBxEdmx68f69JUKQ5K9bopWnth0StqxdyelRcTyqUCOLe5HdCcbSpJSRLnn72LutkO8QYgb54E+jCimXLiCvrFrWIfX1RR2Jp5JKR3yfLV8PDEMFubdKt+wWN/vKgCNsazJK6uQUPLWHr2V7HCoFUt9FX8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1BOn3ovXjF5eBdA59lopxEnBIhV4f4pluGlLUojo/Q=;
 b=iXo2E5Pz8g6TTJB+exGeHtKANgrDE5/Efy70u74ZxO/V90PdIKOxXUJtJDVOp3Pupr64iKovQmS8kHRA0rhqH4nV1gRa/2O4b+5pqwZqU8jVTjXNYCiLw6HF0Cu2cr13+c9zet1EIRBBd+D5mDRcxum/uxL3T2QLdDLiaAxyrWg1KFfCtIFNcMrq4FGxRESFy2XytSgrs+xwON5WS1TYnOw88X6EZfKCC2J1PJxm8n73iKQ7R1DPV32Xg6TszcL46TQCoxA/2lL8VD+6eiQIAyLSCmJcsFpvo0+khTK7BJ+aVbzdZOBpROE8V+ktifReoU6mXGO3WxZB0E38RYWSyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1BOn3ovXjF5eBdA59lopxEnBIhV4f4pluGlLUojo/Q=;
 b=PdieT18kFOmREcNag7LbKtN/Cm+iLSYtBKNwY4VtkQ3rEKyWwexU6BlxLd+hmuNb+vUcWavWnLyBRc5mgGo2RBnRH06fR+zFzMWlMhe6YIyaQkC7Z73RymcaWHix/BCMwnkY6wURjFaE4LjcpYay9BxaUT2Yre67QW2qv4MVlUReoFiUxWCLfhEIuypVbH8KyN3p2LhH4DHkOQWKnrcD5gGVYnTpsptDHF6Z89HtzhvdQEpo/kIZKOqhRRJGyN0dTJmK5bGf635Kcnlbr9IiPk9NKGIDxo/BZbhUCs+2qc88+gWC3X7fslhOOHkv9u9K4sDRDqLMCBZpDZccHlZpaA==
Received: from MW4PR04CA0310.namprd04.prod.outlook.com (2603:10b6:303:82::15)
 by SN6PR12MB2798.namprd12.prod.outlook.com (2603:10b6:805:69::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Wed, 27 Jul
 2022 17:47:01 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::fa) by MW4PR04CA0310.outlook.office365.com
 (2603:10b6:303:82::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.7 via Frontend
 Transport; Wed, 27 Jul 2022 17:47:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:47:00 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:46:54 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:46:53 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 03/14] sfc: ef100 representor RX top half
Date:   Wed, 27 Jul 2022 18:45:53 +0100
Message-ID: <dc5b3793c268e48c7b3250d237bfd66d15f59638.1658943677.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658943677.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1531c38-6012-400a-3edd-08da6ff80251
X-MS-TrafficTypeDiagnostic: SN6PR12MB2798:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlQp1j4HVGlPwsDFA+mDyo+Ht9ml7v8FvNRH7qu3ILEua1pxj8TW5QkWxzngs9RcVvasn/4zTexBEE+6H0Qk382HUNBFeDqinSJGWnLUNTZZl6cI0Ayg4JrtVdeL8YZf3SSypCvS+tTcJ3NjgcNqNkoTFPzrACqtr4tsMvYTxenOp7YxoHQPmQomVTUopwHF3CtKPX7riVG8nz5YmEX//x2WGBHQiwKuXtQxEqzOPugv41Uf/V84lFg++K+m17iRLbye13jWmvP4EXH4Hb540+L5jUYW2Gi9vloqxtlE/I+YVU0C2X9RbEKLFkLZmcsj4/0ZkSE5Ji1xxs7sl/LXwdQRKf7pwbSpSxeugX+Lb9ULuQpeVSyu+t/RyFdWW7CT0AJ8HM1FqmvH7YJ0faI+4BfnimOW1QXZEYoynWr3PfhMF1L3EIzMOYWw9i/5ED24NZptynwHPAWIWWGbWw6xHExlk6YJ73fQKzHib4sIznTjGghmBulMJmzaW+bBLbqlE6GCn0lA0kSkKcDCRjJa2j9e0e2HHfKuH38Zd2I3CLeyjGKJhbZ0LlgLvQhqNo4zG0Op1WIJnc6qkZsKVxi/DoK62d0cWzaCb/uoOW5+IYnBLeivb0T7aLnwo4q4jCiDQYkt/8s3HDOTYUBOmXSdFoUft1v72fdRVD/VsV4cXhV6wnyXDe5GeKxClbj/OMiQJbaIeLmH/uvihaR5m73/geUol7mrG/Cd6+Ke1dwOGdPdmPG6O4u6MkeI18soDucJ+BcaAR0Cyh1bJRc3HJvv2NyxrZh9VWJm0lJId9ZUI+cRYEA4vY0Xr3v0zi5fEcN3Q6tKaBvydu+KJwhMSsg5ew==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(376002)(396003)(46966006)(36840700001)(40470700004)(83170400001)(336012)(47076005)(82740400003)(36756003)(81166007)(9686003)(316002)(55446002)(110136005)(186003)(54906003)(42882007)(478600001)(26005)(4326008)(70586007)(41300700001)(82310400005)(2876002)(40460700003)(5660300002)(2906002)(8936002)(8676002)(70206006)(40480700001)(356005)(83380400001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:47:00.6079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1531c38-6012-400a-3edd-08da6ff80251
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2798
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Representor RX uses a NAPI context driven by a 'fake interrupt': when
 the parent PF receives a packet destined for the representor, it adds
 it to an SKB list (efv->rx_list), and schedules NAPI if the 'fake
 interrupt' is primed.  The NAPI poll then pulls packets off this list
 and feeds them to the stack with netif_receive_skb_list().
This scheme allows us to decouple representor RX from the parent PF's
 RX fast-path.
This patch implements the 'top half', which builds an SKB, copies data
 into it from the RX buffer (which can then be released), adds it to
 the queue and fires the 'fake interrupt' if necessary.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c | 55 ++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_rep.h |  1 +
 2 files changed, 56 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index fe45ae963391..e6c6e9e764b2 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -13,9 +13,12 @@
 #include "ef100_netdev.h"
 #include "ef100_nic.h"
 #include "mae.h"
+#include "rx_common.h"
 
 #define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
 
+#define EFX_REP_DEFAULT_PSEUDO_RING_SIZE	64
+
 static int efx_ef100_rep_poll(struct napi_struct *napi, int weight);
 
 static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv,
@@ -198,6 +201,7 @@ static int efx_ef100_configure_rep(struct efx_rep *efv)
 	u32 selector;
 	int rc;
 
+	efv->rx_pring_size = EFX_REP_DEFAULT_PSEUDO_RING_SIZE;
 	/* Construct mport selector for corresponding VF */
 	efx_mae_mport_vf(efx, efv->idx, &selector);
 	/* Look up actual mport ID */
@@ -320,3 +324,54 @@ static int efx_ef100_rep_poll(struct napi_struct *napi, int weight)
 		}
 	return spent;
 }
+
+void efx_ef100_rep_rx_packet(struct efx_rep *efv, struct efx_rx_buffer *rx_buf)
+{
+	u8 *eh = efx_rx_buf_va(rx_buf);
+	struct sk_buff *skb;
+	bool primed;
+
+	/* Don't allow too many queued SKBs to build up, as they consume
+	 * GFP_ATOMIC memory.  If we overrun, just start dropping.
+	 */
+	if (efv->write_index - READ_ONCE(efv->read_index) > efv->rx_pring_size) {
+		atomic64_inc(&efv->stats.rx_dropped);
+		if (net_ratelimit())
+			netif_dbg(efv->parent, rx_err, efv->net_dev,
+				  "nodesc-dropped packet of length %u\n",
+				  rx_buf->len);
+		return;
+	}
+
+	skb = netdev_alloc_skb(efv->net_dev, rx_buf->len);
+	if (!skb) {
+		atomic64_inc(&efv->stats.rx_dropped);
+		if (net_ratelimit())
+			netif_dbg(efv->parent, rx_err, efv->net_dev,
+				  "noskb-dropped packet of length %u\n",
+				  rx_buf->len);
+		return;
+	}
+	memcpy(skb->data, eh, rx_buf->len);
+	__skb_put(skb, rx_buf->len);
+
+	skb_record_rx_queue(skb, 0); /* rep is single-queue */
+
+	/* Move past the ethernet header */
+	skb->protocol = eth_type_trans(skb, efv->net_dev);
+
+	skb_checksum_none_assert(skb);
+
+	atomic64_inc(&efv->stats.rx_packets);
+	atomic64_add(rx_buf->len, &efv->stats.rx_bytes);
+
+	/* Add it to the rx list */
+	spin_lock_bh(&efv->rx_lock);
+	primed = efv->read_index == efv->write_index;
+	list_add_tail(&skb->list, &efv->rx_list);
+	efv->write_index++;
+	spin_unlock_bh(&efv->rx_lock);
+	/* Trigger rx work */
+	if (primed)
+		napi_schedule(&efv->napi);
+}
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index 77037ab22052..7d2f15cee8d1 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -57,4 +57,5 @@ int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i);
 void efx_ef100_vfrep_destroy(struct efx_nic *efx, struct efx_rep *efv);
 void efx_ef100_fini_vfreps(struct efx_nic *efx);
 
+void efx_ef100_rep_rx_packet(struct efx_rep *efv, struct efx_rx_buffer *rx_buf);
 #endif /* EF100_REP_H */
