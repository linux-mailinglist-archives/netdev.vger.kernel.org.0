Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B49583261
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbiG0Sv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiG0Suz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:50:55 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB86ABE6E
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:47:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObA471f8wf7pEtCM46RPBja8mm4/ae8SgZrMKfcbfYCjFVKcAXoRsuTFsmahpzbS4rkGr79SmNzfbOntgoNckNpL6OHn0OyifZw5xGAiPG9QnaojHq6IoBgAQIWp5SB5liMu3koqdbCSxNbXaL4VvAMlktJ/P7d9bhYtghHiz6WHrdhbVOKYtjqMOQy0BTEB6BX5HLVh1DkyCn7OfohO5XHgyU5cVR7JFXRDFvI2o/1b2/8Aa/8wTgRJrv42ndh83jEtOiOBVCYhNSe4RLgUCrars7fym1XLveGzg0P/09XGnNP+NrLlWl1QHoPnEVnVASho5CidiK0NKFSXdUcnQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHgwljLfdYJ2/mmfLdsSo5WsvB6WAUWcUmPQlYkqf88=;
 b=OvR+UEDzjz1hN7o4raCuiQZaZUfBjvVkhv+wfWR2GXeR2gLd+JHdX7D51E1BmqTTkiFqDus1s8MR0YQOCefJnvZ9sylfrCbvaJ6aZOfCQLzk3TGuL9wASHMzCmzxFwFjWbMAt3b+j7b2koOfprcYmTTL4WU/0xkMhD3DoZ2n+3vOdDYkuNfyq0cGog5TnHiuHEmYah8+uyiJ6fGF2IwEIjxaG+MQlJfj8oDrHcIkNDbAmsgRrUfQt6z81Hv6gd/szYiQo/iBkd4YZzDgFyHxg5tm/L8vpSIfFUNG3i/wpMJeDhl4EMSeMZqXdqBvx54Ugv/k4qsqv7L4rjWovD5CQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHgwljLfdYJ2/mmfLdsSo5WsvB6WAUWcUmPQlYkqf88=;
 b=4iOTK6jWeHA35i57lJUBRXd1EdoHm33V1WuIRuGsGVY45jlctFXOSKpNFZAb9dot2f7ILZRK7GrjhjGFQfZIzcZaRfSDzNeHcOyHh30XMRKiEZMPQGRvJzi1f/was93ajX8iY2D2DNRn76EdLrWk8zUYbxF86dJ7M5Tit9tlatyV9gTYTA4/RokzYkfZi1RFOmeR6h0J/0uuy62TRycL/3d292w4bey0c59d0vUc4cP6oosePYAGQ0SdCK7v++9XTjs3rwU5MrwiqA+48AAt5SqeKwJp5ZOeCVvDjVtBcuCtuT5Cf1EQCfaQWJ3zskBB77K4iXw2JevW+/N50cMWvQ==
Received: from MW3PR06CA0019.namprd06.prod.outlook.com (2603:10b6:303:2a::24)
 by DM6PR12MB4975.namprd12.prod.outlook.com (2603:10b6:5:1bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 17:47:05 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::ee) by MW3PR06CA0019.outlook.office365.com
 (2603:10b6:303:2a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Wed, 27 Jul 2022 17:47:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:47:04 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:46:57 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:46:56 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 05/14] sfc: check ef100 RX packets are from the wire
Date:   Wed, 27 Jul 2022 18:45:55 +0100
Message-ID: <f2baf235d2e32d2195611b230a576839871702b5.1658943677.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658943677.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7efa69c-ea61-4bc2-3780-08da6ff804d0
X-MS-TrafficTypeDiagnostic: DM6PR12MB4975:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KL5wQQaOyVcDFmo01pqPTvWh478GZf5c4wpDmZA+O/aqQ7dSjf046tapOGn4oThJI8jUAN7EnDD7+ijOEDlQdDX1vVod6sR8yg2nsmHgCmY5omnDHT/xr8dvpV4/0xhOH0AyAcYUgZoThYvVjfDrc/662Yrpp/clUdSoyuKVehsGTCSMRhkGJUsJspxj4aFneMR9VUQkGcpYx112ADr4LOLaANa4dIE4Xnnm8BmL55FExI7JDHDbv91srNmNLGNRhSBd+lXVDnxYvZEFiyZ2UGzDIpO+0i6einF6jeSDOTgAmAx4pHcYihygFPykEIrM47IIWnN37oeZfnB0Js2r4dTTYfO1tXNi3PdPMW4VQbnYq0Foyh17chjZT7dif5g60RdgI50csQ7ImoU4mCuZVAPmwJFgJ5E5aKFL3MO9qLTfhQMm/PPTNvNSB2kB9d9NwyMFYkAytoA5K2+XQDpc4lflSTb7UdFVPVjySKZSOt6foJDICSNVzfBbx8vdUOPJ9MFKC0HIf1+yoNSp+ip4idpMvn5dzGYps61JWeVma7MDp5lAHOfG1/6/nl2Yto6+btd4rBrrZnsnwOi0id+ybbXQpAYVQlII+IIZtjJChPB04mwsq2Uh3hq3QiwvAceyG/TN4q517UpvCZcc8HUnMfqHgzUW76O4YSh7HFxCQlsWoqDkCM4ctjl08L9Y7u3C+DJ4Fk9ZM04nshbMsByS5MHZ4aM0l6eMzDrfzG5knubFfuKm9jjJSnMuiXQHTAW6OTXP8B7yX+IvVik2JP1CpPddPN9lOEIdxMEMtpx8/BpI2OwWhO2v5KPebBK6Av6P1S35GPU5tvtkAr+WnNYQzg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(396003)(136003)(36840700001)(46966006)(40470700004)(2876002)(83170400001)(36756003)(41300700001)(316002)(40480700001)(478600001)(42882007)(36860700001)(2906002)(186003)(83380400001)(82310400005)(110136005)(356005)(81166007)(54906003)(55446002)(82740400003)(47076005)(70586007)(4326008)(70206006)(336012)(5660300002)(40460700003)(8676002)(8936002)(26005)(9686003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:47:04.7798
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7efa69c-ea61-4bc2-3780-08da6ff804d0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4975
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
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
