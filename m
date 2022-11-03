Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A206182C9
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbiKCP3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbiKCP2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:28:10 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3A31B9F2
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 08:28:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AoWC9e+PDhwSCeQiYxkOwGhGRdIvD/hC3MWdeI0aoI2rgDwBNMo4d1NtCLzEoCWIr1xUizpxvZywRW6oHPlzI+xdZipMywTKaCWlkPuDXnmEEnNmB08q+kD2NOA78Rw/+nzuiejhMHpcoeIkgKls5MAqYNA23APhnXJvHKKBbGAQJvr0aebdqCoZdqRdLNN8GpFw7HVsKu85zrnmojfaQtd5pA/yssfR0SXT98RoGU6BcBkjEz/MGFH4amS5mp0bFn1RdO0Z/MqXgjfgUy5wY41DXR5XyV5XOdI9MBItWSyZ8h+3uKdtSjBDOPv6CClZ9Rg3vk23NdTOllfUJh7oyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paOFrwP8qlnxk1MkOis5EPY4kXJciQxx6UMYE3uMSkM=;
 b=aiNw7h20f5e8gUZ1pXUysekhwYUC/vt/ZlqVZScymIF3qdf/VoLI+QJVoMi4JZjJ+EGcH47BfNoSBBj2ErjKP1Ayrb7PUEbnjzyQaZgawg30ID9M/L+y5nSoxjYy45hNrwwam97IhbOZkyKvSdkvLEDEXdqrNQk14gSCVQcHJVRNxsNHpQD0kd0R8GC9He/uQ0RFWzC0Kw+4fkcRrMgeBi/k9bFj0u8A6jDK+Gp2PSoePo7hPKKk2TDUm2OXmClLPFWTFTPRuyPoPagpCH8WW8kHIw2ennXyRftxACajU0sS+aJY7nz8jXeMnFM+fkFp5lxavUErnKryEuWlf3pBKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paOFrwP8qlnxk1MkOis5EPY4kXJciQxx6UMYE3uMSkM=;
 b=O/8fNoe9YKg51GBrp1g9XaReikzBT5QT4t+nw8NjYihZYaRhEREWZi9sAXa4SNFhe4X/TLi2V1ZhgfaP4HfvtDkwSS/q2PAdBN0QKLVok/LRO7bzYRxhW9yL44/oqnlyaIwoLZ3TOiFW6ampiXN7Ok4uN8FRonhhuAiUU6Ewc4g=
Received: from DS7PR03CA0017.namprd03.prod.outlook.com (2603:10b6:5:3b8::22)
 by SA0PR12MB4464.namprd12.prod.outlook.com (2603:10b6:806:9f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 15:28:07 +0000
Received: from DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::88) by DS7PR03CA0017.outlook.office365.com
 (2603:10b6:5:3b8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22 via Frontend
 Transport; Thu, 3 Nov 2022 15:28:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT076.mail.protection.outlook.com (10.13.173.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Thu, 3 Nov 2022 15:28:07 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 10:28:06 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 10:28:06 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Thu, 3 Nov 2022 10:28:05 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 5/5] sfc: add Layer 4 matches to ef100 TC offload
Date:   Thu, 3 Nov 2022 15:27:31 +0000
Message-ID: <2ca1b54f62eb030a98ad94b9709e95fc39b29351.1667412458.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667412458.git.ecree.xilinx@gmail.com>
References: <cover.1667412458.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT076:EE_|SA0PR12MB4464:EE_
X-MS-Office365-Filtering-Correlation-Id: bd99c55e-eb51-4fb7-e4b4-08dabdb0021d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IHb4NF+OLclTXkfqqPHeLb0XcSvs6/xO/7daSANNHKn+gYroYPltC25K5X9vZNYVrN1um0ld8fUFslLn72ifuKqWJqlJutPjXVs+We1r8KQOpu0zF+IP5ZTTHmoF7eMO3ItJm5z8MxWwPKwk67Miye8Bu4FxWbd9IrbbgOUGaMcSd8oNGxGv6pKZYyDQZ4aQdeI6Ql1wrg27ZzkWxsGzExu8bsV///ZKo5o5hHYQRK6zdKMg5QA63U65wZBn+gO8DU3MS2JEEVD4fkZ0C7+PO9vL9yrfZvZu5bEQU6PTWkqhwnfwEYHA3Fjq1nVYgs9Xr9hw5DfEj5RTCTPAaQv368Z5xz6905WqYwQgALDcv8k45KB6A0P3/w/1eNqu1tLrHnx1um8vvx3uYylVV8+jRPOoMnqiCbFXojHvwDA3V82wJ3NxHF+bqfN2AmitOmEKJlhoR99DXY6pKzLV0Hdtj6w7JmPx5/fAgtPiCMmCx/0lEM/390GjDyXK765RQUa+08kHDLflo0+noaukru6sHOV2Ej2xc5YRGH8L97a8BnlSaX1aL1hFttLx7AvAeY2Cl6f67EdSiTzlbbE7sswJfZXBcC5BmhBnswG5kvc9FZX9ZXTl/J0A4gUy0JTFzFbcgzj/dUt2xO3/XXlq2ztwvGpx5Jb6qSL6oro1T0vV5vXfcobhrVNcK8CJd6RsNWzBdHfZYV7UJ/QFLnV0H3Kr9cKW3Azx8+OjmJh7rXLsGrrlc6eA5CKRbbq1BnAtM2b/teK4I+tmQJ5jvla1GYWuRn/M+A/Vqm6cx0cqISzQ93Y2yksoMUxXQ9wDdHdLMIgi
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199015)(36840700001)(40470700004)(46966006)(478600001)(9686003)(26005)(5660300002)(336012)(186003)(41300700001)(8936002)(83380400001)(316002)(47076005)(2876002)(40480700001)(6666004)(4326008)(8676002)(426003)(2906002)(6636002)(36756003)(70206006)(70586007)(36860700001)(356005)(81166007)(82740400003)(40460700003)(82310400005)(110136005)(86362001)(55446002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 15:28:07.2816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd99c55e-eb51-4fb7-e4b4-08dabdb0021d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4464
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

Support matching on UDP/TCP source and destination ports and TCP flags,
 with masking if supported by the hardware.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c | 15 +++++++++++++++
 drivers/net/ethernet/sfc/tc.c  | 21 +++++++++++++++++++--
 drivers/net/ethernet/sfc/tc.h  |  3 +++
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index e24436ba699c..1e605e2a08c5 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -311,6 +311,9 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 	    CHECK(SRC_IP6, src_ip6) ||
 	    CHECK(DST_IP6, dst_ip6) ||
 #endif
+	    CHECK(L4_SPORT, l4_sport) ||
+	    CHECK(L4_DPORT, l4_dport) ||
+	    CHECK(TCP_FLAGS, tcp_flags) ||
 	    CHECK_BIT(IS_IP_FRAG, ip_frag) ||
 	    CHECK_BIT(IP_FIRST_FRAG, ip_firstfrag) ||
 	    CHECK(RECIRC_ID, recirc_id))
@@ -559,6 +562,18 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
 	memcpy(MCDI_STRUCT_PTR(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_DST_IP6_BE_MASK),
 	       &match->mask.dst_ip6, sizeof(struct in6_addr));
 #endif
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_L4_SPORT_BE,
+				match->value.l4_sport);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_L4_SPORT_BE_MASK,
+				match->mask.l4_sport);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_L4_DPORT_BE,
+				match->value.l4_dport);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_L4_DPORT_BE_MASK,
+				match->mask.l4_dport);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_TCP_FLAGS_BE,
+				match->value.tcp_flags);
+	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_TCP_FLAGS_BE_MASK,
+				match->mask.tcp_flags);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 1a9cc2ad1335..17e1a3447554 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -190,6 +190,8 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	      BIT(FLOW_DISSECTOR_KEY_CVLAN) |
 	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
 	      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
+	      BIT(FLOW_DISSECTOR_KEY_TCP) |
 	      BIT(FLOW_DISSECTOR_KEY_IP))) {
 		NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported flower keys %#x",
 				       dissector->used_keys);
@@ -204,8 +206,10 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 		if (dissector->used_keys &
 		    (BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
 		     BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
-		     BIT(FLOW_DISSECTOR_KEY_IP))) {
-			NL_SET_ERR_MSG_FMT_MOD(extack, "L3 flower keys %#x require protocol ipv[46]",
+		     BIT(FLOW_DISSECTOR_KEY_PORTS) |
+		     BIT(FLOW_DISSECTOR_KEY_IP) |
+		     BIT(FLOW_DISSECTOR_KEY_TCP))) {
+			NL_SET_ERR_MSG_FMT_MOD(extack, "L3/L4 flower keys %#x require protocol ipv[46]",
 					       dissector->used_keys);
 			return -EINVAL;
 		}
@@ -249,6 +253,16 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	}
 
 	MAP_KEY_AND_MASK(BASIC, basic, ip_proto, ip_proto);
+	/* Make sure we're TCP/UDP if any L4 keys used. */
+	if ((match->value.ip_proto != IPPROTO_UDP &&
+	     match->value.ip_proto != IPPROTO_TCP) || !IS_ALL_ONES(match->mask.ip_proto))
+		if (dissector->used_keys &
+		    (BIT(FLOW_DISSECTOR_KEY_PORTS) |
+		     BIT(FLOW_DISSECTOR_KEY_TCP))) {
+			NL_SET_ERR_MSG_FMT_MOD(extack, "L4 flower keys %#x require ipproto udp or tcp",
+					       dissector->used_keys);
+			return -EINVAL;
+		}
 	MAP_KEY_AND_MASK(IP, ip, tos, ip_tos);
 	MAP_KEY_AND_MASK(IP, ip, ttl, ip_ttl);
 	if (ipv == 4) {
@@ -261,6 +275,9 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 		MAP_KEY_AND_MASK(IPV6_ADDRS, ipv6_addrs, dst, dst_ip6);
 	}
 #endif
+	MAP_KEY_AND_MASK(PORTS, ports, src, l4_sport);
+	MAP_KEY_AND_MASK(PORTS, ports, dst, l4_dport);
+	MAP_KEY_AND_MASK(TCP, tcp, flags, tcp_flags);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index d2b61926657b..4240c375a8e6 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -39,6 +39,9 @@ struct efx_tc_match_fields {
 	struct in6_addr src_ip6, dst_ip6;
 #endif
 	bool ip_frag, ip_firstfrag;
+	/* L4 */
+	__be16 l4_sport, l4_dport; /* Ports (UDP, TCP) */
+	__be16 tcp_flags;
 };
 
 struct efx_tc_match {
