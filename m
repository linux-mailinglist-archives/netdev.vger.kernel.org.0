Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6034C58466B
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiG1S6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiG1S6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:58:44 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ECE2A71E
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:58:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtL0czTHgpibfkM9+TA1PJIYq4M+LRzj8cqC84mjQFT3u6fkeHzaogowSPMBaJK8gVq1sz88bTjIM8IjIYlrzsf+f17m6xlBBRMgPxWLb9HuTLMVTu4uWjZqcKhyYlf77b57Zi5M6ReVImFXObSxcHAWMzUNLH8ElKYF+qu2dLt1xtuFpKuooDhnGA8hnc4xUygClti0Ilgs5X8T0WqLYL/Ysxjr7jmnSue1GXyHKZoqwg15d96HSw6FZ5VwsBzpmlJfVvmw4mlco8H92+9xVDHC6nW5ggeLHRurC7ehvindMy7EMVCAt058ZweZYrZf6JCvpiKXP4uvNfeV4N/1DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DggtUei1bA7tcaYBGILcO8uL6PwnvobY/ZfO76mhf5U=;
 b=RHj1lFI3WVBAo7uDkXh5v9CgTfj88xbZ7jXfsYNKRuNyFsHZx3RfXqlXbfiotloXntABEhGVk7DEf8i5HUgOFSwE8zeMCU2WkVPEP+xaGi8Yf1aRghxo1Ph5wLd82ZLarvfBcjQ7qdgWC6hpsdCSeokS0AFMA3L30q/B9s3sHdFkw+W04AZpA/eTMCh9FKCX3agFmIiSU+8FgnQZjrQOBgFFBMjORQI5tzOvG/yFHFEMPRdGBFRLR/WJh3GDS1Oo8pMVpmuesCct0N0nTf1Ys0kMgBvWzJmRx2d+rT6fY/vwYhuHaz89zoKDKvP21rrK3vyjCg38DMNUIsAt/SOCAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DggtUei1bA7tcaYBGILcO8uL6PwnvobY/ZfO76mhf5U=;
 b=2ETM854S0z7m1nQF1gLe2n0jiM/OpEZ3bmMH2ji/fu8HMkzDqA/2xNO6v7rXiweoa347g+qEzH5vcKq/UdoG+sT6otjXb7xJMZY3Xt1VQsp4VohuB7hwtEdB2osytc2xLn3bATaeCiLcIQrVyMXblBlsni6Wv4sKjTcsLOGl1Tr+Yw+MfkGFsh1L16G+nFQH6khbmEjn1PdxPF5+wccbxonW97e/K8b03heo9jfTJeSdmEElFNT0FUOYwMjJvHColGukbcZs2ySRy4LXxIOmNGYiS/UZbrQhq+L+SvVRrf/BclCWnuDDh4X9G58bsM4kyFXZ3T96ZDGPNEe/FRY2mw==
Received: from BN9PR03CA0116.namprd03.prod.outlook.com (2603:10b6:408:fd::31)
 by CH2PR12MB4022.namprd12.prod.outlook.com (2603:10b6:610:22::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 18:58:41 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::52) by BN9PR03CA0116.outlook.office365.com
 (2603:10b6:408:fd::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.23 via Frontend
 Transport; Thu, 28 Jul 2022 18:58:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 18:58:40 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 13:58:39 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 11:58:39 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 28 Jul 2022 13:58:38 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v3 02/10] sfc: ef100 representor RX NAPI poll
Date:   Thu, 28 Jul 2022 19:57:44 +0100
Message-ID: <5057a124182d9e56ce2195da586cd4f184dc232f.1659034549.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1659034549.git.ecree.xilinx@gmail.com>
References: <cover.1659034549.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27aa2d50-3a86-4afc-b818-08da70cb2f9a
X-MS-TrafficTypeDiagnostic: CH2PR12MB4022:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lexg5Vdke4gPRWEnD1Ig8PPfkFtkLNRB797Ld2jXdtCDDSxwiQWRXzt5gYtdKJsPMNdcDsy9/0AkVJNM877QnjtYTa2TUh7TWBTHvZRgr+SSCzlfzsLfUuBN2G8bcSqju+ECjmbmqqec8ShLdn62bFBpCJCbhgw2flYiFCS8NvTjoTpuYzlhm9xt13/vVYYhAX8430SaskV/PFKhXGusBdYTBi3I+uodFmE5l8QTqxpeatRH8Wy0MGnj1vgJhje+TN+03o8Jw2kejXrSsP3nBgrdb3aT5Q5jYL6VVld+KD7ehX1CxD7LKT2sO76XDqqyyHe9yN3m3Rksh1HvBnWz5WBimlYnIRT0hv2ZK/AiipOdYi59v4t1jO6XQ8qCpWiC3BANzceeQVvVoIBW6qlpQqMLBEtOf4LTRPuan3U4pgAIsOe04vEdiiQVG7+axWVsyFgGe4OeHrVShSNJvpclKX6pkWRO5L6rMENSamhOyOPGIxGEY3SBvDgvFWUcX3BLpbmQUIKimXElEcDRE1ZtG+4M8nKh/5VHwIJc/1qCzOpDkaxX6MxOtelmUTo4yenBM8U69E+j2pl0tvh9M/ohMmnD2s+poBC/6W8pVMgxipD2G2elq17Zr3unHHM2agtM7N5X1DOMITzsNF62k0RJTEIgOusiiOrP5Idwp0WFTZdJp7Rbaf5tAChPIs0LdryOzDhGj8Elw4ulDMl7/PL0XHNLYbIpYs5DW8O4/4FlSSMn6u5JYOnWyYx0OjtXge4WiVo0IEBh/dqgwYryf+iQZpXrKpqgSXf9Zwsk/iYomtP+IcCugaJe//XXehl2CeGA+0S9ckD1etg4QezzCvQWXA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(396003)(136003)(46966006)(40470700004)(36840700001)(336012)(47076005)(110136005)(186003)(83380400001)(8676002)(316002)(70586007)(42882007)(70206006)(26005)(36756003)(9686003)(4326008)(54906003)(6666004)(2876002)(41300700001)(2906002)(82310400005)(40460700003)(55446002)(40480700001)(36860700001)(5660300002)(8936002)(81166007)(83170400001)(82740400003)(478600001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 18:58:40.5062
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27aa2d50-3a86-4afc-b818-08da70cb2f9a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4022
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

This patch adds the 'bottom half' napi->poll routine for representor RX.
See the next patch (with the top half) for an explanation of the 'fake
 interrupt' scheme used to drive this NAPI context.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c | 64 ++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_rep.h | 11 +++++
 2 files changed, 75 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 102071ed051b..fe45ae963391 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -16,12 +16,16 @@
 
 #define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
 
+static int efx_ef100_rep_poll(struct napi_struct *napi, int weight);
+
 static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv,
 				     unsigned int i)
 {
 	efv->parent = efx;
 	efv->idx = i;
 	INIT_LIST_HEAD(&efv->list);
+	INIT_LIST_HEAD(&efv->rx_list);
+	spin_lock_init(&efv->rx_lock);
 	efv->msg_enable = NETIF_MSG_DRV | NETIF_MSG_PROBE |
 			  NETIF_MSG_LINK | NETIF_MSG_IFDOWN |
 			  NETIF_MSG_IFUP | NETIF_MSG_RX_ERR |
@@ -29,6 +33,25 @@ static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv,
 	return 0;
 }
 
+static int efx_ef100_rep_open(struct net_device *net_dev)
+{
+	struct efx_rep *efv = netdev_priv(net_dev);
+
+	netif_napi_add(net_dev, &efv->napi, efx_ef100_rep_poll,
+		       NAPI_POLL_WEIGHT);
+	napi_enable(&efv->napi);
+	return 0;
+}
+
+static int efx_ef100_rep_close(struct net_device *net_dev)
+{
+	struct efx_rep *efv = netdev_priv(net_dev);
+
+	napi_disable(&efv->napi);
+	netif_napi_del(&efv->napi);
+	return 0;
+}
+
 static netdev_tx_t efx_ef100_rep_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
@@ -93,6 +116,8 @@ static void efx_ef100_rep_get_stats64(struct net_device *dev,
 }
 
 static const struct net_device_ops efx_ef100_rep_netdev_ops = {
+	.ndo_open		= efx_ef100_rep_open,
+	.ndo_stop		= efx_ef100_rep_close,
 	.ndo_start_xmit		= efx_ef100_rep_xmit,
 	.ndo_get_port_parent_id	= efx_ef100_rep_get_port_parent_id,
 	.ndo_get_phys_port_name	= efx_ef100_rep_get_phys_port_name,
@@ -256,3 +281,42 @@ void efx_ef100_fini_vfreps(struct efx_nic *efx)
 	list_for_each_entry_safe(efv, next, &efx->vf_reps, list)
 		efx_ef100_vfrep_destroy(efx, efv);
 }
+
+static int efx_ef100_rep_poll(struct napi_struct *napi, int weight)
+{
+	struct efx_rep *efv = container_of(napi, struct efx_rep, napi);
+	unsigned int read_index;
+	struct list_head head;
+	struct sk_buff *skb;
+	bool need_resched;
+	int spent = 0;
+
+	INIT_LIST_HEAD(&head);
+	/* Grab up to 'weight' pending SKBs */
+	spin_lock_bh(&efv->rx_lock);
+	read_index = efv->write_index;
+	while (spent < weight && !list_empty(&efv->rx_list)) {
+		skb = list_first_entry(&efv->rx_list, struct sk_buff, list);
+		list_del(&skb->list);
+		list_add_tail(&skb->list, &head);
+		spent++;
+	}
+	spin_unlock_bh(&efv->rx_lock);
+	/* Receive them */
+	netif_receive_skb_list(&head);
+	if (spent < weight)
+		if (napi_complete_done(napi, spent)) {
+			spin_lock_bh(&efv->rx_lock);
+			efv->read_index = read_index;
+			/* If write_index advanced while we were doing the
+			 * RX, then storing our read_index won't re-prime the
+			 * fake-interrupt.  In that case, we need to schedule
+			 * NAPI again to consume the additional packet(s).
+			 */
+			need_resched = efv->write_index != read_index;
+			spin_unlock_bh(&efv->rx_lock);
+			if (need_resched)
+				napi_schedule(&efv->napi);
+		}
+	return spent;
+}
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index d47fd8ff6220..77037ab22052 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -29,7 +29,13 @@ struct efx_rep_sw_stats {
  * @msg_enable: log message enable flags
  * @mport: m-port ID of corresponding VF
  * @idx: VF index
+ * @write_index: number of packets enqueued to @rx_list
+ * @read_index: number of packets consumed from @rx_list
+ * @rx_pring_size: max length of RX list
  * @list: entry on efx->vf_reps
+ * @rx_list: list of SKBs queued for receive in NAPI poll
+ * @rx_lock: protects @rx_list
+ * @napi: NAPI control structure
  * @stats: software traffic counters for netdev stats
  */
 struct efx_rep {
@@ -38,7 +44,12 @@ struct efx_rep {
 	u32 msg_enable;
 	u32 mport;
 	unsigned int idx;
+	unsigned int write_index, read_index;
+	unsigned int rx_pring_size;
 	struct list_head list;
+	struct list_head rx_list;
+	spinlock_t rx_lock;
+	struct napi_struct napi;
 	struct efx_rep_sw_stats stats;
 };
 
