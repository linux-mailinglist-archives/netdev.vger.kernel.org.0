Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50AF26182C7
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiKCP24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbiKCP2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:28:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A6A1B783
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 08:28:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e23kQmuU5xgOxH2Lca91Vom2BALs/6ZyZfustXDLd41gDbJ70BEBY1vs5b7hFPdoVRbdRGqpGidYQnV8YZvWgn6g9YMLvi/aNDG5Ioz9Op74IDs0cpzXDeNe9DLZ2mHsW0II0IlVhf8eXQPgJbeLhQ0//0RZcxvx0TvoAlPtAFeloFpdNMWGjroT7tvK/EsjsCYkyTxKpupLDyCLyo/6Q1zEQu2tJd2E5YPu3sZ9DqJCWTgK+cUqstjw4tb3IwmFw+rwGUr6TnlPBL0dwNA3y4EYm/J6elxnXNVJPI16Ahptk/eoZxda6NCOfbqIRZTikmOw9xPybMVzFRSjt3tlgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0X5bMrW2EGgpt/ybTTdP45hLukAHCAfc2T06tzRA/c=;
 b=iRP8WAJ/ZU0rAUcPM+jn0sPfRi43qnUni2xPkocv8PFq5OnZSTCsu+pXfxwtQdmdQ/lBeLYl24tnJtq9DYM23vHw1xdWm8q1w7SgiZHfMEqozsaf2+wN8kuS/bQZ9UFJUzCB3ecbOJUWm0fvuAGRr3RdJLb+f3VzpmdVy2phtLy8nFLSbVMcGi73MlcNsConfdo8o93AgitD/Q3dSMe5qkMStSIgjwCund7PWmPeUZ8WDThKXW5xo01J3p1F1HxQjYwq7vJs5GV4OoPm684dDObabLsHaUOxJ47kv/HTLjlqryKNtAu4EMYg2m+7lNb9oO8J/M/bbCfmP6AFghnOnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0X5bMrW2EGgpt/ybTTdP45hLukAHCAfc2T06tzRA/c=;
 b=Gf8r2diDgH8MjdcUQ1cZx+jhPt1cBu2LNJBZKNXrnQ1xo07tuSHvYKEM6C9D9XRxwQTDkD+EjLsXPjyo8rml2XDXNZkQRrfvvCdiW1rTgVP0EKC9JTIRJKxUwRu1efrdl4jnIYb3FX2jYTKsTXEXpzQFxfspNKeR0qQ+I8ziqPE=
Received: from DS7P222CA0018.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::33) by
 PH7PR12MB6695.namprd12.prod.outlook.com (2603:10b6:510:1b2::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Thu, 3 Nov 2022 15:28:05 +0000
Received: from DM6NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::87) by DS7P222CA0018.outlook.office365.com
 (2603:10b6:8:2e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22 via Frontend
 Transport; Thu, 3 Nov 2022 15:28:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT082.mail.protection.outlook.com (10.13.173.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Thu, 3 Nov 2022 15:28:05 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 10:28:04 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 10:28:03 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Thu, 3 Nov 2022 10:28:02 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 3/5] sfc: add Layer 3 matches to ef100 TC offload
Date:   Thu, 3 Nov 2022 15:27:29 +0000
Message-ID: <415e8d4a16c22d8e8ec94ffa829c894a3651e3e1.1667412458.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667412458.git.ecree.xilinx@gmail.com>
References: <cover.1667412458.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT082:EE_|PH7PR12MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: 532fafb7-2d4b-406e-f041-08dabdb00109
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JuHtOpy57BYUwBS05w+frSdOmy5FvR07vjHd5oKTbFzTaWyDq0MZfUhE3L2etlhGmCLhlbLyvkfgASevkzasyz2vRgVqAFUqlsQpsqSSvkl47dpgojwoUcvUs8t2iO9HtAjSAQRdpBbrfWyBUSdbCDfsCTTqvZr7WMrSKQHtDWvZlXF0+ox1wLOFy7kuq17gkmRPth+P/m0oADpsW/vsmsBGxh89YIJN8CH6v4yYYFdb/kSsjQYJZ7Y7WCkdt8cS53NQtGfa+YJcfKmdqloVX4HVQXVaMQyCnAuFiI+VUsjaIpvvD68Y8uGeJTvuAfhtN93CoKShsVl4cyHkpBTSDMMXwmlXaBMD7g+4a6YTeXCwQl/DunU3YXf2zMH0nH/uuoF9jlkRt7oMO35YuGrBwW9iQ6uO8BZgdO81dFnfmHuyp5zNtuqgxieisg7bcZ2vDUPW4oWd8A49/5fXwFMlqHRW8BJFEZvZtO17Cl98RN6f82FCwvJ0NHosYUc8OYyKS4VCtQpOtelr57nnL3rtn1x9F+6OD0M9W1KB0S/ZfwtsSrK+cj8XvaIGaDGRtj17G2LGgqMc+qp6CKVFpbsb+uqvnAwpwwU7XgmVwVLoqI8LbSdQAWnKVC3gND4WnLbHVm2ft15y8FNrYnjLBKQLMX6+3i+aNPXX9dNAqu6M21Rg1nmN/+Q5JZoUNkg6vODLMiaG3XrRVkQ0KYvT2E3fZmVR0e0LN5eIfMxujMrNg1LdbWe/8noMgLHGaqkad+DnbA5U3XlEPUQGBRjaeA58RQ5PUXGgXWImIYwCt4RBQuc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199015)(40470700004)(46966006)(36840700001)(36756003)(81166007)(356005)(36860700001)(82740400003)(5660300002)(2876002)(2906002)(86362001)(55446002)(47076005)(426003)(83380400001)(40460700003)(336012)(9686003)(6636002)(6666004)(26005)(110136005)(478600001)(40480700001)(70586007)(316002)(54906003)(41300700001)(186003)(8676002)(70206006)(8936002)(4326008)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 15:28:05.4731
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 532fafb7-2d4b-406e-f041-08dabdb00109
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6695
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

Support matching on IP protocol, Type of Service, Time To Live, source
 and destination addresses, with masking if supported by the hardware.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c  | 39 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi.h |  6 ++++
 drivers/net/ethernet/sfc/tc.c   | 56 +++++++++++++++++++++++++++------
 drivers/net/ethernet/sfc/tc.h   |  8 +++++
 4 files changed, 100 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 6dfcf87f9659..b894fc658867 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -290,6 +290,15 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 	    CHECK(VLAN1_PROTO, vlan_proto[1]) ||
 	    CHECK(ETH_SADDR, eth_saddr) ||
 	    CHECK(ETH_DADDR, eth_daddr) ||
+	    CHECK(IP_PROTO, ip_proto) ||
+	    CHECK(IP_TOS, ip_tos) ||
+	    CHECK(IP_TTL, ip_ttl) ||
+	    CHECK(SRC_IP4, src_ip) ||
+	    CHECK(DST_IP4, dst_ip) ||
+#ifdef CONFIG_IPV6
+	    CHECK(SRC_IP6, src_ip6) ||
+	    CHECK(DST_IP6, dst_ip6) ||
+#endif
 	    CHECK(RECIRC_ID, recirc_id))
 		return rc;
 	return 0;
@@ -495,6 +504,36 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
 	       match->value.eth_daddr, ETH_ALEN);
 	memcpy(MCDI_STRUCT_PTR(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ETH_DADDR_BE_MASK),
 	       match->mask.eth_daddr, ETH_ALEN);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_IP_PROTO,
+			     match->value.ip_proto);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_IP_PROTO_MASK,
+			     match->mask.ip_proto);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_IP_TOS,
+			     match->value.ip_tos);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_IP_TOS_MASK,
+			     match->mask.ip_tos);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_IP_TTL,
+			     match->value.ip_ttl);
+	MCDI_STRUCT_SET_BYTE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_IP_TTL_MASK,
+			     match->mask.ip_ttl);
+	MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_SRC_IP4_BE,
+				 match->value.src_ip);
+	MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_SRC_IP4_BE_MASK,
+				 match->mask.src_ip);
+	MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_DST_IP4_BE,
+				 match->value.dst_ip);
+	MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_DST_IP4_BE_MASK,
+				 match->mask.dst_ip);
+#ifdef CONFIG_IPV6
+	memcpy(MCDI_STRUCT_PTR(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_SRC_IP6_BE),
+	       &match->value.src_ip6, sizeof(struct in6_addr));
+	memcpy(MCDI_STRUCT_PTR(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_SRC_IP6_BE_MASK),
+	       &match->mask.src_ip6, sizeof(struct in6_addr));
+	memcpy(MCDI_STRUCT_PTR(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_DST_IP6_BE),
+	       &match->value.dst_ip6, sizeof(struct in6_addr));
+	memcpy(MCDI_STRUCT_PTR(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_DST_IP6_BE_MASK),
+	       &match->mask.dst_ip6, sizeof(struct in6_addr));
+#endif
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 883a4db695e2..fbeb58104936 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -236,6 +236,12 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 	EFX_POPULATE_DWORD_1(*_MCDI_STRUCT_DWORD(_buf, _field), EFX_DWORD_0, _value)
 #define MCDI_DWORD(_buf, _field)					\
 	EFX_DWORD_FIELD(*_MCDI_DWORD(_buf, _field), EFX_DWORD_0)
+/* Write a 32-bit field defined in the protocol as being big-endian. */
+#define MCDI_STRUCT_SET_DWORD_BE(_buf, _field, _value) do {		\
+	BUILD_BUG_ON(_field ## _LEN != 4);				\
+	BUILD_BUG_ON(_field ## _OFST & 3);				\
+	*(__force __be32 *)MCDI_STRUCT_PTR(_buf, _field) = (_value);	\
+	} while (0)
 #define MCDI_POPULATE_DWORD_1(_buf, _field, _name1, _value1)		\
 	EFX_POPULATE_DWORD_1(*_MCDI_DWORD(_buf, _field),		\
 			     MC_CMD_ ## _name1, _value1)
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index b469a1263211..d992fafc844e 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -144,11 +144,29 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 				     struct netlink_ext_ack *extack)
 {
 	struct flow_dissector *dissector = rule->match.dissector;
+	unsigned char ipv = 0;
 
+	/* Owing to internal TC infelicities, the IPV6_ADDRS key might be set
+	 * even on IPv4 filters; so rather than relying on dissector->used_keys
+	 * we check the addr_type in the CONTROL key.  If we don't find it (or
+	 * it's masked, which should never happen), we treat both IPV4_ADDRS
+	 * and IPV6_ADDRS as absent.
+	 */
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
 		struct flow_match_control fm;
 
 		flow_rule_match_control(rule, &fm);
+		if (IS_ALL_ONES(fm.mask->addr_type))
+			switch (fm.key->addr_type) {
+			case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
+				ipv = 4;
+				break;
+			case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
+				ipv = 6;
+				break;
+			default:
+				break;
+			}
 
 		if (fm.mask->flags) {
 			NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported match on control.flags %#x",
@@ -161,22 +179,28 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
 	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
 	      BIT(FLOW_DISSECTOR_KEY_VLAN) |
-	      BIT(FLOW_DISSECTOR_KEY_CVLAN))) {
+	      BIT(FLOW_DISSECTOR_KEY_CVLAN) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
+	      BIT(FLOW_DISSECTOR_KEY_IP))) {
 		NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported flower keys %#x",
 				       dissector->used_keys);
 		return -EOPNOTSUPP;
 	}
 
 	MAP_KEY_AND_MASK(BASIC, basic, n_proto, eth_proto);
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
-		struct flow_match_basic fm;
-
-		flow_rule_match_basic(rule, &fm);
-		if (fm.mask->ip_proto) {
-			NL_SET_ERR_MSG_MOD(extack, "Unsupported ip_proto match");
-			return -EOPNOTSUPP;
+	/* Make sure we're IP if any L3/L4 keys used. */
+	if (!IS_ALL_ONES(match->mask.eth_proto) ||
+	    !(match->value.eth_proto == htons(ETH_P_IP) ||
+	      match->value.eth_proto == htons(ETH_P_IPV6)))
+		if (dissector->used_keys &
+		    (BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
+		     BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
+		     BIT(FLOW_DISSECTOR_KEY_IP))) {
+			NL_SET_ERR_MSG_FMT_MOD(extack, "L3 flower keys %#x require protocol ipv[46]",
+					       dissector->used_keys);
+			return -EINVAL;
 		}
-	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
 		struct flow_match_vlan fm;
@@ -216,6 +240,20 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 		ether_addr_copy(match->mask.eth_daddr, fm.mask->dst);
 	}
 
+	MAP_KEY_AND_MASK(BASIC, basic, ip_proto, ip_proto);
+	MAP_KEY_AND_MASK(IP, ip, tos, ip_tos);
+	MAP_KEY_AND_MASK(IP, ip, ttl, ip_ttl);
+	if (ipv == 4) {
+		MAP_KEY_AND_MASK(IPV4_ADDRS, ipv4_addrs, src, src_ip);
+		MAP_KEY_AND_MASK(IPV4_ADDRS, ipv4_addrs, dst, dst_ip);
+	}
+#ifdef CONFIG_IPV6
+	else if (ipv == 6) {
+		MAP_KEY_AND_MASK(IPV6_ADDRS, ipv6_addrs, src, src_ip6);
+		MAP_KEY_AND_MASK(IPV6_ADDRS, ipv6_addrs, dst, dst_ip6);
+	}
+#endif
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 272efbabd6be..aebe9c251b2c 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -15,6 +15,8 @@
 #include <linux/rhashtable.h>
 #include "net_driver.h"
 
+#define IS_ALL_ONES(v)	(!(typeof (v))~(v))
+
 struct efx_tc_action_set {
 	u16 deliver:1;
 	u32 dest_mport;
@@ -30,6 +32,12 @@ struct efx_tc_match_fields {
 	__be16 eth_proto;
 	__be16 vlan_tci[2], vlan_proto[2];
 	u8 eth_saddr[ETH_ALEN], eth_daddr[ETH_ALEN];
+	/* L3 (when IP) */
+	u8 ip_proto, ip_tos, ip_ttl;
+	__be32 src_ip, dst_ip;
+#ifdef CONFIG_IPV6
+	struct in6_addr src_ip6, dst_ip6;
+#endif
 };
 
 struct efx_tc_match {
