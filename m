Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98556584643
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbiG1S64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbiG1S6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:58:48 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2080.outbound.protection.outlook.com [40.107.101.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AE37646B
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:58:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hx/ckODcQ0lyvHYJ9WfOk8QUPmexjPDn4m/xqU2b8PiV5h0v2nEXq48OXs6TtYH6+t93HyV9KMglTi/bhRTNUEIogeICgljz+R3OVN+bzxJj3afpoW/wf4AsZIkpunpk0IhYiib0g0IoCn8YicNCy2P+ufZ/KcBJyrekn7xo1xeIcBfhMCLakfWLIcL9GS3fviO4HWSeTHqwnsVDvVga+Jiwlav2bERpue1C7Y2dYx7Zz5BSLVdn/gRzExgZy5W9EBt+AosYwS9G0vGCxGXrO90DhuPgUWa7CQaQynySvqQI2aRUN2h/QaedpPBq0oCsRJVoNBlJR9zBxis64/AYQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHgwljLfdYJ2/mmfLdsSo5WsvB6WAUWcUmPQlYkqf88=;
 b=MoWvKQ16FKmI33mo4iSJkkLI357PDlzGFI2ztRTYs2EJLHzrU5DHU3GeS4Q4rDVlRqWN7ys8+0ZI3pST7v8Or9lq05MqHHP+Fxh/Wxk6ss/f5aGbiuFcjEMYkQOYPwZdmQHVBaDJ/XZv63kswvvKH6pnfrVbR8TNAbtoHrcMY/X5qVUlR9A/Sd0MNhNwUD10GuprcBjKHryazWhZvRI/9qh8tucbmuhfuENGkS8KkT2Z+bS7a7kzD7d0cDxZ+BogPyR4ldf6/dN/cCQojJunf59aAlP637cLHLgyaSFnecigDR/s8LrevspSLGpuU1CUyrmen+pDbx8DTGpo4xYEnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHgwljLfdYJ2/mmfLdsSo5WsvB6WAUWcUmPQlYkqf88=;
 b=Br1nxtHKlJI52eHz+iAeLnI4cjo6hPKgW3GaNCAnFKSasVByFdCD0YGqnGvfv9RvVy93y/FOzCBe8BdaOQE0NyW4wo0F/7JmhCncuN9+8ZqPGoXN+50JBUpqqGfuYN4GaDn7Mj+KlLR7QoA1jjevQc8uUa4bOKM7EO6KEySEZFn86aj/l8E/Q80dRxK7FmgS3C9rMvJR4tK5X3qgmyDPQzTXxX7qfIZzuQa1WA9cPkMo5zZQDsqeHx72JT6Khzqy+CHa9cx2MiGXtY/HYsLx8jdimRiwzkMP9lSi+UZVLoqb0tZLZuI+w5Qan6fASvBFapWLjrmv2olW46PWFFPpkQ==
Received: from BN8PR15CA0060.namprd15.prod.outlook.com (2603:10b6:408:80::37)
 by BY5PR12MB4179.namprd12.prod.outlook.com (2603:10b6:a03:211::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 18:58:45 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::f9) by BN8PR15CA0060.outlook.office365.com
 (2603:10b6:408:80::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Thu, 28 Jul 2022 18:58:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 18:58:44 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 13:58:43 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 28 Jul 2022 13:58:42 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v3 05/10] sfc: check ef100 RX packets are from the wire
Date:   Thu, 28 Jul 2022 19:57:47 +0100
Message-ID: <635300dea9828bef7f1267f68bd73978125d651b.1659034549.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1659034549.git.ecree.xilinx@gmail.com>
References: <cover.1659034549.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ed1450f-dbbe-4653-e023-08da70cb31d3
X-MS-TrafficTypeDiagnostic: BY5PR12MB4179:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7sl+OhSJoy3nvjP9xY24iJQ1qZorI9Ilge4EIKRnFsDnjCnfCqfG/fYHwM2fWQaZA3j5cNukYQC/P6ITjTOma7SF97H4pi/1RIu4U0j746T/04atR9itnJSnz3NhRv4dl6y7leqsRkMFYRC5HuSBmghaXDNKw6BBEZ+yvTMc3AbE3qofSZxgveDJ3hjcaLxW90LMM4NDxnb+FCskPpWY7QdkCbcpcItuatjjK3tsrycOqn9yWq+zFTDpTzADBDbf8fBePQKuTqkLKwPm2rz3rvPZktMuQuq2AtqsGEuax7DmtSXpLz+HAK1DT+r1CA7DIwZjcU0hzzNcnNy5KnQRtlhYrIjy4LPRxjKSA/SIKNOnEpS89u6DW3WciTPEb4fo3oJA+TtH9StCeB4bCn3V8zysUQ893z5Jca2kSQ/5PZlnm4sIS2HBb3s7iXrEG16Zq9pv6rM57CtVxuIPuhqVovXwmbpTuVEzHJhZqIYWaImjFol3Ns5nMQypJoNG6gp0Lw98D0rlZKCAMlMa+3/S+miN5rLg4y5m4axfXc5UEL7lMuanIQ7GwS/qfdiTN1p1Tu7QWHlkVbM+TFn1fS00f4eGADV344F9lrZNDCHZaXYORioS3HjIx4gBEBwjHdfDL6l4YvCdwwReSpnmt0F7QiPfzq7HXlIhY/gjIPewEUi037B6SOIZM4K6k/iZ6I87hcoonZ0JprWGHRJ705b6Eq2hdlb0VSLrbsEKhkXhc8u5mcT45kG9UV8dN0yjcCkp8aa9XufcyJryU4ekX2bxiy3Wz2ybCzB2ZLJcd2t9SRS3LmIDxtlqvDR8wDuEUBAhG2mQsZDGyPBeBLAjgxf2Sw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(36840700001)(40470700004)(46966006)(47076005)(36860700001)(42882007)(36756003)(336012)(5660300002)(186003)(8936002)(2906002)(82310400005)(26005)(2876002)(9686003)(55446002)(70586007)(81166007)(70206006)(110136005)(41300700001)(316002)(54906003)(83170400001)(82740400003)(356005)(478600001)(83380400001)(40460700003)(40480700001)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 18:58:44.2362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed1450f-dbbe-4653-e023-08da70cb31d3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4179
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

If not, for now drop them and warn.  A subsequent patch will look up
 the source m-port to try and find a representor to deliver them to.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rx.c       | 28 ++++++++++++++++++-----
 drivers/net/ethernet/sfc/ethtool_common.c |  1 +
 drivers/net/ethernet/sfc/net_driver.h     |  3 +++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
index 85207acf7dee..b8da9e3b7bf2 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.c
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -55,10 +55,14 @@ static bool ef100_has_fcs_error(struct efx_channel *channel, u32 *prefix)
 
 void __ef100_rx_packet(struct efx_channel *channel)
 {
-	struct efx_rx_buffer *rx_buf = efx_rx_buffer(&channel->rx_queue, channel->rx_pkt_index);
+	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
+	struct efx_rx_buffer *rx_buf = efx_rx_buffer(rx_queue,
+						     channel->rx_pkt_index);
 	struct efx_nic *efx = channel->efx;
+	struct ef100_nic_data *nic_data;
 	u8 *eh = efx_rx_buf_va(rx_buf);
 	__wsum csum = 0;
+	u16 ing_port;
 	u32 *prefix;
 
 	prefix = (u32 *)(eh - ESE_GZ_RX_PKT_PREFIX_LEN);
@@ -76,6 +80,19 @@ void __ef100_rx_packet(struct efx_channel *channel)
 		goto out;
 	}
 
+	ing_port = le16_to_cpu((__force __le16) PREFIX_FIELD(prefix, INGRESS_MPORT));
+
+	nic_data = efx->nic_data;
+
+	if (nic_data->have_mport && ing_port != nic_data->base_mport) {
+		if (net_ratelimit())
+			netif_warn(efx, drv, efx->net_dev,
+				   "Unrecognised ing_port %04x (base %04x), dropping\n",
+				   ing_port, nic_data->base_mport);
+		channel->n_rx_mport_bad++;
+		goto free_rx_buffer;
+	}
+
 	if (likely(efx->net_dev->features & NETIF_F_RXCSUM)) {
 		if (PREFIX_FIELD(prefix, NT_OR_INNER_L3_CLASS) == 1) {
 			++channel->n_rx_ip_hdr_chksum_err;
@@ -87,17 +104,16 @@ void __ef100_rx_packet(struct efx_channel *channel)
 	}
 
 	if (channel->type->receive_skb) {
-		struct efx_rx_queue *rx_queue =
-			efx_channel_get_rx_queue(channel);
-
 		/* no support for special channels yet, so just discard */
 		WARN_ON_ONCE(1);
-		efx_free_rx_buffers(rx_queue, rx_buf, 1);
-		goto out;
+		goto free_rx_buffer;
 	}
 
 	efx_rx_packet_gro(channel, rx_buf, channel->rx_pkt_n_frags, eh, csum);
+	goto out;
 
+free_rx_buffer:
+	efx_free_rx_buffers(rx_queue, rx_buf, 1);
 out:
 	channel->rx_pkt_n_frags = 0;
 }
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index 58ad9d665805..bc840ede3053 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -91,6 +91,7 @@ static const struct efx_sw_stat_desc efx_sw_stat_desc[] = {
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_bad_drops),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_tx),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_xdp_redirect),
+	EFX_ETHTOOL_UINT_CHANNEL_STAT(rx_mport_bad),
 #ifdef CONFIG_RFS_ACCEL
 	EFX_ETHTOOL_UINT_CHANNEL_STAT_NO_N(rfs_filter_count),
 	EFX_ETHTOOL_UINT_CHANNEL_STAT(rfs_succeeded),
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 4cde54cf77b9..6b64ba3a7d36 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -478,6 +478,8 @@ enum efx_sync_events_state {
  * @n_rx_xdp_bad_drops: Count of RX packets dropped due to XDP errors
  * @n_rx_xdp_tx: Count of RX packets retransmitted due to XDP
  * @n_rx_xdp_redirect: Count of RX packets redirected to a different NIC by XDP
+ * @n_rx_mport_bad: Count of RX packets dropped because their ingress mport was
+ *	not recognised
  * @rx_pkt_n_frags: Number of fragments in next packet to be delivered by
  *	__efx_rx_packet(), or zero if there is none
  * @rx_pkt_index: Ring index of first buffer for next packet to be delivered
@@ -540,6 +542,7 @@ struct efx_channel {
 	unsigned int n_rx_xdp_bad_drops;
 	unsigned int n_rx_xdp_tx;
 	unsigned int n_rx_xdp_redirect;
+	unsigned int n_rx_mport_bad;
 
 	unsigned int rx_pkt_n_frags;
 	unsigned int rx_pkt_index;
