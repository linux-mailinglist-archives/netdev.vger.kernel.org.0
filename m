Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30607621A7D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiKHR03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbiKHR0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:26:21 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28106B81
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:26:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHHxYEz9JXYjDujsI2OyrOZ3YHEU6w7enIBY3gkzSB/Fvw8wUv1dim9gcgnVRwN7qjXSjID+0/IuJyXZpNVvNHgs7iafsDPTIuG/yeG6aX1ArkFhnpVi4quFJZW0reJ0lQ7itJd1tf6topUzXuuk4OPXQBDZD4B0wzXyeY8+YIaHdtvRp0tG0sszuu0kgzMcHY5DZQGptLW7pPitHAL0lNECTCAuiXs78FKtFZnNvx9yPW7F7MAAB8+Mzr8FGRPew3DwAyfSOGnzOf1UUMNHHzy8qXeFAEdsNvXH82BH9KvEsAstGfUKwfaEzwEbfJ3rovje/iKVMdrVgCeHkF/LcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfoo7gnX3GSebhlbQu3T9XIm64uqzcP1dbIRFQSVFgs=;
 b=T6pz+s2EUWoX/9/rtkXookMOo/JNEUGi/ZWpOoa2WSF3t+Q5ykxIljyH1UXrbmYIKb5+kvgP1G2OavNg2eqYJzEArrpcXjoTpdX96ooaVC0QS3Hh+px2GH4G5jFIrN6Gm5xiJzY1GCaoi1fkZdKdQr3TZ6IsyoclOTdfuGxQHYHtT0bUEK/U+3250yxDxeNFN2T60qtTDj/D6liBtKgA+KMENEMnDnQD9zelb6uSgZ0QR8KYSkxWhho5n2yXS1hjhxzmx4H+I9aA8KAxx+8xEVgTTHdEqFqW+QKjWj52WK+yp33T5lypDNhsJloRPHHs8wQpG34XeUI2N0MBZoWW+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfoo7gnX3GSebhlbQu3T9XIm64uqzcP1dbIRFQSVFgs=;
 b=nZHbMYZq7KfFYsfj+az1JC5L29PJNnGOg7fhQ+a00l0/fI1WgV8R1edn70XEggA5TlOFozGDTED8lpkOSrcELEtkLMQCwxJzYoxUZvjIDeBHN4eHtaoiDYttk9aXkUbwHCJ3VnhZAzEQ0XtJSykjONG2FTAA0EaCMMpbOYTinrw=
Received: from MW4PR03CA0089.namprd03.prod.outlook.com (2603:10b6:303:b6::34)
 by DS0PR12MB6557.namprd12.prod.outlook.com (2603:10b6:8:d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.26; Tue, 8 Nov 2022 17:26:17 +0000
Received: from CO1NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::b9) by MW4PR03CA0089.outlook.office365.com
 (2603:10b6:303:b6::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26 via Frontend
 Transport; Tue, 8 Nov 2022 17:26:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT101.mail.protection.outlook.com (10.13.175.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 17:26:17 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 11:26:15 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 09:26:14 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 8 Nov 2022 11:26:13 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 03/11] sfc: add ability for extra channels to receive raw RX buffers
Date:   Tue, 8 Nov 2022 17:24:44 +0000
Message-ID: <50ecccc725b9481c79f89e8dbd0eac9d043ce4a1.1667923490.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667923490.git.ecree.xilinx@gmail.com>
References: <cover.1667923490.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT101:EE_|DS0PR12MB6557:EE_
X-MS-Office365-Filtering-Correlation-Id: e26621b1-84e8-499a-13a1-08dac1ae580b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T/NaMX/jqJMOwjfbN2eRcQ5qyDmCgr2CxBh0V/+10QbtuU5C9F5uw9uzqbbmCX1JywXFYBMxYyDWVZl55pByHtJez4Um2Bh1UoY1SOzbc1IhZF6gHnLhDAjHREy9/DDc4a/vtjP4CdQiWILZu554IIYSwnMa0FAqHLKYdcbcsFD93SkwBSdxor5LwNavGWFOj1/0wnDEnu9d9DiA82mEA1oHKD3D5v/pLDBMLTCGkxlfM0NOq3mcS0cfPbON5Hy+ig636H25L1QHxr5vDuna8OiW4xvDpqv4+scZekp+L4NS1tpVw98y03Jw+pcHhx0hYJw7ijxD/jJoCJxsOKlJgq/Sy45sgiOo8VxBsVab8Gsm0XdaaqRZOPCse0ulPo1xQpLEU1+lWMT7cFweo8HM3/52FY3TcEFPG0WVQZt04ASg2Ata41SzsEgDNmpVNwV+DW+xdzDOrXw0Gn9eNy1C5TfvBZEZibG3NOJlfIuYI7qghJMVKmio+5IlAof6wveZPkVQH91rop+a/Ze1hIXxrbQPuspRy5MXqa+/5PdWpmTEFoat35XsRNazW3mlnOODQbM53pZ4xNi357b/Ba5lfH23F77bEgD98e0HN4/P3LktKPO4VClrywlZxv/SgsFvhtkl1qMXr5dYf30Dik4sRGrgAQgev1vJFYdzzTfkFZSs/jNmY9sl0x+ITpL3c2UoZHAeFNGQaZNb8O/c9Sl7qu7nLigSWp5NSc4h5sqsrhWhG6vlBaqBJt9TRDmzkF2/C5uo1sAREm31x+vqGvr2cI/lZs8uz8GSZvzh0p85ugQYlUSQG6C0XQiEwycCkUV1
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199015)(36840700001)(40470700004)(46966006)(36756003)(86362001)(81166007)(82740400003)(356005)(55446002)(2906002)(9686003)(40460700003)(40480700001)(2876002)(26005)(36860700001)(47076005)(426003)(186003)(336012)(6666004)(70206006)(70586007)(6636002)(82310400005)(110136005)(478600001)(8676002)(54906003)(316002)(5660300002)(4326008)(8936002)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:26:17.0531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e26621b1-84e8-499a-13a1-08dac1ae580b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6557
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
index 24db44210acc..106afeb75c05 100644
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
