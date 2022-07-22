Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11B957E422
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbiGVQGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbiGVQGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:06:31 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE6550738
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 09:06:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AY/x+mY7RrN2A9czqbOka/rvJTCBmaUyxpcs2iJZEopPvdO5vhL8c9sb0RH27t3wcK9HUX+tQfPd/kCR4zYv4wBo6Y6Cx6Y79bUm7QED1FyscZ/jzAoterVgO61xnZcJHKhr2Q+TwgIINu0wVS9i62CHLVfdnn6NaMTLMeEy5Fxq8sPOfx3Py+f7eTmtv5qy09omjat7aaT5VNR7IH5Ze+3mnU8Zf/mIqDeIZxlLLp8yTWkaiTM+35hJryE+mjHwVOPWUFAzlQPo/FHM/ZIQmIBk4yF6OGhaw63svZke5/v5gJ2Wm9VQ3hIoXZoElpoLk7jKb3tAHz1jQzIHqAirzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHgwljLfdYJ2/mmfLdsSo5WsvB6WAUWcUmPQlYkqf88=;
 b=Dk1dvo5sridWPOZKZNJS2c7wTAz3BQGqjcdZIaU9kiCyEhMsPPejsK7bGbCdyYl11D19KK1RxkD9Ziwj+DpbypMdY1MvvAG6wGLX1M4PKx0HCZGnnieX8YObaVEM97gOK5b926DF7+YSt+ya/aDPfeA4bFKNXlPUwF0vlB/HlTsLgw/s5zVvfPUXezbUhM7gJ0oeQG78cHMjqdxsVGYDDWC/+bULLGooTwke08ECwZu0oiR+50uMP4rossVKox3zNCf2MiBRVLH9H/aFXWLIblE2DXiYpyKDfFPMWGZGsficANNV3Bjlprp8OEav6mBit/vsqto4wowpYkGVK8jxfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHgwljLfdYJ2/mmfLdsSo5WsvB6WAUWcUmPQlYkqf88=;
 b=gUYwY7EVJUSTM1J530GttJq70/maWqk1GXn9NIW8VI+Hxb/RArscdI4RqmQgGn8hlNoh5meyiaInae3UkSzz1ujKbHyGqxKI6Ws/Pb1+FMsuW3/q202JLGVVrOsz8zYc9vrwv/imT6EsBqFPIYfzWRFXyaHkWdBYctaccXpP7b53zdN4Q4J7hxl1xk96/C5NDEzl4XLxvYGlm6+IaFPcUrr2rF/6JzdzZz+o7i9dPSO2g9AoZ1Rnm8Xot9xA9fb/3BUP+66oDBRP36qq0UhZLlpRBTE0FkG0/NQN8dzbtkWDqxMMI3cy6EhXzQQzRdzqTrRBPdN/WmnINFiDW9CaGA==
Received: from DS7PR03CA0049.namprd03.prod.outlook.com (2603:10b6:5:3b5::24)
 by MN2PR12MB4016.namprd12.prod.outlook.com (2603:10b6:208:16b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Fri, 22 Jul
 2022 16:06:26 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::6e) by DS7PR03CA0049.outlook.office365.com
 (2603:10b6:5:3b5::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Fri, 22 Jul 2022 16:06:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 16:06:26 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:06:21 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 22 Jul 2022 11:06:20 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 05/14] sfc: check ef100 RX packets are from the wire
Date:   Fri, 22 Jul 2022 17:04:14 +0100
Message-ID: <4418ea846c849bff8c5b9255775a4e1380d89985.1658497661.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658497661.git.ecree.xilinx@gmail.com>
References: <cover.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86c0c84a-ea2f-4819-c036-08da6bfc21af
X-MS-TrafficTypeDiagnostic: MN2PR12MB4016:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZdnjB8v2XZt1QFD8VADiykU3H5mB3UfPd3iVx7I6FTrgfxjBkQRvj2gY+QUuH49bWCs/r4ZLL2NTS7r5/jVzHhkHiVMw27r3QOpX6Q0gLaVqgdROBA+QE1/jSQg9CX0o524EULD1/wbuBz4g1jzU4L9uRVcn8LIZUF55maDtDaK460GGnBO/gx59tHpVmFOeLO/m+iecpSXgcfyxZaRamZ4G/J09FB4kDuKLNeTlpIXBhnKuDKffk1bP5BS1BCUAPOcPKe+rntvsf0T5aTGY1EdEYF7/W6GmLQS0EzzNsYcJei4Iu5MxRuhsPwuqNHWkNzdUOYXvo78NTL8CamfEOZtVsVKGSYOmYiHy4fepN2Hb1soslll50ThTetqPDwt53pKt6nbWAQhWIiw+KxM0FzT/cccs02dUSEPZ2quQPlk+fgPmOERrZm/yVb6Mj9LXVtwTG860L5+Nqp1Z8o3cqpAUUzkJxjm5pIg8SvbMaBJPqleG1HEmIFFeZB+TGtDdyg1iwuVvB4/h0evUYTljRHECQ3Dc/ywgkgO3t2rhYUP288f9t9EOQ9DjT8AaLdukZlel1scImR07oC/Iun2jXJJliGib01Wo513W4d9fWtikXJ2TcaRz9seRBpMm+EdGwc8TURovviuny8EDGksAis8ou5xmjpJeEVAurnZ+ArRdeYG6guOqGl4PCZHGf0amOE0k8dYj0HuGQ39hEqxZnOflnPqqJIYVqAOxGx44t5SVdVZjMndfNv83cKXzJb6TVq8qb1NzUaKdamGxgwJnXT6q0rBLW39dyuCd3oAhjgbr40xbutMa+0dmA5nHGZCh+yFV+k/tqia8mjH7lpVO3g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(396003)(39860400002)(46966006)(40470700004)(36840700001)(82310400005)(81166007)(36860700001)(55446002)(83380400001)(40460700003)(82740400003)(478600001)(316002)(356005)(8936002)(5660300002)(4326008)(36756003)(83170400001)(42882007)(41300700001)(54906003)(70586007)(47076005)(40480700001)(186003)(110136005)(336012)(70206006)(2876002)(6666004)(8676002)(2906002)(26005)(9686003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:06:26.6349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86c0c84a-ea2f-4819-c036-08da6bfc21af
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4016
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
