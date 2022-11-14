Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C757C628107
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbiKNNQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236774AbiKNNQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:16:25 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D253BC28
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:16:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEqZIwnrK8JIJMEAGS6y/tci2E0NwE4DzB8xQdrShjD52y+NekypUxiaKm26iwuNdDfMMCJJX2sPHiJR/90/qSKrZ+ceHMziElfKZ6yvZ/qkPVkyaVbb3KmHQ9KOGkz9Ys+vGmbdshJPT/HGRzj66lZEIusekQCgydBfAu71uLLLoYKacWnQs/2ya6VMXRty+ChOuaT7V+QprpYF1/E8BLWNdr5KKPp3R20fUgPBrE5QUw6U7CKez2jHm/7ayxtrmPLiua9/sB/hDIWuYnH4xqv2KXKyGcW38VFvoPt3saOUDZtBnj3MkBfetzOyz0L0oHM7T8cH2OVCPe1tmmhjQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7BjGmf7CnqlHV6DpSb9csCWA/Df9kMKuSOyDBIN4Vbc=;
 b=G8g2PbiKOZGqRHHW8Xa/vbV2+myKAFy0aQxbFnRIkVDAjhB5581i1Vk3roOZ2chcGPqCvQOXtCqcvLl/4cGNTaO2eYpq4j/xHoueQM6uCDfuaMyIaDLND16PYWYCxcv8MSZ5t1D+dok2W7dpiz84QMjGNV5mTeubTvWctzCop91RhyRQKIJpw1trO0rK2p9VqfJBYCaWDU6r4Zovq7EOdFh3wLSe4Ot37UgUeq1evtLZaQgwmLEoUwLcxBTc05g/DrgiScM+EFiMCwG9O6beAvMcQP0TKIkMd7jnzTWpmc4o/EFtpB9UTXpw6JqUKMxwh1WeyCUkff/E8jdPG1ZGXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7BjGmf7CnqlHV6DpSb9csCWA/Df9kMKuSOyDBIN4Vbc=;
 b=z4aqW9Z5XeYH0Y+QUUWCkWdyOPt2LrZ9hdq7VF0Aibi7tX3WPFZarci2FDgQ1QTKBRBWAGJEIaUg/e7kUzKGZ5i5d4pXt8yJ9ND3aPA+Y3Cp5FW8D+BkYdAVXBakH+tUcN4mxQVoMl1qZLIqrbOXbdPOeGhbgX8MBb1qRdQ0YZA=
Received: from DS7PR03CA0283.namprd03.prod.outlook.com (2603:10b6:5:3ad::18)
 by IA0PR12MB7697.namprd12.prod.outlook.com (2603:10b6:208:433::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Mon, 14 Nov
 2022 13:16:21 +0000
Received: from DM6NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::d4) by DS7PR03CA0283.outlook.office365.com
 (2603:10b6:5:3ad::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Mon, 14 Nov 2022 13:16:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT090.mail.protection.outlook.com (10.13.172.184) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Mon, 14 Nov 2022 13:16:21 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 07:16:20 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 05:16:20 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 14 Nov 2022 07:16:18 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 04/12] sfc: add ability for extra channels to receive raw RX buffers
Date:   Mon, 14 Nov 2022 13:15:53 +0000
Message-ID: <15d47ffdd878dedb726abbc27a0932b6080191e9.1668430870.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1668430870.git.ecree.xilinx@gmail.com>
References: <cover.1668430870.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT090:EE_|IA0PR12MB7697:EE_
X-MS-Office365-Filtering-Correlation-Id: cfc5d5b7-a8e7-4a7d-997c-08dac6426c5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YSYAiLM3dBc/3OaERImj2Y+r8nSflwG++xrMJk2WQ2R1ZFrUNWkE6Lo0RhCQjkx0j/ZZs4j0k0jMYtfGDpUMBZWERccJ1We0KIcqNpbmgHRo+Kd0Sy/tuWJQTHOO1yPxtBdftZuCjbpvRqU1kL/oj2eZmlazyXqLFObw5jlmo5TmWPuqylF8jHmudq7/lUaRbLDP9JgQIDJCkRTFbxHvDdg30jCYU7ma7yz7GrtYZ0qyvZ9cs+wu/IW5aZFOoscnCuYatxkoxbhjBd789r36OgYVVmFvBq4M+kF7Px/jUjOS6PuElb5nGOIWorQZd4y+daCQebhjY2JsjkIWD/lID9ENKNfAu4fcPXt00q9Vw10k4CBfyCnakhx/24QjiVW+Qz4BFX646NALJwFXh4c3xv/Lzv8cXITmiXIpoPT3nQ0lAwjELWSBNDfcx9ESbyJmULlnqmwb0xm0kd2adb02ii9+LK/x3kiDWhdRwFW7XrA+5V7+gE8c2+UnlzEkqEkloOfuy4fDGzLCkUhV4B/nHdHnwCNSX7gQweHPh2QXbaf5ELoRmAUPKfL3Kuv4XOFncnCFX4DiALnUYKjFk0qgQhQlWJf/xZUcsC0vXrZrXefYY1tQJlinzx91Hpfw2uJVSD7DUry9cCzVBG2lXmu9MHoVwPMUIH4syHtu4x7OmRyOjfa7JmhomVQLKgjTMwWWDpKynIsHODJs2JYFPF92ZesgaOcvhYWRhF3cJgm2p68kKF9dFhVDQYk1odLYJmvDbxT00eYqwC836wNbBE6H628cJFWwj4rGZY4qNbQkXYJftuAHtLoqR1LXbJmGbnTL
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199015)(40470700004)(46966006)(36840700001)(4326008)(316002)(6666004)(81166007)(356005)(40460700003)(8676002)(82310400005)(336012)(86362001)(36756003)(55446002)(2906002)(186003)(36860700001)(41300700001)(70206006)(9686003)(82740400003)(2876002)(26005)(426003)(5660300002)(8936002)(54906003)(70586007)(6636002)(110136005)(478600001)(47076005)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 13:16:21.4001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc5d5b7-a8e7-4a7d-997c-08dac6426c5e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7697
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

The TC extra channel will need its own special RX handling, which must
 operate before any code that expects the RX buffer to contain a network
 packet; buffers on this RX queue contain MAE counter packets in a
 special format that does not resemble an Ethernet frame, and many fields
 of the RX packet prefix are not populated.
The USER_MARK field, however, is populated with the generation count from
 the counter subsystem, which needs to be passed on to the RX handler.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rx.c   | 7 +++++++
 drivers/net/ethernet/sfc/net_driver.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
index 735f50385919..83d9db71d7d7 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.c
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -67,6 +67,13 @@ void __ef100_rx_packet(struct efx_channel *channel)
 
 	prefix = (u32 *)(eh - ESE_GZ_RX_PKT_PREFIX_LEN);
 
+	if (channel->type->receive_raw) {
+		u32 mark = PREFIX_FIELD(prefix, USER_MARK);
+
+		if (channel->type->receive_raw(rx_queue, mark))
+			return; /* packet was consumed */
+	}
+
 	if (ef100_has_fcs_error(channel, prefix) &&
 	    unlikely(!(efx->net_dev->features & NETIF_F_RXALL)))
 		goto out;
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index b3d413896230..1e42f3447b24 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -593,6 +593,7 @@ struct efx_msi_context {
  * @copy: Copy the channel state prior to reallocation.  May be %NULL if
  *	reallocation is not supported.
  * @receive_skb: Handle an skb ready to be passed to netif_receive_skb()
+ * @receive_raw: Handle an RX buffer ready to be passed to __efx_rx_packet()
  * @want_txqs: Determine whether this channel should have TX queues
  *	created.  If %NULL, TX queues are not created.
  * @keep_eventq: Flag for whether event queue should be kept initialised
@@ -609,6 +610,7 @@ struct efx_channel_type {
 	void (*get_name)(struct efx_channel *, char *buf, size_t len);
 	struct efx_channel *(*copy)(const struct efx_channel *);
 	bool (*receive_skb)(struct efx_channel *, struct sk_buff *);
+	bool (*receive_raw)(struct efx_rx_queue *, u32);
 	bool (*want_txqs)(struct efx_channel *);
 	bool keep_eventq;
 	bool want_pio;
