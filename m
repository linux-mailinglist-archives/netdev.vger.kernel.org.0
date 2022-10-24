Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F02609E0C
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiJXJbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiJXJap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:30:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D6D52823
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:30:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSeWN7JwKl5X23WoDU4ucVOMmri3XKpOjzMJ9a1Q+t+Z0Ndde0TS/RTqqgWrHlGLBhRnF5CzIx3zgqmvjTL9jo18e7Kvo05W/1Owq8wEFL8ZSazNNAKaqUr63oKvQY/WkzQ9s0KGm6zRXDOILhCIh4RMk7yyC15zapZjcDmYTv6WhEJSfRg3ioQuDVg7s079BhWVGY2lGBb1niDM8mUm6WfuOHH+kc3/3rA7Jp1b7qy4fNJOPQlQhxI2kbiMMR6sNUTpO8pHLcC1jw7N+Qg4rn4s1dfYB14uoig8wPNRiGOyRb+ynv3g9sv/PL+D1J6V6nrgX231kXTry8aN/thh0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YE4GQ70AcuyPgMvCr/DL4EcuWyY0iXA1gt4/dgl/yPw=;
 b=jyeOVaDzhuFbgEbVsYe9rDKPHrFz9yEMuCGkuJ18FPI08bAF9kLKr2SOxLm74cOdkt4BqgfTsPkucs2DFPrqL4APCpq2GJW8Q3yppXGxJ5PkrEaV2rpY3sop8UyHLowQ2l+ZB5qf8ZqTMBwNAgyHDPFqTIawWhZgHze2r68HLNlkWr2mrVJnRctTt78pKR4Jv7An6uwhIMMNPGh3U8eFSldzQVFe44z4N3nMyEjKIaWd8j2honY6aIsIJYKQEyEstouHzMxBUQ+4QLEeG7QDmbw4D81I77m+rsReGSX22RGrYSzRUiaGv3PHfdgorvEXjDEO7PRKMbM7aD4d5RGa9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YE4GQ70AcuyPgMvCr/DL4EcuWyY0iXA1gt4/dgl/yPw=;
 b=d5Wl+FodwOJi6SiIQPRi8SDTpzezZdA01Ss4lB8ZHTKAJJ2reV96AV/jHfEHHswcGw4dx63wPD6SmZz+0K8F0nYVLqvbyKdv1tD/wdkSZ7KOnPGXxbTJ2ztjRkxfpTuWegN6Rcj39lbT4WIX1wZbDE27xJhQm9HH2yMy9SvqRDA=
Received: from MW4PR03CA0046.namprd03.prod.outlook.com (2603:10b6:303:8e::21)
 by DM4PR12MB5293.namprd12.prod.outlook.com (2603:10b6:5:390::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Mon, 24 Oct
 2022 09:30:34 +0000
Received: from CO1NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::cb) by MW4PR03CA0046.outlook.office365.com
 (2603:10b6:303:8e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.27 via Frontend
 Transport; Mon, 24 Oct 2022 09:30:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT074.mail.protection.outlook.com (10.13.174.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Mon, 24 Oct 2022 09:30:34 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 04:30:30 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 24 Oct
 2022 04:30:30 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Mon, 24 Oct 2022 04:30:29 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 5/5] sfc: add Layer 4 matches to ef100 TC offload
Date:   Mon, 24 Oct 2022 10:29:25 +0100
Message-ID: <9d30e1b05dd84ab47d7627b1a0236ea79d70b5fa.1666603600.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1666603600.git.ecree.xilinx@gmail.com>
References: <cover.1666603600.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT074:EE_|DM4PR12MB5293:EE_
X-MS-Office365-Filtering-Correlation-Id: d3c46e16-bede-424f-4e9f-08dab5a266e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BnBvVWBBFEkRf/2o7r26+O7Btg2kzRmyEfNOuhdPTIQpsRFxUvZ4AsL1qt0dA+qAF/n52BpNiL3vFLkjF9tMxctwfSDjewNJgwK+H6AEKZ5RsjzJd4kFULEm6NXr6hZSMc/k6ZASMScm//X6r17Mnob6JXDBsi4cCrzRXIuIS4EOvR9hRYSRzMAl/5IX8WLcKy8lRV9x5hvlKtQsDohJvezmNG0IZxYHhI4bffrZXkzkmtP/o27D3PDPvqz+2LyhCv+M+6XI++71jSDCorpiwz8BPZyFhynwjPR4SVbN5vrQ2NMu0n5OdFhoyG7Hds56VgVjfFE/aEJtvCoKrauDwfEXOPoUz9JYqnMmM3mY/DYiigJIxjcU3YgeXf+5p/RCGfFI9a4sudY944Oo3J5KjPGTTHkT6bbzuUXT3oFkh8OUdiORhANwYnRG4B31eReaBMnCy1fdNS83g+C7Ln7SA92Ngl3xYpn/kd5j4V85gkxov1LFg9X1TIh66Hmsw9Ce93sL9BNbRSC7QSOhZ+LRCf5oDDqY4wSguG3U41FSC/74tJKiD1IWXQR9ys2mwTxjcf+AGOwioxkAkP2u137AgttkD8hOUDODapw83KuUh98fIVUaZxbtvOAVDhP+ZZBnkg0kGqOgEF5kKCvQGQ+dpEmRCd5ZbAVBn++NPyrBIEX8WjjVt8taB4ACdO+Xew4icQA1t8unvlLTwIq1nxOSiorjllZaVaquQiU0JZ2M5LY9i7M5EV2+gmUW9AjxwQtKqc1SAL7w7eijKHpc6epVVtDEs8RXXMH1qbalt+XJS5yHsirRXiALtM42+0bobSGT
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(82310400005)(36756003)(55446002)(426003)(41300700001)(82740400003)(356005)(86362001)(47076005)(36860700001)(336012)(5660300002)(40460700003)(83380400001)(81166007)(316002)(2876002)(40480700001)(26005)(478600001)(70586007)(6666004)(2906002)(70206006)(8676002)(4326008)(6636002)(8936002)(9686003)(110136005)(186003)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 09:30:34.0089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c46e16-bede-424f-4e9f-08dab5a266e0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5293
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
index 76b75b3975d5..19b73cef5b30 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -313,6 +313,9 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 	CHECK(SRC_IP6, src_ip6);
 	CHECK(DST_IP6, dst_ip6);
 #endif
+	CHECK(L4_SPORT, l4_sport);
+	CHECK(L4_DPORT, l4_dport);
+	CHECK(TCP_FLAGS, tcp_flags);
 	CHECK_BIT(IS_IP_FRAG, ip_frag);
 	CHECK_BIT(IP_FIRST_FRAG, ip_firstfrag);
 	CHECK(RECIRC_ID, recirc_id);
@@ -560,6 +563,18 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
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
